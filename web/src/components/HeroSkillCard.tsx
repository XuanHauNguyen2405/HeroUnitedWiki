import Link from "next/link";
import ImageWithFallback from "./ImageWithFallback";
import { resolveSkillAtEvolution, type EvolvableSkill } from "@/lib/hero-progression";

export type HeroSkill = EvolvableSkill;

const SKILL_QUALITY_LABELS: Record<number, { label: string; className: string }> = {
  1: { label: "Lục", className: "border-emerald-500/40 bg-emerald-950/60 text-emerald-300" },
  2: { label: "Lam", className: "border-sky-500/40 bg-sky-950/60 text-sky-300" },
  3: { label: "Tím", className: "border-purple-500/40 bg-purple-950/60 text-purple-300" },
  4: { label: "Cam", className: "border-orange-500/40 bg-orange-950/60 text-orange-300" },
  5: { label: "Đỏ", className: "border-red-500/40 bg-red-950/60 text-red-300" },
  6: { label: "Vàng", className: "border-amber-400/50 bg-amber-950/60 text-amber-300" },
  7: { label: "Ám Kim", className: "border-yellow-300/60 bg-gradient-to-r from-amber-950/80 to-red-950/80 text-yellow-200" },
};

export default function HeroSkillCard({
  skill,
  superEvo,
  required,
  strengthenLevel = 0,
  skillLevel = 1,
}: {
  skill: HeroSkill;
  superEvo: number;
  required?: number | null;
  strengthenLevel?: number;
  skillLevel?: number;
}) {
  const hasSuperEvo = required != null;
  const lockedBySuperEvo = required != null && superEvo < required;
  const missing = skill.has_definition === false;

  const resolved = resolveSkillAtEvolution(skill, strengthenLevel, skillLevel);
  const hasEvoChain = resolved.max_stage > 1;
  const isEvoUpgraded = resolved.stage > 1;
  const qualityInfo = resolved.quality != null ? SKILL_QUALITY_LABELS[resolved.quality] : null;

  return (
    <article
      className={`min-w-0 rounded-2xl border p-4 space-y-3 transition-all ${
        isEvoUpgraded
          ? "border-amber-500/50 bg-gradient-to-br from-slate-950 via-slate-950/90 to-amber-950/20 shadow-lg shadow-amber-950/20"
          : "border-slate-700 bg-slate-950/60"
      }`}
      data-skill-id={resolved.skill_id}
      data-skill-stage={resolved.stage}
    >
      <div className="flex items-start justify-between gap-3">
        <div className="flex items-start gap-3 min-w-0">
          <ImageWithFallback
            src={resolved.icon}
            alt=""
            className="h-12 w-12 shrink-0 rounded-xl object-contain bg-slate-900 border border-slate-800 p-0.5"
            fallbackIcon="⚡"
          />
          <div className="min-w-0">
            <div className="flex flex-wrap items-center gap-1.5">
              <p className="text-xs text-slate-400">Ô kỹ năng {resolved.slot}</p>
              {qualityInfo && (
                <span className={`text-[10px] font-bold px-2 py-0.2 rounded-full border ${qualityInfo.className}`}>
                  Phẩm {qualityInfo.label}
                </span>
              )}
              {hasEvoChain && (
                <span
                  className={`text-[10px] font-mono font-bold px-2 py-0.2 rounded-full border ${
                    isEvoUpgraded
                      ? "border-amber-400/60 bg-amber-500/15 text-amber-300"
                      : "border-slate-700 bg-slate-900 text-slate-300"
                  }`}
                >
                  Cấp KN: Giai {resolved.stage}/{resolved.max_stage}
                </span>
              )}
              {resolved.max_lv > 1 && (
                <span className="text-[10px] font-mono font-semibold px-2 py-0.2 rounded-full border border-sky-500/30 bg-sky-950/50 text-sky-300">
                  Lv.{resolved.skill_level}/{resolved.max_lv}
                </span>
              )}
            </div>
            <h3 className="font-bold text-white break-words mt-0.5">
              {resolved.name ?? `Kỹ năng #${resolved.skill_id}`}
            </h3>
          </div>
        </div>
      </div>

      {missing ? (
        <p className="text-sm text-amber-200">Chưa có định nghĩa kỹ năng trong dữ liệu game.</p>
      ) : (
        <>
          {hasSuperEvo && required != null && required > 0 && (
            <p className={lockedBySuperEvo ? "text-xs font-semibold text-amber-200" : "text-xs font-semibold text-emerald-300"}>
              {lockedBySuperEvo ? "🔒 Chưa mở" : "✓ Đã mở"} · Yêu cầu siêu tiến hoá{" "}
              {required === 3 ? "Đỏ" : required === 6 ? "Vàng" : `mốc ${required}`}
            </p>
          )}

          {hasEvoChain && (
            <div className="rounded-xl border border-slate-800/90 bg-slate-900/70 px-3 py-2 text-xs space-y-1">
              <div className="flex flex-wrap items-center justify-between gap-2">
                <span className="text-slate-300 font-medium">
                  {!resolved.is_unlocked_by_evo ? (
                    <span className="text-amber-300">
                      🔒 Mở khóa tại Tiến Hóa <b>+{resolved.initial_unlock_evo}</b> (Đang ở +{strengthenLevel})
                    </span>
                  ) : resolved.stage === resolved.max_stage ? (
                    <span className="text-amber-300 font-semibold">
                      ⚡ Đã đạt tối đa <b>Giai {resolved.stage}/{resolved.max_stage}</b> (Mốc Tiến Hóa +{resolved.unlock_evo})
                    </span>
                  ) : (
                    <span>
                      Đang kích hoạt: <b className="text-amber-300">Giai {resolved.stage}/{resolved.max_stage}</b>{" "}
                      {resolved.unlock_evo > 0 ? `(từ +${resolved.unlock_evo})` : "(Mặc định +0)"}
                    </span>
                  )}
                </span>
                {resolved.next_stage && (
                  <span className="text-[11px] font-mono text-sky-300">
                    Tiếp theo: Giai {resolved.next_stage.stage} tại +{resolved.next_stage.unlock_evo}
                  </span>
                )}
              </div>

              {resolved.effect != null && (
                <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-[11px] text-slate-300 pt-0.5 border-t border-slate-800/60">
                  <span>
                    Hệ số sát thương: <b className="font-mono text-amber-300 text-xs">{resolved.effect}%</b>
                  </span>
                  {resolved.evo_effect_gain > 0 && (
                    <span className="text-emerald-300 font-mono">
                      (Giai 1: {resolved.stage1_effect}% ➔ +{resolved.evo_effect_gain}% nhờ Tiến Hóa)
                    </span>
                  )}
                  {resolved.max_lv > 1 && (resolved.effect_lvchange ?? 0) > 0 && (
                    <span className="text-slate-400 font-mono">
                      • Tăng +{resolved.effect_lvchange}%/Lv (Lv.{resolved.max_lv}: {resolved.max_lv_effect}%)
                    </span>
                  )}
                </div>
              )}
            </div>
          )}

          {!hasEvoChain && resolved.effect != null && resolved.max_lv > 1 && (resolved.effect_lvchange ?? 0) > 0 && (
            <div className="rounded-xl border border-slate-800/90 bg-slate-900/70 px-3 py-1.5 text-[11px] text-slate-300 flex flex-wrap items-center gap-x-3 gap-y-1">
              <span>
                Hệ số sát thương: <b className="font-mono text-amber-300">{resolved.effect}%</b>
              </span>
              <span className="text-slate-400 font-mono">
                • Tăng +{resolved.effect_lvchange}%/Lv (Lv.{resolved.max_lv}: {resolved.max_lv_effect}%)
              </span>
            </div>
          )}

          <div className="flex flex-wrap gap-3 text-xs text-slate-300">
            {resolved.cd != null && (
              <span>
                Hồi chiêu: <b className="text-white font-mono">{resolved.cd}</b> lượt
                {resolved.base_cd != null && resolved.cd < resolved.base_cd && (
                  <span className="text-emerald-400 font-mono ml-1">(Gốc: {resolved.base_cd})</span>
                )}
              </span>
            )}
            {resolved.pre_cd != null && resolved.pre_cd > 0 && (
              <span>Khởi động: {resolved.pre_cd} lượt</span>
            )}
            {resolved.rate != null && <span>Tỷ lệ: {resolved.rate}%</span>}
          </div>

          <p className="text-sm text-slate-200 leading-relaxed whitespace-pre-line">
            {resolved.description}
          </p>

          {resolved.base_skill_id && (
            <Link className="hero-control inline-flex items-center text-xs text-sky-300 hover:text-sky-200" href={`/skills/${resolved.base_skill_id}`}>
              Xem chi tiết kỹ năng →
            </Link>
          )}
        </>
      )}
    </article>
  );
}
