
require_ex("ECASystem.eca_system")

Skill = DefineClass("Skill")

function Skill:ctor(owner)
    self.owner = owner
    self._ecaSystem = ECASystem.new(self)
end

function Skill:initECASystem(data)
    self.skillId = data.skillId
    self._ecaSystem:initFromData(data.eca)
end

function Skill:start()
    self._ecaSystem:start()
end