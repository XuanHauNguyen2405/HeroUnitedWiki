// web/src/app/tier-list/page.tsx
import Link from "next/link";
import { getEditorialData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";

export const metadata = {
  title: "Bảng Xếp Hạng Tướng (Tier List) | SAHHT WIKI",
  description: "Bảng xếp hạng sức mạnh tướng Siêu Anh Hùng Hội Tụ. Tách biệt dữ liệu game với đánh giá biên tập viên.",
};

export default function TierListPage() {
  const editorial = getEditorialData();
  const tierData = editorial?.tier_list || { status: "draft" };

  return (
    <div className="space-y-8 animate-fade-in max-w-4xl mx-auto">
      <Breadcrumbs items={[{ label: "Bảng Xếp Hạng Tướng" }]} />

      <div className="border-b border-slate-800 pb-6">
        <div className="flex items-center gap-3 mb-2">
          <span className="rounded-full border border-amber-500/30 bg-amber-500/10 px-3 py-0.5 text-xs font-semibold text-amber-400">
            Nội dung biên tập (Chưa đối chiếu thực chiến)
          </span>
          <span className="rounded-full border border-slate-700 bg-slate-800 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
            Trạng thái: Bản Thảo
          </span>
        </div>
        <h1 className="text-3xl font-extrabold text-white tracking-tight">
          Bảng Xếp Hạng Tướng (Tier List)
        </h1>
        <p className="mt-2 text-sm text-slate-400">
          Đánh giá xếp hạng dựa trên sức mạnh thực chiến trong PvP, PvE, khả năng kết hợp duyên phận và bộ trang bị.
        </p>
      </div>

      {/* Editorial Notice Banner */}
      <div className="rounded-2xl border border-amber-500/20 bg-amber-950/10 p-6 backdrop-blur">
        <div className="flex items-start gap-4">
          <span className="text-2xl">⚠️</span>
          <div className="space-y-2 text-sm text-amber-200/90 leading-relaxed">
            <h3 className="font-bold text-amber-300 text-base">
              Nguyên Tắc Minh Bạch Của SAHHT WIKI
            </h3>
            <p>
              Hệ thống wiki tuyệt đối tuân thủ nguyên tắc <strong>không tự tạo bảng xếp hạng ảo</strong> khi chưa có dữ liệu đối chiếu thực chiến và bằng chứng xác thực từ cộng đồng game thủ.
            </p>
            <p className="text-xs text-amber-300/70">
              Mọi xếp hạng trong tương lai sẽ được đánh dấu rõ ràng là đánh giá chủ quan của người biên tập, tách rời hoàn toàn với dữ liệu cấu hình gốc của game.
            </p>
          </div>
        </div>
      </div>

      {/* Empty State / Tier Template */}
      <div className="space-y-4">
        {["Tier SSS (Siêu Cấp Meta)", "Tier SS (Chủ Lực)", "Tier S (Đa Dụng)", "Tier A (Tình Huống)"].map((tierName, idx) => (
          <div
            key={idx}
            className="rounded-xl border border-slate-800 bg-slate-900/30 p-5 backdrop-blur opacity-75"
          >
            <div className="flex items-center justify-between mb-3 border-b border-slate-800 pb-2">
              <span className="font-bold text-slate-300 text-sm">{tierName}</span>
              <span className="text-xs text-slate-500 italic">Đang thu thập dữ liệu</span>
            </div>
            <div className="py-6 text-center text-xs text-slate-500 border border-dashed border-slate-800/80 rounded-lg">
              Chưa có dữ liệu tướng được xếp vào phân hạng này.
            </div>
          </div>
        ))}
      </div>

      {/* Helpful Navigation */}
      <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur text-center space-y-4">
        <h3 className="font-bold text-white text-base">Bạn Muốn Tra Cứu Dữ Liệu Thực Tế?</h3>
        <p className="text-xs text-slate-400 max-w-lg mx-auto">
          Tra cứu chỉ số, tăng trưởng, kỹ năng và duyên phận nguyên bản đã được trích xuất trực tiếp từ mã nguồn:
        </p>
        <div className="flex flex-wrap items-center justify-center gap-3">
          <Link
            href="/heroes"
            className="rounded-xl border border-sky-500/30 bg-sky-500/10 px-4 py-2 text-xs font-semibold text-sky-400 hover:bg-sky-500/20 transition-colors"
          >
            Danh Sách 721 Tướng →
          </Link>
          <Link
            href="/suits"
            className="rounded-xl border border-purple-500/30 bg-purple-500/10 px-4 py-2 text-xs font-semibold text-purple-400 hover:bg-purple-500/20 transition-colors"
          >
            Bộ Trang Bị Kích Hoạt →
          </Link>
          <Link
            href="/ban-suc"
            className="rounded-xl border border-emerald-500/30 bg-emerald-500/10 px-4 py-2 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/20 transition-colors"
          >
            Ban Sức & Huy Hiệu →
          </Link>
        </div>
      </div>
    </div>
  );
}
