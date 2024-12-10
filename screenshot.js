const puppeteer = require('puppeteer');

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });
  const page = await browser.newPage();

  // Use the HA long-lived token for authorization
  await page.setExtraHTTPHeaders({
    'Authorization': `Bearer ${process.env.HA_TOKEN}`
  });

  await page.goto(process.env.DASHBOARD_URL, { waitUntil: 'networkidle2' });

  // Take screenshot and save to /config/www
  await page.screenshot({ path: '/config/www/dashboard_screenshot.png', fullPage: true });

  await browser.close();
})();
