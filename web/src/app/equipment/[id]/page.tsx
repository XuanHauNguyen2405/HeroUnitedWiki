// web/src/app/equipment/[id]/page.tsx
import { notFound } from "next/navigation";
import Link from "next/link";
import { getEquipmentById, getSuitById } from "@/lib/data";
import { getQualityConfig, formatNumber } from "@/lib/utils";
import Breadcrumbs from "@/components/Breadcrumbs";
import ImageWithFallback from "@/components/ImageWithFallback";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const eq = getEquipmentById(id);
  if (!eq) return { title: "Không tìm thấy trang bị | SAHHT Wiki" };
  return {
    title: `${eq.name || `Trang bị #${id}`} - SAHHT WIKI`,
    description: `Chi tiết chỉ số, vị trí ${eq.slot_name || eq.slot}, bộ ${eq.suit_name || "Lẻ"} của ${eq.name || id}.`,
  };
}

export default async function EquipmentDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const eq = getEquipmentById(id);

  if (!eq) {
    notFound();
  }

  const qConfig = getQualityConfig(eq.quality);
  const suit = eq.suit_id ? getSuitById(eq.suit_id) : null;
  const nextEvo = eq.evolution?.next_evolution_equip_id ? getEquipmentById(eq.evolution.next_evolution_equip_id) : null;

  return (
    <div className="space-y-8 animate-fade-in">
      <Breadcrumbs
        items={[
          { label: "Trang Bị", href: "/equipment" },
          { label: eq.name || `Trang bị #${id}` },
        ]}
      />

      {/* Hero Overview */}
      <div className="relative overflow-hidden rounded-2xl border border-slate-800 bg-slate-900/60 p-6 md:p-8 backdrop-blur-xl">
        <div
          className="absolute -right-20 -top-20 h-72 w-72 rounded-full blur-3xl opacity-20 pointer-events-none"
          style={{ background: qConfig.bgGlow }}
        />

        <div className="relative flex flex-col md:flex-row items-start md:items-center gap-6">
          <div className="relative h-28 w-28 shrink-0 overflow-hidden rounded-2xl border-2 border-slate-700 bg-slate-950 p-2 shadow-2xl">
            <ImageWithFallback
              src={eq.icon}
              alt={eq.name || id}
              className="h-full w-full object-contain"
              fallbackIcon="⚔️"
              fallbackText="Chưa tìm thấy ảnh"
            />
          </div>

          <div className="flex-1 space-y-3">
            <div className="flex flex-wrap items-center gap-2">
              <span className={`rounded-full border px-3 py-0.5 text-xs font-semibold ${qConfig.badgeClass}`}>
                {qConfig.name}
              </span>
              <span className="rounded-full border border-sky-500/30 bg-sky-500/10 px-3 py-0.5 text-xs font-semibold text-sky-400">
                Slot {eq.slot}: {eq.slot_name || "Chưa xác minh"}
              </span>
              <span className="rounded-full border border-slate-700 bg-slate-800/80 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
                ID: {id}
              </span>
              {eq.equip_id && (
                <span className="rounded-full border border-slate-700 bg-slate-800/80 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
                  Mã Equip: {eq.equip_id}
                </span>
              )}
            </div>

            <h1 className="text-3xl md:text-4xl font-extrabold text-white tracking-tight">
              {eq.name || <span className="text-slate-500 italic">Chưa có tên trong cấu hình</span>}
            </h1>

            <div className="flex flex-wrap items-center gap-4 text-sm text-slate-400">
              {suit ? (
                <div>
                  Thuộc bộ:{" "}
                  <Link href={`/suits/${suit.id}`} className="text-sky-400 hover:text-sky-300 font-semibold underline underline-offset-4">
                    {suit.name || `Bộ #${suit.id}`}
                  </Link>
                </div>
              ) : eq.suit_id ? (
                <div>
                  Thuộc bộ (Mã: {eq.suit_id}): <span className="text-slate-500">Chưa xác minh chi tiết bộ</span>
                </div>
              ) : (
                <div className="text-slate-500">Trang bị đơn lẻ (Không thuộc bộ)</div>
              )}

              {eq.cd !== undefined && (
                <div>
                  Thời gian hồi (CD):{" "}
                  <span className="text-slate-200 font-mono">{eq.cd}</span>{" "}
                  <span className="text-xs text-amber-400/80">(Chưa xác minh đơn vị)</span>
                </div>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left Column: Stats & Properties */}
        <div className="lg:col-span-2 space-y-6">
          {/* Primary & Secondary Stats */}
          <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur">
            <h2 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
              <span className="h-2 w-2 rounded-full bg-sky-500" />
              Chỉ Số Thuộc Tính
            </h2>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* Primary Stat */}
              <div className="rounded-xl border border-slate-800 bg-slate-950/60 p-4">
                <div className="text-xs text-slate-400 uppercase tracking-wider mb-1">Chỉ số chính (Primary)</div>
                {eq.primary_stat && eq.primary_stat.ability_id ? (
                  <div className="space-y-1">
                    <div className="text-lg font-bold text-sky-400">
                      +{formatNumber(eq.primary_stat.value)}
                    </div>
                    <div className="text-xs text-slate-400">
                      Tăng mỗi cấp: <span className="font-mono text-slate-300">+{eq.primary_stat.level_add}</span>
                    </div>
                    <div className="text-[11px] text-slate-500 font-mono">
                      Mã thuộc tính: {eq.primary_stat.ability_id}{" "}
                      <span className="text-amber-400/80">(Chưa xác minh tên gọi thuộc tính)</span>
                    </div>
                  </div>
                ) : (
                  <div className="text-sm text-slate-500 italic">Không có chỉ số chính</div>
                )}
              </div>

              {/* Secondary Stat */}
              <div className="rounded-xl border border-slate-800 bg-slate-950/60 p-4">
                <div className="text-xs text-slate-400 uppercase tracking-wider mb-1">Chỉ số phụ (Secondary)</div>
                {eq.secondary_stat && eq.secondary_stat.ability_id ? (
                  <div className="space-y-1">
                    <div className="text-lg font-bold text-purple-400">
                      +{formatNumber(eq.secondary_stat.value)}
                    </div>
                    <div className="text-xs text-slate-400">
                      Tăng mỗi cấp: <span className="font-mono text-slate-300">+{eq.secondary_stat.level_add}</span>
                    </div>
                    <div className="text-[11px] text-slate-500 font-mono">
                      Mã thuộc tính: {eq.secondary_stat.ability_id}{" "}
                      <span className="text-amber-400/80">(Chưa xác minh tên gọi thuộc tính)</span>
                    </div>
                  </div>
                ) : (
                  <div className="text-sm text-slate-500 italic">Không có chỉ số phụ</div>
                )}
              </div>
            </div>
          </div>

          {/* Evolution Chain */}
          <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur">
            <h2 className="text-xl font-bold text-white mb-4 flex items-center gap-2">
              <span className="h-2 w-2 rounded-full bg-emerald-500" />
              Tiến Hóa Trang Bị
            </h2>

            {nextEvo ? (
              <div className="rounded-xl border border-slate-800 bg-slate-950/60 p-4 flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="h-12 w-12 rounded-lg border border-slate-700 bg-slate-900 p-1">
                    <ImageWithFallback
                      src={nextEvo.icon}
                      alt={nextEvo.name || nextEvo.id}
                      className="h-full w-full object-contain"
                      fallbackIcon="⚔️"
                      fallbackText="Chưa tìm thấy ảnh"
                    />
                  </div>
                  <div>
                    <div className="text-xs text-emerald-400 font-semibold">Cấp tiến hóa kế tiếp</div>
                    <div className="font-bold text-white">{nextEvo.name || `Trang bị #${nextEvo.id}`}</div>
                    <div className="text-xs text-slate-400">ID: {nextEvo.id} | Slot {nextEvo.slot}</div>
                  </div>
                </div>

                <Link
                  href={`/equipment/${nextEvo.id}`}
                  className="rounded-lg border border-sky-500/30 bg-sky-500/10 px-4 py-2 text-sm font-semibold text-sky-400 hover:bg-sky-500/20 transition-colors"
                >
                  Xem tiến hóa →
                </Link>
              </div>
            ) : eq.evolution?.raw_evolution ? (
              <div className="rounded-xl border border-slate-800 bg-slate-950/60 p-4">
                <div className="text-xs text-slate-400">Mã tiến hóa nguồn: <span className="font-mono text-slate-200">{eq.evolution.raw_evolution}</span></div>
                <div className="text-xs text-slate-500 mt-1">Dữ liệu trang bị đích chưa có trong config hiện tại.</div>
              </div>
            ) : (
              <div className="text-sm text-slate-500 italic">Trang bị này không có tiến hóa hoặc đã đạt cấp tối đa.</div>
            )}
          </div>
        </div>

        {/* Right Column: Suit Info & Metadata */}
        <div className="space-y-6">
          {/* Suit Card */}
          {suit && (
            <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur">
              <h2 className="text-lg font-bold text-white mb-3">Thông Tin Bộ Trang Bị</h2>
              <div className="space-y-3">
                <div className="flex items-center justify-between">
                  <span className="text-sm text-slate-400">Tên bộ:</span>
                  <Link href={`/suits/${suit.id}`} className="font-bold text-sky-400 hover:text-sky-300">
                    {suit.name || `Bộ #${suit.id}`}
                  </Link>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-sm text-slate-400">Số món bộ:</span>
                  <span className="font-mono text-white">{suit.parts_count || suit.parts?.length || 0} món</span>
                </div>
                <div className="pt-2">
                  <Link
                    href={`/suits/${suit.id}`}
                    className="block w-full text-center rounded-xl border border-slate-700 bg-slate-800/80 py-2.5 text-xs font-semibold text-slate-200 hover:bg-slate-700 transition-colors"
                  >
                    Xem chi tiết toàn bộ bộ {suit.name || `#${suit.id}`} →
                  </Link>
                </div>
              </div>
            </div>
          )}

          {/* Technical Metadata Card */}
          <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur space-y-3 text-xs">
            <h2 className="text-sm font-bold text-slate-300 uppercase tracking-wider">Thông Tin Hệ Thống</h2>
            <div className="flex justify-between py-1 border-b border-slate-800">
              <span className="text-slate-400">ID Trang Bị:</span>
              <span className="font-mono text-slate-200">{id}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-800">
              <span className="text-slate-400">Tệp Cấu Hình:</span>
              <span className="font-mono text-slate-200">{eq._source?.file || "equip.config"}</span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-800">
              <span className="text-slate-400">Tham Chiếu Ảnh:</span>
              <span className="font-mono text-slate-300 truncate max-w-[180px]">
                {eq.assets?.image?.ref || "Không có"}
              </span>
            </div>
            <div className="flex justify-between py-1 border-b border-slate-800">
              <span className="text-slate-400">Trạng Thái Ảnh:</span>
              <span className="font-mono text-emerald-400">
                {eq.assets?.image?.status === "found" ? "Đã xác thực" : "Chưa tìm thấy ảnh"}
              </span>
            </div>
            {eq.economy?.sell_metal !== undefined && (
              <div className="flex justify-between py-1">
                <span className="text-slate-400">Bán (Kim Loại):</span>
                <span className="font-mono text-amber-400">{formatNumber(eq.economy.sell_metal)}</span>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
