-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local sfx = require("sfx")
local composer = require( "composer" )
local gamesettings = require("gamesettings")
local admanagement = require("admanagement")
local loadsave = require("loadsave")
local globals = require("globals")
local fuse = require( "plugin.fuse" )
local networksLib = require("networksLib")
--local facebook = require("facebook")
local scene = composer.newScene()

-- forward declarations and other locals
local background, playButton
local title;
local swipeThresh = 100		-- amount of pixels finger must travel to initiate page swipe
local tweenTime = 500
local readyToContinue = false
local webView;
local tutorialBtn,leaderBrdAchvmntBtn;
local rateAppBtn,facebookBtn,twitterBtn;
local settingsBtn;
local fb = false;

local function onplayButtonTouch(event)
if(event.phase == "began") then
		sfx.playTouchSound();
		composer.gotoScene( "powerUpsActivation", "slideLeft", 800 )
	end
end

local function onTutorialBtnTouch(event)
if(event.phase == "began") then
		sfx.playTouchSound();
		composer.removeScene("menu")
		composer.gotoScene( "tutorial", "slideLeft", 800 )
	end
end

local function onstoreButtonTouch(event)
if(event.phase == "began") then
		sfx.playTouchSound();
		composer.removeScene("menu")
		composer.gotoScene( "powerupstore", "slideLeft", 800 )
	end
end

local function onSettingsButtonTouch(event)
if(event.phase == "began") then
		sfx.playTouchSound();
		composer.removeScene("menu")
		composer.gotoScene( "settings", "slideLeft", 800 )
	end
end

local function onfacebookButtonTouch( event )
	if(event.phase == "ended") then
		sfx.playTouchSound();
		native.showPopup( "social",
    {
        service = "facebook",
        url = 
        {
        	"https://play.google.com/store/apps/details?id=com.ainantech.savethebubble",
            "https://itunes.apple.com/us/app/save-bubble-ultimate-reflex/id1056917215?ls=1&mt=8"
        }
    })
	end
end

local function ontwitterButtonTouch( event )
	if(event.phase == "began") then
		sfx.playTouchSound();
		native.showPopup( "social",
    {
        service = "twitter",
        message = "I just scored "..gamesettings.highScore.." in Save the Bubble! #SavetheBubble",
        image = 
        {
            { filename="Icon.png", baseDir=system.ResourceDirectory }
        },
        url = 
        {
            "https://itunes.apple.com/us/app/save-bubble-ultimate-reflex/id1056917215?ls=1&mt=8","https://play.google.com/store/apps/details?id=com.ainantech.savethebubble"
        }
    })
	end
end

local function onRateAppBtnTouch(event)
	if(event.phase == "began") then
		sfx.playTouchSound();
		local options = {
                supportedAndroidStores = { "google" },
        }
        native.showPopup("rateApp", options)
        gamesettings.ratedUsOnAppStore = "Yes";
        loadsave.saveTable(gamesettings, "settings.json");
	end
end

local function leaderBrdAchCallBack( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
        	sfx.playTouchSound();
        	networksLib.showLeaderboard();
        elseif 2 == i then
        	sfx.playTouchSound();
        	networksLib.showAchievements();
        elseif 3 == i then
        	sfx.playTouchSound();
        end
    end
end

local function onLeaderAchTouch(event)
	if(event.phase =="began") then
		sfx.playTouchSound();
		local alert = native.showAlert( "Game Services", "Do you want to open Leaderboards or acheivements?", { "Leaderboards","Acheivements","Cancel" }, leaderBrdAchCallBack )
	end
end

function rateUsAlertCallback ( event )
    if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            local options = {
            supportedAndroidStores = { "google" },
            }
            native.showPopup("rateApp", options)
            gamesettings.ratedUsOnAppStore = "Yes";
            loadsave.saveTable(gamesettings, "settings.json");
        elseif 2 == i then
            gamesettings.ratedUsCount = 0;
            loadsave.saveTable(gamesettings, "settings.json");
        elseif 3 == i then
            gamesettings.ratedUsOnAppStore = "Never";
            loadsave.saveTable(gamesettings, "settings.json");
        end
    end
end

function requestUserRatingForAppStore ( ) 
    if (gamesettings.ratedUsOnAppStore == "No") then
        if (gamesettings.ratedUsCount > globals.rateUsPopupFrequency) then
            local alert = native.showAlert( "Rate our game", "Take a second to rate our game! Thank you :)", { "Sure", "Later", "Never" }, rateUsAlertCallback )
        else
            gamesettings.ratedUsCount = gamesettings.ratedUsCount + 1;
            loadsave.saveTable(gamesettings, "settings.json")
        end
    end
end

function videoAdListener(event)
        if "clicked" == event.action then
        local i = event.index
            if 1 == i then
            	print("1st")
                sfx.playTouchSound();
                globals.vungleAdCached = false;
                admanagement.handleIncentivizedAdPlay();
            elseif 2 == i then
                sfx.playTouchSound();
            end
        end
end

local function adListener( event )

    if ( event.isError ) then
        print( "Fuse error: " .. event.response )
    else
        if ( event.phase == "init" ) then
            -- Fuse system initialized


        elseif ( event.phase == "shown" ) then
            -- An ad finished showing
            
        elseif ( event.phase == "completed" ) then
            -- User accepted an offer or completed a task for a reward
            -- The event.payload table contains details about the reward
            gamesettings.totalCoins = gamesettings.totalCoins + 10;
        	loadsave.saveTable(gamesettings, "settings.json");
        end
    end
end

function fuseAdListener(event)
        if "clicked" == event.action then
        local i = event.index
            if 1 == i then
            	print("1st")
                sfx.playTouchSound();
                fuse.show({ zone = "676ee657" }); 
            elseif 2 == i then
                sfx.playTouchSound();
            end
        end
end


function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	background = display.newImageRect( sceneGroup, "assets/pictures/bg.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	title = display.newImageRect( sceneGroup, "assets/pictures/main menu/title.png", 500,500 )
	title.x = display.contentWidth/2
	title.y = display.contentHeight/4
	title.isVisible = true

	-- create sun, moon, and corona icon
	playButton = display.newImageRect( sceneGroup, "assets/pictures/main menu/play.png", 287.5,250 )
	playButton.x = display.contentWidth * 0.5
	playButton.y = display.contentHeight/1.7
	playButton.isVisible = true

	-- create store button
	storeButton = display.newImageRect( sceneGroup, "assets/pictures/main menu/store.png", 162.5,137.5 )
	storeButton.x = display.contentWidth/4;
	storeButton.y = display.contentHeight - display.contentHeight/5;
	storeButton.isVisible = true

	facebookBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/facebook.png", 162.5,137.5 )
	facebookBtn.x = display.contentWidth - display.contentWidth/4;
	facebookBtn.y = display.contentHeight - display.contentHeight/5;
	facebookBtn.isVisible = true

	tutorialBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/info.png", 162.5,137.5 )
	tutorialBtn.x = display.contentWidth/8;
	tutorialBtn.y = display.contentHeight - display.contentHeight/3;
	tutorialBtn.isVisible = true	

	leaderBrdAchvmntBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/high_score.png", 162.5,137.5 )
	leaderBrdAchvmntBtn.x = display.contentWidth - display.contentWidth/8;
	leaderBrdAchvmntBtn.y = display.contentHeight - display.contentHeight/3;
	leaderBrdAchvmntBtn.isVisible = true	

	twitterBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/twitter.png", 162.5,137.5 )
	twitterBtn.x = display.contentWidth/2;
	twitterBtn.y = display.contentHeight - display.contentHeight/8;
	twitterBtn.isVisible = true	

	rateAppBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/rate.png", 162.5,137.5 )
	rateAppBtn.x = display.contentWidth/8;
	rateAppBtn.y = display.contentHeight/2;
	rateAppBtn.isVisible = true		

	settingsBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/setting.png", 162.5,137.5 )
	settingsBtn.x = display.contentWidth - display.contentWidth/8;
	settingsBtn.y = display.contentHeight/2;
	settingsBtn.isVisible = true	

	sceneGroup:insert(background);
	sceneGroup:insert(title)
	sceneGroup:insert(playButton);
	sceneGroup:insert(storeButton);
	sceneGroup:insert(facebookBtn)
	sceneGroup:insert(tutorialBtn)
	sceneGroup:insert(leaderBrdAchvmntBtn)
	sceneGroup:insert(twitterBtn)
	sceneGroup:insert(rateAppBtn)
	sceneGroup:insert(settingsBtn)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		sfx.init();
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		--admanagement.initVungleVideoAd();
		requestUserRatingForAppStore();
		-- if (system.getInfo("platformName") == "Android") then
		-- 	admanagement.initVungleVideoAd();
		-- 	if(gamesettings.removeAds == false and gamesettings.adCounter%4==0 and globals.vungleAdCached) then
  --           	local alert = native.showAlert( "Video Advertisement", "Do you want to watch a video advertisement for 10 coins?", { "Yes","No" }, videoAdListener )
  --       	end
		-- else
			fuse.init(adListener);
			if(gamesettings.removeAds == false and gamesettings.adCounter%4==0) then
	            local alert = native.showAlert( "Video Advertisement", "Do you want to watch a video advertisement for 10 coins?", { "Yes","No" }, fuseAdListener )
	        end
	    --end
	    gamesettings.adCounter = gamesettings.adCounter + 1;
        loadsave.saveTable(gamesettings, "settings.json");
		
        if(gamesettings.removeAds == false) then
            if(gamesettings.bannerAdCounter % 5 == 0) then
                print("show admob banner")
                admanagement.showAdMobBannerAd(0,display.contentHeight - display.contentHeight/15)
            end
            gamesettings.bannerAdCounter = gamesettings.bannerAdCounter + 1;
        end

        loadsave.saveTable(gamesettings, "settings.json");
		

		-- assign touch event to background to monitor page swiping
		playButton:addEventListener("touch",onplayButtonTouch)
		leaderBrdAchvmntBtn:addEventListener("touch",onLeaderAchTouch)
		storeButton:addEventListener("touch",onstoreButtonTouch)
		facebookBtn:addEventListener("touch",onfacebookButtonTouch)
		twitterBtn:addEventListener("touch",ontwitterButtonTouch)
		rateAppBtn:addEventListener("touch",onRateAppBtnTouch)
		tutorialBtn:addEventListener("touch",onTutorialBtnTouch)
		settingsBtn:addEventListener("touch",onSettingsButtonTouch)
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		-- remove event listener from background
		
	elseif phase == "did" then
		-- Called when the scene is now off screen
		playButton:removeEventListener("touch",onplayButtonTouch)
		leaderBrdAchvmntBtn:removeEventListener("touch",onLeaderAchTouch)
		storeButton:removeEventListener("touch",onstoreButtonTouch)
		facebookBtn:removeEventListener("touch",onfacebookButtonTouch)
		twitterBtn:removeEventListener("touch",ontwitterButtonTouch)
		rateAppBtn:removeEventListener("touch",onRateAppBtnTouch)
		tutorialBtn:removeEventListener("touch",onTutorialBtnTouch)
		settingsBtn:removeEventListener("touch",onSettingsButtonTouch)
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	background = nil;
	pageTween = nil;
	tutorialBtn = nil;
	fadeTween1 = nil;
	fadeTween2 = nil;
	playButton = nil;
	swipeThresh = nil;		-- amount of pixels finger must travel to initiate page swipe
	tweenTime = nil;
	readyToContinue = nil;
	facebookBtn = nil;
	twitterBtn = nil;
	settingsBtn = nil;
	leaderBrdAchvmntBtn = nil;
	title = nil;
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene