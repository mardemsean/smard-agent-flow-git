'use strict';
const { test } = require('node:test');
const assert = require('node:assert');
const { spawnSync } = require('node:child_process');
const crypto = require('node:crypto');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const CLI = path.join(__dirname, 'smard-agent-flow.js');
const ROOT = path.resolve(__dirname, '..', '..');
const SRC = path.join(ROOT, 'plugin', 'smard-agent-flow');
const CMD_SRC = path.join(ROOT, '.claude', 'commands', 'smard-agent-flow.md');

function run(cfg, ...args) {
  return spawnSync(process.execPath, [CLI, ...args], {
    env: { ...process.env, CLAUDE_CONFIG_DIR: cfg },
    encoding: 'utf8',
  });
}

function tree(root) {
  const out = {};
  (function walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else out[path.relative(root, full)] = crypto.createHash('sha256').update(fs.readFileSync(full)).digest('hex');
    }
  })(root);
  return out;
}

function tempConfig() {
  return fs.mkdtempSync(path.join(os.tmpdir(), 'saf-cfg-'));
}

test('install copies the plugin and the entry command byte for byte', () => {
  const cfg = tempConfig();
  const result = run(cfg);
  assert.strictEqual(result.status, 0, result.stderr);
  assert.deepStrictEqual(tree(path.join(cfg, 'skills', 'smard-agent-flow')), tree(SRC));
  assert.deepStrictEqual(
    fs.readFileSync(path.join(cfg, 'commands', 'smard-agent-flow.md')),
    fs.readFileSync(CMD_SRC),
  );
});

test('install refuses a folder that is not this plugin and changes nothing', () => {
  const cfg = tempConfig();
  const dest = path.join(cfg, 'skills', 'smard-agent-flow');
  fs.mkdirSync(dest, { recursive: true });
  fs.writeFileSync(path.join(dest, 'mine.txt'), 'keep');
  const result = run(cfg);
  assert.strictEqual(result.status, 1);
  assert.deepStrictEqual(fs.readdirSync(dest), ['mine.txt']);
  assert.ok(!fs.existsSync(path.join(cfg, 'commands')));
});

test('install backs up a different entry command and keeps files of an earlier copy', () => {
  const cfg = tempConfig();
  assert.strictEqual(run(cfg).status, 0);
  const cmd = path.join(cfg, 'commands', 'smard-agent-flow.md');
  const old = path.join(cfg, 'skills', 'smard-agent-flow', 'skills', 'method', 'SKILL.md');
  fs.writeFileSync(cmd, 'edited by the user');
  fs.mkdirSync(path.dirname(old), { recursive: true });
  fs.writeFileSync(old, 'earlier version');

  const result = run(cfg);
  assert.strictEqual(result.status, 0, result.stderr);
  const backups = fs.readdirSync(path.dirname(cmd)).filter((f) => f.includes('.bak-'));
  assert.strictEqual(backups.length, 1);
  assert.strictEqual(fs.readFileSync(path.join(path.dirname(cmd), backups[0]), 'utf8'), 'edited by the user');
  assert.deepStrictEqual(fs.readFileSync(cmd), fs.readFileSync(CMD_SRC));
  assert.ok(fs.existsSync(old));
  assert.match(result.stdout, /Kept 1 file/);
});

test('--dry-run changes nothing; uninstall removes both and refuses a foreign folder', () => {
  const cfg = tempConfig();
  assert.strictEqual(run(cfg, '--dry-run').status, 0);
  assert.deepStrictEqual(fs.readdirSync(cfg), []);

  assert.strictEqual(run(cfg).status, 0);
  assert.strictEqual(run(cfg, 'uninstall').status, 0);
  assert.ok(!fs.existsSync(path.join(cfg, 'skills', 'smard-agent-flow')));
  assert.ok(!fs.existsSync(path.join(cfg, 'commands', 'smard-agent-flow.md')));

  const dest = path.join(cfg, 'skills', 'smard-agent-flow');
  fs.mkdirSync(dest, { recursive: true });
  fs.writeFileSync(path.join(dest, 'mine.txt'), 'keep');
  assert.strictEqual(run(cfg, 'uninstall').status, 1);
  assert.ok(fs.existsSync(path.join(dest, 'mine.txt')));
});
