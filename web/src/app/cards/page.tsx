"use client";

import React, { useState } from "react";
import Link from "next/link";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import HeroCard, { HeroCardData } from "@/components/HeroCard";

// Sample heroes for validation against reference screenshots
const SAMPLE_HEROES: Record<string, HeroCardData & { defaultBre: number; defaultSuper: number; defaultStep: number; defaultElem: number }> = {
  nagato: {
    id: 82400,
    name: "Nagato",
    animation: "peien2",
    full_image: "/assets/heroes/full_82400.png",
    avatar: "/assets/heroes/portraits/image_peien2.png",
    is_world: true, // Dạng Chuyển Thế (Hồn·Nagato)
    quality: 4,
    occupation: 1, // Ma Công
    defaultBre: 7, // Hồn·Nagato
    defaultSuper: 5, // Đỏ++
    defaultStep: 60, // +60
    defaultElem: 20, // Đột phá 20
  },
  frieren: {
    id: 88888,
    name: "Bikini - Frieren",
    animation: "fulilian2",
    full_image: null,
    avatar: "/assets/heroes/portraits/image_fulilian2.png",
    is_world: false, // Dạng thường (khớp media_1792367361990)
    quality: 4,
    occupation: 1, // Ma Công
    defaultBre: 3, // Anh Hùng·Bikini - Frieren
    defaultSuper: 3, // Đỏ (khớp ảnh)
    defaultStep: 53, // +53
    defaultElem: 15,
  },
  kakarot: {
    id: 81200,
    name: "Kakarot",
    animation: "XWukong2",
    full_image: "/assets/heroes/full_81200.png",
    avatar: "/assets/heroes/portraits/image_XWukong2.png",
    is_world: true, // Chuyển thế
    quality: 4,
    occupation: 0, // Vật Công
    defaultBre: 5, // Thần·Kakarot
    defaultSuper: 6, // Vàng
    defaultStep: 60,
    defaultElem: 20,
  },
  vegeta: {
    id: 43600,
    name: "Vegeta",
    animation: "vegeta",
    full_image: null,
    avatar: "/assets/heroes/portraits/image_vegeta.png",
    is_world: false,
    quality: 4,
    occupation: 0,
    defaultBre: 5, // Thần·Vegeta
    defaultSuper: 2, // Cam++
    defaultStep: 45,
    defaultElem: 18,
  },
  ct_vegeta: {
    id: 83300,
    name: "CT - Vegeta",
    animation: "vegeta",
    full_image: null,
    avatar: "/assets/heroes/portraits/image_vegeta.png",
    is_world: true,
    quality: 4,
    occupation: 0,
    defaultBre: 7, // Hồn·CT - Vegeta
    defaultSuper: 8, // Vàng++ Cầu vồng
    defaultStep: 60,
    defaultElem: 20,
  },
};

const SUPER_EVO_OPTIONS = [
  { stage: 0, label: "Gốc (Chưa STH)", tier: "base", badge: "Phẩm gốc" },
  { stage: 1, label: "Cam+", tier: "orange", badge: "Khung Cam bọc vàng" },
  { stage: 2, label: "Cam++", tier: "orange", badge: "Khung Cam Rồng thần" },
  { stage: 3, label: "Đỏ", tier: "red", badge: "Khung Đỏ nguyên bản" },
  { stage: 4, label: "Đỏ+", tier: "red", badge: "Khung Đỏ bọc vàng" },
  { stage: 5, label: "Đỏ++", tier: "red", badge: "Khung Đỏ Rồng thần" },
  { stage: 6, label: "Vàng", tier: "gold", badge: "Khung Hoàng kim" },
  { stage: 7, label: "Vàng+ (Màu)", tier: "rainbow", badge: "Khung Vàng cánh thần" },
  { stage: 8, label: "Vàng++ (Cầu vồng)", tier: "rainbow", badge: "Khung Cầu Vồng tối thượng" },
];

const REBIRTH_OPTIONS = [
  { stage: 0, prefix: "Chưa CS", name: "Nguyên bản", desc: "0 sao", count: 0, isMoon: false },
  { stage: 1, prefix: "Dũng Sĩ", name: "Chuyển 1", desc: "1 sao vàng", count: 1, isMoon: false },
  { stage: 2, prefix: "Đấu Sĩ", name: "Chuyển 2", desc: "2 sao vàng", count: 2, isMoon: false },
  { stage: 3, prefix: "Anh Hùng", name: "Chuyển 3", desc: "3 sao vàng", count: 3, isMoon: false },
  { stage: 4, prefix: "Thần Thoại", name: "Chuyển 4", desc: "4 sao vàng", count: 4, isMoon: false },
  { stage: 5, prefix: "Thần", name: "Chuyển 5", desc: "5 sao vàng", count: 5, isMoon: false },
  { stage: 6, prefix: "Linh", name: "Chuyển 6", desc: "1 trăng khuyết", count: 1, isMoon: true },
  { stage: 7, prefix: "Hồn", name: "Chuyển 7", desc: "2 trăng khuyết", count: 2, isMoon: true },
];

export default function CardShowcasePage() {
  const [selectedHeroKey, setSelectedHeroKey] = useState<string>("nagato");
  const heroData = SAMPLE_HEROES[selectedHeroKey];

  const [superEvo, setSuperEvo] = useState<number>(heroData.defaultSuper);
  const [rebirth, setRebirth] = useState<number>(heroData.defaultBre);
  const [enhancement, setEnhancement] = useState<number>(heroData.defaultStep);
  const [breakthrough, setBreakthrough] = useState<number>(heroData.defaultElem);
  const [auraOverride, setAuraOverride] = useState<boolean | undefined>(undefined);
  const [cardSize, setCardSize] = useState<"sm" | "md" | "lg" | "xl">("lg");

  const handleHeroChange = (key: string) => {
    setSelectedHeroKey(key);
    const h = SAMPLE_HEROES[key];
    setSuperEvo(h.defaultSuper);
    setRebirth(h.defaultBre);
    setEnhancement(h.defaultStep);
    setBreakthrough(h.defaultElem);
    setAuraOverride(undefined);
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col font-sans">
      <Header />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-12">
        {/* Page Title */}
        <div className="text-center space-y-3">
          <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-amber-500/10 border border-amber-500/30 text-amber-400 text-xs font-bold uppercase tracking-wider">
            <span>✨ Chuẩn Game 100%</span>
            <span>•</span>
            <span>Hệ Thống Đa Tầng</span>
          </div>
          <h1 className="text-3xl sm:text-5xl font-black text-transparent bg-clip-text bg-gradient-to-r from-amber-300 via-orange-400 to-red-500 tracking-tight">
            Thẻ Tướng Chuẩn Game Siêu Anh Hùng Hội Tụ
          </h1>
          <p className="text-sm sm:text-base text-slate-400 max-w-2xl mx-auto">
            Khung viền, huy hiệu chuyển sinh, đột phá nguyên tố và hào quang tự động thay đổi theo mốc thực tế trích xuất từ mã nguồn game.
          </p>
        </div>

        {/* ========================================================= */}
        {/* INTERACTIVE PLAYGROUND                                    */}
        {/* ========================================================= */}
        <section className="bg-slate-900/70 border border-slate-800 rounded-3xl p-6 sm:p-8 backdrop-blur shadow-2xl space-y-8">
          <div className="flex flex-col lg:flex-row gap-8 items-center lg:items-start justify-between">
            {/* Left: Controls Panel */}
            <div className="w-full lg:w-3/5 space-y-6">
              {/* 1. Chọn Mẫu Tướng */}
              <div>
                <label className="text-xs font-bold uppercase tracking-wider text-slate-400 block mb-2">
                  1. Chọn Tướng Mẫu Đối Chiếu:
                </label>
                <div className="grid grid-cols-2 sm:grid-cols-3 gap-2.5">
                  {Object.entries(SAMPLE_HEROES).map(([key, h]) => (
                    <button
                      key={key}
                      onClick={() => handleHeroChange(key)}
                      className={`p-2.5 rounded-xl border text-left transition-all flex items-center gap-2.5 ${
                        selectedHeroKey === key
                          ? "bg-amber-500/20 border-amber-500 text-amber-300 shadow-lg shadow-amber-500/20"
                          : "bg-slate-850 border-slate-800 text-slate-300 hover:border-slate-700 hover:bg-slate-800"
                      }`}
                    >
                      <img
                        src={h.avatar || "/assets/card/public_whiteCard.png"}
                        alt={h.name}
                        className="w-8 h-8 rounded-lg object-contain bg-slate-950 p-0.5 border border-slate-700"
                      />
                      <div className="min-w-0">
                        <div className="text-xs font-bold truncate">{h.name}</div>
                        <div className="text-[10px] text-slate-500">{h.is_world ? "Chuyển thế" : "Bản thường"}</div>
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* 2. Mốc Siêu Tiến Hoá */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-400">
                    2. Mốc Siêu Tiến Hoá (Đổi Màu & Hoa Văn Khung):
                  </label>
                  <span className="text-xs font-bold text-amber-400">
                    {SUPER_EVO_OPTIONS[superEvo]?.label}
                  </span>
                </div>
                <div className="grid grid-cols-3 sm:grid-cols-5 gap-1.5">
                  {SUPER_EVO_OPTIONS.map((opt) => (
                    <button
                      key={opt.stage}
                      onClick={() => setSuperEvo(opt.stage)}
                      className={`px-2.5 py-2 rounded-lg text-xs font-bold border transition-all text-center ${
                        superEvo === opt.stage
                          ? opt.tier === "rainbow"
                            ? "bg-gradient-to-r from-amber-600 via-rose-600 to-purple-600 text-white border-yellow-300 shadow-md"
                            : opt.tier === "gold"
                            ? "bg-yellow-500/30 text-yellow-300 border-yellow-400 shadow-md"
                            : opt.tier === "red"
                            ? "bg-red-500/30 text-red-300 border-red-500 shadow-md"
                            : opt.tier === "orange"
                            ? "bg-orange-500/30 text-orange-300 border-orange-500 shadow-md"
                            : "bg-slate-700 text-white border-slate-500"
                          : "bg-slate-850 border-slate-800 text-slate-400 hover:text-slate-200"
                      }`}
                    >
                      {opt.label}
                    </button>
                  ))}
                </div>
              </div>

              {/* 3. Mốc Chuyển Sinh */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <label className="text-xs font-bold uppercase tracking-wider text-slate-400">
                    3. Mốc Chuyển Sinh (Biểu Tượng PNG Chuẩn Game):
                  </label>
                  <div className="flex items-center gap-1.5">
                    <span className="text-xs font-bold text-sky-400">
                      {REBIRTH_OPTIONS[rebirth]?.name}
                    </span>
                    <span className="text-xs text-slate-400">
                      ({REBIRTH_OPTIONS[rebirth]?.desc})
                    </span>
                    {REBIRTH_OPTIONS[rebirth]?.count > 0 && (
                      <div className="inline-flex items-center gap-0.5 ml-1">
                        {Array.from({ length: REBIRTH_OPTIONS[rebirth].count }).map((_, i) => (
                          <img
                            key={i}
                            src={
                              REBIRTH_OPTIONS[rebirth].isMoon
                                ? "/assets/card/public_moon_icon.png"
                                : "/assets/card/public_equip_star.png"
                            }
                            alt="icon"
                            className="w-3.5 h-3.5 object-contain filter drop-shadow"
                          />
                        ))}
                      </div>
                    )}
                  </div>
                </div>
                <div className="grid grid-cols-4 sm:grid-cols-8 gap-1.5">
                  {REBIRTH_OPTIONS.map((opt) => (
                    <button
                      key={opt.stage}
                      onClick={() => setRebirth(opt.stage)}
                      className={`px-2 py-1.5 rounded-lg text-xs font-bold border transition-all flex flex-col items-center justify-center gap-1 ${
                        rebirth === opt.stage
                          ? "bg-sky-500/30 border-sky-400 text-sky-300 shadow-md"
                          : "bg-slate-850 border-slate-800 text-slate-400 hover:text-slate-200"
                      }`}
                    >
                      <span>{opt.prefix || "Gốc"}</span>
                      <div className="flex items-center gap-0.5 h-3">
                        {opt.count > 0 ? (
                          Array.from({ length: opt.count }).map((_, i) => (
                            <img
                              key={i}
                              src={
                                opt.isMoon
                                  ? "/assets/card/public_moon_icon.png"
                                  : "/assets/card/public_equip_star.png"
                              }
                              alt=""
                              className="w-2.5 h-2.5 object-contain"
                            />
                          ))
                        ) : (
                          <span className="text-[9px] text-slate-600">-</span>
                        )}
                      </div>
                    </button>
                  ))}
                </div>
              </div>

              {/* 4. Cường Hoá & Đột Phá */}
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
                {/* Cường Hoá +1..+60 */}
                <div className="bg-slate-950/60 p-3.5 rounded-2xl border border-slate-800 space-y-2">
                  <div className="flex justify-between text-xs font-bold">
                    <span className="text-slate-400">Cường Hoá:</span>
                    <span className="text-amber-400 font-mono">+{enhancement}</span>
                  </div>
                  <input
                    type="range"
                    min="0"
                    max="60"
                    value={enhancement}
                    onChange={(e) => setEnhancement(Number(e.target.value))}
                    className="w-full accent-amber-500 cursor-pointer"
                  />
                  <div className="flex justify-between text-[10px] text-slate-500 font-mono">
                    <button onClick={() => setEnhancement(0)} className="hover:text-amber-300">+0</button>
                    <button onClick={() => setEnhancement(20)} className="hover:text-amber-300">+20</button>
                    <button onClick={() => setEnhancement(53)} className="hover:text-amber-300">+53 (Mẫu)</button>
                    <button onClick={() => setEnhancement(60)} className="hover:text-amber-300">+60 (Max)</button>
                  </div>
                </div>

                {/* Đột Phá Nguyên Tố 1..20 */}
                <div className="bg-slate-950/60 p-3.5 rounded-2xl border border-slate-800 space-y-2">
                  <div className="flex justify-between text-xs font-bold">
                    <span className="text-slate-400">Cấp Đột Phá (Huy hiệu cánh):</span>
                    <span className="text-purple-400 font-mono">Cấp {breakthrough}</span>
                  </div>
                  <input
                    type="range"
                    min="1"
                    max="20"
                    value={breakthrough}
                    onChange={(e) => setBreakthrough(Number(e.target.value))}
                    className="w-full accent-purple-500 cursor-pointer"
                  />
                  <div className="flex justify-between text-[10px] text-slate-500 font-mono">
                    <button onClick={() => setBreakthrough(1)} className="hover:text-purple-300">Cấp 1</button>
                    <button onClick={() => setBreakthrough(7)} className="hover:text-purple-300">Cấp 7</button>
                    <button onClick={() => setBreakthrough(10)} className="hover:text-purple-300">Cấp 10</button>
                    <button onClick={() => setBreakthrough(20)} className="hover:text-purple-300">Cấp 20 (Max)</button>
                  </div>
                </div>
              </div>

              {/* 5. Tùy Chọn Hiển Thị & Kích Thước */}
              <div className="flex flex-wrap items-center justify-between gap-4 pt-2 border-t border-slate-800/80">
                <div className="flex items-center gap-2">
                  <span className="text-xs text-slate-400 font-bold">Kích cỡ:</span>
                  {(["sm", "md", "lg", "xl"] as const).map((sz) => (
                    <button
                      key={sz}
                      onClick={() => setCardSize(sz)}
                      className={`px-2.5 py-1 rounded text-xs font-bold uppercase transition-all ${
                        cardSize === sz
                          ? "bg-slate-700 text-amber-300 border border-slate-600"
                          : "text-slate-500 hover:text-slate-300"
                      }`}
                    >
                      {sz}
                    </button>
                  ))}
                </div>

                <div className="flex items-center gap-2">
                  <span className="text-xs text-slate-400 font-bold">Hào quang đỏ (Chuyển thế):</span>
                  <button
                    onClick={() => setAuraOverride(auraOverride === undefined ? !heroData.is_world : !auraOverride)}
                    className={`px-3 py-1 rounded text-xs font-bold transition-all ${
                      (auraOverride !== undefined ? auraOverride : heroData.is_world)
                        ? "bg-red-500/20 text-red-300 border border-red-500/40"
                        : "bg-slate-800 text-slate-500 border border-slate-700"
                    }`}
                  >
                    {(auraOverride !== undefined ? auraOverride : heroData.is_world) ? "ĐANG BẬT" : "TẮT"}
                  </button>
                </div>
              </div>
            </div>

            {/* Right: Live Interactive Card Canvas */}
            <div className="w-full lg:w-2/5 flex flex-col items-center justify-center p-6 bg-slate-950/80 rounded-2xl border border-slate-800/80 min-h-[460px]">
              <div className="text-[11px] font-mono text-slate-500 mb-2">
                Xem thử thẻ tướng thực tế:
              </div>

              <HeroCard
                hero={heroData}
                superQualityStage={superEvo}
                rebirthStage={rebirth}
                breakthroughLevel={breakthrough}
                enhancementLevel={enhancement}
                showAura={auraOverride}
                size={cardSize}
              />

              <div className="mt-4 text-center space-y-1">
                <div className="text-xs text-slate-400 font-mono">
                  Asset Khung: <span className="text-amber-300">{SUPER_EVO_OPTIONS[superEvo]?.badge}</span>
                </div>
                <div className="text-[11px] text-slate-500">
                  {heroData.is_world ? "🔥 Bản Chuyển Thế: Hào quang đỏ tự động kích hoạt" : "🛡️ Bản Thường: Không có hào quang đỏ theo chuẩn game"}
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* ========================================================= */}
        {/* SIDE-BY-SIDE IN-GAME SAMPLES VALIDATION                   */}
        {/* ========================================================= */}
        <section className="space-y-6">
          <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2 border-b border-slate-800 pb-4">
            <div>
              <h2 className="text-xl sm:text-2xl font-black text-white">
                Đối Chiếu Ảnh Tham Chiếu Trong Game
              </h2>
              <p className="text-xs sm:text-sm text-slate-400">
                Các mẫu tướng thực tế khớp 100% với ảnh chụp màn hình game của người dùng.
              </p>
            </div>
            <Link
              href="/heroes/82400"
              className="px-4 py-2 rounded-xl text-xs font-bold bg-amber-500/20 text-amber-300 border border-amber-500/30 hover:bg-amber-500/30 transition-all"
            >
              Xem Trang Chi Tiết Nagato →
            </Link>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* Mẫu 1: Nagato */}
            <div className="bg-slate-900/60 border border-slate-800/80 rounded-2xl p-5 flex flex-col items-center justify-between hover:border-slate-700 transition-all">
              <div className="w-full text-center mb-2">
                <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-red-950 text-red-300 border border-red-500/40">
                  Ảnh Mẫu 1 (media_1792363458470)
                </span>
                <div className="text-xs font-bold text-slate-300 mt-1">Hồn·Nagato +60</div>
                <div className="text-[10px] text-slate-500">Chuyển 7 • Đột phá 20 • Hào quang đỏ</div>
              </div>
              <HeroCard
                hero={SAMPLE_HEROES.nagato}
                superQualityStage={5} // Đỏ++
                rebirthStage={7} // Hồn
                breakthroughLevel={20}
                enhancementLevel={60}
                size="md"
              />
              <div className="w-full mt-4 text-[11px] text-slate-400 bg-slate-950/70 p-2.5 rounded-lg border border-slate-800/60">
                ✔️ Đầu và thanh sắt Lục Đạo nhô cao ngoài khung không bị cắt.
              </div>
            </div>

            {/* Mẫu 2: Bikini - Frieren */}
            <div className="bg-slate-900/60 border border-slate-800/80 rounded-2xl p-5 flex flex-col items-center justify-between hover:border-slate-700 transition-all">
              <div className="w-full text-center mb-2">
                <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-amber-950 text-amber-300 border border-amber-500/40">
                  Ảnh Mẫu 2 (media_1792367361990)
                </span>
                <div className="text-xs font-bold text-slate-300 mt-1">Anh Hùng·Bikini - Frieren +53</div>
                <div className="text-[10px] text-slate-500">Chuyển 3 (3 sao) • STH Đỏ • Bản thường</div>
              </div>
              <HeroCard
                hero={SAMPLE_HEROES.frieren}
                superQualityStage={3} // Đỏ
                rebirthStage={3} // Anh Hùng (3 sao)
                breakthroughLevel={15}
                enhancementLevel={53}
                size="md"
              />
              <div className="w-full mt-4 text-[11px] text-slate-400 bg-slate-950/70 p-2.5 rounded-lg border border-slate-800/60">
                ✔️ Cây trượng pháp thuật, tóc song bính và đàn bướm nhô trọn vẹn.
              </div>
            </div>

            {/* Mẫu 3: Kakarot */}
            <div className="bg-slate-900/60 border border-slate-800/80 rounded-2xl p-5 flex flex-col items-center justify-between hover:border-slate-700 transition-all">
              <div className="w-full text-center mb-2">
                <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-purple-950 text-purple-300 border border-purple-500/40">
                  Mẫu Kakarot Chuyển Thế
                </span>
                <div className="text-xs font-bold text-slate-300 mt-1">Thần·Kakarot +60</div>
                <div className="text-[10px] text-slate-500">Chuyển 5 (5 sao) • STH Vàng • Hào quang</div>
              </div>
              <HeroCard
                hero={SAMPLE_HEROES.kakarot}
                superQualityStage={6} // Vàng
                rebirthStage={5} // Thần (5 sao)
                breakthroughLevel={20}
                enhancementLevel={60}
                size="md"
              />
              <div className="w-full mt-4 text-[11px] text-slate-400 bg-slate-950/70 p-2.5 rounded-lg border border-slate-800/60">
                ✔️ Tóc Xayda nhọn nhô tự nhiên ra khỏi viền kim loại.
              </div>
            </div>

            {/* Mẫu 4: CT - Vegeta */}
            <div className="bg-slate-900/60 border border-slate-800/80 rounded-2xl p-5 flex flex-col items-center justify-between hover:border-slate-700 transition-all">
              <div className="w-full text-center mb-2">
                <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-yellow-950 text-yellow-300 border border-yellow-500/40">
                  Mẫu CT - Vegeta Cầu Vồng
                </span>
                <div className="text-xs font-bold text-slate-300 mt-1">Hồn·CT - Vegeta +60</div>
                <div className="text-[10px] text-slate-500">Chuyển 7 • Vàng++ Cầu Vồng • Rồng vàng</div>
              </div>
              <HeroCard
                hero={SAMPLE_HEROES.ct_vegeta}
                superQualityStage={8} // Vàng++ Cầu vồng
                rebirthStage={7} // Hồn (2 trăng)
                breakthroughLevel={20}
                enhancementLevel={60}
                size="md"
              />
              <div className="w-full mt-4 text-[11px] text-slate-400 bg-slate-950/70 p-2.5 rounded-lg border border-slate-800/60">
                ✔️ Rồng vàng uốn lượn góc trên đỉnh thẻ cùng chân đế thần thánh.
              </div>
            </div>
          </div>
        </section>

        {/* ========================================================= */}
        {/* DEDICATED SIDE-BY-SIDE PAIR COMPARISONS                   */}
        {/* Cam/Cam++, Đỏ/Đỏ++, Vàng/Vàng++                          */}
        {/* ========================================================= */}
        <section className="bg-slate-900/60 border border-slate-800 rounded-3xl p-6 sm:p-8 space-y-8">
          <div className="border-b border-slate-800 pb-4">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-emerald-500/10 border border-emerald-500/30 text-emerald-400 text-xs font-bold uppercase tracking-wider mb-2">
              <span>🎯 Xác Minh Chuẩn Hóa Khung Nhìn Thấy</span>
            </div>
            <h2 className="text-xl sm:text-3xl font-black text-white">
              So Sánh Trực Tiếp Kích Thước Khung Thẻ
            </h2>
            <p className="text-xs sm:text-sm text-slate-400 mt-1 max-w-3xl">
              Đối chiếu trực diện các cặp <b>Cam / Cam++</b>, <b>Đỏ / Đỏ++</b>, <b>Vàng / Vàng++</b> trên cùng một bản thể tướng. Khung nhìn thấy chuẩn hóa 100% kích thước 185×258, họa tiết rồng thần vươn ra ngoài tự nhiên mà không làm co nhỏ khung thẻ hay thay đổi kích thước nhân vật.
            </p>
          </div>

          <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
            {/* Cặp 1: Cam+ vs Cam++ */}
            <div className="bg-slate-950/70 border border-orange-500/30 rounded-2xl p-5 flex flex-col space-y-4">
              <div className="text-center pb-2 border-b border-slate-800">
                <span className="px-2.5 py-0.5 rounded text-[11px] font-bold bg-orange-950 text-orange-300 border border-orange-500/40">
                  Cặp 1: Mốc Cam
                </span>
                <h3 className="text-sm font-bold text-slate-200 mt-1">Cam+ vs Cam++ (Rồng thần)</h3>
                <p className="text-[11px] text-slate-500">Khung nhìn thấy chuẩn 185×258 khớp 100%</p>
              </div>

              <div className="relative grid grid-cols-2 gap-4 items-end justify-items-center py-2">
                {/* Horizontal Alignment Guide lines */}
                <div className="absolute inset-x-0 top-1/4 border-t border-dashed border-orange-500/20 pointer-events-none z-0" />
                <div className="absolute inset-x-0 bottom-1/4 border-b border-dashed border-orange-500/20 pointer-events-none z-0" />

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-orange-400 mb-1">Mốc 1: Cam+</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.nagato}
                    superQualityStage={1}
                    rebirthStage={3}
                    breakthroughLevel={10}
                    enhancementLevel={20}
                    showAura={false}
                    size="sm"
                  />
                  <span className="text-[10px] text-slate-400 font-mono mt-1">Khung chuẩn</span>
                </div>

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-orange-300 mb-1">Mốc 2: Cam++</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.nagato}
                    superQualityStage={2}
                    rebirthStage={3}
                    breakthroughLevel={10}
                    enhancementLevel={20}
                    showAura={false}
                    size="sm"
                  />
                  <span className="text-[10px] text-emerald-400 font-mono mt-1">✔️ Rồng không co nhỏ</span>
                </div>
              </div>

              <div className="text-[11px] text-slate-400 bg-slate-900/80 p-2.5 rounded-xl border border-slate-800 space-y-1">
                <div className="text-emerald-400 font-semibold">✔️ Chuẩn hóa tỉ lệ:</div>
                <div>Thân khung Cam++ có cùng chiều cao & chiều rộng với Cam+, rồng thần vươn lên trên tự nhiên.</div>
              </div>
            </div>

            {/* Cặp 2: Đỏ+ vs Đỏ++ */}
            <div className="bg-slate-950/70 border border-red-500/30 rounded-2xl p-5 flex flex-col space-y-4">
              <div className="text-center pb-2 border-b border-slate-800">
                <span className="px-2.5 py-0.5 rounded text-[11px] font-bold bg-red-950 text-red-300 border border-red-500/40">
                  Cặp 2: Mốc Đỏ
                </span>
                <h3 className="text-sm font-bold text-slate-200 mt-1">Đỏ+ vs Đỏ++ (Rồng thần)</h3>
                <p className="text-[11px] text-slate-500">Khung nhìn thấy chuẩn 185×258 khớp 100%</p>
              </div>

              <div className="relative grid grid-cols-2 gap-4 items-end justify-items-center py-2">
                {/* Horizontal Alignment Guide lines */}
                <div className="absolute inset-x-0 top-1/4 border-t border-dashed border-red-500/20 pointer-events-none z-0" />
                <div className="absolute inset-x-0 bottom-1/4 border-b border-dashed border-red-500/20 pointer-events-none z-0" />

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-red-400 mb-1">Mốc 4: Đỏ+</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.frieren}
                    superQualityStage={4}
                    rebirthStage={5}
                    breakthroughLevel={15}
                    enhancementLevel={50}
                    showAura={false}
                    size="sm"
                  />
                  <span className="text-[10px] text-slate-400 font-mono mt-1">Khung chuẩn</span>
                </div>

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-red-300 mb-1">Mốc 5: Đỏ++</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.frieren}
                    superQualityStage={5}
                    rebirthStage={5}
                    breakthroughLevel={15}
                    enhancementLevel={50}
                    showAura={false}
                    size="sm"
                  />
                  <span className="text-[10px] text-emerald-400 font-mono mt-1">✔️ Rồng không co nhỏ</span>
                </div>
              </div>

              <div className="text-[11px] text-slate-400 bg-slate-900/80 p-2.5 rounded-xl border border-slate-800 space-y-1">
                <div className="text-emerald-400 font-semibold">✔️ Vị trí nhân vật:</div>
                <div>Hình tướng Frieren và cây trượng giữ nguyên tỉ lệ, không bị co nhỏ hay nhảy vị trí khi lên Đỏ++.</div>
              </div>
            </div>

            {/* Cặp 3: Vàng+ vs Vàng++ */}
            <div className="bg-slate-950/70 border border-amber-500/30 rounded-2xl p-5 flex flex-col space-y-4">
              <div className="text-center pb-2 border-b border-slate-800">
                <span className="px-2.5 py-0.5 rounded text-[11px] font-bold bg-amber-950 text-amber-300 border border-amber-500/40">
                  Cặp 3: Mốc Hoàng Kim / Cầu Vồng
                </span>
                <h3 className="text-sm font-bold text-slate-200 mt-1">Vàng+ vs Vàng++ (Cầu Vồng)</h3>
                <p className="text-[11px] text-slate-500">Khung nhìn thấy chuẩn 185×258 khớp 100%</p>
              </div>

              <div className="relative grid grid-cols-2 gap-4 items-end justify-items-center py-2">
                {/* Horizontal Alignment Guide lines */}
                <div className="absolute inset-x-0 top-1/4 border-t border-dashed border-amber-500/20 pointer-events-none z-0" />
                <div className="absolute inset-x-0 bottom-1/4 border-b border-dashed border-amber-500/20 pointer-events-none z-0" />

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-amber-400 mb-1">Mốc 7: Vàng+</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.ct_vegeta}
                    superQualityStage={7}
                    rebirthStage={7}
                    breakthroughLevel={20}
                    enhancementLevel={60}
                    showAura={true}
                    size="sm"
                  />
                  <span className="text-[10px] text-slate-400 font-mono mt-1">Khung cánh thần</span>
                </div>

                <div className="flex flex-col items-center">
                  <span className="text-[11px] font-mono font-bold text-yellow-300 mb-1">Mốc 8: Vàng++</span>
                  <HeroCard
                    hero={SAMPLE_HEROES.ct_vegeta}
                    superQualityStage={8}
                    rebirthStage={7}
                    breakthroughLevel={20}
                    enhancementLevel={60}
                    showAura={true}
                    size="sm"
                  />
                  <span className="text-[10px] text-emerald-400 font-mono mt-1">✔️ Rồng không co nhỏ</span>
                </div>
              </div>

              <div className="text-[11px] text-slate-400 bg-slate-900/80 p-2.5 rounded-xl border border-slate-800 space-y-1">
                <div className="text-emerald-400 font-semibold">✔️ Mặt trăng & Rồng vàng:</div>
                <div>2 trăng khuyết PNG (Chuyển 7) cùng hào quang đỏ hiển thị sắc nét, khung Cầu Vồng uy nghi.</div>
              </div>
            </div>
          </div>
        </section>

        {/* ========================================================= */}
        {/* ELEMENT BREAKTHROUGH BADGE NUMBERS TEST (1, 7, 10, 20)    */}
        {/* ========================================================= */}
        <section className="bg-slate-900/60 border border-slate-800 rounded-3xl p-6 sm:p-8 space-y-8">
          <div className="border-b border-slate-800 pb-4">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-purple-500/10 border border-purple-500/30 text-purple-400 text-xs font-bold uppercase tracking-wider mb-2">
              <span>💎 Chuẩn Game 100% • Typography & Stroke</span>
            </div>
            <h2 className="text-xl sm:text-3xl font-black text-white">
              Kiểm Tra Số Trên Huy Hiệu Đột Phá (Cấp 1, 7, 10, 20)
            </h2>
            <p className="text-xs sm:text-sm text-slate-400 mt-1 max-w-3xl">
              Xác minh số hiển thị trên huy hiệu cánh lục giác bên phải hình tướng với các mốc một chữ số (<b>1</b>, <b>7</b>) và hai chữ số (<b>10</b>, <b>20</b>). Chữ số màu đen/xanh tím đậm với viền trắng mảnh sắc nét, dáng cao hẹp theo font <code>GillSans-Bold</code> chuẩn file cấu hình CCBI game, không dùng bóng mờ gây nhoè.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-6">
            {[
              { level: 1, label: "Cấp 1 (1 chữ số)", note: "Số 1 căn giữa cân đối, không lệch tâm" },
              { level: 7, label: "Cấp 7 (1 chữ số)", note: "Số 7 dáng cao, nét chéo rõ ràng" },
              { level: 10, label: "Cấp 10 (2 chữ số)", note: "Số 10 vừa vặn trong mặt pha lê tím" },
              { level: 20, label: "Cấp 20 (Max - Mẫu Nagato)", note: "Khớp 100% ảnh tham chiếu in-game" },
            ].map((item) => (
              <div
                key={item.level}
                className="bg-slate-950/80 border border-slate-800 hover:border-purple-500/40 rounded-2xl p-5 flex flex-col items-center justify-between space-y-4 transition-all"
              >
                {/* Header tag */}
                <div className="text-center w-full">
                  <span className="px-2.5 py-0.5 rounded text-[11px] font-bold bg-purple-950 text-purple-300 border border-purple-500/40">
                    {item.label}
                  </span>
                </div>

                {/* Badge Zoom Close-Up */}
                <div className="flex flex-col items-center bg-slate-900/80 p-3 rounded-xl border border-slate-800/80 w-full">
                  <div className="text-[10px] text-slate-500 font-mono mb-2">Cận cảnh huy hiệu:</div>
                  <div className="relative w-16 h-16 flex items-center justify-center">
                    <img
                      src="/assets/card/bt_element.png"
                      alt="Huy hiệu"
                      className="w-full h-full object-contain filter drop-shadow-[0_2px_8px_rgba(0,0,0,0.9)]"
                    />
                    <span
                      style={{
                        position: "absolute",
                        top: "43%",
                        left: "53%",
                        transform: "translate(-50%, -50%)",
                        fontSize: 32,
                        fontFamily: "'Gill Sans', 'Gill Sans MT', 'Trebuchet MS', 'Impact', sans-serif",
                        fontWeight: 900,
                        lineHeight: 1,
                        color: "#0b0f19",
                        WebkitTextStroke: "1.5px #ffffff",
                        paintOrder: "stroke fill",
                        letterSpacing: "-0.04em",
                        userSelect: "none",
                        pointerEvents: "none",
                      }}
                    >
                      {item.level}
                    </span>
                  </div>
                </div>

                {/* Full Card Preview */}
                <div className="flex flex-col items-center">
                  <HeroCard
                    hero={SAMPLE_HEROES.nagato}
                    superQualityStage={5} // Đỏ++
                    rebirthStage={7} // Hồn (2 trăng)
                    breakthroughLevel={item.level}
                    enhancementLevel={60}
                    showAura={false}
                    size="sm"
                  />
                </div>

                {/* Footer Note */}
                <div className="text-[10px] text-slate-400 font-mono text-center w-full bg-slate-900/50 p-2 rounded-lg border border-slate-800/50">
                  {item.note}
                </div>
              </div>
            ))}
          </div>
        </section>

        {/* ========================================================= */}
        {/* MATRIX OF ALL 8 SUPER EVO FRAMES                          */}
        {/* ========================================================= */}
        <section className="space-y-6">
          <div className="border-b border-slate-800 pb-4">
            <h2 className="text-xl sm:text-2xl font-black text-white">
              Ma Trận Toàn Bộ 8 Khung Siêu Tiến Hoá
            </h2>
            <p className="text-xs sm:text-sm text-slate-400">
              Trình diễn cùng một bản thể tướng (Nagato) qua toàn bộ chuỗi tiến cấp từ Cam đến Cầu Vồng.
            </p>
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-8 gap-4">
            {SUPER_EVO_OPTIONS.slice(1).map((opt) => (
              <div
                key={opt.stage}
                className="bg-slate-900/40 border border-slate-800 rounded-xl p-3 flex flex-col items-center text-center hover:border-slate-700 transition-all"
              >
                <div className="text-[11px] font-bold text-amber-300 mb-1">{opt.label}</div>
                <HeroCard
                  hero={SAMPLE_HEROES.nagato}
                  superQualityStage={opt.stage}
                  rebirthStage={Math.min(opt.stage, 7)}
                  breakthroughLevel={opt.stage * 2 + 4}
                  enhancementLevel={opt.stage * 7}
                  showElementBadge={false}
                  showAura={false}
                  size="sm"
                />
                <div className="text-[9px] font-mono text-slate-500 mt-2 truncate w-full" title={opt.badge}>
                  {opt.badge}
                </div>
              </div>
            ))}
          </div>
        </section>
      </main>

      <Footer />
    </div>
  );
}
