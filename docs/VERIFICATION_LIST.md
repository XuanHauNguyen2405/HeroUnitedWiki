# DANH SÁCH DỮ LIỆU CẦN XÁC MINH (VERIFICATION LIST)
### Dự án: Siêu Anh Hùng Hội Tụ WIKI (SAHHT WIKI)
**Phiên bản:** 1.2.0 | **Thời điểm cập nhật:** 18/10/2026

> **Tuân thủ Nguyên tắc 3 & Yêu cầu chất lượng dữ liệu:**
> - *"Không tự tạo tên tướng, số liệu, công thức, ý nghĩa mã hoặc liên kết còn thiếu. Dùng `null` và ghi vào danh sách cần xác minh."*
> - *"Dùng 'Chưa có dữ liệu' cho kỹ năng thiếu định nghĩa; không tự kết luận là nội tại ẩn, chưa mở khóa hay thử nghiệm."*
> - *"Tách bạch rõ ràng số lượt tham chiếu thiếu khỏi số ID riêng biệt."*
> - *"Xử lý tài nguyên trùng tên bằng trạng thái ambiguous và mảng candidates ứng viên."*

Tài liệu này ghi nhận toàn bộ các trường hợp dữ liệu khuyết thiếu, bản ghi không tên, liên kết ngoại chưa khớp, kết quả đối chiếu tài nguyên và kiểm tra hồi quy đột biến.

---

## 1. Tướng khuyết thiếu tên (`heroes.json`)

Trong 721 bản ghi tướng tại `character_detail.config`, có **02 bản ghi** có trường tên (`name`) rỗng `""`. Trong dữ liệu xuất ra, các trường này được gán giá trị `null` và ghi nhận trạng thái khách quan:

| ID bản thể | `character_ID` | Ảnh tham chiếu (`image.ref`) | Trạng thái ảnh | Phẩm chất | Ghi chú từ `story` gốc | Đề xuất xác minh |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`57`** | `1007` | `icon_ling4.png` | `not_found` | 6 | "转世的灵魂转生时使用的特殊魂魄" | Bản ghi mang đặc điểm phôi linh hồn chuyển sinh dùng làm nguyên liệu tiến hóa. Cần chuyên viên vận hành xác nhận tên hiển thị chính thức trong game. |
| **`58`** | `1008` | `icon_ling5.png` | `not_found` | 6 | "转世的灵魂超进化时使用的特殊魂魄" | Bản ghi mang đặc điểm phôi linh hồn siêu tiến hóa. Cần chuyên viên vận hành xác nhận tên hiển thị chính thức trong game. |

---

## 2. Kỹ năng khuyết thiếu tên (`skills.json`)

Trong 10.836 kỹ năng trích xuất từ `skill_detail.config`, có **28 kỹ năng** có trường `skill_name` là chuỗi rỗng. Các bản ghi này được gán `name: null`:

- **Danh sách 28 ID:**  
  `70010`, `77111`, `77112`, `77113`, `77114`, `77115`, `77116`, `77117`, `77120`, `77121`, `77122`, `77123`, `77124`, `77125`, `77126`, `77127`, `77130`, `77131`, `77132`, `77133`, `77134`, `77135`, `77136`, `77137`, `77140`, `77150`, `77160`, `77170`.
- **Hiện trạng xử lý:** Bảo tồn nguyên vẹn các thông số chiến đấu gốc (`cd`, `rate`, `effect`, `skill_type`, `action`) và gán `name: null`. Không tự đặt tên thay thế.

---

## 3. Vật phẩm khuyết thiếu tên (`items.json`)

Trong 3.707 vật phẩm tại `item.config`, có **19 vật phẩm** có trường `name` là chuỗi rỗng. Các bản ghi này được gán `name: null`:

- **Danh sách 19 ID:**  
  `2116`, `2117`, `2118`, `2119`, `2120`, `2121`, `2122`, `2123`, `2128`, `2129`, `2130`, `2131`, `2136`, `2137`, `2138`, `2139`, `511146`, `511147`, `522002`.

---

## 4. Kỹ năng được tướng tham chiếu nhưng thiếu định nghĩa trong `skill_detail.config`

Khi đối chiếu toàn bộ 2.788 lượt tham chiếu kỹ năng từ 721 tướng (`skill_1_source` đến `skill_7_source`):
- **Số lượt tham chiếu hợp lệ:** 2.637 lượt.
- **Số lượt tham chiếu thiếu (Missing Reference Occurrences):** **151 lượt**.
- **Số ID kỹ năng riêng biệt bị thiếu (Distinct Missing Skill IDs):** **150 ID**.
- **Chi tiết phân tách:**
  - Có 149 ID kỹ năng bị thiếu xuất hiện đúng 1 lần.
  - Có **01 ID kỹ năng (`80040`)** được tham chiếu **2 lần** (bởi tướng `74100` và tướng `74101` - đều mang tên *"Quái Nhân Dây Xích"* tại ô kỹ năng 1).
- **Quy chuẩn hiển thị:**
  - Trong `heroes.json`, các kỹ năng này có `skill_id` nguyên bản, `skill_name: "Chưa có dữ liệu"` và `status: "missing_definition"`.
  - **Lưu ý kiểm định:** Không đưa ra nhận định chủ quan về việc các kỹ năng này là "nội tại ẩn", "chưa mở khóa" hay "thử nghiệm". Trạng thái kỹ thuật khách quan là: **Kỹ năng được tham chiếu trong character_detail.config nhưng không tồn tại bản ghi trong skill_detail.config.**

---

## 5. Mảnh trang bị của bộ thiếu định nghĩa trong `equip.config`

Trong 729 bộ trang bị tại `suit.config` (tổng cộng 2.916 lượt tham chiếu mảnh):
- **Hợp lệ:** 2.908 lượt.
- **Lượt tham chiếu thiếu:** **8 lượt** tương ứng với **8 ID trang bị riêng biệt**:

| Mã bộ (`suit_id`) | Tên bộ trang bị | Mã mảnh thiếu | Vị trí dự kiến |
| :--- | :--- | :--- | :--- |
| `150` | 真の誓言 | `12004`, `22004`, `32004`, `42004` | Cả 4 vị trí của bộ 150 |
| `307` | 神の忍术 | `25007`, `35007`, `45007` | 3 vị trí của bộ 307 |
| `1310` | 仙の佩恩 | `107105` | Vị trí thứ 1 của bộ 1310 |

---

## 6. Công thức tiến hóa trang bị thiếu trong `equip_evolution.config`

Trong 3.451 trang bị có tham chiếu công thức tiến hóa (`evolution_id > 0`):
- **Hợp lệ:** 3.442 lượt.
- **Lượt tham chiếu thiếu:** **9 lượt** tương ứng với **9 ID công thức riêng biệt**:  
  `107005`, `107105`, `107205`, `107305`, `207005`, `207105`, `207205`, `207305`, `307005`.

---

## 7. Mục tiêu tiến hóa kỹ năng tiếp theo thiếu trong `skill_detail.config`

Trong 8.019 kỹ năng có trường `is_evolution > 0`:
- **Hợp lệ:** 7.918 lượt.
- **Lượt tham chiếu thiếu:** **101 lượt** tương ứng với **81 ID kỹ năng mục tiêu riêng biệt**.

---

## 8. Khôi phục `equip_id` và phân tích khác biệt với Khóa chính

Trong quá trình rà soát đối chiếu, phát hiện giả định trước đây cho rằng `equip_id` "trùng lặp với key" là sai lệch:
- **Thống kê thực tế:** Có đến **4.217 / 4.366 trang bị (96.59%)** có giá trị `equip_id` **khác biệt hoàn toàn** với khóa chính (`key`).
- **Ý nghĩa cấu trúc:**
  - Đối với các trang bị cấp cơ bản (ví dụ ID `16401` - Đao Ninja), `equip_id` mang giá trị `164` (mã chuỗi dòng trang bị hoặc liên kết hệ thống).
  - Đối với các trang bị tiến hóa cao cấp (ví dụ ID `16404` - Đao Ninja.Chân), `equip_id` mang giá trị `16401` (trỏ ngược về phôi trang bị gốc sơ cấp).
- **Hành động kỹ thuật:** Đã khôi phục hoàn toàn trường `equip_id` (kiểu chuỗi) và `raw_equip_id` (số nguyên gốc) cùng trường `effect` vào [equipment.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/equipment.json), đối chiếu khớp 100% từng bản ghi với nguồn.

---

## 9. Xử lý tài nguyên trùng tên (Ambiguous Assets) và Kết quả sau khi tích hợp APK

- **Tổng số tài nguyên tướng được phân giải (Sau khi hợp nhất APK):**
  - **Ảnh chân dung/đại diện:** `found`: **683 / 721 (94.73%)**, `ambiguous`: **0**, `not_found`: **38**.
  - **Hoạt họa (Animation plist/swf):** `found`: **672 / 721 (93.20%)**, `ambiguous`: **14** (kèm danh sách ứng viên), `not_found`: **35**.
- **Quy chuẩn cấu trúc:** Trạng thái được lưu rõ ràng tại `assets.image.status` và `assets.animation.status = "ambiguous"` kèm danh sách toàn bộ các đường dẫn ứng viên tại `candidates`.

---

## 10. Kết quả kiểm tra đột biến thực tế (Mutation Testing on Clones)

Bộ kiểm tra đột biến trong [validate_pipeline.py](file:///c:/Users/Utente/Desktop/SAHHT_export/tools/validate_pipeline.py) đã thực hiện trực tiếp trên các bản sao sâu (`copy.deepcopy`), **gọi trực tiếp các hàm kiểm tra trong validator** thay vì viết điều kiện kiểm tra riêng:
1. **Đột biến 1 (Sửa sai HP):** Thay đổi `base_stats.hp` của tướng `8200` từ 2074 thành 999999 -> Gọi hàm `reconcile_heroes` -> Phát hiện chính xác sai lệch trường `growth_stats`/`base_stats` so với nguồn -> **ĐẠT (PASSED)**.
2. **Đột biến 2 (Sửa sai kiểu ID):** Thay đổi `character_id` của tướng `8200` thành `int(82)` -> Gọi hàm `check_hero_id_types` -> Phát hiện chính xác kiểu dữ liệu không phải chuỗi -> **ĐẠT (PASSED)**.
3. **Đột biến 3 (Sửa sai liên kết bộ):** Thay đổi `suit_id` của trang bị `16401` thành `"CORRUPTED_SUIT_99999"` -> Gọi hàm `check_equip_suit_links` -> Phát hiện và ghi cảnh báo liên kết hỏng/đích không tồn tại -> **ĐẠT (PASSED)**.
4. **Đột biến 4 (Mất giá trị 0):** Thay đổi `assets.action` của kỹ năng `65536` từ `0` thành `None` -> Gọi hàm `reconcile_skills` -> Phát hiện sai lệch trường action không bảo toàn giá trị 0 -> **ĐẠT (PASSED)**.
5. **Đột biến 5 (Đổi sang ID hợp lệ nhưng sai đối tượng):** Thay đổi `suit_id` của Đao Ninja (`16401`) từ `"53"` thành `"1"` (bộ tồn tại trong bảng bộ nhưng sai đối tượng trang bị) -> Gọi hàm `reconcile_equipment` -> Phát hiện chính xác `equip[16401].suit_id: output '1' != source '53'` -> **ĐẠT (PASSED)**.

---

## 11. Kiểm tra liên kết `equipment.suit_id`: Phân biệt thiếu từ nguồn với đích không tồn tại

Trong dữ liệu trang bị [equipment.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/equipment.json) và cấu hình gốc `equip.config`:
- **Liên kết thiếu từ nguồn (Unsuited Equipment - 133 bản ghi):** Nguồn mang giá trị `suit: 0` (hoặc thiếu trường `suit`). Đây là các trang bị đứng lẻ tự nhiên, không thuộc bất kỳ bộ trang bị nào theo thiết kế game. Trường `suit_id` được gán chuẩn `null`. Đây là trạng thái hợp lệ, hoàn toàn không phải lỗi hay cảnh báo đích hỏng.
- **Liên kết bộ hợp lệ (Valid Suited Equipment - 4.233 bản ghi):** Nguồn mang giá trị `suit > 0` và mã `suit_id` tồn tại trong [equipment_sets.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/equipment_sets.json). 100% bản ghi này được kết nối thành công.
- **Liên kết hỏng / đích không tồn tại (Broken Suit Target - 0 bản ghi):** Trường hợp nguồn có `suit > 0` nhưng ID không tồn tại trong `suit.config`. Bộ kiểm tra [validate_pipeline.py](file:///c:/Users/Utente/Desktop/SAHHT_export/tools/validate_pipeline.py) đã tích hợp hàm `check_equip_suit_links` tự động ghi nhận cảnh báo (`warning`) riêng biệt khi phát hiện đích không tồn tại (đã được minh chứng qua Mutation Test 3).

---

## 12. Cập nhật và kiểm định tệp `ignored_fields.json`

Tệp [ignored_fields.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/ignored_fields.json) đã được cập nhật toàn diện:
- Loại bỏ hoàn toàn ghi nhận bỏ qua đối với `equip_id` và `effect` trong `equip.config`.
- Xác nhận 100% các trường dữ liệu từ các tệp cấu hình cốt lõi (`character_detail.config`, `equip.config`, `skill_detail.config`, `suit.config`, `item.config`) đều đã được ánh xạ đầy đủ (`[]` trường bị bỏ qua).
- Ghi nhận lịch sử khôi phục minh bạch trong mảng `restored_fields` bao gồm: `equip_id`, `effect`, `rgb_sort`, `occupation_shade`, `is_notice`, `attack_effect`.
- Hàm `check_ignored_fields_manifest` trong validator tự động kiểm định tính toàn vẹn của tệp này ở mỗi lượt chạy kiểm thử.

---

## 13. Bộ mẫu giao diện đối chiếu thực tế (In-Game Preview Samples)

Đã xây dựng và cập nhật toàn diện tại [preview/](file:///c:/Users/Utente/Desktop/SAHHT_export/preview) với giao diện dark-mode hiện đại, hiển thị trực quan dữ liệu đã trích xuất để so sánh với in-game:
- **Tướng:** Lục Đạo Sasuke (`84000`) kèm icon thực tế, chỉ số khởi đầu, tăng trưởng, 7 kỹ năng có đủ 7 icon thực tế, duyên phận và mốc thức tỉnh/đột phá.
- **Kỹ năng:** Chidori (`76510`) kèm icon:
  - Loại bỏ đơn vị giây `s` tại `cd: 3` và `pre_cd: 0`, hiển thị giá trị nguồn kèm nhãn *"Chưa xác minh cách tính/đơn vị"*.
  - Giá trị `attr_effect: 550` không tự gán nhãn sát thương Hỏa (mô tả Chidori ghi rõ "100% ST thuộc tính Hỏa", chưa xác minh cơ chế trường attr_effect), hiển thị giá trị nguồn kèm nhãn *"Chưa xác minh cách tính/đơn vị"*.
  - Giá trị `effect_lvchange: 2.0` không tự định dạng "+2%/cấp", hiển thị giá trị nguồn kèm nhãn *"Chưa xác minh cách tính/đơn vị"*.
  - Chuỗi tiến hóa 3 giai đoạn hiển thị giá trị `effect` gốc.
- **Bộ trang bị:**
  - Bộ Chú Nguyền Sasuke (`1710`): 4 món có đủ 4 ảnh thực tế (Kiếm Kusanagi - Vũ khí, Obi Rắn - Trang sức, Áo Sasuke - Giáp/Áo, Giày Sasuke - Giày).
  - Bộ Thần Đồng (`53`): Chứa Đao Ninja (`16401`), trọn bộ 4 mảnh (`e_br_sword`, `e_br_cloak`, `e_br_crown`, `e_br_shoe`) nay đã hiển thị ảnh thực tế được trích xuất từ APK (`output/apk_extracted/assets/iphonehd/icon/`). Mọi ảnh chưa tìm thấy trên toàn hệ thống đều hiển thị nhãn *"Chưa tìm thấy ảnh"*.

---

## 14. Tích hợp APK chính thức (`apk/game.apk`) và Bảng liên kết ảnh (`output/asset_manifest.json`)

- **Thông tin gói và phiên bản:**
  - Tệp: `apk/game.apk` (951.46 MB, SHA-256: `d8085fc187f1b72d334e5200ef896fb6a8970395e6093e371e35ac81279ccee6`).
  - Gói ứng dụng: `com.kaiqigu.cjyxyn.kvsdk`
  - Phiên bản: `1.9` (Version Code: `10`), Target SDK: `28`.
  - Thông tin đầy đủ lưu tại: [output/apk_extracted/apk_info.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/apk_extracted/apk_info.json).
- **Thư mục giải nén:** Toàn bộ 15.287 tệp tin được giải nén vào `output/apk_extracted/` (1.27 GB).
- **Bảng liên kết ảnh:** [output/asset_manifest.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/asset_manifest.json) (10.84 MB) đối chiếu toàn bộ tham chiếu ảnh trong JSON với `Resources/` và `output/apk_extracted/`.
- **Kết quả giải quyết ảnh:**
  - Ảnh đại diện Tướng: **683 / 721 (94.73%)** tìm thấy, 0 trùng tên, 38 chưa tìm thấy.
  - Hoạt ảnh Tướng: **672 / 721 (93.20%)** tìm thấy, 14 trùng tên có danh sách ứng viên, 35 chưa tìm thấy.
  - Icon Kỹ năng: **10.396 / 10.836 (95.94%)** tìm thấy, 0 trùng tên, 332 chưa tìm thấy (108 rỗng từ nguồn).
  - Icon Trang bị: **4.318 / 4.366 (98.90%)** tìm thấy, 0 trùng tên, 48 chưa tìm thấy.
  - Icon Vật phẩm: **3.677 / 3.707 (99.19%)** tìm thấy, 24 trùng tên có danh sách ứng viên, 4 chưa tìm thấy (2 rỗng từ nguồn).
- **Bảo toàn nguồn:** Tệp APK và dữ liệu gốc trong `config/`, `Resources/`, `lua/` được bảo toàn nguyên vẹn 100%.

---

## 15. Thư mục ảnh độc lập `public/assets/` và Kiểm tra tính độc lập tuyệt đối

- **Thư mục ảnh độc lập:** Đã khởi tạo [public/assets/](file:///c:/Users/Utente/Desktop/SAHHT_export/public/assets) lưu trữ toàn bộ 3.987 tệp tài nguyên (trong đó có 2.878 tệp ảnh PNG/JPG, 63.57 MB).
- **Quy tắc bảo vệ trùng tên:**
  - Giữ nguyên cấu trúc cây thư mục con (`iphonehd/icon/`, `iphonehd/img/`, `iphonehd/anim/`, `iphonehd/card/`, `sound/`, `lua/`).
  - Các tệp trùng tên nhưng khác nội dung (như `iphonehd/img/ma.png` và `iphonehd/icon/ma.png`) được phân tách tại các thư mục tương ứng, tuyệt đối không bị ghi đè.
- **Cập nhật dữ liệu:** Toàn bộ [output/heroes.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/heroes.json), [output/skills.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/skills.json), [output/equipment.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/equipment.json), [output/items.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/items.json), [output/asset_manifest.json](file:///c:/Users/Utente/Desktop/SAHHT_export/output/asset_manifest.json) và các trang [preview/](file:///c:/Users/Utente/Desktop/SAHHT_export/preview) đều trỏ trực tiếp tới `public/assets/`.
- **Kiểm tra tính độc lập ([tools/test_independence.py](file:///c:/Users/Utente/Desktop/SAHHT_export/tools/test_independence.py)):**
  - Tạm đổi tên `apk/` $\rightarrow$ `apk_temp_isolated/` và `output/apk_extracted/` $\rightarrow$ `output/apk_extracted_temp_isolated/`.
  - Kết quả:
    * 68 lượt thẻ `<img>` trên 4 trang mẫu đều tải thành công, không có liên kết hỏng.
    * 24.247 lượt đường dẫn trong JSON: 0 tham chiếu phụ thuộc thư mục cũ.
    * Bộ kiểm tra [validate_pipeline.py](file:///c:/Users/Utente/Desktop/SAHHT_export/tools/validate_pipeline.py) đạt 100% với 0 lỗi cấu trúc và 5/5 bài kiểm tra đột biến đạt.
  - Khôi phục an toàn thư mục gốc sau kiểm thử.


