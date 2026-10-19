import json
import re

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

print(f"Loaded {len(heroes)} heroes.")

# We want to identify heroes whose skills, passives, or rebirth mechanics depend on THEIR OWN HP.
# "phải là HP của chính tướng, không phải HP đối phương hoặc đồng đội. Không suy ra chỉ vì chỉ số HP cao."

hp_patterns = [
    r'hp\s+bản\s+thân',
    r'máu\s+bản\s+thân',
    r'sinh\s+lực\s+bản\s+thân',
    r'hp\s+tối\s+đa\s+của\s+bản\s+thân',
    r'dựa\s+vào\s+hp',
    r'dựa\s+trên\s+hp',
    r'theo\s+hp\s+tối\s+đa',
    r'hp\s+càng\s+thấp',
    r'lượng\s+hp\s+đã\s+mất',
    r'tiêu\s+hao\s+\d+%\s+hp',
    r'mất\s+\d+%\s+hp',
    r'mỗi\s+\d+%\s+hp\s+mất',
    r'khi\s+hp\s+dưới',
    r'khi\s+hp\s+thấp\s+hơn',
    r'khi\s+hp\s+bản\s+thân'
]

compiled = [re.compile(p, re.IGNORECASE) for p in hp_patterns]

results = []

for hid, h in heroes.items():
    name = h.get('name') or ''
    char_id = str(h.get('character_id') or '')
    evidences = []
    
    # 1. Check skills
    for sk in h.get('skills_detailed', []):
        sk_name = sk.get('name') or ''
        sk_desc = sk.get('description') or ''
        full_text = f"{sk_name} {sk_desc}"
        
        for p, cp in zip(hp_patterns, compiled):
            m = cp.search(full_text)
            if m:
                # Filter out obvious enemy hp mentions like "hp của mục tiêu", "hp kẻ địch"
                # Check surrounding text
                start = max(0, m.start() - 30)
                end = min(len(full_text), m.end() + 60)
                snippet = full_text[start:end]
                evidences.append({
                    'type': 'skill',
                    'name': sk_name,
                    'snippet': snippet,
                    'full_desc': sk_desc
                })
                break
                
    # 2. Check chuyen_sinh
    cs = h.get('chuyen_sinh') or {}
    for st in cs.get('stages', []):
        stage_num = st.get('stage')
        st_title = st.get('title') or ''
        st_detail = st.get('detail') or ''
        st_story = st.get('story') or ''
        full_text = f"{st_title} {st_detail} {st_story}"
        
        for p, cp in zip(hp_patterns, compiled):
            m = cp.search(full_text)
            if m:
                start = max(0, m.start() - 30)
                end = min(len(full_text), m.end() + 60)
                snippet = full_text[start:end]
                evidences.append({
                    'type': f'CS{stage_num}',
                    'name': st_title,
                    'snippet': snippet,
                    'full_desc': st_detail or st_story
                })
                break
                
    if evidences:
        results.append({
            'id': hid,
            'name': name,
            'char_id': char_id,
            'is_world': h.get('is_world'),
            'evidences': evidences
        })

print(f"\nFound {len(results)} heroes with potential HP self-scaling mechanics:")
for r in results:
    print(f"\nHero #{r['id']} - {r['name']} (CharID {r['char_id']}, World: {r['is_world']}):")
    for ev in r['evidences']:
        print(f"  [{ev['type']}: {ev['name']}] -> {ev['snippet']}")
