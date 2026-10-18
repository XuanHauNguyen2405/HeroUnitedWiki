// web/src/components/Header.tsx
"use client";

import React, { useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import SearchBar from "./SearchBar";

export default function Header() {
  const pathname = usePathname();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navLinks = [
    { href: "/heroes", label: "Tướng", icon: "👤" },
    { href: "/skills", label: "Kỹ Năng", icon: "⚡" },
    { href: "/suits", label: "Bộ Trang Bị", icon: "🛡️" },
    { href: "/equipment", label: "Trang Bị", icon: "⚔️" },
    { href: "/ban-suc", label: "Ban Sức", icon: "🔮" },
    { href: "/tier-list", label: "Tier List", icon: "🏆" },
    { href: "/guides", label: "Cẩm Nang", icon: "📖" },
  ];

  return (
    <header className="sticky top-0 z-40 bg-gray-950/80 backdrop-blur-xl border-b border-gray-800/80 transition-all">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16 gap-4">
          
          {/* Logo & Brand */}
          <Link href="/" className="flex items-center gap-3 flex-shrink-0 group">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-indigo-500 via-purple-600 to-pink-500 flex items-center justify-center font-black text-white text-base shadow-lg shadow-indigo-500/20 group-hover:scale-105 transition-transform">
              SA
            </div>
            <div>
              <div className="text-base font-extrabold tracking-tight text-white flex items-center gap-1.5">
                <span>SAHHT WIKI</span>
                <span className="text-[10px] px-1.5 py-0.2 font-semibold bg-indigo-500/20 text-indigo-300 border border-indigo-500/30 rounded">
                  v1.2
                </span>
              </div>
              <div className="text-[10px] text-gray-400 font-medium tracking-wide">
                Siêu Anh Hùng Hội Tụ
              </div>
            </div>
          </Link>

          {/* Desktop Search */}
          <div className="hidden md:block flex-1 max-w-md mx-4">
            <SearchBar placeholder="Tìm kiếm tướng, kỹ năng, trang bị..." />
          </div>

          {/* Desktop Navigation Links */}
          <nav className="hidden lg:flex items-center gap-1 text-sm font-medium">
            {navLinks.map((item) => {
              const isActive = pathname.startsWith(item.href);
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  className={`flex items-center gap-1.5 px-3 py-2 rounded-lg transition-colors ${
                    isActive
                      ? "bg-indigo-600/20 text-indigo-400 border border-indigo-500/30 font-semibold"
                      : "text-gray-300 hover:text-white hover:bg-gray-900/60"
                  }`}
                >
                  <span className="text-sm">{item.icon}</span>
                  <span>{item.label}</span>
                </Link>
              );
            })}
          </nav>

          {/* Mobile Menu Button */}
          <div className="flex lg:hidden items-center gap-2">
            <button
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
              className="p-2 rounded-lg bg-gray-900 text-gray-300 hover:text-white border border-gray-800"
              aria-label="Toggle menu"
            >
              {mobileMenuOpen ? "✕" : "☰"}
            </button>
          </div>

        </div>

        {/* Mobile Search Input (Visible only on mobile/tablet) */}
        <div className="block md:hidden pb-3">
          <SearchBar placeholder="Tìm kiếm nhanh..." />
        </div>
      </div>

      {/* Mobile Menu Drawer */}
      {mobileMenuOpen && (
        <div className="lg:hidden border-t border-gray-800 bg-gray-950/95 px-4 pt-3 pb-6 space-y-1">
          {navLinks.map((item) => {
            const isActive = pathname.startsWith(item.href);
            return (
              <Link
                key={item.href}
                href={item.href}
                onClick={() => setMobileMenuOpen(false)}
                className={`flex items-center gap-3 px-3 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                  isActive
                    ? "bg-indigo-600/20 text-indigo-400 border border-indigo-500/30 font-semibold"
                    : "text-gray-300 hover:text-white hover:bg-gray-900"
                }`}
              >
                <span className="text-base">{item.icon}</span>
                <span>{item.label}</span>
              </Link>
            );
          })}
        </div>
      )}
    </header>
  );
}
