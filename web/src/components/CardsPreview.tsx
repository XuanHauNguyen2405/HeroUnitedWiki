"use client";

import { useState } from "react";
import Link from "next/link";
import HeroCard, { type HeroCardData } from "./HeroCard";
import HeroSection from "./HeroSection";
import { maxStrengthenAtLevel } from "@/lib/hero-progression";
import strengthenTable from "@/data/character_strengthen.json";

export interface CardPreviewHero extends HeroCardData {
  levelLimit: number; supportsStrengthening: boolean;
  rebirthStages: { stage: number; title: string }[];
  superStages: { id: string; name: string }[];
  breakthroughSteps: number[];
}

function SelectedCard({ hero }: { hero: CardPreviewHero }) {
  const [level, setLevel] = useState(1);
  const [strengthen, setStrengthen] = useState(0);
  const [rebirth, setRebirth] = useState(0);
  const [superIndex, setSuperIndex] = useState(0);
  const [breakthrough, setBreakthrough] = useState(0);
  const maxStrengthen = maxStrengthenAtLevel(level, hero.supportsStrengthening, strengthenTable);
  return <div className="grid gap-6 lg:grid-cols-2">
    <HeroSection className="flex flex-col items-center justify-center gap-4">
      <HeroCard hero={hero} size="md" reserveArtworkSpace level={level} maxLevel={hero.levelLimit}
        enhancementLevel={strengthen} rebirthStage={rebirth} superQualityStage={superIndex}
        breakthroughLevel={breakthrough} showElementBadge={hero.breakthroughSteps.length > 0} />
      <Link className="hero-control text-sky-200" href={`/heroes/${hero.id}`}>Xem chỉ số, kỹ năng & gợi ý trang bị →</Link>
    </HeroSection>
    <HeroSection>
      <h2 className="text-lg font-bold text-white">Mốc của {hero.name}</h2>
      <label className="block space-y-2 text-sm text-slate-300">Cấp độ
        <input className="hero-control block w-full" aria-label="Cấp độ thẻ" type="number" min={1} max={hero.levelLimit} value={level} onChange={e => {
          const next = Math.max(1, Math.min(hero.levelLimit, Number(e.target.value) || 1));
          setLevel(next); setStrengthen(Math.min(strengthen, maxStrengthenAtLevel(next, hero.supportsStrengthening, strengthenTable)));
        }} />
      </label>
      {hero.supportsStrengthening && <label className="block space-y-2 text-sm text-slate-300">Tiến hoá: +{strengthen}
        <input className="block w-full accent-sky-400" aria-label="Tiến hoá thẻ" type="range" min={0} max={maxStrengthen} value={strengthen} onChange={e => setStrengthen(Number(e.target.value))} />
        <span className="block text-xs text-slate-400">Ở cấp hiện tại hỗ trợ tối đa +{maxStrengthen}.</span>
      </label>}
      {hero.rebirthStages.length > 0 && <label className="block space-y-2 text-sm text-slate-300">Chuyển sinh
        <select className="hero-control block w-full" aria-label="Chuyển sinh thẻ" value={rebirth} onChange={e => setRebirth(Number(e.target.value))}>
          <option value={0}>Chưa chuyển sinh</option>{hero.rebirthStages.map(s => <option key={s.stage} value={s.stage}>{s.title}</option>)}
        </select>
      </label>}
      {hero.superStages.length > 0 && <label className="block space-y-2 text-sm text-slate-300">Siêu tiến hoá
        <select className="hero-control block w-full" aria-label="Siêu tiến hoá thẻ" value={superIndex} onChange={e => setSuperIndex(Number(e.target.value))}>
          {hero.superStages.map((s, index) => <option key={s.id} value={index}>{s.name}</option>)}
        </select>
      </label>}
      {hero.breakthroughSteps.length > 0 && <label className="block space-y-2 text-sm text-slate-300">Đột phá
        <select className="hero-control block w-full" aria-label="Đột phá thẻ" value={breakthrough} onChange={e => setBreakthrough(Number(e.target.value))}>
          <option value={0}>Chưa đột phá</option>{hero.breakthroughSteps.map(step => <option key={step} value={step}>Cấp {step}</option>)}
        </select>
      </label>}
      <p className="text-sm text-slate-400">Chọn dạng khác sẽ đặt lại các mốc. Ảnh thẻ và ảnh đứng được quản lý riêng; xem chi tiết tướng để tra điều kiện, nguyên liệu và trang bị.</p>
    </HeroSection>
  </div>;
}

export default function CardsPreview({ heroes }: { heroes: CardPreviewHero[] }) {
  const [heroId, setHeroId] = useState("43900");
  const hero = heroes.find(h => String(h.id) === heroId);
  return <div className="space-y-6">
    <label className="block space-y-2 text-sm text-slate-300">Tướng / dạng đang xem
      <select className="hero-control block w-full" aria-label="Tướng trên thẻ" value={heroId} onChange={e => setHeroId(e.target.value)}>
        {heroes.map(h => <option key={h.id} value={h.id}>{h.name} · #{h.id}</option>)}
      </select>
    </label>
    {hero ? <SelectedCard key={hero.id} hero={hero} /> : <p>Chưa có dữ liệu dạng này.</p>}
  </div>;
}
