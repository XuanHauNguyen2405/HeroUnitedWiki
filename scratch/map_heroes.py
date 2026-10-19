import json

with open('web/src/data/heroes_catalog.json', 'r', encoding='utf-8') as f:
    catalog = json.load(f)

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    details = json.load(f)

names = [
    'tenka', 'vegeta', 'goku', 'kakarot', 'zoro', 'newgate', 'vegetto', 'shalltear',
    'tanjiro', 'gojo', 'rimuru', 'kikyo', 'nagato', 'pain', 'shadow', 'trunks', 'broli', 'broly',
    'elaina', 'frieren', 'gohan', 'piccolo', 'maple', 'inori', 'luffy', 'nika',
    'sasuke', 'shamrock', 'meliodas', 'kanae'
]

print(f"Total catalog heroes: {len(catalog)}")
print(f"Total detail heroes: {len(details)}")

# Map by character_id and id
results = {}
for h in catalog:
    hname = (h.get('name') or '').strip()
    hname_lower = hname.lower()
    hid = str(h.get('id'))
    cid = str(h.get('character_id') or '')
    
    for query in names:
        if query in hname_lower:
            if query not in results:
                results[query] = []
            results[query].append({
                'id': hid,
                'name': hname,
                'char_id': cid,
                'quality': h.get('quality'),
                'is_world': h.get('is_world'),
                'rebirth': h.get('rebirth')
            })

for q in names:
    items = results.get(q, [])
    print(f"\n--- {q.upper()} ({len(items)}) ---")
    for it in items:
        print(f"  ID: {it['id']:<8} Name: {it['name']:<25} CharID: {it['char_id']:<6} World: {it['is_world']} Rebirth: {it['rebirth']}")
