# tools/dump_all_suits.py
import json

with open('config/suit.config', 'r', encoding='utf-8') as f:
    suits = json.load(f)

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)
if isinstance(equips, dict): equips = list(equips.values())
eq_map = {str(e.get('id')): e for e in equips}

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

# Collect all heroes and their equipment bonds
hero_bonds = {}
for hid, h in heroes.items():
    for vm in h.get('van_menh', []):
        if vm.get('type') == 'equip':
            for t in vm.get('targets', []):
                hero_bonds.setdefault(str(t.get('id')), []).append({
                    'hero_id': hid,
                    'hero_name': h.get('name'),
                    'bond_name': vm.get('name'),
                    'effects': vm.get('effects')
                })

print("Listing all suits with their parts and hero bonds:")
results = []
for sid, s in suits.items():
    sname = s.get('name', '')
    parts = s.get('part', [])
    part_names = [eq_map.get(str(p), {}).get('name', f"Part #{p}") for p in parts]
    
    # Check if any part is in hero bonds
    bonded_heroes = []
    for p in parts:
        if str(p) in hero_bonds:
            bonded_heroes.extend(hero_bonds[str(p)])
    
    results.append({
        'id': sid,
        'name': sname,
        'parts': part_names,
        'bonded_count': len(bonded_heroes),
        'bonded_heroes': bonded_heroes
    })

# Sort by bonded count descending
results.sort(key=lambda x: x['bonded_count'], reverse=True)
print(f"Total suits: {len(results)}")
print("\nTop 30 suits with most hero bonds:")
for r in results[:30]:
    heroes_str = ", ".join(set(h['hero_name'] for h in r['bonded_heroes']))
    print(f"Suit {r['id']} ({r['name']}) -> {r['parts']} -> Heroes ({len(r['bonded_heroes'])}): {heroes_str}")
