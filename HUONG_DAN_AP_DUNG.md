# Bản vá v2 — hình tướng và khung thẻ SAHHT WIKI

Gói này chứa các file cần chép đè/bổ sung, không chứa toàn bộ website.

## Cách áp dụng trên Windows

1. Dừng web đang chạy bằng Ctrl+C trong Terminal.
2. Sao lưu thư mục `SAHHT_export/web` hiện tại.
3. Giải nén ZIP. Chép thư mục `web` trong gói vào `SAHHT_export`, đồng ý thay thế các file trùng tên. Đây là thao tác gộp thư mục; không xoá thư mục web cũ. File mới `web/src/lib/hero-progression.ts` phải được chép cùng các file khác.
4. Mở Terminal tại `SAHHT_export/web` và chạy `npm.cmd run dev`.
5. Mở địa chỉ Local trong Terminal và nhấn Ctrl+F5 để tải lại.

Không cần cài lại thư viện: package.json và package-lock.json không thay đổi.
Nếu bạn đã sửa tiếp các file này sau khi gửi web.rar, hãy đưa gói vá cho Antigravity để gộp thay đổi trước khi chép đè.

## Sửa hình trong bản v2

- Chỉnh vùng nhìn rõ của ba ảnh full_43900.png, full_83900.png và full_84000.png bằng metadata CSS; không thay PNG nguồn.
- Lục Đạo Sasuke không còn bị thu nhỏ do phần khói mờ kéo dài ở nửa trên ảnh. Vùng đầu, thân và chân được căn đầy khu vực hình tướng; phần khói mờ ngoài vùng hiển thị bị giới hạn bởi viewport CSS.
- Hai dạng Chú Nguyền được căn chung một cách, giữ đầu, chân và cánh trong vùng hiển thị.
- Chừa chiều ngang cho phần hình nhô ra ngoài khung ở trang chi tiết, tránh cánh đè vào tên/thông tin tướng.
- Kích thước khung vẫn thống nhất; thay mốc khung không đổi tỉ lệ hình tướng.
- Giữ logic ban sức của bản trước. Bản v2 tập trung sửa hình và kích thước; không đổi danh sách khuyến nghị.
- Đã kiểm tra trực tiếp cả ba ID ở 1440px và 390px, cùng khung Cam++/Đỏ++/Vàng++ trên hai dạng có dữ liệu. Không có lỗi JavaScript trong các luồng đã kiểm tra.

## Những gì đã sửa trong bản trước (được giữ lại)

- ID 43900 không còn dùng bảng STH và đột phá sao chép trái với cờ của chính bản thể trong family_forms.
- Mốc mặc định chỉ được lấy từ các mốc áp dụng cho bản thể đó. Cam là phẩm gốc, không hiện nhãn “đã siêu tiến hoá” và không được cộng như chỉ số nâng cấp bổ sung.
- Nút Tối đa chỉ chọn mốc có trong dữ liệu bản thể; nút Mặc định đặt lại cả đột phá và STH.
- Khi đổi ID, bộ mô phỏng được tạo lại theo ID, tránh giữ mốc của bản thể trước.
- Lỗi ảnh được theo dõi theo URL, nên ảnh hợp lệ của tướng mới không bị kẹt ở trạng thái dự phòng sau một ảnh lỗi.
- Phần nội dung cạnh thẻ được phép co trong bố cục flex để khuyến nghị không đẩy tràn màn hình.
- Giữ hình toàn thân, asset mặt trăng/sao, khung rồng, huy hiệu và danh sách ban sức có sẵn. Mặt trăng trong gói nguồn đã là PNG; không có thay đổi font cho biểu tượng này.

## Kiểm tra đã thực hiện

- `npm run build`: thành công, bao gồm kiểm tra TypeScript và tạo trang production.
- `node --test tests/hero-artwork.test.mjs tests/hero-progression.test.mjs`: 8 bài kiểm tra qua, trong đó có đối chiếu xử lý cờ của cả 721 bản thể.
- Kiểm tra trình duyệt trên bản production: đổi qua lại ID 43900/83900/84000; chọn CS1, CS4, CS6, CS7; chọn Cam++/Đỏ++/Vàng++; nút Mặc định và Tối đa.
- Theo dữ liệu khuyến nghị đã gửi: Thần Thư của 43900/83900 mở ở CS1, của 84000 mở ở CS4. Kiểm tra UI có/không có gợi ý theo đúng mốc này.
- Kiểm tra vùng khuyến nghị trên màn hình 390px và desktop 1440px, ảnh toàn thân 84000 tải thành công, không có lỗi JavaScript trong các luồng đã kiểm tra.

## Giới hạn dữ liệu cần xử lý tiếp

Trong heroes_detail.json có 230 bản thể có cờ has_super_evo khác giữa family_forms và super_evo, cùng 139 bản thể có trạng thái đột phá khác giữa family_forms và breakthrough_system.

Bản vá không sửa JSON. Khi có cờ phủ định rõ ràng cho đúng ID trong family_forms, giao diện không áp dụng bảng chi tiết mâu thuẫn và dùng nhãn “Chưa có dữ liệu STH”, thay vì kết luận rằng bản thể chắc chắn không thể nâng cấp trong game. Nếu thiếu mục family_forms, dùng cờ của chính bảng chi tiết.

Cần đối chiếu lại pipeline tạo dữ liệu với config và Lua gốc để chốt các khả năng nâng cấp thực tế. Trong web.rar không có đủ nguồn này để xác minh toàn bộ. Các công thức lực chiến/chỉ số và chi phí nguyên liệu ngoài phạm vi bản vá chưa được kiểm chứng lại. Không coi việc build hoặc kiểm tra UI thành công là xác nhận toàn bộ dữ liệu game chính xác.

## File trong gói

- web/src/lib/hero-progression.ts (mới)
- web/src/components/HeroInteractiveView.tsx
- web/src/components/HeroCard.tsx
- web/src/components/ImageWithFallback.tsx
- web/src/app/heroes/[id]/page.tsx
- web/tests/hero-progression.test.mjs (mới)

Bản v2 bổ sung: web/src/lib/hero-artwork.ts và web/tests/hero-artwork.test.mjs.
