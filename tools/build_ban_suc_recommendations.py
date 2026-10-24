# tools/build_ban_suc_recommendations.py
import json
import os

ban_suc_definitions = {
    "con-lac": {
        "id": "con-lac",
        "name": "Con Lắc",
        "fate_id": "11",
        "icon": "/assets/iphonehd/icon/dianhaushi10_3_4.png",
        "url": "/ban-suc#fate-11"
    },
    "aether": {
        "id": "aether",
        "name": "Aether",
        "fate_id": "2",
        "icon": "/assets/iphonehd/icon/dianhaushi01_3_4.png",
        "url": "/ban-suc#fate-2"
    },
    "lanh-chua": {
        "id": "lanh-chua",
        "name": "Lãnh Chúa",
        "fate_id": "5",
        "icon": "/assets/iphonehd/icon/dianhaushi04_3_4.png",
        "url": "/ban-suc#fate-5"
    },
    "titan": {
        "id": "titan",
        "name": "Titan",
        "fate_id": "3",
        "icon": "/assets/iphonehd/icon/dianhaushi02_3_4.png",
        "url": "/ban-suc#fate-3"
    },
    "quang-nien": {
        "id": "quang-nien",
        "name": "Quang Niên",
        "fate_id": "8",
        "icon": "/assets/iphonehd/icon/dianhaushi07_3_4.png",
        "url": "/ban-suc#fate-8"
    },
    "than-thu": {
        "id": "than-thu",
        "alias": ["thien-thu"],
        "name": "Thần Thư",
        "fate_id": "7",
        "icon": "/assets/iphonehd/icon/dianhaushi06_3_4.png",
        "url": "/ban-suc#fate-7"
    },
    "vuong-toa": {
        "id": "vuong-toa",
        "alias": ["vuong-toạ"],
        "name": "Vương Toạ",
        "fate_id": "9",
        "icon": "/assets/iphonehd/icon/dianhaushi08_3_4.png",
        "url": "/ban-suc#fate-9"
    },
    "tinh-than": {
        "id": "tinh-than",
        "name": "Tinh Thần",
        "fate_id": "6",
        "icon": "/assets/iphonehd/icon/dianhaushi05_3_4.png",
        "url": "/ban-suc#fate-6"
    },
    "khoi-nguyen": {
        "id": "khoi-nguyen",
        "name": "Khởi Nguyên",
        "fate_id": "10",
        "icon": "/assets/iphonehd/icon/dianhaushi09_3_4.png",
        "url": "/ban-suc#fate-10"
    },
    "huy-diet": {
        "id": "huy-diet",
        "alias": ["huy-biet"],
        "name": "Huỷ Diệt",
        "fate_id": "4",
        "icon": "/assets/iphonehd/icon/dianhaushi03_3_4.png",
        "url": "/ban-suc#fate-4"
    }
}

# Raw guides provided by the user with exact conditions & wording
# Each hero has:
# - raw_list: user's recommendation list
# - hp_scaling_evidence: internal grounds for HP-based Thần Thư addition (or None)
# - target_ids: list of hero catalog IDs mapped explicitly

hero_configs = [
    {
        "group_name": "Tenka",
        "target_ids": ["81700"],
        "target_name": "Yatogami Tenka",
        "character_id": "427",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "titan", "name": "Titan"},
            {"id": "quang-nien", "name": "Quang Niên"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Kiếm Chung Yên",
            "description": "Kĩ năng trước chiến đấu: Yatogami Tenka phóng ra sức mạnh Tinh Linh, vĩnh viễn tăng 230% HP tối đa bản thân và 79% Giảm Thương toàn thể, tăng 500% Trúng Đích, Né Tránh và Bạo Kích; và Truy Kích ST thực bằng 50% HP tối đa bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Kiếm Chung Yên truy kích ST thực bằng 50% HP tối đa bản thân"
        }
    },
    {
        "group_name": "Vegeta",
        "target_ids": ["43600", "83300", "83400"],
        "target_name": "Vegeta / CT - Vegeta",
        "character_id": "436",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "than-thu", "name": "Thần Thư"}
        ],
        "hp_scaling_evidence": None # Already has Thần Thư
    },
    {
        "group_name": "Goku",
        "target_ids": ["1", "42500", "81100", "81200", "425000", "39600", "69200", "69500"],
        "target_name": "Songoku / Kakarot / CT - Songoku",
        "character_id": "425",
        "raw_items": [
            {"id": "than-thu", "name": "Thần Thư x4", "condition": "nếu chơi Gogeta", "custom_text": "Thần Thư x4 (nếu chơi Gogeta)"},
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "aether", "name": "Aether"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "quang-nien", "name": "Quang Niên", "condition": "khi không đi cùng Vegeta", "custom_text": "Quang Niên (khi không đi cùng Vegeta)"}
        ],
        "hp_scaling_evidence": None # Already has Thần Thư x4
    },
    {
        "group_name": "Zoro",
        "target_ids": ["32900", "43700", "83500", "83600", "67500"],
        "target_name": "Zoro / Thợ Săn - Zoro / Quỷ Thần - Zoro",
        "character_id": "437",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "than-thu", "name": "Thần Thư"}
        ],
        "hp_scaling_evidence": None # Already has Thần Thư
    },
    {
        "group_name": "Newgate",
        "target_ids": ["43000", "82100", "82200"],
        "target_name": "Râu Trắng / Edward Newgate",
        "character_id": "430",
        "raw_items": [
            {"id": "aether", "name": "Aether"},
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": "Kỹ năng: Moby Dick / Một địch một ngàn",
            "description": "Chỉ có cơ chế hồi phục 50% HP bản thân khi chết (tự hồi máu), không có sát thương/hiệu ứng phụ thuộc lượng HP bản thân.",
            "status": "verified_no_scaling",
            "added_than_thu": False
        }
    },
    {
        "group_name": "Vegetto",
        "target_ids": ["44200", "84500", "442000", "84600"],
        "target_name": "Vegetto / CT - vegetto",
        "character_id": "442",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Cực - Kamekameha & Chuyển Sinh 7: Hồn·CT - Vegetto",
            "description": "Kỹ năng Cực - Kamekameha gây thêm ST truy kích bằng 10%-40% HP max bản thân. Chuyển Sinh 7 gây Truy Kích cho kẻ địch khác với ST bằng 50% HP max bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Cực - Kamekameha & CS7 truy kích 10-50% HP max bản thân"
        }
    },
    {
        "group_name": "Shalltear",
        "target_ids": ["41700", "79800"],
        "target_name": "Shalltear / CT-Shalltear",
        "character_id": "417",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "titan", "name": "Titan"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Ngọn Thương Thanh Tẩy",
            "description": "Kĩ năng tiền chiến: Tăng vĩnh viễn 100% giới hạn HP của bản thân và giảm 79% thương tổn tổng thể, gây ST thực bằng 50% lượng HP tối đa của bản thân cho tất cả kẻ địch.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Ngọn Thương Thanh Tẩy gây ST thực bằng 50% lượng HP tối đa của bản thân"
        }
    },
    {
        "group_name": "Tanjiro",
        "target_ids": ["42100", "80300", "80400"],
        "target_name": "Kamado Tanjiro / CT-Kamado Tanjiro / HỏaKamado Tanjiro",
        "character_id": "421",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "than-thu", "name": "Thần Thư"}
        ],
        "hp_scaling_evidence": None # Already has Thần Thư
    },
    {
        "group_name": "Gojo",
        "target_ids": ["42300", "80700", "80800"],
        "target_name": "Satoru Gojo / CT-Satoru Gojo / GiácSatoru Gojo",
        "character_id": "423",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "aether", "name": "Aether"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "titan", "name": "Titan"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng tiền chiến: Thuật Thức Nghịch Chuyển [Hách] & Chú Thuật [Thương]",
            "description": "Thuật Thức Nghịch Chuyển [Hách] vĩnh viễn tăng 200% HP/79% Giảm Thương bản thân và gây thêm ST thực bằng 50% HP tối đa bản thân. Kỹ năng Chú Thuật [Thương] gây thêm ST bằng 30% HP.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Thuật Thức Nghịch Chuyển [Hách] gây thêm ST thực bằng 50% HP tối đa bản thân"
        }
    },
    {
        "group_name": "Rimuru",
        "target_ids": ["42900", "81900", "82000"],
        "target_name": "Rimuru / CT - Rimuru / DK - Rimuru",
        "character_id": "429",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "aether", "name": "Aether"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": "Hiền Giả Phân Tích / Sức Mạnh Ma Vương",
            "description": "Kỹ năng hồi sinh 100% HP khi tử vong, sát thương tính theo Ma Công và Công Thuộc Tính, không tính sát thương theo lượng HP bản thân.",
            "status": "verified_no_scaling",
            "added_than_thu": False
        }
    },
    {
        "group_name": "Kikyo",
        "target_ids": ["41900", "80000"],
        "target_name": "Kikyo / CT-Kikyo",
        "character_id": "419",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "than-thu", "name": "Thần Thư"},
            {"id": "tinh-than", "name": "Tinh Thần"}
        ],
        "hp_scaling_evidence": None # Already has Thần Thư
    },
    {
        "group_name": "Nagato",
        "target_ids": ["43100", "82300", "82400"],
        "target_name": "Pain / CT - Pain / Nagato",
        "character_id": "431",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "aether", "name": "Aether"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "titan", "name": "Titan"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng Siêu Tiến Hóa 2: Ngoại đạo ma tượng - Genryuu Kyuu Fuujin",
            "description": "Vĩnh viễn tăng 210% HP max, 79% Giảm Thương chỉnh thể, gây ra effect% ST thực ma pháp và 1800% ST nguyên tố Thổ, Truy Kích với ST thực bằng 50% HP max của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Ngoại Đạo Ma Tượng truy kích ST thực bằng 50% HP max bản thân"
        }
    },
    {
        "group_name": "Shadow",
        "target_ids": ["43400", "82900", "83000"],
        "target_name": "Cid Kageno / CT - Cid Kageno / Shadow",
        "character_id": "434",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": "I Am Atomic",
            "description": "Sát thương tính theo Công Ma Pháp và Công Thuộc Tính Địa, không có tỷ lệ theo HP bản thân.",
            "status": "verified_no_scaling",
            "added_than_thu": False
        }
    },
    {
        "group_name": "Trunks",
        "target_ids": ["43200", "82500", "82600"],
        "target_name": "Trunks / CT - Trunks / Kiếm Hy Vọng",
        "character_id": "432",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "aether", "name": "Aether"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Galick Canon / Hủy Diệt Ma Phong Ba",
            "description": "Kĩ năng trước chiến đấu: Vĩnh viễn tăng 220% HP max, 79% Giảm Thương chỉnh thể. Truy Kích với ST thực bằng 50% HP max của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Galick Canon truy kích ST thực bằng 50% HP max của bản thân"
        }
    },
    {
        "group_name": "Broli",
        "target_ids": ["42000", "80100", "80200"],
        "target_name": "Broli / CT-Broli / CuồnBroli",
        "character_id": "420",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ", "condition": "Hướng thủ", "custom_text": "Vương Toạ (Hướng thủ)"},
            {"id": "slash-titan-quang-nien", "is_slash": True, "slash_label": "Titan / Quang Niên", "condition": "Hướng công", "custom_text": "Titan / Quang Niên (Hướng công)", "items": [{"id": "titan", "name": "Titan"}, {"id": "quang-nien", "name": "Quang Niên"}]}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Giác Tỉnh, Cuồng - Giác Tỉnh & Vực Sâu",
            "description": "Kỹ năng tiền chiến Giác Tỉnh tăng 180%-220% HP/79% Giảm Thương bản thân và gây thêm ST thực bằng 50% HP tối đa bản thân. Kỹ năng Vực Sâu gây thêm ST thực bằng 50% HP.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Giác Tỉnh và Vực Sâu gây thêm ST thực bằng 50% HP tối đa bản thân"
        }
    },
    {
        "group_name": "Elaina",
        "target_ids": ["43500", "83100", "83200"],
        "target_name": "Elaina / Phù Thủy - Elaina",
        "character_id": "435",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "slash-lanh-chua-vuong-toa", "is_slash": True, "slash_label": "Lãnh Chúa / Vương Toạ", "items": [{"id": "lanh-chua", "name": "Lãnh Chúa"}, {"id": "vuong-toa", "name": "Vương Toạ"}]},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": "Bão Tố Ma Thuật",
            "description": "Sát thương tính theo Ma Công và Công Thuộc Tính Phong/Thủy, không có tỷ lệ theo HP bản thân.",
            "status": "verified_no_scaling",
            "added_than_thu": False
        }
    },
    {
        "group_name": "Frieren",
        "target_ids": ["43300", "82700", "82800"],
        "target_name": "Frieren / CT - Frieren / Bikini - Frieren",
        "character_id": "433",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Ma pháp tán ma / Bạo phá trái tim",
            "description": "Kỹ năng tiền chiến: Vĩnh viễn tăng 220% HP tối đa của bản thân, giảm thương chỉnh thể 79%. Truy kích với ST thực bằng 50% HP của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Ma pháp tán ma truy kích ST thực bằng 50% HP của bản thân"
        }
    },
    {
        "group_name": "Gohan",
        "target_ids": ["42600", "81400", "81500"],
        "target_name": "Songohan / CT - Songohan / Songohan Kong",
        "character_id": "426",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "vuong-toa", "name": "Vương Toạ"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Kamekameha / Bạo Phát Nộ Khí",
            "description": "Kỹ năng trước khi chiến đấu: Tăng 200% HP bản thân / 79% giảm thương. Gây ra ST bằng 30% HP tối đa của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Kamekameha gây ST bằng 30% HP tối đa bản thân"
        }
    },
    {
        "group_name": "Piccolo",
        "target_ids": ["41800", "79900"],
        "target_name": "Piccolo / CT-Piccolo",
        "character_id": "418",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "tinh-than", "name": "Tinh Thần"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": "Ma Quán Quang Sát Pháo",
            "description": "Cơ chế hỗ trợ và khống chế, không có sát thương theo tỷ lệ HP bản thân.",
            "status": "verified_no_scaling",
            "added_than_thu": False
        }
    },
    {
        "group_name": "Maple",
        "target_ids": ["42200", "80500", "80600"],
        "target_name": "Maple / CT-Maple / MG -Maple",
        "character_id": "422",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "slash-tinh-than-khoi-nguyen", "is_slash": True, "slash_label": "Tinh Thần / Khởi Nguyên", "items": [{"id": "tinh-than", "name": "Tinh Thần"}, {"id": "khoi-nguyen", "name": "Khởi Nguyên"}]},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: MG - Bạo Phát, Kẻ Thôn Phệ Bom & Chuyển Sinh CS5",
            "description": "MG - Bạo Phát tăng 200% HP/79% Giảm Thương bản thân và gây thêm ST thực bằng 50% HP tối đa bản thân. Kẻ Thôn Phệ Bom và CS5 Thần·MG -Maple gây thêm ST thực bằng 50% HP.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng MG - Bạo Phát và CS5 gây thêm ST thực bằng 50% HP tối đa bản thân"
        }
    },
    {
        "group_name": "Inori",
        "target_ids": ["42800", "81800", "428000"],
        "target_name": "Inori / CT - Inori / Hắc Vũ Chi Dạ - Inori",
        "character_id": "428",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "tinh-than", "name": "Tinh Thần"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Hư Không (Skin Hắc Vũ Chi Dạ)",
            "description": "Kĩ năng tử vong Hư Không: Nếu sử dụng skin 'Hắc Vũ Chi Dạ' thì sẽ được nhận thêm 1 tầng 'Hòa vào màn đêm', gây ra thêm ST bằng 30% HP tối đa của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư (nếu kích hoạt cơ chế ST theo 30% HP bản thân từ skin Hắc Vũ Chi Dạ)"
        }
    },
    {
        "group_name": "Luffy Nika",
        "target_ids": ["81300"],
        "target_name": "Luffy - Nika",
        "character_id": "424",
        "raw_items": [
            {"id": "con-lac", "name": "Con Lắc"},
            {"id": "aether", "name": "Aether"},
            {"id": "lanh-chua", "name": "Lãnh Chúa"},
            {"id": "vuong-toa", "name": "Vương Toạ"},
            {"id": "than-thu", "name": "Thần Thư"},
            {"id": "huy-diet", "name": "Huỷ Diệt"}
        ],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Tự Do!!!!!!",
            "description": "Kỹ năng trước khi chiến đấu: Tăng 210% HP bản thân / 79% giảm thương. Gây ra ST bằng 40% HP tối đa của bản thân.",
            "status": "verified_already_in_list",
            "added_than_thu": False # Already in manual list
        }
    },
    # The 4 heroes without manual lists:
    {
        "group_name": "Sasuke",
        "target_ids": ["84000"],
        "target_name": "Lục Đạo Sasuke",
        "character_id": "439",
        "is_unlisted": True,
        "raw_items": [],
        "min_rebirth_stage": 4,
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "min_rebirth_stage": 4,
            "skill_or_stage": "CS4 Lục Đạo Sasuke (Kỹ năng: Địa Bộc Thiên Tinh / Thần Ngự)",
            "description": "Kỹ năng Chuyển Sinh 4: Nếu Sức Mạnh Sấm Sét > 5 gây ra ST truy kích bằng 50% HP max của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế CS4 Lục Đạo Sasuke gây ST truy kích bằng 50% HP max bản thân (Mở từ Chuyển Sinh 4). Các ban sức khác đang cập nhật."
        }
    },
    {
        "group_name": "Sasuke",
        "target_ids": ["43900", "83900"],
        "target_name": "Chú Nguyền Sasuke / CT - Chú Nguyền Sasuke",
        "character_id": "439",
        "is_unlisted": True,
        "raw_items": [],
        "min_rebirth_stage": 1,
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "min_rebirth_stage": 1,
            "skill_or_stage": "CS1 Chú Nguyền Sasuke",
            "description": "Kỹ năng Chuyển Sinh 1: Gây ra thêm ST truy kích bằng 50% HP max của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế CS1 Chú Nguyền Sasuke gây ST truy kích bằng 50% HP max bản thân (Mở từ Chuyển Sinh 1). Các ban sức khác đang cập nhật."
        }
    },
    {
        "group_name": "Shamrock",
        "target_ids": ["44100", "84300", "84400"],
        "target_name": "Shanks / Shamrock (夏姆洛克)",
        "character_id": "441",
        "is_unlisted": True,
        "raw_items": [],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": None,
            "description": "Chưa có danh sách thủ công và không có cơ chế phụ thuộc HP bản thân.",
            "status": "pending_update"
        }
    },
    {
        "group_name": "Meliodas",
        "target_ids": ["44000", "84100", "84200"],
        "target_name": "Meliodas / CT - Meliodas / Ma Thần Meliodas",
        "character_id": "440",
        "is_unlisted": True,
        "raw_items": [],
        "hp_scaling_evidence": {
            "has_hp_mechanic": True,
            "skill_or_stage": "Kỹ năng: Cắt Kim Loại / Ma Thần Bộc Phát",
            "description": "Kĩ năng trước lượt đấu: Dùng 1 tầng 'Sức Mạnh Ma Thần' của bản thân gây ra ST truy kích bằng 50% HP max của bản thân.",
            "status": "verified",
            "added_than_thu": True,
            "note": "Bổ sung Thần Thư theo cơ chế kỹ năng Cắt Kim Loại / Ma Thần Bộc Phát gây ST truy kích bằng 50% HP max của bản thân. Các ban sức khác đang cập nhật."
        }
    },
    {
        "group_name": "Kanae",
        "target_ids": ["83800"],
        "target_name": "Kanae",
        "character_id": "438",
        "is_unlisted": True,
        "raw_items": [],
        "hp_scaling_evidence": {
            "has_hp_mechanic": False,
            "skill_or_stage": None,
            "description": "Chưa có danh sách thủ công. Cơ chế kỹ năng và CS tập trung vào Trúng Độc và né tránh, không có cơ chế sát thương theo lượng HP bản thân.",
            "status": "pending_update"
        }
    }
]

# Generate per-hero ID recommendations
output_data = {
    "metadata": {
        "title": "Cẩm Nang Ban Sức Khuyến Nghị Tướng",
        "description": "Dữ liệu hướng dẫn ban sức tối ưu do người dùng cung cấp và cơ chế Thần Thư theo HP bản thân",
        "updated_at": "2026-10-20"
    },
    "ban_suc_definitions": ban_suc_definitions,
    "heroes": {}
}

for cfg in hero_configs:
    gname = cfg["group_name"]
    items = list(cfg["raw_items"])
    hp_ev = cfg.get("hp_scaling_evidence")
    
    # If HP scaling found and Thần Thư not already in list, append Thần Thư
    if hp_ev and hp_ev.get("added_than_thu"):
        # Check if than-thu already exists
        has_tt = any(it.get("id") == "than-thu" or (it.get("is_slash") and any(sub.get("id") == "than-thu" for sub in it.get("items", []))) for it in items)
        if not has_tt:
            items.append({
                "id": "than-thu",
                "name": "Thần Thư",
                "is_hp_addition": True,
                "min_rebirth_stage": cfg.get("min_rebirth_stage", 0),
                "hp_note": hp_ev.get("note")
            })

    # Build recommendations list with resolved icons, links, and notes
    processed_recs = []
    for it in items:
        if it.get("is_slash"):
            sub_items = []
            for sub in it.get("items", []):
                b_def = ban_suc_definitions.get(sub["id"], {})
                sub_items.append({
                    "id": sub["id"],
                    "name": sub["name"],
                    "icon": b_def.get("icon"),
                    "url": b_def.get("url")
                })
            processed_recs.append({
                "is_slash": True,
                "label": it.get("slash_label"),
                "condition": it.get("condition"),
                "custom_text": it.get("custom_text"),
                "sub_items": sub_items
            })
        else:
            b_def = ban_suc_definitions.get(it["id"], {})
            processed_recs.append({
                "id": it["id"],
                "name": it["name"],
                "icon": b_def.get("icon"),
                "url": b_def.get("url"),
                "condition": it.get("condition"),
                "custom_text": it.get("custom_text"),
                "is_hp_addition": it.get("is_hp_addition", False),
                "min_rebirth_stage": it.get("min_rebirth_stage", 0),
                "hp_note": it.get("hp_note")
            })

    entry = {
        "group_name": gname,
        "is_unlisted": cfg.get("is_unlisted", False),
        "status": "ready" if processed_recs else "pending_update",
        "recommendations": processed_recs,
        "hp_scaling_evidence": hp_ev
    }

    # Map to each target ID
    for hid in cfg["target_ids"]:
        output_data["heroes"][hid] = {
            **entry,
            "hero_id": hid
        }

os.makedirs("web/src/data", exist_ok=True)
with open("web/src/data/ban_suc_recommendations.json", "w", encoding="utf-8") as f:
    json.dump(output_data, f, ensure_ascii=False, indent=2)

print(f"Successfully generated ban_suc_recommendations.json for {len(output_data['heroes'])} hero IDs across {len(hero_configs)} groups!")
