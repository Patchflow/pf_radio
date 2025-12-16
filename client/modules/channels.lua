local config = require "shared.config"
local settings = require "client.modules.settings"

---@param channel number
---@return boolean
local function validateChannelAccess(channel)
  local baseChannel = math.floor(channel)

  if config.restrictedChannels[baseChannel] then
    local authorized = lib.callback.await("pf_radio:canAccessChannel", false, baseChannel)

    if not authorized then
      lib.notify({
        title = locale("radio.frequency"),
        description = locale("radio.access_restricted"),
        type = "error",
        icon = "radio",
        position = "top-right"
      })
    end

    return authorized
  end

  return true
end

---@param direction "up" | "down"
local function quickSwitchChannel(direction)
  local current = LocalPlayer.state.radioChannel
  if current <= 0 then return end

  local channelJumps = settings.get().channelJumps
  local increment = channelJumps * (direction == "up" and 1 or -1)
  local newChannel = current + increment

  newChannel = math.floor(newChannel * 100 + 0.5) / 100

  if newChannel < 1 or newChannel > 1000 then
    lib.notify({
      title = locale("radio.frequency"),
      description = locale("radio.out_of_range"),
      type = "error",
      icon = "radio",
      position = "top-right",
      duration = 2000
    })
    return
  end

  if not validateChannelAccess(newChannel) then
    return
  end

  exports["pma-voice"]:setRadioChannel(newChannel)
end

local function setupKeybinds()
  local keybinds = {
    { name = "jumpChannelUp",   key = "PAGEUP",   direction = "up",   description = locale("radio.jump_channel_up") },
    { name = "jumpChannelDown", key = "PAGEDOWN", direction = "down", description = locale("radio.jump_channel_down") },
  }

  for _, bind in ipairs(keybinds) do
    lib.addKeybind({
      name = bind.name,
      description = bind.description,
      defaultKey = bind.key,
      onPressed = function()
        quickSwitchChannel(bind.direction)
      end
    })
  end
end

return {
  validate = validateChannelAccess,
  quickSwitch = quickSwitchChannel,
  setupKeybinds = setupKeybinds,
}
