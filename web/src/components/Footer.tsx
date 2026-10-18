// web/src/components/Footer.tsx
import React from "react";
import Link from "next/link";

export default function Footer() {
  return (
    <footer className="border-t border-gray-800/80 bg-gray-950/60 mt-20 text-gray-400 text-sm">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          
          {/* Brand Info */}
          <div className="md:col-span-2 space-y-3">
            <div className="flex items-center gap-2">
              <div className="w-7 h-7 rounded-lg bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center font-bold text-white text-xs">
                SA
              </div>
              <span className="font-extrabold text-white text-base">Siêu Anh Hùng Hội Tụ WIKI</span>
            </div>
            <p className="text-xs text-gray-400 leading-relaxed max-w-md">
              Kho tri thức dữ liệu game mobile Siêu Anh Hùng Hội Tụ. Trích xuất tĩnh bảo toàn 100% cấu hình client gốc, kiểm định tính toàn vẹn đa mốc, loại bỏ hoàn toàn suy diễn không có căn cứ.
            </p>
            <div className="flex items-center gap-2 text-xs text-emerald-400 font-mono">
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
              <span>Dữ liệu đã xác minh: 721 tướng • 10.836 kỹ năng • 4.366 trang bị</span>
            </div>
          </div>

          {/* Quick Links */}
          <div>
            <h4 className="text-xs font-semibold text-gray-200 uppercase tracking-wider mb-3">
              Danh Mục Dữ Liệu
            </h4>
            <ul className="space-y-2 text-xs">
              <li>
                <Link href="/heroes" className="hover:text-white transition-colors">
                  Danh Sách Tướng (721)
                </Link>
              </li>
              <li>
                <Link href="/skills" className="hover:text-white transition-colors">
                  Tra Cứu Kỹ Năng (10.836)
                </Link>
              </li>
              <li>
                <Link href="/suits" className="hover:text-white transition-colors">
                  Bộ Trang Bị (729 Suits)
                </Link>
              </li>
              <li>
                <Link href="/equipment" className="hover:text-white transition-colors">
                  Kho Trang Bị (4.366)
                </Link>
              </li>
              <li>
                <Link href="/ban-suc" className="hover:text-white transition-colors">
                  Ban Sức & Huy Hiệu
                </Link>
              </li>
            </ul>
          </div>

          {/* Editorial & Rules */}
          <div>
            <h4 className="text-xs font-semibold text-gray-200 uppercase tracking-wider mb-3">
              Biên Tập & Kiểm Định
            </h4>
            <ul className="space-y-2 text-xs">
              <li>
                <Link href="/tier-list" className="hover:text-white transition-colors">
                  Bảng Xếp Hạng (Tier List)
                </Link>
              </li>
              <li>
                <Link href="/guides" className="hover:text-white transition-colors">
                  Cẩm Nang Nhập Môn
                </Link>
              </li>
              <li>
                <span className="text-gray-500">
                  Phiên bản Pipeline: 1.2.0
                </span>
              </li>
              <li>
                <span className="text-gray-500">
                  APK Target SDK: 28 (v1.9)
                </span>
              </li>
            </ul>
          </div>

        </div>

        <div className="border-t border-gray-800/60 mt-10 pt-6 flex flex-col sm:flex-row items-center justify-between text-xs text-gray-500 gap-4">
          <p>© 2026 Siêu Anh Hùng Hội Tụ WIKI. Dữ liệu phục vụ nghiên cứu và cộng đồng người chơi.</p>
          <p className="flex items-center gap-1.5">
            <span className="inline-block w-1.5 h-1.5 rounded-full bg-indigo-500"></span>
            <span>Tài nguyên ảnh độc lập từ /assets/</span>
          </p>
        </div>
      </div>
    </footer>
  );
}
