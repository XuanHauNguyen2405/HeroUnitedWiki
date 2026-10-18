// web/src/components/HeroInteractiveView.tsx
"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import ImageWithFallback from "@/components/ImageWithFallback";
import { formatNumber, getQualityConfig } from "@/lib/utils";

interface ChuyenSinhStage {
  stage: number;
  title: string;
  prefix: string;
  story: string;
  detail: string;
  conditions?: string;
  materials: Array<{ id: string; name: string; count: number; is_hero_card?: boolean }>;
}

interface VanMenhTarget {
  id: string;
  name: string;
  type: "hero" | "equip";
  exists: boolean;
  url: string | null;
}

interface VanMenhEffect {
  key: "hp" | "patk" | "matk" | "def" | "speed";
  name: string;
  percent: number;
}

interface VanMenhItem {
  id: string;
  name: string;
  condition_sort: string;
  type: "hero" | "equip";
  type_label: string;
  description: string;
  targets: VanMenhTarget[];
  effects: VanMenhEffect[];
}

interface BadgeStat {
  key: string;
  name: string;
  value: number;
}

interface BadgeItem {
  id: string;
  name: string;
  character_name: string;
  level: number;
  refine: number;
  badge_break: number;
  stats: BadgeStat[];
  synergy_name: string;
  synergy_desc: string;
}

interface SuperEvoStage {
  id: string;
  name: string;
  tier: "orange" | "red" | "gold";
  unlocks_skill: number;
  skill_name?: string | null;
  stats: { hp: number; patk: number; matk: number; def: number; speed: number };
}

interface SuperEvoData {
  has_super_evo: boolean;
  stages: SuperEvoStage[];
  evo_skill_1: string;
  evo_skill_2: string;
  break4?: number[];
  break5?: number[];
}

interface HeroInteractiveViewProps {
  hero: {
    id: string;
    character_id: string;
    name: string;
    quality: number;
    career: number;
    race: number;
    sex: number;
    star: number;
    star_max: number;
    level_max: number;
    avatar: string | null;
    is_only: number;
    rebirth: number;
    streng?: number;
    base_stats: { hp?: number; patk?: number; matk?: number; def?: number; speed?: number };
    growth_stats: { hp?: number; patk?: number; matk?: number; def?: number; speed?: number };
    skills_detailed: any[];
    chuyen_sinh?: {
      has_rebirth: boolean;
      high_break: number;
      stages: ChuyenSinhStage[];
    };
    van_menh?: VanMenhItem[];
    super_evo?: SuperEvoData;
    badges?: BadgeItem[];
    story?: string;
  };
}

export default function HeroInteractiveView({ hero }: HeroInteractiveViewProps) {
  // 1. Interactive States
  const [level, setLevel] = useState<number>(1);
  const [selectedChuyenStage, setSelectedChuyenStage] = useState<number>(0); // 0 = Chưa chuyển, 1-7
  const [activeTabChuyen, setActiveTabChuyen] = useState<number>(1); // For viewing stage details 1-7

  // Super Evo state (9 stages: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++)
  const [selectedSuperEvoId, setSelectedSuperEvoId] = useState<string>("none");

  // Badge interactive state
  const heroBadges = hero.badges || [];
  const [badgeEquipped, setBadgeEquipped] = useState<boolean>(heroBadges.length > 0);
  const [selectedBadgeLevel, setSelectedBadgeLevel] = useState<number>(
    heroBadges.length > 0 ? Math.min(heroBadges.length - 1, 7) : 0
  );

  // Vận mệnh activation map: { [vanMenhId]: boolean }
  const initialVanMenh = useMemo(() => {
    const map: Record<string, boolean> = {};
    hero.van_menh?.forEach((vm) => {
      map[vm.id] = false;
    });
    return map;
  }, [hero.van_menh]);

  const [activeVanMenh, setActiveVanMenh] = useState<Record<string, boolean>>(initialVanMenh);

  const toggleVanMenh = (id: string) => {
    setActiveVanMenh((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  const setAllVanMenh = (enable: boolean) => {
    const updated: Record<string, boolean> = {};
    hero.van_menh?.forEach((vm) => {
      updated[vm.id] = enable;
    });
    setActiveVanMenh(updated);
  };

  const qConfig = getQualityConfig(hero.quality);

  // Dynamic name based on Chuyển sinh
  const chuyenStages = hero.chuyen_sinh?.stages || [];
  const currentStageObj = chuyenStages.find((s) => s.stage === selectedChuyenStage);
  const currentTitle = currentStageObj ? currentStageObj.title : (hero.name || `Tướng #${hero.id}`);

  // Current super evo stage object
  const superEvoStages = hero.super_evo?.stages || [];
  const currentEvoStage = superEvoStages.find((s) => s.id === selectedSuperEvoId);

  // Skills unlock status
  const isEvoSkill1Unlocked = currentEvoStage ? currentEvoStage.unlocks_skill >= 1 : false;
  const isEvoSkill2Unlocked = currentEvoStage ? currentEvoStage.unlocks_skill >= 2 : false;

  // Current badge
  const activeBadge = heroBadges.find((b) => b.level === selectedBadgeLevel) || heroBadges[0] || null;

  // 2. Compute live combat stats
  const calculatedStats = useMemo(() => {
    const base = hero.base_stats || {};
    const growth = hero.growth_stats || {};

    // Level additions: growth * (level - 1)
    const lvHp = (base.hp || 0) + (growth.hp || 0) * (level - 1);
    const lvPatk = (base.patk || 0) + (growth.patk || 0) * (level - 1);
    const lvMatk = (base.matk || 0) + (growth.matk || 0) * (level - 1);
    const lvDef = (base.def || 0) + (growth.def || 0) * (level - 1);
    const lvSpeed = (base.speed || 0) + (growth.speed || 0) * (level - 1);

    // Super Evo Flat Stats
    const evoStats = currentEvoStage?.stats || { hp: 0, patk: 0, matk: 0, def: 0, speed: 0 };
    const evoHp = evoStats.hp || 0;
    const evoPatk = evoStats.patk || 0;
    const evoMatk = evoStats.matk || 0;
    const evoDef = evoStats.def || 0;
    const evoSpeed = evoStats.speed || 0;

    // Badge Flat Stats (if equipped)
    let badgeHp = 0;
    let badgePatk = 0;
    let badgeMatk = 0;
    let badgeDef = 0;
    let badgeSpeed = 0;

    if (badgeEquipped && activeBadge) {
      activeBadge.stats.forEach((st) => {
        if (st.key === "hp") badgeHp += st.value;
        if (st.key === "patk") badgePatk += st.value;
        if (st.key === "matk") badgeMatk += st.value;
        if (st.key === "def") badgeDef += st.value;
        if (st.key === "speed") badgeSpeed += st.value;
      });
    }

    // Chuyển sinh bonus percentages: each stage from 1 to 5 grants +30% HP (up to +150% at stage 5)
    let chuyenHpPct = 0;
    if (selectedChuyenStage >= 1) chuyenHpPct = Math.min(selectedChuyenStage, 5) * 30;

    // Vận mệnh (Fate Bonds) active bonus percentages
    let bondHpPct = 0;
    let bondPatkPct = 0;
    let bondMatkPct = 0;
    let bondDefPct = 0;
    let bondSpeedPct = 0;

    hero.van_menh?.forEach((vm) => {
      if (activeVanMenh[vm.id]) {
        vm.effects.forEach((eff) => {
          if (eff.key === "hp") bondHpPct += eff.percent;
          if (eff.key === "patk") bondPatkPct += eff.percent;
          if (eff.key === "matk") bondMatkPct += eff.percent;
          if (eff.key === "def") bondDefPct += eff.percent;
          if (eff.key === "speed") bondSpeedPct += eff.percent;
        });
      }
    });

    // Total Calculation
    const totalHp = Math.round((lvHp + evoHp + badgeHp) * (1 + (chuyenHpPct + bondHpPct) / 100));
    const totalPatk = Math.round((lvPatk + evoPatk + badgePatk) * (1 + bondPatkPct / 100));
    const totalMatk = Math.round((lvMatk + evoMatk + badgeMatk) * (1 + bondMatkPct / 100));
    const totalDef = Math.round((lvDef + evoDef + badgeDef) * (1 + bondDefPct / 100));
    const totalSpeed = Math.round((lvSpeed + evoSpeed + badgeSpeed) * (1 + bondSpeedPct / 100));

    return {
      total: { hp: totalHp, patk: totalPatk, matk: totalMatk, def: totalDef, speed: totalSpeed },
      breakdown: {
        lv: { hp: lvHp, patk: lvPatk, matk: lvMatk, def: lvDef, speed: lvSpeed },
        evo: { hp: evoHp, patk: evoPatk, matk: evoMatk, def: evoDef, speed: evoSpeed },
        badge: { hp: badgeHp, patk: badgePatk, matk: badgeMatk, def: badgeDef, speed: badgeSpeed },
        percentages: {
          hp: chuyenHpPct + bondHpPct,
          patk: bondPatkPct,
          matk: bondMatkPct,
          def: bondDefPct,
          speed: bondSpeedPct,
        },
      },
    };
  }, [level, selectedChuyenStage, currentEvoStage, badgeEquipped, activeBadge, activeVanMenh, hero]);

  return (
    <div className="space-y-8 animate-fade-in">
      {/* 1. HERO MAIN CARD & AURA DISPLAY */}
      <div className="relative overflow-hidden rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900 via-slate-950 to-[#070a12] p-6 sm:p-8 shadow-2xl">
        {/* Dynamic Super Evo Glow Background based on stage */}
        <div
          className={`absolute -right-16 -top-16 h-96 w-96 rounded-full blur-3xl opacity-30 transition-all duration-700 pointer-events-none ${
            currentEvoStage?.tier === "gold"
              ? "bg-amber-400 opacity-40 scale-125"
              : currentEvoStage?.tier === "red"
              ? "bg-red-600 opacity-40 scale-125"
              : currentEvoStage?.tier === "orange"
              ? "bg-orange-500 opacity-30 scale-110"
              : "bg-purple-600 opacity-20"
          }`}
        />

        <div className="relative z-10 flex flex-col md:flex-row items-center md:items-start gap-8">
          {/* Avatar Container with Visual Aura Effect */}
          <div className="relative flex-shrink-0 group">
            {/* Visual Aura Ring */}
            <div
              className={`absolute -inset-2.5 rounded-3xl transition-all duration-700 blur-md ${
                currentEvoStage?.tier === "gold"
                  ? "bg-gradient-to-t from-yellow-500 via-amber-300 to-yellow-200 opacity-90 animate-pulse"
                  : currentEvoStage?.tier === "red"
                  ? "bg-gradient-to-t from-red-600 via-rose-500 to-amber-500 opacity-90 animate-pulse"
                  : currentEvoStage?.tier === "orange"
                  ? "bg-gradient-to-t from-orange-600 via-amber-500 to-orange-400 opacity-75"
                  : "bg-purple-900/40 opacity-40"
              }`}
            />

            <div
              className={`relative h-36 w-36 sm:h-44 sm:w-44 overflow-hidden rounded-2xl border-2 bg-slate-950 p-2 shadow-2xl transition-all duration-500 ${
                currentEvoStage?.tier === "gold"
                  ? "border-amber-400 shadow-amber-400/50"
                  : currentEvoStage?.tier === "red"
                  ? "border-red-500 shadow-red-500/50"
                  : currentEvoStage?.tier === "orange"
                  ? "border-orange-500 shadow-orange-500/40"
                  : "border-slate-700 shadow-purple-950/40"
              }`}
            >
              <ImageWithFallback
                src={hero.avatar}
                alt={currentTitle}
                className="h-full w-full object-contain"
                fallbackIcon="👤"
                fallbackText="Chưa tìm thấy ảnh"
              />

              {/* Status Badge in avatar */}
              <div className="absolute top-2 left-2 rounded-md bg-black/75 backdrop-blur px-2 py-0.5 text-[10px] font-bold text-amber-400 border border-amber-500/30">
                Lv.{level}
              </div>

              {/* Wing Rank Badge */}
              <div className="absolute top-2 right-2 flex items-center justify-center h-6 w-6 rounded-full bg-slate-900/90 border border-slate-700 shadow-md">
                <span className="text-[10px] font-extrabold text-amber-300">
                  {selectedChuyenStage > 0 ? selectedChuyenStage : "★"}
                </span>
              </div>
            </div>

            {/* EXP Bar preview */}
            <div className="mt-3 w-36 sm:w-44 text-center">
              <div className="flex justify-between text-[10px] text-slate-400 mb-1">
                <span>EXP</span>
                <span className="font-mono text-slate-300">0 / 147,420</span>
              </div>
              <div className="h-1.5 w-full rounded-full bg-slate-800 overflow-hidden">
                <div className="h-full w-1/3 bg-emerald-500 rounded-full" />
              </div>
            </div>
          </div>

          {/* Hero Identity & Title Info */}
          <div className="flex-1 text-center md:text-left space-y-3">
            <div className="flex flex-wrap items-center justify-center md:justify-start gap-2">
              <span className="rounded-full border border-slate-700 bg-slate-800/80 px-2.5 py-0.5 text-xs text-slate-300 font-mono">
                Bản thể ID: <b>{hero.id}</b>
              </span>
              <span className="rounded-full border border-sky-500/30 bg-sky-950/60 px-2.5 py-0.5 text-xs text-sky-300 font-mono">
                Nhóm Tướng: <b>{hero.character_id}</b>
              </span>
              <span className={`rounded-full border px-3 py-0.5 text-xs font-semibold ${qConfig.badgeClass}`}>
                {qConfig.name}
              </span>

              {/* Super Evo Tag */}
              {currentEvoStage && currentEvoStage.id !== "none" && (
                <span
                  className={`rounded-full border px-3 py-0.5 text-xs font-bold animate-pulse ${
                    currentEvoStage.tier === "gold"
                      ? "border-amber-400 bg-amber-950/80 text-amber-300"
                      : currentEvoStage.tier === "red"
                      ? "border-red-500 bg-red-950/80 text-red-400"
                      : "border-orange-500 bg-orange-950/80 text-orange-400"
                  }`}
                >
                  ⚡ Siêu Tiến Hóa {currentEvoStage.name}
                </span>
              )}
            </div>

            <div>
              <div className="text-xs text-slate-400 font-medium mb-1">
                {currentStageObj ? `Mốc Chuyển Sinh ${selectedChuyenStage}: ${currentStageObj.prefix}` : "Dạng Nguyên Bản"}
              </div>
              <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight flex flex-wrap items-center justify-center md:justify-start gap-3">
                <span>{currentTitle}</span>
                {hero.streng ? (
                  <span className="text-amber-400 text-2xl sm:text-3xl font-mono">+{hero.streng}</span>
                ) : (
                  <span className="text-slate-500 text-2xl sm:text-3xl font-mono">+60</span>
                )}
              </h1>
            </div>

            {/* Stars & Basic tags (Career & Race removed per instruction) */}
            <div className="flex flex-wrap items-center justify-center md:justify-start gap-3 text-xs pt-1">
              <span className="rounded-xl border border-amber-500/30 bg-amber-500/10 px-3 py-1 text-amber-400 font-semibold">
                ⭐ {hero.star || 0} / {hero.star_max || 0} Sao
              </span>
              {heroBadges.length > 0 && (
                <span className="rounded-xl border border-purple-500/30 bg-purple-500/10 px-3 py-1 text-purple-300 font-semibold flex items-center gap-1">
                  <span>🎖️</span> Có Huy Hiệu Độc Quyền ({heroBadges[0].name})
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* 2. HUY HIỆU CỦA TƯỚNG (NẾU CÓ - VÍ DỤ: NAGATO, SHADOW, SONGOKU...) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🎖️</span>
              <h2 className="text-xl font-bold text-white">
                Huy Hiệu Anh Hùng Độc Quyền
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              {heroBadges.length > 0
                ? `Huy hiệu tiềm lực chỉ định riêng cho ${activeBadge?.character_name || hero.name}, tăng phúc lượng lớn thuộc tính và mở kỹ năng tổ hợp đội hình.`
                : `Tướng này hiện chưa mở tính năng Huy Hiệu cá nhân trong cấu hình game (Độc quyền cho các tướng chủ lực như Nagato, Shadow, Songoku/Kakarot, Elaina, Broli, Shalltear...).`}
            </p>
          </div>

          {heroBadges.length > 0 && (
            <button
              onClick={() => setBadgeEquipped(!badgeEquipped)}
              className={`rounded-xl px-4 py-2 text-xs font-bold transition-all ${
                badgeEquipped
                  ? "bg-purple-600 text-white shadow-lg shadow-purple-600/30 border border-purple-400"
                  : "border border-slate-700 bg-slate-800 text-slate-400 hover:text-white"
              }`}
            >
              {badgeEquipped ? "✓ Đang trang bị Huy Hiệu" : "+ Trang bị Huy Hiệu vào chỉ số"}
            </button>
          )}
        </div>

        {heroBadges.length > 0 && activeBadge ? (
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
            {/* Badge Profile Card */}
            <div className="rounded-2xl border border-purple-500/30 bg-purple-950/20 p-5 space-y-3 flex flex-col justify-between">
              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <span className="text-xs font-mono text-purple-300">ID: {activeBadge.id}</span>
                  <span className="rounded-full bg-purple-500/20 px-2 py-0.5 text-[10px] font-bold text-purple-300 border border-purple-500/40">
                    Cấp {activeBadge.level}
                  </span>
                </div>
                <h3 className="text-lg font-extrabold text-white">{activeBadge.name}</h3>
                <div className="text-xs text-slate-300">
                  Tướng tương thích: <span className="font-bold text-amber-400">{activeBadge.character_name}</span>
                </div>
              </div>

              {/* Badge Level Switcher (Cấp 0 - 7) */}
              <div className="space-y-1 pt-2 border-t border-purple-900/40">
                <div className="text-[11px] text-slate-400">Chọn cấp độ Huy Hiệu:</div>
                <div className="grid grid-cols-4 gap-1.5">
                  {heroBadges.map((b) => (
                    <button
                      key={b.id}
                      onClick={() => setSelectedBadgeLevel(b.level)}
                      className={`rounded-lg py-1 text-xs font-mono font-bold transition-all ${
                        selectedBadgeLevel === b.level
                          ? "bg-purple-500 text-white shadow"
                          : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
                      }`}
                    >
                      Cấp {b.level}
                    </button>
                  ))}
                </div>
              </div>
            </div>

            {/* Badge Stats */}
            <div className="rounded-2xl border border-slate-800 bg-slate-950/60 p-5 space-y-3">
              <div className="text-xs uppercase font-bold text-slate-400 tracking-wider">
                Thuộc Tính Cộng Trực Tiếp (Cấp {activeBadge.level})
              </div>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1">
                {activeBadge.stats.map((st, idx) => (
                  <div key={idx} className="rounded-xl border border-slate-800 bg-slate-900/80 p-3 space-y-0.5">
                    <div className="text-[11px] text-slate-400">{st.name}</div>
                    <div className="text-lg font-black text-purple-400 font-mono">
                      +{formatNumber(st.value)}
                    </div>
                  </div>
                ))}
              </div>
              <div className="text-[11px] text-slate-500 pt-1">
                Tinh luyện vận mệnh: <span className="font-mono text-slate-300">Mức {activeBadge.refine}</span> | Đột phá kế tiếp: <span className="font-mono text-slate-300">#{activeBadge.badge_break || "Max"}</span>
              </div>
            </div>

            {/* Synergy Combo Info */}
            <div className="rounded-2xl border border-amber-500/30 bg-amber-950/20 p-5 space-y-3">
              <div className="text-xs uppercase font-bold text-amber-400 tracking-wider flex items-center gap-1.5">
                <span>⚡</span> Kỹ Năng Tổ Hợp Đội Hình
              </div>
              <h4 className="font-bold text-white text-sm">{activeBadge.synergy_name}</h4>
              <p className="text-xs text-amber-200/90 leading-relaxed font-sans">
                {activeBadge.synergy_desc}
              </p>
              <div className="pt-2">
                <Link
                  href="/ban-suc"
                  className="text-[11px] text-amber-400 hover:text-amber-300 font-semibold underline underline-offset-4"
                >
                  Tra cứu chi tiết 112 Huy Hiệu & Kỹ năng tổ hợp →
                </Link>
              </div>
            </div>
          </div>
        ) : (
          <div className="rounded-2xl border border-slate-800 bg-slate-950/40 p-6 text-center text-xs text-slate-500">
            Hiện tại chỉ 14 thẻ tướng chủ lực (Nagato, Shadow, Songoku/Kakarot, Phù Thủy Elaina, CuồnBroli, MG Maple, CT Shalltear, Songohan Kong, CT Kikyo, Kiếm Hy Vọng, CT Inori, Yatogami Tenka, CT Vegeta, Bikini Frieren) sở hữu Huy Hiệu cá nhân trong cấu hình game.
          </div>
        )}
      </section>

      {/* 3. SIÊU TIẾN HÓA (7 MỐC / 9 CẤP ĐỘ: CAM -> VÀNG++) & KỸ NĂNG TIẾN HÓA MỞ KHÓA TẠI ĐỎ VÀ VÀNG */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">✨</span>
              <h2 className="text-xl font-bold text-white">
                Siêu Tiến Hóa (Cam, Đỏ, Vàng) & Kỹ Năng Tiến Hóa
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Siêu tiến hóa gồm các mốc: <b>Cam, Cam+, Cam++</b> $\rightarrow$ <b>Đỏ, Đỏ+, Đỏ++</b> (mở Kỹ năng Siêu Tiến Hóa 1) $\rightarrow$ <b>Vàng, Vàng+, Vàng++</b> (mở Kỹ năng Siêu Tiến Hóa 2).
            </p>
          </div>
        </div>

        {/* 9 Stage Selector Buttons */}
        <div className="space-y-3">
          <div className="text-xs uppercase font-bold text-slate-400 tracking-wider">
            Chọn Mốc Siêu Tiến Hóa:
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-5 lg:grid-cols-10 gap-2">
            <button
              onClick={() => setSelectedSuperEvoId("none")}
              className={`rounded-xl p-2.5 text-xs font-semibold transition-all text-center ${
                selectedSuperEvoId === "none"
                  ? "bg-slate-700 text-white border border-slate-500 shadow"
                  : "bg-slate-950 text-slate-400 hover:bg-slate-900 border border-slate-800"
              }`}
            >
              Chưa kích hoạt
            </button>

            {superEvoStages.map((st) => {
              const isSelected = selectedSuperEvoId === st.id;
              return (
                <button
                  key={st.id}
                  onClick={() => setSelectedSuperEvoId(st.id)}
                  className={`rounded-xl p-2.5 text-xs font-bold transition-all text-center flex flex-col items-center justify-center gap-1 border ${
                    isSelected
                      ? st.tier === "gold"
                        ? "bg-gradient-to-b from-amber-500 to-yellow-600 text-slate-950 border-amber-300 shadow-lg shadow-amber-500/30"
                        : st.tier === "red"
                        ? "bg-gradient-to-b from-red-600 to-rose-700 text-white border-red-400 shadow-lg shadow-red-600/30"
                        : "bg-gradient-to-b from-orange-500 to-amber-600 text-white border-orange-400 shadow-lg shadow-orange-500/30"
                      : st.tier === "gold"
                      ? "bg-amber-950/30 text-amber-300 border-amber-900/50 hover:bg-amber-950/60"
                      : st.tier === "red"
                      ? "bg-red-950/30 text-red-300 border-red-900/50 hover:bg-red-950/60"
                      : "bg-orange-950/30 text-orange-300 border-orange-900/50 hover:bg-orange-950/60"
                  }`}
                >
                  <span className="text-sm">{st.name}</span>
                  {st.unlocks_skill === 1 && (
                    <span className="text-[9px] bg-red-900/80 text-white px-1.5 py-0.2 rounded font-mono">
                      Mở KN1
                    </span>
                  )}
                  {st.unlocks_skill === 2 && (
                    <span className="text-[9px] bg-yellow-950 text-amber-300 px-1.5 py-0.2 rounded font-mono border border-amber-500/40">
                      Mở KN2
                    </span>
                  )}
                </button>
              );
            })}
          </div>
        </div>

        {/* 2 Evolution Skills Cards (Matching Screenshot 1 & 2: Diêm Vương Luân Hồi Phục Sinh & Ngoại đạo ma tượng) */}
        <div className="space-y-3 pt-2">
          <div className="text-xs uppercase font-bold text-slate-400 tracking-wider flex items-center justify-between">
            <span>Kỹ Năng Tiến Hóa (Mở khóa tại mốc Đỏ và Vàng)</span>
            <span className="text-[11px] text-slate-500">
              Trạng thái: {isEvoSkill2Unlocked ? "✓ Mở khóa toàn bộ 2 kỹ năng" : isEvoSkill1Unlocked ? "✓ Đã mở kỹ năng 1" : "🔒 Đang khóa"}
            </span>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {/* Skill 1: Unlocked at Đỏ */}
            <div
              className={`rounded-2xl border p-5 transition-all duration-300 flex items-start gap-4 ${
                isEvoSkill1Unlocked
                  ? "border-red-500/60 bg-red-950/20 shadow-lg shadow-red-950/40"
                  : "border-slate-800 bg-slate-950/40 opacity-60"
              }`}
            >
              <div
                className={`h-16 w-16 shrink-0 rounded-2xl border-2 flex items-center justify-center text-2xl shadow-lg ${
                  isEvoSkill1Unlocked
                    ? "border-red-500 bg-red-950 text-red-300 shadow-red-500/30"
                    : "border-slate-800 bg-slate-900 text-slate-600"
                }`}
              >
                {isEvoSkill1Unlocked ? "👹" : "🔒"}
              </div>

              <div className="space-y-1.5 flex-1">
                <div className="flex items-center justify-between">
                  <span
                    className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full border ${
                      isEvoSkill1Unlocked
                        ? "border-red-500/40 bg-red-500/10 text-red-400"
                        : "border-slate-700 bg-slate-800 text-slate-500"
                    }`}
                  >
                    {isEvoSkill1Unlocked ? "✓ Đã mở khóa (Mốc Đỏ)" : "Mở khóa tại mốc Đỏ"}
                  </span>
                  <span className="text-xs font-mono text-slate-500">KN Siêu Tiến Hóa 1</span>
                </div>

                <h4 className="text-base font-extrabold text-white">
                  {hero.super_evo?.evo_skill_1 || "Kỹ năng Siêu Tiến Hóa 1"}
                </h4>

                <p className="text-xs text-slate-300 leading-relaxed font-sans">
                  {hero.chuyen_sinh?.stages?.[5]?.story || "Cường hóa sức mạnh và kỹ năng siêu tiến hóa 1 của bản thể tướng."}
                </p>
              </div>
            </div>

            {/* Skill 2: Unlocked at Vàng */}
            <div
              className={`rounded-2xl border p-5 transition-all duration-300 flex items-start gap-4 ${
                isEvoSkill2Unlocked
                  ? "border-amber-400/70 bg-amber-950/20 shadow-lg shadow-amber-950/40"
                  : "border-slate-800 bg-slate-950/40 opacity-60"
              }`}
            >
              <div
                className={`h-16 w-16 shrink-0 rounded-2xl border-2 flex items-center justify-center text-2xl shadow-lg ${
                  isEvoSkill2Unlocked
                    ? "border-amber-400 bg-amber-950 text-amber-300 shadow-amber-400/40"
                    : "border-slate-800 bg-slate-900 text-slate-600"
                }`}
              >
                {isEvoSkill2Unlocked ? "👑" : "🔒"}
              </div>

              <div className="space-y-1.5 flex-1">
                <div className="flex items-center justify-between">
                  <span
                    className={`text-[10px] font-bold px-2.5 py-0.5 rounded-full border ${
                      isEvoSkill2Unlocked
                        ? "border-amber-400/40 bg-amber-400/10 text-amber-300"
                        : "border-slate-700 bg-slate-800 text-slate-500"
                    }`}
                  >
                    {isEvoSkill2Unlocked ? "✓ Đã mở khóa (Mốc Vàng)" : "Mở khóa tại mốc Vàng"}
                  </span>
                  <span className="text-xs font-mono text-slate-500">KN Siêu Tiến Hóa 2</span>
                </div>

                <h4 className="text-base font-extrabold text-white">
                  {hero.super_evo?.evo_skill_2 || "Kỹ năng Siêu Tiến Hóa 2"}
                </h4>

                <p className="text-xs text-slate-300 leading-relaxed font-sans">
                  {hero.chuyen_sinh?.stages?.[6]?.story || "Cường hóa đỉnh phong và kỹ năng siêu tiến hóa 2 của bản thể tướng."}
                </p>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 4. STAT SIMULATOR & LEVEL CONTROLS (1 - 255) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <h2 className="text-xl font-bold text-white flex items-center gap-2">
              <span>📈</span>
              Tùy Chọn Level (1 - 255) & Chỉ Số Thay Đổi Thời Gian Thực
            </h2>
            <p className="text-xs text-slate-400 mt-1">
              Chỉ số tự động tính toán dựa trên: <b>Cấp độ ({level})</b> + <b>Chuyển sinh ({selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage}` : "Gốc"})</b> + <b>Siêu tiến hóa ({currentEvoStage?.name || "Chưa"})</b> + <b>Huy hiệu ({badgeEquipped ? `Cấp ${selectedBadgeLevel}` : "Tắt"})</b> + <b>Vận mệnh</b>.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => {
                setLevel(1);
                setSelectedChuyenStage(0);
                setSelectedSuperEvoId("none");
                setAllVanMenh(false);
              }}
              className="rounded-xl border border-slate-700 bg-slate-800/80 px-3 py-1.5 text-xs text-slate-400 hover:text-white transition-colors"
            >
              Mặc định (Lv.1)
            </button>
            <button
              onClick={() => {
                setLevel(255);
                setSelectedChuyenStage(7);
                setSelectedSuperEvoId("vang_plus2");
                setAllVanMenh(true);
              }}
              className="rounded-xl border border-amber-500/40 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-300 hover:bg-amber-500/20 transition-colors shadow-lg shadow-amber-500/10"
            >
              ⚡ Tối Đa Sức Mạnh (Max Lv.255 + Chuyển 7 + Vàng++ + Vận Mệnh)
            </button>
          </div>
        </div>

        {/* Level Controls */}
        <div className="space-y-3 rounded-2xl border border-slate-800/80 bg-slate-950/60 p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm font-bold text-white flex items-center gap-2">
              <span>🎯</span> Cấp Độ Tướng (Level 1 - 255)
            </span>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-400">Cấp:</span>
              <input
                type="number"
                min={1}
                max={255}
                value={level}
                onChange={(e) => setLevel(Math.min(255, Math.max(1, parseInt(e.target.value) || 1)))}
                className="w-20 rounded-xl border border-slate-700 bg-slate-900 px-3 py-1 text-center font-mono text-sm font-bold text-sky-400 focus:border-sky-500 focus:outline-none"
              />
            </div>
          </div>

          <input
            type="range"
            min={1}
            max={255}
            value={level}
            onChange={(e) => setLevel(parseInt(e.target.value, 10))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-sky-500"
          />

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="text-[11px] text-slate-500">Mốc nhanh:</span>
            {[1, 50, 100, 150, 200, 255].map((lv) => (
              <button
                key={lv}
                onClick={() => setLevel(lv)}
                className={`rounded-lg px-2.5 py-0.5 text-xs font-mono transition-colors ${
                  level === lv
                    ? "bg-sky-500 text-white font-bold"
                    : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
                }`}
              >
                Lv.{lv}
              </button>
            ))}
          </div>
        </div>

        {/* 5 Live Combat Stats */}
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-3">
          {/* HP */}
          <div className="rounded-2xl border border-red-500/20 bg-red-950/10 p-4 space-y-1">
            <div className="text-xs text-red-400/80 font-medium">Sinh Lực (HP)</div>
            <div className="text-2xl font-black text-red-400 font-mono">
              {formatNumber(calculatedStats.total.hp)}
            </div>
            <div className="text-[11px] text-slate-400">
              Gốc: <span className="font-mono text-slate-300">{formatNumber(hero.base_stats?.hp)}</span> (+{formatNumber(hero.growth_stats?.hp)}/Lv)
            </div>
            {calculatedStats.breakdown.percentages.hp > 0 && (
              <div className="text-[10px] text-amber-400 font-semibold">
                +{calculatedStats.breakdown.percentages.hp}% từ CS & Vận mệnh
              </div>
            )}
          </div>

          {/* P.ATK */}
          <div className="rounded-2xl border border-amber-500/20 bg-amber-950/10 p-4 space-y-1">
            <div className="text-xs text-amber-400/80 font-medium">Công Vật Lý (PATK)</div>
            <div className="text-2xl font-black text-amber-400 font-mono">
              {formatNumber(calculatedStats.total.patk)}
            </div>
            <div className="text-[11px] text-slate-400">
              Gốc: <span className="font-mono text-slate-300">{formatNumber(hero.base_stats?.patk)}</span> (+{formatNumber(hero.growth_stats?.patk)}/Lv)
            </div>
            {calculatedStats.breakdown.percentages.patk > 0 && (
              <div className="text-[10px] text-amber-400 font-semibold">
                +{calculatedStats.breakdown.percentages.patk}% từ Vận mệnh
              </div>
            )}
          </div>

          {/* M.ATK */}
          <div className="rounded-2xl border border-purple-500/20 bg-purple-950/10 p-4 space-y-1">
            <div className="text-xs text-purple-400/80 font-medium">Công Ma Pháp (MATK)</div>
            <div className="text-2xl font-black text-purple-400 font-mono">
              {formatNumber(calculatedStats.total.matk)}
            </div>
            <div className="text-[11px] text-slate-400">
              Gốc: <span className="font-mono text-slate-300">{formatNumber(hero.base_stats?.matk)}</span> (+{formatNumber(hero.growth_stats?.matk)}/Lv)
            </div>
            {calculatedStats.breakdown.percentages.matk > 0 && (
              <div className="text-[10px] text-amber-400 font-semibold">
                +{calculatedStats.breakdown.percentages.matk}% từ Vận mệnh
              </div>
            )}
          </div>

          {/* DEF */}
          <div className="rounded-2xl border border-sky-500/20 bg-sky-950/10 p-4 space-y-1">
            <div className="text-xs text-sky-400/80 font-medium">Phòng Ngự (DEF)</div>
            <div className="text-2xl font-black text-sky-400 font-mono">
              {formatNumber(calculatedStats.total.def)}
            </div>
            <div className="text-[11px] text-slate-400">
              Gốc: <span className="font-mono text-slate-300">{formatNumber(hero.base_stats?.def)}</span> (+{formatNumber(hero.growth_stats?.def)}/Lv)
            </div>
            {calculatedStats.breakdown.percentages.def > 0 && (
              <div className="text-[10px] text-amber-400 font-semibold">
                +{calculatedStats.breakdown.percentages.def}% từ Vận mệnh
              </div>
            )}
          </div>

          {/* SPEED */}
          <div className="rounded-2xl border border-emerald-500/20 bg-emerald-950/10 p-4 space-y-1">
            <div className="text-xs text-emerald-400/80 font-medium">Tốc Độ (SPEED)</div>
            <div className="text-2xl font-black text-emerald-400 font-mono">
              {formatNumber(calculatedStats.total.speed)}
            </div>
            <div className="text-[11px] text-slate-400">
              Gốc: <span className="font-mono text-slate-300">{formatNumber(hero.base_stats?.speed)}</span> (+{formatNumber(hero.growth_stats?.speed)}/Lv)
            </div>
            {calculatedStats.breakdown.percentages.speed > 0 && (
              <div className="text-[10px] text-amber-400 font-semibold">
                +{calculatedStats.breakdown.percentages.speed}% từ Vận mệnh
              </div>
            )}
          </div>
        </div>
      </section>

      {/* 5. 7 MỐC CHUYỂN SINH & ĐIỀU KIỆN CHUYỂN SINH CỦA TƯỚNG */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="border-b border-slate-800 pb-4">
          <div className="flex items-center gap-2">
            <span className="text-2xl">🔄</span>
            <h2 className="text-xl font-bold text-white">
              7 Mốc Chuyển Sinh & Điều Kiện Chuyển Sinh
            </h2>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Điều kiện chuyển sinh của tướng bao gồm: mốc chuyển sinh tuần tự, phẩm chất tối thiểu, nguyên liệu theo từng chương thế giới và thẻ tướng bản sao.
          </p>
        </div>

        {chuyenStages.length > 0 ? (
          <div className="space-y-6">
            {/* Visual stage tabs matching Screenshot 1 & 2 */}
            <div className="grid grid-cols-2 sm:grid-cols-4 lg:grid-cols-7 gap-2">
              {chuyenStages.map((st) => (
                <button
                  key={st.stage}
                  onClick={() => {
                    setActiveTabChuyen(st.stage);
                    setSelectedChuyenStage(st.stage);
                  }}
                  className={`rounded-2xl p-3 text-center transition-all border ${
                    activeTabChuyen === st.stage
                      ? "border-sky-500 bg-sky-950/40 shadow-lg shadow-sky-500/20"
                      : "border-slate-800 bg-slate-950/60 hover:bg-slate-900 text-slate-400"
                  }`}
                >
                  <div className="text-xs font-bold text-white mb-0.5">
                    Chuyển {st.stage}
                  </div>
                  <div className="text-[11px] text-amber-400 font-semibold truncate">
                    {st.prefix}
                  </div>
                  <div className="text-[10px] text-slate-500 mt-1">
                    {st.stage <= 2 ? "★★ Xanh" : st.stage === 3 ? "★★★ Lá" : st.stage <= 5 ? "★★★★★ Vàng" : st.stage === 6 ? "Huy hiệu Linh" : "Huy hiệu Hồn"}
                  </div>
                </button>
              ))}
            </div>

            {/* Selected Stage Detail Card */}
            {(() => {
              const activeStage = chuyenStages.find((s) => s.stage === activeTabChuyen) || chuyenStages[0];
              if (!activeStage) return null;

              return (
                <div className="rounded-2xl border border-slate-800 bg-slate-950/70 p-6 space-y-4">
                  <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-slate-800 pb-3">
                    <div>
                      <div className="text-xs text-sky-400 font-semibold uppercase tracking-wider">
                        Mốc Chuyển {activeStage.stage} ({activeStage.prefix})
                      </div>
                      <h3 className="text-xl font-bold text-white mt-0.5">
                        {activeStage.title}
                      </h3>
                    </div>

                    <button
                      onClick={() => setSelectedChuyenStage(activeStage.stage)}
                      className={`rounded-xl px-4 py-2 text-xs font-bold transition-all ${
                        selectedChuyenStage === activeStage.stage
                          ? "bg-emerald-600 text-white shadow-lg shadow-emerald-600/30"
                          : "border border-slate-700 bg-slate-800 text-slate-300 hover:bg-slate-700"
                      }`}
                    >
                      {selectedChuyenStage === activeStage.stage ? "✓ Đang áp dụng vào chỉ số" : "Áp dụng mốc này"}
                    </button>
                  </div>

                  {/* Conditions Box */}
                  <div className="rounded-xl border border-sky-500/30 bg-sky-950/20 p-4">
                    <div className="text-xs font-bold text-sky-400 flex items-center gap-1.5 mb-1">
                      <span>📋</span> Điều Kiện Chuyển Sinh Cấp {activeStage.stage}:
                    </div>
                    <div className="text-xs text-slate-300">
                      {activeStage.conditions}
                    </div>
                  </div>

                  <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
                    {/* Story / Main Buff */}
                    <div className="lg:col-span-2 space-y-3">
                      <div>
                        <div className="text-xs text-slate-400 uppercase tracking-wider mb-1">
                          Hiệu ứng tăng cường & Kỹ năng
                        </div>
                        <div className="rounded-xl border border-slate-800 bg-slate-900/60 p-4 text-sm text-slate-200 whitespace-pre-line leading-relaxed">
                          {activeStage.story || "Chưa có mô tả kỹ năng tăng cường."}
                        </div>
                      </div>

                      {activeStage.detail && (
                        <div>
                          <div className="text-xs text-slate-400 uppercase tracking-wider mb-1">
                            Kỹ năng bị động / Cơ chế chiến đấu đặc biệt
                          </div>
                          <div className="rounded-xl border border-slate-800 bg-slate-900/40 p-4 text-xs sm:text-sm text-amber-200/90 whitespace-pre-line leading-relaxed">
                            {activeStage.detail}
                          </div>
                        </div>
                      )}
                    </div>

                    {/* Required Materials */}
                    <div>
                      <div className="text-xs text-slate-400 uppercase tracking-wider mb-1">
                        Nguyên liệu & Thẻ Tướng Yêu Cầu
                      </div>
                      <div className="rounded-xl border border-slate-800 bg-slate-900/60 p-4 space-y-2">
                        {activeStage.materials.length > 0 ? (
                          activeStage.materials.map((m, idx) => (
                            <div
                              key={idx}
                              className="flex items-center justify-between text-xs py-1.5 border-b border-slate-800/60 last:border-0"
                            >
                              <div className="flex items-center gap-1.5">
                                <span>{m.is_hero_card ? "🃏" : "💎"}</span>
                                <span className={`font-medium ${m.is_hero_card ? "text-amber-400" : "text-slate-300"}`}>
                                  {m.name}
                                </span>
                              </div>
                              <span className="font-mono text-amber-400 font-bold">x{m.count}</span>
                            </div>
                          ))
                        ) : (
                          <div className="text-xs text-slate-500 italic">Không yêu cầu nguyên liệu.</div>
                        )}
                      </div>
                    </div>
                  </div>
                </div>
              );
            })()}
          </div>
        ) : (
          <div className="rounded-2xl border border-slate-800 bg-slate-950/40 p-6 text-center text-xs text-slate-400">
            Bản thể tướng này chưa có dữ liệu mốc Chuyển sinh riêng trong cấu hình character_break_new.
          </div>
        )}
      </section>

      {/* 6. VẬN MỆNH (KÍCH HOẠT VẬN MỆNH - MATCHING SCREENSHOT 3) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <h2 className="text-xl font-bold text-white flex items-center gap-2">
              <span>⚜️</span>
              Vận Mệnh (Duyên Phận Tướng & Trang Bị)
            </h2>
            <p className="text-xs text-slate-400 mt-1">
              Bật/tắt các mục Vận Mệnh bên dưới để kích hoạt trực tiếp các chỉ số % cộng thêm vào bảng thuộc tính.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => setAllVanMenh(true)}
              className="rounded-xl border border-amber-500/40 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-300 hover:bg-amber-500/20 transition-colors"
            >
              ✓ Kích hoạt tất cả
            </button>
            <button
              onClick={() => setAllVanMenh(false)}
              className="rounded-xl border border-slate-700 bg-slate-800 px-3 py-1.5 text-xs text-slate-400 hover:text-white transition-colors"
            >
              ✕ Hủy kích hoạt
            </button>
          </div>
        </div>

        {hero.van_menh && hero.van_menh.length > 0 ? (
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {hero.van_menh.map((vm) => {
              const isActive = !!activeVanMenh[vm.id];
              const isCardBond = vm.condition_sort === "0";

              return (
                <div
                  key={vm.id}
                  onClick={() => toggleVanMenh(vm.id)}
                  className={`cursor-pointer rounded-2xl border p-5 transition-all duration-200 space-y-3 ${
                    isActive
                      ? isCardBond
                        ? "border-amber-500/60 bg-amber-950/20 shadow-lg shadow-amber-950/30"
                        : "border-purple-500/60 bg-purple-950/20 shadow-lg shadow-purple-950/30"
                      : "border-slate-800 bg-slate-950/60 hover:border-slate-700 hover:bg-slate-900/60"
                  }`}
                >
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <input
                        type="checkbox"
                        checked={isActive}
                        onChange={() => {}} // handled by parent onClick
                        className="h-4 w-4 rounded border-slate-700 text-amber-500 focus:ring-0 cursor-pointer"
                      />
                      <span
                        className={`text-base font-extrabold ${
                          isCardBond ? "text-amber-300" : "text-purple-300"
                        }`}
                      >
                        {vm.name}
                      </span>
                    </div>

                    <span
                      className={`text-[10px] font-semibold px-2.5 py-0.5 rounded-full border ${
                        isCardBond
                          ? "border-amber-500/30 bg-amber-500/10 text-amber-400"
                          : "border-purple-500/30 bg-purple-500/10 text-purple-400"
                      }`}
                    >
                      {vm.type_label}
                    </span>
                  </div>

                  {/* Formatted description with highlights */}
                  <div className="text-xs sm:text-sm text-slate-200 leading-relaxed font-sans pl-7">
                    {vm.description}
                  </div>

                  {/* Targets / Links */}
                  {vm.targets.length > 0 && (
                    <div className="flex flex-wrap items-center gap-1.5 pl-7 pt-1 text-xs">
                      <span className="text-slate-500 text-[11px]">Yêu cầu:</span>
                      {vm.targets.map((t, idx) => (
                        <span key={idx}>
                          {t.url ? (
                            <Link
                              href={t.url}
                              onClick={(e) => e.stopPropagation()}
                              className={`font-semibold underline underline-offset-2 ${
                                isCardBond
                                  ? "text-amber-400 hover:text-amber-300"
                                  : "text-purple-400 hover:text-purple-300"
                              }`}
                            >
                              {t.name}
                            </Link>
                          ) : (
                            <span className="text-slate-300 font-medium">{t.name}</span>
                          )}
                          {idx < vm.targets.length - 1 && <span className="text-slate-600">, </span>}
                        </span>
                      ))}
                    </div>
                  )}

                  {/* Effects badges */}
                  <div className="flex flex-wrap items-center gap-1.5 pl-7 pt-1">
                    {vm.effects.map((eff, idx) => (
                      <span
                        key={idx}
                        className={`rounded-md px-2 py-0.5 text-[10px] font-mono font-bold ${
                          isActive
                            ? "bg-emerald-500/20 text-emerald-300 border border-emerald-500/40"
                            : "bg-slate-900 text-slate-400 border border-slate-800"
                        }`}
                      >
                        +{eff.percent}% {eff.name}
                      </span>
                    ))}
                  </div>
                </div>
              );
            })}
          </div>
        ) : (
          <div className="rounded-2xl border border-slate-800 bg-slate-950/40 p-6 text-center text-xs text-slate-400">
            Chưa có cấu hình Vận Mệnh cho bản thể này.
          </div>
        )}
      </section>

      {/* 7. SKILLS LIST (7 Ô KỸ NĂNG NGUYÊN BẢN) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="border-b border-slate-800 pb-4">
          <h2 className="text-xl font-bold text-white flex items-center gap-2">
            <span>⚡</span>
            7 Ô Kỹ Năng Bản Thể
          </h2>
          <p className="text-xs text-slate-400 mt-1">
            Toàn bộ 7 kỹ năng từ cấu hình game nguyên bản.
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          {hero.skills_detailed?.map((sk: any, idx: number) => (
            <div
              key={idx}
              className="rounded-2xl border border-slate-800 bg-slate-950/60 p-5 flex items-start gap-4 hover:border-slate-700 transition-colors"
            >
              <div className="h-14 w-14 shrink-0 rounded-xl border border-slate-700 bg-slate-900 p-1">
                <ImageWithFallback
                  src={sk.icon}
                  alt={sk.name || `Kỹ năng #${sk.skill_id}`}
                  className="h-full w-full object-contain"
                  fallbackIcon="⚡"
                  fallbackText="Chưa tìm thấy ảnh"
                />
              </div>

              <div className="flex-1 space-y-1.5 min-w-0">
                <div className="flex items-center justify-between gap-2">
                  <h4 className="font-bold text-white text-sm truncate">
                    {sk.name || `Kỹ năng #${sk.skill_id}`}
                  </h4>
                  <span className="shrink-0 rounded-full border border-sky-500/30 bg-sky-500/10 px-2 py-0.5 text-[10px] text-sky-400 font-mono">
                    Slot {sk.slot}
                  </span>
                </div>

                <div className="flex items-center gap-3 text-[11px] text-slate-400">
                  {sk.cd !== undefined && (
                    <span>
                      Hồi: <span className="text-slate-200 font-mono">{sk.cd}</span>
                    </span>
                  )}
                  {sk.rate !== undefined && (
                    <span>
                      Tỷ lệ: <span className="text-slate-200 font-mono">{sk.rate}%</span>
                    </span>
                  )}
                  {sk.skill_type && (
                    <span className="text-purple-400 font-mono">{sk.skill_type}</span>
                  )}
                </div>

                <p className="text-xs text-slate-300 leading-relaxed line-clamp-3">
                  {sk.description || "Chưa có mô tả kỹ năng."}
                </p>

                {sk.skill_id && (
                  <div className="pt-1">
                    <Link
                      href={`/skills/${sk.skill_id}`}
                      className="text-[11px] text-sky-400 hover:text-sky-300 font-semibold inline-flex items-center gap-1"
                    >
                      <span>Xem chi tiết kỹ năng</span>
                      <span>→</span>
                    </Link>
                  </div>
                )}
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* 8. SYSTEM & METADATA */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur text-xs space-y-3">
        <h3 className="text-sm font-bold text-slate-300 uppercase tracking-wider">Thông Tin Bản Thể & Cấu Hình</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-2">
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Mã Bản Thể:</span>
            <div className="font-mono text-white font-bold">{hero.id}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Mã Nhóm Tướng:</span>
            <div className="font-mono text-white font-bold">{hero.character_id}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Cấp Tối Đa Cấu Hình:</span>
            <div className="font-mono text-white font-bold">{hero.level_max || 255}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Trạng Thái Độc Quyền (is_only):</span>
            <div className="font-mono text-white font-bold">{hero.is_only ?? 0}</div>
          </div>
        </div>
      </section>
    </div>
  );
}
