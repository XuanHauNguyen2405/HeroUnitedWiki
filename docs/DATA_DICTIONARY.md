# TỪ ĐIỂN DỮ LIỆU - SIÊU ANH HÙNG HỘI TỤ WIKI (SAHHT WIKI)
**Phiên bản Schema:** 1.2.0  
**Ngày cập nhật:** 18/10/2026  
**Trạng thái chuẩn hóa:** Bảo toàn 100% trường nguồn gốc, ID chuỗi, phân định trạng thái tài nguyên đa ứng viên (ambiguous).

---

## 1. Tướng (Heroes / Characters) - `output/heroes.json`

- **Tệp nguồn:** `config/character_detail.config`
- **Số lượng bản ghi:** 721 bản ghi (352 base `character_ID` riêng biệt)
- **Khóa chính (PK):** `id` (chuỗi, ví dụ: `"8200"`, `"61100"`, `"1"`)

| Tên trường | Kiểu dữ liệu | Cho phép Null | Nguồn gốc | Mô tả / Ý nghĩa |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `String` | Không | Key của dict | Mã định danh duy nhất của bản ghi tướng/biến thể |
| `character_id` | `String` | Có | `character_ID` | Mã định danh nhóm tướng cơ bản (Base Hero ID). Chuyển thành chuỗi |
| `name` | `String` | Có | `name` | Tên tướng (tiếng Việt). Bằng `null` nếu nguồn để trống (bản ghi `'57'`, `'58'`) |
| `quality` | `Integer` | Có | `quality` | Phẩm chất tướng (0: Thường, 1-6: Phẩm chất sao/màu sắc) |
| `star` | `Integer` | Có | `star` | Số sao khởi đầu (0, 1, 2, 6) |
| `star_max` | `Integer` | Có | `star_max` | Số sao tối đa có thể đạt được |
| `career` | `Integer` | Có | `career` | Mã nghề nghiệp gốc (0-5). Giữ nguyên số nguyên gốc |
| `race` | `Integer` | Có | `race` | Mã chủng tộc gốc (0-5). Giữ nguyên số nguyên gốc |
| `sex` | `Integer` | Có | `sex` | Giới tính (1: Nam, 2: Nữ, 0: Phi giới tính) |
| `type` | `Integer` | Có | `type` | Phân loại thẻ bài |
| `streng` | `Integer` | Có | `streng` | Cấp độ cường hóa mặc định ban đầu |
| `level_max` | `Integer` | Có | `level_max` | Cấp độ tối đa của bản thể |
| `call_price` | `Integer` | Có | `call_price` | Giá trị chiêu mộ / đổi |
| `skill_num` | `Integer` | Có | `skill_num` | Số lượng kỹ năng được cấu hình |
| `exchange_id` | `Integer` | Có | `exchange_id` | Mã liên kết cửa hàng đổi thưởng |
| `is_only` | `Integer` | Có | `is_only` | Cờ thẻ duy nhất |
| `rebirth` | `Integer` | Có | `rebirth` | Mốc chuyển sinh |
| `rgb_sort` | `Integer` | Có | `rgb_sort` | Thứ tự phân loại màu sắc hiển thị nguồn |
| `occupation_shade` | `Integer` | Có | `occupation_shade` | Độ lệch bóng đổ nghề nghiệp nguồn |
| `is_notice` | `Integer` | Có | `is_notice` | Cờ thông báo nguồn |
| `base_stats` | `Object` | Không | Nhóm `base_*` | Chỉ số cơ bản lúc cấp 1: `hp`, `patk`, `matk`, `def`, `speed` |
| `growth_stats` | `Object` | Không | Nhóm `growth_*` | Chỉ số tăng trưởng mỗi cấp: `hp`, `patk`, `matk`, `def`, `speed` |
| `skills` | `Array[Object]`| Không | `skill_1_source`..`7` | Danh sách kỹ năng: `slot` (1-7), `skill_id` (String), `level` (Int), `skill_name` (String hoặc `"Chưa có dữ liệu"` nếu thiếu định nghĩa trong bảng kỹ năng), `status` (`"valid"`, `"unnamed_skill"`, hoặc `"missing_definition"`) |
| `bonds` | `Array[Object]`| Không | `chain` -> `chain.config` | Duyên phận kích hoạt: `chain_id` (String), `name`, `description`, `required_characters` (Array[String]), `effects` |
| `story` | `String` | Có | `story` | Tiểu sử nhân vật. Giữ nguyên định dạng gốc |
| `short_story` | `String` | Có | `short_story` | Mô tả ngắn / tóm tắt |
| `assets` | `Object` | Không | `img`, `animation` | Đối tượng tài nguyên đa trạng thái gồm `image` và `animation`: `ref` (tên tham chiếu), `status` (`"found"`, `"ambiguous"`, `"not_found"`), `candidates` (mảng đường dẫn ứng viên), `path` (đường dẫn duy nhất nếu found) |
| `awakening` | `Object` | Không | `wake1`..`wake6` | Điều kiện và nguyên liệu thức tỉnh từ bậc 1 đến bậc 6 (mảng gốc) |
| `breakthrough` | `Object` | Không | `breakthrough_ids`, `break4`, `break5` | `breakthrough_ids`: mảng chuỗi ID liên kết sang `breakthrough.config` |
| `evolution` | `Object` | Không | `is_evo`, `super_evo`, `evo_kind`, `evo_food`, `is_skin` | Các thông số cơ chế tiến hóa tướng |
| `_source` | `Object` | Không | Metadata | Nguồn gốc truy xuất: `{"file": "character_detail.config", "key": "..."}` |

---

## 2. Kỹ năng (Skills) - `output/skills.json`

- **Tệp nguồn:** `config/skill_detail.config` (10.836 bản ghi)
- **Số lượng bản ghi:** 10.836
- **Khóa chính (PK):** `id` (chuỗi, ví dụ: `"8210"`)

| Tên trường | Kiểu dữ liệu | Cho phép Null | Nguồn gốc | Mô tả / Ý nghĩa |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `String` | Không | Key của dict | Mã kỹ năng dạng chuỗi |
| `name` | `String` | Có | `skill_name` | Tên kỹ năng. Bằng `null` nếu nguồn để trống (28 kỹ năng) |
| `quality` | `Integer` | Có | `skill_quality` | Phẩm chất kỹ năng (0 - 7) |
| `skill_type` | `String` | Có | `skill_type` | Kiểu kích hoạt: `KBEFOREATTACK`, `KBEFOREBATTLE`, `KBEATTACK`, `KBEFOREHERT`, `KBEFOREROUND`, `KDEAD`, `KATTACK` |
| `cd` | `Integer` | Có | `cd` | Thời gian hồi chiêu (lượt). Giữ nguyên 0 nếu nguồn là 0 |
| `pre_cd` | `Integer` | Có | `pre_cd` | Hồi chiêu trước trận. Giữ nguyên 0 nếu nguồn là 0 |
| `rate` | `Integer` | Có | `rate` | Tỉ lệ kích hoạt (%) |
| `attr_effect` | `Integer` | Có | `attr_effect` | Hệ số hiệu ứng thuộc tính |
| `effect` | `Integer` | Có | `effect` | Hệ số hiệu ứng chính (%) |
| `effect_talent` | `Float` | Có | `effect_talent` | Hệ số thiên phú cộng thêm |
| `effect_lvchange`| `Float` | Có | `effect_lvchange` | Mức tăng hiệu ứng theo cấp kỹ năng |
| `effect_delay` | `Integer` | Có | `effect_delay` | Độ trễ kích hoạt hiệu ứng |
| `is_learn` | `Integer` | Có | `is_learn` | Cờ có thể học |
| `evolution` | `Object` | Không | `is_evolution` | `raw_is_evolution`: giá trị số nguyên gốc (0 hoặc ID); `next_evolution_skill_id`: chuỗi ID kỹ năng tiến hóa tiếp theo (hoặc `null` nếu giá trị gốc là 0 = đã đạt cấp tối đa); `has_next_evolution`: boolean |
| `evo_food` | `Any` | Có | `evo_food` | Nguyên liệu thức ăn tiến hóa kỹ năng |
| `max_lv` | `Integer` | Có | `max_lv` | Cấp kỹ năng tối đa |
| `description` | `String` | Có | `skill_story` | Mô tả kỹ năng. Giữ nguyên chuỗi gốc chứa biến `%s`, `effect%` |
| `evo_description`| `String` | Có | `evo_story` | Mô tả điều kiện tiến cấp kỹ năng |
| `assets` | `Object` | Không | `skill_icon`, `sprite_py`, `action` | `icon`, `sprite_py` (đối tượng phân giải asset kèm candidates), `action` (giữ nguyên số nguyên 0, 1, 2, 3) |
| `attack_effect` | `Integer` | Có | `attack_effect` | Mã hiệu ứng hoạt họa tấn công nguồn |
| `resource` | `Object` | Không | `resource_type`, `resource_count` | Tài nguyên tiêu hao |
| `_source` | `Object` | Không | Metadata | Nguồn gốc truy xuất: `{"file": "skill_detail.config", "key": "..."}` |

---

## 3. Trang bị (Equipment) - `output/equipment.json`

- **Tệp nguồn:** `config/equip.config`
- **Số lượng bản ghi:** 4.366
- **Khóa chính (PK):** `id` (chuỗi, ví dụ: `"16401"`)

| Tên trường | Kiểu dữ liệu | Cho phép Null | Nguồn gốc | Mô tả / Ý nghĩa |
| :--- | :--- | :--- | :--- | :--- |
| `id` | `String` | Không | Key của dict | Mã trang bị dạng chuỗi |
| `name` | `String` | Có | `name` | Tên trang bị |
| `quality` | `Integer` | Có | `quality` | Phẩm chất trang bị (1 - 8) |
| `slot` | `Integer` | Có | `sort` | Mã vị trí trang bị: `1`, `2`, `3`, `4` |
| `slot_name` | `String` | Có | Ánh xạ từ `sort` | **1: "Vũ khí", 2: "Trang sức", 3: "Giáp/Áo", 4: "Giày"** *(Mức độ xác minh: Đối chiếu tĩnh 100% từ tên món, icon sprite và quy luật mở khóa vị trí trang bị trong badge_txet.config; chưa can thiệp runtime client game)* |
| `equip_id` | `String` | Không | `equip_id` | **Khôi phục hoàn toàn:** Mã định danh nhánh trang bị dạng chuỗi (khác biệt với key ở 4.217 bản ghi, liên kết phôi trang bị gốc hoặc chuỗi dòng) |
| `raw_equip_id` | `Integer` | Không | `equip_id` | Giá trị số nguyên gốc của `equip_id` |
| `effect` | `Integer` | Có | `effect` | **Khôi phục hoàn toàn:** Chỉ số hiệu ứng trang bị nâng cao từ nguồn |
| `suit_id` | `String` | Có | `suit` | Mã chuỗi liên kết sang `suit.config`. `null` nếu nguồn là 0 hoặc thiếu |
| `suit_name` | `String` | Có | `suit.config` | Tên bộ trang bị tương ứng |
| `primary_stat` | `Object` | Không | `ability1`, `value1`, `level_add1` | Chỉ số chính (ability_id: mã chỉ số, value: giá trị, level_add: tăng mỗi cấp) |
| `secondary_stat`| `Object` | Không | `ability2`, `value2`, `level_add2` | Chỉ số phụ (thường là Sinh lực: ability_id = 5) |
| `enhancement` | `Object` | Không | `equip_add1`, `activation`, `activation_level` | Mức cường hóa và điều kiện kích hoạt |
| `evolution` | `Object` | Không | `evolution`, `evolution_id` | `raw_evolution`: giá trị gốc; `next_evolution_equip_id`: mã chuỗi trang bị tiến hóa tiếp theo (hoặc `null` nếu là 0 = đã đạt phẩm chất tối đa); `raw_evolution_id`: giá trị gốc; `evolution_recipe_id`: mã chuỗi công thức tiến hóa sang `equip_evolution.config` (hoặc `null` nếu là 0) |
| `refine_id` | `Integer` | Có | `refine_id` | Mã tinh luyện trang bị |
| `chain_id` | `Integer` | Có | `chain_id` | Mã duyên phận/liên kết trang bị |
| `cd` | `Integer` | Có | `cd` | Thời gian hồi trang bị |
| `afterlife` | `Integer` | Có | `afterlife` | Thuộc tính luân hồi/chiến trường cõi âm |
| `skill_type` | `String` | Có | `skill_type` | Kiểu kỹ năng gắn kèm |
| `occupation1` | `Integer` | Có | `occupation1` | Giới hạn nghề sử dụng |
| `economy` | `Object` | Không | `sell_metal`, `exchange_id`, `is_resolve` | Thông số kinh tế: giá bán quặng, đổi điểm, cờ phân giải |
| `description` | `String` | Có | `des` | Mô tả trang bị |
| `assets` | `Object` | Không | `image`, `sprite_py` | `image`, `sprite_py` (đối tượng phân giải asset kèm trạng thái và danh sách candidates) |
| `_source` | `Object` | Không | Metadata | Nguồn gốc truy xuất: `{"file": "equip.config", "key": "..."}` |

---

## 4. Bộ trang bị (Equipment Sets / Suits) - `output/equipment_sets.json`

- **Tệp nguồn:** `config/suit.config` (729 bản ghi)
- **Khóa chính (PK):** `id` (chuỗi, ví dụ: `"1"`)
- **Trường:** `id`, `name`, `parts` (Array[String]), `part_details` (Array[Object]), `bonuses` (`2_piece`, `3_piece`, `4_piece`), `_source`.

---

## 5. Ban Sức (Empowerment System) - `output/ban_suc.json`

- `fate_rules`: 11 quy tắc Ban Sức Vận Mệnh từ `equip_gem_fate_txt.config`.
- `fate_skills`: 40 kỹ năng Ban Sức từ `equip_gem_fate_skill.config` (10 hệ đá: Aether, Titan, Hủy Diệt, Lãnh Chúa, Tinh Thần, Thần Thư, Quang Niên, Vương Tọa, Khởi Nguyên, Con Lắc).
- `fate_words`: 120 dòng thác ấn/điểm hóa từ `equip_gem_fate_word.config`.
- `fate_rune_characters`: 162 liên kết Rune với tướng từ `fate_rune_character.config`.
- `badges`: 112 Huy Hiệu nhân vật từ `badge.config`.
- `badge_rules`: 6 quy tắc tổ hợp Huy Hiệu từ `badge_txet.config`.
- `badge_combinations`: 9 kỹ năng tổ hợp đội hình từ `badge_skill_combination.config`.
- `badge_refinements`: 30 bậc tinh luyện vận mệnh từ `badge_refinement.config`.

---

## 6. Cơ chế nâng cấp (Upgrade Mechanisms) - `output/upgrade_mechanisms.json`

- `character_strengthen`: 60 cấp cường hóa tướng từ `character_strengthen.config` (bảo toàn nguyên vẹn giá trị 0).
- `character_break_new`: 393 cây đột phá tướng mới từ `character_break_new.config` (10 tầng, giải mã nguyên liệu thẻ tướng và đá chuyển sinh).
- `character_breakthrough`: 3.400 bậc đột phá thường từ `breakthrough.config`.
- `equipment_evolution`: 3.550 công thức tiến hóa trang bị từ `equip_evolution.config`.

---

## 7. Từ điển vật phẩm (Items Catalog) - `output/items.json`

- **Tệp nguồn:** `item.config` (3.707 bản ghi)
- **Trường:** `id`, `name`, `quality`, `sort`, `stack`, `is_sell`, `is_use`, `daily_use`, `use_num`, `use_effect`, `description`, `assets`.

## 8. Thuộc tính dùng chung trên website (25/10/2026)

- `web/src/data/game_definitions.json`: ánh xạ ability lấy từ PUBLIC_ABILITY_TABLE của Lua; nguyên tố dùng ID chuẩn fire/water/wind/earth, không dùng career/race/occupation/sort làm hệ. Màu và emoji là quy ước hiển thị wiki.
- `web/src/data/hero_combat_profiles.json`: từng record ID có công thức kỹ năng nguồn và điều kiện min_rebirth/min_super_evo; skill_unlocks đọc đúng super_evolution.config. Không có trường hệ bẩm sinh được xác nhận cho tướng.
- Trang bị: element_id có thể null, element_status và element_source cho biết hệ được đối chiếu từ công nguyên tố bộ; combat_effect giữ description, effect, occupation_ids, activation, activation_level và nguồn. Điều kiện hiệu ứng không đồng nghĩa với cấm mang đồ khác hệ.
- Đột phá: source_id/raw_abilities cho phép đối chiếu từng mốc; stats.attributes giữ công/phòng từng hệ, ele_atk/ele_def là tổng nhóm tương ứng. Không đảo 201–204 và 301–304.
- Danh mục tướng hiện giữ career/race/occupation_type đầy đủ, gồm 0. Mốc chuyển sinh theo key dạng và high_break của nguồn; không kế thừa cây của dạng khác.
- [Bảng mapping và giới hạn xác minh](ATTRIBUTE_MAPPING.md); [báo cáo và danh sách ảnh hưởng](EQUIPMENT_UX_AUDIT.md).
