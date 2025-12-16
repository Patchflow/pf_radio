---@meta

---@alias FrameworkType "standalone" | "esx" | "ox" | "qbx" | "vrp05"

---@class RadioPlacement
---@field bone number
---@field pos vector3
---@field rot vector3

---@class RadioAnimation
---@field dict string
---@field anim string

---@class RadioConfig
---@field item string
---@field framework FrameworkType
---@field model string
---@field disabledControls number[]
---@field disableShooting boolean
---@field hideMetadataWhenOff boolean
---@field radioPlacement table<string, RadioPlacement>
---@field restrictedChannels table<number, string[]>
---@field radioAnimations table<string, RadioAnimation>

---@class RadioSettings
---@field radioClicks boolean
---@field channelJumps number
---@field volume number
---@field position {x: number, y: number}
---@field size {width: number, height: number}
---@field selectedAnim string

---@class RadioKvpKeys
---@field radioClicks string
---@field channelJumps string
---@field volume string
---@field position string
---@field size string
---@field selectedAnim string
