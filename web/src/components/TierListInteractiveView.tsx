"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import Image from "next/image";
import { TierListData, TierListHero, TierListGroup } from "@/lib/data";

interface TierListInteractiveViewProps {
  initialData: TierListData;
}

export default function TierListInteractiveView({ initialData }: TierListInteractiveViewProps) {
  const [selectedRole, setSelectedRole] = useState<"ALL" | "DEALER" | "SUPPORT">("ALL");
  const [selectedTier, setSelectedTier] = useState<string>("ALL");
  const [searchQuery, setSearchQuery] = useState<string>("");
  const [viewMode, setViewMode] = useState<"grid" | "infographic">("grid");
  const [previewHero, setPreviewHero] = useState<TierListHero | null>(null);
  const [lightboxImage, setLightboxImage] = useState<{ src: string; title: string } | null>(null);

  // Filter heroes
  const filteredGroups = useMemo(() => {
    const q = searchQuery.toLowerCase().trim();

    return initialData.groups
      .filter((g) => {
        if (selectedRole === "ALL") return true;
        return g.role === selectedRole;
      })
      .map((group) => {
        const sections = group.sections
          .filter((sec) => {
            if (selectedTier === "ALL") return true;
            return sec.tier === selectedTier;
          })
          .map((sec) => {
            const heroes = sec.heroes.filter((h) => {
              if (!q) return true;
              return (
                h.name.toLowerCase().includes(q) ||
                h.game_name.toLowerCase().includes(q) ||
                h.career_name.toLowerCase().includes(q) ||
                h.id.includes(q) ||
                (h.notes && h.notes.toLowerCase().includes(q))
              );
            });
            return { ...sec, heroes };
          })
          .filter((sec) => sec.heroes.length > 0);

        const totalFilteredHeroes = sections.reduce((acc, s) => acc + s.heroes.length, 0);

        return {
          ...group,
          sections,
          totalFilteredHeroes,
        };
      })
      .filter((g) => g.sections.length > 0);
  }, [initialData, selectedRole, selectedTier, searchQuery]);

  const totalMatches = useMemo(() => {
    return filteredGroups.reduce((acc, g) => acc + g.totalFilteredHeroes, 0);
  }, [filteredGroups]);

  const allTiersList = ["UBER", "TIER 0", "TIER 1", "TIER 2", "TIER 3", "TIER 4"];

  return (
    <div className="space-y-10">
      {/* ==================================================== */}
      {/* 1. TOP CONTROLS & META STATS BANNER                  */}
      {/* ==================================================== */}
      <div className="rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900/90 via-slate-950/95 to-slate-900/80 p-6 sm:p-8 backdrop-blur-xl shadow-2xl relative overflow-hidden">
        {/* Subtle decorative background gradient */}
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-80 h-80 rounded-full bg-gradient-to-br from-amber-500/10 via-purple-500/10 to-transparent blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-80 h-80 rounded-full bg-gradient-to-tr from-sky-500/10 via-red-500/10 to-transparent blur-3xl pointer-events-none" />

        <div className="relative z-10 space-y-6">
          {/* Header Row */}
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
                Bộ Lọc & Tìm Kiếm Chiến Lực
              </h2>
            </div>

            {/* View Mode Toggle */}
            <div className="inline-flex items-center p-1 rounded-2xl bg-slate-950 border border-slate-800 self-start md:self-auto">
              <button
                type="button"
                onClick={() => setViewMode("grid")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  viewMode === "grid"
                    ? "bg-gradient-to-r from-amber-500 to-orange-500 text-slate-950 shadow-lg shadow-amber-500/20"
                    : "text-slate-400 hover:text-white"
                }`}
              >
                <span>🎴</span>
                <span>Lưới Thẻ Tương Tác</span>
              </button>
              <button
                type="button"
                onClick={() => setViewMode("infographic")}
                className={`flex items-center gap-2 px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                  viewMode === "infographic"
                    ? "bg-gradient-to-r from-amber-500 to-orange-500 text-slate-950 shadow-lg shadow-amber-500/20"
                    : "text-slate-400 hover:text-white"
                }`}
              >
                <span>🖼️</span>
                <span>Bảng Đồ Họa Gốc</span>
              </button>
            </div>
          </div>

          {/* Search & Filter Bar */}
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
                placeholder="Tìm tên tướng (Sasuke, Tenka, Vegeta, Frieren...)..."
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
              <span className="text-xs font-semibold text-slate-400 mr-1 hidden sm:inline">Vai trò:</span>
              <button
                type="button"
                onClick={() => setSelectedRole("ALL")}
                className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-colors ${
                  selectedRole === "ALL"
                    ? "bg-slate-700 text-white border border-slate-600 shadow"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800"
                }`}
              >
                Tất Cả ({initialData.stats.total_ranked_heroes})
              </button>
              <button
                type="button"
                onClick={() => setSelectedRole("DEALER")}
                className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-colors ${
                  selectedRole === "DEALER"
                    ? "bg-red-500/20 text-red-300 border border-red-500/40 shadow-sm shadow-red-500/20"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800 hover:text-red-300"
                }`}
              >
                ⚔️ Sát Thương - Dealer ({initialData.stats.dealer_count})
              </button>
              <button
                type="button"
                onClick={() => setSelectedRole("SUPPORT")}
                className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-colors ${
                  selectedRole === "SUPPORT"
                    ? "bg-amber-500/20 text-amber-300 border border-amber-500/40 shadow-sm shadow-amber-500/20"
                    : "bg-slate-900/60 text-slate-400 border border-slate-800 hover:bg-slate-800 hover:text-amber-300"
                }`}
              >
                🛡️ Hỗ Trợ - Support & Hybrid ({initialData.stats.support_count})
              </button>
            </div>
          </div>

          {/* Tier Buttons Bar */}
          <div className="flex flex-wrap items-center gap-2 pt-2 border-t border-slate-800/60">
            <span className="text-xs font-semibold text-slate-400 mr-1">Bậc Sức Mạnh:</span>
            <button
              type="button"
              onClick={() => setSelectedTier("ALL")}
              className={`px-3 py-1 rounded-lg text-xs font-bold transition-colors ${
                selectedTier === "ALL"
                  ? "bg-slate-200 text-slate-900 font-extrabold"
                  : "bg-slate-900 border border-slate-800 text-slate-400 hover:text-white"
              }`}
            >
              Tất Cả Tiers
            </button>
            {allTiersList.map((tier) => {
              const active = selectedTier === tier;
              const colorClasses = {
                UBER: active ? "bg-red-600 text-white" : "border-red-500/30 text-red-400 hover:bg-red-500/10",
                "TIER 0": active ? "bg-amber-600 text-white" : "border-amber-500/30 text-amber-400 hover:bg-amber-500/10",
                "TIER 1": active ? "bg-orange-600 text-white" : "border-orange-500/30 text-orange-400 hover:bg-orange-500/10",
                "TIER 2": active ? "bg-yellow-500 text-slate-950 font-black" : "border-yellow-500/30 text-yellow-400 hover:bg-yellow-500/10",
                "TIER 3": active ? "bg-emerald-600 text-white" : "border-emerald-500/30 text-emerald-400 hover:bg-emerald-500/10",
                "TIER 4": active ? "bg-sky-600 text-white" : "border-sky-500/30 text-sky-400 hover:bg-sky-500/10",
              }[tier];

              return (
                <button
                  key={tier}
                  type="button"
                  onClick={() => setSelectedTier(tier)}
                  className={`px-3 py-1 rounded-lg text-xs font-semibold border transition-all ${colorClasses}`}
                >
                  {tier}
                </button>
              );
            })}

            {(searchQuery || selectedRole !== "ALL" || selectedTier !== "ALL") && (
              <button
                type="button"
                onClick={() => {
                  setSearchQuery("");
                  setSelectedRole("ALL");
                  setSelectedTier("ALL");
                }}
                className="ml-auto text-xs text-amber-400 hover:underline flex items-center gap-1"
              >
                <span>↺</span> Đặt lại bộ lọc
              </button>
            )}
          </div>
        </div>
      </div>

      {/* ==================================================== */}
      {/* 2. INFOGRAPHIC VIEW MODE                             */}
      {/* ==================================================== */}
      {viewMode === "infographic" && (
        <div className="space-y-8 animate-fade-in">
          {/* Infographic Banner Notice */}
          <div className="rounded-2xl border border-amber-500/20 bg-amber-950/20 p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4 backdrop-blur">
            <div className="flex items-start gap-3">
              <span className="text-2xl">🏆</span>
              <div>
                <h3 className="font-bold text-amber-300 text-sm sm:text-base">
                  Bảng Đồ Họa Phân Tầng Chính Thức (Official Graphic Boards)
                </h3>
                <p className="text-xs text-amber-200/80 mt-0.5">
                  Hình ảnh trực quan tổng hợp nguyên bản từ ban biên tập. Nhấp vào ảnh để phóng to, hoặc nhấp vào thẻ tướng để xem chi tiết.
                </p>
              </div>
            </div>
            <button
              type="button"
              onClick={() =>
                setLightboxImage({
                  src: initialData.original_graphic,
                  title: "Bảng Xếp Hạng Đầy Đủ (Dealer & Support + Hybrid)",
                })
              }
              className="inline-flex items-center justify-center gap-2 px-4 py-2 rounded-xl text-xs font-bold bg-amber-500 text-slate-950 hover:bg-amber-400 transition-colors shrink-0 shadow-lg"
            >
              <span>🔍</span>
              <span>Phóng To Toàn Bảng</span>
            </button>
          </div>

          {/* Side by side boards (or stacked on mobile) */}
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
            {/* Dealer Board */}
            {(selectedRole === "ALL" || selectedRole === "DEALER") && (
              <div className="rounded-3xl border border-red-500/30 bg-slate-900/60 overflow-hidden shadow-2xl flex flex-col">
                <div className="bg-gradient-to-r from-red-950 via-slate-900 to-slate-950 px-6 py-4 border-b border-red-500/20 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-xl">⚔️</span>
                    <div>
                      <h3 className="font-extrabold text-white text-base">BẢNG DEALER (SÁT THƯƠNG)</h3>
                      <p className="text-xs text-red-300/80">19 Tướng Sát Thương Chủ Lực & Đột Phá</p>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() =>
                      setLightboxImage({
                        src: "/assets/tier-list/tier_dealer_full.png",
                        title: "Bảng Xếp Hạng Dealer (Sát Thương)",
                      })
                    }
                    className="text-xs font-semibold text-red-400 hover:text-red-300 hover:underline flex items-center gap-1"
                  >
                    <span>Phóng to</span> ↗
                  </button>
                </div>

                <div className="p-4 sm:p-6 bg-slate-950/70 flex-1 flex flex-col items-center justify-center">
                  <div
                    onClick={() =>
                      setLightboxImage({
                        src: "/assets/tier-list/tier_dealer_full@2x.png",
                        title: "Bảng Xếp Hạng Dealer (Sát Thương Chủ Lực)",
                      })
                    }
                    className="relative cursor-pointer group rounded-xl overflow-hidden border border-slate-800 hover:border-red-500/50 transition-all shadow-xl max-w-full"
                  >
                    <img
                      src="/assets/tier-list/tier_dealer_full@2x.png"
                      alt="Tier List Dealer"
                      className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.02]"
                    />
                    <div className="absolute inset-0 bg-red-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <span className="px-3 py-1.5 rounded-full bg-slate-950/90 text-red-300 text-xs font-bold shadow-lg border border-red-500/40">
                        🔍 Nhấp để phóng to
                      </span>
                    </div>
                  </div>
                </div>

                {/* Quick Hero List Pills */}
                <div className="px-6 py-4 bg-slate-900/40 border-t border-slate-800 text-xs text-slate-400">
                  <span className="font-bold text-slate-300 mr-2">Tướng trong bảng:</span>
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {initialData.groups[0]?.heroes.map((h) => (
                      <Link
                        key={h.id}
                        href={h.url}
                        className="px-2 py-0.5 rounded-md bg-slate-800 hover:bg-red-500/20 hover:text-red-300 border border-slate-700/60 transition-colors"
                      >
                        {h.name}
                      </Link>
                    ))}
                  </div>
                </div>
              </div>
            )}

            {/* Support Board */}
            {(selectedRole === "ALL" || selectedRole === "SUPPORT") && (
              <div className="rounded-3xl border border-amber-500/30 bg-slate-900/60 overflow-hidden shadow-2xl flex flex-col">
                <div className="bg-gradient-to-r from-amber-950 via-slate-900 to-slate-950 px-6 py-4 border-b border-amber-500/20 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <span className="text-xl">🛡️</span>
                    <div>
                      <h3 className="font-extrabold text-white text-base">BẢNG SUPPORT + HYBRID</h3>
                      <p className="text-xs text-amber-300/80">27 Tướng Hỗ Trợ, Đa Năng & Khống Chế</p>
                    </div>
                  </div>
                  <button
                    type="button"
                    onClick={() =>
                      setLightboxImage({
                        src: "/assets/tier-list/tier_support_full.png",
                        title: "Bảng Xếp Hạng Support & Hybrid",
                      })
                    }
                    className="text-xs font-semibold text-amber-400 hover:text-amber-300 hover:underline flex items-center gap-1"
                  >
                    <span>Phóng to</span> ↗
                  </button>
                </div>

                <div className="p-4 sm:p-6 bg-slate-950/70 flex-1 flex flex-col items-center justify-center">
                  <div
                    onClick={() =>
                      setLightboxImage({
                        src: "/assets/tier-list/tier_support_full@2x.png",
                        title: "Bảng Xếp Hạng Support + Hybrid (Hỗ Trợ & Đa Dụng)",
                      })
                    }
                    className="relative cursor-pointer group rounded-xl overflow-hidden border border-slate-800 hover:border-amber-500/50 transition-all shadow-xl max-w-full"
                  >
                    <img
                      src="/assets/tier-list/tier_support_full@2x.png"
                      alt="Tier List Support + Hybrid"
                      className="w-full h-auto object-contain transition-transform duration-300 group-hover:scale-[1.02]"
                    />
                    <div className="absolute inset-0 bg-amber-950/20 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                      <span className="px-3 py-1.5 rounded-full bg-slate-950/90 text-amber-300 text-xs font-bold shadow-lg border border-amber-500/40">
                        🔍 Nhấp để phóng to
                      </span>
                    </div>
                  </div>
                </div>

                {/* Quick Hero List Pills */}
                <div className="px-6 py-4 bg-slate-900/40 border-t border-slate-800 text-xs text-slate-400">
                  <span className="font-bold text-slate-300 mr-2">Tướng trong bảng:</span>
                  <div className="flex flex-wrap gap-1.5 mt-2">
                    {initialData.groups[1]?.heroes.map((h) => (
                      <Link
                        key={h.id}
                        href={h.url}
                        className="px-2 py-0.5 rounded-md bg-slate-800 hover:bg-amber-500/20 hover:text-amber-300 border border-slate-700/60 transition-colors"
                      >
                        {h.name}
                      </Link>
                    ))}
                  </div>
                </div>
              </div>
            )}
          </div>
        </div>
      )}

      {/* ==================================================== */}
      {/* 3. INTERACTIVE CARD GRID VIEW MODE                   */}
      {/* ==================================================== */}
      {viewMode === "grid" && (
        <div className="space-y-14 animate-fade-in">
          {totalMatches === 0 ? (
            <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-12 text-center space-y-4">
              <span className="text-4xl">🔍</span>
              <h3 className="font-bold text-white text-lg">Không tìm thấy vị tướng nào</h3>
              <p className="text-xs text-slate-400 max-w-md mx-auto">
                Không có kết quả nào khớp với từ khóa &ldquo;{searchQuery}&rdquo; trong phân loại đã chọn.
              </p>
              <button
                type="button"
                onClick={() => {
                  setSearchQuery("");
                  setSelectedRole("ALL");
                  setSelectedTier("ALL");
                }}
                className="px-4 py-2 rounded-xl text-xs font-semibold bg-amber-500 text-slate-950 hover:bg-amber-400"
              >
                Đặt lại bộ lọc
              </button>
            </div>
          ) : (
            filteredGroups.map((group) => (
              <section key={group.role} className="space-y-8">
                {/* Group Title Banner */}
                <div className="rounded-2xl border border-slate-800 bg-gradient-to-r from-slate-900 via-slate-950 to-slate-900 p-6 backdrop-blur">
                  <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
                    <div className="flex items-center gap-3">
                      <span className="text-3xl">
                        {group.role === "DEALER" ? "⚔️" : "🛡️"}
                      </span>
                      <div>
                        <div className="flex items-center gap-2">
                          <h2 className="text-xl sm:text-2xl font-black text-white tracking-tight">
                            {group.title}
                          </h2>
                          <span
                            className={`px-2.5 py-0.5 rounded-full text-xs font-bold border ${
                              group.role === "DEALER"
                                ? "bg-red-500/20 text-red-300 border-red-500/30"
                                : "bg-amber-500/20 text-amber-300 border-amber-500/30"
                            }`}
                          >
                            {group.totalFilteredHeroes} tướng
                          </span>
                        </div>
                        <p className="text-xs sm:text-sm text-slate-400 mt-1 max-w-2xl">
                          {group.description}
                        </p>
                      </div>
                    </div>

                    <button
                      type="button"
                      onClick={() =>
                        setLightboxImage({
                          src: group.infographic_image_2x,
                          title: group.title,
                        })
                      }
                      className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-xs font-semibold bg-slate-800 hover:bg-slate-700 text-slate-300 border border-slate-700 self-start sm:self-auto transition-colors"
                    >
                      <span>Xem Bảng Infographic</span> ↗
                    </button>
                  </div>
                </div>

                {/* Tier Sections */}
                <div className="space-y-8">
                  {group.sections.map((sec) => (
                    <div
                      key={sec.tier}
                      className={`rounded-3xl border ${sec.border} bg-gradient-to-b ${sec.bg} p-5 sm:p-7 backdrop-blur-xl transition-all duration-300 shadow-xl`}
                    >
                      {/* Section Header */}
                      <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 border-b border-slate-800/80 pb-4 mb-6">
                        <div className="flex items-center gap-3">
                          <span className={`px-3.5 py-1 rounded-xl text-xs font-black uppercase tracking-wider border shadow-sm ${sec.badge}`}>
                            {sec.tier}
                          </span>
                          <h3 className="text-lg font-bold text-white tracking-tight">
                            {sec.title}
                          </h3>
                        </div>
                        <p className="text-xs text-slate-400 italic max-w-lg sm:text-right">
                          {sec.description}
                        </p>
                      </div>

                      {/* Heroes Grid */}
                      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4 sm:gap-5">
                        {sec.heroes.map((hero) => (
                          <div
                            key={hero.id}
                            className="group relative flex flex-col rounded-2xl border border-slate-800/80 bg-slate-950/80 hover:border-amber-500/50 hover:bg-slate-900/90 transition-all duration-300 overflow-hidden shadow-lg hover:shadow-2xl hover:-translate-y-1"
                          >
                            {/* Card Media Section */}
                            <div className="relative aspect-[72/69] w-full bg-slate-950 overflow-hidden flex items-center justify-center p-1.5 border-b border-slate-800/60">
                              {/* Background spotlight */}
                              <div className="absolute inset-0 bg-radial from-slate-800/40 via-transparent to-transparent opacity-50 group-hover:opacity-80 transition-opacity" />

                              {/* Hero Crop Image */}
                              <img
                                src={hero.image_2x || hero.image}
                                alt={hero.name}
                                className="relative z-10 w-full h-full object-contain filter drop-shadow-[0_4px_8px_rgba(0,0,0,0.8)] transition-transform duration-300 group-hover:scale-105"
                                loading="lazy"
                              />

                              {/* Chuyển Thế / Biến Thể Badge */}
                              {hero.is_world && (
                                <span className="absolute top-1.5 left-1.5 z-20 px-1.5 py-0.5 rounded text-[9px] font-bold bg-purple-600/90 text-purple-100 border border-purple-400/50 shadow">
                                  CT
                                </span>
                              )}

                              {/* Quick Preview Hover Button */}
                              <button
                                type="button"
                                onClick={() => setPreviewHero(hero)}
                                className="absolute bottom-1.5 right-1.5 z-20 opacity-0 group-hover:opacity-100 transition-opacity px-2 py-0.5 rounded text-[10px] font-semibold bg-slate-900/90 text-amber-300 border border-amber-500/40 backdrop-blur shadow"
                              >
                                Xem Nhanh
                              </button>
                            </div>

                            {/* Card Content Section */}
                            <div className="p-3.5 flex flex-col flex-1 justify-between space-y-2">
                              <div>
                                <div className="flex items-center justify-between gap-1 mb-1">
                                  <span className="text-[10px] font-mono text-slate-400 font-semibold px-1.5 py-0.5 rounded bg-slate-900 border border-slate-800">
                                    {hero.career_name}
                                  </span>
                                  <span className="text-[10px] font-mono text-slate-500">
                                    ID: {hero.id}
                                  </span>
                                </div>
                                <h4 className="font-extrabold text-sm text-white group-hover:text-amber-300 transition-colors line-clamp-1">
                                  {hero.name}
                                </h4>
                                {hero.game_name !== hero.name && (
                                  <p className="text-[11px] text-slate-400 italic line-clamp-1">
                                    {hero.game_name}
                                  </p>
                                )}
                              </div>

                              {/* Tactical Combat Note */}
                              {hero.notes && (
                                <p className="text-[11px] text-slate-300/80 leading-relaxed line-clamp-2 pt-1 border-t border-slate-900">
                                  {hero.notes}
                                </p>
                              )}

                              {/* Link to hero detail page */}
                              <Link
                                href={hero.url}
                                className="mt-2 inline-flex items-center justify-center gap-1 w-full py-1.5 px-2 rounded-xl text-xs font-semibold bg-slate-900 hover:bg-amber-500 hover:text-slate-950 text-slate-300 border border-slate-800 transition-colors"
                              >
                                <span>Chi tiết tướng</span>
                                <span>→</span>
                              </Link>
                            </div>
                          </div>
                        ))}
                      </div>
                    </div>
                  ))}
                </div>
              </section>
            ))
          )}
        </div>
      )}

      {/* ==================================================== */}
      {/* 4. META SYNERGY & TEAM BUILDING ADVICE               */}
      {/* ==================================================== */}
      <div className="rounded-3xl border border-slate-800 bg-slate-900/40 p-6 sm:p-8 backdrop-blur space-y-6">
        <div className="flex items-center gap-3 border-b border-slate-800 pb-4">
          <span className="text-2xl">💡</span>
          <div>
            <h3 className="text-lg font-bold text-white">
              Cẩm Nang Xây Dựng Đội Hình Theo Tier List
            </h3>
            <p className="text-xs text-slate-400">
              Nguyên lý phối hợp tối ưu hóa lực chiến PvP Đấu Trường & Vượt Ải PvE
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-5">
          <div className="rounded-2xl border border-slate-800 bg-slate-950/60 p-4 space-y-2">
            <div className="flex items-center gap-2 text-red-400 font-bold text-sm">
              <span>⚔️</span>
              <span>1. Xác Định 1 Dealer Chủ Lực</span>
            </div>
            <p className="text-xs text-slate-300 leading-relaxed">
              Chọn 1 tướng từ bậc <strong>UBER hoặc Tier 0</strong> (như CT Tenka, CT Sasuke, CT Shamrock, Vegeta Fusion) làm trung tâm dồn tài nguyên, nâng cấp sao, thức tỉnh và kích hoạt bộ trang bị mạnh nhất.
            </p>
          </div>

          <div className="rounded-2xl border border-slate-800 bg-slate-950/60 p-4 space-y-2">
            <div className="flex items-center gap-2 text-amber-400 font-bold text-sm">
              <span>🛡️</span>
              <span>2. Ghép 2-3 Hỗ Trợ Đa Dụng</span>
            </div>
            <p className="text-xs text-slate-300 leading-relaxed">
              Kết hợp các hỗ trợ hàng đầu như <strong>CT Nagato</strong> (Hồi sinh), <strong>CT Trunks</strong> (Xóa bùa), <strong>CT Broli</strong> (Tanker hút sát thương), <strong>CT Elaina</strong> (Khống chế).
            </p>
          </div>

          <div className="rounded-2xl border border-slate-800 bg-slate-950/60 p-4 space-y-2">
            <div className="flex items-center gap-2 text-purple-400 font-bold text-sm">
              <span>🔮</span>
              <span>3. Kích Hoạt Duyên Phận & Ban Sức</span>
            </div>
            <p className="text-xs text-slate-300 leading-relaxed">
              Tận dụng cặp tướng kích hoạt đặc thù (như <em>Vegeta Fusion + Kakarot</em> biến thân Gogeta) và kết hợp với <strong>10 Hệ Đá Ban Sức Vận Mệnh</strong> cùng <strong>5 Set Con Giáp</strong>.
            </p>
          </div>
        </div>
      </div>

      {/* ==================================================== */}
      {/* 5. MODAL: HERO QUICK PREVIEW                         */}
      {/* ==================================================== */}
      {previewHero && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/80 backdrop-blur-md animate-fade-in"
          onClick={() => setPreviewHero(null)}
        >
          <div
            className="relative w-full max-w-lg rounded-3xl border border-slate-700 bg-slate-950 p-6 sm:p-8 shadow-2xl text-white space-y-6 overflow-hidden"
            onClick={(e) => e.stopPropagation()}
          >
            {/* Close button */}
            <button
              type="button"
              onClick={() => setPreviewHero(null)}
              className="absolute top-4 right-4 w-8 h-8 rounded-full bg-slate-800 hover:bg-slate-700 flex items-center justify-center text-slate-400 hover:text-white transition-colors"
            >
              ✕
            </button>

            {/* Hero Header */}
            <div className="flex items-center gap-4">
              <div className="w-20 h-20 rounded-2xl border border-amber-500/40 bg-slate-900 overflow-hidden shrink-0 flex items-center justify-center p-1">
                <img
                  src={previewHero.image_2x || previewHero.image}
                  alt={previewHero.name}
                  className="w-full h-full object-contain"
                />
              </div>
              <div className="space-y-1">
                <div className="flex items-center gap-2">
                  <span className="px-2.5 py-0.5 rounded-md text-xs font-black uppercase bg-red-600 text-white">
                    {previewHero.tier}
                  </span>
                  <span className="text-xs font-semibold text-slate-400 px-2 py-0.5 rounded bg-slate-800">
                    {previewHero.role_label}
                  </span>
                </div>
                <h3 className="text-xl font-black text-white">{previewHero.name}</h3>
                <p className="text-xs text-slate-400">
                  Tên game: <span className="text-slate-200">{previewHero.game_name}</span> • ID: {previewHero.id}
                </p>
              </div>
            </div>

            {/* Tactical Notes */}
            <div className="rounded-2xl border border-slate-800 bg-slate-900/60 p-4 space-y-1">
              <span className="text-xs font-bold text-amber-400 uppercase tracking-wider">
                Đánh Giá Thực Chiến:
              </span>
              <p className="text-xs sm:text-sm text-slate-200 leading-relaxed">
                {previewHero.notes}
              </p>
            </div>

            {/* Quick Stats Grid */}
            <div className="grid grid-cols-3 sm:grid-cols-5 gap-2 text-center text-xs">
              <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800">
                <span className="text-[10px] text-slate-400 block">Máu (HP)</span>
                <span className="font-mono font-bold text-emerald-400">{previewHero.hp.toLocaleString()}</span>
              </div>
              <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800">
                <span className="text-[10px] text-slate-400 block">Vật Công</span>
                <span className="font-mono font-bold text-red-400">{previewHero.patk.toLocaleString()}</span>
              </div>
              <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800">
                <span className="text-[10px] text-slate-400 block">Ma Công</span>
                <span className="font-mono font-bold text-purple-400">{previewHero.matk.toLocaleString()}</span>
              </div>
              <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800">
                <span className="text-[10px] text-slate-400 block">Phòng Ngự</span>
                <span className="font-mono font-bold text-sky-400">{previewHero.def.toLocaleString()}</span>
              </div>
              <div className="p-2.5 rounded-xl bg-slate-900 border border-slate-800 col-span-2 sm:col-span-1">
                <span className="text-[10px] text-slate-400 block">Tốc Độ</span>
                <span className="font-mono font-bold text-amber-400">{previewHero.speed.toLocaleString()}</span>
              </div>
            </div>

            {/* Action buttons */}
            <div className="flex items-center justify-end gap-3 pt-2">
              <button
                type="button"
                onClick={() => setPreviewHero(null)}
                className="px-4 py-2 rounded-xl text-xs font-semibold text-slate-400 hover:text-white"
              >
                Đóng
              </button>
              <Link
                href={previewHero.url}
                className="px-5 py-2.5 rounded-xl text-xs font-bold bg-amber-500 text-slate-950 hover:bg-amber-400 transition-colors shadow-lg"
              >
                Xem Hồ Sơ Chi Tiết Tướng →
              </Link>
            </div>
          </div>
        </div>
      )}

      {/* ==================================================== */}
      {/* 6. MODAL: IMAGE LIGHTBOX ZOOM                        */}
      {/* ==================================================== */}
      {lightboxImage && (
        <div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/90 backdrop-blur-md animate-fade-in"
          onClick={() => setLightboxImage(null)}
        >
          <div
            className="relative max-w-5xl max-h-[90vh] flex flex-col items-center space-y-4"
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center justify-between w-full px-2 text-white">
              <h4 className="font-bold text-sm sm:text-base">{lightboxImage.title}</h4>
              <button
                type="button"
                onClick={() => setLightboxImage(null)}
                className="px-3 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-xs font-bold text-slate-300"
              >
                ✕ Đóng (ESC)
              </button>
            </div>
            <div className="rounded-2xl overflow-hidden border border-slate-700 bg-slate-950 shadow-2xl">
              <img
                src={lightboxImage.src}
                alt={lightboxImage.title}
                className="max-h-[80vh] w-auto object-contain"
              />
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
