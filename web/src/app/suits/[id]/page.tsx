// web/src/app/suits/[id]/page.tsx
import React from "react";
import { notFound } from "next/navigation";
import ElementBadge from "@/components/ElementBadge";
import { EquipmentStatLine, SetBonuses } from "@/components/EquipmentDetails";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { getSuitById } from "@/lib/data";
import { getQualityConfig } from "@/lib/utils";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const suit = getSuitById(id);
  if (!suit) return { title: `Bộ Trang Bị #${id} - Không tìm thấy` };
  return {
    title: `Bộ ${suit.name || `#${id}`} (Suit: ${id}) - Siêu Anh Hùng Hội Tụ WIKI`,
    description: `Chi tiết 4 món trang bị và hiệu ứng kích hoạt mốc 2/3/4 món của Bộ ${suit.name}.`,
  };
}

export default async function SuitDetailPage({ params }: PageProps) {
  const { id } = await params;
  const suit = getSuitById(id);

  if (!suit) {
    notFound();
  }

  return (
    <div className="space-y-8">
      {/* Breadcrumbs */}
      <Breadcrumbs
        items={[
          { label: "Bộ Trang Bị", href: "/suits" },
          { label: `Bộ ${suit.name} (ID: ${suit.id})` },
        ]}
      />

      {/* Header Banner */}
      <div className="p-6 sm:p-8 rounded-3xl border border-slate-800/80 bg-gradient-to-r from-emerald-950/40 via-slate-900/90 to-slate-950 shadow-2xl">
        <div className="flex flex-col sm:flex-row items-center sm:items-start gap-5">
          <div className="text-4xl p-4 rounded-2xl bg-slate-950 border border-slate-800 shadow-xl">
            🛡️
          </div>

          <div className="flex-1 text-center sm:text-left space-y-2.5">
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2">
              <span className="text-xs font-mono px-2.5 py-0.5 rounded-lg bg-slate-900 text-slate-300 border border-slate-800">
                Suit ID: <b>{suit.id}</b>
              </span>
              <span className="text-xs px-2.5 py-0.5 rounded-lg bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-semibold">
                {suit.parts?.length || 0} Vị Trí Trang Bị
              </span>
              <ElementBadge id={suit.element_id} />
              {suit.has_all_images && (
                <span className="text-xs px-2.5 py-0.5 rounded-lg bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 font-semibold">
                  ✓ Đủ 4 ảnh từ APK
                </span>
              )}
            </div>

            <h1 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight">
              Bộ Trang Bị: {suit.name}
            </h1>

            <p className="text-xs sm:text-sm text-slate-400 max-w-2xl leading-relaxed">
              Trang bị đồng bộ các mảnh thuộc bộ sẽ kích hoạt các thuộc tính cộng thêm mạnh mẽ tương ứng với các mốc 2, 3 và 4 món.
            </p>
          </div>
        </div>
      </div>

      {/* Set Activation Bonuses */}
      <section className="p-6 rounded-2xl border border-slate-800/90 bg-slate-900/50 backdrop-blur-xl space-y-4">
        <div className="flex flex-wrap items-center justify-between gap-2">
          <div>
            <h2 className="text-lg font-bold text-white flex items-center gap-2">
              <span>✨</span> Hiệu Ứng Kích Hoạt Bộ (2 / 3 / 4 Món)
            </h2>
            <p className="text-xs text-slate-400 mt-0.5">
              Các mốc thuộc tính cộng dồn khi nhân vật trang bị đủ số món thuộc Bộ {suit.name}.
            </p>
          </div>
          <ElementBadge id={suit.element_id} />
        </div>
        <SetBonuses bonuses={suit.bonuses} />
      </section>

      {/* 4 Equipment Parts in Detail */}
      <section className="p-6 rounded-2xl border border-slate-800/90 bg-slate-900/50 backdrop-blur-xl space-y-5">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-bold text-white flex items-center gap-2">
              <span>🗡️</span> Chi Tiết 4 Vị Trí Trang Bị Thuộc Bộ
            </h2>
            <p className="text-xs text-slate-400 mt-0.5">
              Vũ khí (Slot 1), Trang sức (Slot 2), Giáp/Áo (Slot 3), Giày (Slot 4)
            </p>
          </div>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          {suit.parts?.map((eq: any) => {
            const qConfig = getQualityConfig(eq.quality);
            return (
              <div
                key={eq.id}
                className="p-4 rounded-2xl border border-slate-800 bg-slate-950/70 flex flex-col justify-between space-y-3 hover:border-slate-700 transition-colors"
              >
                <div>
                  <div className="w-16 h-16 mx-auto rounded-xl overflow-hidden border border-slate-700/80 bg-slate-900 mb-3 p-1">
                    <ImageWithFallback
                      src={eq.icon}
                      alt={eq.name}
                      className="w-full h-full object-contain"
                      fallbackText="Chưa tìm thấy ảnh"
                      fallbackIcon="⚔️"
                    />
                  </div>

                  <div className="text-center space-y-1.5 mb-3">
                    <h3 className="font-bold text-white text-sm truncate" title={eq.name}>
                      {eq.name}
                    </h3>
                    <div className="flex flex-wrap items-center justify-center gap-1.5">
                      <span className="text-[10px] px-2 py-0.5 rounded-md bg-sky-500/10 text-sky-400 border border-sky-500/20 font-medium">
                        Slot {eq.slot}: {eq.slot_name}
                      </span>
                      <span
                        className={`text-[10px] px-1.5 py-0.5 rounded-md border ${qConfig.badgeClass}`}
                      >
                        Phẩm {eq.quality}
                      </span>
                    </div>
                  </div>

                  {/* Attributes */}
                  <div className="text-xs text-slate-300 bg-slate-900/70 p-3 rounded-xl border border-slate-800/80 space-y-1.5">
                    <div className="flex items-center justify-between text-[11px]">
                      <span className="text-slate-400">Mã ID:</span>
                      <code className="text-indigo-300 font-mono font-bold">
                        #{eq.id}
                      </code>
                    </div>
                    <div className="flex items-center justify-between text-[11px]">
                      <span className="text-slate-400">equip_id gốc:</span>
                      <code className="text-slate-300 font-mono">
                        {eq.equip_id}
                      </code>
                    </div>
                    <div className="border-t border-slate-800/80 pt-1.5 space-y-1">
                      {eq.primary_stat && (
                        <div>
                          <EquipmentStatLine stat={eq.primary_stat} />
                        </div>
                      )}
                      {eq.secondary_stat && (
                        <div>
                          <EquipmentStatLine stat={eq.secondary_stat} />
                        </div>
                      )}
                    </div>
                    {eq.evolution?.next_evolution_equip_id && (
                      <div className="border-t border-slate-800/80 pt-1.5 text-[11px] text-amber-300">
                        ⚡ Tiến hóa sang ID:{" "}
                        <b className="font-mono">
                          #{eq.evolution.next_evolution_equip_id}
                        </b>
                      </div>
                    )}
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </section>
    </div>
  );
}
