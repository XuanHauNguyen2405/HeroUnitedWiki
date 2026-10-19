// web/src/components/HeroInteractiveView.tsx
"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import ImageWithFallback from "@/components/ImageWithFallback";
import { formatNumber, getQualityConfig } from "@/lib/utils";
import strengthenTableRaw from "@/data/character_strengthen.json";
import zodiacSetsRaw from "@/data/zodiac_sets.json";

interface ChuyenSinhMaterial {
  id: string;
  name: string;
  count: number;
  is_hero_card?: boolean;
}

interface ChuyenSinhStage {
  stage: number;
  title: string;
  prefix: string;
  story: string;
  detail: string;
  conditions?: string;
  materials: ChuyenSinhMaterial[];
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

interface SuperEvoMaterial {
  name: string;
  count: number;
  is_hero_card?: boolean;
  is_currency?: boolean;
  card_id?: string;
}

interface SuperEvoStage {
  id: string;
  name: string;
  tier: "orange" | "red" | "gold";
  unlocks_skill: number;
  skill_name?: string | null;
  materials?: SuperEvoMaterial[];
  stats: { hp: number; patk: number; matk: number; def: number; speed: number };
}

interface SuperEvoData {
  has_super_evo: boolean;
  is_base_form?: boolean;
  base_hero_id?: string;
  base_hero_name?: string;
  materials_note?: string;
  stages: SuperEvoStage[];
  evo_skill_1: string;
  evo_skill_2: string;
  break4?: number[];
  break5?: number[];
}

interface FamilyForm {
  id: string;
  name: string;
  avatar: string | null;
  quality: number;
  rebirth: number;
  is_current: boolean;
  is_base: boolean;
  has_super_evo: boolean;
  label: string;
  breakthrough_count?: number;
}

interface HeroInteractiveViewProps {
  hero: {
    id: string;
    character_id: string;
    name: string;
    quality: number;
    career?: number;
    race?: number;
    sex: number;
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
    family_forms?: FamilyForm[];
    story?: string;
  };
}

const strengthenTable: Record<string, { level: number; add_hp: number; add_patk: number; add_matk: number; add_def: number; add_speed: number; need_level: number; need_food: number }> = strengthenTableRaw;
const zodiacSetsList: any[] = zodiacSetsRaw;

export default function HeroInteractiveView({ hero }: HeroInteractiveViewProps) {
  // 1. Interactive States
  const [level, setLevel] = useState<number>(1);
  const [selectedChuyenStage, setSelectedChuyenStage] = useState<number>(0); // 0 = Chưa chuyển, 1-7
  const [activeTabChuyen, setActiveTabChuyen] = useState<number>(1); // For viewing stage details 1-7

  // Regular evolution (+1 to +60)
  const initialStreng = Math.min(60, Math.max(0, hero.streng || 0));
  const [strengthenLevel, setStrengthenLevel] = useState<number>(initialStreng > 0 ? initialStreng : 0);

  // Super Evo state (9 stages: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++)
  const [selectedSuperEvoId, setSelectedSuperEvoId] = useState<string>("none");

  // Badge interactive state
  const heroBadges = hero.badges || [];
  const [badgeEquipped, setBadgeEquipped] = useState<boolean>(heroBadges.length > 0);
  const [selectedBadgeLevel, setSelectedBadgeLevel] = useState<number>(
    heroBadges.length > 0 ? Math.min(heroBadges.length - 1, 7) : 0
  );

  // Zodiac set simulation state
  const [activeZodiacId, setActiveZodiacId] = useState<string>("none"); // 'none' or 'chuot', 'ti', 'hoi', 'rong', 'ngua'
  const [activeZodiacTab, setActiveZodiacTab] = useState<string>("chuot");

  // Compare forms modal
  const [showCompareModal, setShowCompareModal] = useState<boolean>(false);

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

  // Dynamic title based on Chuyển sinh and strengthen (+1 to +60)
  const chuyenStages = hero.chuyen_sinh?.stages || [];
  const currentStageObj = chuyenStages.find((s) => s.stage === selectedChuyenStage);
  const stagePrefix = currentStageObj ? currentStageObj.prefix : "";
  const currentTitle = stagePrefix ? `${stagePrefix}·${hero.name}` : (hero.name || `Tướng #${hero.id}`);

  // Current super evo stage object
  const superEvoStages = hero.super_evo?.stages || [];
  const currentEvoStage = superEvoStages.find((s) => s.id === selectedSuperEvoId);

  // Skills unlock status
  const isEvoSkill1Unlocked = currentEvoStage ? currentEvoStage.unlocks_skill >= 1 : false;
  const isEvoSkill2Unlocked = currentEvoStage ? currentEvoStage.unlocks_skill >= 2 : false;

  // Current badge
  const activeBadge = heroBadges.find((b) => b.level === selectedBadgeLevel) || heroBadges[0] || null;

  // Current strengthen bonus (+1 to +60)
  const currentStrengthenData = strengthenLevel > 0 ? (strengthenTable[String(strengthenLevel)] || { add_hp: 0, add_patk: 0, add_matk: 0, add_def: 0, add_speed: 0, need_level: 0, need_food: 0 }) : { add_hp: 0, add_patk: 0, add_matk: 0, add_def: 0, add_speed: 0, need_level: 0, need_food: 0 };

  // 2. Compute live combat stats
  const calculatedStats = useMemo(() => {
    const base = hero.base_stats || {};
    const growth = hero.growth_stats || {};

    // 1. Level additions: growth * (level - 1)
    const lvHp = (base.hp || 0) + (growth.hp || 0) * (level - 1);
    const lvPatk = (base.patk || 0) + (growth.patk || 0) * (level - 1);
    const lvMatk = (base.matk || 0) + (growth.matk || 0) * (level - 1);
    const lvDef = (base.def || 0) + (growth.def || 0) * (level - 1);
    const lvSpeed = (base.speed || 0) + (growth.speed || 0) * (level - 1);

    // 2. Regular Evolution Stats (+1 to +60 from character_strengthen.config)
    const stHp = currentStrengthenData.add_hp || 0;
    const stPatk = currentStrengthenData.add_patk || 0;
    const stMatk = currentStrengthenData.add_matk || 0;
    const stDef = currentStrengthenData.add_def || 0;
    const stSpeed = currentStrengthenData.add_speed || 0;

    // 3. Super Evo Flat Stats
    const evoStats = currentEvoStage?.stats || { hp: 0, patk: 0, matk: 0, def: 0, speed: 0 };
    const evoHp = evoStats.hp || 0;
    const evoPatk = evoStats.patk || 0;
    const evoMatk = evoStats.matk || 0;
    const evoDef = evoStats.def || 0;
    const evoSpeed = evoStats.speed || 0;

    // 4. Badge Flat Stats (if equipped)
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

    // 5. Zodiac Set Flat Stats (if simulated)
    let zodiacHp = 0;
    let zodiacPatk = 0;
    let zodiacMatk = 0;
    let zodiacDef = 0;
    let zodiacSpeed = 0;

    if (activeZodiacId !== "none") {
      // 4-piece zodiac set adds +270,000 ATK, +90,000 DEF, +315,000 HP
      zodiacHp = 315000;
      zodiacPatk = 270000;
      zodiacMatk = 270000;
      zodiacDef = 90000;
      zodiacSpeed = 50000;
    }

    // 6. Chuyển sinh bonus percentages: each stage from 1 to 5 grants +30% HP (up to +150% at stage 5)
    let chuyenHpPct = 0;
    if (selectedChuyenStage >= 1) chuyenHpPct = Math.min(selectedChuyenStage, 5) * 30;

    // 7. Vận mệnh (Fate Bonds) active bonus percentages
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
    const totalHp = Math.round((lvHp + stHp + evoHp + badgeHp + zodiacHp) * (1 + (chuyenHpPct + bondHpPct) / 100));
    const totalPatk = Math.round((lvPatk + stPatk + evoPatk + badgePatk + zodiacPatk) * (1 + bondPatkPct / 100));
    const totalMatk = Math.round((lvMatk + stMatk + evoMatk + badgeMatk + zodiacMatk) * (1 + bondMatkPct / 100));
    const totalDef = Math.round((lvDef + stDef + evoDef + badgeDef + zodiacDef) * (1 + bondDefPct / 100));
    const totalSpeed = Math.round((lvSpeed + stSpeed + evoSpeed + badgeSpeed + zodiacSpeed) * (1 + bondSpeedPct / 100));

    // Dynamic combat power (Lực chiến)
    const combatPower = Math.round(totalPatk * 2.5 + totalMatk * 2.5 + totalDef * 2.0 + totalHp * 0.4 + totalSpeed * 3.0);

    return {
      combatPower,
      total: { hp: totalHp, patk: totalPatk, matk: totalMatk, def: totalDef, speed: totalSpeed },
      breakdown: {
        lv: { hp: lvHp, patk: lvPatk, matk: lvMatk, def: lvDef, speed: lvSpeed },
        strengthen: { hp: stHp, patk: stPatk, matk: stMatk, def: stDef, speed: stSpeed },
        evo: { hp: evoHp, patk: evoPatk, matk: evoMatk, def: evoDef, speed: evoSpeed },
        badge: { hp: badgeHp, patk: badgePatk, matk: badgeMatk, def: badgeDef, speed: badgeSpeed },
        zodiac: { hp: zodiacHp, patk: zodiacPatk, matk: zodiacMatk, def: zodiacDef, speed: zodiacSpeed },
        percentages: {
          hp: chuyenHpPct + bondHpPct,
          patk: bondPatkPct,
          matk: bondMatkPct,
          def: bondDefPct,
          speed: bondSpeedPct,
        },
      },
    };
  }, [level, selectedChuyenStage, strengthenLevel, currentStrengthenData, currentEvoStage, badgeEquipped, activeBadge, activeZodiacId, activeVanMenh, hero]);

  const familyForms = hero.family_forms || [];

  return (
    <div className="space-y-8 animate-fade-in">
      {/* 0. DÒNG DẠNG BIẾN THỂ & CHUYỂN THẾ (FORMS & REBIRTH LINEAGE - REQUIREMENT 5) */}
      {familyForms.length > 1 && (
        <section className="rounded-3xl border border-sky-500/30 bg-gradient-to-r from-sky-950/40 via-slate-900 to-indigo-950/40 p-5 backdrop-blur-xl shadow-xl">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-sky-900/30 pb-3 mb-4">
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xl">🧬</span>
                <h3 className="text-base font-extrabold text-white">
                  Dòng Dạng Biến Thể & Chuyển Thế (Nhóm Tướng #{hero.character_id})
                </h3>
              </div>
              <p className="text-xs text-sky-200/70 mt-0.5">
                Chuyển đổi nhanh giữa bản thể thường và các dạng chuyển thế để đối chiếu kỹ năng và chỉ số.
              </p>
            </div>

            <button
              onClick={() => setShowCompareModal(!showCompareModal)}
              className="rounded-xl border border-sky-400/40 bg-sky-500/10 hover:bg-sky-500/20 px-3.5 py-1.5 text-xs font-bold text-sky-300 transition-all flex items-center gap-1.5 shadow"
            >
              <span>⚖️</span>
              <span>{showCompareModal ? "Ẩn bảng so sánh" : "So sánh các dạng"}</span>
            </button>
          </div>

          {/* Form pills */}
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
            {familyForms.map((form) => {
              const isCurrent = form.id === hero.id;
              return (
                <Link
                  key={form.id}
                  href={`/heroes/${form.id}`}
                  className={`group relative rounded-2xl border p-3 transition-all duration-200 flex items-center gap-3 ${
                    isCurrent
                      ? "border-sky-400 bg-sky-950/70 shadow-lg shadow-sky-500/20 ring-2 ring-sky-500/40"
                      : "border-slate-800 bg-slate-950/60 hover:border-slate-700 hover:bg-slate-900/60"
                  }`}
                >
                  <div className="relative h-12 w-12 shrink-0 rounded-xl overflow-hidden border border-slate-700 bg-slate-900 p-0.5">
                    <ImageWithFallback
                      src={form.avatar}
                      alt={form.name}
                      className="h-full w-full object-contain"
                      fallbackIcon="👤"
                      fallbackText="Chưa có ảnh"
                    />
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-1.5">
                      <span
                        className={`text-[9px] font-bold px-1.5 py-0.2 rounded font-mono ${
                          form.is_base
                            ? "bg-emerald-950 text-emerald-400 border border-emerald-500/40"
                            : "bg-purple-950 text-purple-300 border border-purple-500/40"
                        }`}
                      >
                        {form.label}
                      </span>
                      {isCurrent && (
                        <span className="text-[9px] font-bold text-sky-400 font-sans">
                          (Đang xem)
                        </span>
                      )}
                    </div>
                    <div className="text-xs font-extrabold text-white truncate mt-0.5 group-hover:text-sky-300 transition-colors">
                      {form.name}
                    </div>
                    <div className="text-[10px] text-slate-400 font-mono flex items-center gap-1 mt-0.5">
                      <span>ID: {form.id}</span>
                      <span>•</span>
                      <span className={form.has_super_evo ? "text-amber-400" : "text-slate-500"}>
                        {form.has_super_evo ? "⚡ Siêu Tiến Hóa" : "🔒 Chưa mở STH"}
                      </span>
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>

          {/* Expandable Comparison Matrix */}
          {showCompareModal && (
            <div className="mt-4 pt-4 border-t border-sky-900/40 animate-fade-in">
              <div className="text-xs font-bold text-sky-300 mb-2">Bảng đối chiếu tổng quan các dạng:</div>
              <div className="overflow-x-auto rounded-xl border border-slate-800 bg-slate-950/80">
                <table className="w-full text-xs text-left">
                  <thead className="bg-slate-900 text-slate-400 border-b border-slate-800">
                    <tr>
                      <th className="p-2.5">Phiên Bản</th>
                      <th className="p-2.5">Bản Thể ID</th>
                      <th className="p-2.5">Phân Loại</th>
                      <th className="p-2.5">Siêu Tiến Hóa</th>
                      <th className="p-2.5">Chuyển Sinh</th>
                      <th className="p-2.5">Thao Tác</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-800/60">
                    {familyForms.map((f) => (
                      <tr key={f.id} className={f.id === hero.id ? "bg-sky-950/30" : "hover:bg-slate-900/40"}>
                        <td className="p-2.5 font-bold text-white flex items-center gap-2">
                          <span>{f.name}</span>
                          {f.id === hero.id && <span className="text-[10px] text-sky-400">(Hiện tại)</span>}
                        </td>
                        <td className="p-2.5 font-mono text-slate-300">{f.id}</td>
                        <td className="p-2.5">
                          <span className={`px-2 py-0.5 rounded text-[10px] font-bold ${f.is_base ? "bg-emerald-950 text-emerald-300" : "bg-purple-950 text-purple-300"}`}>
                            {f.label}
                          </span>
                        </td>
                        <td className="p-2.5">
                          {f.has_super_evo ? (
                            <span className="text-amber-400 font-semibold">✓ 9 Mốc (Cam $\rightarrow$ Vàng)</span>
                          ) : (
                            <span className="text-slate-500">🔒 Chưa mở (Cần Chuyển thế)</span>
                          )}
                        </td>
                        <td className="p-2.5 text-slate-300">
                          {f.rebirth > 0 ? `Tái sinh cấp ${f.rebirth}` : "Cơ bản"}
                        </td>
                        <td className="p-2.5">
                          {f.id !== hero.id ? (
                            <Link href={`/heroes/${f.id}`} className="text-sky-400 hover:underline font-semibold">
                              Xem dạng này →
                            </Link>
                          ) : (
                            <span className="text-slate-500 italic">Đang xem</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </section>
      )}

      {/* 1. HERO MAIN CARD & AURA DISPLAY (Star section removed per requirement 3) */}
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
                {strengthenLevel > 0 ? (
                  <span className="text-amber-400 text-2xl sm:text-3xl font-mono">+{strengthenLevel}</span>
                ) : (
                  <span className="text-slate-600 text-2xl sm:text-3xl font-mono">+0</span>
                )}
              </h1>
            </div>

            {/* Combat Power & Identity Tags (STAR REMOVED) */}
            <div className="flex flex-wrap items-center justify-center md:justify-start gap-3 text-xs pt-1">
              <span className="rounded-xl border border-red-500/40 bg-red-950/40 px-3.5 py-1 text-red-300 font-bold flex items-center gap-1.5 shadow-lg shadow-red-950/30">
                <span className="text-amber-400">🔥</span> Lực chiến: <b className="font-mono text-amber-300 text-sm">{formatNumber(calculatedStats.combatPower)}</b>
              </span>
              {heroBadges.length > 0 && (
                <span className="rounded-xl border border-purple-500/30 bg-purple-500/10 px-3 py-1 text-purple-300 font-semibold flex items-center gap-1">
                  <span>🎖️</span> Có Huy Hiệu Độc Quyền ({heroBadges[0].name})
                </span>
              )}
              {activeZodiacId !== "none" && (
                <span className="rounded-xl border border-amber-500/40 bg-amber-950/60 px-3 py-1 text-amber-300 font-bold flex items-center gap-1">
                  <span>🛡️</span> Đang Kích Hoạt Set Con Giáp ({activeZodiacId.toUpperCase()})
                </span>
              )}
            </div>
          </div>
        </div>
      </div>

      {/* 2. TIẾN HÓA THƯỜNG (+0 ĐẾN +60) - REQUIREMENT 1 (KHÁC VỚI SIÊU TIẾN HÓA) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-5">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">📈</span>
              <h2 className="text-xl font-bold text-white">
                Tiến Hóa Thường (+0 đến +60)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Tiến hóa thường tăng cường chỉ số cơ bản theo từng mốc level yêu cầu và tiêu hao lương thực/pha lê (hiển thị hậu tố <b>+{strengthenLevel}</b> cạnh tên tướng như trong ảnh mẫu). <b>Khác hoàn toàn với Siêu Tiến Hóa (Cam, Đỏ, Vàng).</b>
            </p>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-xs text-slate-400">Mốc Tiến Hóa:</span>
            <span className="text-xl font-black font-mono text-amber-400 bg-amber-950/60 border border-amber-500/30 px-3 py-1 rounded-xl">
              +{strengthenLevel}
            </span>
          </div>
        </div>

        {/* Strengthen Slider & Quick Select Buttons */}
        <div className="space-y-3 rounded-2xl border border-slate-800 bg-slate-950/60 p-5">
          <div className="flex items-center justify-between text-xs text-slate-400">
            <span>Kéo chọn bậc Tiến Hóa Thường:</span>
            <span className="font-mono text-slate-300">Cấp yêu cầu: Lv.{currentStrengthenData.need_level} | Lương thực: {formatNumber(currentStrengthenData.need_food)}</span>
          </div>

          <input
            type="range"
            min={0}
            max={60}
            value={strengthenLevel}
            onChange={(e) => setStrengthenLevel(parseInt(e.target.value, 10))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-amber-500"
          />

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="text-[11px] text-slate-500">Mốc nhanh:</span>
            {[0, 10, 20, 30, 40, 50, 53, 60].map((stVal) => (
              <button
                key={stVal}
                onClick={() => setStrengthenLevel(stVal)}
                className={`rounded-lg px-2.5 py-1 text-xs font-mono font-bold transition-all ${
                  strengthenLevel === stVal
                    ? "bg-amber-500 text-slate-950 shadow"
                    : stVal === 53
                    ? "bg-amber-950/80 text-amber-300 border border-amber-500/40 hover:bg-amber-900"
                    : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
                }`}
              >
                +{stVal} {stVal === 53 ? "(Ảnh mẫu)" : stVal === 60 ? "(Max)" : ""}
              </button>
            ))}
          </div>

          {/* Stats added by current strengthen */}
          {strengthenLevel > 0 && (
            <div className="grid grid-cols-2 sm:grid-cols-5 gap-2 pt-2 border-t border-slate-800/80 text-xs">
              <div className="p-2 rounded-lg bg-red-950/20 border border-red-500/20 text-center">
                <span className="text-[10px] text-slate-400 block">HP Thêm</span>
                <b className="text-red-400 font-mono">+{formatNumber(currentStrengthenData.add_hp)}</b>
              </div>
              <div className="p-2 rounded-lg bg-amber-950/20 border border-amber-500/20 text-center">
                <span className="text-[10px] text-slate-400 block">Vật Công Thêm</span>
                <b className="text-amber-400 font-mono">+{formatNumber(currentStrengthenData.add_patk)}</b>
              </div>
              <div className="p-2 rounded-lg bg-purple-950/20 border border-purple-500/20 text-center">
                <span className="text-[10px] text-slate-400 block">Ma Công Thêm</span>
                <b className="text-purple-400 font-mono">+{formatNumber(currentStrengthenData.add_matk)}</b>
              </div>
              <div className="p-2 rounded-lg bg-sky-950/20 border border-sky-500/20 text-center">
                <span className="text-[10px] text-slate-400 block">Phòng Ngự Thêm</span>
                <b className="text-sky-400 font-mono">+{formatNumber(currentStrengthenData.add_def)}</b>
              </div>
              <div className="p-2 rounded-lg bg-emerald-950/20 border border-emerald-500/20 text-center">
                <span className="text-[10px] text-slate-400 block">Tốc Độ Thêm</span>
                <b className="text-emerald-400 font-mono">+{formatNumber(currentStrengthenData.add_speed)}</b>
              </div>
            </div>
          )}
        </div>
      </section>

      {/* 3. MỤC CHUYỂN SINH (DESIGNED EXACTLY LIKE IMAGE 1 - REQUIREMENT 4) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="border-b border-slate-800 pb-4">
          <div className="flex items-center gap-2">
            <span className="text-2xl">🔄</span>
            <h2 className="text-xl font-bold text-white">
              Chuyển Sinh (Giao Diện Chuẩn Game - Ảnh 1)
            </h2>
          </div>
          <p className="text-xs text-slate-400 mt-1">
            Giao diện mô phỏng chính xác mục Chuyển Sinh trong game với hàng huy hiệu cánh thiên thần và 4 ô nguyên liệu (Đá Chuyển Sinh, Tinh thể, Mũ/Giáp và Thẻ Tướng Clone).
          </p>
        </div>

        {chuyenStages.length > 0 ? (
          <div className="space-y-6">
            {/* Top row: Circular badges with wings & star ratings matching Image 1 */}
            <div className="flex flex-wrap items-center justify-center gap-3 sm:gap-6 py-2">
              {chuyenStages.map((st) => {
                const isSelected = activeTabChuyen === st.stage;
                const starCount = Math.min(st.stage, 5);
                const isGoldTier = st.stage >= 4;

                return (
                  <button
                    key={st.stage}
                    onClick={() => {
                      setActiveTabChuyen(st.stage);
                      setSelectedChuyenStage(st.stage);
                    }}
                    className={`group flex flex-col items-center focus:outline-none transition-transform ${
                      isSelected ? "scale-110" : "opacity-80 hover:opacity-100 hover:scale-105"
                    }`}
                  >
                    {/* Circular winged badge matching Screenshot 1 */}
                    <div
                      className={`relative flex items-center justify-center h-16 w-16 sm:h-20 sm:w-20 rounded-full border-2 transition-all shadow-xl ${
                        isSelected
                          ? isGoldTier
                            ? "border-amber-400 bg-gradient-to-b from-amber-600 via-yellow-800 to-amber-950 shadow-amber-500/40"
                            : "border-emerald-400 bg-gradient-to-b from-emerald-600 via-teal-800 to-slate-950 shadow-emerald-500/40"
                          : "border-slate-700 bg-slate-900"
                      }`}
                    >
                      {/* Wing silhouette */}
                      <span className="text-2xl sm:text-3xl select-none">
                        {isGoldTier ? "🪽" : "🦅"}
                      </span>

                      {/* Small inner avatar icon */}
                      <div className="absolute inset-2 rounded-full border border-black/40 bg-black/30 flex items-center justify-center">
                        <span className="text-xs sm:text-sm font-black text-white/90">
                          CS{st.stage}
                        </span>
                      </div>
                    </div>

                    {/* Stars below circular badge matching Screenshot 1 */}
                    <div className="flex items-center gap-0.5 mt-1">
                      {Array.from({ length: starCount }).map((_, idx) => (
                        <span key={idx} className="text-xs text-amber-400 drop-shadow">
                          ★
                        </span>
                      ))}
                    </div>

                    {/* Text Label: Chuyển 1, Chuyển 2... */}
                    <span
                      className={`text-xs font-bold mt-0.5 ${
                        isSelected ? "text-amber-300 font-black" : "text-slate-300"
                      }`}
                    >
                      Chuyển{st.stage}
                    </span>
                  </button>
                );
              })}
            </div>

            {/* Bottom row: The 4 item requirement slots with rounded red boxes matching Image 1 */}
            {(() => {
              const activeStage = chuyenStages.find((s) => s.stage === activeTabChuyen) || chuyenStages[0];
              if (!activeStage) return null;

              // Extract 4 specific materials or fallback
              const mats = activeStage.materials || [];
              const daChuyenSinh = mats.find((m) => m.name.toLowerCase().includes("chuyển sinh")) || mats[0];
              const tinhTheMat = mats.find((m) => !m.is_hero_card && m !== daChuyenSinh) || mats[1];
              const trangBiMat = mats.find((m) => !m.is_hero_card && m !== daChuyenSinh && m !== tinhTheMat) || mats[2];
              const theTuongMat = mats.find((m) => m.is_hero_card) || mats[3];

              const slotList = [
                {
                  label: "Đá Chuyển Sinh",
                  item: daChuyenSinh,
                  defaultIcon: "💎",
                  ratioText: daChuyenSinh ? `74 / ${daChuyenSinh.count}` : "0 / 150",
                  isHero: false
                },
                {
                  label: "Tinh Thể / Linh Phách",
                  item: tinhTheMat,
                  defaultIcon: "🔮",
                  ratioText: tinhTheMat ? `0 / ${tinhTheMat.count}` : "0 / 40",
                  isHero: false
                },
                {
                  label: "Trang Bị Khí Lực",
                  item: trangBiMat,
                  defaultIcon: "🛡️",
                  ratioText: trangBiMat ? `0 / ${trangBiMat.count}` : "0 / 40",
                  isHero: false
                },
                {
                  label: "Thẻ Tướng Bản Sao",
                  item: theTuongMat,
                  defaultIcon: "🃏",
                  ratioText: theTuongMat ? `6 / ${theTuongMat.count}` : "6 / 2",
                  isHero: true
                }
              ];

              return (
                <div className="rounded-2xl border border-slate-800 bg-black/60 p-6 space-y-5">
                  <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-slate-800/80 pb-3">
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

                  {/* 4 Materials Boxes Matching Screenshot 1 */}
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
                    {slotList.map((slot, sIdx) => (
                      <div key={sIdx} className="flex flex-col items-center gap-2">
                        {/* Box with glowing red border */}
                        <div className="relative h-20 w-20 sm:h-24 sm:w-24 rounded-2xl border-2 border-red-600 bg-gradient-to-b from-red-950/60 to-black p-2 flex items-center justify-center shadow-lg shadow-red-900/40">
                          {slot.item?.is_hero_card ? (
                            <div className="h-full w-full rounded-xl overflow-hidden bg-slate-900 flex items-center justify-center">
                              <span className="text-3xl">👤</span>
                            </div>
                          ) : (
                            <span className="text-3xl select-none">{slot.defaultIcon}</span>
                          )}

                          {/* Item name tooltip tag */}
                          <div className="absolute -top-2 px-1.5 py-0.2 bg-black/90 border border-slate-700 rounded text-[9px] text-slate-300 truncate max-w-[90px]">
                            {slot.item?.name || slot.label}
                          </div>
                        </div>

                        {/* Ratio Pill matching Screenshot 1 (e.g. 74 / 150) */}
                        <div className="rounded-xl border border-red-950 bg-black/90 px-3 py-1 font-mono text-xs font-bold">
                          <span className="text-slate-300">{slot.ratioText.split("/")[0]}</span>
                          <span className="text-slate-500"> / </span>
                          <span className="text-red-500 font-black">{slot.ratioText.split("/")[1] || "0"}</span>
                        </div>
                      </div>
                    ))}
                  </div>

                  {/* Story & Passive Buff Details */}
                  <div className="rounded-xl border border-slate-800 bg-slate-900/40 p-4 space-y-2 text-xs">
                    <div className="text-slate-400 font-semibold uppercase tracking-wider">
                      Cơ chế & Kỹ năng tăng cường ở Chuyển {activeStage.stage}:
                    </div>
                    <div className="text-slate-200 whitespace-pre-line leading-relaxed">
                      {activeStage.story || "Tăng cường năng lực cơ bản của tướng."}
                    </div>
                    {activeStage.detail && (
                      <div className="text-amber-200/90 whitespace-pre-line leading-relaxed pt-1 border-t border-slate-800/80">
                        {activeStage.detail}
                      </div>
                    )}
                  </div>
                </div>
              );
            })()}
          </div>
        ) : (
          <div className="rounded-2xl border border-slate-800 bg-slate-950/40 p-6 text-center text-xs text-slate-400">
            Bản thể tướng này chưa có dữ liệu mốc Chuyển sinh riêng.
          </div>
        )}
      </section>

      {/* 4. MỤC SIÊU TIẾN HÓA & ĐÚC HỒN (DESIGNED EXACTLY LIKE IMAGE 2 - REQUIREMENT 4) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">✨</span>
              <h2 className="text-xl font-bold text-white">
                Siêu Tiến Hóa (Giao Diện Đúc Hồn - Ảnh 2)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Giao diện mô phỏng chuẩn màn hình Đúc Hồn trong game với khung thẻ chính, ô 4 thẻ nguyên liệu và phân loại chi tiết nguyên liệu cần thiết.
            </p>
          </div>

          {/* Lực chiến Badge matching Screenshot 2 */}
          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Lực Chiến Đúc Hồn</div>
            <div className="text-xl sm:text-2xl font-black font-mono text-red-500">
              {formatNumber(calculatedStats.combatPower > 100000000 ? 2147483647 : calculatedStats.combatPower)}
            </div>
          </div>
        </div>

        {/* 9 Stage Selector Buttons */}
        <div className="space-y-3">
          <div className="text-xs uppercase font-bold text-slate-400 tracking-wider">
            Chọn Mốc Siêu Tiến Hóa (Cam $\rightarrow$ Đỏ $\rightarrow$ Vàng):
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

        {/* Layout 2 columns matching Screenshot 2: Hero Card Frame on Left + "Hiệu quả đúc hồn" on Right */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Left Column: Hero Card Frame matching Screenshot 2 */}
          <div className="rounded-2xl border-2 border-amber-500/40 bg-gradient-to-b from-amber-950/40 via-red-950/30 to-black p-5 flex flex-col items-center justify-between gap-4 text-center shadow-xl">
            {/* Wing decoration top left */}
            <div className="w-full flex items-center justify-between text-xs text-amber-300 font-bold">
              <span>🪽 Đúc Hồn</span>
              <span className="rounded-full bg-amber-500/20 px-2 py-0.5 text-[10px] border border-amber-500/30">
                Tập hợp - Hộ Uy
              </span>
            </div>

            {/* Avatar inside card frame */}
            <div className="relative h-44 w-36 rounded-xl overflow-hidden border-2 border-amber-400 bg-slate-950 p-1 shadow-2xl">
              <ImageWithFallback
                src={hero.avatar}
                alt={currentTitle}
                className="h-full w-full object-contain"
                fallbackIcon="👤"
                fallbackText="Chưa có ảnh"
              />
              <div className="absolute bottom-1 inset-x-1 rounded bg-black/85 backdrop-blur py-0.5 text-[10px] font-mono text-amber-400 text-center font-bold">
                Lv.255/255
              </div>
            </div>

            {/* Title with Evolution Prefix and Strengthen Level (+53) matching Screenshot 2 */}
            <div className="space-y-1">
              <div className="text-sm sm:text-base font-black text-white">
                {currentTitle} <span className="text-amber-400 font-mono">+{strengthenLevel}</span>
              </div>
              <div className="text-[11px] text-slate-400">
                Bản thể ID: {hero.id} • Nhóm #{hero.character_id}
              </div>
            </div>

            <button className="w-full rounded-xl border border-amber-500/40 bg-amber-950/60 hover:bg-amber-900/60 py-2 text-xs font-bold text-amber-300 transition-colors">
              Tra Cứu Tiến Hóa
            </button>
          </div>

          {/* Right Column: "Hiệu quả đúc hồn" Box matching Screenshot 2 */}
          <div className="lg:col-span-2 rounded-2xl border border-slate-800 bg-slate-950/80 p-6 space-y-4 flex flex-col justify-between">
            <div className="space-y-3">
              <div className="flex items-center justify-between border-b border-slate-800 pb-2">
                <span className="text-xs uppercase font-extrabold text-amber-400 tracking-wider">
                  Hiệu Quả Đúc Hồn
                </span>
                <span className="text-xs text-slate-400">
                  {currentEvoStage ? `Đang chọn mốc: ${currentEvoStage.name}` : "Chưa chọn mốc"}
                </span>
              </div>

              {/* Requirement Note: Distinguishing before and after transformation */}
              <div className="rounded-xl border border-amber-500/30 bg-amber-950/20 p-4 text-xs space-y-2">
                <div className="font-bold text-amber-300 flex items-center gap-1.5">
                  <span>📌</span> Quy Tắc Nguyên Liệu Đúc Hồn (Trước vs Sau Chuyển Thế):
                </div>
                <p className="text-slate-200 leading-relaxed font-sans">
                  {hero.super_evo?.materials_note || "Tướng trước chuyển thế chưa mở khóa siêu tiến hóa. Tướng sau chuyển thế cần Chuyển Thế Đơn hoặc Thẻ Bản Thể Gốc."}
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1 text-[11px]">
                  <div className="p-2 rounded bg-black/40 border border-slate-800">
                    <b className="text-orange-400">Mốc Lẻ (Cam, Cam++, Đỏ+, Vàng, Vàng++):</b>
                    <div className="text-slate-300 mt-0.5">20 Chuyển Thế Đơn + Tinh Hoa + Đá Năng Lượng + Vàng</div>
                  </div>
                  <div className="p-2 rounded bg-black/40 border border-slate-800">
                    <b className="text-amber-400">Mốc Chẵn (Cam+, Đỏ, Đỏ++, Vàng+):</b>
                    <div className="text-slate-300 mt-0.5">
                      <b>1 Thẻ Bản Thể Gốc [{hero.super_evo?.base_hero_name || "Gốc"}]</b> + Tinh Hoa + Đá + Vàng
                    </div>
                  </div>
                </div>
              </div>

              {/* Current Stage Materials Breakdown */}
              {currentEvoStage && currentEvoStage.materials && (
                <div className="space-y-1.5 pt-1">
                  <div className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                    Nguyên Liệu Cần Để Đúc Hồn Mốc {currentEvoStage.name}:
                  </div>
                  <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                    {currentEvoStage.materials.map((m, mIdx) => (
                      <div key={mIdx} className="p-2.5 rounded-xl border border-slate-800 bg-slate-900/60 text-center space-y-1">
                        <span className="text-xl block">{m.is_hero_card ? "🃏" : m.is_currency ? "🪙" : "💎"}</span>
                        <div className="text-[11px] font-bold text-white truncate">{m.name}</div>
                        <div className="text-xs font-mono text-amber-400 font-black">
                          {m.is_currency ? `${formatNumber(m.count)}` : `x${m.count}`}
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </div>

            {/* Bottom 4 Hero Sacrifice Slots matching Screenshot 2 */}
            <div className="pt-4 border-t border-slate-800/80 space-y-3">
              <div className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                Ô Đặt Thẻ Nguyên Liệu Đúc Hồn (Ảnh 2):
              </div>
              <div className="grid grid-cols-4 gap-3">
                {[1, 2, 3, 4].map((slotIdx) => (
                  <div
                    key={slotIdx}
                    className="relative h-16 sm:h-20 rounded-xl border-2 border-slate-700 bg-slate-900 flex items-center justify-center shadow hover:border-amber-400 transition-colors cursor-pointer group"
                  >
                    <span className="text-2xl opacity-40 group-hover:opacity-80">👤</span>
                    {/* Green + badge matching Screenshot 2 */}
                    <div className="absolute bottom-1 right-1 h-5 w-5 rounded-full bg-emerald-600 border border-emerald-400 flex items-center justify-center text-white text-xs font-black shadow">
                      +
                    </div>
                  </div>
                ))}
              </div>

              {/* Buttons matching Screenshot 2 */}
              <div className="grid grid-cols-2 gap-3 pt-1">
                <button className="rounded-xl border border-amber-600 bg-gradient-to-r from-amber-700 to-yellow-700 hover:from-amber-600 hover:to-yellow-600 py-2.5 text-xs font-black text-white shadow-lg shadow-amber-900/30 transition-all">
                  Đúc Hồn
                </button>
                <button className="rounded-xl border border-slate-700 bg-slate-800 hover:bg-slate-700 py-2.5 text-xs font-bold text-slate-300 transition-all">
                  Tự Động Tăng
                </button>
              </div>
            </div>
          </div>
        </div>

        {/* 2 Evolution Skills Cards (Diêm Vương Luân Hồi Phục Sinh & Ngoại đạo ma tượng) */}
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

      {/* 5. 5 ĐẠI BỘ TRANG BỊ CON GIÁP (CHUỘT, TỊ, HỢI, RỒNG, NGỰA) - REQUIREMENT 2 */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🛡️</span>
              <h2 className="text-xl font-bold text-white">
                5 Đại Bộ Trang Bị Con Giáp (Chuột, Tị, Hợi, Rồng, Ngựa)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              5 bộ trang bị hoàng đạo uy lực tối thượng trong game. Khám phá tướng tương thích và kích hoạt trực tiếp vào bảng mô phỏng sức mạnh.
            </p>
          </div>

          {activeZodiacId !== "none" ? (
            <button
              onClick={() => setActiveZodiacId("none")}
              className="rounded-xl border border-red-500/40 bg-red-950/60 px-4 py-2 text-xs font-bold text-red-300 hover:bg-red-900/60 transition-all shadow"
            >
              ✕ Bỏ trang bị Set {activeZodiacId.toUpperCase()}
            </button>
          ) : (
            <div className="text-xs text-slate-400 italic">
              (Chưa trang bị set con giáp)
            </div>
          )}
        </div>

        {/* 5 Zodiac Tab Switcher */}
        <div className="grid grid-cols-2 sm:grid-cols-5 gap-2">
          {zodiacSetsList.map((z) => (
            <button
              key={z.id}
              onClick={() => setActiveZodiacTab(z.id)}
              className={`rounded-2xl p-3 text-center transition-all border ${
                activeZodiacTab === z.id
                  ? "border-amber-400 bg-amber-950/50 shadow-lg shadow-amber-500/20"
                  : "border-slate-800 bg-slate-950/60 hover:bg-slate-900 text-slate-400"
              }`}
            >
              <span className="text-2xl block mb-1">{z.icon}</span>
              <div className="text-xs font-extrabold text-white truncate">{z.name}</div>
              <div className="text-[10px] text-amber-400 mt-0.5">{z.theme}</div>
            </button>
          ))}
        </div>

        {/* Selected Zodiac Set Detail */}
        {(() => {
          const zSet = zodiacSetsList.find((z) => z.id === activeZodiacTab) || zodiacSetsList[0];
          if (!zSet) return null;

          const isSimulated = activeZodiacId === zSet.id;
          const currentVariant = zSet.variants[0]; // Primary variant

          return (
            <div className="rounded-2xl border border-amber-500/30 bg-slate-950/80 p-6 space-y-5">
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-slate-800 pb-3">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-2xl">{zSet.icon}</span>
                    <h3 className="text-lg font-black text-white">{zSet.name} - {zSet.theme}</h3>
                  </div>
                  <p className="text-xs text-amber-200/90 mt-1">{zSet.description}</p>
                </div>

                <button
                  onClick={() => setActiveZodiacId(isSimulated ? "none" : zSet.id)}
                  className={`rounded-xl px-4 py-2 text-xs font-bold transition-all shadow ${
                    isSimulated
                      ? "bg-amber-500 text-slate-950 font-black shadow-amber-500/40"
                      : "border border-amber-500/40 bg-amber-950/40 text-amber-300 hover:bg-amber-900/60"
                  }`}
                >
                  {isSimulated ? "✓ Đang trang bị vào chỉ số tướng" : "+ Trang bị thử bộ này vào tướng"}
                </button>
              </div>

              {/* 4 Parts Display */}
              <div className="space-y-2">
                <div className="text-xs font-bold text-slate-400 uppercase tracking-wider">
                  4 Món Trang Bị Thuộc Bộ (Phẩm 7 - Linh Thần):
                </div>
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                  {currentVariant.parts.map((p: any, idx: number) => (
                    <div key={idx} className="rounded-xl border border-slate-800 bg-slate-900/80 p-3 flex items-center gap-3">
                      <div className="h-10 w-10 shrink-0 rounded-lg border border-amber-500/30 bg-slate-950 flex items-center justify-center text-xl">
                        {p.slot_name === "Vũ khí" ? "⚔️" : p.slot_name === "Áo giáp" ? "🛡️" : p.slot_name === "Trang sức" ? "💍" : "👢"}
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="text-[10px] text-amber-400 font-semibold">{p.slot_name}</div>
                        <div className="text-xs font-bold text-white truncate">{p.name}</div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              {/* Set Effects & Best Heroes Synergy */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 pt-1">
                {/* Set Bonuses */}
                <div className="rounded-xl border border-slate-800 bg-slate-900/50 p-4 space-y-2">
                  <div className="text-xs font-bold text-amber-400 uppercase tracking-wider">
                    Hiệu Ứng Kích Hoạt Bộ Trang Bị
                  </div>
                  <div className="space-y-1.5 text-xs">
                    <div className="flex items-center justify-between text-slate-300 py-1 border-b border-slate-800/60">
                      <span>Mốc 2 món:</span>
                      <span className="font-mono text-emerald-400 font-semibold">{currentVariant.bonuses.two_piece}</span>
                    </div>
                    <div className="flex items-center justify-between text-slate-300 py-1 border-b border-slate-800/60">
                      <span>Mốc 3 món:</span>
                      <span className="font-mono text-emerald-400 font-semibold">{currentVariant.bonuses.three_piece}</span>
                    </div>
                    <div className="flex items-center justify-between text-slate-300 py-1">
                      <span>Mốc 4 món:</span>
                      <span className="font-mono text-amber-400 font-bold">{currentVariant.bonuses.four_piece}</span>
                    </div>
                  </div>
                </div>

                {/* Best Heroes Recommendation */}
                <div className="rounded-xl border border-slate-800 bg-slate-900/50 p-4 space-y-2">
                  <div className="text-xs font-bold text-sky-400 uppercase tracking-wider">
                    Tướng Tương Thích & Kích Hoạt Vận Mệnh Tối Ưu
                  </div>
                  <div className="space-y-1.5 text-xs">
                    {zSet.best_heroes.map((bh: any, idx: number) => (
                      <div key={idx} className="flex items-start gap-2 py-1 border-b border-slate-800/60 last:border-0">
                        <span className="font-bold text-amber-300 shrink-0">• {bh.name}:</span>
                        <span className="text-slate-300 font-sans">{bh.reason}</span>
                      </div>
                    ))}
                  </div>
                </div>
              </div>
            </div>
          );
        })()}
      </section>

      {/* 6. STAT SIMULATOR & LEVEL CONTROLS (1 - 255) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <h2 className="text-xl font-bold text-white flex items-center gap-2">
              <span>📈</span>
              Tùy Chọn Level (1 - 255) & Bảng Thuộc Tính Tổng Hợp
            </h2>
            <p className="text-xs text-slate-400 mt-1">
              Chỉ số tự động tính toán dựa trên: <b>Cấp độ ({level})</b> + <b>Tiến hóa (+{strengthenLevel})</b> + <b>Chuyển sinh ({selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage}` : "Gốc"})</b> + <b>Siêu tiến hóa ({currentEvoStage?.name || "Chưa"})</b> + <b>Huy hiệu ({badgeEquipped ? `Cấp ${selectedBadgeLevel}` : "Tắt"})</b> + <b>Set Con Giáp ({activeZodiacId.toUpperCase()})</b> + <b>Vận mệnh</b>.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => {
                setLevel(1);
                setStrengthenLevel(0);
                setSelectedChuyenStage(0);
                setSelectedSuperEvoId("none");
                setActiveZodiacId("none");
                setAllVanMenh(false);
              }}
              className="rounded-xl border border-slate-700 bg-slate-800/80 px-3 py-1.5 text-xs text-slate-400 hover:text-white transition-colors"
            >
              Mặc định (Lv.1 +0)
            </button>
            <button
              onClick={() => {
                setLevel(255);
                setStrengthenLevel(60);
                setSelectedChuyenStage(7);
                setSelectedSuperEvoId("vang_plus2");
                setActiveZodiacId("chuot");
                setAllVanMenh(true);
              }}
              className="rounded-xl border border-amber-500/40 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-300 hover:bg-amber-500/20 transition-colors shadow-lg shadow-amber-500/10"
            >
              ⚡ Tối Đa Sức Mạnh (Max Lv.255 +60 + CS7 + Vàng++ + Set Con Giáp)
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

      {/* 7. HUY HIỆU CỦA TƯỚNG (NẾU CÓ) */}
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
                Tinh luyện vận mệnh: <span className="font-mono text-slate-300">Mức {activeBadge.refine}</span> | Đột phá: <span className="font-mono text-slate-300">#{activeBadge.badge_break || "Max"}</span>
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
            Hiện tại 14 thẻ tướng chủ lực sở hữu Huy Hiệu cá nhân trong cấu hình game.
          </div>
        )}
      </section>

      {/* 8. VẬN MỆNH (KÍCH HOẠT VẬN MỆNH) */}
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
                        onChange={() => {}}
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

                  <div className="text-xs sm:text-sm text-slate-200 leading-relaxed font-sans pl-7">
                    {vm.description}
                  </div>

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

      {/* 9. SKILLS LIST (7 Ô KỸ NĂNG NGUYÊN BẢN) */}
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

      {/* 10. SYSTEM & METADATA */}
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
