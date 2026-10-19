/** Layout metadata only: original PNGs are not edited or replaced. */
interface ArtworkFocus {
  width: number;
  height: number;
  // Visually reviewed region containing the solid character, weapons and wings.
  // Low-opacity smoke outside this region must not determine character size.
  focus: { x: number; y: number; width: number; height: number };
}

const SASUKE_WINGS: ArtworkFocus = {
  width: 790,
  height: 800,
  focus: { x: 0, y: 0, width: 790, height: 745 },
};

const ARTWORK_FOCUS: Record<string, ArtworkFocus> = {
  "/assets/heroes/full_43900.png": SASUKE_WINGS,
  "/assets/heroes/full_83900.png": SASUKE_WINGS,
  "/assets/heroes/full_84000.png": {
    width: 770,
    height: 1173,
    focus: { x: 73, y: 344, width: 603, height: 741 },
  },
};

export function getHeroArtworkLayout(src: string | null, width: number, height: number) {
  const artwork = src ? ARTWORK_FOCUS[src] : undefined;
  if (!artwork || width <= 0 || height <= 0) return null;
  const { focus } = artwork;
  const scale = Math.min(width / focus.width, height / focus.height);
  return {
    width: artwork.width * scale,
    height: artwork.height * scale,
    left: (width - focus.width * scale) / 2 - focus.x * scale,
    top: height - focus.height * scale - focus.y * scale,
  };
}
