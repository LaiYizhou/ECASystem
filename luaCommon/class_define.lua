local string_format = string.format

function DefineClass(classname, ...)
    local env = _G
    if env[classname] == nil then
        env[classname] = {__cname = classname}
    else
        setmetatable(env[classname], nil)
        env[classname].__cname = classname
    end

    local cls = env[classname]

    cls.__index = cls
    cls.__supers = nil
    if select("#", ...) > 0 then
        local supers = {...}
        for _, super in ipairs(supers) do
            local superType = type(super)
            assert(superType == "nil" or superType == "table",
            string_format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

            if superType == "table" then
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
            else
                error(string_format("class() - create class \"%s\" with invalid super type",
                classname), 0)
            end
        end

        if cls.__supers and #cls.__supers == 1 then
            setmetatable(cls, {__index = cls.__supers and cls.__supers[1]})
        elseif cls.__supers then
            local clsSupers = cls.__supers
            setmetatable(cls, {__index = function(_, key)
                for i = 1, #clsSupers do
                    local super = clsSupers[i]
                    local v = super[key]
                    if v ~= nil then
                        return v
                    end
                end
            end})
        end
    end


    cls.new = function(...)
        local instance = {}
        setmetatable(instance, cls)
        instance:ctor(...)
        return instance
    end

    rawset(cls, "__tostring", cls.__tostring)
    return cls
end