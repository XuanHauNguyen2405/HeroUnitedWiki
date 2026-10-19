// web/src/app/heroes/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { stripVietnameseAccents, getQualityConfig } from "@/lib/utils";
import heroesData from "@/data/heroes_catalog.json";

export default function HeroesPage() {
  const [search, setSearch] = useState("");
  const [qualityFilter, setQualityFilter] = useState<string>("all");
  const [careerFilter, setCareerFilter] = useState<string>("all");
  const [raceFilter, setRaceFilter] = useState<string>("all");
  const [onlyWithImage, setOnlyWithImage] = useState(false);
  const [sortBy, setSortBy] = useState<string>("id_asc");
  const [page, setPage] = useState(1);
  const pageSize = 24;

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

    // 3. Filter Career
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
  }, [search, qualityFilter, careerFilter, raceFilter, onlyWithImage, sortBy]);

  // Reset page to 1 when filters change
  useEffect(() => {
    setPage(1);
  }, [search, qualityFilter, careerFilter, raceFilter, onlyWithImage, sortBy]);

  const totalPages = Math.ceil(filteredHeroes.length / pageSize) || 1;
  const paginatedHeroes = filteredHeroes.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  return (
    <div className="space-y-6">
      
      {/* Breadcrumbs */}
      <Breadcrumbs items={[{ label: "Danh Sách Tướng" }]} />

      {/* Header Banner */}
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-purple-950/40 via-gray-900 to-gray-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white flex items-center gap-3">
            <span>👤</span> Danh Sách 721 Bản Thể Tướng
          </h1>
          <p className="text-xs sm:text-sm text-gray-400 mt-1.5 max-w-2xl">
            Kho dữ liệu phân biệt rõ ràng từng bản thể riêng biệt (`id`), tránh gộp nhầm các biến thể sao hoặc dạng tiến hóa khác nhau.
          </p>
        </div>

        <div className="flex items-center gap-3 text-xs bg-gray-950/80 px-3.5 py-2 rounded-xl border border-gray-800">
          <span className="text-gray-400">Kết quả khớp:</span>
          <span className="font-bold text-indigo-400 text-sm">
            {filteredHeroes.length} / {heroesData.length}
          </span>
        </div>
      </div>

      {/* Filter & Search Bar Controls */}
      <div className="p-4 sm:p-5 rounded-xl border border-gray-800 bg-gray-900/60 backdrop-blur-xl space-y-4">
        
        {/* Search Input */}
        <div className="relative">
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Tìm theo tên tướng (Sasuke, Luffy, Goku...) hoặc mã ID..."
            className="w-full bg-gray-950 border border-gray-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-gray-500 focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500"
          />
          <span className="absolute left-3.5 top-3 text-gray-500">🔍</span>
          {search && (
            <button
              onClick={() => setSearch("")}
              className="absolute right-3 top-2.5 text-gray-400 hover:text-white text-sm"
            >
              ✕
            </button>
          )}
        </div>

        {/* Filter Row */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 gap-3 text-xs">
          
          {/* Quality Filter */}
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Phẩm chất</label>
            <select
              value={qualityFilter}
              onChange={(e) => setQualityFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-indigo-500"
            >
              <option value="all">Tất cả phẩm chất</option>
              <option value="5">Phẩm 5 (Đỏ)</option>
              <option value="4">Phẩm 4 (Cam)</option>
              <option value="3">Phẩm 3 (Tím)</option>
              <option value="2">Phẩm 2 (Lam)</option>
              <option value="1">Phẩm 1 (Lục)</option>
            </select>
          </div>

          {/* Career Filter */}
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Nghề (Career)</label>
            <select
              value={careerFilter}
              onChange={(e) => setCareerFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-indigo-500"
            >
              <option value="all">Tất cả nghề</option>
              <option value="1">Nghề 1</option>
              <option value="2">Nghề 2</option>
              <option value="3">Nghề 3</option>
              <option value="4">Nghề 4</option>
              <option value="5">Nghề 5</option>
            </select>
          </div>

          {/* Race Filter */}
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Hệ/Tộc (Race)</label>
            <select
              value={raceFilter}
              onChange={(e) => setRaceFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-indigo-500"
            >
              <option value="all">Tất cả hệ tộc</option>
              <option value="1">Tộc 1</option>
              <option value="2">Tộc 2</option>
              <option value="3">Tộc 3</option>
              <option value="4">Tộc 4</option>
              <option value="5">Tộc 5</option>
            </select>
          </div>

          {/* Sort By */}
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Sắp xếp theo</label>
            <select
              value={sortBy}
              onChange={(e) => setSortBy(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-indigo-500"
            >
              <option value="id_asc">ID tăng dần</option>
              <option value="id_desc">ID giảm dần</option>
              <option value="quality_desc">Phẩm chất cao nhất</option>
              <option value="hp_desc">HP cao nhất</option>
              <option value="patk_desc">Vật công cao nhất</option>
              <option value="speed_desc">Tốc độ cao nhất</option>
            </select>
          </div>

          {/* Only with Image Toggle */}
          <div className="flex items-end pb-1">
            <label className="flex items-center gap-2 cursor-pointer text-gray-300 hover:text-white select-none">
              <input
                type="checkbox"
                checked={onlyWithImage}
                onChange={(e) => setOnlyWithImage(e.target.checked)}
                className="w-4 h-4 rounded bg-gray-950 border-gray-700 text-indigo-600 focus:ring-indigo-500 focus:ring-offset-gray-900"
              />
              <span>Chỉ hiện có ảnh ({heroesData.filter((h) => h.has_image).length})</span>
            </label>
          </div>

        </div>

      </div>

      {/* Heroes Grid */}
      {paginatedHeroes.length === 0 ? (
        <div className="p-12 text-center border border-gray-800 rounded-2xl bg-gray-900/30 text-gray-400">
          <div className="text-4xl mb-3">🔍</div>
          <div className="text-base font-semibold text-gray-200">Không tìm thấy tướng phù hợp</div>
          <p className="text-xs text-gray-500 mt-1">
            Thử thay đổi từ khóa tìm kiếm hoặc bỏ chọn một số tiêu chí bộ lọc phía trên.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {paginatedHeroes.map((hero) => {
            const qConfig = getQualityConfig(hero.quality);
            return (
              <Link
                key={hero.id}
                href={`/heroes/${hero.id}`}
                className="p-4 rounded-xl border border-gray-800/80 bg-gray-900/40 hover:bg-gray-850 hover:border-gray-700 transition-all hover:-translate-y-1 hover:shadow-lg flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center gap-3 mb-3">
                    <div className="w-14 h-14 rounded-xl overflow-hidden border border-gray-700/80 bg-gray-950 flex-shrink-0 group-hover:scale-105 transition-transform">
                      <ImageWithFallback
                        src={hero.avatar}
                        alt={hero.name}
                        className="w-full h-full object-cover"
                        fallbackText="No Pic"
                        fallbackIcon="👤"
                      />
                    </div>
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-1.5 mb-0.5">
                        <span className="text-[10px] font-mono text-gray-400">
                          #{hero.id}
                        </span>
                        <span
                          className={`text-[9px] px-1.5 py-0.2 rounded border font-semibold ${qConfig.badgeClass}`}
                        >
                          Phẩm {hero.quality}
                        </span>
                      </div>
                      <h3 className="font-bold text-white text-sm truncate group-hover:text-indigo-400 transition-colors">
                        {hero.name}
                      </h3>
                      <div className="text-[11px] text-amber-400 font-medium flex items-center gap-1">
                        <img
                          src="/assets/card/public_equip_star.png"
                          alt="Sao"
                          className="w-3.5 h-3.5 object-contain filter drop-shadow"
                        />
                        <span>{hero.star} / {hero.star_max} Sao</span>
                      </div>
                    </div>
                  </div>

                  {/* Quick Stats Grid */}
                  <div className="grid grid-cols-3 gap-1 py-2 px-2.5 rounded-lg bg-gray-950/70 border border-gray-800 text-center text-[10px]">
                    <div>
                      <div className="text-gray-500 uppercase">HP</div>
                      <div className="font-bold text-gray-200">
                        {hero.hp?.toLocaleString()}
                      </div>
                    </div>
                    <div>
                      <div className="text-gray-500 uppercase">V.Công</div>
                      <div className="font-bold text-gray-200">
                        {hero.patk?.toLocaleString()}
                      </div>
                    </div>
                    <div>
                      <div className="text-gray-500 uppercase">Tốc độ</div>
                      <div className="font-bold text-gray-200">
                        {hero.speed?.toLocaleString()}
                      </div>
                    </div>
                  </div>
                </div>

                <div className="mt-3 pt-2.5 border-t border-gray-800/60 flex items-center justify-between text-[11px] text-gray-400">
                  <span>Nghề {hero.career} • Tộc {hero.race}</span>
                  <span className="text-indigo-400 font-semibold group-hover:translate-x-1 transition-transform">
                    Chi tiết ➔
                  </span>
                </div>
              </Link>
            );
          })}
        </div>
      )}

      {/* Pagination Controls */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between pt-6 border-t border-gray-800 text-xs text-gray-400">
          <div>
            Hiển thị{" "}
            <span className="text-white font-medium">
              {(page - 1) * pageSize + 1} -{" "}
              {Math.min(page * pageSize, filteredHeroes.length)}
            </span>{" "}
            trong tổng số{" "}
            <span className="text-white font-medium">{filteredHeroes.length}</span> tướng
          </div>

          <div className="flex items-center gap-1.5">
            <button
              onClick={() => setPage(1)}
              disabled={page === 1}
              className="px-2.5 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40 disabled:pointer-events-none"
            >
              ««
            </button>
            <button
              onClick={() => setPage((p) => Math.max(p - 1, 1))}
              disabled={page === 1}
              className="px-3 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40 disabled:pointer-events-none"
            >
              Trước
            </button>
            <span className="px-3 py-1.5 font-bold text-white bg-gray-950 border border-gray-800 rounded-lg">
              {page} / {totalPages}
            </span>
            <button
              onClick={() => setPage((p) => Math.min(p + 1, totalPages))}
              disabled={page === totalPages}
              className="px-3 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40 disabled:pointer-events-none"
            >
              Sau
            </button>
            <button
              onClick={() => setPage(totalPages)}
              disabled={page === totalPages}
              className="px-2.5 py-1.5 rounded-lg bg-gray-900 border border-gray-800 hover:bg-gray-800 disabled:opacity-40 disabled:pointer-events-none"
            >
              »»
            </button>
          </div>
        </div>
      )}

    </div>
  );
}
