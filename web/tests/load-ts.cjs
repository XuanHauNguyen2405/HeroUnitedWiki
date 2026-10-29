const fs = require('node:fs');
const path = require('node:path');
const ts = require('typescript');
const cache = new Map();
module.exports = function load(file) {
  file = path.resolve(file);
  if (cache.has(file)) return cache.get(file).exports;
  if (file.endsWith('.json')) return JSON.parse(fs.readFileSync(file, 'utf8'));
  const module = { exports: {} };
  cache.set(file, module);
  const source = fs.readFileSync(file, 'utf8');
  const result = ts.transpileModule(source, { compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, esModuleInterop: true } });
  const localRequire = name => {
    const target = path.resolve(path.dirname(file), name);
    if (name.startsWith('.')) return moduleLoader(target.endsWith('.json') ? target : target + '.ts');
    return require(name);
  };
  const moduleLoader = require('./load-ts.cjs');
  new Function('require', 'module', 'exports', result.outputText)(localRequire, module, module.exports);
  return module.exports;
};
