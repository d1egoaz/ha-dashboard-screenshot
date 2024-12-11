const puppeteer = require("puppeteer");
const fs = require("fs").promises;

(async () => {
  let browser;
  try {
    console.log("Launching browser...");
    browser = await puppeteer.launch({
      args: [
        "--disable-dev-shm-usage",
        "--no-sandbox",
        "--lang=en",
        "--disable-web-security",
        "--disable-features=IsolateOrigins",
        "--disable-site-isolation-trials",
      ],
      defaultViewport: {
        width: 1280,
        height: 1024,
      },
      headless: true,
    });

    const fullDashboardUrl = process.env.DASHBOARD_URL;

    // Extract base URL from the dashboard URL
    const baseUrl = new URL(fullDashboardUrl).origin;
    console.log("Base URL:", baseUrl);
    // Prepare authentication tokens
    const hassTokens = {
      hassUrl: baseUrl,
      access_token: process.env.HA_TOKEN,
      token_type: "Bearer",
    };


    console.log("Full Dashboard URL:", fullDashboardUrl);

    // Create a new page and navigate to base URL first
    const page = await browser.newPage();

    // Listen for console messages
    page.on("console", (msg) => console.log("PAGE LOG:", msg.text()));

    // Listen for errors
    page.on("error", (err) => {
      console.error("Page error:", err);
    });

    page.on("pageerror", (err) => {
      console.error("Page error:", err);
    });


    await page.goto(baseUrl);
            // First set up the auth
      console.log("Setting up authentication...");
      await page.evaluate((tokens) => {
        localStorage.setItem("hassTokens", tokens);
      }, JSON.stringify(hassTokens));


    console.log("Navigating to dashboard...");
      await page.goto(fullDashboardUrl, {waitUntil: "domcontentloaded"});

    // Ensure output directory exists
    const outputPath = `${process.env.OUTPUT_DIR}/dashboard_screenshot.png`;
    await fs.mkdir(process.env.OUTPUT_DIR, { recursive: true });

    console.log("Preparing to take screenshot...");

    // Get page dimensions
    const dimensions = await page.evaluate(() => {
      return {
        width: document.documentElement.clientWidth,
        height: document.documentElement.clientHeight,
        deviceScaleFactor: window.devicePixelRatio,
      };
    });

    console.log("Page dimensions:", dimensions);

    // Set viewport to match dimensions
    await page.setViewport({
      width: dimensions.width,
      height: dimensions.height,
      deviceScaleFactor: dimensions.deviceScaleFactor,
    });

    console.log("Taking screenshot...");
    try {
      await page.screenshot({
        path: outputPath,
        fullPage: true,
        timeout: 30000,
      });
      console.log("Screenshot taken successfully");
    } catch (screenshotError) {
      console.error("Screenshot error:", screenshotError);
      throw screenshotError;
    }

    console.log(`Screenshot saved to ${outputPath}`);
  } catch (error) {
    console.error("Error during process:", error);
    process.exit(1);
  } finally {
    if (browser) {
      console.log("Closing browser...");
      await browser.close();
    }
  }
})();
