import subprocess
import os

script = """
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch({ headless: true });
    const page = await browser.newPage();
    await page.setViewport({ width: 1440, height: 2800 });
    await page.goto('http://localhost:3000/heroes/82400', { waitUntil: 'networkidle0' });

    // Click Level 150
    const lvButtons = await page.$$('button');
    for (const btn of lvButtons) {
        const text = await (await btn.getProperty('textContent')).jsonValue();
        if (text.includes('Lv.150')) {
            await btn.click();
            break;
        }
    }

    // Click Tiến Hóa +20
    for (const btn of lvButtons) {
        const text = await (await btn.getProperty('textContent')).jsonValue();
        if (text.trim() === '+20') {
            await btn.click();
            break;
        }
    }

    // Click Chuyển 4
    for (const btn of lvButtons) {
        const text = await (await btn.getProperty('textContent')).jsonValue();
        if (text.trim() === 'Chuyển4') {
            await btn.click();
            break;
        }
    }

    // Click Siêu Tiến Hóa Đỏ++
    for (const btn of lvButtons) {
        const text = await (await btn.getProperty('textContent')).jsonValue();
        if (text.includes('Đỏ++')) {
            await btn.click();
            break;
        }
    }

    // Click Đột Phá 10
    for (const btn of lvButtons) {
        const text = await (await btn.getProperty('textContent')).jsonValue();
        if (text.trim() === '10' || text.trim() === 'Cấp 10') {
            await btn.click();
            break;
        }
    }

    await new Promise(r => setTimeout(r, 1000));
    await page.screenshot({ path: 'scratch/screenshots/hero_interactive_test.png', fullPage: false });
    await browser.close();
    console.log('Interactive test screenshot saved!');
})();
"""

# If puppeteer isn't installed globally, we can use python playwright or headless chrome with evaluate script
