---
name: eb-git-cleanup
version: 0.1.0
description: Inspect the working tree (staged, unstaged, and untracked changes), learn this repo's commit conventions from recent history, and propose a grouping of the changes into a sequence of cohesive commits with written messages. Use when the user asks to clean up, organize, group, split, or stage changes into commits, or asks "how should I commit this?".
---

Turn a messy working tree into an ordered set of cohesive commits that match
this repo's existing commit style.

Every convention in this skill is derived per repo. Nothing here assumes a
house style — read the repo, then follow it.

## Steps

### 1. Survey the working tree

Confirm there is something to work with first:

```bash
git rev-parse --is-inside-work-tree
```

If that fails, stop and say so — this skill needs a git repo.

Then run these together — they are independent:

```bash
git status --porcelain=v1
git diff --stat
git diff --cached --stat
git ls-files --others --exclude-standard
```

Then read the actual content. Do not propose commits from filenames alone:

- `git diff` and `git diff --cached` for tracked changes
- For untracked files, read them directly (`cat`, `sed -n '1,120p'`) — new
  directories can hold many files, so sample enough to know what each one is
- Note anything that should probably be ignored rather than committed
  (editor state, build output, caches, dependency directories, secrets,
  credentials, large binaries) and call it out separately instead of folding
  it into a commit

If the tree is clean, say so and stop.

### 2. Learn the commit style from history

```bash
git log --pretty=format:'%s' -40
git log -10 --pretty=format:'---%n%B'
git log -6 --stat
```

Derive from what you see, not from a generic convention:

- the **prefix vocabulary** actually in use and what each one covers —
  Conventional Commit types, area or component names, a mix of both, or no
  prefixes at all
- subject **mood, case, and length**
- whether bodies are used, and for what kind of change
- any **trailers** that appear on recent commits — carry a trailer only if
  recent history already uses it
- typical **commit size** — how many files and how much ground one commit covers

Weight recent commits over old ones. A repo's style often shifts partway
through its history; when old and new disagree, follow the recent convention
and mention the shift.

Written conventions beat inferred ones, so also check for them:

```bash
ls CONTRIBUTING.md CLAUDE.md AGENTS.md .gitmessage 2>/dev/null
git config --get commit.template
```

along with any `commitlint`/`.commitlintrc*` config or `commit-msg` hook in
`.husky/` or `.git/hooks/`. If a written rule conflicts with history, follow
the written rule and say why.

If there is no usable history — a fresh repo, a lone initial commit, or a
shallow clone — say so explicitly and fall back to:

- `<type>: <lowercase imperative summary>`, no trailing period, ~72 chars
- Conventional Commit types (`feat`, `fix`, `docs`, `refactor`, `test`,
  `chore`, `build`, `ci`) with an optional `(scope)`
- body only when the change needs explanation, wrapped at ~72 chars after a
  blank line following the subject

### 3. Group the changes

One commit = one reviewable idea. Prefer these seams, in order:

1. **Intent** — a feature, a fix, a test, a docs change, a tooling or config
   change, a rename/restructure. Never mix a restructure with new content.
2. **Area** — the boundaries this repo actually has: top-level directories,
   packages or modules, source vs tests vs docs, and repo-root config (build
   files, CI, `.gitignore`, editor and agent config). Read the tree to find
   the areas; do not assume a layout.
3. **Dependency order** — anything later commits build on goes first;
   `.gitignore` updates precede the commits whose files they affect.

Rules of thumb:

- A set of files that only makes sense together (e.g. a source file + its
  Dockerfile + run script) is one commit, not three.
- A self-contained addition on its own topic — one script, one doc, one
  module — is its own commit.
- Keep a change and its tests together unless the repo's history shows they
  are habitually split.
- Each commit should leave the repo in a coherent state: code that builds,
  docs that do not reference files added later.
- If a single file contains two unrelated changes, say so and propose
  `git add -p` for it rather than silently lumping them together.

### 4. Present the plan

Report before changing anything. Lead with the convention you derived in
step 2 and where it came from (recent history, a written rule, or the
fallback), so the user can correct it before any commit exists.

Then, for each proposed commit, in order:

```
Commit N: <subject line in repo style>

  <body, if the change warrants one>

  Files:
    path/one
    path/two
  Why: <one line — what makes these one unit>
```

Follow the list with:

- anything deliberately **left out** (ignore candidates, incomplete work,
  files you could not classify) and why
- any file needing a **split** via `git add -p`

Then ask whether to create the commits as proposed. Do not commit without
approval. Do not push.

### 5. Execute on approval

For each commit in order:

```bash
git reset                                   # once, up front, if the index
                                            # does not match the plan
git add -- <explicit paths>
git commit -m "<subject>" -m "<body>" -m "<trailers>"
```

- Stage **explicit paths** only — never `git add -A` or `git add .`
- Pass `-m` for the body and trailers only when the plan includes them
- Verify with `git status --porcelain` after each commit that only the
  intended paths were consumed
- If a commit fails (hook, empty tree), stop and report rather than
  continuing down the list
- Finish with `git log --oneline -<N>` and a one-line summary of what remains
  uncommitted

## Scope

This skill only stages and commits. It does not push, rebase, amend published
commits, or touch branches unless the user explicitly asks for that as a
follow-up.
