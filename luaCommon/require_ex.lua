local string_gsub = string.gsub
local strStarts   = string.starts

_G.loaded = {}

function loadfile_ex(moduleName)
    moduleName = string_gsub(moduleName, "%.", "/")
    moduleName = moduleName .. ".lua"
    local ret, msg = loadfile(moduleName)
    if ret then
        return ret, msg
    else
        -- error(msg)
        return nil, msg
    end
end

function require_ex(moduleName)
    if _G.loaded[moduleName] == nil then
        local ret, _ = loadfile_ex(moduleName)
        if ret == nil then
            return nil
        end
        local moduleEnv = setmetatable({}, {__index = _G})
        setfenv(ret, moduleEnv)()
        _G.loaded[moduleName] = moduleEnv
        return moduleEnv
    else
        return _G.loaded[moduleName]
    end
end