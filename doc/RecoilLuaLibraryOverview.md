# recoil-lua-library 目录说明

`recoil-lua-library` 是 Recoil Engine 的 Lua Language Server 类型库子模块。它主要服务开发阶段，用来给编辑器提供 Spring/Recoil Lua API 的类型提示、补全和静态检查辅助，不是游戏运行时核心逻辑目录。

## 核心职责

- 为 LuaLS 提供 Recoil/Spring API 类型声明。
- 让编辑器理解 `Spring`、`Script`、`VFS`、`gl`、call-in 等引擎对象。
- 改善 Lua 代码补全、跳转、诊断和参数提示。
- 保存从 Recoil 引擎接口生成的 API 声明文件。

## 顶层文件

| 文件 | 含义 |
| --- | --- |
| `recoil-lua-library/README.md` | 使用说明，说明如何作为子模块加入 Recoil 项目，并配置 `.luarc.json`。 |
| `recoil-lua-library/config.json` | LuaLS addon 配置，声明 Lua 5.1、require 路径、`VFS.Include`/`include`/`shard_include` 的特殊 require 行为。 |
| `recoil-lua-library/AI_POLICY.md` | 该子模块的 AI 使用/贡献策略说明。 |
| `recoil-lua-library/.git` | Git submodule 指针文件。 |

## library 目录

| 文件或目录 | 含义 |
| --- | --- |
| `library/Spring.lua` | Spring 全局 API 的类型入口。 |
| `library/Script.lua` | Script 全局对象的类型入口。 |
| `library/Types.lua` | 通用类型定义。 |
| `library/tracy.lua` | Tracy profiling 相关类型或 stub。 |
| `library/RulesSyncedCallins.lua` | LuaRules synced call-in 类型。 |
| `library/RulesUnsyncedCallins.lua` | LuaRules unsynced call-in 类型。 |
| `library/generated` | 从 Recoil 引擎源码/API 生成的类型声明。 |

## generated 目录

`library/generated/rts/Lua` 下的文件名对应 Recoil 引擎中的 Lua 绑定源文件，例如：

- `LuaSyncedRead.cpp.lua`
- `LuaSyncedCtrl.cpp.lua`
- `LuaUnsyncedRead.cpp.lua`
- `LuaUnsyncedCtrl.cpp.lua`
- `LuaOpenGL.cpp.lua`
- `LuaShaders.cpp.lua`
- `LuaVFS.cpp.lua`
- `LuaRules.cpp.lua`
- `LuaUI.cpp.lua`
- `LuaIntro.cpp.lua`

这些文件的作用是把引擎暴露给 Lua 的函数和常量转换成 LuaLS 能读懂的声明。

`library/generated/rts/Rml` 则对应 Recoil 的 RmlUi Lua 绑定类型。

## 与本仓库的关系

- 根目录 `.gitmodules` 把它作为子模块管理。
- 根目录 `.emmyrc.json`、`.luacheckrc`、`lux.toml` 等开发配置可能会配合它做类型检查或编辑器提示。
- `luaui`、`luarules`、`luaintro` 写代码时会大量调用 Recoil/Spring API，这个库让这些调用在编辑器里有类型信息。
- 游戏运行时并不通过这个目录加载规则或 UI 逻辑。

## 使用方式

典型 LuaLS 配置会把该目录加入 workspace library：

```json
{
  "runtime.version": "Lua 5.1",
  "workspace.library": [
    "recoil-lua-library"
  ],
  "runtime.special": {
    "VFS.Include": "require",
    "include": "require",
    "shard_include": "require"
  }
}
```

这样编辑器会把 `VFS.Include("...")` 和 `include("...")` 近似理解为模块加载，提升跳转和补全效果。

## 修改建议

- 一般业务开发不需要修改这个目录。
- 如果编辑器提示缺失某个 Recoil API，先确认子模块是否更新。
- 如果确实是类型声明缺失，应优先从上游 `recoil-lua-library` 或生成流程修复，而不是在游戏逻辑里绕过。
- 不要把游戏规则、UI 逻辑或资源放到这个目录；它是开发辅助库。

