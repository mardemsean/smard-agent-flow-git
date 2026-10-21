---
name: grill-me
description: Interview the user thoroughly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

## Preamble — agree before starting (invariant I3)

Before the first question, confirm three things with the user:

1. **Goal** — what specific aspect or decision the session must resolve.
2. **Intensity** — light (surface check), moderate (probe assumptions), or intense (adversarial challenge).
3. **Stop condition** — a concrete criterion for ending: a number of rounds, a time box, or "when all branches of topic X are resolved."

Present these as one AskUserQuestion with sensible defaults. If the user overrides any default, respect it. The session never becomes an open-ended permanent interrogation.

## Conduct

Walk down each branch of the design tree within the agreed goal, resolving dependencies between decisions one by one. Challenge assumptions at the agreed intensity; do not escalate beyond it without asking.

## How to ask questions

Use the **AskUserQuestion tool** for every question you ask. Never pose questions as plain text in your response — always use the multiple-choice popup so the user can quickly select an answer or type a custom one.

Ask **one question at a time**. Wait for the user's answer before moving to the next question. This keeps the conversation focused and prevents overwhelm.

For each question, provide 2–4 concrete multiple-choice options representing the most likely answers or directions. Think about what the user would realistically choose — generic options like "Yes" / "No" aren't helpful unless the question is genuinely binary. The user always has the "Other" field available to write something custom.

## Flow

1. After receiving an answer, briefly acknowledge the decision (1–2 sentences max), then immediately ask the next question via AskUserQuestion.
2. If a question can be answered by exploring the codebase or files, explore them yourself instead of asking the user.
3. Continue until all branches of the design tree are resolved.
4. When finished, provide a concise summary of all decisions made.
