import subprocess, os

html_content = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  body {
    background: #0b0f19;
    display: flex;
    gap: 30px;
    padding: 40px;
    align-items: center;
    justify-content: center;
    margin: 0;
  }
  .badge-box {
    position: relative;
    width: 60px;
    height: 60px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .badge-img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    filter: drop-shadow(0 2px 6px rgba(0,0,0,0.9));
  }
  .num {
    position: absolute;
    top: 44%;
    left: 53%;
    transform: translate(-50%, -50%);
    font-family: 'Gill Sans', 'Gill Sans MT', 'Trebuchet MS', 'Impact', sans-serif;
    font-weight: 900;
    line-height: 1;
    color: #0b0f19;
    -webkit-text-stroke: 1.5px #ffffff;
    paint-order: stroke fill;
    text-shadow: 0 0 1px #fff;
    letter-spacing: -0.05em;
    user-select: none;
    font-size: 30px;
  }
</style>
</head>
<body>
  <!-- Test with 1, 7, 10, 20 -->
  <div class="badge-box">
    <img src="http://localhost:3000/assets/card/bt_element.png" class="badge-img">
    <span class="num">1</span>
  </div>
  <div class="badge-box">
    <img src="http://localhost:3000/assets/card/bt_element.png" class="badge-img">
    <span class="num">7</span>
  </div>
  <div class="badge-box">
    <img src="http://localhost:3000/assets/card/bt_element.png" class="badge-img">
    <span class="num">10</span>
  </div>
  <div class="badge-box">
    <img src="http://localhost:3000/assets/card/bt_element.png" class="badge-img">
    <span class="num">20</span>
  </div>
</body>
</html>
"""

os.makedirs('scratch', exist_ok=True)
with open('scratch/test_badge.html', 'w', encoding='utf-8') as f:
    f.write(html_content)

chrome = r'C:\Program Files\Google\Chrome\Application\chrome.exe'
out = os.path.abspath('scratch/test_badge.png')
cmd = [
    chrome,
    '--headless=new',
    '--disable-gpu',
    '--window-size=500,160',
    f'--screenshot={out}',
    'file:///' + os.path.abspath('scratch/test_badge.html').replace('\\', '/')
]
subprocess.run(cmd, check=True)
print('Rendered test_badge.png')
