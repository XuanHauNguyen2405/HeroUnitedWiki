import json, os

cfg = json.load(open('config/character_detail.config', encoding='utf-8'))
heroes = json.load(open('web/src/data/heroes_detail.json', encoding='utf-8'))
img_dir = 'output/apk_extracted/assets/iphonehd/img'
anim_dirs = ['output/apk_extracted/assets/iphonehd/anim', 'Resources/iphonehd/anim']

missing = []
for hid, h in heroes.items():
    anim = cfg[hid].get('animation', '')
    has_sam = any(os.path.exists(os.path.join(ad, f'{anim}.swf.sam')) for ad in anim_dirs)
    has_card = os.path.exists(os.path.join(img_dir, f'image_{anim}.png'))
    if not has_sam or not has_card:
        missing.append((hid, h.get('name'), anim, has_sam, has_card))

print(f"Total missing either SAM or Card: {len(missing)}")
for hid, name, anim, has_sam, has_card in missing:
    print(f"{hid:6s} | {name:25s} | anim={anim:15s} | sam={has_sam!s:5s} | card_img={has_card!s:5s}")
