"use client";

import { useState } from "react";
import Link from "next/link";
import ElementBadge from "./ElementBadge";
import { EquipmentItemCard, SetBonuses } from "./EquipmentDetails";
import { combatProfiles, emptySelection, recommendations, resolveVariant, zodiacSets, type Selection, type UpgradeState } from "@/lib/equipment-advisor";
import { formatNumber } from "@/lib/utils";
import { getElement } from "@/lib/game-attributes";

export default function EquipmentAdvisor({ heroId, heroName, state, selection, onSelect }: {
  heroId: string; heroName: string; state: UpgradeState; selection: Selection; onSelect: (value: Selection) => void;
}) {
  const [previewChoice, setPreviewChoice] = useState<Selection | null>(null);
  const [showAll, setShowAll] = useState(false);
  const candidates = recommendations(heroId, state, selection.rainbow);
  const preview = previewChoice ?? candidates[0]?.selection ?? { setId: "hoi", elementId: "wind", rainbow: false };
  const variant = resolveVariant(preview);
  const set = zodiacSets.find(s => s.id === preview.setId);
  const equipped = resolveVariant(selection);
  const isEquipped = equipped !== null && selection.setId === preview.setId && selection.elementId === preview.elementId && selection.rainbow === preview.rainbow;
  const profile = combatProfiles[heroId];

  return <section id="equipment" className="hero-section space-y-5" aria-labelledby="equipment-heading">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div><h2 id="equipment-heading" className="text-xl font-bold text-white">6. Trang bị & gợi ý cho {heroName}</h2>
        <p className="mt-2 text-sm text-slate-300">Đối chiếu công thức kỹ năng của dạng đang chọn với công nguyên tố của bộ. Thứ tự dựa trên lượng công nguyên tố cộng trực tiếp; các bộ bằng điểm là lựa chọn tương đương theo tiêu chí này.</p></div>
      {equipped && <button className="hero-control" onClick={() => onSelect({ ...emptySelection, rainbow: selection.rainbow })}>Bỏ trang bị</button>}
    </div>
    <div className="rounded-xl border border-sky-800 bg-sky-950/30 p-4 text-sm space-y-2" role="status" data-equipped-element={equipped?.element_id ?? "none"}>
      <p>Đang trang bị: {equipped ? <><b>{zodiacSets.find(s => s.id === selection.setId)?.name}</b> <ElementBadge id={equipped.element_id} /> · {selection.rainbow ? "Cầu Vồng" : "Thường"}</> : "Chưa chọn bộ"}</p>
      <p className="text-slate-300">Mốc hiện tại: cấp {state.level}, CS{state.rebirth}, siêu tiến hoá {state.superEvo}, đột phá {state.breakthrough}. Các kỹ năng chưa mở không dùng làm lý do gợi ý.</p>
    </div>
    <div className="space-y-3" data-recommendations>
      <h3 className="font-semibold text-sky-200">Các lựa chọn có bằng chứng</h3>
      {!candidates.length && <p className="rounded-xl border border-slate-700 p-4 text-slate-300">Chưa đủ công thức thuộc tính đã xác minh ở mốc này để xếp hạng trang bị. Bạn vẫn có thể tra cứu và thử từng bộ bên dưới.</p>}
      <div className="grid gap-3 md:grid-cols-2">
        {(showAll ? candidates : candidates.slice(0, 4)).map(rec => <article key={`${rec.selection.setId}-${rec.selection.elementId}`} className="rounded-xl border border-slate-700 bg-slate-950/50 p-4 space-y-3">
          <div className="flex flex-wrap items-center gap-2"><h4 className="font-bold text-white">{rec.name}</h4><ElementBadge id={rec.selection.elementId} /></div>
          <p className="text-sm text-emerald-200">+{formatNumber(rec.amount)} {getElement(rec.selection.elementId)?.meaning} khi đủ 4 món {rec.selection.rainbow ? "Cầu Vồng" : "thường"}.</p>
          <p className="text-sm text-slate-300">Phù hợp công thức của <b>{rec.evidence.map(e => e.name).join(", ")}</b>.</p>
          {rec.manualNote && <p className="text-xs text-amber-200">{rec.manualNote}</p>}
          <details className="text-sm text-slate-300"><summary className="cursor-pointer min-h-10">Công thức, điều kiện & nguồn đối chiếu</summary>
            {rec.evidence.map(e => <div key={e.source} className="mt-3 border-t border-slate-700 pt-2 space-y-2"><p>{e.description}</p><p className="text-xs text-slate-400">{e.source}</p>
              {e.skill_id && <Link className="text-sky-300 underline" href={`/skills/${e.skill_id}`}>Xem {e.name}</Link>}</div>)}
            <p className="mt-2">Là gợi ý theo chỉ số đã công bố, chưa phải kết quả so sát thương thực chiến. Hệ khác vẫn có thể dùng khi kỹ năng chuyển đổi công; kiểm tra mô tả phía trên.</p>
          </details>
          <button className="hero-control w-full" onClick={() => { onSelect(rec.selection); setPreviewChoice(rec.selection); }}>Trang bị {rec.name} · {getElement(rec.selection.elementId)?.name}</button>
        </article>)}
      </div>
      {candidates.length > 4 && <button className="hero-control" onClick={() => setShowAll(!showAll)}>{showAll ? "Thu gọn" : `Xem đủ ${candidates.length} lựa chọn`}</button>}
    </div>
    <div className="rounded-2xl border border-slate-700 bg-slate-900/50 p-4 sm:p-5 space-y-5" data-equipment-preview>
      <div className="grid gap-4 sm:grid-cols-2">
        <label className="space-y-2 text-sm"><span className="block text-slate-300">Bộ trang bị đang xem</span>
          <select aria-label="Bộ trang bị đang xem" className="hero-control w-full" value={preview.setId} onChange={e => setPreviewChoice({ ...preview, setId: e.target.value })}>
            {zodiacSets.map(s => <option key={s.id} value={s.id}>{s.icon} {s.name}</option>)}
          </select>
        </label>
        <label className="flex items-center gap-3 text-sm"><input aria-label="Xem mốc Cầu Vồng" type="checkbox" checked={preview.rainbow} onChange={e => setPreviewChoice({ ...preview, rainbow: e.target.checked })} /> Mốc Cầu Vồng (Phẩm 8)</label>
      </div>
      <div className="grid grid-cols-2 sm:grid-cols-4 gap-2" aria-label="Biến thể thuộc tính">
        {set?.variants.map(v => <button key={v.element_id} aria-pressed={v.element_id === preview.elementId} className="hero-control" onClick={() => setPreviewChoice({ ...preview, elementId: v.element_id })}><ElementBadge id={v.element_id} /></button>)}
      </div>
      {!variant ? <p>Biến thể chưa xác minh. Chọn một thuộc tính có trong bộ.</p> : <>
        <div className="flex flex-wrap items-center justify-between gap-3"><h3 className="font-bold text-white">{set?.name} <ElementBadge id={variant.element_id} /></h3>
          <button className="hero-control" aria-pressed={isEquipped} onClick={() => onSelect(preview)}>{isEquipped ? "✓ Đang trang bị bộ này" : "Trang bị bộ đang xem"}</button></div>
        <p className="text-xs text-slate-400">Chỉ số món ở cấp đồ 1, chưa tinh luyện. Đủ 2/3/4 món kích hoạt các mốc cộng dồn. Điều kiện nghề bên dưới áp dụng cho hiệu ứng chiến đấu, không mặc định cấm mang đồ khác hệ.</p>
        <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">{(preview.rainbow ? variant.rainbow_parts : variant.parts).map(p => <EquipmentItemCard key={p.id} part={p} profile={profile} />)}</div>
        <SetBonuses bonuses={preview.rainbow ? variant.rainbow_bonuses : variant.bonuses} />
        <p className="text-xs text-slate-400 break-words">Nguồn: {variant.source}</p>
      </>}
    </div>
  </section>;
}
