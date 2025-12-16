---@type RadioKvpKeys
local kvpKeys = {
  radioClicks = "pma-voice_enableMicClicks",
  channelJumps = "pma-voice_radioJumps",
  volume = "pf_radio_volume",
  position = "pf_radio_position",
  size = "pf_radio_size",
  selectedAnim = "pf_radio_selectedAnim",
}

---@generic T
---@param key string
---@param default? T
---@return string | T
local function getKvpValue(key, default)
  local status, result = pcall(GetResourceKvpString, key)

  if not status then
    DeleteResourceKvp(key)
    return default
  end

  return result or default
end

---@type RadioSettings
local settings = {
  radioClicks = getKvpValue(kvpKeys.radioClicks, "true") == "true",
  channelJumps = tonumber(getKvpValue(kvpKeys.channelJumps, "0.25")) or 0.25,
  volume = tonumber(getKvpValue(kvpKeys.volume, "75")) or 75,
  position = json.decode(getKvpValue(kvpKeys.position, '{"x":-1,"y":-1}')),
  size = json.decode(getKvpValue(kvpKeys.size, '{"width":263,"height":660}')),
  selectedAnim = getKvpValue(kvpKeys.selectedAnim, "face"),
}

---@generic T
---@generic K
---@param key K
---@param value T|nil
---@param serializer fun(value: T): string
---@param callback? fun(value: T)
local function persistSetting(key, value, serializer, callback)
  if value == nil or settings[key] == value then return end

  settings[key] = value
  SetResourceKvp(kvpKeys[key], serializer(value))

  if callback then
    callback(value)
  end
end

local function initializeSettings()
  exports.ox_inventory:displayMetadata("lastChannel", locale("radio.frequency"))
  exports["pma-voice"]:setRadioVolume(settings.volume)
  exports["pma-voice"]:setVoiceProperty("micClicks", settings.radioClicks)
end

SetTimeout(1000, initializeSettings)

return {
  get = function() return settings end,
  persist = persistSetting,
}
