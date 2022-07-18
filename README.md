# ECASystem
skill system based on event-condition-action rescursion

### 举例

以如下导出的技能数据为例：

```lua
[101] = {
  ["skillId"] = 101,
  ["eca"] = {
    ["eventId"] = 701,	-- eventId
    ["conditionList"] = {
												-- 为nil（就默认true）
    },
    ["trueActionList"] =
    {
      {
        ["TYPE"] = 100,		-- Type为100: 位移Action
        ["unit"] = {			-- 参数1，unit
          ["TYPE"] = 201,	-- Type为201：召唤物
          ["unit"] = {		-- 参数1.1 unit
            ["TYPE"] = 200, -- Type为200：技能所有者
            ["skill"] = {		-- 参数1.1.1 skill
              ["TYPE"] = 500,	-- Type为500：技能本身
            }
          }
        },
        ["speed"] = {				-- 参数2，speed
          ["TYPE"] = 400,		-- Type为400：float常量
          ["val"] = 2.5,
        },
        ["targetPos"] = {		-- 参数3，targetPos
          ["TYPE"] = 301,		-- Type为301：两个Vector3的和
          ["leftVal"] = {		-- 参数3.1，leftVal
            ["TYPE"] = 302,	-- Type为302：单位的坐标
            ["unit"] = {		-- 参数3.1.1，unit
              ["TYPE"] = 201,	-- Type为201：召唤物（配置上同，不赘述）
              ["unit"] = {
                ["TYPE"] = 200,
                ["skill"] = {
                  ["TYPE"] = 500,
                }
              }
            },
          },
          ["rightVal"] = {		-- 参数3.2，rightVal
            ["TYPE"] = 300,		-- Type为300：Vector常量
            ["x"] = {					-- 参数3.2.1，x值
              ["TYPE"] = 400,	-- Type为400：float常量
              ["val"] = 10,
            },
            ["y"] = {
              ["TYPE"] = 400, -- Type为400：float常量
              ["val"] = 20,
            },
            ["z"] = {
              ["TYPE"] = 400, -- Type为400：float常量
              ["val"] = 30,
            },
          },
        },
      },
    },
    ["falseActionList"] = {

    },
  },
},
```



### 递归分析

概述一下便是：

- 当eventId701触发时，判断conditionList，成功则依次执行 trueActionList，失败则依次执行 falseActionList
- 对于某一个Action，比如 位移Action
  - 参数1：unit（如何求unit？）
    - 参数1.1：召唤物（如何求召唤物？）
      - 参数1.1.1：技能释放者（如何求技能？）
        - 参数1.1.1.1：当前技能<u>（递归出口，直接取值）</u>
  - 参数2：speed（如何求float值？）
    - 参数2.1：float常量 <u>（递归出口，直接取值）</u>
  - 参数3：targetPos（如何求Vector3值？）
    - 参数3.1：左值（如何求左值Vector3？）
      - 参数3.1.1：unit的脚底坐标（如何求unit？）
        - 参数3.1.1.1：召唤物（如何求召唤物？）
          - 参数3.1.1.1.1：技能释放者（如何求技能？）
            - 参数3.1.1.1.1.1：当前技能<u>（递归出口，直接取值）</u>
    - 参数3.2：右值（如何求右值Vector3？）
      - 参数3.2.1：x值（如何求float值？）
        - 参数3.2.1.1：float常量 <u>（递归出口，直接取值）</u>
      - 参数3.2.2：y值（如何求float值？）
        - 参数3.2.2.1：float常量 <u>（递归出口，直接取值）</u>
      - 参数3.2.3：z值（如何求float值？）
        - 参数3.2.3.1：float常量 <u>（递归出口，直接取值）</u>



所以这个技能的效果就是：让自己的召唤物，以2.5的速度，位移至 “自己的脚底坐标+Vector3(10, 20, 30)” 的位置
