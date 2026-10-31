import ElementBadge from "./ElementBadge";
import ImageWithFallback from "./ImageWithFallback";
import { abilityLabel, slots } from "@/lib/game-attributes";
import { formatNumber } from "@/lib/utils";
import {
  effectEligibility,
  type Bonuses,
  type CombatProfile,
  type EquipmentPart,
  type Stat,
} from "@/lib/equipment-advisor";

export function EquipmentStatLine({
  stat,
}: {
  stat: Stat | null | undefined;
}) {
  if (!stat) return <span className="text-slate-500">Chưa có chỉ số</span>;
  return (
    <span className="text-slate-200">
      <strong className="font-semibold text-white">
        {abilityLabel(stat.ability_id)}
      </strong>{" "}
      <span className="font-mono text-emerald-300 font-semibold">
        +{formatNumber(stat.value)}
      </span>{" "}
      <span className="text-slate-400 text-[11px]">
        (+{formatNumber(stat.level_add)}/cấp đồ)
      </span>
    </span>
  );
}

export function SetBonuses({ bonuses }: { bonuses: Bonuses | undefined }) {
  return (
    <dl className="grid grid-cols-1 sm:grid-cols-3 gap-2.5 text-xs" data-set-bonuses>
      {[2, 3, 4].map((n) => (
        <div
          key={n}
          className="rounded-xl border border-slate-800 bg-slate-950/70 p-3 space-y-1.5"
        >
          <dt className="font-bold text-sky-300 flex items-center justify-between">
            <span>Mốc {n} món</span>
            <span className="text-[10px] font-normal text-slate-400">
              Cộng dồn
            </span>
          </dt>
          <dd className="text-slate-200 flex flex-wrap gap-1.5">
            {bonuses?.[`${n}_piece`]?.length ? (
              bonuses[`${n}_piece`].map(([id, value], index) => (
                <span
                  key={`${id}-${index}`}
                  className="inline-flex items-center gap-1 rounded-md bg-slate-900 border border-slate-800 px-2 py-0.5 text-[11px]"
                >
                  <span className="text-slate-300">{abilityLabel(id)}</span>
                  <strong className="font-mono text-amber-300">
                    +{formatNumber(value)}
                  </strong>
                </span>
              ))
            ) : (
              <span className="text-slate-500 italic">
                Chưa có hiệu ứng trong nguồn
              </span>
            )}
          </dd>
        </div>
      ))}
    </dl>
  );
}

export function EquipmentItemCard({
  part,
  profile,
}: {
  part: EquipmentPart;
  profile?: CombatProfile;
}) {
  const effect = part.combat_effect;
  const eligible = profile ? effectEligibility(part, profile) : "unknown";
  return (
    <article
      className="min-w-0 rounded-2xl border border-slate-800 bg-slate-950/75 p-4 space-y-3 hover:border-slate-700 transition-colors"
      data-equipment-id={part.id}
    >
      <div className="flex items-start gap-3">
        <div className="h-12 w-12 shrink-0 rounded-xl border border-slate-800 bg-slate-900 p-1 flex items-center justify-center">
          <ImageWithFallback
            src={part.icon}
            alt=""
            className="h-full w-full object-contain"
            fallbackIcon="🛡️"
          />
        </div>
        <div className="min-w-0 space-y-1">
          <p className="text-[11px] text-slate-400">
            {slots[String(part.slot)] ?? "Chưa xác minh vị trí"} · Phẩm{" "}
            {part.quality} · <span className="font-mono">#{part.id}</span>
          </p>
          <h4 className="font-bold text-white text-sm break-words">
            {part.name && part.name !== "#N/A"
              ? part.name
              : `Trang bị #${part.id} · nguồn chưa có tên`}
          </h4>
        </div>
      </div>

      <div className="flex items-center justify-between gap-2">
        <ElementBadge id={part.element_id} />
      </div>

      <div className="space-y-1 text-xs rounded-xl bg-slate-900/70 border border-slate-800/80 p-2.5">
        <p>
          <EquipmentStatLine stat={part.primary_stat} />
        </p>
        <p>
          <EquipmentStatLine stat={part.secondary_stat} />
        </p>
      </div>

      <div className="border-t border-slate-800/80 pt-2.5 text-xs space-y-1.5">
        <p className="text-slate-300 leading-relaxed">
          {effect.description
            ? effect.description
                .replace(/effect/g, String(effect.effect))
                .replace(
                  /occupation/g,
                  `nhóm nghề [${effect.occupation_ids.join(", ")}]`
                )
            : "Nguồn chưa có mô tả hiệu ứng chiến đấu."}
        </p>
        {effect.description && (
          <p className="text-[11px] text-amber-200/90">
            {eligible === "eligible"
              ? "✓ Đạt điều kiện hiệu ứng đã đối chiếu"
              : eligible === "ineligible"
              ? "✕ Chưa đạt điều kiện hiệu ứng"
              : "⚠ Cần kiểm tra điều kiện hiệu ứng"}
            {effect.activation_level > 0 &&
              ` · activation_level=${effect.activation_level}`}
            {effect.occupation_ids.length > 0 &&
              ` · Nhóm nghề: ${effect.occupation_ids.join(", ")}`}
            {effect.activation !== "" && ` · Kích hoạt: ${effect.activation}`}
          </p>
        )}
      </div>
    </article>
  );
}
