-- matcha.lua
-- Credit: @slyemane

local function safe_rawget(name)
	local ok, v = pcall(function() return rawget(_G, name) or _G[name] end)
	return ok and v or nil
end

local libs = {
	math = {"abs","acos","asin","atan","atan2","ceil","clamp","cos","cosh","deg","exp","floor","fmod",
		"frexp","ldexp","log","log10","max","min","modf","noise","pi","pow","rad","random","randomseed",
		"round","sign","sin","sinh","sqrt","tan","tanh","lerp","map"},
	string = {"byte","char","find","format","gmatch","gsub","len","lower","match","rep","reverse",
		"split","sub","upper","pack","packsize","unpack"},
	table = {"clear","clone","concat","create","find","foreach","foreachi","freeze","getn","insert",
		"isfrozen","maxn","move","pack","remove","sort","unpack"},
	utf8 = {"char","codepoint","codes","len","offset","charpattern"},
	os = {"clock","date","difftime","time"},
	coroutine = {"create","resume","running","status","wrap","yield","isyieldable","close"},
	debug = {"traceback","info","profilebegin","profileend","resetmemorycategory"},
	task = {"wait","spawn","defer","delay","cancel"},
}

local userdata_targets = {
	game = {"GetService","FindFirstChild"},
	workspace = {"FindFirstChild","GetChildren","WaitForChild"},
}

local globals = {
	"assert","error","getfenv","getmetatable","ipairs","loadstring","next","pairs","pcall","print",
	"rawequal","rawget","rawlen","rawset","select","setfenv","setmetatable","tonumber","tostring",
	"type","unpack","warn","xpcall","typeof","require",
}

local total, working, missing = 0, 0, 0

print("=== Matcha Luau VM Functions Test ===")

for libName, members in pairs(libs) do
	local lib = safe_rawget(libName)
	if lib then
		print(libName.." => exists / "..type(lib))
		for _, fn in ipairs(members) do
			total = total + 1
			local ok, valType = pcall(function() return type(lib[fn]) end)
			if ok and valType == "function" then
				print("  - "..fn.." : function")
				working = working + 1
			else
				print("  - "..fn.." : MISSING")
				missing = missing + 1
			end
		end
	else
		print(libName.." => MISSING")
		total = total + #members
		missing = missing + #members
	end
end

for name, members in pairs(userdata_targets) do
	local obj = safe_rawget(name)
	if obj then
		print(name.." => exists / "..type(obj))
		for _, fn in ipairs(members) do
			total = total + 1
			local ok, valType = pcall(function()
				local success, v = pcall(function() return obj[fn] end)
				if not success then return nil end
				return type(v)
			end)
			if ok and valType == "function" then
				print("  - "..fn.." : function")
				working = working + 1
			else
				print("  - "..fn.." : MISSING")
				missing = missing + 1
			end
		end
	else
		print(name.." => MISSING")
		total = total + #members
		missing = missing + #members
	end
end

print("Globals:")
for _, g in ipairs(globals) do
	total = total + 1
	if type(_G[g]) == "function" then
		print("  - "..g.." : function")
		working = working + 1
	else
		print("  - "..g.." : MISSING")
		missing = missing + 1
	end
end

local percent = 0
if total > 0 then
	percent = math.floor((working / total) * 10000) / 100
end

print("----------------------------------------")
print("FUNCTIONS TEST SUMMARY")
print("Tested:", total)
print("Working:", working)
print("Missing:", missing)
print(string.format("Availability: %.2f%%", percent))
print("Credit: @slyemane")
print("----------------------------------------")
