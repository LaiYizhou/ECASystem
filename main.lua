
require("luaCommon.__init__")
require("ECASystem.__init__")

require_ex("skill")

Father = DefineClass("Father")
function Father:ctor(name)
    self.name = name
    self.position = {100, 100, 100}
end

Child = DefineClass("Child", Father)
function Child:ctor(name)
    Father.ctor(self, name)
end

Puppet = DefineClass("Puppet")
function Puppet:ctor(name)
    self.name = name
    self.position = {20, 20, 20}
end

local skillData = require("skill_data")

local father = Father.new("XiaoTou")
local child = Child.new("DaTou")
local ant = Puppet.new("ant")
child.puppet = ant

local skill = Skill.new(child)
skill:initECASystem(skillData[101])
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
skill:start()
