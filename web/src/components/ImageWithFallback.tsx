// web/src/components/ImageWithFallback.tsx
"use client";

import React, { useState } from "react";

interface ImageWithFallbackProps {
  src: string | null | undefined;
  alt: string;
  className?: string;
  style?: React.CSSProperties;
  fallbackText?: string;
  fallbackIcon?: string;
}

export default function ImageWithFallback({
  src,
  alt,
  className = "",
  style = {},
  fallbackText = "Chưa tìm thấy ảnh",
  fallbackIcon = "🖼️",
}: ImageWithFallbackProps) {
  const [failedSrc, setFailedSrc] = useState<string | null>(null);

  if (!src || failedSrc === src) {
    return (
      <div
        className={`flex flex-col items-center justify-center bg-gray-900/80 border border-gray-800 text-gray-500 text-xs p-2 text-center rounded-lg select-none ${className}`}
        style={style}
        title={alt}
      >
        <span className="text-base mb-1">{fallbackIcon}</span>
        <span className="text-[10px] leading-tight text-gray-400 font-medium line-clamp-2">
          {fallbackText}
        </span>
      </div>
    );
  }

  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src={src}
      alt={alt}
      className={`object-cover rounded-lg ${className}`}
      style={style}
      loading="lazy"
      onError={() => setFailedSrc(src)}
    />
  );
}
