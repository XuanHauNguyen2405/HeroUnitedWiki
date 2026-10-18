import json
import os

def analyze_character():
    print("=== 1. ANALYZING CHARACTERS ===")
    with open("config/character_detail.config", "r", encoding="utf-8") as f:
        chars = json.load(f)
    print(f"Total character records: {len(chars)}")
    
    # Analyze distinct names, character_IDs, qualities, stars, careers, races
    distinct_cids = set()
    distinct_names = set()
    qualities = {}
    stars = {}
    careers = {}
    races = {}
    missing_fields = {}
    
    for k, v in chars.items():
        cid = str(v.get("character_ID"))
        distinct_cids.add(cid)
        distinct_names.add(v.get("name"))
        q = v.get("quality")
        qualities[q] = qualities.get(q, 0) + 1
        st = v.get("star")
        stars[st] = stars.get(st, 0) + 1
        car = v.get("career")
        careers[car] = careers.get(car, 0) + 1
        rc = v.get("race")
        races[rc] = races.get(rc, 0) + 1
        
        for field in ["name", "character_ID", "quality", "career", "base_hp", "base_def", "base_speed", "base_patk", "base_matk"]:
            if v.get(field) is None:
                missing_fields.setdefault(field, []).append(k)
                
    print(f"Distinct character_IDs: {len(distinct_cids)}")
    print(f"Distinct names: {len(distinct_names)}")
    print(f"Quality distribution: {sorted(qualities.items())}")
    print(f"Star distribution: {sorted(stars.items())}")
    print(f"Career distribution: {sorted(careers.items())}")
    print(f"Race distribution: {sorted(races.items())}")
    print(f"Missing mandatory fields: {missing_fields}")
    
    # Check sample record
    sample_key = "8200" # Duong Tien
    if sample_key in chars:
        print(f"\nSample Character [Key: {sample_key}]:")
        c = chars[sample_key]
        for f in ["character_ID", "name", "race", "career", "quality", "star", "base_hp", "base_def", "base_speed", "base_patk", "base_matk", "growth_hp", "growth_def", "growth_speed", "growth_patk", "growth_matk", "story"]:
            print(f"  {f}: {c.get(f)}")

def analyze_skills():
    print("\n=== 2. ANALYZING SKILLS ===")
    with open("config/skill_detail.config", "r", encoding="utf-8") as f:
        skills = json.load(f)
    print(f"Total skills: {len(skills)}")
    
    skill_types = {}
    qualities = {}
    has_story = 0
    missing_names = 0
    
    for k, v in skills.items():
        st = v.get("skill_type")
        skill_types[st] = skill_types.get(st, 0) + 1
        sq = v.get("skill_quality")
        qualities[sq] = qualities.get(sq, 0) + 1
        if v.get("skill_story"):
            has_story += 1
        if not v.get("skill_name"):
            missing_names += 1
            
    print(f"Skill types: {skill_types}")
    print(f"Skill qualities: {sorted(qualities.items())}")
    print(f"Skills with description/story: {has_story}/{len(skills)}")
    print(f"Skills missing name: {missing_names}")
    
    # Check sample
    sample_key = "8210"
    if sample_key in skills:
        print(f"\nSample Skill [Key: {sample_key}]:")
        sk = skills[sample_key]
        for f in ["skill_name", "skill_quality", "skill_type", "cd", "rate", "attr_effect", "effect", "effect_talent", "effect_lvchange", "skill_story"]:
            print(f"  {f}: {sk.get(f)}")

def analyze_equip_and_suits():
    print("\n=== 3. ANALYZING EQUIP & SUITS ===")
    with open("config/equip.config", "r", encoding="utf-8") as f:
        equips = json.load(f)
    with open("config/suit.config", "r", encoding="utf-8") as f:
        suits = json.load(f)
        
    print(f"Total equips: {len(equips)}")
    print(f"Total suits: {len(suits)}")
    
    equip_qualities = {}
    equips_with_suit = 0
    equips_without_suit = 0
    suit_id_references = set()
    
    for k, v in equips.items():
        q = v.get("quality")
        equip_qualities[q] = equip_qualities.get(q, 0) + 1
        s_id = v.get("suit")
        if s_id and s_id != 0:
            equips_with_suit += 1
            suit_id_references.add(str(s_id))
        else:
            equips_without_suit += 1
            
    print(f"Equip qualities: {sorted(equip_qualities.items())}")
    print(f"Equips with suit: {equips_with_suit}, without: {equips_without_suit}")
    print(f"Distinct suit IDs referenced: {len(suit_id_references)}")
    
    # Cross reference with suit.config
    matched_suits = suit_id_references.intersection(set(suits.keys()))
    unmatched_suits = suit_id_references - set(suits.keys())
    print(f"Matched suits: {len(matched_suits)}, Unmatched suit IDs: {len(unmatched_suits)} {unmatched_suits}")
    
    # Sample equip
    sample_eq = "16401"
    if sample_eq in equips:
        print(f"\nSample Equip [Key: {sample_eq}]:")
        eq = equips[sample_eq]
        for f in ["name", "quality", "suit", "ability1", "value1", "ability2", "value2", "evolution_id", "des"]:
            print(f"  {f}: {eq.get(f)}")
            
    # Sample suit
    sample_suit = "1"
    if sample_suit in suits:
        print(f"\nSample Suit [Key: {sample_suit}]:")
        st = suits[sample_suit]
        for f in ["name", "part", "effect_2", "effect_3", "effect_4"]:
            print(f"  {f}: {st.get(f)}")

def analyze_bansuc():
    print("\n=== 4. ANALYZING BAN SỨC (FATE GEMS & BADGES) ===")
    with open("config/equip_gem_fate_txt.config", "r", encoding="utf-8") as f:
        fate_txt = json.load(f)
    with open("config/equip_gem_fate_word.config", "r", encoding="utf-8") as f:
        fate_word = json.load(f)
    with open("config/equip_gem_fate_skill.config", "r", encoding="utf-8") as f:
        fate_skill = json.load(f)
    with open("config/badge.config", "r", encoding="utf-8") as f:
        badge = json.load(f)
    with open("config/badge_txet.config", "r", encoding="utf-8") as f:
        badge_text = json.load(f)
    with open("config/badge_refinement.config", "r", encoding="utf-8") as f:
        badge_refine = json.load(f)
    with open("config/badge_skill_combination.config", "r", encoding="utf-8") as f:
        badge_combo = json.load(f)
        
    print(f"Fate Gem Text entries: {len(fate_txt)}")
    print(f"Fate Gem Words: {len(fate_word)}")
    print(f"Fate Gem Skills: {len(fate_skill)}")
    print(f"Badges: {len(badge)}")
    print(f"Badge Text entries: {len(badge_text)}")
    print(f"Badge Refinements: {len(badge_refine)}")
    print(f"Badge Skill Combinations: {len(badge_combo)}")
    
    # Print sample fate skills
    print("\nSample Fate Skills:")
    for k in list(fate_skill.keys())[:3]:
        fs = fate_skill[k]
        print(f"  ID {k}: name={fs.get('name')}, des={fs.get('des')}, quality={fs.get('skill_quality')}, power_text={fs.get('power_text')}")

    # Print sample badges
    print("\nSample Badges:")
    for k in list(badge.keys())[:3]:
        b = badge[k]
        print(f"  ID {k}: name={b.get('badge_name')}, level={b.get('badge_level')}, base_up={b.get('base_up')}, skill={b.get('skill_name')}")

def analyze_upgrades():
    print("\n=== 5. ANALYZING UPGRADES ===")
    with open("config/character_strengthen.config", "r", encoding="utf-8") as f:
        cs = json.load(f)
    with open("config/character_break_new.config", "r", encoding="utf-8") as f:
        cbn = json.load(f)
    with open("config/breakthrough.config", "r", encoding="utf-8") as f:
        bt = json.load(f)
    with open("config/equip_evolution.config", "r", encoding="utf-8") as f:
        ee = json.load(f)
        
    print(f"Character Strengthen levels: {len(cs)}")
    print(f"Character Break New records: {len(cbn)}")
    print(f"Breakthrough records: {len(bt)}")
    print(f"Equip Evolution records: {len(ee)}")
    
    print("\nSample Strengthen Level 1:")
    print(cs.get("1"))
    print("\nSample Strengthen Level 60:")
    print(cs.get("60"))

if __name__ == "__main__":
    analyze_character()
    analyze_skills()
    analyze_equip_and_suits()
    analyze_bansuc()
    analyze_upgrades()
