"""Verified domains; never infer an element from a name, picture, race or career."""
import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / 'web/src/data'


def read(path):
    return json.loads((ROOT / path).read_text(encoding='utf-8'))


def write(path, value):
    (ROOT / path).write_text(json.dumps(value, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')


def definitions():
    # Decrypted Lua has binary trailer after its NUL terminator; decode source only.
    lua = (ROOT / 'lua_decrypted/game_config.lua').read_bytes().split(b'\0', 1)[0].decode('utf-8')
    block = lua.split('PUBLIC_ABILITY_TABLE =', 1)[1].split('PUBLIC_ABILITY_NAME_TABLE =', 1)[0]
    abilities = {}
    for id, name, icon, key, value in re.findall(
        r'ability_(\d+)\s*=\s*\{name\s*=\s*"([^"]+)",icon\s*=\s*"([^"]+)",attrName\s*=\s*"([^"]+)",typeValue\s*=\s*(\d+)', block
    ):
        abilities[id] = {'id': int(id), 'name': name, 'key': key, 'type_value': int(value),
                         'source': 'lua_decrypted/game_config.lua:PUBLIC_ABILITY_TABLE', 'game_icon': icon}
    # Colors/symbols are wiki presentation choices, not game enums.
    display = [('fire', 'Hỏa (Lửa)', '🔥', '#fca5a5'), ('water', 'Thủy (Nước)', '💧', '#7dd3fc'),
               ('wind', 'Phong (Gió)', '🌪️', '#6ee7b7'), ('earth', 'Địa (Thổ)', '⛰️', '#fcd34d')]
    elements = {}
    for key, name, symbol, color in display:
        attack = next(a for a in abilities.values() if a['key'] == key and 200 <= a['id'] < 300)
        defense = next(a for a in abilities.values() if a['key'] == key + '_dfs' and 300 <= a['id'] < 400)
        elements[key] = {'id': key, 'name': name, 'symbol': symbol, 'color': color,
                         'attack_id': attack['id'], 'defense_id': defense['id'], 'meaning': attack['name'],
                         'source': attack['source']}
    return {'elements': elements, 'abilities': abilities,
            'slots': {'0': 'Tạp vật', '1': 'Vũ khí', '2': 'Trang sức', '3': 'Phòng cụ', '4': 'Giày'}}


def suit_element(suit, defs):
    attacks = {id for n in (2, 3, 4) for id, value in suit.get(f'effect_{n}', [])
               if id in [e['attack_id'] for e in defs['elements'].values()]}
    return next((key for key, e in defs['elements'].items() if attacks == {e['attack_id']}), None)


def equipment_record(id, raw, suits, defs):
    sid = str(raw['suit']) if raw.get('suit') not in (None, 0) else None
    element = suit_element(suits.get(sid, {}), defs)
    return {'id': str(id), 'equip_id': str(raw['equip_id']), 'name': raw.get('name'),
            'element_id': element, 'element_status': 'verified_set_bonus' if element else 'not_established',
            'element_source': f'config/suit.config:{sid}:effect_4' if element else None,
            'slot': raw.get('sort'), 'quality': raw.get('quality'), 'suit_id': sid,
            'icon': f"/assets/iphonehd/icon/{raw['image']}.png" if raw.get('image') else None,
            'primary_stat': {'ability_id': raw.get('ability1'), 'value': raw.get('value1'), 'level_add': raw.get('level_add1')},
            'secondary_stat': {'ability_id': raw.get('ability2'), 'value': raw.get('value2'), 'level_add': raw.get('level_add2')},
            'combat_effect': {'description': raw.get('des', ''), 'effect': raw.get('effect'),
                              'occupation_ids': raw.get('occupation1'), 'activation': raw.get('activation'),
                              'activation_level': raw.get('activation_level'), 'skill_type': raw.get('skill_type'),
                              'source': f'config/equip.config:{id}'},
            'next_id': str(raw['evolution']) if raw.get('evolution') not in (None, 0) else None}


def skill_elements(description):
    # Explicit damage formulas only, never a skill name or story keyword.
    names = {'hỏa': 'fire', 'hoả': 'fire', 'thủy': 'water', 'thuỷ': 'water',
             'phong': 'wind', 'gió': 'wind', 'thổ': 'earth', 'địa': 'earth'}
    pattern = r'(?:ST|sát thương)\s+(?:thực\s+)?(?:thuộc tính|nguyên tố)\s+(Hỏa|Hoả|Thủy|Thuỷ|Phong|Gió|Thổ|Địa)'
    return sorted({names[m.lower()] for m in re.findall(pattern, description, re.IGNORECASE)})


def progression_stats(rows, defs):
    stats = dict.fromkeys(('hp', 'patk', 'matk', 'def', 'speed', 'ele_atk', 'ele_def'), 0)
    attributes = {}
    unverified = []
    for id, value in rows:
        ability = defs['abilities'].get(str(id))
        if ability and (1 <= id <= 5 or 201 <= id <= 204 or 301 <= id <= 304):
            key = ability['key']
            attributes[key] = attributes.get(key, 0) + value
            if 1 <= id <= 5:
                stats[key] += value
            elif 201 <= id <= 204:
                stats['ele_atk'] += value
            else:
                stats['ele_def'] += value
        else:
            # E.g. 501 in super_evolution.config is not silently treated as
            # a flat gemstone defense stat merely because its numeric ID matches.
            unverified.append([id, value])
    return {**stats, 'attributes': attributes, 'unverified_abilities': unverified}


def generate():
    defs = definitions()
    write('web/src/data/game_definitions.json', defs)
    suits, equips = read('config/suit.config'), read('config/equip.config')
    heroes, skills, occupations = read('config/character_detail.config'), read('config/skill_detail.config'), read('config/occupation.config')
    rebirth = read('config/character_break_new.config')
    super_evo = read('config/super_evolution.config')
    profiles = {}
    for id, h in heroes.items():
        evidence = []
        se = super_evo.get(str(h.get('super_evo')), {})
        for slot in range(1, 8):
            for sid, level in h.get(f'skill_{slot}_source', []):
                sk = skills.get(str(sid), {})
                text = sk.get('skill_story', '') or ''
                found = skill_elements(text)
                if found:
                    evidence.append({'skill_id': str(sid), 'slot': slot, 'name': sk.get('skill_name'),
                                     'min_rebirth': 0, 'min_super_evo': se.get(f'skill{slot}_open', 0) if slot in (4, 5) else 0,
                                     'element_ids': found, 'description': text,
                                     'source': f'config/character_detail.config:{id}:skill_{slot}_source → config/skill_detail.config:{sid}:skill_story'})
        rb = rebirth.get(id, {})
        for stage in range(1, min(rb.get('high_break', 0), 7) + 1):
            text = rb.get(f'story_detail{stage}', '') or ''
            # An explicit upgrade formula, not the title/name of an upgrade.
            formulas = re.findall(r'(?:tấn công|lực công|công)\s+(?:thuộc tính\s+)?(Hỏa|Thủy|Phong|Gió|Thổ|Địa)', text, re.IGNORECASE)
            labels = {'hỏa': 'fire', 'thủy': 'water', 'phong': 'wind', 'gió': 'wind', 'thổ': 'earth', 'địa': 'earth'}
            elements = sorted(set(skill_elements(text)) | {labels[f.lower()] for f in formulas})
            if elements:
                evidence.append({'skill_id': None, 'slot': 0, 'name': f'Chuyển sinh {stage}',
                                 'element_ids': elements, 'description': text,
                                 'min_rebirth': stage, 'min_super_evo': 0,
                                 'source': f'config/character_break_new.config:{id}:story_detail{stage}'})
        profiles[id] = {'id': id, 'innate_element_id': None, 'innate_status': 'not_in_source_schema',
                        'career_id': h.get('career'), 'race_id': h.get('race'),
                        'occupation_id': occupations.get(h.get('animation')),
                        'skill_unlocks': {str(slot): se.get(f'skill{slot}_open') for slot in (4, 5)},
                        'occupation_shade_id': h.get('occupation_shade'), 'evidence': evidence}
    write('web/src/data/hero_combat_profiles.json', profiles)
    artwork = read('web/src/data/hero_artwork_manifest.json')
    for filename in ('heroes_catalog.json', 'heroes_detail.json'):
        data = read('web/src/data/' + filename)
        for record in (data.values() if isinstance(data, dict) else data):
            id = record['id']
            record['career'] = heroes[id].get('career')
            record['race'] = heroes[id].get('race')
            record['occupation_type'] = profiles[id]['occupation_id']
            if filename == 'heroes_detail.json':
                record['animation'] = heroes[id].get('animation')
                record['standing_image'] = artwork.get(id, {}).get('standing', {}).get('image')
                record['card_image'] = artwork.get(id, {}).get('card', {}).get('image')
                record['elemental_builds'] = None
                for skill in record.get('skills_detailed', []):
                    skill['effect'] = skills.get(skill.get('skill_id'), {}).get('effect')
                rb = rebirth.get(id)
                if not rb:
                    record['chuyen_sinh'] = {'has_rebirth': False, 'high_break': 0, 'stages': []}
                else:
                    progression = record.get('chuyen_sinh', {})
                    progression['stages'] = [s for s in progression.get('stages', []) if s['stage'] <= rb.get('high_break', 0)]
                    progression['source'] = f'config/character_break_new.config:{id}'
        (DATA / filename).write_text(json.dumps(data, ensure_ascii=False, indent=2 if filename == 'heroes_detail.json' else None) + '\n', encoding='utf-8')
    # Enrich existing records without touching artwork or progression.
    for filename in ('equipment_catalog.json', 'equipment_detail.json'):
        data = read('web/src/data/' + filename)
        for record in (data.values() if isinstance(data, dict) else data):
            verified = equipment_record(record['id'], equips[record['id']], suits, defs)
            for key in ('element_id', 'element_status', 'element_source', 'combat_effect'):
                record[key] = verified[key]
        (DATA / filename).write_text(json.dumps(data, ensure_ascii=False) + '\n', encoding='utf-8')
    for filename in ('suits_catalog.json', 'suits_detail.json'):
        data = read('web/src/data/' + filename)
        for record in (data.values() if isinstance(data, dict) else data):
            raw = suits[record['id']]
            record['element_id'] = suit_element(raw, defs)
            record['bonuses'] = {f'{n}_piece': raw.get(f'effect_{n}', []) for n in (2, 3, 4)}
        (DATA / filename).write_text(json.dumps(data, ensure_ascii=False) + '\n', encoding='utf-8')
    audit = {'mapping': defs, 'heroes': profiles,
             'equipment': {id: equipment_record(id, raw, suits, defs) for id, raw in equips.items()},
             'suits': {id: {'element_id': suit_element(raw, defs), 'effect_2': raw.get('effect_2'),
                             'effect_3': raw.get('effect_3'), 'effect_4': raw.get('effect_4')} for id, raw in suits.items()},
             'unverified_domains': {'career': sorted({h['career'] for h in heroes.values()}),
                                    'race': sorted({h['race'] for h in heroes.values()}),
                                    'note': 'Preserved IDs; Vietnamese meanings not independently established. Not elements/factions.'}}
    detail = read('web/src/data/heroes_detail.json')
    audit['breakthrough_forms'] = {
        id: [{'source_id': stage.get('source_id'), 'step': stage['step'],
              'raw_abilities': stage.get('raw_abilities'), 'stats': stage['stats']}
             for stage in hero.get('breakthrough_system', {}).get('stages', [])]
        for id, hero in detail.items() if hero.get('breakthrough_system', {}).get('has_breakthrough')}
    audit['unverified_progression_ability_ids'] = sorted({
        ability[0] for row in super_evo.values() for field, rows in row.items()
        if field.endswith('_add') and isinstance(rows, list)
        for ability in rows if ability[0] not in (1, 2, 3, 4, 5)})
    write('docs/attribute_reconciliation.json', audit)
    print(f'Verified domains: {len(heroes)} forms, {len(equips)} items, {len(suits)} sets.')


if __name__ == '__main__':
    generate()
