import Link from "next/link";
import ElementBadge from "./ElementBadge";
import ImageWithFallback from "./ImageWithFallback";
import { abilityLabel, slots } from "@/lib/game-attributes";
import { formatNumber } from "@/lib/utils";
import { effectEligibility, type Bonuses, type CombatProfile, type EquipmentPart, type Stat } from "@/lib/equipment-advisor";

export function EquipmentStatLine({ stat }: { stat: Stat | null | undefined }) {
  if (!stat) return <span>Chưa có chỉ số</span>;
  return <span>{abilityLabel(stat.ability_id)} +{formatNumber(stat.value)} <span className="text-slate-400">(+{formatNumber(stat.level_add)}/cấp đồ)</span></span>;
}

export function SetBonuses({ bonuses }: { bonuses: Bonuses | undefined }) {
  return <dl className="space-y-2 text-sm" data-set-bonuses>
    {[2, 3, 4].map(n => <div key={n} className="rounded-xl border border-slate-700 bg-slate-950/50 p-3">
      <dt className="mb-1 font-semibold text-sky-200">Đủ {n} món · cộng dồn</dt>
      <dd>{bonuses?.[`${n}_piece`]?.length ? bonuses[`${n}_piece`].map(([id, value], index) =>
        <span key={`${id}-${index}`} className="mr-3 inline-block">{abilityLabel(id)} +{formatNumber(value)}</span>
      ) : "Chưa có hiệu ứng trong nguồn"}</dd>
    </div>)}
  </dl>;
}

export function EquipmentItemCard({ part, profile }: { part: EquipmentPart; profile?: CombatProfile }) {
  const effect = part.combat_effect;
  const eligible = profile ? effectEligibility(part, profile) : "unknown";
  return <article className="min-w-0 rounded-2xl border border-slate-700 bg-slate-950/60 p-4 space-y-3" data-equipment-id={part.id}>
    <div className="flex items-start gap-3">
      <ImageWithFallback src={part.icon} alt="" className="h-12 w-12 shrink-0 object-contain" fallbackIcon="🛡️" />
      <div className="min-w-0 space-y-1">
        <p className="text-xs text-slate-400">{slots[String(part.slot)] ?? "Chưa xác minh vị trí"} · Phẩm {part.quality} · #{part.id}</p>
        <Link className="block font-semibold text-white hover:text-sky-300 break-words" href={`/equipment/${part.id}`}>{part.name && part.name !== "#N/A" ? part.name : `Trang bị #${part.id} · nguồn chưa có tên`}</Link>
      </div>
    </div>
    <ElementBadge id={part.element_id} />
    <p className="text-xs text-slate-400">Hệ theo công nguyên tố của bộ, không phải điều kiện bắt buộc cùng hệ tướng.</p>
    <div className="space-y-1 text-sm"><p><EquipmentStatLine stat={part.primary_stat} /></p><p><EquipmentStatLine stat={part.secondary_stat} /></p></div>
    <div className="border-t border-slate-800 pt-3 text-sm space-y-2">
      <p>{effect.description ? effect.description.replace(/effect/g, String(effect.effect)).replace(/occupation/g, `nhóm nghề [${effect.occupation_ids.join(", ")}]`) : "Nguồn chưa có mô tả hiệu ứng chiến đấu."}</p>
      {effect.description && <p className="text-xs text-amber-200">
        {eligible === "eligible" ? "Đạt điều kiện hiệu ứng đã đối chiếu" : eligible === "ineligible" ? "Chưa đạt điều kiện hiệu ứng" : "Cần kiểm tra điều kiện hiệu ứng"}
        {effect.activation_level > 0 && ` · activation_level=${effect.activation_level} (cần xác minh điều kiện)`}
        {effect.occupation_ids.length > 0 && ` · Nhóm nghề: ${effect.occupation_ids.join(", ")}`}
        {effect.activation !== "" && ` · Kích hoạt: ${effect.activation}`}
      </p>}
      <p className="text-xs text-slate-400">Hiệu ứng chiến đấu hiển thị riêng, không cộng vào chỉ số cơ bản.</p>
    </div>
  </article>;
}
