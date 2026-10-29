"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import { TierListData, TierListHero } from "@/lib/data";

interface TierListInteractiveViewProps {
  initialData: TierListData;
}

export default function TierListInteractiveView({ initialData }: TierListInteractiveViewProps) {
  const [selectedRole, setSelectedRole] = useState<"ALL" | "DEALER" | "SUPPORT">("ALL");
  const [displayQuality, setDisplayQuality] = useState<"vector" | "image4k">("vector");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [lightboxImage, setLightboxImage] = useState<{ src: string; title: string } | null>(null);
  const [zoomLevel, setZoomLevel] = useState<number>(1);

  const q = searchQuery.toLowerCase().trim();

  const dealerHeroes = initialData.groups[0]?.heroes || [];
  const supportHeroes = initialData.groups[1]?.heroes || [];

  const matchedHeroIds = useMemo(() => {
    if (!q) return new Set<string>();
    const all = [...dealerHeroes, ...supportHeroes];
    const matched = all.filter(
      (h) =>
        h.name.toLowerCase().includes(q) ||
        h.game_name.toLowerCase().includes(q) ||
        h.id.includes(q) ||
        h.tier.toLowerCase().includes(q)
    );
    return new Set(matched.map((h) => h.id));
  }, [dealerHeroes, supportHeroes, q]);

  // Dealer rows definition for vector rendering
  const dealerGrid = useMemo(() => {
    const heroesMap: Record<string, TierListHero> = {};
    for (const h of dealerHeroes) {
      heroesMap[h.name] = h;
    }

    return {
      title: "DEALER",
      subtitle: "Sát Thương Chủ Lực",
      headerBg: "bg-[#717171]",
      headerText: "text-[#ffd428]",
      rows: [
        {
          tier: "UBER",
          tierBg: "bg-[#d60000]",
          tierColor: "text-white",
          isSplit: true,
          cell1: heroesMap["CT Tenka"],
          tier2: "TIER 0",
          tier2Bg: "bg-[#bf3900]",
          tier2Color: "text-white",
          restCells: [heroesMap["CT Sasuke"], heroesMap["CT Shamrock"], heroesMap["Vegeta (Fusion)"]],
        },
        {
          tier: "TIER 1",
          tierBg: "bg-[#eb6100]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["CT-Zoro"],
            heroesMap["CT-Newgate"],
            heroesMap["Vegetto"],
            heroesMap["CT-Shalltear"],
            heroesMap["CT-Tanjiro"],
          ],
        },
        {
          tier: "TIER 2",
          tierBg: "bg-[#f5a623]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["Sasuke"],
            heroesMap["Shanks"],
            heroesMap["Zoro"],
            heroesMap["CT-Gojo"],
            heroesMap["Tanjiro"],
          ],
        },
        {
          tier: "TIER 3",
          tierBg: "bg-[#9ecf8d]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["Tohka"],
            heroesMap["Râu Trắng"],
            heroesMap["Kenpachi"],
            heroesMap["CT-Rimuru"],
            heroesMap["Kikyo"],
          ],
        },
      ],
    };
  }, [dealerHeroes]);

  // Support rows definition for vector rendering
  const supportGrid = useMemo(() => {
    const heroesMap: Record<string, TierListHero> = {};
    for (const h of supportHeroes) {
      heroesMap[h.name] = h;
    }

    return {
      title: "SUPPORT + HYBRID",
      subtitle: "Hỗ Trợ, Đa Năng & Khống Chế",
      headerBg: "bg-[#717171]",
      headerText: "text-[#ffd428]",
      rows: [
        {
          tier: "UBER",
          tierBg: "bg-[#d60000]",
          tierColor: "text-white",
          cells: [heroesMap["CT Nagato"], heroesMap["CT Shadow"], null, null, null],
        },
        {
          tier: "TIER 0",
          tierBg: "bg-[#bf3900]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Trunks"],
            heroesMap["CT-Broli"],
            heroesMap["CT-Kakarot"],
            heroesMap["CT-Elaina"],
            heroesMap["CT-Frieren"],
          ],
        },
        {
          tier: "TIER 1",
          tierBg: "bg-[#eb6100]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Gohan"],
            heroesMap["Piccolo"],
            heroesMap["CT-Meliodas"],
            heroesMap["MG-Maple"],
            heroesMap["Số 18"],
          ],
        },
        {
          tier: "TIER 2",
          tierBg: "bg-[#f5a623]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Inori"],
            heroesMap["Kakarot SSJ3"],
            heroesMap["CT-Luffy Nika"],
            heroesMap["CT-Kanae"],
            heroesMap["Cid Kagenou"],
          ],
        },
        {
          tier: "TIER 3",
          tierBg: "bg-[#9ecf8d]",
          tierColor: "text-white",
          cells: [
            heroesMap["Pain"],
            heroesMap["Broli"],
            heroesMap["Meliodas"],
            heroesMap["Frieren"],
            heroesMap["Elaina"],
          ],
        },
        {
          tier: "TIER 4",
          tierBg: "bg-[#7eaddf]",
          tierColor: "text-white",
          cells: [
            heroesMap["Trunks"],
            heroesMap["Inori"],
            heroesMap["Maple"],
            heroesMap["Shinobu"],
            heroesMap["Yachiru"],
          ],
        },
      ],
    };
  }, [supportHeroes]);

  // Helper to render an individual hero cell in the vector table
  const renderHeroCell = (hero: TierListHero | null | undefined, hasRedBorder = false) => {
    if (!hero) {
      return (
        <div className="relative border border-black bg-slate-900/40 min-h-[90px] sm:min-h-[110px]" />
      );
    }

    const isMatch = matchedHeroIds.has(hero.id);
    const imgSrc = hero.image_3x || hero.image_2x || hero.image;

    return (
      <Link
        href={hero.url}
        key={hero.id}
        title={`${hero.name} (${hero.game_name}) - Bấm để xem chi tiết`}
        className={`group relative flex flex-col border border-black bg-[#cf8527] transition-all duration-200 overflow-hidden cursor-pointer select-none ${
          isMatch ? "ring-4 ring-amber-400 z-20 scale-[1.03] shadow-2xl" : "hover:z-10 hover:scale-[1.02]"
        } ${hasRedBorder ? "ring-2 ring-red-600 ring-inset" : ""}`}
      >
        {/* Top Sprite Area */}
        <div className="relative aspect-[72/53] w-full flex items-center justify-center overflow-hidden bg-gradient-to-b from-[#df9330] via-[#c97e1e] to-[#a35e0d]">
          {/* Subtle wooden floor texture */}
          <div
            className="absolute inset-0 opacity-25 pointer-events-none mix-blend-overlay bg-cover bg-bottom"
            style={{ backgroundImage: "url('/assets/card/kpxq_taizi.png')" }}
          />

          {/* Hero Sprite with crisp rendering */}
          <img
            src={imgSrc}
            alt={hero.name}
            className="relative z-10 max-h-full max-w-full object-contain filter drop-shadow-[0_2px_4px_rgba(0,0,0,0.85)] group-hover:scale-105 transition-transform duration-200"
            style={{
              imageRendering: "-webkit-optimize-contrast",
            }}
            loading="lazy"
          />

          {/* Hover highlight overlay */}
          <div className="absolute inset-0 bg-amber-400/10 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none" />
        </div>

        {/* Bottom Name Label (100% Vector HTML Typography - Ultra Sharp) */}
        <div className="bg-white border-t border-black py-1 px-0.5 text-center flex items-center justify-center shrink-0">
          <span className="font-extrabold text-[10px] sm:text-[11px] md:text-xs text-black tracking-tight leading-tight line-clamp-1 truncate w-full px-0.5">
            {hero.name}
          </span>
        </div>
      </Link>
    );
  };

  return (
    <div className="space-y-10">
      {/* ==================================================== */}
      {/* 1. TOP CONTROLS & CLARITY SETTINGS                   */}
      {/* ==================================================== */}
      <div className="rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900/90 via-slate-950/95 to-slate-900/80 p-6 sm:p-8 backdrop-blur-xl shadow-2xl relative overflow-hidden">
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 rounded-full bg-gradient-to-br from-amber-500/10 via-purple-500/10 to-transparent blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 rounded-full bg-gradient-to-tr from-sky-500/10 via-red-500/10 to-transparent blur-3xl pointer-events-none" />

        <div className="relative z-10 space-y-6">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-800/80 pb-6">
            <div>
              <div className="flex flex-wrap items-center gap-2.5 mb-2">
                <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider bg-red-500/10 border border-red-500/30 text-red-400">
                  <span className="w-2 h-2 rounded-full bg-red-400 animate-ping" />
                  Meta Mới Nhất 2026
                </span>
                <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
                  ✨ Chế Độ Hiển Thị Siêu Nét (Ultra-HD)
                </span>
                <span className="px-2.5 py-1 rounded-full text-xs font-mono bg-slate-800 text-slate-300 border border-slate-700">
                  46 Tướng
                </span>
              </div>
              <h2 className="text-xl sm:text-2xl font-black text-white tracking-tight">
                Bảng Đồ Họa Phân Tầng Thực Chiến
              </h2>
            </div>

            {/* Quality View Switcher & Fullscreen Button */}
            <div className="flex flex-wrap items-center gap-3">
              <div className="inline-flex items-center p-1 rounded-2xl bg-slate-950 border border-slate-800">
                <button
                  type="button"
                  onClick={() => setDisplayQuality("vector")}
                  className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all ${
                    displayQuality === "vector"
                      ? "bg-gradient-to-r from-amber-500 to-orange-500 text-slate-950 shadow-lg shadow-amber-500/20 font-black"
                      : "text-slate-400 hover:text-white"
                  }`}
                  title="Chữ và khung viền vẽ vector 100% sắc nét ở mọi độ phân giải"
                >
                  <span>✨</span>
                  <span>Bảng Vector Siêu Nét</span>
                </button>
                <button
                  type="button"
                  onClick={() => setDisplayQuality("image4k")}
                  className={`flex items-center gap-1.5 px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all ${
                    displayQuality === "image4k"
                      ? "bg-gradient-to-r from-amber-500 to-orange-500 text-slate-950 shadow-lg shadow-amber-500/20 font-black"
                      : "text-slate-400 hover:text-white"
                  }`}
                  title="Ảnh đồ họa 4K kích thước lớn"
                >
                  <span>🖼️</span>
                  <span>Ảnh Đồ Họa 4K</span>
                </button>
              </div>

              <button
                type="button"
                onClick={() => {
                  setZoomLevel(1);
                  setLightboxImage({
                    src: "/assets/tier-list/tier_combined_original_4k.png",
                    title: "Bảng Xếp Hạng Tổng Hợp Toàn Bộ (Dealer & Support + Hybrid) - 4096 x 1804 px",
                  });
                }}
                className="inline-flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold bg-slate-800 hover:bg-slate-700 text-amber-300 border border-amber-500/40 shadow-lg transition-all hover:scale-105"
              >
                <span>🔍</span>
                <span>Phóng To 4K (4096px)</span>
              </button>
            </div>
          </div>

          {/* Filter & Search Bar */}
          <div className="grid grid-cols-1 md:grid-cols-12 gap-4 items-center">
            {/* Search Input */}
            <div className="md:col-span-5 relative">
              <span className="absolute inset-y-0 left-0 flex items-center pl-3.5 pointer-events-none text-slate-400">
                🔍
              </span>
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Tìm tên tướng (Tenka, Sasuke, Frieren, Broli...)..."
                className="w-full pl-10 pr-9 py-2.5 rounded-xl bg-slate-950/80 border border-slate-800 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-amber-500 focus:ring-1 focus:ring-amber-500 transition-colors"
              />
              {searchQuery && (
                <button
                  type="button"
                  onClick={() => setSearchQuery("")}
                  className="absolute inset-y-0 right-0 flex items-center pr-3 text-slate-400 hover:text-white"
                >
                  ✕
                </button>
              )}
            </div>

            {/* Role Filter Tabs */}
            <div className="md:col-span-7 flex flex-wrap items-center gap-2">
              <span className="text-xs font-semibold text-slate-400 mr-1 hidden sm:inline">Hiển thị:</span>
              <button
                type="button"
                onClick={() => setSelectedRole("ALL")}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  selectedRole === "ALL"
                    ? "bg-slate-700 text-white border border-slate-600 shadow"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800"
                }`}
              >
                Cả 2 Bảng (46 Tướng)
              </button>
              <button
                type="button"
                onClick={() => setSelectedRole("DEALER")}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  selectedRole === "DEALER"
                    ? "bg-red-500/20 text-red-300 border border-red-500/50 shadow-sm shadow-red-500/20"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800 hover:text-red-300"
                }`}
              >
                ⚔️ Bảng Dealer (19 Tướng)
              </button>
              <button
                type="button"
                onClick={() => setSelectedRole("SUPPORT")}
                className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  selectedRole === "SUPPORT"
                    ? "bg-amber-500/20 text-amber-300 border border-amber-500/50 shadow-sm shadow-amber-500/20"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800 hover:text-amber-300"
                }`}
              >
                🛡️ Bảng Support + Hybrid (27 Tướng)
              </button>
            </div>
          </div>

          {/* Realtime Search Result Info */}
          {q && (
            <div className="pt-2 border-t border-slate-800/60 flex items-center justify-between text-xs text-slate-400">
              <span>
                Tìm thấy <strong className="text-amber-400">{matchedHeroIds.size}</strong> tướng khớp với &ldquo;{searchQuery}&rdquo;.
                Các ô tướng khớp đang được viền nổi bật màu vàng trên bảng.
              </span>
              <button
                type="button"
                onClick={() => setSearchQuery("")}
                className="text-amber-400 hover:underline shrink-0 ml-2"
              >
                Xóa tìm kiếm
              </button>
            </div>
          )}
        </div>
      </div>

      {/* ==================================================== */}
      {/* 2. MAIN BOARDS DISPLAY (VECTOR HD OR IMAGE 4K)       */}
      {/* ==================================================== */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-start">
        {/* ==================================================== */}
        {/* BOARD 1: DEALER                                      */}
        {/* ==================================================== */}
        {(selectedRole === "ALL" || selectedRole === "DEALER") && (
          <div className="rounded-3xl border border-red-500/30 bg-slate-900/70 overflow-hidden shadow-2xl flex flex-col transition-all duration-300 hover:border-red-500/50">
            {/* Header */}
            <div className="bg-gradient-to-r from-red-950 via-slate-900 to-slate-950 px-6 py-4 border-b border-red-500/20 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <span className="text-2xl">⚔️</span>
                <div>
                  <h3 className="font-extrabold text-white text-base tracking-tight">
                    BẢNG DEALER (SÁT THƯƠNG CHỦ LỰC)
                  </h3>
                  <p className="text-xs text-red-300/80">
                    19 Vị Tướng Sát Thương Bùng Nổ & Đột Phá
                  </p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => {
                  setZoomLevel(1);
                  setLightboxImage({
                    src: "/assets/tier-list/tier_dealer_full_4k.png",
                    title: "Bảng Xếp Hạng Dealer (Sát Thương Chủ Lực) - 1736 x 1192 px",
                  });
                }}
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-red-500/20 hover:bg-red-500/30 text-red-300 border border-red-500/30 text-xs font-bold transition-colors shadow"
              >
                <span>Phóng To 4K</span> ↗
              </button>
            </div>

            {/* Board Content */}
            <div className="p-3 sm:p-5 bg-slate-950 flex flex-col items-center justify-center overflow-x-auto">
              {displayQuality === "vector" ? (
                /* -------------------------------------------------- */
                /* VECTOR RECONSTRUCTED TABLE (ULTRA SHARP, NO BLUR)   */
                /* -------------------------------------------------- */
                <div className="w-full min-w-[340px] max-w-[560px] border-2 border-black bg-black shadow-2xl">
                  {/* Table Header */}
                  <div className="bg-[#717171] text-[#ffd428] font-black text-center py-1.5 text-base sm:text-lg tracking-wider border-b-2 border-black font-sans uppercase">
                    DEALER
                  </div>

                  {/* Row 0: UBER & TIER 0 */}
                  <div className="grid grid-cols-6 border-b border-black">
                    {/* Col 0: UBER Header */}
                    <div className="bg-[#d60000] text-white font-black flex items-center justify-center p-1 text-xs sm:text-sm md:text-base border-r border-black tracking-wider">
                      UBER
                    </div>
                    {/* Col 1: CT Tenka (with red border around sprite) */}
                    <div className="border-r border-black">
                      {renderHeroCell(dealerGrid.rows[0].cell1, true)}
                    </div>
                    {/* Col 2: TIER 0 Header */}
                    <div className="bg-[#bf3900] text-white font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center leading-tight">
                      TIER 0
                    </div>
                    {/* Cols 3, 4, 5 */}
                    <div className="border-r border-black">
                      {renderHeroCell(dealerGrid.rows[0].restCells?.[0])}
                    </div>
                    <div className="border-r border-black">
                      {renderHeroCell(dealerGrid.rows[0].restCells?.[1])}
                    </div>
                    <div>{renderHeroCell(dealerGrid.rows[0].restCells?.[2])}</div>
                  </div>

                  {/* Rows 1, 2, 3: TIER 1, TIER 2, TIER 3 */}
                  {dealerGrid.rows.slice(1).map((row, idx) => (
                    <div
                      key={row.tier}
                      className={`grid grid-cols-6 ${
                        idx < dealerGrid.rows.length - 2 ? "border-b border-black" : ""
                      }`}
                    >
                      {/* Tier Header */}
                      <div
                        className={`${row.tierBg} ${row.tierColor} font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center`}
                      >
                        {row.tier}
                      </div>
                      {/* 5 Hero Cells */}
                      {row.cells?.map((cell, cIdx) => (
                        <div
                          key={cIdx}
                          className={cIdx < 4 ? "border-r border-black" : ""}
                        >
                          {renderHeroCell(cell)}
                        </div>
                      ))}
                    </div>
                  ))}
                </div>
              ) : (
                /* -------------------------------------------------- */
                /* 4K ULTRA-HD IMAGE VIEW                             */
                /* -------------------------------------------------- */
                <div
                  onClick={() => {
                    setZoomLevel(1);
                    setLightboxImage({
                      src: "/assets/tier-list/tier_dealer_full_4k.png",
                      title: "Bảng Xếp Hạng Dealer (Sát Thương Chủ Lực) - 1736 x 1192 px",
                    });
                  }}
                  className="relative cursor-pointer group rounded-xl overflow-hidden border-2 border-black hover:border-red-500/60 transition-all duration-300 shadow-2xl max-w-full bg-slate-950"
                >
                  <img
                    src="/assets/tier-list/tier_dealer_full_4k.png"
                    alt="Bảng Xếp Hạng Dealer (Sát Thương)"
                    className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.01]"
                    style={{ imageRendering: "-webkit-optimize-contrast" }}
                    loading="eager"
                  />
                  <div className="absolute inset-0 bg-red-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                    <span className="px-4 py-2 rounded-full bg-slate-950/95 text-red-300 text-xs font-bold shadow-2xl border border-red-500/50 backdrop-blur">
                      🔍 Nhấp để phóng to toàn màn hình (4K)
                    </span>
                  </div>
                </div>
              )}
            </div>

            {/* Quick Hero Links Categorized by Tier */}
            <div className="p-5 sm:p-6 bg-slate-900/40 border-t border-slate-800 space-y-4">
              <div className="flex items-center justify-between border-b border-slate-800/80 pb-2">
                <span className="text-xs font-extrabold text-slate-300 uppercase tracking-wider">
                  Danh Sách Tướng & Hồ Sơ Tra Cứu:
                </span>
                <span className="text-[11px] text-slate-400">Nhấp để xem chi tiết tướng</span>
              </div>

              <div className="space-y-2.5">
                {initialData.groups[0]?.sections.map((sec) => (
                  <div key={sec.tier} className="flex flex-wrap items-center gap-2">
                    <span
                      className={`px-2.5 py-0.5 rounded-lg text-[10px] font-black uppercase tracking-wider shrink-0 ${sec.badge}`}
                    >
                      {sec.tier}
                    </span>
                    <div className="flex flex-wrap gap-1.5 flex-1">
                      {sec.heroes.map((h) => {
                        const isMatch = matchedHeroIds.has(h.id);
                        return (
                          <Link
                            key={h.id}
                            href={h.url}
                            className={`px-2.5 py-1 rounded-lg text-xs font-medium border transition-all ${
                              isMatch
                                ? "bg-red-500 text-white border-red-400 ring-2 ring-red-400 font-bold"
                                : "bg-slate-800/80 hover:bg-red-500/20 text-slate-300 hover:text-red-300 border-slate-700/60"
                            }`}
                          >
                            {h.name}
                          </Link>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* ==================================================== */}
        {/* BOARD 2: SUPPORT + HYBRID                            */}
        {/* ==================================================== */}
        {(selectedRole === "ALL" || selectedRole === "SUPPORT") && (
          <div className="rounded-3xl border border-amber-500/30 bg-slate-900/70 overflow-hidden shadow-2xl flex flex-col transition-all duration-300 hover:border-amber-500/50">
            {/* Header */}
            <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-950 px-6 py-4 border-b border-amber-500/20 flex items-center justify-between">
              <div className="flex items-center gap-3">
                <span className="text-2xl">🛡️</span>
                <div>
                  <h3 className="font-extrabold text-white text-base tracking-tight">
                    BẢNG SUPPORT + HYBRID (HỖ TRỢ & ĐA DỤNG)
                  </h3>
                  <p className="text-xs text-amber-300/80">
                    27 Vị Tướng Hỗ Trợ, Khống Chế & Tanker
                  </p>
                </div>
              </div>
              <button
                type="button"
                onClick={() => {
                  setZoomLevel(1);
                  setLightboxImage({
                    src: "/assets/tier-list/tier_support_full_4k.png",
                    title: "Bảng Xếp Hạng Support + Hybrid (Hỗ Trợ & Đa Dụng) - 1732 x 1776 px",
                  });
                }}
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-amber-500/20 hover:bg-amber-500/30 text-amber-300 border border-amber-500/30 text-xs font-bold transition-colors shadow"
              >
                <span>Phóng To 4K</span> ↗
              </button>
            </div>

            {/* Board Content */}
            <div className="p-3 sm:p-5 bg-slate-950 flex flex-col items-center justify-center overflow-x-auto">
              {displayQuality === "vector" ? (
                /* -------------------------------------------------- */
                /* VECTOR RECONSTRUCTED TABLE (ULTRA SHARP, NO BLUR)   */
                /* -------------------------------------------------- */
                <div className="w-full min-w-[340px] max-w-[560px] border-2 border-black bg-black shadow-2xl">
                  {/* Table Header */}
                  <div className="bg-[#717171] text-[#ffd428] font-black text-center py-1.5 text-base sm:text-lg tracking-wider border-b-2 border-black font-sans uppercase">
                    SUPPORT + HYBRID
                  </div>

                  {/* 6 Rows: UBER, TIER 0, TIER 1, TIER 2, TIER 3, TIER 4 */}
                  {supportGrid.rows.map((row, idx) => (
                    <div
                      key={row.tier}
                      className={`grid grid-cols-6 ${
                        idx < supportGrid.rows.length - 1 ? "border-b border-black" : ""
                      }`}
                    >
                      {/* Tier Header */}
                      <div
                        className={`${row.tierBg} ${row.tierColor} font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center`}
                      >
                        {row.tier}
                      </div>
                      {/* 5 Hero Cells */}
                      {row.cells?.map((cell, cIdx) => (
                        <div
                          key={cIdx}
                          className={cIdx < 4 ? "border-r border-black" : ""}
                        >
                          {renderHeroCell(cell)}
                        </div>
                      ))}
                    </div>
                  ))}
                </div>
              ) : (
                /* -------------------------------------------------- */
                /* 4K ULTRA-HD IMAGE VIEW                             */
                /* -------------------------------------------------- */
                <div
                  onClick={() => {
                    setZoomLevel(1);
                    setLightboxImage({
                      src: "/assets/tier-list/tier_support_full_4k.png",
                      title: "Bảng Xếp Hạng Support + Hybrid (Hỗ Trợ & Đa Dụng) - 1732 x 1776 px",
                    });
                  }}
                  className="relative cursor-pointer group rounded-xl overflow-hidden border-2 border-black hover:border-amber-500/60 transition-all duration-300 shadow-2xl max-w-full bg-slate-950"
                >
                  <img
                    src="/assets/tier-list/tier_support_full_4k.png"
                    alt="Bảng Xếp Hạng Support + Hybrid"
                    className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.01]"
                    style={{ imageRendering: "-webkit-optimize-contrast" }}
                    loading="eager"
                  />
                  <div className="absolute inset-0 bg-amber-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                    <span className="px-4 py-2 rounded-full bg-slate-950/95 text-amber-300 text-xs font-bold shadow-2xl border border-amber-500/50 backdrop-blur">
                      🔍 Nhấp để phóng to toàn màn hình (4K)
                    </span>
                  </div>
                </div>
              )}
            </div>

            {/* Quick Hero Links Categorized by Tier */}
            <div className="p-5 sm:p-6 bg-slate-900/40 border-t border-slate-800 space-y-4">
              <div className="flex items-center justify-between border-b border-slate-800/80 pb-2">
                <span className="text-xs font-extrabold text-slate-300 uppercase tracking-wider">
                  Danh Sách Tướng & Hồ Sơ Tra Cứu:
                </span>
                <span className="text-[11px] text-slate-400">Nhấp để xem chi tiết tướng</span>
              </div>

              <div className="space-y-2.5">
                {initialData.groups[1]?.sections.map((sec) => (
                  <div key={sec.tier} className="flex flex-wrap items-center gap-2">
                    <span
                      className={`px-2.5 py-0.5 rounded-lg text-[10px] font-black uppercase tracking-wider shrink-0 ${sec.badge}`}
                    >
                      {sec.tier}
                    </span>
                    <div className="flex flex-wrap gap-1.5 flex-1">
                      {sec.heroes.map((h) => {
                        const isMatch = matchedHeroIds.has(h.id);
                        return (
                          <Link
                            key={h.id}
                            href={h.url}
                            className={`px-2.5 py-1 rounded-lg text-xs font-medium border transition-all ${
                              isMatch
                                ? "bg-amber-500 text-slate-950 border-amber-400 ring-2 ring-amber-400 font-bold"
                                : "bg-slate-800/80 hover:bg-amber-500/20 text-slate-300 hover:text-amber-300 border-slate-700/60"
                            }`}
                          >
                            {h.name}
                          </Link>
                        );
                      })}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}
      </div>

      {/* ==================================================== */}
      {/* 3. LIGHTBOX ZOOM MODAL (4K ULTRA-HD VIEWER)          */}
      {/* ==================================================== */}
      {lightboxImage && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-6 bg-black/95 backdrop-blur-md animate-fade-in"
          onClick={() => setLightboxImage(null)}
        >
          <div
            className="relative max-w-7xl max-h-[95vh] flex flex-col items-center space-y-3 w-full"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Modal Bar */}
            <div className="flex flex-wrap items-center justify-between w-full px-2 text-white gap-2">
              <div className="flex items-center gap-2">
                <span className="text-xl">🖼️</span>
                <h4 className="font-bold text-sm sm:text-base">{lightboxImage.title}</h4>
                <span className="px-2 py-0.5 rounded bg-amber-500/20 text-amber-400 text-xs font-mono font-semibold">
                  Độ phân giải 4K
                </span>
              </div>

              {/* Controls */}
              <div className="flex items-center gap-2">
                <button
                  type="button"
                  onClick={() => setZoomLevel((z) => Math.max(0.75, z - 0.25))}
                  className="px-2.5 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-bold text-slate-300"
                  title="Thu nhỏ"
                >
                  -
                </button>
                <span className="text-xs font-mono text-slate-400 px-1">
                  {Math.round(zoomLevel * 100)}%
                </span>
                <button
                  type="button"
                  onClick={() => setZoomLevel((z) => Math.min(2.5, z + 0.25))}
                  className="px-2.5 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-bold text-slate-300"
                  title="Phóng to"
                >
                  +
                </button>
                <button
                  type="button"
                  onClick={() => setZoomLevel(1)}
                  className="px-2.5 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-semibold text-slate-300"
                >
                  Chuẩn (100%)
                </button>
                <a
                  href={lightboxImage.src}
                  download="SAHHT_TierList_4K.png"
                  className="px-3.5 py-1 rounded-lg bg-amber-500 hover:bg-amber-400 text-slate-950 text-xs font-bold transition-colors"
                >
                  Tải Ảnh 4K ↓
                </a>
                <button
                  type="button"
                  onClick={() => setLightboxImage(null)}
                  className="px-3.5 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-bold text-slate-300 transition-colors shadow ml-1"
                >
                  ✕ Đóng
                </button>
              </div>
            </div>

            {/* Modal Image Display */}
            <div className="rounded-2xl overflow-auto border border-slate-700 bg-slate-950 shadow-2xl flex items-center justify-center p-2 max-h-[84vh] w-full">
              <img
                src={lightboxImage.src}
                alt={lightboxImage.title}
                style={{
                  transform: `scale(${zoomLevel})`,
                  transformOrigin: "center center",
                  transition: "transform 0.15s ease-out",
                  imageRendering: "-webkit-optimize-contrast",
                }}
                className="max-h-[80vh] w-auto max-w-full object-contain rounded-lg"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
