// web/src/lib/utils.ts

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
  const q = quality || 1;
  switch (q) {
    case 5:
      return {
        name: "Phẩm 5 (Cam/Đỏ)",
        badgeClass: "bg-amber-500/15 text-amber-400 border-amber-500/30",
        textClass: "text-amber-400",
        borderClass: "border-amber-500/40",
        bgGlow: "rgba(245, 158, 11, 0.15)",
      };
    case 4:
      return {
        name: "Phẩm 4 (Tím)",
        badgeClass: "bg-purple-500/15 text-purple-400 border-purple-500/30",
        textClass: "text-purple-400",
        borderClass: "border-purple-500/40",
        bgGlow: "rgba(168, 85, 247, 0.15)",
      };
    case 3:
      return {
        name: "Phẩm 3 (Lam đậm)",
        badgeClass: "bg-indigo-500/15 text-indigo-400 border-indigo-500/30",
        textClass: "text-indigo-400",
        borderClass: "border-indigo-500/40",
        bgGlow: "rgba(99, 102, 241, 0.15)",
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
        name: "Phẩm 1 (Lục/Thường)",
        badgeClass: "bg-emerald-500/15 text-emerald-400 border-emerald-500/30",
        textClass: "text-emerald-400",
        borderClass: "border-emerald-500/40",
        bgGlow: "rgba(16, 185, 129, 0.15)",
      };
  }
}

export function getSlotLabel(slot: number | null | undefined): string {
  switch (slot) {
    case 1:
      return "Vũ khí";
    case 2:
      return "Trang sức";
    case 3:
      return "Giáp/Áo";
    case 4:
      return "Giày";
    default:
      return "Chưa xác minh";
  }
}
