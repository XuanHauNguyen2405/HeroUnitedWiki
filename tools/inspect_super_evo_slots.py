import json

with open('config/super_evo_team.config', 'r', encoding='utf-8') as f:
    setm = json.load(f)

with open('config/character_detail.config', 'r', encoding='utf-8') as f:
    chars = json.load(f)

for i in range(1, 33):
    entry = setm.get(str(i), {})
    cid = entry.get('card_need')
    c = chars.get(str(cid), {})
    cname = c.get('name', 'Thẻ tự do') if cid != -1 else 'Thẻ phôi cùng phẩm (Tự do)'
    avatar = c.get('assets', {}).get('head', {}).get('ref') or c.get('head') or str(cid)
    print(f"Slot {i:2d}: Card ID: {cid} | Name: {cname} | Avatar: {avatar}")
