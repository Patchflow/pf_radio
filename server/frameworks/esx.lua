local ESX = exports.es_extended:getSharedObject()

---@param source number
---@param groups string[]
function DoesPlayerHaveGroup(source, groups)
  local player = ESX.GetPlayerFromId(source)

  if not player or not player.job then
    return false
  end

  local jobName = player.job.name

  return lib.table.contains(groups, jobName)
end
