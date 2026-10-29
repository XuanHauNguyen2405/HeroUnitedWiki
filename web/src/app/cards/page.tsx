import Link from "next/link";
import Breadcrumbs from "@/components/Breadcrumbs";
import CardsPreview, { type CardPreviewHero } from "@/components/CardsPreview";
import { getHeroesCatalog, getHeroesDetails } from "@/lib/data";

export default function CardsPage() {
  const details = getHeroesDetails();
  const heroes: CardPreviewHero[] = getHeroesCatalog().map(summary => {
    const hero = details[summary.id];
    return {
      id: summary.id, name: summary.name, quality: summary.quality,
      avatar: hero.avatar, card_image: hero.card_image, standing_image: hero.standing_image,
      full_image: hero.full_image, animation: hero.animation,
      occupation: hero.occupation_type,
      levelLimit: hero.level_max > 0 ? hero.level_max : 255,
      supportsStrengthening: hero.evolution?.is_evo === 1,
      rebirthStages: hero.chuyen_sinh?.stages?.map((s: {stage: number; title: string}) => ({stage:s.stage,title:s.title})) ?? [],
      superStages: hero.super_evo?.has_super_evo ? hero.super_evo.stages.map((s: {id: string; name: string}) => ({id:s.id,name:s.name})) : [],
      breakthroughSteps: hero.breakthrough_system?.has_breakthrough ? hero.breakthrough_system.stages.map((s: {step:number}) => s.step) : [],
    };
  });
  return <div className="space-y-6">
    <Breadcrumbs items={[{label:"Thẻ tướng"}]} />
    <div className="space-y-2"><h1 className="text-2xl font-bold text-white">Thẻ tướng</h1>
      <p className="text-sm text-slate-300">Xem ảnh thẻ và các mốc được cấu hình riêng cho từng dạng.</p>
      <Link href="/heroes/gallery" className="inline-flex text-sm text-sky-300 underline">Đối chiếu ảnh đứng toàn thân và ảnh thẻ</Link>
    </div>
    <CardsPreview heroes={heroes} />
  </div>;
}
