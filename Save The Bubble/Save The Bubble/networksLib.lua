local networksLib = {};

local gameNetwork = require "gameNetwork";
local gamesettings = require("gamesettings")
local currentSystem = system.getInfo("platformName");
if currentSystem ~= "Android" and currentSystem ~= "iPhone OS" then
  currentSystem = "Android";
end

local activeNetworksProviders;
local currentNetwork;

local function initCallback( event )
    if event.data then
        loggedIntoGC = true
        native.showAlert( "Success!", "User has logged into Game Center", { "OK" } )
    else
        loggedIntoGC = false
        native.showAlert( "Fail", "User is not logged into Game Center", { "OK" } )
    end
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer")
   loggedIntoGC = true;
   return true
end

local function gpgsInitCallback( event )
  print("GPGSInit")
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

local initializeFunctions = {
  print("..............INIT..............");
  loggedIntoGC = false;
  ["google"] = function()
    gameNetwork.init("google", gpgsInitCallback)
  end,
  ["gamecenter"] = function()
    gameNetwork.init( "gamecenter", initCallback )
  end
};

networksLib.init = function(activeNetworks)
  print("ENTER")
  activeNetworksProviders = activeNetworks;
  currentNetwork = activeNetworks[currentSystem][1];
  if initializeFunctions[currentNetwork] then
    initializeFunctions[currentNetwork]();
  end
  print("EXIT")
end

networksLib.showLeaderboard = function()
  if currentNetwork == "google" then
    if loggedIntoGC then
        gameNetwork.show("leaderboards");
    end
  elseif currentNetwork == "gamecenter" then
    if loggedIntoGC then
      --native.showAlert("iphone")
        gameNetwork.show("leaderboards", { leaderboard = {timeScope="AllTime"}});
    end
  end
end

networksLib.showAchievements = function()
   gameNetwork.show( "achievements" )
end

local function updateCallback(e)
    local data = json.encode( e.data )

    -- show encoded json string via native alert
    native.showAlert( "e.data", data, { "OK" } )
end


networksLib.achievementCheck = function ()
  if loggedIntoGC then
            if (gamesettings.highScore >= 50) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQAg", percentComplete=100, showsCompletionBanner=true }});
            end
            if (gamesettings.highScore >= 75) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQAw", percentComplete=100, showsCompletionBanner=true }});
            end 
            if (gamesettings.highScore >= 100) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQBA", percentComplete=100, showsCompletionBanner=true }});
            end
            if (gamesettings.highScore >= 150) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQBQ", percentComplete=100, showsCompletionBanner=true }});
            end
            if (gamesettings.highScore >= 200) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQBg", percentComplete=100, showsCompletionBanner=true }});
            end
            if (gamesettings.highScore >= 400) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQCA", percentComplete=100, showsCompletionBanner=true }});
            end
            if (gamesettings.highScore >= 600) then
                gameNetwork.request( "unlockAchievement",{achievement = { identifier="CgkIsbWi-ZkaEAIQCQ", percentComplete=100, showsCompletionBanner=true }});
            end
  end
end

networksLib.addScoreToLeaderboard = function(score)
  if currentNetwork == "google" then
    if loggedIntoGC then
      gameNetwork.request( "setHighScore", { localPlayerScore = { category = "CgkIsbWi-ZkaEAIQAQ", value = score } ,listener = updateCallback  } )
      print("highscore GameCenter")
    end
  elseif currentNetwork == "gamecenter" then
    if loggedIntoGC then
      gameNetwork.request( "setHighScore",
      {
          localPlayerScore = { category=activeNetworksProviders[currentSystem][2], value=tonumber(score) },
          listener= function() print("Score was posted"); end
      });
    end
  end
end


return networksLib;