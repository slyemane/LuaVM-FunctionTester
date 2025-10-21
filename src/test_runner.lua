local M = {}

local function safe_dofile(path)
    local ok, res = pcall(function()
        local f, err = loadfile(path)
        if not f then error(err) end
        return f()
    end)
    return ok, res
end

function M.run_tests()
    local results = {}
    local lfs_ok, lfs = pcall(function() return require("lfs") end)
    local base = "./tests"
    local ok, handle = pcall(function() return io.open(base, "r") end)
    if not ok then
        local predefined = {"tests/basic_math.lua","tests/string_ops.lua","tests/coroutine_test.lua"}
        for _,p in ipairs(predefined) do
            local name = p:match("tests/(.*)%.lua") or p
            local s, r = safe_dofile(p)
            results[name] = {passed = s, detail = (s and "OK" or tostring(r))}
        end
        return results
    end

    local files = {}
    local dir = io.popen('ls "'..base..'"')
    if dir then
        for file in dir:lines() do
            if file:match("%.lua$") then table.insert(files, base.."/"..file) end
        end
        dir:close()
    end

    for _,p in ipairs(files) do
        local name = p:match("tests/(.*)%.lua") or p
        local s, r = safe_dofile(p)
        results[name] = {passed = s, detail = (s and "OK" or tostring(r))}
    end
    return results
end

return M
