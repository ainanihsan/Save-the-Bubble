-----------------------------------------------------------------------------------------
--
-- globals.lua a lua file to hold all the global variables
--
-----------------------------------------------------------------------------------------
-- global file

--[[
globals._H = display.contentHeight;
globals._Hh = display.contentWidth / 2;
globals._W = display.contentWidth;
globals._Wh = display.contentWidth / 2;
globals.rateUsPopupFrequency = 10;
globals.arenaW = display.contentWidth * 3.5
globals.swipeDistance = 450;
globals.grassPhyProperties = {density = 1.0, friction = 0.3, bounce = 0.4, isSensor = false};
globals.icePhyProperties = {density = 1.0, friction = 0.1, bounce = 0.1, isSensor = false};
globals.roadPhyProperties = {density = 2.0, friction = 0.5, bounce = 0.5, isSensor = false};
globals.normalBallPhyProperties = {density = 1.0, friction = 0.2, bounce = 0.3, isSensor = false};
globals.woodPhyProperties = {density = 1.0, friction = 0.3, bounce = 0.2, isSensor = false};
globals.brickPhyProperties = {density = 3.0, friction = 0.3, bounce = 0.5, isSensor = false};
globals.glassPhyProperties = {density = 2.0, friction = 0.1, bounce = 0.1, isSensor = false};
]]--

local M = {}

return M;