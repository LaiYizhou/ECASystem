-- table模块的扩展函数

local table = table
local tostring = tostring
local type = type

function table.clear(tab)
    for k, _ in pairs(tab) do
        tab[k] = nil
    end
end

function table.removeItem(list, item, removeAll)
    local rmCount = 0
    for i = #list, 1, -1 do
        if list[i] == item then
            table.remove(list, i)
            if removeAll then
                rmCount = rmCount + 1
            else
                return 1
            end
        end
    end
    return rmCount
end

function table.contains(tbl, element)
  if tbl == nil then
        return false
  end

  for _, value in pairs(tbl) do
    if value == element then
      return true
    end
  end
  return false
end

function table.getCount(self)
    local count = 0

    if self then
        for k, v in pairs(self) do
            count = count + 1
        end
    end

    return count
end

function table.merge(dest, src)
    for k, v in pairs(src) do
        dest[k] = v
    end
end

function table.mergeList(dest, src, fromIdx, toIdx)
    fromIdx = fromIdx or 1
    toIdx = toIdx or #src
    for i = fromIdx, toIdx do
        table.insert(dest, src[i])
    end
end

-- in a, not in b
function table.arrayDiff(a, b)
    local union = {}
    for _, val in pairs(a) do union[val] = true end
    for _, val in pairs(b) do union[val] = nil end

    local ret = {}
    for _, val in pairs(a) do
        if union[val] then
            ret[#ret + 1] = val
        end
    end
    return ret
end

function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.keys(hashtable)
    local keys = {}
    for k, _ in pairs(hashtable) do
        keys[#keys + 1] = k
    end
    return keys
end

function table.values(hashtable)
    local values = {}
    for _, v in pairs(hashtable) do
        values[#values + 1] = v
    end
    return values
end

-- From http://lua-users.org/wiki/TableUtils
function table.valToStr(v)
    if "string" == type(v) then
        v = string.gsub(v, "\n", "\\n")
        if string.match(string.gsub(v, "[^'\"]", ""), '^"+$') then
            return "'" .. v .. "'"
        end
        return '"' .. string.gsub(v, '"', '\\"') .. '"'
    else
        return table.tostring(v)
    end
end

function table.keyToStr(k)
    if "string" == type(k) and string.match(k, "^[_%a][_%a%d]*$") then
        return k
    else
        return "[" .. table.valToStr(k) .. "]"
    end
end

function table.sum(tbl)
    local s = 0
    for _, v in pairs(tbl) do
        s = s + v
    end
    return s
end

function table.maxKey(tbl)
    local max
    for k, v in pairs(tbl) do
        if max == nil then
            max = k
        else
            if k > max then
                max = k
            end
        end
    end
    return max
end

function table.tostring(tbl)
    if "table" ~= type(tbl) or (tbl.__cname ~= "OrderedTable" and tbl.__cname ~= nil) then
        return tostring(tbl)
    end
    local result, done = {}, {}
    for k, v in ipairs(tbl) do
        table.insert(result, table.valToStr(v))
        done[k] = true
    end
    for k, v in pairs(tbl) do
        if not done[k] then
            table.insert(result, table.keyToStr(k) .. "=" .. (table.valToStr(v) or "nil"))
        end
    end
    return "{" .. table.concat(result, ",") .. "}"
end

-- 深拷贝函数（拷贝配表数据，拷贝出来的table将不再是readonly的）
function table.dataCopy(t)
    return _deepCopy(t, {})
end

function _deepCopy(t, seen)
    local vt = type(t)


    if vt == "userdata" then
        if t.clone then
            return t:clone()
        else
            -- error("table.deepCopy: copy -- error type userdata")
            return nil
        end
    end

    if vt ~= "table" then
        return t
    end

    -- __data是引擎的包装，对应lua的真实table是__data
    -- 业务关注的也是lua数据，基础函数自动hook, 包装层对脚本开发应该不可见
    if rawget(t, "__data") then
        t = rawget(t, "__data")
    end

    if seen[t] ~= nil then
        return seen[t]
    end

    local ret = setmetatable({}, getmetatable(t))
    seen[t] = ret
    for k, v in pairs(t) do
        rawset(ret, k, _deepCopy(v, seen))
    end

    return ret
end

-- 深拷贝函数
function table.deepCopy(t)
    if type(t) ~= "table" then
        -- error(string.format("table deep copy cannot pass in non-table type %s", type(t)))
    end
    return _deepCopy(t, {})
end

-- 浅拷贝函数，只拷贝table内第一层元素
function table.copy(t)
    local ret = setmetatable({}, getmetatable(t))
    for k, v in pairs(t) do
        ret[k] = v
    end
    return ret
end

function table.setMapDefault(t, key, value)
    if t[key] == nil then
        t[key] = value
    end
    return t[key]
end

function table.getMapDefault(t, key)
    if t then
        return t[key]
    else
        return nil
    end
end

function table.listmerge(dest, src)
    for _, v in pairs(src) do
        dest[#dest + 1] = v
    end
end

function table.listIntersection(lhs, rhs)
    local ret = {}
    for _, i in ipairs(lhs) do
        for _, j in ipairs(rhs) do
            if i == j then
                ret[#ret + 1] = i
            end
        end
    end
    return ret
end

function table.equals(lhs, rhs)
    local ks = 0
    for k, l in pairs(lhs) do
        local r = rhs[k]
        if type(l) ~= type(r) then
            return false
        end
        if type(l) == "table" then
            if not table.equals(l, r) then
                return false
            end
        else
            if l ~= r then
                return false
            end
        end
        ks = ks + 1
    end
    return table.nums(rhs) == ks
end

function table.isEmpty(tb)
    return next(tb) == nil
end

function table.new(narray, nhash)
    return {}
end

function table.setDefaultTable(tbl, key)
    local val = tbl[key]
    if not val then
        val = {}
        tbl[key] = val
    end
    return val
end

function table.slice(array, startPos, endPos)
    local result = {}
    for i = startPos, endPos do
        table.insert(result, array[i])
    end
    return result
end