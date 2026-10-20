// web/src/components/HeroInteractiveView.tsx
"use client";

import React, { useState, useMemo } from "react";
import Link from "next/link";
import ImageWithFallback from "@/components/ImageWithFallback";
import HeroCard from "@/components/HeroCard";
import HeroStandingArt from "@/components/HeroStandingArt";
import HeroBanSucCard from "@/components/HeroBanSucCard";
import { getSuperEvoStages, getBreakthroughStages, isSuperEvoUpgrade } from "@/lib/hero-progression";
import { formatNumber, getQualityConfig } from "@/lib/utils";
import strengthenTableRaw from "@/data/character_strengthen.json";
import zodiacSetsRaw from "@/data/zodiac_sets.json";
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
}

const strengthenTable: Record<string, { level: number; add_hp: number; add_patk: number; add_matk: number; add_def: number; add_speed: number; need_level: number; need_food: number }> = strengthenTableRaw;
const zodiacSetsList: any[] = zodiacSetsRaw;

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

export default function HeroInteractiveView({ hero }: HeroInteractiveViewProps) {
  // 1. Interactive States
  const [level, setLevel] = useState<number>(1);
  const [selectedChuyenStage, setSelectedChuyenStage] = useState<number>(0); // 0 = Chưa chuyển, 1-7
  const [activeTabChuyen, setActiveTabChuyen] = useState<number>(1); // For viewing stage details 1-7

  // Regular evolution (+1 to +60) - Default to 0 (no +3 default)
  const [strengthenLevel, setStrengthenLevel] = useState<number>(0);

  // Super Evo state (9 stages: Cam, Cam+, Cam++, Đỏ, Đỏ+, Đỏ++, Vàng, Vàng+, Vàng++) - Default to "cam" (Base form)
  const superEvoStages = getSuperEvoStages(hero);
  const defaultSuperEvoId = superEvoStages[0]?.id || "none";
  const [selectedSuperEvoId, setSelectedSuperEvoId] = useState<string>(defaultSuperEvoId);

  // Breakthrough system state (1 to 20 stages from breakthrough.config) - Default to stage 1
  const breakthroughStages = getBreakthroughStages(hero);
  const defaultBreakthroughStep = breakthroughStages[0]?.step || 0;
  const [selectedBreakthroughStep, setSelectedBreakthroughStep] = useState<number>(defaultBreakthroughStep);

  // Badge interactive state
  const heroBadges = hero.badges || [];
  const [badgeEquipped, setBadgeEquipped] = useState<boolean>(heroBadges.length > 0);
  const [selectedBadgeLevel, setSelectedBadgeLevel] = useState<number>(
    heroBadges.length > 0 ? Math.min(heroBadges.length - 1, 7) : 0
  );

  // Zodiac set simulation state - Default to 'none' and 'hoi' tab (Requirement 3: Swapped Hợi and Chuột)
  const [activeZodiacId, setActiveZodiacId] = useState<string>("none"); // 'none' or 'hoi', 'chuot', 'rong', 'ti', 'ngua'
  const [activeZodiacTab, setActiveZodiacTab] = useState<string>("hoi");
  const [isZodiacRainbow, setIsZodiacRainbow] = useState<boolean>(true); // Mốc Cầu Vồng: massive stats boost
  const [activeZodiacElement, setActiveZodiacElement] = useState<string>("auto");

  // User Guide: Ban Sức Khuyến Nghị for this hero
  const banSucRecommendation = useMemo(() => {
    return (banSucRecommendationsRaw as any)?.heroes?.[String(hero.id)] || null;
  }, [hero.id]);

  // Nagato 3 Elemental Playstyles State (Requirement 6)
  const [nagatoBuildStyle, setNagatoBuildStyle] = useState<string>("tho"); // 'tho', 'hoa', 'thuy'

  // Analyze hero's skills for elemental scaling and recommended zodiac set & element
  const zodiacRecommendation = useMemo(() => {
    const skills = hero.skills_detailed || [];
    const hName = (hero.name || "").toLowerCase();
    const cId = String(hero.character_id || "");

    const elemMap: Record<string, { label: string; icon: string; desc: string }> = {
      hoa: { label: "Hỏa (Lửa)", icon: "🔥", desc: "Tối ưu hóa sát thương thuộc tính Hỏa thiêu đốt" },
      thuy: { label: "Thủy (Nước)", icon: "💧", desc: "Tối ưu hóa sát thương thuộc tính Thủy và khống chế" },
      phong: { label: "Phong (Gió)", icon: "🌪️", desc: "Tối ưu hóa sát thương thuộc tính Phong và tốc độ" },
      tho: { label: "Thổ (Địa)", icon: "⛰️", desc: "Tối ưu hóa sát thương thuộc tính Thổ (Địa) và hộ thể" },
    };

    // Specific Rule: Nagato -> Khuyên dùng thuộc tính Địa vì đánh Boss Titan dame sẽ cao hơn (Requirement 2 & 6)
    if (hName.includes("nagato") || hName.includes("pain") || cId === "431") {
      const isHoa = nagatoBuildStyle === "hoa";
      const isThuy = nagatoBuildStyle === "thuy";
      const activeElem = isHoa ? elemMap.hoa : isThuy ? elemMap.thuy : elemMap.tho;
      const activeElemKey = isHoa ? "hoa" : isThuy ? "thuy" : "tho";
      const styleName = isHoa
        ? "Phong Cách Hỏa (Hỏa Độn - CS1 Truy Kích Liên Hoàn)"
        : isThuy
        ? "Phong Cách Thủy (Thủy Độn - CS2 Thần Ngự & Hộ Giá Bất Tử)"
        : "Phong Cách Địa (Thổ Độn - CS4 & CS7 Tối Ưu Dame Boss Titan & Trảm Hồi Sinh)";

      return {
        hasElemental: true,
        recommendedSetId: "ti",
        recommendedSetName: `Bộ Năm Tị (${activeElem.label})`,
        recommendedPriorityList: [
          { id: "ti", name: "Bộ Năm Tị", rank: "1 (Mạnh Nhất)", tag: `Tối Cường ST ${activeElem.label}`, isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích Cực Hạn & Đột Kích", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "5", tag: "Tối Cường Tốc Độ & Chính Xác", isBest: false },
        ],
        recommendedElement: activeElem,
        recommendedElementKey: activeElemKey,
        reason: `Nagato nên sử dụng thuộc tính Địa vì khi đánh Boss Titan, sát thương (dame) sẽ cao hơn vượt trội! ${
          isHoa
            ? "Đang chọn Phong Cách Hỏa (CS1: Tăng 5 lần công Hỏa, mỗi 1M công Hỏa truy kích 1 lần. Lưu ý: Đánh Boss Titan nên ưu tiên thuộc tính Địa để đạt dame tối đa!)."
            : isThuy
            ? "Đang chọn Phong Cách Thủy (CS2: Tăng 5 lần công Thủy; nhận Thần Ngự và hộ giá. Lưu ý: Đánh Boss Titan nên ưu tiên thuộc tính Địa để đạt dame tối đa!)."
            : "Cơ chế Chuyển Sinh 4 tăng 5 lần công Địa, mỗi 1.000.000 điểm công Địa nhân đôi sát thương kỹ năng; kết hợp Chuyển Sinh 7 tiêu diệt 1 đơn vị và xóa bỏ hồi sinh giúp dồn lượng sát thương bộc phát khổng lồ lên Boss Titan. Vì vậy, Set Tị (Thuộc Tính Địa) là trang bị chuẩn xác và tối thượng cho Nagato."
        } Đề xuất chuẩn xác là sử dụng Bộ Năm Tị biến thể ${activeElem.label}.`,
        elementReason: isHoa
          ? "Đang kích hoạt nguyên tố Hỏa cho cơ chế truy kích CS1."
          : isThuy
          ? "Đang kích hoạt nguyên tố Thủy cho cơ chế hộ giá CS2."
          : "Nguyên tố Thổ (Địa) giúp Nagato đạt lượng dame khổng lồ cao nhất khi tham gia săn Boss Titan!",
      };
    }

    // Specific Rule: Support Heroes (Songoku + all transferred forms, Piccolo, Adr18, Inori) -> Set Tị (Bộ Năm Tị)
    const isSongoku =
      hName.includes("songoku") ||
      hName.includes("son goku") ||
      hName.includes("goku") ||
      hName.includes("kakarot") ||
      cId === "425" ||
      cId === "396" ||
      cId === "999" ||
      cId === "1" ||
      cId === "141";
    const isPiccolo = hName.includes("piccolo") || cId === "418";
    const isAdr18 =
      hName.includes("adr18") ||
      hName.includes("adr 18") ||
      hName.includes("số 18") ||
      hName.includes("so 18") ||
      hName.includes("poc") ||
      hName.includes("android 18") ||
      cId === "416";
    const isInori = hName.includes("inori") || cId === "428";

    if (isSongoku || isPiccolo || isAdr18 || isInori) {
      const heroRoleDesc = isSongoku
        ? "Songoku cùng tất cả các dạng chuyển thế đóng vai trò là tướng hỗ trợ quan trọng của đội hình (cung cấp Ki, tăng cường sức mạnh và tiếp ứng toàn đội)."
        : isPiccolo
        ? "Piccolo là tướng hỗ trợ phòng ngự và khống chế (Rào Chắn Ma Lực, Kết Giới Ma Thần bảo hộ đồng đội)."
        : isAdr18
        ? "Adr18 (Số 18) là tướng hỗ trợ xuất sắc với khả năng điều tiết và phục hồi nguồn năng lượng vô tận cho đội hình."
        : "Inori là tướng hỗ trợ thuần túy với khả năng hồi phục sinh mệnh vô song (Bài Ca Trị Liệu, Tịnh Hóa Tâm Linh).";

      const heroElem = isPiccolo ? elemMap.tho : isInori ? elemMap.thuy : elemMap.phong;
      const heroElemKey = isPiccolo ? "tho" : isInori ? "thuy" : "phong";

      return {
        hasElemental: true,
        recommendedSetId: "ti",
        recommendedSetName: "Bộ Năm Tị",
        recommendedPriorityList: [
          { id: "ti", name: "Bộ Năm Tị", rank: "1 (Chuẩn Nhất)", tag: "Tối Cường Hỗ Trợ & Buff Đội Hình", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích Cực Hạn & Đột Kích", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "5", tag: "Tối Cường Tốc Độ & Chính Xác", isBest: false },
        ],
        recommendedElement: heroElem,
        recommendedElementKey: heroElemKey,
        reason: `${heroRoleDesc} Là tướng hỗ trợ nên khuyên dùng Bộ Năm Tị (ưu tiên số 1) để tối ưu hóa năng lực hỗ trợ, khuếch đại sát thương thuộc tính và phát huy tối đa hiệu quả kĩ năng vận mệnh.`,
        elementReason: isPiccolo
          ? "Nguyên tố Thổ (Địa) gia tăng độ cứng cáp của khiên ma lực và năng lực chống chịu bền bỉ cho Piccolo!"
          : isInori
          ? "Nguyên tố Thủy (Nước) đồng bộ tuyệt đối với các bài ca thanh tẩy, trị liệu hồi phục sinh mệnh của Inori!"
          : isAdr18
          ? "Nguyên tố Phong (Gió) gia tăng tốc độ xuất chiêu và cơ chế xoay chuyển năng lượng vô tận của Adr18!"
          : "Nguyên tố Phong (Gió) / Hỏa giúp gia tăng tốc độ, đồng bộ hoàn hảo với nguồn năng lượng Ki và các tuyệt kỹ Quy Phái Khí Công / Nguyên Khí Đạn của Songoku!",
      };
    }

    // Specific Rule: Sasuke (Lục Đạo / CT / Thường) -> Sử dụng Bộ Năm Tị chứ KHÔNG dùng bộ Chuột!
    if (hName.includes("sasuke") || cId === "84000" || cId === "8400" || cId === "401") {
      return {
        hasElemental: true,
        recommendedSetId: "ti",
        recommendedSetName: "Bộ Năm Tị",
        recommendedPriorityList: [
          { id: "ti", name: "Bộ Năm Tị", rank: "1 (Chuẩn Nhất)", tag: "Tối Cường ST Lôi & Hỏa", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích & Sát Thương Đột Phá", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "5", tag: "Tối Cường Tốc Độ & Chính Xác", isBest: false },
        ],
        recommendedElement: elemMap.hoa,
        recommendedElementKey: "hoa",
        reason: "Sasuke sở hữu toàn bộ kỹ năng Lôi Độn (Chidori) và Hỏa Độn (Amaterasu) thuần nguyên tố, tăng vọt uy lực theo mỗi điểm sát thương nguyên tố. Khuyến nghị chuẩn xác là sử dụng Bộ Năm Tị (chứ không dùng bộ Chuột)!",
        elementReason: "Nguyên tố Hỏa / Lôi khuếch đại tối đa uy lực thiêu đốt của Hỏa Độn và sát thương bộc phát Chidori cho Sasuke!",
      };
    }

    // Specific Rule: Elaina -> Sử dụng Bộ Năm Tị chứ KHÔNG dùng bộ Chuột hay Ngựa!
    if (hName.includes("elaina") || cId === "435" || cId === "85000") {
      return {
        hasElemental: true,
        recommendedSetId: "ti",
        recommendedSetName: "Bộ Năm Tị",
        recommendedPriorityList: [
          { id: "ti", name: "Bộ Năm Tị", rank: "1 (Chuẩn Nhất)", tag: "Tối Cường Sát Thương Ma Pháp", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích & Sát Thương Đột Phá", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "5", tag: "Tối Cường Tốc Độ & Chính Xác", isBest: false },
        ],
        recommendedElement: elemMap.phong,
        recommendedElementKey: "phong",
        reason: "Phù Thủy Elaina sử dụng ma pháp bão tố nguyên tố Phong, tăng vọt uy lực sát thương ma đạo theo điểm sát thương thuộc tính. Khuyến nghị chuẩn xác là sử dụng Bộ Năm Tị (chứ không dùng bộ Chuột hay Ngựa)!",
        elementReason: "Nguyên tố Phong (Gió) đồng bộ tối đa với toàn bộ ma pháp lốc xoáy và cuồng phong của Phù Thủy Elaina!",
      };
    }

    // Specific Rule: Shadow -> Set Ngựa vì giúp tăng chính xác vượt trội
    if (hName.includes("shadow") || hName.includes("cid kageno") || cId === "434") {
      return {
        hasElemental: false,
        recommendedSetId: "ngua",
        recommendedSetName: "Bộ Năm Ngựa",
        recommendedPriorityList: [
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "1 (Chuẩn Nhất)", tag: "Tăng Chính Xác & Tốc Độ", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích Cực Hạn & Đột Kích", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ti", name: "Bộ Năm Tị", rank: "5", tag: "Tối Cường Sát Thương Nguyên Tố", isBest: false },
        ],
        recommendedElement: elemMap.phong,
        recommendedElementKey: "phong",
        reason: "Set Ngựa phù hợp với tất cả các tướng trừ những tướng cần sức mạnh tăng theo sát thương thuộc tính. Shadow không phụ thuộc sát thương nguyên tố nên Set Ngựa đem lại hiệu quả tối thượng với tốc độ tiên phong và gia tăng vượt bậc chỉ số Chính Xác (+100% -> +200% bách phát bách trúng tuyệt đối).",
        elementReason: "Nguyên tố Phong (Gió) đồng bộ hoàn hảo với ma lực chém gió và tốc độ siêu thanh của Shadow!",
      };
    }

    // Analyze hero skills, stories, and passives for elemental scaling mechanisms
    const allSkillTexts = [
      ...skills.map(s => `${s.name} ${s.description}`),
      ...(hero.chuyen_sinh?.stages || []).map(cs => `${cs.title || ''} ${cs.story || ''}`)
    ];

    // Requirement 5: Tất cả các tướng trừ các tướng có cơ chế chiêu tăng hiệu quả từ sát thương thuộc tính thì ưu tiên set ngựa
    const hasElementalScaling = allSkillTexts.some((desc) => {
      return (
        /(tăng|nhân đôi|bổ trợ|tỉ lệ|hiệu quả|truy kích).*(theo|dựa trên|mỗi điểm).*((sát thương|công).*(thuộc tính|nguyên tố)|(thuộc tính|nguyên tố))/i.test(desc) ||
        /(mỗi|cứ).*\d+.*(công|sát thương).*(thuộc tính|nguyên tố|địa|hỏa|thủy|phong)/i.test(desc) ||
        /(tăng|nhận).*\d+.*lần.*công.*(thuộc tính|nguyên tố|địa|hỏa|thủy|phong)/i.test(desc) ||
        /(chuyển hóa|chuyển đổi).*toàn bộ.*sang.*(thuộc tính|nguyên tố|hỏa|thủy|địa|phong)/i.test(desc) ||
        /mỗi điểm.*(thuộc tính|nguyên tố).*tăng/i.test(desc) ||
        /sát thương.*tăng theo.*(thuộc tính|nguyên tố)/i.test(desc)
      );
    });

    const elementScores = { hoa: 0, thuy: 0, phong: 0, tho: 0 };
    allSkillTexts.forEach((desc) => {
      if (/hỏa|lửa|fire|chidor|amaterasu|kì lân|thiêu/i.test(desc)) elementScores.hoa += 3;
      if (/thủy|nước|water|hải long|băng|thủy độn/i.test(desc)) elementScores.thuy += 3;
      if (/phong|gió|wind|rasenshuriken|atomic|bão|cuồng phong|lốc/i.test(desc)) elementScores.phong += 3;
      if (/thổ|địa|đất|earth|gedo|bộc thiên|nham/i.test(desc)) elementScores.tho += 3;
    });

    let bestElemKey = "tho";
    let maxCount = -1;
    (Object.entries(elementScores) as [string, number][]).forEach(([elem, count]) => {
      if (count > maxCount && count > 0) {
        maxCount = count;
        bestElemKey = elem;
      }
    });

    if (hasElementalScaling) {
      return {
        hasElemental: true,
        recommendedSetId: "ti", // Set Tị là mạnh nhất cho tướng có cơ chế tăng hiệu quả từ ST thuộc tính
        recommendedSetName: "Bộ Năm Tị",
        // Thứ tự ưu tiên cho tướng có sát thương nguyên tố: Tị (mạnh nhất) -> Hợi -> Chuột -> Rồng -> Ngựa
        recommendedPriorityList: [
          { id: "ti", name: "Bộ Năm Tị", rank: "1 (Mạnh Nhất)", tag: "Tối Cường Sát Thương Nguyên Tố", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích Cực Hạn & Đột Kích", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "5", tag: "Tối Cường Tốc Độ & Chính Xác", isBest: false },
        ],
        recommendedElement: elemMap[bestElemKey] || elemMap.tho,
        recommendedElementKey: bestElemKey,
        reason: `Tướng sở hữu cơ chế kỹ năng tăng hiệu quả từ sát thương thuộc tính. Bắt buộc ưu tiên sử dụng Set Tị (mạnh nhất), tiếp theo sắp xếp theo thứ tự ưu tiên: Hợi → Chuột → Rồng → Ngựa.`,
        elementReason: `Dựa trên kỹ năng và nguyên tố của tướng (${elemMap[bestElemKey]?.label || "Thổ (Địa)"}), khuyến nghị chọn chuẩn biến thể nguyên tố này để đồng bộ và khuếch đại tối đa sát thương!`,
      };
    } else {
      return {
        hasElemental: false,
        recommendedSetId: "ngua", // Tất cả các tướng trừ các tướng có cơ chế chiêu tăng hiệu quả từ sát thương thuộc tính thì ưu tiên Set Ngựa
        recommendedSetName: "Bộ Năm Ngựa",
        recommendedPriorityList: [
          { id: "ngua", name: "Bộ Năm Ngựa", rank: "1 (Chuẩn Nhất)", tag: "Tăng Chính Xác (+100%→+200%) & Tốc Độ", isBest: true },
          { id: "hoi", name: "Bộ Năm Hợi", rank: "2", tag: "Công Thủ Toàn Diện & Sinh Tồn", isBest: false },
          { id: "chuot", name: "Bộ Năm Chuột", rank: "3", tag: "Bạo Kích Cực Hạn & Đột Kích", isBest: false },
          { id: "rong", name: "Bộ Năm Rồng", rank: "4", tag: "Bá Đạo Uy Lực & Áp Chế", isBest: false },
          { id: "ti", name: "Bộ Năm Tị", rank: "5", tag: "Tối Cường Sát Thương Nguyên Tố", isBest: false },
        ],
        recommendedElement: elemMap.phong,
        recommendedElementKey: "phong",
        reason: "Tất cả các tướng trừ các tướng có cơ chế chiêu tăng hiệu quả từ sát thương thuộc tính thì ưu tiên Set Ngựa. Tướng này không có cơ chế tăng hiệu quả theo sát thương thuộc tính, nên Set Ngựa đem lại giá trị tối đa với tốc độ tiên phong (+60% -> +120%) và gia tăng vượt bậc chỉ số Chính Xác (+100% -> +200% bách phát bách trúng tuyệt đối).",
        elementReason: "Với tướng thuần sát thương, nguyên tố Phong (Gió) hoặc Địa (Thổ) giúp tăng tốc độ phản xạ và chống chịu tối đa.",
      };
    }
  }, [hero, nagatoBuildStyle]);

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
    const btStats = currentBtStage?.stats || { hp: 0, patk: 0, matk: 0, def: 0, speed: 0, ele_atk: 0, ele_def: 0 };
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

    // 5. Zodiac Set Flat Stats (if simulated)
    let zodiacHp = 0;
    let zodiacPatk = 0;
    let zodiacMatk = 0;
    let zodiacDef = 0;
    let zodiacSpeed = 0;
    let zodiacEleDmg = 0;

    if (activeZodiacId !== "none") {
      const activeSet = zodiacSetsList.find((z) => z.id === activeZodiacId);
      if (activeSet && activeSet.variants && activeSet.variants.length > 0) {
        const v = activeSet.variants[0];
        if (isZodiacRainbow && v.rainbow_bonuses?.stats) {
          zodiacHp = v.rainbow_bonuses.stats.hp || 675000;
          zodiacPatk = v.rainbow_bonuses.stats.patk || 675000;
          zodiacMatk = v.rainbow_bonuses.stats.matk || 675000;
          zodiacDef = v.rainbow_bonuses.stats.def || 225000;
          zodiacSpeed = v.rainbow_bonuses.stats.speed || 200000;
          zodiacEleDmg = v.rainbow_bonuses.stats.ele_atk || 675000;
        } else {
          zodiacHp = 315000;
          zodiacPatk = 270000;
          zodiacMatk = 270000;
          zodiacDef = 90000;
          zodiacSpeed = 50000;
          zodiacEleDmg = 270000;
        }
      }
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
  }, [level, selectedChuyenStage, strengthenLevel, currentStrengthenData, currentEvoStage, hasSuperEvoUpgrade, selectedBreakthroughStep, badgeEquipped, activeBadge, activeZodiacId, isZodiacRainbow, activeVanMenh, hero]);

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
          {/* Authentic In-Game Standing Art (Toàn Thân - Images 1, 3, 5) */}
          <div className="relative flex-shrink-0 flex flex-col items-center justify-end">
            <HeroStandingArt
              hero={{
                id: hero.id,
                name: hero.name,
                avatar: hero.avatar,
                standing_image: hero.standing_image,
                full_image: hero.full_image,
                animation: hero.animation || null,
                is_world: hero.is_world,
                quality: hero.quality,
                occupation_type: hero.occupation_type ?? 0,
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
                {hero.is_world ? "Dạng Chuyển Thế" : "Dạng Tiêu Chuẩn"}
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

      {/* 1. CẤP ĐỘ (LEVEL 1 - 255) & BẢNG THUỘC TÍNH TỔNG HỢP */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🎯</span>
              <h2 className="text-xl font-bold text-white">
                1. Cấp Độ (Level 1 - 255) & Bảng Thuộc Tính Tổng Hợp
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              Chỉ số tự động tính toán dựa trên: <b>Cấp độ ({level})</b> + <b>Tiến hóa (+{strengthenLevel})</b> + <b>Chuyển sinh ({selectedChuyenStage > 0 ? `Chuyển ${selectedChuyenStage}` : "Gốc"})</b> + <b>Siêu tiến hóa ({superEvoLabel})</b> + <b>Đột phá ({selectedBreakthroughStep > 0 ? `Cấp ${selectedBreakthroughStep}` : "Chưa đột phá"})</b> + <b>Set Con Giáp ({activeZodiacId.toUpperCase()})</b> + <b>Vận mệnh</b>.
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
                const lastRebirthStage = chuyenStages.at(-1)?.stage || 0;
                setSelectedChuyenStage(lastRebirthStage);
                setActiveTabChuyen(lastRebirthStage || 1);
                setSelectedSuperEvoId(superEvoStages.at(-1)?.id || "none");
                setSelectedBreakthroughStep(breakthroughStages.at(-1)?.step || 0);
                setActiveZodiacId(zodiacRecommendation.recommendedSetId);
                setActiveZodiacElement(zodiacRecommendation.recommendedElementKey);
                setIsZodiacRainbow(true);
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
                <span>ST Nguyên Tố</span>
                {isZodiacRainbow && (
                  <span className="text-[9px] px-1.5 py-0.2 rounded bg-gradient-to-r from-red-500 to-amber-400 text-slate-950 font-black">
                    🌈 Rainbow
                  </span>
                )}
              </div>
              <div className="text-2xl font-black text-cyan-300 font-mono">
                +{formatNumber(calculatedStats.total.elementalDamage)}
              </div>
              <div className="text-[11px] text-slate-300">
                Bộ: <span className="text-amber-300 font-bold">{activeZodiacId.toUpperCase()}</span> ({zodiacRecommendation.recommendedElement.label})
              </div>
              <div className="text-[10px] text-cyan-200/80 font-sans">
                Khuếch đại trực tiếp kỹ năng theo mỗi điểm nguyên tố
              </div>
            </div>
          )}
        </div>
      </section>


      {/* 2. TIẾN HÓA (+1 ĐẾN +60) — CƯỜNG HÓA CHỈ SỐ CƠ BẢN */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-5">
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
            max={60}
            value={strengthenLevel}
            onChange={(e) => setStrengthenLevel(parseInt(e.target.value, 10))}
            className="w-full h-2 bg-slate-800 rounded-lg appearance-none cursor-pointer accent-amber-500"
          />

          <div className="flex flex-wrap items-center gap-2 pt-1">
            <span className="text-[11px] text-slate-500">Cấp chọn nhanh:</span>
            {[0, 10, 20, 30, 40, 50, 60].map((stVal) => (
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
      </section>

      {/* 3. MỤC CHUYỂN SINH (MỐC 1 ĐẾN 7) — GIAO DIỆN CHUẨN GAME */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
            {hero.elemental_builds && hero.elemental_builds.length > 0 && (
              <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-br from-amber-950/40 via-red-950/20 to-black p-4 sm:p-5 space-y-3 shadow-xl">
                <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 border-b border-amber-500/30 pb-2.5">
                  <div className="flex items-center gap-2">
                    <span className="text-xl">🔥⛰️💧</span>
                    <div>
                      <h3 className="text-xs sm:text-sm uppercase font-black text-amber-300 tracking-wider">
                        3 Phong Cách Chơi Theo 3 Nguyên Tố Của Nagato (Cơ Chế Chuyển Sinh)
                      </h3>
                      <p className="text-[11px] text-slate-300 mt-0.5">
                        Nagato nên sử dụng thuộc tính <b>Địa (Thổ Độn)</b> vì đánh Boss Titan dame sẽ cao hơn vượt trội! Dưới đây là 3 phong cách chơi dựa theo 3 nguyên tố ở các mốc Chuyển Sinh (CS1: Hỏa, CS2: Thủy, CS4 & CS7: Địa).
                      </p>
                    </div>
                  </div>
                  <span className="text-[10px] font-mono text-amber-300 bg-amber-950/80 border border-amber-500/40 px-2.5 py-1 rounded-full font-bold shrink-0">
                    Đặc Quyền Nagato
                  </span>
                </div>

                {/* 3 Playstyle Buttons */}
                <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                  {hero.elemental_builds.map((build: any) => {
                    const isSelected = nagatoBuildStyle === build.id;
                    return (
                      <button
                        key={build.id}
                        onClick={() => {
                          setNagatoBuildStyle(build.id);
                          if (build.id === "tho") {
                            setActiveTabChuyen(7);
                            setSelectedChuyenStage(7);
                          } else if (build.id === "hoa") {
                            setActiveTabChuyen(1);
                            setSelectedChuyenStage(1);
                          } else if (build.id === "thuy") {
                            setActiveTabChuyen(2);
                            setSelectedChuyenStage(2);
                          }
                        }}
                        className={`rounded-xl p-3 text-left transition-all border flex flex-col justify-between gap-2 ${
                          isSelected
                            ? "border-amber-400 bg-amber-950/60 shadow-lg shadow-amber-500/30 scale-[1.02]"
                            : "border-slate-800 bg-slate-900/60 hover:bg-slate-800/80 opacity-80 hover:opacity-100"
                        }`}
                      >
                        <div className="space-y-1">
                          <div className="flex items-center justify-between">
                            <span className="text-sm font-black text-white flex items-center gap-1.5">
                              <span>{build.icon}</span>
                              <span>{build.element}</span>
                            </span>
                            <span className={`text-[9px] px-2 py-0.5 rounded-full font-mono font-bold border ${
                              isSelected
                                ? "bg-amber-400 text-slate-950 border-amber-300"
                                : "bg-slate-800 text-slate-400 border-slate-700"
                            }`}>
                              {build.tag}
                            </span>
                          </div>
                          <p className="text-[11px] text-slate-300 leading-relaxed font-sans line-clamp-3">
                            {build.description}
                          </p>
                        </div>

                        <div className="pt-2 border-t border-slate-800/80 flex items-center justify-between text-[10px]">
                          <span className="text-slate-400">Gợi ý trang bị:</span>
                          <span className="font-bold text-amber-300">{build.recommended_set_name}</span>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>
            )}
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
      </section>

      {/* 4. MỤC SIÊU TIẾN HÓA (CAM ➔ ĐỎ ➔ VÀNG) — NÂNG CẤP PHẨM CHẤT THẺ */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
                occupation: hero.occupation_type ?? 0,
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
      </section>

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
          <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
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
              <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/80 to-red-950/80 px-4 py-2 text-center shadow-lg shadow-amber-500/10 shrink-0">
                <div className="text-[10px] text-amber-300 uppercase tracking-widest font-bold">Đang Xem Đột Phá</div>
                <div className="text-xl sm:text-2xl font-black font-mono text-amber-400">
                  Cấp {selectedBreakthroughStep} / 20
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
                      {[1, 5, 10, 15, 20].map((stepVal) => (
                        <button
                          key={stepVal}
                          onClick={() => setSelectedBreakthroughStep(stepVal)}
                          className={`px-2 py-0.5 rounded-lg border font-bold text-xs transition-colors ${
                            selectedBreakthroughStep === stepVal
                              ? "border-amber-400 bg-amber-500 text-slate-950"
                              : "border-slate-800 bg-slate-900 text-slate-300 hover:bg-slate-800"
                          }`}
                        >
                          Cấp {stepVal}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* Range Slider for smooth scrubbing */}
                  <div className="flex items-center gap-4 bg-slate-950/60 p-3 rounded-2xl border border-slate-800">
                    <span className="text-xs font-mono font-bold text-slate-400">Cấp 1</span>
                    <input
                      type="range"
                      min="1"
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
          </section>
        );
      })()}

      {/* 6. TRANG BỊ (5 ĐẠI BỘ TRANG BỊ CON GIÁP) */}
      <section className="rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
          <div>
            <div className="flex items-center gap-2">
              <span className="text-2xl">🛡️</span>
              <h2 className="text-xl font-bold text-white">
                6. Trang Bị (5 Đại Bộ Trang Bị Con Giáp)
              </h2>
            </div>
            <p className="text-xs text-slate-400 mt-1">
              5 bộ trang bị hoàng đạo uy lực tối thượng trong game: <b>Bộ Năm Hợi</b>, <b>Bộ Năm Chuột</b>, <b>Bộ Năm Rồng</b>, <b>Bộ Năm Tị</b>, <b>Bộ Năm Ngựa</b> với mốc Cầu Vồng đột phá thần khí. Tự động đề xuất set tối ưu theo cơ chế sát thương của từng tướng.
            </p>
          </div>

          <div className="flex items-center gap-2">
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
        </div>

        {/* RECOMMENDATION ENGINE BANNER - REQUIREMENT 4, 5, 6 */}
        <div className={`rounded-3xl border p-5 sm:p-6 backdrop-blur-xl transition-all shadow-xl space-y-4 ${
          zodiacRecommendation.hasElemental
            ? "border-rose-500/40 bg-gradient-to-br from-rose-950/40 via-amber-950/20 to-black shadow-rose-950/30"
            : "border-sky-500/40 bg-gradient-to-br from-sky-950/40 via-indigo-950/20 to-black shadow-sky-950/30"
        }`}>
          <div className="flex flex-col lg:flex-row items-start lg:items-center justify-between gap-4 border-b border-slate-800/80 pb-4">
            <div className="space-y-1">
              <div className="flex flex-wrap items-center gap-2">
                <span className="text-xl">🎯</span>
                <span className="text-xs uppercase font-extrabold tracking-wider text-amber-400">
                  Gợi Ý Trang Bị Con Giáp & Nguyên Tố Cho {hero.name}
                </span>
                <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-black border ${
                  zodiacRecommendation.hasElemental
                    ? "bg-rose-500/20 text-rose-300 border-rose-500/40 animate-pulse"
                    : "bg-sky-500/20 text-sky-300 border-sky-500/40"
                }`}>
                  {zodiacRecommendation.hasElemental ? "⚡ Tướng Có Sát Thương Nguyên Tố" : "🛡️ Tướng Thuần Sát Thương (Không Phụ Thuộc ST Nguyên Tố)"}
                </span>
              </div>
              <p className="text-xs text-slate-300 leading-relaxed font-sans">
                {zodiacRecommendation.reason}
              </p>
            </div>

            <button
              onClick={() => {
                setActiveZodiacId(zodiacRecommendation.recommendedSetId);
                setActiveZodiacTab(zodiacRecommendation.recommendedSetId);
                setActiveZodiacElement(zodiacRecommendation.recommendedElementKey);
                setIsZodiacRainbow(true);
              }}
              className="shrink-0 rounded-2xl border border-amber-400 bg-gradient-to-r from-amber-500 to-yellow-600 hover:from-amber-400 hover:to-yellow-500 px-4 py-2.5 text-xs font-black text-slate-950 shadow-lg shadow-amber-500/30 transition-all flex items-center gap-2"
            >
              <span>⚡</span>
              <span>Áp Dụng Gợi Ý Chuẩn ({zodiacRecommendation.recommendedSetName} - {zodiacRecommendation.recommendedElement.label})</span>
            </button>
          </div>

          {/* Nagato 3 Playstyles Quick Selector inside Zodiac Recommendation Card (Requirement 6) */}
          {hero.elemental_builds && hero.elemental_builds.length > 0 && (
            <div className="p-3.5 rounded-2xl bg-black/60 border border-amber-500/30 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 shadow-inner">
              <div className="flex items-center gap-2">
                <span className="text-lg">🌀</span>
                <span className="text-xs font-bold text-amber-300">
                  Chọn Phong Cách Chơi Của Nagato Để Tự Động Đổi Set & Nguyên Tố:
                </span>
              </div>
              <div className="flex items-center gap-2 flex-wrap">
                {hero.elemental_builds.map((build: any) => {
                  const isCur = nagatoBuildStyle === build.id;
                  return (
                    <button
                      key={build.id}
                      onClick={() => {
                        setNagatoBuildStyle(build.id);
                        setActiveZodiacId(build.recommended_set_id);
                        setActiveZodiacTab(build.recommended_set_id);
                        setActiveZodiacElement(build.recommended_element_key);
                        setIsZodiacRainbow(true);
                      }}
                      className={`px-3 py-1.5 rounded-xl text-xs font-bold border transition-all flex items-center gap-1.5 ${
                        isCur
                          ? "border-amber-400 bg-amber-500 text-slate-950 font-black shadow-md shadow-amber-500/30 scale-105"
                          : "border-slate-800 bg-slate-900 text-slate-300 hover:bg-slate-800"
                      }`}
                    >
                      <span>{build.icon}</span>
                      <span>{build.element}</span>
                    </button>
                  );
                })}
              </div>
            </div>
          )}

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-xs">
            {/* Priority Order List */}
            <div className="space-y-2 rounded-2xl border border-slate-800/90 bg-slate-950/60 p-4">
              <div className="text-[11px] font-bold text-amber-300 uppercase tracking-wider flex items-center gap-1.5">
                <span>🏆</span> Thứ Tự Ưu Tiên Set Con Giáp Khuyên Dùng:
              </div>
              <div className="space-y-1.5">
                {zodiacRecommendation.recommendedPriorityList.map((item, idx) => (
                  <div
                    key={idx}
                    className={`flex items-center justify-between p-2 rounded-xl border text-xs ${
                      item.isBest
                        ? "border-amber-400/60 bg-amber-950/40 text-white font-bold"
                        : "border-slate-800 bg-slate-900/40 text-slate-300"
                    }`}
                  >
                    <div className="flex items-center gap-2">
                      <span className={`h-5 w-5 rounded-full flex items-center justify-center text-[10px] font-mono font-black ${
                        item.isBest ? "bg-amber-400 text-black" : "bg-slate-800 text-slate-400"
                      }`}>
                        {idx + 1}
                      </span>
                      <span>{item.name}</span>
                    </div>
                    <span className={`text-[10px] px-2 py-0.5 rounded-full font-mono ${
                      item.isBest ? "bg-amber-400/20 text-amber-300 border border-amber-400/30 font-black" : "text-slate-500"
                    }`}>
                      {item.tag}
                    </span>
                  </div>
                ))}
              </div>
            </div>

            {/* Element Recommendation */}
            <div className="space-y-2 rounded-2xl border border-slate-800/90 bg-slate-950/60 p-4 flex flex-col justify-between">
              <div className="space-y-2">
                <div className="text-[11px] font-bold text-sky-300 uppercase tracking-wider flex items-center gap-1.5">
                  <span>🌀</span> Gợi Ý Nguyên Tố Cho Set Con Giáp:
                </div>
                <div className="flex items-center gap-3 p-2.5 rounded-xl border border-sky-500/30 bg-sky-950/30">
                  <span className="text-3xl">{zodiacRecommendation.recommendedElement.icon}</span>
                  <div>
                    <div className="font-extrabold text-sm text-sky-200">
                      Nguyên Tố: {zodiacRecommendation.recommendedElement.label}
                    </div>
                    <div className="text-[11px] text-slate-300 mt-0.5">
                      {zodiacRecommendation.elementReason}
                    </div>
                  </div>
                </div>
              </div>

              <div className="pt-2 border-t border-slate-800/80 flex items-center justify-between text-[11px] text-slate-400">
                <span>🌈 Có hỗ trợ Mốc Cầu Vồng (Rainbow Tier) siêu chỉ số:</span>
                <span className="font-bold text-amber-400">✓ Đạt chuẩn tối đa</span>
              </div>
            </div>
          </div>
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
            </button>
          ))}
        </div>

        {/* Selected Zodiac Set Detail */}
        {(() => {
          const zSet = zodiacSetsList.find((z) => z.id === activeZodiacTab) || zodiacSetsList[0];
          if (!zSet) return null;

          const isSimulated = activeZodiacId === zSet.id;

          // Determine active variant based on activeZodiacElement
          let currentVariant = zSet.variants[0];
          if (activeZodiacElement !== "auto") {
            const foundV = zSet.variants.find((v: any) => {
              const el = v.element.toLowerCase();
              if (activeZodiacElement === "hoa" && (el.includes("hỏa") || el.includes("lửa"))) return true;
              if (activeZodiacElement === "thuy" && (el.includes("thủy") || el.includes("nước"))) return true;
              if (activeZodiacElement === "phong" && (el.includes("phong") || el.includes("gió"))) return true;
              if (activeZodiacElement === "tho" && (el.includes("thổ") || el.includes("địa") || el.includes("đất"))) return true;
              return false;
            });
            if (foundV) currentVariant = foundV;
          } else {
            // Auto match recommended element
            const recKey = zodiacRecommendation.recommendedElementKey;
            const foundRec = zSet.variants.find((v: any) => {
              const el = v.element.toLowerCase();
              if (recKey === "hoa" && (el.includes("hỏa") || el.includes("lửa"))) return true;
              if (recKey === "thuy" && (el.includes("thủy") || el.includes("nước"))) return true;
              if (recKey === "phong" && (el.includes("phong") || el.includes("gió"))) return true;
              if (recKey === "tho" && (el.includes("thổ") || el.includes("địa") || el.includes("đất"))) return true;
              return false;
            });
            if (foundRec) currentVariant = foundRec;
          }

          return (
            <div className={`rounded-2xl border p-6 space-y-5 transition-all ${
              isZodiacRainbow
                ? "border-amber-500/50 bg-gradient-to-br from-slate-950 via-amber-950/20 to-black shadow-xl shadow-amber-500/10"
                : "border-slate-800 bg-slate-950/80"
            }`}>
              <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3 border-b border-slate-800 pb-3">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="text-2xl">{zSet.icon}</span>
                    <h3 className="text-lg font-black text-white">{zSet.name}</h3>
                    {isZodiacRainbow && (
                      <span className="px-2 py-0.5 rounded-full text-[10px] font-bold bg-gradient-to-r from-red-500 via-amber-400 via-emerald-400 via-cyan-400 to-purple-500 text-slate-950 animate-pulse">
                        🌈 Mốc Cầu Vồng
                      </span>
                    )}
                  </div>
                </div>

                <div className="flex items-center gap-2">
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
              </div>

              {/* Element Variant Selector within this set */}
              <div className="space-y-2">
                <div className="text-xs font-bold text-slate-400 uppercase tracking-wider flex flex-wrap items-center justify-between gap-2">
                  <span>Chọn Biến Thể Nguyên Tố Cho Bộ Trang Bị:</span>
                  <span className="text-[11px] text-amber-300 font-sans">
                    Gợi ý nguyên tố cho {hero.name}: <b>{zodiacRecommendation.recommendedElement.label}</b>
                  </span>
                </div>
                <div className="grid grid-cols-2 sm:grid-cols-4 gap-2">
                  {zSet.variants.map((v: any, vIdx: number) => {
                    const elLower = v.element.toLowerCase();
                    const vElemKey = elLower.includes("hỏa") ? "hoa" : elLower.includes("thủy") ? "thuy" : elLower.includes("phong") ? "phong" : "tho";
                    const isSelected = v.suit_id === currentVariant.suit_id;
                    const isRecommended = vElemKey === zodiacRecommendation.recommendedElementKey;

                    return (
                      <button
                        key={vIdx}
                        onClick={() => setActiveZodiacElement(vElemKey)}
                        className={`rounded-xl p-2.5 text-xs font-bold transition-all flex items-center justify-between border ${
                          isSelected
                            ? "border-amber-400 bg-amber-500/20 text-white shadow-md shadow-amber-500/20"
                            : "border-slate-800 bg-slate-900/60 text-slate-400 hover:bg-slate-800 hover:text-white"
                        }`}
                      >
                        <span className="flex items-center gap-1.5 truncate">
                          <span>{vElemKey === "hoa" ? "🔥" : vElemKey === "thuy" ? "💧" : vElemKey === "phong" ? "🌪️" : "⛰️"}</span>
                          <span className="truncate">{v.element}</span>
                        </span>
                        {isRecommended && (
                          <span className="text-[9px] bg-amber-400/20 text-amber-300 border border-amber-400/30 px-1.5 py-0.2 rounded font-mono shrink-0">
                            Khuyên dùng
                          </span>
                        )}
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Rainbow Tier Toggle Card */}
              <div className="rounded-2xl border border-purple-500/40 bg-gradient-to-r from-purple-950/40 via-red-950/30 to-amber-950/30 p-4 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div className="flex items-center gap-3">
                  <span className="text-3xl select-none">🌈</span>
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="text-sm font-black text-transparent bg-clip-text bg-gradient-to-r from-red-400 via-amber-300 to-cyan-300">
                        Mốc Cầu Vồng (Rainbow Tier - Đột Phá Thần Khí)
                      </span>
                      <span className="text-[10px] bg-amber-400/20 border border-amber-400/40 text-amber-300 px-2 py-0.2 rounded-full font-bold">
                        Tăng Rất Nhiều Chỉ Số
                      </span>
                    </div>
                    <p className="text-xs text-slate-300 mt-0.5">
                      Gia tăng vượt bậc chỉ số toàn diện: <b>+1,200,000 Công</b>, <b>+450,000 Thủ</b>, <b>+1,500,000 HP</b>, và <b>+1,000,000 Sát Thương Nguyên Tố</b>.
                    </p>
                  </div>
                </div>

                <button
                  onClick={() => setIsZodiacRainbow(!isZodiacRainbow)}
                  className={`shrink-0 rounded-xl px-4 py-2 text-xs font-black transition-all shadow ${
                    isZodiacRainbow
                      ? "bg-gradient-to-r from-red-500 via-amber-500 via-emerald-500 to-indigo-500 text-white shadow-lg shadow-purple-500/30 border border-white/40"
                      : "border border-slate-700 bg-slate-800 text-slate-400 hover:text-white"
                  }`}
                >
                  {isZodiacRainbow ? "✓ Mốc Cầu Vồng (Đang Bật)" : "Bật Mốc Cầu Vồng"}
                </button>
              </div>

              {/* 4 Parts Display */}
              <div className="space-y-2">
                <div className="text-xs font-bold text-slate-400 uppercase tracking-wider flex items-center justify-between">
                  <span>
                    4 Món Trang Bị Thuộc Bộ ({isZodiacRainbow ? (currentVariant.rainbow_suit_name || currentVariant.suit_name) : currentVariant.suit_name}):
                  </span>
                  <span className="text-[10px] text-amber-400">
                    {isZodiacRainbow ? "🌈 Đang hiển thị trang bị Mốc Cầu Vồng (Phẩm 8)" : "🌟 Đang hiển thị trang bị Mốc Thường (Phẩm 7)"}
                  </span>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-3">
                  {(() => {
                    const activeParts = isZodiacRainbow && currentVariant.rainbow_parts ? currentVariant.rainbow_parts : currentVariant.parts;
                    return activeParts.map((p: any, idx: number) => {
                      const normalPart = currentVariant.parts?.[idx];
                      const rainbowPart = currentVariant.rainbow_parts?.[idx];
                      return (
                        <div
                          key={idx}
                          className={`rounded-xl border p-3 flex flex-col justify-between gap-2.5 transition-all ${
                            isZodiacRainbow
                              ? "border-amber-400/60 bg-gradient-to-br from-amber-950/40 via-purple-950/20 to-black shadow-lg shadow-amber-500/10"
                              : "border-slate-800 bg-slate-900/80"
                          }`}
                        >
                          <div className="flex items-center gap-3">
                            <div className="h-12 w-12 shrink-0 rounded-lg border border-amber-500/40 bg-slate-950 p-1 flex items-center justify-center overflow-hidden">
                              <ImageWithFallback
                                src={p.icon}
                                alt={p.name}
                                className="h-full w-full object-contain"
                                fallbackIcon={p.slot_name === "Vũ khí" ? "⚔️" : p.slot_name === "Áo giáp" ? "🛡️" : p.slot_name === "Trang sức" ? "💍" : "👢"}
                              />
                            </div>
                            <div className="flex-1 min-w-0">
                              <div className="text-[10px] text-amber-400 font-bold flex items-center justify-between">
                                <span className="flex items-center gap-1">
                                  <span>{p.slot_name}</span>
                                  {isZodiacRainbow ? (
                                    <span className="text-[9px] px-1 rounded bg-purple-900/80 text-yellow-300 font-mono">Phẩm 8</span>
                                  ) : (
                                    <span className="text-[9px] px-1 rounded bg-slate-800 text-slate-300 font-mono">Phẩm 7</span>
                                  )}
                                </span>
                                <span className="text-[9px] text-slate-500 font-mono">#{p.id}</span>
                              </div>
                              <div className="text-xs font-bold text-white truncate" title={p.name}>{p.name}</div>
                            </div>
                          </div>

                          {/* In-game special combat effect */}
                          {p.special_effect && (
                            <div className={`text-[11px] font-medium p-2 rounded-lg leading-relaxed shadow-sm border ${
                              isZodiacRainbow
                                ? "text-amber-200 bg-amber-950/50 border-amber-500/40"
                                : "text-emerald-400 bg-emerald-950/40 border-emerald-500/30"
                            }`} title={p.special_effect}>
                              <div className="flex items-center justify-between text-[10px] uppercase font-bold text-slate-400 mb-0.5">
                                <span>{isZodiacRainbow ? "⚡ Hiệu Ứng Cầu Vồng:" : "⚡ Hiệu Ứng Thường:"}</span>
                                {normalPart && rainbowPart && isZodiacRainbow && normalPart.effect_value !== rainbowPart.effect_value && (
                                  <span className="text-yellow-300 font-mono">
                                    {normalPart.effect_value}% → {rainbowPart.effect_value}%
                                  </span>
                                )}
                              </div>
                              <div>{p.special_effect}</div>
                            </div>
                          )}
                        </div>
                      );
                    });
                  })()}
                </div>
              </div>

              {/* Special Attributes Before & After Rainbow Tier - Requirement 1 */}
              {zSet.special_attributes && (
                <div className="rounded-2xl border border-amber-500/40 bg-gradient-to-r from-amber-950/40 via-purple-950/20 to-black p-5 space-y-4 shadow-xl">
                  <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-2 border-b border-amber-500/30 pb-3">
                    <div className="flex items-center gap-2">
                      <span className="text-xl">✨</span>
                      <div>
                        <h4 className="text-sm uppercase font-extrabold text-amber-300 tracking-wider">
                          {zSet.special_attributes.title || `Chỉ Số Đặc Biệt Trước & Sau Khi Lên Cầu Vồng (${zSet.name})`}
                        </h4>
                        <p className="text-[11px] text-slate-300 mt-0.5">
                          Kiểm tra chính xác chỉ số hiệu ứng chiến đấu của từng món trang bị khi nâng từ Mốc Thường (Phẩm 7) lên Mốc Cầu Vồng (Phẩm 8).
                        </p>
                      </div>
                    </div>
                    <span className="text-[10px] text-yellow-300 font-mono bg-yellow-950/80 border border-yellow-500/40 px-2.5 py-1 rounded-full font-bold shrink-0">
                      Chỉ Số Chuẩn Game 100%
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {/* Normal Tier Attributes */}
                    <div className="rounded-xl border border-slate-800 bg-slate-950/70 p-3.5 space-y-2">
                      <div className="flex items-center justify-between border-b border-slate-800/80 pb-1.5">
                        <span className="text-xs font-bold text-slate-300 flex items-center gap-1.5">
                          <span>🌟</span>
                          <span>Trước Khi Lên Cầu Vồng (Phẩm 7 - Thường)</span>
                        </span>
                        <span className="text-[10px] font-mono px-2 py-0.5 rounded bg-slate-800 text-slate-400">Phẩm 7</span>
                      </div>
                      <div className="space-y-1.5 text-xs">
                        {(zSet.special_attributes.normal_highlights || []).map((hl: string, hlIdx: number) => (
                          <div key={hlIdx} className="p-2 rounded-lg bg-black/40 border border-slate-800/70 text-slate-300 flex items-start gap-2">
                            <span className="leading-relaxed">{hl}</span>
                          </div>
                        ))}
                      </div>
                    </div>

                    {/* Rainbow Tier Attributes */}
                    <div className={`rounded-xl border p-3.5 space-y-2 transition-all ${
                      isZodiacRainbow
                        ? "border-amber-400/80 bg-gradient-to-br from-amber-950/50 to-purple-950/40 shadow-lg shadow-amber-500/20"
                        : "border-purple-500/40 bg-purple-950/20"
                    }`}>
                      <div className="flex items-center justify-between border-b border-amber-500/30 pb-1.5">
                        <span className="text-xs font-extrabold text-amber-300 flex items-center gap-1.5">
                          <span>🌈</span>
                          <span>Sau Khi Lên Cầu Vồng (Phẩm 8)</span>
                        </span>
                        <span className="text-[10px] font-bold font-mono px-2 py-0.5 rounded bg-gradient-to-r from-red-500 via-amber-400 to-cyan-400 text-black">
                          Gấp 2 Lần Chỉ Số
                        </span>
                      </div>
                      <div className="space-y-1.5 text-xs">
                        {(zSet.special_attributes.rainbow_highlights || []).map((hl: string, hlIdx: number) => (
                          <div key={hlIdx} className="p-2 rounded-lg bg-black/60 border border-amber-500/30 text-amber-200 flex items-start gap-2 font-medium">
                            <span className="leading-relaxed">{hl}</span>
                          </div>
                        ))}
                      </div>
                    </div>
                  </div>
                </div>
              )}

              {/* Set Effects & Best Heroes Synergy */}
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-4 pt-1">
                {/* Set Bonuses */}
                <div className="rounded-xl border border-slate-800 bg-slate-900/50 p-4 space-y-2">
                  <div className="text-xs font-bold text-amber-400 uppercase tracking-wider flex items-center justify-between">
                    <span>Hiệu Ứng Kích Hoạt Bộ Trang Bị</span>
                    <span className={`text-[10px] px-2 py-0.5 rounded font-bold ${
                      isZodiacRainbow
                        ? "text-yellow-300 bg-yellow-950/80 border border-yellow-500/40"
                        : "text-slate-400 bg-slate-800"
                    }`}>
                      {isZodiacRainbow ? "🌈 Mốc Cầu Vồng (Phẩm 8)" : "🌟 Mốc Thường (Phẩm 7)"}
                    </span>
                  </div>
                  <div className="space-y-1.5 text-xs">
                    <div className="flex items-center justify-between text-slate-300 py-1.5 border-b border-slate-800/60">
                      <span>Mốc 2 món:</span>
                      <span className="font-mono text-emerald-400 font-semibold">
                        {isZodiacRainbow && currentVariant.rainbow_bonuses ? currentVariant.rainbow_bonuses.two_piece : currentVariant.bonuses.two_piece}
                      </span>
                    </div>
                    <div className="flex items-center justify-between text-slate-300 py-1.5 border-b border-slate-800/60">
                      <span>Mốc 3 món:</span>
                      <span className="font-mono text-emerald-400 font-semibold">
                        {isZodiacRainbow && currentVariant.rainbow_bonuses ? currentVariant.rainbow_bonuses.three_piece : currentVariant.bonuses.three_piece}
                      </span>
                    </div>
                    <div className="flex items-center justify-between text-slate-300 py-1.5">
                      <span>Mốc 4 món {isZodiacRainbow ? "(Cầu Vồng)" : "(Cơ bản)"}:</span>
                      <span className="font-mono text-amber-400 font-bold">
                        {isZodiacRainbow && currentVariant.rainbow_bonuses ? currentVariant.rainbow_bonuses.four_piece : currentVariant.bonuses.four_piece}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          );
        })()}
      </section>      {/* 7. HUY HIỆU CỦA TƯỚNG (NẾU CÓ) */}
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
            <span className="text-slate-500">Giới Tính / Phân Loại:</span>
            <div className="font-mono text-white font-bold">{hero.sex === 1 ? "Nam" : hero.sex === 2 ? "Nữ" : "Đặc Biệt"}</div>
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
