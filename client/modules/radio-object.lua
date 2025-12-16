local config = require "shared.config"

local radioObject = nil

---@param model string
---@param placement table
local function spawnRadioObject(model, placement)
  local modelHash = lib.requestModel(model)
  local coords = GetEntityCoords(cache.ped)

  local obj = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false)
  SetModelAsNoLongerNeeded(modelHash)

  AttachEntityToEntity(
    obj, cache.ped,
    GetPedBoneIndex(cache.ped, placement.bone),
    placement.pos.x, placement.pos.y, placement.pos.z,
    placement.rot.x, placement.rot.y, placement.rot.z,
    true, true, false, true, 0, true
  )

  return obj
end

---@param mode 'holding' | 'speaking'
---@param selectedAnim string
local function getPlacementForAnimation(mode, selectedAnim)
  if mode == "holding" then
    return config.radioPlacement.holding
  end

  if selectedAnim == "ear" then
    return config.radioPlacement.holding
  end

  return config.radioPlacement.speaking
end

---@param mode 'holding' | 'speaking'
---@param selectedAnim string
local function attachRadio(mode, selectedAnim)
  if radioObject and DoesEntityExist(radioObject) then
    return
  end

  local placement = getPlacementForAnimation(mode, selectedAnim)
  radioObject = spawnRadioObject(config.model, placement)
end

local function removeRadio()
  if not radioObject then return end

  if DoesEntityExist(radioObject) then
    DeleteEntity(radioObject)
  end

  radioObject = nil
end

---@param controls number[]
local function handleControlRestrictions(controls)
  CreateThread(function()
    while LocalPlayer.state.radioActive do
      for i = 1, #controls do
        DisableControlAction(0, controls[i], true)
      end

      if config.disableShooting then
        DisablePlayerFiring(cache.ped, true)
      end

      Wait(0)
    end
  end)
end

return {
  attach = attachRadio,
  remove = removeRadio,
  handleRestrictions = handleControlRestrictions,
}
