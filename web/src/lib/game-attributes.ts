import raw from "../data/game_definitions.json";

export interface ElementDefinition {
  id: string; name: string; symbol: string; color: string;
  attack_id: number; defense_id: number; meaning: string; source: string;
}
export interface AbilityDefinition { id: number; name: string; key: string; type_value: number }
export const elements: Record<string, ElementDefinition> = raw.elements;
export const abilities: Record<string, AbilityDefinition> = raw.abilities;
export const slots: Record<string, string> = raw.slots;

export function getElement(id: unknown): ElementDefinition | null {
  return typeof id === "string" && Object.hasOwn(elements, id) ? elements[id] : null;
}
export function getAbility(id: unknown): AbilityDefinition | null {
  return (typeof id === "number" || typeof id === "string") && Object.hasOwn(abilities, String(id))
    ? abilities[String(id)] : null;
}
export function abilityLabel(id: unknown): string {
  return getAbility(id)?.name ?? `Chưa xác minh chỉ số ${id ?? "(thiếu)"}`;
}
export function rawDomainLabel(domain: "career" | "race" | "occupation", id: unknown): string {
  const label = { career: "Nghề", race: "Tộc", occupation: "Nhóm nghề" }[domain];
  return id === null || id === undefined ? `${label}: chưa có dữ liệu` : `${label} ${String(id)}`;
}
