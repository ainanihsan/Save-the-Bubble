-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"
local globals = require("globals")
local setupFile = require("setupFile");
local gamesettings = require("gamesettings")
local loadsave = require("loadsave")
-- load title screen
globals.reset = false;
local settings = loadsave.loadTable("settings.json");   -- user settings are stored in settings.json. Loading previous user setting into a table
if (settings == nil ) then                              -- if no settings exist (first time user) create the first set of user settings
	gamesettings.soundOn = true;
	gamesettings.musicOn = true;
	gamesettings.ratedUsOnAppStore = "No"; -- No, Yes, "Never"
	gamesettings.ratedUsCount = 0;                     -- user is asked to rate app every 10th (globals.rateusfrequency) time when he reaches menu.lua. This variable keeps count of the number of times user has reached menu.lua
	gamesettings.removeAds = false;
	gamesettings.adCounter = 0;
	gamesettings.totalAdCount = 0;
	gamesettings.interstitialAdCounter = 0;
	gamesettings.bannerAdCounter = 0;
	gamesettings.totalScore = 0;
	gamesettings.slowTorpedoes = 5;
	gamesettings.bubbleLife = 3;
	gamesettings.sheildColor = 3;
	gamesettings.totalCoins = 500;
	gamesettings.highScore = 0;
	gamesettings.torpedoSpeed = 1500;
	loadsave.saveTable(gamesettings, "settings.json")  -- storing the default settings on the phone
else                                               -- if settings exist (Not first time user)
	for k,v in pairs(settings) do                      -- loop and load the settings table (retreived above) into the gamesettings global table. gamesettings is in the app and is kept in sync with the settings.json. At the start of the game settings.json is loaded into the settings (here) any changes made in gamsettings during game is regularly synced with settings.json
		gamesettings[k] = v
	end
end
composer.gotoScene( "title", "fade" )