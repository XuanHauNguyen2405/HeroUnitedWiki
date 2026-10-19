# tools/inspect_breakthrough_materials.py
import json

with open('config/breakthrough.config', 'r', encoding='utf-8') as f:
    bt = json.load(f)

with open('config/item.config', 'r', encoding='utf-8') as f:
    items = json.load(f)

with open('output/heroes.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)
if isinstance(heroes, dict): heroes = list(heroes.values())
hero_names = {str(h.get('id')): h.get('name') for h in heroes}

# Check Frieren (82800 or related), Nagato (82400), Goku (1 or 81200)
print(f"Total entries in breakthrough.config: {len(bt)}")

def analyze_char(char_id_str, name):
    print(f"\n=================== {name} (character_id: {char_id_str}) ===================")
    matched = []
    for k, v in bt.items():
        if str(v.get('character_id')) == char_id_str or str(k).startswith(char_id_str):
            matched.append((k, v))
    print(f"Found {len(matched)} breakthrough stages:")
    for k, v in matched:
        mats = v.get('need_material', [])
        mats_desc = []
        for m in mats:
            m_type = m[0]
            m_id = str(m[1])
            m_count = m[2]
            if m_type == 5:
                # Hero card
                card_name = hero_names.get(m_id, f"Thẻ Tướng #{m_id}")
                mats_desc.append(f"[Thẻ Tướng] {card_name} (ID: {m_id}) x{m_count}")
            elif m_type == 6:
                # Item
                item_name = items.get(m_id, {}).get('name', f"Vật phẩm #{m_id}")
                mats_desc.append(f"[Vật phẩm] {item_name} (ID: {m_id}) x{m_count}")
            else:
                mats_desc.append(f"[Loại {m_type}] #{m_id} x{m_count}")
        print(f"  Stage {k}: Money={v.get('need_money')}, Materials: {', '.join(mats_desc) if mats_desc else 'None'}")

# Check Bikini Frieren (82800) and other Frieren
analyze_char("82800", "Bikini Frieren")
analyze_char("82400", "Nagato")
analyze_char("83000", "Shadow")
analyze_char("81200", "Kakarot")
analyze_char("1", "Songoku")
analyze_char("999", "Songoku 999")
