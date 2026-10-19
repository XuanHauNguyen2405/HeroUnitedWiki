# BẢNG ÁNH XẠ KHUNG THẺ TƯỚNG & QUY TẮC HIỂN THỊ (CARD FRAME MAPPING)

Báo cáo xác minh trực tiếp từ mã nguồn giải mã Lua (`scratch/lua_decrypted/game_util.lua`, `scratch/lua_decrypted/game_config.lua`, `game_hero_info_pop.lua`, `game_hero_super_evolution.lua`) và cấu hình game (`character_break_new.config`, `character_detail.config`).

---

## 1. Phân Biệt Các Hệ Thống (Tránh Nhầm Lẫn)

| Hệ Thống | Phạm Vi Mốc | Tác Động Giao Diện Thẻ | Nguồn Xác Minh |
| :--- | :--- | :--- | :--- |
| **Phẩm Chất Cơ Bản (Quality)** | Phẩm 0 đến 8 (Trắng, Lục, Lam, Tím, Cam, Đỏ, Vàng, Màu, Cầu Vồng) | Quyết định khung thẻ ban đầu (`card_q_bg*.png`) | `game_config.lua:4` (`HERO_QUALITY_COLOR_TABLE`) |
| **Siêu Tiến Hoá (Super Evolution)** | Mốc 1 đến 8 (Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++) | Thay đổi màu sắc & hoa văn viền khung thẻ (`card_q_bg*.png`) | `game_config.lua:42` (`HERO_QUALITY_COLOR_TABLE_2`) & `game_util.lua:2243` |
| **Chuyển Sinh (Rebirth / Bre)** | Chuyển 1 đến Chuyển 7 (Dũng Sĩ -> Đấu Sĩ -> Anh Hùng -> Thần Thoại -> Thần -> Linh -> Hồn) | Thêm tiền tố tên, số sao/trăng góc trái, huy hiệu chuyển sinh cánh chim/sư tử (`kpxq_break_1..7.png`) | `game_util.lua:2365`, `character_break_new.config` |
| **Cường Hoá (+1 đến +60)** | +0 đến +60 (Tiến hoá cơ bản tăng HP, Công, Thủ, Tốc Độ) | Thêm hậu tố `+{step}` ngay sau tên tướng (ví dụ `+60`, `+53`, `+3`). **Không đổi màu khung thẻ** | `game_util.lua:8312` |
| **Đột Phá Nguyên Tố (Element Breakthrough)** | Cấp 1 đến 20 | Huy hiệu lục giác cánh thiên thần `bt_element.png` kèm số cấp độ bên trong | `ui_hero_info_pop.ccbi`, `game_hero_info_pop.lua:304` |
| **Hào Quang Chuyển Thế (Transferred Aura)** | Chỉ áp dụng cho bản Chuyển Thế (`is_world == true`) | Vòng hào quang lửa đỏ/tím rực rỡ phía sau lưng tướng (`anim_zhuanshi`). **Bản thường không có hào quang này** | `game_util.lua:185-192` |

---

## 2. Bảng Ánh Xạ Khung Thẻ Theo Siêu Tiến Hoá & Phẩm Chất

Ánh xạ chuẩn theo hàm `setHeroListItemInfoByTable` (`game_util.lua:2243-2246`):
```lua
local hero_quality_item = super_quality_1 > 0 and HERO_QUALITY_COLOR_TABLE_2[super_quality_1] or HERO_QUALITY_COLOR_TABLE[quality+1]
ccbNode:spriteForName("m_spr_bg"):setDisplayFrame(CCSpriteFrameCache:sharedSpriteFrameCache():spriteFrameByName(hero_quality_item.card_img))
```

### A. Bảng Khung Siêu Tiến Hoá (`super_quality_1` từ 1 đến 8)
| Mốc Siêu Tiến Hoá | Tên Hiển Thị | Tên File Asset Texture | Đặc Điểm Nhận Diện Khung |
| :--- | :--- | :--- | :--- |
| **Chưa kích hoạt** | Theo phẩm gốc | `card_q_bgOrange.png` (với tướng Cam) | Viền cam kim loại nguyên bản |
| **Mốc 1: Cam+** | `cam+` | `card_q_bgOrange1.png` | Viền cam, chân đế có hoa văn bọc vàng & viên ngọc đỏ |
| **Mốc 2: Cam++** | `cam++` | `card_q_bgOrange2.png` | Viền cam, góc trên có rồng vàng ngự trị, chân đế có cánh hoa văn & ngọc đỏ |
| **Mốc 3: Đỏ** | `đỏ` | `card_q_bgRed.png` | Viền đỏ viền kép dát vàng nguyên bản (Chuẩn theo ảnh Frieren) |
| **Mốc 4: Đỏ+** | `đỏ+` | `card_q_bgRed1.png` | Viền đỏ, chân đế hoa văn bọc vàng & viên ngọc đỏ |
| **Mốc 5: Đỏ++** | `đỏ++` | `card_q_bgRed2.png` | Viền đỏ, góc trên có rồng vàng ngự trị, chân đế có cánh hoa văn & ngọc đỏ |
| **Mốc 6: Vàng** | `Vàng` | `card_q_bgYellow.png` | Viền hoàng kim sáng chói |
| **Mốc 7: Vàng+** | `Vàng+` (Màu) | `card_q_bgGolden1.png` | Viền hoàng kim lấp lánh, chân đế có hoa văn thần thánh & ngọc đỏ |
| **Mốc 8: Vàng++** | `Vàng++` (Cầu vồng) | `card_q_bgGolden2.png` | Viền hoàng kim thần thoại, có rồng thần uốn lượn góc trên & cánh thần chân đế |

### B. Bảng Khung Phẩm Chất Gốc (Khi chưa Siêu Tiến Hoá)
| Phẩm Chất (Quality) | Tên Phẩm | Tên File Asset Texture |
| :--- | :--- | :--- |
| Phẩm 0 | Trắng | `card_q_bgGrey.png` |
| Phẩm 1 | Lục | `card_q_bgGreen.png` |
| Phẩm 2 | Lam | `card_q_bgBlue.png` |
| Phẩm 3 | Tím | `card_q_bgPurple.png` |
| Phẩm 4 | Cam | `card_q_bgOrange.png` |
| Phẩm 5 | Đỏ | `card_q_bgRed.png` |
| Phẩm 6 | Vàng | `card_q_bgYellow.png` |
| Phẩm 7 | Màu (Thần) | `card_q_bgGolden1.png` |
| Phẩm 8 | Cầu vồng (Thánh) | `card_q_bgGolden2.png` |

---

## 3. Bảng Ánh Xạ Chuyển Sinh (`bre` từ 0 đến 7)

Căn cứ từ `character_break_new.config` và hàm `game_util:getCardName` (`game_util.lua:8306-8324`):

| Mốc `bre` | Tiền Tố Danh Xưng | Biểu Tượng Chuyển Sinh (`kpxq_break`) | Hiển Thị Sao / Trăng Trên Thẻ |
| :--- | :--- | :--- | :--- |
| **0** | *(Không có)* | *(Không hiển thị)* | 0 sao |
| **1 (Chuyển 1)** | `Dũng Sĩ·` | `kpxq_break_1.png` (Đấu sĩ lam cánh chim, 1 sao) | 1 sao vàng (`public_equip_star.png`) |
| **2 (Chuyển 2)** | `Đấu Sĩ·` | `kpxq_break_2.png` (Đấu sĩ lam cánh chim, 2 sao) | 2 sao vàng |
| **3 (Chuyển 3)** | `Anh Hùng·` | `kpxq_break_3.png` (Đấu sĩ lục cánh chim, 3 sao) | 3 sao vàng (Khớp mẫu Frieren) |
| **4 (Chuyển 4)** | `Thần Thoại·` | `kpxq_break_4.png` (Đấu sĩ vàng cánh chim, 4 sao) | 4 sao vàng |
| **5 (Chuyển 5)** | `Thần·` | `kpxq_break_5.png` (Đấu sĩ vàng cánh chim, 5 sao) | 5 sao vàng |
| **6 (Chuyển 6)** | `Linh·` | `kpxq_break_6.png` (Huy hiệu đầu sư tử vàng, 1 ngọc hoàng kim) | 1 trăng khuyết (`public_moon_icon.png`) |
| **7 (Chuyển 7)** | `Hồn·` | `kpxq_break_7.png` (Huy hiệu đầu sư tử vàng, 2 ngọc hoàng kim) | 2 trăng khuyết (Khớp mẫu Hồn·Nagato) |

---

## 4. Bảng Ánh Xạ Đột Phá Nguyên Tố (`element_break` 1-20)
| Cấp Đột Phá | Biểu Tượng | Con Số Hiển Thị | Nguồn Mã Nguồn |
| :--- | :--- | :--- | :--- |
| Cấp 1 - 20 | `bt_element.png` (Huy hiệu lục giác cánh thiên thần vàng) | Số cấp độ `1` .. `20` màu trắng viền đen ở tâm huy hiệu | `game_hero_info_pop.lua:304-305` |

---

## 5. Quy Tắc Lớp Ảnh (Layering & Pop-out)

Để tái hiện chính xác thẻ tướng như trong game:
1. **Lớp 1 (Aura Chuyển Thế - Nền sâu nhất)**:
   - Nếu là Dạng Chuyển Thế (`is_world == true`): Render `aura_zhuanshi.png` với hiệu ứng tỏa sáng đỏ tím phía sau lưng tướng.
   - Nếu là Dạng Thường (`is_world == false`): Không có hào quang này.
2. **Lớp 2 (Khung Nền Thẻ - Card Frame)**:
   - Ảnh khung `card_q_bg*.png` tương ứng với mốc siêu tiến hoá / phẩm chất.
3. **Lớp 3 (Hình Tướng - Hero Visual)**:
   - Đặt trong khung nhưng nhô lên trên đỉnh khung ~15-25% (`overflow: visible`), tuyệt đối không cắt tóc, đầu, hay vũ khí của tướng.
4. **Lớp 4 (Huy Hiệu & Cấp Độ - Overlay)**:
   - Góc trên bên trái: Vòm sao (1-5 sao vàng hoặc 1-2 trăng khuyết).
   - Góc trên bên phải: Huy hiệu Chuyển Sinh (`kpxq_break_*.png`).
   - Cạnh bên phải tướng: Huy hiệu Đột Phá nguyên tố (`bt_element.png` với số 1-20).
   - Tấm biển kim loại phía dưới khung: Dòng chữ `Lv.255/255`.
   - Góc dưới bên trái hoặc bên phải khung: Biểu tượng nghề nghiệp `public_ocupation*.png` lồng trong `card_race_bg.png`.
5. **Lớp 5 (Thanh Tên Tướng)**:
   - Dưới chân thẻ: `[Tiền Tố Chuyển Sinh]·[Tên Tướng] +[Cấp Cường Hoá]` (ví dụ: `Hồn·Nagato+60`, `Anh Hùng·Bikini - Frieren +53`, `Thần·Vegeta+60`).
