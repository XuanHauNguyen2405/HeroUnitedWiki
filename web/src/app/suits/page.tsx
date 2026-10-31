// web/src/app/suits/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import ElementBadge from "@/components/ElementBadge";
import { SetBonuses } from "@/components/EquipmentDetails";
import { elements } from "@/lib/game-attributes";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { stripVietnameseAccents } from "@/lib/utils";
import suitsCatalog from "@/data/suits_catalog.json";

const ZODIAC_SUIT_MAP: Record<string, string[]> = {
  hoi: ["652", "653", "654", "655"],
  chuot: ["471", "472", "473", "474"],
  rong: ["485", "486", "487", "488"],
  ti: ["1370", "1371", "1372", "1373"],
  ngua: ["1630", "1650", "1670", "1690"],
};

export default function SuitsPage() {
  const [search, setSearch] = useState("");
  const [elementFilter, setElementFilter] = useState("all");
  const [zodiacFilter, setZodiacFilter] = useState<string | null>(null);
  const [onlyCompleteImages, setOnlyCompleteImages] = useState(false);
  const [page, setPage] = useState(1);
  const pageSize = 20;

  const filteredSuits = useMemo(() => {
    let list = suitsCatalog as any[];
    if (elementFilter !== "all") {
      list = list.filter((suit) =>
        elementFilter === "unknown"
          ? !suit.element_id
          : suit.element_id === elementFilter
      );
    }

    if (zodiacFilter && ZODIAC_SUIT_MAP[zodiacFilter]) {
      const allowedIds = ZODIAC_SUIT_MAP[zodiacFilter];
      list = list.filter((s) => allowedIds.includes(String(s.id)));
    }

    if (search.trim()) {
      const cleanSearch = stripVietnameseAccents(search);
      const rawSearch = search.toLowerCase().trim();
      list = list.filter(
        (s) =>
          stripVietnameseAccents(s.name).includes(cleanSearch) ||
          s.name?.toLowerCase().includes(rawSearch) ||
          String(s.id).includes(cleanSearch) ||
          s.parts?.some(
            (p: any) =>
              stripVietnameseAccents(p.name).includes(cleanSearch) ||
              String(p.id).includes(cleanSearch)
          )
      );
    }

    if (onlyCompleteImages) {
      list = list.filter((s) => s.has_all_images);
    }

    return list;
  }, [elementFilter, search, zodiacFilter, onlyCompleteImages]);

  useEffect(() => {
    setPage(1);
  }, [elementFilter, search, zodiacFilter, onlyCompleteImages]);

  const totalPages = Math.ceil(filteredSuits.length / pageSize) || 1;
  const paginatedSuits = filteredSuits.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  return (
    <div className="space-y-6">
      <Breadcrumbs items={[{ label: "Bộ Trang Bị (Suits)" }]} />

      {/* Header */}
      <div className="p-6 sm:p-8 rounded-3xl border border-slate-800/80 bg-gradient-to-r from-emerald-950/40 via-slate-900/90 to-slate-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-xl">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-[11px] font-semibold text-emerald-300 mb-2">
            <span>🛡️</span> Hệ Thống Bộ Trang Bị Đồng Bộ
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
            Danh Mục {suitsCatalog.length} Bộ Trang Bị (Suits)
          </h1>
          <p className="text-xs sm:text-sm text-slate-400 mt-1.5 max-w-2xl leading-relaxed">
            Tra cứu đầy đủ 4 vị trí trang bị trong bộ (Vũ khí, Trang sức, Giáp/Áo, Giày) và các mốc kích hoạt thuộc tính cộng dồn 2, 3, 4 món.
          </p>
        </div>
        <div className="flex items-center gap-3 text-xs bg-slate-950/90 px-4 py-2.5 rounded-2xl border border-slate-800 shrink-0">
          <span className="text-slate-400">Đang hiển thị:</span>{" "}
          <span className="font-mono font-extrabold text-emerald-400 text-sm">
            {filteredSuits.length} / {suitsCatalog.length}
          </span>
        </div>
      </div>

      {/* Controls */}
      <div className="p-4 sm:p-5 rounded-2xl border border-slate-800/90 bg-slate-900/60 backdrop-blur-xl space-y-4 shadow-lg">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-3 items-center">
          {/* Search Input */}
          <div className="relative lg:col-span-6">
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Tìm theo tên bộ (Thần Đồng, Sasuke, Chú Nguyền...), ID bộ, tên món..."
              className="w-full bg-slate-950 border border-slate-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 transition-all"
            />
            <span className="absolute left-3.5 top-1/2 -translate-y-1/2 text-slate-500 text-sm">
              🔍
            </span>
            {search && (
              <button
                onClick={() => setSearch("")}
                className="absolute right-3 top-1/2 -translate-y-1/2 text-slate-400 hover:text-white text-xs px-1.5 py-0.5 rounded bg-slate-800"
              >
                ✕
              </button>
            )}
          </div>

          {/* Element Filter */}
          <div className="lg:col-span-3">
            <select
              aria-label="Lọc thuộc tính theo bộ"
              className="w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2.5 text-xs text-slate-200 focus:outline-none focus:border-emerald-500 transition-colors"
              value={elementFilter}
              onChange={(e) => setElementFilter(e.target.value)}
            >
              <option value="all">Tất cả thuộc tính bộ</option>
              {Object.values(elements).map((e) => (
                <option key={e.id} value={e.id}>
                  Hệ {e.name} ({e.meaning})
                </option>
              ))}
              <option value="unknown">Chưa xác minh thuộc tính</option>
            </select>
          </div>

          {/* Complete Images Toggle */}
          <div className="lg:col-span-3 flex items-center justify-end">
            <label className="w-full flex items-center justify-center gap-2.5 px-3.5 py-2.5 rounded-xl border border-slate-800 bg-slate-950/80 cursor-pointer text-xs text-slate-300 hover:text-white hover:border-slate-700 select-none whitespace-nowrap transition-colors">
              <input
                type="checkbox"
                checked={onlyCompleteImages}
                onChange={(e) => setOnlyCompleteImages(e.target.checked)}
                className="w-4 h-4 rounded bg-slate-950 border-slate-700 text-emerald-600 focus:ring-emerald-500"
              />
              <span>
                Đủ 4 ảnh ({suitsCatalog.filter((s: any) => s.has_all_images).length})
              </span>
            </label>
          </div>
        </div>

        {/* 5 Đại Bộ Trang Bị Con Giáp Quick Filter */}
        <div className="p-3 sm:p-3.5 rounded-xl border border-amber-500/25 bg-gradient-to-r from-amber-950/20 via-slate-950/60 to-slate-950/40 flex flex-wrap items-center gap-2">
          <span className="text-xs font-bold text-amber-400 flex items-center gap-1.5 mr-1">
            <span>🌟</span> 5 Đại Bộ Con Giáp:
          </span>
          {[
            { label: "🐷 Set Hợi", id: "hoi" },
            { label: "🐭 Set Chuột", id: "chuot" },
            { label: "🐉 Set Rồng", id: "rong" },
            { label: "🐍 Set Tị", id: "ti" },
            { label: "🐴 Set Ngựa", id: "ngua" },
          ].map((item) => (
            <button
              key={item.id}
              onClick={() => {
                if (zodiacFilter === item.id) {
                  setZodiacFilter(null);
                } else {
                  setZodiacFilter(item.id);
                  setSearch("");
                }
              }}
              className={`text-xs px-3 py-1.5 rounded-lg border transition-all ${
                zodiacFilter === item.id
                  ? "bg-amber-500 text-slate-950 border-amber-400 font-bold shadow-md shadow-amber-500/20"
                  : "bg-slate-900/90 text-slate-300 border-slate-700/80 hover:border-amber-400/60 hover:text-white"
              }`}
            >
              {item.label}
            </button>
          ))}
          {(search || zodiacFilter || elementFilter !== "all" || onlyCompleteImages) && (
            <button
              onClick={() => {
                setSearch("");
                setZodiacFilter(null);
                setElementFilter("all");
                setOnlyCompleteImages(false);
              }}
              className="text-xs px-2.5 py-1 rounded-lg border border-rose-500/30 bg-rose-500/10 text-rose-300 hover:bg-rose-500/20 ml-auto font-medium transition-colors"
            >
              Bỏ lọc ✕
            </button>
          )}
        </div>
      </div>

      {/* Suits Grid */}
      {paginatedSuits.length === 0 ? (
        <div className="p-12 text-center border border-slate-800 rounded-2xl bg-slate-900/30 text-slate-400">
          Không tìm thấy bộ trang bị phù hợp.
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          {paginatedSuits.map((suit: any) => (
            <div
              key={suit.id}
              className="p-5 rounded-2xl border border-slate-800/90 bg-slate-900/50 hover:border-emerald-500/40 hover:bg-slate-900/80 transition-all hover:shadow-xl flex flex-col justify-between space-y-4"
            >
              <div className="space-y-4">
                <div className="flex items-start justify-between gap-3">
                  <div className="flex items-center gap-3">
                    <span className="text-2xl p-2.5 rounded-xl bg-slate-950 border border-slate-800 shrink-0">
                      🛡️
                    </span>
                    <div>
                      <h3 className="font-bold text-white text-base sm:text-lg">
                        Bộ {suit.name}
                      </h3>
                      <div className="flex flex-wrap items-center gap-2 mt-1">
                        <span className="text-[11px] font-mono text-slate-400 bg-slate-950 border border-slate-800 px-2 py-0.5 rounded">
                          Suit ID: #{suit.id}
                        </span>
                        <ElementBadge id={suit.element_id} />
                      </div>
                    </div>
                  </div>

                  <span
                    className={`text-[10px] px-2.5 py-1 rounded-full border font-semibold shrink-0 ${
                      suit.has_all_images
                        ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
                        : "bg-slate-800 text-slate-400 border-slate-700"
                    }`}
                  >
                    {suit.parts_count} Mảnh
                  </span>
                </div>

                {/* 4 Parts Display */}
                <div className="grid grid-cols-4 gap-2">
                  {suit.parts?.map((p: any) => (
                    <div
                      key={p.id}
                      className="p-2.5 rounded-xl bg-slate-950/80 border border-slate-800/90 text-center flex flex-col items-center justify-between"
                    >
                      <div className="w-11 h-11 rounded-lg overflow-hidden border border-slate-700/80 bg-slate-900 mb-1.5 p-0.5">
                        <ImageWithFallback
                          src={p.icon}
                          alt={p.name}
                          className="w-full h-full object-contain"
                          fallbackText="No Pic"
                          fallbackIcon="⚔️"
                        />
                      </div>
                      <div
                        className="text-[11px] font-semibold text-slate-200 truncate w-full"
                        title={p.name}
                      >
                        {p.name}
                      </div>
                      <div className="text-[10px] text-slate-500 truncate w-full mt-0.5">
                        {p.slot_name}
                      </div>
                    </div>
                  ))}
                </div>

                <SetBonuses bonuses={suit.bonuses} />
              </div>

              <Link
                href={`/suits/${suit.id}`}
                className="py-2.5 px-4 rounded-xl bg-slate-950 hover:bg-emerald-500/15 hover:border-emerald-500/40 border border-slate-800 text-emerald-300 hover:text-emerald-200 text-xs font-semibold text-center transition-all flex items-center justify-center gap-1.5"
              >
                <span>Xem chi tiết 4 món & thuộc tính</span>
                <span>→</span>
              </Link>
            </div>
          ))}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-6 border-t border-slate-800/80 text-xs text-slate-400">
          <div>
            Trang <span className="text-white font-bold">{page}</span> /{" "}
            {totalPages} ({filteredSuits.length} bộ trang bị)
          </div>

          <div className="flex items-center gap-1.5">
            <button
              onClick={() => setPage(1)}
              disabled={page === 1}
              className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white disabled:opacity-40 disabled:pointer-events-none transition-colors"
            >
              ««
            </button>
            <button
              onClick={() => setPage((p) => Math.max(p - 1, 1))}
              disabled={page === 1}
              className="px-3.5 py-1.5 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white disabled:opacity-40 disabled:pointer-events-none transition-colors"
            >
              Trước
            </button>
            <span className="px-3.5 py-1.5 font-mono font-bold text-white bg-emerald-950/60 border border-emerald-500/30 rounded-xl">
              {page} / {totalPages}
            </span>
            <button
              onClick={() => setPage((p) => Math.min(p + 1, totalPages))}
              disabled={page === totalPages}
              className="px-3.5 py-1.5 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white disabled:opacity-40 disabled:pointer-events-none transition-colors"
            >
              Sau
            </button>
            <button
              onClick={() => setPage(totalPages)}
              disabled={page === totalPages}
              className="px-3 py-1.5 rounded-xl bg-slate-900 border border-slate-800 hover:bg-slate-800 hover:text-white disabled:opacity-40 disabled:pointer-events-none transition-colors"
            >
              »»
            </button>
          </div>
        </div>
      )}
    </div>
  );
}
