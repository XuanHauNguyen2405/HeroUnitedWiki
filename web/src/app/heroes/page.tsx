// web/src/app/heroes/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Breadcrumbs from "@/components/Breadcrumbs";
import HeroSummaryCard from "@/components/HeroSummaryCard";
import { elements, rawDomainLabel } from "@/lib/game-attributes";
import { combatProfiles } from "@/lib/equipment-advisor";
import { stripVietnameseAccents } from "@/lib/utils";
import heroesData from "@/data/heroes_catalog.json";

export default function HeroesPage() {
  const [search, setSearch] = useState("");
  const [qualityFilter, setQualityFilter] = useState<string>("all");
  const [elementFilter, setElementFilter] = useState("all");
  const [careerFilter, setCareerFilter] = useState<string>("all");
  const [raceFilter, setRaceFilter] = useState<string>("all");
  const [onlyWithImage, setOnlyWithImage] = useState(false);
  const [sortBy, setSortBy] = useState<string>("id_asc");
  const [page, setPage] = useState(1);
  const pageSize = 24;

  const hasActiveFilters =
    search.trim() !== "" ||
    qualityFilter !== "all" ||
    elementFilter !== "all" ||
    careerFilter !== "all" ||
    raceFilter !== "all" ||
    onlyWithImage ||
    sortBy !== "id_asc";

  const resetAllFilters = () => {
    setSearch("");
    setQualityFilter("all");
    setElementFilter("all");
    setCareerFilter("all");
    setRaceFilter("all");
    setOnlyWithImage(false);
    setSortBy("id_asc");
  };

  // Filter and sort heroes
  const filteredHeroes = useMemo(() => {
    let list = heroesData as any[];

    // 1. Search (accent-insensitive)
    if (search.trim()) {
      const cleanSearch = stripVietnameseAccents(search);
      const rawSearch = search.toLowerCase().trim();
      list = list.filter(
        (h) =>
          stripVietnameseAccents(h.name).includes(cleanSearch) ||
          h.name?.toLowerCase().includes(rawSearch) ||
          String(h.id).includes(cleanSearch) ||
          String(h.character_id).includes(cleanSearch)
      );
    }

    // 2. Filter Quality
    if (qualityFilter !== "all") {
      const q = parseInt(qualityFilter, 10);
      list = list.filter((h) => h.quality === q);
    }

    // 3. Filter Element & Career
    if (elementFilter !== "all") {
      list = list.filter((h) =>
        combatProfiles[h.id]?.evidence.some(
          (e) => e.slot > 0 && e.element_ids.includes(elementFilter)
        )
      );
    }
    if (careerFilter !== "all") {
      const c = parseInt(careerFilter, 10);
      list = list.filter((h) => h.career === c);
    }

    // 4. Filter Race
    if (raceFilter !== "all") {
      const r = parseInt(raceFilter, 10);
      list = list.filter((h) => h.race === r);
    }

    // 5. Only with image
    if (onlyWithImage) {
      list = list.filter((h) => h.has_image);
    }

    // 6. Sort
    list = [...list].sort((a, b) => {
      switch (sortBy) {
        case "hp_desc":
          return (b.hp || 0) - (a.hp || 0);
        case "patk_desc":
          return (b.patk || 0) - (a.patk || 0);
        case "speed_desc":
          return (b.speed || 0) - (a.speed || 0);
        case "quality_desc":
          return (b.quality || 0) - (a.quality || 0);
        case "id_desc":
          return parseInt(b.id, 10) - parseInt(a.id, 10);
        case "id_asc":
        default:
          return parseInt(a.id, 10) - parseInt(b.id, 10);
      }
    });

    return list;
  }, [
    search,
    qualityFilter,
    careerFilter,
    raceFilter,
    elementFilter,
    onlyWithImage,
    sortBy,
  ]);

  // Reset page to 1 when filters change
  useEffect(() => {
    setPage(1);
  }, [
    search,
    qualityFilter,
    careerFilter,
    raceFilter,
    elementFilter,
    onlyWithImage,
    sortBy,
  ]);

  const totalPages = Math.ceil(filteredHeroes.length / pageSize) || 1;
  const paginatedHeroes = filteredHeroes.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  const selectClass =
    "w-full bg-slate-950 border border-slate-800 rounded-xl px-3 py-2 text-xs text-slate-200 focus:outline-none focus:border-indigo-500 transition-colors";

  return (
    <div className="space-y-6">
      {/* Breadcrumbs */}
      <Breadcrumbs items={[{ label: "Danh Sách Tướng" }]} />

      {/* Header Banner */}
      <div className="p-6 sm:p-8 rounded-3xl border border-slate-800/80 bg-gradient-to-r from-indigo-950/40 via-slate-900/90 to-slate-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-xl">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-indigo-500/10 border border-indigo-500/20 text-[11px] font-semibold text-indigo-300 mb-2">
            <span>👤</span> Kho Dữ Liệu Bản Thể Tướng
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
            Danh Sách {heroesData.length} Bản Thể Tướng
          </h1>
          <p className="text-xs sm:text-sm text-slate-400 mt-1.5 max-w-2xl leading-relaxed">
            Phân biệt rõ ràng từng bản thể riêng biệt (<code className="text-indigo-300 font-mono">id</code>), giúp tra cứu chính xác các biến thể sao, trang phục và dạng chuyển thế.
          </p>
        </div>

        <div className="flex items-center gap-3 text-xs bg-slate-950/90 px-4 py-2.5 rounded-2xl border border-slate-800 shrink-0">
          <span className="text-slate-400">Đang hiển thị:</span>
          <span className="font-mono font-extrabold text-indigo-400 text-sm">
            {filteredHeroes.length} / {heroesData.length}
          </span>
        </div>
      </div>

      {/* Filter & Search Bar Controls */}
      <div className="p-4 sm:p-5 rounded-2xl border border-slate-800/90 bg-slate-900/60 backdrop-blur-xl space-y-4 shadow-lg">
        {/* Search Input + Quick Toggles */}
        <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
          <div className="relative flex-1">
            <input
              type="text"
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Tìm theo tên tướng (Sasuke, Luffy, Vegetto, Inori...) hoặc mã ID..."
              className="w-full bg-slate-950 border border-slate-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-slate-500 focus:outline-none focus:border-indigo-500 focus:ring-2 focus:ring-indigo-500/20 transition-all"
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

          <label className="flex items-center gap-2.5 px-3.5 py-2.5 rounded-xl border border-slate-800 bg-slate-950/80 cursor-pointer text-xs text-slate-300 hover:text-white hover:border-slate-700 select-none shrink-0 transition-colors">
            <input
              type="checkbox"
              checked={onlyWithImage}
              onChange={(e) => setOnlyWithImage(e.target.checked)}
              className="w-4 h-4 rounded bg-slate-900 border-slate-700 text-indigo-600 focus:ring-indigo-500"
            />
            <span>
              Chỉ hiện có ảnh ({heroesData.filter((h) => h.has_image).length})
            </span>
          </label>

          {hasActiveFilters && (
            <button
              onClick={resetAllFilters}
              className="px-3.5 py-2.5 rounded-xl border border-rose-500/30 bg-rose-500/10 text-rose-300 hover:bg-rose-500/20 text-xs font-semibold shrink-0 transition-colors"
            >
              Đặt lại bộ lọc ✕
            </button>
          )}
        </div>

        {/* 5 Filter Selects */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3 text-xs">
          {/* Quality Filter */}
          <div>
            <label className="block text-slate-400 mb-1.5 font-medium">
              Phẩm chất
            </label>
            <select
              value={qualityFilter}
              onChange={(e) => setQualityFilter(e.target.value)}
              className={selectClass}
            >
              <option value="all">Tất cả phẩm chất</option>
              <option value="5">Phẩm 5 (Đỏ)</option>
              <option value="4">Phẩm 4 (Cam)</option>
              <option value="3">Phẩm 3 (Tím)</option>
              <option value="2">Phẩm 2 (Lam)</option>
              <option value="1">Phẩm 1 (Lục)</option>
            </select>
          </div>

          {/* Skill Element Filter */}
          <div>
            <label
              htmlFor="skill-element-filter"
              className="block text-slate-400 mb-1.5 font-medium"
            >
              Thuộc tính trong kỹ năng
            </label>
            <select
              id="skill-element-filter"
              value={elementFilter}
              onChange={(e) => setElementFilter(e.target.value)}
              className={selectClass}
            >
              <option value="all">Tất cả thuộc tính kỹ năng</option>
              {Object.values(elements).map((e) => (
                <option key={e.id} value={e.id}>
                  {e.name}
                </option>
              ))}
            </select>
          </div>

          {/* Career Filter */}
          <div>
            <label className="block text-slate-400 mb-1.5 font-medium">
              Nghề (Career)
            </label>
            <select
              aria-label="Nghề của tướng"
              value={careerFilter}
              onChange={(e) => setCareerFilter(e.target.value)}
              className={selectClass}
            >
              <option value="all">Tất cả nghề</option>
              {[...new Set(heroesData.map((h) => h.career))]
                .filter((id) => id !== null && id !== undefined)
                .sort((a, b) => a - b)
                .map((id) => (
                  <option key={id} value={String(id)}>
                    {rawDomainLabel("career", id)}
                  </option>
                ))}
            </select>
          </div>

          {/* Race Filter */}
          <div>
            <label className="block text-slate-400 mb-1.5 font-medium">
              Tộc (ID nguồn)
            </label>
            <select
              aria-label="Tộc của tướng"
              value={raceFilter}
              onChange={(e) => setRaceFilter(e.target.value)}
              className={selectClass}
            >
              <option value="all">Tất cả tộc</option>
              {[...new Set(heroesData.map((h) => h.race))]
                .filter((id) => id !== null && id !== undefined)
                .sort((a, b) => a - b)
                .map((id) => (
                  <option key={id} value={String(id)}>
                    {rawDomainLabel("race", id)}
                  </option>
                ))}
            </select>
          </div>

          {/* Sort By */}
          <div>
            <label className="block text-slate-400 mb-1.5 font-medium">
              Sắp xếp theo
            </label>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className={selectClass}
            >
              <option value="id_asc">ID tăng dần</option>
              <option value="id_desc">ID giảm dần</option>
              <option value="quality_desc">Phẩm chất cao nhất</option>
              <option value="hp_desc">HP cao nhất</option>
              <option value="patk_desc">Vật công cao nhất</option>
              <option value="speed_desc">Tốc độ cao nhất</option>
            </select>
          </div>
        </div>
      </div>

      {/* Heroes Grid */}
      {paginatedHeroes.length === 0 ? (
        <div className="p-12 text-center border border-slate-800 rounded-2xl bg-slate-900/30 text-slate-400">
          <div className="text-4xl mb-3">🔍</div>
          <div className="text-base font-semibold text-slate-200">
            Không tìm thấy tướng phù hợp
          </div>
          <p className="text-xs text-slate-500 mt-1">
            Thử thay đổi từ khóa tìm kiếm hoặc nhấn &ldquo;Đặt lại bộ lọc&rdquo; phía trên.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {paginatedHeroes.map((hero) => (
            <HeroSummaryCard key={hero.id} hero={hero} />
          ))}
        </div>
      )}

      {/* Pagination Controls */}
      {totalPages > 1 && (
        <div className="flex flex-col sm:flex-row items-center justify-between gap-4 pt-6 border-t border-slate-800/80 text-xs text-slate-400">
          <div>
            Hiển thị{" "}
            <span className="text-white font-semibold">
              {(page - 1) * pageSize + 1} –{" "}
              {Math.min(page * pageSize, filteredHeroes.length)}
            </span>{" "}
            trong tổng số{" "}
            <span className="text-white font-semibold">
              {filteredHeroes.length}
            </span>{" "}
            bản thể tướng
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
            <span className="px-3.5 py-1.5 font-mono font-bold text-white bg-indigo-950/60 border border-indigo-500/30 rounded-xl">
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
