// web/src/app/page.tsx
import React from "react";
import Link from "next/link";
import SearchBar from "@/components/SearchBar";
import ImageWithFallback from "@/components/ImageWithFallback";
import { getHeroById, getSuitById, getSkillById } from "@/lib/data";

export default function HomePage() {
  // Load featured showcase records
  const sasuke = getHeroById("84000");
  const suit53 = getSuitById("53");
  const chidori = getSkillById("76510");

  const statCounters = [
    { label: "Bản Thể Tướng", count: "721", icon: "👤", href: "/heroes" },
    { label: "Bộ Trang Bị", count: "729", icon: "🛡️", href: "/suits" },
    { label: "Huy Hiệu Tướng", count: "112", icon: "🎖️", href: "/ban-suc" },
    { label: "Hệ Đá Ban Sức", count: "10", icon: "🔮", href: "/ban-suc" },
    { label: "Xếp Hạng Meta", count: "46", icon: "🏆", href: "/tier-list" },
  ];

  const categoryCards = [
    {
      title: "Danh Sách Tướng",
      count: "721 Bản Thể",
      desc: "Tra cứu đầy đủ 721 bản thể, phân biệt ID bản thể với ID nhóm tướng. Chi tiết 5 chỉ số cơ sở, tăng trưởng, 7 kỹ năng, chuyển sinh, siêu tiến hóa và duyên phận.",
      icon: "👤",
      href: "/heroes",
      gradient: "from-purple-900/35 via-indigo-950/20 to-slate-950/80",
      border: "hover:border-purple-500/50",
      accent: "text-purple-300 border-purple-500/30 bg-purple-500/10",
    },
    {
      title: "Bảng Xếp Hạng (Tier List)",
      count: "46 Tướng • Meta 2026",
      desc: "Bảng xếp hạng thực chiến Dealer và Support + Hybrid (UBER đến Tier 4) sắc nét, bấm trực tiếp vào từng ô tướng để xem hồ sơ chi tiết.",
      icon: "🏆",
      href: "/tier-list",
      gradient: "from-amber-900/35 via-red-950/20 to-slate-950/80",
      border: "hover:border-amber-500/50",
      accent: "text-amber-300 border-amber-500/30 bg-amber-500/10",
    },
    {
      title: "Bộ Trang Bị (Suits)",
      count: "729 Bộ Kèm 4 Món",
      desc: "Khám phá 729 bộ trang bị (bao gồm 5 Đại Bộ Con Giáp: Hợi, Chuột, Rồng, Tị, Ngựa) với đủ 4 vị trí và mốc kích hoạt thuộc tính 2, 3, 4 món.",
      icon: "🛡️",
      href: "/suits",
      gradient: "from-emerald-900/35 via-teal-950/20 to-slate-950/80",
      border: "hover:border-emerald-500/50",
      accent: "text-emerald-300 border-emerald-500/30 bg-emerald-500/10",
    },
    {
      title: "Ban Sức & Huy Hiệu",
      count: "10 Hệ Đá & 112 Huy Hiệu",
      desc: "10 hệ Đá Ban Sức Vận Mệnh (Aether, Titan, Hủy Diệt...), 40 kỹ năng, 120 dòng điểm hóa và tổ hợp kích hoạt kỹ năng đội hình.",
      icon: "🔮",
      href: "/ban-suc",
      gradient: "from-indigo-900/35 via-blue-950/20 to-slate-950/80",
      border: "hover:border-indigo-500/50",
      accent: "text-indigo-300 border-indigo-500/30 bg-indigo-500/10",
    },
    {
      title: "Cẩm Nang & Chiến Thuật",
      count: "Hướng Dẫn Chuyên Sâu",
      desc: "Cơ chế nâng cấp tướng, đột phá trang bị, kích hoạt duyên phận và kinh nghiệm xây dựng đội hình chuẩn.",
      icon: "📖",
      href: "/guides",
      gradient: "from-cyan-900/35 via-sky-950/20 to-slate-950/80",
      border: "hover:border-cyan-500/50",
      accent: "text-cyan-300 border-cyan-500/30 bg-cyan-500/10",
    },
  ];

  return (
    <div className="space-y-14 py-2">
      
      {/* 1. HERO BANNER */}
      <section className="relative overflow-hidden rounded-3xl border border-slate-800/90 bg-gradient-to-b from-slate-900/90 via-[#0a0f1d] to-[#060911] p-7 sm:p-12 text-center shadow-2xl">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_0%,rgba(99,102,241,0.22),transparent_68%)] pointer-events-none"></div>

        <div className="relative z-10 max-w-3xl mx-auto">
          <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-indigo-500/10 border border-indigo-500/30 text-indigo-300 text-xs font-semibold mb-5">
            <span className="w-2 h-2 rounded-full bg-indigo-400 animate-pulse"></span>
            <span>Dữ Liệu Chuẩn Xác • Bảo Toàn 100% Cấu Hình Gốc</span>
          </div>

          <h1 className="text-3xl sm:text-5xl font-black tracking-tight text-white leading-tight">
            SIÊU ANH HÙNG HỘI TỤ{" "}
            <span className="bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">
              WIKI
            </span>
          </h1>

          <p className="mt-3.5 text-sm sm:text-base text-slate-300 max-w-2xl mx-auto leading-relaxed">
            Cổng tra cứu toàn diện tướng, bộ trang bị, đá ban sức, huy hiệu và bảng xếp hạng Tier List từ bộ cài chính thức. Hỗ trợ tìm kiếm tức thì có dấu hoặc không dấu.
          </p>

          {/* Big Search Bar */}
          <div className="mt-7 max-w-2xl mx-auto">
            <SearchBar
              large
              placeholder="Nhập tên tướng (Sasuke, Vegetto, Gojo, Nagato...), ID (84000), hoặc bộ trang bị..."
            />
            <div className="mt-3.5 flex flex-wrap items-center justify-center gap-2 text-xs text-slate-400">
              <span className="text-slate-500 font-medium">Tra cứu nhanh:</span>
              {[
                { label: "🔥 Tier List Meta", href: "/tier-list" },
                { label: "Lục Đạo Sasuke", href: "/heroes/84000" },
                { label: "Vegetto", href: "/heroes/84500" },
                { label: "Nagato", href: "/heroes/82400" },
                { label: "Bộ Thần Đồng", href: "/suits/53" },
                { label: "Đá Ban Sức", href: "/ban-suc" },
              ].map((tag) => (
                <Link
                  key={tag.label}
                  href={tag.href}
                  className="px-3 py-1 rounded-lg bg-slate-900/90 border border-slate-800 hover:border-indigo-500/50 hover:bg-indigo-950/40 hover:text-white transition-all"
                >
                  {tag.label}
                </Link>
              ))}
            </div>
          </div>
        </div>

        {/* Stats Strip */}
        <div className="relative z-10 mt-10 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 pt-7 border-t border-slate-800/80">
          {statCounters.map((stat) => (
            <Link
              key={stat.label}
              href={stat.href}
              className="p-3.5 rounded-2xl bg-slate-950/70 border border-slate-800/80 hover:border-indigo-500/40 hover:bg-slate-900/80 transition-all text-center group"
            >
              <div className="text-xl mb-1 group-hover:scale-110 transition-transform">{stat.icon}</div>
              <div className="text-lg font-extrabold text-white tracking-tight font-mono">{stat.count}</div>
              <div className="text-xs text-slate-400 font-medium truncate">{stat.label}</div>
            </Link>
          ))}
        </div>
      </section>

      {/* 2. CATEGORY ENTRANCES */}
      <section className="space-y-5">
        <div className="flex items-end justify-between">
          <div>
            <h2 className="text-xl sm:text-2xl font-extrabold text-white flex items-center gap-2.5">
              <span>🧭</span> Khám Phá Chuyên Mục Chính
            </h2>
            <p className="text-xs sm:text-sm text-slate-400 mt-1">
              Chọn phân hệ bạn muốn tra cứu — giao diện tối ưu, trực quan và chuẩn xác theo cấu hình game
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {categoryCards.map((cat, idx) => (
            <Link
              key={cat.title}
              href={cat.href}
              className={`p-6 rounded-2xl border border-slate-800/90 bg-gradient-to-br ${cat.gradient} ${cat.border} transition-all duration-200 hover:-translate-y-1 hover:shadow-xl group flex flex-col justify-between ${
                idx === 0 ? "md:col-span-2 lg:col-span-1" : ""
              }`}
            >
              <div>
                <div className="flex items-center justify-between mb-4">
                  <span className="text-2xl p-3 rounded-2xl bg-slate-950/80 border border-slate-800 group-hover:scale-105 transition-transform shadow-inner">
                    {cat.icon}
                  </span>
                  <span className={`text-xs font-semibold px-3 py-1 rounded-full border ${cat.accent}`}>
                    {cat.count}
                  </span>
                </div>
                <h3 className="text-lg font-extrabold text-white group-hover:text-indigo-300 transition-colors">
                  {cat.title}
                </h3>
                <p className="text-xs sm:text-sm text-slate-300/85 mt-2 leading-relaxed">
                  {cat.desc}
                </p>
              </div>

              <div className="mt-5 pt-3.5 border-t border-slate-800/60 flex items-center justify-between text-xs font-bold text-slate-300 group-hover:text-white">
                <span>Mở danh mục</span>
                <span className="group-hover:translate-x-1 transition-transform">➔</span>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* 3. VERIFIED HIGHLIGHTS (SASUKE & BỘ THẦN ĐỒNG & CHIDORI) */}
      <section className="space-y-5">
        <div>
          <h2 className="text-xl sm:text-2xl font-extrabold text-white flex items-center gap-2.5">
            <img
              src="/assets/card/public_equip_star.png"
              alt="Sao"
              className="w-5 h-5 object-contain filter drop-shadow"
            />
            <span>Hồ Sơ Tiêu Biểu Đã Đối Chiếu In-Game</span>
          </h2>
          <p className="text-xs sm:text-sm text-slate-400 mt-1">
            Hình ảnh toàn thân và biểu tượng trích xuất trực tiếp từ APK kết hợp 100% trường dữ liệu nguồn
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

          {/* Featured Hero: Sasuke 84000 */}
          {sasuke && (
            <div className="p-6 rounded-2xl border border-purple-800/40 bg-gradient-to-br from-purple-950/35 to-slate-950/95 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-2xl overflow-hidden border-2 border-purple-500/40 shadow-lg flex-shrink-0 bg-slate-950 p-0.5">
                    <ImageWithFallback
                      src={sasuke.avatar}
                      alt={sasuke.name}
                      className="w-full h-full object-contain rounded-xl"
                    />
                  </div>
                  <div>
                    <div className="text-[11px] text-purple-400 font-bold uppercase tracking-wider">
                      Tướng Nổi Bật • ID 84000
                    </div>
                    <h3 className="text-xl font-extrabold text-white leading-tight mt-0.5">
                      {sasuke.name}
                    </h3>
                    <div className="flex items-center gap-2 mt-1.5">
                      <span className="text-xs px-2 py-0.5 rounded-md bg-amber-500/20 text-amber-300 border border-amber-500/30 font-semibold">
                        Phẩm {sasuke.quality}
                      </span>
                      <span className="text-xs px-2 py-0.5 rounded-md bg-purple-500/20 text-purple-300 border border-purple-500/30 font-semibold">
                        ⚡ 9 Mốc STH & 20 Đột Phá
                      </span>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-2 my-4 p-3 rounded-xl bg-slate-950/70 border border-slate-800/90 text-center">
                  <div>
                    <div className="text-[10px] text-slate-400 uppercase font-medium">HP</div>
                    <div className="text-sm font-extrabold text-white font-mono">{sasuke.base_stats?.hp?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400 font-mono">+{sasuke.growth_stats?.hp}/Lv</div>
                  </div>
                  <div>
                    <div className="text-[10px] text-slate-400 uppercase font-medium">Vật Công</div>
                    <div className="text-sm font-extrabold text-white font-mono">{sasuke.base_stats?.patk?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400 font-mono">+{sasuke.growth_stats?.patk}/Lv</div>
                  </div>
                  <div>
                    <div className="text-[10px] text-slate-400 uppercase font-medium">Tốc Độ</div>
                    <div className="text-sm font-extrabold text-white font-mono">{sasuke.base_stats?.speed?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400 font-mono">+{sasuke.growth_stats?.speed}/Lv</div>
                  </div>
                </div>

                <div className="text-xs text-slate-300/90 leading-relaxed">
                  Trọn bộ 7 kỹ năng có đủ icon thực tế: Chidori, Susanoo, Kì Lân, Amaterasu cùng mô phỏng chỉ số Lv.1–255.
                </div>
              </div>

              <Link
                href="/heroes/84000"
                className="w-full mt-5 py-2.5 rounded-xl bg-purple-600/25 hover:bg-purple-600 text-purple-200 hover:text-white border border-purple-500/40 font-bold text-xs text-center transition-all block"
              >
                Xem Hồ Sơ Lục Đạo Sasuke ➔
              </Link>
            </div>
          )}

          {/* Featured Suit: Suit 53 (Bộ Thần Đồng & Đao Ninja) */}
          {suit53 && (
            <div className="p-6 rounded-2xl border border-emerald-800/40 bg-gradient-to-br from-emerald-950/35 to-slate-950/95 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-3.5 mb-4">
                  <span className="text-3xl p-3 rounded-2xl bg-emerald-950/80 border border-emerald-800/60">
                    🛡️
                  </span>
                  <div>
                    <div className="text-[11px] text-emerald-400 font-bold uppercase tracking-wider">
                      Bộ Trang Bị Mẫu • Suit #53
                    </div>
                    <h3 className="text-xl font-extrabold text-white leading-tight mt-0.5">
                      Bộ Thần Đồng
                    </h3>
                    <div className="text-xs text-slate-400 mt-1">
                      Đủ 4 vị trí trang bị & mốc cộng dồn 2/3/4 món
                    </div>
                  </div>
                </div>

                {/* 4 Pieces Icons */}
                <div className="grid grid-cols-4 gap-2 my-4">
                  {suit53.parts?.map((p: any) => (
                    <div key={p.id} className="p-2 rounded-xl bg-slate-950/75 border border-slate-800 text-center">
                      <div className="w-10 h-10 mx-auto rounded-lg overflow-hidden border border-slate-700 bg-slate-900 mb-1">
                        <ImageWithFallback
                          src={p.icon}
                          alt={p.name}
                          className="w-full h-full object-cover"
                        />
                      </div>
                      <div className="text-[11px] font-semibold text-slate-200 truncate">{p.name}</div>
                      <div className="text-[9px] text-slate-500">{p.slot_name}</div>
                    </div>
                  ))}
                </div>

                <div className="text-xs text-slate-300 space-y-1 p-3 rounded-xl bg-slate-950/60 border border-slate-800/90">
                  <div>• <b className="text-emerald-300">Đủ 2 món:</b> Vật công +300, Ma công +250</div>
                  <div>• <b className="text-emerald-300">Đủ 3 món:</b> Phòng ngự +200, Tốc độ +500</div>
                  <div>• <b className="text-emerald-300">Đủ 4 món:</b> Vật công +300, Ma công +250, HP +3.300</div>
                </div>
              </div>

              <Link
                href="/suits/53"
                className="w-full mt-5 py-2.5 rounded-xl bg-emerald-600/25 hover:bg-emerald-600 text-emerald-200 hover:text-white border border-emerald-500/40 font-bold text-xs text-center transition-all block"
              >
                Chi Tiết Bộ Thần Đồng #53 ➔
              </Link>
            </div>
          )}

          {/* Featured Skill: Chidori 76510 */}
          {chidori && (
            <div className="p-6 rounded-2xl border border-indigo-800/40 bg-gradient-to-br from-indigo-950/35 to-slate-950/95 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-2xl overflow-hidden border-2 border-indigo-500/40 shadow-lg flex-shrink-0 bg-slate-950">
                    <ImageWithFallback
                      src={chidori.icon}
                      alt={chidori.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div>
                    <div className="text-[11px] text-indigo-400 font-bold uppercase tracking-wider">
                      Chuỗi Kỹ Năng • ID 76510
                    </div>
                    <h3 className="text-xl font-extrabold text-white leading-tight mt-0.5">
                      {chidori.name}
                    </h3>
                    <div className="flex items-center gap-2 mt-1.5">
                      <span className="text-xs px-2 py-0.5 rounded-md bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 font-semibold">
                        {chidori.skill_type}
                      </span>
                      <span className="text-xs text-slate-400 font-mono">
                        CD: {chidori.cd}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-slate-950/70 border border-slate-800/90 text-xs text-slate-300 leading-relaxed mb-3">
                  &ldquo;{chidori.description}&rdquo;
                </div>

                <div className="p-3 rounded-xl bg-slate-950/50 border border-slate-800/80 text-xs text-slate-400">
                  <div className="font-semibold text-slate-200 mb-1">Chuỗi tiến hóa 3 giai đoạn trong hồ sơ tướng:</div>
                  <div className="flex items-center gap-2 text-[11px]">
                    <span className="text-indigo-400 font-bold">Chidori</span>
                    <span>➔</span>
                    <span className="text-slate-300">Chidori Giai 2</span>
                    <span>➔</span>
                    <span className="text-amber-300 font-semibold">Chidori Giai 3</span>
                  </div>
                </div>
              </div>

              <Link
                href="/heroes/43900#hero-skills"
                className="w-full mt-5 py-2.5 rounded-xl bg-indigo-600/25 hover:bg-indigo-600 text-indigo-200 hover:text-white border border-indigo-500/40 font-bold text-xs text-center transition-all block"
              >
                Xem Kỹ Năng Trong Hồ Sơ Tướng ➔
              </Link>
            </div>
          )}

        </div>
      </section>

      {/* 4. METHODOLOGY & EDITORIAL PRINCIPLES BANNER */}
      <section className="p-6 sm:p-7 rounded-2xl border border-slate-800/80 bg-slate-900/35 text-slate-400 text-xs leading-relaxed space-y-2.5">
        <h3 className="text-sm font-bold text-slate-200 uppercase tracking-wider flex items-center gap-2">
          <span>🛡️</span> Nguyên Tắc Biên Tập & Minh Bạch Dữ Liệu
        </h3>
        <p>
          • <b className="text-slate-200">Bảo toàn cấu hình nguồn:</b> Tất cả giá trị thuộc tính (HP, PATK, CD, rate, effect) được trích xuất tĩnh nguyên vẹn từ các tệp cấu hình game (<code>.config</code>). Không tự gán đơn vị tính hay suy đoán công thức sát thương khi chưa có đối chiếu game thực tế.
        </p>
        <p>
          • <b className="text-slate-200">Tách bạch biên tập:</b> Dữ liệu cấu hình game độc lập hoàn toàn với các bài viết đánh giá, cẩm nang hướng dẫn hay bảng xếp hạng Tier List của biên tập viên.
        </p>
      </section>

    </div>
  );
}
