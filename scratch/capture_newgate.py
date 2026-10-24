import subprocess, os, time
from PIL import Image

chrome = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
os.makedirs("scratch/screenshots", exist_ok=True)

heroes_to_capture = [
    ("82200", "newgate_82200"),
    ("43000", "whitebeard_43000"),
    ("82100", "whitebeard_ct_82100"),
    ("82400", "nagato_82400"),
    ("43900", "sasuke_43900"),
    ("43700", "zoro_43700"),
]

for hid, name in heroes_to_capture:
    # Desktop 1440px
    cmd_d = [
        chrome,
        "--headless=new",
        "--disable-gpu",
        "--window-size=1440,1600",
        f"--screenshot=scratch/screenshots/{name}_desktop.png",
        f"http://localhost:3000/heroes/{hid}"
    ]
    subprocess.run(cmd_d, check=True)
    
    # Mobile 390px
    cmd_m = [
        chrome,
        "--headless=new",
        "--disable-gpu",
        "--window-size=390,1600",
        f"--screenshot=scratch/screenshots/{name}_mobile.png",
        f"http://localhost:3000/heroes/{hid}"
    ]
    subprocess.run(cmd_m, check=True)
    print(f"Captured {name} (desktop & mobile)")

print("All screenshots captured successfully!")
