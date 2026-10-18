// web/src/app/skills/[id]/page.tsx
import React from "react";
import Link from "next/link";
import { notFound } from "next/navigation";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";
import { getSkillById } from "@/lib/data";
import { getQualityConfig } from "@/lib/utils";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const skill = getSkillById(id);
  if (!skill) return { title: `Kỹ năng #${id} - Không tìm thấy` };
  return {
    title: `${skill.name || `Kỹ năng #${id}`} (ID: ${id}) - Siêu Anh Hùng Hội Tụ WIKI`,
    description: `Chi tiết kỹ năng ${skill.name || `ID: ${id}`}, chuỗi tiến cấp và tướng sở hữu.`,
  };
}

export default async function SkillDetailPage({ params }: PageProps) {
  const { id } = await params;
  const skill = getSkillById(id);

  if (!skill) {
    notFound();
  }

  const qConfig = getQualityConfig(skill.quality);

  return (
    <div className="space-y-8">
      
      {/* Breadcrumbs */}
      <Breadcrumbs
        items={[
          { label: "Kỹ Năng", href: "/skills" },
          { label: `${skill.name || `Kỹ năng #${id}`} (ID: ${id})` },
        ]}
      />

      {/* Header Banner */}
      <div className="p-6 sm:p-8 rounded-2xl border border-gray-800 bg-gradient-to-r from-amber-950/40 via-gray-900 to-gray-950 shadow-2xl relative overflow-hidden">
        <div className="flex flex-col sm:flex-row items-center sm:items-start gap-6 relative z-10">
          
          {/* Skill Icon */}
          <div className="w-24 h-24 sm:w-28 sm:h-28 rounded-2xl overflow-hidden border-2 border-amber-500/40 bg-gray-950 shadow-2xl flex-shrink-0">
            <ImageWithFallback
              src={skill.icon}
              alt={skill.name || `Kỹ năng #${id}`}
              className="w-full h-full object-cover"
              fallbackText="Chưa có ảnh"
              fallbackIcon="⚡"
            />
          </div>

          {/* Meta */}
          <div className="flex-1 text-center sm:text-left space-y-2.5">
            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2">
              <span className="text-xs font-mono px-2.5 py-0.5 rounded bg-gray-900 text-gray-300 border border-gray-800">
                ID Kỹ Năng: <b>{skill.id}</b>
              </span>
              <span className="text-xs px-2.5 py-0.5 rounded bg-amber-500/10 text-amber-300 border border-amber-500/30 font-semibold">
                Loại: {skill.skill_type || "Chưa phân loại"}
              </span>
              <span className={`text-xs px-2.5 py-0.5 rounded border font-semibold ${qConfig.badgeClass}`}>
                {qConfig.name}
              </span>
            </div>

            <h1 className="text-2xl sm:text-4xl font-extrabold text-white tracking-tight">
              {skill.name || <span className="text-gray-500 italic">Chưa có dữ liệu tên</span>}
            </h1>

            <div className="flex flex-wrap items-center justify-center sm:justify-start gap-2 text-xs">
              <span className="px-2.5 py-1 rounded-md bg-gray-900 text-gray-300 border border-gray-800">
                Cấp tối đa: <b>{skill.max_lv || "0"}</b>
              </span>
              <span className="px-2.5 py-1 rounded-md bg-gray-900 text-gray-300 border border-gray-800">
                Tỉ lệ kích hoạt (rate): <b>{skill.rate}%</b>
              </span>
              <span className="px-2.5 py-1 rounded-md bg-gray-900 text-gray-300 border border-gray-800">
                Action: <b className="text-emerald-400">{skill.action ?? "0"}</b> (Bảo toàn số nguyên 0)
              </span>
            </div>
          </div>

        </div>
      </div>

      {/* Raw Attributes & Game Description */}
      <section className="p-6 rounded-2xl border border-gray-800 bg-gray-900/40 backdrop-blur-xl space-y-6">
        <h2 className="text-lg font-bold text-white flex items-center gap-2">
          <span>📋</span> Thuộc Tính Nguồn & Mô Tả Kỹ Năng
        </h2>

        {/* 6 Value Boxes */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 text-center">
          
          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">Hồi chiêu (cd)</div>
            <div className="text-lg font-bold text-white">{skill.cd}</div>
            <div className="text-[9px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 inline-block">
              Chưa xác minh đơn vị
            </div>
          </div>

          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">Tiền hồi chiêu (pre_cd)</div>
            <div className="text-lg font-bold text-white">{skill.pre_cd}</div>
            <div className="text-[9px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 inline-block">
              Chưa xác minh đơn vị
            </div>
          </div>

          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">Tỉ lệ kích hoạt (rate)</div>
            <div className="text-lg font-bold text-emerald-400">{skill.rate}%</div>
            <div className="text-[9px] text-gray-500">Xác suất kích hoạt</div>
          </div>

          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">Trường effect</div>
            <div className="text-lg font-bold text-white">{skill.effect}</div>
            <div className="text-[9px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 inline-block">
              Chưa xác minh cách tính
            </div>
          </div>

          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">Trường attr_effect</div>
            <div className="text-lg font-bold text-white">{skill.attr_effect}</div>
            <div className="text-[9px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 inline-block">
              Chưa xác minh cách tính
            </div>
          </div>

          <div className="p-3.5 rounded-xl bg-gray-950/70 border border-gray-800 space-y-1">
            <div className="text-[10px] text-gray-400 uppercase font-medium">effect_lvchange</div>
            <div className="text-lg font-bold text-white">{skill.effect_lvchange}</div>
            <div className="text-[9px] px-1.5 py-0.5 rounded bg-amber-500/10 text-amber-400 border border-amber-500/20 inline-block">
              Chưa xác minh cách tính
            </div>
          </div>

        </div>

        {/* Game Story Description */}
        <div className="p-4 rounded-xl bg-gray-950/80 border-l-4 border-amber-500 space-y-1.5">
          <div className="text-[10px] uppercase font-bold text-amber-400 tracking-wider">
            Mô tả hiển thị trong game (Game Story Text):
          </div>
          <div className="text-sm sm:text-base text-gray-100 font-medium leading-relaxed">
            &ldquo;{skill.description}&rdquo;
          </div>
          <div className="text-[11px] text-gray-500 pt-1">
            * Nguyên tắc bảo toàn: Giữ nguyên các biến công thức (ví dụ: <code className="text-indigo-300">effect%</code>, <code className="text-indigo-300">%s</code>), không tự quy đổi thành công thức khi chưa có đối chiếu game.
          </div>
        </div>
      </section>

      {/* Evolution Chain */}
      {skill.evolution_chain && skill.evolution_chain.length > 1 && (
        <section className="p-6 rounded-2xl border border-gray-800 bg-gray-900/40 backdrop-blur-xl space-y-4">
          <h2 className="text-lg font-bold text-white flex items-center gap-2">
            <span>🧬</span> Chuỗi Tiến Cấp Kỹ Năng ({skill.evolution_chain.length} Giai Đoạn)
          </h2>

          <div className="flex flex-col sm:flex-row items-center gap-3 overflow-x-auto p-2">
            {skill.evolution_chain.map((step: any, idx: number) => {
              const isCurrent = step.id === skill.id;
              return (
                <React.Fragment key={step.id}>
                  <div
                    className={`p-4 rounded-xl border flex-1 min-w-[200px] text-center space-y-2 transition-all ${
                      isCurrent
                        ? "bg-amber-950/40 border-amber-500/60 shadow-lg shadow-amber-500/10 ring-1 ring-amber-500/30"
                        : "bg-gray-950/60 border-gray-800 hover:border-gray-700"
                    }`}
                  >
                    <div className="text-[10px] font-bold text-amber-400 uppercase tracking-wider">
                      Giai Đoạn {idx + 1} {isCurrent && "(Hiện tại)"}
                    </div>
                    <div className="font-bold text-sm text-white truncate">
                      {step.name || `Kỹ năng #${step.id}`}
                    </div>
                    <div className="text-xs font-mono text-gray-400">ID: {step.id}</div>
                    <div className="text-xs text-emerald-400 font-semibold">
                      effect: {step.effect}
                    </div>
                    {!isCurrent && (
                      <Link
                        href={`/skills/${step.id}`}
                        className="inline-block mt-2 text-[11px] text-indigo-400 hover:text-indigo-300 font-medium"
                      >
                        Chuyển sang xem ➔
                      </Link>
                    )}
                  </div>
                  {idx < skill.evolution_chain.length - 1 && (
                    <span className="text-gray-600 text-xl font-bold hidden sm:inline-block">
                      ➔
                    </span>
                  )}
                </React.Fragment>
              );
            })}
          </div>
        </section>
      )}

      {/* Used by Heroes */}
      <section className="p-6 rounded-2xl border border-gray-800 bg-gray-900/40 backdrop-blur-xl space-y-4">
        <h2 className="text-lg font-bold text-white flex items-center gap-2">
          <span>👥</span> Tướng Sở Hữu Kỹ Năng Này ({skill.used_by_heroes?.length || 0})
        </h2>

        {skill.used_by_heroes && skill.used_by_heroes.length > 0 ? (
          <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-3">
            {skill.used_by_heroes.map((h: any) => (
              <Link
                key={h.hero_id}
                href={`/heroes/${h.hero_id}`}
                className="p-3 rounded-xl border border-gray-800 bg-gray-950/60 hover:bg-gray-900 hover:border-gray-700 transition-all flex items-center gap-3 group"
              >
                <div className="w-12 h-12 rounded-lg overflow-hidden border border-gray-700 bg-gray-900 flex-shrink-0">
                  <ImageWithFallback
                    src={h.hero_avatar}
                    alt={h.hero_name}
                    className="w-full h-full object-cover"
                    fallbackText="No Pic"
                    fallbackIcon="👤"
                  />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="text-xs font-bold text-white truncate group-hover:text-indigo-400 transition-colors">
                    {h.hero_name}
                  </div>
                  <div className="text-[10px] text-gray-500 font-mono">
                    ID Bản Thể: #{h.hero_id}
                  </div>
                </div>
                <span className="text-xs text-gray-500 group-hover:text-indigo-400 group-hover:translate-x-1 transition-transform">
                  ➔
                </span>
              </Link>
            ))}
          </div>
        ) : (
          <div className="text-xs text-gray-500 italic p-4 text-center">
            Chiêu thức này thuộc hệ kỹ năng phụ trợ, quái hoặc chưa liên kết với bản thể tướng nào.
          </div>
        )}
      </section>

    </div>
  );
}
