import json

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    hd = json.load(f)

h = hd.get('82400')
print("Nagato elemental_builds count:", len(h.get('elemental_builds') or []))
for b in h.get('elemental_builds', []):
    print(f"  {b['icon']} {b['name']} -> {b['recommended_set_name']}")

print("\nSuper evo stages with materials:")
for st in h.get('super_evo', {}).get('stages', []):
    mats = st.get('materials', [])
    print(f"  Stage {st['name']} ({st['tier']}): {len(mats)} materials")
    for m in mats:
        print(f"    - {m['name']} x{m['count']} (icon: {m['icon']})")
