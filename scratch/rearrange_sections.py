import re

with open("web/src/components/HeroInteractiveView.tsx", "r", encoding="utf-8") as f:
    text = f.read()

# 1. Update the h1 title to also show +strengthenLevel
old_h1 = '''            <div>
              <div className="text-xs text-slate-400 font-medium mb-1">
                {currentStageObj ? `Mốc Chuyển Sinh ${selectedChuyenStage}: ${currentStageObj.prefix}` : "Dạng Nguyên Bản"}
              </div>
              <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight flex flex-wrap items-center justify-center md:justify-start gap-3">
                <span>{currentTitle}</span>
              </h1>
            </div>'''

new_h1 = '''            <div>
              <div className="text-xs text-slate-400 font-medium mb-1">
                {currentStageObj ? `Mốc Chuyển Sinh ${selectedChuyenStage}: ${currentStageObj.prefix}` : "Dạng Nguyên Bản"}
              </div>
              <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight flex flex-wrap items-center justify-center md:justify-start gap-3">
                <span>{currentTitle}</span>
                {strengthenLevel > 0 && (
                  <span className="text-amber-400 font-mono text-2xl sm:text-4xl font-black">
                    +{strengthenLevel}
                  </span>
                )}
              </h1>
            </div>'''

if old_h1 in text:
    text = text.replace(old_h1, new_h1, 1)

# 2. Extract Section 6 (Level & Stats Simulator) and remove it from bottom
s6_pattern = re.compile(r'(\s*\{\/\* 6\. STAT SIMULATOR & LEVEL CONTROLS \(1 - 255\) \*\/\}[\s\S]*?<\/section>\n\n)', re.MULTILINE)
match_s6 = s6_pattern.search(text)
assert match_s6, "Section 6 not found"
s6_content = match_s6.group(1)

# Remove s6 from bottom
text = text[:match_s6.start()] + text[match_s6.end():]

# Transform s6_content into Section 1
new_s1_header = '''      {/* 1. CẤP ĐỘ (LEVEL 1 - 255) & BẢNG THUỘC TÍNH TỔNG HỢP */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🎯</span>
              <h2 className="text-xl font-bold text-white">
                1. Cấp Độ (Level 1 - 255) & Bảng Thuộc Tính Tổng Hợp
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Chỉ số tự động tính toán dựa trên: <b>Cấp độ ({level})</b> + <b>Tiến hóa (+{strengthenLevel})</b> + <b>Chuyển sinh ({selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage}` : "Gốc"})</b> + <b>Siêu tiến hóa ({currentEvoStage?.name || "Cam (Base)"})</b> + <b>Đột phá ({selectedBreakthroughStep > 0 ? `Cấp ${selectedBreakthroughStep}` : "Cấp 1"})</b> + <b>Set Con Giáp ({activeZodiacId.toUpperCase()})</b> + <b>Vận mệnh</b>.
            </p>
          </div>'''

# Replace header in s6_content
old_s6_header_pattern = re.compile(r'\s*\{\/\* 6\. STAT SIMULATOR & LEVEL CONTROLS \(1 - 255\) \*\/\}[\s\S]*?<\/div>', re.MULTILINE)
s6_replaced = old_s6_header_pattern.sub(new_s1_header, s6_content, count=1)

# 3. Update Section 2 (Tiến Hóa)
old_s2_header = '''      {/* 2. TIẾN HÓA (+1 ĐẾN +60) - REQUIREMENT 1 */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-5">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">📈</span>
              <h2 className="text-xl font-bold text-white">
                Tiến Hóa (+1 đến +60)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Hệ thống tiến hóa từ <b>+1 đến +60</b> giúp tăng cường trực tiếp các chỉ số cơ bản (HP, Vật Công, Ma Công, Phòng Ngự, Tốc Độ) theo từng cấp yêu cầu và tiêu hao lương thực/pha lê. <b>Khác biệt hoàn toàn với Đột Phá mở Kỹ Năng Siêu Tiến Hóa (Đỏ, Vàng).</b>
            </p>
          </div>'''

new_s2_header = '''      {/* 2. TIẾN HÓA (+1 ĐẾN +60) — CƯỜNG HÓA CHỈ SỐ CƠ BẢN */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-5">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">⚡</span>
              <h2 className="text-xl font-bold text-white">
                2. Tiến Hóa (+1 đến +60) — Cường Hóa Chỉ Số Cơ Bản
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Hệ thống Tiến Hóa cường hóa từ <b>+1 đến +60</b> giúp tăng cường trực tiếp các chỉ số cơ bản (HP, Vật Công, Ma Công, Phòng Ngự, Tốc Độ) theo từng cấp yêu cầu và tiêu hao lương thực. <b className="text-amber-400">Lưu ý phân biệt:</b> Đây là hệ thống cường hóa điểm cộng (+1..+60), hoàn toàn độc lập với <b>Mục 4: Siêu Tiến Hóa (Cam ➔ Đỏ ➔ Vàng)</b>.
            </p>
          </div>'''

assert old_s2_header in text, "old_s2_header not found"

# Insert Section 1 right before Section 2
text = text.replace(old_s2_header, s6_replaced + "\n" + new_s2_header, 1)

# 4. Update Section 3 (Chuyển Sinh) header & add Stage 0 (Gốc) button
old_s3_header = '''      {/* 3. MỤC CHUYỂN SINH (DESIGNED EXACTLY LIKE IMAGE 1 - REQUIREMENT 4) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="border-b border-slate-800 pb-4">
          <div className="flex items-center gap-2">
            <span className="text-2xl">🔄</span>
            <h2 className="text-xl font-bold text-white">
              Chuyển Sinh (Giao Diện Chuẩn Game - Ảnh 1)
            </h2>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Giao diện mô phỏng chính xác mục Chuyển Sinh trong game với hàng huy hiệu cánh thiên thần và 4 ô nguyên liệu (Đá Chuyển Sinh, Tinh thể, Mũ/Giáp và Thẻ Tướng Clone).
          </p>
        </div>'''

new_s3_header = '''      {/* 3. MỤC CHUYỂN SINH (MỐC 1 ĐẾN 7) — GIAO DIỆN CHUẨN GAME */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🔄</span>
              <h2 className="text-xl font-bold text-white">
                3. Chuyển Sinh (Mốc 1 đến 7) — Giao Diện Chuẩn Game
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Giao diện mô phỏng chính xác hệ thống Chuyển Sinh trong game với hàng huy hiệu cánh thiên thần và 4 ô nguyên liệu (Đá Chuyển Sinh, Tinh thể, Mũ/Giáp và Thẻ Tướng Clone). Thay đổi mốc chuyển sinh sẽ tự động cập nhật danh hiệu tiền tố, huy hiệu cánh và sao/trăng trên thẻ tướng.
            </p>
          </div>

          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10 shrink-0">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Mốc Chuyển Sinh</div>
            <div className="text-lg sm:text-xl font-black font-mono text-amber-400">
              {selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage} (${currentStageObj?.prefix || ""})` : "Gốc (Chưa chuyển)"}
            </div>
          </div>
        </div>'''

assert old_s3_header in text, "old_s3_header not found"
text = text.replace(old_s3_header, new_s3_header, 1)

# Add stage 0 button in the circular winged badges row
old_stage_row = '''            {/* Top row: Circular badges with wings & star ratings matching Image 1 */}
            <div className="flex flex-wrap items-center justify-center gap-3 sm:gap-6 py-2">
              {chuyenStages.map((st) => {'''

new_stage_row = '''            {/* Top row: Circular badges with wings & star ratings matching Image 1 */}
            <div className="flex flex-wrap items-center justify-center gap-3 sm:gap-6 py-2">
              {/* Nút mốc Gốc (Chưa chuyển) */}
              <button
                onClick={() => setSelectedChuyenStage(0)}
                className={`group flex flex-col items-center focus:outline-none transition-transform ${
                  selectedChuyenStage === 0 ? "scale-110" : "opacity-75 hover:opacity-100 hover:scale-105"
                }`}
                title="Dạng gốc nguyên bản chưa chuyển sinh"
              >
                <div
                  className={`relative flex items-center justify-center h-16 w-16 sm:h-20 sm:w-20 rounded-2xl border transition-all ${
                    selectedChuyenStage === 0
                      ? "border-amber-400 bg-amber-950/60 shadow-lg shadow-amber-500/30 ring-2 ring-amber-400/40"
                      : "border-slate-800 bg-slate-950/60 hover:border-slate-700"
                  }`}
                >
                  <span className="text-2xl sm:text-3xl">👤</span>
                </div>
                <div className="flex items-center justify-center gap-1 mt-1.5 h-4">
                  <span className="text-[10px] text-slate-500 font-mono">0 sao</span>
                </div>
                <span
                  className={`text-xs font-bold mt-0.5 ${
                    selectedChuyenStage === 0 ? "text-amber-300 font-black" : "text-slate-400"
                  }`}
                >
                  Gốc (0)
                </span>
              </button>

              {chuyenStages.map((st) => {'''

assert old_stage_row in text, "old_stage_row not found"
text = text.replace(old_stage_row, new_stage_row, 1)

# 5. Update Section 4 (Siêu Tiến Hóa) header
old_s4_header = '''      {/* 4. MỤC SIÊU TIẾN HÓA (CAM -> ĐỎ -> VÀNG) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🧬</span>
              <h2 className="text-xl font-bold text-white">
                Siêu Tiến Hóa
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Thẻ tướng cơ bản khởi đầu ở phẩm <b>Cam (Base)</b>. Quá trình <b>Siêu Tiến Hóa</b> qua các mốc <b>Cam → Đỏ → Vàng</b> giúp gia tăng vượt trội chỉ số, đặc biệt mốc <b>Đỏ</b> mở khóa Kỹ Năng Siêu Tiến Hóa 1 và mốc <b>Vàng</b> mở khóa Kỹ Năng Siêu Tiến Hóa 2.
            </p>
          </div>

          {/* Super Evo status pill */}
          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Mốc Siêu Tiến Hóa</div>
            <div className="text-lg sm:text-xl font-black font-mono text-amber-400">
              {currentEvoStage?.name || "Cam (Base)"}
            </div>
          </div>
        </div>'''

new_s4_header = '''      {/* 4. MỤC SIÊU TIẾN HÓA (CAM ➔ ĐỎ ➔ VÀNG) — NÂNG CẤP PHẨM CHẤT THẺ */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🧬</span>
              <h2 className="text-xl font-bold text-white">
                4. Siêu Tiến Hóa (Cam ➔ Đỏ ➔ Vàng) — Nâng Cấp Phẩm Chất Thẻ
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Hệ thống Siêu Tiến Hóa nâng cấp phẩm chất thẻ từ <b>Cam (Base) ➔ Đỏ ➔ Vàng</b> (gồm 9 mốc: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++). Hệ thống này trực tiếp thay đổi <b>Khung Thẻ Tướng (Frame)</b>, hiệu ứng hào quang, mở khóa 2 Kỹ Năng Siêu Tiến Hóa độc quyền và cộng dồn lượng chỉ số thuộc tính cực lớn. <b className="text-sky-400">Lưu ý phân biệt:</b> Khác hoàn toàn với <b>Mục 2: Tiến Hóa (+1..+60)</b> chỉ tăng điểm số cơ bản.
            </p>
          </div>

          {/* Super Evo status pill */}
          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Phẩm Chất Thẻ</div>
            <div className="text-lg sm:text-xl font-black font-mono text-amber-400">
              {currentEvoStage?.name || "Cam (Base)"}
            </div>
          </div>
        </div>'''

assert old_s4_header in text, "old_s4_header not found"
text = text.replace(old_s4_header, new_s4_header, 1)

# 6. Update Section 4.5 -> Section 5 (Đột Phá) header and IIFE calculation
old_s5_header = '''      {/* 4.5. MỤC ĐỘT PHÁ TƯỚNG (20 CẤP ĐỘT PHÁ TỪ BREAKTHROUGH.CONFIG) */}
      {(() => {
        const btSystem = hero.breakthrough_system;
        const btStages = btSystem?.stages || [];
        const hasBt = btSystem?.has_breakthrough && btStages.length > 0;
        const currentStageData = hasBt && selectedBreakthroughStep > 0 && selectedBreakthroughStep <= btStages.length
          ? btStages[selectedBreakthroughStep - 1]
          : null;

        // Calculate cumulative materials from step 1 to selectedBreakthroughStep (Requirement 1: Bỏ Vàng)
        const cumulativeSummary = useMemo(() => {'''

new_s5_header = '''      {/* 5. MỤC ĐỘT PHÁ TƯỚNG (20 CẤP ĐỘT PHÁ NGUYÊN TỐ) */}
      {(() => {
        const btSystem = hero.breakthrough_system;
        const btStages = btSystem?.stages || [];
        const hasBt = btSystem?.has_breakthrough && btStages.length > 0;
        const currentStageData = hasBt && selectedBreakthroughStep > 0 && selectedBreakthroughStep <= btStages.length
          ? btStages[selectedBreakthroughStep - 1]
          : null;

        // Calculate cumulative materials from step 1 to selectedBreakthroughStep (Requirement 1: Bỏ Vàng)
        const cumulativeSummary = (() => {'''

assert old_s5_header in text, "old_s5_header not found"
text = text.replace(old_s5_header, new_s5_header, 1)

old_s5_deps = '        }, [hasBt, selectedBreakthroughStep, btStages]);'
new_s5_deps = '        })();'
assert old_s5_deps in text, "old_s5_deps not found"
text = text.replace(old_s5_deps, new_s5_deps, 1)

old_s5_title = '''                  <h2 className="text-xl font-bold text-white">
                    Đột Phá Tướng (20 Cấp Đột Phá)
                  </h2>
                </div>
                <p className="text-xs text-slate-400 mt-1">
                  Hệ thống 20 cấp Đột Phá từ config game chuẩn (<b>breakthrough.config</b>). Mỗi cấp yêu cầu Chuyển Thế Đơn hoặc Thẻ Bản Thể Tướng, Tinh Hoa Nguyên Tố, Đá Năng Lượng, cộng dồn lượng lớn chỉ số cơ bản và thuộc tính.
                </p>'''

new_s5_title = '''                  <h2 className="text-xl font-bold text-white">
                    5. Đột Phá Tướng (20 Cấp Đột Phá Nguyên Tố)
                  </h2>
                </div>
                <p className="text-xs text-slate-400 mt-1">
                  Hệ thống 20 cấp Đột Phá từ config game chuẩn (<b>breakthrough.config</b>). Mỗi cấp độ gia tăng chỉ số cơ bản, chỉ số Công/Thủ Nguyên Tố và thay đổi trực tiếp con số trên <b>Huy Hiệu Đột Phá</b> bên phải hình tướng.
                </p>'''

assert old_s5_title in text, "old_s5_title not found"
text = text.replace(old_s5_title, new_s5_title, 1)

# 7. Update Section 5 -> Section 6 (Trang Bị) header
old_s6_gear_header = '''      {/* 5. 5 ĐẠI BỘ TRANG BỊ CON GIÁP (HỢI, CHUỘT, RỒNG, TỊ, NGỰA) - REQUIREMENT 1, 2, 3 */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🛡️</span>
              <h2 className="text-xl font-bold text-white">
                5 Đại Bộ Trang Bị Con Giáp (Hợi, Chuột, Rồng, Tị, Ngựa)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              5 bộ trang bị hoàng đạo uy lực tối thượng trong game với mốc Cầu Vồng đột phá thần khí. Tự động đề xuất set tối ưu theo cơ chế sát thương của từng tướng.
            </p>
          </div>'''

new_s6_gear_header = '''      {/* 6. TRANG BỊ (5 ĐẠI BỘ TRANG BỊ CON GIÁP) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🛡️</span>
              <h2 className="text-xl font-bold text-white">
                6. Trang Bị (5 Đại Bộ Trang Bị Con Giáp)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              5 bộ trang bị hoàng đạo uy lực tối thượng trong game: <b>Bộ Năm Hợi</b>, <b>Bộ Năm Chuột</b>, <b>Bộ Năm Rồng</b>, <b>Bộ Năm Tị</b>, <b>Bộ Năm Ngựa</b> với mốc Cầu Vồng đột phá thần khí. Tự động đề xuất set tối ưu theo cơ chế sát thương của từng tướng.
            </p>
          </div>'''

assert old_s6_gear_header in text, "old_s6_gear_header not found"
text = text.replace(old_s6_gear_header, new_s6_gear_header, 1)

with open("web/src/components/HeroInteractiveView.tsx", "w", encoding="utf-8") as f:
    f.write(text)

print("HeroInteractiveView.tsx successfully rearranged and updated!")
