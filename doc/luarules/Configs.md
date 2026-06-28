# LuaRules Configs 模块

`luarules/configs` 存放规则层数据配置。它们通常被 gadget 通过 `VFS.Include` 加载，用于把单位名单、地图参数、PVE 生成表、AI 名字、命令描述和模式参数从执行逻辑中拆出来。

## 根目录配置

| 文件 | 用途 |
| --- | --- |
| `collisionvolumes.lua` | 单位或对象的碰撞体配置。 |
| `critters.lua` | Gaia critter/小动物相关配置。 |
| `customcmds.h.lua` | 旧式自定义命令导入入口。文件内提示新命令应放到 `modules/customcommands.lua`。 |
| `gui_soundeffects.lua` | UI/规则提示音效映射。 |
| `icon_generator.lua` | 图标生成相关配置。 |
| `map_biomes.lua` | 地图 biome 信息。 |
| `onoffdescs.lua` | ON/OFF 命令显示描述。 |
| `powerusers.lua` | 特权用户/开发权限相关名单。 |
| `quick_start_build_defs.lua` | quick start 初始建造/生成数据。 |
| `raptor_spawn_defs.lua` | Raptors 模式生成、难度、单位池、巢穴和 queen anger 相关配置。 |
| `scav_spawn_defs.lua` | Scavengers 模式生成、难度、boss、burrow、turret 和经济缩放配置。 |
| `timeslow_defs.lua` | 时间减速/相关单位或效果配置。 |

## 子目录

| 目录 | 用途 |
| --- | --- |
| `ai_namer` | AI 名字池，按阵营、贡献者、Raptors、Scavengers 等分类。由 `ai_namer.lua` 使用。 |
| `Atmosphereconfigs` | 地图大气、光照、天空、环境特效配置。与 `map_atmosphere_cegs.lua`、`fx_atmosphere.lua` 等配合。 |
| `BARb` | BARb LuaAI 的稳定版配置和脚本，按 easy/medium/hard/hard_aggressive 难度拆分。 |
| `ffa_startpoints` | 地图 FFA 起点配置，包含独立 README。由 FFA/startbox 相关 gadget 使用。 |

## 数据形态

这些配置大多返回 Lua table，常见 key 包括单位名、武器名、难度枚举、modoption 派生值、地图名和坐标。部分配置会在加载时读取 `Spring.GetModOptions()`、`UnitDefNames` 或地图参数，因此不是纯静态数据。

## 修改建议

- 改 PVE 难度或单位池时，先查 `raptor_spawn_defs.lua`、`scav_spawn_defs.lua`，再查消费它们的 `raptor_*.lua`、`scav_*.lua`、`pve_*.lua` gadget。
- 改 AI 名字只需维护 `ai_namer` 下的数据文件，避免在 `ai_namer.lua` 中硬编码。
- 改地图氛围时，优先在 `Atmosphereconfigs` 添加或调整地图配置，不要把地图名判断散落到 gadget。
- 改 FFA 起点时，同时阅读 `luarules/configs/ffa_startpoints/README.md`，保持地图文件命名和坐标格式一致。
- 新增配置文件时，优先让文件返回 table，并在消费 gadget 中集中校验字段，避免静默 nil 导致对局中报错。

## 同步注意

被 synced gadget 读取的配置会影响模拟结果。不要在这类配置中依赖本地文件状态、真实时间、客户端专有设置或非确定性随机逻辑。
