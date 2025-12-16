local Proxy = require "@vrp/lib/Proxy"
local vRP = Proxy.getInterface("vRP")

---@param source number
---@param groups string[]
function DoesPlayerHaveGroup(source, groups)
  local userId = vRP.getUserId({ source })

  if not userId then
    return false
  end

  local userJobGroup = vRP.getUserGroupByType({ userId, "job" })

  return lib.table.contains(groups, userJobGroup)
end
