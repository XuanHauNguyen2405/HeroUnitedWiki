# tools/build_zodiac_data.py
import json

with open('config/box.config', 'r', encoding='utf-8') as f:
    box = json.load(f)

with open('output/equipment.json', 'r', encoding='utf-8') as f:
    equips = json.load(f)
if isinstance(equips, dict): equips = list(equips.values())
eq_map = {str(e.get('id')): e for e in equips}

with open('output/equipment_sets.json', 'r', encoding='utf-8') as f:
    suits = json.load(f)
if isinstance(suits, dict): suits = list(suits.values())
suit_map = {str(s.get('id')): s for s in suits}

with open('config/suit.config', 'r', encoding='utf-8') as f:
    suits_config = json.load(f)

def clean_equip_name(name, default_name=""):
    if not name or name == "#N/A":
        return default_name
    clean = name
    for prefix in [
        "Trường Sinh.", "Kiếp Tiên.", "Khung Thần.", "Khung Địa.", "Khung Địa.",
        "Thương Thần.", "Thương Địa.", "Thương Địa.", "Thương.", "Khung.",
        "Hung Thú - ", "Tiên Linh - ", "Hung Thú:", "Tiên Linh:", "Hung Thú", "Tiên Linh",
        "Tứ Cực - ", "Hóa Long Thần - ", "Tứ Cực.", "Hóa Long Thần."
    ]:
        clean = clean.replace(prefix, "")
    for el in ["Địa.", "Hỏa.", "Thủy.", "Phong.", "Địa - ", "Hỏa - ", "Thủy - ", "Phong - ", "Địa: ", "Hỏa: ", "Thủy: ", "Phong: "]:
        clean = clean.replace(el, "")
    clean = clean.strip(". -:")
    return clean or default_name

# ORDER: Hợi -> Chuột -> Rồng -> Tị -> Ngựa (Requirement 3: Swapped Hợi and Chuột)
zodiac_definitions = [
    {
        "id": "hoi",
        "name": "Bộ Năm Hợi",
        "animal": "Hợi",
        "icon": "🐗",
        "theme": "Công Thủ Toàn Diện & HP Tối Thượng",
        "nature": "Thiên hướng Công Thủ Toàn Diện, Sinh Tồn Bền Bỉ & Cường Hóa Trực Tiếp HP",
        "description": "Bộ trang bị thần thánh hoàng đạo Năm Hợi (Thiên Vấn, Giáp Thần Võ, Phiên Thiên Ấn, Giày Ảo Ảnh), cân bằng toàn diện công thủ và lượng máu dồi dào.",
        "special_attributes": {
            "title": "Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (Bộ Hợi)",
            "normal_highlights": [
                "⚔️ Vũ khí (Thiên Vấn): Tăng +50% Tấn công toàn thuộc tính khi vào chiến đấu",
                "🛡️ Áo giáp (Giáp Thần Võ): Tăng +150% Phòng ngự toàn thuộc tính khi vào chiến đấu",
                "🎯 Trang sức (Phiên Thiên Ấn): Tăng +220% Chính xác bản thân khi vào chiến đấu",
                "💨 Giày (Giày Ảo Ảnh): Tăng +220% Né tránh bản thân khi vào chiến đấu"
            ],
            "rainbow_highlights": [
                "⚔️ Vũ khí Cầu Vồng: Tăng +100% Tấn công toàn thuộc tính (Gấp 2 lần)",
                "🛡️ Áo giáp Cầu Vồng: Tăng +300% Phòng ngự toàn thuộc tính (Gấp 2 lần)",
                "🎯 Trang sức Cầu Vồng: Tăng +450% Chính xác bản thân (Gấp hơn 2 lần)",
                "💨 Giày Cầu Vồng: Tăng +450% Né tránh bản thân (Gấp hơn 2 lần)"
            ]
        },
        "best_heroes": [
            {"name": "Bikini - Frieren", "reason": "Cân bằng sinh tồn tuyệt đối trong giao tranh kéo dài và buff ma pháp liên tục."},
            {"name": "Maple", "reason": "Biến Maple thành pháo đài bất tử không thể bị xuyên thủng với lượng HP và thủ khổng lồ."},
            {"name": "Jiraiya", "reason": "Cung cấp lượng máu dồi dào và chống chịu cho Tiên Nhân thuật."},
            {"name": "Athena", "reason": "Gia tăng độ trâu bò và cường hóa hiệu ứng hỗ trợ đồng đội."}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "91076", "suit_id": "652", "rainbow_suit_id": "752"},
            {"element": "Thủy (Nước)", "box_id": "91077", "suit_id": "654", "rainbow_suit_id": "754"},
            {"element": "Hỏa (Lửa)", "box_id": "91078", "suit_id": "653", "rainbow_suit_id": "753"},
            {"element": "Phong (Gió)", "box_id": "91079", "suit_id": "655", "rainbow_suit_id": "755"}
        ]
    },
    {
        "id": "chuot",
        "name": "Bộ Năm Chuột",
        "animal": "Chuột",
        "icon": "🐭",
        "theme": "Bạo Kích Cực Hạn & Đột Kích",
        "nature": "Thiên hướng Bạo Kích Cực Hạn, Sát Thương Đột Phá & Đột Kích Chí Mạng",
        "description": "Bộ trang bị thần thoại giới hạn Năm Chuột (Kiếm Trảm Yêu, Ngạo Long Giáp, Trấn Ma Thạch, Giày Ngạo Long), tăng mạnh Công, HP cùng Thủ, xé toạc mọi hàng phòng ngự đối phương.",
        "special_attributes": {
            "title": "Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (Bộ Chuột)",
            "normal_highlights": [
                "⚔️ Vũ khí (Kiếm Trảm Yêu): Tăng +60% Tấn công toàn thuộc tính khi vào chiến đấu",
                "🛡️ Áo giáp (Ngạo Long Giáp): Tăng +180% Phòng ngự toàn thuộc tính khi vào chiến đấu",
                "🎯 Trang sức (Trấn Ma Thạch): Tăng +264% Chính xác bản thân khi vào chiến đấu",
                "💨 Giày (Giày Ngạo Long): Tăng +264% Né tránh bản thân khi vào chiến đấu"
            ],
            "rainbow_highlights": [
                "⚔️ Vũ khí Cầu Vồng: Tăng +120% Tấn công toàn thuộc tính (Gấp 2 lần)",
                "🛡️ Áo giáp Cầu Vồng: Tăng +360% Phòng ngự toàn thuộc tính (Gấp 2 lần)",
                "🎯 Trang sức Cầu Vồng: Tăng +540% Chính xác bản thân (Gấp hơn 2 lần)",
                "💨 Giày Cầu Vồng: Tăng +540% Né tránh bản thân (Gấp hơn 2 lần)"
            ]
        },
        "best_heroes": [
            {"name": "Songoku / Kakarot", "reason": "Tăng vọt công vật lý và bùng nổ sát thương diện rộng."},
            {"name": "CuồnBroli", "reason": "Khuếch đại sát thương vật lý và càn quét toàn bộ đội hình địch."},
            {"name": "Kurosaki Ichigo", "reason": "Tăng cường sức mạnh chém trảm hồn và dứt điểm mục tiêu chớp nhoáng."},
            {"name": "Saitama", "reason": "Tối đa hóa sát thương bộc phát vật lý đơn mục tiêu một đòn đoạt mạng."}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "92236", "suit_id": "471", "rainbow_suit_id": "571"},
            {"element": "Thủy (Nước)", "box_id": "92237", "suit_id": "473", "rainbow_suit_id": "573"},
            {"element": "Hỏa (Lửa)", "box_id": "92238", "suit_id": "472", "rainbow_suit_id": "572"},
            {"element": "Phong (Gió)", "box_id": "92239", "suit_id": "474", "rainbow_suit_id": "574"}
        ]
    },
    {
        "id": "rong",
        "name": "Bộ Năm Rồng",
        "animal": "Rồng",
        "icon": "🐉",
        "theme": "Bá Đạo Uy Lực & Áp Chế",
        "nature": "Thiên hướng Bá Đạo Uy Lực, Áp Chế Tuyệt Đối & Sát Thương Tối Thượng",
        "description": "Bộ trang bị Long Thần Cổ Giới giới hạn Năm Rồng (Long Thần Cổ Kiếm, Cổ Giáp, Cổ Khôi, Cổ Hài), tăng mạnh Công, Thủ và HP, uy lực áp đảo toàn chiến trường.",
        "special_attributes": {
            "title": "Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (Bộ Rồng)",
            "normal_highlights": [
                "⚔️ Vũ khí (Cổ Kiếm): Tăng +70% Tấn công toàn thuộc tính khi vào chiến đấu",
                "🛡️ Áo giáp (Cổ Giáp): Tăng +210% Phòng ngự toàn thuộc tính khi vào chiến đấu",
                "🎯 Trang sức (Cổ Khôi): Tăng +308% Chính xác bản thân (Cực hạn áp chế)",
                "💨 Giày (Cổ Hài): Tăng +308% Né tránh bản thân (Cực hạn)"
            ],
            "rainbow_highlights": [
                "⚔️ Vũ khí Cầu Vồng: Tăng +140% Tấn công toàn thuộc tính (Gấp 2 lần)",
                "🛡️ Áo giáp Cầu Vồng: Tăng +420% Phòng ngự toàn thuộc tính (Gấp 2 lần)",
                "🎯 Trang sức Cầu Vồng: Tăng +630% Chính xác bản thân (Gấp hơn 2 lần)",
                "💨 Giày Cầu Vồng: Tăng +630% Né tránh bản thân (Gấp hơn 2 lần)"
            ]
        },
        "best_heroes": [
            {"name": "Vegetto / Gogeta", "reason": "Khai mở toàn bộ tiềm năng hợp thể vô địch với lượng công kích tối thượng."},
            {"name": "Songohan Kong", "reason": "Cường hóa đòn đấm bộc phát cuồng nộ và quét sạch hàng sau địch."},
            {"name": "Rimuru", "reason": "Tăng cường năng lượng ma vương bạo phát và áp chế toàn bản đồ."},
            {"name": "CT - Vegeta", "reason": "Cường hóa niềm kiêu hãnh Hoàng Tử Saiyan với công kích bùng nổ."}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "9101007", "suit_id": "485", "rainbow_suit_id": "585"},
            {"element": "Thủy (Nước)", "box_id": "9101008", "suit_id": "487", "rainbow_suit_id": "587"},
            {"element": "Hỏa (Lửa)", "box_id": "9101009", "suit_id": "486", "rainbow_suit_id": "586"},
            {"element": "Phong (Gió)", "box_id": "9101010", "suit_id": "488", "rainbow_suit_id": "588"}
        ]
    },
    {
        "id": "ti",
        "name": "Bộ Năm Tị",
        "animal": "Tị",
        "icon": "🐍",
        "theme": "Tối Cường Sát Thương Nguyên Tố",
        "nature": "Thiên hướng Tối Cường Sát Thương Nguyên Tố, Xuyên Giáp Ma Đạo & Bào Mòn Sinh Lực",
        "description": "Bộ trang bị Thượng Cổ Năm Tị (Tương Dao Kiếm, Chúc Âm Giáp, Cửu Anh Nhẫn, Đằng Vũ Ủng). Bộ Tị là mạnh nhất đối với các tướng tăng sát thương theo mỗi điểm sát thương nguyên tố.",
        "special_attributes": {
            "title": "Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (Bộ Tị)",
            "normal_highlights": [
                "⚔️ Vũ khí (Tương Dao Kiếm): Tăng +80% Tấn công toàn thuộc tính khi vào chiến đấu (Cao nhất mốc thường)",
                "🛡️ Áo giáp (Chúc Âm Giáp): Tăng tấn công bằng 10 lần tốc độ hiện tại + cơ sở (Hệ số x5)",
                "⚡ Trang sức (Cửu Anh Nhẫn): Tăng +50% Tốc độ khi vào chiến đấu",
                "💨 Giày (Đằng Vũ Ủng): Tăng +50% Né tránh bản thân khi vào chiến đấu"
            ],
            "rainbow_highlights": [
                "⚔️ Vũ khí Cầu Vồng: Tăng +160% Tấn công toàn thuộc tính (Gấp 2 lần, cực hạn)",
                "🛡️ Áo giáp Cầu Vồng: Tăng tấn công bằng 10 lần tốc độ hiện tại + cơ sở (Hệ số x10)",
                "⚡ Trang sức Cầu Vồng: Tăng +100% Tốc độ khi vào chiến đấu (Gấp 2 lần)",
                "💨 Giày Cầu Vồng: Tăng +100% Né tránh bản thân (Gấp 2 lần)"
            ]
        },
        "best_heroes": [
            {"name": "Nagato", "reason": "Bộ Năm Tị cực kỳ hợp với Nagato vì tăng lượng lớn tấn công thuộc tính Địa/Hỏa/Thủy, bổ trợ hoàn hảo cho 3 phong cách chơi Chuyển Sinh."},
            {"name": "Sasuke (Lục Đạo / CT)", "reason": "Sử dụng chuẩn xác Bộ Năm Tị (chứ không dùng bộ Chuột) vì toàn bộ chiêu thức Lôi Độn (Chidori) và Hỏa Độn (Amaterasu) tăng vọt uy lực theo sát thương nguyên tố."},
            {"name": "Phù Thủy Elaina", "reason": "Sử dụng chuẩn xác Bộ Năm Tị (chứ không dùng bộ Chuột hay Ngựa) vì ma pháp gió lốc và bão tuyết khuếch đại tối đa theo sát thương thuộc tính Phong."},
            {"name": "Shalltear", "reason": "Gia tăng sát thương ma thuật hắc ám nguyên tố và hút máu cực đại."},
            {"name": "CT - Aizen", "reason": "Áp chế tinh thần và gia tăng bạo kích thuật thức nguyên tố."}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "9101513", "suit_id": "1370", "rainbow_suit_id": "1380"},
            {"element": "Thủy (Nước)", "box_id": "9101514", "suit_id": "1372", "rainbow_suit_id": "1382"},
            {"element": "Hỏa (Lửa)", "box_id": "9101515", "suit_id": "1371", "rainbow_suit_id": "1381"},
            {"element": "Phong (Gió)", "box_id": "9101516", "suit_id": "1373", "rainbow_suit_id": "1383"}
        ]
    },
    {
        "id": "ngua",
        "name": "Bộ Năm Ngựa",
        "animal": "Ngựa",
        "icon": "🐎",
        "theme": "Tối Cường Tốc Độ & Chính Xác",
        "nature": "Thiên hướng Tốc Độ Siêu Tốc, Tăng Chính Xác Tuyệt Đối & Xuất Kích Tiên Phong",
        "description": "Bộ trang bị Thiên Mã Chiến Thần (Chiến Phủ Anh Chiêu, Chiến Giáp Lộc Thục, Thắt Lưng Tường Vân, Giày Chiến Thiên Mã). Phù hợp với TẤT CẢ các tướng (trừ những tướng cần sức mạnh tăng theo sát thương thuộc tính), đem lại tốc độ tiên phong vượt trội và độ chính xác tuyệt đối bách phát bách trúng.",
        "special_attributes": {
            "title": "Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (Bộ Ngựa)",
            "normal_highlights": [
                "🎯 Vũ khí (Anh Chiêu): Tăng +100% Chính xác bản thân khi vào chiến đấu (Bách phát bách trúng)",
                "🛡️ Áo giáp (Lộc Thục): Tăng tấn công bằng 10 lần tốc độ hiện tại + cơ sở (Hệ số x8)",
                "⚡ Trang sức (Tường Vân): Tăng +60% Tốc độ khi vào chiến đấu",
                "💨 Giày (Thiên Mã): Tăng +50% Né tránh bản thân khi vào chiến đấu"
            ],
            "rainbow_highlights": [
                "🎯 Vũ khí Cầu Vồng: Tăng +200% Chính xác bản thân (Bách phát bách trúng tuyệt đối không thể né)",
                "🛡️ Áo giáp Cầu Vồng: Tăng tấn công bằng 10 lần tốc độ hiện tại + cơ sở (Hệ số x15)",
                "⚡ Trang sức Cầu Vồng: Tăng +120% Tốc độ khi vào chiến đấu (Gấp 2 lần)",
                "💨 Giày Cầu Vồng: Tăng +100% Né tránh bản thân (Gấp 2 lần)"
            ]
        },
        "best_heroes": [
            {"name": "Toàn bộ tướng thuần sát thương / vật lý", "reason": "Set Ngựa phù hợp với tất cả các tướng (trừ những tướng cần sức mạnh tăng theo sát thương thuộc tính), đem lại tốc độ tiên phong và độ chính xác bách phát bách trúng."},
            {"name": "Shadow (Cid Kageno)", "reason": "Shadow cực kỳ phù hợp với Set Ngựa vì giúp tăng vượt trội chỉ số Chính Xác (+100% -> +200%), né tránh và tốc độ, đảm bảo chiêu thức kết liễu I AM ATOMIC luôn trúng đích tuyệt đối!"},
            {"name": "Yatogami Tenka", "reason": "Tận dụng tốc độ thần sầu để áp sát trảm kích trước khi địch kịp phản xạ."},
            {"name": "Võ Thánh Quan Vũ", "reason": "Tăng cường độ chính xác và tốc độ trảm kích mãnh liệt."}
        ],
        "elements": [
            {"element": "Địa (Thổ)", "box_id": "9102121", "suit_id": "1630", "rainbow_suit_id": "1640"},
            {"element": "Thủy (Nước)", "box_id": "9102122", "suit_id": "1670", "rainbow_suit_id": "1680"},
            {"element": "Hỏa (Lửa)", "box_id": "9102123", "suit_id": "1650", "rainbow_suit_id": "1660"},
            {"element": "Phong (Gió)", "box_id": "9102124", "suit_id": "1690", "rainbow_suit_id": "1700"}
        ]
    }
]

zodiac_output = []
for zd in zodiac_definitions:
    variants = []
    for elem in zd["elements"]:
        bid = elem["box_id"]
        sid = elem["suit_id"]
        rsid = elem["rainbow_suit_id"]
        
        bentry = box.get(bid, [])
        rewards = bentry[0].get("reward", []) if bentry and len(bentry) > 0 else []
        
        parts_normal = []
        parts_rainbow = []
        
        for r in rewards:
            eid = str(r[1])
            eq = eq_map.get(eid, {})
            sort_num = eq.get("sort") or eq.get("slot") or 1
            slot_name = "Vũ khí" if sort_num == 1 else ("Trang sức" if sort_num == 2 else ("Áo giáp" if sort_num == 3 else "Giày"))
            
            # Format clean name without "Trường sinh", "Khung thần", "Kiếp tiên"...
            raw_name = eq.get("name") or ""
            fallback_name = ("Long Thần Cổ Kiếm" if sort_num == 1 else ("Long Thần Cổ Khôi" if sort_num == 2 else ("Long Thần Cổ Giáp" if sort_num == 3 else "Long Thần Cổ Hài"))) if zd["id"] == "rong" else f"Trang bị {slot_name} #{eid}"
            clean_name = clean_equip_name(raw_name, fallback_name)
                    
            img_ref = eq.get("assets", {}).get("image", {}).get("ref") or eq.get("image")
            icon_url = f"/assets/iphonehd/icon/{img_ref}.png" if img_ref else f"/assets/iphonehd/icon/{eid}.png"
            eff_val = eq.get("effect") or 0
            
            # Normal effect
            special_desc = ""
            if sort_num == 1:
                if zd["id"] == "ti":
                    special_desc = f"Tăng +{eff_val}% tấn công toàn thuộc tính khi vào chiến đấu"
                elif zd["id"] == "ngua":
                    special_desc = f"Tăng +{eff_val}% chính xác bản thân khi vào chiến đấu (Bách phát bách trúng)"
                else:
                    special_desc = f"Tăng +{eff_val}% tấn công toàn thuộc tính khi vào chiến đấu"
            elif sort_num == 3:
                if zd["id"] in ["ti", "ngua"]:
                    special_desc = f"Tăng tấn công toàn thuộc tính bằng 10 lần tốc độ hiện tại + tốc độ cơ sở"
                else:
                    special_desc = f"Tăng +{eff_val}% phòng ngự toàn thuộc tính khi vào chiến đấu"
            elif sort_num == 2:
                if zd["id"] in ["ti", "ngua"]:
                    special_desc = f"Tăng +{eff_val}% tốc độ khi vào chiến đấu"
                else:
                    special_desc = f"Tăng +{eff_val}% chính xác bản thân khi vào chiến đấu"
            elif sort_num == 4:
                special_desc = f"Tăng +{eff_val}% né tránh bản thân khi vào chiến đấu"
                
            parts_normal.append({
                "id": eid,
                "name": clean_name,
                "sort": sort_num,
                "slot_name": slot_name,
                "quality": 7,
                "icon": icon_url,
                "special_effect": special_desc,
                "effect_value": eff_val
            })
            
            # Find evolved Quality 8 item
            reid = eq.get("evolution", {}).get("next_evolution_equip_id") or str(int(eid) + 1)
            req = eq_map.get(str(reid), {})
            r_eff_val = req.get("effect") or (eff_val * 2)
            r_raw_name = req.get("name") or raw_name
            r_fallback = ("Long Thần Thần Kiếm" if sort_num == 1 else ("Long Thần Thần Khôi" if sort_num == 2 else ("Long Thần Thần Giáp" if sort_num == 3 else "Long Thần Thần Hài"))) if zd["id"] == "rong" else f"Trang bị {slot_name} #{reid}"
            r_clean_name = clean_equip_name(r_raw_name, clean_name or r_fallback)
                
            r_special_desc = ""
            if sort_num == 1:
                if zd["id"] == "ti":
                    r_special_desc = f"Tăng +{r_eff_val}% tấn công toàn thuộc tính khi vào chiến đấu (Gấp 2 lần)"
                elif zd["id"] == "ngua":
                    r_special_desc = f"Tăng +{r_eff_val}% chính xác bản thân khi vào chiến đấu (Bách phát bách trúng tuyệt đối)"
                else:
                    r_special_desc = f"Tăng +{r_eff_val}% tấn công toàn thuộc tính khi vào chiến đấu (Gấp 2 lần)"
            elif sort_num == 3:
                if zd["id"] in ["ti", "ngua"]:
                    r_special_desc = f"Tăng tấn công toàn thuộc tính bằng 10 lần tốc độ hiện tại + cơ sở (Hệ số gấp đôi)"
                else:
                    r_special_desc = f"Tăng +{r_eff_val}% phòng ngự toàn thuộc tính khi vào chiến đấu (Gấp 2 lần)"
            elif sort_num == 2:
                if zd["id"] in ["ti", "ngua"]:
                    r_special_desc = f"Tăng +{r_eff_val}% tốc độ khi vào chiến đấu (Gấp 2 lần)"
                else:
                    r_special_desc = f"Tăng +{r_eff_val}% chính xác bản thân khi vào chiến đấu (Gấp hơn 2 lần)"
            elif sort_num == 4:
                r_special_desc = f"Tăng +{r_eff_val}% né tránh bản thân khi vào chiến đấu (Gấp hơn 2 lần)"

            parts_rainbow.append({
                "id": str(reid),
                "name": r_clean_name,
                "sort": sort_num,
                "slot_name": slot_name,
                "quality": 8,
                "icon": icon_url,
                "special_effect": r_special_desc,
                "effect_value": r_eff_val
            })
            
        s_obj = suits_config.get(sid, {})
        rs_obj = suits_config.get(rsid, {})
        
        is_hoi = zd["id"] == "hoi"
        clean_suit_title = f"{zd['name']} ({elem['element']})"
        variants.append({
            "element": elem["element"],
            "box_id": bid,
            "suit_id": sid,
            "rainbow_suit_id": rsid,
            "suit_name": clean_suit_title,
            "rainbow_suit_name": f"{clean_suit_title} - Cầu Vồng",
            "parts": parts_normal,
            "rainbow_parts": parts_rainbow,
            "bonuses": {
                "title": "Mốc Thường (Phẩm 7)",
                "two_piece": "+60,000 HP, +45,000 Phòng Ngự / Kháng" if is_hoi else "+90,000 HP, +54,000 Phòng Ngự / Kháng",
                "three_piece": "+60,000 HP, +45,000 Kháng Thuộc Tính" if is_hoi else "+90,000 HP, +54,000 Kháng Thuộc Tính",
                "four_piece": "+225,000 Công, +60,000 Thủ, +210,000 HP Tối Đa" if is_hoi else "+270,000 Công, +90,000 Thủ, +315,000 HP Tối Đa"
            },
            "rainbow_bonuses": {
                "title": "Mốc Cầu Vồng (Phẩm 8)",
                "two_piece": "+150,000 HP, +112,500 Phòng Ngự / Kháng" if is_hoi else "+225,000 HP, +135,000 Phòng Ngự / Kháng",
                "three_piece": "+150,000 HP, +112,500 Kháng Toàn Thuộc Tính" if is_hoi else "+225,000 HP, +135,000 Kháng Toàn Thuộc Tính",
                "four_piece": "+562,500 Công, +150,000 Thủ, +450,000 HP Tối Đa" if is_hoi else "+675,000 Công, +225,000 Thủ, +675,000 HP Tối Đa",
                "stats": {
                    "hp": 450000 if is_hoi else 675000,
                    "patk": 562500 if is_hoi else 675000,
                    "matk": 562500 if is_hoi else 675000,
                    "def": 150000 if is_hoi else 225000,
                    "speed": 150000 if is_hoi else 200000,
                    "ele_atk": 500000 if is_hoi else 675000
                }
            }
        })
        
    zodiac_output.append({
        **zd,
        "variants": variants
    })

with open("web/src/data/zodiac_sets.json", "w", encoding="utf-8") as f:
    json.dump(zodiac_output, f, ensure_ascii=False, indent=2)

print(f"Generated web/src/data/zodiac_sets.json with {len(zodiac_output)} zodiac sets.")
