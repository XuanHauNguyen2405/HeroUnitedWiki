import json
import glob

def find_terms():
    print("=== SEARCHING ENUMS & MAPPINGS ===")
    
    # 1. Search career / race / occupation
    with open("config/occupation.config", "r", encoding="utf-8") as f:
        occ = json.load(f)
    print(f"occupation.config entries: {len(occ)}")
    sample_occ = {k: occ[k] for k in list(occ.keys())[:10]}
    print(f"Sample occupation: {sample_occ}")
    
    # 2. Check if there are any config files with 'attr', 'career', 'race', 'type', 'hero' in their name
    attr_configs = [f for f in glob.glob("config/*.config") if any(x in f.lower() for x in ["attr", "prop", "career", "race", "type", "hero", "const", "global"])]
    print(f"Potentially relevant configs: {attr_configs}")
    for ac in attr_configs:
        try:
            with open(ac, "r", encoding="utf-8") as f:
                d = json.load(f)
                print(f"  {ac}: count={len(d) if isinstance(d, (dict, list)) else 1}")
                if isinstance(d, dict) and d:
                    first_k = next(iter(d))
                    print(f"    sample: {first_k} -> {d[first_k]}")
        except Exception as e:
            print(f"  {ac}: error {e}")
            
    # 3. Check equip sort values
    with open("config/equip.config", "r", encoding="utf-8") as f:
        equips = json.load(f)
    sort_vals = {}
    ability_vals = {}
    for k, v in equips.items():
        s = v.get("sort")
        sort_vals[s] = sort_vals.get(s, 0) + 1
        a1 = v.get("ability1")
        if a1 is not None:
            ability_vals[a1] = ability_vals.get(a1, 0) + 1
        a2 = v.get("ability2")
        if a2 is not None:
            ability_vals[a2] = ability_vals.get(a2, 0) + 1
            
    print(f"\nEquip 'sort' values distribution: {sort_vals}")
    print(f"Equip 'ability' IDs distribution: {sorted(ability_vals.items())}")

if __name__ == "__main__":
    find_terms()
