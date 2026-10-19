# tools/find_5_zodiac_sets.py
import json

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)
if isinstance(equips, dict): equips = list(equips.values())

with open('output/equipment_sets.json', 'r', encoding='utf-8') as f:
    suits = json.load(f)
if isinstance(suits, dict): suits = list(suits.values())

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

print(f"Loaded {len(equips)} equips, {len(suits)} suits, {len(heroes)} heroes.")

# Let's search all equipment names for any animal / zodiac names:
# Chuột, Tý, Chuot, Ty
# Rắn, Tị, Ran, Ti
# Heo, Hợi, Lợn, Trư, Hoi
# Rồng, Thìn, Rong, Thin, Long
# Ngựa, Ngọ, Ngua, Ngo, Ma
zodiac_groups = {
    'Chuột (Tý)': ['chuột', 'tý', 'chuot', ' ty '],
    'Tị (Rắn)': ['rắn', 'tị', 'ran', ' ti ', 'xà'],
    'Hợi (Heo)': ['heo', 'hợi', 'lợn', 'trư', 'hoi'],
    'Rồng (Thìn)': ['rồng', 'thìn', 'rong', 'thin', 'long'],
    'Ngựa (Ngọ)': ['ngựa', 'ngọ', 'ngua', ' ngo ', 'mã']
}

found_equips = {z: [] for z in zodiac_groups}
for eq in equips:
    name = (eq.get('name') or '').lower()
    for z, kws in zodiac_groups.items():
        if any(k in name for k in kws):
            found_equips[z].append(eq)

for z, elist in found_equips.items():
    print(f"\n==================== {z} ({len(elist)} items) ====================")
    unique_names = set(e.get('name') for e in elist)
    print("Unique names:", sorted(list(unique_names))[:15])
    suit_ids = set(e.get('suit_id') for e in elist if e.get('suit_id'))
    print("Associated suit IDs:", suit_ids)
