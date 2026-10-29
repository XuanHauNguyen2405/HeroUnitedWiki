import { getElement } from "@/lib/game-attributes";

export default function ElementBadge({ id, unknownLabel = "Chưa xác minh hệ" }: { id: unknown; unknownLabel?: string }) {
  const element = getElement(id);
  return <span className="element-badge" style={{ color: element?.color ?? "#cbd5e1" }} data-element-id={element?.id ?? "unknown"}>
    <span aria-hidden="true">{element?.symbol ?? "?"}</span> {element?.name ?? unknownLabel}
  </span>;
}
