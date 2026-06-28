# LuaRules 入口与运行时

这个模块覆盖 `luarules` 根目录下的入口文件和 gadget 运行环境。它决定 LuaRules 如何启动、如何扫描 gadget、每个 gadget 能看到哪些全局对象，以及 synced/unsynced call-in 如何被分发。

## 关键文件

| 文件 | 职责 |
| --- | --- |
| `luarules/main.lua` | LuaRules 主入口。补齐 Lua 5.1 兼容的 `select` 后加载 `luarules/gadgets.lua`。 |
| `luarules/draw.lua` | 绘制侧入口，当前同样转入 `luarules/gadgets.lua`。 |
| `luarules/gadgets.lua` | gadget handler。负责扫描、加载、排序、启用、禁用 gadget，并把引擎 call-in 分发给对应 gadget。 |
| `luarules/system.lua` | gadget 沙箱环境定义。把 `Spring`、`Game`、`UnitDefs`、`WeaponDefs`、`GG`、标准库、Tracy stub 等对象暴露给 gadget。 |
| `luarules/utilities.lua` | LuaRules 专用工具入口。自动加载 `luarules/Utilities/*.lua` 这一层的 Lua 文件。 |
| `luarules/colors.h.lua` | 规则层可 include 的颜色常量。 |

## 启动流程

1. 引擎加载 `luarules/main.lua`。
2. `main.lua` 使用 `VFS.Include` 进入 `luarules/gadgets.lua`。
3. `gadgets.lua` 选择 VFS 模式，加载根目录 `init.lua`、LuaGadgets 基础定义、`luarules/system.lua`、call-in 列表和 `luarules/utilities.lua`。
4. handler 扫描 `luarules/gadgets/*.lua`，逐个构建 gadget 环境并执行文件。
5. 每个 gadget 通过 `gadget:GetInfo()` 提供 `name`、`desc`、`layer`、`enabled` 等元信息。
6. handler 按 `layer` 和加载顺序排序，注册 gadget 实现的 call-in。
7. 引擎触发 `GameFrame`、`UnitCreated`、`AllowCommand`、`DrawWorld` 等 call-in 时，handler 依序调用注册 gadget。

## gadget 环境

每个 gadget 在自己的环境中运行。`system.lua` 提供常用全局对象，但不会把所有宿主全局都直接暴露出来。常见可用对象包括：

| 对象 | 用途 |
| --- | --- |
| `Spring`、`Game`、`Engine`、`Platform` | 引擎 API、游戏状态和平台能力检查。 |
| `UnitDefs`、`WeaponDefs`、`FeatureDefs` | 单位、武器、特征物定义。 |
| `CMD`、`CMDTYPE`、`COB`、`SFX` | 命令、脚本和特效常量。 |
| `GG` | gadget 间共享状态和 API 的主要位置。 |
| `SendToUnsynced`、`SYNCED` | synced/unsynced 通信入口。 |
| `VFS` | 加载配置、helper 和数据文件。 |

## synced 与 unsynced

LuaRules 同时存在 synced 和 unsynced 侧：

- synced 侧负责确定性模拟，影响真实对局结果。
- unsynced 侧负责本地显示、部分输入、绘制和从 synced 接收数据。
- 常见通信方式是 `SendToUnsynced`、`RecvFromSynced`、`Script.LuaUI.*`、`GG` 和 `SYNCED`。

修改 synced 逻辑时要避免客户端本地状态、非确定性随机数、真实时间和只在某个玩家机器上存在的数据。显示和提示类逻辑优先放在 unsynced 或 LuaUI。

## 修改建议

- 改加载顺序或 call-in 分发时，先读 `luarules/gadgets.lua` 的 `LoadGadget`、`FinalizeGadget`、`InsertGadgetRaw`、`UpdateCallIns`。
- 改 gadget 可见的全局对象时，改 `luarules/system.lua`，并确认不会污染 synced 环境。
- 给所有 gadget 增加通用 helper 时，优先放 `common/Utilities`；只有 LuaRules 专用 helper 才放 `luarules/Utilities`。
- 新增入口级逻辑要格外保守，因为它会影响所有 gadget 的加载和执行。
