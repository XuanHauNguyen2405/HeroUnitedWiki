# 🌟 HeroUnitedWiki (Siêu Anh Hùng Hội Tụ WIKI)

Kho dữ liệu có cấu trúc và ứng dụng web tra cứu toàn diện về Tướng, Kỹ Năng, Trang Bị, Bộ Trang Bị, Bản Sức (Huy Hiệu), Vận Mệnh và Cơ chế Nâng Cấp (Chuyển Sinh, Siêu Tiến Hóa) cho tựa game **Siêu Anh Hùng Hội Tụ**.

![Next.js](https://img.shields.io/badge/Next.js-16.4-black?logo=next.js)
![TypeScript](https://img.shields.io/badge/TypeScript-5.0-blue?logo=typescript)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v4-38bdf8?logo=tailwindcss)
![Python](https://img.shields.io/badge/Python-3.10+-yellow?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📌 Tính Năng Nổi Bật

### 1. Tra cứu Tướng & Mô phỏng Chỉ số Thời gian thực
- **7 Mốc Chuyển Sinh:** Dũng Sĩ, Đấu Sĩ, Anh Hùng, Thần Thoại, Thần, Linh, Hồn kèm chi tiết điều kiện mở mốc, nguyên liệu từng chương (Đá Chuyển Sinh thường và Cao Cấp) và thẻ tướng bản sao (Clone Cards) theo cốt truyện.
- **Siêu Tiến Hóa (Cam, Đỏ, Vàng):** Gồm 9 mốc tiến cấp (`Cam`, `Cam+`, `Cam++`, `Đỏ`, `Đỏ+`, `Đỏ++`, `Vàng`, `Vàng+`, `Vàng++`) với hiệu ứng hào quang động.
  - **Mốc Đỏ:** Mở khóa Kỹ năng Siêu Tiến Hóa 1 (ví dụ: *Diêm Vương Luân Hồi Phục Sinh* ở Nagato, *Ma Lực Đâm Xuyên* ở Shadow).
  - **Mốc Vàng:** Mở khóa Kỹ năng Siêu Tiến Hóa 2 (ví dụ: *Ngoại đạo ma tượng* ở Nagato, *Ám Đao* ở Shadow).
- **Mô phỏng Chỉ số Level 1 – 255:** Tự động tính toán HP, PATK, MATK, DEF, Speed theo công thức tăng trưởng từ config game.
- **Kích hoạt Vận Mệnh (Fate Bonds):** Bật/tắt duyên phận tướng và trang bị trực tiếp, cộng dồn tỷ lệ % vào thuộc tính.

### 2. Huy Hiệu Anh Hùng Độc Quyền (Bản Sức)
- Tích hợp 112 Huy Hiệu độc quyền cho 14 tướng chủ lực (Nagato, Shadow, Songoku/Kakarot, Elaina, Broli, Shalltear, Maple, Tenka, Frieren...).
- Hỗ trợ chọn cấp bậc từ **Cấp 0 đến Cấp 7**, cộng dồn trực tiếp chỉ số và kích hoạt các kỹ năng tổ hợp đội hình lớn (*Siêu Anh Hùng Hội Tụ*, *Ngọc Rồng*, *Nữ Thần*).

### 3. Trang Bị & Bộ Trang Bị (Suits)
- Bảng tra cứu vũ khí, áo giáp, trang sức, giày theo từng phẩm chất.
- Hiển thị đầy đủ kích hoạt mốc 2 món, 3 món, 4 món.

### 4. Pipeline Xử lý Dữ liệu Chuẩn hóa (Python)
- Trích xuất trực tiếp từ các file cấu hình game nguồn (`character_detail.config`, `character_break_new.config`, `breakthrough.config`, `badge.config`, `suit.config`, `equip.config`).
- Bảo toàn 100% giá trị gốc, không suy diễn, hỗ trợ đối chiếu thực tế.

---

## 📂 Cấu Trúc Dự Án

```
HeroUnitedWiki/
├── config/                # 297 bảng cấu hình game nguồn (.config / JSON)
├── docs/                  # Tài liệu phân tích, báo cáo trích xuất và checklist kiểm định
├── lua/                   # Mã nguồn logic & giao diện game (.lua)
├── output/                # Kho dữ liệu chuẩn hóa dạng JSON (heroes, skills, equip, suits, ban_suc...)
├── preview/               # Bộ mẫu giao diện tĩnh đối chiếu dữ liệu thực tế
├── public/                # Tài nguyên hình ảnh, biểu tượng (assets/iphonehd)
├── tools/                 # Bộ công cụ Python trích xuất, xác minh và đồng bộ dữ liệu
└── web/                   # Ứng dụng web Next.js + React + TailwindCSS (App Router)
    ├── src/
    │   ├── app/           # Các trang: /heroes, /skills, /equipment, /suits, /ban-suc, /tier-list
    │   ├── components/    # HeroInteractiveView, ImageWithFallback, SearchModal...
    │   └── lib/           # Utility functions và data loader
    └── package.json
```

---

## 🚀 Hướng Dẫn Cài Đặt & Khởi Chạy

### 1. Yêu cầu hệ thống
- **Node.js** >= 18.x
- **Python** >= 3.9
- **npm** hoặc **yarn** / **pnpm**

### 2. Cài đặt dependencies cho Web
```bash
cd web
npm install
```

### 3. Chạy môi trường Development
```bash
npm run dev
```
Truy cập trình duyệt tại: [http://localhost:3000](http://localhost:3000)

### 4. Build phiên bản Production
```bash
npm run build
npm run start
```

### 5. Cập nhật dữ liệu từ nguồn game
Nếu có thay đổi trong `config/`:
```bash
python tools/prepare_web_data.py
```

---

## 🛠️ Công Nghệ Sử Dụng

- **Frontend:** [Next.js](https://nextjs.org/) (Turbopack, App Router), [React](https://react.dev/), [TypeScript](https://www.typescriptlang.org/), [Tailwind CSS](https://tailwindcss.com/)
- **Data Engineering:** [Python](https://www.python.org/) (Regex parsing, JSON normalization, Schema validation)
- **Design:** Modern Dark Mode, Glassmorphism, Micro-animations, Responsive Layouts

---

## 📄 Bản Quyền & Giấy Phép
Dự án được xây dựng phục vụ mục đích tra cứu cộng đồng phi thương mại.
Mọi tài nguyên bản quyền game thuộc về nhà phát hành trò chơi gốc.
Phát triển bởi **XuanHauNguyen2405** (Hau2405).
