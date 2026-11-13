# Changelog

Changes that reach the people who use SMard Agent Flow. The version number is the
one in `plugin/smard-agent-flow/.claude-plugin/plugin.json`.

## 0.6.2

Prepared on 2026-11-13. The first version offered as a release with installers.

**New**

- Install on Windows with a setup program (English and Brazilian Portuguese), with
  a ZIP that has an `Install.cmd`, or with Node.js (`npx`). The Claude Code
  marketplace route stays as it was.
- winget manifests prepared for `SMardLabs.SMardAgentFlow`. They are not yet in
  the winget community repository.
- MIT license. The documentary part of the method that covers the workflow for
  Git and CI/CD was heavily inspired by GitHub's Spec-Driven Development workflow
  documentation (GitHub Spec Kit); the README says so and `LICENSE` keeps GitHub's
  copyright notice.
- The README is now the front page of the product: what it is, the cycle, the
  state of each piece, how to install.

**Fixed**

- The script installer (`plugin/install.ps1`) stopped before it copied anything,
  and the `/smard-agent-flow` command and the `coordinate` skill pointed to a skill
  that was renamed in 0.4.1 (`method`, now `smard-agent-flow`).
- The plugin tests reported false failures on Linux and macOS, and reported an
  absolute link as a broken relative link.

**Known limits**

- The setup program is not digitally signed. Windows SmartScreen can show a
  warning before it runs.
- The precompact hook, automatic session recovery and the Spec Kit integration
  are still not implemented.

## Earlier versions

Versions 0.4.0 to 0.6.1 were distributed only through the marketplace of the
repository. Their history is in the commits and in the pull requests.
