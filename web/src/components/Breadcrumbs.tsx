// web/src/components/Breadcrumbs.tsx
import React from "react";
import Link from "next/link";

export interface Crumb {
  label: string;
  href?: string;
}

interface BreadcrumbsProps {
  items: Crumb[];
}

export default function Breadcrumbs({ items }: BreadcrumbsProps) {
  return (
    <nav
      className="inline-flex flex-wrap items-center gap-2 text-xs text-slate-400 bg-slate-900/50 border border-slate-800/80 px-3.5 py-2 rounded-xl backdrop-blur-sm"
      aria-label="Breadcrumb"
    >
      <Link href="/" className="hover:text-indigo-400 transition-colors flex items-center gap-1.5 font-medium text-slate-300">
        <span>🏠</span>
        <span>Trang chủ</span>
      </Link>
      {items.map((item, idx) => (
        <React.Fragment key={idx}>
          <span className="text-slate-600 select-none">›</span>
          {item.href ? (
            <Link href={item.href} className="hover:text-indigo-400 transition-colors font-medium text-slate-300">
              {item.label}
            </Link>
          ) : (
            <span className="text-indigo-300 font-semibold truncate max-w-xs sm:max-w-md">{item.label}</span>
          )}
        </React.Fragment>
      ))}
    </nav>
  );
}
