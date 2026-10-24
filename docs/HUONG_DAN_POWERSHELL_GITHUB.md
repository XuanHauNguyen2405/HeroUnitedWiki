# 📘 HƯỚNG DẪN SỬ DỤNG POWERSHELL & GITHUB (DỰ ÁN SAHHT WIKI)

Tài liệu này hướng dẫn chi tiết từng bước dành cho người mới bắt đầu làm quen với **PowerShell** và **Git/GitHub** trên hệ điều hành Windows. Hướng dẫn bao gồm toàn bộ quy trình: từ kiểm tra công cụ, mở website trên máy cá nhân hằng ngày, đến cách lưu trữ và cập nhật mã nguồn an toàn lên GitHub.

---

## 📑 MỤC LỤC
1. [Khảo Sát Thực Tế Dự Án & Workspace](#1-khảo-sát-thực-tế-dự-án--workspace)
2. [Khối Lệnh Mở Nhanh Website Hằng Ngày](#2-khối-lệnh-mở-nhanh-website-hằng-ngày)
3. [Hướng Dẫn Mở Website Trên Máy Bằng PowerShell](#3-hướng-dẫn-mở-website-trên-máy-bằng-powershell)
4. [Hướng Dẫn Chạy Bản Production Tại Máy Cục Bộ](#4-hướng-dẫn-chạy-bản-production-tại-máy-cục-bộ)
5. [Hướng Dẫn Đẩy Dự Án Lên GitHub Lần Đầu](#5-hướng-dẫn-đẩy-dự-án-lên-github-lần-đầu)
6. [Hướng Dẫn Cập Nhật GitHub Những Lần Sau](#6-hướng-dẫn-cập-nhật-github-những-lần-sau)
7. [Xử Lý 11 Lỗi Thường Gặp (Nguyên Nhân & Cách Sửa)](#7-xử-lý-11-lỗi-thường-gặp-nguyên-nhân--cách-sửa)
8. [Phân Biệt Lưu Code GitHub & Đưa Web Lên Mạng (Deploy)](#8-phân-biệt-lưu-code-github--đưa-web-lên-mạng-deploy)

---

## 1. KHẢO SÁT THỰC TẾ DỰ ÁN & WORKSPACE

Dưới đây là các thông số thực tế của dự án trên máy tính của bạn:

- **Thư mục gốc dự án (Repository Root):**  
  `C:\Users\Utente\Desktop\SAHHT_export`  
  *(Đây là nơi chứa thư mục `.git`, thư mục cấu hình game `config/`, công cụ `tools/`, tài liệu `docs/` và thư mục ứng dụng web `web/`).*
- **Thư mục ứng dụng web (Next.js Web App):**  
  `C:\Users\Utente\Desktop\SAHHT_export\web`  
  *(Tệp cấu hình `package.json` và mã nguồn web nằm tại đây).*
- **Trình quản lý package & Lockfile:**  
  Dự án sử dụng **npm** và có tệp khóa `package-lock.json` đi kèm.
- **Yêu cầu môi trường:**
  - **Node.js:** Phiên bản `>= 18.x` (Máy hiện tại đang cài đặt: `v24.22.0`).
  - **npm:** Đi kèm Node.js (Máy hiện tại đang cài đặt: `11.19.1`).
  - **Git:** Phần mềm quản lý phiên bản (Máy hiện tại đang cài đặt: `git version 2.56.0`).
- **Kho lưu trữ GitHub thực tế (Remote URL):**  
  `https://github.com/XuanHauNguyen2405/HeroUnitedWiki.git` (Nhánh chính: `main`).

> [!IMPORTANT]
> **Quy tắc vàng khi dùng PowerShell trên Windows:**
> 1. **Dùng lệnh `npm.cmd` thay vì `npm`:** Mặc định Windows chặn thực thi tệp `npm.ps1` vì chính sách bảo mật (`ExecutionPolicy`). Sử dụng `npm.cmd` sẽ chạy trực tiếp tệp lệnh Windows, tương thích 100% mà **không cần tắt bảo mật hệ thống**.
> 2. **Không nối lệnh bằng `&&`:** Windows PowerShell 5.1 mặc định không hỗ trợ toán tử `&&`. Luôn gõ từng lệnh riêng biệt hoặc dùng dấu chấm phẩy `;`.
> 3. **Đường dẫn có khoảng trắng/ký tự đặc biệt:** Luôn đặt đường dẫn thư mục trong cặp dấu ngoặc kép `""`.

---

## 2. KHỐI LỆNH MỞ NHANH WEBSITE HẰNG NGÀY

Mỗi khi bật máy tính hoặc muốn mở lại trang web để tra cứu / thử nghiệm, bạn chỉ cần mở PowerShell và chạy 2 dòng lệnh sau:

```powershell
Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export\web"
npm.cmd run dev
```

*Sau khi thấy dòng chữ `- Local: http://localhost:3000` hiện ra, hãy mở trình duyệt web (Chrome, Edge) và truy cập địa chỉ:*  
👉 **http://localhost:3000**

---

## 3. HƯỚNG DẪN MỞ WEBSITE TRÊN MÁY BẰNG POWERSHELL

Thực hiện tuần tự theo 6 bước dưới đây:

### Bước 1: Mở cửa sổ dòng lệnh PowerShell
Bạn có thể mở theo một trong hai cách:
- **Cách 1 (Từ Windows):** Nhấn phím `Windows` trên bàn phím, gõ chữ `PowerShell`, rồi nhấn `Enter`.
- **Cách 2 (Trong Antigravity IDE / VSCode):** Nhấn tổ hợp phím `` Ctrl + ` `` (phím dấu huyền cạnh số 1) để mở Terminal tích hợp sẵn.

### Bước 2: Kiểm tra các công cụ Node.js, npm và Git
Gõ lần lượt các lệnh sau vào PowerShell để đảm bảo máy tính đã nhận diện đầy đủ công cụ:

```powershell
node --version
npm.cmd --version
git --version
```

- **Kết quả mong đợi:** Mỗi lệnh sẽ in ra một số phiên bản (ví dụ: `v24.22.0`, `11.19.1`, `git version 2.56.0`).
- **Nếu báo lỗi đỏ `'node' is not recognized`:** Bạn chưa cài Node.js. Hãy tải bộ cài chính thức tại [https://nodejs.org/](https://nodejs.org/) (chọn bản **LTS**), cài đặt theo mặc định rồi khởi động lại PowerShell.
- **Nếu báo lỗi đỏ `'git' is not recognized`:** Bạn chưa cài Git. Hãy tải bộ cài chính thức tại [https://git-scm.com/download/win](https://git-scm.com/download/win), cài đặt theo mặc định rồi mở lại PowerShell.

### Bước 3: Di chuyển vào đúng thư mục ứng dụng web
Ứng dụng web Next.js nằm trong thư mục `web`. Bạn phải đứng tại thư mục `web` thì lệnh npm mới tìm thấy tệp `package.json`:

```powershell
Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export\web"
```
*(Hoặc dùng lệnh rút gọn: `cd "C:\Users\Utente\Desktop\SAHHT_export\web"`)*

- **Cách kiểm tra:** Gõ `Get-Location` hoặc nhìn đầu dòng lệnh hiển thị đường dẫn kết thúc bằng `...\web`.

### Bước 4: Cài đặt thư viện phụ thuộc (Dependencies)
- **Lần đầu tiên mở dự án (hoặc sau khi tải mã nguồn mới về):**
  Chạy lệnh cài đặt đồng bộ chính xác theo tệp `package-lock.json`:
  ```powershell
  npm.cmd ci
  ```
  *(Nếu lệnh trên báo lỗi mạng, bạn có thể chạy `npm.cmd install`). Tiến trình sẽ tải các thư viện React, Next.js, TailwindCSS vào thư mục `web/node_modules/`.*
- **Những lần mở web sau:**
  Khi thư mục `web/node_modules/` đã tồn tại trên máy, bạn **BỎ QUA** bước này và sang thẳng Bước 5.

### Bước 5: Kiểm tra cấu hình môi trường (.env)
- Dự án SAHHT WIKI là ứng dụng web tra cứu dữ liệu tĩnh nội bộ (`web/src/data/*.json`).
- **Dự án KHÔNG cần tệp `.env` hay khóa API bí mật nào.** Bạn không cần tạo hay chỉnh sửa tệp môi trường.

### Bước 6: Khởi chạy máy chủ phát triển (Development Server)
Chạy lệnh khởi động:

```powershell
npm.cmd run dev
```

- **Kết quả mong đợi trên màn hình Terminal:**
  ```text
  ▲ Next.js 16.4.2 (Turbopack)
  - Local:        http://localhost:3000
  - Network:      http://192.168.x.x:3000

  ✓ Ready in 1200ms
  ```
- **Cách vào website:** Mở trình duyệt và truy cập: [http://localhost:3000](http://localhost:3000).
- **Trường hợp cổng 3000 bị chiếm:** Nếu cổng 3000 đang được một phần mềm khác sử dụng, Next.js sẽ tự động chuyển sang cổng tiếp theo (ví dụ: `http://localhost:3001`). Hãy nhìn dòng `- Local:` trên màn hình để bấm đúng link.
- **Cách dừng máy chủ web:** Khi muốn tắt web, quay lại cửa sổ PowerShell và nhấn tổ hợp phím:
  `Ctrl + C`  
  *(Nếu terminal hỏi `Terminate batch job (Y/N)?`, hãy gõ chữ `Y` rồi nhấn `Enter`).*

---

## 4. HƯỚNG DẪN CHẠY BẢN PRODUCTION TẠI MÁY CỤC BỘ

### Khi nào cần dùng bản Production?
- Khi bạn muốn kiểm tra tốc độ tải trang thực tế, độ mượt mà tối đa của website.
- Khi muốn kiểm tra biên dịch mã nguồn (TypeScript & Turbopack) để đảm bảo không có bất kỳ lỗi cú pháp nào trước khi bàn giao hoặc đẩy lên hosting.

### Các bước thực hiện:
Tại thư mục `web`, chạy lần lượt 2 lệnh sau:

```powershell
Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export\web"
npm.cmd run build
```
- Lệnh này sẽ biên dịch toàn bộ các trang App Router (`/heroes`, `/skills`, `/equipment`, `/suits`, `/ban-suc`, `/tier-list`) thành các tệp HTML/JS tĩnh tối ưu vào thư mục `web/.next/`. Kết quả báo `Compiled successfully` là đạt.

Sau khi build xong, khởi chạy máy chủ production:
```powershell
npm.cmd run start
```
- Mở trình duyệt tại [http://localhost:3000](http://localhost:3000) để trải nghiệm phiên bản tối ưu hóa cao nhất.

---

## 5. HƯỚNG DẪN ĐẨY DỰ ÁN LÊN GITHUB LẦN ĐẦU

### Phân biệt 2 tình huống:

#### Tình huống A: Dự án ĐÃ CÓ Git và Remote GitHub (Trạng thái hiện tại của bạn)
Kho lưu trữ của bạn đã được kết nối với repository:  
`https://github.com/XuanHauNguyen2405/HeroUnitedWiki.git`

Bạn chỉ cần thực hiện từ [Bước 3: Rà soát tệp và tạo Commit](#bước-3-rà-soát-tệp-trước-khi-stage) bên dưới.

---

#### Tình huống B: Bắt đầu từ đầu với một kho lưu trữ GitHub hoàn toàn mới

### Bước 1: Tạo kho lưu trữ mới trên trang web GitHub
1. Đăng nhập vào tài khoản của bạn tại [https://github.com](https://github.com).
2. Nhấn vào dấu cộng `+` ở góc trên bên phải -> Chọn **New repository**.
3. Điền thông tin:
   - **Repository name:** Điền tên dự án (ví dụ: `HeroUnitedWiki` hoặc `SAHHT_Wiki`).
   - **Public / Private:** Chọn Public (công khai) hoặc Private (riêng tư) tùy ý.
   - **Initialize this repository with:** **KHÔNG** tích chọn *Add a README file*, **KHÔNG** tích chọn *.gitignore*, **KHÔNG** tích chọn *license* (vì máy tính của bạn đã có sẵn các tệp này).
4. Nhấn **Create repository**.
5. GitHub sẽ hiển thị đường link của kho lưu trữ, có dạng:  
   `https://github.com/<TÊN_TÀI_KHOẢN>/<TÊN_REPO>.git`  
   *(Trong các lệnh bên dưới, chuỗi này được gọi là `<REPO_URL>`).*

### Bước 2: Đảm bảo đứng tại đúng thư mục gốc của dự án
> [!WARNING]
> Tuyệt đối **KHÔNG** chạy lệnh `git init` bên trong thư mục `web/` vì sẽ tạo ra kho Git lồng nhau gây lỗi. Luôn đứng tại thư mục gốc `SAHHT_export`:

```powershell
Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export"
```

Kiểm tra thư mục gốc hiện tại:
```powershell
git rev-parse --show-toplevel
```
*(Kết quả phải trả về đường dẫn thư mục gốc `C:/Users/Utente/Desktop/SAHHT_export`).*

Nếu dự án chưa từng khởi tạo Git bao giờ:
```powershell
git init
git branch -M main
```

### Bước 3: Cấu hình danh tính người dùng Git (Nếu chưa có)
Kiểm tra cấu hình hiện tại:
```powershell
git config user.name
git config user.email
```
Nếu chưa có hoặc muốn thay đổi thông tin của chính bạn:
```powershell
git config --global user.name "Hau2405"
git config --global user.email "nguyenxuanhau890@gmail.com"
```
*(Thay thế bằng tên và email tài khoản GitHub thực tế của bạn).*

### Bước 4: Rà soát tệp và quy tắc loại trừ (.gitignore)
Dự án đã có tệp `.gitignore` chuẩn hóa ở thư mục gốc:
- **Được loại trừ tự động (Không đưa lên Git):**
  - `web/node_modules/` (thư viện ngoài, nặng > 400 MB).
  - `web/.next/` (build cache, nặng > 400 MB).
  - `apk/` & `*.apk` (tệp cài đặt game nguyên bản, nặng gần 1 GB).
  - `*.zip`, `*.rar`, `*.7z` (các gói nén sao lưu).
  - `__pycache__/` và các tệp nhật ký `.log`.
- **Được bảo tồn và đẩy lên Git:**
  - Toàn bộ mã nguồn web `web/src/` và dữ liệu chuẩn hóa `web/src/data/*.json`.
  - Toàn bộ tệp cấu hình game `config/*.config`.
  - Toàn bộ công cụ pipeline `tools/*.py`.
  - Toàn bộ tài liệu kỹ thuật `docs/*.md`.
  - Toàn bộ tài nguyên hiển thị website `web/public/assets/`.

Kiểm tra kích thước tệp lớn nhất:
- Tệp lớn nhất trong mã nguồn là `web/src/data/heroes_detail.json` (~20,19 MB).
- Toàn bộ các tệp dự án đều **nhỏ hơn 21 MB**, nằm an toàn dưới giới hạn 50 MB cảnh báo và 100 MB từ chối của GitHub. Do đó dự án **hoạt động hoàn hảo với Git tiêu chuẩn, không cần cấu hình Git LFS phức tạp**.

### Bước 5: Xem trạng thái và đưa tệp vào hàng đợi (Stage)
Xem danh sách các tệp thay đổi:
```powershell
git status
```

Đưa tất cả các tệp hợp lệ vào hàng đợi commit:
```powershell
git add .
```

Kiểm tra lại danh sách chuẩn bị commit:
```powershell
git status
```
*(Các tệp hiển thị màu xanh lá là các tệp đã sẵn sàng được ghi nhận).*

### Bước 6: Tạo bản ghi commit
Gõ lệnh commit với nội dung mô tả rõ ràng:
```powershell
git commit -m "feat: cập nhật toàn diện dữ liệu và giao diện wiki"
```

### Bước 7: Cấu hình Remote và đẩy lên GitHub (Push)
- **Nếu là kho lưu trữ mới tạo (Tình huống B):**
  ```powershell
  git remote add origin <REPO_URL>
  git push -u origin main
  ```
  *(Thay `<REPO_URL>` bằng đường link GitHub bạn đã tạo ở Bước 1, ví dụ: `https://github.com/XuanHauNguyen2405/HeroUnitedWiki.git`).*

- **Nếu đã có sẵn Remote `origin` (Tình huống A hiện tại):**
  ```powershell
  git push origin main
  ```

### Bước 8: Đăng nhập xác thực tài khoản GitHub
- Khi bạn chạy lệnh `git push` lần đầu, Windows sẽ tự động mở một cửa sổ nhỏ của **Git Credential Manager** hoặc trình duyệt web.
- Hãy nhấn vào nút xanh **"Sign in with your browser"**.
- Trình duyệt sẽ hiện trang xác thực của GitHub -> Nhấn nút **"Authorize GitCredentialManager"**.
- Cửa sổ PowerShell sẽ tự động hoàn tất quá trình đẩy mã nguồn lên GitHub.
- **Tuyệt đối không cần tạo Personal Access Token thủ công hay dán mật khẩu vào cửa sổ dòng lệnh.**

---

## 6. HƯỚNG DẪN CẬP NHẬT GITHUB NHỮNG LẦN SAU

Sau mỗi lần bạn sửa đổi giao diện, cập nhật dữ liệu hoặc thêm tài liệu mới, hãy thực hiện quy trình 5 bước ngắn sau:

### Quy trình 5 bước cập nhật:

```powershell
# Bước 1: Về đúng thư mục gốc dự án
Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export"

# Bước 2: Xem trạng thái các tệp đã sửa đổi
git status

# Bước 3: Đưa các thay đổi vào hàng đợi
git add .

# Bước 4: Tạo commit với ghi chú ngắn gọn về việc vừa làm
git commit -m "docs: cập nhật hướng dẫn powershell và github"

# Bước 5: Đẩy lên GitHub
git push origin main
```

### Cách đồng bộ khi GitHub có thay đổi mới (Từ máy khác hoặc sửa trên web):
Nếu bạn có chỉnh sửa tệp trực tiếp trên giao diện website GitHub hoặc làm việc từ một máy tính khác, trước khi sửa code trên máy này hãy gõ lệnh:
```powershell
git pull origin main
```
Lệnh này sẽ tải các commit mới nhất về máy tính của bạn một cách an toàn.

---

## 7. XỬ LÝ 11 LỖI THƯỜNG GẶP (NGUYÊN NHÂN & CÁCH SỬA)

### Lỗi 1: Không nhận diện `node`, `npm` hoặc `git`
- **Thông báo lỗi:** `'node' is not recognized as an internal or external command...`
- **Nguyên nhân:** Phần mềm chưa được cài đặt, hoặc sau khi cài đặt chưa khởi động lại terminal để nhận diện biến môi trường `PATH`.
- **Cách sửa:**
  1. Tải và cài đặt Node.js từ [https://nodejs.org](https://nodejs.org) và Git từ [https://git-scm.com](https://git-scm.com).
  2. Đóng toàn bộ các cửa sổ PowerShell và Antigravity IDE, sau đó mở lại.

---

### Lỗi 2: Chặn thực thi tệp `npm.ps1` trên PowerShell
- **Thông báo lỗi:** `File C:\Program Files\nodejs\npm.ps1 cannot be loaded because running scripts is disabled on this system. (PSSecurityException)`
- **Nguyên nhân:** Windows PowerShell mặc định đặt `ExecutionPolicy` ở mức `Restricted` để chống virus thực thi kịch bản `.ps1`.
- **Cách sửa chuẩn xác nhất (Không cần đổi bảo mật Windows):**
  - Luôn gõ **`npm.cmd`** thay vì `npm`.
  - Ví dụ: Dùng `npm.cmd run dev`, `npm.cmd install`, `npm.cmd run build`. Tệp `.cmd` là tệp thực thi batch an toàn của Windows và không bao giờ bị chính sách PowerShell chặn.

---

### Lỗi 3: Chạy sai thư mục, không tìm thấy `package.json`
- **Thông báo lỗi:** `npm error ENOENT: no such file or directory, open 'C:\Users\...\package.json'`
- **Nguyên nhân:** Bạn đang đứng ở thư mục gốc `SAHHT_export` thay vì thư mục `web`.
- **Cách sửa:**
  Chuyển vào thư mục `web`:
  ```powershell
  Set-Location -Path "C:\Users\Utente\Desktop\SAHHT_export\web"
  ```
  Sau đó chạy lại lệnh `npm.cmd run dev`.

---

### Lỗi 4: Cổng 3000 đang bị phần mềm khác sử dụng
- **Thông báo lỗi:** `Port 3000 is in use, trying 3001 instead` hoặc web không chịu tải.
- **Nguyên nhân:** Một phiên bản web cũ đang chạy ngầm hoặc một phần mềm khác đang chiếm cổng 3000.
- **Cách sửa:**
  - **Cách đơn giản:** Next.js sẽ tự đổi sang cổng 3001, bạn chỉ cần mở trình duyệt tại `http://localhost:3001`.
  - **Cách tắt tiến trình cũ chiếm cổng 3000:** Chạy 2 lệnh sau trên PowerShell:
    ```powershell
    $procId = (Get-NetTCPConnection -LocalPort 3000 -ErrorAction SilentlyContinue).OwningProcess
    if ($procId) { Stop-Process -Id $procId -Force; Write-Host "Đã giải phóng cổng 3000!" }
    ```

---

### Lỗi 5: Không mở được `localhost:3000` trên trình duyệt
- **Thông báo lỗi:** Trình duyệt báo `This site can’t be reached` hoặc `ERR_CONNECTION_REFUSED`.
- **Nguyên nhân:** Máy chủ Next.js chưa được bật, hoặc đã bị tắt bằng Ctrl+C.
- **Cách sửa:**
  1. Nhìn vào cửa sổ PowerShell xem có dòng chữ `✓ Ready in ...ms` không.
  2. Nếu cửa sổ PowerShell đang ở dấu nhắc lệnh `PS C:\...>`, nghĩa là web chưa chạy. Hãy chạy lại:
     ```powershell
     cd "C:\Users\Utente\Desktop\SAHHT_export\web"
     npm.cmd run dev
     ```
  3. Giữ nguyên cửa sổ PowerShell đang chạy, không được đóng cửa sổ này trong suốt thời gian xem web.

---

### Lỗi 6: Báo lỗi thiếu thư viện module (`Cannot find module...`)
- **Thông báo lỗi:** `Module not found: Can't resolve 'next' ...` hoặc thiếu thư viện sau khi clone.
- **Nguyên nhân:** Thư mục `node_modules` chưa được tải về máy.
- **Cách sửa:**
  Vào thư mục `web` và cài đặt lại:
  ```powershell
  cd "C:\Users\Utente\Desktop\SAHHT_export\web"
  npm.cmd install
  ```

---

### Lỗi 7: Git báo chưa có `user.name` hoặc `user.email`
- **Thông báo lỗi:** `fatal: unable to auto-detect email address` hoặc `Author identity unknown`.
- **Nguyên nhân:** Git trên máy tính mới chưa được gán tên tác giả cho các bản ghi commit.
- **Cách sửa:**
  Chạy lệnh gán thông tin (thay bằng tên và email của bạn):
  ```powershell
  git config --global user.name "Hau2405"
  git config --global user.email "nguyenxuanhau890@gmail.com"
  ```

---

### Lỗi 8: Báo lỗi Remote đã tồn tại hoặc đường link sai
- **Thông báo lỗi:** `fatal: remote origin already exists.`
- **Nguyên nhân:** Bạn chạy lệnh `git remote add origin` khi kho lưu trữ đã có remote `origin` từ trước.
- **Cách kiểm tra:** Gõ `git remote -v` để xem đường link hiện tại.
- **Cách sửa:** Đổi đường link sang URL mới bằng lệnh:
  ```powershell
  git remote set-url origin <REPO_URL>
  ```

---

### Lỗi 9: Lỗi xác thực tài khoản GitHub (`Permission denied` / `403`)
- **Thông báo lỗi:** `remote: Permission to XuanHauNguyen2405/HeroUnitedWiki.git denied to <tai_khoan_khac>.` hoặc `Authentication failed`.
- **Nguyên nhân:** Windows Credential Manager đang ghi nhớ thông tin đăng nhập của một tài khoản GitHub cũ khác trên máy tính.
- **Cách sửa:**
  1. Nhấn phím `Windows` -> Gõ `Credential Manager` (Quản lý thông tin xác thực) -> Mở ứng dụng.
  2. Chọn mục **Windows Credentials**.
  3. Tìm các dòng có chữ `git:https://github.com` -> Bấm vào mũi tên mở rộng -> Chọn **Remove** (Xóa bỏ).
  4. Quay lại PowerShell gõ `git push origin main`, cửa sổ đăng nhập trình duyệt sẽ hiện ra để bạn đăng nhập đúng tài khoản mới.

---

### Lỗi 10: Push bị từ chối do remote có commit mới (`non-fast-forward`)
- **Thông báo lỗi:** `error: failed to push some refs to ... Updates were rejected because the remote contains work that you do not have locally.`
- **Nguyên nhân:** Trên GitHub đang có commit mới hơn máy của bạn (ví dụ ai đó vừa push, hoặc bạn vừa sửa tệp trực tiếp trên trang github.com).
- **Cách sửa an toàn (Tuyệt đối không dùng force push làm mất dữ liệu):**
  1. Kéo dữ liệu mới về và tự động ghép với thay đổi của bạn:
     ```powershell
     git pull --rebase origin main
     ```
  2. Sau khi kéo về thành công, đẩy tiếp lên GitHub:
     ```powershell
     git push origin main
     ```
  - *Nếu có xung đột (conflict):* VSCode / IDE sẽ đánh dấu các đoạn xung đột bằng `<<<<<<< HEAD` và `>>>>>>>`. Hãy chọn "Accept Current Change" (giữ thay đổi của bạn) hoặc "Accept Both Changes", lưu tệp lại, sau đó gõ:
    ```powershell
    git add .
    git rebase --continue
    git push origin main
    ```

---

### Lỗi 11: File quá lớn hoặc vô tình đưa file rác lên Git
- **Thông báo lỗi:** `remote: error: File ... is 120.00 MB; this exceeds GitHub's file size limit of 100.00 MB`
- **Nguyên nhân:** Bạn vô tình đưa tệp APK (`game.apk`), tệp nén lớn (`.zip`, `.rar`) hoặc thư mục `node_modules` vào commit.
- **Cách sửa:**
  1. Hủy commit vừa tạo nhưng giữ nguyên file trên máy:
     ```powershell
     git reset --soft HEAD~1
     ```
  2. Loại bỏ tệp lớn khỏi hàng đợi Git (ví dụ file `game.apk` hoặc file `.zip`):
     ```powershell
     git rm --cached -r apk/
     git rm --cached *.zip
     ```
  3. Kiểm tra đảm bảo `.gitignore` đã ghi các đuôi tệp này.
  4. Tạo lại commit gọn gàng:
     ```powershell
     git commit -m "fix: loại bỏ tệp nhị phân lớn khỏi commit"
     git push origin main
     ```

---

## 8. PHÂN BIỆT LƯU CODE GITHUB & ĐƯA WEB LÊN MẠNG (DEPLOY)

Rất nhiều người mới nhầm lẫn giữa việc "Đẩy code lên GitHub" và "Mở web cho mọi người cùng xem". Hãy hiểu rõ sự khác biệt:

1. **Đẩy mã nguồn lên GitHub (`git push`):**
   - Chỉ là thao tác **sao lưu mã nguồn (Source Code)** lên kho lưu trữ trên đám mây của GitHub để quản lý phiên bản và làm việc nhóm.
   - Chưa thể chia sẻ đường link này cho người khác bấm vào dùng thử web như một trang web thật được (vì GitHub chỉ hiển thị mã nguồn tệp tin).

2. **Đưa website lên mạng công khai (Deployment):**
   - Để người khác có thể truy cập website từ điện thoại, máy tính ở bất kỳ đâu qua đường link công khai (ví dụ: `https://sahht-wiki.vercel.app`), bạn cần liên kết GitHub Repository này với một dịch vụ hosting miễn phí chuyên dụng cho Next.js như **Vercel** ([https://vercel.com](https://vercel.com)).
   - **Cách thực hiện cực kỳ đơn giản qua 3 bước trên Vercel:**
     1. Đăng nhập Vercel bằng tài khoản GitHub của bạn.
     2. Nhấn nút **"Add New Project"** -> Chọn kho lưu trữ `HeroUnitedWiki`.
     3. Nhấn vào mục **Root Directory** -> Chọn thư mục **`web`** -> Nhấn nút **"Deploy"**.
     4. Vercel sẽ tự động build và cấp cho bạn một tên miền miễn phí hoạt động 24/7. Mỗi khi bạn chạy lệnh `git push origin main`, trang web trên Vercel sẽ tự động cập nhật ngay lập tức!

---
*Tài liệu được biên soạn và kiểm chứng thực tế cho dự án Siêu Anh Hùng Hội Tụ WIKI ngày 2026-10-20.*
