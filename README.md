# PureLuaCompat
Forward and backward compatibility between Lua versions, in pure Lua.

## Objective
To make code written in any version of Lua work on any other version, using only Lua itself.

## Scope
All published incompatibilities will be rectified, if possible in such a way as to allow unmodified programs for other versions of Lua to run after the compatibility layer is engaged. However, code will be provided to aid authors with porting their existing code if code modification is required.

Also, various environments may not include some of the standard library. Alternate implementations of compatibility layer functionality will be provided if possible.

## Roadmap
Initially, this project will be developed for the various minor versions of Lua 5. If I have more time, earlier versions of Lua will be added as far as feasible.

First, features that were removed will be re-added. Then, features that were added will be back-ported. Finally, features that were changed will be re-implemented as they were and made available for optional activation.

* Removed
  * 5.3
    * `bit32` library
    * Functions `math.atan2`, `math.cosh`, `math.sinh`, `math.tanh`, `math.pow`, `math.frexp`, and `math.ldexp`
  * 5.2
    * Event *tail return* in debug hooks
    * Function `module`
    * Functions `setfenv` and `getfenv`
    * Function `math.log10`
    * Function `loadstring`
    * Function `table.maxn`
    * Function `unpack`
    * Character class `%z` in patterns
    * Table package.loaders
    * Bytecode verification
  * 5.1
    * Pseudo-argument `arg`
    * Function `string.gfind`
    * Function `table.setn`
    * Function `loadlib`
    * Function `math.mod`
    * Functions `table.foreach` and `table.foreachi`
* Check on later
  * Better solution for garbage collector generational mode
