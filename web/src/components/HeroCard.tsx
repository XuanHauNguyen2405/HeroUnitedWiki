"use client";

import React, { useState } from "react";
import HeroIdentityBadges from "./HeroIdentityBadges";
import { combatProfiles } from "@/lib/equipment-advisor";

export interface HeroCardData {
  id: number | string;
  name: string;
  avatar?: string | null;
  card_image?: string | null;
  standing_image?: string | null;
  full_image?: string | null;
  animation?: string | null;
  is_world?: boolean; // True for Chuyển Thế
  quality?: number; // Base quality 0..8
  occupation?: number; // occupation.config[animation]; separate from career/race/element.
}

export interface HeroCardProps {
  hero: HeroCardData;
  superQualityStage?: number; // 0 (None/Base), 1 (Cam+), 2 (Cam++), 3 (Đỏ), 4 (Đỏ+), 5 (Đỏ++), 6 (Vàng), 7 (Vàng+), 8 (Vàng++)
  rebirthStage?: number; // 0..7 (0: None, 1: Dũng Sĩ, 2: Đấu Sĩ, 3: Anh Hùng, 4: Thần Thoại, 5: Thần, 6: Linh, 7: Hồn)
  breakthroughLevel?: number; // 1..20 (Element breakthrough)
  enhancementLevel?: number; // 0..60 (+1..+60)
  level?: number; // e.g. 255
  maxLevel?: number; // e.g. 255
  showAura?: boolean; // Defaults to auto (true if is_world)
  showElementBadge?: boolean; // Winged badge with breakthrough level 1..20
  showRebirthBadge?: boolean; // Rebirth badge (kpxq_break_*)
  showOccupation?: boolean; // Occupation icon on bottom left
  showStars?: boolean; // Arc of stars in top left
  size?: "sm" | "md" | "lg" | "xl"; // Size preset
  className?: string;
  reserveArtworkSpace?: boolean; // Reserve protruding envelope so cards in grids don't collide
  onClick?: () => void;
}

// Verified mapping from game_config.lua & game_util.lua
export interface FrameInfo {
  frame: string;
  name: string;
  tier?: string;
  isDragonFrame?: boolean;
}

export const SUPER_EVO_FRAMES: Record<number, FrameInfo> = {
  1: { frame: "card_q_bgOrange1.png", name: "Cam+", tier: "orange" },
  2: { frame: "card_q_bgOrange2.png", name: "Cam++", tier: "orange", isDragonFrame: true },
  3: { frame: "card_q_bgRed.png", name: "Đỏ", tier: "red" },
  4: { frame: "card_q_bgRed1.png", name: "Đỏ+", tier: "red" },
  5: { frame: "card_q_bgRed2.png", name: "Đỏ++", tier: "red", isDragonFrame: true },
  6: { frame: "card_q_bgYellow.png", name: "Vàng", tier: "gold" },
  7: { frame: "card_q_bgGolden1.png", name: "Vàng+", tier: "rainbow" },
  8: { frame: "card_q_bgGolden2.png", name: "Vàng++ (Cầu vồng)", tier: "rainbow", isDragonFrame: true },
};

export const BASE_QUALITY_FRAMES: Record<number, FrameInfo> = {
  0: { frame: "card_q_bgGrey.png", name: "Trắng" },
  1: { frame: "card_q_bgGreen.png", name: "Lục" },
  2: { frame: "card_q_bgBlue.png", name: "Lam" },
  3: { frame: "card_q_bgPurple.png", name: "Tím" },
  4: { frame: "card_q_bgOrange.png", name: "Cam" },
  5: { frame: "card_q_bgRed.png", name: "Đỏ" },
  6: { frame: "card_q_bgYellow.png", name: "Vàng" },
  7: { frame: "card_q_bgGolden1.png", name: "Màu" },
  8: { frame: "card_q_bgGolden2.png", name: "Cầu vồng", isDragonFrame: true },
};

// Mathematical alignment for 228x318 dragon frames:
export const DRAGON_FRAME_STYLE: React.CSSProperties = {
  position: "absolute",
  width: "123.24%",
  height: "123.26%",
  left: "50%",
  top: "50%",
  transform: "translate(-50%, -50%)",
  maxWidth: "none",
};

export const STANDARD_FRAME_STYLE: React.CSSProperties = {
  position: "absolute",
  width: "100%",
  height: "100%",
  left: "0%",
  top: "0%",
};

const REBIRTH_TITLES: Record<number, string> = {
  0: "",
  1: "Dũng Sĩ",
  2: "Đấu Sĩ",
  3: "Anh Hùng",
  4: "Thần Thoại",
  5: "Thần",
  6: "Linh",
  7: "Hồn",
};

export default function HeroCard({
  hero,
  superQualityStage = 0,
  rebirthStage = 0,
  breakthroughLevel = 20,
  enhancementLevel = 0,
  level = 255,
  maxLevel = 255,
  showAura,
  showElementBadge = true,
  showRebirthBadge = false,
  showOccupation = true,
  showStars = true,
  size = "md",
  className = "",
  reserveArtworkSpace = true,
  onClick,
}: HeroCardProps) {
  const [failedImageSrc, setFailedImageSrc] = useState<string | null>(null);

  // Defensive fallback for undefined hero
  const safeHero = hero || {
    id: 0,
    name: "Tướng",
    quality: 4,
  };

  // Determine frame texture based on verified Lua logic
  const frameInfo =
    superQualityStage > 0
      ? SUPER_EVO_FRAMES[superQualityStage] || SUPER_EVO_FRAMES[1]
      : BASE_QUALITY_FRAMES[safeHero.quality ?? 4] || BASE_QUALITY_FRAMES[4];

  const frameSrc = `/assets/card/${frameInfo.frame}`;

  // Aura rule: Transferred form (is_world) has red fiery aura, normal does not
  const hasAura = showAura !== undefined ? showAura : Boolean(safeHero.is_world);

  // Full formatted name: [Prefix]·[Name] +[Enhancement]
  const prefix = REBIRTH_TITLES[rebirthStage] || "";
  const nameWithPrefix = prefix ? `${prefix}·${safeHero.name}` : safeHero.name;
  const fullName = enhancementLevel > 0 ? `${nameWithPrefix}+${enhancementLevel}` : nameWithPrefix;

  // STRICT SEPARATION: Card Art vs Standing Art
  // Priority: safeHero.card_image -> fallback to /assets/heroes/card_${id}.png -> full_image -> avatar
  const cardArtUrl =
    safeHero.card_image ||
    `/assets/heroes/card_${safeHero.id}.png`;

  const fallbackFullUrl = safeHero.full_image || `/assets/heroes/standing_${safeHero.id}.png`;
  const avatarUrl = safeHero.avatar || "/assets/card/public_whiteCard.png";

  const effectiveCardUrl =
    failedImageSrc !== cardArtUrl
      ? cardArtUrl
      : failedImageSrc !== fallbackFullUrl
      ? fallbackFullUrl
      : null;

  const hasCardArt = Boolean(effectiveCardUrl);

  // Occupation index
  const profile = combatProfiles[String(safeHero.id)];
  const occupation = profile ? profile.occupation_id ?? 5 : safeHero.occupation ?? 5;
  const occIconSrc = `/assets/card/public_ocupation${occupation}.png`;
  const occBgSrc = superQualityStage > 0 ? "/assets/card/card_race_bg_2.png" : "/assets/card/card_race_bg.png";

  // Size configurations
  const sizeConfig = {
    sm: {
      width: 160,
      height: 224,
      popoutTop: -36,
      envelopeMarginX: 18,
      starSize: 14,
      badgeSize: 28,
      elemSize: 32,
      lvFont: "text-[10px]",
      nameFont: "text-xs",
    },
    md: {
      width: 213,
      height: 298,
      popoutTop: -50,
      envelopeMarginX: 24,
      starSize: 18,
      badgeSize: 38,
      elemSize: 42,
      lvFont: "text-xs",
      nameFont: "text-sm",
    },
    lg: {
      width: 256,
      height: 358,
      popoutTop: -62,
      envelopeMarginX: 30,
      starSize: 22,
      badgeSize: 46,
      elemSize: 50,
      lvFont: "text-sm",
      nameFont: "text-base",
    },
    xl: {
      width: 320,
      height: 448,
      popoutTop: -78,
      envelopeMarginX: 38,
      starSize: 26,
      badgeSize: 56,
      elemSize: 62,
      lvFont: "text-base",
      nameFont: "text-lg",
    },
  }[size];

  // Authentic Cocos2d-x card portrait geometry (ui_hero_list_item.ccbi):
  // Frame is 185x258 px; standardized half-body portrait canvas is 280x220 px anchored at (0.5, 0)
  // at m_anim_node Y = 91/258 (35.27% from bottom of frame, resting on the inner window border).
  const cardArtWidth = Math.round(sizeConfig.width * (280 / 185));
  const cardArtHeight = Math.round(sizeConfig.height * (220 / 258));
  const cardArtBottom = Math.round(sizeConfig.height * (91 / 258));

  // Rebirth stars / moons calculation (Authentic Cocos2d Lua rule):
  const isMoonTier = rebirthStage > 5;
  const starOrMoonCount = isMoonTier ? Math.min(rebirthStage - 5, 5) : Math.min(rebirthStage, 5);
  const starOrMoonIcon = isMoonTier ? "/assets/card/public_moon_icon.png" : "/assets/card/public_equip_star.png";
  const starOrMoonAlt = isMoonTier ? `Trăng khuyết ${starOrMoonCount}` : `Sao vàng ${starOrMoonCount}`;

  return (
    <div
      onClick={onClick}
      className={`relative select-none flex flex-col items-center group ${onClick ? "cursor-pointer" : ""} ${className}`}
      style={{
        width: reserveArtworkSpace ? sizeConfig.width + sizeConfig.envelopeMarginX * 2 : sizeConfig.width,
        paddingLeft: reserveArtworkSpace ? sizeConfig.envelopeMarginX : 0,
        paddingRight: reserveArtworkSpace ? sizeConfig.envelopeMarginX : 0,
        maxWidth: "100%",
      }}
      data-component="HeroCard"
      data-card-id={hero.id}
    >
      {/* 
        CARD OUTER WRAPPER:
        Has top margin so protruding character head, hair, weapons and wings never get clipped or overlap neighbors
      */}
      <div
        className="relative shrink-0 flex items-center justify-center"
        style={{
          width: sizeConfig.width,
          height: sizeConfig.height,
          marginTop: Math.abs(sizeConfig.popoutTop),
        }}
      >
        {/* ==================================================== */}
        {/* LAYER 1: TRANSFERRED AURA (Bản Chuyển Thế is_world)   */}
        {/* ==================================================== */}
        {hasAura && (
          <div
            className="absolute z-0 pointer-events-none animate-pulse transition-opacity duration-700"
            style={{
              top: sizeConfig.popoutTop - 20,
              width: sizeConfig.width * 1.5,
              height: sizeConfig.height * 1.3,
            }}
          >
            {/* Glowing background halo */}
            <div
              className="absolute inset-0 rounded-full blur-2xl opacity-60"
              style={{
                background: "radial-gradient(circle, rgba(239, 68, 68, 0.7) 0%, rgba(168, 85, 247, 0.4) 50%, transparent 80%)",
              }}
            />
            {/* Authentic game aura texture */}
            <img
              src="/assets/card/aura_zhuanshi.png"
              alt="Hào quang chuyển thế"
              className="w-full h-full object-contain filter drop-shadow-[0_0_20px_rgba(239,68,68,0.8)] opacity-90 scale-110"
            />
          </div>
        )}

        {/* ==================================================== */}
        {/* LAYER 2: CARD FRAME BACKGROUND                       */}
        {/* ==================================================== */}
        <div className="absolute inset-0 z-10 pointer-events-none">
          <img
            src={frameSrc}
            alt={frameInfo.name}
            style={frameInfo.isDragonFrame ? DRAGON_FRAME_STYLE : STANDARD_FRAME_STYLE}
            className="object-fill filter drop-shadow-[0_10px_20px_rgba(0,0,0,0.85)] pointer-events-none"
          />
        </div>

        {/* ==================================================== */}
        {/* LAYER 3: HERO CHARACTER CARD ART (HALF-BODY PORTRAIT) */}
        {/* ==================================================== */}
        {hasCardArt ? (
          <div
            className="absolute z-20 pointer-events-none flex items-end justify-center"
            style={{
              bottom: cardArtBottom,
              width: cardArtWidth,
              height: cardArtHeight,
              left: Math.round((sizeConfig.width - cardArtWidth) / 2),
            }}
          >
            <img
              src={effectiveCardUrl!}
              alt={fullName}
              onError={() => setFailedImageSrc(effectiveCardUrl)}
              className="w-full h-full object-contain object-bottom filter drop-shadow-[0_8px_16px_rgba(0,0,0,0.75)] transform transition-transform duration-300 group-hover:scale-105"
            />
          </div>
        ) : (
          /* Fallback when hero has no card art yet */
          <div
            className="absolute z-20 pointer-events-none flex flex-col items-center justify-center px-4"
            style={{
              top: sizeConfig.height * 0.14,
              bottom: sizeConfig.height * 0.22,
              width: sizeConfig.width * 0.82,
            }}
          >
            <div className="flex flex-col items-center justify-center p-2 rounded-2xl bg-slate-950/70 border border-slate-700/60 backdrop-blur-sm shadow-xl">
              <div className="relative w-20 h-20 sm:w-24 sm:h-24 rounded-xl overflow-hidden border border-amber-500/40 shadow-inner bg-slate-900 flex items-center justify-center">
                <img
                  src={avatarUrl}
                  alt={fullName}
                  className="w-full h-full object-contain filter drop-shadow p-1"
                />
              </div>
              <span className="mt-2 text-[10px] text-slate-300 bg-slate-900/90 border border-slate-700/80 px-2 py-0.5 rounded-md font-sans font-medium select-none shadow whitespace-nowrap">
                Chưa có ảnh thẻ
              </span>
            </div>
          </div>
        )}

        {/* ==================================================== */}
        {/* LAYER 4: TOP-LEFT REBIRTH STARS / MOONS              */}
        {/* ==================================================== */}
        {showStars && starOrMoonCount > 0 && (
          <div
            className="absolute z-30 flex flex-col items-center gap-1 pointer-events-none"
            style={{
              top: sizeConfig.height * 0.10,
              left: sizeConfig.width * 0.11,
            }}
          >
            {Array.from({ length: starOrMoonCount }).map((_, i) => (
              <img
                key={`${isMoonTier ? "moon" : "star"}-${i}`}
                src={starOrMoonIcon}
                alt={starOrMoonAlt}
                className="filter drop-shadow-[0_2px_4px_rgba(0,0,0,0.95)]"
                style={{
                  width: sizeConfig.starSize,
                  height: sizeConfig.starSize,
                }}
              />
            ))}
          </div>
        )}

        {/* ==================================================== */}
        {/* LAYER 5: REBIRTH BADGE (Top-Right / kpxq_break)      */}
        {/* ==================================================== */}
        {showRebirthBadge && rebirthStage > 0 && (
          <div
            className="absolute z-30 pointer-events-none"
            style={{
              top: -Math.round(sizeConfig.badgeSize * 0.35),
              right: -Math.round(sizeConfig.badgeSize * 0.25),
              width: sizeConfig.badgeSize,
              height: sizeConfig.badgeSize,
            }}
          >
            <img
              src={`/assets/card/kpxq_break_${rebirthStage}.png`}
              alt={`Chuyển ${rebirthStage}`}
              className="w-full h-full object-contain filter drop-shadow-[0_2px_6px_rgba(0,0,0,0.9)]"
            />
          </div>
        )}

        {/* ==================================================== */}
        {/* LAYER 6: ELEMENT BREAKTHROUGH BADGE (Right Side)     */}
        {/* ==================================================== */}
        {showElementBadge && breakthroughLevel > 0 && (
          <div
            className="absolute z-30 pointer-events-none flex items-center justify-center"
            style={{
              top: sizeConfig.height * 0.35,
              right: -sizeConfig.elemSize * 0.2,
              width: sizeConfig.elemSize,
              height: sizeConfig.elemSize,
            }}
          >
            <img
              src="/assets/card/bt_element.png"
              alt="Đột phá nguyên tố"
              className="w-full h-full object-contain filter drop-shadow-[0_2px_6px_rgba(0,0,0,0.9)]"
            />
            {/* Level number in center of the crystal face matching game reference */}
            <span
              style={{
                position: "absolute",
                top: "43%",
                left: "53%",
                transform: "translate(-50%, -50%)",
                fontSize: Math.round(sizeConfig.elemSize * 0.50),
                fontFamily: "'Gill Sans', 'Gill Sans MT', 'Trebuchet MS', 'Impact', sans-serif",
                fontWeight: 900,
                lineHeight: 1,
                color: "#0b0f19",
                WebkitTextStroke: `${Math.max(1, Math.round(sizeConfig.elemSize * 0.028 * 10) / 10)}px #ffffff`,
                paintOrder: "stroke fill",
                letterSpacing: "-0.04em",
                userSelect: "none",
                pointerEvents: "none",
              }}
            >
              {breakthroughLevel}
            </span>
          </div>
        )}

        {/* ==================================================== */}
        {/* LAYER 7: BOTTOM PLAQUE (Lv.255/255)                  */}
        {/* ==================================================== */}
        <div
          className="absolute z-30 pointer-events-none flex items-center justify-center font-bold tracking-wider font-mono"
          style={{
            bottom: sizeConfig.height * 0.075,
            width: sizeConfig.width * 0.72,
            height: sizeConfig.height * 0.13,
          }}
        >
          <span
            className={`${sizeConfig.lvFont} font-extrabold text-amber-200 drop-shadow-[0_2px_3px_rgba(0,0,0,0.95)]`}
            style={{
              textShadow: "0 0 6px rgba(245, 158, 11, 0.6), 0 1px 2px #000",
            }}
          >
            Lv.{level}/{maxLevel}
          </span>
        </div>

        {/* ==================================================== */}
        {/* LAYER 8: OCCUPATION BADGE (Bottom-Left)              */}
        {/* ==================================================== */}
        {showOccupation && (
          <div
            className="absolute z-30 pointer-events-none flex items-center justify-center"
            style={{
              bottom: sizeConfig.height * 0.03,
              left: sizeConfig.width * 0.03,
              width: sizeConfig.badgeSize * 0.85,
              height: sizeConfig.badgeSize * 0.85,
            }}
          >
            <img
              src={occBgSrc}
              alt="Nền biểu tượng nghề"
              className="w-full h-full object-contain filter drop-shadow-[0_1px_3px_rgba(0,0,0,0.8)]"
            />
            <img
              src={occIconSrc}
              alt="Nghề nghiệp"
              className="absolute w-[65%] h-[65%] object-contain"
            />
          </div>
        )}
      </div>

      {/* ==================================================== */}
      {/* LAYER 9: NAME BANNER (Below Card Frame)              */}
      {/* ==================================================== */}
      <div className="mt-2 text-center px-1 max-w-full">
        <h4
          className={`${sizeConfig.nameFont} font-black tracking-wide truncate ${
            superQualityStage >= 6 || hero.quality === 6
              ? "text-amber-300 drop-shadow-[0_0_8px_rgba(251,191,36,0.5)]"
              : superQualityStage >= 3 || hero.quality === 5
              ? "text-red-400 drop-shadow-[0_0_8px_rgba(248,113,113,0.5)]"
              : "text-orange-400 drop-shadow-[0_0_6px_rgba(251,146,60,0.4)]"
          }`}
          title={fullName}
        >
          {fullName}
        </h4>
        <HeroIdentityBadges id={hero.id} compact />
        {hero.is_world ? (
          <div className="inline-block mt-0.5 px-2.5 py-0.5 rounded-full text-[10px] font-bold bg-red-950/80 text-red-300 border border-red-500/40 tracking-wider">
            Dạng Chuyển Thế
          </div>
        ) : (
          <div className="inline-block mt-0.5 px-2.5 py-0.5 rounded-full text-[10px] font-medium bg-slate-800/80 text-slate-400 border border-slate-700/60 tracking-wider">
            Dạng Tiêu Chuẩn
          </div>
        )}
      </div>
    </div>
  );
}
