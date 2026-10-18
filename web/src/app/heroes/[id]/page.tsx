// web/src/app/heroes/[id]/page.tsx
import React from "react";
import { notFound } from "next/navigation";
import Breadcrumbs from "@/components/Breadcrumbs";
import HeroInteractiveView from "@/components/HeroInteractiveView";
import { getHeroById } from "@/lib/data";

export const dynamic = "force-dynamic";

interface PageProps {
  params: Promise<{ id: string }>;
}

export async function generateMetadata({ params }: PageProps) {
  const { id } = await params;
  const hero = getHeroById(id);
  if (!hero) {
    return { title: `Tướng #${id} - Không tìm thấy` };
  }
  return {
    title: `${hero.name || `Tướng #${id}`} (ID: ${id}) - Siêu Anh Hùng Hội Tụ WIKI`,
    description: `Chi tiết 7 mốc chuyển sinh, siêu tiến hóa vàng/đỏ, kích hoạt vận mệnh và mô phỏng chỉ số level 1 - 255 của ${hero.name || `Tướng #${id}`}.`,
  };
}

export default async function HeroDetailPage({ params }: PageProps) {
  const { id } = await params;
  const hero = getHeroById(id);

  if (!hero) {
    notFound();
  }

  return (
    <div className="space-y-8 animate-fade-in">
      <Breadcrumbs
        items={[
          { label: "Danh Sách Tướng", href: "/heroes" },
          { label: `${hero.name || `Tướng #${id}`} (ID: ${id})` },
        ]}
      />

      <HeroInteractiveView hero={hero} />
    </div>
  );
}
