import Link from "next/link";
import ImageWithFallback from "./ImageWithFallback";

export interface HeroSkill {
  slot: number; skill_id?: string; name?: string; description?: string; icon?: string | null;
  cd?: number | null; rate?: number | null; effect?: number | null; has_definition?: boolean;
}
export default function HeroSkillCard({ skill, superEvo, required }: { skill: HeroSkill; superEvo: number; required?: number | null }) {
  const hasSuperEvo = required != null;
  const locked = required != null && superEvo < required;
  const missing = skill.has_definition === false;
  return <article className="min-w-0 rounded-2xl border border-slate-700 bg-slate-950/60 p-4 space-y-3" data-skill-id={skill.skill_id}>
    <div className="flex items-start gap-3">
      <ImageWithFallback src={skill.icon} alt="" className="h-12 w-12 shrink-0 rounded-xl object-contain bg-slate-900" fallbackIcon="⚡" />
      <div className="min-w-0"><p className="text-xs text-slate-400">Ô kỹ năng {skill.slot}</p><h3 className="font-bold text-white break-words">{skill.name ?? `Kỹ năng #${skill.skill_id}`}</h3></div>
    </div>
    {missing ? <p className="text-sm text-amber-200">Chưa có định nghĩa kỹ năng trong dữ liệu game.</p> : <>
      {hasSuperEvo && required != null && required > 0 && <p className={locked ? "text-sm text-amber-200" : "text-sm text-emerald-200"}>{locked ? "Chưa mở" : "Đã mở"} · Yêu cầu siêu tiến hoá {required === 3 ? "Đỏ" : required === 6 ? "Vàng" : `mốc ${required}`}</p>}
      <div className="flex flex-wrap gap-3 text-xs text-slate-300">{skill.cd != null && <span>Hồi chiêu: {skill.cd}</span>}{skill.rate != null && <span>Tỷ lệ: {skill.rate}%</span>}</div>
      <p className="text-sm text-slate-300 leading-relaxed">{skill.effect != null ? skill.description?.replace(/effect%/g, `${skill.effect}%`) : skill.description ?? "Nguồn chưa có mô tả kỹ năng."}</p>
      {skill.skill_id && <Link className="hero-control inline-flex items-center text-sky-200" href={`/skills/${skill.skill_id}`}>Xem chi tiết kỹ năng →</Link>}
    </>}
  </article>;
}
