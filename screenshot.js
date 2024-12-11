const puppeteer = require('puppeteer');

(async () => {
  try {
    const browser = await puppeteer.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    });

    const page = await browser.newPage();

    // Set authorization header
    await page.setExtraHTTPHeaders({
      'Authorization': `Bearer ${process.env.HA_TOKEN}`
    });

    await page.goto(process.env.DASHBOARD_URL, { waitUntil: 'networkidle2' });

    // Take screenshot and save to specified directory
    const outputPath = `${process.env.OUTPUT_DIR}/dashboard_screenshot.png`;
    await page.screenshot({ path: outputPath, fullPage: true });

    await browser.close();
    console.log(`Screenshot saved to ${outputPath}`);
  } catch (error) {
    console.error('Error taking screenshot:', error);
    process.exit(1);
  }
})();
