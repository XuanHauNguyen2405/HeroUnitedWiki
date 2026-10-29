// web/src/app/equipment/page.tsx
"use client";

import React, { useState, useMemo, useEffect } from "react";
import Link from "next/link";
import ElementBadge from "@/components/ElementBadge";
import { EquipmentStatLine } from "@/components/EquipmentDetails";
import { elements } from "@/lib/game-attributes";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { stripVietnameseAccents, getQualityConfig } from "@/lib/utils";
import equipmentCatalog from "@/data/equipment_catalog.json";

export default function EquipmentPage() {
  const [search, setSearch] = useState("");
  const [elementFilter, setElementFilter] = useState("all");
  const [slotFilter, setSlotFilter] = useState("all");
  const [qualityFilter, setQualityFilter] = useState("all");
  const [suitFilter, setSuitFilter] = useState("all"); // all, suited, unsuited
  const [page, setPage] = useState(1);
  const pageSize = 24;

  const filteredEquipment = useMemo(() => {
    let list = equipmentCatalog as any[];
    if (elementFilter !== "all") list = list.filter(eq => elementFilter === "unknown" ? !eq.element_id : eq.element_id === elementFilter);

    if (search.trim()) {
      const cleanSearch = stripVietnameseAccents(search);
      const rawSearch = search.toLowerCase().trim();
      list = list.filter(
        (eq) =>
          stripVietnameseAccents(eq.name).includes(cleanSearch) ||
          eq.name?.toLowerCase().includes(rawSearch) ||
          String(eq.id).includes(cleanSearch) ||
          String(eq.equip_id).includes(cleanSearch) ||
          (eq.suit_name && stripVietnameseAccents(eq.suit_name).includes(cleanSearch))
      );
    }

    if (slotFilter !== "all") {
      const s = parseInt(slotFilter, 10);
      list = list.filter((eq) => eq.slot === s);
    }

    if (qualityFilter !== "all") {
      const q = parseInt(qualityFilter, 10);
      list = list.filter((eq) => eq.quality === q);
    }

    if (suitFilter === "suited") {
      list = list.filter((eq) => eq.suit_id !== null && eq.suit_id !== "0");
    } else if (suitFilter === "unsuited") {
      list = list.filter((eq) => eq.suit_id === null || eq.suit_id === "0");
    }

    return list;
  }, [elementFilter, search, slotFilter, qualityFilter, suitFilter]);

  useEffect(() => {
    setPage(1);
  }, [elementFilter, search, slotFilter, qualityFilter, suitFilter]);

  const totalPages = Math.ceil(filteredEquipment.length / pageSize) || 1;
  const paginatedEquips = filteredEquipment.slice(
    (page - 1) * pageSize,
    page * pageSize
  );

  return (
    <div className="space-y-6">
      <Breadcrumbs items={[{ label: "Kho Trang Bị" }]} />

      <label className="block text-sm text-slate-300 space-y-2"><span>Lọc thuộc tính theo bộ</span>
        <select aria-label="Lọc thuộc tính theo bộ" className="hero-control" value={elementFilter} onChange={e => setElementFilter(e.target.value)}>
          <option value="all">Tất cả thuộc tính</option>
          {Object.values(elements).map(e => <option key={e.id} value={e.id}>{e.name}</option>)}
          <option value="unknown">Chưa xác minh thuộc tính</option>
        </select>
      </label>
      {/* Header */}
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-blue-950/40 via-gray-900 to-gray-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white flex items-center gap-3">
            <span>⚔️</span> Kho 4.366 Trang Bị
          </h1>
          <p className="text-xs sm:text-sm text-gray-400 mt-1 max-w-2xl">
            Đầy đủ 4 vị trí đã xác minh (Vũ khí, Trang sức, Giáp/Áo, Giày). Phân biệt rõ nhánh trang bị cơ sở (equip_id) và bộ trang bị trực thuộc.
          </p>
        </div>
        <div className="text-xs bg-gray-950/80 px-3.5 py-2 rounded-xl border border-gray-800">
          <span className="text-gray-400">Kết quả khớp:</span>{" "}
          <span className="font-bold text-blue-400 text-sm">
            {filteredEquipment.length} / {equipmentCatalog.length}
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
            placeholder="Tìm theo tên món (Đao Ninja, Kiếm Kusanagi...), ID trang bị (16401), tên bộ..."
            className="w-full bg-gray-950 border border-gray-700/80 rounded-xl px-4 py-2.5 pl-10 text-sm text-white placeholder-gray-500 focus:outline-none focus:border-blue-500"
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

        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 text-xs">
          <div>
            <label className="block text-gray-400 mb-1 font-medium">Vị Trí Trang Bị</label>
            <select
              value={slotFilter}
              onChange={(e) => setSlotFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-blue-500"
            >
              <option value="all">Tất cả vị trí</option>
              <option value="1">Slot 1: Vũ khí</option>
              <option value="2">Slot 2: Trang sức</option>
              <option value="3">Slot 3: Giáp / Áo</option>
              <option value="4">Slot 4: Giày</option>
            </select>
          </div>

          <div>
            <label className="block text-gray-400 mb-1 font-medium">Phẩm Chất</label>
            <select
              value={qualityFilter}
              onChange={(e) => setQualityFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-blue-500"
            >
              <option value="all">Tất cả phẩm chất</option>
              <option value="5">Phẩm 5 (Đỏ)</option>
              <option value="4">Phẩm 4 (Cam)</option>
              <option value="3">Phẩm 3 (Tím)</option>
              <option value="2">Phẩm 2 (Lam)</option>
              <option value="1">Phẩm 1 (Lục)</option>
            </select>
          </div>

          <div>
            <label className="block text-gray-400 mb-1 font-medium">Phân Loại Bộ</label>
            <select
              value={suitFilter}
              onChange={(e) => setSuitFilter(e.target.value)}
              className="w-full bg-gray-950 border border-gray-800 rounded-lg p-2 text-gray-200 focus:outline-none focus:border-blue-500"
            >
              <option value="all">Tất cả (Có bộ & Lẻ)</option>
              <option value="suited">Thuộc bộ trang bị (4.233)</option>
              <option value="unsuited">Trang bị độc lập / Lẻ (133)</option>
            </select>
          </div>
        </div>
      </div>

      {/* Equipment Grid */}
      {paginatedEquips.length === 0 ? (
        <div className="p-12 text-center border border-gray-800 rounded-2xl bg-gray-900/30 text-gray-400">
          Không tìm thấy trang bị phù hợp.
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
          {paginatedEquips.map((eq: any) => {
            const qConfig = getQualityConfig(eq.quality);
            return (
              <Link
                key={eq.id}
                href={`/equipment/${eq.id}`}
                className="p-4 rounded-xl border border-gray-800/80 bg-gray-900/40 hover:bg-gray-850 hover:border-gray-700 transition-all hover:-translate-y-1 hover:shadow-lg flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center gap-3 mb-2.5">
                    <div className="w-12 h-12 rounded-xl overflow-hidden border border-gray-700 bg-gray-950 flex-shrink-0 group-hover:scale-105 transition-transform">
                      <ImageWithFallback
                        src={eq.icon}
                        alt={eq.name}
                        className="w-full h-full object-cover"
                        fallbackText="No Pic"
                        fallbackIcon="⚔️"
                      />
                    </div>
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-1.5 mb-0.5">
                        <span className="text-[10px] font-mono text-gray-400">#{eq.id}</span>
                        <span className={`text-[9px] px-1.5 py-0.2 rounded border font-semibold ${qConfig.badgeClass}`}>
                          Phẩm {eq.quality}
                        </span>
                      </div>
                      <h3 className="font-bold text-white text-sm truncate group-hover:text-blue-400 transition-colors">
                        {eq.name}
                      </h3>
                      <div className="text-[10px] text-gray-400 truncate">
                        Slot {eq.slot}: {eq.slot_name}
                      </div>
                    </div>
                  </div>

                  {/* Suit Link / Unsuited */}
                  <div className="text-[11px] mb-2">
                    {eq.suit_id ? (
                      <span className="text-emerald-400 bg-emerald-950/40 px-2 py-0.5 rounded border border-emerald-800/60 inline-block truncate max-w-full">
                        🛡️ Bộ: {eq.suit_name || `#${eq.suit_id}`}
                      </span>
                    ) : (
                      <span className="text-gray-500 bg-gray-950 px-2 py-0.5 rounded border border-gray-800 inline-block">
                        Độc lập (Không thuộc bộ)
                      </span>
                    )}
                  </div>

                  <ElementBadge id={eq.element_id} />
                  {/* Stats snippet */}
                  <div className="text-[10px] text-gray-400 bg-gray-950/60 p-2 rounded-lg border border-gray-800 space-y-0.5">
                    {eq.primary_stat && (
                      <div className="truncate">
                        <EquipmentStatLine stat={eq.primary_stat} />
                      </div>
                    )}
                    {eq.secondary_stat && (
                      <div className="truncate">
                        <EquipmentStatLine stat={eq.secondary_stat} />
                      </div>
                    )}
                  </div>
                </div>

                <div className="mt-3 pt-2 border-t border-gray-800/60 flex items-center justify-between text-[11px] text-gray-400">
                  <span>Phôi: {eq.equip_id}</span>
                  <span className="text-blue-400 font-semibold group-hover:translate-x-1 transition-transform">
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
            {filteredEquipment.length} trang bị)
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
