# LuaRules Gadgets 模块

`luarules/gadgets` 是规则层主体。每个 `.lua` 文件通常是一个 gadget，通过 `gadget:GetInfo()` 声明元信息，并实现引擎 call-in 来改变游戏规则、单位行为、命令权限、地图机制、PVE 逻辑或显示转发。

## 加载模型

- `luarules/gadgets.lua` 只扫描 `luarules/gadgets/*.lua` 这一层的 gadget 文件。
- `include` 和 `ruins` 子目录不会作为 gadget 自动加载，它们是 helper 和数据目录。
- gadget 的 `layer` 决定 call-in 执行顺序。低 layer 通常更早执行。
- `enabled = true` 的 gadget 默认启用；部分调试或实验 gadget 会根据 dev mode、modoption 或硬编码状态启用。
- `gadgetHandler:IsSyncedCode()` 常用于把 synced 和 unsynced 逻辑分开。

## 命名分组

文件名前缀是定位功能域的主要线索：

| 前缀 | 职责 |
| --- | --- |
| `unit_` | 单位规则。包括伤害、护盾、隐身、运输、特殊武器、死亡、经验、状态、碰撞、目标选择、工厂和建造行为。 |
| `game_` | 对局级规则。包括开局、结束、资源、共享限制、队伍状态、FFA、no rush、快速开始、重启和胜负条件。 |
| `cmd_` | 命令处理。包括命令限制、撤销、手动发射、区域 mex、停止生产、玩家数据命令和开发命令。 |
| `gfx_` | 规则层驱动的图形效果，多数与 GL4 单位/投射物/护盾/火焰/爆炸效果有关。 |
| `fx_` | 粒子和特效行为，例如导弹烟雾、水花、深水炸弹、回收碎片和大气效果。 |
| `map_` | 地图规则。包括岩浆、水位、金属点、夜间模式、太阳、地形限制和地图特效。 |
| `api_` | 给其他 gadget、LuaUI 或任务系统使用的 API/事件桥。 |
| `ai_` | AI 命名、废墟生成、简单 AI 和蓝图测试。 |
| `pve_` | PVE 控制逻辑，例如 boss、补给、builder controller、nuke controller 和附件系统。 |
| `scav_`、`raptor_` | Scavengers 和 Raptors 模式专用生成、防御、状态和拾取逻辑。 |
| `mo_` | modoption 驱动的模式规则，例如 FFA、battle royale、coop 和 commander counter。 |
| `dbg_`、`dev_` | 调试、profiling、自动重载、同步测试和开发辅助。 |
| `gui_`、`sfx_`、`snd_` | 向 UI 或声音层转发规则事件，或在规则层控制提示/音量相关状态。 |
| `feature_` | feature/残骸相关规则，例如死亡爆炸、碎片物理和 widget 转发。 |

## 共享子目录

| 路径 | 用途 |
| --- | --- |
| `luarules/gadgets/include` | gadget 复用 helper，例如方向工具、shader/LUT 生成、敌人生成库、可迭代 map 和 startbox 工具。 |
| `luarules/gadgets/ruins` | 废墟/遗迹蓝图数据和控制文件，主要由 `ai_ruins.lua`、`ai_ruin_blueprint_tester.lua` 等使用。 |

## 常见协作方式

- `GG.*` 用于在 gadget 间暴露共享状态或函数。
- `gadgetHandler:RegisterGlobal` 可注册 handler 管理的全局接口。
- `Script.LuaUI.*` 和消息代理常用于把规则事件转发给 UI。
- `SendToUnsynced`/`RecvFromSynced` 用于 synced 到 unsynced 的规则层通信。
- `VFS.Include` 用于加载 `configs`、`include`、`Utilities` 或其他数据文件。

## 定位建议

| 要改的内容 | 优先查找 |
| --- | --- |
| 单位是否能被攻击、运输、建造、回收、捕获 | `unit_*.lua` |
| 开局资源、出生点、队伍状态、胜负条件 | `game_*.lua`、`mo_*.lua` |
| 玩家命令能否执行、命令按钮是否出现 | `cmd_*.lua`、`api_build_blocking.lua` |
| GL4 特效、投射物/护盾/火焰表现 | `gfx_*.lua`、`fx_*.lua` |
| 地图特殊机制 | `map_*.lua` 和 `luarules/configs/Atmosphereconfigs` |
| Scavengers/Raptors/PVE | `scav_*.lua`、`raptor_*.lua`、`pve_*.lua`、对应 spawn defs |
| 单人任务触发 | `api_missions*.lua` 和 `luarules/mission_api` |

## 新增 gadget 清单

新增 gadget 时至少确认：

- `gadget:GetInfo()` 有清晰的 `name`、`desc`、`date`、`layer`、`enabled`。
- synced/unsynced 代码用 `gadgetHandler:IsSyncedCode()` 明确分支。
- 影响模拟结果的逻辑保持确定性。
- 如果依赖其他 gadget 的 `GG` API，要在 layer 或初始化时机上保证顺序。
- `AllowCommand`、`UnitPreDamaged`、`GameFrame` 等高频 call-in 要控制开销。
- 只服务开发的 gadget 应该受 dev mode、cheat 或配置保护。
