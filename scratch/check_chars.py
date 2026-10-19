import json

with open('web/src/data/heroes_catalog.json', 'r', encoding='utf-8') as f:
    cat = json.load(f)

chars = {}
for h in cat:
    cid = str(h.get('character_id'))
    if cid not in chars:
        chars[cid] = []
    chars[cid].append(h)

for cid in sorted(chars.keys(), key=lambda x: int(x) if x.isdigit() else 9999):
    if cid.isdigit() and 410 <= int(cid) <= 450:
        names = [f"{h['id']}:{h['name']}" for h in chars[cid]]
        print(f"CharID {cid}: {', '.join(names)}")
