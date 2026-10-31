import Link from "next/link";
import ImageWithFallback from "./ImageWithFallback";
import HeroIdentityBadges from "./HeroIdentityBadges";
import { formatNumber, getQualityConfig } from "@/lib/utils";
import type { HeroSummary } from "@/lib/data";

export default function HeroSummaryCard({ hero }: { hero: HeroSummary }) {
  const qConfig = getQualityConfig(hero.quality);

  return (
    <Link
      href={`/heroes/${hero.id}`}
      className="group min-w-0 flex flex-col justify-between rounded-2xl border border-slate-800/90 bg-slate-900/50 p-4 space-y-3.5 hover:-translate-y-0.5 hover:border-indigo-500/50 hover:bg-slate-900/90 hover:shadow-xl hover:shadow-indigo-950/20 transition-all duration-200"
    >
      <div className="space-y-3">
        <div className="flex items-start gap-3.5">
          <div className="relative h-16 w-16 shrink-0 rounded-xl overflow-hidden border border-slate-700/80 bg-slate-950 p-1 group-hover:border-indigo-500/50 transition-colors">
            <ImageWithFallback
              src={hero.avatar}
              alt={hero.name}
              className="h-full w-full object-contain group-hover:scale-105 transition-transform duration-200"
              fallbackIcon="👤"
            />
          </div>

          <div className="min-w-0 flex-1 space-y-1">
            <div className="flex flex-wrap items-center gap-1.5 text-[11px]">
              <span className="font-mono text-slate-400 bg-slate-950/90 border border-slate-800 px-1.5 py-0.5 rounded">
                #{hero.id}
              </span>
              <span
                className={`px-1.5 py-0.5 rounded border text-[10px] font-semibold ${qConfig.badgeClass}`}
              >
                Phẩm {hero.quality}
              </span>
            </div>
            <h3 className="font-bold text-white text-sm sm:text-base leading-snug group-hover:text-indigo-300 transition-colors break-words">
              {hero.name}
            </h3>
            <p className="text-[11px] font-medium text-amber-300/90 flex items-center gap-1">
              <span>★</span> {hero.star} / {hero.star_max} sao
            </p>
          </div>
        </div>

        <HeroIdentityBadges id={hero.id} career={hero.career} race={hero.race} />
      </div>

      <div className="space-y-3 pt-1">
        <dl className="grid grid-cols-3 gap-1.5 rounded-xl border border-slate-800/80 bg-slate-950/80 p-2.5 text-xs">
          <div className="px-1">
            <dt className="text-[10px] text-slate-400">HP</dt>
            <dd className="font-mono font-bold text-rose-300 mt-0.5 truncate">
              {formatNumber(Number(hero.hp))}
            </dd>
          </div>
          <div className="px-1 border-x border-slate-800/80">
            <dt className="text-[10px] text-slate-400">Vật công</dt>
            <dd className="font-mono font-bold text-amber-300 mt-0.5 truncate">
              {formatNumber(Number(hero.patk))}
            </dd>
          </div>
          <div className="px-1">
            <dt className="text-[10px] text-slate-400">Tốc độ</dt>
            <dd className="font-mono font-bold text-emerald-300 mt-0.5 truncate">
              {formatNumber(Number(hero.speed))}
            </dd>
          </div>
        </dl>

        <div className="flex items-center justify-between text-xs font-semibold text-indigo-400 group-hover:text-indigo-300 pt-0.5">
          <span>Xem hồ sơ & mô phỏng</span>
          <span className="group-hover:translate-x-1 transition-transform">→</span>
        </div>
      </div>
    </Link>
  );
}
