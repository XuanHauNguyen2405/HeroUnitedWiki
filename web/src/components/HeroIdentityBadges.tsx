import { activeEvidence, combatProfiles, type UpgradeState } from "@/lib/equipment-advisor";
import { rawDomainLabel } from "@/lib/game-attributes";
import ElementBadge from "./ElementBadge";

export default function HeroIdentityBadges({
  id,
  career,
  race,
  compact = false,
  state,
}: {
  id: string | number;
  career?: number | null;
  race?: number | null;
  compact?: boolean;
  state?: UpgradeState;
}) {
  const profile = combatProfiles[String(id)];
  const evidence = state
    ? activeEvidence(profile, state)
    : profile?.evidence.filter((e) => e.slot > 0) ?? [];
  const elements = [...new Set(evidence.flatMap((e) => e.element_ids))];

  return (
    <div
      className="flex flex-wrap items-center gap-1.5 text-xs"
      data-hero-identity={String(id)}
    >
      {!compact && (
        <>
          <span className="rounded-md border border-slate-700/80 bg-slate-900/90 px-2 py-0.5 text-[11px] font-medium text-slate-300">
            {rawDomainLabel("career", career)}
          </span>
          <span className="rounded-md border border-slate-700/80 bg-slate-900/90 px-2 py-0.5 text-[11px] font-medium text-slate-300">
            {rawDomainLabel("race", race)}
          </span>
        </>
      )}
      <span className="text-[11px] text-slate-400 ml-0.5">
        {state ? "Kỹ năng đã mở:" : "Hệ kỹ năng:"}
      </span>
      {elements.length ? (
        elements.map((e) => <ElementBadge key={e} id={e} />)
      ) : (
        <span className="text-[11px] text-slate-500 italic">
          Chưa xác minh công thức thuộc tính
        </span>
      )}
    </div>
  );
}
