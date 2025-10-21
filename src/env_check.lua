local M = {}
local probeMembers = {"spawn","delay","time","now","tick","GetService","FindFirstChild","print"}
local libs = {"math","table","string","utf8","coroutine","debug","os","task","workspace","game"}

local function safe_get(name)
    local ok, v = pcall(function() return rawget(_G, name) or _G[name] end)
    if not ok then return nil end
    return v
end

local function probe_table(tbl)
    local out = {}
    for _, m in ipairs(probeMembers) do
        local ok, mt = pcall(function()
            local v = tbl[m]
            return type(v)
        end)
        out[m] = (ok and mt) or "error"
    end
    return out
end

function M.run()
    local out = {}
    out.meta = {
        schema = "lua-vm-function-tester-1.0",
        generated = (os and os.time and os.time()) or 0,
        lua_version = _VERSION or "unknown"
    }
    out.libs = {}
    for _, name in ipairs(libs) do
        local g = safe_get(name)
        local entry = {exists = g ~= nil, type = type(g)}
        if type(g) == "table" or type(g) == "userdata" then
            entry.members = probe_table(g)
        end
        out.libs[name] = entry
    end
    out.globals = {}
    local globalsToCheck = {"print","pcall","xpcall","type","tostring","tonumber","loadstring"}
    for _, name in ipairs(globalsToCheck) do
        out.globals[name] = {exists = type(_G[name])=="function"}
    end
    return out
end

return M
