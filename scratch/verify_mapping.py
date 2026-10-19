import json

with open('web/src/data/heroes_catalog.json', 'r', encoding='utf-8') as f:
    cat = json.load(f)

# Group heroes by character_id
by_char_id = {}
for h in cat:
    cid = str(h.get('character_id'))
    if cid not in by_char_id:
        by_char_id[cid] = []
    by_char_id[cid].append(h)

# Character ID mapping table:
# Tenka: 427 (81700 Yatogami Tenka)
# Vegeta: 436 (43600, 83300, 83400) - Note: 142 is clone
# Goku: 425 (42500, 81100, 81200 Kakarot, 425000), 396 (39600, 69200, 69500), 1 (Songoku 999)
# Zoro: 437 (43700, 83500, 83600), 329 (32900, 67500)
# Newgate: 430 (43000, 82100, 82200)
# Vegetto: 442 (44200, 84500, 442000, 84600)
# Shalltear: 417 (41700, 79800)
# Tanjiro: 421 (42100, 80300, 80400)
# Gojo: 423 (42300, 80700, 80800)
# Rimuru: 429 (42900, 81900, 82000)
# Kikyo: 419 (41900, 80000)
# Nagato: 431 (43100 Pain, 82300 CT - Pain, 82400 Nagato)
# Shadow: 434 (43400 Cid Kageno, 82900 CT - Cid Kageno, 83000 Shadow)
# Trunks: 432 (43200, 82500, 82600)
# Broli: 420 (42000, 80100, 80200)
# Elaina: 435 (43500, 83100, 83200)
# Frieren: 433 (43300, 82700, 82800)
# Gohan: 426 (42600, 81400, 81500)
# Piccolo: 418 (41800, 79900)
# Maple: 422 (42200, 80500, 80600)
# Inori: 428 (42800, 81800, 428000)
# Luffy Nika: 424 (specifically 81300 Luffy - Nika)
# Sasuke: 439 (43900, 83900, 84000)
# Shamrock: 441 (44100, 84300, 84400)
# Meliodas: 440 (44000, 84100, 84200)
# Kanae: 438 (specifically 83800 Kanae)

target_mapping = {
    'Tenka': ['81700'],
    'Vegeta': ['43600', '83300', '83400'],
    'Goku': ['1', '42500', '81100', '81200', '425000', '39600', '69200', '69500'],
    'Zoro': ['32900', '43700', '83500', '83600', '67500'],
    'Newgate': ['43000', '82100', '82200'],
    'Vegetto': ['44200', '84500', '442000', '84600'],
    'Shalltear': ['41700', '79800'],
    'Tanjiro': ['42100', '80300', '80400'],
    'Gojo': ['42300', '80700', '80800'],
    'Rimuru': ['42900', '81900', '82000'],
    'Kikyo': ['41900', '80000'],
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
    'Luffy Nika': ['81300'],
    'Sasuke': ['43900', '83900', '84000'],
    'Shamrock': ['44100', '84300', '84400'],
    'Meliodas': ['44000', '84100', '84200'],
    'Kanae': ['83800'],
}

print("=== VERIFYING TARGET MAPPINGS AGAINST HERO CATALOG ===")
all_cat_ids = {str(h['id']): h for h in cat}

for group, ids in target_mapping.items():
    print(f"\nGroup: {group}")
    for hid in ids:
        h = all_cat_ids.get(hid)
        if h:
            print(f"  ID {hid:<8} -> {h.get('name')} (CharID {h.get('character_id')})")
        else:
            print(f"  [MISSING] ID {hid}")
