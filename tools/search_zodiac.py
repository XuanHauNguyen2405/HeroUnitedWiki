# tools/search_zodiac.py
import json

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)

if isinstance(equips, dict):
    equips = list(equips.values())

print(f"Total equips: {len(equips)}")
zodiac_kws = ['chuột', 'hợi', 'ngựa', 'rồng', 'rắn', 'tị', 'thìn', 'tý', 'ngọ', 'mã', 'long', 'xà', 'trư', 'thử']
found = []
for eq in equips:
    name = eq.get('name', '')
    for kw in ['chuột', 'hợi', 'ngựa', 'rồng', 'rắn']:
        if kw in name.lower():
            found.append(eq)
            print(f"Equip ID: {eq.get('id')} | Name: {name} | suit_id: {eq.get('suit_id')} | sort: {eq.get('sort')} | quality: {eq.get('quality')}")
            break

print(f"Found {len(found)} equips matching!")
