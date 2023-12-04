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
_addon.commands = { 'toolbag', 'tb', 'tool', 'tools' }

require('tables')
require('strings')
require('logger')

local config = require('config')
local spells = require('resources').spells
local texts = require('texts')


-----------------------------
-- List of all ninja tools --
-----------------------------
local ValidToolNames = T {
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

local ToolDictionary = T {
  { id = 1161, en = "Uchitake",        stack = 99 },
  { id = 1167, en = "Kawahori-Ogi",    stack = 99 },
  { id = 1170, en = "Makibishi",       stack = 99 },
  { id = 1173, en = "Hiraishin",       stack = 99 },
  { id = 1176, en = "Mizu-Deppo",      stack = 99 },
  { id = 1179, en = "Shihei",          stack = 99 },
  { id = 1182, en = "Jusatsu",         stack = 99 },
  { id = 1185, en = "Kaginawa",        stack = 99 },
  { id = 1188, en = "Sairui-Ran",      stack = 99 },
  { id = 1191, en = "Kodoku",          stack = 99 },
  { id = 1194, en = "Shinobi-Tabi",    stack = 99 },
  { id = 2555, en = "Soshi",           stack = 99 },
  { id = 2642, en = "Kabenro",         stack = 99 },
  { id = 2643, en = "Jinko",           stack = 99 },
  { id = 2644, en = "Ryuno",           stack = 99 },
  { id = 2970, en = "Mokujin",         stack = 99 },
  { id = 2971, en = "Inoshishinofuda", stack = 99 },
  { id = 2972, en = "Shikanofuda",     stack = 99 },
  { id = 2973, en = "Chonofuda",       stack = 99 },
  { id = 5308, en = "Toolbag (Uchi)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5309, en = "Toolbag (Tsura)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5310, en = "Toolbag (Kawa)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5311, en = "Toolbag (Maki)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5312, en = "Toolbag (Hira)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5313, en = "Toolbag (Mizu)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5314, en = "Toolbag (Shihe)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5315, en = "Toolbag (Jusa)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5316, en = "Toolbag (Kagi)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5317, en = "Toolbag (Sai)",   cast_time = 1, category = "Usable", stack = 12 },
  { id = 5318, en = "Toolbag (Kodo)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5319, en = "Toolbag (Shino)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5417, en = "Toolbag (Sanja)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5734, en = "Toolbag (Soshi)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5863, en = "Toolbag (Kaben)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5864, en = "Toolbag (Jinko)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5865, en = "Toolbag (Ryuno)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5866, en = "Toolbag (Moku)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 5867, en = "Toolbag (Ino)",   cast_time = 1, category = "Usable", stack = 12 },
  { id = 5868, en = "Toolbag (Shika)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 5869, en = "Toolbag (Cho)",   cast_time = 1, category = "Usable", stack = 12 },
  { id = 6265, en = "Toolbag (Ranka)", cast_time = 1, category = "Usable", stack = 12 },
  { id = 6266, en = "Toolbag (Furu)",  cast_time = 1, category = "Usable", stack = 12 },
  { id = 8803, en = "Ranka",           stack = 99 },
  { id = 8804, en = "Furusumi",        stack = 99 },
}

-----------------------
-- Helpful Constants --
-----------------------
local ActionCastSpell = 4
local ActionUseItem = 5

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

-------------
-- Baggage --
-------------
local GlobalBags = {
  'Inventory',
  'Satchel',
  'Sack',
  'Case',
}

local HomeBags = {
  'Safe',
  'Storage',
  'Locker',
  'Safe 2',
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

--------------------------
-- Update rendered text --
--------------------------
local function updateToolText(currentTools)
  log('Updating tool text')
  for tool, count in pairs(currentTools) do
    if toolTexts[tool] then
      toolTexts[tool]:text('x' .. count)
    end
  end
end

------------
-- Search --
------------
local function getTools()
  log('Grabbing Tools')
  local inventory = T {}

  for _, bag in ipairs(GlobalBags) do
    local items = windower.ffxi.get_items(bag)
    if items.enabled then
      for _, item in ipairs(items) do
        -- Look for any tools or toolbags
        local foundItem = ToolDictionary:with('id', item.id)

        -- If the tool is to be displayed, track the count
        if foundItem and settings.display.tools:contains(foundItem.en) then
          -- Add to the total or create the entry in the built inventory
          if inventory[foundItem.en] then
            inventory[foundItem.en] = inventory[foundItem.en] + item.count
          else
            inventory[foundItem.en] = item.count
          end
        end
      end
    end
  end

  return inventory
end

------------------------
-- Initialize Display --
------------------------
local function onLoad()
  if (initialized) then
    return
  end

  for _, name in ipairs(settings.display.tools) do
    createTextures(name)
  end

  local currentTools = getTools()
  updateToolText(currentTools)

  initialized = true
end

-------------
-- Cleanup --
-------------
local function onUnload()
  -- Destroy icons
  for _, name in ipairs(settings.display.tools) do
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
  updateToolText(getTools())
end

local function onItemRemoved(bag, index, id, count)
  updateToolText(getTools())
end

local function onAction(action)
  -- Check if the the player is the action initiator and if the action is a spell or item usage
  if (
        action.actor_id ~= windower.ffxi.get_player().id
        and action.category ~= ActionUseItem
        and action.category ~= ActionCastSpell
      )
  then
    return
  end

  if (action.category == ActionUseItem) then
    updateToolText(getTools())
  elseif (action.category == ActionCastSpell and spells[action.param].type == "Ninjutsu") then
    updateToolText(getTools())
  end
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
windower.register_event('action', onAction)

-- Listen
windower.register_event('addon command', onAddonCommand)
