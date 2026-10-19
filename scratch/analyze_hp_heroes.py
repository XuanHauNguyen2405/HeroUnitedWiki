import json
import re

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

check_ids = [
    # 22 heroes
    '81700', # Tenka
    '82200', # Newgate
    '44200', '84500', '442000', # Vegetto
    '41700', '79800', # Shalltear
    '42300', '80700', '80800', # Gojo
    '42900', '81900', '82000', # Rimuru
    '43100', '82300', '82400', # Nagato
    '43400', '82900', '83000', # Shadow
    '43200', '82500', '82600', # Trunks
    '42000', '80100', '80200', # Broli
    '43500', '83100', '83200', # Elaina
    '43300', '82700', '82800', # Frieren
    '42600', '81400', '81500', # Gohan
    '41800', '79900', # Piccolo
    '42200', '80500', '80600', # Maple
    '42800', '81800', '428000', # Inori
    # 4 pending
    '43900', '83900', '84000', # Sasuke
    '44100', '84300', '84400', # Shamrock
    '44000', '84100', '84200', # Meliodas
    '83800', # Kanae
]

print("=== CHECKING HP SCALING FOR TARGET HEROES ===")

for hid in check_ids:
    h = heroes.get(hid)
    if not h:
        print(f"Hero {hid} not found in detail json")
        continue
    name = h.get('name')
    char_id = h.get('character_id')
    
    matches = []
    
    # Check skills
    for sk in h.get('skills_detailed', []):
        sk_name = sk.get('name') or ''
        sk_desc = sk.get('description') or ''
        text = f"{sk_name} {sk_desc}"
        # Look for HP scaling: damage based on HP, shield based on HP, bonus based on HP
        # e.g., "bằng X% HP", "dựa trên HP", "theo HP", "HP tối đa"
        if re.search(r'(bằng|dựa|theo|chuyển).*?\bHP\b', text, re.I) or re.search(r'\bHP\b.*?(chuyển|tăng|sát thương|st|khiên)', text, re.I):
            matches.append(('skill', sk_name, sk_desc))
            
    # Check CS stages
    cs = h.get('chuyen_sinh') or {}
    for st in cs.get('stages', []):
        st_num = st.get('stage')
        st_title = st.get('title') or ''
        st_detail = st.get('detail') or ''
        st_story = st.get('story') or ''
        text = f"{st_title} {st_detail} {st_story}"
        if re.search(r'(bằng|dựa|theo|chuyển).*?\bHP\b', text, re.I) or re.search(r'\bHP\b.*?(chuyển|tăng|sát thương|st|khiên)', text, re.I):
            matches.append((f'CS{st_num}', st_title, st_detail or st_story))
            
    if matches:
        print(f"\n[!] Hero {hid} - {name} (CharID {char_id}): {len(matches)} HP mentions")
        for m_type, m_name, m_desc in matches:
            print(f"    - {m_type}: {m_name}")
            print(f"      Desc: {m_desc}")
    else:
        print(f"[-] Hero {hid} - {name}: No HP scaling found")
