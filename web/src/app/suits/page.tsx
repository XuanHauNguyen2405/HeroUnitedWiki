// web/src/app/suits/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { stripVietnameseAccents } from "@/lib/utils";
import suitsCatalog from "@/data/suits_catalog.json";

export default function SuitsPage() {
  const [search, setSearch] = useState("");
  const [onlyCompleteImages, setOnlyCompleteImages] = useState(false);
  const [page, setPage] = useState(1);
  const pageSize = 20;

  const filteredSuits = useMemo(() => {
    let list = suitsCatalog as any[];

    if (search.trim()) {
      const cleanSearch = stripVietnameseAccents(search);
      const rawSearch = search.toLowerCase().trim();
      list = list.filter(
        (s) =>
          stripVietnameseAccents(s.name).includes(cleanSearch) ||
          s.name?.toLowerCase().includes(rawSearch) ||
          String(s.id).includes(cleanSearch) ||
          s.parts?.some((p: any) =>
            stripVietnameseAccents(p.name).includes(cleanSearch) ||
            String(p.id).includes(cleanSearch)
          )
      );
    }

    if (onlyCompleteImages) {
      list = list.filter((s) => s.has_all_images);
    }

    return list;
  }, [search, onlyCompleteImages]);

  useEffect(() => {
    setPage(1);
  }, [search, onlyCompleteImages]);

  const totalPages = Math.ceil(filteredSuits.length / pageSize) || 1;
  const paginatedSuits = filteredSuits.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  return (
    <div className="space-y-6">
      <Breadcrumbs items={[{ label: "Bộ Trang Bị (Suits)" }]} />

      {/* Header */}
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-emerald-950/40 via-gray-900 to-gray-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white flex items-center gap-3">
            <span>🛡️</span> Danh Mục 729 Bộ Trang Bị (Suits)
          </h1>
          <p className="text-xs sm:text-sm text-gray-400 mt-1 max-w-2xl">
            Tra cứu đầy đủ 4 vị trí trang bị trong bộ (Vũ khí, Trang sức, Giáp/Áo, Giày) và các mốc kích hoạt thuộc tính 2, 3, 4 món.
          </p>
        </div>
        <div className="text-xs bg-gray-950/80 px-3.5 py-2 rounded-xl border border-gray-800">
          <span className="text-gray-400">Kết quả khớp:</span>{" "}
          <span className="font-bold text-emerald-400 text-sm">
            {filteredSuits.length} / {suitsCatalog.length}
          </span>
        </div>
      </div>

      {/* Controls */}
      <div className="p-4 sm:p-5 rounded-xl border border-gray-800 bg-gray-900/60 backdrop-blur-xl flex flex-col sm:flex-row gap-4 items-center justify-between">
        <div className="relative flex-1 w-full">
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Tìm theo tên bộ (Thần Đồng, Sasuke, Chú Nguyền...), ID bộ, tên món trang bị..."
            className="w-full bg-gray-950 border border-gray-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-gray-500 focus:outline-none focus:border-emerald-500"
          />
          <span className="absolute left-3.5 top-3 text-gray-500">🔍</span>
          {search && (
            <button
              onClick={() => setSearch("")}
              className="absolute right-3 top-2.5 text-gray-400 hover:text-white"
            >
              ✕
            </button>
          )}
        </div>

        <label className="flex items-center gap-2 cursor-pointer text-xs text-gray-300 hover:text-white select-none whitespace-nowrap">
          <input
            type="checkbox"
            checked={onlyCompleteImages}
            onChange={(e) => setOnlyCompleteImages(e.target.checked)}
            className="w-4 h-4 rounded bg-gray-950 border-gray-700 text-emerald-600 focus:ring-emerald-500"
          />
          <span>Chỉ hiện bộ đủ 4 ảnh ({suitsCatalog.filter((s: any) => s.has_all_images).length})</span>
        </label>
      </div>

      {/* Suits Grid */}
      {paginatedSuits.length === 0 ? (
        <div className="p-12 text-center border border-gray-800 rounded-2xl bg-gray-900/30 text-gray-400">
          Không tìm thấy bộ trang bị phù hợp.
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-5">
          {paginatedSuits.map((suit: any) => (
            <div
              key={suit.id}
              className="p-5 rounded-2xl border border-gray-800 bg-gray-900/40 hover:border-gray-700 transition-all hover:shadow-xl flex flex-col justify-between"
            >
              <div>
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center gap-2.5">
                    <span className="text-2xl p-2 rounded-xl bg-gray-950 border border-gray-800">
                      🛡️
                    </span>
                    <div>
                      <h3 className="font-bold text-white text-base">
                        Bộ {suit.name}
                      </h3>
                      <span className="text-[11px] font-mono text-gray-400">
                        Suit ID: #{suit.id}
                      </span>
                    </div>
                  </div>

                  <span
                    className={`text-[10px] px-2.5 py-1 rounded-full border font-medium ${
                      suit.has_all_images
                        ? "bg-emerald-500/10 text-emerald-400 border-emerald-500/20"
                        : "bg-gray-800 text-gray-400 border-gray-700"
                    }`}
                  >
                    {suit.parts_count} Mảnh
                  </span>
                </div>

                {/* 4 Parts Display */}
                <div className="grid grid-cols-4 gap-2 my-4">
                  {suit.parts?.map((p: any) => (
                    <div
                      key={p.id}
                      className="p-2 rounded-xl bg-gray-950/70 border border-gray-800 text-center flex flex-col items-center justify-between"
                    >
                      <div className="w-10 h-10 rounded-lg overflow-hidden border border-gray-700 bg-gray-900 mb-1">
                        <ImageWithFallback
                          src={p.icon}
                          alt={p.name}
                          className="w-full h-full object-cover"
                          fallbackText="No Pic"
                          fallbackIcon="⚔️"
                        />
                      </div>
                      <div className="text-[10px] font-semibold text-gray-200 truncate w-full">
                        {p.name}
                      </div>
                      <div className="text-[9px] text-gray-500 truncate w-full">
                        {p.slot_name}
                      </div>
                    </div>
                  ))}
                </div>

                {/* Set Bonuses Preview */}
                <div className="text-[11px] text-gray-400 space-y-1 bg-gray-950/50 p-2.5 rounded-lg border border-gray-800 font-mono">
                  {suit.bonuses?.suit_add2 && (
                    <div className="truncate text-amber-400/90">
                      • 2 món: {JSON.stringify(suit.bonuses.suit_add2)}
                    </div>
                  )}
                  {suit.bonuses?.suit_add3 && (
                    <div className="truncate text-blue-400/90">
                      • 3 món: {JSON.stringify(suit.bonuses.suit_add3)}
                    </div>
                  )}
                  {suit.bonuses?.suit_add4 && (
                    <div className="truncate text-purple-400/90">
                      • 4 món: {JSON.stringify(suit.bonuses.suit_add4)}
                    </div>
                  )}
                </div>
              </div>

              <Link
                href={`/suits/${suit.id}`}
                className="mt-4 py-2 px-4 rounded-xl bg-gray-900 hover:bg-emerald-600/30 hover:border-emerald-500/50 border border-gray-800 text-gray-200 hover:text-white text-xs font-semibold text-center transition-all flex items-center justify-center gap-1.5"
              >
                <span>Xem chi tiết 4 món & thuộc tính</span>
                <span>➔</span>
              </Link>
            </div>
          ))}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between pt-6 border-t border-gray-800 text-xs text-gray-400">
          <div>
            Trang <span className="text-white font-bold">{page}</span> / {totalPages} (
            {filteredSuits.length} bộ)
          </div>

          <div className="flex items-center gap-1.5">
            <button
              onClick={() => setPage((p) => Math.max(p - 1, 1))}
              disabled={page === 1}
              className="px-3 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40"
            >
              Trước
            </button>
            <span className="px-3 py-1.5 font-bold text-white bg-gray-950 border border-gray-800 rounded-lg">
              {page}
            </span>
            <button
              onClick={() => setPage((p) => Math.min(p + 1, totalPages))}
              disabled={page === totalPages}
              className="px-3 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40"
            >
              Sau
            </button>
          </div>
        </div>
      )}

    </div>
  );
}
