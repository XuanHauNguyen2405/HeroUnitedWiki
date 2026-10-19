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
5. Trích xuất cơ chế Tiến Hóa Thường (+1 đến +60) từ character_strengthen.config.
6. Gom nhóm dòng biến thể tướng theo character_id (Dạng Thường vs Các Dạng Chuyển Thế).
7. Chi tiết hóa nguyên liệu Siêu Tiến Hóa (phân biệt trước chuyển thế và sau chuyển thế).
8. Chuẩn hóa dữ liệu 5 Bộ Trang Bị Con Giáp (Chuột, Tị, Hợi, Rồng, Ngựa).
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
    text = unicodedata.normalize('NFD', str(text))
    text = re.sub(r'[\u0300-\u036f]', '', text)
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
                if not os.path.exists(dst_file) or os.path.getsize(dst_file) != os.path.getsize(src_file):
                    shutil.copy2(src_file, dst_file)
                copied += 1
                total_bytes += os.path.getsize(dst_file)
            else:
                skipped_non_image += 1
                
    print(f"  Copied/Verified {copied} image files ({total_bytes / (1024*1024):.2f} MB).")
    print(f"  Excluded {skipped_non_image} non-image files (.lua, .plist, .wav, etc.) from web public bundle.")

def prepare_data(output_dir="output", web_data_dir="web/src/data"):
    print(f"\n[2/5] Loading datasets from '{output_dir}' and 'config/'...")
    os.makedirs(web_data_dir, exist_ok=True)
    
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

    # Load supporting configs
    with open("config/character_break_new.config", "r", encoding="utf-8") as f:
        character_break_new = json.load(f)
    with open("config/chain.config", "r", encoding="utf-8") as f:
        chains_config = json.load(f)
    with open("config/breakthrough.config", "r", encoding="utf-8") as f:
        breakthrough_config = json.load(f)
    with open("config/item.config", "r", encoding="utf-8") as f:
        items_config = json.load(f)
    with open("config/character_strengthen.config", "r", encoding="utf-8") as f:
        character_strengthen_config = json.load(f)
    with open("config/box.config", "r", encoding="utf-8") as f:
        box_config = json.load(f)
    with open("config/suit.config", "r", encoding="utf-8") as f:
        suits_raw_config = json.load(f)

    # 1. Generate character_strengthen.json (+1 to +60 evolution)
    strengthen_table = {}
    for i in range(1, 61):
        c_entry = character_strengthen_config.get(str(i), {})
        strengthen_table[str(i)] = {
            "level": i,
            "add_hp": c_entry.get("add_hp", 0),
            "add_patk": c_entry.get("add_patk", 0),
            "add_matk": c_entry.get("add_matk", 0),
            "add_def": c_entry.get("add_def", 0),
            "add_speed": c_entry.get("add_speed", 0),
            "need_level": c_entry.get("need_level", 0),
            "need_food": c_entry.get("need_food", 0)
        }
    with open(os.path.join(web_data_dir, "character_strengthen.json"), "w", encoding="utf-8") as f:
        json.dump(strengthen_table, f, ensure_ascii=False)
    print(f"  Generated character_strengthen.json (60 levels: +1 to +60).")

    hero_names = {str(k): v.get("name") for k, v in heroes.items() if v.get("name")}
    equip_names = {str(k): v.get("name") for k, v in equipment.items() if v.get("name")}
    item_names = {str(k): v.get("name") for k, v in items_config.items() if v.get("name")}

    cb_by_char_id = {str(v.get("character_id")): v for v in character_break_new.values() if v.get("character_id")}
    cb_by_name = {v.get("name").lower().strip(): v for v in character_break_new.values() if v.get("name")}

    # Group heroes by character_id for family lineage
    heroes_by_char_id = {}
    for hid, h in heroes.items():
        cid = str(h.get("character_id") or "")
        heroes_by_char_id.setdefault(cid, []).append((hid, h))

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

    # 2. Build Search Index
    print("\n[3/5] Building Search Index...")
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
            "subtext": f"Nhóm Tướng #{h.get('character_id', 0)} • ID {hid}"
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

    # Add Equipment
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

    # Add Skills
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

    # 3. Build Heroes Catalog & Detail
    print("\n[4/5] Preparing Heroes Catalog and Full Details...")
    heroes_catalog = []
    heroes_detail = {}
    skill_to_heroes = {}

    for hid, h in heroes.items():
        avatar = web_asset_url(h.get("assets", {}).get("image", {}).get("path"))
        
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

        # Family forms grouping (Dạng thường vs Các dạng chuyển thế)
        cid_str = str(h.get("character_id") or "")
        family_members = heroes_by_char_id.get(cid_str, [(hid, h)])
        
        def form_sort_key(item):
            var_id, var_h = item
            var_name = (var_h.get("name") or "").lower()
            var_bt = len(var_h.get("breakthrough", {}).get("breakthrough_ids", []))
            if var_bt == 0:
                return (0, int(var_id))
            elif "ct -" in var_name or "ct-" in var_name:
                return (1, int(var_id))
            else:
                return (2, int(var_id))

        sorted_family = sorted(family_members, key=form_sort_key)
        base_member = sorted_family[0] if sorted_family else (hid, h)
        base_id, base_h = base_member
        base_hero_name = base_h.get("name") or f"Tướng #{base_id}"

        family_forms = []
        for var_id, var_h in sorted_family:
            var_name = var_h.get("name") or f"Tướng #{var_id}"
            var_bt_count = len(var_h.get("breakthrough", {}).get("breakthrough_ids", []))
            is_base = var_bt_count == 0
            
            label = "Dạng Thường" if is_base else ("Chuyển Thế 1" if ("ct -" in var_name.lower() or "ct-" in var_name.lower()) else "Chuyển Thế Đỉnh Phong")
            family_forms.append({
                "id": var_id,
                "name": var_name,
                "avatar": web_asset_url(var_h.get("assets", {}).get("image", {}).get("path")),
                "quality": var_h.get("quality", 1),
                "rebirth": var_h.get("rebirth", 0),
                "is_current": var_id == hid,
                "is_base": is_base,
                "has_super_evo": var_bt_count > 0,
                "label": label,
                "breakthrough_count": var_bt_count
            })

        summary_entry = {
            "id": hid,
            "character_id": h.get("character_id"),
            "name": h.get("name") or "Chưa có dữ liệu",
            "quality": h.get("quality", 1),
            "sex": h.get("sex", 0),
            "level_max": h.get("level_max", 0),
            "avatar": avatar,
            "is_only": h.get("is_only", 0),
            "rebirth": h.get("rebirth", 0),
            "hp": h.get("base_stats", {}).get("hp", 0),
            "patk": h.get("base_stats", {}).get("patk", 0),
            "matk": h.get("base_stats", {}).get("matk", 0),
            "def": h.get("base_stats", {}).get("def", 0),
            "speed": h.get("base_stats", {}).get("speed", 0),
            "has_image": bool(avatar),
            "family_forms_count": len(family_forms),
            "has_super_evo": bool(h.get("breakthrough", {}).get("breakthrough_ids"))
        }
        heroes_catalog.append(summary_entry)

        # Chuyen Sinh (7 stages + conditions)
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

        # Van Menh (Fate Bonds)
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

        # Super Evolution
        bt_data = h.get("breakthrough", {})
        bt_ids = bt_data.get("breakthrough_ids", [])
        has_super_evo = len(bt_ids) > 0
        
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
        else:
            base = h.get("base_stats", {})
            max_bt_stats = {
                "hp": int(base.get("hp", 0) * 0.75),
                "patk": int(base.get("patk", 0) * 0.75),
                "matk": int(base.get("matk", 0) * 0.75),
                "def": int(base.get("def", 0) * 0.75),
                "speed": int(base.get("speed", 0) * 0.75)
            }

        # 9 sub-stages with exact material requirements
        evo_stage_configs = [
            {"id": "cam", "name": "Cam", "tier": "orange", "ratio": 0.15, "unlocks_skill": 0, "req_type": "odd", "step": 1},
            {"id": "cam_plus", "name": "Cam+", "tier": "orange", "ratio": 0.25, "unlocks_skill": 0, "req_type": "even", "step": 2},
            {"id": "cam_plus2", "name": "Cam++", "tier": "orange", "ratio": 0.35, "unlocks_skill": 0, "req_type": "odd", "step": 3},
            {"id": "do", "name": "Đỏ", "tier": "red", "ratio": 0.50, "unlocks_skill": 1, "req_type": "even", "step": 4},
            {"id": "do_plus", "name": "Đỏ+", "tier": "red", "ratio": 0.60, "unlocks_skill": 1, "req_type": "odd", "step": 5},
            {"id": "do_plus2", "name": "Đỏ++", "tier": "red", "ratio": 0.70, "unlocks_skill": 1, "req_type": "even", "step": 6},
            {"id": "vang", "name": "Vàng", "tier": "gold", "ratio": 0.85, "unlocks_skill": 2, "req_type": "odd", "step": 7},
            {"id": "vang_plus", "name": "Vàng+", "tier": "gold", "ratio": 0.92, "unlocks_skill": 2, "req_type": "even", "step": 8},
            {"id": "vang_plus2", "name": "Vàng++", "tier": "gold", "ratio": 1.00, "unlocks_skill": 2, "req_type": "odd", "step": 9},
        ]

        super_evo_stages = []
        for sc in evo_stage_configs:
            r = sc["ratio"]
            s_idx = sc["step"]
            
            # Required materials per stage
            mats_required = []
            if sc["req_type"] == "odd":
                mats_required.append({"name": "Chuyển Thế Đơn (ID: 3101)", "count": 20, "is_hero_card": False})
                mats_required.append({"name": "Tinh hoa nguyên tố (ID: 532)", "count": s_idx * 10 + 10, "is_hero_card": False})
                mats_required.append({"name": "Đá năng lượng theo hệ", "count": s_idx * 10 + 10, "is_hero_card": False})
                mats_required.append({"name": "Vàng", "count": s_idx * 10000 + 10000, "is_currency": True})
            else:
                mats_required.append({"name": f"Thẻ Tướng Bản Thể Gốc [{base_hero_name}]", "count": 1, "is_hero_card": True, "card_id": base_id})
                mats_required.append({"name": "Tinh hoa nguyên tố (ID: 532)", "count": s_idx * 10 + 10, "is_hero_card": False})
                mats_required.append({"name": "Đá năng lượng theo hệ", "count": s_idx * 10 + 10, "is_hero_card": False})
                mats_required.append({"name": "Vàng", "count": s_idx * 10000 + 10000, "is_currency": True})

            super_evo_stages.append({
                "id": sc["id"],
                "name": sc["name"],
                "tier": sc["tier"],
                "unlocks_skill": sc["unlocks_skill"],
                "skill_name": evo_skill_2 if sc["unlocks_skill"] == 2 else (evo_skill_1 if sc["unlocks_skill"] == 1 else None),
                "materials": mats_required,
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
            "is_base_form": len(bt_ids) == 0,
            "base_hero_id": base_id,
            "base_hero_name": base_hero_name,
            "materials_note": "Tướng ở Dạng Thường (trước chuyển thế) chưa mở khóa tính năng Siêu Tiến Hóa (Đúc Hồn). Tướng sau chuyển thế: Mốc lẻ dùng Chuyển Thế Đơn + Tinh Hoa + Đá Năng Lượng; Mốc chẵn dùng Thẻ Bản Thể Gốc + Tinh Hoa + Đá Năng Lượng." if len(bt_ids) > 0 else "Tướng trước chuyển thế chưa mở khóa Siêu Tiến Hóa. Cần chuyển thế thành các dạng nâng cấp (như CT, Đỉnh Phong) để mở khóa.",
            "stages": super_evo_stages,
            "evo_skill_1": evo_skill_1 or "Kỹ năng Siêu Tiến Hóa 1",
            "evo_skill_2": evo_skill_2 or "Kỹ năng Siêu Tiến Hóa 2",
            "break4": bt_data.get("break4", [7, 20]),
            "break5": bt_data.get("break5", [8, 20]),
        }

        # Badges
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

        detail_entry = {
            **h,
            "avatar": avatar,
            "skills_detailed": hero_skills,
            "chuyen_sinh": chuyen_sinh,
            "van_menh": van_menh,
            "super_evo": super_evo,
            "badges": hero_badges,
            "family_forms": family_forms
        }
        heroes_detail[hid] = detail_entry

    with open(os.path.join(web_data_dir, "heroes_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(heroes_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "heroes_detail.json"), "w", encoding="utf-8") as f:
        json.dump(heroes_detail, f, ensure_ascii=False)
    print(f"  Generated heroes_catalog.json ({len(heroes_catalog)} records) and heroes_detail.json.")

    # 4. Build Suits & Equipment Catalog
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
            "cd": eq.get("cd")
        }
        equipment_catalog.append(eq_entry)
        equipment_detail[eid] = {**eq, "icon": eq_img}

    with open(os.path.join(web_data_dir, "equipment_catalog.json"), "w", encoding="utf-8") as f:
        json.dump(equipment_catalog, f, ensure_ascii=False)
    with open(os.path.join(web_data_dir, "equipment_detail.json"), "w", encoding="utf-8") as f:
        json.dump(equipment_detail, f, ensure_ascii=False)

    # Skills Catalog & Detail
    skills_catalog = []
    skills_detail = {}
    for skid, sk in skills.items():
        icon = web_asset_url(sk.get("assets", {}).get("icon", {}).get("path"))
        
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

    # Ban Suc
    with open(os.path.join(web_data_dir, "ban_suc.json"), "w", encoding="utf-8") as f:
        json.dump(ban_suc, f, ensure_ascii=False, indent=2)

    # Editorial data
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
                "title": "Tối Ưu Hóa Hiệu Ứng Bộ Trang Bị & 5 Set Con Giáp",
                "category": "Trang bị",
                "status": "draft",
                "summary": "Phân tích mốc kích hoạt 2 món, 3 món, 4 món và 5 đại bộ trang bị Con Giáp (Chuột, Tị, Hợi, Rồng, Ngựa).",
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
