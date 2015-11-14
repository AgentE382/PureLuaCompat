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

local function mask(n)
  return (~((ALLONES << 1) << ((n) - 1)))
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

local function fieldargs(f, w)
  w = w or 1  -- TODO: Make this use the debug library to change w by reference
  assert(0 <= f, "field cannot be negative")
  assert(0 < w, "width must be positive")
  if (f + w > LUA_NBITS) then
    error("trying to access non-existent bits") end
  return f
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
local band = bit32.band

function bit32.bnot(r)
  return ~trim(r)
end

function bit32.bor(...)
  local args = {...}
  local r = 0
  for i = 1, #args do
    r = r | args[i]
  end
  return trim(r)
end

function bit32.btest(...)
  return band(...) ~= 0
end

function bit32.bxor(...)
  local args = {...}
  local r = 0
  for i = 1, #args do
    r = r ~ args[i]
  end
  return trim(r)
end

function bit32.extract(r, f, w)
  f = fieldargs(f, w)
  w = w or 1
  r = (r >> f) & mask(w)
  return r
end

function bit32.replace(r, v, f, w)
  f = fieldargs(f, w)
  local m = mask(w)
  v = v & m  --[[ erase bits outside given width ]]
  r = (r & ~(m << f)) | (v << f)
  return r
}

return -- option processing function
