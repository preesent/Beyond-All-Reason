# Git Workflow

This repository is a local clone of the official Beyond All Reason repository, with a personal fork configured for local custom changes.

## Current Remotes

The remotes are configured as:

```powershell
origin   https://github.com/preesent/Beyond-All-Reason.git
upstream https://github.com/beyond-all-reason/Beyond-All-Reason.git
```

`origin` is the personal fork and is used for pushing local work.

`upstream` is the official repository and is used only for fetching official updates. Its push URL has been disabled:

```powershell
git remote set-url --push upstream DISABLED
```

## Local Custom Branch

Local custom work should not be committed directly to `master`. Keep `master` aligned with official upstream, and put custom work on a separate branch:

```powershell
git switch -c local-custom-rules
```

The current local custom branch contains this commit:

```text
4a16782706 Add custom map rules and documentation
```

The commit includes:

- `custom/` map-specific game rule and UI extensions.
- `doc/` documentation files.
- Minimal loader changes in `luarules/gadgets.lua` and `luaui/barwidgets.lua`.

## Commit Local Changes

When committing custom changes, avoid `git add .` unless every untracked file is intentional. Prefer explicit paths:

```powershell
git add luarules/gadgets.lua luaui/barwidgets.lua custom doc
git commit -m "Add custom map rules and documentation"
```

## Push To Personal Fork

Push the custom branch to the personal fork:

```powershell
git push -u origin local-custom-rules
```

If HTTPS authentication fails with:

```text
Invalid username or token. Password authentication is not supported for Git operations.
```

then authenticate with a GitHub personal access token, GitHub Credential Manager, or switch `origin` to SSH:

```powershell
git remote set-url origin git@github.com:preesent/Beyond-All-Reason.git
git push -u origin local-custom-rules
```

SSH requires an SSH key already added to the GitHub account.

## Sync Official Updates

Use this flow to bring official updates into the local custom branch:

```powershell
git fetch upstream
git switch master
git pull --ff-only upstream master
git switch local-custom-rules
git rebase master
```

If conflicts occur during rebase:

```powershell
git status
```

Fix the conflicting files, then continue:

```powershell
git add <fixed-files>
git rebase --continue
```

After rebasing a branch that was already pushed, update the fork with:

```powershell
git push --force-with-lease origin local-custom-rules
```

Use `--force-with-lease` instead of plain `--force` because it refuses to overwrite remote work that was not present locally.

## Branch Roles

- `master`: official upstream tracking branch; keep it clean.
- `local-custom-rules`: personal custom changes; push this to the fork.
- `origin`: personal fork; push target.
- `upstream`: official repository; fetch/pull target only.
