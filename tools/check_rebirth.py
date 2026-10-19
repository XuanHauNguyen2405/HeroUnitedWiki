import json

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

for hid in ['82400', '85000', '84000', '82200']:
    h = heroes.get(hid)
    if not h: continue
    print(f"\n=== Hero: {h.get('name')} (ID: {hid}) ===")
    cs = h.get('chuyen_sinh', {})
    stages = cs.get('stages', [])
    for stage in stages[:3]:
        print(f"Stage {stage.get('stage')}: {len(stage.get('materials', []))} mats")
        for m in stage.get('materials', []):
            print(f"  - {m.get('name')}: {m.get('amount')} (id: {m.get('id')})")
