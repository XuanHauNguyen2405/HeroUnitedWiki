// web/src/app/ban-suc/page.tsx
import { getBanSucData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";
import BanSucView from "@/components/BanSucView";

export const metadata = {
  title: "Ban Sức Vận Mệnh & Huy Hiệu | SAHHT WIKI",
  description: "Cơ chế Ban Sức Vận Mệnh, 10 hệ Đá Vận Mệnh, kỹ năng tổ hợp đội hình và danh mục 112 Huy Hiệu Anh Hùng từ cấu hình game nguyên bản.",
};

export default function BanSucPage() {
  const banSucData = getBanSucData();

  return (
    <div className="space-y-8 animate-fade-in">
      <Breadcrumbs items={[{ label: "Ban Sức Vận Mệnh & Huy Hiệu" }]} />

      <div className="border-b border-slate-800 pb-6">
        <h1 className="text-3xl font-extrabold text-white tracking-tight">
          Ban Sức Vận Mệnh & Huy Hiệu
        </h1>
        <p className="mt-2 text-sm text-slate-400">
          Hệ thống Ban Sức Vận Mệnh, 10 hệ Đá Vận Mệnh, kỹ năng tổ hợp đội hình và danh mục 112 Huy Hiệu Anh Hùng được trích xuất trực tiếp từ cấu hình game nguyên bản.
        </p>
      </div>

      <BanSucView data={banSucData} />
    </div>
  );
}
