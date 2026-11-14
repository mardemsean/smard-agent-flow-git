# References

The works that the documentary review of this method covered. The list follows
ABNT NBR 6023 for the references and NBR 6033 for the alphabetical order;
citations in the text follow NBR 10520.

## What the review was

Before the method was written, its author read six public repositories on the
software life cycle, to look for inspiration and to form a conviction. The
snapshots were taken on 14 October 2026, each one fixed at a commit. The roles
below are the author's own reading of each source.

| Source | Role in the review |
| --- | --- |
| Spec Kit (GitHub, 2026) | Specification-driven flow; with OpenSpec, a candidate for the official source of one same change. The documentary part of this method that covers the workflow for Git and CI/CD was heavily inspired by its Spec-Driven Development workflow documentation |
| OpenSpec (Fission AI, 2026) | Specification-driven flow; with Spec Kit, a candidate for the official source of one same change |
| BMAD-METHOD (BMad Code, 2026) | Complement for discovery and planning |
| The GitLab handbook (GitLab, [2026]) | Complement for discovery and planning; the product development flow |
| Google engineering practices documentation (Google, 2024) | Complement for review |
| Test-driven development (El Assas, 2026) | Complement for learning red-green-refactor |

The sources were read; they are not shipped with this repository. The line the
review kept is: problem, specification, plan, tasks, tests, PR and CI, release
and traceable results.

## References

BMAD CODE. **BMAD-METHOD**: breakthrough method for agile AI driven
development. [*S. l.*]: BMad Code, 2026. Repositório de código. Disponível em:
https://github.com/bmad-code-org/BMAD-METHOD. Acesso em: 14 out. 2026.

EL ASSAS, Akram. **Test-driven development**: a comprehensive guide. [*S. l.*:
*s. n.*], 2026. Repositório de código. Disponível em:
https://github.com/aelassas/tdd. Acesso em: 14 out. 2026.

FISSION AI. **OpenSpec**: spec-driven development (SDD) for AI coding
assistants. [*S. l.*]: Fission AI, 2026. Repositório de código. Disponível em:
https://github.com/Fission-AI/OpenSpec. Acesso em: 14 out. 2026.

GITHUB. **Spec Kit**. [*S. l.*]: GitHub, 2026. Repositório de código.
Disponível em: https://github.com/github/spec-kit. Acesso em: 14 out. 2026.

GITLAB. **The GitLab handbook**. [*S. l.*]: GitLab, [2026]. Repositório de
conteúdo. Disponível em:
https://gitlab.com/gitlab-com/content-sites/handbook. Acesso em: 14 out. 2026.

GOOGLE. **Google engineering practices documentation**. [*S. l.*]: Google,
2024. Repositório de documentação. Disponível em:
https://github.com/google/eng-practices. Acesso em: 14 out. 2026.

## Evidence

The snapshots are recorded in
[docs/references/SUPERPAK-MANIFEST.json](docs/references/SUPERPAK-MANIFEST.json),
the manifest of the package *SMard-software-life-cycle-SUPERPAK*, created on
2026-10-14T04:11:52Z: official address, branch, commit, checksum of each
download and file counts, 9,552 source files in all.

| Repository | Commit | Date of the commit | License declared at the source |
| --- | --- | --- | --- |
| `github/spec-kit` | `96774bc52fd7dccc7185791e1cac7572b9e09dea` | 2026-10-13 | MIT, Copyright GitHub, Inc. |
| `Fission-AI/OpenSpec` | `9111a7654d7800391459431fff4eaf66e33a3d2e` | 2026-10-06 | MIT, Copyright (c) 2024 OpenSpec Contributors |
| `bmad-code-org/BMAD-METHOD` | `8f0d50e1817fdd8fcf05a20c524218222d13cd8d` | 2026-10-13 | MIT, Copyright (c) 2025 BMad Code, LLC |
| `google/eng-practices` | `3bb3ec25b3b0199f4940b1aa75f0ac5c5753301c` | 2024-09-19 | Creative Commons Attribution 3.0 Unported |
| `aelassas/tdd` | `aa81c10a1f251ed7f4c7fa3a64a79780a9f3f4fe` | 2026-07-13 | None declared |
| `gitlab-com/content-sites/handbook` | `d64ae3845579a3ac5f9a38af63710d9597225d53` | Not verified | Not verified; the snapshot holds a `LICENSE` file at its root |

Dates and licenses of the five GitHub repositories were confirmed at the source
on 2026-11-14, at the commits above. GitLab could not be reached on that day,
so the year of the handbook is given in brackets, as inferred from the date of
the snapshot.

The file inventory of the package (`FILE-INVENTORY.json`, one entry per file
with path, size and SHA-256) is not in this repository because of its size. Its
SHA-256 is `abf9f7702d963c82b04cc978e932708fd48dbcb0d6841908a846e15aa408764b`;
the SHA-256 of the manifest is
`c08c14e70f1fd29eed41ac2786b77d8e4ab1567ecbbe8286cd707be35230c476`.

## Whole-file comparison

On 2026-11-14 the SHA-256 of each file tracked in this repository was compared
with the 9,552 entries of the inventory. No file with content is identical to a
file of the six sources; the only matches are empty placeholder files.

This comparison finds copies of whole files. It does not find excerpts,
translations or paraphrase, and it is not a legal opinion.

## Licenses of the sources

A license of a source governs the reuse of its text, not the reading of it.
`aelassas/tdd` declares no license, so its text gives no permission of reuse;
it is cited here as a reading. The license of this repository and its relation
to Spec Kit are in the README, section *Attribution and license*, and in
[LICENSE](LICENSE).
