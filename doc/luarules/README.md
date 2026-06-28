# LuaRules 模块文档索引

这个目录按模块说明 `luarules` 的内容。`doc/LuaRulesOverview.md` 是总览，这里的文档用于更具体地说明每个模块的职责、关键文件、加载关系和修改入口。

## 模块

| 文档 | 对应路径 | 内容 |
| --- | --- | --- |
| [EntryRuntime.md](EntryRuntime.md) | `luarules/*.lua` | LuaRules 入口、gadget 管理器、gadget 运行环境和通用入口文件。 |
| [Gadgets.md](Gadgets.md) | `luarules/gadgets` | 规则 gadget 的加载模型、命名分组、共享目录和修改建议。 |
| [Configs.md](Configs.md) | `luarules/configs` | 规则层配置、PVE/AI/地图配置和数据维护方式。 |
| [MissionAPI.md](MissionAPI.md) | `luarules/mission_api` | 单人任务 trigger/action API、schema、loader 和 dispatcher。 |
| [Utilities.md](Utilities.md) | `luarules/Utilities` | LuaRules 专用工具库、单位/特征渲染 helper 和 Damgam 工具。 |
| [Images.md](Images.md) | `luarules/images` | 规则层图片资源及使用注意事项。 |

## 阅读顺序

1. 先读 [EntryRuntime.md](EntryRuntime.md)，理解 LuaRules 怎么启动和加载 gadget。
2. 再读 [Gadgets.md](Gadgets.md)，按文件名前缀定位具体规则。
3. 如果要改数据驱动内容，读 [Configs.md](Configs.md)。
4. 如果要改单人任务或场景触发，读 [MissionAPI.md](MissionAPI.md)。
5. 如果要复用工具函数或理解 spawn/position helper，读 [Utilities.md](Utilities.md)。

## 边界说明

LuaRules 负责会影响对局结果的规则逻辑。修改 synced 侧代码时要保持确定性，不要依赖本地时间、客户端状态或非同步随机源。纯显示逻辑、HUD 和玩家本地交互通常属于 `luaui`。
