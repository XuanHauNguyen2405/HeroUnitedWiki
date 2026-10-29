// web/src/lib/utils.ts
import { slots } from "./game-attributes";

export function stripVietnameseAccents(str: string | null | undefined): string {
  if (!str) return "";
  return str
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/đ/g, "d")
    .replace(/Đ/g, "d")
    .toLowerCase()
    .trim();
}

export function formatNumber(num: number | null | undefined): string {
  if (num === null || num === undefined) return "0";
  return new Intl.NumberFormat("vi-VN").format(num);
}

export interface QualityConfig {
  name: string;
  badgeClass: string;
  textClass: string;
  borderClass: string;
  bgGlow: string;
}

export function getQualityConfig(quality: number | null | undefined): QualityConfig {
  const q = quality;
  if (q == null || q === 0 || q < 0 || q > 8) return {
    name: q === 0 ? "Phẩm 0" : "Chưa xác minh phẩm chất",
    badgeClass: "bg-slate-800 text-slate-300 border-slate-600", textClass: "text-slate-300",
    borderClass: "border-slate-600", bgGlow: "transparent",
  };
  switch (q) {
    case 6:
    case 7:
    case 8:
      return {
        name: `Phẩm ${q} (${q === 6 ? "Vàng" : q === 7 ? "Màu" : "Cầu vồng"})`,
        badgeClass: "bg-yellow-500/15 text-yellow-300 border-yellow-500/30",
        textClass: "text-yellow-300", borderClass: "border-yellow-500/40", bgGlow: "rgba(250, 204, 21, 0.15)",
      };
    case 5:
      return {
        name: "Phẩm 5 (Đỏ)",
        badgeClass: "bg-red-500/15 text-red-400 border-red-500/30",
        textClass: "text-red-400",
        borderClass: "border-red-500/40",
        bgGlow: "rgba(239, 68, 68, 0.15)",
      };
    case 4:
      return {
        name: "Phẩm 4 (Cam)",
        badgeClass: "bg-amber-500/15 text-amber-400 border-amber-500/30",
        textClass: "text-amber-400",
        borderClass: "border-amber-500/40",
        bgGlow: "rgba(245, 158, 11, 0.15)",
      };
    case 3:
      return {
        name: "Phẩm 3 (Tím)",
        badgeClass: "bg-purple-500/15 text-purple-400 border-purple-500/30",
        textClass: "text-purple-400",
        borderClass: "border-purple-500/40",
        bgGlow: "rgba(168, 85, 247, 0.15)",
      };
    case 2:
      return {
        name: "Phẩm 2 (Lam)",
        badgeClass: "bg-blue-500/15 text-blue-400 border-blue-500/30",
        textClass: "text-blue-400",
        borderClass: "border-blue-500/40",
        bgGlow: "rgba(59, 130, 246, 0.15)",
      };
    case 1:
    default:
      return {
        name: "Phẩm 1 (Lục)",
        badgeClass: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
        textClass: "text-emerald-400",
        borderClass: "border-emerald-500/40",
        bgGlow: "rgba(16, 185, 129, 0.15)",
      };
  }
}

export function getSlotLabel(slot: number | null | undefined): string {
  return slot != null ? slots[String(slot)] ?? "Chưa xác minh" : "Chưa xác minh";
}
