# tools/search_diachi.py
import json

with open('config/equip.config', 'r', encoding='utf-8') as f:
    equips = json.load(f)

with open('config/suit.config', 'r', encoding='utf-8') as f:
    suits = json.load(f)

diachi = {
    'Chuột (Tý)': ['子', '鼠', 'chuột', 'tý'],
    'Tị (Rắn)': ['巳', '蛇', 'tị', 'rắn'],
    'Hợi (Heo)': ['亥', '猪', 'hợi', 'heo', 'trư'],
    'Rồng (Thìn)': ['辰', '龙', 'rồng', 'thìn', 'long'],
    'Ngựa (Ngọ)': ['午', '马', 'ngựa', 'ngọ', 'mã']
}

print("=== CHECKING SUIT.CONFIG FOR 5 CON GIÁP ===")
for sid, s in suits.items():
    name = s.get('name', '')
    desc = s.get('suit_desc', '')
    for zname, terms in diachi.items():
        for t in terms:
            if t in name:
                print(f"[{zname}] Suit {sid}: Name='{name}' | parts={s.get('part')} | eff2={s.get('effect_2')} | eff4={s.get('effect_4')}")
                break

print("\n=== CHECKING EQUIP.CONFIG FOR 5 CON GIÁP ===")
matches_by_zodiac = {z: [] for z in diachi}
for eid, eq in equips.items():
    name = eq.get('name', '')
    for zname, terms in diachi.items():
        for t in terms:
            if t in name:
                matches_by_zodiac[zname].append((eid, name, eq.get('suit_id'), eq.get('quality'), eq.get('sort')))
                break

for zname, mlist in matches_by_zodiac.items():
    print(f"\n[{zname}] Total equips: {len(mlist)}")
    for item in mlist[:10]:
        print(f"  ID: {item[0]} | Name: {item[1]} | suit_id: {item[2]} | quality: {item[3]} | sort: {item[4]}")
