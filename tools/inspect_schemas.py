import json
import os

target_files = [
    "character_detail.config",
    "character_strengthen.config",
    "character_break_new.config",
    "character_skin.config",
    "equip.config",
    "equip_evolution.config",
    "suit.config",
    "skill_detail.config",
    "skill_detail_1.config",
    "equip_gem_fate_txt.config",
    "equip_gem_fate_word.config",
    "equip_gem_fate_skill.config",
    "badge.config",
    "badge_equip.config",
    "badge_refinement.config",
    "badge_skill_combination.config",
    "badge_txet.config",
    "fate_rune_character.config",
    "breakthrough.config",
    "occupation.config",
    "item.config"
]

print("=== INSPECTING CONFIG SCHEMAS ===")
for fname in target_files:
    fpath = os.path.join("config", fname)
    if not os.path.exists(fpath):
        print(f"MISSING: {fname}")
        continue
    with open(fpath, "r", encoding="utf-8") as f:
        data = json.load(f)
    print(f"\n--- {fname} ---")
    print(f"Total entries: {len(data)}, type: {type(data).__name__}")
    if isinstance(data, dict):
        keys = list(data.keys())
        first_key = keys[0]
        first_val = data[first_key]
        print(f"Sample key: {first_key}")
        if isinstance(first_val, dict):
            print(f"Fields ({len(first_val)}): {list(first_val.keys())}")
            # print a few field values
            sample_preview = {k: first_val[k] for k in list(first_val.keys())[:10]}
            print(f"Sample data preview: {json.dumps(sample_preview, ensure_ascii=False)[:300]}")
        else:
            print(f"Sample value: {first_val}")
    elif isinstance(data, list) and data:
        print(f"First item type: {type(data[0]).__name__}")
        if isinstance(data[0], dict):
            print(f"Fields ({len(data[0])}): {list(data[0].keys())}")
            sample_preview = {k: data[0][k] for k in list(data[0].keys())[:10]}
            print(f"Sample data preview: {json.dumps(sample_preview, ensure_ascii=False)[:300]}")
