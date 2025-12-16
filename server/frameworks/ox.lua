local Ox = require "@ox_core/lib/init"

---@param source number
---@param groups string[]
function DoesPlayerHaveGroup(source, groups)
  local player = Ox.GetPlayer(source)

  if not player then
    return false
  end

  return player.getGroup(groups)
end
