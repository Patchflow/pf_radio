---@param source number
---@param groups string[]
function DoesPlayerHaveGroup(source, groups)
  local hasGroup = exports.qbx_core:HasGroup(source, groups)
  return hasGroup
end
