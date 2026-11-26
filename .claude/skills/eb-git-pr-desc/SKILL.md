---
name: eb-git-pr-desc
version: 0.1.0
description: Read the commits on the current branch (HEAD) against its base and write a pull request description — a Conventional Commit title, a "## What" section of concise bullets, and a "## Why" section. Use when the user asks for a PR description, PR title and body, a summary of the branch, or asks "what should this PR say?".
---

Turn the commits on the current branch into a pull request description in a
fixed shape: a Conventional Commit title, a `## What` section, and a `## Why`
section.

The *format* is fixed by this skill. The *vocabulary* — which types and scopes
the title may use — is derived from the repo's own history.

## Steps

### 1. Find the branch's commit range

Confirm there is a repo and that HEAD is not the base branch itself:

```bash
git rev-parse --is-inside-work-tree
git rev-parse --abbrev-ref HEAD
```

Resolve the base in this order, stopping at the first that works:

1. the branch's upstream, if it is not the branch itself:
   `git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}'`
2. `git symbolic-ref --short refs/remotes/origin/HEAD` (the remote's default
   branch)
3. the first of `origin/main`, `origin/master`, `main`, `master` that exists
   (`git rev-parse --verify`)

Then take the merge base and the range:

```bash
git merge-base HEAD <base>
git log --oneline <base>..HEAD
```

If the range is empty, say so and stop — there is nothing to describe. If HEAD
is itself the base branch, say so and ask which base to compare against rather
than guessing. If uncommitted changes exist (`git status --porcelain`), mention
them as *not* covered by the description.

### 2. Read the commits and the diff

Do not write the description from subject lines alone — subjects say what was
touched, the diff says what changed.

```bash
git log --reverse --pretty=format:'---%n%H%n%s%n%n%b' <base>..HEAD
git diff --stat <base>...HEAD
git diff <base>...HEAD
```

Use the three-dot form for diffs so base-branch commits merged in along the way
do not show up as this branch's work. For a large diff, read the stat first and
then the files that carry the substance; skip generated or vendored files but
note that you skipped them.

Look for things the commits imply but do not state: new dependencies, config or
schema changes, renamed or deleted files, behavior that changes for existing
callers.

### 3. Derive the title vocabulary

```bash
git log --pretty=format:'%s' -40
```

Take from history:

- which Conventional Commit types this repo actually uses (`feat`, `fix`,
  `docs`, `refactor`, `test`, `chore`, `build`, `ci`, …)
- whether subjects carry a `(scope)`, and the scope names in use — prefer an
  existing scope over inventing one
- subject case and mood

Also check written rules if present — `CONTRIBUTING.md`, `CLAUDE.md`,
`AGENTS.md`, any `commitlint` config — and follow them over inferred style.

With no usable history, fall back to `<type>(<scope>): <summary>` with a
lowercase imperative summary, no trailing period, under ~72 characters.

### 4. Write the description

Output exactly this shape:

```
<type>(<scope>): <summary of the whole branch>

## What

- <Complete sentence describing one change.>
- <Complete sentence describing another change.>

## Why

- <Complete sentence giving the reason for the branch.>
```

Title:

- describes the branch as a whole, not the last commit. When the branch is a
  single commit, reuse that subject if it already fits.
- picks the type of the dominant change — a branch that adds a feature and
  incidentally fixes a typo is `feat`, not `fix`.
- drops the scope when the change spans the repo and no existing scope covers
  it.

`## What`:

- one bullet per reviewable change, not one per commit and not one per thing
  the change does — squash several commits that built up a single change into
  one bullet, and split a commit that did two unrelated things into two.
- scale the bullet count to the size of the diff, not to how much the change
  does internally. One added or rewritten file is normally **one bullet**, plus
  at most one more for a decision a reviewer would otherwise have to read the
  file to discover. A branch touching a single area is two to four bullets.
- never walk through the inside of one change — listing a new file's sections,
  options, or steps as separate bullets summarizes the file instead of
  describing the branch, and tells a reviewer nothing they will not see on
  opening it.
- every bullet is a **complete sentence ending in a period**.
- present tense, describing the state of the branch ("Adds …", "Moves …",
  "Removes …") — stay consistent across all bullets.
- concise: one line each, no sub-bullets, no restating the diff file by file.
  Name files or commands in backticks when it helps a reviewer find the change.
- ordered so that foundational changes come before what builds on them.
- call out anything a reviewer must act on — a breaking change, a required
  migration, a new required env var — in its own bullet.

`## Why`:

- usually a **single bullet**, because a branch usually has one reason. Use
  multiple bullets only when there are genuinely separate motivations.
- complete sentences ending in periods, same as `## What`.
- gives the motivation, not a restatement of the change: the problem it solves,
  the friction it removes, the request or incident behind it.
- draws on commit bodies, linked issues, and `TODO`/`FIXME` comments the branch
  removes. If nothing in the branch explains the motivation, say so in your
  reply and offer a best guess as the bullet — mark it as a guess rather than
  presenting an invented reason as fact.

Keep the whole body short enough to read in one pass. More bullets than the
branch has changed files is a reliable sign they describe the contents of a
change rather than the change itself — merge them.

A single-commit branch adding one file looks like this, and no longer:

```
feat(claude): Add eb-git-cleanup skill for grouping commits

## What

- Adds `.claude/skills/eb-git-cleanup/SKILL.md`, a skill that reads the working
  tree and proposes a grouping of the changes into cohesive commits.
- Learns the commit conventions from recent history rather than assuming a
  fixed format.

## Why

- Staging a sprawling working tree by hand tends to produce one catch-all
  commit, which makes the history hard to review later.
```

### 5. Deliver it

Print the description in a single fenced block so it can be copied in one go,
then note separately:

- the base branch and commit count the description covers
- any uncommitted changes, skipped files, or guessed motivation

Stop there. Do not create, push, or edit a PR, and do not run `gh pr create` or
`gh pr edit`, unless the user asks for that as a follow-up — if they do, pass
the body via a file (`--body-file`) so the markdown survives intact.

## Scope

This skill writes text. It does not commit, rebase, push, or open pull
requests.
