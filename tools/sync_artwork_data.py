"""Sync generated standing and card artwork into heroes_detail.json and hero_artwork_manifest.json."""
import os, json

HEROES_DETAIL_PATH = 'web/src/data/heroes_detail.json'
MANIFEST_PATH = 'web/src/data/hero_artwork_manifest.json'

# Targets and their animation metadata
TARGETS = {
    '43900': {'anim': 'xzuozhu', 'card_img': 'image_xzuozhu.png'},
    '83900': {'anim': 'xzuozhu', 'card_img': 'image_xzuozhu.png'},
    '84000': {'anim': 'xzuozhu2', 'card_img': 'image_xzuozhu2.png'},
    '32100': {'anim': 'sasuke2'},
    '2100': {'anim': 'sasuke'},
    '82400': {'anim': 'peien2'},
    '43700': {'anim': 'xsjsuolong', 'card_img': 'image_xsjsuolong.png'},
    '83500': {'anim': 'xsjsuolong', 'card_img': 'image_xsjsuolong.png'},
    '83600': {'anim': 'xsjsuolong2', 'card_img': 'image_xsjsuolong2.png'},
    '32900': {'anim': 'suolong'},
    '43600': {'anim': 'beijita', 'card_img': 'image_beijita.png'},
    '83300': {'anim': 'beijita2', 'card_img': 'image_beijita2.png'},
    '83400': {'anim': 'beijita2', 'card_img': 'image_beijita2.png'},
    '43400': {'anim': 'anying', 'card_img': 'image_anying.png'},
    '82900': {'anim': 'anying', 'card_img': 'image_anying.png'},
    '83000': {'anim': 'anying2', 'card_img': 'image_anying2.png'},
    '43800': {'anim': 'hudieren', 'card_img': 'image_hudieren.png'},
    '83700': {'anim': 'hudieren', 'card_img': 'image_hudieren.png'},
    '83800': {'anim': 'hudieren2', 'card_img': 'image_hudieren2.png'},
    '44000': {'anim': 'mlads', 'card_img': 'image_mlads.png'},
    '84100': {'anim': 'mlads', 'card_img': 'image_mlads.png'},
    '84200': {'anim': 'mlads2', 'card_img': 'image_mlads2.png'},
    '43500': {'anim': 'yileina', 'card_img': 'image_yileina.png'},
    '83100': {'anim': 'yileina', 'card_img': 'image_yileina.png'},
    '83200': {'anim': 'yileina2', 'card_img': 'image_yileina2.png'},
    '44200': {'anim': 'vegetto', 'card_img': 'image_vegetto.png'},
    '84500': {'anim': 'vegetto', 'card_img': 'image_vegetto.png'},
    '442000': {'anim': 'vegettopf', 'card_img': 'image_vegettopf.png'},
    '425000': {'anim': 'XWukong3', 'card_img': 'image_XWukong3.png'},
    '43000': {'anim': 'baihuzi', 'card_img': 'image_baihuzi.png'},
    '82100': {'anim': 'baihuzi', 'card_img': 'image_baihuzi.png'},
    '82200': {'anim': 'baihuzi2', 'card_img': 'image_baihuzi2.png'},
}

def main():
    with open(HEROES_DETAIL_PATH, 'r', encoding='utf-8') as f:
        heroes = json.load(f)

    with open(MANIFEST_PATH, 'r', encoding='utf-8') as f:
        manifest = json.load(f)

    updated_count = 0
    for hid, info in TARGETS.items():
        st_file = f'/assets/heroes/standing_{hid}.png'
        cd_file = f'/assets/heroes/card_{hid}.png'
        st_disk = f'web/public{st_file}'
        cd_disk = f'web/public{cd_file}'

        if not os.path.exists(st_disk) or not os.path.exists(cd_disk):
            print(f"Skipping {hid}: missing on disk")
            continue

        # 1. Update heroes_detail
        if hid in heroes:
            heroes[hid]['standing_image'] = st_file
            heroes[hid]['card_image'] = cd_file
            heroes[hid]['animation'] = info.get('anim')
            updated_count += 1

        # 2. Update manifest
        has_card_art = bool(info.get('card_img'))
        m_entry = manifest.setdefault(hid, {'id': hid, 'name': heroes.get(hid, {}).get('name', '')})
        m_entry['animation'] = info.get('anim')
        m_entry['standing'] = {
            'image': st_file,
            'source_type': 'anim_sequence',
            'anim_file': f"{info['anim']}.swf.sam",
            'action': 'daiji',
            'frame': 0,
            'scale': 2.0,
            'anchor': [0.5, 0.0],
            'verified': True,
        }
        m_entry['card'] = {
            'image': cd_file,
            'source_type': 'card_img' if has_card_art else 'anim_card_crop',
            'source_file': f"Resources/iphonehd/img/{info['card_img']}" if has_card_art else f"{info['anim']}.swf.sam",
            'overflow': {'top': -45, 'sides': -15} if has_card_art else {'top': -40, 'sides': -10},
            'verified': True,
        }

    with open(HEROES_DETAIL_PATH, 'w', encoding='utf-8') as f:
        json.dump(heroes, f, ensure_ascii=False, indent=2)

    with open(MANIFEST_PATH, 'w', encoding='utf-8') as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)

    print(f"Successfully synced artwork metadata for {updated_count} heroes!")

if __name__ == '__main__':
    main()
