# Situational Assessment — smard-agent-flow-git

**Date:** 2026-10-20
**Branch:** main (commit 20ec9df)
**Reviewer:** Session continuation from the 66.05 USD English-translation session

---

## Executive Summary

The repository is in **good shape for a documentation/methodology project at version 0.3.0**. The English translation is complete and well-written. All internal links resolve. No documents are missing. No folders are truly empty (all reserved folders carry `.gitkeep` per the approved tree addendum). Templates have real structural content (41–143 lines each).

The operator's concerns — "commands in Portuguese, non-existent documents, empty directories, documents with only one meaningless sentence" — map almost entirely to **Portuguese names on files and folders**, not to missing or empty content. The translation session translated all *content* to English but did not rename paths.

**Three categories of work remain:**

| # | Category | Items | Effort |
|---|----------|-------|--------|
| 1 | Portuguese path names | 1 folder + 13 files + 4 `.gitignore` comments | Medium (renames break all internal links, packaged copy, plugin) |
| 2 | Line-ending drift | grill-me SKILL.md CRLF vs LF | Trivial |
| 3 | Branch cleanup | 5 stale local branches from translation work | Trivial |

---

## Finding 1: Portuguese Path Names (the main issue)

The repository language rule says English. All document **content** is English. But the following **paths** are still Portuguese:

### Folder
- `docs/workflow-producao/` → should be `docs/production-workflow/` (or similar)

### Workflow documents (4 files)
| Current name | Suggested English name |
|---|---|
| ADAPTACAO-SPECKIT.md | SPECKIT-ADAPTATION.md |
| BASELINE-METODO.md | METHOD-BASELINE.md |
| CONTRATO-DOCUMENTAL.md | DOCUMENTARY-CONTRACT.md |
| MEMORIA-SESSOES.md | SESSION-MEMORY.md |

### Templates (8 of 11 files)
| Current name | Suggested English name |
|---|---|
| CAPACIDADES-INTEGRACOES.md | CAPABILITIES-INTEGRATIONS.md |
| CHECKPOINT-SESSAO.md | SESSION-CHECKPOINT.md |
| CONSTITUICAO-REPOSITORIO.md | REPOSITORY-CONSTITUTION.md |
| ENTREGA-APRENDIZADO.md | LEARNING-DELIVERY.md |
| EXPLORACAO.md | EXPLORATION.md |
| PONTE-SPECS-TAREFAS.md | SPECS-TASKS-BRIDGE.md |
| RATIFICACAO-DOCUMENTAL.md | DOCUMENTARY-RATIFICATION.md |
| REGISTRO-PASSAGEM.md | PASSAGE-RECORD.md |

### Prompt (1 file)
| Current name | Suggested English name |
|---|---|
| exploracao-acompanhada.md | accompanied-exploration.md |

### `.gitignore` comments (4 lines, all Portuguese)
```
Line 1: # Claude Code: configuração local da máquina (caminhos, endpoints) — nunca versionar
Line 4: # Worktrees de subagentes (Claude Code)
Line 7: # higiene (sessao 2026-09-27)
Line 12: # Memoria local entre sessoes; publicacao exige promocao explicita.
```

### Impact of renaming

Renaming is **not a simple find-replace**. It requires coordinated changes across:
1. The files themselves (git mv)
2. Every cross-reference in all root documents (README.md, METHODOLOGY.md, RULES.md, INDEX.md, specs.md, etc.)
3. The packaged method copy under `plugin/smard-agent-flow/method/`
4. The sync-method.ps1 script (which maps source → packaged paths)
5. Internal links within the workflow documents themselves
6. The prompts/README.md references

---

## Finding 2: Line-Ending Drift (grill-me SKILL.md)

| File | Line endings |
|---|---|
| `.claude/skills/grill-me/SKILL.md` | CRLF (Windows) |
| `plugin/smard-agent-flow/method/.claude/skills/grill-me/SKILL.md` | LF (Unix) |

Content is byte-identical except for line endings. This causes `test.ps1` to report 1 FAILED (sync drift).

**Fix:** Normalize to LF in both copies (matches the rest of the repository), or add a `.gitattributes` rule.

---

## Finding 3: Stale Local Branches

| Branch | Purpose | Action |
|---|---|---|
| `smard/goofy-kare-a65377` | Unknown (harness-generated name, violates session identity rule) | Delete |
| `smardlabs/kind-williamson-9a9c1f` | Unknown (harness-generated name) | Delete |
| `smardlabs/method-english-plugin-distribution` | Translation session (has docs/pt-BR/ originals not on main) | Safe to delete — content squash-merged, PT-BR originals intentionally excluded |
| `smardlabs/method-english-plugin-skills` | Translation session (subset of above) | Safe to delete |
| `smardlabs/method-english-translation` | Translation session (subset of above) | Safe to delete |
| `smardlabs/method-plugin-distribution` | Translation session | Merged into main — safe to delete |

Translation work was squash-merged to main (20ec9df). The 3 unmerged branches carry Portuguese originals (`docs/pt-BR/`) and extra `.gitkeep` folders that were intentionally excluded from main. The 3 merged branches are identical to or ancestors of main.

---

## What Is NOT Wrong

These items are confirmed healthy:

| Check | Result |
|---|---|
| Internal links | All resolve (validated by script) |
| Root documents (8) | Complete, well-written English, 20–196 lines each |
| Workflow documents (5) | Substantial content: 17–368 lines, 1–31 KB each |
| Templates (11) | Real structural content: 41–143 lines each, headers + placeholder sections |
| Plugin integrity | All 8 root docs byte-identical between repo root and packaged copy |
| Plugin JSON | Valid v0.3.0, proper userConfig schema |
| Marketplace JSON | Correct source path |
| Reserved folders | All 32 present with `.gitkeep`, per approved tree addendum |
| BOM (byte-order marks) | None found in any file |
| Plugin skills (9) | All have proper SKILL.md with mandatory readings and route tables |
| Entry command | Present at `.claude/commands/smard-agent-flow.md` |

---

## Recommended Next Steps (in order)

1. **Decide on English path names** — the folder and file renames in Finding 1. This is the largest remaining task and requires a coordinated rename across the repository.
2. **Fix grill-me line endings** — normalize to LF.
3. **Delete stale branches** — after confirming they are merged into main.
4. **Translate `.gitignore` comments** — four lines.
5. **Bump plugin version** to 0.4.0 after the renames (new paths = breaking change for installed copies).

