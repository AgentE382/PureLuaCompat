-- Aux
function printf(...)
  local function wrapper(...) io.write(string.format(...)) end
  local status, result = pcall(wrapper, ...)
  if not status then error(result, 2) end
end

return -- option processing function
