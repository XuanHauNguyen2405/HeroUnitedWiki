"use client";

import React, { useState } from "react";
import Link from "next/link";
import Header from "@/components/Header";
import Footer from "@/components/Footer";
import HeroStandingArt from "@/components/HeroStandingArt";
import HeroCard from "@/components/HeroCard";
import manifestRaw from "@/data/hero_artwork_manifest.json";

interface ManifestEntry {
  id: string;
  name: string;
  animation: string;
  standing: {
    image: string;
    source_type: string;
    anim_file?: string;
    action?: string;
    frame?: number;
    scale?: number;
    anchor?: number[];
    verified_against?: string;
    verified: boolean;
  };
  card: {
    image: string;
    source_type: string;
    source_file?: string;
    anim_file?: string;
    action?: string;
    scale?: number;
    offset?: number[];
    overflow?: { top: number; sides: number };
    verified_against?: string;
    verified: boolean;
  };
}

const MANIFEST: Record<string, ManifestEntry> = manifestRaw as any;

export default function HeroArtworkGalleryPage() {
  const [filterType, setFilterType] = useState<"all" | "verified">("verified");
  const [searchTerm, setSearchTerm] = useState("");

  const heroList = Object.values(MANIFEST);

  const filteredHeroes = heroList.filter((item) => {
    if (filterType === "verified" && !item.standing?.verified && !item.card?.verified) {
      return false;
    }
    if (searchTerm.trim()) {
      const q = searchTerm.toLowerCase();
      const matchName = item.name.toLowerCase().includes(q);
      const matchId = item.id.includes(q);
      const matchAnim = (item.animation || "").toLowerCase().includes(q);
      return matchName || matchId || matchAnim;
    }
    return true;
  });

  return (
    <div className="min-h-screen bg-[#070a12] text-slate-100 flex flex-col font-sans">
      <Header />

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 py-8 space-y-8">
        {/* Navigation Breadcrumbs */}
        <div className="flex items-center gap-2 text-xs text-slate-400">
          <Link href="/heroes" className="hover:text-amber-400 transition-colors">
            Danh Sách Tướng
          </Link>
          <span>/</span>
          <span className="text-amber-400 font-semibold">
            Thư Viện Đối Chiếu: Toàn Thân vs Dạng Thẻ
          </span>
        </div>

        {/* Page Header */}
        <div className="rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900 via-slate-950 to-[#0b0f19] p-6 sm:p-8 shadow-2xl relative overflow-hidden">
          <div className="absolute -right-20 -top-20 w-80 h-80 rounded-full bg-amber-500/10 blur-3xl pointer-events-none" />
          <div className="relative z-10 space-y-3">
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full text-xs font-bold bg-amber-500/10 text-amber-400 border border-amber-500/30">
              <span>⚔️</span> Rà Soát Tạo Hình Chuẩn Xác
            </div>
            <h1 className="text-2xl sm:text-4xl font-black text-white tracking-tight">
              Đối Chiếu 2 Chế Độ Dựng Hình: <span className="text-amber-400">Toàn Thân</span> vs{" "}
              <span className="text-red-400">Dạng Thẻ</span>
            </h1>
            <p className="text-sm text-slate-300 max-w-3xl leading-relaxed">
              Game có <b>HAI</b> cách dựng hình riêng biệt: màn hình <b>Chi tiết tướng</b> dùng hoạt ảnh
              đứng (<i>待机 - daiji</i>) hiển thị trọn vẹn đầu, chân, cánh và vũ khí; còn màn hình <b>Thẻ bài</b> dùng
              ảnh thẻ riêng hoặc hoạt ảnh phóng lớn nhô khỏi viền thẻ.
            </p>
          </div>
        </div>

        {/* Filter & Search Bar */}
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 bg-slate-900/60 p-4 rounded-2xl border border-slate-800">
          <div className="flex items-center gap-2 w-full sm:w-auto">
            <button
              onClick={() => setFilterType("verified")}
              className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                filterType === "verified"
                  ? "bg-amber-500 text-slate-950 shadow-lg shadow-amber-500/20"
                  : "bg-slate-800 text-slate-300 hover:bg-slate-700"
              }`}
            >
              🌟 Đã Rà Soát Thực Nghiệm ({heroList.filter((h) => h.standing?.verified || h.card?.verified).length})
            </button>
            <button
              onClick={() => setFilterType("all")}
              className={`px-4 py-2 rounded-xl text-xs font-bold transition-all ${
                filterType === "all"
                  ? "bg-amber-500 text-slate-950 shadow-lg shadow-amber-500/20"
                  : "bg-slate-800 text-slate-300 hover:bg-slate-700"
              }`}
            >
              Tất Cả Tướng ({heroList.length})
            </button>
          </div>

          <div className="w-full sm:w-72">
            <input
              type="text"
              placeholder="Tìm theo tên, ID hoặc animation..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full px-3.5 py-2 rounded-xl bg-slate-950 border border-slate-700/80 text-xs text-white placeholder-slate-500 focus:outline-none focus:border-amber-400"
            />
          </div>
        </div>

        {/* Comparison Grid */}
        <div className="space-y-8">
          {filteredHeroes.map((h) => (
            <div
              key={h.id}
              className="rounded-3xl border border-slate-800 bg-slate-900/50 p-6 md:p-8 backdrop-blur-md shadow-xl space-y-6"
            >
              {/* Row Header */}
              <div className="flex flex-wrap items-center justify-between gap-3 border-b border-slate-800 pb-4">
                <div className="flex items-center gap-3">
                  <span className="text-xl">🎴</span>
                  <div>
                    <h2 className="text-xl font-black text-white flex items-center gap-2">
                      <Link
                        href={`/heroes/${h.id}`}
                        className="hover:text-amber-400 transition-colors"
                      >
                        {h.name}
                      </Link>
                      <span className="text-xs font-mono px-2 py-0.5 rounded-md bg-slate-800 text-slate-400 border border-slate-700">
                        ID: {h.id}
                      </span>
                    </h2>
                    <p className="text-xs text-slate-400 mt-0.5">
                      Animation: <code className="text-amber-300 font-mono">{h.animation || "none"}</code>
                    </p>
                  </div>
                </div>

                <Link
                  href={`/heroes/${h.id}`}
                  className="px-3.5 py-1.5 rounded-xl bg-amber-500/10 border border-amber-500/30 text-xs font-bold text-amber-300 hover:bg-amber-500/20 transition-all"
                >
                  Xem Trang Chi Tiết &rarr;
                </Link>
              </div>

              {/* Two Column Side-by-Side Comparison */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-8 items-start">
                {/* COLUMN 1: TOÀN THÂN (STANDING ART) */}
                <div className="rounded-2xl border border-emerald-500/30 bg-gradient-to-b from-emerald-950/20 via-slate-950/40 to-slate-950 p-5 flex flex-col items-center justify-between min-h-[520px] shadow-lg">
                  <div className="w-full flex items-center justify-between text-xs font-bold border-b border-emerald-500/20 pb-3 mb-4">
                    <span className="flex items-center gap-1.5 text-emerald-400">
                      <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
                      1. Toàn Thân (Standing Art)
                    </span>
                    <span className="text-[11px] px-2 py-0.5 rounded bg-emerald-950/60 text-emerald-300 border border-emerald-500/30">
                      Chi Tiết Game
                    </span>
                  </div>

                  {/* Standing Art Display */}
                  <div className="flex-1 w-full flex items-end justify-center py-4">
                    <HeroStandingArt
                      hero={{
                        id: h.id,
                        name: h.name,
                        standing_image: h.standing.image,
                        full_image: h.standing.image,
                        animation: h.animation,
                      }}
                      size="md"
                    />
                  </div>

                  {/* Standing Art Technical Metadata */}
                  <div className="w-full mt-4 p-3 rounded-xl bg-slate-950/80 border border-slate-800 text-[11px] space-y-1 font-mono text-slate-300">
                    <div className="flex justify-between">
                      <span className="text-slate-500">Mã nguồn tạo:</span>
                      <span className="text-emerald-400">game_util:createAnimSequence</span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-slate-500">Hoạt ảnh / Frame:</span>
                      <span className="text-slate-200">
                        {h.standing.anim_file || `${h.animation}.swf.sam`} [action: {h.standing.action || "daiji"}]
                      </span>
                    </div>
                    {h.standing.verified_against && (
                      <div className="flex justify-between border-t border-slate-800/80 pt-1 text-emerald-300 font-sans font-semibold">
                        <span>Đối chiếu:</span>
                        <span>{h.standing.verified_against}</span>
                      </div>
                    )}
                  </div>
                </div>

                {/* COLUMN 2: DẠNG THẺ (CARD ART) */}
                <div className="rounded-2xl border border-amber-500/30 bg-gradient-to-b from-amber-950/20 via-slate-950/40 to-slate-950 p-5 flex flex-col items-center justify-between min-h-[520px] shadow-lg">
                  <div className="w-full flex items-center justify-between text-xs font-bold border-b border-amber-500/20 pb-3 mb-4">
                    <span className="flex items-center gap-1.5 text-amber-400">
                      <span className="w-2 h-2 rounded-full bg-amber-400" />
                      2. Dạng Thẻ (Card Art)
                    </span>
                    <span className="text-[11px] px-2 py-0.5 rounded bg-amber-950/60 text-amber-300 border border-amber-500/30">
                      Nhô Khỏi Viền Thẻ
                    </span>
                  </div>

                  {/* Card Art Display */}
                  <div className="flex-1 w-full flex items-center justify-center py-2">
                    <HeroCard
                      hero={{
                        id: h.id,
                        name: h.name,
                        card_image: h.card.image,
                        full_image: h.standing.image,
                        animation: h.animation,
                        quality: 4,
                      }}
                      superQualityStage={5} // Đỏ++
                      rebirthStage={h.id === "82400" ? 7 : 2}
                      level={255}
                      enhancementLevel={60}
                      breakthroughLevel={20}
                      size="md"
                      reserveArtworkSpace
                    />
                  </div>

                  {/* Card Art Technical Metadata */}
                  <div className="w-full mt-4 p-3 rounded-xl bg-slate-950/80 border border-slate-800 text-[11px] space-y-1 font-mono text-slate-300">
                    <div className="flex justify-between">
                      <span className="text-slate-500">Mã nguồn tạo:</span>
                      <span className="text-amber-400">
                        {h.card.source_type === "card_img"
                          ? "createCardImgByCfg (Tài nguyên riêng)"
                          : "createIdelAnim (Scale 0.66, Offset 0, -33)"}
                      </span>
                    </div>
                    <div className="flex justify-between">
                      <span className="text-slate-500">Tài nguyên gốc:</span>
                      <span className="text-slate-200 truncate max-w-[260px]" title={h.card.source_file}>
                        {h.card.source_file || h.card.image}
                      </span>
                    </div>
                    {h.card.verified_against && (
                      <div className="flex justify-between border-t border-slate-800/80 pt-1 text-amber-300 font-sans font-semibold">
                        <span>Đối chiếu:</span>
                        <span>{h.card.verified_against}</span>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </main>

      <Footer />
    </div>
  );
}
