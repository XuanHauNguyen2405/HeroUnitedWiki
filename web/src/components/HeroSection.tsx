import type { ComponentProps } from "react";

export default function HeroSection({ className = "", ...props }: ComponentProps<"section">) {
  return <section {...props} className={`hero-section space-y-5 ${className}`} />;
}
