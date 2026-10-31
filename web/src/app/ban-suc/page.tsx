// web/src/app/ban-suc/page.tsx
import { getBanSucData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";
import BanSucView from "@/components/BanSucView";

export const metadata = {
  title: "Ban Sức Vận Mệnh & Huy Hiệu | SAHHT WIKI",
  description:
    "Cơ chế Ban Sức Vận Mệnh, 10 hệ Đá Vận Mệnh, kỹ năng tổ hợp đội hình và danh mục 112 Huy Hiệu Anh Hùng từ cấu hình game nguyên bản.",
};

export default function BanSucPage() {
  const banSucData = getBanSucData();

  return (
    <div className="space-y-8 animate-fade-in">
      <Breadcrumbs items={[{ label: "Ban Sức Vận Mệnh & Huy Hiệu" }]} />

      <div className="p-6 sm:p-8 rounded-3xl border border-slate-800/80 bg-gradient-to-r from-purple-950/45 via-slate-900/90 to-slate-950 flex flex-col md:flex-row items-start md:items-center justify-between gap-4 shadow-xl">
        <div>
          <div className="inline-flex items-center gap-2 px-2.5 py-0.5 rounded-full bg-purple-500/10 border border-purple-500/20 text-[11px] font-semibold text-purple-300 mb-2">
            <span>🔮</span> Hệ Thống Đá Vận Mệnh & Huy Hiệu Độc Quyền
          </div>
          <h1 className="text-2xl sm:text-3xl font-extrabold text-white tracking-tight">
            Ban Sức Vận Mệnh & Huy Hiệu Anh Hùng
          </h1>
          <p className="mt-1.5 text-xs sm:text-sm text-slate-400 max-w-2xl leading-relaxed">
            Hệ thống Ban Sức Vận Mệnh, 10 hệ Đá Vận Mệnh, kỹ năng tổ hợp đội hình và danh mục 112 Huy Hiệu Anh Hùng được trích xuất trực tiếp từ cấu hình game nguyên bản.
          </p>
        </div>

        <div className="flex items-center gap-3 text-xs bg-slate-950/90 px-4 py-2.5 rounded-2xl border border-slate-800 shrink-0">
          <span className="text-slate-400">Huy hiệu đã giải mã:</span>
          <span className="font-mono font-extrabold text-purple-400 text-sm">
            112 Cấp Độ
          </span>
        </div>
      </div>

      <BanSucView data={banSucData} />
    </div>
  );
}
