import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import ts from 'typescript';

const source = readFileSync(new URL('../src/lib/hero-progression.ts', import.meta.url), 'utf8');
const { outputText } = ts.transpileModule(source, {
  compilerOptions: { module: ts.ModuleKind.ESNext, target: ts.ScriptTarget.ES2022 },
});
const { getSuperEvoStages, getBreakthroughStages, isSuperEvoUpgrade } = await import(
  `data:text/javascript;base64,${Buffer.from(outputText).toString('base64')}`
);
const heroes = JSON.parse(readFileSync(new URL('../src/data/heroes_detail.json', import.meta.url), 'utf8'));

test('base Sasuke ignores copied progression tables belonging to other forms', () => {
  assert.equal(heroes['43900'].super_evo.has_super_evo, true); // The reported contradiction.
  assert.ok(heroes['43900'].super_evo.stages.length > 0);
  assert.deepEqual(getSuperEvoStages(heroes['43900']), []);
  assert.deepEqual(getBreakthroughStages(heroes['43900']), []);
});

test('transferred Sasuke forms retain their progression tables', () => {
  for (const id of ['83900', '84000']) {
    assert.equal(getSuperEvoStages(heroes[id]).length, 9);
    assert.equal(getBreakthroughStages(heroes[id]).length, 20);
  }
});

test('all 721 hero forms respect their own explicit capability flags', () => {
  assert.equal(Object.keys(heroes).length, 721);
  for (const hero of Object.values(heroes)) {
    const form = hero.family_forms?.find(item => item.id === hero.id);
    if (form?.has_super_evo === false || !hero.super_evo?.has_super_evo) {
      assert.equal(getSuperEvoStages(hero).length, 0, hero.id);
    } else {
      assert.deepEqual(getSuperEvoStages(hero), hero.super_evo.stages, hero.id);
    }
    if (form?.breakthrough_count === 0 || !hero.breakthrough_system?.has_breakthrough) {
      assert.equal(getBreakthroughStages(hero).length, 0, hero.id);
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
