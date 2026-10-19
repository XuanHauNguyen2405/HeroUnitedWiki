import subprocess
import time
from PIL import Image

chrome = r"C:\Program Files\Google\Chrome\Application\chrome.exe"

# 1. Desktop screenshot
cmd_desktop = [
    chrome,
    "--headless=new",
    "--disable-gpu",
    "--window-size=1440,5500",
    "--screenshot=scratch/screenshots/hero_order_desktop.png",
    "http://localhost:3000/heroes/82400"
]
print("Capturing desktop...")
subprocess.run(cmd_desktop, check=True)

# 2. Mobile screenshot
cmd_mobile = [
    chrome,
    "--headless=new",
    "--disable-gpu",
    "--window-size=412,6500",
    "--screenshot=scratch/screenshots/hero_order_mobile.png",
    "http://localhost:3000/heroes/82400"
]
print("Capturing mobile...")
subprocess.run(cmd_mobile, check=True)

print("Screenshots captured successfully!")
