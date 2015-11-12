-- Aux
function printf(...)
  local function wrapper(...) io.write(string.format(...)) end
  local status, result = pcall(wrapper, ...)
  if not status then error(result, 2) end
end

-- Garbage Collection
local oldcollectgarbage = collectgarbage
function collectgarbage(opt, arg)
  if opt ~= "generational" then
    oldcollectgarbage(opt, arg)
  end
end

-- bit32
local function cnot(x)
  return x == 0
end

local LUA_NBITS = 32
local ALLONES = (~(((~0) << (LUA_NBITS - 1)) << 1))

local function trim(x)
  print(x)
  return x & ALLONES
end

local function shift(r, i)
  print(r, i)
  if (i < 0) then  --[[ shift right? ]]
    i = -i
    r = trim(r)
    if (i >= LUA_NBITS) then r = 0
    else r = r >> i end
  else  --[[ shift left ]]
    if (i >= LUA_NBITS) then r = 0
    else r = r << i end
    r = trim(r)
  end
  return r
end

bit32 = {}
local bit32 = bit32

function bit32.arshift(r, i)
  if (i < 0 or cnot(r & (1 << (LUA_NBITS - 1)))) then
    return shift(r, -i)
  else  --[[ arithmetic shift for 'negative' number ]]
    if (i >= LUA_NBITS) then r = ALLONES
    else
      r = trim((r >> i) | ~(~0 >> (LUA_NBITS + i))) end  --[[ add signal bit ]]
    return r
  end
end

function bit32.band(...)
  local args = {...}
  local r = ~0
  for i = 1, #args do
    r = r & args[i]
  end
  return trim(r)
end

function bit32.bnot(r)
  return ~trim(r)
end

return -- option processing function
