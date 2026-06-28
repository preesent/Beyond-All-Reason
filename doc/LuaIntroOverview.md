# luaintro 目录说明

`luaintro` 是游戏进入和加载阶段运行的 Lua 环境。它在完整 LuaUI 和 LuaRules 进入稳定运行前执行，主要负责加载画面、加载进度、加载阶段音乐，以及部分引擎配置初始化。

## 核心职责

- 设置加载阶段需要的引擎配置。
- 初始化 Lua addon handler。
- 绘制加载画面和进度条。
- 显示本地化加载提示。
- 根据模式、节日、配置选择加载阶段音乐。
- 在加载结束时保存地图加载耗时缓存，用于下次估算进度。

## 入口文件

| 文件 | 含义 |
| --- | --- |
| `luaintro/main.lua` | LuaIntro 入口。加载根目录 `init.lua`，设置 `LUA_NAME`、`LUA_DIRNAME`、日志行为、VFS 模式，然后加载 LuaHandler 和 `springconfig.lua`。 |
| `luaintro/config.lua` | addon handler 的配置文件。定义安全包装、VFS 模式、addon 搜索路径。 |
| `luaintro/springconfig.lua` | 加载前设置 Spring/Recoil 引擎配置，例如渲染、图标、UI 缩放、GC、鼠标拖拽阈值、字体等。 |

## Addons 子目录

| 文件 | 含义 |
| --- | --- |
| `luaintro/Addons/main.lua` | 主要加载画面 addon。选择加载背景图，生成加载提示，绘制背景、进度条、警告信息，并处理 shader/字体资源释放。 |
| `luaintro/Addons/loadprogress.lua` | 加载进度估算。读取和写入 `loadprogress_cached.lua`，按地图记录上次加载耗时，用时间比例估算进度。 |
| `luaintro/Addons/music.lua` | 加载阶段音乐选择。按 Raptors、Scavengers、节日活动、地图音乐、原声/自定义音乐配置选择曲目并播放。 |
| `luaintro/Addons/engine_taskbar_control.lua` | 加载阶段任务栏/引擎窗口相关控制。 |

## 加载流程

1. `luaintro/main.lua` 被引擎调用。
2. 根目录 `init.lua` 加载通用函数和公共模块。
3. 设置 `LUA_NAME`、`LUA_DIRNAME`、日志过滤和 VFS 模式。
4. 加载 `LuaHandler/Utilities/utils.lua` 和 `LuaHandler/handler.lua`。
5. 根据 `luaintro/config.lua` 的配置查找 Addons。
6. `Addons/loadprogress.lua` 提供 `SG.GetLoadProgress()`。
7. `Addons/main.lua` 读取进度、背景图和提示文本并绘制加载界面。
8. `Addons/music.lua` 根据配置播放加载音乐。
9. 加载结束时 addon 的 `Shutdown()` 释放资源或写缓存。

## 与其他目录的关系

- 依赖根目录 `init.lua` 提供公共 Lua 工具、i18n、Spring 工具函数。
- 读取 `bitmaps/loadpictures` 作为加载背景图来源。
- 读取 `music/original`、`music/custom` 作为加载音乐来源。
- 使用 `language` 中的翻译键显示加载提示。
- 先于 `luarules` 和 `luaui` 的完整运行阶段，但加载过程中会显示 `Loading LuaRules`、`Loading LuaUI` 等状态。

## 修改建议

- 调整加载图和提示：优先看 `luaintro/Addons/main.lua`。
- 调整加载音乐：优先看 `luaintro/Addons/music.lua`。
- 调整加载前引擎默认配置：看 `luaintro/springconfig.lua`。
- 修改加载进度估算：看 `luaintro/Addons/loadprogress.lua`。

