"""Rebuild zodiac variants from box → equipment record → suit → Lua ability IDs."""
from game_semantics import definitions, equipment_record, read, write, suit_element

ZODIAC_BOXES = {
    'hoi': ('Bộ Năm Hợi', '🐗', ['91076', '91077', '91078', '91079']),
    'chuot': ('Bộ Năm Chuột', '🐭', ['92236', '92237', '92238', '92239']),
    'rong': ('Bộ Năm Rồng', '🐉', ['9101007', '9101008', '9101009', '9101010']),
    'ti': ('Bộ Năm Tị', '🐍', ['9101513', '9101514', '9101515', '9101516']),
    'ngua': ('Bộ Năm Ngựa', '🐎', ['9102121', '9102122', '9102123', '9102124']),
}


def build():
    defs, boxes, equips, suits = definitions(), read('config/box.config'), read('config/equip.config'), read('config/suit.config')
    output = []
    for id, (name, icon, bids) in ZODIAC_BOXES.items():
        variants = []
        for bid in bids:
            ids = [str(r[1]) for r in boxes[bid][0]['reward'] if r[0] == 7]
            parts = [equipment_record(eid, equips[eid], suits, defs) for eid in ids]
            sid = parts[0]['suit_id']
            assert len(parts) == 4 and all(p['suit_id'] == sid for p in parts)
            assert set(ids) == {str(p) for p in suits[sid]['part']}
            rainbow_ids = [p['next_id'] for p in parts]
            rainbow = [equipment_record(eid, equips[eid], suits, defs) for eid in rainbow_ids]
            rsid = rainbow[0]['suit_id']
            assert all(p['suit_id'] == rsid for p in rainbow)
            assert set(rainbow_ids) == {str(p) for p in suits[rsid]['part']}
            element = suit_element(suits[sid], defs)
            assert element and element == suit_element(suits[rsid], defs)
            variants.append({'element_id': element, 'element': defs['elements'][element]['name'],
                             'box_id': bid, 'suit_id': sid, 'rainbow_suit_id': rsid,
                             'parts': parts, 'rainbow_parts': rainbow,
                             'bonuses': {f'{n}_piece': suits[sid][f'effect_{n}'] for n in (2, 3, 4)},
                             'rainbow_bonuses': {f'{n}_piece': suits[rsid][f'effect_{n}'] for n in (2, 3, 4)},
                             'source': f'config/box.config:{bid} → config/equip.config → config/suit.config:{sid}/{rsid}'})
        output.append({'id': id, 'name': name, 'icon': icon, 'variants': variants})
    write('web/src/data/zodiac_sets.json', output)
    print(f'Rebuilt {len(output)} zodiac families, 20 variants, 160 item records from source.')


if __name__ == '__main__':
    build()
