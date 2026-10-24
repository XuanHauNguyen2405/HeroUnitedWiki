"""Generate engine-accurate standing and card art for reference heroes and heroes with official card assets."""
import os, sys, json, shutil
sys.path.insert(0, os.path.abspath('.'))
import numpy as np
from PIL import Image
from tools.render_engine import render

HEROES_DIR = 'web/public/assets/heroes'
os.makedirs(HEROES_DIR, exist_ok=True)

def make_card_fade(img, fade_start=0.52, fade_end=0.88):
    """Apply smooth cosine vertical alpha gradient on bottom portion of character."""
    w, h = img.size
    y_start = int(h * fade_start)
    y_end = int(h * fade_end)
    cropped = img.crop((0, 0, w, y_end))
    r, g, b, a = cropped.split()
    a_arr = np.array(a, dtype=np.float32)
    for y in range(y_start, y_end):
        progress = (y - y_start) / float(y_end - y_start)
        factor = 0.5 * (1.0 + np.cos(np.pi * progress))
        a_arr[y, :] *= factor
    cropped.putalpha(Image.fromarray(np.clip(a_arr, 0, 255).astype(np.uint8)))
    b = cropped.getbbox()
    return cropped.crop(b) if b else cropped

# Hero mappings:
# hero_id -> {'anim': animation_name, 'card_file': optional_image_file, 'fade': bool}
HERO_SPECS = {
    # Sasuke forms
    '43900': {'anim': 'xzuozhu', 'card_file': 'Resources/iphonehd/img/image_xzuozhu.png'},
    '83900': {'anim': 'xzuozhu', 'card_file': 'Resources/iphonehd/img/image_xzuozhu.png'},
    '84000': {'anim': 'xzuozhu2', 'card_file': 'Resources/iphonehd/img/image_xzuozhu2.png'},
    '32100': {'anim': 'sasuke2', 'fade': True},
    '2100': {'anim': 'sasuke', 'fade': True},

    # Nagato
    '82400': {'anim': 'peien2'}, # standing already exists, card already exists

    # Zoro forms
    '43700': {'anim': 'xsjsuolong', 'card_file': 'Resources/iphonehd/img/image_xsjsuolong.png'},
    '83500': {'anim': 'xsjsuolong', 'card_file': 'Resources/iphonehd/img/image_xsjsuolong.png'},
    '83600': {'anim': 'xsjsuolong2', 'card_file': 'Resources/iphonehd/img/image_xsjsuolong2.png'},
    '32900': {'anim': 'suolong', 'fade': True},

    # Vegeta forms
    '43600': {'anim': 'beijita', 'card_file': 'Resources/iphonehd/img/image_beijita.png'},
    '83300': {'anim': 'beijita2', 'card_file': 'Resources/iphonehd/img/image_beijita2.png'},
    '83400': {'anim': 'beijita2', 'card_file': 'Resources/iphonehd/img/image_beijita2.png'},

    # Cid Kageno & Shadow
    '43400': {'anim': 'anying', 'card_file': 'Resources/iphonehd/img/image_anying.png'},
    '82900': {'anim': 'anying', 'card_file': 'Resources/iphonehd/img/image_anying.png'},
    '83000': {'anim': 'anying2', 'card_file': 'Resources/iphonehd/img/image_anying2.png'},

    # Shinobu & Kanae
    '43800': {'anim': 'hudieren', 'card_file': 'Resources/iphonehd/img/image_hudieren.png'},
    '83700': {'anim': 'hudieren', 'card_file': 'Resources/iphonehd/img/image_hudieren.png'},
    '83800': {'anim': 'hudieren2', 'card_file': 'Resources/iphonehd/img/image_hudieren2.png'},

    # Meliodas forms
    '44000': {'anim': 'mlads', 'card_file': 'Resources/iphonehd/img/image_mlads.png'},
    '84100': {'anim': 'mlads', 'card_file': 'Resources/iphonehd/img/image_mlads.png'},
    '84200': {'anim': 'mlads2', 'card_file': 'Resources/iphonehd/img/image_mlads2.png'},

    # Elaina forms
    '43500': {'anim': 'yileina', 'card_file': 'Resources/iphonehd/img/image_yileina.png'},
    '83100': {'anim': 'yileina', 'card_file': 'Resources/iphonehd/img/image_yileina.png'},
    '83200': {'anim': 'yileina2', 'card_file': 'Resources/iphonehd/img/image_yileina2.png'},

    # Vegetto forms
    '44200': {'anim': 'vegetto', 'card_file': 'Resources/iphonehd/img/image_vegetto.png'},
    '84500': {'anim': 'vegetto', 'card_file': 'Resources/iphonehd/img/image_vegetto.png'},
    '442000': {'anim': 'vegettopf', 'card_file': 'Resources/iphonehd/img/image_vegettopf.png'},

    # Songoku 3
    '425000': {'anim': 'XWukong3', 'card_file': 'Resources/iphonehd/img/image_XWukong3.png'},

    # Edward Newgate & Whitebeard forms (character_id: 430)
    '43000': {'anim': 'baihuzi', 'card_file': 'output/apk_extracted/assets/iphonehd/img/image_baihuzi.png'},
    '82100': {'anim': 'baihuzi', 'card_file': 'output/apk_extracted/assets/iphonehd/img/image_baihuzi.png'},
    '82200': {'anim': 'baihuzi2', 'card_file': 'output/apk_extracted/assets/iphonehd/img/image_baihuzi2.png'},
}

def main():
    print("Generating engine-accurate standing and card art...")
    rendered_cache = {}

    for hid, spec in HERO_SPECS.items():
        anim = spec.get('anim')
        st_path = os.path.join(HEROES_DIR, f'standing_{hid}.png')
        cd_path = os.path.join(HEROES_DIR, f'card_{hid}.png')

        # 1. Standing art
        if not os.path.exists(st_path) or hid in ['84000', '83600', '32100', '2100', '32900', '43000', '82100', '82200']:
            if anim not in rendered_cache:
                try:
                    img, _ = render(anim, 'daiji', 0)
                    rendered_cache[anim] = img
                except Exception as e:
                    print(f"[{hid}] Failed to render {anim}: {e}")
                    continue
            rendered_cache[anim].save(st_path)
            # Also overwrite legacy full_<hid>.png with clean engine standing art
            legacy_full = os.path.join(HEROES_DIR, f'full_{hid}.png')
            rendered_cache[anim].save(legacy_full)
            print(f"[{hid}] Saved standing art -> {st_path} & {legacy_full} ({rendered_cache[anim].size})")

        # 2. Card art
        card_file = spec.get('card_file')
        # Check both direct path and fallback to output/apk_extracted
        if card_file and not os.path.exists(card_file):
            alt_card = os.path.join('output/apk_extracted/assets/iphonehd/img', os.path.basename(card_file))
            if os.path.exists(alt_card):
                card_file = alt_card
        if card_file and os.path.exists(card_file):
            shutil.copyfile(card_file, cd_path)
            print(f"[{hid}] Copied card art from {card_file} -> {cd_path}")
        elif spec.get('fade') or not os.path.exists(cd_path):
            st_img = Image.open(st_path)
            cd_img = make_card_fade(st_img)
            cd_img.save(cd_path)
            print(f"[{hid}] Generated smooth-faded card art -> {cd_path} ({cd_img.size})")

    print("\nAll target hero artwork generated successfully!")

if __name__ == '__main__':
    main()
