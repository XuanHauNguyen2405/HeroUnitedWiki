import json

with open('config/super_evolution.config', 'r', encoding='utf-8') as f:
    se = json.load(f)

with open('config/super_evo_team.config', 'r', encoding='utf-8') as f:
    setm = json.load(f)

with open('config/character_detail.config', 'r', encoding='utf-8') as f:
    chars = json.load(f)

with open('output/items.json', 'r', encoding='utf-8') as f:
    items = json.load(f)
if isinstance(items, dict): items = list(items.values())
item_map = {str(i.get('id')): i for i in items}

print(f"Total entries in super_evolution.config: {len(se)}")
print(f"Sample keys: {list(se.keys())[:10]}")

# Let's check Nagato or other heroes
for cid, c in list(chars.items())[:50]:
    name = c.get('name', '')
    if 'nagato' in name.lower() or 'pain' in name.lower() or cid == '43100' or cid == '82400':
        print(f"Match: cid={cid}, name={name}, in_se={cid in se}")

# Let's see what keys in `se` correspond to characters
found_chars = []
for k in se.keys():
    if k in chars:
        found_chars.append((k, chars[k].get('name')))

print(f"Total matched characters with super_evolution: {len(found_chars)}")
print("Sample matched:", found_chars[:10])

# Inspect one character's super evolution in detail
sample_cid = found_chars[0][0] if found_chars else list(se.keys())[0]
sample_name = found_chars[0][1] if found_chars else "Unknown"
print(f"\nDetailed look at {sample_name} (ID: {sample_cid}):")
se_entry = se[sample_cid]
for k, v in se_entry.items():
    print(f"  {k}: {v}")

# Resolve level needs:
for lvl in range(1, 9):
    needs = se_entry.get(f"level_{lvl}_need", [])
    print(f"\n--- Level {lvl} Need (Slots: {needs}) ---")
    for nid in needs:
        team_entry = setm.get(str(nid), {})
        card_id = team_entry.get('card_need')
        card_name = chars.get(str(card_id), {}).get('name', f"Card #{card_id}")
        ability = team_entry.get('ability_add')
        print(f"    Slot {nid}: Requires Hero Card '{card_name}' (ID: {card_id}), Ability Add: {ability}")
