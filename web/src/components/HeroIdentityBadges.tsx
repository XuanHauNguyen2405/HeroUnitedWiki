import { activeEvidence, combatProfiles, type UpgradeState } from "@/lib/equipment-advisor";
import { rawDomainLabel } from "@/lib/game-attributes";
import ElementBadge from "./ElementBadge";

export default function HeroIdentityBadges({ id, career, race, compact = false, state }: {
  id: string | number; career?: number | null; race?: number | null; compact?: boolean; state?: UpgradeState;
}) {
  const profile = combatProfiles[String(id)];
  const evidence = state ? activeEvidence(profile, state) : profile?.evidence.filter(e => e.slot > 0) ?? [];
  const elements = [...new Set(evidence.flatMap(e => e.element_ids))];
  return <div className="flex flex-wrap items-center gap-2 text-xs" data-hero-identity={String(id)}>
    {!compact && <><span>{rawDomainLabel("career", career)}</span><span>{rawDomainLabel("race", race)}</span></>}
    <span className="text-slate-400">{state ? "Kỹ năng đã mở:" : "Kỹ năng (gồm mốc mở khoá):"}</span>
    {elements.length ? elements.map(e => <ElementBadge key={e} id={e} />)
      : <span className="text-slate-400">Chưa xác minh công thức thuộc tính</span>}
  </div>;
}
