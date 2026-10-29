// web/src/app/tier-list/page.tsx
import Link from "next/link";
import { getTierListData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";
import TierListInteractiveView from "@/components/TierListInteractiveView";

export const metadata = {
  title: "Bảng Xếp Hạng Tướng (Tier List) Meta Mới Nhất | SAHHT WIKI",
  description:
    "Bảng xếp hạng sức mạnh thực chiến tướng Siêu Anh Hùng Hội Tụ. Phân chia rõ rệt giữa Dealer (Sát thương) và Support & Hybrid (Hỗ trợ đa dụng) từ UBER đến Tier 4.",
};

export default function TierListPage() {
  const tierData = getTierListData();

  return (
    <div className="space-y-10 animate-fade-in max-w-7xl mx-auto px-2 sm:px-4">
      <Breadcrumbs items={[{ label: "Bảng Xếp Hạng Tướng (Tier List)" }]} />

      {/* Page Header */}
      <div className="border-b border-slate-800 pb-8 space-y-4">
        <div className="flex flex-wrap items-center gap-3">
          <span className="rounded-full border border-emerald-500/30 bg-emerald-500/10 px-3.5 py-1 text-xs font-bold text-emerald-400 flex items-center gap-1.5 shadow-sm">
            <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            Meta Mới Nhất • Tháng 10/2026
          </span>
          <span className="rounded-full border border-slate-700 bg-slate-800/90 px-3 py-1 text-xs text-slate-300 font-mono">
            Trạng thái: Chính thức (Đối chiếu thực chiến)
          </span>
          <span className="rounded-full border border-amber-500/30 bg-amber-500/10 px-3 py-1 text-xs text-amber-400 font-semibold">
            46 Tướng Xếp Hạng
          </span>
        </div>

        <div>
          <h1 className="text-3xl sm:text-5xl font-black text-white tracking-tight">
            Bảng Xếp Hạng Tướng{" "}
            <span className="bg-gradient-to-r from-amber-400 via-orange-400 to-red-400 bg-clip-text text-transparent">
              (Tier List)
            </span>
          </h1>
          <p className="mt-3 text-sm sm:text-base text-slate-300 max-w-3xl leading-relaxed">
            Đánh giá phân tầng sức mạnh thực chiến toàn diện trong PvP Đấu Trường & PvE Phụ Bản. Hệ thống phân chia độc lập giữa <strong>DEALER (Sát Thương Chủ Lực)</strong> và <strong>SUPPORT + HYBRID (Hỗ Trợ, Đa Năng & Khống Chế)</strong>.
          </p>
        </div>
      </div>

      {/* Main Interactive View Component */}
      <TierListInteractiveView initialData={tierData} />

      {/* Tier Legend & Explanation */}
      <div className="rounded-3xl border border-slate-800 bg-slate-900/40 p-6 sm:p-8 backdrop-blur space-y-6">
        <div className="border-b border-slate-800 pb-4">
          <h3 className="text-lg font-bold text-white flex items-center gap-2">
            <span>📖</span>
            <span>Quy Chuẩn Phân Tầng Sức Mạnh (Tier Standards)</span>
          </h3>
          <p className="text-xs text-slate-400 mt-1">
            Định nghĩa các bậc xếp hạng sức mạnh được áp dụng trong cộng đồng Siêu Anh Hùng Hội Tụ
          </p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {tierData.tier_legend?.map((t) => (
            <div
              key={t.tier}
              className="rounded-2xl border border-slate-800/80 bg-slate-950/70 p-4 space-y-1.5"
            >
              <div className="flex items-center gap-2">
                <span
                  className="w-3 h-3 rounded-full shrink-0 shadow-sm"
                  style={{ backgroundColor: t.color }}
                />
                <h4 className="font-bold text-sm text-white">{t.title}</h4>
              </div>
              <p className="text-xs text-slate-300/80 leading-relaxed pl-5">
                {t.desc}
              </p>
            </div>
          ))}
        </div>
      </div>

      {/* Helpful Navigation */}
      <div className="rounded-3xl border border-slate-800 bg-gradient-to-b from-slate-900/60 to-slate-950/80 p-8 text-center space-y-5 shadow-2xl">
        <h3 className="font-extrabold text-white text-lg sm:text-xl">
          Khám Phá Dữ Liệu Tướng & Trang Bị Chi Tiết
        </h3>
        <p className="text-xs sm:text-sm text-slate-400 max-w-xl mx-auto leading-relaxed">
          Tra cứu chỉ số, hệ số tăng trưởng, công thức kỹ năng nguyên bản và duyên phận trang bị được trích xuất trực tiếp từ mã nguồn:
        </p>
        <div className="flex flex-wrap items-center justify-center gap-3 pt-2">
          <Link
            href="/heroes"
            className="rounded-xl border border-sky-500/40 bg-sky-500/10 px-5 py-2.5 text-xs font-bold text-sky-400 hover:bg-sky-500/20 transition-all shadow-lg hover:shadow-sky-500/20 hover:-translate-y-0.5"
          >
            Danh Sách 721 Tướng →
          </Link>
          <Link
            href="/suits"
            className="rounded-xl border border-purple-500/40 bg-purple-500/10 px-5 py-2.5 text-xs font-bold text-purple-400 hover:bg-purple-500/20 transition-all shadow-lg hover:shadow-purple-500/20 hover:-translate-y-0.5"
          >
            Bộ Trang Bị Kích Hoạt →
          </Link>
          <Link
            href="/ban-suc"
            className="rounded-xl border border-emerald-500/40 bg-emerald-500/10 px-5 py-2.5 text-xs font-bold text-emerald-400 hover:bg-emerald-500/20 transition-all shadow-lg hover:shadow-emerald-500/20 hover:-translate-y-0.5"
          >
            Ban Sức & Huy Hiệu →
          </Link>
        </div>
      </div>
    </div>
  );
}
