// web/src/lib/data.ts
import fs from "fs";
import path from "path";
import { stripVietnameseAccents } from "./utils";

const DATA_DIR = path.join(process.cwd(), "src", "data");

function readJsonFile<T>(filename: string, fallback: T): T {
  try {
    const filePath = path.join(DATA_DIR, filename);
    if (!fs.existsSync(filePath)) {
      return fallback;
    }
    const content = fs.readFileSync(filePath, "utf-8");
    return JSON.parse(content) as T;
  } catch (err) {
    console.error(`Error reading ${filename}:`, err);
    return fallback;
  }
}

// 1. Heroes
export interface HeroSummary {
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
  full_image?: string | null;
  is_only: number;
  rebirth: number;
  hp: number;
  patk: number;
  matk: number;
  def: number;
  speed: number;
  has_image: boolean;
}

export function getHeroesCatalog(): HeroSummary[] {
  return readJsonFile<HeroSummary[]>("heroes_catalog.json", []);
}

export function getHeroById(id: string): any | null {
  const allHeroes = readJsonFile<Record<string, any>>("heroes_detail.json", {});
  return allHeroes[id] || null;
}

// Batch consumers (card library) read the detail file once for all forms.
export function getHeroesDetails(): Record<string, ReturnType<typeof getHeroById>> {
  return readJsonFile("heroes_detail.json", {});
}

// 2. Suits (Equipment Sets)
export interface SuitSummary {
  element_id?: string | null;
  id: string;
  name: string;
  parts_count: number;
  parts: Array<{
    id: string;
    name: string;
    slot: number;
    slot_name: string;
    quality: number;
    equip_id: string;
    icon: string | null;
    primary_stat?: any;
    secondary_stat?: any;
    evolution?: any;
  }>;
  bonuses: Record<string, any>;
  has_all_images: boolean;
}

export function getSuitsCatalog(): SuitSummary[] {
  return readJsonFile<SuitSummary[]>("suits_catalog.json", []);
}

export function getSuitById(id: string): SuitSummary | null {
  const allSuits = readJsonFile<Record<string, SuitSummary>>("suits_detail.json", {});
  return allSuits[id] || null;
}

// 3. Equipment
export interface EquipmentSummary {
  element_id?: string | null;
  id: string;
  name: string;
  slot: number;
  slot_name: string;
  quality: number;
  equip_id: string;
  suit_id: string | null;
  suit_name: string | null;
  icon: string | null;
  primary_stat: any;
  secondary_stat: any;
  evolution: any;
  cd?: number;
}

export function getEquipmentCatalog(): EquipmentSummary[] {
  return readJsonFile<EquipmentSummary[]>("equipment_catalog.json", []);
}

export function getEquipmentById(id: string): any | null {
  const allEquip = readJsonFile<Record<string, any>>("equipment_detail.json", {});
  return allEquip[id] || null;
}

// 4. Skills
export interface SkillSummary {
  id: string;
  name: string;
  skill_type: string;
  quality: number;
  max_lv: number;
  cd: number;
  pre_cd: number;
  rate: number;
  icon: string | null;
  effect: number;
  attr_effect: number;
  effect_lvchange: number;
  description: string;
}

export function getSkillsCatalog(): SkillSummary[] {
  return readJsonFile<SkillSummary[]>("skills_catalog.json", []);
}

export function getSkillById(id: string): any | null {
  const allSkills = readJsonFile<Record<string, any>>("skills_detail.json", {});
  return allSkills[id] || null;
}

// 5. Ban Sức
export function getBanSucData(): any {
  return readJsonFile<any>("ban_suc.json", {});
}

export function getBanSucRecommendations(): any {
  return readJsonFile<any>("ban_suc_recommendations.json", { heroes: {}, ban_suc_definitions: {} });
}

export function getHeroBanSucRecommendation(heroId: string): any | null {
  const data = getBanSucRecommendations();
  return data?.heroes?.[heroId] || null;
}

// 6. Editorial
export function getEditorialData(): any {
  return readJsonFile<any>("editorial_data.json", { tier_list: { status: "draft" }, guides: [] });
}

// 6.1 Tier List
export interface TierListHero {
  id: string;
  name: string;
  game_name: string;
  tier: "UBER" | "TIER 0" | "TIER 1" | "TIER 2" | "TIER 3" | "TIER 4";
  role: "DEALER" | "SUPPORT";
  role_label: string;
  career_id: number;
  career_name: string;
  quality: number;
  avatar: string | null;
  standing_image: string | null;
  image: string;
  image_2x: string;
  image_3x?: string;
  url: string;
  notes: string;
  hp: number;
  patk: number;
  matk: number;
  def: number;
  speed: number;
  is_world: boolean;
}

export interface TierListSection {
  tier: string;
  title: string;
  description: string;
  badge: string;
  border: string;
  bg: string;
  accent: string;
  heroes: TierListHero[];
}

export interface TierListGroup {
  role: "DEALER" | "SUPPORT";
  title: string;
  subtitle: string;
  description: string;
  infographic_image: string;
  infographic_image_2x: string;
  infographic_image_4k?: string;
  total_heroes: number;
  sections: TierListSection[];
  heroes: TierListHero[];
}

export interface TierListData {
  version: string;
  status: string;
  title: string;
  subtitle: string;
  last_updated: string;
  original_graphic: string;
  original_graphic_4k?: string;
  stats: {
    total_ranked_heroes: number;
    dealer_count: number;
    support_count: number;
    tiers_count: number;
  };
  tier_legend: Array<{
    tier: string;
    title: string;
    color: string;
    desc: string;
  }>;
  groups: TierListGroup[];
}

export function getTierListData(): TierListData {
  return readJsonFile<TierListData>("tier_list.json", {
    version: "2026.10",
    status: "draft",
    title: "Bảng Xếp Hạng Tướng (Tier List)",
    subtitle: "",
    last_updated: "",
    original_graphic: "",
    stats: { total_ranked_heroes: 0, dealer_count: 0, support_count: 0, tiers_count: 0 },
    tier_legend: [],
    groups: [],
  });
}

// 7. Search Index
export interface SearchEntity {
  id: string;
  title: string;
  clean_title: string;
  category: "hero" | "skill" | "suit" | "equipment";
  category_name: string;
  url: string;
  image: string | null;
  badge: string;
  subtext: string;
}

let cachedSearchIndex: SearchEntity[] | null = null;

export function getSearchIndex(): SearchEntity[] {
  if (!cachedSearchIndex) {
    cachedSearchIndex = readJsonFile<SearchEntity[]>("search_index.json", []);
  }
  return cachedSearchIndex;
}

export function searchEntities(query: string, limit: number = 10): SearchEntity[] {
  if (!query || query.trim().length === 0) return [];
  const cleanQ = stripVietnameseAccents(query);
  const qLower = query.toLowerCase().trim();
  const index = getSearchIndex();

  const results: SearchEntity[] = [];
  for (const item of index) {
    // Exact or prefix match on clean or raw title
    if (
      item.clean_title.includes(cleanQ) ||
      item.title.toLowerCase().includes(qLower) ||
      item.id === cleanQ
    ) {
      results.push(item);
      if (results.length >= limit) break;
    }
  }
  return results;
}
