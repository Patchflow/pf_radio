---@alias NuiEvent
---| "TOGGLE_NUI"
---| "SET_LOCALE"
---| "TOGGLE_ANIM_SELECTOR"

---@class NuiMessage
---@field action NuiEvent
---@field data any

---@param message NuiMessage
local function sendNuiMessage(message)
  SendNUIMessage({
    action = message.action,
    data = message.data
  })
end

---@alias NuiCallback
---| "CLOSE_NUI"
---| "SET_VOICE_PROPERTY"
---| "VOLUME_CHANGED"
---| "GET_CONFIG"
---| "HANDLE_CONNECTION"
---| "SET_POWER_STATE"
---| "SET_ANIMATION"
---| "CLOSE_ANIM_SELECTOR"

---@generic D, R
---@param name NuiCallback
---@param handler fun(data:D): R
local function registerNuiHandler(name, handler)
  RegisterNuiCallback(name, function(data, cb)
    local result = handler(data)
    cb(result ~= nil and result or false)
  end)
end

return {
  send = sendNuiMessage,
  registerHandler = registerNuiHandler,
}
