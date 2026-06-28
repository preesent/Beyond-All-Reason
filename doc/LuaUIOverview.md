# luaui 目录说明

`luaui` 是玩家客户端 UI 和本地交互层。它运行在 Spring/Recoil 的 LuaUI 环境中，负责 HUD、Widget、快捷键、命令界面、图形显示、声音提示、玩家输入、RmlUi 组件和本地测试工具。

## 核心职责

- 加载和管理 widgets。
- 接收玩家输入，例如键盘、鼠标、手柄、文本输入。
- 绘制 HUD、建造菜单、资源栏、小地图、范围圈、提示框等。
- 管理本地显示效果，例如 GL4 地图/单位效果、LOS、贴花、阴影、云、雪、景深等。
- 处理用户配置、快捷键、布局、widget 选择器。
- 与 LuaRules 通过 LuaMsg、共享状态或事件桥交互。

## 入口文件

| 文件 | 含义 |
| --- | --- |
| `luaui.lua` | 根目录入口文件，由引擎加载 LuaUI 时使用。 |
| `luaui/main.lua` | LuaUI 主入口。设置 Gaia 队伍颜色、ctrlpanel，加载 `init.lua`、RmlUi、工具、定义、布局和 widget 管理器，并把引擎 call-in 转发给 `widgetHandler`。 |
| `luaui/barwidgets.lua` | BAR 的 widget 管理器。扫描并加载 `luaui/Widgets` 和 `luaui/RmlWidgets`，管理 widget 顺序、配置、权限、call-in 分发。 |
| `luaui/system.lua` | 定义每个 widget 可访问的全局环境，例如 `Spring`、`Game`、`gl`、`WG`、`UnitDefs`、`RmlUi`、`socket` 等。 |
| `luaui/callins.lua` | LuaUI 支持的 call-in 列表和映射。 |
| `luaui/setupdefs.lua` | 为 `UnitDefs`、`WeaponDefs`、`FeatureDefs` 补充便捷字段，并初始化本地化单位名/描述。 |
| `luaui/rml_setup.lua` | RmlUi 初始化。设置 shared context、dp ratio、字体和鼠标 cursor alias。 |

## 子目录

| 目录 | 含义 |
| --- | --- |
| `luaui/Widgets` | 主要 widget 目录，绝大多数 UI、命令、图形和本地逻辑都在这里。 |
| `luaui/RmlWidgets` | 使用 RmlUi 的 UI 组件目录。 |
| `luaui/configs` | UI 配置，例如快捷键、gridmenu、建造菜单、灯光/扭曲效果配置。 |
| `luaui/configs/hotkeys` | 快捷键配置文件。 |
| `luaui/images` | UI 图片、图标、贴花、面板背景、噪声图、状态图等。 |
| `luaui/sounds` | UI 层使用的声音资源。 |
| `luaui/Shaders` | UI/图形 widget 使用的 shader。 |
| `luaui/Headers` | 头文件式常量，例如 key symbol 和颜色。 |
| `luaui/Include` | widget 复用代码。 |
| `luaui/Scenarios` | UI 侧场景/压力测试相关内容。 |
| `luaui/Tests` | LuaUI 测试。 |
| `luaui/TestsExamples` | 测试示例和参考用例。 |

## widget 命名分组

`luaui/Widgets` 的文件名前缀基本代表功能：

| 前缀 | 大致含义 |
| --- | --- |
| `gui_` | HUD 和界面组件，数量最多。包括资源栏、建造菜单、聊天、提示框、玩家列表、选择面板、暂停界面等。 |
| `cmd_` | 玩家命令增强和快捷操作，例如队列管理、区域命令、快捷建造、攻击过滤、热键加载等。 |
| `unit_` | 本地单位控制或显示辅助，例如智能选择、自动修理、工厂辅助、单位状态偏好等。 |
| `gfx_` | 图形效果 widget，例如 GL4 高亮、贴花、LOS、云、雪、泛光、景深、SSAO。 |
| `api_` | 给其他 widget 使用的本地 API，例如单位追踪、蓝图、资源点、屏幕拷贝、共享状态。 |
| `dbg_` | 调试和开发工具，例如 widget profiler、测试 runner、自动重载、起点编辑器。 |
| `camera_` | 摄像机控制和辅助。 |
| `map_` | 地图显示与交互，例如起始框、地图边缘、小草、光照、地图标记。 |
| `snd_` | 声音通知、音量 OSD、单位完成提示等。 |
| `minimap_` | 小地图相关行为。 |

## 加载和执行机制

1. 引擎加载根目录 `luaui.lua`。
2. LuaUI 初始化后进入 `luaui/main.lua`。
3. `main.lua` 加载根目录 `init.lua`，初始化通用函数、i18n、命令、图形模块。
4. 加载 `rml_setup.lua`、`utils.lua`、`setupdefs.lua`、`savetable.lua`、`debug.lua`、`layout.lua`。
5. 加载 `barwidgets.lua`，创建 `widgetHandler`。
6. `widgetHandler` 扫描 `luaui/Widgets` 和 `luaui/RmlWidgets`，按配置和 `GetInfo()` 元信息启用 widget。
7. 引擎触发 `Update`、`DrawScreen`、`KeyPress`、`MousePress` 等 call-in 时，`main.lua` 转发给 `widgetHandler`。

## 用户 widget 限制

`barwidgets.lua` 会读取 modoptions：

- `allowuserwidgets`
- `allowunitcontrolwidgets`

在匿名模式、排位或特殊房间中，用户自定义 widget 可能被禁用。涉及 `Spring.GiveOrder*` 的用户 widget 属于 unit control 范畴，需要通过 `GetInfo().control = true` 或检查 `widget.canControlUnits` 来避免受限环境报错。相关说明见 `doc/RestrictedUserWidgets.md`。

## 与 LuaRules 的关系

- LuaUI 是本地客户端层，不应直接承担会影响同步结果的规则逻辑。
- LuaRules 负责确定性游戏规则，LuaUI 负责显示、输入和本地辅助。
- 两者通常通过 `SendLuaRulesMsg`、`RecvLuaMsg`、规则层 gadget 转发、`WG`/`GG` 桥接模式协作。

## 修改建议

- 改 HUD/界面：先查 `luaui/Widgets/gui_*.lua`。
- 改快捷键：先查 `luaui/configs/hotkeys` 和 `cmd_bar_hotkeys.lua`。
- 改建造菜单：先查 `gui_buildmenu.lua`、`gui_gridmenu.lua` 和 `luaui/configs/unit_buildmenu_config.lua`。
- 改图形效果：先查 `gfx_*.lua`、`luaui/Shaders`、`luaui/images`。
- 改 RmlUi 组件：先查 `luaui/RmlWidgets` 和 `luaui/rml_setup.lua`。
- 新增 widget 时，要实现 `widget:GetInfo()`，明确 `name`、`desc`、`author`、`layer`、`enabled`，涉及单位下令时标记 `control = true`。

