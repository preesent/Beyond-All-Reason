# Mission API 模块

`luarules/mission_api` 是单人任务/场景逻辑的 trigger/action 框架。它把任务脚本中的 `Triggers` 和 `Actions` 读入 `GG.MissionAPI`，按 schema 做基础校验，再由 gadget 在对局中触发 action。

## 关键文件

| 文件 | 职责 |
| --- | --- |
| `actions_schema.lua` | 定义 action 类型枚举和各类型参数 schema。 |
| `triggers_schema.lua` | 定义 trigger 类型枚举和各类型参数 schema。 |
| `actions_loader.lua` | 读取 raw actions，复制到内部表并校验类型和必填参数。 |
| `triggers_loader.lua` | 读取 raw triggers，补齐 settings，校验 trigger 参数和 action 引用。 |
| `actions.lua` | action 的实际实现，例如启用/禁用 trigger、发送消息、生成/删除单位。 |
| `actions_dispatcher.lua` | 根据 action type 找到实现函数，并按 schema 顺序展开参数调用。 |

## 关联 gadget

| Gadget | 作用 |
| --- | --- |
| `luarules/gadgets/api_missions.lua` | Mission API loader。初始化 `GG.MissionAPI`，加载任务脚本、schema、loader 和 raw data。当前 `enabled = false`。 |
| `luarules/gadgets/api_missions_triggers.lua` | 监控 trigger 并派发 action。依赖 `GG.MissionAPI`，初始化时如果 Mission API 未建立会移除自身。 |

## 数据流

1. `api_missions.lua` 读取任务脚本，取得 `mission.Triggers` 和 `mission.Actions`。
2. `triggers_loader.lua` 预处理 triggers，补齐默认 settings。
3. `actions_loader.lua` 预处理 actions。
4. loader 把结果写入 `GG.MissionAPI.Triggers` 和 `GG.MissionAPI.Actions`。
5. `triggers_loader.lua` postprocess 阶段检查 trigger 引用的 action 是否存在。
6. `api_missions_triggers.lua` 在 call-in 中判断 trigger 条件，触发后通过 `actions_dispatcher.lua` 执行 action。

## 已定义类型

`actions_schema.lua` 已定义的 action 类型包括 trigger 开关、命令控制、buildlist 修改、单位/建筑/武器/特效生成、LOS、单位转移、镜头、暂停、媒体播放、消息和胜负处理。其中当前已有实现的主要是：

- `EnableTrigger`
- `DisableTrigger`
- `SpawnUnits`
- `DespawnUnits`
- `SendMessage`

`triggers_schema.lua` 已定义的 trigger 类型包括时间、单位存在/死亡/捕获/复活、区域进入/离开/停留、视野、feature、资源、统计、队伍死亡和胜负事件。当前 trigger 监控实现主要覆盖：

- `TimeElapsed`
- `UnitExists` 的部分路径

## Trigger 设置

loader 会为 trigger 补齐默认设置：

| 字段 | 含义 |
| --- | --- |
| `active` | 是否启用。默认 `true`。 |
| `repeating` | 是否可重复触发。默认 `false`。 |
| `prerequisites` | 前置 trigger 列表。默认空表。 |
| `maxRepeats` | 最大重复次数，可为空。 |
| `difficulties` | 可触发的任务难度集合，可为空。 |

运行时还会维护 `triggered` 和 `repeatCount`。

## 扩展建议

- 新增 action 时，先在 `actions_schema.lua` 添加类型和参数，再在 `actions.lua` 实现函数，最后在 `actions_dispatcher.lua` 建立 type 到函数的映射。
- 新增 trigger 时，先在 `triggers_schema.lua` 添加类型和参数，再在 `api_missions_triggers.lua` 对应 call-in 中添加条件判断。
- schema 的参数顺序会影响 dispatcher 展开参数的顺序，新增参数时要同步实现函数签名。
- 当前 Mission API 仍有 TODO 和未实现类型，启用前需要确认任务路径、modoption、难度和所有 trigger/action 类型都有实际处理逻辑。
