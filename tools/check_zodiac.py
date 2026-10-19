import json

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    eqs = json.load(f)
if isinstance(eqs, dict):
    eqs = list(eqs.values())
eq_map = {str(e.get('id')): e for e in eqs}

with open('config/box.config', 'r', encoding='utf-8') as f:
    box = json.load(f)

with open('config/suit.config', 'r', encoding='utf-8') as f:
    suits_config = json.load(f)

boxes = [('Chuot', '92236'), ('Hoi', '91076'), ('Rong', '9101007'), ('Ti', '9101513'), ('Ngua', '9102121')]

for name, bid in boxes:
    print(f'=== {name} (Box {bid}) ===')
    rewards = box.get(bid, [{}])[0].get('reward', [])
    for r in rewards:
        eid = str(r[1])
        e = eq_map.get(eid, {})
        reid = e.get('evolution', {}).get('next_evolution_equip_id') or str(int(eid)+1)
        re = eq_map.get(str(reid), {})
        print(f"  Slot {e.get('sort')} ({e.get('name')}, Q={e.get('quality')}): effect={e.get('effect')} -> Rainbow ({re.get('name')}, Q={re.get('quality')}): effect={re.get('effect')}")
        print(f"    Normal abilitys: {e.get('abilitys')}")
        print(f"    Rainbow abilitys: {re.get('abilitys')}")
