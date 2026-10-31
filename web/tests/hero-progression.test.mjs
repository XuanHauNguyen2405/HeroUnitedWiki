import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import ts from 'typescript';

const source = readFileSync(new URL('../src/lib/hero-progression.ts', import.meta.url), 'utf8');
const { outputText } = ts.transpileModule(source, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
});
const { getSuperEvoStages, getBreakthroughStages, isSuperEvoUpgrade, maxStrengthenAtLevel, resolveSkillAtEvolution } = await import(
  `data:text/javascript;base64,${Buffer.from(outputText).toString('base64')}`
);
const heroes = JSON.parse(readFileSync(new URL('../src/data/heroes_detail.json', import.meta.url), 'utf8'));

test('base Sasuke has its own super evolution stages and no breakthrough stages', () => {
  assert.equal(heroes['43900'].super_evo.has_super_evo, true);
  assert.equal(getSuperEvoStages(heroes['43900']).length, 9);
  assert.equal(heroes['43900'].breakthrough_system.has_breakthrough, false);
  assert.deepEqual(getBreakthroughStages(heroes['43900']), []);
});

test('transferred Sasuke forms retain both super evolution and breakthrough tables', () => {
  for (const id of ['83900', '84000']) {
    assert.equal(heroes[id].super_evo.has_super_evo, true);
    assert.equal(getSuperEvoStages(heroes[id]).length, 9);
    assert.equal(heroes[id].breakthrough_system.has_breakthrough, true);
    assert.equal(getBreakthroughStages(heroes[id]).length, 20);
  }
});

test('all 721 hero forms respect their own explicit capability flags', () => {
  assert.equal(Object.keys(heroes).length, 721);
  for (const hero of Object.values(heroes)) {
    if (!hero.super_evo?.has_super_evo) {
      assert.equal(getSuperEvoStages(hero).length, 0, hero.id);
    } else {
      assert.deepEqual(getSuperEvoStages(hero), hero.super_evo.stages, hero.id);
    }
    if (!hero.breakthrough_system?.has_breakthrough) {
      assert.equal(getBreakthroughStages(hero).length, 0, hero.id);
    } else {
      assert.deepEqual(getBreakthroughStages(hero), hero.breakthrough_system.stages, hero.id);
    }
  }
});

test('Cam base and missing selections do not activate upgrade effects', () => {
  assert.equal(isSuperEvoUpgrade(undefined), false);
  assert.equal(isSuperEvoUpgrade({ id: 'none' }), false);
  assert.equal(isSuperEvoUpgrade({ id: 'cam' }), false);
  for (const id of ['cam_plus', 'cam_plus2', 'do', 'do_plus', 'do_plus2', 'vang', 'vang_plus', 'vang_plus2']) {
    assert.equal(isSuperEvoUpgrade({ id }), true, id);
  }
});

test('missing family entries fall back to the exact detail record', () => {
  const stages = [{ id: 'cam' }, { id: 'do' }];
  assert.deepEqual(getSuperEvoStages({ id: 'x', super_evo: { has_super_evo: true, stages } }), stages);
  assert.deepEqual(getSuperEvoStages({ id: 'x' }), []);
  assert.deepEqual(getSuperEvoStages({ id: 'x', super_evo: { has_super_evo: false, stages } }), []);
});

test('lowering hero level clamps evolution to milestones with verified level requirements', () => {
  const table = JSON.parse(readFileSync(new URL('../src/data/character_strengthen.json', import.meta.url), 'utf8'));
  assert.equal(maxStrengthenAtLevel(1, true, table), 0);
  assert.equal(maxStrengthenAtLevel(255, false, table), 0);
  assert.equal(maxStrengthenAtLevel(255, true, table), 60);
  for (const level of [1, 10, 40, 50, 100, 150, 255]) {
    const max = maxStrengthenAtLevel(level, true, table);
    if (max > 0) assert(table[String(max)].need_level <= level);
    if (max < 60) assert(table[String(max + 1)].need_level > level);
  }
});

test('evolution +1..+60 advances skills 1..3 from Giai 1 to Giai 8 and updates damage and description', () => {
  const vegeta = heroes['43600'];
  const skill1 = vegeta.skills_detailed.find(s => s.slot === 1);
  const skill2 = vegeta.skills_detailed.find(s => s.slot === 2);
  const skill3 = vegeta.skills_detailed.find(s => s.slot === 3);

  const s1At0 = resolveSkillAtEvolution(skill1, 0, 1);
  assert.equal(s1At0.stage, 1);
  assert.equal(s1At0.max_stage, 8);
  assert.equal(s1At0.effect, 500);
  assert.match(s1At0.description, /500%.*100%/);

  const s1At60 = resolveSkillAtEvolution(skill1, 60, 1);
  assert.equal(s1At60.stage, 8);
  assert.equal(s1At60.effect, 1200);
  assert.equal(s1At60.evo_effect_gain, 700);
  assert.match(s1At60.description, /1200%.*800%/);

  const s1At60Lv30 = resolveSkillAtEvolution(skill1, 60, 30);
  assert.equal(s1At60Lv30.effect, 1490);
  assert.match(s1At60Lv30.description, /1490%.*800%/);

  assert.equal(resolveSkillAtEvolution(skill2, 2, 1).is_unlocked_by_evo, false);
  assert.equal(resolveSkillAtEvolution(skill2, 3, 1).is_unlocked_by_evo, true);
  assert.equal(resolveSkillAtEvolution(skill2, 55, 1).stage, 8);
  assert.equal(resolveSkillAtEvolution(skill3, 59, 1).stage, 7);
  assert.equal(resolveSkillAtEvolution(skill3, 60, 1).stage, 8);
});

test('all 16 requested hero families use standardized half-body card_<id>.png portraits', () => {
  for (const id of ['81600', '81700', '43600', '84500', '79800', '80300', '80400', '80700', '80800', '42900', '82000', '80000', '43100', '82400', '43200', '82600', '80100', '80200', '43800', '83800', '43300', '82800', '43400', '83100', '80500', '80600', '42800', '81800', '80900', '81000', '81900']) {
    assert.equal(heroes[id].card_image, `/assets/heroes/card_${id}.png`, id);
  }
});
