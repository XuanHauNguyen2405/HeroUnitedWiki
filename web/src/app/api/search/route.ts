// web/src/app/api/search/route.ts
import { NextRequest, NextResponse } from "next/server";
import { searchEntities } from "@/lib/data";

export async function GET(request: NextRequest) {
  const { searchParams } = new URL(request.url);
  const q = searchParams.get("q") || "";
  const limit = parseInt(searchParams.get("limit") || "10", 10);

  if (!q.trim()) {
    return NextResponse.json({ query: q, results: [] });
  }

  const results = searchEntities(q, limit);
  return NextResponse.json({ query: q, count: results.length, results });
}
