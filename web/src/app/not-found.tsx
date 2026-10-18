// web/src/app/not-found.tsx
import Link from "next/link";

export default function NotFound() {
  return (
    <div className="min-h-[60vh] flex flex-col items-center justify-center text-center space-y-6 animate-fade-in">
      <div className="h-20 w-20 rounded-3xl bg-slate-900 border border-slate-800 flex items-center justify-center text-4xl shadow-xl">
        🔍
      </div>

      <div className="space-y-2">
        <h1 className="text-3xl font-extrabold text-white">404 - Không Tìm Thấy Trang</h1>
        <p className="text-sm text-slate-400 max-w-md">
          Dữ liệu hoặc trang bạn tìm kiếm không tồn tại trong hệ thống hoặc mã định danh chưa được ánh xạ trong cấu hình game hiện tại.
        </p>
      </div>

      <div className="flex flex-wrap items-center justify-center gap-3">
        <Link
          href="/"
          className="rounded-xl bg-sky-500 px-5 py-2.5 text-xs font-semibold text-white hover:bg-sky-400 transition-colors shadow-lg shadow-sky-500/20"
        >
          Trang Chủ
        </Link>
        <Link
          href="/heroes"
          className="rounded-xl border border-slate-700 bg-slate-800 px-5 py-2.5 text-xs font-semibold text-slate-300 hover:bg-slate-700 transition-colors"
        >
          Danh Mục Tướng
        </Link>
      </div>
    </div>
  );
}
