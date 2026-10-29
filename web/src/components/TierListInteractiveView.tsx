"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import { TierListData } from "@/lib/data";

interface TierListInteractiveViewProps {
  initialData: TierListData;
}

export default function TierListInteractiveView({ initialData }: TierListInteractiveViewProps) {
  const [selectedRole, setSelectedRole] = useState<"ALL" | "DEALER" | "SUPPORT">("ALL");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [lightboxImage, setLightboxImage] = useState<{ src: string; title: string } | null>(null);

  // Search filter to highlight or find heroes
  const q = searchQuery.toLowerCase().trim();

  const dealerHeroes = initialData.groups[0]?.heroes || [];
  const supportHeroes = initialData.groups[1]?.heroes || [];

  const matchedDealerHeroes = useMemo(() => {
    if (!q) return dealerHeroes;
    return dealerHeroes.filter(
      (h) =>
        h.name.toLowerCase().includes(q) ||
        h.game_name.toLowerCase().includes(q) ||
        h.id.includes(q) ||
        h.tier.toLowerCase().includes(q)
    );
  }, [dealerHeroes, q]);

  const matchedSupportHeroes = useMemo(() => {
    if (!q) return supportHeroes;
    return supportHeroes.filter(
      (h) =>
        h.name.toLowerCase().includes(q) ||
        h.game_name.toLowerCase().includes(q) ||
        h.id.includes(q) ||
        h.tier.toLowerCase().includes(q)
    );
  }, [supportHeroes, q]);

  return (
    <div className="space-y-10">
      {/* ==================================================== */}
      {/* 1. CONTROLS & FILTER BAR                             */}
      {/* ==================================================== */}
      <div className="rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900/90 via-slate-950/95 to-slate-900/80 p-6 sm:p-8 backdrop-blur-xl shadow-2xl relative overflow-hidden">
        {/* Subtle decorative background gradient */}
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 rounded-full bg-gradient-to-br from-amber-500/10 via-purple-500/10 to-transparent blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 rounded-full bg-gradient-to-tr from-sky-500/10 via-red-500/10 to-transparent blur-3xl pointer-events-none" />

        <div className="relative z-10 space-y-6">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-800/80 pb-6">
            <div>
              <div className="flex flex-wrap items-center gap-2.5 mb-2">
                <span className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider bg-red-500/10 border border-red-500/30 text-red-400">
                  <span className="w-2 h-2 rounded-full bg-red-400 animate-ping" />
                  Meta Thực Chiến 2026
                </span>
                <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-slate-800 border border-slate-700 text-slate-300">
                  Phiên bản: {initialData.version}
                </span>
                <span className="px-2.5 py-1 rounded-full text-xs font-semibold bg-emerald-500/10 border border-emerald-500/30 text-emerald-400">
                  46 Tướng Xếp Hạng
                </span>
              </div>
              <h2 className="text-xl sm:text-2xl font-black text-white tracking-tight">
                Bảng Đồ Họa Phân Tầng Thực Chiến
              </h2>
            </div>

            {/* Quick Fullscreen Button */}
            <button
              type="button"
              onClick={() =>
                setLightboxImage({
                  src: initialData.original_graphic,
                  title: "Bảng Xếp Hạng Tổng Hợp Toàn Bộ (Dealer & Support + Hybrid)",
                })
              }
              className="inline-flex items-center gap-2 px-5 py-2.5 rounded-2xl text-xs font-bold bg-gradient-to-r from-amber-500 to-orange-500 text-slate-950 hover:from-amber-400 hover:to-orange-400 shadow-lg shadow-amber-500/20 transition-all hover:scale-105 self-start md:self-auto shrink-0"
            >
              <span>🔍</span>
              <span>Phóng To Cả 2 Bảng (HD)</span>
            </button>
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
                placeholder="Tìm tên tướng (Sasuke, Tenka, Frieren, Broli...)..."
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
                Tìm thấy{" "}
                <strong className="text-amber-400">
                  {matchedDealerHeroes.length + matchedSupportHeroes.length}
                </strong>{" "}
                tướng khớp với &ldquo;{searchQuery}&rdquo;:{" "}
                <span className="text-slate-200">
                  {[...matchedDealerHeroes, ...matchedSupportHeroes]
                    .map((h) => `${h.name} (${h.tier})`)
                    .join(", ")}
                </span>
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
      {/* 2. AUTHENTIC GRAPHICAL BOARDS DISPLAY                */}
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
                onClick={() =>
                  setLightboxImage({
                    src: "/assets/tier-list/tier_dealer_full@2x.png",
                    title: "Bảng Xếp Hạng Dealer (Sát Thương Chủ Lực)",
                  })
                }
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-red-500/20 hover:bg-red-500/30 text-red-300 border border-red-500/30 text-xs font-bold transition-colors"
              >
                <span>Phóng To</span> ↗
              </button>
            </div>

            {/* Graphic Board Image */}
            <div className="p-4 sm:p-6 bg-slate-950 flex flex-col items-center justify-center">
              <div
                onClick={() =>
                  setLightboxImage({
                    src: "/assets/tier-list/tier_dealer_full@2x.png",
                    title: "Bảng Xếp Hạng Dealer (Sát Thương Chủ Lực)",
                  })
                }
                className="relative cursor-pointer group rounded-2xl overflow-hidden border border-slate-800 hover:border-red-500/60 transition-all duration-300 shadow-2xl max-w-full bg-slate-950"
              >
                <img
                  src="/assets/tier-list/tier_dealer_full@2x.png"
                  alt="Bảng Xếp Hạng Dealer (Sát Thương)"
                  className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.01]"
                  loading="eager"
                />
                <div className="absolute inset-0 bg-red-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                  <span className="px-4 py-2 rounded-full bg-slate-950/95 text-red-300 text-xs font-bold shadow-2xl border border-red-500/50 backdrop-blur">
                    🔍 Nhấp để phóng to toàn màn hình
                  </span>
                </div>
              </div>
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
                        const isMatch = q && h.name.toLowerCase().includes(q);
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
                onClick={() =>
                  setLightboxImage({
                    src: "/assets/tier-list/tier_support_full@2x.png",
                    title: "Bảng Xếp Hạng Support + Hybrid (Hỗ Trợ & Đa Dụng)",
                  })
                }
                className="inline-flex items-center gap-1 px-3 py-1.5 rounded-xl bg-amber-500/20 hover:bg-amber-500/30 text-amber-300 border border-amber-500/30 text-xs font-bold transition-colors"
              >
                <span>Phóng To</span> ↗
              </button>
            </div>

            {/* Graphic Board Image */}
            <div className="p-4 sm:p-6 bg-slate-950 flex flex-col items-center justify-center">
              <div
                onClick={() =>
                  setLightboxImage({
                    src: "/assets/tier-list/tier_support_full@2x.png",
                    title: "Bảng Xếp Hạng Support + Hybrid (Hỗ Trợ & Đa Dụng)",
                  })
                }
                className="relative cursor-pointer group rounded-2xl overflow-hidden border border-slate-800 hover:border-amber-500/60 transition-all duration-300 shadow-2xl max-w-full bg-slate-950"
              >
                <img
                  src="/assets/tier-list/tier_support_full@2x.png"
                  alt="Bảng Xếp Hạng Support + Hybrid"
                  className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.01]"
                  loading="eager"
                />
                <div className="absolute inset-0 bg-amber-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                  <span className="px-4 py-2 rounded-full bg-slate-950/95 text-amber-300 text-xs font-bold shadow-2xl border border-amber-500/50 backdrop-blur">
                    🔍 Nhấp để phóng to toàn màn hình
                  </span>
                </div>
              </div>
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
                        const isMatch = q && h.name.toLowerCase().includes(q);
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
      {/* 3. LIGHTBOX ZOOM MODAL                               */}
      {/* ==================================================== */}
      {lightboxImage && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/90 backdrop-blur-md animate-fade-in"
          onClick={() => setLightboxImage(null)}
        >
          <div
            className="relative max-w-6xl max-h-[92vh] flex flex-col items-center space-y-4 w-full"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between w-full px-2 text-white">
              <div className="flex items-center gap-2">
                <span className="text-xl">🖼️</span>
                <h4 className="font-bold text-sm sm:text-base">{lightboxImage.title}</h4>
              </div>
              <button
                type="button"
                onClick={() => setLightboxImage(null)}
                className="px-3.5 py-1.5 rounded-xl bg-slate-800 hover:bg-slate-700 text-xs font-bold text-slate-300 transition-colors shadow"
              >
                ✕ Đóng (ESC)
              </button>
            </div>
            <div className="rounded-2xl overflow-hidden border border-slate-700 bg-slate-950 shadow-2xl flex items-center justify-center p-2">
              <img
                src={lightboxImage.src}
                alt={lightboxImage.title}
                className="max-h-[82vh] w-auto max-w-full object-contain rounded-lg"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
