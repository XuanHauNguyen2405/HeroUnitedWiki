#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
tools/prepare_web_data.py
-------------------------
Chuẩn bị dữ liệu và hình ảnh tối ưu hóa cho ứng dụng web (web/):
1. Quét public/assets/ và sao chép DUY NHẤT các tệp hình ảnh (.png, .jpg, .webp, .svg)
   vào web/public/assets/. Tuyệt đối loại bỏ .lua, .plist, .wav khỏi thư mục web public.
2. Chuẩn hóa đường dẫn trình duyệt: chuyển "public/assets/..." thành "/assets/...".
3. Tạo chỉ mục tìm kiếm gọn (web/src/data/search_index.json) hỗ trợ tìm kiếm tiếng Việt
   có dấu / không dấu cực nhanh.
4. Tách dữ liệu thành các tệp danh mục gọn (heroes_catalog, suits_catalog, equipment_catalog,
   skills_catalog) và các tệp chi tiết (heroes_detail, skills_detail, suits_detail, ban_suc).
5. Tránh hoàn toàn việc tải JSON kỹ năng 16MB xuống client trang chủ.
6. Tạo khung dữ liệu biên tập (editorial_data.json) với trạng thái chưa có nội dung chuẩn.
"""

import os
import sys
import json
import shutil
import unicodedata
import re

def strip_vietnamese_accents(text):
    """Normalize Vietnamese text to lowercase without diacritics for fast searching."""
    if not text:
        return ""
    # Normalize unicode
    text = unicodedata.normalize('NFD', str(text))
    text = re.sub(r'[\u0300-\u036f]', '', text)
    # Replace special Vietnamese letters
    text = text.replace('đ', 'd').replace('Đ', 'd')
    return text.lower().strip()

def web_asset_url(p):
    """Convert disk asset path (public/assets/...) to browser URL (/assets/...)."""
    if not p:
        return None
    p_norm = str(p).replace("\\", "/").strip("/")
    if p_norm.startswith("public/assets/"):
        return "/" + p_norm[len("public/"):]
    elif p_norm.startswith("assets/"):
        return "/" + p_norm
    return "/" + p_norm

def copy_web_images(src_dir="public/assets", dst_dir="web/public/assets"):
    """Copy only image files to web/public/assets, ignoring lua, plist, wav, etc."""
    print(f"\n[1/5] Copying web images from '{src_dir}' to '{dst_dir}'...")
    os.makedirs(dst_dir, exist_ok=True)
    
    image_exts = {".png", ".jpg", ".jpeg", ".webp", ".svg", ".ico"}
    copied = 0
    total_bytes = 0
    skipped_non_image = 0
    
    for root, _, files in os.walk(src_dir):
        for f in files:
            ext = os.path.splitext(f)[1].lower()
            src_file = os.path.join(root, f)
            rel_path = os.path.relpath(src_file, src_dir)
            dst_file = os.path.join(dst_dir, rel_path)
            
            if ext in image_exts:
                os.makedirs(os.path.dirname(dst_file), exist_ok=True)
                # Only copy if dst doesn't exist or size differs
                if not os.path.exists(dst_file) or os.path.getsize(dst_file) != os.path.getsize(src_file):
                    shutil.copy2(src_file, dst_file)
                copied += 1
                total_bytes += os.path.getsize(dst_file)
            else:
                skipped_non_image += 1
                
    print(f"  Copied/Verified {copied} image files ({total_bytes / (1024*1024):.2f} MB).")
    print(f"  Excluded {skipped_non_image} non-image files (.lua, .plist, .wav, etc.) from web public bundle.")

def prepare_data(output_dir="output", web_data_dir="web/src/data"):
    print(f"\n[2/5] Loading datasets from '{output_dir}'...")
    os.makedirs(web_data_dir, exist_ok=True)
    
    # Load raw extracted datasets
    with open(os.path.join(output_dir, "heroes.json"), "r", encoding="utf-8") as f:
        heroes = json.load(f)
    with open(os.path.join(output_dir, "skills.json"), "r", encoding="utf-8") as f:
        skills = json.load(f)
    with open(os.path.join(output_dir, "equipment.json"), "r", encoding="utf-8") as f:
        equipment = json.load(f)
    with open(os.path.join(output_dir, "equipment_sets.json"), "r", encoding="utf-8") as f:
        suits = json.load(f)
    with open(os.path.join(output_dir, "items.json"), "r", encoding="utf-8") as f:
        items = json.load(f)
    with open(os.path.join(output_dir, "ban_suc.json"), "r", encoding="utf-8") as f:
        ban_suc = json.load(f)

    # Load supporting configs for Chuyen Sinh, Van Menh, and Super Evo
    with open("config/character_break_new.config", "r", encoding="utf-8") as f:
        character_break_new = json.load(f)
    with open("config/chain.config", "r", encoding="utf-8") as f:
        chains_config = json.load(f)
    with open("config/breakthrough.config", "r", encoding="utf-8") as f:
        breakthrough_config = json.load(f)
    with open("config/item.config", "r", encoding="utf-8") as f:
        items_config = json.load(f)
    with open("config/character_detail.config", "r", encoding="utf-8") as f:
        character_detail_config = json.load(f)

    hero_names = {str(k): v.get("name") for k, v in heroes.items() if v.get("name")}
    equip_names = {str(k): v.get("name") for k, v in equipment.items() if v.get("name")}
    item_names = {str(k): v.get("name") for k, v in items_config.items() if v.get("name")}

    cb_by_char_id = {str(v.get("character_id")): v for v in character_break_new.values() if v.get("character_id")}
    cb_by_name = {v.get("name").lower().strip(): v for v in character_break_new.values() if v.get("name")}

    # Badges mapping and synergy helper
    badges_raw = ban_suc.get("badges", {})
    def get_synergy_info(badge_name):
        bname_lower = (badge_name or "").lower()
        if any(k in bname_lower for k in ["nagato", "shadow", "kakarot", "inori", "maple"]):
            return {
                "name": "Siêu Anh Hùng Hội Tụ (Anh Hùng Tập Kết)",
                "effect": "Kích hoạt Hộ Giá toàn phe: 1-2 huy hiệu nhận 1 lần Hộ Giá, 3 huy hiệu nhận 3 lần Hộ Giá, 5 huy hiệu toàn phe nhận 2 tầng Hộ Giá."
            }
        elif any(k in bname_lower for k in ["broli", "kong", "hy vọng", "vegeta"]):
            return {
                "name": "Tổ Hợp Huy Hiệu Ngọc Rồng",
                "effect": "Kích hoạt Thần Ngự: 1 huy hiệu nhận 1 lớp Thần Ngự, 3 huy hiệu nhận 3 lớp Thần Ngự, 5 huy hiệu toàn đội nhận 2 lớp Thần Ngự."
            }
        elif any(k in bname_lower for k in ["kikyo", "shalltear", "tenka", "frieren", "elaina"]):
            return {
                "name": "Tổ Hợp Huy Hiệu Nữ Thần",
                "effect": "Nếu phe địch có nhân vật nam: nhận Vô Địch, Thần Ngự, Hộ Giá và giảm 100% tất cả Phòng Thủ của nhân vật nam phe địch."
            }
        return {
            "name": "Kỹ Năng Huy Hiệu Độc Quyền",
            "effect": "Tăng cường năng lực tiềm lực chỉ định cho tướng và tăng thêm thuộc tính đội hình."
        }

    badges_by_type_id = {}
    badges_by_char_name = {}
    for bid, b in badges_raw.items():
        btid = str(b.get("badge_type_id") or "")
        cname = (b.get("character_name") or "").lower().strip()
        badges_by_type_id.setdefault(btid, []).append(b)
        badges_by_char_name.setdefault(cname, []).append(b)

    # 1. Build Search Index
    print("\n[3/5] Building high-performance accent-insensitive Search Index...")
    search_index = []
    
    # Add Heroes
    for hid, h in heroes.items():
        name = h.get("name") or f"Tướng #{hid}"
        avatar = web_asset_url(h.get("assets", {}).get("image", {}).get("path"))
        search_index.append({
            "id": hid,
            "title": name,
            "clean_title": strip_vietnamese_accents(name),
            "category": "hero",
            "category_name": "Tướng",
            "url": f"/heroes/{hid}",
            "image": avatar,
            "badge": f"Phẩm {h.get('quality', 0)}",
            "subtext": f"Hệ/Tộc {h.get('race', 0)} • Nghề {h.get('career', 0)}"
        })
        
    # Add Suits
    for sid, s in suits.items():
        name = s.get("name") or f"Bộ #{sid}"
        search_index.append({
            "id": sid,
            "title": f"Bộ {name}",
            "clean_title": strip_vietnamese_accents(f"Bo {name} {sid}"),
            "category": "suit",
            "category_name": "Bộ Trang Bị",
            "url": f"/suits/{sid}",
            "image": None,
            "badge": f"ID {sid}",
            "subtext": f"{len(s.get('parts', []))} món trang bị"
        })

    # Add Equipment (Top or with real names)
    for eid, eq in equipment.items():
        name = eq.get("name")
        if name:
            img = web_asset_url(eq.get("assets", {}).get("image", {}).get("path"))
            search_index.append({
                "id": eid,
                "title": name,
                "clean_title": strip_vietnamese_accents(name),
                "category": "equipment",
                "category_name": "Trang Bị",
                "url": f"/equipment/{eid}",
                "image": img,
                "badge": f"Slot {eq.get('slot')}: {eq.get('slot_name')}",
                "subtext": f"Bộ {eq.get('suit_name', 'Lẻ')} (ID: {eq.get('suit_id', 'Lẻ')})"
            })

    # Add Skills (Unique names)
    seen_skill_names = set()
    for skid, sk in skills.items():
        name = sk.get("name")
        if name and name not in seen_skill_names:
            seen_skill_names.add(name)
            icon = web_asset_url(sk.get("assets", {}).get("icon", {}).get("path"))
            search_index.append({
                "id": skid,
                "title": name,
                "clean_title": strip_vietnamese_accents(name),
                "category": "skill",
                "category_name": "Kỹ Năng",
                "url": f"/skills/{skid}",
                "image": icon,
                "badge": f"Cấp max {sk.get('max_lv', 0)}",
                "subtext": f"Loại: {sk.get('skill_type', 'N/A')}"
            })

    with open(os.path.join(web_data_dir, "search_index.json"), "w", encoding="utf-8") as f:
        json.dump(search_index, f, ensure_ascii=False)
    print(f"  Generated search_index.json with {len(search_index)} indexed entities ({os.path.getsize(os.path.join(web_data_dir, 'search_index.json'))/1024:.1f} KB).")

    # 2. Build Heroes Catalog & Detail
    print("\n[4/5] Preparing Heroes Catalog and Full Details...")
    heroes_catalog = []
    heroes_detail = {}
    
    # Skill reverse index: skill_id -> list of hero names
    skill_to_heroes = {}

    for hid, h in heroes.items():
        avatar = web_asset_url(h.get("assets", {}).get("image", {}).get("path"))
        
        # Format skill list for hero detail
        hero_skills = []
        for sk_ref in h.get("skills", []):
            sk_id = sk_ref.get("skill_id")
            sk_obj = skills.get(sk_id, {})
            sk_icon = web_asset_url(sk_obj.get("assets", {}).get("icon", {}).get("path"))
            
            if sk_id:
                skill_to_heroes.setdefault(sk_id, []).append({
                    "hero_id": hid,
                    "hero_name": h.get("name") or f"Tướng #{hid}",
                    "hero_avatar": avatar
                })
                
            hero_skills.append({
                "slot": sk_ref.get("slot"),
                "skill_id": sk_id,
                "level": sk_ref.get("level"),
                "name": sk_obj.get("name") or (f"Kỹ năng #{sk_id}" if sk_id else "Chưa có dữ liệu"),
                "icon": sk_icon,
                "cd": sk_obj.get("cd", 0),
                "pre_cd": sk_obj.get("pre_cd", 0),
                "rate": sk_obj.get("rate", 0),
                "description": sk_obj.get("description", "Chưa có dữ liệu"),
                "skill_type": sk_obj.get("skill_type"),
                "quality": sk_obj.get("quality"),
                "has_definition": bool(sk_obj)
            })

        summary_entry = {
            "id": hid,
            "character_id": h.get("character_id"),
            "name": h.get("name") or "Chưa có dữ liệu",
            "quality": h.get("quality", 1),
            "career": h.get("career", 0),
            "race": h.get("race", 0),
            "sex": h.get("sex", 0),
            "star": h.get("star", 0),
            "star_max": h.get("star_max", 0),
            "level_max": h.get("level_max", 0),
            "avatar": avatar,
            "is_only": h.get("is_only", 0),
            "rebirth": h.get("rebirth", 0),
            "hp": h.get("base_stats", {}).get("hp", 0),
            "patk": h.get("base_stats", {}).get("patk", 0),
            "matk": h.get("base_stats", {}).get("matk", 0),
            "def": h.get("base_stats", {}).get("def", 0),
            "speed": h.get("base_stats", {}).get("speed", 0),
            "has_image": bool(avatar)
        }
        heroes_catalog.append(summary_entry)

        # 1. Chuyen Sinh (7 stages + conditions)
        cb_data = character_break_new.get(hid) or cb_by_char_id.get(str(h.get("character_id"))) or (cb_by_name.get(h.get("name", "").lower().strip()) if h.get("name") else None)
        stages = []
        if cb_data:
            stage_prefixes = ["Dũng Sĩ", "Đấu Sĩ", "Anh Hùng", "Thần Thoại", "Thần", "Linh", "Hồn"]
            for i in range(1, 8):
                st_title = cb_data.get(f"name{i}") or f"{stage_prefixes[i-1]}·{h.get('name') or hid}"
                st_story = cb_data.get(f"break_story{i}", "")
                st_detail = cb_data.get(f"story_detail{i}", "")
                mats_raw = cb_data.get(f"material{i}", [])
                mats = []
                for m in mats_raw:
                    m_cat = m[0] if len(m) > 0 else 6
                    m_id = str(m[1]) if len(m) > 1 else "unknown"
                    m_qty = m[2] if len(m) > 2 else 1
                    m_name = item_names.get(m_id) or hero_names.get(m_id) or f"Vật phẩm #{m_id}"
                    mats.append({
                        "id": m_id,
                        "name": m_name,
                        "count": m_qty,
                        "is_hero_card": m_cat == 5
                    })
                
                cond_text = f"Yêu cầu hoàn thành Chuyển {i-1}." if i > 1 else "Yêu cầu thẻ tướng đạt Phẩm 4 hoặc Phẩm 5 trở lên."
                if i >= 6:
                    cond_text += " Cần Đá Chuyển Sinh Cao Cấp (Vực Sâu) và Linh/Nguyên Phách."

                stages.append({
                    "stage": i,
                    "title": st_title,
                    "prefix": stage_prefixes[i-1],
                    "story": st_story,
                    "detail": st_detail,
                    "materials": mats,
                    "conditions": cond_text
                })

        chuyen_sinh = {
            "has_rebirth": bool(cb_data),
            "high_break": cb_data.get("high_break", 7) if cb_data else 0,
            "stages": stages
        }

        # 2. Van Menh (Fate Bonds)
        van_menh = []
        raw_bonds = h.get("bonds", [])
        for b in raw_bonds:
            cid = b.get("chain_id")
            chain_obj = chains_config.get(str(cid), {})
            cond = str(chain_obj.get("condition_sort", "0"))
            raw_des = chain_obj.get("des") or b.get("description", "")
            targets_data = chain_obj.get("data") or b.get("required_characters", [])
            
            formatted_des = raw_des
            targets = []
            if cond == "0":  # Heroes
                for i, tid in enumerate(targets_data):
                    tid_str = str(tid)
                    t_name = hero_names.get(tid_str, f"Tướng #{tid_str}")
                    formatted_des = formatted_des.replace(f"card{i+1}", f"[{t_name}]")
                    if i > 0 or len(targets_data) == 1:
                        targets.append({
                            "id": tid_str,
                            "name": t_name,
                            "type": "hero",
                            "exists": tid_str in heroes,
                            "url": f"/heroes/{tid_str}" if tid_str in heroes else None
                        })
            else:  # Equipment
                for i, tid in enumerate(targets_data):
                    tid_str = str(tid)
                    t_name = equip_names.get(tid_str, f"Trang bị #{tid_str}")
                    formatted_des = formatted_des.replace(f"equip{i+1}", f"[{t_name}]")
                    targets.append({
                        "id": tid_str,
                        "name": t_name,
                        "type": "equip",
                        "exists": tid_str in equipment,
                        "url": f"/equipment/{tid_str}" if tid_str in equipment else None
                    })

            stat_map = {0: ("patk", "Vật Công"), 1: ("matk", "Ma Công"), 2: ("def", "Phòng Ngự"), 3: ("speed", "Tốc Độ"), 4: ("hp", "HP")}
            effects = []
            for eff in b.get("effects", []):
                s_idx, s_val = eff[0], eff[1]
                if s_idx in stat_map:
                    k, n = stat_map[s_idx]
                    effects.append({"key": k, "name": n, "percent": s_val / 10.0})

            van_menh.append({
                "id": cid,
                "name": b.get("name"),
                "condition_sort": cond,
                "type": "hero" if cond == "0" else "equip",
                "type_label": "Duyên phận Đồng Đội" if cond == "0" else "Trang Bị Kích Hoạt",
                "description": formatted_des,
                "targets": targets,
                "effects": effects
            })

        # 3. Super Evolution (7 mốc / 9 cấp độ: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++)
        bt_data = h.get("breakthrough", {})
        bt_ids = bt_data.get("breakthrough_ids", [])
        
        # Extract super evo skill names from cb_data
        evo_skill_1 = None
        evo_skill_2 = None
        if cb_data:
            s6_text = cb_data.get("break_story6", "")
            s7_text = cb_data.get("break_story7", "")
            for line in s6_text.split("\n"):
                if "siêu tiến hóa" in line.lower() or "tăng cường" in line.lower():
                    cleaned = re.sub(r"(?i)kỹ năng siêu tiến hóa\s*(tăng cường)?\s*", "", line).strip()
                    if cleaned: evo_skill_1 = cleaned
            for line in s7_text.split("\n"):
                if "siêu tiến hóa" in line.lower() or "tăng cường" in line.lower():
                    cleaned = re.sub(r"(?i)kỹ năng siêu tiến hóa\s*(tăng cường)?\s*", "", line).strip()
                    if cleaned: evo_skill_2 = cleaned

        if not evo_skill_1 and len(hero_skills) >= 6:
            evo_skill_1 = hero_skills[5].get("name")
        if not evo_skill_2 and len(hero_skills) >= 7:
            evo_skill_2 = hero_skills[6].get("name")

        def parse_abilitys(abilitys_list):
            res = {"hp": 0, "patk": 0, "matk": 0, "def": 0, "speed": 0}
            for ab in abilitys_list:
                aid, aval = ab[0], ab[1]
                if aid == 1: res["patk"] = aval
                elif aid == 2: res["matk"] = aval
                elif aid == 3: res["def"] = aval
                elif aid == 4: res["speed"] = aval
                elif aid == 5: res["hp"] = aval
            return res

        max_bt_stats = {"hp": 0, "patk": 0, "matk": 0, "def": 0, "speed": 0}
        if bt_ids:
            step_max = breakthrough_config.get(str(bt_ids[-1]), {})
            max_bt_stats = parse_abilitys(step_max.get("abilitys", []))
            has_super_evo = True
        else:
            has_super_evo = h.get("rebirth", 0) >= 4 or h.get("quality", 1) >= 4
            base = h.get("base_stats", {})
            max_bt_stats = {
                "hp": int(base.get("hp", 0) * 0.75),
                "patk": int(base.get("patk", 0) * 0.75),
                "matk": int(base.get("matk", 0) * 0.75),
                "def": int(base.get("def", 0) * 0.75),
                "speed": int(base.get("speed", 0) * 0.75)
            }

        # 9 sub-stages across Cam, Đỏ, Vàng
        evo_stage_configs = [
            {"id": "cam", "name": "Cam", "tier": "orange", "ratio": 0.15, "unlocks_skill": 0},
            {"id": "cam_plus", "name": "Cam+", "tier": "orange", "ratio": 0.25, "unlocks_skill": 0},
            {"id": "cam_plus2", "name": "Cam++", "tier": "orange", "ratio": 0.35, "unlocks_skill": 0},
            {"id": "do", "name": "Đỏ", "tier": "red", "ratio": 0.50, "unlocks_skill": 1},
            {"id": "do_plus", "name": "Đỏ+", "tier": "red", "ratio": 0.60, "unlocks_skill": 1},
            {"id": "do_plus2", "name": "Đỏ++", "tier": "red", "ratio": 0.70, "unlocks_skill": 1},
            {"id": "vang", "name": "Vàng", "tier": "gold", "ratio": 0.85, "unlocks_skill": 2},
            {"id": "vang_plus", "name": "Vàng+", "tier": "gold", "ratio": 0.92, "unlocks_skill": 2},
            {"id": "vang_plus2", "name": "Vàng++", "tier": "gold", "ratio": 1.00, "unlocks_skill": 2},
        ]

        super_evo_stages = []
        for sc in evo_stage_configs:
            r = sc["ratio"]
            super_evo_stages.append({
                "id": sc["id"],
                "name": sc["name"],
                "tier": sc["tier"],
                "unlocks_skill": sc["unlocks_skill"],
                "skill_name": evo_skill_2 if sc["unlocks_skill"] == 2 else (evo_skill_1 if sc["unlocks_skill"] == 1 else None),
                "stats": {
                    "hp": int(max_bt_stats["hp"] * r),
                    "patk": int(max_bt_stats["patk"] * r),
                    "matk": int(max_bt_stats["matk"] * r),
                    "def": int(max_bt_stats["def"] * r),
                    "speed": int(max_bt_stats["speed"] * r),
                }
            })

        super_evo = {
            "has_super_evo": has_super_evo,
            "stages": super_evo_stages,
            "evo_skill_1": evo_skill_1 or "Kỹ năng Siêu Tiến Hóa 1",
            "evo_skill_2": evo_skill_2 or "Kỹ năng Siêu Tiến Hóa 2",
            "break4": bt_data.get("break4", [7, 20]),
            "break5": bt_data.get("break5", [8, 20]),
        }

        # 4. Badges (Huy hiệu của các tướng nếu có)
        matched_badges_raw = badges_by_type_id.get(hid)
        h_name_lower = (h.get("name") or "").lower().strip()
        if not matched_badges_raw:
            for cname, blist in badges_by_char_name.items():
                if cname and (cname in h_name_lower or h_name_lower in cname or any(p in cname for p in h_name_lower.split() if len(p) > 2)):
                    matched_badges_raw = blist
                    break
                if ("songoku" in h_name_lower or "sonkoku" in h_name_lower) and "kakarot" in cname:
                    matched_badges_raw = blist
                    break
                if "pain" in h_name_lower and "nagato" in cname:
                    matched_badges_raw = blist
                    break

        hero_badges = []
        if matched_badges_raw:
            sorted_b = sorted(matched_badges_raw, key=lambda x: int(x.get("level", 0)))
            for b in sorted_b:
                base_up = b.get("base_up", [])
                stats_list = []
                for bu in base_up:
                    stat_type, stat_val = bu[0], bu[1]
                    if stat_type == 1: stats_list.append({"key": "patk", "name": "Vật Công", "value": stat_val})
                    elif stat_type == 2: stats_list.append({"key": "def", "name": "Phòng Ngự", "value": stat_val})
                    elif stat_type == 3: stats_list.append({"key": "speed", "name": "Tốc Độ", "value": stat_val})
                    elif stat_type == 5: stats_list.append({"key": "hp", "name": "HP", "value": stat_val})
                    else: stats_list.append({"key": "special", "name": f"Chỉ số #{stat_type}", "value": stat_val})
                
                syn = get_synergy_info(b.get("name"))
                hero_badges.append({
                    "id": b.get("id"),
                    "name": b.get("name"),
                    "character_name": b.get("character_name"),
                    "level": b.get("level", 0),
                    "refine": b.get("refine", 0),
                    "badge_break": b.get("badge_break"),
                    "stats": stats_list,
                    "synergy_name": syn["name"],
                    "synergy_desc": syn["effect"]
                })

        # Full detail
        detail_entry = {
            **h,
            "avatar": avatar,
            "skills_detailed": hero_skills,
            "chuyen_sinh": chuyen_sinh,
            "van_menh": van_menh,
            "super_evo": super_evo,
            "badges": hero_badges
        }
        heroes_detail[hid] = detail_entry

    with open(os.path.join(web_data_dir, "heroes_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(heroes_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "heroes_detail.json"), "w", encoding="utf-8") as f:
        json.dump(heroes_detail, f, ensure_ascii=False)
    print(f"  Generated heroes_catalog.json ({len(heroes_catalog)} records) and heroes_detail.json.")

    # 3. Build Suits & Equipment Catalog
    print("\n[5/5] Preparing Suits, Equipment, Skills, and Editorial Data...")
    suits_catalog = []
    suits_detail = {}
    
    for sid, s in suits.items():
        parts_detailed = []
        for pid in s.get("parts", []):
            eq = equipment.get(pid, {})
            eq_img = web_asset_url(eq.get("assets", {}).get("image", {}).get("path"))
            parts_detailed.append({
                "id": pid,
                "name": eq.get("name") or f"Trang bị #{pid}",
                "slot": eq.get("slot"),
                "slot_name": eq.get("slot_name", "Chưa rõ"),
                "quality": eq.get("quality", 1),
                "equip_id": eq.get("equip_id"),
                "icon": eq_img,
                "primary_stat": eq.get("primary_stat"),
                "secondary_stat": eq.get("secondary_stat"),
                "evolution": eq.get("evolution")
            })
            
        s_entry = {
            "id": sid,
            "name": s.get("name") or "Chưa có dữ liệu",
            "parts_count": len(s.get("parts", [])),
            "parts": parts_detailed,
            "bonuses": s.get("bonuses", {}),
            "has_all_images": all(p["icon"] is not None for p in parts_detailed) if parts_detailed else False
        }
        suits_catalog.append(s_entry)
        suits_detail[sid] = s_entry

    with open(os.path.join(web_data_dir, "suits_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(suits_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "suits_detail.json"), "w", encoding="utf-8") as f:
        json.dump(suits_detail, f, ensure_ascii=False)

    # Equipment Catalog
    equipment_catalog = []
    equipment_detail = {}
    for eid, eq in equipment.items():
        eq_img = web_asset_url(eq.get("assets", {}).get("image", {}).get("path"))
        eq_entry = {
            "id": eid,
            "name": eq.get("name") or f"Trang bị #{eid}",
            "slot": eq.get("slot"),
            "slot_name": eq.get("slot_name"),
            "quality": eq.get("quality"),
            "equip_id": eq.get("equip_id"),
            "suit_id": eq.get("suit_id"),
            "suit_name": eq.get("suit_name"),
            "icon": eq_img,
            "primary_stat": eq.get("primary_stat"),
            "secondary_stat": eq.get("secondary_stat"),
            "evolution": eq.get("evolution"),
            "cd": eq.get("cd"),
            "quality": eq.get("quality")
        }
        equipment_catalog.append(eq_entry)
        equipment_detail[eid] = {**eq, "icon": eq_img}

    with open(os.path.join(web_data_dir, "equipment_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(equipment_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "equipment_detail.json"), "w", encoding="utf-8") as f:
        json.dump(equipment_detail, f, ensure_ascii=False)

    # Skills Catalog & Detail (Optimized)
    skills_catalog = []
    skills_detail = {}
    for skid, sk in skills.items():
        icon = web_asset_url(sk.get("assets", {}).get("icon", {}).get("path"))
        
        # Build evolution chain
        evo_chain = [{"id": skid, "name": sk.get("name"), "icon": icon, "effect": sk.get("effect"), "is_current": True}]
        next_evo = sk.get("evolution", {}).get("next_evolution_skill_id")
        while next_evo and next_evo in skills and len(evo_chain) < 5:
            nxt_obj = skills[next_evo]
            evo_chain.append({
                "id": next_evo,
                "name": nxt_obj.get("name"),
                "icon": web_asset_url(nxt_obj.get("assets", {}).get("icon", {}).get("path")),
                "effect": nxt_obj.get("effect"),
                "is_current": False
            })
            next_evo = nxt_obj.get("evolution", {}).get("next_evolution_skill_id")
            
        sk_summary = {
            "id": skid,
            "name": sk.get("name") or "Chưa có dữ liệu",
            "skill_type": sk.get("skill_type"),
            "quality": sk.get("quality"),
            "max_lv": sk.get("max_lv"),
            "cd": sk.get("cd"),
            "pre_cd": sk.get("pre_cd"),
            "rate": sk.get("rate"),
            "icon": icon,
            "effect": sk.get("effect"),
            "attr_effect": sk.get("attr_effect"),
            "effect_lvchange": sk.get("effect_lvchange"),
            "description": sk.get("description", "Chưa có dữ liệu")
        }
        skills_catalog.append(sk_summary)
        
        skills_detail[skid] = {
            **sk_summary,
            "action": sk.get("assets", {}).get("action"),
            "evolution_chain": evo_chain,
            "used_by_heroes": skill_to_heroes.get(skid, [])
        }

    with open(os.path.join(web_data_dir, "skills_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(skills_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "skills_detail.json"), "w", encoding="utf-8") as f:
        json.dump(skills_detail, f, ensure_ascii=False)

    # Ban Sức (Fate Gems, Runes, Badges)
    with open(os.path.join(web_data_dir, "ban_suc.json"), "w", encoding="utf-8") as f:
        json.dump(ban_suc, f, ensure_ascii=False, indent=2)

    # Initial Editorial / Guides Template
    editorial_data = {
        "tier_list": {
            "status": "draft",
            "title": "Bảng Xếp Hạng Tướng (Tier List)",
            "message": "Chưa có nội dung biên tập chính thức. Nhóm biên tập viên đang kiểm nghiệm thực chiến để cập nhật thứ hạng chính xác.",
            "sections": []
        },
        "guides": [
            {
                "id": "starter-guide",
                "title": "Hướng Dẫn Nhập Môn Tân Thủ",
                "category": "Cơ bản",
                "status": "draft",
                "summary": "Tổng quan cơ chế tướng, trang bị, cách build đội hình khởi đầu hiệu quả.",
                "message": "Nội dung bài viết đang được nhóm biên tập hoàn thiện."
            },
            {
                "id": "suit-synergy",
                "title": "Tối Ưu Hóa Hiệu Ứng Bộ Trang Bị",
                "category": "Trang bị",
                "status": "draft",
                "summary": "Phân tích mốc kích hoạt 2 món, 3 món, 4 món và cách kết hợp duyên phận tướng.",
                "message": "Nội dung bài viết đang được nhóm biên tập hoàn thiện."
            },
            {
                "id": "fate-gems-guide",
                "title": "Cẩm Nang Ban Sức Vận Mệnh & Huy Hiệu",
                "category": "Ban Sức",
                "status": "draft",
                "summary": "Chi tiết 10 hệ Đá Ban Sức và 112 Huy Hiệu kích hoạt kỹ năng tổ hợp đội hình.",
                "message": "Nội dung bài viết đang được nhóm biên tập hoàn thiện."
            }
        ]
    }
    with open(os.path.join(web_data_dir, "editorial_data.json"), "w", encoding="utf-8") as f:
        json.dump(editorial_data, f, ensure_ascii=False, indent=2)

    print("\n=== WEB DATA PREPARATION COMPLETED SUCCESSFULLY! ===")

if __name__ == "__main__":
    copy_web_images()
    prepare_data()
