local config = require "shared.config"
local settings = require "client.modules.settings"
local radioObject = require "client.modules.radio-object"
local channels = require "client.modules.channels"
local NUI = require "client.modules.nui"

channels.setupKeybinds()

---@param slot SlotWithItem
exports("useRadio", function(_, slot)
  if IsNuiFocused() then return end

  local settingsLocal = settings.get()
  local currentChannel = LocalPlayer.state.radioChannel or 0
  local connected = currentChannel > 0

  SetNuiFocus(true, true)
  NUI.send({
    action = "TOGGLE_NUI",
    data = {
      settings = settingsLocal,
      recentChannels = slot.metadata?.recentChannels or {},
      channel = tostring(currentChannel),
      volume = settingsLocal.volume,
      slot = slot.slot,
      position = settingsLocal.position,
      size = settingsLocal.size,
      isPoweredOn = slot.metadata?.isPoweredOn or false,
      isConnected = connected,
    }
  })

  lib.playAnim(cache.ped, "cellphone@", "cellphone_text_in", 4.0, 4.0, -1, 50, 0.0, false, 0, false)

  SetTimeout(200, function()
    radioObject.attach("holding", settings.selectedAnim)
  end)
end)

AddStateBagChangeHandler("radioActive", ("player:%s"):format(cache.serverId), function(_, _, value, _, replicated)
  if not replicated then return end

  local settingsLocal = settings.get()

  if value then
    local selectedAnim = config.radioAnimations[settingsLocal.selectedAnim] or config.radioAnimations.face
    lib.playAnim(cache.ped, selectedAnim.dict, selectedAnim.anim, 8.0, 2.0, -1, 50, 0.0, false, 0, false)
    radioObject.attach("speaking", settingsLocal.selectedAnim)

    if config.disabledControls then
      radioObject.handleRestrictions(config.disabledControls)
    end
  else
    local selectedAnim = config.radioAnimations[settingsLocal.selectedAnim] or config.radioAnimations.face
    StopAnimTask(cache.ped, selectedAnim.dict, selectedAnim.anim, -4.0)
    radioObject.remove()
  end
end)

AddEventHandler("ox_lib:setLocale", function()
  NUI.send({
    action = "SET_LOCALE",
    data = lib.getLocales(),
  })
end)

RegisterCommand("radioanim", function()
  if IsNuiFocused() then return end

  SetNuiFocus(true, true)
  NUI.send({
    action = "TOGGLE_ANIM_SELECTOR",
    data = {
      selectedAnim = settings.get().selectedAnim
    }
  })
end, false)

---@return {locales: table}
NUI.registerHandler("GET_CONFIG", function()
  return {
    locales = lib.getLocales(),
  }
end)

---@param data {volume: number}
NUI.registerHandler("VOLUME_CHANGED", function(data)
  settings.get().volume = data.volume
  exports["pma-voice"]:setRadioVolume(data.volume)
  SetResourceKvp("pf_radio_volume", tostring(data.volume))
  return true
end)

---@param data {key: string, value: string}
NUI.registerHandler("SET_VOICE_PROPERTY", function(data)
  exports["pma-voice"]:setVoiceProperty(data.key, data.value)
  return true
end)

---@param data {slot: number, isPoweredOn: boolean}
NUI.registerHandler("SET_POWER_STATE", function(data)
  TriggerServerEvent("pf_radio:setPowerState", data)
  return true
end)

---@param data {animation: string}
NUI.registerHandler("SET_ANIMATION", function(data)
  settings.persist("selectedAnim", data.animation, tostring)
  return true
end)

NUI.registerHandler("CLOSE_ANIM_SELECTOR", function()
  SetNuiFocus(false, false)
  NUI.send({
    action = "TOGGLE_ANIM_SELECTOR",
    data = false
  })
  return true
end)

---@param data? {radioClicks: boolean, channelJumps: number, volume: number, position: table, size: table, isPoweredOn: boolean, selectedAnim: string}
NUI.registerHandler("CLOSE_NUI", function(data)
  SetNuiFocus(false, false)
  NUI.send({
    action = "TOGGLE_NUI",
    data = false
  })
  lib.playAnim(cache.ped, "cellphone@", "cellphone_text_out", 4.0, 4.0, 300, 50, 0.0, false, 0, false)
  SetTimeout(300, radioObject.remove)

  if data then
    settings.persist("radioClicks", data.radioClicks, tostring, function(val)
      exports["pma-voice"]:setVoiceProperty("micClicks", val)
    end)

    settings.persist("channelJumps", data.channelJumps, tostring)
    settings.persist("volume", data.volume, tostring)
    settings.persist("position", data.position, json.encode)
    settings.persist("size", data.size, json.encode)
    settings.persist("selectedAnim", data.selectedAnim, tostring)
  end

  return true
end)

---@param data {slot: number, channel: number, connect: boolean}
NUI.registerHandler("HANDLE_CONNECTION", function(data)
  if data.connect and (not data.channel or data.channel < 1) then
    lib.notify({
      title = locale("radio.frequency"),
      description = locale("radio.invalid_channel"),
      type = "error",
      icon = "radio",
      position = "top-right"
    })
    return { ok = false, error = "Invalid channel" }
  end

  if data.connect and not channels.validate(data.channel) then
    return { ok = false, error = "Access denied" }
  end

  exports["pma-voice"]:setVoiceProperty("radioEnabled", data.connect)

  if data.connect then
    exports["pma-voice"]:setRadioChannel(data.channel)
    TriggerServerEvent("pf_radio:setItemData", { slot = data.slot, channel = data.channel })

    lib.notify({
      title = locale("radio.frequency"),
      description = locale("radio.connected_to"):format(data.channel),
      type = "success",
      icon = "radio",
      position = "top-right",
      duration = 3000
    })

    return { ok = true }
  else
    exports["pma-voice"]:removePlayerFromRadio()

    lib.notify({
      title = locale("radio.frequency"),
      description = locale("radio.disconnected"),
      type = "info",
      icon = "radio",
      position = "top-right",
      duration = 2000
    })

    return { ok = true }
  end
end)
