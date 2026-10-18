# Siêu Anh Hùng Hội Tụ WIKI - Web Application

Website bách khoa toàn thư tra cứu dữ liệu game mobile **Siêu Anh Hùng Hội Tụ** được xây dựng bằng **Next.js (App Router) + TypeScript + Tailwind CSS**, tích hợp trực tiếp dữ liệu trích xuất từ cấu hình game nguyên bản (`output/*.json`) và kho ảnh thật (`public/assets/`).

---

## 1. Hướng Dẫn Cài Đặt & Khởi Chạy Localhost

### Yêu Cầu Môi Trường
- Node.js v18 trở lên (Khuyến nghị Node.js v20+)
- Python 3.10+ (để chạy pipeline chuẩn bị dữ liệu)

### Khởi Chạy Server Phát Triển (Development)
Di chuyển vào thư mục `web/` và chạy lệnh:

```bash
cd web
npm run dev
# Hoặc trên Windows PowerShell:
# npm.cmd run dev
```

Truy cập website tại: **[http://localhost:3000](http://localhost:3000)**

### Biên Dịch & Chạy Bản Production
```bash
cd web
npm run build
npm run start
```

---

## 2. Kiến Trúc & Cấu Trúc Dữ Liệu

Ứng dụng được thiết kế phân tầng hiệu năng cao, tránh tải các tệp JSON thô khổng lồ (như `skills.json` 16MB) xuống trình duyệt người dùng:

```
web/
├── public/
│   └── assets/                  # Ảnh tĩnh thật được copy từ public/assets/ (2.878 ảnh, 44.2MB)
│       └── iphonehd/            # Cấu trúc đồng bộ: icon/, img/, hero/, equip/, effect/
│                                # (Loại bỏ 100% tệp .lua, .plist, .wav)
├── src/
│   ├── app/                     # Next.js App Router
│   │   ├── page.tsx             # Trang chủ (Hero search, lối vào danh mục, thống kê)
│   │   ├── heroes/              # Danh mục 721 tướng (bộ lọc phẩm, nghề, ảnh, phân trang)
│   │   │   └── [id]/page.tsx    # Chi tiết bản thể tướng (chỉ số, tăng trưởng, 7 kỹ năng, duyên)
│   │   ├── skills/              # Danh mục kỹ năng (phân loại, phẩm cấp, tìm kiếm)
│   │   │   └── [id]/page.tsx    # Chi tiết kỹ năng (chuỗi tiến hóa, tướng sử dụng, công thức gốc)
│   │   ├── suits/               # Danh mục bộ trang bị (preview 4 món, kích hoạt 2/3/4 món)
│   │   │   └── [id]/page.tsx    # Chi tiết bộ (danh sách món, chỉ số kích hoạt chi tiết)
│   │   ├── equipment/           # Danh mục 4.366 trang bị (lọc slot 1-4, phẩm chất, bộ)
│   │   │   └── [id]/page.tsx    # Chi tiết trang bị (chỉ số chính/phụ, tiến hóa kế tiếp)
│   │   ├── ban-suc/             # Ban Sức Vận Mệnh (10 hệ đá, 112 huy hiệu, kỹ năng tổ hợp)
│   │   │   └── page.tsx
│   │   ├── tier-list/           # Tier List biên tập (trạng thái bản thảo, minh bạch không đoán mò)
│   │   │   └── page.tsx
│   │   ├── guides/              # Cẩm nang & Hướng dẫn thực chiến
│   │   │   ├── page.tsx         # Danh sách bài viết
│   │   │   └── [id]/page.tsx    # Chi tiết bài hướng dẫn
│   │   ├── api/search/          # API tìm kiếm nhanh đa thực thể (hỗ trợ tiếng Việt có/không dấu)
│   │   │   └── route.ts
│   │   └── not-found.tsx        # Trang 404 thân thiện, xử lý an toàn tham chiếu thiếu
│   ├── components/              # Các UI Component tái sử dụng (Header, SearchBar, Fallback Image...)
│   ├── data/                    # Lát cắt dữ liệu tối ưu hóa tạo bởi prepare_web_data.py
│   │   ├── search_index.json    # Chỉ mục tìm kiếm nhẹ (~14.600 thực thể)
│   │   ├── heroes_catalog.json  # Catalog tướng cho client (223 KB)
│   │   ├── heroes_detail.json   # Chi tiết tướng phục vụ server-side render
│   │   ├── skills_catalog.json  # Catalog kỹ năng
│   │   ├── skills_detail.json   # Chi tiết kỹ năng + chuỗi tiến hóa
│   │   ├── suits_catalog.json   # Danh mục bộ trang bị
│   │   ├── suits_detail.json    # Chi tiết bộ trang bị
│   │   ├── equipment_catalog.json # Danh mục trang bị
│   │   ├── equipment_detail.json  # Chi tiết trang bị
│   │   ├── ban_suc.json         # Dữ liệu 10 hệ đá, 112 huy hiệu, kỹ năng tổ hợp
│   │   └── editorial_data.json  # Dữ liệu bài viết biên tập độc lập
│   └── lib/
│       ├── data.ts              # Data getters đọc từ disk an toàn
│       └── utils.ts             # Chuẩn hóa tiếng Việt, cấu hình màu phẩm cấp, format số
```

---

## 3. Quy Trình Cập Nhật Dữ Liệu & Đồng Bộ Ảnh

Khi có dữ liệu trích xuất mới từ `output/*.json`:

1. Đặt các tệp JSON cập nhật vào thư mục `output/` ở thư mục gốc.
2. Chạy công cụ tiền xử lý tự động:

```bash
# Chạy từ thư mục gốc của repository:
python tools/prepare_web_data.py
```

Công cụ `tools/prepare_web_data.py` tự động:
- **Sao chép tài nguyên ảnh**: Quét `public/assets/`, chỉ sao chép các tệp ảnh hợp lệ (`.png`, `.jpg`, `.jpeg`, `.webp`) vào `web/public/assets/`, loại trừ toàn bộ file `.lua`, `.plist`, `.wav`.
- **Ánh xạ đường dẫn URL**: Chuyển đổi đường dẫn đĩa vật lý `public/assets/...` thành URL web chuẩn `/assets/...`.
- **Tạo chỉ mục tìm kiếm**: Sinh `search_index.json` gồm tiêu đề gốc và tiêu đề chuẩn hóa không dấu (`clean_title`) để tìm kiếm tức thì.
- **Tạo các lát cắt dữ liệu**: Tách nhỏ `heroes`, `skills`, `suits`, `equipment` thành catalog và detail tương ứng.
- **Xây dựng chuỗi tiến hóa & tra cứu ngược**: Tự động tính toán chuỗi kỹ năng tiến hóa kế tiếp và danh sách các tướng sở hữu từng kỹ năng.

---

## 4. Cách Thêm & Biên Tập Bài Viết Hướng Dẫn

Để đảm bảo nguyên tắc **tách rời 100% dữ liệu game gốc khỏi nhận định chủ quan của biên tập viên**, toàn bộ bài viết được quản lý tại:

`web/src/data/editorial_data.json`

### Cấu Trúc Bài Viết Hướng Dẫn:
```json
{
  "id": "ten-bai-viet-slug",
  "title": "Tiêu Đề Bài Viết Hướng Dẫn",
  "category": "Cơ bản / Trang bị / Ban Sức / Đội hình",
  "status": "draft / published",
  "summary": "Tóm tắt ngắn gọn hiển thị tại thẻ xem trước danh mục.",
  "message": "Nội dung chi tiết của bài viết hoặc ghi chú biên tập."
}
```

Sau khi thêm bài viết vào `editorial_data.json`, website sẽ tự động cập nhật ngay lập tức tại `/guides` và `/guides/[id]`.

---

## 5. Nguyên Tắc Trình Bày & Bảo Toàn Dữ Liệu

1. **Bảo Toàn ID Tướng & Bản Thể**:
   - Website phân biệt rõ ràng giữa **Mã Bản Thể (Variant ID)** và **Mã Nhóm Tướng (Character ID)**.
   - Mỗi bản thể (ví dụ: Naruto 1 sao, Naruto Tiên Nhân, Naruto Lục Đạo) được lưu giữ trang chi tiết riêng biệt với đầy đủ chỉ số tăng trưởng độc lập.

2. **Minh Bạch - Không Đoán Mò Công Thức**:
   - Các trường chỉ số chưa rõ công thức tính toán hoặc chưa xác minh đơn vị được giữ nguyên giá trị cấu hình nguồn và gắn nhãn rõ ràng: `(Chưa xác minh cách tính/đơn vị)`.
   - Thuộc tính chưa xác minh tên gọi hiển thị rõ: `(Mã: X - Chưa xác minh tên gọi thuộc tính)`.
   - Thời gian hồi chiêu hiển thị giá trị thô: `CD: X (Chưa xác minh đơn vị)`.

3. **Xử Lý Ảnh Thiếu Thống Nhất**:
   - Nếu bản ghi chưa tìm thấy ảnh trên đĩa, component `ImageWithFallback` hiển thị placeholder chuyên nghiệp với nhãn: `"Chưa tìm thấy ảnh"`, tuyệt đối không để vỡ giao diện hoặc lỗi console.

4. **An Toàn Tuyệt Đối Khi Thiếu Tham Chiếu**:
   - Chỉ tạo liên kết tới các đối tượng thực sự tồn tại trong cấu hình. Các tham chiếu thiếu được thông báo rõ ràng mà không gây lỗi HTTP 500 hay crash ứng dụng.

5. **Độc Lập Hoàn Toàn Với Thư Mục Cũ**:
   - Website hoạt động 100% độc lập, không còn bất kỳ đường dẫn hay phụ thuộc nào tới thư mục `apk/` hay `output/apk_extracted/`.
