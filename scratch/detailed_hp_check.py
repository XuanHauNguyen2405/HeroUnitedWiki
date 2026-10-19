import json
import re

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

# List of target hero groups
hero_groups = {
    'Tenka': ['81700'],
    'Vegeta': ['43600', '83300', '83400'], # already has Thần Thư
    'Goku': ['1', '42500', '81100', '81200', '425000', '39600', '69200', '69500'], # already has Thần Thư
    'Zoro': ['32900', '43700', '83500', '83600'], # already has Thần Thư
    'Newgate': ['43000', '82100', '82200'],
    'Vegetto': ['44200', '84500', '442000'],
    'Shalltear': ['41700', '79800'],
    'Tanjiro': ['42100', '80300', '80400'], # already has Thần Thư
    'Gojo': ['42300', '80700', '80800'],
    'Rimuru': ['42900', '81900', '82000'],
    'Kikyo': ['41900', '80000'], # already has Thần Thư
    'Nagato': ['43100', '82300', '82400'],
    'Shadow': ['43400', '82900', '83000'],
    'Trunks': ['43200', '82500', '82600'],
    'Broli': ['42000', '80100', '80200'],
    'Elaina': ['43500', '83100', '83200'],
    'Frieren': ['43300', '82700', '82800'],
    'Gohan': ['42600', '81400', '81500'],
    'Piccolo': ['41800', '79900'],
    'Maple': ['42200', '80500', '80600'],
    'Inori': ['42800', '81800', '428000'],
    'Luffy Nika': ['81300'], # already has Thần Thư
    'Sasuke': ['43900', '83900', '84000'],
    'Shamrock': ['44100', '84300', '84400'],
    'Meliodas': ['44000', '84100', '84200'],
    'Kanae': ['83800'],
}

def analyze_hero(hid):
    h = heroes.get(hid)
    if not h: return None
    
    findings = []
    
    # Check skills
    for sk in h.get('skills_detailed', []):
        name = sk.get('name') or ''
        desc = sk.get('description') or ''
        # Look for damage/effect scaling with self HP
        # e.g.: "ST thực bằng X% lượng HP tối đa của bản thân", "ST bằng X% HP", "ST truy kích bằng X% HP max của bản thân"
        # "tạo ST ... theo HP", "1% giới hạn HP bản thân chuyển thành"
        patterns = [
            (r'(?:st|sát thương).*?(?:bằng|\=).*?(\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân)', 'Damage scales with self HP'),
            (r'(\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân).*?(?:chuyển thành|tăng)', 'Self HP converts/amplifies stat'),
            (r'chuyển\s*(\d+%\s*giới hạn\s*hp\s*bản thân)', 'Self HP conversion'),
            (r'khiến\s*bản thân\s*tăng\s*vĩnh viễn\s*(\d+%\s*hp\s*max)', 'Permanent self HP multiplier'),
            (r'truy kích bằng\s*(\d+%\s*hp\s*max)', 'Follow-up damage by self HP max'),
        ]
        for p, reason in patterns:
            m = re.search(p, desc, re.I)
            if m:
                findings.append({
                    'source': f"Kỹ năng: {name}",
                    'matched': m.group(0),
                    'reason': reason,
                    'desc': desc
                })
                
    # Check CS stages
    cs = h.get('chuyen_sinh') or {}
    for st in cs.get('stages', []):
        s_num = st.get('stage')
        title = st.get('title') or ''
        detail = st.get('detail') or ''
        story = st.get('story') or ''
        text = f"{detail} {story}"
        
        patterns = [
            (r'(?:st|sát thương).*?(?:bằng|\=).*?(\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân)', 'CS damage scales with self HP'),
            (r'truy kích bằng\s*(\d+%\s*hp\s*max)', 'CS follow-up damage by self HP max'),
            (r'(\d+%\s*(?:lượng\s+)?hp\s*(?:tối đa|max)?\s*(?:của\s*)?bản thân).*?(?:chuyển thành|tăng)', 'CS Self HP converts/amplifies stat'),
            (r'khiến\s*bản thân\s*tăng\s*vĩnh viễn\s*(\d+%\s*hp\s*max)', 'CS permanent self HP boost'),
            (r'mỗi.*?1%\s*giới hạn\s*hp\s*bản thân\s*chuyển thành', 'CS HP conversion to attack'),
        ]
        for p, reason in patterns:
            m = re.search(p, text, re.I)
            if m:
                findings.append({
                    'source': f"Chuyển Sinh {s_num}: {title}",
                    'matched': m.group(0),
                    'reason': reason,
                    'desc': text
                })
                
    return findings

for gname, ids in hero_groups.items():
    print(f"\n=================== GROUP: {gname} ===================")
    for hid in ids:
        h = heroes.get(hid)
        hname = h.get('name') if h else 'N/A'
        f = analyze_hero(hid)
        if f:
            print(f"  [+] Hero {hid} ({hname}):")
            for item in f:
                print(f"      - {item['source']} [{item['reason']}]: {item['matched']}")
                print(f"        Snippet: {item['desc'][:140]}...")
        else:
            print(f"  [-] Hero {hid} ({hname}): No self HP scaling")
