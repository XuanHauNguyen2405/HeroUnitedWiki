// web/src/app/skills/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { stripVietnameseAccents, getQualityConfig } from "@/lib/utils";
import skillsCatalog from "@/data/skills_catalog.json";

export default function SkillsPage() {
  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("all");
  const [qualityFilter, setQualityFilter] = useState("all");
  const [page, setPage] = useState(1);
  const pageSize = 24;

  // Extract distinct skill types
  const skillTypes = useMemo(() => {
    const set = new Set<string>();
    skillsCatalog.forEach((s: any) => {
      if (s.skill_type) set.add(s.skill_type);
    });
    return Array.from(set).sort();
  }, []);

  // Filter skills
  const filteredSkills = useMemo(() => {
    let list = skillsCatalog as any[];

    if (search.trim()) {
      const cleanSearch = stripVietnameseAccents(search);
      const rawSearch = search.toLowerCase().trim();
      list = list.filter(
        (s) =>
          stripVietnameseAccents(s.name).includes(cleanSearch) ||
          s.name?.toLowerCase().includes(rawSearch) ||
          String(s.id).includes(cleanSearch)
      );
    }

    if (typeFilter !== "all") {
      list = list.filter((s) => s.skill_type === typeFilter);
    }

    if (qualityFilter !== "all") {
      const q = parseInt(qualityFilter, 10);
      list = list.filter((s) => s.quality === q);
    }

    return list;
  }, [search, typeFilter, qualityFilter]);

  useEffect(() => {
    setPage(1);
  }, [search, typeFilter, qualityFilter]);

  const totalPages = Math.ceil(filteredSkills.length / pageSize) || 1;
  const paginatedSkills = filteredSkills.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  return (
    <div className="space-y-6">
      <Breadcrumbs items={[{ label: "Tra Cứu Kỹ Năng" }]} />

      {/* Header */}
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-amber-950/40 via-gray-900 to-gray-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white flex items-center gap-3">
            <span>⚡</span> Kho 10.836 Kỹ Năng & Chiêu Thức
          </h1>
          <p className="text-xs sm:text-sm text-gray-400 mt-1 max-w-2xl">
            Tra cứu thông số gốc, CD, tỉ lệ kích hoạt và chuỗi tiến cấp giai đoạn. Không suy đoán công thức khi chưa có xác minh.
          </p>
        </div>
        <div className="text-xs bg-gray-950/80 px-3.5 py-2 rounded-xl border border-gray-800">
          <span className="text-gray-400">Kết quả khớp:</span>{" "}
          <span className="font-bold text-amber-400 text-sm">
            {filteredSkills.length} / {skillsCatalog.length}
          </span>
        </div>
      </div>

      {/* Controls */}
      <div className="p-4 sm:p-5 rounded-xl border border-gray-800 bg-gray-900/60 backdrop-blur-xl space-y-4">
        <div className="relative">
          <input
            type="text"
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            placeholder="Tìm theo tên chiêu thức (Chidori, Rasengan, Hỏa Cầu...), ID kỹ năng..."
            className="w-full bg-gray-950 border border-gray-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-gray-500 focus:outline-none focus:border-amber-500"
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

        <div className="grid grid-cols-2 sm:grid-cols-3 gap-3 text-xs">
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Loại Kỹ Năng</label>
            <select
              value={typeFilter}
              onChange={(e) => setTypeFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-amber-500"
            >
              <option value="all">Tất cả loại kỹ năng ({skillTypes.length})</option>
              {skillTypes.map((t) => (
                <option key={t} value={t}>
                  {t}
                </option>
              ))}
            </select>
          </div>

          <div>
            <label className="block text-gray-400 mb-1 font-medium">Phẩm Chất</label>
            <select
              value={qualityFilter}
              onChange={(e) => setQualityFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-amber-500"
            >
              <option value="all">Tất cả phẩm chất</option>
              <option value="5">Phẩm 5 (Cam/Đỏ)</option>
              <option value="4">Phẩm 4 (Tím)</option>
              <option value="3">Phẩm 3 (Lam đậm)</option>
              <option value="2">Phẩm 2 (Lam)</option>
              <option value="1">Phẩm 1 (Lục)</option>
            </select>
          </div>
        </div>
      </div>

      {/* Skills Grid */}
      {paginatedSkills.length === 0 ? (
        <div className="p-12 text-center border border-gray-800 rounded-2xl bg-gray-900/30 text-gray-400">
          Không tìm thấy kỹ năng phù hợp.
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {paginatedSkills.map((sk: any) => {
            const qConfig = getQualityConfig(sk.quality);
            return (
              <Link
                key={sk.id}
                href={`/skills/${sk.id}`}
                className="p-4 rounded-xl border border-gray-800/80 bg-gray-900/40 hover:bg-gray-850 hover:border-gray-700 transition-all hover:-translate-y-1 hover:shadow-lg flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center gap-3 mb-2.5">
                    <div className="w-12 h-12 rounded-xl overflow-hidden border border-gray-700 bg-gray-950 flex-shrink-0 group-hover:scale-105 transition-transform">
                      <ImageWithFallback
                        src={sk.icon}
                        alt={sk.name}
                        className="w-full h-full object-cover"
                        fallbackText="No Pic"
                        fallbackIcon="⚡"
                      />
                    </div>
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-1.5 mb-0.5">
                        <span className="text-[10px] font-mono text-gray-400">#{sk.id}</span>
                        <span className={`text-[9px] px-1.5 py-0.2 rounded border font-semibold ${qConfig.badgeClass}`}>
                          Phẩm {sk.quality}
                        </span>
                      </div>
                      <h3 className="font-bold text-white text-sm truncate group-hover:text-amber-400 transition-colors">
                        {sk.name}
                      </h3>
                      <div className="text-[10px] text-gray-400 truncate">
                        {sk.skill_type || "Chưa phân loại"}
                      </div>
                    </div>
                  </div>

                  <div className="flex items-center gap-2 text-[11px] text-gray-400 mb-2">
                    <span>cd: <b className="text-gray-200">{sk.cd}</b></span>
                    <span>•</span>
                    <span>pre_cd: <b className="text-gray-200">{sk.pre_cd}</b></span>
                    <span>•</span>
                    <span>rate: <b className="text-gray-200">{sk.rate}%</b></span>
                  </div>

                  <p className="text-xs text-gray-300 bg-gray-950/60 p-2.5 rounded-lg border border-gray-800 line-clamp-2 leading-relaxed">
                    {sk.description}
                  </p>
                </div>

                <div className="mt-3 pt-2 border-t border-gray-800/60 flex items-center justify-between text-[11px] text-gray-400">
                  <span>Cấp tối đa: {sk.max_lv}</span>
                  <span className="text-amber-400 font-semibold group-hover:translate-x-1 transition-transform">
                    Chi tiết ➔
                  </span>
                </div>
              </Link>
            );
          })}
        </div>
      )}

      {/* Pagination */}
      {totalPages > 1 && (
        <div className="flex items-center justify-between pt-6 border-t border-gray-800 text-xs text-gray-400">
          <div>
            Trang <span className="text-white font-bold">{page}</span> / {totalPages} (
            {filteredSkills.length} kỹ năng)
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
