# Git 工作流

这个仓库是从官方 Beyond All Reason 仓库 clone 下来的。本地同时配置了个人 fork，用来保存自己的修改。

## 当前远端配置

当前 remote 配置如下：

```powershell
origin   https://github.com/preesent/Beyond-All-Reason.git
upstream https://github.com/beyond-all-reason/Beyond-All-Reason.git
```

`origin` 是你的个人 fork，用来推送自己的分支和提交。

`upstream` 是官方仓库，只用来拉取官方更新。为了避免误推到官方仓库，已经禁用了 `upstream` 的 push 地址：

```powershell
git remote set-url --push upstream DISABLED
```

## 本地自定义分支

不要直接在 `master` 上提交自己的改动。推荐保持 `master` 和官方 `upstream/master` 一致，把自己的改动放到单独分支：

```powershell
git switch -c local-custom-rules
```

当前自定义分支包含这些提交：

```text
4a16782706 Add custom map rules and documentation
8c7d3fda5e Document fork sync workflow
```

这些提交包含：

- `custom/`：特定地图规则和 UI 扩展。
- `doc/`：项目说明文档。
- `luarules/gadgets.lua` 和 `luaui/barwidgets.lua`：极小的 custom 加载入口改动。

## 提交本地改动

提交时不要随手使用 `git add .`，除非确认所有未跟踪文件都要提交。更安全的方式是显式指定路径：

```powershell
git add luarules/gadgets.lua luaui/barwidgets.lua custom doc
git commit -m "Add custom map rules and documentation"
```

## 推送到个人 fork

把当前自定义分支推送到你的 fork：

```powershell
git push -u origin local-custom-rules
```

如果 HTTPS 推送失败，并出现类似错误：

```text
Invalid username or token. Password authentication is not supported for Git operations.
```

说明 GitHub 不再支持用账号密码推送。可以使用 GitHub personal access token、GitHub Credential Manager，或者把 `origin` 改成 SSH：

```powershell
git remote set-url origin git@github.com:preesent/Beyond-All-Reason.git
git push -u origin local-custom-rules
```

使用 SSH 前，需要先把本机 SSH key 添加到你的 GitHub 账号。

## 同步官方更新

以后要同步官方更新时，使用这个流程：

```powershell
git fetch upstream
git switch master
git pull --ff-only upstream master
git switch local-custom-rules
git rebase master
```

如果 rebase 过程中出现冲突，先查看冲突文件：

```powershell
git status
```

手动修复冲突后继续：

```powershell
git add <修复后的文件>
git rebase --continue
```

如果这个分支之前已经推送到 GitHub，rebase 后需要更新远端分支：

```powershell
git push --force-with-lease origin local-custom-rules
```

这里使用 `--force-with-lease`，不要直接用 `--force`。它会在远端有你本地不知道的新提交时拒绝覆盖，安全性更高。

## 分支和远端职责

- `master`：官方同步分支，保持干净，不直接放自己的改动。
- `local-custom-rules`：你的本地自定义分支，保存游戏规则、UI 和文档修改。
- `origin`：你的个人 fork，用来推送自己的分支。
- `upstream`：官方仓库，只用来拉取官方更新。

## 常用命令速查

查看当前状态：

```powershell
git status --short --branch
```

查看远端：

```powershell
git remote -v
```

查看最近提交：

```powershell
git log --oneline --decorate -5
```

推送当前分支：

```powershell
git push
```
