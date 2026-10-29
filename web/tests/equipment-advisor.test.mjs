import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import load from './load-ts.cjs';
const read = path => JSON.parse(readFileSync(new URL(path, import.meta.url), 'utf8'));
const source = read('../../config/equip.config');
const suits = read('../../config/suit.config');
const chars = read('../../config/character_detail.config');
const skills = read('../../config/skill_detail.config');
const rebirth = read('../../config/character_break_new.config');
const equipment = read('../src/data/equipment_detail.json');
const heroes = read('../src/data/heroes_detail.json');
const { getAbility, getElement, rawDomainLabel } = load(new URL('../src/lib/game-attributes.ts', import.meta.url).pathname.replace(/^\/(?=[A-Za-z]:)/, ''));
const { zodiacSets, combatProfiles, equipmentStats, recommendations, resolveVariant, activeEvidence, effectEligibility } = load(new URL('../src/lib/equipment-advisor.ts', import.meta.url).pathname.replace(/^\/(?=[A-Za-z]:)/, ''));
const base = { level: 1, rebirth: 0, superEvo: 0, breakthrough: 0 };

test('independent game Lua and raw suit prove 203 is wind, 204 is earth', () => {
  const lua = readFileSync(new URL('../../lua_decrypted/game_config.lua', import.meta.url), 'utf8');
  assert.match(lua, /ability_203 = \{name = "Phong công"[^\n]*attrName = "wind"/);
  assert.match(lua, /ability_204 = \{name = "Địa công"[^\n]*attrName = "earth"/);
  assert.equal(getAbility(203).key, 'wind');
  assert.equal(getAbility(204).key, 'earth');
  assert(suits['1690'].effect_4.some(([id]) => id === 203));
  assert(suits['1630'].effect_4.some(([id]) => id === 204));
});

test('all 4366 items reconcile record IDs, family IDs, original stats and offensive set elements', () => {
  assert.equal(Object.keys(equipment).length, 4366);
  for (const [id, raw] of Object.entries(source)) {
    const generated = equipment[id];
    assert.equal(generated.id, id);
    assert.equal(generated.equip_id, String(raw.equip_id));
    assert.equal(generated.primary_stat.ability_id, raw.ability1);
    assert.equal(generated.primary_stat.value, raw.value1);
    assert.equal(generated.secondary_stat.value, raw.value2);
    assert.deepEqual(generated.combat_effect.occupation_ids, raw.occupation1);
    const effects = [2, 3, 4].flatMap(n => suits[String(raw.suit)]?.[`effect_${n}`] ?? []);
    const attackIds = [...new Set(effects.filter(([id]) => id >= 201 && id <= 204).map(([id]) => id))];
    const expected = attackIds.length === 1 ? {201:'fire',202:'water',203:'wind',204:'earth'}[attackIds[0]] : null;
    assert.equal(generated.element_id, expected, id);
  }
});

test('all 20 zodiac variants and both tiers follow raw boxes, evolutions and suit membership', () => {
  const boxes = read('../../config/box.config');
  for (const set of zodiacSets) for (const variant of set.variants) {
    assert.deepEqual(variant.parts.map(p => p.id), boxes[variant.box_id][0].reward.map(r => String(r[1])));
    for (const rainbow of [false, true]) {
      const sid = rainbow ? variant.rainbow_suit_id : variant.suit_id;
      const parts = rainbow ? variant.rainbow_parts : variant.parts;
      assert.deepEqual(new Set(parts.map(p => p.id)), new Set(suits[sid].part.map(String)));
      for (const p of parts) assert.equal(String(source[p.id].suit), sid);
    }
    assert.deepEqual(variant.rainbow_parts.map(p => p.id), variant.parts.map(p => String(source[p.id].evolution)));
  }
});

test('wind selection is used by calculations and never falls back to first earth variant', () => {
  const selected = { setId: 'ngua', elementId: 'wind', rainbow: true };
  assert.equal(resolveVariant(selected).rainbow_suit_id, '1700');
  const stats = equipmentStats(selected);
  assert.equal(stats.earth, undefined);
  assert.equal(stats.wind, suits['1700'].effect_4.find(([id]) => id === 203)[1]);
  // Every bonus and level-1 item stat is counted once; no invented PATK or Speed.
  const expected = {};
  for (const p of suits['1700'].part.map(id => source[id])) for (const n of [1,2]) {
    const key = {1:'patk',2:'matk',3:'def',4:'speed',5:'hp'}[p[`ability${n}`]];
    expected[key] = (expected[key] ?? 0) + p[`value${n}`];
  }
  for (const [id, value] of [2,3,4].flatMap(n => suits['1700'][`effect_${n}`])) {
    const key = {2:'matk',5:'hp',203:'wind',301:'fire_dfs',302:'water_dfs',303:'wind_dfs',304:'earth_dfs'}[id];
    expected[key] = (expected[key] ?? 0) + value;
  }
  assert.deepEqual(stats, expected);
});

test('missing, invalid and zero IDs stay distinct; legitimate occupation/career/race zero survives', () => {
  for (const invalid of [undefined, null, '', 0, false, '0', 'Wind', 'unknown', '__proto__']) assert.equal(getElement(invalid), null);
  for (const invalid of [undefined, null, '', false, -1, 999999]) assert.equal(getAbility(invalid), null);
  assert.equal(rawDomainLabel('career', 0), 'Nghề 0');
  assert.equal(rawDomainLabel('race', 0), 'Tộc 0');
  assert.notEqual(rawDomainLabel('career', null), rawDomainLabel('career', 0));
  for (const id of ['wind', 'earth', '', 'unknown']) {
    const selection = {setId:'invalid',elementId:id,rainbow:false};
    assert.equal(resolveVariant(selection), null);
    assert.deepEqual(equipmentStats(selection), {});
  }
  const part = structuredClone(zodiacSets[0].variants[0].parts[0]);
  part.combat_effect.occupation_ids = [0];
  assert.equal(effectEligibility(part, {occupation_shade_id:0}, 1), 'eligible');
  assert.equal(effectEligibility(part, {occupation_shade_id:null}, 1), 'unknown');
  part.primary_stat.value = 0;
  part.combat_effect.effect = 0;
  assert.equal(part.combat_effect.effect, 0);
  const zeroSet = structuredClone(zodiacSets[0]);
  for (const v of zeroSet.variants) {
    v.bonuses = {};
    for (const p of v.parts) { p.primary_stat.value = 0; p.secondary_stat.value = 0; }
  }
  assert(Object.values(equipmentStats({setId:zeroSet.id,elementId:'wind',rainbow:false}, [zeroSet])).every(value => value === 0));
});

test('all 721 forms use their own raw skill links; no name-based family merge', () => {
  assert.equal(Object.keys(combatProfiles).length, 721);
  for (const [id, profile] of Object.entries(combatProfiles)) {
    assert.equal(profile.occupation_shade_id, chars[id].occupation_shade);
    for (const e of profile.evidence) {
      if (e.slot > 0) {
        assert(chars[id][`skill_${e.slot}_source`].some(([sid]) => String(sid) === e.skill_id), id);
        assert.equal(e.description, skills[e.skill_id].skill_story);
      } else assert.equal(e.description, rebirth[id][`story_detail${e.min_rebirth}`]);
    }
    assert.equal(heroes[id].chuyen_sinh.has_rebirth, Boolean(rebirth[id]), id);
    assert(heroes[id].chuyen_sinh.stages.every(s => s.stage <= rebirth[id].high_break));
  }
});

test('recommendations include evidenced wind and exclude unsupported earth reasoning', () => {
  const recs = recommendations('83000', base, true);
  assert(recs.some(r => r.selection.setId === 'ngua' && r.selection.elementId === 'wind'));
  assert(!recs.some(r => r.selection.elementId === 'earth'));
  assert(recs.every(r => r.evidence.every(e => e.element_ids.includes(r.selection.elementId))));
  // A skill name containing Fire does not establish a fire formula.
  assert.deepEqual(recommendations('2100', base, false), []);
  assert.deepEqual(recommendations('missing', base, false), []);
});

test('rebirth and super evolution unlock only evidence supported by the selected form and milestone', () => {
  assert(!activeEvidence(combatProfiles['82400'], base).some(e => e.min_rebirth > 0));
  const cs6 = { ...base, rebirth: 6 };
  assert(recommendations('82400', cs6, false).some(r => r.selection.elementId === 'wind'));
  assert(!recommendations('82400', base, false).some(r => r.selection.elementId === 'wind'));
  assert(!activeEvidence(combatProfiles['83200'], base).some(e => e.skill_id === '75770'));
  assert(activeEvidence(combatProfiles['83200'], {...base,superEvo:6}).some(e => e.skill_id === '75770'));
  assert.equal(skills['75670'].skill_story.includes('thuộc tính Phong'), true);
  assert.equal(skills['75770'].skill_story.includes('thuộc tính Hỏa'), true);
});

test('combat effect eligibility is separate from ability to equip a different element', () => {
  const part = zodiacSets.find(s => s.id === 'ngua').variants.find(v => v.element_id === 'wind').rainbow_parts[0];
  assert.deepEqual(source[part.id].occupation1, [0,1,2,3]);
  assert.equal(effectEligibility(part, {occupation_shade_id:4}, 255), 'ineligible');
  assert.equal(effectEligibility(part, {occupation_shade_id:1}, 255), 'eligible');
  const blocked = structuredClone(part);
  blocked.combat_effect.activation = 'unverified';
  assert.equal(effectEligibility(blocked, {occupation_shade_id:1}, 255), 'unknown');
  assert(resolveVariant({setId:'ngua',elementId:'earth',rainbow:false}));
});

test('all breakthrough stages distinguish 201-204 attack from 301-304 defense using independent source rows', () => {
  const raw = read('../../config/breakthrough.config');
  let count = 0;
  for (const hero of Object.values(heroes)) for (const stage of hero.breakthrough_system.stages) {
    const original = raw[stage.source_id].abilitys;
    assert.deepEqual(stage.raw_abilities, original);
    const attack = original.filter(([id]) => id >= 201 && id <= 204).reduce((sum,[,n])=>sum+n,0);
    const defense = original.filter(([id]) => id >= 301 && id <= 304).reduce((sum,[,n])=>sum+n,0);
    assert.equal(stage.stats.ele_atk, attack, stage.source_id);
    assert.equal(stage.stats.ele_def, defense, stage.source_id);
    for (const [id, value] of original.filter(([id])=>id>=201&&id<=304)) {
      const key={201:'fire',202:'water',203:'wind',204:'earth',301:'fire_dfs',302:'water_dfs',303:'wind_dfs',304:'earth_dfs'}[id];
      assert.equal(stage.stats.attributes[key], value);
    }
    count++;
  }
  assert(count > 3000);
  assert.equal(heroes['83100'].breakthrough_system.stages[0].stats.water_dfs, undefined);
  assert.equal(heroes['83100'].breakthrough_system.stages[0].stats.attributes.water_dfs, 5880);
  assert.equal(heroes['83100'].breakthrough_system.stages[0].stats.ele_atk, 0);
});

test('skill unlock milestones come from each exact form super_evolution row', () => {
  const superEvo=read('../../config/super_evolution.config');
  for (const [id,profile] of Object.entries(combatProfiles)) {
    const row=superEvo[String(chars[id].super_evo)];
    for(const slot of [4,5]) assert.equal(profile.skill_unlocks[String(slot)], row?.[`skill${slot}_open`] ?? null);
  }
});
