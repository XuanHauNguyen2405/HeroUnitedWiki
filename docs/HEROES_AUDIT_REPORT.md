# BÁO CÁO KIỂM TOÁN DỮ LIỆU TƯỚNG TOÀN DIỆN (GROUND-TRUTH AUDIT)

## 1. THÔNG TIN PHIÊN BẢN VÀ NGUỒN DỮ LIỆU
- **Phiên bản Game**: `v1.9` (VersionCode: `10`), Package: `com.kaiqigu.cjyxyn.kvsdk`.
- **Tệp APK gốc**: `apk/game.apk` (951.46 MB, SHA256: `d8085fc187f1b72d334e5200ef896fb6a8970395e6093e371e35ac81279ccee6`).
- **Mã nguồn giải mã**: 291 tệp Lua Cocos2d-x giải mã hoàn toàn từ `output/apk_extracted/assets/lua/` (XXTEA key: `aaa`).
- **Cấu hình gốc**: 297 tệp `.config` trong `config/`.
- **Tài nguyên hình ảnh & hoạt ảnh**: Trích xuất từ cả `output/apk_extracted/assets/iphonehd/` và `Resources/iphonehd/`.

## 2. KẾT QUẢ ĐỐI SOÁT TỔNG THỂ (721 BẢN GHI TƯỚNG)

| Phân Loại | Ký Hiệu | Số Lượng | Tỉ Lệ | Ý Nghĩa |
| :--- | :---: | :---: | :---: | :--- |
| **Có trong nguồn và hiển thị đúng** | `A` | 686 | 95.1% | Dữ liệu khớp 100% giữa Lua, config và website |
| **Có trong nguồn nhưng pipeline bỏ sót** | `B` | 0 | 0.0% | Đã phát hiện và sửa hoàn toàn trong pipeline |
| **Có trong dữ liệu web nhưng UI ẩn** | `C` | 0 | 0.0% | Đã loại bỏ điều kiện render sai |
| **Ánh xạ sai sang bản thể khác** | `D` | 0 | 0.0% | Đã triệt tiêu hoàn toàn việc kế thừa sai |
| **Nguồn hiện có chưa đủ để xác định** | `E` | 35 | 4.9% | 35 tướng clone/quái chưa có tài nguyên client |

## 3. CƠ CHẾ TIẾN HÓA & ĐỘT PHÁ ĐÃ XÁC MINH THEO LUA GỐC

1. **Tiến Hóa Thường (+1 đến +60)**:
   - Tệp cấu hình: `character_strengthen.config` (60 mốc).
   - Thuật toán theo Lua `game_util.lua:5946`: `evo_attr_value` và `all_value` tăng chỉ số cơ bản của tướng.

2. **Chuyển Sinh (1 đến 7 Mốc)**:
   - Tệp cấu hình: `character_break_new.config` (393 tướng có cấu hình riêng).
   - 7 mốc danh hiệu: Dũng Sĩ, Đấu Sĩ, Anh Hùng, Thần Thoại, Thần, Linh, Hồn.
   - Biểu tượng mốc 1-7: `kpxq_break_1.png` đến `kpxq_break_7.png`.

3. **Siêu Tiến Hóa (9 Mốc: Cam ➔ Đỏ ➔ Vàng)**:
   - Khóa liên kết: `character_detail.config[id]['super_evo']` trỏ trực tiếp tới `super_evolution.config` (328 tướng hợp lệ).
   - Bảng khung và màu sắc theo `HERO_QUALITY_COLOR_TABLE_2` (`game_config.lua:42`):
     - Mốc 0: Cam (`card_q_bgOrange.png`)
     - Mốc 1: Cam+ (`card_q_bgOrange1.png`)
     - Mốc 2: Cam++ (`card_q_bgOrange2.png`)
     - Mốc 3: Đỏ (`card_q_bgRed.png`) — Mở khóa Kỹ Năng Siêu Tiến Hóa 1
     - Mốc 4: Đỏ+ (`card_q_bgRed1.png`)
     - Mốc 5: Đỏ++ (`card_q_bgRed2.png`)
     - Mốc 6: Vàng (`card_q_bgYellow.png`) — Mở khóa Kỹ Năng Siêu Tiến Hóa 2
     - Mốc 7: Vàng+ (`card_q_bgGolden1.png`)
     - Mốc 8: Vàng++ (`card_q_bgGolden2.png`)
   - Chỉ số cộng thêm: Tổng tích lũy `level_j_add` + 4 vị trí đúc hồn `super_evo_team.config`.

4. **Đột Phá (20 Cấp Đột Phá)**:
   - Tệp cấu hình: `breakthrough.config` (3,400 bản ghi trên 170-172 tướng chuyển thế/CT).
   - Khóa liên kết: `breakthrough_ids` trong `character_detail.config`.
   - Cung cấp chỉ số nguyên tố (`ele_atk`, `ele_def`) và nguyên liệu Tinh Hoa Nguyên Tố, Đá Năng Lượng, Chuyển Thế Đơn.

## 4. CHI TIẾT CÁC BẢN THỂ TƯỚNG ĐẶC BIỆT ĐÃ SỬA LỖI

### Nhóm Edward Newgate & Râu Trắng (Character ID 430)
- **Edward Newgate (ID 82200)**:
  - Phẩm chất gốc: Cam (Quality 4). Dạng biến thể Marineford chiến đấu tàn tạ, vết thương ngực, quấn khăn rằn bandana.
  - Hoạt ảnh gốc: `baihuzi2.swf.sam` (Action: `daiji`, Frame: 0).
  - Tệp thẻ bài chính thức: `output/apk_extracted/assets/iphonehd/img/image_baihuzi2.png` (280x202 px).
  - **Lỗi trước khi sửa:**
    - File trích xuất cũ `full_82200.png` bị lệch ma trận Y khiến lưỡi đại đao Murakumogiri đứt lìa khỏi cán đao, trôi sang trái hông.
    - Cổ áo và áo choàng bị xé toang khỏi vai và ngực.
    - Sprite khói bụi và đá nứt bị kéo giãn phình to khung hình lên 1107x864 px, khiến Newgate bị co nhỏ xíu ở giữa và chân bị khói che khuất.
    - `heroes_detail.json` gán chung cả ảnh đứng và ảnh thẻ vào file lỗi `full_82200.png`.
  - **Kết quả sau khi sửa:**
    - Trích xuất chuẩn xác qua `tools/render_engine.py` -> `standing_82200.png` (492x403 px). Cán đao, lưỡi đao, chuôi kiếm ở ngực, cổ áo, epaulets áo choàng, và tư thế đứng quỳ khụy vững chãi với 2 bốt chạm sàn khớp 100% không đứt đoạn.
    - Ảnh thẻ `card_82200.png` lấy trực tiếp từ `image_baihuzi2.png`, đầu và chuôi đao nhô trên viền thẻ, đáy bo tròn mờ tự nhiên.
- **Râu Trắng (ID 43000 & 82100)**:
  - Phẩm chất gốc: Cam (Quality 4). Dạng thuyền trưởng hải tặc thời hoàng kim: mũ thuyền trưởng bicorne với biểu tượng hải tặc, tóc vàng dài, áo xanh, áo choàng lớn, tay phải cầm đại đao vươn cao, tay trái mở rộng beckoning.
  - Hoạt ảnh gốc: `baihuzi.swf.sam` (Action: `daiji`, Frame: 0).
  - Tệp thẻ bài chính thức: `output/apk_extracted/assets/iphonehd/img/image_baihuzi.png` (280x202 px).
  - Kết xuất chuẩn xác: `standing_43000.png`, `standing_82100.png` (338x368 px) và `card_43000.png`, `card_82100.png`. ID 82100 hiển thị kèm hào quang Chuyển Thế (`anim_zhuanshi.swf.sam`).

### Nhóm Sasuke (Character ID 439)
- **Chú Nguyền Sasuke (ID 43900)**:
  - Phẩm chất gốc: Cam (Quality 4). `super_evo: 43900` (Hợp lệ, có đầy đủ 9 mốc Siêu Tiến Hóa Cam ➔ Vàng++).
  - Đột Phá: `breakthrough_ids: []` (Không có Đột Phá 20 cấp trong game). Đã sửa pipeline triệt tiêu việc lấy nhầm 20 cấp đột phá của ID 83900.
  - Ảnh đứng: Đã trích xuất đúng tư thế tĩnh từ `Resources/iphonehd/anim/xzuozhu.swf.sam` (790x800px).
  - Trạng thái: Hiển thị đồng bộ 'Siêu Tiến Hóa' và 'Chưa mở Đột Phá' trên tất cả danh sách và chi tiết.
- **CT - Chú Nguyền Sasuke (ID 83900)**:
  - Phẩm chất gốc: Cam (Quality 4). `super_evo: 75900` (9 mốc Siêu Tiến Hóa) + Đột Phá 20 cấp (`759001` đến `759020`).
  - Ảnh đứng: Trích xuất từ `xzuozhu` với aura chuyển thế `anim_zhuanshi.swf.sam`.
- **Lục Đạo Sasuke (ID 84000)**:
  - Phẩm chất gốc: Cam (Quality 4). `super_evo: 76000` (9 mốc Siêu Tiến Hóa) + Đột Phá 20 cấp (`760001` đến `760020`).
  - Ảnh đứng: Đã trích xuất ảnh toàn thân Lục Đạo chuẩn (770x1173px) từ `xzuozhu2.swf.sam` thay cho avatar nhỏ trước đây.

## 5. DANH SÁCH 35 TRƯỜNG HỢP CHƯA CÓ ĐỦ TÀI NGUYÊN CLIENT (CATEGORY E)

Các tướng này là tướng clone phụ, NPC quái thử nghiệm hoặc tướng thánh chưa phát hành trong client v1.9, không có tệp `.sam` hoặc `image_*.png`:

| ID | Tên Tướng | Animation Ref | Tệp Thiếu Cụ Thể |
| :--- | :--- | :--- | :--- |
| 1500 | Tyrant | `tyrant` | `tyrant.swf.sam`, `image_tyrant.png` |
| 5000 | Kayako | `jiayezi` | `jiayezi.swf.sam`, `image_jiayezi.png` |
| 5100 | A Trinh | `zhenzi` | `zhenzi.swf.sam`, `image_zhenzi.png` |
| 15001 | Kayako clone A | `jiayezi` | `jiayezi.swf.sam`, `image_jiayezi.png` |
| 15002 | Kayako clone B | `jiayezi` | `jiayezi.swf.sam`, `image_jiayezi.png` |
| 15003 | Kayako clone C | `jiayezi` | `jiayezi.swf.sam`, `image_jiayezi.png` |
| 15101 | Sadako clone A | `zhenzi` | `zhenzi.swf.sam`, `image_zhenzi.png` |
| 15102 | Sadako clone B | `zhenzi` | `zhenzi.swf.sam`, `image_zhenzi.png` |
| 15103 | Sadako clone C | `zhenzi` | `zhenzi.swf.sam`, `image_zhenzi.png` |
| 15401 | Người nhện clone A | `spider` | `spider.swf.sam`, `image_spider.png` |
| 15402 | Người nhện clone B | `spider` | `spider.swf.sam`, `image_spider.png` |
| 15403 | Người nhện clone C | `spider` | `spider.swf.sam`, `image_spider.png` |
| 15601 | Thằng Hề clone A | `mai` | `mai.swf.sam`, `image_mai.png` |
| 15602 | Thằng Hề clone B | `mai` | `mai.swf.sam`, `image_mai.png` |
| 15603 | Thằng Hề clone C | `mai` | `mai.swf.sam`, `image_mai.png` |
| 15701 | Đà Chủ clone A | `mai` | `mai.swf.sam`, `image_mai.png` |
| 15702 | Đà Chủ clone B | `mai` | `mai.swf.sam`, `image_mai.png` |
| 15703 | Đà Chủ clone C | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16001 | Cảnh Trưởng Thép clone A | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16002 | Cảnh Trưởng Thép clone B | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16003 | Cảnh Trưởng Thép clone C | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16101 | Ninja Rùa clone A | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16102 | Ninja Rùa clone B | `mai` | `mai.swf.sam`, `image_mai.png` |
| 16103 | Ninja Rùa clone C | `mai` | `mai.swf.sam`, `image_mai.png` |
| 44100 | 香克斯 | `xiangkesi` | `xiangkesi.swf.sam`, `image_xiangkesi.png` |
| 44300 | 宇智波斑 | `ban` | `ban.swf.sam`, `image_ban.png` |
| 44400 | 阿尔泰尔 | `aertaier` | `aertaier.swf.sam`, `image_aertaier.png` |
| 74100 | Quái Nhân Dây Xích | `boss` | `boss.swf.sam`, `image_boss.png` |
| 74101 | Quái Nhân Dây Xích | `boss` | `boss.swf.sam`, `image_boss.png` |
| 84300 | 圣の香克斯 | `xiangkesi` | `xiangkesi.swf.sam`, `image_xiangkesi.png` |
| 84400 | 夏姆洛克 | `xiangkesi2` | `xiangkesi2.swf.sam`, `image_xiangkesi2.png` |
| 84700 | 圣の宇智波斑 | `ban` | `ban.swf.sam`, `image_ban.png` |
| 84800 | 因陀罗 | `ban2` | `ban2.swf.sam`, `image_ban2.png` |
| 84900 | 圣の阿尔泰尔 | `aertaier` | `aertaier.swf.sam`, `image_aertaier.png` |
| 85000 | 席利乌斯 | `aertaier2` | `aertaier2.swf.sam`, `image_aertaier2.png` |
