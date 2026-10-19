# tools/analyze_zodiac_sets.py
import json

with open('config/chain.config', 'r', encoding='utf-8') as f:
    chains = json.load(f)

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)
if isinstance(equips, dict): equips = list(equips.values())
equip_map = {str(e.get('id')): e for e in equips}

with open('output/equipment_sets.json', 'r', encoding='utf-8') as f:
    suits = json.load(f)
if isinstance(suits, dict): suits = list(suits.values())
suit_map = {str(s.get('id')): s for s in suits}

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

# Search equipment names for any zodiac words or high quality sets
print("=== SCANNING ALL SUITS ===")
zodiac_terms = ['chuột', 'tị', 'hợi', 'rồng', 'ngựa', 'tý', 'thìn', 'ngọ', 'xà', 'trư', 'sinh tiêu', 'giáp', 'thập nhị']
matched_suits = []
for s in suits:
    sname = s.get('name', '')
    for part_id in s.get('parts', []):
        eq = equip_map.get(str(part_id))
        if eq:
            eq_name = eq.get('name', '')
            for z in ['chuột', 'tị', 'hợi', 'rồng', 'ngựa', 'tý', 'thìn', 'ngọ', 'rắn', 'heo', 'lợn']:
                if z in eq_name.lower():
                    matched_suits.append((s, eq_name, z))
                    break

print(f"Matched suits from equip parts: {len(matched_suits)}")
seen = set()
for s, eq_name, z in matched_suits:
    sid = s.get('id')
    if sid not in seen:
        seen.add(sid)
        print(f"Suit ID {sid}: {s.get('name')} | Part matching: {eq_name} (Zodiac: {z})")

# Also look into character_detail.config for bonds with equip
print("\n=== SCANNING HERO BONDS WITH EQUIPMENT ===")
hero_equip_bonds = {}
for hid, h in heroes.items():
    vm_list = h.get('van_menh', [])
    for vm in vm_list:
        if vm.get('type') == 'equip':
            for t in vm.get('targets', []):
                eid = t.get('id')
                eq = equip_map.get(str(eid))
                suit_id = eq.get('suit_id') if eq else None
                suit_name = suit_map.get(str(suit_id), {}).get('name') if suit_id else None
                hero_equip_bonds.setdefault(str(eid), {
                    'equip_name': t.get('name'),
                    'suit_id': suit_id,
                    'suit_name': suit_name,
                    'heroes': []
                })['heroes'].append({'id': hid, 'name': h.get('name'), 'bond_name': vm.get('name'), 'effects': vm.get('effects')})

print(f"Total distinct equips used in hero bonds: {len(hero_equip_bonds)}")
for eid, data in list(hero_equip_bonds.items())[:30]:
    hero_str = ", ".join([h['name'] for h in data['heroes']])
    print(f"Equip {eid} ({data['equip_name']}) -> Suit {data['suit_id']} ({data['suit_name']}) -> Heroes: {hero_str}")
