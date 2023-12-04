-- Copyright © 2023, Syzak
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:

--     * Redistributions of source code must retain the above copyright
--       notice, this list of conditions and the following disclaimer.
--     * Redistributions in binary form must reproduce the above copyright
--       notice, this list of conditions and the following disclaimer in the
--       documentation and/or other materials provided with the distribution.
--     * Neither the name of toolbag nor the
--       names of its contributors may be used to endorse or promote products
--       derived from this software without specific prior written permission.

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
-- DISCLAIMED. IN NO EVENT SHALL <your name> BE LIABLE FOR ANY
-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

_addon.name = 'toolbag'
_addon.author = 'Syzak'
_addon.version = '0.0.0'
_addon.commands = { 'toolbag', 'tb', 'tool', 'tools', 'shihei', 'ino', 'shika', 'cho' }

require('tables')
require('strings')
require('logger')

local config = require('config')
local texts = require('texts')

-----------------------------
-- List of all ninja tools --
-----------------------------
local tools = T {
  'Chonofuda',
  'Furusumi',
  'Hiraishin',
  'Inoshishinofuda',
  'Jinko',
  'Jusatsu',
  'Kabenro',
  'Kaginawa',
  'Kawahori-Ogi',
  'Kodoku',
  'Makibishi',
  'Mizu-Deppo',
  'Mokujin',
  'Ranka',
  'Ryuno',
  'Sairui-Ran',
  'Shihei',
  'Shikanofuda',
  'Shinobi-Tabi',
  'Soshi',
  'Uchitake',
}

-----------------------
-- Helpful Constants --
-----------------------
local DisplayType = {
  Icon = 'Icon',
  SpellName = 'SpellName',
}

local Direction = {
  Vertical = 'Vertical',
  Horizontal = 'Horizontal',
}

local Shihei = 'Shihei'
local ShinobiTabi = 'Shinobi-Tabi'
local TextureSize = 32
local UniversalTool = {
  Ino = 'Inoshishinofuda',
  Shika = 'Shikanofuda',
  Cho = 'Chonofuda',
}

----------------------------
-- Text Visual Indicators --
----------------------------
local LowerBound = 10
local UpperBound = 35

--------------------------------------------------
-- Default Settings, saved in data/settings.xml --
--------------------------------------------------
local defaults = {
  canMoveItems = false,
  canUseItems = false,
  display = {
    direction = Direction.Vertical,
    threshold = {
      lower = LowerBound,
      upper = UpperBound,
    },
    tools = T { Shihei, ShinobiTabi, UniversalTool.Ino, UniversalTool.Shika, UniversalTool.Cho },
    type = DisplayType.Icon,
  },
  window = {
    x = 500,
    y = 300,
  },
  colors = {
    high = {
      r = 0,
      g = 158,
      b = 115,
    },
    mid = {
      r = 240,
      g = 228,
      b = 66,
    },
    low = {
      r = 213,
      g = 94,
      b = 0,
    },
  },
  texts = {
    bg = {
      alpha = 0,
    },
    flags = {
      draggable = false,
    },
    text = {
      size = 12,
      stroke = {
        width = 2
      }
    },
  },
}

local settings = config.load(defaults)

---------------------
-- Text Management --
---------------------
local offsetMultiplierX = settings.display.direction == Direction.Horizontal and TextureSize or 1
local offsetMultiplierY = settings.display.direction == Direction.Vertical and TextureSize or 1

local toolTexts = T {}

------------------------------
-- Initialization Variables --
------------------------------
local initialized = false
local currentTexture = 0

----------------------------------
-- Create and render tool icons --
----------------------------------
local function createTextures(name)
  local textureName = name .. '_toolbag_syz'
  local iconName = name .. '_icon.png'
  local texturePath = windower.addon_path .. 'icons/' .. iconName

  local actualX = settings.window.x + offsetMultiplierX * currentTexture
  local actualY = settings.window.y + offsetMultiplierY * currentTexture

  -- For notes on prim, see Windower documentation
  -- https://github.com/Windower/Lua/wiki/Image-Primitive-Functions
  windower.prim.create(textureName)
  windower.prim.set_texture(textureName, texturePath)
  windower.prim.set_fit_to_texture(textureName, true)
  windower.prim.set_position(textureName, actualX, actualY)

  -- Create the text object at the appropriate position
  local toolText = texts.new('x ??', settings.texts)

  toolTexts[name] = toolText
  toolTexts[name]:pos_x(actualX + TextureSize + 4)
  toolTexts[name]:pos_y(actualY)
  toolTexts[name]:show()

  currentTexture = currentTexture + 1
end

------------------------
-- Initialize Display --
------------------------
local function onLoad()
  if (initialized) then
    return
  end

  settings.display.tools:map(createTextures)
end

-------------
-- Cleanup --
-------------
local function onUnload()
  -- Destroy icons
  for _, name in ipairs(tools) do
    local textureName = name .. '_toolbag_syz'
    windower.prim.delete(textureName)
  end

  -- Destroy text objects
  for _, v in pairs(toolTexts) do
    texts.destroy(v)
  end
end

-----------------------
-- Monitor Inventory --
-----------------------
local function onItemAdded(bag, index, id, count)

end

local function onItemRemoved(bag, index, id, count)
end

--------------------
-- Addon Commands --
--------------------
local function onAddonCommand()

end

-- local function useItem()
-- end

-- local function placeItem()
-- end

-- Bring up
windower.register_event('load', 'login', onLoad)

-- Tear down
windower.register_event('logout', 'unload', onUnload)

-- Monitor
windower.register_event('add item', onItemAdded)
windower.register_event('remove item', onItemRemoved)

-- Listen
windower.register_event('addon command', onAddonCommand)
