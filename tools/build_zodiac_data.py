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

zodiac_definitions = [
    {
        "id": "chuot",
        "name": "Bộ Năm Chuột (Tý)",
        "animal": "Chuột (Tý)",
        "icon": "🐭",
        "theme": "Kiếp Tiên",
        "nature": "Thiên hướng Bạo Kích Cực Hạn, Sát Thương Đột Phá & Công Kích Toàn Diện",
        "description": "Bộ trang bị thần thoại giới hạn Tết Năm Chuột, tăng đột biến 270.000 Công, 315.000 HP cùng 90.000 Thủ, xé toạc mọi hàng phòng thủ.",
        "best_heroes": [
            {"name": "Shadow", "reason": "Tối đa hóa bạo kích và sát thương ma pháp xuyên giáp"},
            {"name": "Songoku / Kakarot", "reason": "Tăng vọt công vật lý và bùng nổ sát thương diện rộng"},
            {"name": "CuồnBroli", "reason": "Khuếch đại sát thương vật lý và càn quét đội hình"},
            {"name": "Kurosaki Ichigo", "reason": "Tăng cường sức mạnh chém trảm hồn và dứt điểm mục tiêu"}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "92236", "suit_id": "471"},
            {"element": "Thủy (Nước)", "box_id": "92237", "suit_id": "473"},
            {"element": "Hỏa (Lửa)", "box_id": "92238", "suit_id": "472"},
            {"element": "Phong (Gió)", "box_id": "92239", "suit_id": "474"}
        ]
    },
    {
        "id": "ti",
        "name": "Bộ Năm Tị (Rắn)",
        "animal": "Tị (Rắn)",
        "icon": "🐍",
        "theme": "Hung Thú Cổ Đại",
        "nature": "Thiên hướng Khống Chế, Xuyên Giáp Ma Đạo & Bào Mòn Sinh Lực",
        "description": "Bộ trang bị Hung Thú Thượng Cổ (Tương Dao, Chúc Âm, Cửu Anh, Đằng Vũ), tăng 270.000 Công thuộc tính, 90.000 Kháng và 315.000 HP, khắc chế cứng các tanker.",
        "best_heroes": [
            {"name": "Nagato", "reason": "Cường hóa Ngoại Đạo Ma Tượng và sát thương diện rộng Luân Hồi Nhãn"},
            {"name": "Lục Đạo Sasuke", "reason": "Tối ưu hóa hỏa lôi sát thương và hiệu ứng khống chế Chidori"},
            {"name": "Shalltear", "reason": "Hút máu cực lớn và gia tăng sát thương ma thuật hắc ám"},
            {"name": "CT - Aizen", "reason": "Áp chế tinh thần và gia tăng sức mạnh thuật thức"}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "9101513", "suit_id": "1370"},
            {"element": "Thủy (Nước)", "box_id": "9101514", "suit_id": "1372"},
            {"element": "Hỏa (Lửa)", "box_id": "9101515", "suit_id": "1371"},
            {"element": "Phong (Gió)", "box_id": "9101516", "suit_id": "1373"}
        ]
    },
    {
        "id": "hoi",
        "name": "Bộ Năm Hợi (Heo)",
        "animal": "Hợi (Heo)",
        "icon": "🐗",
        "theme": "Thương Thần (Thương Khung)",
        "nature": "Thiên hướng Công Thủ Toàn Diện, Sinh Tồn Bền Bỉ & Cường Hóa Trực Tiếp HP",
        "description": "Bộ trang bị thần thánh hoàng đạo Năm Hợi (Thiên Vấn, Giáp Thần Võ, Phiên Thiên Ấn, Giày Ảo Ảnh), tăng 225.000 Công, 60.000 Thủ và 210.000 HP.",
        "best_heroes": [
            {"name": "Bikini - Frieren", "reason": "Cân bằng sinh tồn tuyệt đối trong giao tranh kéo dài và buff ma pháp liên tục"},
            {"name": "Maple", "reason": "Biến Maple thành pháo đài bất tử không thể bị xuyên thủng"},
            {"name": "Jiraiya", "reason": "Cung cấp lượng máu khổng lồ và chống chịu cho Tiên Nhân thuật"},
            {"name": "Athena", "reason": "Gia tăng độ trâu bò và cường hóa hiệu ứng hỗ trợ đồng đội"}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "91076", "suit_id": "652"},
            {"element": "Thủy (Nước)", "box_id": "91077", "suit_id": "654"},
            {"element": "Hỏa (Lửa)", "box_id": "91078", "suit_id": "653"},
            {"element": "Phong (Gió)", "box_id": "91079", "suit_id": "655"}
        ]
    },
    {
        "id": "rong",
        "name": "Bộ Năm Rồng (Thìn)",
        "animal": "Rồng (Thìn)",
        "icon": "🐉",
        "theme": "Tứ Cực Long Thần",
        "nature": "Thiên hướng Bá Đạo Uy Lực, Áp Chế Tuyệt Đối & Sát Thương Tối Thượng",
        "description": "Bộ trang bị Long Thần Cổ Giới giới hạn Năm Rồng, tăng 270.000 Công, 90.000 Thủ và 315.000 HP, là trang bị uy lực tối cao trong game.",
        "best_heroes": [
            {"name": "Vegetto / Gogeta", "reason": "Khai mở toàn bộ tiềm năng hợp thể vô địch với lượng công tối thượng"},
            {"name": "Songohan Kong", "reason": "Cường hóa đòn đấm bộc phát cuồng nộ và quét sạch hàng sau địch"},
            {"name": "Rimuru", "reason": "Tăng cường năng lượng ma vương bạo phát và áp chế toàn bản đồ"},
            {"name": "CT - Vegeta", "reason": "Cường hóa niềm kiêu hãnh Hoàng Tử Saiyan với công kích bùng nổ"}
        ],
        "elements": [
            {"element": "Thổ (Địa)", "box_id": "9101007", "suit_id": "485"},
            {"element": "Thủy (Nước)", "box_id": "9101008", "suit_id": "487"},
            {"element": "Hỏa (Lửa)", "box_id": "9101009", "suit_id": "486"},
            {"element": "Phong (Gió)", "box_id": "9101010", "suit_id": "488"}
        ]
    },
    {
        "id": "ngua",
        "name": "Bộ Năm Ngựa (Ngọ)",
        "animal": "Ngựa (Ngọ)",
        "icon": "🐎",
        "theme": "Chiến Thần Thiên Mã",
        "nature": "Thiên hướng Tốc Độ Siêu Tốc, Xuất Kích Tiên Phong & Liên Kích Vũ Bão",
        "description": "Bộ trang bị Thiên Mã Chiến Thần (Chiến Phủ Anh Chiêu, Giáp Lộc Thục, Thắt Lưng Tường Vân, Giày Thiên Mã), tăng 270.000 Công, 90.000 Thủ, 315.000 HP và tốc độ xuất chiêu áp đảo.",
        "best_heroes": [
            {"name": "Phù Thủy Elaina", "reason": "Tăng tốc xuất chiêu tối thượng, khống chế và tung đòn kết liễu đầu tiên"},
            {"name": "Yatogami Tenka", "reason": "Tận dụng tốc độ thần sầu để áp sát trảm kích trước khi địch kịp ra chiêu"},
            {"name": "Võ Thánh Quan Vũ", "reason": "Cộng hưởng trực tiếp hình tượng Xích Thố Thiên Mã, chém rách phòng ngự"},
            {"name": "Kiếm Hy Vọng (Trunks)", "reason": "Xuất kiếm chớp nhoáng tạo đột biến lật ngược thế trận"}
        ],
        "elements": [
            {"element": "Địa (Thổ)", "box_id": "9102121", "suit_id": "1630"},
            {"element": "Thủy (Nước)", "box_id": "9102122", "suit_id": "1670"},
            {"element": "Hỏa (Lửa)", "box_id": "9102123", "suit_id": "1650"},
            {"element": "Phong (Gió)", "box_id": "9102124", "suit_id": "1690"}
        ]
    }
]

zodiac_output = []
for zd in zodiac_definitions:
    variants = []
    for elem in zd["elements"]:
        bid = elem["box_id"]
        sid = elem["suit_id"]
        bentry = box.get(bid, [])
        rewards = bentry[0].get("reward", []) if bentry and len(bentry) > 0 else []
        
        parts = []
        for r in rewards:
            eid = str(r[1])
            eq = eq_map.get(eid, {})
            parts.append({
                "id": eid,
                "name": eq.get("name") or f"Trang bị #{eid}",
                "sort": eq.get("sort"),
                "slot_name": "Vũ khí" if eq.get("sort") == 1 else ("Trang sức" if eq.get("sort") == 2 else ("Áo giáp" if eq.get("sort") == 3 else "Giày")),
                "quality": eq.get("quality", 7),
                "icon": f"/assets/iphonehd/icon/{eid}.png"
            })
            
        s_obj = suits_config.get(sid, {})
        variants.append({
            "element": elem["element"],
            "box_id": bid,
            "suit_id": sid,
            "suit_name": s_obj.get("name") or suit_map.get(sid, {}).get("name"),
            "parts": parts,
            "bonuses": {
                "two_piece": "+90,000 HP, +54,000 Phòng Ngự / Kháng",
                "three_piece": "+90,000 HP, +54,000 Kháng Thuộc Tính",
                "four_piece": "+270,000 Công, +90,000 Thủ, +315,000 HP Tối Đa"
            }
        })
        
    zodiac_output.append({
        **zd,
        "variants": variants
    })

with open("web/src/data/zodiac_sets.json", "w", encoding="utf-8") as f:
    json.dump(zodiac_output, f, ensure_ascii=False, indent=2)

print(f"Generated web/src/data/zodiac_sets.json with {len(zodiac_output)} zodiac sets.")
