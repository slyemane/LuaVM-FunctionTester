local env_check = require(script:WaitForChild("env_check"))
local report = require(script:WaitForChild("report"))
local runner = require(script:WaitForChild("test_runner"))

local results = env_check.run()
report.print(results)

local ok = report.write_json("vm_report.json", results)
if ok then print("vm_report.json written") end

local summary = runner.run_tests()
print("=== Test Summary ===")
for name,res in pairs(summary) do
    print(name, res.passed and "PASS" or "FAIL", "("..tostring(res.detail)..")")
end
