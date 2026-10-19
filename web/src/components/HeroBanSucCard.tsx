// web/src/components/HeroBanSucCard.tsx
"use client";

import React from "react";
import Link from "next/link";

export interface BanSucSubItem {
  id: string;
  name: string;
  icon?: string | null;
  url?: string;
}

export interface BanSucRecItem {
  id?: string;
  name?: string;
  icon?: string | null;
  url?: string;
  condition?: string | null;
  custom_text?: string | null;
  is_hp_addition?: boolean;
  min_rebirth_stage?: number;
  hp_note?: string | null;
  is_slash?: boolean;
  label?: string;
  sub_items?: BanSucSubItem[];
}

export interface HeroBanSucCardProps {
  heroId: string;
  currentRebirthStage?: number;
  recommendationData?: {
    group_name: string;
    is_unlisted?: boolean;
    status: "ready" | "pending_update";
    recommendations: BanSucRecItem[];
    hp_scaling_evidence?: {
      has_hp_mechanic: boolean;
      min_rebirth_stage?: number;
      skill_or_stage?: string | null;
      description?: string | null;
      status: string;
      added_than_thu?: boolean;
      note?: string | null;
    } | null;
  } | null;
  className?: string;
}

export default function HeroBanSucCard({
  heroId,
  currentRebirthStage = 0,
  recommendationData,
  className = "",
}: HeroBanSucCardProps) {
  // Filter recommendations based on active rebirth stage
  // (e.g. Thần Thư requiring CS4 only unlocks when user selects stage >= 4)
  const activeRecommendations = (recommendationData?.recommendations || []).filter((item) => {
    if (item.min_rebirth_stage !== undefined && item.min_rebirth_stage !== null && item.min_rebirth_stage > 0) {
      return currentRebirthStage >= item.min_rebirth_stage;
    }
    return true;
  });

  const isPending =
    !recommendationData ||
    recommendationData.status === "pending_update" ||
    activeRecommendations.length === 0;

  return (
    <div
      className={`rounded-2xl border border-sky-500/25 bg-gradient-to-br from-slate-950/90 via-slate-900/80 to-[#070e1b]/90 p-3 sm:p-4 backdrop-blur shadow-xl space-y-2.5 max-w-full overflow-hidden ${className}`}
    >
      {/* Header bar */}
      <div className="flex flex-wrap items-center justify-between gap-2 border-b border-slate-800/80 pb-2">
        <div className="flex items-center gap-2">
          <span className="text-base sm:text-lg">💎</span>
          <h3 className="text-xs sm:text-sm font-extrabold text-white tracking-wide uppercase flex items-center gap-1.5">
            <span>Ban Sức Khuyến Nghị</span>
          </h3>
          <span className="text-[10px] font-bold text-sky-300 bg-sky-950/80 px-2 py-0.5 rounded-full border border-sky-500/30 font-sans">
            Cẩm nang
          </span>
        </div>

        <Link
          href="/ban-suc"
          className="text-[11px] font-semibold text-sky-400 hover:text-sky-300 transition-colors flex items-center gap-1 group"
        >
          <span>Chi tiết 10 Hệ Ban Sức</span>
          <span className="group-hover:translate-x-0.5 transition-transform">→</span>
        </Link>
      </div>

      {/* Main Content */}
      {isPending ? (
        <div className="flex flex-wrap items-center gap-2.5 py-1">
          <span className="inline-flex items-center gap-1.5 rounded-xl border border-slate-700/80 bg-slate-900/90 px-3 py-1.5 text-xs text-slate-300 italic shadow-sm">
            <span>⏳</span>
            <span className="font-semibold">Đang cập nhật</span>
          </span>
          <span className="text-[11px] text-slate-400 leading-relaxed">
            Chưa có gợi ý ban sức cho mốc này trong cẩm nang người chơi.
          </span>
        </div>
      ) : (
        <div className="space-y-2 max-w-full">
          {/* List of Recommendation Chips */}
          <div className="flex flex-wrap items-center gap-2 pt-0.5 max-w-full">
            {activeRecommendations.map((item, idx) => {
              // Slash choice (e.g. Tinh Thần / Khởi Nguyên, Lãnh Chúa / Vương Toạ, Titan / Quang Niên)
              if (item.is_slash && item.sub_items && item.sub_items.length > 0) {
                const subItems = item.sub_items;
                return (
                  <div
                    key={idx}
                    className="inline-flex flex-wrap items-center gap-1 rounded-xl border border-slate-700/80 bg-slate-900/90 px-2.5 py-1.5 shadow-sm text-xs font-semibold hover:border-slate-600 transition-colors"
                  >
                    {subItems.map((sub, sIdx) => (
                      <React.Fragment key={sub.id}>
                        <Link
                          href={sub.url || "/ban-suc"}
                          className="group inline-flex items-center gap-1 px-1.5 py-0.5 rounded-lg hover:bg-slate-800 text-slate-200 hover:text-sky-300 transition-colors"
                          title={`Xem chi tiết Ban Sức ${sub.name}`}
                        >
                          {sub.icon && (
                            <img
                              src={sub.icon}
                              alt={sub.name}
                              className="w-4 h-4 object-contain filter drop-shadow group-hover:scale-110 transition-transform"
                            />
                          )}
                          <span>{sub.name}</span>
                        </Link>
                        {sIdx < subItems.length - 1 && (
                          <span className="text-slate-500 font-bold px-0.5 select-none">/</span>
                        )}
                      </React.Fragment>
                    ))}
                    {item.condition && (
                      <span className="text-[10px] text-amber-300 font-mono pl-1 border-l border-slate-700/80 ml-0.5">
                        {item.condition}
                      </span>
                    )}
                  </div>
                );
              }

              // Standard Chip: Clean display with Icon, Name, Link & short user condition
              return (
                <Link
                  key={idx}
                  href={item.url || "/ban-suc"}
                  className="group inline-flex items-center gap-1.5 rounded-xl border border-slate-700/80 bg-slate-900/90 px-3 py-1.5 text-xs font-semibold text-slate-200 hover:border-sky-400 hover:bg-slate-800 hover:text-white transition-all duration-200 shadow-sm"
                  title={`Xem chi tiết Ban Sức ${item.name}`}
                >
                  {item.icon && (
                    <img
                      src={item.icon}
                      alt={item.name || "Ban sức"}
                      className="w-4 h-4 object-contain filter drop-shadow group-hover:scale-110 transition-transform"
                    />
                  )}
                  <span>{item.name}</span>

                  {/* Only display user-specified conditions (e.g. Goku Gogeta/Vegeta notes, Broli directions) */}
                  {item.condition && (
                    <span className="text-[10px] text-amber-300 font-mono font-normal">
                      ({item.condition})
                    </span>
                  )}
                </Link>
              );
            })}
          </div>
        </div>
      )}
    </div>
  );
}
