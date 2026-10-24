"use client";

import React, { useState } from "react";

export interface HeroStandingArtData {
  id: number | string;
  name: string;
  avatar?: string | null;
  standing_image?: string | null;
  full_image?: string | null;
  animation?: string | null;
  is_world?: boolean; // True for Chuyển Thế
  quality?: number;
  occupation_type?: number;
}

export interface HeroStandingArtProps {
  hero: HeroStandingArtData;
  className?: string;
  size?: "sm" | "md" | "lg";
  showAura?: boolean;
}

/**
 * HeroStandingArt - Dedicated Full Body Standing Art Component
 * 
 * Replicates the in-game Hero Detail popup view (Images 1, 3, 5):
 * - Displays character full body (head, feet, wings, weapons, natural character aura).
 * - NO rectangular card frame.
 * - Subtle authentic ambient backlight & floor shadow.
 * - If Chuyển Thế (is_world), displays authentic transferred aura behind.
 */
export default function HeroStandingArt({
  hero,
  className = "",
  size = "md",
  showAura,
}: HeroStandingArtProps) {
  const [failedSrc, setFailedSrc] = useState<string | null>(null);

  // Standing image fallback hierarchy
  const standingSrc =
    hero.standing_image ||
    hero.full_image ||
    `/assets/heroes/standing_${hero.id}.png`;

  const imgFailed = failedSrc === standingSrc;

  const avatarUrl = hero.avatar || "/assets/card/public_whiteCard.png";
  const hasAura = showAura !== undefined ? showAura : Boolean(hero.is_world);

  const sizeClasses = {
    sm: "w-64 max-h-[340px]",
    md: "w-80 sm:w-96 max-h-[460px]",
    lg: "w-96 sm:w-[450px] max-h-[560px]",
  }[size];

  return (
    <div
      className={`relative flex flex-col items-center justify-end select-none ${className}`}
      data-component="HeroStandingArt"
      data-hero-id={hero.id}
    >
      {/* Container with relative sizing */}
      <div className={`relative flex items-end justify-center ${sizeClasses}`}>
        {/* ==================================================== */}
        {/* LAYER 1: AMBIENT BACKLIGHT / CHUYỂN THẾ AURA          */}
        {/* ==================================================== */}
        {hasAura ? (
          <div className="absolute inset-0 z-0 pointer-events-none flex items-center justify-center animate-pulse duration-1000">
            <div
              className="w-4/5 h-4/5 rounded-full blur-3xl opacity-50"
              style={{
                background:
                  "radial-gradient(circle, rgba(239, 68, 68, 0.8) 0%, rgba(168, 85, 247, 0.4) 60%, transparent 80%)",
              }}
            />
            <img
              src="/assets/card/aura_zhuanshi.png"
              alt="Hào quang Chuyển Thế"
              className="absolute w-full h-full object-contain filter drop-shadow-[0_0_25px_rgba(239,68,68,0.7)] scale-110 opacity-80"
            />
          </div>
        ) : (
          /* Subtle ambient backlight for standard heroes */
          <div
            className="absolute inset-0 z-0 pointer-events-none rounded-full blur-3xl opacity-20"
            style={{
              background:
                "radial-gradient(circle, rgba(245, 158, 11, 0.6) 0%, rgba(59, 130, 246, 0.3) 50%, transparent 70%)",
            }}
          />
        )}

        {/* ==================================================== */}
        {/* LAYER 2: FLOOR SHADOW / AMBIENT GROUND               */}
        {/* ==================================================== */}
        <div
          className="absolute bottom-2 z-0 pointer-events-none rounded-full blur-md opacity-40 bg-black"
          style={{
            width: "70%",
            height: "18px",
          }}
        />

        {/* ==================================================== */}
        {/* LAYER 3: FULL BODY CHARACTER ART                     */}
        {/* ==================================================== */}
        {!imgFailed ? (
          <img
            src={standingSrc}
            alt={hero.name}
            onError={() => setFailedSrc(standingSrc)}
            className="relative z-10 max-h-full max-w-full object-contain filter drop-shadow-[0_12px_24px_rgba(0,0,0,0.85)] transform transition-transform duration-300 hover:scale-[1.02]"
          />
        ) : (
          /* Fallback when standing sprite is missing */
          <div className="relative z-10 flex flex-col items-center justify-center p-6 rounded-3xl bg-slate-900/80 border border-slate-700/60 backdrop-blur-md shadow-2xl">
            <div className="w-24 h-24 rounded-2xl overflow-hidden border border-amber-500/40 bg-slate-950 p-2 shadow-inner">
              <img
                src={avatarUrl}
                alt={hero.name}
                className="w-full h-full object-contain filter drop-shadow"
              />
            </div>
            <span className="mt-3 text-xs text-slate-300 font-sans font-medium px-3 py-1 rounded-full bg-slate-800/90 border border-slate-700">
              Đang hoàn thiện mô hình toàn thân
            </span>
          </div>
        )}
      </div>

      {/* Subtle indicator tag */}
      <div className="mt-2 text-center pointer-events-none">
        <span className="inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-mono tracking-wider bg-slate-900/70 border border-slate-700/50 text-slate-400">
          <span className="w-1.5 h-1.5 rounded-full bg-emerald-400 animate-ping" />
          Hình Toàn Thân (Chi Tiết Game)
        </span>
      </div>
    </div>
  );
}
