local report = {}

local function is_simple_type(v)
    local t = type(v)
    return t == "nil" or t == "number" or t == "boolean" or t == "string"
end

local function pretty_print(data)
    print("=== LuaVM-FunctionTester Report ===")
    if data.meta then
        print("schema:", data.meta.schema, "lua_version:", data.meta.lua_version, "generated:", data.meta.generated)
    end
    for lib,entry in pairs(data.libs or {}) do
        if entry.exists then
            print(lib.." => exists / "..tostring(entry.type))
        else
            print(lib.." => MISSING")
        end
        if entry.members then
            for m,mt in pairs(entry.members) do
                print("  - "..m.." : "..tostring(mt))
            end
        end
    end
    print("Globals:")
    for g,v in pairs(data.globals or {}) do
        print("  "..g.." => "..(v.exists and "function" or "MISSING"))
    end
end

local function safe_encode(value, seen)
    seen = seen or {}
    local t = type(value)
    if is_simple_type(value) then
        if t == "string" then
            return string.format("%q", value)
        else
            return tostring(value)
        end
    elseif t == "table" then
        if seen[value] then return '"<recursive>"' end
        seen[value] = true
        local parts = {}
        for k,v in pairs(value) do
            local key = type(k) == "string" and string.format("%q", k) or ("["..tostring(k).."]")
            local val = safe_encode(v, seen)
            table.insert(parts, key..":"..val)
        end
        return "{"..table.concat(parts, ",").."}"
    else
        return string.format("%q", "<"..tostring(t)..">")
    end
end

function report.print(data)
    pretty_print(data)
end

function report.write_json(path, data)
    local ok, f = pcall(function() return io.open(path, "w") end)
    if not ok or not f then return false end
    f:write(safe_encode(data))
    f:close()
    return true
end

return report
