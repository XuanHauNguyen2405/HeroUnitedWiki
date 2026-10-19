import json
import re

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

test_heroes = [
    ('79800', 'CT-Shalltear'),
    ('41700', 'Shalltear'),
    ('81800', 'CT - Inori'),
    ('42800', 'Inori'),
    ('428000', 'Hắc Vũ Chi Dạ - Inori'),
    ('80500', 'CT-Maple'),
    ('80600', 'MG -Maple'),
    ('42200', 'Maple'),
    ('83000', 'Shadow'),
    ('82200', 'Edward Newgate'),
    ('82400', 'Nagato'),
    ('80700', 'CT-Satoru Gojo'),
    ('80800', 'GiácSatoru Gojo'),
    ('81900', 'CT - Rimuru'),
    ('82000', 'DK - Rimuru'),
    ('82500', 'CT - Trunks'),
    ('82600', 'Kiếm Hy Vọng'),
    ('80100', 'CT-Broli'),
    ('80200', 'CuồnBroli'),
    ('83200', 'Phù Thủy - Elaina'),
    ('82700', 'CT - Frieren'),
    ('82800', 'Bikini - Frieren'),
    ('81400', 'CT - Songohan'),
    ('81500', 'Songohan Kong'),
    ('79900', 'CT-Piccolo'),
    ('81700', 'Yatogami Tenka'),
    ('84500', 'CT - vegetto'),
    ('43900', 'Chú Nguyền Sasuke'),
    ('83900', 'CT - Chú Nguyền Sasuke'),
    ('84000', 'Lục Đạo Sasuke'),
    ('44000', 'Meliodas'),
    ('84100', 'CT - Meliodas'),
    ('84200', 'Ma Thần Meliodas'),
    ('84400', 'Shamrock'),
    ('83800', 'Kanae'),
]

print("=== VERIFYING HP MECHANICS (DAMAGE / SCALING BASED ON OWN HP) ===")

for hid, label in test_heroes:
    h = heroes.get(hid)
    if not h: continue
    
    hp_scaling_found = []
    
    # Skills
    for sk in h.get('skills_detailed', []):
        s_name = sk.get('name') or ''
        s_desc = sk.get('description') or ''
        # Look for explicit damage scaling with self HP
        # "ST thực bằng X% lượng HP tối đa của bản thân"
        # "ST bằng X% HP max của bản thân"
        # "ST truy kích bằng X% HP max của bản thân"
        # "chuyển 1% giới hạn HP bản thân thành ATK"
        if re.search(r'(?:st|sát thương).*?(?:bằng|\=).*?\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân', s_desc, re.I):
            hp_scaling_found.append(('Skill', s_name, s_desc))
        elif re.search(r'truy kích bằng\s*\d+%\s*hp\s*max', s_desc, re.I):
            hp_scaling_found.append(('Skill', s_name, s_desc))
        elif re.search(r'giới hạn\s*hp\s*bản thân\s*chuyển thành', s_desc, re.I):
            hp_scaling_found.append(('Skill', s_name, s_desc))
            
    # CS
    cs = h.get('chuyen_sinh') or {}
    for st in cs.get('stages', []):
        s_num = st.get('stage')
        s_title = st.get('title') or ''
        s_text = f"{st.get('detail') or ''} {st.get('story') or ''}"
        if re.search(r'(?:st|sát thương).*?(?:bằng|\=).*?\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân', s_text, re.I):
            hp_scaling_found.append((f'CS{s_num}', s_title, s_text))
        elif re.search(r'truy kích bằng\s*\d+%\s*hp\s*max', s_text, re.I):
            hp_scaling_found.append((f'CS{s_num}', s_title, s_text))
        elif re.search(r'giới hạn\s*hp\s*bản thân\s*chuyển thành', s_text, re.I):
            hp_scaling_found.append((f'CS{s_num}', s_title, s_text))
            
    if hp_scaling_found:
        print(f"\n[YES HP-SCALE] Hero {hid} ({label}):")
        for stype, sname, sdesc in hp_scaling_found:
            print(f"  - [{stype}: {sname}]")
            # print exact sentence
            sentences = [s.strip() for s in sdesc.split('.') if 'hp' in s.lower()]
            for s in sentences:
                print(f"    * {s}")
    else:
        print(f"[NO] Hero {hid} ({label})")
