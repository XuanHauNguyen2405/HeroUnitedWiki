import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import ts from 'typescript';
const { outputText } = ts.transpileModule(
  readFileSync(new URL('../src/lib/hero-artwork.ts', import.meta.url), 'utf8'),
  { compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 } },
);
const { getHeroArtworkLayout } = await import(`data:text/javascript;base64,${Buffer.from(outputText).toString('base64')}`);
const sizes = [[160,224,-36], [213,298,-48], [256,358,-60], [320,448,-75]];

test('Lục Đạo solid character fills the art window despite tall translucent smoke', () => {
  for (const [w,h,top] of sizes) {
    const vw=w*1.35, vh=h*.78-top;
    const art=getHeroArtworkLayout('/assets/heroes/full_84000.png',vw,vh);
    const scale=art.width/770;
    // Actual solid character: alpha >= 200, x 140..639, y 369..1044.
    const head=art.top+369*scale;
    const foot=art.top+1044*scale;
    assert.ok(head>=0 && foot<=vh,'head and feet remain visible');
    assert.ok((foot-head)/vh>.90,'visible body should not be shrunk by smoke');
    assert.ok(art.left+140*scale>=0 && art.left+639*scale<=vw,'body fits horizontally');
  }
});

test('both winged forms share alignment and retain solid wings and feet', () => {
  for (const [w,h,top] of sizes) {
    const vw=w*1.35, vh=h*.78-top;
    const a=getHeroArtworkLayout('/assets/heroes/full_43900.png',vw,vh);
    const b=getHeroArtworkLayout('/assets/heroes/full_83900.png',vw,vh);
    assert.deepEqual(a,b);
    const scale=a.width/790;
    assert.ok(a.left+12*scale>=0 && a.left+778*scale<=vw,'wing tips remain visible');
    assert.ok(a.top+12*scale>=0 && a.top+721*scale<=vh,'head and feet remain visible');
  }
});

test('unreviewed images retain existing layout instead of receiving a guessed crop', () => {
  assert.equal(getHeroArtworkLayout('/assets/heroes/full_82400.png',287,281),null);
  assert.equal(getHeroArtworkLayout(null,287,281),null);
  assert.equal(getHeroArtworkLayout('/assets/heroes/full_84000.png',0,281),null);
});
