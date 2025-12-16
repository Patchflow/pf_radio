---@type RadioConfig
return {
  -- The item name of the radio. (used for security checks)
  item = "radio",

  -- The framework to use for the radio.
  -- Options: standalone, esx, ox, qbx, vrp05
  framework = "qbx",

  -- The model of the radio.
  model = "prop_cs_hand_radio",

  -- List of disabled controls when the radio is active.
  -- See: https://docs.fivem.net/docs/game-references/controls/
  disabledControls = { 24 },

  -- Disable shooting when the radio is active.
  -- This only works if disabledControls is set.
  disableShooting = true,

  -- Whether to hide the recent frequency in the metadata when radio is off.
  hideMetadataWhenOff = true,

  -- The available radio animations.
  radioAnimations = {
    face = {
      dict = "ultra@walkie_talkie",
      anim = "walkie_talkie"
    },
    shoulder = {
      dict = "random@arrests",
      anim = "generic_radio_chatter"
    },
    chest = {
      dict = "anim@cop_mic_pose_002",
      anim = "chest_mic"
    },
    ear = {
      dict = "cellphone@",
      anim = "cellphone_call_listen_base"
    }
  },

  -- The placement of the radio prop.
  -- holding = the position of the radio when holding it.
  -- speaking = the position of the radio when speaking into it.
  radioPlacement = {
    holding = {
      bone = 28422,
      pos = vec3(0.0, 0.0, 0.0),
      rot = vec3(0.0, 0.0, 0.0)
    },
    speaking = {
      bone = 18905,
      pos = vec3(0.14, 0.03, 0.03),
      rot = vec3(-105.87, -10.94, -33.72)
    }
  },

  -- The channels that are restricted to certain gang/group (locks entire number from 1 - 1.99 etc.)
  restrictedChannels = {
    [1] = { "police", "ambulance" }
  }
}
