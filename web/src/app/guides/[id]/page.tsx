// web/src/app/guides/[id]/page.tsx
import { notFound } from "next/navigation";
import Link from "next/link";
import { getEditorialData } from "@/lib/data";
import Breadcrumbs from "@/components/Breadcrumbs";

export const dynamic = "force-dynamic";

export async function generateMetadata({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const editorial = getEditorialData();
  const guide = editorial?.guides?.find((g: any) => g.id === id);
  if (!guide) return { title: "Không tìm thấy bài viết | SAHHT Wiki" };
  return {
    title: `${guide.title} - Cẩm Nang SAHHT WIKI`,
    description: guide.summary,
  };
}

export default async function GuideDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const editorial = getEditorialData();
  const guide = editorial?.guides?.find((g: any) => g.id === id);

  if (!guide) {
    notFound();
  }

  return (
    <div className="space-y-8 animate-fade-in max-w-4xl mx-auto">
      <Breadcrumbs
        items={[
          { label: "Cẩm Nang", href: "/guides" },
          { label: guide.title },
        ]}
      />

      <div className="border-b border-slate-800 pb-6 space-y-3">
        <div className="flex items-center gap-2">
          <span className="rounded-full border border-sky-500/30 bg-sky-500/10 px-3 py-0.5 text-xs font-semibold text-sky-400">
            {guide.category}
          </span>
          <span className="rounded-full border border-amber-500/30 bg-amber-500/10 px-2.5 py-0.5 text-xs text-amber-400 font-medium">
            {guide.status === "draft" ? "Trạng thái: Bản Thảo" : "Đã xuất bản"}
          </span>
        </div>

        <h1 className="text-3xl md:text-4xl font-extrabold text-white tracking-tight">
          {guide.title}
        </h1>

        <p className="text-base text-slate-300 leading-relaxed">
          {guide.summary}
        </p>
      </div>

      {/* Draft State Notice */}
      <div className="rounded-2xl border border-amber-500/30 bg-amber-950/20 p-8 backdrop-blur text-center space-y-4">
        <div className="inline-flex h-12 w-12 items-center justify-center rounded-2xl bg-amber-500/10 text-2xl text-amber-400">
          📝
        </div>
        <h2 className="text-xl font-bold text-white">Nội Dung Đang Được Biên Tập</h2>
        <p className="text-sm text-slate-400 max-w-md mx-auto leading-relaxed">
          {guide.message || "Bài viết này đang được nhóm biên tập viên nghiên cứu, đối chiếu và hoàn thiện nội dung. Vui lòng quay lại sau."}
        </p>
        <div className="pt-2">
          <Link
            href="/guides"
            className="inline-flex items-center gap-2 rounded-xl border border-slate-700 bg-slate-800 px-4 py-2 text-xs font-semibold text-slate-300 hover:bg-slate-700 transition-colors"
          >
            ← Quay lại danh mục cẩm nang
          </Link>
        </div>
      </div>
    </div>
  );
}
