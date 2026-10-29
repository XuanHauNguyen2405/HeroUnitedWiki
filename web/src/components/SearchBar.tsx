// web/src/components/SearchBar.tsx
"use client";

import React, { useState, useEffect, useRef } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import ImageWithFallback from "./ImageWithFallback";

interface SearchResult {
  id: string;
  title: string;
  category: "hero" | "skill" | "suit" | "equipment";
  category_name: string;
  url: string;
  image: string | null;
  badge: string;
  subtext: string;
}

interface SearchBarProps {
  placeholder?: string;
  className?: string;
  autoFocus?: boolean;
  large?: boolean;
}

export default function SearchBar({
  placeholder = "Tìm tướng, kỹ năng, bộ trang bị... (có hoặc không dấu)",
  className = "",
  autoFocus = false,
  large = false,
}: SearchBarProps) {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState<SearchResult[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isOpen, setIsOpen] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);
  const router = useRouter();

  // Global hotkey: press '/' to focus search
  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (
        e.key === "/" &&
        document.activeElement !== inputRef.current &&
        !["INPUT", "TEXTAREA"].includes((document.activeElement as HTMLElement)?.tagName)
      ) {
        e.preventDefault();
        inputRef.current?.focus();
      } else if (e.key === "Escape") {
        setIsOpen(false);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, []);

  // Handle click outside to close dropdown
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (containerRef.current && !containerRef.current.contains(event.target as Node)) {
        setIsOpen(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // Debounced search
  useEffect(() => {
    if (!query.trim()) {
      setResults([]);
      setIsLoading(false);
      return;
    }

    setIsLoading(true);
    const timer = setTimeout(async () => {
      try {
        const res = await fetch(`/api/search?q=${encodeURIComponent(query)}&limit=8`);
        if (res.ok) {
          const data = await res.json();
          setResults(data.results || []);
          setIsOpen(true);
        }
      } catch (err) {
        console.error("Search failed:", err);
      } finally {
        setIsLoading(false);
      }
    }, 200);

    return () => clearTimeout(timer);
  }, [query]);

  const handleSelect = (url: string) => {
    setIsOpen(false);
    setQuery("");
    router.push(url);
  };

  const getCategoryBadgeClass = (category: string) => {
    switch (category) {
      case "hero":
        return "bg-purple-900/60 text-purple-300 border-purple-700/50";
      case "skill":
        return "bg-amber-900/60 text-amber-300 border-amber-700/50";
      case "suit":
        return "bg-emerald-900/60 text-emerald-300 border-emerald-700/50";
      case "equipment":
        return "bg-blue-900/60 text-blue-300 border-blue-700/50";
      default:
        return "bg-gray-800 text-gray-300 border-gray-700";
    }
  };

  return (
    <div ref={containerRef} className={`relative w-full ${className}`}>
      <div
        className={`relative flex items-center bg-slate-900/85 hover:bg-slate-900 border border-slate-700/70 hover:border-slate-600/80 rounded-xl transition-all shadow-inner focus-within:border-indigo-500 focus-within:bg-slate-900 focus-within:ring-2 focus-within:ring-indigo-500/25 ${
          large ? "px-4 py-3.5 text-base" : "px-3 py-2 text-xs sm:text-sm"
        }`}
      >
        <span className="text-slate-400 pr-2.5 select-none flex-shrink-0">
          {isLoading ? (
            <svg
              className="animate-spin h-4 w-4 text-indigo-400"
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
            >
              <circle
                className="opacity-25"
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                strokeWidth="4"
              ></circle>
              <path
                className="opacity-75"
                fill="currentColor"
                d="M4 12a8 8 0 018-8v8H4z"
              ></path>
            </svg>
          ) : (
            <svg
              className={large ? "h-5 w-5" : "h-4 w-4"}
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={2}
                d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
              />
            </svg>
          )}
        </span>

        <input
          ref={inputRef}
          type="text"
          value={query}
          onChange={(e) => {
            setQuery(e.target.value);
            setIsOpen(true);
          }}
          onFocus={() => {
            if (query.trim()) setIsOpen(true);
          }}
          placeholder={placeholder}
          autoFocus={autoFocus}
          className="w-full min-w-0 bg-transparent text-gray-100 placeholder-slate-400 focus:outline-none truncate"
        />

        {query ? (
          <button
            type="button"
            onClick={() => {
              setQuery("");
              setResults([]);
              setIsOpen(false);
            }}
            className="text-slate-400 hover:text-gray-200 pl-2 flex-shrink-0"
          >
            ✕
          </button>
        ) : (
          <kbd className="hidden sm:inline-flex items-center justify-center px-1.5 py-0.5 ml-2 text-[10px] font-mono text-slate-400 bg-slate-800/90 border border-slate-700/80 rounded-md select-none flex-shrink-0">
            /
          </kbd>
        )}
      </div>

      {/* Results Dropdown */}
      {isOpen && query.trim() && (
        <div className="absolute top-full left-0 right-0 mt-2 bg-gray-900/95 backdrop-blur-xl border border-gray-700/80 rounded-xl shadow-2xl overflow-hidden z-50 max-h-96 overflow-y-auto">
          {results.length === 0 && !isLoading ? (
            <div className="p-4 text-center text-sm text-gray-400">
              Không tìm thấy kết quả nào khớp với &ldquo;<span className="text-gray-200">{query}</span>&rdquo;.
            </div>
          ) : (
            <div className="divide-y divide-gray-800">
              <div className="px-3 py-1.5 text-[11px] font-semibold text-gray-400 uppercase tracking-wider bg-gray-950/60">
                Gợi ý nhanh ({results.length})
              </div>
              {results.map((item) => (
                <div
                  key={`${item.category}-${item.id}`}
                  onClick={() => handleSelect(item.url)}
                  className="flex items-center gap-3 p-3 hover:bg-gray-800/80 cursor-pointer transition-colors"
                >
                  <div className="w-10 h-10 flex-shrink-0 bg-gray-950 rounded-lg overflow-hidden border border-gray-800 flex items-center justify-center">
                    {item.image ? (
                      <ImageWithFallback
                        src={item.image}
                        alt={item.title}
                        className="w-full h-full object-cover"
                        fallbackText="No Pic"
                        fallbackIcon="✨"
                      />
                    ) : (
                      <span className="text-base">
                        {item.category === "suit" ? "👘" : "📦"}
                      </span>
                    )}
                  </div>

                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2">
                      <span className="font-semibold text-gray-100 text-sm truncate">
                        {item.title}
                      </span>
                      <span
                        className={`text-[10px] px-1.5 py-0.5 rounded border font-medium uppercase tracking-wider ${getCategoryBadgeClass(
                          item.category
                        )}`}
                      >
                        {item.category_name}
                      </span>
                    </div>
                    <div className="text-xs text-gray-400 truncate mt-0.5">
                      {item.subtext}
                    </div>
                  </div>

                  <div className="text-xs text-gray-500 font-mono flex-shrink-0">
                    #{item.id}
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>
      )}
    </div>
  );
}
