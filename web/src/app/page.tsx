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
    { label: "Kỹ Năng & Chiêu", count: "10.836", icon: "⚡", href: "/skills" },
    { label: "Bộ Trang Bị", count: "729", icon: "🛡️", href: "/suits" },
    { label: "Món Trang Bị", count: "4.366", icon: "⚔️", href: "/equipment" },
    { label: "Huy Hiệu Tướng", count: "112", icon: "🎖️", href: "/ban-suc" },
    { label: "Hệ Đá Ban Sức", count: "10", icon: "🔮", href: "/ban-suc" },
  ];

  const categoryCards = [
    {
      title: "Danh Sách Tướng",
      count: "721 Bản Thể",
      desc: "Tra cứu đầy đủ 721 bản thể, phân biệt ID bản thể với ID nhóm tướng. Chi tiết 5 chỉ số cơ sở, tăng trưởng, 7 kỹ năng và duyên phận.",
      icon: "👤",
      href: "/heroes",
      gradient: "from-purple-900/40 via-purple-950/20 to-transparent",
      border: "hover:border-purple-500/50",
      accent: "text-purple-400",
    },
    {
      title: "Kỹ Năng & Chiêu Thức",
      count: "10.836 Chiêu Thức",
      desc: "Xem mô tả gốc, CD, pre_cd, tỉ lệ kích hoạt, hiệu ứng sát thương và chuỗi tiến cấp 3 giai đoạn (Giai 1 ➔ Giai 2 ➔ Cực Hạn).",
      icon: "⚡",
      href: "/skills",
      gradient: "from-amber-900/40 via-amber-950/20 to-transparent",
      border: "hover:border-amber-500/50",
      accent: "text-amber-400",
    },
    {
      title: "Bộ Trang Bị (Suits)",
      count: "729 Bộ Kèm 4 Món",
      desc: "Khám phá 729 bộ trang bị với đủ 4 vị trí (Vũ khí, Trang sức, Giáp/Áo, Giày) và mốc kích hoạt thuộc tính 2 món, 3 món, 4 món.",
      icon: "🛡️",
      href: "/suits",
      gradient: "from-emerald-900/40 via-emerald-950/20 to-transparent",
      border: "hover:border-emerald-500/50",
      accent: "text-emerald-400",
    },
    {
      title: "Kho Trang Bị Lẻ",
      count: "4.366 Trang Bị",
      desc: "Đầy đủ 4 vị trí đã xác minh, thuộc tính chính, thuộc tính phụ, cấp tiến hóa và phân biệt trang bị có bộ hay trang bị độc lập.",
      icon: "⚔️",
      href: "/equipment",
      gradient: "from-blue-900/40 via-blue-950/20 to-transparent",
      border: "hover:border-blue-500/50",
      accent: "text-blue-400",
    },
    {
      title: "Ban Sức & Huy Hiệu",
      count: "10 Hệ Đá & 112 Huy Hiệu",
      desc: "10 hệ Đá Ban Sức Vận Mệnh (Aether, Titan, Hủy Diệt...), 40 kỹ năng, 120 dòng điểm hóa và tổ hợp kích hoạt kỹ năng đội hình.",
      icon: "🔮",
      href: "/ban-suc",
      gradient: "from-indigo-900/40 via-indigo-950/20 to-transparent",
      border: "hover:border-indigo-500/50",
      accent: "text-indigo-400",
    },
    {
      title: "Tier List & Cẩm Nang",
      count: "Biên Tập Chuyên Sâu",
      desc: "Khu vực bài viết, đánh giá xếp hạng và đội hình thực chiến từ các biên tập viên. Dữ liệu biên tập tách biệt rõ ràng với cấu hình game.",
      icon: "📖",
      href: "/tier-list",
      gradient: "from-pink-900/40 via-pink-950/20 to-transparent",
      border: "hover:border-pink-500/50",
      accent: "text-pink-400",
    },
  ];

  return (
    <div className="space-y-16 py-4">
      
      {/* 1. HERO BANNER */}
      <section className="relative overflow-hidden rounded-3xl border border-gray-800 bg-gradient-to-b from-gray-900/90 via-gray-950/95 to-[#070a12] p-8 sm:p-14 text-center shadow-2xl">
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_0%,rgba(99,102,241,0.18),transparent_70%)] pointer-events-none"></div>

        <div className="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full bg-indigo-500/10 border border-indigo-500/30 text-indigo-400 text-xs font-semibold mb-6">
          <span className="w-2 h-2 rounded-full bg-indigo-400 animate-pulse"></span>
          <span>Dữ Liệu Chuẩn Xác • Bảo Toàn 100% Cấu Hình Gốc</span>
        </div>

        <h1 className="text-3xl sm:text-5xl lg:text-6xl font-extrabold tracking-tight text-white max-w-4xl mx-auto leading-tight">
          SIÊU ANH HÙNG HỘI TỤ <span className="bg-gradient-to-r from-indigo-400 via-purple-400 to-pink-400 bg-clip-text text-transparent">WIKI</span>
        </h1>

        <p className="mt-4 text-base sm:text-lg text-gray-400 max-w-2xl mx-auto leading-relaxed">
          Tra cứu toàn diện tướng, kỹ năng, trang bị, bộ trang bị và ban sức từ bộ cài chính thức. Tìm kiếm tức thì có dấu hoặc không dấu.
        </p>

        {/* Big Search Bar */}
        <div className="mt-8 max-w-2xl mx-auto">
          <SearchBar
            large
            placeholder="Nhập tên tướng (Sasuke, Luffy, Goku...), ID (84000, 16401), chiêu thức, trang bị..."
          />
          <div className="mt-3 flex flex-wrap items-center justify-center gap-2 text-xs text-gray-400">
            <span className="text-gray-500">Gợi ý tìm kiếm:</span>
            {[
              { label: "Lục Đạo Sasuke", href: "/heroes/84000" },
              { label: "Đao Ninja", href: "/equipment/16401" },
              { label: "Bộ Thần Đồng", href: "/suits/53" },
              { label: "Chidori", href: "/skills/76510" },
              { label: "Đá Ban Sức", href: "/ban-suc" },
            ].map((tag) => (
              <Link
                key={tag.label}
                href={tag.href}
                className="px-2.5 py-1 rounded-md bg-gray-900 border border-gray-800 hover:border-gray-700 hover:text-white transition-colors"
              >
                {tag.label}
              </Link>
            ))}
          </div>
        </div>

        {/* Stats Grid */}
        <div className="mt-12 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 pt-8 border-t border-gray-800/80">
          {statCounters.map((stat) => (
            <Link
              key={stat.label}
              href={stat.href}
              className="p-3.5 rounded-xl bg-gray-950/60 border border-gray-800/60 hover:border-gray-700 hover:bg-gray-900/60 transition-all text-center group"
            >
              <div className="text-xl mb-1 group-hover:scale-110 transition-transform">{stat.icon}</div>
              <div className="text-lg font-bold text-white tracking-tight">{stat.count}</div>
              <div className="text-[11px] text-gray-400 truncate">{stat.label}</div>
            </Link>
          ))}
        </div>
      </section>

      {/* 2. CATEGORY ENTRANCES */}
      <section className="space-y-6">
        <div className="flex items-end justify-between">
          <div>
            <h2 className="text-xl sm:text-2xl font-bold text-white flex items-center gap-2">
              <span>📚</span> Lối Vào Danh Mục Dữ Liệu
            </h2>
            <p className="text-xs sm:text-sm text-gray-400 mt-1">
              Khám phá các phân hệ dữ liệu đã được đối chiếu chuẩn xác từng trường
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-5">
          {categoryCards.map((cat) => (
            <Link
              key={cat.title}
              href={cat.href}
              className={`p-6 rounded-2xl border border-gray-800 bg-gray-900/40 backdrop-blur-xl bg-gradient-to-br ${cat.gradient} ${cat.border} transition-all duration-300 hover:-translate-y-1 hover:shadow-xl group flex flex-col justify-between`}
            >
              <div>
                <div className="flex items-center justify-between mb-4">
                  <span className="text-3xl p-2.5 rounded-xl bg-gray-950/70 border border-gray-800 group-hover:scale-110 transition-transform">
                    {cat.icon}
                  </span>
                  <span className={`text-xs font-semibold px-2.5 py-1 rounded-full bg-gray-950/80 border border-gray-800 ${cat.accent}`}>
                    {cat.count}
                  </span>
                </div>
                <h3 className="text-lg font-bold text-white group-hover:text-indigo-300 transition-colors">
                  {cat.title}
                </h3>
                <p className="text-xs text-gray-400 mt-2 leading-relaxed">
                  {cat.desc}
                </p>
              </div>

              <div className="mt-5 pt-4 border-t border-gray-800/60 flex items-center justify-between text-xs font-semibold text-gray-300 group-hover:text-white">
                <span>Khám phá ngay</span>
                <span className="group-hover:translate-x-1 transition-transform">➔</span>
              </div>
            </Link>
          ))}
        </div>
      </section>

      {/* 3. VERIFIED HIGHLIGHTS (SASUKE & ĐAO NINJA & CHIDORI) */}
      <section className="space-y-6 pt-4">
        <div>
          <h2 className="text-xl sm:text-2xl font-bold text-white flex items-center gap-2">
            <img
              src="/assets/card/public_equip_star.png"
              alt="Sao"
              className="w-5 h-5 object-contain filter drop-shadow"
            />
            <span>Thực Thể Mẫu Đối Chiếu In-Game Đã Xác Minh</span>
          </h2>
          <p className="text-xs sm:text-sm text-gray-400 mt-1">
            Hình ảnh thật trích xuất từ APK kết hợp 100% trường dữ liệu nguồn
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

          {/* Featured Hero: Sasuke 84000 */}
          {sasuke && (
            <div className="p-6 rounded-2xl border border-purple-900/40 bg-gradient-to-br from-purple-950/40 to-gray-950/90 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-xl overflow-hidden border-2 border-purple-500/40 shadow-lg flex-shrink-0 bg-gray-950">
                    <ImageWithFallback
                      src={sasuke.avatar}
                      alt={sasuke.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-purple-400 font-semibold uppercase tracking-wider">
                      Tướng Nổi Bật (ID: 84000)
                    </div>
                    <h3 className="text-xl font-bold text-white leading-tight">
                      {sasuke.name}
                    </h3>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs px-2 py-0.5 rounded bg-amber-500/20 text-amber-300 border border-amber-500/30">
                        Phẩm 4 (Cam)
                      </span>
                      <span className="text-xs text-amber-400 font-medium flex items-center gap-1">
                        <img
                          src="/assets/card/public_equip_star.png"
                          alt="Sao"
                          className="w-3.5 h-3.5 object-contain filter drop-shadow"
                        />
                        <span>0 / 20 Sao</span>
                      </span>
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-3 gap-2 my-4 p-3 rounded-xl bg-gray-950/60 border border-gray-800 text-center">
                  <div>
                    <div className="text-[10px] text-gray-400 uppercase">HP</div>
                    <div className="text-sm font-bold text-white">{sasuke.base_stats?.hp?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400">+{sasuke.growth_stats?.hp}/cấp</div>
                  </div>
                  <div>
                    <div className="text-[10px] text-gray-400 uppercase">Công Vật Lý</div>
                    <div className="text-sm font-bold text-white">{sasuke.base_stats?.patk?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400">+{sasuke.growth_stats?.patk}/cấp</div>
                  </div>
                  <div>
                    <div className="text-[10px] text-gray-400 uppercase">Tốc Độ</div>
                    <div className="text-sm font-bold text-white">{sasuke.base_stats?.speed?.toLocaleString()}</div>
                    <div className="text-[10px] text-emerald-400">+{sasuke.growth_stats?.speed}/cấp</div>
                  </div>
                </div>

                <div className="text-xs text-gray-400 mb-2">
                  Trọn bộ 7 kỹ năng có đủ icon thực tế: Chidori, Susanoo, Kì Lân, Amaterasu...
                </div>
              </div>

              <Link
                href="/heroes/84000"
                className="w-full mt-4 py-2.5 rounded-xl bg-purple-600/30 hover:bg-purple-600 text-purple-200 hover:text-white border border-purple-500/40 font-semibold text-xs text-center transition-all block"
              >
                Xem Toàn Bộ 7 Chiêu & Duyên Phận ➔
              </Link>
            </div>
          )}

          {/* Featured Suit: Suit 53 (Bộ Thần Đồng & Đao Ninja) */}
          {suit53 && (
            <div className="p-6 rounded-2xl border border-emerald-900/40 bg-gradient-to-br from-emerald-950/40 to-gray-950/90 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-3 mb-4">
                  <span className="text-3xl p-2 rounded-xl bg-emerald-950/80 border border-emerald-800">
                    🗡️
                  </span>
                  <div>
                    <div className="text-xs text-emerald-400 font-semibold uppercase tracking-wider">
                      Bộ Trang Bị Mẫu (Suit: 53)
                    </div>
                    <h3 className="text-xl font-bold text-white leading-tight">
                      Bộ Thần Đồng (神童)
                    </h3>
                    <div className="text-xs text-gray-400 mt-0.5">
                      Chứa Đao Ninja (ID: 16401) • Đủ 4 ảnh từ APK
                    </div>
                  </div>
                </div>

                {/* 4 Pieces Icons */}
                <div className="grid grid-cols-4 gap-2 my-4">
                  {suit53.parts?.map((p: any) => (
                    <div key={p.id} className="p-2 rounded-xl bg-gray-950/70 border border-gray-800 text-center">
                      <div className="w-10 h-10 mx-auto rounded-lg overflow-hidden border border-gray-700 bg-gray-900 mb-1">
                        <ImageWithFallback
                          src={p.icon}
                          alt={p.name}
                          className="w-full h-full object-cover"
                        />
                      </div>
                      <div className="text-[11px] font-semibold text-gray-200 truncate">{p.name}</div>
                      <div className="text-[9px] text-gray-500">{p.slot_name}</div>
                    </div>
                  ))}
                </div>

                <div className="text-xs text-gray-400 space-y-1 p-2.5 rounded-lg bg-gray-950/50 border border-gray-800">
                  <div>• Mốc 2 món: [[1, 300], [2, 250]]</div>
                  <div>• Mốc 3 món: [[3, 200], [4, 500]]</div>
                  <div>• Mốc 4 món: [[1, 300], [2, 250], [5, 3300]]</div>
                </div>
              </div>

              <Link
                href="/suits/53"
                className="w-full mt-4 py-2.5 rounded-xl bg-emerald-600/30 hover:bg-emerald-600 text-emerald-200 hover:text-white border border-emerald-500/40 font-semibold text-xs text-center transition-all block"
              >
                Chi Tiết Bộ 53 & Đao Ninja ➔
              </Link>
            </div>
          )}

          {/* Featured Skill: Chidori 76510 */}
          {chidori && (
            <div className="p-6 rounded-2xl border border-blue-900/40 bg-gradient-to-br from-blue-950/40 to-gray-950/90 shadow-xl flex flex-col justify-between">
              <div>
                <div className="flex items-center gap-4 mb-4">
                  <div className="w-16 h-16 rounded-xl overflow-hidden border-2 border-blue-500/40 shadow-lg flex-shrink-0 bg-gray-950">
                    <ImageWithFallback
                      src={chidori.icon}
                      alt={chidori.name}
                      className="w-full h-full object-cover"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-blue-400 font-semibold uppercase tracking-wider">
                      Kỹ Năng Tiêu Biểu (ID: 76510)
                    </div>
                    <h3 className="text-xl font-bold text-white leading-tight">
                      {chidori.name}
                    </h3>
                    <div className="flex items-center gap-2 mt-1">
                      <span className="text-xs px-2 py-0.5 rounded bg-blue-500/20 text-blue-300 border border-blue-500/30">
                        {chidori.skill_type}
                      </span>
                      <span className="text-xs text-gray-400 font-mono">
                        cd: {chidori.cd}
                      </span>
                    </div>
                  </div>
                </div>

                <div className="p-3 rounded-xl bg-gray-950/60 border border-gray-800 text-xs text-gray-300 leading-relaxed mb-3">
                  &ldquo;{chidori.description}&rdquo;
                </div>

                <div className="p-2.5 rounded-lg bg-gray-950/40 border border-gray-800 text-[11px] text-gray-400">
                  <div className="font-semibold text-gray-300 mb-1">Chuỗi tiến hóa 3 giai đoạn:</div>
                  <div className="flex items-center gap-2">
                    <span className="text-blue-400 font-bold">Chidori</span>
                    <span>➔</span>
                    <span>Chidori Giai 2</span>
                    <span>➔</span>
                    <span>Chidori Giai 3</span>
                  </div>
                </div>
              </div>

              <Link
                href="/skills/76510"
                className="w-full mt-4 py-2.5 rounded-xl bg-blue-600/30 hover:bg-blue-600 text-blue-200 hover:text-white border border-blue-500/40 font-semibold text-xs text-center transition-all block"
              >
                Xem Chuỗi Tiến Hóa Kỹ Năng ➔
              </Link>
            </div>
          )}

        </div>
      </section>

      {/* 4. METHODOLOGY & EDITORIAL PRINCIPLES BANNER */}
      <section className="p-8 rounded-2xl border border-gray-800 bg-gray-900/30 text-gray-400 text-xs leading-relaxed space-y-3">
        <h3 className="text-sm font-bold text-gray-200 uppercase tracking-wider flex items-center gap-2">
          <span>🛡️</span> Nguyên Tắc Biên Tập & Minh Bạch Dữ Liệu
        </h3>
        <p>
          • <b>Bảo toàn cấu hình nguồn:</b> Tất cả giá trị thuộc tính (HP, PATK, CD, rate, effect) được trích xuất tĩnh nguyên vẹn từ các tệp cấu hình game (.config). Không tự gán đơn vị tính (như giây s) hay suy đoán công thức sát thương khi chưa có đối chiếu game thực tế.
        </p>
        <p>
          • <b>Tách bạch biên tập:</b> Dữ liệu game độc lập hoàn toàn với các bài viết đánh giá, cẩm nang hướng dẫn hay bảng xếp hạng tier list của biên tập viên.
        </p>
      </section>

    </div>
  );
}
