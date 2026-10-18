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
    <nav className="flex items-center text-xs text-gray-400 py-3 space-x-2" aria-label="Breadcrumb">
      <Link href="/" className="hover:text-indigo-400 transition-colors flex items-center gap-1">
        <span>🏠</span>
        <span>Trang chủ</span>
      </Link>
      {items.map((item, idx) => (
        <React.Fragment key={idx}>
          <span className="text-gray-600">/</span>
          {item.href ? (
            <Link href={item.href} className="hover:text-indigo-400 transition-colors">
              {item.label}
            </Link>
          ) : (
            <span className="text-gray-200 font-medium truncate max-w-xs">{item.label}</span>
          )}
        </React.Fragment>
      ))}
    </nav>
  );
}
