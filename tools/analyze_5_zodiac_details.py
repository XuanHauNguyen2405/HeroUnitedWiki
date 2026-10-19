# tools/analyze_5_zodiac_details.py
import json

with open('config/box.config', 'r', encoding='utf-8') as f:
    box = json.load(f)

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)
if isinstance(equips, dict): equips = list(equips.values())
eq_map = {str(e.get('id')): e for e in equips}

with open('output/equipment_sets.json', 'r', encoding='utf-8') as f:
    suits = json.load(f)
if isinstance(suits, dict): suits = list(suits.values())
suit_map = {str(s.get('id')): s for s in suits}

with open('config/suit.config', 'r', encoding='utf-8') as f:
    suits_config = json.load(f)

with open('web/src/data/heroes_detail.json', 'r', encoding='utf-8') as f:
    heroes = json.load(f)

# Hero equip bonds map: equip_id -> list of heroes
hero_bonds = {}
for hid, h in heroes.items():
    for vm in h.get('van_menh', []):
        if vm.get('type') == 'equip':
            for t in vm.get('targets', []):
                hero_bonds.setdefault(str(t.get('id')), []).append({
                    'hero_id': hid,
                    'hero_name': h.get('name'),
                    'bond_name': vm.get('name'),
                    'effects': vm.get('effects')
                })

zodiac_groups = [
    {
        'zodiac': 'Chuột (Tý)',
        'boxes': [('Thổ', '92236'), ('Thủy', '92237'), ('Hỏa', '92238'), ('Phong', '92239')]
    },
    {
        'zodiac': 'Tị (Rắn)',
        'boxes': [('Thổ', '9101513'), ('Thủy', '9101514'), ('Hỏa', '9101515'), ('Phong', '9101516')]
    },
    {
        'zodiac': 'Hợi (Heo)',
        'boxes': [('Thổ', '91076'), ('Hợi Thủy', '91077'), ('Hỏa', '91078'), ('Phong', '91079')]
    },
    {
        'zodiac': 'Rồng (Thìn)',
        'boxes': [('Thổ', '9101007'), ('Rồng Thủy', '9101008'), ('Hỏa', '9101009'), ('Phong', '9101010')]
    },
    {
        'zodiac': 'Ngựa (Ngọ)',
        'boxes': [('Địa/Thổ', '9102121'), ('Thủy', '9102122'), ('Hỏa', '9102123'), ('Phong', '9102124')]
    }
]

for zg in zodiac_groups:
    print(f"\n=======================================================")
    print(f"BỘ CON GIÁP: {zg['zodiac'].upper()}")
    print(f"=======================================================")
    
    for elem_name, bid in zg['boxes']:
        bentry = box.get(bid, [])
        rewards = bentry[0].get('reward', []) if bentry and len(bentry) > 0 else []
        print(f"\n--- Thuộc tính {elem_name} (Vé Box ID: {bid}) ---")
        
        suit_ids_in_box = set()
        for r in rewards:
            eid = str(r[1])
            eq = eq_map.get(eid, {})
            ename = eq.get('name', f"Trang bị #{eid}")
            sid = eq.get('suit_id')
            if sid: suit_ids_in_box.add(str(sid))
            
            # Check hero bonds
            b_heroes = hero_bonds.get(eid, [])
            b_str = f" [KÍCH HOẠT VẬN MỆNH: {', '.join(h['hero_name'] for h in b_heroes)}]" if b_heroes else ""
            print(f"  • {ename} (ID: {eid}, Sort: {eq.get('sort')}, Phẩm: {eq.get('quality')}){b_str}")
        
        # Display suit info & set effects
        for sid in suit_ids_in_box:
            s_obj = suits_config.get(sid, {})
            s_name = s_obj.get('name') or suit_map.get(sid, {}).get('name')
            print(f"  --> Thuộc Bộ Trang Bị ID: {sid} ({s_name})")
            print(f"      Hiệu ứng 2 món: {s_obj.get('effect_2')}")
            print(f"      Hiệu ứng 3 món: {s_obj.get('effect_3')}")
            print(f"      Hiệu ứng 4 món: {s_obj.get('effect_4')}")
