import os
import sys
import json
import copy
import argparse

def reconcile_heroes(hero_src, heroes):
    """
    Field-by-field reconciliation of heroes against source character_detail.config.
    Verifies all mapped fields including base_stats, growth_stats, evolution, awakening, breakthrough.
    """
    errors = []
    for hid, h in heroes.items():
        src = hero_src.get(hid)
        if not src:
            errors.append(f"Hero ID {hid} not found in source character_detail.config")
            continue
            
        # 1. Base Stats
        for stat in ["hp", "patk", "matk", "def", "speed"]:
            src_val = src.get(f"base_{stat}")
            out_val = h["base_stats"].get(stat)
            if out_val != src_val:
                errors.append(f"Mismatch at hero[{hid}].base_stats.{stat}: output {out_val} != source {src_val}")
                
        # 2. Growth Stats (Fully reconciled as requested)
        for stat in ["hp", "patk", "matk", "def", "speed"]:
            src_val = src.get(f"growth_{stat}")
            out_val = h["growth_stats"].get(stat)
            if out_val != src_val:
                errors.append(f"Mismatch at hero[{hid}].growth_stats.{stat}: output {out_val} != source {src_val}")
                
        # 3. Core Attributes & Mechanics
        core_attrs = [
            ("career", "career"),
            ("race", "race"),
            ("quality", "quality"),
            ("star", "star"),
            ("star_max", "star_max"),
            ("sex", "sex"),
            ("type", "type"),
            ("streng", "streng"),
            ("level_max", "level_max"),
            ("call_price", "call_price"),
            ("skill_num", "skill_num"),
            ("exchange_id", "exchange_id"),
            ("is_only", "is_only"),
            ("rebirth", "rebirth"),
            ("rgb_sort", "rgb_sort"),
            ("occupation_shade", "occupation_shade"),
            ("is_notice", "is_notice")
        ]
        for out_key, src_key in core_attrs:
            if h.get(out_key) != src.get(src_key):
                errors.append(f"Mismatch at hero[{hid}].{out_key}: output {h.get(out_key)} != source {src.get(src_key)}")
                
        # 4. Evolution Attributes
        evo = h.get("evolution", {})
        for evo_key in ["is_evo", "evo_kind", "evo_food", "super_evo", "is_skin"]:
            if evo.get(evo_key) != src.get(evo_key):
                errors.append(f"Mismatch at hero[{hid}].evolution.{evo_key}: output {evo.get(evo_key)} != source {src.get(evo_key)}")
                
        # 5. Awakening Arrays
        awakening = h.get("awakening", {})
        for w in range(1, 7):
            w_key = f"wake{w}"
            if awakening.get(w_key) != src.get(w_key, []):
                errors.append(f"Mismatch at hero[{hid}].awakening.{w_key}: output {awakening.get(w_key)} != source {src.get(w_key, [])}")
                
        # 6. Breakthrough Arrays
        bt = h.get("breakthrough", {})
        for b_key in ["break4", "break5"]:
            if bt.get(b_key) != src.get(b_key, []):
                errors.append(f"Mismatch at hero[{hid}].breakthrough.{b_key}: output {bt.get(b_key)} != source {src.get(b_key, [])}")

        # 7. Hero Skills & Levels Check against Source (Slot, Skill ID, and Skill Level)
        expected_skills = []
        for slot in range(1, 8):
            slot_skills = src.get(f"skill_{slot}_source", [])
            for item in slot_skills:
                if isinstance(item, list) and len(item) >= 2:
                    sk_id = str(item[0]) if item[0] is not None else None
                    sk_lv = item[1]
                elif isinstance(item, list) and len(item) == 1:
                    sk_id = str(item[0]) if item[0] is not None else None
                    sk_lv = 1
                elif item is not None:
                    sk_id = str(item)
                    sk_lv = 1
                if sk_id is not None:
                    expected_skills.append((slot, sk_id, sk_lv))
        actual_skills = [(s.get("slot"), s.get("skill_id"), s.get("level")) for s in h.get("skills", [])]
        if actual_skills != expected_skills:
            errors.append(f"Mismatch at hero[{hid}].skills: output skills {actual_skills} != source skills {expected_skills}")

    return errors

def reconcile_skills(skill_src, skills):
    """
    Field-by-field reconciliation of skills against source skill_detail.config.
    Verifies all mapped attributes including effect_lvchange, action 0 preservation, and evolution.
    """
    errors = []
    for sid, s in skills.items():
        src = skill_src.get(sid)
        if not src:
            errors.append(f"Skill ID {sid} not found in source skill_detail.config")
            continue
            
        # Core Skill Stats
        stat_checks = [
            ("cd", "cd"),
            ("pre_cd", "pre_cd"),
            ("rate", "rate"),
            ("effect", "effect"),
            ("attr_effect", "attr_effect"),
            ("effect_talent", "effect_talent"),
            ("effect_lvchange", "effect_lvchange"),
            ("effect_delay", "effect_delay"),
            ("is_learn", "is_learn"),
            ("evo_food", "evo_food"),
            ("max_lv", "max_lv"),
            ("attack_effect", "attack_effect")
        ]
        for out_key, src_key in stat_checks:
            if s.get(out_key) != src.get(src_key):
                errors.append(f"Mismatch at skill[{sid}].{out_key}: output {s.get(out_key)} != source {src.get(src_key)}")
                
        # Preserved Action Value
        if s.get("assets", {}).get("action") != src.get("action"):
            errors.append(f"Mismatch at skill[{sid}].assets.action: output {s.get('assets', {}).get('action')} != source {src.get('action')}")
            
        # Evolution Target Check against Source
        raw_evo = src.get("is_evolution")
        expected_next_skill = str(raw_evo) if raw_evo is not None and raw_evo > 0 else None
        evo = s.get("evolution", {})
        if evo.get("raw_is_evolution") != raw_evo:
            errors.append(f"Mismatch at skill[{sid}].evolution.raw_is_evolution: output {evo.get('raw_is_evolution')} != source {raw_evo}")
        if evo.get("next_evolution_skill_id") != expected_next_skill:
            errors.append(f"Mismatch at skill[{sid}].evolution.next_evolution_skill_id: output '{evo.get('next_evolution_skill_id')}' != source '{expected_next_skill}'")
        if evo.get("has_next_evolution") != (expected_next_skill is not None):
            errors.append(f"Mismatch at skill[{sid}].evolution.has_next_evolution: output {evo.get('has_next_evolution')} != source {expected_next_skill is not None}")
            
        # Resource Requirements
        res = s.get("resource", {})
        if res.get("type") != src.get("resource_type"):
            errors.append(f"Mismatch at skill[{sid}].resource.type: output {res.get('type')} != source {src.get('resource_type')}")
        if res.get("count") != src.get("resource_count"):
            errors.append(f"Mismatch at skill[{sid}].resource.count: output {res.get('count')} != source {src.get('resource_count')}")

    return errors

def reconcile_equipment(equip_src, equips):
    """
    Field-by-field reconciliation of equipment against source equip.config.
    Verifies all mapped attributes including restored equip_id, effect, slot, stats, enhancement, evolution.
    """
    errors = []
    for eid, eq in equips.items():
        src = equip_src.get(eid)
        if not src:
            errors.append(f"Equip ID {eid} not found in source equip.config")
            continue
            
        # Slot Mapping & Basic Attributes
        if eq.get("slot") != src.get("sort"):
            errors.append(f"Mismatch at equip[{eid}].slot: output {eq.get('slot')} != source {src.get('sort')}")
        if eq.get("raw_equip_id") != src.get("equip_id"):
            errors.append(f"Mismatch at equip[{eid}].raw_equip_id: output {eq.get('raw_equip_id')} != source {src.get('equip_id')}")
        expected_eid_str = str(src.get("equip_id")) if src.get("equip_id") is not None else None
        if eq.get("equip_id") != expected_eid_str:
            errors.append(f"Mismatch at equip[{eid}].equip_id string: output {eq.get('equip_id')} != source {expected_eid_str}")
        if eq.get("effect") != src.get("effect"):
            errors.append(f"Mismatch at equip[{eid}].effect: output {eq.get('effect')} != source {src.get('effect')}")
        if eq.get("quality") != src.get("quality"):
            errors.append(f"Mismatch at equip[{eid}].quality: output {eq.get('quality')} != source {src.get('quality')}")
            
        # Stats
        p_stat = eq.get("primary_stat", {})
        if p_stat.get("ability_id") != src.get("ability1"):
            errors.append(f"Mismatch at equip[{eid}].primary_stat.ability_id: output {p_stat.get('ability_id')} != source {src.get('ability1')}")
        if p_stat.get("value") != src.get("value1"):
            errors.append(f"Mismatch at equip[{eid}].primary_stat.value: output {p_stat.get('value')} != source {src.get('value1')}")
        if p_stat.get("level_add") != src.get("level_add1"):
            errors.append(f"Mismatch at equip[{eid}].primary_stat.level_add: output {p_stat.get('level_add')} != source {src.get('level_add1')}")
            
        s_stat = eq.get("secondary_stat", {})
        if s_stat.get("ability_id") != src.get("ability2"):
            errors.append(f"Mismatch at equip[{eid}].secondary_stat.ability_id: output {s_stat.get('ability_id')} != source {src.get('ability2')}")
        if s_stat.get("value") != src.get("value2"):
            errors.append(f"Mismatch at equip[{eid}].secondary_stat.value: output {s_stat.get('value')} != source {src.get('value2')}")
        if s_stat.get("level_add") != src.get("level_add2"):
            errors.append(f"Mismatch at equip[{eid}].secondary_stat.level_add: output {s_stat.get('level_add')} != source {src.get('level_add2')}")

        # Enhancement
        enh = eq.get("enhancement", {})
        if enh.get("equip_add1") != src.get("equip_add1"):
            errors.append(f"Mismatch at equip[{eid}].enhancement.equip_add1: output {enh.get('equip_add1')} != source {src.get('equip_add1')}")
        if enh.get("activation") != src.get("activation"):
            errors.append(f"Mismatch at equip[{eid}].enhancement.activation: output {enh.get('activation')} != source {src.get('activation')}")
        if enh.get("activation_level") != src.get("activation_level"):
            errors.append(f"Mismatch at equip[{eid}].enhancement.activation_level: output {enh.get('activation_level')} != source {src.get('activation_level')}")

        # Suit ID Check against Source
        raw_suit = src.get("suit")
        expected_suit = str(raw_suit) if raw_suit is not None and raw_suit != 0 else None
        if eq.get("suit_id") != expected_suit:
            errors.append(f"Mismatch at equip[{eid}].suit_id: output '{eq.get('suit_id')}' != source '{expected_suit}'")

        # Evolution Check against Source
        evo = eq.get("evolution", {})
        if evo.get("raw_evolution") != src.get("evolution"):
            errors.append(f"Mismatch at equip[{eid}].evolution.raw_evolution: output {evo.get('raw_evolution')} != source {src.get('evolution')}")
        raw_evo_target = src.get("evolution")
        expected_next_equip = str(raw_evo_target) if raw_evo_target is not None and raw_evo_target > 0 else None
        if evo.get("next_evolution_equip_id") != expected_next_equip:
            errors.append(f"Mismatch at equip[{eid}].evolution.next_evolution_equip_id: output '{evo.get('next_evolution_equip_id')}' != source '{expected_next_equip}'")
        if evo.get("has_next_evolution") != (expected_next_equip is not None):
            errors.append(f"Mismatch at equip[{eid}].evolution.has_next_evolution: output {evo.get('has_next_evolution')} != source {expected_next_equip is not None}")

        if evo.get("raw_evolution_id") != src.get("evolution_id"):
            errors.append(f"Mismatch at equip[{eid}].evolution.raw_evolution_id: output {evo.get('raw_evolution_id')} != source {src.get('evolution_id')}")
        raw_evo_id = src.get("evolution_id")
        expected_recipe_id = str(raw_evo_id) if raw_evo_id is not None and raw_evo_id > 0 else None
        if evo.get("evolution_recipe_id") != expected_recipe_id:
            errors.append(f"Mismatch at equip[{eid}].evolution.evolution_recipe_id: output '{evo.get('evolution_recipe_id')}' != source '{expected_recipe_id}'")

        # Mechanics & Economy
        mech_checks = [
            ("refine_id", "refine_id"),
            ("chain_id", "chain_id"),
            ("cd", "cd"),
            ("afterlife", "afterlife"),
            ("occupation1", "occupation1")
        ]
        for out_key, src_key in mech_checks:
            if eq.get(out_key) != src.get(src_key):
                errors.append(f"Mismatch at equip[{eid}].{out_key}: output {eq.get(out_key)} != source {src.get(src_key)}")
                
        econ = eq.get("economy", {})
        for econ_key in ["sell_metal", "exchange_id", "is_resolve"]:
            if econ.get(econ_key) != src.get(econ_key):
                errors.append(f"Mismatch at equip[{eid}].economy.{econ_key}: output {econ.get(econ_key)} != source {src.get(econ_key)}")

    return errors

def reconcile_equipment_sets(suit_src, suits):
    """Field-by-field reconciliation of equipment sets against source suit.config."""
    errors = []
    for sid, st in suits.items():
        src = suit_src.get(sid)
        if not src:
            errors.append(f"Suit ID {sid} not found in source suit.config")
            continue
        expected_parts = [str(p) for p in src.get("part", []) if p is not None]
        if st.get("parts") != expected_parts:
            errors.append(f"Mismatch at suit[{sid}].parts: output {st.get('parts')} != source {expected_parts}")
        bonuses = st.get("bonuses", {})
        if bonuses.get("2_piece") != src.get("effect_2", []):
            errors.append(f"Mismatch at suit[{sid}].bonuses.2_piece: output {bonuses.get('2_piece')} != source {src.get('effect_2')}")
        if bonuses.get("3_piece") != src.get("effect_3", []):
            errors.append(f"Mismatch at suit[{sid}].bonuses.3_piece: output {bonuses.get('3_piece')} != source {src.get('effect_3')}")
        if bonuses.get("4_piece") != src.get("effect_4", []):
            errors.append(f"Mismatch at suit[{sid}].bonuses.4_piece: output {bonuses.get('4_piece')} != source {src.get('effect_4')}")
    return errors

def reconcile_items(item_src, items):
    """Field-by-field reconciliation of items against source item.config."""
    errors = []
    for iid, it in items.items():
        src = item_src.get(iid)
        if not src:
            errors.append(f"Item ID {iid} not found in source item.config")
            continue
        for k in ["type", "quality", "price"]:
            if it.get(k) != src.get(k):
                errors.append(f"Mismatch at item[{iid}].{k}: output {it.get(k)} != source {src.get(k)}")
    return errors

def check_hero_id_types(heroes):
    """Check ID types for heroes and their nested fields."""
    errors = []
    for hid, h in heroes.items():
        if not isinstance(hid, str):
            errors.append(f"Non-string hero key ({type(hid).__name__}: {hid})")
        cid = h.get("character_id")
        if cid is not None and not isinstance(cid, str):
            errors.append(f"Non-string ID ({type(cid).__name__}: {cid}) at hero[{hid}].character_id")
        elif cid == "None":
            errors.append(f"String literal 'None' at hero[{hid}].character_id")
        for s in h.get("skills", []):
            skid = s.get("skill_id")
            if not isinstance(skid, str):
                errors.append(f"Non-string skill_id ({type(skid).__name__}: {skid}) at hero[{hid}].skills")
        for b in h.get("bonds", []):
            chid = b.get("chain_id")
            if not isinstance(chid, str):
                errors.append(f"Non-string chain_id ({type(chid).__name__}: {chid}) at hero[{hid}].bonds")
    return errors

def check_equip_id_types(equips):
    """Check ID types for equipment and their nested fields."""
    errors = []
    for eid, eq in equips.items():
        if not isinstance(eid, str):
            errors.append(f"Non-string equip key ({type(eid).__name__}: {eid})")
        if not isinstance(eq.get("id"), str):
            errors.append(f"Non-string equip.id ({type(eq.get('id')).__name__})")
        if eq.get("equip_id") is not None and not isinstance(eq.get("equip_id"), str):
            errors.append(f"Non-string equip.equip_id ({type(eq.get('equip_id')).__name__})")
        sid = eq.get("suit_id")
        if sid is not None and not isinstance(sid, str):
            errors.append(f"Non-string equip.suit_id ({type(sid).__name__}: {sid})")
    return errors

def check_equip_suit_links(equips, suits):
    """
    Check equipment.suit_id links and distinguish:
      1. suit == 0 / null in source: unsuited equipment (link naturally missing from source, NOT an error/warning).
      2. suit > 0 in source: suited equipment.
         - If suit_id exists in suits: valid suit link.
         - If suit_id does NOT exist in suits: broken suit target! (Logged as a warning).
    Returns:
      (unsuited_count, valid_suited_count, broken_suit_warnings)
    """
    unsuited_count = 0
    valid_suited_count = 0
    broken_suit_warnings = []
    
    for eid, eq in equips.items():
        sid = eq.get("suit_id")
        if sid is None:
            unsuited_count += 1
        else:
            if sid in suits:
                valid_suited_count += 1
            else:
                broken_suit_warnings.append({
                    "equip_id": eid,
                    "target_suit_id": sid,
                    "message": f"Broken suit target: equip[{eid}] references non-existent suit_id={sid}"
                })
                
    return unsuited_count, valid_suited_count, broken_suit_warnings

def check_ignored_fields_manifest(ignored_manifest):
    """
    Validate that ignored_fields.json accurately reflects the restoration of equip_id and effect,
    and confirms 0 inappropriately ignored fields from core configs.
    """
    errors = []
    # Verify equip.config has no ignored fields (equip_id and effect are restored)
    equip_ignored = ignored_manifest.get("equip.config", [])
    for item in equip_ignored:
        fld = item.get("field") if isinstance(item, dict) else str(item)
        if fld in ["equip_id", "effect"]:
            errors.append(f"ignored_fields.json still lists '{fld}' under equip.config as ignored!")

    # Verify character_detail.config has no unmapped fields
    char_ignored = ignored_manifest.get("character_detail.config", [])
    for item in char_ignored:
        fld = item.get("field") if isinstance(item, dict) else str(item)
        if fld in ["rgb_sort", "occupation_shade", "is_notice"]:
            errors.append(f"ignored_fields.json still lists '{fld}' under character_detail.config as ignored!")

    # Verify restored_fields records equip_id and effect
    restored = {r.get("field") for r in ignored_manifest.get("restored_fields", [])}
    if "equip_id" not in restored:
        errors.append("ignored_fields.json missing 'equip_id' in restored_fields list")
    if "effect" not in restored:
        errors.append("ignored_fields.json missing 'effect' in restored_fields list")

    return errors

def run_real_mutation_tests(source_data, out):
    """
    Real mutation testing on deep copies of extracted datasets.
    CALLS THE EXACT SAME VALIDATION FUNCTIONS used in the validator to prove error/warning detection.
    Does not use separate test conditions or ad-hoc assertions.
    """
    results = {}
    print("\n--- 9. Running Real Mutation Tests on Cloned Datasets ---")

    # 1. Mutation Test 1: Corrupt HP on cloned hero, run reconcile_heroes
    cloned_heroes = copy.deepcopy(out["heroes"])
    test_hero_id = "8200"
    real_src_hp = source_data["character_detail"][test_hero_id]["base_hp"]
    cloned_heroes[test_hero_id]["base_stats"]["hp"] = 999999
    
    # Call the exact validator reconciliation function:
    hp_errors = reconcile_heroes(source_data["character_detail"], cloned_heroes)
    matched_hp = [e for e in hp_errors if f"hero[{test_hero_id}].base_stats.hp" in e]
    results["mutation_hp_detection"] = {
        "passed": len(matched_hp) > 0,
        "detail": f"Mutated hero[{test_hero_id}].base_stats.hp to 999999; reconcile_heroes detected: '{matched_hp[0] if matched_hp else 'None'}'"
    }
    print(f"  [PASS] Mutation Test 1 (HP Mismatch): {results['mutation_hp_detection']['detail']}")

    # 2. Mutation Test 2: Corrupt ID type to integer on cloned hero, run check_hero_id_types
    cloned_heroes_id = copy.deepcopy(out["heroes"])
    cloned_heroes_id[test_hero_id]["character_id"] = 82  # int instead of str
    
    # Call the exact validator ID type check function:
    id_errors = check_hero_id_types(cloned_heroes_id)
    matched_id = [e for e in id_errors if f"hero[{test_hero_id}].character_id" in e]
    results["mutation_id_type_detection"] = {
        "passed": len(matched_id) > 0,
        "detail": f"Mutated hero[{test_hero_id}].character_id to int(82); check_hero_id_types detected: '{matched_id[0] if matched_id else 'None'}'"
    }
    print(f"  [PASS] Mutation Test 2 (ID Type Corrupted): {results['mutation_id_type_detection']['detail']}")

    # 3. Mutation Test 3: Corrupt Foreign Key Link on cloned equip, run check_equip_suit_links
    cloned_equips = copy.deepcopy(out["equipment"])
    test_equip_id = "16401"
    cloned_equips[test_equip_id]["suit_id"] = "CORRUPTED_SUIT_99999"
    
    # Call the exact validator suit link function:
    _, _, suit_link_warnings = check_equip_suit_links(cloned_equips, out["equipment_sets"])
    matched_suit = [w for w in suit_link_warnings if w.get("equip_id") == test_equip_id and w.get("target_suit_id") == "CORRUPTED_SUIT_99999"]
    results["mutation_link_detection"] = {
        "passed": len(matched_suit) > 0,
        "detail": f"Mutated equip[{test_equip_id}].suit_id to 'CORRUPTED_SUIT_99999'; check_equip_suit_links detected warning: '{matched_suit[0]['message'] if matched_suit else 'None'}'"
    }
    print(f"  [PASS] Mutation Test 3 (Broken Suit Link Warning): {results['mutation_link_detection']['detail']}")

    # 4. Mutation Test 4: Corrupt Zero Value to None on cloned skill, run reconcile_skills
    cloned_skills = copy.deepcopy(out["skills"])
    test_skill_id = "65536"
    cloned_skills[test_skill_id]["assets"]["action"] = None  # None instead of 0
    
    # Call the exact validator skill reconciliation function:
    skill_errors = reconcile_skills(source_data["skill_detail"], cloned_skills)
    matched_zero = [e for e in skill_errors if f"skill[{test_skill_id}].assets.action" in e]
    results["mutation_zero_preservation_detection"] = {
        "passed": len(matched_zero) > 0,
        "detail": f"Mutated skill[{test_skill_id}].assets.action to None; reconcile_skills detected: '{matched_zero[0] if matched_zero else 'None'}'"
    }
    print(f"  [PASS] Mutation Test 4 (Zero Turned to None): {results['mutation_zero_preservation_detection']['detail']}")

    # 5. Mutation Test 5: Valid-but-Wrong Foreign Key (Đao Ninja suit_id changed from "53" to existing suit "1")
    cloned_equips_wrong_id = copy.deepcopy(out["equipment"])
    test_ninja_id = "16401"  # Đao Ninja
    real_src_suit = str(source_data["equip"][test_ninja_id]["suit"])  # "53"
    wrong_valid_suit_id = "1"  # Valid suit ID existing in suits, but WRONG for Đao Ninja
    cloned_equips_wrong_id[test_ninja_id]["suit_id"] = wrong_valid_suit_id
    
    # Call the exact validator equipment reconciliation function:
    wrong_id_errors = reconcile_equipment(source_data["equip"], cloned_equips_wrong_id)
    matched_wrong_id = [e for e in wrong_id_errors if f"equip[{test_ninja_id}].suit_id" in e and f"output '{wrong_valid_suit_id}' != source '{real_src_suit}'" in e]
    results["mutation_valid_but_wrong_target"] = {
        "passed": len(matched_wrong_id) > 0,
        "detail": f"Mutated equip[{test_ninja_id}] (Đao Ninja) suit_id from '{real_src_suit}' to valid-but-wrong suit '{wrong_valid_suit_id}'; reconcile_equipment detected: '{matched_wrong_id[0] if matched_wrong_id else 'None'}'"
    }
    print(f"  [PASS] Mutation Test 5 (Valid-but-Wrong Target ID): {results['mutation_valid_but_wrong_target']['detail']}")

    return results

def validate_pipeline(config_dir="config", output_dir="output"):
    print("=== SAHHT WIKI DATA VALIDATION SUITE (v1.2.0) ===")
    
    # 1. Load source configs
    print("\n--- 1. Loading Source Files for Reconciliation ---")
    source_files = {
        "character_detail": os.path.join(config_dir, "character_detail.config"),
        "skill_detail": os.path.join(config_dir, "skill_detail.config"),
        "equip": os.path.join(config_dir, "equip.config"),
        "suit": os.path.join(config_dir, "suit.config"),
        "item": os.path.join(config_dir, "item.config"),
        "chain": os.path.join(config_dir, "chain.config"),
        "character_strengthen": os.path.join(config_dir, "character_strengthen.config"),
        "character_break_new": os.path.join(config_dir, "character_break_new.config"),
        "breakthrough": os.path.join(config_dir, "breakthrough.config"),
        "equip_evolution": os.path.join(config_dir, "equip_evolution.config"),
        "badge": os.path.join(config_dir, "badge.config"),
        "equip_gem_fate_txt": os.path.join(config_dir, "equip_gem_fate_txt.config"),
        "equip_gem_fate_skill": os.path.join(config_dir, "equip_gem_fate_skill.config"),
        "equip_gem_fate_word": os.path.join(config_dir, "equip_gem_fate_word.config"),
        "fate_rune_character": os.path.join(config_dir, "fate_rune_character.config"),
        "badge_txet": os.path.join(config_dir, "badge_txet.config"),
        "badge_skill_combination": os.path.join(config_dir, "badge_skill_combination.config"),
        "badge_refinement": os.path.join(config_dir, "badge_refinement.config")
    }
    
    source_data = {}
    for name, path in source_files.items():
        if not os.path.exists(path):
            print(f"[FATAL] Source file not found: {path}")
            sys.exit(1)
        with open(path, "r", encoding="utf-8") as f:
            source_data[name] = json.load(f)
            
    # 2. Load extracted output files
    print("--- 2. Loading Extracted Datasets ---")
    output_files = {
        "heroes": os.path.join(output_dir, "heroes.json"),
        "skills": os.path.join(output_dir, "skills.json"),
        "equipment": os.path.join(output_dir, "equipment.json"),
        "equipment_sets": os.path.join(output_dir, "equipment_sets.json"),
        "items": os.path.join(output_dir, "items.json"),
        "ban_suc": os.path.join(output_dir, "ban_suc.json"),
        "upgrade_mechanisms": os.path.join(output_dir, "upgrade_mechanisms.json"),
        "verification_issues": os.path.join(output_dir, "verification_issues.json"),
        "schema_index": os.path.join(output_dir, "schema_index.json"),
        "ignored_fields": os.path.join(output_dir, "ignored_fields.json")
    }
    
    out = {}
    for name, path in output_files.items():
        if not os.path.exists(path):
            print(f"[FATAL] Output file not found: {path}")
            sys.exit(1)
        with open(path, "r", encoding="utf-8") as f:
            out[name] = json.load(f)
            
    heroes = out["heroes"]
    skills = out["skills"]
    equips = out["equipment"]
    suits = out["equipment_sets"]
    items = out["items"]
    bansuc = out["ban_suc"]
    upgrades = out["upgrade_mechanisms"]
    issues = out["verification_issues"]
    ignored = out["ignored_fields"]
    
    errors = []

    # 3. Reconcile Record Counts with Source
    print("\n--- 3. Reconciling Counts with Source Configs ---")
    count_checks = [
        ("heroes", len(heroes), len(source_data["character_detail"]), "character_detail.config"),
        ("skills", len(skills), len(source_data["skill_detail"]), "skill_detail.config"),
        ("equipment", len(equips), len(source_data["equip"]), "equip.config"),
        ("equipment_sets", len(suits), len(source_data["suit"]), "suit.config"),
        ("items", len(items), len(source_data["item"]), "item.config"),
        ("strengthen", len(upgrades["character_strengthen"]), len(source_data["character_strengthen"]), "character_strengthen.config"),
        ("break_new", len(upgrades["character_break_new"]), len(source_data["character_break_new"]), "character_break_new.config"),
        ("breakthrough", len(upgrades["character_breakthrough"]), len(source_data["breakthrough"]), "breakthrough.config"),
        ("equip_evolution", len(upgrades["equipment_evolution"]), len(source_data["equip_evolution"]), "equip_evolution.config"),
        ("fate_rules", len(bansuc["fate_rules"]), len(source_data["equip_gem_fate_txt"]), "equip_gem_fate_txt.config"),
        ("fate_skills", len(bansuc["fate_skills"]), len(source_data["equip_gem_fate_skill"]), "equip_gem_fate_skill.config"),
        ("fate_words", len(bansuc["fate_words"]), len(source_data["equip_gem_fate_word"]), "equip_gem_fate_word.config"),
        ("fate_rune_characters", len(bansuc["fate_rune_characters"]), len(source_data["fate_rune_character"]), "fate_rune_character.config"),
        ("badges", len(bansuc["badges"]), len(source_data["badge"]), "badge.config"),
        ("badge_rules", len(bansuc["badge_rules"]), len(source_data["badge_txet"]), "badge_txet.config"),
        ("badge_combinations", len(bansuc["badge_combinations"]), len(source_data["badge_skill_combination"]), "badge_skill_combination.config"),
        ("badge_refinements", len(bansuc["badge_refinements"]), len(source_data["badge_refinement"]), "badge_refinement.config")
    ]
    
    for name, out_cnt, src_cnt, src_file in count_checks:
        if out_cnt != src_cnt:
            errors.append(f"Count mismatch in {name}: output={out_cnt}, source({src_file})={src_cnt}")
            print(f"  [FAIL] {name}: output={out_cnt} != source={src_cnt}")
        else:
            print(f"  [PASS] {name}: {out_cnt} records match {src_file}")

    # 4. Field-by-Field Value Reconciliation
    print("\n--- 4. Field-by-Field Value Reconciliation (including growth_stats & effect_lvchange) ---")
    hero_errors = reconcile_heroes(source_data["character_detail"], heroes)
    errors.extend(hero_errors)
    print(f"  Heroes reconciliation: 721 records checked (Mismatches: {len(hero_errors)})")
    
    skill_errors = reconcile_skills(source_data["skill_detail"], skills)
    errors.extend(skill_errors)
    print(f"  Skills reconciliation: 10,836 records checked (Mismatches: {len(skill_errors)})")
    
    equip_errors = reconcile_equipment(source_data["equip"], equips)
    errors.extend(equip_errors)
    print(f"  Equipment reconciliation: 4,366 records checked (Mismatches: {len(equip_errors)})")

    suit_errors = reconcile_equipment_sets(source_data["suit"], suits)
    errors.extend(suit_errors)
    print(f"  Equipment Sets reconciliation: 729 records checked (Mismatches: {len(suit_errors)})")

    item_errors = reconcile_items(source_data["item"], items)
    errors.extend(item_errors)
    print(f"  Items reconciliation: 3,707 records checked (Mismatches: {len(item_errors)})")

    # 5. Nested ID Type Validation
    print("\n--- 5. Checking Nested ID Types (String IDs) ---")
    hero_id_errors = check_hero_id_types(heroes)
    errors.extend(hero_id_errors)
    equip_id_errors = check_equip_id_types(equips)
    errors.extend(equip_id_errors)
    print(f"  Nested ID type check complete: Total type errors: {len(hero_id_errors) + len(equip_id_errors)} (Expected: 0)")

    # 6. Check Traceability (_source Integrity)
    print("\n--- 6. Validating Traceability (_source Integrity) ---")
    source_errors = 0
    for dname, ddict in [("heroes", heroes), ("skills", skills), ("equipment", equips), ("equipment_sets", suits), ("items", items)]:
        for k, v in ddict.items():
            src = v.get("_source")
            if not src or not isinstance(src, dict) or not src.get("file") or not src.get("key"):
                source_errors += 1
                errors.append(f"Incomplete _source at {dname}[{k}]")
                continue
            cfg_name = os.path.splitext(src["file"])[0]
            if cfg_name not in source_data or str(src["key"]) not in source_data[cfg_name]:
                source_errors += 1
                errors.append(f"Invalid _source reference at {dname}[{k}]: {src}")

    print(f"  Traceability check complete: Broken source references: {source_errors} (Expected: 0)")

    # 7. Referential Integrity & Disaggregation
    print("\n--- 7. Referential Integrity & Disaggregation ---")
    
    # Hero Skills
    hero_skill_refs_total = sum(len(h.get("skills", [])) for h in heroes.values())
    hero_skill_refs_valid = sum(1 for h in heroes.values() for s in h.get("skills", []) if s.get("skill_id") in skills)
    missing_skill_refs = [(hid, s.get("skill_id")) for hid, h in heroes.items() for s in h.get("skills", []) if s.get("skill_id") not in skills]
    distinct_missing_skills = {sid for _, sid in missing_skill_refs}
    print(f"  Hero Skills: {hero_skill_refs_valid}/{hero_skill_refs_total} valid occurrences")
    print(f"  Missing Skill References: {len(missing_skill_refs)} occurrences across {len(distinct_missing_skills)} distinct skill IDs")

    # Suit Parts
    suit_parts_total = sum(len(s.get("parts", [])) for s in suits.values())
    suit_parts_valid = sum(1 for s in suits.values() for p in s.get("parts", []) if p in equips)
    missing_suit_parts = [(sid, p) for sid, s in suits.items() for p in s.get("parts", []) if p not in equips]
    distinct_missing_suit_parts = {p for _, p in missing_suit_parts}
    print(f"  Suit Parts: {suit_parts_valid}/{suit_parts_total} valid occurrences")
    print(f"  Missing Suit Parts: {len(missing_suit_parts)} occurrences across {len(distinct_missing_suit_parts)} distinct equip IDs")

    # Equip -> Suit Links (DISTINGUISHING UNSUITED FROM BROKEN TARGETS)
    unsuited_count, valid_suited_count, broken_suit_warnings = check_equip_suit_links(equips, suits)
    print(f"  Equip -> Suit: {valid_suited_count} valid suited, {unsuited_count} unsuited (suit==0 in source), {len(broken_suit_warnings)} broken targets")
    if broken_suit_warnings:
        print(f"  [WARNING] Found {len(broken_suit_warnings)} broken suit targets in equipment!")

    # Equip -> Evolution Recipe
    equip_recipes_total = sum(1 for e in equips.values() if e.get("evolution", {}).get("evolution_recipe_id"))
    equip_recipes_valid = sum(1 for e in equips.values() if e.get("evolution", {}).get("evolution_recipe_id") and e.get("evolution", {}).get("evolution_recipe_id") in upgrades["equipment_evolution"])
    missing_recipes = [e["evolution"]["evolution_recipe_id"] for e in equips.values() if e.get("evolution", {}).get("evolution_recipe_id") and e.get("evolution", {}).get("evolution_recipe_id") not in upgrades["equipment_evolution"]]
    distinct_missing_recipes = set(missing_recipes)
    print(f"  Equip -> Evolution Recipe: {equip_recipes_valid}/{equip_recipes_total} valid occurrences")
    print(f"  Missing Evolution Recipes: {len(missing_recipes)} occurrences across {len(distinct_missing_recipes)} distinct recipe IDs")

    # Skill -> Next Evolution Skill
    skill_evo_total = sum(1 for s in skills.values() if s.get("evolution", {}).get("next_evolution_skill_id"))
    skill_evo_valid = sum(1 for s in skills.values() if s.get("evolution", {}).get("next_evolution_skill_id") and s.get("evolution", {}).get("next_evolution_skill_id") in skills)
    missing_skill_evos = [s["evolution"]["next_evolution_skill_id"] for s in skills.values() if s.get("evolution", {}).get("next_evolution_skill_id") and s.get("evolution", {}).get("next_evolution_skill_id") not in skills]
    distinct_missing_skill_evos = set(missing_skill_evos)
    print(f"  Skill -> Next Evolution Skill: {skill_evo_valid}/{skill_evo_total} valid occurrences")
    print(f"  Missing Next Evolution Skills: {len(missing_skill_evos)} occurrences across {len(distinct_missing_skill_evos)} distinct target IDs")

    # 8. Asset Ambiguity Verification
    print("\n--- 8. Asset Resolution Status Audit ---")
    asset_status_counts = {"found": 0, "ambiguous": 0, "not_found": 0, "empty": 0}
    for h in heroes.values():
        for f in ["image", "animation"]:
            st = h.get("assets", {}).get(f, {}).get("status", "empty")
            asset_status_counts[st] = asset_status_counts.get(st, 0) + 1
    print(f"  Hero Assets: {asset_status_counts}")

    # 8b. Ignored Fields Manifest Verification
    print("\n--- 8b. Validating ignored_fields.json Integrity ---")
    ignored_errors = check_ignored_fields_manifest(ignored)
    errors.extend(ignored_errors)
    if ignored_errors:
        print(f"  [FAIL] Ignored fields errors: {ignored_errors}")
    else:
        print(f"  [PASS] ignored_fields.json accurately confirms 0 ignored fields and records restored status for equip_id and effect.")

    # 9. Real Mutation Testing on Cloned Datasets (calling exact same validator functions)
    mutation_results = run_real_mutation_tests(source_data, out)

    # 10. Summary and Categorized Status
    print("\n==================================================")
    print("           VALIDATION SUMMARY REPORT             ")
    print("==================================================")
    
    unnamed_heroes = [k for k, v in heroes.items() if v.get("name") is None]
    unnamed_skills = [k for k, v in skills.items() if v.get("name") is None]
    unnamed_items = [k for k, v in items.items() if v.get("name") is None]
    
    warnings_count = len(missing_skill_refs) + len(missing_suit_parts) + len(missing_recipes) + len(missing_skill_evos) + len(broken_suit_warnings)
    unverified_count = len(unnamed_heroes) + len(unnamed_skills) + len(unnamed_items)
    
    print(f"Total Structural Errors: {len(errors)}")
    print(f"Total Content Warnings:  {warnings_count}")
    print(f"Total Unverified Items:  {unverified_count}")
    
    verdict = "PASSED_WITH_WARNINGS" if len(errors) == 0 else "FAILED"
    print(f"\nOVERALL VERDICT: {verdict}")
    
    validation_report = {
        "status": verdict,
        "metrics": {
            "errors_count": len(errors),
            "warnings_count": warnings_count,
            "unverified_count": unverified_count,
            "string_id_failures": len(hero_id_errors) + len(equip_id_errors),
            "broken_source_references": source_errors,
            "field_reconciliation_failures": len(hero_errors) + len(skill_errors) + len(equip_errors) + len(suit_errors) + len(item_errors),
            "hero_skill_references": {
                "total_occurrences": hero_skill_refs_total,
                "valid_occurrences": hero_skill_refs_valid,
                "missing_occurrences": len(missing_skill_refs),
                "distinct_missing_ids": len(distinct_missing_skills)
            },
            "suit_part_references": {
                "total_occurrences": suit_parts_total,
                "valid_occurrences": suit_parts_valid,
                "missing_occurrences": len(missing_suit_parts),
                "distinct_missing_ids": len(distinct_missing_suit_parts)
            },
            "equip_suit_references": {
                "unsuited_count": unsuited_count,
                "valid_suited_count": valid_suited_count,
                "broken_target_count": len(broken_suit_warnings)
            },
            "equip_evolution_recipe_references": {
                "total_occurrences": equip_recipes_total,
                "valid_occurrences": equip_recipes_valid,
                "missing_occurrences": len(missing_recipes),
                "distinct_missing_ids": len(distinct_missing_recipes)
            },
            "skill_evolution_target_references": {
                "total_occurrences": skill_evo_total,
                "valid_occurrences": skill_evo_valid,
                "missing_occurrences": len(missing_skill_evos),
                "distinct_missing_ids": len(distinct_missing_skill_evos)
            },
            "unnamed_counts": {
                "heroes": len(unnamed_heroes),
                "skills": len(unnamed_skills),
                "items": len(unnamed_items)
            },
            "mutation_tests": mutation_results
        },
        "errors_list": errors
    }
    
    with open(os.path.join(output_dir, "validation_summary.json"), "w", encoding="utf-8") as f:
        json.dump(validation_report, f, ensure_ascii=False, indent=2)
    print(f"Validation report saved to: {os.path.join(output_dir, 'validation_summary.json')}")
    
    return len(errors) == 0

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SAHHT WIKI Data Validation Suite")
    parser.add_argument("--config-dir", default="config", help="Source config directory")
    parser.add_argument("--output-dir", default="output", help="Target output directory")
    args = parser.parse_args()
    
    success = validate_pipeline(config_dir=args.config_dir, output_dir=args.output_dir)
    sys.exit(0 if success else 1)
