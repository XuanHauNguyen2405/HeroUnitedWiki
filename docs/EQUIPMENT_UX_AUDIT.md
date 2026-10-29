# Rà soát thuộc tính và UX trang bị — 25/10/2026

## Tiến độ

- [x] Đọc `web/AGENTS.md`, `docs/AUDIT_STATUS.md`, từ điển dữ liệu; working tree ban đầu sạch. Không commit hoặc reset.
- [x] Chụp website trước sửa ở 390 và 1440px: `docs/evidence/equipment-before/`.
- [x] Truy nguồn enum: `lua_decrypted/game_config.lua:332–339` xác nhận 201 Hỏa, 202 Thủy, **203 Phong**, **204 Địa** và 301–304 phòng tương ứng.
- [x] Truy nguồn hiệu ứng bộ: `game_util.lua:getEquipSuit` cộng dồn effect_2/3/4 khi đủ món, dùng PUBLIC_ABILITY_TABLE; không phải gán mọi chỉ số cho cả vật công lẫn ma công.
- [x] Sinh định nghĩa dùng chung, đối chiếu toàn bộ 721 hero / 4366 equipment / 729 suit trong `attribute_reconciliation.json`.
- [x] Thay suy đoán theo tên bằng gợi ý từ công thức mô tả nguồn, có điều kiện mở khoá và lý do riêng.
- [x] Đồng bộ ElementBadge, EquipmentAdvisor, EquipmentItemCard, EquipmentStatLine, SetBonuses, HeroSection, HeroIdentityBadges, HeroSummaryCard; bổ sung HeroSkillCard.
- [x] Regression, kiểm tra trình duyệt, typecheck/build; lưu báo cáo và ảnh bàn giao.

## Phát hiện đã xác nhận

1. Mapping 20 biến thể con giáp cũ trong `build_zodiac_data.py` trỏ đúng hệ trong config. Tuy nhiên `HeroInteractiveView` tính chỉ số bằng `activeSet.variants[0]` (Địa) dù UI chọn Gió; nhãn tổng hợp lại lấy hệ **được gợi ý**, không lấy hệ **đang trang bị**. Trình chọn còn tự rơi về biến thể đầu tiên và nhánh `... ? phong : tho` gán giá trị lạ sang Địa.
2. Bộ gợi ý suy diễn từ tên nhân vật, lore và từ khóa (atomic, băng, chidori...), áp dụng cả họ theo character_id. Ví dụ Elaina 83100 và 83200 có kỹ năng trước trận lần lượt chuyển công sang Phong và Hỏa; cùng họ không có nghĩa cùng hệ. Tướng không có trường hệ cố định trong character_detail.config.
3. Chỉ số bộ và Cầu Vồng bị hardcode: công nguyên tố bị cộng thành cả PATK/MATK, thêm speed không tồn tại; effect_4 có ability 2 là **Ma Công**, không phải Phòng ngự (3).
4. Trang bộ tra khóa `suit_add2/3/4` trong khi pipeline sinh `2_piece/3_piece/4_piece`, dẫn đến mất hiệu ứng.
5. `career`, `race`, `occupation.config[animation]`, `occupation_shade`, `ability*`, `sort` là các miền khác nhau. Không dùng race làm nguyên tố. Giá trị 0 hợp lệ cần được giữ, thiếu dữ liệu không được gán 0.
6. Phần đột phá có lỗi riêng: parse_abilitys đảo công (201–204) và phòng (301–304). Đã sửa nguồn, tái tạo 172 dạng / 3.440 hàng mốc và tách từng hệ trong bảng chỉ số. Mốc 1 của 83100 thêm 5.880 Thủy phòng (302), không thêm Thủy công; mốc 20 có 27.636 Thủy công (202). Regression dùng config độc lập.

## Cần giữ giới hạn chứng cứ

- Chưa có chứng cứ runtime rằng bộ nào là tối ưu tuyệt đối hoặc Địa luôn đánh Boss Titan mạnh nhất. Giữ lịch sử khuyến nghị thủ công trong báo cáo, chỉ dùng khuyến nghị có điều kiện/nguồn.
- Bằng chứng kỹ năng lấy từ nội dung công thức mô tả game, phải ghi rõ; không suy từ tên, ảnh hoặc màu. Không tuyên bố đã kiểm nghiệm chiến đấu thực tế.

## Checkpoint sau triển khai dữ liệu / UI

- Đã chạy lại toàn bộ `tools/prepare_web_data.py`. Bổ sung bước sinh semantics và con giáp vào lệnh chuẩn, giữ artwork theo manifest.
- Khi chạy pipeline đầy đủ phát hiện thêm bộ copy ảnh cũ ghi đè 13 ảnh `full_*` đã sửa ở phiên trước. Đã khôi phục đúng 13 file vừa bị thao tác của phiên này ghi đè, sửa copier giữ ảnh engine đang tồn tại, thêm regression `test_web_assets.py`. Không thay ảnh đứng/thẻ đã kiểm chứng.
- Loại bỏ mốc chuyển sinh kế thừa sai ở 9 dạng: 1, 2, 3, 4, 5, 6, 7, 44300, 7500. 35 dạng có high_break=5 hiện chỉ còn 5 mốc, không dựng mốc 6/7.
- 721 occupation icons trước đây thiếu occupation_type và bị mặc định thành 0; nay lấy `occupation.config[animation]`, giữ 0 và để thiếu khác 0.
- Kiểm tra sau tái tạo: 17 test Node đạt (đang bổ sung test hạ cấp độ), audit_validator 6/6, validate_pipeline 0 lỗi cấu trúc, 269 cảnh báo nội dung và 49 mục chưa xác minh đã có từ nguồn.
- Build và typecheck đã đạt trước vòng tinh chỉnh cuối. Lint so sánh trực tiếp HEAD: 60 lỗi/34 cảnh báo ban đầu → 53 lỗi/33 cảnh báo sau sửa; các module/component mới không có lỗi lint. Xem `evidence/lint-comparison.json`.
- Trình duyệt dev: 21 bước, 390/1440px, không tràn ngang, ảnh vỡ, exception hoặc lỗi mạng. Phát hiện cache CSS dev cũ; tách CSS component thành `hero-ui.css`, xác nhận build sạch có đủ stylesheet. Đang chạy vòng cuối trên production local.

## File và phạm vi ảnh hưởng

| Nhóm | File chính | Kết quả |
|---|---|---|
| Nguồn định nghĩa | tools/game_semantics.py → game_definitions.json, hero_combat_profiles.json | Mapping đọc từ Lua; hồ sơ công thức theo từng ID dạng; ghi rõ dữ liệu thiếu |
| Tạo dữ liệu | tools/prepare_web_data.py, tools/build_zodiac_data.py | Ghép đúng record key, equip_id, evolution và suit; nguồn thống nhất cho chỉ số, hệ và mốc |
| Gợi ý / tính toán | lib/equipment-advisor.ts, lib/game-attributes.ts, HeroInteractiveView.tsx | Một resolver cho biến thể đang mang; bỏ suy hệ theo tên; lý do theo công thức; điều kiện hiệu ứng tách khỏi điều kiện mang đồ |
| UX | HeroSection, HeroSummaryCard, HeroIdentityBadges, HeroSkillCard, ElementBadge, EquipmentAdvisor, EquipmentDetails | Cùng bố cục/chữ/nhãn trên danh sách, thẻ và chi tiết; giữ ảnh đứng đúng ID; Ban Sức ở đầu; thứ tự điều khiển đúng yêu cầu |
| Thẻ tướng | /cards, CardsPreview, HeroCard | Bỏ mẫu riêng có ID giả 88888 và đường dẫn ảnh tự dựng; chọn đủ 721 dạng từ dữ liệu thật, chỉ điều khiển các mốc có nguồn; đổi dạng remount trạng thái |
| Các trang khác | /equipment, /equipment/[id], /suits, /suits/[id] | Nhãn hệ và chỉ số dùng chung; sửa mất hiệu ứng 2/3/4 món; bộ lọc hệ riêng |
| Kiểm tra | equipment-advisor.test.mjs, hero-progression.test.mjs, test_web_assets.py, browser_check.mjs | Đối chiếu nguồn độc lập, 0/null/ID lạ, điều kiện kích hoạt, UI thực tế và ảnh trước/sau |

- Đối chiếu toàn bộ: 721 dạng, 4.366 món, 729 bộ; 20 biến thể con giáp, 160 bản ghi món ở hai phẩm.
- 605 dạng thay biểu tượng nghề mặc định 0 bằng giá trị nguồn hoặc trạng thái thiếu; 116 dạng thực sự có occupation=0 được giữ nguyên.
- 44 dạng sửa số mốc chuyển sinh: 9 dạng bỏ cây mượn sai và 35 dạng giới hạn ở high_break=5. 172 dạng sửa miền công/phòng đột phá.
- Danh sách ID đầy đủ: [equipment_affected_records.json](equipment_affected_records.json). Đối chiếu từng giá trị/nguồn: [attribute_reconciliation.json](attribute_reconciliation.json). Bảng đọc nhanh: [ATTRIBUTE_MAPPING.md](ATTRIBUTE_MAPPING.md).
- Giữ 77 khuyến nghị Ban Sức thủ công và 10 định nghĩa; audit xác nhận nguyên vẹn. Với trang bị, giữ ưu tiên Tị của các ID Elaina/Nagato và Ngựa của Cid/Shadow dưới dạng ưu tiên biên tập khi bằng điểm và có công thức phù hợp. Bỏ các kết luận từ lore hoặc tuyên bố tối ưu thực chiến chưa có nguồn; danh sách trong equipment_affected_records.json.

## Giới hạn còn lại đã nhận diện

- 547 dạng chưa được bộ phân tích công thức mô tả nhận diện đủ bằng chứng hệ; không mặc định thành Địa hoặc Phong và không đưa gợi ý chung sai căn cứ.
- 2.177 món chưa thiết lập được một công nguyên tố bộ duy nhất; không đoán hệ từ tên/màu/icon.
- Chưa xác minh tên Việt của các ID career/race và một số điều kiện occupation_shade=-1/activation; giữ ID và trạng thái cần kiểm tra.
- ID 501 ở miền siêu tiến hoá chưa được đồng nhất với enum của đá thánh. Chưa kiểm nghiệm chiến đấu thực tế, ưu thế Boss Titan hay công thức DPS tổng thể; lực chiến được trình bày là mô phỏng/ước tính.
- Nguồn thô vẫn có liên kết thiếu: 151 lượt kỹ năng tướng, 8 món bộ, 9 công thức tiến hoá trang bị, 101 liên kết tiến hoá kỹ năng. validate_pipeline báo 269 cảnh báo nội dung, 49 mục chưa xác minh, 0 lỗi cấu trúc. Không tạo bản ghi giả để làm sạch cảnh báo.

## Kiểm chứng cuối

- `npm.cmd --prefix web test`: **20/20 đạt**. Đối chiếu độc lập Lua/config cho Gió/Địa, toàn bộ equipment, form, chỉ số đột phá, ID 0/null/sai và điều kiện hiệu ứng.
- `python tools/test_web_assets.py`: đạt; pipeline không ghi đè ảnh engine bằng ảnh staging cũ. Đã kiểm tra chạy lại toàn pipeline không thay đổi JSON/tài nguyên sau tái tạo.
- `python tools/audit_validator.py`: **6/6 đạt**, không lỗi hoặc cảnh báo trong phạm vi audit này.
- `python tools/validate_pipeline.py`: **PASSED_WITH_WARNINGS**; 0 lỗi cấu trúc, 269 cảnh báo nội dung, 49 mục chưa xác minh từ dữ liệu nguồn.
- `npm.cmd --prefix web run typecheck`: đạt. `npm.cmd --prefix web run build`: đạt trên source cuối, sinh đủ 13 trang tĩnh và các route động.
- Lint toàn dự án vẫn chưa đạt do lỗi có sẵn: **60 → 52 lỗi**, **34 → 29 cảnh báo**, **0 lỗi mới** theo so sánh file/rule/thông báo với HEAD. Xem [lint-comparison.json](evidence/lint-comparison.json).
- Production local `http://127.0.0.1:3001`: **39 bước / 23 assertion** ở **390×844 và 1440×900**. Đã đổi tướng/dạng, bật/tắt trang bị Gió, mốc đột phá công/phòng, tối đa/hạ cấp, tải lại với cache bật, lọc career=0/race=0/Phong. **0px tràn ngang, 0 ảnh vỡ, 0 JS exception, 0 lỗi mạng/HTTP/console**. [Báo cáo đầy đủ](evidence/equipment-final/report.json).
- Kiểm tra bổ sung /cards trên build cuối: chọn dạng có/không hỗ trợ đột phá, đặt lại mốc khi chuyển dạng; ảnh thẻ và bố cục kiểm tra ở cả 390/1440px. [Báo cáo thẻ](evidence/cards-final/report.json).
- Ảnh lỗi tiêu biểu: [trước](evidence/equipment-before/equipment-mobile.png) / [sau](evidence/equipment-final/wind-equipped-mobile.png), [đầu trang toàn thân mobile](evidence/equipment-final/standing-mobile.png), [gợi ý desktop](evidence/equipment-final/equipment-desktop.png), [bộ lọc Phong](evidence/equipment-final/wind-filter-desktop.png).
- Máy chủ dev 3000 và build sạch 3001 đều đã kiểm tra tải stylesheet chung mới. Không service worker/localStorage lưu lựa chọn trang bị; đổi key dạng đặt lại trạng thái và tải lại quay về mặc định.

Toàn bộ thay đổi để **chưa commit**. Không triển khai lên dịch vụ hosting hoặc thay cấu hình chia sẻ.
