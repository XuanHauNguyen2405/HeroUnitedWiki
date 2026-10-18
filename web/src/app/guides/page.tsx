// web/src/app/guides/page.tsx
import Link from "next/link";
import { getEditorialData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";

export const metadata = {
  title: "Cẩm Nang & Hướng Dẫn | SAHHT WIKI",
  description: "Các bài viết hướng dẫn tân thủ, tối ưu hóa đội hình, bộ trang bị và ban sức.",
};

export default function GuidesPage() {
  const editorial = getEditorialData();
  const guides: Array<{
    id: string;
    title: string;
    category: string;
    status: string;
    summary: string;
    message: string;
  }> = editorial?.guides || [];

  return (
    <div className="space-y-8 animate-fade-in max-w-5xl mx-auto">
      <Breadcrumbs items={[{ label: "Cẩm Nang & Hướng Dẫn" }]} />

      <div className="border-b border-slate-800 pb-6">
        <div className="flex items-center gap-3 mb-2">
          <span className="rounded-full border border-sky-500/30 bg-sky-500/10 px-3 py-0.5 text-xs font-semibold text-sky-400">
            Nội dung biên tập
          </span>
          <span className="rounded-full border border-slate-700 bg-slate-800 px-2.5 py-0.5 text-xs text-slate-400 font-mono">
            Tách biệt dữ liệu game
          </span>
        </div>
        <h1 className="text-3xl font-extrabold text-white tracking-tight">
          Cẩm Nang & Hướng Dẫn Thực Chiến
        </h1>
        <p className="mt-2 text-sm text-slate-400">
          Tài liệu phân tích chuyên sâu, cẩm nang xây dựng đội hình và mẹo tối ưu hóa tài nguyên cho người chơi Siêu Anh Hùng Hội Tụ.
        </p>
      </div>

      {/* Guide Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {guides.map((g) => (
          <Link
            key={g.id}
            href={`/guides/${g.id}`}
            className="group relative flex flex-col justify-between rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur transition-all duration-300 hover:-translate-y-1 hover:border-sky-500/50 hover:bg-slate-900/80"
          >
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="rounded-full border border-slate-700 bg-slate-800 px-2.5 py-0.5 text-[11px] font-medium text-slate-300">
                  {g.category}
                </span>
                <span className="rounded-full border border-amber-500/30 bg-amber-500/10 px-2 py-0.5 text-[10px] text-amber-400 font-medium">
                  {g.status === "draft" ? "Bản thảo" : "Đã xuất bản"}
                </span>
              </div>

              <h2 className="text-lg font-bold text-white group-hover:text-sky-400 transition-colors">
                {g.title}
              </h2>

              <p className="text-xs text-slate-400 leading-relaxed line-clamp-3">
                {g.summary}
              </p>
            </div>

            <div className="mt-6 pt-4 border-t border-slate-800/80 flex items-center justify-between text-xs text-sky-400 font-semibold">
              <span>Đọc bài viết</span>
              <span className="group-hover:translate-x-1 transition-transform">→</span>
            </div>
          </Link>
        ))}
      </div>

      {/* Contribution notice */}
      <div className="rounded-2xl border border-slate-800 bg-slate-900/40 p-6 backdrop-blur space-y-2">
        <h3 className="font-bold text-white text-sm">Đóng Góp Bài Hướng Dẫn</h3>
        <p className="text-xs text-slate-400 leading-relaxed">
          Các bài viết hướng dẫn được lưu trữ độc lập tại <code className="font-mono text-slate-300">src/data/editorial_data.json</code> để đảm bảo phân tách rõ ràng giữa cấu hình gốc của game và kinh nghiệm của người chơi.
        </p>
      </div>
    </div>
  );
}
