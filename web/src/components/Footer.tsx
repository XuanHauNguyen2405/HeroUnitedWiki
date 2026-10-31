// web/src/components/Footer.tsx
import React from "react";
import Link from "next/link";

export default function Footer() {
  return (
    <footer className="border-t border-slate-800/80 bg-[#050810] mt-20 text-slate-400 text-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          
          {/* Brand Info */}
          <div className="md:col-span-2 space-y-3">
            <div className="flex items-center gap-2.5">
              <div className="w-8 h-8 rounded-xl bg-gradient-to-br from-indigo-500 via-purple-600 to-pink-500 flex items-center justify-center font-black text-white text-xs shadow-md shadow-indigo-500/20">
                SA
              </div>
              <span className="font-extrabold text-white text-base tracking-tight">Siêu Anh Hùng Hội Tụ WIKI</span>
            </div>
            <p className="text-xs text-slate-400 leading-relaxed max-w-md">
              Kho tri thức dữ liệu game mobile Siêu Anh Hùng Hội Tụ. Trích xuất tĩnh bảo toàn 100% cấu hình client gốc, kiểm định tính toàn vẹn đa mốc, loại bỏ hoàn toàn suy diễn không có căn cứ.
            </p>
            <div className="inline-flex items-center gap-2 text-xs text-emerald-400 font-medium bg-emerald-950/40 border border-emerald-500/25 px-3 py-1.5 rounded-full">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              <span>Dữ liệu đã xác minh: 721 bản thể tướng • 729 bộ trang bị • 112 huy hiệu</span>
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-xs font-bold text-slate-200 uppercase tracking-wider mb-3">
              Danh Mục Tra Cứu
            </h4>
            <ul className="space-y-2.5 text-xs">
              <li>
                <Link href="/heroes" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5">
                  <span>👤</span>
                  <span>Danh Sách Tướng (721)</span>
                </Link>
              </li>
              <li>
                <Link href="/suits" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5">
                  <span>🛡️</span>
                  <span>Bộ Trang Bị (729 Suits)</span>
                </Link>
              </li>
              <li>
                <Link href="/ban-suc" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5">
                  <span>🔮</span>
                  <span>Ban Sức & Huy Hiệu</span>
                </Link>
              </li>
            </ul>
          </div>

          {/* Editorial & Rules */}
          <div>
            <h4 className="text-xs font-bold text-slate-200 uppercase tracking-wider mb-3">
              Biên Tập & Chiến Thuật
            </h4>
            <ul className="space-y-2.5 text-xs">
              <li>
                <Link href="/tier-list" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5">
                  <span>🏆</span>
                  <span>Bảng Xếp Hạng (Tier List)</span>
                </Link>
              </li>
              <li>
                <Link href="/guides" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5">
                  <span>📖</span>
                  <span>Cẩm Nang Nhập Môn</span>
                </Link>
              </li>
              <li className="pt-1 text-slate-500">
                Phiên bản Pipeline: 1.2.0 • APK v1.9
              </li>
            </ul>
          </div>

        </div>

        <div className="border-t border-slate-800/60 mt-10 pt-6 flex flex-col sm:flex-row items-center justify-between text-xs text-slate-500 gap-4">
          <p>© 2026 Siêu Anh Hùng Hội Tụ WIKI. Dữ liệu phục vụ nghiên cứu và cộng đồng người chơi.</p>
          <p className="flex items-center gap-1.5">
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-indigo-500"></span>
            <span>Tài nguyên ảnh trích xuất nguyên bản từ APK</span>
          </p>
        </div>
      </div>
    </footer>
  );
}
