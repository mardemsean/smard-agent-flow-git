#!/usr/bin/env node
'use strict';
// Sets the smard-agent-flow plugin up for Claude Code. Same contract as plugin/install.ps1:
// it only copies, it refuses a destination that is not this plugin, it backs up a different
// entry command, and it never removes files it did not bring.

const fs = require('fs');
const os = require('os');
const path = require('path');
const crypto = require('crypto');

const NAME = 'smard-agent-flow';
const ROOT = path.resolve(__dirname, '..', '..');
const SRC = path.join(ROOT, 'plugin', NAME);
const CMD_SRC = path.join(ROOT, '.claude', 'commands', NAME + '.md');

function configDir() {
  return process.env.CLAUDE_CONFIG_DIR || path.join(os.homedir(), '.claude');
}

function isOurPlugin(folder) {
  try {
    const manifest = JSON.parse(fs.readFileSync(path.join(folder, '.claude-plugin', 'plugin.json'), 'utf8'));
    return manifest.name === NAME;
  } catch {
    return false;
  }
}

function listFiles(root) {
  const out = [];
  (function walk(dir) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) walk(full);
      else out.push(path.relative(root, full));
    }
  })(root);
  return out.sort();
}

function sha256(file) {
  return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}

function sameFile(a, b) {
  return fs.existsSync(a) && fs.existsSync(b) && sha256(a) === sha256(b);
}

function stamp() {
  const d = new Date();
  const p = (n) => String(n).padStart(2, '0');
  return `${d.getFullYear()}${p(d.getMonth() + 1)}${p(d.getDate())}-${p(d.getHours())}${p(d.getMinutes())}${p(d.getSeconds())}`;
}

function fail(message) {
  console.error('Not done: ' + message);
  process.exit(1);
}

function install(dryRun) {
  const cfg = configDir();
  const dest = path.join(cfg, 'skills', NAME);
  const cmdDest = path.join(cfg, 'commands', NAME + '.md');

  if (!isOurPlugin(SRC)) fail(`the plugin files are missing from this package (${SRC}).`);
  if (!fs.existsSync(path.join(SRC, 'skills', NAME, 'SKILL.md'))) fail('the router skill is missing from this package.');
  if (!fs.existsSync(CMD_SRC)) fail(`the entry command is missing from this package (${CMD_SRC}).`);
  if (fs.existsSync(dest) && !isOurPlugin(dest)) {
    fail(`${dest} exists and is not the ${NAME} plugin. Nothing was changed.`);
  }

  const version = JSON.parse(fs.readFileSync(path.join(SRC, '.claude-plugin', 'plugin.json'), 'utf8')).version;
  const files = listFiles(SRC);
  console.log(`SMard Agent Flow ${version}`);
  console.log(`Claude Code settings folder: ${cfg}`);

  if (dryRun) {
    console.log(`Would copy ${files.length} plugin files to: ${dest}`);
    console.log(`Would copy the entry command to: ${cmdDest}`);
    return;
  }

  for (const rel of files) {
    const target = path.join(dest, rel);
    fs.mkdirSync(path.dirname(target), { recursive: true });
    fs.copyFileSync(path.join(SRC, rel), target);
  }
  fs.mkdirSync(path.dirname(cmdDest), { recursive: true });
  if (fs.existsSync(cmdDest) && !sameFile(cmdDest, CMD_SRC)) {
    const backup = `${cmdDest}.bak-${stamp()}`;
    fs.copyFileSync(cmdDest, backup);
    console.log(`A different entry command was already there. Backup: ${backup}`);
  }
  fs.copyFileSync(CMD_SRC, cmdDest);

  const wrong = files.filter((rel) => !sameFile(path.join(SRC, rel), path.join(dest, rel)));
  if (wrong.length) fail(`these files did not copy correctly: ${wrong.join(', ')}`);
  if (!sameFile(CMD_SRC, cmdDest)) fail('the entry command did not copy correctly.');
  const extra = listFiles(dest).filter((rel) => !files.includes(rel));
  if (extra.length) {
    console.log(`Kept ${extra.length} file(s) from an earlier copy that this version does not have: ${extra.join(', ')}`);
  }

  console.log(`Installed and checked: ${files.length} plugin files and the entry command.`);
  console.log('');
  console.log('Next: open a NEW Claude Code session (or run /reload-plugins) and type:');
  console.log('  /smard-agent-flow');
}

function uninstall(dryRun) {
  const cfg = configDir();
  const dest = path.join(cfg, 'skills', NAME);
  const cmdDest = path.join(cfg, 'commands', NAME + '.md');
  console.log(`Claude Code settings folder: ${cfg}`);

  if (fs.existsSync(dest) && !isOurPlugin(dest)) {
    fail(`${dest} is not the ${NAME} plugin. Nothing was removed.`);
  }
  for (const target of [dest, cmdDest]) {
    if (!fs.existsSync(target)) {
      console.log(`Not installed: ${target}`);
    } else if (dryRun) {
      console.log(`Would remove: ${target}`);
    } else {
      fs.rmSync(target, { recursive: true, force: true });
      console.log(`Removed: ${target}`);
    }
  }
  if (!dryRun) console.log('Uninstalled. Open a new Claude Code session or run /reload-plugins.');
}

function help() {
  console.log(`SMard Agent Flow: this installer sets the ${NAME} plugin up for Claude Code.

Usage:
  smard-agent-flow [install]     copy the plugin and the /smard-agent-flow command
  smard-agent-flow uninstall     remove both
  smard-agent-flow --dry-run     with install or uninstall: show what would happen, change nothing
  smard-agent-flow --version     show the plugin version
  smard-agent-flow --help        show this text

The files go to the Claude Code settings folder: the folder in CLAUDE_CONFIG_DIR when
that variable is set, otherwise .claude in your home folder.`);
}

function main(argv) {
  const flags = argv.filter((a) => a.startsWith('-'));
  const words = argv.filter((a) => !a.startsWith('-'));
  const unknown = flags.filter((f) => !['--dry-run', '--help', '-h', '--version', '-v'].includes(f));
  if (unknown.length || words.length > 1) {
    help();
    fail(`unknown option: ${unknown.concat(words.slice(1)).join(' ')}`);
  }
  if (flags.includes('--help') || flags.includes('-h')) return help();
  if (flags.includes('--version') || flags.includes('-v')) {
    return console.log(JSON.parse(fs.readFileSync(path.join(SRC, '.claude-plugin', 'plugin.json'), 'utf8')).version);
  }
  const dryRun = flags.includes('--dry-run');
  const action = words[0] || 'install';
  if (action === 'install') return install(dryRun);
  if (action === 'uninstall') return uninstall(dryRun);
  help();
  fail(`unknown command: ${action}`);
}

try {
  main(process.argv.slice(2));
} catch (error) {
  fail(error.message);
}
