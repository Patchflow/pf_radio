if cache.resource ~= "pf_radio" then
  lib.print.error("Resource name must be 'pf_radio' for proper functionality.")
  return
end

local config = require "shared.config"
SetConvarReplicated("voice_enableRadioAnim", "0");

local function loadFramework()
  local frameworkPath = ("server.frameworks.%s"):format(config.framework)

  local success = pcall(require, frameworkPath)

  if not success then
    error(("Framework '%s' failed to load. Verify config settings."):format(config.framework))
  end
end

AddEventHandler("onResourceStart", function(resourceName)
  if resourceName ~= cache.resource then return end
  loadFramework()
end)

---@param source number
---@param slot number
---@return table|nil
local function getRadioSlot(source, slot)
  local slotData = exports.ox_inventory:GetSlot(source, slot)

  if not slotData or slotData.name ~= config.item then
    return nil
  end

  return slotData
end

---@param source number
---@param slot number
---@param metadata table
local function updateSlotMetadata(source, slot, metadata)
  exports.ox_inventory:SetMetadata(source, slot, metadata)
end

---@param channels table
---@param newChannel number
---@param maxRecent number
---@return table
local function updateRecentChannels(channels, newChannel, maxRecent)
  local updated = {}

  for _, ch in ipairs(channels) do
    if ch ~= newChannel then
      updated[#updated + 1] = ch
    end
  end

  table.insert(updated, 1, newChannel)

  while #updated > maxRecent do
    table.remove(updated)
  end

  return updated
end

---@param data {slot: number, channel: number}
RegisterNetEvent("pf_radio:setItemData", function(data)
  local slotData = getRadioSlot(source, data.slot)
  if not slotData then return end

  local metadata = slotData.metadata or {}
  metadata.lastChannel = data.channel
  metadata.recentChannels = updateRecentChannels(
    metadata.recentChannels or {},
    data.channel,
    3
  )

  updateSlotMetadata(source, data.slot, metadata)
end)

---@param data {slot: number, isPoweredOn: boolean}
RegisterNetEvent("pf_radio:setPowerState", function(data)
  local slotData = getRadioSlot(source, data.slot)
  if not slotData then return end

  local metadata = slotData.metadata or {}
  metadata.isPoweredOn = data.isPoweredOn

  if config.hideMetadataWhenOff and not data.isPoweredOn then
    metadata.lastChannel = nil
  end

  updateSlotMetadata(source, data.slot, metadata)
end)

---@param source number
---@param channel number
---@return boolean
lib.callback.register("pf_radio:canAccessChannel", function(source, channel)
  local baseChannel = math.floor(channel)
  local restrictions = config.restrictedChannels[baseChannel]

  if not restrictions then
    return true
  end

  return DoesPlayerHaveGroup(source, restrictions)
end)
