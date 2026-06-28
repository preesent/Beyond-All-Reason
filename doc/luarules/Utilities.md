# LuaRules Utilities 模块

`luarules/Utilities` 存放只适用于 LuaRules 的工具代码。通用工具应放在 `common/Utilities`；只有依赖 LuaRules 环境、规则层状态或 gadget 使用方式的代码才应放在这里。

## 加载方式

`luarules/utilities.lua` 会自动加载：

```lua
VFS.DirList('luarules/Utilities/', "*.lua")
```

这只覆盖 `luarules/Utilities` 这一层的 `.lua` 文件，不会递归加载子目录。因此：

- `luarules/Utilities/unitrendering.lua` 会作为规则层 utility 自动加载。
- `luarules/Utilities/damgam_lib/*.lua` 需要由具体 gadget 或库显式 `VFS.Include`。

## 根目录工具

| 文件 | 职责 |
| --- | --- |
| `unitrendering.lua` | 包装 `Spring.UnitRendering` 和 `Spring.FeatureRendering` 的 LOD/material 激活状态。只在 unsynced 可用时执行，提供 `GetLODCount`、`ActivateMaterial`、`DeactivateMaterial` 等 helper。 |

## `damgam_lib`

| 文件 | 职责 |
| --- | --- |
| `hashpostable.lua` | 根据分辨率把地图位置 hash 到格子，支持反查、距离排序和按中心点取附近格子。 |
| `nearby_capture.lua` | 处理附近单位捕获逻辑。 |
| `position_checks.lua` | 提供 PVE/生成逻辑常用的位置检查，例如平整度、陆海、占用、资源、视野、startbox、地图边缘、地表和岩浆检查。 |
| `spawn_queue.lua` | 分帧生成和销毁单位的队列，避免一次性创建/删除过多对象。 |
| `unit_swap.lua` | 把现有单位替换成另一种单位的 helper。 |

## 使用建议

- 高频 gadget 中使用工具函数时，要确认工具内部是否调用昂贵的地图扫描、单位查询或 LOS 检查。
- `spawn_queue.lua` 这类分帧工具需要调用方在 `GameFrame` 中持续消费队列。
- `position_checks.lua` 依赖地图高度、startbox、LOS、资源点等运行时状态，适合 synced 生成逻辑，但要注意确定性。
- 如果工具函数需要被 LuaUI、LuaRules 和 LuaIntro 共享，应迁移或新增到 `common/Utilities`，不要从其他环境直接依赖 `luarules/Utilities`。
