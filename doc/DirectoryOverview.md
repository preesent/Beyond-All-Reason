# 目录说明

这份说明用于快速理解 `BAR.sdd` 里每个顶层文件夹的职责。它是一个 Beyond All Reason 的 Spring/Recoil 游戏包，目录大致可分为资源、规则、UI、测试和工具几类。

## 顶层目录

| 目录 | 含义 |
| --- | --- |
| `.github` | GitHub 的 issue 模板和 CI 配置。 |
| `.vscode` | 编辑器配置。 |
| `anims` | 动画序列贴图资源。 |
| `bitmaps` | 通用位图资源，例如载入图、贴花、烟雾、界面图。 |
| `common` | 通用 Lua 工具库和跨环境公共函数。 |
| `doc` | 项目文档。 |
| `effects` | CEG / 特效定义，包含爆炸、火焰、烟尘、轨迹等。 |
| `features` | 地图特征物定义，例如树、石头、残骸和装饰物。 |
| `fonts` | 字体资源。 |
| `gamedata` | 引擎加载的核心数据汇总层，包括单位、武器、声音、阵营等。 |
| `icons` | 图标资源和图标 atlas。 |
| `language` | 多语言翻译文件。 |
| `luaintro` | 进入游戏/载入阶段的 Lua 逻辑。 |
| `luarules` | 同步游戏规则层，控制单位行为、游戏模式、AI、地图机制等。 |
| `luaui` | 非同步 UI 层，包含 HUD、Widget、菜单、测试和 UI 资源。 |
| `modelmaterials` | 旧渲染管线的模型材质定义。 |
| `modelmaterials_gl4` | GL4 渲染管线的模型材质与模板。 |
| `modules` | 可复用 Lua 模块。 |
| `music` | 背景音乐资源。 |
| `objects3d` | 3D 模型资源，主要是单位、建筑、装饰物和特殊对象。 |
| `recoil-lua-library` | Recoil Lua 库子模块。 |
| `scripts` | 单位脚本，控制模型动画、武器、死亡效果等。 |
| `shaders` | GLSL shader 代码。 |
| `sidepics` | 阵营选择图。 |
| `singleplayer` | 单人任务和场景脚本。 |
| `sounds` | 音效和语音资源。 |
| `spec` | 自动化测试。 |
| `tools` | 开发和测试工具。 |
| `types` | Lua 类型声明和辅助类型。 |
| `unitbasedefs` | 单位基础定义模板。 |
| `unitpics` | 单位图标。 |
| `units` | 具体单位定义。 |
| `unittextures` | 单位贴图资源。 |
| `weapons` | 武器定义和特殊武器脚本。 |

## 读取顺序建议

通常可以按这个顺序理解整个项目：

1. `modinfo.lua`：识别游戏包基本信息。
2. `init.lua`：进入不同 Lua 环境时加载哪些公共模块。
3. `gamedata`：理解基础数据如何被组装。
4. `units`、`weapons`、`scripts`：理解具体单位与战斗表现。
5. `luarules`：理解游戏规则、模式和同步逻辑。
6. `luaui`：理解玩家界面和交互层。

## 结构关系

- `units` 定义单位是什么。
- `weapons` 定义单位怎么攻击。
- `scripts` 定义单位怎么动、怎么死、怎么挂载武器。
- `objects3d`、`unittextures`、`unitpics` 定义视觉资源。
- `luarules` 决定实际对局规则。
- `luaui` 负责界面表现和玩家交互。
- `common` 和 `modules` 提供公共代码，避免重复。

## 备注

这里的判断主要基于目录命名、文件类型分布，以及仓库入口文件的加载关系。对于某些子目录，具体职责会在对应脚本里再细分。
