import Link from "next/link";
import ImageWithFallback from "./ImageWithFallback";
import HeroIdentityBadges from "./HeroIdentityBadges";
import { formatNumber, getQualityConfig } from "@/lib/utils";
import type { HeroSummary } from "@/lib/data";

export default function HeroSummaryCard({ hero }: { hero: HeroSummary }) {
  return <Link href={`/heroes/${hero.id}`} className="min-w-0 rounded-2xl border border-slate-700 bg-slate-900/60 p-4 space-y-4 hover:border-sky-400 transition-colors">
    <div className="flex items-start gap-3">
      <ImageWithFallback src={hero.avatar} alt="" className="h-16 w-16 shrink-0 rounded-xl object-contain bg-slate-950" fallbackIcon="👤" />
      <div className="min-w-0 space-y-1">
        <p className="text-xs text-slate-400">#{hero.id} · <span className={getQualityConfig(hero.quality).textClass}>Phẩm {hero.quality}</span></p>
        <h3 className="font-bold text-white break-words">{hero.name}</h3>
        <p className="text-xs text-amber-200">{hero.star} / {hero.star_max} sao</p>
      </div>
    </div>
    <HeroIdentityBadges id={hero.id} career={hero.career} race={hero.race} />
    <dl className="grid grid-cols-3 gap-2 rounded-xl bg-slate-950 p-3 text-xs">
      {[["HP", hero.hp], ["Vật công", hero.patk], ["Tốc độ", hero.speed]].map(([label, value]) => <div key={String(label)}><dt className="text-slate-400">{label}</dt><dd className="text-slate-200 mt-1">{formatNumber(Number(value))}</dd></div>)}
    </dl>
    <p className="text-xs font-semibold text-sky-300">Xem tướng & các dạng →</p>
  </Link>;
}
