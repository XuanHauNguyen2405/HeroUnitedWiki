# TÀI LIỆU BỐI CẢNH KIỂM TRA DỰ ÁN (REVIEW_CONTEXT.md)
**Dự án:** Siêu Anh Hùng Hội Tụ WIKI (SAHHT WIKI)  
**Ngày đóng gói:** 2026-10-20  
**Phiên bản Pipeline & Wiki:** v1.2.0  
**Mục đích:** Cung cấp đầy đủ bối cảnh kỹ thuật, nguồn dữ liệu, quy trình thực thi và tình trạng kiểm tra cho đội ngũ review / QA.

---

## 1. PHIÊN BẢN GAME VÀ NGUỒN DỮ LIỆU

### 1.1 Thông tin gói xuất bản APK gốc
- **Tên tệp APK:** `apk/game.apk`
- **Tên gói ứng dụng (Package Name):** `com.kaiqigu.cjyxyn.kvsdk`
- **Phiên bản (Version Name):** `1.9`
- **Mã phiên bản (Version Code):** `10`
- **Nền tảng SDK:**
  - `minSdkVersion`: 19 (Android 4.4 KitKat)
  - `targetSdkVersion`: 28 (Android 9.0 Pie)
  - `compileSdkVersion`: 28
- **Tổng dung lượng APK gốc:** 997.683.359 bytes (951,46 MB)
- **Tổng số tệp trong APK:** 15.287 tệp
- **Checksum SHA-256 APK:** `d8085fc187f1b72d334e5200ef896fb6a8970395e6093e371e35ac81279ccee6`
- **Metadata chi tiết:** Lưu trữ tại `output/apk_extracted/apk_info.json`

### 1.2 Kiến trúc Game Engine & Nguồn dữ liệu trích xuất
- **Game Engine:** Cocos2d-x (C++ Native) tích hợp hệ thống hoạt ảnh múa rối Flash (`*.swf.sam`) qua thư viện native `lib/armeabi-v7a/libjinqu.so`.
- **Cấu hình dữ liệu game:**
  - 297 tệp cấu hình `.config` tại thư mục `config/` (được trích xuất nguyên bản từ APK tại `assets/config/`).
  - Toàn bộ 297 tệp đều là định dạng JSON UTF-8 chuẩn, không bị mã hóa hay nén nhị phân.
  - Checksum SHA-256 của từng tệp cấu hình được lập chỉ mục tại `output/schema_index.json`.
- **Mã nguồn kịch bản Lua:**
  - Toàn bộ script Lua gốc trong APK được mã hóa bằng thuật toán XXTEA với key `aaa`.
  - Toàn bộ 291 tệp Lua đã được giải mã hoàn toàn sang văn bản thuần tại `lua_decrypted/` (và bản gốc tại `lua/`).
- **Tài nguyên hình ảnh & âm thanh:**
  - Kho tài nguyên gốc đi kèm: `Resources/iphonehd/` (164,40 MB) và `Resources/sound/` (82,37 MB).
  - Kho tài nguyên giải nén từ APK: `output/apk_extracted/assets/iphonehd/` và `output/apk_extracted/assets/sound/`.
  - Kho tài nguyên chuẩn hóa độc lập của pipeline: `public/assets/` (258,88 MB).
  - Kho tài nguyên hiển thị website Next.js: `web/public/assets/` (261,09 MB).

---

## 2. QUY TRÌNH & LỆNH CHẠY PIPELINE, VALIDATOR VÀ WEBSITE

Toàn bộ quy trình từ dữ liệu thô đến website hoàn chỉnh có thể tái lập 100% thông qua chuỗi lệnh sau:

### Bước 1: Trích xuất và chuẩn hóa dữ liệu quan hệ từ cấu hình
```bash
python tools/extract_pipeline.py
```
*Tác dụng:* Quét 297 tệp `config/*.config`, trích xuất và liên kết quan hệ thực thể cho 721 tướng, 10.836 kỹ năng, 4.366 trang bị, 729 bộ trang bị, hệ thống Ban Sức và 3.550 công thức tiến hóa; xuất ra 14 tệp JSON tại `output/`.

### Bước 2: Tạo kho tài nguyên độc lập cho pipeline
```bash
python tools/setup_public_assets.py
```
*Tác dụng:* Quét toàn bộ đường dẫn ảnh và tài nguyên trong `output/*.json`, sao chép vào `public/assets/` với cơ chế chống xung đột SHA-256, cập nhật đường dẫn JSON độc lập hoàn toàn khỏi APK gốc.

### Bước 3: Dựng hoạt ảnh chuẩn Game Engine cho các tướng chủ lực
```bash
python tools/generate_reference_art.py
```
*Tác dụng:* Sử dụng engine dựng hình Flash SAM đảo ngược mã máy từ `libjinqu.so` (`tools/render_engine.py`) để sinh ra ảnh đứng toàn thân (Standing Art) và ảnh thẻ bài nhô viền (Card Art) cho 29 tướng có tài nguyên riêng (Sasuke, Nagato, Zoro, Vegeta, Shadow, Shinobu, v.v.) vào `web/public/assets/heroes/`.

### Bước 4: Đồng bộ siêu dữ liệu đồ họa tướng
```bash
python tools/sync_artwork_data.py
```
*Tác dụng:* Đồng bộ các đường dẫn ảnh đứng và ảnh thẻ vào `web/src/data/heroes_detail.json` và tạo bảng siêu dữ liệu kỹ thuật `web/src/data/hero_artwork_manifest.json`.

### Bước 5: Chuẩn bị dữ liệu và hình ảnh tối ưu cho ứng dụng Web
```bash
python tools/prepare_web_data.py
```
*Tác dụng:* 
- Sao chép duy nhất các tệp hình ảnh (.png, .jpg, .webp) vào `web/public/assets/`, loại trừ các tệp nhị phân không cần cho web (.lua, .plist, .wav).
- Tạo chỉ mục tìm kiếm tiếng Việt không dấu/có dấu siêu nhanh tại `web/src/data/search_index.json`.
- Tách các tệp danh mục gọn nhẹ (`heroes_catalog.json`, `skills_catalog.json`, `suits_catalog.json`, `equipment_catalog.json`) và chi tiết (`heroes_detail.json`, `skills_detail.json`, `suits_detail.json`, `ban_suc.json`, `character_strengthen.json`).

### Bước 6: Chạy bộ kiểm thử tự động toàn diện (Audit Validator)
```bash
python tools/audit_validator.py
```
*Tác dụng:* Thực hiện kiểm thử tự động 6 hạng mục:
1. Đối chiếu 721 tướng với config thô (bảo toàn số 0, false, null, id).
2. Kiểm tra tính toàn vẹn cơ chế tiến trình (Chuyển Sinh 7 tầng, Siêu Tiến Hóa 9 mốc, Đột Phá 20 cấp, Cường Hóa 60 cấp).
3. Kiểm tra tính toàn vẹn Ban Sức Khuyến Nghị (10 loại Ban Sức, 77 khuyến nghị tướng, Thiên Thư == Thần Thư).
4. Kiểm tra toàn vẹn siêu dữ liệu đồ họa (721 bản ghi, 0 tệp ảnh thiếu).
5. Kiểm tra liên kết dòng biến thể gia tộc (Family Forms, 0 liên kết hỏng).
6. Kiểm tra tính toàn vẹn bộ trang bị (729 bộ) và huy hiệu (112 huy hiệu).
*Kết quả hiện tại:* **6 PASSED, 0 FAILED, 0 WARNINGS**.

### Bước 7: Kiểm tra tính độc lập tuyệt đối với APK
```bash
python tools/test_independence.py
```
*Tác dụng:* Tạm thời đổi tên cô lập `apk/` và `output/apk_extracted/`, kiểm tra pipeline và preview vẫn hoạt động độc lập 100%, không bị phụ thuộc vào tệp APK gốc.

### Bước 8: Khởi chạy ứng dụng Web tra cứu (Next.js)
```bash
cd web
npm install          # Cài đặt thư viện phụ thuộc (nếu chưa có node_modules)
npm run dev          # Chạy server phát triển tại http://localhost:3000
# hoặc
npm run build        # Biên dịch production bundle tĩnh/SSR tối ưu
npm run start        # Chạy server production
```

---

## 3. SCRIPT TẠO TỪNG BỘ DỮ LIỆU VÀ HÌNH ẢNH

| Bộ dữ liệu / Hình ảnh | Tệp đích | Script tạo / xử lý | Ghi chú kỹ thuật |
| :--- | :--- | :--- | :--- |
| **Dữ liệu Tướng thô** | `output/heroes.json` | `tools/extract_pipeline.py` | Trích xuất từ `character_detail.config`, 721 tướng |
| **Danh mục Tướng Web** | `web/src/data/heroes_catalog.json` | `tools/prepare_web_data.py` | Bản tóm tắt gọn nhẹ phục vụ danh sách và lọc |
| **Chi tiết Tướng Web** | `web/src/data/heroes_detail.json` | `tools/prepare_web_data.py` | 721 tướng đầy đủ kỹ năng, chuyển sinh, duyên phận, đột phá |
| **Siêu dữ liệu Đồ Họa** | `web/src/data/hero_artwork_manifest.json` | `tools/sync_artwork_data.py` | Siêu dữ liệu 2 chế độ (Standing vs Card), anchor, action, frame |
| **Hoạt ảnh Đứng & Thẻ** | `web/public/assets/heroes/` | `tools/generate_reference_art.py` | Render từ Flash SAM qua `tools/render_engine.py` |
| **Dữ liệu Kỹ Năng** | `output/skills.json`, `web/src/data/skills_detail.json` | `tools/extract_pipeline.py`, `tools/prepare_web_data.py` | 10.836 kỹ năng, bảo toàn `action: 0` |
| **Trang Bị & Bộ Trang Bị** | `output/equipment.json`, `output/equipment_sets.json` | `tools/extract_pipeline.py` | 4.366 trang bị chuẩn 4 slot, 729 bộ trang bị |
| **Chi tiết Bộ Trang Bị** | `web/src/data/suits_detail.json` | `tools/prepare_web_data.py` | Chi tiết hiệu ứng 2, 3, 4 món và 5 bộ con giáp |
| **Hệ thống Ban Sức** | `output/ban_suc.json`, `web/src/data/ban_suc.json` | `tools/extract_pipeline.py` | 10 loại đá Vận Mệnh, Điểm Hóa, Thác Ấn, 112 Huy Hiệu |
| **Ban Sức Khuyến Nghị** | `web/src/data/ban_suc_recommendations.json` | `tools/build_ban_suc_recommendations.py` | Cẩm nang Ban Sức chuẩn hóa thuật ngữ Thiên Thư / Thần Thư |
| **Tiến Hóa Cường Hóa** | `web/src/data/character_strengthen.json` | `tools/prepare_web_data.py` | 60 cấp độ từ `character_strengthen.config` |
| **Chỉ mục tìm kiếm** | `web/src/data/search_index.json` | `tools/prepare_web_data.py` | Tìm kiếm tiếng Việt chuẩn hóa bỏ dấu |

---

## 4. NHỮNG THAY ĐỔI GẦN NHẤT, LỖI CÒN TỒN TẠI VÀ PHẦN CHƯA XÁC MINH

### 4.1 Những thay đổi và cải tiến gần nhất
1. **Phân biệt triệt để hai cách hiển thị tướng:**
   - **Chế độ Toàn Thân (Standing Art):** Dùng ở đầu trang `/heroes/[id]`. Không đóng khung chữ nhật, hiển thị trọn vẹn đầu, chân, cánh, vũ khí, hào quang chuyển thế và bóng sàn gốc. Bố cục desktop: hình bên trái, bảng chỉ số bên phải; mobile: hình ở trên, thông tin ở dưới. Mục Ban Sức Khuyến Nghị đặt ngay dưới tên tướng.
   - **Chế độ Dạng Thẻ (Card Art):** Dùng trong danh sách thẻ và ô xem trước khung thẻ (`HeroCard.tsx`). Nhân vật nhô khỏi viền trên và 2 mép thẻ theo đúng phong cách game gốc.
2. **Sửa dứt điểm lỗi tư thế Sasuke (ID 43900 / 83900):**
   - Đảo ngược thành công mã máy ARM Thumb Cocos2d-x từ `libjinqu.so` (`zcAnimSprite::setMatrix` và `zcAnimSprite::updateAnimMatrix`).
   - Sửa sai lệch trục tọa độ Y và tâm ma trận Flash khiến 2 cẳng chân bị lệch 50px khỏi ống quần trong công thức render cũ. Sasuke hiện đứng vững hai chân chạm sàn chuẩn xác 100% theo tài nguyên gốc.
3. **Chuẩn hóa đồ họa cho 29 mô hình nhân vật chủ lực:**
   - Hoàn thiện render ảnh đứng và ảnh thẻ riêng biệt cho Sasuke, Nagato, Zoro, Vegeta, Shadow, Shinobu, Meliodas, Elaina, Vegito, v.v.
4. **Xây dựng trang Thư Viện Đối Chiếu Song Song:**
   - Trang `/heroes/gallery` hiển thị minh bạch 2 cột "Toàn thân" đối chiếu trực quan với "Dạng thẻ" kèm ID, action, frame và nguồn gốc tài nguyên.
5. **Cẩm nang Ban Sức Khuyến Nghị:**
   - Đồng nhất thuật ngữ "Thần Thư" chính là "Thiên Thư" (ID 7) theo đúng ngữ cảnh thực tế của game, gắn điều kiện ngưỡng máu dưới 50% cho Đảo Ngược Càn Khôn.

### 4.2 Lỗi còn tồn tại & Hạn chế đã biết
1. **Phạm vi render ảnh động SAM:**
   - Đã render engine-faithful cho 29 tướng chủ lực/biến thể quan trọng. Các tướng còn lại trong tổng số 721 tướng đang hiển thị bằng ảnh chân dung official từ `Resources/iphonehd/img/` hoặc `icon/`. Hoạt ảnh SAM của các tướng phụ chưa được trích xuất hàng loạt (do game có tới 324 hoạt ảnh khác nhau).
2. **Văn bản dịch thuật thô trong một số cốt truyện chuyển sinh:**
   - Trong `character_break_new.config`, một số chuỗi cốt truyện chuyển sinh tầng 6-7 có chứa mã màu Cocos2d-x đã được làm sạch, tuy nhiên phần lời thoại còn dịch thô từ tiếng Trung.

### 4.3 Các phần chưa xác minh (Ground Truth Limits)
1. **Tỷ lệ rơi vật phẩm từ phụ bản sự kiện:**
   - Các bảng phụ bản giới hạn giờ và sự kiện đặc biệt được điều khiển từ phía máy chủ (Server-side drop table), client game chỉ lưu cấu hình giao diện tĩnh.
2. **Dữ liệu đấu trường liên server và bang hội:**
   - Một số cấu hình liên quan đến tính năng nhiều người chơi thời gian thực nằm trong các gói cập nhật động qua mạng (hot-update patch), không có trong APK client tĩnh ban đầu.

---
*Tài liệu được khởi tạo tự động trong phiên chuẩn bị bàn giao ngày 2026-10-20.*
