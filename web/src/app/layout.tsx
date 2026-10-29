// web/src/app/layout.tsx
import type { Metadata } from "next";
import { Suspense } from "react";
import "./globals.css";
import "./hero-ui.css";
import Header from "@/components/Header";
import Footer from "@/components/Footer";

export const metadata: Metadata = {
  title: "Siêu Anh Hùng Hội Tụ WIKI - Kho Dữ Liệu Game Chính Thức",
  description:
    "Kho tra cứu thông tin tướng, kỹ năng, trang bị, bộ trang bị, ban sức và cơ chế nâng cấp game mobile Siêu Anh Hùng Hội Tụ. Trích xuất tĩnh bảo toàn 100% cấu hình nguồn.",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="vi" className="dark">
      <body className="bg-[#070a12] text-gray-100 min-h-screen flex flex-col antialiased selection:bg-indigo-600 selection:text-white">
        <Suspense fallback={<div className="h-16 bg-slate-900/60 border-b border-slate-800" />}>
          <Header />
        </Suspense>
        <main className="flex-1 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          {children}
        </main>
        <Footer />
      </body>
    </html>
  );
}
