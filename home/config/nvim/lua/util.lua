local mod = {}

function mod.list_find(haystack, needle)
  for i, v in ipairs(haystack) do
    if v == needle then
      return i
    end
  end
  return nil
end

function mod.list_remove_val(haystack, needle)
  local idx = mod.list_find(haystack, needle)
  if idx then
    table.remove(haystack, idx)
  end
  return haystack
end

-- for debugging: https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console#9173416
function mod.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

return mod
