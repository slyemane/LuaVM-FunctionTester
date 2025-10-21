# LuaVM-FunctionTester

Advanced Luau/Lua environment diagnostic and function tester.

**Repository credit:** Maintained by `@slyemane`.

## Summary

LuaVM-FunctionTester inspects a Lua/Luau runtime's global environment, safely probes standard
libraries and selected members, runs a curated suite of non-invasive tests, and emits
both console and JSON reports. This distribution is prepared for publication (CI, test runner,
contributor guidance, and safer JSON encoding included).

## What's new compared to prototype

- Robust test runner that executes all `tests/*.lua` and summarizes results
- Safer JSON encoder that avoids infinite recursion and skips userdata
- Added metadata: interpreter version, timestamp, schema version
- GitHub Actions workflow to run tests on push/pull requests
- CONTRIBUTING.md and CHANGELOG.md
- Credits file naming `@slyemane` as the maintainer

## Quick start (local Lua)

```bash
git clone https://github.com/slyemane/LuaVM-FunctionTester.git
cd LuaVM-FunctionTester
lua src/main.lua
```

## Quick start (Roblox Studio / Luau)

- Convert `src/*.lua` into ModuleScripts.
- Call `env_check.run()` from a Script or LocalScript and inspect output.

## Output

- Human-readable console output
- `vm_report.json` with schema and metadata (if run in an environment with filesystem access)

## License

MIT
