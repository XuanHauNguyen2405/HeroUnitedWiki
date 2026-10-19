/**
 * Resolve progression for the exact form, not another member of its family.
 * Some detail records contain a copied nine-stage table even when the same
 * form's family entry explicitly says it has no super-evolution data.
 * Keep that disagreement out of the simulator without changing source JSON.
 */
interface FormProgression {
  id: string;
  has_super_evo?: boolean;
  breakthrough_count?: number;
}

interface ProgressionHero<T> {
  id: string;
  family_forms?: FormProgression[];
  super_evo?: { has_super_evo: boolean; stages: T[] };
}

export function getSuperEvoStages<T>(hero: ProgressionHero<T>): T[] {
  const form = hero.family_forms?.find((item) => String(item.id) === String(hero.id));
  if (form?.has_super_evo === false || !hero.super_evo?.has_super_evo) return [];
  return hero.super_evo.stages;
}

export function getBreakthroughStages<T>(hero: {
  id: string;
  family_forms?: FormProgression[];
  breakthrough_system?: { has_breakthrough: boolean; stages: T[] };
}): T[] {
  const form = hero.family_forms?.find((item) => String(item.id) === String(hero.id));
  if (form?.breakthrough_count === 0 || !hero.breakthrough_system?.has_breakthrough) return [];
  return hero.breakthrough_system.stages;
}

export function isSuperEvoUpgrade(stage: { id: string } | undefined): boolean {
  // Cam is the starting card quality, not an upgrade or an extra stat bonus.
  return Boolean(stage && stage.id !== "cam" && stage.id !== "none");
}
