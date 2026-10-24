# CHỈ MỤC CÁC GÓI ĐÓNG GÓI DỰ ÁN SAHHT (PACKAGES_INDEX.md)
**Dự án:** Siêu Anh Hùng Hội Tụ WIKI (SAHHT WIKI)  
**Thời gian tạo:** 2026-10-20  
**Chuẩn tuân thủ:** Giới hạn mỗi file ZIP < 500.000.000 bytes (tất cả đều < 270 MB, đạt chuẩn an toàn dự phòng < 450 MB).  
**Tính toàn vẹn:** 100% tệp đã được kiểm tra tính toàn vẹn (CRC check & Zip integrity test) và kiểm tra giải nén thử nghiệm thành công.

---

## 1. BẢNG TỔNG HỢP CÁC GÓI ĐÓNG GÓI

| Tên gói | Dung lượng nén (Bytes) | Dung lượng nén (MB) | Dung lượng gốc (MB) | Số tệp | Checksum SHA-256 |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **`SAHHT_code_data.zip`** | 14.544.694 B | **13,87 MB** | 151,46 MB | 1.000 | `ac3ba9f389b4442ac9ea398c251aaa7b142c7c8744361f82adafeb93d6e55abf` |
| **`SAHHT_assets_01.zip`** | 268.724.551 B | **256,28 MB** | 261,09 MB | 4.190 | `d44c319726e980f2f342860d64c5bab77e8aa0de25f764c56e565c94fbc5706e` |
| **`SAHHT_assets_02.zip`** | 210.839.074 B | **201,07 MB** | 246,78 MB | 767 | `f65ac1879185c4215635793eaf3507519a2b033707083cde660d38c807f3fe35` |
| **`SAHHT_assets_03.zip`** | 261.040.989 B | **248,95 MB** | 276,27 MB | 4.866 | `ea4be423589f4731d6532f4b70fbf484650cbac5abaee290535e056f103dae42` |

> [!NOTE]
> Đường dẫn tuyệt đối của các tệp ZIP trên máy chủ hiện tại:
> - `C:\Users\Utente\Desktop\SAHHT_export\SAHHT_code_data.zip`
> - `C:\Users\Utente\Desktop\SAHHT_export\SAHHT_assets_01.zip`
> - `C:\Users\Utente\Desktop\SAHHT_export\SAHHT_assets_02.zip`
> - `C:\Users\Utente\Desktop\SAHHT_export\SAHHT_assets_03.zip`

---

## 2. NỘI DUNG CHI TIẾT TỪNG GÓI

### 2.1 GÓI 1: `SAHHT_code_data.zip` (Mã nguồn, Dữ liệu JSON, Cấu hình & Báo cáo)
Gói độc lập chứa toàn bộ logic, công cụ pipeline, kịch bản giải mã, báo cáo kiểm tra và mã nguồn website Next.js:
- **`config/` (297 tệp, 43,75 MB):** Toàn bộ tệp cấu hình `.config` gốc của game (định dạng JSON UTF-8 hợp lệ).
- **`lua/` & `lua_decrypted/` (18 tệp/thư mục, 8,20 MB):** Toàn bộ mã kịch bản Lua Cocos2d-x nguyên bản và bản giải mã XXTEA (key `aaa`).
- **`tools/` (36 tệp script Python, 0,41 MB):** Toàn bộ công cụ pipeline trích xuất, đối chiếu, render engine hoạt ảnh SAM, validator (`extract_pipeline.py`, `render_engine.py`, `audit_validator.py`, `prepare_web_data.py`, v.v.).
- **`docs/` (7 tệp markdown, 0,16 MB):** Toàn bộ tài liệu kỹ thuật, từ điển dữ liệu, ma trận thẻ và các báo cáo kiểm định gần nhất (`AUDIT_STATUS.md`, `EXTRACTION_REPORT.md`, `HEROES_AUDIT_REPORT.md`, v.v.).
- **`output/` (14 tệp JSON quan hệ, 42,00 MB):** Kho dữ liệu quan hệ trích xuất chuẩn hóa (`heroes.json`, `skills.json`, `equipment.json`, `equipment_sets.json`, `items.json`, `ban_suc.json`, `asset_manifest.json`, `schema_index.json`, v.v.). Không chứa tài nguyên nhị phân APK thô.
- **`web/src/` (Đầy đủ mã nguồn web, 51,45 MB):**
  - `web/src/data/`: Toàn bộ dữ liệu web tối ưu (`heroes_catalog.json`, `heroes_detail.json`, `hero_artwork_manifest.json`, `skills_detail.json`, `suits_detail.json`, `ban_suc_recommendations.json`, `character_strengthen.json`, `search_index.json`).
  - `web/src/app/`: Toàn bộ các trang Next.js App Router (`/heroes`, `/heroes/[id]`, `/heroes/gallery`, `/skills`, `/equipment`, `/suits`, `/ban-suc`).
  - `web/src/components/`: Toàn bộ components UI (`HeroStandingArt.tsx`, `HeroCard.tsx`, `HeroInteractiveView.tsx`, v.v.).
  - `web/src/lib/`: Các tiện ích hỗ trợ.
- **Tệp cấu hình Web & Tài liệu gốc:**
  - `web/package.json`, `web/package-lock.json`, `web/tsconfig.json`, `web/next.config.ts`, `web/eslint.config.mjs`, `web/README.md`, `web/AGENTS.md`.
  - `README.md`, `HUONG_DAN_AP_DUNG.md`, `.gitignore`, `REVIEW_CONTEXT.md`.

### 2.2 GÓI TÀI NGUYÊN 1: `SAHHT_assets_01.zip` (Tài nguyên Web Public)
Chứa toàn bộ tài nguyên hình ảnh được tối ưu hóa cho ứng dụng web Next.js:
- **`web/public/` (4.190 tệp ảnh, 261,09 MB uncompressed):**
  - `web/public/assets/heroes/`: Chân dung (portraits), ảnh đứng toàn thân không viền (standing art), ảnh thẻ bài nhô viền (card art) cho 721 tướng.
  - `web/public/assets/iphonehd/icon/`: Hàng ngàn biểu tượng vật phẩm, trang bị, nguyên liệu, kỹ năng game.
  - `web/public/assets/iphonehd/img/`: Các tệp đồ họa đặc biệt của game.
  - `web/public/assets/card/`: Khung thẻ bài các phẩm cấp (Lục, Lam, Tím, Cam, Đỏ, Kim...).
> *Chỉ cần giải nén Gói 1 và Gói Tài nguyên 1 là website có thể khởi chạy hoàn chỉnh 100% hình ảnh hiển thị.*

### 2.3 GÓI TÀI NGUYÊN 2: `SAHHT_assets_02.zip` (Tài nguyên Game Cocos2d-x Gốc)
Chứa toàn bộ kho tài nguyên gốc của game engine có sẵn trong kho lưu trữ:
- **`Resources/` (767 tệp, 246,78 MB uncompressed):**
  - `Resources/iphonehd/anim/`: Toàn bộ bộ hoạt ảnh Flash SAM (`.swf.sam`), atlas (`.plist`), texture nén (`.pvr.ccz`) của các nhân vật gốc.
  - `Resources/iphonehd/ccb/` & `ccbResources/`: Giao diện CCB dựng sẵn của CocosBuilder.
  - `Resources/iphonehd/icon/`: Biểu tượng gốc đi kèm game.
  - `Resources/iphonehd/img/`: Đồ họa minh họa gốc.
  - `Resources/sound/`: Toàn bộ hiệu ứng âm thanh game (`.wav`, `.mp3`).

### 2.4 GÓI TÀI NGUYÊN 3: `SAHHT_assets_03.zip` (Kho Public Chuẩn Hóa & Tài nguyên APK Pipeline)
Chứa kho tài nguyên độc lập do pipeline tạo ra và các tài nguyên từ APK được pipeline sử dụng:
- **`public/` (4.851 tệp, 258,88 MB uncompressed):** Kho tài nguyên chuẩn hóa độc lập được tạo bởi `tools/setup_public_assets.py` (chứa toàn bộ ảnh, atlas, hoạt ảnh phục vụ pipeline trung gian).
- **Tài nguyên từ APK được pipeline sử dụng (`output/apk_extracted/` - 15 tệp, 17,39 MB uncompressed):**
  - Hoạt ảnh Flash SAM & Texture tướng bổ sung từ APK phục vụ render engine:
    - `output/apk_extracted/assets/iphonehd/anim/peien2.swf.sam`, `peien2.plist`, `peien2.pvr.ccz` (Nagato).
    - `output/apk_extracted/assets/iphonehd/anim/sasuke.swf.sam`, `sasuke.plist`, `sasuke-hd.pvr.ccz` (Xaxuke).
    - `output/apk_extracted/assets/iphonehd/anim/sasuke2.swf.sam`, `sasuke2.plist`, `sasuke2-hd.pvr.ccz` (Sasuke Susano).
    - `output/apk_extracted/assets/iphonehd/anim/suolong.swf.sam`, `suolong.plist`, `suolong-hd.pvr.ccz` (Zoro).
  - Thư viện Native ARM Thumb Cocos2d-x: `output/apk_extracted/lib/armeabi-v7a/libjinqu.so` (dùng để dịch ngược ma trận hoạt ảnh SAM trong `AUDIT_STATUS.md` và `tools/render_engine.py`).
  - Metadata APK: `output/apk_extracted/apk_info.json`, `output/apk_extracted/AndroidManifest.xml`.

---

## 3. HƯỚNG DẪN GIẢI NÉN VÀ KHÔI PHỤC CẤU TRÚC DỰ ÁN

Tất cả các gói ZIP đều lưu trữ đường dẫn tương đối (relative path) tính từ thư mục gốc của dự án (`SAHHT_export`). Do đó, việc khôi phục cấu trúc cực kỳ đơn giản và không bị xung đột.

### Cách 1: Giải nén bằng lệnh dòng lệnh (Khuyến nghị)
Đặt cả 4 tệp ZIP vào cùng một thư mục dự án mới (ví dụ `SAHHT_project`), sau đó thực thi:

#### Trên Windows PowerShell:
```powershell
# Tạo thư mục đích
New-Item -ItemType Directory -Force -Path ".\SAHHT_restored"

# Giải nén lần lượt từng gói
Expand-Archive -Path ".\SAHHT_code_data.zip" -DestinationPath ".\SAHHT_restored" -Force
Expand-Archive -Path ".\SAHHT_assets_01.zip" -DestinationPath ".\SAHHT_restored" -Force
Expand-Archive -Path ".\SAHHT_assets_02.zip" -DestinationPath ".\SAHHT_restored" -Force
Expand-Archive -Path ".\SAHHT_assets_03.zip" -DestinationPath ".\SAHHT_restored" -Force

cd ".\SAHHT_restored"
```

#### Trên Linux / macOS Terminal:
```bash
mkdir -p SAHHT_restored
unzip -q SAHHT_code_data.zip -d SAHHT_restored
unzip -q SAHHT_assets_01.zip -d SAHHT_restored
unzip -q SAHHT_assets_02.zip -d SAHHT_restored
unzip -q SAHHT_assets_03.zip -d SAHHT_restored

cd SAHHT_restored
```

### Cách 2: Giải nén bằng giao diện đồ họa (7-Zip, WinRAR)
1. Chọn cả 4 tệp ZIP.
2. Nhấp chuột phải -> Chọn **"Extract here"** (hoặc **"Extract to <Folder>"**).
3. Các thư mục con (`config/`, `lua/`, `tools/`, `docs/`, `output/`, `web/`, `Resources/`, `public/`) sẽ tự động hợp nhất vào đúng vị trí phân cấp của dự án.

### Cách kiểm tra sau khi khôi phục:
```bash
# 1. Chạy bộ kiểm thử validator đối chiếu dữ liệu:
python tools/audit_validator.py
# Kết quả mong đợi: 6 PASSED, 0 FAILED, 0 WARNINGS

# 2. Khởi chạy website Wiki:
cd web
npm install
npm run dev
# Mở trình duyệt tại http://localhost:3000 để tra cứu
```

---

## 4. DANH SÁCH CHI TIẾT TẤT CẢ CÁC TỆP BỊ LOẠI HOẶC CHƯA ĐÓNG GÓI

Tuân thủ nghiêm ngặt yêu cầu *"Liệt kê rõ mọi file bị loại hoặc chưa đóng gói; không âm thầm bỏ qua"*, bảng dưới đây thống kê đầy đủ toàn bộ tệp và thư mục đã được cố ý loại trừ khỏi các gói đóng gói kèm theo lý do kỹ thuật:

| Tệp / Thư mục bị loại | Dung lượng | Vị trí | Lý do kỹ thuật loại trừ |
| :--- | :--- | :--- | :--- |
| **`apk/game.apk`** | 951,46 MB (997.683.359 B) | `apk/` | APK nhị phân nguyên bản. Yêu cầu chỉ định loại trừ trực tiếp. Metadata đã được lưu tại `apk_info.json` và `REVIEW_CONTEXT.md`. |
| **`web/node_modules/`** | 417,05 MB (4.037 tệp) | `web/` | Thư viện phụ thuộc Node.js. Loại trừ theo chuẩn phát triển web; có thể cài lại bằng `npm install` từ `package-lock.json`. |
| **`web/.next/`** | 423,85 MB | `web/` | Build cache và output biên dịch tạm thời Turbopack. Tự động tái tạo khi chạy `npm run build` hoặc `npm run dev`. |
| **`.git/`** | 316,65 MB | Thư mục gốc | Lịch sử commit Git cục bộ. Loại trừ theo yêu cầu đóng gói gọn nhẹ và bảo mật. |
| **`web/web.rar`** | 160,97 MB | `web/` | Tệp nén sao lưu cũ của thư mục web, loại trừ để tránh trùng lặp dung lượng. |
| **`web/SAHHT_web_fix.zip`** | 0,04 MB | `web/` | Tệp nén bản vá cũ, toàn bộ nội dung sửa đổi đã có sẵn trong `web/src/`. |
| **`tools/__pycache__/`** | ~0,20 MB | `tools/` | Tệp bytecode `.pyc` biên dịch tạm thời của Python, tự sinh khi chạy script. |
| **`scratch/`** | 70,01 MB | Thư mục gốc | Thư mục scratch chứa ảnh chụp màn hình kiểm tra (`scratch/screenshots/`), các frame thử nghiệm trích xuất (`daiji_sprites/`, `peien_frames/`). Không thuộc mã nguồn phát hành. |
| **`preview/`** | 0,15 MB (4 tệp HTML) | Thư mục gốc | Các tệp HTML xem trước thử nghiệm từ Giai đoạn 1. Có thể tái tạo lại bất kỳ lúc nào bằng lệnh `python tools/build_preview.py`. |
| **Tài nguyên thô APK còn lại trong `output/apk_extracted/`** | ~1.258 MB | `output/apk_extracted/` | Các tệp nhị phân thô không được pipeline wiki sử dụng trực tiếp: bao gồm 1.177 hoạt ảnh SAM của quái/NPC chưa dùng, SDK bên thứ ba (`UPPayPluginEx.apk`, `Sonnenblume`, `nim`), thư viện native cho CPU khác (`arm64-v8a`, `x86`), và bytecode Java (`classes.dex`, `resources.arsc`). Có thể tái trích xuất từ `game.apk` qua `tools/extract_apk.py`. |

---
*Tài liệu kiểm mục bàn giao được tạo tự động và đối chiếu toàn vẹn vào ngày 2026-10-20.*
