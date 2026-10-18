// web/src/components/BanSucView.tsx
"use client";

import { useState, useMemo } from "react";
import { stripVietnameseAccents } from "@/lib/utils";

interface BanSucViewProps {
  data: {
    fate_rules: Array<{ id: string; sort: number; text: string }>;
    fate_skills: Record<string, any>;
    badges: Record<string, any>;
    badge_rules: Array<{ id: string; sort: number; name: string; description: string }>;
    badge_combinations: Record<string, any>;
  };
}

export default function BanSucView({ data }: BanSucViewProps) {
  const [activeTab, setActiveTab] = useState<"fate" | "synergy" | "badges" | "rules">("fate");
  const [searchQuery, setSearchQuery] = useState("");

  const fateRules = data.fate_rules || [];
  const generalRule = fateRules[0] || null;
  const gemSets = fateRules.slice(1);

  const badgesList = useMemo(() => {
    return Object.values(data.badges || {});
  }, [data.badges]);

  const filteredBadges = useMemo(() => {
    if (!searchQuery.trim()) return badgesList;
    const cleanQ = stripVietnameseAccents(searchQuery);
    return badgesList.filter((b) => {
      const cleanName = stripVietnameseAccents(b.name || "");
      const cleanChar = stripVietnameseAccents(b.character_name || "");
      return cleanName.includes(cleanQ) || cleanChar.includes(cleanQ) || b.id === cleanQ;
    });
  }, [badgesList, searchQuery]);

  const synergyRules = (data.badge_rules || []).filter((r) =>
    ["Anh Hùng tập kết", "Ngọc Rồng", "Nữ Thần"].some((k) => r.name?.includes(k))
  );

  return (
    <div className="space-y-8 animate-fade-in">
      {/* Navigation Tabs */}
      <div className="flex flex-wrap gap-2 border-b border-slate-800 pb-4">
        <button
          onClick={() => setActiveTab("fate")}
          className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-semibold transition-all ${
            activeTab === "fate"
              ? "bg-sky-500 text-white shadow-lg shadow-sky-500/25"
              : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
          }`}
        >
          <span>💎</span>
          <span>Ban Sức Vận Mệnh (10 Hệ)</span>
        </button>

        <button
          onClick={() => setActiveTab("synergy")}
          className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-semibold transition-all ${
            activeTab === "synergy"
              ? "bg-purple-600 text-white shadow-lg shadow-purple-600/25"
              : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
          }`}
        >
          <span>⚡</span>
          <span>Tổ Hợp Kỹ Năng Đội Hình</span>
        </button>

        <button
          onClick={() => setActiveTab("badges")}
          className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-semibold transition-all ${
            activeTab === "badges"
              ? "bg-amber-600 text-white shadow-lg shadow-amber-600/25"
              : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
          }`}
        >
          <span>🎖️</span>
          <span>Huy Hiệu Anh Hùng ({badgesList.length})</span>
        </button>

        <button
          onClick={() => setActiveTab("rules")}
          className={`flex items-center gap-2 rounded-xl px-5 py-2.5 text-sm font-semibold transition-all ${
            activeTab === "rules"
              ? "bg-emerald-600 text-white shadow-lg shadow-emerald-600/25"
              : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
          }`}
        >
          <span>📜</span>
          <span>Quy Tắc Tinh Luyện</span>
        </button>
      </div>

      {/* TAB 1: BAN SỨC VẬN MỆNH */}
      {activeTab === "fate" && (
        <div className="space-y-8">
          {/* General Rules Box */}
          {generalRule && (
            <div className="rounded-2xl border border-sky-500/30 bg-sky-950/20 p-6 backdrop-blur">
              <h2 className="text-lg font-bold text-sky-400 flex items-center gap-2 mb-3">
                <span>📘</span> Quy Tắc Ban Sức Vận Mệnh (Nguyên Bản)
              </h2>
              <div className="space-y-2 text-sm text-slate-300 whitespace-pre-line leading-relaxed font-sans">
                {generalRule.text}
              </div>
            </div>
          )}

          {/* 10 Fate Gem Sets */}
          <div>
            <h2 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
              <span className="h-2 w-2 rounded-full bg-sky-500" />
              10 Hệ Hiệu Ứng Đá Vận Mệnh (Set 4 Viên)
            </h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              {gemSets.map((set, idx) => {
                const lines = set.text.split("\n");
                const titleLine = lines[0] || `Hệ Ban Sức #${set.id}`;
                const effectLines = lines.slice(1);

                return (
                  <div
                    key={set.id || idx}
                    className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur hover:border-slate-700 transition-colors"
                  >
                    <div className="flex items-center justify-between mb-3 border-b border-slate-800 pb-3">
                      <h3 className="font-bold text-sky-400 text-base">{titleLine}</h3>
                      <span className="rounded-full border border-slate-700 bg-slate-800 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
                        Mã: {set.id}
                      </span>
                    </div>

                    <div className="space-y-2 text-xs md:text-sm text-slate-300 leading-relaxed whitespace-pre-line">
                      {effectLines.join("\n")}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}

      {/* TAB 2: TỔ HỢP KỸ NĂNG HUY HIỆU */}
      {activeTab === "synergy" && (
        <div className="space-y-6">
          <div className="rounded-xl border border-purple-500/30 bg-purple-950/20 p-4 text-sm text-purple-300">
            Kỹ năng kết hợp của Huy Hiệu trong một trận đấu sẽ được kích hoạt tối đa 3 kỹ năng dựa theo đội hình ra trận.
          </div>

          <div className="grid grid-cols-1 gap-6">
            {synergyRules.map((r) => (
              <div
                key={r.id}
                className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur"
              >
                <div className="flex items-center justify-between mb-3 border-b border-slate-800 pb-3">
                  <h3 className="text-lg font-bold text-purple-400 flex items-center gap-2">
                    <span>✨</span> {r.name}
                  </h3>
                  <span className="rounded-full border border-slate-700 bg-slate-800 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
                    ID: {r.id}
                  </span>
                </div>
                <div className="text-sm text-slate-200 whitespace-pre-line leading-relaxed">
                  {r.description}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* TAB 3: HUY HIỆU ANH HÙNG */}
      {activeTab === "badges" && (
        <div className="space-y-6">
          {/* Search Bar for Badges */}
          <div className="flex flex-col sm:flex-row items-center gap-4 justify-between">
            <div className="relative w-full sm:w-80">
              <input
                type="text"
                placeholder="Tìm huy hiệu hoặc tên tướng..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full rounded-xl border border-slate-700 bg-slate-900/80 px-4 py-2.5 pl-10 text-sm text-white placeholder-slate-500 focus:border-amber-500 focus:outline-none"
              />
              <span className="absolute left-3 top-3 text-slate-500">🔍</span>
            </div>

            <div className="text-xs text-slate-400">
              Hiển thị <span className="font-bold text-white">{filteredBadges.length}</span> / {badgesList.length} huy hiệu
            </div>
          </div>

          {/* Badges Grid */}
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredBadges.slice(0, 60).map((b) => (
              <div
                key={b.id}
                className="rounded-xl border border-slate-800 bg-slate-900/40 p-4 backdrop-blur hover:border-slate-700 transition-colors space-y-2"
              >
                <div className="flex items-start justify-between gap-2">
                  <h4 className="font-bold text-white text-sm line-clamp-1">{b.name}</h4>
                  <span className="shrink-0 rounded-full border border-amber-500/30 bg-amber-500/10 px-2 py-0.5 text-[10px] text-amber-400 font-mono">
                    ID: {b.id}
                  </span>
                </div>

                <div className="text-xs text-slate-400 flex items-center gap-1.5">
                  <span>Tướng tương thích:</span>
                  <span className="text-sky-400 font-medium">{b.character_name || "Chưa xác minh"}</span>
                </div>

                <div className="grid grid-cols-2 gap-2 pt-2 border-t border-slate-800/80 text-[11px] text-slate-400">
                  <div>
                    Tinh luyện: <span className="text-slate-200 font-mono">{b.refine ?? "N/A"}</span>
                  </div>
                  <div>
                    Đột phá: <span className="text-slate-200 font-mono">{b.badge_break ?? "N/A"}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {filteredBadges.length > 60 && (
            <div className="text-center text-xs text-slate-500 pt-4">
              Đang hiển thị 60 kết quả đầu tiên. Nhập từ khóa để lọc chính xác hơn.
            </div>
          )}
        </div>
      )}

      {/* TAB 4: QUY TẮC TINH LUYỆN */}
      {activeTab === "rules" && (
        <div className="space-y-6">
          <div className="grid grid-cols-1 gap-6">
            {(data.badge_rules || []).map((r) => (
              <div
                key={r.id}
                className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur"
              >
                <h3 className="text-base font-bold text-emerald-400 mb-3 flex items-center gap-2">
                  <span>📜</span> {r.name}
                </h3>
                <div className="text-sm text-slate-300 whitespace-pre-line leading-relaxed">
                  {r.description}
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
