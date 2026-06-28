# LuaRules Images 模块

`luarules/images` 存放规则层引用的小型图片资源。它不是通用 UI 图库，主要服务 LuaRules gadget 或由规则层转发到 UI/显示逻辑的特殊标记。

## 当前资源

| 文件 | 说明 |
| --- | --- |
| `blank.png` | 空白占位图。 |
| `bullcup.png` | 特殊杯赛/标记图片。 |
| `comwreath.png` | commander wreath/装饰标记图片。 |
| `cow.png` | 特殊标记图片。 |
| `fuscup.png` | 特殊杯赛/标记图片。 |
| `traitor.png` | traitor/背刺或动态同盟相关提示图片。 |
| `license.txt` | 图片资源许可说明。 |

## 使用建议

- 新增规则层图片时，同时更新 `license.txt` 或相关许可文档。
- 如果资源只属于 HUD、菜单或 widget，优先放到 `luaui/images`。
- 如果资源由规则事件驱动但最终在 UI 显示，保留清晰命名，并在消费 gadget/widget 中注明用途。
- 不要把大体积通用贴图放在这里；地图、单位、UI 和特效资源应使用各自目录。
