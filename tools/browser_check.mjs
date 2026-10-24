#!/usr/bin/env node
/**
 * browser_check.mjs — kiểm tra website bằng Chrome/Edge headless qua Chrome DevTools Protocol.
 * Không cần cài thư viện (dùng WebSocket/fetch có sẵn của Node >= 22).
 *
 * Cách dùng (PowerShell, từ thư mục gốc dự án):
 *   node tools/browser_check.mjs <scenario.json> [outDir]
 *
 * scenario.json:
 * {
 *   "base": "http://localhost:3000",
 *   "steps": [
 *     { "url": "/heroes/82200", "width": 1440, "height": 900, "shot": "newgate_1440.png", "fullPage": false },
 *     { "eval": "document.title" },
 *     { "click": "#some-button" , "wait": 500 },
 *     { "scrollTo": "#section-id" },
 *     { "shot": "after_click.png" }
 *   ]
 * }
 * Kết quả: ảnh chụp trong outDir và report.json (console error/warning, request lỗi, giá trị eval,
 * độ rộng cuộn ngang document).
 */
import { spawn } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

const CANDIDATES = [
  process.env.CHROME_PATH,
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  '/usr/bin/google-chrome', '/usr/bin/chromium',
].filter(Boolean);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function main() {
  const [scenarioPath, outDirArg] = process.argv.slice(2);
  if (!scenarioPath) {
    console.error('Usage: node tools/browser_check.mjs <scenario.json> [outDir]');
    process.exit(2);
  }
  const scenario = JSON.parse(fs.readFileSync(scenarioPath, 'utf8'));
  const outDir = outDirArg || path.join(path.dirname(scenarioPath), 'browser_out');
  fs.mkdirSync(outDir, { recursive: true });
  const exe = CANDIDATES.find((p) => fs.existsSync(p));
  if (!exe) throw new Error('Không tìm thấy Chrome/Edge. Đặt biến CHROME_PATH.');

  const port = 9300 + Math.floor(Math.random() * 500);
  const profile = fs.mkdtempSync(path.join(os.tmpdir(), 'sahht-cdp-'));
  const chrome = spawn(exe, [
    '--headless=new', `--remote-debugging-port=${port}`, `--user-data-dir=${profile}`,
    '--no-first-run', '--no-default-browser-check', '--disable-gpu', '--hide-scrollbars',
    'about:blank',
  ], { stdio: 'ignore' });

  let wsUrl;
  for (let i = 0; i < 50 && !wsUrl; i++) {
    await sleep(200);
    try {
      const list = await (await fetch(`http://127.0.0.1:${port}/json/list`)).json();
      wsUrl = list.find((t) => t.type === 'page')?.webSocketDebuggerUrl;
    } catch { /* chưa sẵn sàng */ }
  }
  if (!wsUrl) throw new Error('Không kết nối được DevTools');

  const ws = new WebSocket(wsUrl);
  await new Promise((r, j) => { ws.onopen = r; ws.onerror = j; });
  let seq = 0;
  const pending = new Map();
  const report = { console: [], exceptions: [], failedRequests: [], badResponses: [], steps: [] };
  let currentStep = null;
  const inflight = new Set();
  ws.onmessage = (ev) => {
    const msg = JSON.parse(ev.data);
    if (msg.id && pending.has(msg.id)) {
      const { resolve, reject } = pending.get(msg.id);
      pending.delete(msg.id);
      msg.error ? reject(new Error(JSON.stringify(msg.error))) : resolve(msg.result);
      return;
    }
    const p = msg.params || {};
    switch (msg.method) {
      case 'Runtime.consoleAPICalled':
        if (['error', 'warning', 'assert'].includes(p.type)) {
          report.console.push({ step: currentStep, type: p.type,
            text: (p.args || []).map((a) => a.value ?? a.description ?? '').join(' ').slice(0, 500) });
        }
        break;
      case 'Runtime.exceptionThrown':
        report.exceptions.push({ step: currentStep, text: (p.exceptionDetails?.exception?.description || p.exceptionDetails?.text || '').slice(0, 800) });
        break;
      case 'Log.entryAdded':
        if (p.entry?.level === 'error') report.console.push({ step: currentStep, type: 'log-error', text: `${p.entry.text} ${p.entry.url || ''}`.slice(0, 500) });
        break;
      case 'Network.requestWillBeSent': inflight.add(p.requestId); break;
      case 'Network.loadingFinished': inflight.delete(p.requestId); break;
      case 'Network.loadingFailed':
        inflight.delete(p.requestId);
        if (!p.canceled) report.failedRequests.push({ step: currentStep, error: p.errorText, type: p.type, id: p.requestId });
        break;
      case 'Network.responseReceived':
        if (p.response?.status >= 400) report.badResponses.push({ step: currentStep, status: p.response.status, url: p.response.url });
        break;
      default: break;
    }
  };
  const send = (method, params = {}) => new Promise((resolve, reject) => {
    const id = ++seq;
    pending.set(id, { resolve, reject });
    ws.send(JSON.stringify({ id, method, params }));
  });
  const evaluate = async (expr) => {
    const r = await send('Runtime.evaluate', { expression: expr, awaitPromise: true, returnByValue: true });
    if (r.exceptionDetails) return { error: r.exceptionDetails.exception?.description || r.exceptionDetails.text };
    return r.result?.value;
  };
  const waitIdle = async (maxMs = 15000) => {
    const t0 = Date.now();
    let quietSince = Date.now();
    while (Date.now() - t0 < maxMs) {
      await sleep(150);
      if (inflight.size > 0) quietSince = Date.now();
      const ready = await evaluate('document.readyState');
      if (ready === 'complete' && Date.now() - quietSince > 600) return;
    }
  };

  await send('Page.enable');
  await send('Runtime.enable');
  await send('Log.enable');
  await send('Network.enable');
  await send('Network.setCacheDisabled', { cacheDisabled: false });

  let width = 1440, height = 900;
  const base = scenario.base || 'http://localhost:3000';
  for (const [i, step] of scenario.steps.entries()) {
    currentStep = i;
    const rec = { i, ...step };
    try {
      if (step.width) {
        width = step.width; height = step.height || height;
        await send('Emulation.setDeviceMetricsOverride', { width, height, deviceScaleFactor: 1, mobile: width < 600 });
      }
      if (step.url) {
        await send('Page.navigate', { url: step.url.startsWith('http') ? step.url : base + step.url });
        await sleep(300);
        await waitIdle(step.timeout || 20000);
        await sleep(step.settle ?? 400);
      }
      if (step.click) {
        rec.clickResult = await evaluate(`(() => { const el = document.querySelector(${JSON.stringify(step.click)}); if (!el) return 'NOT_FOUND'; el.scrollIntoView({block:'center'}); el.click(); return 'OK'; })()`);
        await sleep(step.wait ?? 400);
        await waitIdle(8000);
      }
      if (step.clickText) {
        rec.clickResult = await evaluate(`(() => { const t = ${JSON.stringify(step.clickText)}; const els = [...document.querySelectorAll(${JSON.stringify(step.within || 'button, a, [role=button], [role=tab]')})]; const el = els.find(e => (e.innerText||e.textContent||'').trim() === t) || els.find(e => (e.innerText||e.textContent||'').includes(t)); if (!el) return 'NOT_FOUND'; el.scrollIntoView({block:'center'}); el.click(); return 'OK'; })()`);
        await sleep(step.wait ?? 400);
        await waitIdle(8000);
      }
      if (step.scrollTo) {
        rec.scrollResult = await evaluate(`(() => { const el = document.querySelector(${JSON.stringify(step.scrollTo)}); if (!el) return 'NOT_FOUND'; el.scrollIntoView({block:'start'}); window.scrollBy(0, -70); return 'OK'; })()`);
        await sleep(300);
      }
      if (step.scrollY !== undefined) {
        await evaluate(`window.scrollTo(0, ${Number(step.scrollY)})`);
        await sleep(300);
      }
      if (step.eval) rec.evalResult = await evaluate(step.eval);
      rec.overflowX = await evaluate('Math.max(document.documentElement.scrollWidth, document.body ? document.body.scrollWidth : 0) - window.innerWidth');
      rec.brokenImages = await evaluate(`[...document.images].filter(im => im.complete && im.naturalWidth === 0 && im.getAttribute('src')).map(im => im.getAttribute('src')).slice(0, 30)`);
      if (step.shot) {
        let clip;
        if (step.fullPage) {
          const m = await send('Page.getLayoutMetrics');
          const h = Math.min(Math.ceil(m.cssContentSize?.height || m.contentSize.height), step.maxHeight || 12000);
          clip = { x: 0, y: 0, width, height: h, scale: 1 };
        }
        const r = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: !!step.fullPage, ...(clip ? { clip } : {}) });
        const file = path.join(outDir, step.shot);
        fs.writeFileSync(file, Buffer.from(r.data, 'base64'));
        rec.file = file;
      }
    } catch (e) {
      rec.error = String(e.message || e);
    }
    report.steps.push(rec);
    console.log(`[${i}]`, JSON.stringify({ url: step.url, shot: step.shot, click: step.click || step.clickText, overflowX: rec.overflowX, broken: rec.brokenImages?.length, eval: rec.evalResult, error: rec.error, click_result: rec.clickResult }).slice(0, 600));
  }
  fs.writeFileSync(path.join(outDir, 'report.json'), JSON.stringify(report, null, 2));
  console.log(`console=${report.console.length} exceptions=${report.exceptions.length} failedRequests=${report.failedRequests.length} badResponses=${report.badResponses.length}`);
  for (const c of [...report.exceptions, ...report.console].slice(0, 30)) console.log(' -', JSON.stringify(c).slice(0, 300));
  for (const b of report.badResponses.slice(0, 30)) console.log(' - HTTP', b.status, b.url);
  ws.close();
  chrome.kill();
  await sleep(300);
  try { fs.rmSync(profile, { recursive: true, force: true }); } catch { /* bỏ qua */ }
}

main().catch((e) => { console.error(e); process.exit(1); });
