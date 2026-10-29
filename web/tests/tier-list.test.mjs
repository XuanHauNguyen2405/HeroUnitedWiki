import test from "node:test";
import assert from "node:assert/strict";
import fs from "node:fs";
import path from "node:path";

const DATA_DIR = path.join(process.cwd(), "src", "data");
const PUBLIC_DIR = path.join(process.cwd(), "public");

test("Tier list data integrity and 46 ranked heroes coverage", () => {
  const tierListPath = path.join(DATA_DIR, "tier_list.json");
  assert.ok(fs.existsSync(tierListPath), "tier_list.json must exist");

  const tierList = JSON.parse(fs.readFileSync(tierListPath, "utf-8"));
  assert.equal(tierList.status, "official");
  assert.equal(tierList.version, "2026.10");
  assert.equal(tierList.stats.total_ranked_heroes, 46);
  assert.equal(tierList.stats.dealer_count, 19);
  assert.equal(tierList.stats.support_count, 27);

  // Check heroes detail
  const heroesDetailPath = path.join(DATA_DIR, "heroes_detail.json");
  const heroesDetail = JSON.parse(fs.readFileSync(heroesDetailPath, "utf-8"));

  let verifiedCount = 0;
  for (const group of tierList.groups) {
    assert.ok(group.heroes.length > 0, `Group ${group.role} must have heroes`);
    for (const h of group.heroes) {
      assert.ok(h.id, "Hero must have an id");
      assert.ok(h.name, "Hero must have a name");
      assert.ok(h.tier, "Hero must have a tier");
      assert.ok(heroesDetail[h.id], `Hero ${h.id} (${h.name}) must exist in heroes_detail.json`);

      // Verify cropped card asset exists in public folder
      const imageRel = h.image.startsWith("/") ? h.image.slice(1) : h.image;
      const imagePath = path.join(PUBLIC_DIR, imageRel);
      assert.ok(fs.existsSync(imagePath), `Card image ${imagePath} must exist for ${h.name}`);

      verifiedCount++;
    }
  }

  assert.equal(verifiedCount, 46, "Exactly 46 heroes must be verified");

  // Verify infographic images exist
  assert.ok(fs.existsSync(path.join(PUBLIC_DIR, "assets", "tier-list", "tier_dealer_full.png")));
  assert.ok(fs.existsSync(path.join(PUBLIC_DIR, "assets", "tier-list", "tier_support_full.png")));
  assert.ok(fs.existsSync(path.join(PUBLIC_DIR, "assets", "tier-list", "tier_combined_original.png")));
});
