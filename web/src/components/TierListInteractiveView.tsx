"use client";

import React, { useMemo } from "react";
import Link from "next/link";
import { TierListData, TierListHero } from "@/lib/data";

interface TierListInteractiveViewProps {
  initialData: TierListData;
}

export default function TierListInteractiveView({ initialData }: TierListInteractiveViewProps) {
  const dealerHeroes = initialData.groups[0]?.heroes || [];
  const supportHeroes = initialData.groups[1]?.heroes || [];

  // Dealer rows definition for vector rendering
  const dealerGrid = useMemo(() => {
    const heroesMap: Record<string, TierListHero> = {};
    for (const h of dealerHeroes) {
      heroesMap[h.name] = h;
    }

    return {
      title: "DEALER",
      rows: [
        {
          tier: "UBER",
          tierBg: "bg-[#d60000]",
          tierColor: "text-white",
          isSplit: true,
          cell1: heroesMap["CT Tenka"],
          tier2: "TIER 0",
          tier2Bg: "bg-[#bf3900]",
          tier2Color: "text-white",
          restCells: [heroesMap["CT Sasuke"], heroesMap["CT Shamrock"], heroesMap["Vegeta (Fusion)"]],
        },
        {
          tier: "TIER 1",
          tierBg: "bg-[#eb6100]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["CT-Zoro"],
            heroesMap["CT-Newgate"],
            heroesMap["Vegetto"],
            heroesMap["CT-Shalltear"],
            heroesMap["CT-Tanjiro"],
          ],
        },
        {
          tier: "TIER 2",
          tierBg: "bg-[#f5a623]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["Sasuke"],
            heroesMap["Shanks"],
            heroesMap["Zoro"],
            heroesMap["CT-Gojo"],
            heroesMap["Tanjiro"],
          ],
        },
        {
          tier: "TIER 3",
          tierBg: "bg-[#9ecf8d]",
          tierColor: "text-white",
          isSplit: false,
          cells: [
            heroesMap["Tohka"],
            heroesMap["Râu Trắng"],
            heroesMap["Kenpachi"],
            heroesMap["CT-Rimuru"],
            heroesMap["Kikyo"],
          ],
        },
      ],
    };
  }, [dealerHeroes]);

  // Support rows definition for vector rendering
  const supportGrid = useMemo(() => {
    const heroesMap: Record<string, TierListHero> = {};
    for (const h of supportHeroes) {
      heroesMap[h.name] = h;
    }

    return {
      title: "SUPPORT + HYBRID",
      rows: [
        {
          tier: "UBER",
          tierBg: "bg-[#d60000]",
          tierColor: "text-white",
          cells: [heroesMap["CT Nagato"], heroesMap["CT Shadow"], null, null, null],
        },
        {
          tier: "TIER 0",
          tierBg: "bg-[#bf3900]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Trunks"],
            heroesMap["CT-Broli"],
            heroesMap["CT-Kakarot"],
            heroesMap["CT-Elaina"],
            heroesMap["CT-Frieren"],
          ],
        },
        {
          tier: "TIER 1",
          tierBg: "bg-[#eb6100]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Gohan"],
            heroesMap["Piccolo"],
            heroesMap["CT-Meliodas"],
            heroesMap["MG-Maple"],
            heroesMap["Số 18"],
          ],
        },
        {
          tier: "TIER 2",
          tierBg: "bg-[#f5a623]",
          tierColor: "text-white",
          cells: [
            heroesMap["CT-Inori"],
            heroesMap["Kakarot SSJ3"],
            heroesMap["CT-Luffy Nika"],
            heroesMap["CT-Kanae"],
            heroesMap["Cid Kagenou"],
          ],
        },
        {
          tier: "TIER 3",
          tierBg: "bg-[#9ecf8d]",
          tierColor: "text-white",
          cells: [
            heroesMap["Pain"],
            heroesMap["Broli"],
            heroesMap["Meliodas"],
            heroesMap["Frieren"],
            heroesMap["Elaina"],
          ],
        },
        {
          tier: "TIER 4",
          tierBg: "bg-[#7eaddf]",
          tierColor: "text-white",
          cells: [
            heroesMap["Trunks"],
            heroesMap["Inori"],
            heroesMap["Maple"],
            heroesMap["Shinobu"],
            heroesMap["Yachiru"],
          ],
        },
      ],
    };
  }, [supportHeroes]);

  // Helper to render an individual hero cell in the vector table
  const renderHeroCell = (hero: TierListHero | null | undefined) => {
    if (!hero) {
      return <div className="relative bg-white h-full w-full" />;
    }

    const imgSrc = hero.image_3x || hero.image_2x || hero.image;

    return (
      <Link
        href={hero.url}
        key={hero.id}
        title={`${hero.name} (${hero.game_name}) - Bấm để xem chi tiết`}
        className="group relative flex flex-col bg-[#cf8527] transition-all duration-200 overflow-hidden cursor-pointer select-none hover:z-10 hover:brightness-110"
      >
        {/* Top Sprite Area (Pure sprite crop without duplicate white name bar) */}
        <div className="relative aspect-[71/57] w-full overflow-hidden bg-[#cf8527]">
          <img
            src={imgSrc}
            alt={hero.name}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-200"
            style={{
              imageRendering: "-webkit-optimize-contrast",
            }}
            loading="eager"
          />
        </div>

        {/* Single Sharp Bottom Name Label */}
        <div className="bg-white border-t border-black py-1 px-0.5 text-center flex items-center justify-center shrink-0">
          <span className="font-bold text-[9.5px] sm:text-[11px] text-black tracking-tight leading-none whitespace-nowrap">
            {hero.name}
          </span>
        </div>
      </Link>
    );
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-start">
      {/* ==================================================== */}
      {/* BOARD 1: DEALER                                      */}
      {/* ==================================================== */}
      <div className="w-full overflow-x-auto flex justify-center">
        <div className="w-full min-w-[360px] max-w-[580px] border-2 border-black bg-black shadow-2xl">
          {/* Table Header */}
          <div className="bg-[#757575] text-[#ffd428] font-black text-center py-1.5 text-base sm:text-lg tracking-wider border-b-2 border-black uppercase">
            DEALER
          </div>

          {/* Row 0: UBER & TIER 0 */}
          <div className="grid grid-cols-6 border-b border-black">
            {/* Col 0: UBER Header */}
            <div className="bg-[#d60000] text-white font-black flex items-center justify-center p-1 text-xs sm:text-sm md:text-base border-r border-black tracking-wider">
              UBER
            </div>
            {/* Col 1: CT Tenka */}
            <div className="border-r border-black">
              {renderHeroCell(dealerGrid.rows[0].cell1)}
            </div>
            {/* Col 2: TIER 0 Header */}
            <div className="bg-[#bf3900] text-white font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center leading-tight">
              TIER 0
            </div>
            {/* Cols 3, 4, 5 */}
            <div className="border-r border-black">
              {renderHeroCell(dealerGrid.rows[0].restCells?.[0])}
            </div>
            <div className="border-r border-black">
              {renderHeroCell(dealerGrid.rows[0].restCells?.[1])}
            </div>
            <div>{renderHeroCell(dealerGrid.rows[0].restCells?.[2])}</div>
          </div>

          {/* Rows 1, 2, 3: TIER 1, TIER 2, TIER 3 */}
          {dealerGrid.rows.slice(1).map((row, idx) => (
            <div
              key={row.tier}
              className={`grid grid-cols-6 ${
                idx < dealerGrid.rows.length - 2 ? "border-b border-black" : ""
              }`}
            >
              {/* Tier Header */}
              <div
                className={`${row.tierBg} ${row.tierColor} font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center`}
              >
                {row.tier}
              </div>
              {/* 5 Hero Cells */}
              {row.cells?.map((cell, cIdx) => (
                <div
                  key={cIdx}
                  className={cIdx < 4 ? "border-r border-black" : ""}
                >
                  {renderHeroCell(cell)}
                </div>
              ))}
            </div>
          ))}
        </div>
      </div>

      {/* ==================================================== */}
      {/* BOARD 2: SUPPORT + HYBRID                            */}
      {/* ==================================================== */}
      <div className="w-full overflow-x-auto flex justify-center">
        <div className="w-full min-w-[360px] max-w-[580px] border-2 border-black bg-black shadow-2xl">
          {/* Table Header */}
          <div className="bg-[#757575] text-[#ffd428] font-black text-center py-1.5 text-base sm:text-lg tracking-wider border-b-2 border-black uppercase">
            SUPPORT + HYBRID
          </div>

          {/* 6 Rows: UBER, TIER 0, TIER 1, TIER 2, TIER 3, TIER 4 */}
          {supportGrid.rows.map((row, idx) => (
            <div
              key={row.tier}
              className={`grid grid-cols-6 ${
                idx < supportGrid.rows.length - 1 ? "border-b border-black" : ""
              }`}
            >
              {/* Tier Header */}
              <div
                className={`${row.tierBg} ${row.tierColor} font-black flex items-center justify-center p-1 text-xs sm:text-sm border-r border-black tracking-wider text-center`}
              >
                {row.tier}
              </div>
              {/* Hero Cells */}
              {row.tier === "UBER" ? (
                <>
                  <div className="border-r border-black">
                    {renderHeroCell(row.cells?.[0])}
                  </div>
                  <div className="border-r border-black">
                    {renderHeroCell(row.cells?.[1])}
                  </div>
                  <div className="col-span-3 bg-slate-950" />
                </>
              ) : (
                row.cells?.map((cell, cIdx) => (
                  <div
                    key={cIdx}
                    className={cIdx < 4 ? "border-r border-black" : ""}
                  >
                    {renderHeroCell(cell)}
                  </div>
                ))
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
