// web/src/app/suits/[id]/page.tsx
import React from "react";
import Link from "next/link";
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
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-emerald-950/40 via-gray-900 to-gray-950 shadow-2xl">
        <div className="flex flex-col sm:flex-row items-center sm:items-start gap-5">
          <div className="text-4xl p-4 rounded-2xl bg-gray-950 border border-gray-800 shadow-xl">
            🛡️
          </div>

          <div className="flex-1 text-center sm:text-left space-y-2">
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2">
              <span className="text-xs font-mono px-2.5 py-0.5 rounded bg-gray-900 text-gray-300 border border-gray-800">
                Suit ID: <b>{suit.id}</b>
              </span>
              <span className="text-xs px-2.5 py-0.5 rounded bg-emerald-500/10 text-emerald-400 border border-emerald-500/20 font-semibold">
                {suit.parts?.length || 0} Vị Trí Trang Bị
              </span>
              {suit.has_all_images && (
                <span className="text-xs px-2.5 py-0.5 rounded bg-emerald-500/20 text-emerald-300 border border-emerald-500/40 font-semibold">
                  ✓ Đã tìm thấy đủ 4 ảnh từ APK
                </span>
              )}
            </div>

            <h1 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight">
              Bộ Trang Bị: {suit.name}
            </h1>

            <p className="text-xs text-gray-400 max-w-2xl leading-relaxed">
              Trang bị đồng bộ các mảnh thuộc bộ sẽ kích hoạt các thuộc tính cộng thêm mạnh mẽ tương ứng với các mốc 2, 3 và 4 món.
            </p>
          </div>
        </div>
      </div>

      {/* Set Activation Bonuses */}
      <section className="hero-section"><ElementBadge id={suit.element_id} /><SetBonuses bonuses={suit.bonuses} /></section>

      {/* 4 Equipment Parts in Detail */}
      <section className="p-6 rounded-2xl border border-gray-800 bg-gray-900/40 backdrop-blur-xl space-y-5">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-lg font-bold text-white flex items-center gap-2">
              <span>🗡️</span> Chi Tiết 4 Vị Trí Trang Bị Thuộc Bộ
            </h2>
            <p className="text-xs text-gray-400 mt-0.5">
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
                className="p-4 rounded-xl border border-gray-800 bg-gray-950/60 flex flex-col justify-between space-y-3"
              >
                <div>
                  <div className="w-16 h-16 mx-auto rounded-xl overflow-hidden border border-gray-700 bg-gray-900 mb-2">
                    <ImageWithFallback
                      src={eq.icon}
                      alt={eq.name}
                      className="w-full h-full object-cover"
                      fallbackText="Chưa tìm thấy ảnh"
                      fallbackIcon="⚔️"
                    />
                  </div>

                  <div className="text-center space-y-1 mb-3">
                    <h3 className="font-bold text-white text-sm truncate">
                      {eq.name}
                    </h3>
                    <div className="flex items-center justify-center gap-1.5">
                      <span className="text-[10px] px-2 py-0.5 rounded bg-blue-500/10 text-blue-400 border border-blue-500/20 font-medium">
                        Slot {eq.slot}: {eq.slot_name}
                      </span>
                      <span className={`text-[10px] px-1.5 py-0.5 rounded border ${qConfig.badgeClass}`}>
                        Phẩm {eq.quality}
                      </span>
                    </div>
                  </div>

                  {/* Attributes */}
                  <div className="text-[11px] text-gray-300 bg-gray-900/60 p-2.5 rounded-lg border border-gray-800/80 space-y-1">
                    <div>
                      • <b>ID:</b> <code className="text-indigo-300 font-mono">{eq.id}</code>
                    </div>
                    <div>
                      • <b>equip_id gốc:</b> <code className="text-gray-400 font-mono">{eq.equip_id}</code>
                    </div>
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
                    {eq.evolution?.next_evolution_equip_id && (
                      <div>
                        • <b>Tiến hóa:</b> Sang ID {eq.evolution.next_evolution_equip_id}
                      </div>
                    )}
                  </div>
                </div>

                <Link
                  href={`/equipment/${eq.id}`}
                  className="w-full py-2 rounded-lg bg-gray-900 hover:bg-emerald-600/30 text-gray-300 hover:text-white border border-gray-800 text-xs font-semibold text-center transition-all block"
                >
                  Xem Trang Bị #{eq.id} ➔
                </Link>
              </div>
            );
          })}
        </div>
      </section>

    </div>
  );
}
