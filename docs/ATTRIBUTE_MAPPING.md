# Bảng đối chiếu thuộc tính thực tế — 25/10/2026

Nguồn: `lua_decrypted/game_config.lua:PUBLIC_ABILITY_TABLE`; phép cộng bộ: `game_util.lua:getEquipSuit`. Màu/emoji là lựa chọn hiển thị của wiki, không phải enum game.

## Nguyên tố

| ID chuẩn | Công | Phòng | Tên Việt | Biểu tượng | Màu wiki |
|---|---:|---:|---|---|---|
| fire | 201 | 301 | Hỏa (Lửa) | 🔥 | #fca5a5 |
| water | 202 | 302 | Thủy (Nước) | 💧 | #7dd3fc |
| wind | 203 | 303 | Phong (Gió) | 🌪️ | #6ee7b7 |
| earth | 204 | 304 | Địa (Thổ) | ⛰️ | #fcd34d |

## Toàn bộ ability ID dùng trong trang bị và bộ

| ID nguồn | Ý nghĩa trong Lua | Khoá game | Số lần dùng |
|---:|---|---|---:|
| 1 | Vật công | patk | 1445 |
| 2 | Ma Công | matk | 1995 |
| 3 | Phòng ngự | def | 1262 |
| 4 | Tốc độ | speed | 1257 |
| 5 | HP | hp | 6211 |
| 201 | Hỏa công | fire | 125 |
| 202 | Thủy công | water | 98 |
| 203 | Phong công | wind | 209 |
| 204 | Địa công | earth | 114 |
| 301 | Hỏa phòng | fire_dfs | 559 |
| 302 | Thủy phòng | water_dfs | 560 |
| 303 | Phong phòng | wind_dfs | 559 |
| 304 | Địa phòng | earth_dfs | 559 |

## Những miền tách biệt

| Miền | Giá trị thực tế | Cách dùng |
|---|---|---|
| career | 0, 1, 2, 3, 4, 5 | ID nghề; chưa xác minh tên Việt, không dùng làm hệ |
| race | 0, 1, 2, 3, 4, 5 | ID tộc; không dùng làm hệ hoặc phe |
| occupation | 0, 1, 2, 4, 5, 6 | Từ occupation.config[animation], dùng biểu tượng nghề |
| occupation_shade | -1, 0, 1, 2, 3 | Điều kiện hiệu ứng occupation1; khác career/race |
| sort | 1, 2, 3, 4 (0 là Tạp vật trong Lua) | Vị trí món đồ, khác ability1 dù có thể trùng số |
| innate element | Không có trường trong character_detail.config | Không tự tạo hệ cố định cho tướng |
| damage type | Theo công thức mô tả kỹ năng: vật lý, ma pháp, thực, thuộc tính | Không chuyển tên nhân vật/lore thành hệ |
| faction / role | Chưa có enum được xác minh trong luồng này | Không ánh xạ career/race sang phe/vai trò |

## Phạm vi đối chiếu

- 721 dạng: 174 có ít nhất một công thức thuộc tính được bộ phân tích mô tả nguồn nhận diện; 547 còn lại không bị gán hệ giả hoặc nhận gợi ý mặc định. Điều này không chứng minh 547 dạng không có sát thương thuộc tính.
- 4.366 món: chưa thiết lập: 2177, fire: 497, earth: 456, wind: 844, water: 392.
- Toàn bộ 729 bộ và 20 biến thể / 160 bản ghi món con giáp đã đối chiếu bằng ID, cả thường và Cầu Vồng. Danh sách ID, công thức, điều kiện và nguồn đầy đủ: [attribute_reconciliation.json](attribute_reconciliation.json).
- 0 là hợp lệ ở career/race/occupation và chỉ số; không phải enum hệ. Thiếu/null/ID lạ không được thay thành earth, fire hoặc 0.
- Món không có một công nguyên tố duy nhất đã xác minh: giữ null. Không suy từ tên, màu, ảnh, thứ tự mảng hay chỉ số kháng.

## Đột phá và miền chưa xác minh

- `prepare_web_data.py:parse_abilitys` trước đây đảo 201–204 thành phòng và 301–304 thành công. Nay đọc chung định nghĩa Lua, giữ các khoá `fire/water/wind/earth` và `*_dfs` riêng biệt. 172 dạng / 3.440 hàng mốc website có regression đối chiếu từng hàng với `breakthrough.config`.
- Mốc mở kỹ năng 4/5 lấy `skill4_open/skill5_open` của đúng `super_evolution.config[character_detail.super_evo]`, không suy từ tên hay dùng một mốc chung cho mọi dạng.
- ID 501 trong `super_evolution.config:level_*_add` chưa có bằng chứng rằng cùng nghĩa với ID 501 của miền đá thánh trong PUBLIC_ABILITY_TABLE. Không cộng nó như chỉ số phòng phẳng. Xem `unverified_progression_ability_ids` trong báo cáo máy đọc.
- `occupation_shade=-1`, activation khác rỗng/0, hoặc activation_level khác 0 được trả về trạng thái cần xác minh. Toàn bộ activation_level thực tế đang bằng 0; không đoán đó là cấp tướng hay cấp đồ.
- Xếp hạng hiện đối chiếu chỉ số công cộng trực tiếp. Chưa xác minh công thức DPS thực chiến, thứ tự chuyển đổi nguyên tố giữa các kỹ năng, hoặc ưu thế Boss Titan. Các trường level_max=0 giữ nguyên trong dữ liệu; mô phỏng dùng trần 255 và không coi đó là giới hạn nguồn đã xác nhận.
- Tên 83100 là `3.0` trong character_detail.config, trong khi character_break_new.config ghi `CT - Elaina`. Giữ tên nguồn và ID để không tự sửa mâu thuẫn nội dung ngoài chứng cứ hiện có.
