# luarules 目录说明

`luarules` 是游戏规则层。它运行在 Spring/Recoil 的 LuaRules 环境中，负责对局中的同步规则、单位行为、游戏模式、命令限制、AI/PVE 逻辑、地图机制、特效转发和部分 unsynced 绘制逻辑。

## 核心职责

- 加载和管理 gadgets。
- 响应引擎 call-in，例如 `GameFrame`、`UnitCreated`、`UnitPreDamaged`、`AllowCommand`、`DrawWorld`。
- 实现游戏模式、单位规则、命令规则、地图规则、PVE 规则。
- 在 synced 和 unsynced 两侧之间转发必要数据。
- 提供 `GG` 作为 gadget 之间共享状态。

## 入口文件

| 文件 | 含义 |
| --- | --- |
| `luarules/main.lua` | LuaRules 入口。兼容 Lua 5.1 的 `select`，然后加载 `luarules/gadgets.lua`。 |
| `luarules/gadgets.lua` | gadget 管理器。扫描 `luarules/gadgets/*.lua`，加载、排序、启用、禁用 gadget，并把引擎 call-in 分发到各 gadget。 |
| `luarules/system.lua` | 定义每个 gadget 可访问的全局环境，例如 `Spring`、`Game`、`UnitDefs`、`WeaponDefs`、`GG`、标准库和 Tracy stub。 |
| `luarules/utilities.lua` | LuaRules 环境下的辅助函数入口。 |
| `luarules/draw.lua` | 绘制相关入口。 |
| `luarules/colors.h.lua` | 颜色常量。 |

## 子目录

| 目录 | 含义 |
| --- | --- |
| `luarules/gadgets` | 主要规则脚本目录。每个 `.lua` 通常是一个 gadget，通过 `GetInfo()` 声明名称、层级和默认启用状态。 |
| `luarules/gadgets/include` | gadget 复用 helper，例如方向工具、shader helper、出生点工具、生成器工具等。 |
| `luarules/gadgets/ruins` | ruins/废墟相关蓝图和控制逻辑。 |
| `luarules/configs` | 规则层配置，例如碰撞体、AI 命名、Raptors/Scavengers 生成配置、地图气氛、FFA 起点等。 |
| `luarules/images` | 规则层使用的图片资源。 |
| `luarules/mission_api` | 任务 API，包含 actions/triggers 的 schema、loader 和 dispatcher。 |
| `luarules/Utilities` | 规则层工具代码，例如单位渲染和 Damgam 相关库。 |

## 模块文档

更细的模块说明见 `doc/luarules`：

| 文档 | 内容 |
| --- | --- |
| `doc/luarules/EntryRuntime.md` | 入口文件、gadget handler、运行环境和 synced/unsynced 边界。 |
| `doc/luarules/Gadgets.md` | gadget 加载模型、命名分组、共享目录和新增建议。 |
| `doc/luarules/Configs.md` | 规则层配置文件和数据维护建议。 |
| `doc/luarules/MissionAPI.md` | 任务 trigger/action API、schema、loader 和 dispatcher。 |
| `doc/luarules/Utilities.md` | LuaRules 专用工具和 Damgam helper。 |
| `doc/luarules/Images.md` | 规则层图片资源。 |

## gadget 命名分组

`luarules/gadgets` 的文件名前缀基本反映功能域：

| 前缀 | 大致含义 |
| --- | --- |
| `unit_` | 单位规则，数量最多。包括伤害、护盾、隐身、经验、运输、寻路限制、特殊武器、单位生成、单位状态等。 |
| `game_` | 对局规则和游戏模式基础逻辑，例如开局、结束、队伍资源、无共享、快速开始、重连/重启等。 |
| `cmd_` | 命令处理和限制，例如撤销、手动发射、工厂停止、区域 mex、玩家数据命令等。 |
| `gfx_` | 规则层驱动的图形效果，例如 GL4 单位特效、火焰、导弹、护盾、投射物绘制。 |
| `fx_` | 粒子、爆炸、水花、导弹烟雾等效果控制。 |
| `map_` | 地图机制，例如岩浆、水位、金属点、夜间模式、太阳处理、地形限制。 |
| `api_` | 给其他 gadget 或 LuaUI 使用的 API/事件桥。 |
| `ai_` | 简单 AI、命名、废墟蓝图测试等。 |
| `pve_` | PVE 机制，例如 boss、补给、builder controller、nuke controller。 |
| `scav_` / `raptor_` | Scavengers 和 Raptors 模式专用生成、状态和防御逻辑。 |
| `dbg_` / `dev_` | 调试、profiling、自动重载、测试辅助。 |
| `mo_` | modoption/game option 驱动的模式规则。 |

## 加载和执行机制

1. `luarules/main.lua` 加载 `luarules/gadgets.lua`。
2. `gadgets.lua` 根据是否启用 dev lua 选择 VFS 模式。
3. 加载根目录 `init.lua`，再加载 LuaGadgets 的基础定义、`luarules/system.lua`、call-ins 和 utilities。
4. 扫描 `luarules/gadgets/*.lua`。
5. 每个 gadget 在独立环境中执行，调用 `GetInfo()` 获取元信息。
6. 根据 `layer`、order 和 `enabled` 排序并启用。
7. 引擎触发 call-in 时，`gadgetHandler` 按列表分发给实现了对应函数的 gadget。

## synced 和 unsynced

LuaRules 同时涉及 synced 和 unsynced 两类执行环境：

- synced 侧负责确定性游戏逻辑，直接影响模拟结果。
- unsynced 侧负责本地显示、输入、部分绘制和从 synced 接收数据。
- 两侧常通过 `SendToUnsynced`、`RecvFromSynced`、`GG`、`SYNCED` 等机制配合。

修改会影响对战同步时，要格外注意确定性。不要在 synced 逻辑里使用本地时间、随机数或客户端状态，除非已有代码明确保证同步。

## 修改建议

- 改单位行为：先查 `luarules/gadgets/unit_*.lua`。
- 改游戏规则/模式：先查 `luarules/gadgets/game_*.lua` 或 `mo_*.lua`。
- 改命令限制：先查 `luarules/gadgets/cmd_*.lua`。
- 改 PVE：先查 `pve_*.lua`、`raptor_*.lua`、`scav_*.lua` 和 `luarules/configs/*spawn_defs.lua`。
- 改地图机制：先查 `map_*.lua` 和 `luarules/configs/Atmosphereconfigs`。
- 新增 gadget 时，要提供清晰的 `GetInfo()`，合理设置 `layer`，并确认是否会影响同步。
