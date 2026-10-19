import json

with open('config/super_evolution.config', 'r', encoding='utf-8') as f:
    se = json.load(f)
with open('config/super_evo_team.config', 'r', encoding='utf-8') as f:
    setm = json.load(f)
with open('config/character_detail.config', 'r', encoding='utf-8') as f:
    chars = json.load(f)

se_hero = se.get('43100', {})
for lvl in range(1, 9):
    need_slots = se_hero.get(f'level_{lvl}_need', [])
    mats = []
    for nid in need_slots:
        team_entry = setm.get(str(nid), {})
        cid = team_entry.get('card_need')
        if cid == -1:
            mats.append({
                'id': '-1',
                'name': 'Thẻ Phôi Cam Bất Kỳ',
                'count': 1,
                'icon': '/assets/iphonehd/icon/item_addcard.png',
                'is_wildcard': True
            })
        else:
            c = chars.get(str(cid), {})
            img = c.get('img') or 'icon_monkey.png'
            mats.append({
                'id': str(cid),
                'name': c.get('name', f'Thẻ Tướng #{cid}'),
                'count': 1,
                'icon': f'/assets/iphonehd/icon/{img}',
                'is_wildcard': False
            })
    print(f"Level {lvl}: {len(mats)} mats")
    for m in mats:
        print(f"  - {m['name']} | Icon: {m['icon']}")
