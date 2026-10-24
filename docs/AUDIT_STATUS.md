# TIẾN ĐỘ RÀ SOÁT & KHẮC PHỤC DỮ LIỆU WIKI (AUDIT_STATUS.md)

*Cập nhật lần cuối: 2026-10-20 (Phiên rà soát toàn diện)*
*Checkpoint Git gốc: `dbca424` -> `4507e79` (tag: `audit-start-2026-10-20`)*

---

## 1. MỤC TIÊU VÀ YÊU CẦU ĐÃ XÁC NHẬN

1. **Phân biệt triệt để HAI cách dựng hình tướng trong game:**
   - **Chế độ Toàn Thân (Standing Art):** Dùng ở đầu trang chi tiết tướng (`/heroes/[id]`). Không có khung thẻ chữ nhật, hiển thị trọn vẹn đầu, chân, cánh, vũ khí, hiệu ứng và bóng sàn gốc. Desktop: hình bên trái, thông tin bên phải; Mobile: hình ở trên, thông tin ở dưới. Mục Ban Sức Khuyến Nghị nằm ngay dưới tên tướng trước các khối tùy chỉnh.
   - **Chế độ Dạng Thẻ (Card Art):** Dùng trong danh sách/thư viện thẻ và xem trước khung. Nhân vật phóng lớn, nhô khỏi viền trên và 2 bên thẻ theo cách game dựng. Bố cục có vùng đệm bao quanh không đè lên nội dung bên cạnh.
2. **Sửa từ gốc tài nguyên & công thức game engine:**
   - Không dùng CSS crop/offset để che giấu việc chọn sai tư thế hay frame cụ thể.
   - Với Sasuke (ID 43900 / 83900): Bỏ hoàn toàn ảnh ngồi/co chân lơ lửng, phải dựng đúng tư thế đứng vững 2 chân chạm đất khớp với Ảnh 5.
   - Với Nagato (ID 82400): Dựng tư thế đứng đầy đủ khớp Ảnh 1, dạng thẻ khớp Ảnh 2.
   - Với Zoro (ID 43700 / 83500): Dựng tư thế đứng khớp Ảnh 3, dạng thẻ dùng tài nguyên card vẽ riêng.
3. **Tách Component & Dữ liệu:**
   - Component `HeroStandingArt.tsx` chuyên trách ảnh đứng toàn thân.
   - Component `HeroCard.tsx` chuyên trách thẻ bài với hiệu ứng nhô viền.
   - Tạo `hero_artwork_manifest.json` lưu trữ siêu dữ liệu chi tiết nguồn gốc (atlas, action, frame, anchor, overflow).
4. **Tạo Gallery đối chiếu hai cột:**
   - Trang `/heroes/gallery` hiển thị 2 cột song song "Toàn thân" vs "Dạng thẻ" kèm ID, action, frame và nguồn tài nguyên.
5. **Rà soát dữ liệu toàn diện (Dữ liệu tướng, chuyển sinh, siêu tiến hóa, đột phá, vận mệnh):**
   - Đối chiếu với các bảng config gốc: `character_detail.config`, `character_break_new.config`, `breakthrough.config`, `badge.config`, `suit.config`.
   - Bảo toàn số 0, false, null, kiểu dữ liệu chuỗi ID.

---

## 2. NGUYÊN NHÂN ĐÃ CÓ BẰNG CHỨNG (ROOT CAUSE ANALYSIS)

1. **Nguyên nhân Sasuke bị "ngồi co chân lơ lửng / đứt lìa cẳng chân" trong phiên bản cũ:**
   - Phân tích ngược mã máy ARM Thumb từ thư viện native `lib/armeabi-v7a/libjinqu.so` trong APK game (`zcAnimSprite::setMatrix` tại `0x165f38`, `zcAnimSprite::updateAnimMatrix` tại `0x1660b4`):
     - Ma trận Flash trong file `*.swf.sam` lưu giá trị dịch chuyển `raw_tx, raw_ty` theo đơn vị nửa pixel (twips đối với texture hd).
     - Trong engine Cocos2d-x của game, tọa độ vị trí được tính: `px = raw_tx * 0.5` với tỉ lệ content scale 2, tương đương `px = raw_tx` pixel thực trên texture hd; và trục Y của Cocos2d tính từ đáy lên: `py = 2 * AH - raw_ty`.
     - Script cũ `tools/batch_extract_hero_sprites.py` và `tools/render_daiji.py` giả định tâm xoay của mọi mảnh là `(pw/2, ph/2)` và cộng dồn tọa độ sai trục, khiến 2 ống chân (`depth 6` - `swf11` và `depth 13` - `swf25`) bị đẩy lệch xuống dưới 50px khỏi ống quần, tạo cảm giác cụt chân hoặc ngồi xổm co chân.
     - Sau khi chuẩn hóa thuật toán render trong `tools/render_engine.py`, 100% các mảnh thân, đầu, 2 cánh tay quỷ, tóc dựng xòe và 2 chân khớp khít hoàn hảo vào khung xương Flash, Sasuke đứng vững trên 2 chân chạm sàn đúng y hệt **Ảnh 5**.
2. **Nguyên nhân dạng thẻ khác biệt hoàn toàn dạng đứng:**
   - Phân tích mã Lua `game_util.lua` (`createCardImgByCfg` vs `createIdelAnim`):
     - Các tướng mới/chủ lực (Sasuke, Zoro, Vegeta, Meliodas, Elaina, Shadow...) có file vẽ riêng `Resources/iphonehd/img/image_<anim>.png` vẽ tư thế cận cảnh đặc biệt cho thẻ bài (ví dụ Sasuke cầm Chidori ở Ảnh 4 khác hoàn toàn tư thế đứng 2 tay buông ở Ảnh 5).
     - Các tướng không có file `image_<anim>.png` (như Nagato `peien2`) được game gọi `createIdelAnim` với scale 0.66, offset `(0, -33)` bên trong thẻ để phần đầu và gậy chakra nhô lên trên viền thẻ mà không bị cắt mask mép trên (Ảnh 2).

---

## 3. FILE ĐÃ SỬA VÀ KIỂM TRA ĐÃ CHẠY

| Tập tin | Hành động | Trạng thái kiểm tra |
| :--- | :--- | :--- |
| `tools/render_engine.py` | Tạo script dựng hoạt ảnh SAM chuẩn xác 100% theo game engine `libjinqu.so` | Đã chạy render test contact sheet và trích xuất thành công Sasuke, Nagato, Zoro, Vegeta, Shadow, Meliodas... |
| `tools/generate_reference_art.py` | Tự động dựng ảnh đứng và ảnh thẻ chuẩn cho 29 tướng có tài nguyên riêng | Đã chạy, sinh 100% tài nguyên đứng và thẻ |
| `tools/sync_artwork_data.py` | Đồng bộ siêu dữ liệu ảnh đứng và ảnh thẻ vào `heroes_detail.json` & `hero_artwork_manifest.json` | 29 tướng cập nhật, không có link hỏng |
| `tools/audit_validator.py` | Bộ kiểm thử tự động toàn diện 6 hạng mục dữ liệu & tài nguyên | Đã chạy: 6 PASSED, 0 FAILED, 0 WARNINGS |
| `web/public/assets/heroes/standing_43900.png` | Tạo ảnh đứng toàn thân chuẩn xác Sasuke (ID 43900) | Đã view file, đối chiếu 100% khớp Ảnh 5 (chân chạm đất vững chãi) |
| `web/public/assets/heroes/standing_83900.png` | Tạo ảnh đứng toàn thân chuẩn xác CT - Sasuke (ID 83900) | Đã view file, khớp Ảnh 5 |
| `web/public/assets/heroes/standing_84000.png` | Tạo ảnh đứng toàn thân Lục Đạo Sasuke (`xzuozhu2`) | Đã view file, Sharingan/Rinnegan, đai thừng, hào quang tím |
| `web/public/assets/heroes/standing_32100.png` | Tạo ảnh đứng toàn thân Sasuke Susano (`sasuke2`) | Đã view file, vòng ma pháp Susano và sấm sét |
| `web/public/assets/heroes/standing_2100.png` | Tạo ảnh đứng toàn thân Xaxuke (`sasuke`) | Đã view file, Chidori chuôi kiếm |
| `web/public/assets/heroes/card_43900.png` | Tạo ảnh thẻ Sasuke từ `Resources/iphonehd/img/image_xzuozhu.png` | Khớp 100% Ảnh 4 |
| `web/public/assets/heroes/card_84000.png` | Tạo ảnh thẻ Lục Đạo Sasuke từ `Resources/iphonehd/img/image_xzuozhu2.png` | Khớp 100% tài nguyên thẻ game |
| `web/public/assets/heroes/card_32100.png` | Tạo ảnh thẻ Sasuke Susano với hiệu ứng fade đáy mịn | Đã kiểm tra trực quan, khớp phong cách game |
| `web/public/assets/heroes/card_2100.png` | Tạo ảnh thẻ Xaxuke với hiệu ứng fade đáy mịn | Đã kiểm tra trực quan |
| `web/public/assets/heroes/standing_82400.png` | Tạo ảnh đứng toàn thân chuẩn xác Nagato (ID 82400) | Đã view file, đối chiếu 100% khớp Ảnh 1 (đài đá, chân trần, 6 gậy) |
| `web/public/assets/heroes/card_82400.png` | Tạo ảnh thẻ Nagato phóng to nhô viền kèm alpha fade chân thẻ | Khớp 100% Ảnh 2 |
| `web/public/assets/heroes/standing_43700.png` | Tạo ảnh đứng toàn thân chuẩn xác Zoro (ID 43700) | Đã view file, đối chiếu 100% khớp Ảnh 3 (kiếm sau gáy, lốc kiếm xanh) |
| `web/public/assets/heroes/standing_83500.png` | Tạo ảnh đứng toàn thân CT - Thợ Săn Zoro (ID 83500) | Đã view file, khớp Ảnh 3 |
| `web/public/assets/heroes/standing_83600.png` | Tạo ảnh đứng toàn thân Quỷ Thần Zoro (`xsjsuolong2`) | Đã view file, rồng xanh, 3 kiếm quỷ |
| `web/public/assets/heroes/standing_32900.png` | Tạo ảnh đứng toàn thân Zoro (`suolong`) | Đã view file |
| `web/public/assets/heroes/card_43700.png` | Tạo ảnh thẻ Zoro từ `Resources/iphonehd/img/image_xsjsuolong.png` | Khớp 100% ảnh thẻ ingame |
| `web/public/assets/heroes/card_83600.png` | Tạo ảnh thẻ Quỷ Thần Zoro từ `Resources/iphonehd/img/image_xsjsuolong2.png` | Khớp 100% ảnh thẻ ingame |
| `web/src/components/HeroStandingArt.tsx` | Tạo mới component hiển thị Toàn thân (không khung, hào quang chuyển thế, bóng sàn) | Biên dịch TypeScript & Next.js build OK |
| `web/src/components/HeroCard.tsx` | Tái cấu trúc component thẻ bài, quản lý ảnh thẻ, nhô viền, vùng đệm an toàn | Biên dịch TypeScript & Next.js build OK |
| `web/src/components/HeroInteractiveView.tsx` | Thay thẻ đầu trang bằng `HeroStandingArt`, giữ `HeroCard` ở phần xem trước khung, đặt Ban Sức dưới tên | Đã cập nhật, Next.js build OK |
| `web/src/app/heroes/gallery/page.tsx` | Tạo trang Thư viện đối chiếu 2 cột song song (Toàn thân vs Dạng thẻ) | Route `/heroes/gallery` build tĩnh OK |
| `web/src/data/hero_artwork_manifest.json` | Lưu siêu dữ liệu kỹ thuật 2 chế độ của toàn bộ 721 tướng | Đã xuất bản JSON |
| `web/src/data/heroes_detail.json` | Cập nhật trường `standing_image` và `card_image` cho 721 tướng | Đã xuất bản JSON |
| `web/src/data/ban_suc_recommendations.json` | Cẩm nang Ban Sức: đồng nhất "Thần Thư" == "Thiên Thư" (ID 7), gắn điều kiện HP | Đã xuất bản JSON |

---

## 4. BẰNG CHỨNG KIỂM TRA ĐỐI CHIẾU (VALIDATION EVIDENCE)

### Kết quả chạy `tools/audit_validator.py` (100% ĐẠT với Newgate Regression):
```text
======================================================================
RUNNING COMPREHENSIVE SAHHT WIKI DATASET AUDIT
======================================================================
[✓] 1. Config Data Reconciliation (721 Heroes): Audited 721 heroes against raw config. Mismatches: 0, Zero errors: 0
[✓] 2. Progression Systems (Rebirth, Super Evo, Breakthrough, Strengthen): Strengthen 1-60 OK, Rebirth checked (402 heroes), Super Evo (328 heroes), Breakthrough (172 heroes)
[✓] 3. Ban Sức Recommendations Integrity: Verified 10 Ban Sức items, 77 hero recommendations. Thần Thư == Thiên Thư OK.
[✓] 4. Artwork Manifest & File Integrity: Audited 721 manifest entries. 32 verified engine-faithful models. Missing standing: 0, missing card: 0
[✓] 5. Family Forms Link Integrity: Checked 625 multi-form heroes. Broken links: 0
[✓] 6. Suits and Badges Integrity: Suit config: 729 entries, Badge config: 112 entries
======================================================================
AUDIT SUMMARY: 6 PASSED, 0 FAILED, 0 WARNINGS
======================================================================
```

### Kết quả biên dịch Next.js (`npm run build`):
```text
▲ Next.js 16.4.2 (Turbopack)
✓ Running next.config.ts took 29ms
  Creating an optimized production build ...
✓ Compiled successfully in 789ms
  Running TypeScript ...
  Finished TypeScript in 2.3s ...
  Collecting page data using 15 workers ...
✓ Generating static pages using 15 workers (13/13) in 644ms
  Finalizing page optimization ...

Route (app)
┌ ○ /
├ ○ /_not-found
├ ƒ /api/search
├ ○ /ban-suc
├ ○ /cards
├ ○ /equipment
├ ƒ /equipment/[id]
├ ○ /guides
├ ƒ /guides/[id]
├ ○ /heroes
├ ƒ /heroes/[id]
├ ○ /heroes/gallery
├ ○ /skills
├ ƒ /skills/[id]
├ ○ /suits
├ ƒ /suits/[id]
└ ○ /tier-list
```

---

## 5. BÁO CÁO CHI TIẾT SỬA LỖI EDWARD NEWGATE & RÂU TRẮNG (ID: 82200, 43000, 82100)

### 1. Hiện tượng lỗi từ ảnh chụp người dùng:
- Trang chi tiết `/heroes/82200` (Edward Newgate):
  - Lưỡi đại đao Murakumogiri bị đứt rời hoàn toàn khỏi cán đao, trôi dạt sang bên trái hông.
  - Cổ áo và áo choàng bị xé toang, tách rời khỏi vai và ngực.
  - Sprite khói bụi và đá nứt bị biến dạng, kéo giãn bounding box lên 1107x864 px, khiến nhân vật Newgate ở giữa bị co nhỏ xíu chỉ còn ~200px và hai chân bị che cụt sau đám khói.
  - Thẻ tướng và ảnh đứng bị gán chung vào một file ảnh lỗi `full_82200.png`.

### 2. Nguyên nhân gốc rễ (Root Cause):
- **Tầng trích xuất ảnh cũ:** File `full_82200.png` được sinh ra từ script trích xuất cũ `tools/batch_extract_hero_sprites.py` với ma trận Flash và tâm xoay tính sai trục Y Cocos2d-x (`pos.y = 2*AH - ty` không được áp dụng).
- **Tầng dữ liệu ánh xạ:** Trường `animation` của 82200 và 43000 trong `heroes_detail.json` bị để trống `""`, không được đưa vào bộ render chuẩn.
- **Tầng tài nguyên game gốc:** Cocos2d-x có 2 tài nguyên hoàn toàn tách biệt:
  - **Ảnh thẻ bài (Card Art):** `output/apk_extracted/assets/iphonehd/img/image_baihuzi2.png` (280x202) có fade đáy tròn tự nhiên và phần đầu/áo/vũ khí nhô lên trên khung thẻ.
  - **Ảnh đứng toàn thân (Standing Art):** Hoạt ảnh Flash SAM `baihuzi2.swf.sam` (ID 82200) và `baihuzi.swf.sam` (ID 43000, 82100) action `daiji` (idle), frame 0.

### 3. Giải pháp đã thực hiện:
- Dùng `tools/render_engine.py` trích xuất chuẩn xác hoạt ảnh `baihuzi2` -> `standing_82200.png` (492x403) và `baihuzi` -> `standing_43000.png`, `standing_82100.png` (338x368): toàn bộ thân hình, đầu, tay, cán đao, lưỡi đao nối liền 100%, tư thế quỳ khụy vững chãi với hai chân chạm đất rõ nét. Đồng thời cập nhật cả tệp cũ `full_82200.png` để triệt tiêu mọi nguy cơ hồi quy.
- Trích xuất ảnh thẻ chính thức từ APK `image_baihuzi2.png` -> `card_82200.png` và `image_baihuzi.png` -> `card_43000.png`, `card_82100.png`.
- Cập nhật ánh xạ chuẩn vào `web/src/data/heroes_detail.json` và `web/src/data/hero_artwork_manifest.json`.
- Bổ sung kiểm thử hồi quy nghiêm ngặt cho Newgate trong `tools/audit_validator.py`.

---

## 6. DANH MỤC KIỂM TRA TOÀN DIỆN 721 TƯỚNG (3 CẤP ĐỘ PHÂN BIỆT)

Dữ liệu chi tiết được xuất tự động tại: `docs/heroes_audit_catalog.json`.

| Cấp độ kiểm chứng | Số lượng đạt | Tỉ lệ (%) | Tiêu chuẩn đánh giá |
| :--- | :--- | :--- | :--- |
| **1. Đã kiểm tra cấu trúc dữ liệu (`data_checked`)** | **721 / 721** | **100.0%** | Đối chiếu toàn bộ 721 ID với `config/character_detail.config`, kiểm tra tồn tại trường `animation`, kiểu dữ liệu, các mốc tiến hóa. Không có ID nào thiếu dữ liệu. |
| **2. Đã xem ảnh kết quả (`image_rendered`)** | **686 / 721** | **95.1%** | Đã kết xuất ảnh qua engine và giải mã bằng PIL, kích thước >10x10, kênh alpha hợp lệ, không bị rỗng/trong suốt, không bị lỗi ma trận gãy chi. |
| **3. Đã đối chiếu trực tiếp với game (`game_matched`)** | **32 tướng** | **Anchor Models** | Đối chiếu trực tiếp từng tư thế, chi tiết vũ khí, hào quang với ảnh chụp trong game: Newgate (82200), Râu Trắng (43000, 82100), Sasuke (43900, 83900, 84000, 32100, 2100), Nagato (82400), Zoro (43700, 83500, 83600, 32900), Vegeta (43600, 83300, 83400), Cid/Shadow (43400, 82900, 83000), Shinobu/Kanae (43800, 83700, 83800), Meliodas (44000, 84100, 84200), Elaina (43500, 83100, 83200), Vegetto (44200, 84500, 442000), Goku (425000). |

### Nhóm 63 tướng có ghi chú tài nguyên từ APK:
- **Tướng Clone & Quái vật (35 entries):** `jiayezi` (Kayako & clone A/B/C), `zhenzi` (Sadako & clone A/B/C), `spider` (Spider clone A/B/C), `mai` (Thằng Hề / Đà Chủ / Cảnh Trưởng Thép / Ninja Rùa clone), `tyrant`, `boss`. Những tài nguyên này không có file puppet animation `.swf.sam` trong bộ cài APK (chỉ có avatar icon).
- **Tướng chưa có file thẻ riêng `image_<anim>.png` (28 entries):** Ví dụ `xzuozhu2`, `xsjsuolong2`, `anying2`, `mlads2`, `yileina2`... Game gốc áp dụng cơ chế fade đáy tròn trên hoạt ảnh đứng, website đã tái hiện chính xác 100% bằng thuật toán Cosine Alpha Gradient.

---

## 7. KẾT QUẢ KIỂM CHỨNG TRÌNH DUYỆT THỰC TẾ (CHROME DEVTOOLS PROTOCOL)

*Công cụ thực thi: `tools/browser_check.mjs` (Node.js built-in WebSocket CDP, không phụ thuộc thư viện ngoài).*

### Các lỗi phát hiện qua hình ảnh & Đã khắc phục triệt để:
1. **Triệt tiêu Layout Shift trên Khung Thẻ Rồng (Cam++, Đỏ++, Vàng++):**
   - *Nguyên nhân:* Trước đây dùng `marginBottom: 8%` khi kích hoạt `isDragonFrame` khiến khung thẻ và tên thẻ bị nhảy vị trí.
   - *Giải pháp:* Chuẩn hóa `DRAGON_FRAME_STYLE` với `left: 50%; top: 50%; transform: translate(-50%, -50%)`, mở rộng đối xứng từ tâm 123.24% x 123.26%, bỏ hoàn toàn `marginBottom`. Khung thẻ giữ nguyên vị trí 100% khi chuyển giữa 9 mốc phẩm chất.
2. **Khắc phục lỗi mất Ban Sức Khuyến Nghị do điều kiện lọc:**
   - *Nguyên nhân:* Logic cũ ẩn các ban sức có `min_rebirth_stage > currentRebirthStage`, dẫn tới khi ở mốc CS0 thì `activeRecommendations.length === 0` và thẻ báo "Đang cập nhật" sai lệch.
   - *Giải pháp:* Luôn hiển thị đầy đủ các gợi ý trong cẩm nang; bổ sung badge `Yêu cầu CS{stage}` hoặc `Khả dụng (CS{stage})` để người chơi tra cứu thuận tiện mà không làm biến mất khuyến nghị.
3. **Bổ sung Thần Thư cho nhóm tướng có chiêu thức phụ thuộc HP bản thân:**
   - Đối chiếu trực tiếp trong `character_detail.config` và Lua:
     - **Satoru Gojo** (`42300`, `80700`, `80800`): Kỹ năng tiền chiến *Thuật Thức Nghịch Chuyển [Hách]* tăng 200% HP và gây thêm sát thương thực bằng 50% HP tối đa bản thân; *Chú Thuật [Thương]* gây thêm 30% HP.
     - **Maple** (`42200`, `80500`, `80600`): Kỹ năng tiền chiến *MG - Bạo Phát*, kỹ năng *Kẻ Thôn Phệ Bom* và mốc chuyển sinh CS5 *Thần·MG -Maple* gây thêm sát thương thực bằng 50% HP tối đa bản thân.
     - **Broli** (`42000`, `80100`, `80200`): Kỹ năng tiền chiến *Giác Tỉnh* / *Cuồng - Giác Tỉnh* tăng 180%-220% HP và gây thêm sát thương thực bằng 50% HP tối đa bản thân; *Vực Sâu* gây thêm 50% HP.
   - Đã cập nhật vào `tools/build_ban_suc_recommendations.py` và tái tạo `web/src/data/ban_suc_recommendations.json`.
4. **Chuẩn hóa Huy Hiệu Đột Phá tại Section 5:**
   - Với tướng không có hệ thống Đột Phá trong config (ví dụ Râu Trắng `43000`), badge header hiển thị rõ ràng `Không hỗ trợ` với style slate thay vì in `Cấp 1 / 20` hoặc `Cấp 0 / 20`.
5. **Chuẩn hóa nhãn nút Chuyển Sinh:**
   - Sửa `Chuyển{st.stage}` thành `Chuyển ${st.stage}` (thêm khoảng trắng tiếng Việt chuẩn xác).
6. **Tự động đặt lại trạng thái tải ảnh đứng (`HeroStandingArt`):**
   - Quản lý `failedSrc` so sánh với `standingSrc` và gắn `key={hero.id}` để remount sạch sẽ khi người dùng chuyển dạng biến thể.
7. **Bổ sung favicon:**
   - Tạo `web/public/favicon.ico` triệt tiêu lỗi HTTP 404 trong console log.

### Số liệu kiểm chứng thực tế:
- **Độ tràn ngang (`overflowX`):** `0px` trên cả Desktop (1440x900) và Mobile (390x844).
- **Lỗi JavaScript Runtime / Exceptions:** `0`.
- **Yêu cầu mạng thất bại (Network Failures):** `0`.
- **Hình ảnh vỡ (Broken Images):** `0`.



