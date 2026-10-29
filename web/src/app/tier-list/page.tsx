// web/src/app/tier-list/page.tsx
import { getTierListData } from "@/lib/data";
import TierListInteractiveView from "@/components/TierListInteractiveView";

export const metadata = {
  title: "Bảng Xếp Hạng Tướng (Tier List) Meta Mới Nhất | SAHHT WIKI",
  description:
    "Bảng xếp hạng sức mạnh thực chiến tướng Siêu Anh Hùng Hội Tụ. Phân chia rõ rệt giữa Dealer (Sát thương) và Support & Hybrid (Hỗ trợ đa dụng) từ UBER đến Tier 4.",
};

export default function TierListPage() {
  const tierData = getTierListData();

  return (
    <div className="py-6 animate-fade-in max-w-7xl mx-auto px-2 sm:px-4">
      <TierListInteractiveView initialData={tierData} />
    </div>
  );
}
