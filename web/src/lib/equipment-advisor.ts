import zodiacData from "../data/zodiac_sets.json";
import profileData from "../data/hero_combat_profiles.json";
import { getAbility, getElement } from "./game-attributes";

export interface Stat { ability_id: number; value: number; level_add: number }
export interface EquipmentPart {
  id: string; equip_id: string; name: string | null; element_id: string | null;
  slot: number; quality: number; icon: string | null;
  primary_stat: Stat; secondary_stat: Stat;
  combat_effect: { description: string; effect: number; occupation_ids: number[];
    activation: string | number; activation_level: number; skill_type: string; source: string };
}
export type Bonuses = Record<string, number[][]>;
export interface Variant {
  element_id: string; suit_id: string; rainbow_suit_id: string;
  parts: EquipmentPart[]; rainbow_parts: EquipmentPart[];
  bonuses: Bonuses; rainbow_bonuses: Bonuses; source: string;
}
export interface ZodiacSet { id: string; name: string; icon: string; variants: Variant[] }
export interface Evidence {
  skill_id: string | null; slot: number; name: string; element_ids: string[];
  description: string; source: string; min_rebirth: number; min_super_evo: number;
}
export interface CombatProfile {
  id: string; occupation_id: number | null; occupation_shade_id: number | null;
  evidence: Evidence[];
  skill_unlocks: Record<string, number | null>;
}
export const zodiacSets = zodiacData as unknown as ZodiacSet[];
export const combatProfiles = profileData as unknown as Record<string, CombatProfile>;
export interface Selection { setId: string; elementId: string; rainbow: boolean }
export interface UpgradeState { rebirth: number; superEvo: number; level: number; breakthrough: number }
export const emptySelection: Selection = { setId: "none", elementId: "", rainbow: false };

export function resolveVariant(selection: Selection, sets = zodiacSets): Variant | null {
  if (!getElement(selection.elementId)) return null;
  return sets.find(s => s.id === selection.setId)?.variants.find(v => v.element_id === selection.elementId) ?? null;
}

export function activeEvidence(profile: CombatProfile | undefined, state: UpgradeState): Evidence[] {
  return profile?.evidence.filter(e => e.min_rebirth <= state.rebirth && e.min_super_evo <= state.superEvo) ?? [];
}

// Manual preferences retained only as tie breakers supported by exact-form formulas.
// They do not establish an innate element or a universal best build.
export const manualPreferences: Record<string, { setId: string; note: string }> = {
  "82400": { setId: "ti", note: "Cẩm nang ưu tiên Tị; công Địa bổ trợ công thức Gedo Mazo. Chưa xác minh ưu thế Boss Titan." },
  "43500": { setId: "ti", note: "Cẩm nang ưu tiên Tị cho Elaina; chỉ áp dụng khi có công thức kỹ năng tương ứng." },
  "83100": { setId: "ti", note: "Cẩm nang ưu tiên Tị cho CT - Elaina; phân biệt từng hệ trong kỹ năng." },
  "83200": { setId: "ti", note: "Cẩm nang ưu tiên Tị cho Phù Thủy - Elaina; không sao chép hệ của dạng CT." },
  "43400": { setId: "ngua", note: "Cẩm nang ưu tiên Ngựa cho Cid; hiệu ứng chính xác có điều kiện nghề, không bảo đảm luôn trúng." },
  "82900": { setId: "ngua", note: "Cẩm nang ưu tiên Ngựa cho CT - Cid; đối chiếu công Phong của kỹ năng." },
  "83000": { setId: "ngua", note: "Cẩm nang ưu tiên Ngựa cho Shadow; đối chiếu công Phong của kỹ năng." },
};
export interface Recommendation { selection: Selection; name: string; amount: number; evidence: Evidence[]; manualNote: string | null }
export function recommendations(heroId: string, state: UpgradeState, rainbow: boolean, sets = zodiacSets): Recommendation[] {
  const evidence = activeEvidence(combatProfiles[heroId], state);
  const result: Recommendation[] = [];
  for (const set of sets) for (const variant of set.variants) {
    const element = getElement(variant.element_id);
    const matching = evidence.filter(e => e.element_ids.includes(variant.element_id));
    const parts = rainbow ? variant.rainbow_parts : variant.parts;
    if (!element || !matching.length || parts.length !== 4 || parts.some(p => p.element_id !== variant.element_id)) continue;
    const bonuses = rainbow ? variant.rainbow_bonuses : variant.bonuses;
    const amount = Object.values(bonuses).flat().filter(([id]) => id === element.attack_id).reduce((sum, [, value]) => sum + value, 0);
    if (amount <= 0) continue;
    const preference = manualPreferences[heroId];
    result.push({ selection: { setId: set.id, elementId: variant.element_id, rainbow },
      name: set.name, amount, evidence: matching, manualNote: preference?.setId === set.id ? preference.note : null });
  }
  return result.sort((a, b) => b.amount - a.amount || Number(Boolean(b.manualNote)) - Number(Boolean(a.manualNote)));
}

export function effectEligibility(part: EquipmentPart, profile: CombatProfile | undefined): "eligible" | "ineligible" | "unknown" {
  const effect = part.combat_effect;
  if (effect.activation !== "" && effect.activation !== 0) return "unknown";
  // All current records have activation_level=0. Do not guess whether a future
  // nonzero value means hero level, equipment level, or another activation gate.
  if (effect.activation_level !== 0) return "unknown";
  if (!effect.occupation_ids.length) return "eligible";
  // occupation1 describes a combat-effect condition, not permission to equip.
  const id = profile?.occupation_shade_id;
  if (id === -1) return "unknown";
  if (id === null || id === undefined) return "unknown";
  return effect.occupation_ids.includes(id) ? "eligible" : "ineligible";
}

export function equipmentStats(selection: Selection, sets = zodiacSets): Record<string, number> {
  const variant = resolveVariant(selection, sets);
  const totals: Record<string, number> = {};
  if (!variant) return totals;
  const add = (id: number, value: number) => {
    const ability = getAbility(id);
    if (ability) totals[ability.key] = (totals[ability.key] ?? 0) + value;
  };
  for (const part of selection.rainbow ? variant.rainbow_parts : variant.parts) {
    // Base item level 1; combat-only effects are shown separately, never flat stats.
    for (const stat of [part.primary_stat, part.secondary_stat]) add(stat.ability_id, stat.value);
  }
  for (const effect of Object.values(selection.rainbow ? variant.rainbow_bonuses : variant.bonuses)) {
    for (const [id, value] of effect) add(id, value);
  }
  return totals;
}
