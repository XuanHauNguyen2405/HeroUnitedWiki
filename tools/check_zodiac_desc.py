import json

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    eqs = json.load(f)
if isinstance(eqs, dict):
    eqs = list(eqs.values())
eq_map = {str(e.get('id')): e for e in eqs}

ids = [
    56105, 56106, 66105, 66106, 76105, 76106, 86105, 86106, # Hoi
    59405, 59406, 69405, 69406, 79405, 79406, 89405, 89406, # Rong
    109405, 109406, 110405, 110406, 111405, 111406, 112405, 112406, # Ti
    119405, 119406, 120405, 120406, 121405, 121406, 122405, 122406 # Ngua
]
for eid in ids:
    e = eq_map.get(str(eid), {})
    print(f"{eid} ({e.get('name')}, Q={e.get('quality')}): eff={e.get('effect')}, desc={e.get('description') or e.get('desc')}")
