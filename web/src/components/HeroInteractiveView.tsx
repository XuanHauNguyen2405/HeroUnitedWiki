// web/src/components/HeroInteractiveView.tsx
"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import HeroSection from "@/components/HeroSection";
import ElementBadge from "@/components/ElementBadge";
import HeroSkillCard from "@/components/HeroSkillCard";
import HeroCard from "@/components/HeroCard";
import HeroStandingArt from "@/components/HeroStandingArt";
import HeroBanSucCard from "@/components/HeroBanSucCard";
import { getSuperEvoStages, getBreakthroughStages, isSuperEvoUpgrade, maxStrengthenAtLevel } from "@/lib/hero-progression";
import { formatNumber, getQualityConfig } from "@/lib/utils";
import strengthenTableRaw from "@/data/character_strengthen.json";
import EquipmentAdvisor from "@/components/EquipmentAdvisor";
import HeroIdentityBadges from "@/components/HeroIdentityBadges";
import { combatProfiles, equipmentStats, emptySelection, recommendations, resolveVariant, type Selection } from "@/lib/equipment-advisor";
import { elements, getElement } from "@/lib/game-attributes";
import banSucRecommendationsRaw from "@/data/ban_suc_recommendations.json";

const mapSuperEvoIdToStage = (id: string | null | undefined): number => {
  switch (id) {
    case "cam": return 0;
    case "cam_plus": return 1;
    case "cam_plus2": return 2;
    case "do": return 3;
    case "do_plus": return 4;
    case "do_plus2": return 5;
    case "vang": return 6;
    case "vang_plus": return 7;
    case "vang_plus2": return 8;
    default: return 0;
  }
};

interface ChuyenSinhMaterial {
  id: string;
  name: string;
  count: number;
  is_hero_card?: boolean;
  icon?: string | null;
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
  id?: string;
  name: string;
  count: number;
  is_hero_card?: boolean;
  is_currency?: boolean;
  card_id?: string;
  icon?: string | null;
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

interface BreakthroughMaterial {
  id: string;
  name: string;
  count: number;
  is_hero_card?: boolean;
  is_currency?: boolean;
  icon?: string | null;
}

interface BreakthroughStage {
  step: number;
  step_name: string;
  need_money: number;
  materials: BreakthroughMaterial[];
  stats: {
    hp: number;
    patk: number;
    matk: number;
    def: number;
    speed: number;
    attributes?: Record<string, number>;
    ele_atk?: number;
    ele_def?: number;
  };
}

interface BreakthroughSystemData {
  has_breakthrough: boolean;
  max_step: number;
  stages: BreakthroughStage[];
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
    evolution?: { is_evo?: number };
    avatar: string | null;
    standing_image?: string | null;
    card_image?: string | null;
    full_image?: string | null;
    animation?: string | null;
    is_world?: boolean;
    occupation_type?: number;
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
    breakthrough_system?: BreakthroughSystemData;
    badges?: BadgeItem[];
    family_forms?: FamilyForm[];
    elemental_builds?: any[];
    story?: string;
  };
  familyHeroes?: Record<string, HeroInteractiveViewProps["hero"]>;
  showBreadcrumbs?: boolean;
}

const strengthenTable: Record<string, { level: number; add_hp: number; add_patk: number; add_matk: number; add_def: number; add_speed: number; need_level: number; need_food: number }> = strengthenTableRaw;

function getMaterialIcon(
  m: { id?: string; name?: string; icon?: string | null; is_hero_card?: boolean; is_currency?: boolean },
  fallbackIcon: string = "💎"
): string {
  if (m.icon) return m.icon;
  const name = (m.name || "").toLowerCase();
  const id = m.id || "";

  if (m.is_currency || name.includes("vàng") || name.includes("tiền")) {
    return "/assets/iphonehd/icon/icon_maze_gold.png";
  }
  if (id === "3101" || name.includes("chuyển thế đơn")) {
    return "/assets/iphonehd/icon/zhuanshi_shitou.png";
  }
  if (id === "532" || name.includes("tinh hoa")) {
    return "/assets/iphonehd/icon/yuansujinghua.png";
  }
  if (id === "900000" || name.includes("đá chuyển sinh")) {
    return "/assets/iphonehd/icon/i_b_0_0.png";
  }
  if (id === "930000" || name.includes("cao cấp")) {
    return "/assets/iphonehd/icon/i_c_gaojizhuansheng.png";
  }
  if (id === "535" || (name.includes("đá năng lượng") && (name.includes("lửa") || name.includes("hỏa")))) {
    return "/assets/iphonehd/icon/huonengliangshi.png";
  }
  if (id === "534" || (name.includes("đá năng lượng") && (name.includes("nước") || name.includes("thủy")))) {
    return "/assets/iphonehd/icon/shuinengliangshi.png";
  }
  if (id === "536" || (name.includes("đá năng lượng") && (name.includes("gió") || name.includes("phong")))) {
    return "/assets/iphonehd/icon/fengnengliangshi.png";
  }
  if (id === "533" || (name.includes("đá năng lượng") && (name.includes("đất") || name.includes("thổ")))) {
    return "/assets/iphonehd/icon/dinengliangshi.png";
  }
  if (name.includes("năng lượng") || name.includes("năng tinh")) {
    return "/assets/iphonehd/icon/dinengliangshi.png";
  }
  if (name.includes("giáp")) {
    return "/assets/iphonehd/icon/i_c_lingpozhijia.png";
  }
  if (name.includes("mũ")) {
    return "/assets/iphonehd/icon/i_c_lingpozhikui.png";
  }
  if (name.includes("kiếm")) {
    return "/assets/iphonehd/icon/i_c_lingpozhijian.png";
  }
  if (name.includes("đá")) {
    return "/assets/iphonehd/icon/i_c_lingpozhishi.png";
  }
  if (name.includes("linh hồn") || name.includes("hồn")) {
    return "/assets/iphonehd/icon/hun.png";
  }
  return fallbackIcon;
}

export default function HeroInteractiveView({
  hero,
  familyHeroes,
  showBreadcrumbs = false,
}: HeroInteractiveViewProps) {
  const [activeHeroId, setActiveHeroId] = useState<string>(String(hero.id));
  const activeHero = (familyHeroes && familyHeroes[activeHeroId]) || hero;

  const handleSelectForm = (formId: string) => {
    const nextId = String(formId);
    if (nextId === String(activeHero.id)) return;
    if (familyHeroes && familyHeroes[nextId]) {
      setActiveHeroId(nextId);
      if (typeof document !== "undefined") {
        const target = familyHeroes[nextId];
        document.title = `${target.name || `Tướng #${nextId}`} (ID: ${nextId}) - Siêu Anh Hùng Hội Tụ WIKI`;
      }
    }
  };

  return (
    <>
      {showBreadcrumbs && (
        <Breadcrumbs
          items={[
            { label: "Danh Sách Tướng", href: "/heroes" },
            { label: `${activeHero.name || `Tướng #${activeHero.id}`} (ID: ${activeHero.id})` },
          ]}
        />
      )}
      <HeroInteractiveViewContent
        key={activeHero.id}
        hero={activeHero}
        onSelectForm={familyHeroes ? handleSelectForm : undefined}
      />
    </>
  );
}

function HeroInteractiveViewContent({
  hero,
  onSelectForm,
}: {
  hero: HeroInteractiveViewProps["hero"];
  onSelectForm?: (formId: string) => void;
}) {
  // 1. Interactive States
  const levelLimit = hero.level_max > 0 ? hero.level_max : 255;
  const supportsStrengthening = hero.evolution?.is_evo === 1;
  const [level, setLevelState] = useState<number>(1);
  const [selectedChuyenStage, setSelectedChuyenStage] = useState<number>(0); // 0 = Chưa chuyển, 1-7
  const [activeTabChuyen, setActiveTabChuyen] = useState<number>(1); // For viewing stage details 1-7

  // Regular evolution (+1 to +60) - Default to 0 (no +3 default)
  const [strengthenLevel, setStrengthenLevel] = useState<number>(0);
  const maxStrengthen = maxStrengthenAtLevel(level, supportsStrengthening, strengthenTable);
  function setLevel(value: number) {
    const next = Math.min(levelLimit, Math.max(1, value));
    setLevelState(next);
    setStrengthenLevel(previous => Math.min(previous, maxStrengthenAtLevel(next, supportsStrengthening, strengthenTable)));
  }

  // Super Evo state (9 stages: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++) - Default to "cam" (Base form)
  const superEvoStages = getSuperEvoStages(hero);
  const defaultSuperEvoId = superEvoStages[0]?.id || "none";
  const [selectedSuperEvoId, setSelectedSuperEvoId] = useState<string>(defaultSuperEvoId);

  // Breakthrough system state (1 to 20 stages from breakthrough.config) - Default to stage 1
  const breakthroughStages = getBreakthroughStages(hero);
  const defaultBreakthroughStep = 0;
  const [selectedBreakthroughStep, setSelectedBreakthroughStep] = useState<number>(defaultBreakthroughStep);

  // Badge interactive state
  const heroBadges = hero.badges || [];
  const [badgeEquipped, setBadgeEquipped] = useState<boolean>(heroBadges.length > 0);
  const [selectedBadgeLevel, setSelectedBadgeLevel] = useState<number>(
    heroBadges.length > 0 ? Math.min(heroBadges.length - 1, 7) : 0
  );

  const [equipmentSelection, setEquipmentSelection] = useState<Selection>(emptySelection);
  const activeZodiacId = equipmentSelection.setId;
  const isZodiacRainbow = equipmentSelection.rainbow;
  const equippedVariant = resolveVariant(equipmentSelection);
  const equippedElement = getElement(equippedVariant?.element_id);

  // User Guide: Ban Sức Khuyến Nghị for this hero
  const banSucRecommendation = useMemo(() => {
    return (banSucRecommendationsRaw as any)?.heroes?.[String(hero.id)] || null;
  }, [hero.id]);

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
  const currentEvoStage = superEvoStages.find((s) => s.id === selectedSuperEvoId) || superEvoStages[0];
  const hasSuperEvo = superEvoStages.length > 0;
  const hasSuperEvoUpgrade = isSuperEvoUpgrade(currentEvoStage);
  const superEvoLabel = currentEvoStage?.name || "Chưa có dữ liệu STH";
  const frameStage = hasSuperEvoUpgrade ? mapSuperEvoIdToStage(currentEvoStage?.id) : 0;

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
    const evoStats = (hasSuperEvoUpgrade ? currentEvoStage?.stats : undefined) || { hp: 0, patk: 0, matk: 0, def: 0, speed: 0 };
    const evoHp = evoStats.hp || 0;
    const evoPatk = evoStats.patk || 0;
    const evoMatk = evoStats.matk || 0;
    const evoDef = evoStats.def || 0;
    const evoSpeed = evoStats.speed || 0;

    // 3.5. Breakthrough System Flat Stats (20 stages from breakthrough.config)
    const btStages = getBreakthroughStages(hero);
    const currentBtStage = selectedBreakthroughStep > 0 && selectedBreakthroughStep <= btStages.length
      ? btStages[selectedBreakthroughStep - 1]
      : null;
    const btStats = currentBtStage?.stats || { attributes: {} as Record<string, number>, hp: 0, patk: 0, matk: 0, def: 0, speed: 0, ele_atk: 0, ele_def: 0 };
    const btHp = btStats.hp || 0;
    const btPatk = btStats.patk || 0;
    const btMatk = btStats.matk || 0;
    const btDef = btStats.def || 0;
    const btSpeed = btStats.speed || 0;
    const btEleDmg = btStats.ele_atk || 0;

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

    // One resolver supplies the exact selected variant to UI and calculations.
    const gear = equipmentStats(equipmentSelection);
    const zodiacHp = gear.hp ?? 0;
    const zodiacPatk = gear.patk ?? 0;
    const zodiacMatk = gear.matk ?? 0;
    const zodiacDef = gear.def ?? 0;
    const zodiacSpeed = gear.speed ?? 0;
    const zodiacEleDmg = equippedElement ? gear[equippedElement.id] ?? 0 : 0;
    const elementTotals = Object.fromEntries(Object.values(elements).map(element =>
      [element.id, (gear[element.id] ?? 0) + (btStats.attributes?.[element.id] ?? 0)]));

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
    const totalHp = Math.round((lvHp + stHp + evoHp + btHp + badgeHp + zodiacHp) * (1 + (chuyenHpPct + bondHpPct) / 100));
    const totalPatk = Math.round((lvPatk + stPatk + evoPatk + btPatk + badgePatk + zodiacPatk) * (1 + bondPatkPct / 100));
    const totalMatk = Math.round((lvMatk + stMatk + evoMatk + btMatk + badgeMatk + zodiacMatk) * (1 + bondMatkPct / 100));
    const totalDef = Math.round((lvDef + stDef + evoDef + btDef + badgeDef + zodiacDef) * (1 + bondDefPct / 100));
    const totalSpeed = Math.round((lvSpeed + stSpeed + evoSpeed + btSpeed + badgeSpeed + zodiacSpeed) * (1 + bondSpeedPct / 100));

    // Dynamic combat power (Lực chiến)
    const combatPower = Math.round(
      totalPatk * 2.5 +
      totalMatk * 2.5 +
      totalDef * 2.0 +
      totalHp * 0.4 +
      totalSpeed * 3.0 +
      (zodiacEleDmg + btEleDmg) * 2.0
    );

    return {
      combatPower,
      elementTotals,
      total: { hp: totalHp, patk: totalPatk, matk: totalMatk, def: totalDef, speed: totalSpeed, elementalDamage: zodiacEleDmg + btEleDmg },
      breakdown: {
        lv: { hp: lvHp, patk: lvPatk, matk: lvMatk, def: lvDef, speed: lvSpeed },
        strengthen: { hp: stHp, patk: stPatk, matk: stMatk, def: stDef, speed: stSpeed },
        evo: { hp: evoHp, patk: evoPatk, matk: evoMatk, def: evoDef, speed: evoSpeed },
        breakthrough: { hp: btHp, patk: btPatk, matk: btMatk, def: btDef, speed: btSpeed, eleDmg: btEleDmg },
        badge: { hp: badgeHp, patk: badgePatk, matk: badgeMatk, def: badgeDef, speed: badgeSpeed },
        zodiac: { hp: zodiacHp, patk: zodiacPatk, matk: zodiacMatk, def: zodiacDef, speed: zodiacSpeed, eleDmg: zodiacEleDmg },
        percentages: {
          hp: chuyenHpPct + bondHpPct,
          patk: bondPatkPct,
          matk: bondMatkPct,
          def: bondDefPct,
          speed: bondSpeedPct,
        },
      },
    };
  }, [level, selectedChuyenStage, strengthenLevel, currentStrengthenData, currentEvoStage, hasSuperEvoUpgrade, selectedBreakthroughStep, badgeEquipped, activeBadge, equipmentSelection, equippedElement, activeVanMenh, hero]);

  const familyForms = hero.family_forms || [];

  return (
    <div className="hero-detail space-y-8 animate-fade-in">
      {/* 0. DÒNG DẠNG BIẾN THỂ & CHUYỂN THẾ (FORMS & REBIRTH LINEAGE - REQUIREMENT 5) */}
      {familyForms.length > 1 && (
        <HeroSection className="rounded-3xl border border-sky-500/30 bg-gradient-to-r from-sky-950/40 via-slate-900 to-indigo-950/40 p-5 backdrop-blur-xl shadow-xl">
          <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-sky-900/30 pb-3 mb-4">
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xl">🧬</span>
                <h3 className="text-base font-extrabold text-white">
                  Dòng Dạng Biến Thể & Chuyển Thế
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
                  replace
                  scroll={false}
                  onClick={(e) => {
                    if (onSelectForm) {
                      e.preventDefault();
                      onSelectForm(form.id);
                    }
                  }}
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
                        {form.has_super_evo ? "⚡ Siêu Tiến Hóa" : "Chưa có dữ liệu STH"}
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
                            <span className="text-amber-400 font-semibold">✓ 9 Mốc (Cam → Vàng)</span>
                          ) : (
                            <span className="text-slate-500">🔒 Chưa mở (Cần Chuyển thế)</span>
                          )}
                        </td>
                        <td className="p-2.5 text-slate-300">
                          {f.rebirth > 0 ? `Tái sinh cấp ${f.rebirth}` : "Cơ bản"}
                        </td>
                        <td className="p-2.5">
                          {f.id !== hero.id ? (
                            <Link
                              href={`/heroes/${f.id}`}
                              replace
                              scroll={false}
                              onClick={(e) => {
                                if (onSelectForm) {
                                  e.preventDefault();
                                  onSelectForm(f.id);
                                }
                              }}
                              className="text-sky-400 hover:underline font-semibold"
                            >
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
        </HeroSection>
      )}

      {/* 1. HERO MAIN CARD & AURA DISPLAY (Star section removed per requirement 3) */}
      <div id="hero-overview" className="relative overflow-hidden rounded-3xl border border-slate-800 bg-gradient-to-br from-slate-900 via-slate-950 to-[#070a12] p-6 sm:p-8 shadow-2xl">
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
          {/* Authentic In-Game Standing Art (Toàn Thân - Images 1, 3, 5) */}
          <div className="relative flex-shrink-0 flex flex-col items-center justify-end">
            <HeroStandingArt
              key={hero.id}
              hero={{
                id: hero.id,
                name: hero.name,
                avatar: hero.avatar,
                standing_image: hero.standing_image,
                full_image: hero.full_image,
                animation: hero.animation || null,
                is_world: hero.is_world,
                quality: hero.quality,
                occupation_type: hero.occupation_type,
              }}
              size="lg"
              showAura={hero.is_world}
            />

            {/* EXP Bar preview */}
            <div className="mt-3 w-44 sm:w-56 text-center">
              <div className="flex justify-between text-[10px] text-slate-400 mb-1 font-mono">
                <span className="text-emerald-400 font-bold">EXP</span>
                <span className="text-slate-300">0 / 1,474,420</span>
              </div>
              <div className="h-1.5 w-full rounded-full bg-slate-800/80 border border-slate-700/50 overflow-hidden">
                <div className="h-full w-1/3 bg-gradient-to-r from-emerald-500 to-teal-400 rounded-full" />
              </div>
            </div>
          </div>

          {/* Hero Identity & Title Info */}
          <div className="min-w-0 w-full flex-1 text-center md:text-left space-y-3">
            <div className="flex flex-wrap items-center justify-center md:justify-start gap-2">
              <span className="rounded-full border border-slate-700 bg-slate-800/80 px-2.5 py-0.5 text-xs text-slate-300 font-mono">
                Bản thể ID: <b>{hero.id}</b>
              </span>
              <span
                className={`rounded-full border px-2.5 py-0.5 text-xs font-bold ${
                  hero.is_world
                    ? "border-red-500/50 bg-red-950/80 text-red-300"
                    : "border-slate-700 bg-slate-800/80 text-slate-300"
                }`}
              >
                {familyForms.find(form => form.id === hero.id)?.label ?? "Dạng đang xem"}
              </span>
              {/* Super Evo Tag */}
              {hasSuperEvoUpgrade && currentEvoStage && (
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
                {currentStageObj
                  ? `Chuyển Sinh Mốc ${selectedChuyenStage}: ${currentStageObj.prefix}`
                  : "Chuyển Sinh: Mốc Gốc (Chưa CS)"}
              </div>
              <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight flex flex-wrap items-center justify-center md:justify-start gap-3">
                <span>{currentTitle}</span>
                {strengthenLevel > 0 && (
                  <span className="text-amber-400 font-mono text-2xl sm:text-4xl font-black">
                    +{strengthenLevel}
                  </span>
                )}
              </h1>
            </div>

            <HeroIdentityBadges id={hero.id} career={hero.career} race={hero.race}
              state={{ level, rebirth: selectedChuyenStage, superEvo: mapSuperEvoIdToStage(selectedSuperEvoId), breakthrough: selectedBreakthroughStep }} />

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

            {/* Ban Sức Khuyến Nghị (Cẩm nang người chơi) */}
            <div className="pt-2 text-left">
              <HeroBanSucCard
                heroId={String(hero.id)}
                currentRebirthStage={selectedChuyenStage}
                recommendationData={banSucRecommendation}
              />
            </div>
          </div>
        </div>
      </div>

      <nav aria-label="Điều khiển tướng" className="flex flex-wrap gap-2">
        <a className="hero-control" href="#level">Cấp độ</a>
        {supportsStrengthening && <a className="hero-control" href="#evolution">Tiến hoá</a>}
        {chuyenStages.length > 0 && <a className="hero-control" href="#rebirth">Chuyển sinh</a>}
        {hasSuperEvo && <a className="hero-control" href="#super-evolution">Siêu tiến hoá</a>}
        {breakthroughStages.length > 0 && <a className="hero-control" href="#breakthrough">Đột phá</a>}
        <a className="hero-control" href="#equipment">Trang bị</a>
      </nav>

      {/* 1. CẤP ĐỘ (LEVEL 1 - 255) & BẢNG THUỘC TÍNH TỔNG HỢP */}
      <HeroSection id="level" className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🎯</span>
              <h2 className="text-xl font-bold text-white">
                1. Cấp Độ (Level 1 - {levelLimit}) & Bảng Thuộc Tính Tổng Hợp
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Chỉ số mô phỏng (chưa gồm hiệu ứng trong chiến đấu), dựa trên: <b>Cấp độ ({level})</b> + <b>Tiến hóa (+{strengthenLevel})</b> + <b>Chuyển sinh ({selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage}` : "Gốc"})</b> + <b>Siêu tiến hóa ({superEvoLabel})</b> + <b>Đột phá ({selectedBreakthroughStep > 0 ? `Cấp ${selectedBreakthroughStep}` : "Chưa đột phá"})</b> + <b>Set Con Giáp ({activeZodiacId.toUpperCase()})</b> + <b>Vận mệnh</b>.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <button
              onClick={() => {
                setLevel(1);
                setStrengthenLevel(0);
                setSelectedChuyenStage(0);
                setSelectedSuperEvoId(defaultSuperEvoId);
                setSelectedBreakthroughStep(defaultBreakthroughStep);
                setEquipmentSelection(emptySelection);
                setAllVanMenh(false);
              }}
              className="rounded-xl border border-slate-700 bg-slate-800/80 px-3 py-1.5 text-xs text-slate-400 hover:text-white transition-colors"
            >
              Mặc định (Lv.1 +0)
            </button>
            <button
              onClick={() => {
                setLevel(levelLimit);
                setStrengthenLevel(maxStrengthenAtLevel(levelLimit, supportsStrengthening, strengthenTable));
                const lastRebirthStage = chuyenStages.at(-1)?.stage || 0;
                setSelectedChuyenStage(lastRebirthStage);
                setActiveTabChuyen(lastRebirthStage || 1);
                setSelectedSuperEvoId(superEvoStages.at(-1)?.id || "none");
                setSelectedBreakthroughStep(breakthroughStages.at(-1)?.step || 0);
                const rec = recommendations(hero.id, { level: levelLimit, rebirth: lastRebirthStage,
                  superEvo: mapSuperEvoIdToStage(superEvoStages.at(-1)?.id),
                  breakthrough: breakthroughStages.at(-1)?.step ?? 0 }, true)[0];
                setEquipmentSelection(rec?.selection ?? emptySelection);
                setAllVanMenh(true);
              }}
              className="rounded-xl border border-amber-500/40 bg-amber-500/10 px-3 py-1.5 text-xs font-semibold text-amber-300 hover:bg-amber-500/20 transition-colors shadow-lg shadow-amber-500/10"
            >
              ⚡ Tối đa theo dữ liệu bản thể
            </button>
          </div>
        </div>

        {/* Level Controls */}
        <div className="space-y-3 rounded-2xl border border-slate-800/80 bg-slate-950/60 p-5">
          <div className="flex items-center justify-between">
            <span className="text-sm font-bold text-white flex items-center gap-2">
              <span>🎯</span> Cấp Độ Tướng (Level 1 - {levelLimit})
            </span>
            <div className="flex items-center gap-2">
              <span className="text-xs text-slate-400">Cấp:</span>
              <input
                type="number"
                aria-label="Cấp độ tướng"
                min={1}
                max={levelLimit}
                value={level}
                onChange={(e) => setLevel(Math.min(levelLimit, Math.max(1, parseInt(e.target.value) || 1)))}
                className="w-20 rounded-xl border border-slate-700 bg-slate-900 px-3 py-1 text-center font-mono text-sm font-bold text-sky-400 focus:border-sky-500 focus:outline-none"
              />
            </div>
          </div>

          <input
            type="range"
            min={1}
            max={levelLimit}
            value={level}
            onChange={(e) => setLevel(parseInt(e.target.value, 10))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-sky-500"
          />

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="text-[11px] text-slate-500">Mốc nhanh:</span>
            {[...new Set([1, 50, 100, 150, 200, levelLimit])].filter(lv => lv <= levelLimit).map((lv) => (
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

        {/* Live Combat Stats */}
        <div className={`grid grid-cols-1 sm:grid-cols-2 ${calculatedStats.total.elementalDamage > 0 ? "lg:grid-cols-3 xl:grid-cols-6" : "lg:grid-cols-5"} gap-3`}>
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

          {/* Elemental Damage (if equipped with Zodiac set) */}
          {calculatedStats.total.elementalDamage > 0 && (
            <div className="rounded-2xl border border-cyan-500/40 bg-gradient-to-br from-cyan-950/30 to-blue-950/20 p-4 space-y-1 shadow-lg shadow-cyan-500/10">
              <div className="text-xs text-cyan-400 font-bold flex items-center justify-between">
                <span>Công nguyên tố · chưa tính kháng địch</span>
                {isZodiacRainbow && (
                  <span className="text-[9px] px-1.5 py-0.2 rounded bg-gradient-to-r from-red-500 to-amber-400 text-slate-950 font-black">
                    🌈 Rainbow
                  </span>
                )}
              </div>
              <div className="space-y-2 pt-2">
                {Object.values(elements).filter(element => calculatedStats.elementTotals[element.id] > 0).map(element =>
                  <div key={element.id} className="flex flex-wrap items-center gap-2 text-sm" data-total-element={element.id}>
                    <ElementBadge id={element.id} /><b>+{formatNumber(calculatedStats.elementTotals[element.id])}</b>
                  </div>)}
              </div>
              <p className="text-xs text-slate-300">Cộng từ đúng hệ trang bị đang mang và chỉ số công đột phá; không cộng phòng nguyên tố vào công.</p>
            </div>
          )}
        </div>
      </HeroSection>


      {/* 2. TIẾN HÓA (+1 ĐẾN +60) — CƯỜNG HÓA CHỈ SỐ CƠ BẢN */}
      {supportsStrengthening && (
      <HeroSection id="evolution" className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-5">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">⚡</span>
              <h2 className="text-xl font-bold text-white">
                2. Tiến Hóa (+1 đến +60) — Cường Hóa Chỉ Số Cơ Bản
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Hệ thống Tiến Hóa cường hóa từ <b>+1 đến +60</b> giúp tăng cường trực tiếp các chỉ số cơ bản (HP, Vật Công, Ma Công, Phòng Ngự, Tốc Độ) theo từng cấp yêu cầu và tiêu hao lương thực. <b className="text-amber-400">Lưu ý phân biệt:</b> Đây là hệ thống cường hóa điểm cộng (+1..+60), hoàn toàn độc lập với <b>Mục 4: Siêu Tiến Hóa (Cam ➔ Đỏ ➔ Vàng)</b>.
            </p>
          </div>

          <div className="flex items-center gap-2">
            <span className="text-xs text-slate-400">Cấp Tiến Hóa:</span>
            <span className="text-xl font-black font-mono text-amber-400 bg-amber-950/60 border border-amber-500/30 px-3 py-1 rounded-xl">
              {strengthenLevel > 0 ? `+${strengthenLevel}` : "0 (Mặc định)"}
            </span>
          </div>
        </div>

        {/* Strengthen Slider & Quick Select Buttons */}
        <div className="space-y-3 rounded-2xl border border-slate-800 bg-slate-950/60 p-5">
          <div className="flex items-center justify-between text-xs text-slate-400">
            <span>Kéo chọn cấp Tiến Hóa (+1 đến +60):</span>
            <span className="font-mono text-slate-300">
              {strengthenLevel > 0
                ? `Cấp yêu cầu: Lv.${currentStrengthenData.need_level} | Lương thực: ${formatNumber(currentStrengthenData.need_food)}`
                : "Cấp yêu cầu: Không | Tiêu hao: 0"}
            </span>
          </div>

          <input
            type="range"
            min={0}
            max={maxStrengthen}
            aria-label="Cấp tiến hoá"
            value={strengthenLevel}
            onChange={(e) => setStrengthenLevel(parseInt(e.target.value, 10))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-amber-500"
          />

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="text-[11px] text-slate-500">Cấp chọn nhanh:</span>
            {[0, 10, 20, 30, 40, 50, 60].filter(stVal => stVal <= maxStrengthen).map((stVal) => (
              <button
                key={stVal}
                onClick={() => setStrengthenLevel(stVal)}
                className={`rounded-lg px-2.5 py-1 text-xs font-mono font-bold transition-all ${
                  strengthenLevel === stVal
                    ? "bg-amber-500 text-slate-950 shadow"
                    : "bg-slate-900 text-slate-400 hover:bg-slate-800 hover:text-slate-200"
                }`}
              >
                {stVal === 0 ? "Mặc định (0)" : stVal === 60 ? "+60 (Max)" : `+${stVal}`}
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
      </HeroSection>
      )}

      {/* 3. MỤC CHUYỂN SINH (MỐC 1 ĐẾN 7) — GIAO DIỆN CHUẨN GAME */}
      {chuyenStages.length > 0 && (
      <HeroSection id="rebirth" className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🔄</span>
              <h2 className="text-xl font-bold text-white">
                3. Chuyển Sinh (Mốc 1 đến 7) — Giao Diện Chuẩn Game
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Giao diện mô phỏng chính xác hệ thống Chuyển Sinh trong game với hàng huy hiệu cánh thiên thần và 4 ô nguyên liệu (Đá Chuyển Sinh, Tinh thể, Mũ/Giáp và Thẻ Tướng Clone). Thay đổi mốc chuyển sinh sẽ tự động cập nhật danh hiệu tiền tố, huy hiệu cánh và sao/trăng trên thẻ tướng.
            </p>
          </div>

          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10 shrink-0">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Mốc Chuyển Sinh</div>
            <div className="text-lg sm:text-xl font-black font-mono text-amber-400">
              {selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage} (${currentStageObj?.prefix || ""})` : "Gốc (Chưa chuyển)"}
            </div>
          </div>
        </div>

        {chuyenStages.length > 0 ? (
          <div className="space-y-6">
            {/* Nagato 3 Elemental Playstyles Selector Card (Requirement 6) */}
            {/* Top row: Circular badges with wings & star ratings matching Image 1 */}
            <div className="flex flex-wrap items-center justify-center gap-3 sm:gap-6 py-2">
              {/* Nút mốc Gốc (Chưa chuyển) */}
              <button
                onClick={() => setSelectedChuyenStage(0)}
                className={`group flex flex-col items-center focus:outline-none transition-transform ${
                  selectedChuyenStage === 0 ? "scale-110" : "opacity-75 hover:opacity-100 hover:scale-105"
                }`}
                title="Dạng gốc nguyên bản chưa chuyển sinh"
              >
                <div
                  className={`relative flex items-center justify-center h-16 w-16 sm:h-20 sm:w-20 rounded-2xl border transition-all ${
                    selectedChuyenStage === 0
                      ? "border-amber-400 bg-amber-950/60 shadow-lg shadow-amber-500/30 ring-2 ring-amber-400/40"
                      : "border-slate-800 bg-slate-950/60 hover:border-slate-700"
                  }`}
                >
                  <span className="text-2xl sm:text-3xl">👤</span>
                </div>
                <div className="flex items-center justify-center gap-1 mt-1.5 h-4">
                  <span className="text-[10px] text-slate-500 font-mono">0 sao</span>
                </div>
                <span
                  className={`text-xs font-bold mt-0.5 ${
                    selectedChuyenStage === 0 ? "text-amber-300 font-black" : "text-slate-400"
                  }`}
                >
                  Gốc (0)
                </span>
              </button>

              {chuyenStages.map((st) => {
                const isSelected = selectedChuyenStage === st.stage;
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
                      className={`relative flex items-center justify-center h-16 w-16 sm:h-20 sm:w-20 transition-all ${
                        isSelected ? "drop-shadow-[0_0_12px_rgba(245,158,11,0.7)] scale-105" : "opacity-85 hover:opacity-100"
                      }`}
                    >
                      <img
                        src={`/assets/card/kpxq_break_${st.stage}.png`}
                        alt={`Chuyển ${st.stage}`}
                        className="w-full h-full object-contain filter drop-shadow-[0_3px_8px_rgba(0,0,0,0.9)]"
                      />
                    </div>

                    {/* Authentic Game Stars / Moons below circular badge */}
                    <div className="flex items-center justify-center gap-1 mt-1.5 h-4">
                      {st.stage <= 5
                        ? Array.from({ length: st.stage }).map((_, idx) => (
                            <img
                              key={idx}
                              src="/assets/card/public_equip_star.png"
                              alt="Sao"
                              className="w-3.5 h-3.5 object-contain filter drop-shadow-[0_1px_2px_rgba(0,0,0,0.9)]"
                            />
                          ))
                        : Array.from({ length: st.stage - 5 }).map((_, idx) => (
                            <img
                              key={idx}
                              src="/assets/card/public_moon_icon.png"
                              alt="Trăng"
                              className="w-3.5 h-3.5 object-contain filter drop-shadow-[0_1px_2px_rgba(0,0,0,0.9)]"
                            />
                          ))}
                    </div>

                    {/* Text Label: Chuyển 1, Chuyển 2... */}
                    <span
                      className={`text-xs font-bold mt-0.5 ${
                        isSelected ? "text-amber-300 font-black" : "text-slate-300"
                      }`}
                    >
                      Chuyển {st.stage}
                    </span>
                  </button>
                );
              })}
            </div>

            {/* Bottom row: The 4 item requirement slots with rounded red boxes matching Image 1 */}
            {(() => {
              const activeStage = chuyenStages.find((s) => s.stage === activeTabChuyen) || chuyenStages[0];
              if (!activeStage) return null;

              return (
                <div className="space-y-4">
                  {/* Materials Boxes Matching Game (CS1: 2 items, CS2: 3 items, etc.) */}
                  <div className={`grid grid-cols-2 ${activeStage.materials.length === 2 ? "sm:grid-cols-2 max-w-md mx-auto" : activeStage.materials.length === 3 ? "sm:grid-cols-3 max-w-xl mx-auto" : "sm:grid-cols-4"} gap-4`}>
                    {activeStage.materials.map((mat, mIdx) => (
                      <div key={mIdx} className="flex flex-col items-center gap-2 max-w-[130px] mx-auto text-center">
                        {/* Box with glowing red border - no overflow-hidden cutting off contents */}
                        <div className="relative h-20 w-20 sm:h-24 sm:w-24 rounded-2xl border-2 border-red-600 bg-gradient-to-b from-red-950/60 to-black p-1.5 flex items-center justify-center shadow-lg shadow-red-900/40 group">
                          {mat.is_hero_card ? (
                            <div className="h-full w-full rounded-xl overflow-hidden bg-slate-900 flex items-center justify-center border border-amber-500/30">
                              <ImageWithFallback
                                src={mat.icon || hero.avatar}
                                alt={mat.name}
                                className="h-full w-full object-contain p-0.5"
                                fallbackIcon="👤"
                              />
                            </div>
                          ) : (
                            <div className="h-full w-full flex items-center justify-center p-1">
                              <ImageWithFallback
                                src={mat.icon || getMaterialIcon(mat)}
                                alt={mat.name}
                                className="h-full w-full object-contain drop-shadow"
                                fallbackIcon="💎"
                              />
                            </div>
                          )}
                        </div>

                        {/* Item name label placed clearly below the box, never clipped or covered */}
                        <div
                          className="text-[11px] font-bold text-slate-200 text-center leading-snug line-clamp-2 min-h-[28px] flex items-center justify-center px-1"
                          title={mat.name}
                        >
                          {mat.name}
                        </div>

                        {/* Exact Required Count Pill */}
                        <div className="rounded-full border border-red-900/80 bg-black/90 px-3 py-0.5 font-mono text-xs font-bold flex items-center gap-1 shadow">
                          <span className="text-slate-400 text-[10px]">Cần:</span>
                          <span className="text-red-400 font-black">x{mat.count}</span>
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
      </HeroSection>
      )}

      {/* 4. MỤC SIÊU TIẾN HÓA (CAM ➔ ĐỎ ➔ VÀNG) — NÂNG CẤP PHẨM CHẤT THẺ */}
      {hasSuperEvo && (
      <HeroSection id="super-evolution" className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        {!hasSuperEvo ? (
          <div>
            <h2 className="text-xl font-bold text-white">4. Siêu Tiến Hoá</h2>
            <p className="mt-3 text-sm text-slate-400">Chưa có dữ liệu siêu tiến hoá áp dụng cho bản thể này.</p>
          </div>
        ) : (
        <>
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🧬</span>
              <h2 className="text-xl font-bold text-white">
                4. Siêu Tiến Hóa (Cam ➔ Đỏ ➔ Vàng) — Nâng Cấp Phẩm Chất Thẻ
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Hệ thống Siêu Tiến Hóa nâng cấp phẩm chất thẻ từ <b>Cam (Base) ➔ Đỏ ➔ Vàng</b> (gồm 9 mốc: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++). Hệ thống này trực tiếp thay đổi <b>Khung Thẻ Tướng (Frame)</b>, hiệu ứng hào quang, mở khóa 2 Kỹ Năng Siêu Tiến Hóa độc quyền và cộng dồn lượng chỉ số thuộc tính cực lớn. <b className="text-sky-400">Lưu ý phân biệt:</b> Khác hoàn toàn với <b>Mục 2: Tiến Hóa (+1..+60)</b> chỉ tăng điểm số cơ bản.
            </p>
          </div>

          {/* Super Evo status pill */}
          <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10">
            <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Phẩm Chất Thẻ</div>
            <div className="text-lg sm:text-xl font-black font-mono text-amber-400">
              {superEvoLabel}
            </div>
          </div>
        </div>

        {/* 9 Stage Selector Buttons - Bỏ mốc 'chưa kích hoạt' */}
        <div className="space-y-3">
          <div className="flex flex-wrap items-center gap-2 text-xs uppercase font-bold text-slate-400 tracking-wider">
            <span>Chọn Cấp Siêu Tiến Hóa (Thẻ Base Cam):</span>
            <span className="inline-flex items-center gap-1.5 font-bold normal-case text-xs">
              <span className="px-2 py-0.5 rounded bg-orange-950/80 border border-orange-500/40 text-orange-400">Cam (Base)</span>
              <span className="text-slate-500 font-mono">→</span>
              <span className="px-2 py-0.5 rounded bg-red-950/80 border border-red-500/40 text-red-400">Đỏ</span>
              <span className="text-slate-500 font-mono">→</span>
              <span className="px-2 py-0.5 rounded bg-amber-950/80 border border-amber-500/40 text-amber-300">Vàng</span>
            </span>
          </div>

          <div className="grid grid-cols-3 sm:grid-cols-9 gap-2">
            {superEvoStages.map((st) => {
              const isSelected = currentEvoStage?.id === st.id;
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

        {/* Layout 2 columns: Hero Card Frame on Left + "Hiệu quả Siêu Tiến Hóa" on Right */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Left Column: Hero Card Frame */}
          <div className="rounded-2xl border-2 border-amber-500/40 bg-gradient-to-b from-amber-950/40 via-red-950/30 to-black p-5 flex flex-col items-center justify-between gap-4 text-center shadow-xl">
            {/* Tag top left */}
            <div className="w-full flex items-center justify-between text-xs text-amber-300 font-bold">
              <span>🧬 Siêu Tiến Hóa</span>
              <span className="rounded-full bg-amber-500/20 px-2 py-0.5 text-[10px] border border-amber-500/30">
                Thẻ Base: Cam
              </span>
            </div>

            {/* Authentic Hero Card */}
            <HeroCard
              hero={{
                id: hero.id,
                name: hero.name,
                avatar: hero.avatar,
                card_image: hero.card_image,
                full_image: hero.full_image,
                animation: hero.animation || null,
                is_world: hero.is_world,
                quality: hero.quality,
                occupation: hero.occupation_type,
              }}
              superQualityStage={frameStage}
              rebirthStage={selectedChuyenStage}
              enhancementLevel={strengthenLevel}
              breakthroughLevel={selectedBreakthroughStep}
              showElementBadge={breakthroughStages.length > 0}
              level={level}
              maxLevel={255}
              size="md"
              reserveArtworkSpace
            />

            <div className="text-[11px] text-slate-400">
              Bản thể ID: {hero.id}
            </div>

            <div className="w-full text-[11px] font-mono text-amber-300/80 bg-amber-950/40 border border-amber-500/30 rounded-xl py-1.5">
              Mốc Hiện Tại: {superEvoLabel}
            </div>
          </div>

          {/* Right Column: "Hiệu quả Siêu Tiến Hóa" */}
          <div className="lg:col-span-2 rounded-2xl border border-slate-800 bg-slate-950/80 p-6 space-y-4 flex flex-col justify-between">
            <div className="space-y-4">
              <div className="flex items-center justify-between border-b border-slate-800 pb-2">
                <span className="text-xs uppercase font-extrabold text-amber-400 tracking-wider">
                  Hiệu Quả Siêu Tiến Hóa
                </span>
                <span className="text-xs text-slate-400">
                  {currentEvoStage ? `Đang chọn mốc: ${currentEvoStage.name}` : "Cam (Base)"}
                </span>
              </div>

              {/* Requirement Note: Base card Cam rules */}
              <div className="rounded-xl border border-amber-500/30 bg-amber-950/20 p-4 text-xs space-y-2">
                <div className="font-bold text-amber-300 flex items-center gap-1.5">
                  <span>📌</span> Quy Tắc Siêu Tiến Hóa (Thẻ Base Phẩm Cam):
                </div>
                <p className="text-slate-200 leading-relaxed font-sans">
                  Bảng mốc của bản thể này bắt đầu ở <b>Cam (Base)</b>. Mốc Cam là phẩm gốc và không được cộng thêm như một lần nâng cấp. Quá trình <b>Siêu Tiến Hóa</b> đưa thẻ tướng thăng hoa qua các cảnh giới <b>Cam → Đỏ → Vàng</b>:
                </p>
                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 pt-1 text-[11px]">
                  <div className="p-3 rounded-xl bg-black/40 border border-red-500/30">
                    <b className="text-red-400">Cảnh Giới Đỏ:</b>
                    <div className="text-slate-300 mt-1">
                      Mở khóa <b>Kỹ Năng Siêu Tiến Hóa 1</b>, cường hóa đột phá uy lực và hiệu ứng đặc biệt cho chiêu thức.
                    </div>
                  </div>
                  <div className="p-3 rounded-xl bg-black/40 border border-amber-500/30">
                    <b className="text-amber-300">Cảnh Giới Vàng:</b>
                    <div className="text-slate-300 mt-1">
                      Mở khóa <b>Kỹ Năng Siêu Tiến Hóa 2</b>, đạt trạng thái tối thượng đỉnh phong toàn diện.
                    </div>
                  </div>
                </div>
              </div>

              {/* Stats granted by current Super Evo Tier */}
              {hasSuperEvoUpgrade && currentEvoStage && (
                <div className="space-y-2 pt-1">
                  <div className="text-[11px] font-bold text-slate-400 uppercase tracking-wider">
                    Chỉ Số Cộng Thêm Tại Mốc {currentEvoStage.name}:
                  </div>
                  <div className="grid grid-cols-2 sm:grid-cols-5 gap-2 text-center text-xs">
                    <div className="p-2.5 rounded-xl bg-slate-900/80 border border-slate-800">
                      <div className="text-[10px] text-slate-400">HP</div>
                      <div className="font-mono font-bold text-emerald-400 mt-0.5">+{formatNumber(currentEvoStage.stats.hp)}</div>
                    </div>
                    <div className="p-2.5 rounded-xl bg-slate-900/80 border border-slate-800">
                      <div className="text-[10px] text-slate-400">Vật Công</div>
                      <div className="font-mono font-bold text-rose-400 mt-0.5">+{formatNumber(currentEvoStage.stats.patk)}</div>
                    </div>
                    <div className="p-2.5 rounded-xl bg-slate-900/80 border border-slate-800">
                      <div className="text-[10px] text-slate-400">Ma Công</div>
                      <div className="font-mono font-bold text-purple-400 mt-0.5">+{formatNumber(currentEvoStage.stats.matk)}</div>
                    </div>
                    <div className="p-2.5 rounded-xl bg-slate-900/80 border border-slate-800">
                      <div className="text-[10px] text-slate-400">Phòng Ngự</div>
                      <div className="font-mono font-bold text-sky-400 mt-0.5">+{formatNumber(currentEvoStage.stats.def)}</div>
                    </div>
                    <div className="p-2.5 rounded-xl bg-slate-900/80 border border-slate-800">
                      <div className="text-[10px] text-slate-400">Tốc Độ</div>
                      <div className="font-mono font-bold text-amber-400 mt-0.5">+{formatNumber(currentEvoStage.stats.speed)}</div>
                    </div>
                  </div>
                </div>
              )}

              {/* Requirement 4: Real materials required for the selected Super Evolution stage */}
              {currentEvoStage && (
                <div className="space-y-2 pt-2 border-t border-slate-800/80">
                  <div className="flex items-center justify-between text-[11px] font-bold text-amber-300 uppercase tracking-wider">
                    <div className="flex items-center gap-1.5">
                      <span>📦</span>
                      <span>Nguyên Liệu Cần Để Siêu Tiến Hóa Lên {currentEvoStage.name}:</span>
                    </div>
                    <span className="text-[10px] text-slate-400 font-normal">
                      {currentEvoStage.materials && currentEvoStage.materials.length > 0
                        ? `${currentEvoStage.materials.length} Thẻ Tướng / Phôi Chuẩn Game`
                        : "Mốc Khởi Đầu (Base)"}
                    </span>
                  </div>

                  {currentEvoStage.materials && currentEvoStage.materials.length > 0 ? (
                    <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
                      {currentEvoStage.materials.map((mat: any, mIdx: number) => {
                        const baseForm = (hero.family_forms || []).find((f: any) => f.is_base);
                        const wildcardAvatar = baseForm?.avatar || mat.icon || hero.avatar;
                        return (
                          <div
                            key={mIdx}
                            className="p-3 rounded-xl border border-slate-800 bg-slate-900/80 text-center space-y-1.5 hover:border-amber-500/40 transition-colors shadow"
                          >
                            <div className={`relative h-14 w-14 mx-auto rounded-xl overflow-hidden border-2 p-1 flex items-center justify-center shadow ${
                              mat.is_wildcard
                                ? "border-amber-400 bg-amber-950/40 shadow-amber-500/20"
                                : "border-amber-500/30 bg-black/60"
                            }`}>
                              <ImageWithFallback
                                src={mat.is_wildcard ? wildcardAvatar : mat.icon}
                                alt={mat.name}
                                className="h-full w-full object-contain"
                                fallbackIcon="👤"
                              />
                              {mat.is_wildcard && (
                                <span className="absolute bottom-0 inset-x-0 bg-amber-950/95 text-amber-300 text-[8px] font-mono py-0.2 font-bold border-t border-amber-500/40">
                                  Phôi Cam
                                </span>
                              )}
                            </div>
                            <div className="text-[11px] font-bold text-white truncate" title={mat.name}>
                              {mat.name}
                            </div>
                            <div className="text-xs font-mono font-black text-amber-400">
                              x{mat.count}
                            </div>
                          </div>
                        );
                      })}
                    </div>
                  ) : (
                    <div className="p-3 rounded-xl border border-slate-800/80 bg-black/40 text-center text-xs text-slate-400">
                      Mốc khởi đầu <b>Cam (Base)</b> của bản thể tướng - Không tốn nguyên liệu để kích hoạt.
                    </div>
                  )}
                </div>
              )}
            </div>

            <div className="text-[11px] text-slate-500 italic pt-2 border-t border-slate-800/60 text-center">
              Nguyên liệu nâng cấp cấp độ Đột Phá tướng được quản lý chuyên sâu ở mục <b>Đột Phá Tướng (20 Cấp)</b> bên dưới.
            </div>
          </div>
        </div>

        {/* 2 Evolution Skills Cards (Mở khóa tại mốc Đỏ và Vàng) */}
        <div className="space-y-3 pt-2">
          <div className="text-xs uppercase font-bold text-slate-400 tracking-wider flex items-center justify-between">
            <span>Kỹ Năng Siêu Tiến Hóa (Mở khóa khi Siêu Tiến Hóa lên Đỏ và Vàng)</span>
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
        </>
        )}
      </HeroSection>
      )}

      {/* 5. MỤC ĐỘT PHÁ TƯỚNG (20 CẤP ĐỘT PHÁ NGUYÊN TỐ) */}
      {(() => {
        const btStages = getBreakthroughStages(hero);
        const hasBt = btStages.length > 0;
        const currentStageData = hasBt && selectedBreakthroughStep > 0 && selectedBreakthroughStep <= btStages.length
          ? btStages[selectedBreakthroughStep - 1]
          : null;

        // Calculate cumulative materials from step 1 to selectedBreakthroughStep (Requirement 1: Bỏ Vàng)
        const cumulativeSummary = (() => {
          if (!hasBt || !currentStageData) return null;
          let totalDan = 0;
          let totalCard = 0;
          let totalTinhHoa = 0;
          let totalStone = 0;
          let stoneName = "Đá Năng Lượng";

          for (let i = 0; i < selectedBreakthroughStep && i < btStages.length; i++) {
            const st = btStages[i];
            st.materials.forEach((m) => {
              if (m.is_currency || m.id === "0" || m.name === "Vàng") return; // Bỏ mục vàng
              if (m.id === "3101" || m.name.includes("Chuyển Thế Đơn")) totalDan += m.count;
              else if (m.is_hero_card) totalCard += m.count;
              else if (m.id === "532" || m.name.includes("Tinh hoa")) totalTinhHoa += m.count;
              else if (m.name.includes("Đá năng lượng")) {
                totalStone += m.count;
                stoneName = m.name;
              }
            });
          }

          return { totalDan, totalCard, totalTinhHoa, totalStone, stoneName };
        })();

        return (
          <HeroSection id="breakthrough" className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
            <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
              <div>
                <div className="flex items-center gap-2">
                  <span className="text-2xl">⚡</span>
                  <h2 className="text-xl font-bold text-white">
                    5. Đột Phá Tướng (20 Cấp Đột Phá Nguyên Tố)
                  </h2>
                </div>
                <p className="text-xs text-slate-400 mt-1">
                  Hệ thống 20 cấp Đột Phá từ config game chuẩn (<b>breakthrough.config</b>). Mỗi cấp độ gia tăng chỉ số cơ bản, chỉ số Công/Thủ Nguyên Tố và thay đổi trực tiếp con số trên <b>Huy Hiệu Đột Phá</b> bên phải hình tướng.
                </p>
              </div>

              {/* Current Step Badge */}
              <div
                className={`rounded-2xl border px-4 py-2 text-center shadow-lg shrink-0 ${
                  hasBt
                    ? "border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 shadow-amber-500/10"
                    : "border-slate-800 bg-slate-950/60"
                }`}
              >
                <div
                  className={`text-[10px] uppercase tracking-widest font-bold ${
                    hasBt ? "text-amber-300" : "text-slate-500"
                  }`}
                >
                  {hasBt ? "Đang Xem Đột Phá" : "Hệ Thống Đột Phá"}
                </div>
                <div
                  className={`text-xl sm:text-2xl font-black font-mono ${
                    hasBt ? "text-amber-400" : "text-sm sm:text-base font-bold text-slate-400 mt-1"
                  }`}
                >
                  {hasBt ? `Cấp ${selectedBreakthroughStep} / 20` : "Không hỗ trợ"}
                </div>
              </div>
            </div>

            {hasBt ? (
              <div className="space-y-6">
                {/* 20 Stage Selector Buttons & Controls */}
                <div className="space-y-3">
                  <div className="flex flex-wrap items-center justify-between gap-2 text-xs uppercase font-bold text-slate-400 tracking-wider">
                    <span>Chọn Cấp Đột Phá (1 - 20):</span>
                    <div className="flex items-center gap-1.5 font-mono text-[11px] normal-case">
                      <span className="text-slate-400">Bước nhảy nhanh:</span>
                      {[0, 1, 5, 10, 15, 20].filter(step => step <= btStages.length).map((stepVal) => (
                        <button
                          key={stepVal}
                          onClick={() => setSelectedBreakthroughStep(stepVal)}
                          className={`px-2 py-0.5 rounded-lg border font-bold text-xs transition-colors ${
                            selectedBreakthroughStep === stepVal
                              ? "border-amber-400 bg-amber-500 text-slate-950"
                              : "border-slate-800 bg-slate-900 text-slate-300 hover:bg-slate-800"
                          }`}
                        >
                          {stepVal === 0 ? "Chưa đột phá" : `Cấp ${stepVal}`}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Range Slider for smooth scrubbing */}
                  <div className="flex items-center gap-4 bg-slate-950/60 p-3 rounded-2xl border border-slate-800">
                    <span className="text-xs font-mono font-bold text-slate-400">Chưa đột phá</span>
                    <input
                      type="range"
                      min="0"
                      aria-label="Cấp đột phá"
                      max={btStages.length}
                      value={selectedBreakthroughStep}
                      onChange={(e) => setSelectedBreakthroughStep(Number(e.target.value))}
                      className="flex-1 h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-amber-500"
                    />
                    <span className="text-xs font-mono font-bold text-amber-400">Cấp {btStages.length}</span>
                  </div>

                  {/* 20 Button Pills Grid */}
                  <div className="grid grid-cols-5 sm:grid-cols-10 lg:grid-cols-20 gap-1.5">
                    {btStages.map((st) => {
                      const isSelected = selectedBreakthroughStep === st.step;
                      const isEven = st.step % 2 === 0;
                      return (
                        <button
                          key={st.step}
                          onClick={() => setSelectedBreakthroughStep(st.step)}
                          className={`rounded-xl py-2 px-1 text-center font-mono text-xs font-bold transition-all border ${
                            isSelected
                              ? "border-amber-400 bg-gradient-to-b from-amber-500 to-yellow-600 text-slate-950 shadow-lg shadow-amber-500/30 scale-105 z-10"
                              : isEven
                              ? "border-slate-800 bg-slate-950/80 text-amber-300 hover:bg-slate-900"
                              : "border-slate-800 bg-slate-950/60 text-slate-300 hover:bg-slate-900"
                          }`}
                          title={`${st.step_name}: ${isEven ? "Mốc Chẵn (Thẻ Bản Thể)" : "Mốc Lẻ (Chuyển Thế Đơn)"}`}
                        >
                          <div className="text-[10px] opacity-75">{isEven ? "🎴" : "💊"}</div>
                          <div className="text-xs">{st.step}</div>
                        </button>
                      );
                    })}
                  </div>
                </div>

                {/* Main Content: 2 Cards (Materials & Stats) */}
                {currentStageData && (
                  <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    {/* Left: Required Materials */}
                    <div className="rounded-2xl border border-slate-800 bg-slate-950/80 p-5 space-y-4 flex flex-col justify-between">
                      <div className="space-y-3">
                        <div className="flex items-center justify-between border-b border-slate-800 pb-2">
                          <div className="flex items-center gap-2">
                            <span className="text-lg">📦</span>
                            <span className="text-xs uppercase font-extrabold text-amber-400 tracking-wider">
                              Nguyên Liệu Cần Để Đột Phá Lên Cấp {currentStageData.step}
                            </span>
                          </div>
                          <span className={`text-[10px] font-bold px-2 py-0.5 rounded-full border ${
                            currentStageData.step % 2 === 0
                              ? "bg-amber-950 text-amber-300 border-amber-500/40"
                              : "bg-orange-950 text-orange-300 border-orange-500/40"
                          }`}>
                            {currentStageData.step % 2 === 0 ? "🎴 Mốc Chẵn (Cần Thẻ Bản Thể)" : "💊 Mốc Lẻ (Cần Chuyển Thế Đơn)"}
                          </span>
                        </div>

                        {/* Materials Grid (Requirement 1: Bỏ mục Vàng) */}
                        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
                          {currentStageData.materials
                            .filter((m) => !m.is_currency && m.id !== "0" && m.name !== "Vàng")
                            .map((m, mIdx) => (
                            <div key={mIdx} className="p-3 rounded-xl border border-slate-800 bg-slate-900/70 text-center space-y-1.5 group hover:border-amber-500/40 transition-colors shadow">
                              <div className="h-11 w-11 mx-auto flex items-center justify-center">
                                <ImageWithFallback
                                  src={m.icon || getMaterialIcon(m, m.is_hero_card ? "🃏" : "💎")}
                                  alt={m.name}
                                  className="h-full w-full object-contain drop-shadow"
                                  fallbackIcon={m.is_hero_card ? "🃏" : "💎"}
                                />
                              </div>
                              <div className="text-[11px] font-bold text-white truncate" title={m.name}>{m.name}</div>
                              <div className="text-xs font-mono text-amber-400 font-black">
                                x{m.count}
                              </div>
                            </div>
                          ))}
                        </div>
                      </div>

                      {/* Cumulative Total Box (Requirement 1: Bỏ mục Vàng) */}
                      {cumulativeSummary && (
                        <div className="rounded-xl border border-slate-800 bg-black/60 p-3.5 space-y-2 mt-2">
                          <div className="text-[11px] font-bold text-amber-300 uppercase tracking-wider flex items-center justify-between">
                            <span>📈 Tích Lũy Từ Cấp 1 Đến Cấp {currentStageData.step}:</span>
                            <span className="text-[10px] text-slate-400 font-normal">Tổng tài nguyên cần</span>
                          </div>
                          <div className="grid grid-cols-2 sm:grid-cols-4 gap-2 text-center text-[11px] font-mono">
                            <div className="p-2 rounded-lg bg-slate-900 border border-slate-800">
                              <div className="text-[10px] text-slate-400 truncate">Chuyển Thế Đơn</div>
                              <div className="font-bold text-orange-400 mt-0.5">x{cumulativeSummary.totalDan}</div>
                            </div>
                            <div className="p-2 rounded-lg bg-slate-900 border border-slate-800">
                              <div className="text-[10px] text-slate-400 truncate">Thẻ Bản Thể</div>
                              <div className="font-bold text-amber-300 mt-0.5">x{cumulativeSummary.totalCard}</div>
                            </div>
                            <div className="p-2 rounded-lg bg-slate-900 border border-slate-800">
                              <div className="text-[10px] text-slate-400 truncate">Tinh Hoa</div>
                              <div className="font-bold text-emerald-400 mt-0.5">x{cumulativeSummary.totalTinhHoa}</div>
                            </div>
                            <div className="p-2 rounded-lg bg-slate-900 border border-slate-800">
                              <div className="text-[10px] text-slate-400 truncate">{cumulativeSummary.stoneName.replace("Đá năng lượng ", "")}</div>
                              <div className="font-bold text-cyan-400 mt-0.5">x{cumulativeSummary.totalStone}</div>
                            </div>
                          </div>
                        </div>
                      )}
                    </div>

                    {/* Right: Added Stats at this stage */}
                    <div className="rounded-2xl border border-slate-800 bg-slate-950/80 p-5 space-y-4 flex flex-col justify-between">
                      <div className="space-y-3">
                        <div className="flex items-center justify-between border-b border-slate-800 pb-2">
                          <div className="flex items-center gap-2">
                            <span className="text-lg">💪</span>
                            <span className="text-xs uppercase font-extrabold text-amber-400 tracking-wider">
                              Chỉ Số Cộng Thêm Tại Cấp {currentStageData.step}
                            </span>
                          </div>
                          <span className="text-xs font-mono text-slate-400">
                            ID Cấu Hình: #{btStages[currentStageData.step - 1] ? hero.breakthrough_system?.stages?.[currentStageData.step - 1]?.step_name : ""}
                          </span>
                        </div>

                        {/* Stat grid */}
                        <div className="grid grid-cols-2 sm:grid-cols-3 gap-2.5 text-xs">
                          <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                            <span className="text-slate-400">Máu (HP):</span>
                            <span className="font-mono font-bold text-emerald-400 text-sm">+{formatNumber(currentStageData.stats.hp)}</span>
                          </div>
                          <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                            <span className="text-slate-400">Vật Công:</span>
                            <span className="font-mono font-bold text-rose-400 text-sm">+{formatNumber(currentStageData.stats.patk)}</span>
                          </div>
                          <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                            <span className="text-slate-400">Ma Công:</span>
                            <span className="font-mono font-bold text-purple-400 text-sm">+{formatNumber(currentStageData.stats.matk)}</span>
                          </div>
                          <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                            <span className="text-slate-400">Phòng Ngự:</span>
                            <span className="font-mono font-bold text-sky-400 text-sm">+{formatNumber(currentStageData.stats.def)}</span>
                          </div>
                          <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                            <span className="text-slate-400">Tốc Độ:</span>
                            <span className="font-mono font-bold text-amber-400 text-sm">+{formatNumber(currentStageData.stats.speed)}</span>
                          </div>
                          {(currentStageData.stats.ele_atk || 0) > 0 ? (
                            <div className="p-3 rounded-xl bg-slate-900/80 border border-amber-500/30 flex items-center justify-between">
                              <span className="text-amber-300">Công Thuộc Tính:</span>
                              <span className="font-mono font-bold text-amber-400 text-sm">+{formatNumber(currentStageData.stats.ele_atk || 0)}</span>
                            </div>
                          ) : (currentStageData.stats.ele_def || 0) > 0 ? (
                            <div className="p-3 rounded-xl bg-slate-900/80 border border-cyan-500/30 flex items-center justify-between">
                              <span className="text-cyan-300">Kháng Thuộc Tính:</span>
                              <span className="font-mono font-bold text-cyan-400 text-sm">+{formatNumber(currentStageData.stats.ele_def || 0)}</span>
                            </div>
                          ) : (
                            <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between">
                              <span className="text-slate-400">Đột Phá:</span>
                              <span className="font-mono font-bold text-amber-300 text-sm">Tối Đa 20 Cấp</span>
                            </div>
                          )}
                        </div>
                      </div>

                      <div className="text-[11px] text-slate-400 italic pt-2 border-t border-slate-800/60 text-center">
                        Chỉ số Đột Phá đang chọn (Cấp {currentStageData.step}) được tích hợp trực tiếp vào bảng mô phỏng lực chiến và thuộc tính tổng thể của tướng.
                      </div>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <div className="rounded-2xl border border-slate-800 bg-slate-950/40 p-6 text-center text-xs text-slate-400">
                Bản thể tướng này không có dữ liệu Đột Phá 20 cấp riêng biệt trong file cấu hình game.
              </div>
            )}
          </HeroSection>
        );
      })()}

      <EquipmentAdvisor heroId={hero.id} heroName={hero.name}
        state={{ level, rebirth: selectedChuyenStage, superEvo: mapSuperEvoIdToStage(selectedSuperEvoId), breakthrough: selectedBreakthroughStep }}
        selection={equipmentSelection} onSelect={setEquipmentSelection} />

      {/* 7. HUY HIỆU CỦA TƯỚNG */}
      <HeroSection className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
      </HeroSection>

      {/* 8. VẬN MỆNH (KÍCH HOẠT VẬN MỆNH) */}
      <HeroSection className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
      </HeroSection>

      {/* 9. SKILLS LIST (7 Ô KỸ NĂNG NGUYÊN BẢN) */}
      <HeroSection className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
          {hero.skills_detailed?.map(sk => <HeroSkillCard key={`${sk.slot}-${sk.skill_id}`} skill={sk}
            required={combatProfiles[hero.id]?.skill_unlocks[String(sk.slot)]} superEvo={mapSuperEvoIdToStage(selectedSuperEvoId)} />)}
        </div>
      </HeroSection>

      {/* 10. SYSTEM & METADATA */}
      <HeroSection className="rounded-3xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur text-xs space-y-3">
        <h3 className="text-sm font-bold text-slate-300 uppercase tracking-wider">Thông Tin Bản Thể & Cấu Hình</h3>
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 pt-2">
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Mã Bản Thể:</span>
            <div className="font-mono text-white font-bold">{hero.id}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Giới Tính / Phân Loại:</span>
            <div className="font-mono text-white font-bold">{hero.sex === 1 ? "Nam" : hero.sex === 2 ? "Nữ" : "Đặc Biệt"}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Cấp Tối Đa Cấu Hình:</span>
            <div className="font-mono text-white font-bold">{hero.level_max > 0 ? hero.level_max : "0 (nguồn chưa nêu giới hạn)"}</div>
          </div>
          <div className="rounded-xl border border-slate-800 bg-slate-950 p-3">
            <span className="text-slate-500">Trạng Thái Độc Quyền (is_only):</span>
            <div className="font-mono text-white font-bold">{hero.is_only ?? 0}</div>
          </div>
        </div>
      </HeroSection>
    </div>
  );
}
