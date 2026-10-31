"use client";

import { useState } from "react";
import ElementBadge from "./ElementBadge";
import { EquipmentItemCard, SetBonuses } from "./EquipmentDetails";
import {
  combatProfiles,
  emptySelection,
  recommendations,
  resolveVariant,
  zodiacSets,
  type Selection,
  type UpgradeState,
} from "@/lib/equipment-advisor";
import { formatNumber } from "@/lib/utils";
import { getElement } from "@/lib/game-attributes";

export default function EquipmentAdvisor({
  heroId,
  heroName,
  state,
  selection,
  onSelect,
}: {
  heroId: string;
  heroName: string;
  state: UpgradeState;
  selection: Selection;
  onSelect: (value: Selection) => void;
}) {
  const [previewChoice, setPreviewChoice] = useState<Selection | null>(null);
  const [showAll, setShowAll] = useState(false);
  const candidates = recommendations(heroId, state, selection.rainbow);
  const preview =
    previewChoice ??
    candidates[0]?.selection ?? {
      setId: "hoi",
      elementId: "wind",
      rainbow: false,
    };
  const variant = resolveVariant(preview);
  const set = zodiacSets.find((s) => s.id === preview.setId);
  const equipped = resolveVariant(selection);
  const isEquipped =
    equipped !== null &&
    selection.setId === preview.setId &&
    selection.elementId === preview.elementId &&
    selection.rainbow === preview.rainbow;
  const profile = combatProfiles[heroId];

  return (
    <section
      id="equipment"
      className="hero-section rounded-3xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl space-y-6"
      aria-labelledby="equipment-heading"
    >
      <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4 border-b border-slate-800 pb-4">
        <div>
          <div className="flex items-center gap-2">
            <span className="text-2xl">🛡️</span>
            <h2 id="equipment-heading" className="text-xl font-bold text-white">
              6. Bộ Trang Bị Con Giáp &amp; Gợi Ý Cho {heroName}
            </h2>
          </div>
          <p className="mt-1 text-xs text-slate-400">
            Đối chiếu công thức kỹ năng của dạng đang chọn với công nguyên tố của bộ. Thứ tự dựa trên lượng công nguyên tố cộng trực tiếp; các bộ bằng điểm là lựa chọn tương đương theo tiêu chí này.
          </p>
        </div>
        {equipped && (
          <button
            className="rounded-xl border border-rose-500/30 bg-rose-500/10 px-3.5 py-2 text-xs font-semibold text-rose-300 hover:bg-rose-500/20 transition-colors shrink-0"
            onClick={() =>
              onSelect({ ...emptySelection, rainbow: selection.rainbow })
            }
          >
            Bỏ trang bị ✕
          </button>
        )}
      </div>

      <div
        className="rounded-2xl border border-sky-500/30 bg-sky-950/25 p-4 text-xs sm:text-sm space-y-1.5"
        role="status"
        data-equipped-element={equipped?.element_id ?? "none"}
      >
        <p className="flex flex-wrap items-center gap-2 text-slate-200">
          <span className="text-slate-400">Đang trang bị:</span>{" "}
          {equipped ? (
            <>
              <b className="text-white">
                {zodiacSets.find((s) => s.id === selection.setId)?.name}
              </b>{" "}
              <ElementBadge id={equipped.element_id} /> ·{" "}
              <span className="font-semibold text-amber-300">
                {selection.rainbow ? "Cầu Vồng (Phẩm 8)" : "Thường"}
              </span>
            </>
          ) : (
            <span className="text-slate-400 italic">Chưa chọn bộ trang bị</span>
          )}
        </p>
        <p className="text-xs text-slate-400">
          Mốc hiện tại: Cấp <b className="text-slate-200">{state.level}</b> · CS
          <b className="text-slate-200">{state.rebirth}</b> · Siêu tiến hoá bậc{" "}
          <b className="text-slate-200">{state.superEvo}</b> · Đột phá cấp{" "}
          <b className="text-slate-200">{state.breakthrough}</b>. Các kỹ năng chưa mở không dùng làm lý do gợi ý.
        </p>
      </div>

      <div className="space-y-3" data-recommendations>
        <h3 className="text-xs uppercase tracking-wider font-extrabold text-sky-300 flex items-center gap-1.5">
          <span>✨</span> Các Lựa Chọn Phù Hợp Có Bằng Chứng Kỹ Năng
        </h3>
        {!candidates.length && (
          <p className="rounded-2xl border border-slate-800 bg-slate-950/50 p-4 text-xs text-slate-400">
            Chưa đủ công thức thuộc tính đã xác minh ở mốc này để xếp hạng tự động. Bạn vẫn có thể tra cứu và thử từng bộ Con Giáp bên dưới.
          </p>
        )}
        <div className="grid gap-3 md:grid-cols-2">
          {(showAll ? candidates : candidates.slice(0, 4)).map((rec) => (
            <article
              key={`${rec.selection.setId}-${rec.selection.elementId}`}
              className="rounded-2xl border border-slate-800 bg-slate-950/60 p-4 space-y-2.5 flex flex-col justify-between"
            >
              <div className="space-y-2">
                <div className="flex flex-wrap items-center justify-between gap-2">
                  <h4 className="font-bold text-white text-sm">{rec.name}</h4>
                  <ElementBadge id={rec.selection.elementId} />
                </div>
                <p className="text-xs font-semibold text-emerald-300">
                  +{formatNumber(rec.amount)}{" "}
                  {getElement(rec.selection.elementId)?.meaning} khi đủ 4 món{" "}
                  {rec.selection.rainbow ? "Cầu Vồng" : "thường"}.
                </p>
                <p className="text-xs text-slate-300">
                  Phù hợp công thức của:{" "}
                  <b className="text-white">
                    {rec.evidence.map((e) => e.name).join(", ")}
                  </b>
                  .
                </p>
                {rec.manualNote && (
                  <p className="text-xs text-amber-200">{rec.manualNote}</p>
                )}
                <details className="text-xs text-slate-300 rounded-xl border border-slate-800/80 bg-slate-900/50 px-3 py-2">
                  <summary className="cursor-pointer font-semibold text-sky-300 hover:text-sky-200">
                    Công thức, điều kiện &amp; nguồn đối chiếu
                  </summary>
                  {rec.evidence.map((e) => (
                    <div
                      key={e.source}
                      className="mt-2.5 border-t border-slate-800 pt-2 space-y-1.5"
                    >
                      <p className="leading-relaxed text-slate-200">
                        {e.description}
                      </p>
                      <p className="text-[11px] text-slate-400 font-mono">
                        {e.source}
                      </p>
                      {e.skill_id && (
                        <a
                          className="inline-block text-sky-400 hover:text-sky-300 underline text-[11px]"
                          href="#skills"
                        >
                          Xem kỹ năng {e.name} ↓
                        </a>
                      )}
                    </div>
                  ))}
                </details>
              </div>
              <button
                className="w-full rounded-xl border border-indigo-500/40 bg-indigo-500/15 hover:bg-indigo-500/25 px-3.5 py-2 text-xs font-bold text-indigo-200 transition-colors mt-2"
                onClick={() => {
                  onSelect(rec.selection);
                  setPreviewChoice(rec.selection);
                }}
              >
                Trang bị {rec.name} ·{" "}
                {getElement(rec.selection.elementId)?.name}
              </button>
            </article>
          ))}
        </div>
        {candidates.length > 4 && (
          <button
            className="rounded-xl border border-slate-700 bg-slate-800/80 px-4 py-2 text-xs font-semibold text-slate-200 hover:bg-slate-800 transition-colors"
            onClick={() => setShowAll(!showAll)}
          >
            {showAll ? "Thu gọn" : `Xem đủ ${candidates.length} lựa chọn`}
          </button>
        )}
      </div>

      <div
        className="rounded-2xl border border-slate-800 bg-slate-950/60 p-4 sm:p-5 space-y-5"
        data-equipment-preview
      >
        <div className="grid gap-4 sm:grid-cols-2 items-end">
          <label className="space-y-1.5 text-xs">
            <span className="block font-semibold text-slate-300">
              Bộ trang bị đang xem
            </span>
            <select
              aria-label="Bộ trang bị đang xem"
              className="w-full rounded-xl border border-slate-700 bg-slate-900 px-3 py-2.5 text-xs text-white focus:border-indigo-500 focus:outline-none"
              value={preview.setId}
              onChange={(e) =>
                setPreviewChoice({ ...preview, setId: e.target.value })
              }
            >
              {zodiacSets.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.icon} {s.name}
                </option>
              ))}
            </select>
          </label>
          <label className="flex items-center gap-3 rounded-xl border border-slate-800 bg-slate-900/80 px-4 py-2.5 text-xs text-slate-200 cursor-pointer hover:border-amber-500/40 transition-colors">
            <input
              aria-label="Xem mốc Cầu Vồng"
              type="checkbox"
              checked={preview.rainbow}
              onChange={(e) =>
                setPreviewChoice({ ...preview, rainbow: e.target.checked })
              }
              className="h-4 w-4 rounded border-slate-700 bg-slate-950 text-amber-500"
            />
            <span className="font-semibold text-amber-300">
              🌈 Mốc Cầu Vồng (Phẩm 8)
            </span>
          </label>
        </div>

        <div
          className="grid grid-cols-2 sm:grid-cols-4 gap-2"
          aria-label="Biến thể thuộc tính"
        >
          {set?.variants.map((v) => (
            <button
              key={v.element_id}
              aria-pressed={v.element_id === preview.elementId}
              className={`rounded-xl border px-3 py-2 text-xs font-semibold flex items-center justify-center transition-all ${
                v.element_id === preview.elementId
                  ? "border-sky-400 bg-sky-500/15 shadow-md shadow-sky-500/10"
                  : "border-slate-800 bg-slate-900/70 hover:border-slate-700"
              }`}
              onClick={() =>
                setPreviewChoice({ ...preview, elementId: v.element_id })
              }
            >
              <ElementBadge id={v.element_id} />
            </button>
          ))}
        </div>

        {!variant ? (
          <p className="text-xs text-slate-400">
            Biến thể chưa xác minh. Chọn một thuộc tính có trong bộ.
          </p>
        ) : (
          <>
            <div className="flex flex-wrap items-center justify-between gap-3 pt-1 border-t border-slate-800/80">
              <h3 className="font-bold text-white flex items-center gap-2 text-sm sm:text-base">
                <span>{set?.name}</span>
                <ElementBadge id={variant.element_id} />
              </h3>
              <button
                className={`rounded-xl border px-4 py-2 text-xs font-bold transition-all ${
                  isEquipped
                    ? "border-emerald-500/50 bg-emerald-500/20 text-emerald-300"
                    : "border-indigo-500/50 bg-indigo-600 hover:bg-indigo-500 text-white shadow-lg shadow-indigo-600/20"
                }`}
                aria-pressed={isEquipped}
                onClick={() => onSelect(preview)}
              >
                {isEquipped
                  ? "✓ Đang trang bị bộ này"
                  : "+ Trang bị bộ đang xem vào chỉ số"}
              </button>
            </div>
            <p className="text-xs text-slate-400">
              Chỉ số món ở cấp đồ 1, chưa tinh luyện. Đủ 2/3/4 món kích hoạt các mốc cộng dồn.
            </p>
            <div className="grid gap-3 sm:grid-cols-2 xl:grid-cols-4">
              {(preview.rainbow ? variant.rainbow_parts : variant.parts).map(
                (p) => (
                  <EquipmentItemCard key={p.id} part={p} profile={profile} />
                )
              )}
            </div>
            <SetBonuses
              bonuses={
                preview.rainbow ? variant.rainbow_bonuses : variant.bonuses
              }
            />
            <p className="text-[11px] text-slate-500 font-mono break-words">
              Nguồn: {variant.source}
            </p>
          </>
        )}
      </div>
    </section>
  );
}
