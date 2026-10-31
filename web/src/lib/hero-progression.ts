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
  if (!hero.super_evo?.has_super_evo) return [];
  return hero.super_evo.stages || [];
}

export function getBreakthroughStages<T>(hero: {
  id: string;
  family_forms?: FormProgression[];
  breakthrough_system?: { has_breakthrough: boolean; stages: T[] };
}): T[] {
  if (!hero.breakthrough_system?.has_breakthrough) return [];
  return hero.breakthrough_system.stages || [];
}

export function isSuperEvoUpgrade(stage: { id: string } | undefined): boolean {
  // Cam is the starting card quality, not an upgrade or an extra stat bonus.
  return Boolean(stage && stage.id !== "cam" && stage.id !== "none");
}

export function maxStrengthenAtLevel(level: number, supported: boolean, table: Record<string, { need_level: number }>): number {
  if (!supported) return 0;
  return Math.max(0, ...Object.entries(table).filter(([, stage]) => stage.need_level <= level).map(([id]) => Number(id)));
}

export interface SkillEvolutionStage {
  stage: number;
  unlock_evo: number;
  skill_id: string;
  name?: string;
  effect?: number | null;
  effect_lvchange?: number | null;
  max_lv?: number | null;
  cd?: number | null;
  pre_cd?: number | null;
  rate?: number | null;
  quality?: number | null;
  description?: string;
}

export interface EvolvableSkill {
  slot: number;
  skill_id?: string;
  name?: string;
  description?: string;
  icon?: string | null;
  cd?: number | null;
  pre_cd?: number | null;
  rate?: number | null;
  effect?: number | null;
  effect_lvchange?: number | null;
  max_lv?: number | null;
  quality?: number | null;
  has_definition?: boolean;
  evolution_chain?: SkillEvolutionStage[];
}

export function resolveSkillAtEvolution(
  skill: EvolvableSkill,
  strengthenLevel: number = 0,
  skillLevel: number = 1
) {
  const chain = skill.evolution_chain || [];
  const baseStage = chain[0];
  let activeStage: SkillEvolutionStage | null = null;
  let nextStage: SkillEvolutionStage | null = null;

  if (chain.length > 0) {
    for (const st of chain) {
      if (st.unlock_evo <= strengthenLevel) {
        activeStage = st;
      } else if (!nextStage) {
        nextStage = st;
      }
    }
    if (!activeStage) {
      activeStage = chain[0];
    }
  }

  const unlockEvoRequired = baseStage?.unlock_evo ?? 0;
  const isUnlockedByEvo = strengthenLevel >= unlockEvoRequired;
  const currentStageNum = activeStage?.stage ?? 1;
  const maxStageNum = chain.length > 0 ? chain[chain.length - 1].stage : 1;

  const baseEffect = activeStage?.effect ?? skill.effect ?? null;
  const baseStageEffect = baseStage?.effect ?? skill.effect ?? null;
  const lvChange = activeStage?.effect_lvchange ?? skill.effect_lvchange ?? 0;
  const maxLv = Math.max(1, activeStage?.max_lv ?? skill.max_lv ?? 1);
  const clampedSkillLv = Math.min(maxLv, Math.max(1, Math.round(skillLevel || 1)));

  const effectiveEffect =
    baseEffect != null
      ? Math.round((baseEffect + (clampedSkillLv - 1) * (lvChange || 0)) * 10) / 10
      : null;

  const maxLvEffect =
    baseEffect != null && maxLv > 1 && lvChange
      ? Math.round((baseEffect + (maxLv - 1) * lvChange) * 10) / 10
      : effectiveEffect;

  const rawDesc = activeStage?.description ?? skill.description ?? "Nguồn chưa có mô tả kỹ năng.";
  const formattedDescription =
    effectiveEffect != null
      ? rawDesc.replace(/effect%/g, `${effectiveEffect}%`).replace(/\beffect\b/g, `${effectiveEffect}`)
      : rawDesc;

  return {
    slot: skill.slot,
    skill_id: activeStage?.skill_id ?? skill.skill_id,
    base_skill_id: skill.skill_id,
    name: activeStage?.name ?? skill.name,
    base_name: baseStage?.name ?? skill.name,
    icon: skill.icon,
    cd: activeStage?.cd ?? skill.cd,
    base_cd: baseStage?.cd ?? skill.cd,
    pre_cd: activeStage?.pre_cd ?? skill.pre_cd,
    rate: activeStage?.rate ?? skill.rate,
    quality: activeStage?.quality ?? skill.quality,
    base_quality: baseStage?.quality ?? skill.quality,
    has_definition: skill.has_definition,
    stage: currentStageNum,
    max_stage: maxStageNum,
    unlock_evo: activeStage?.unlock_evo ?? 0,
    initial_unlock_evo: unlockEvoRequired,
    is_unlocked_by_evo: isUnlockedByEvo,
    next_stage: nextStage,
    base_effect: baseEffect,
    stage1_effect: baseStageEffect,
    evo_effect_gain:
      baseEffect != null && baseStageEffect != null ? Math.round((baseEffect - baseStageEffect) * 10) / 10 : 0,
    effect: effectiveEffect,
    effect_lvchange: lvChange,
    skill_level: clampedSkillLv,
    max_lv: maxLv,
    max_lv_effect: maxLvEffect,
    description: formattedDescription,
    raw_description: rawDesc,
    evolution_chain: chain,
  };
}
