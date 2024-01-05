local composer = require( "composer" )
local globals = require("globals")
local score = require("score")
local gamesettings = require("gamesettings")
local admanagement = require("admanagement")
local  networksLib = require("networksLib")
local loadsave = require("loadsave")
local AdBuddiz = require("plugin.adbuddiz")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here

local playAgainBtn;
local leaderboardButton,acheivementButton;
local menuBtn;
local scoreValueText,highText;
local background;
local facebookBtn;
local twitterBtn;
-- -------------------------------------------------------------------------------


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


local function onPlayAgainTouch(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        globals.reset = true;
        composer.removeScene("rotateAbout")
        composer.gotoScene( "powerUpsActivation", { effect = "fade", time = 300 } )
    end
end

local function onMenuTouch(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        globals.reset = true;
        composer.removeScene("rotateAbout")
        composer.gotoScene( "menu", { effect = "fade", time = 300 } )
    end
end

function onAcheivementBtnTouch( event )
    if(event.phase == "ended") then
        sfx.playTouchSound();
        networksLib.showAchievements();
    end
end

function gotoLeaderBoard( event )
    if(event.phase == "ended") then
        sfx.playTouchSound();
        networksLib.showLeaderboard();
    end
end



-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    local background = display.newImageRect( sceneGroup, "assets/pictures/bg.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local overlay = display.newImageRect("assets/pictures/setting screen/overlay.png",display.contentWidth/1.1,display.contentHeight/1.7);
    overlay.x = display.contentWidth/2;
    overlay.y = display.contentHeight/2;  

    local scoreOverlay1 = display.newImageRect("assets/pictures/game over/overlay.png",200,53)
    scoreOverlay1.x = display.contentWidth - display.contentWidth/4 ;
    scoreOverlay1.y = display.contentHeight/4 + display.contentHeight/16 ;

    local scoreOverlay2 = display.newImageRect("assets/pictures/game over/overlay.png",200,53)
    scoreOverlay2.x = display.contentWidth - display.contentWidth/4 ;
    scoreOverlay2.y = display.contentHeight/3 + display.contentHeight/16 ;    

    local title = display.newImageRect( sceneGroup, "assets/pictures/game over/gameover.png", 600,120 )
    title.x = display.contentWidth/2
    title.y = display.contentHeight/8
    title.isVisible = true

    playAgainBtn = display.newImageRect( sceneGroup, "assets/pictures/game over/play.png", 444,100);
    playAgainBtn.x = display.contentCenterX
    playAgainBtn.y = display.contentHeight - display.contentHeight/3.5;    

    menuBtn = display.newImageRect( sceneGroup, "assets/pictures/store/cross.png", 112.5,100);
    menuBtn.x = display.contentWidth - display.contentWidth/14;
    menuBtn.y = display.contentHeight/4 - display.contentHeight/50;       

    local highScoreText = display.newImageRect("assets/pictures/game over/best score.png",346,65)
    highScoreText.x = display.contentWidth/4 + display.contentWidth/10;
    highScoreText.y = display.contentHeight/3 + display.contentHeight/16 ;

    highText = display.newText( "0",display.contentWidth - display.contentWidth/4 ,display.contentHeight/3 + display.contentHeight/16 , native.systemFontBold, 40 )
    highText:setFillColor( 1,0,0 );

    local scoreText = display.newImageRect("assets/pictures/game over/score.png",175,62.5)
    scoreText.x = display.contentWidth/4;
    scoreText.y = display.contentHeight/4 + display.contentHeight/16;

    scoreValueText = display.newText( "0", display.contentWidth - display.contentWidth/4,display.contentHeight/4 + display.contentHeight/16, native.systemFontBold, 40 )
    scoreValueText.text = score.get();
    scoreValueText:setFillColor( 1,0,0 );

    leaderboardButton = display.newImageRect( sceneGroup, "assets/pictures/game over/rank btn.png", 177,158)
    leaderboardButton.x = display.contentWidth - display.contentWidth/3;
    leaderboardButton.y = display.contentHeight/1.7;

    acheivementButton = display.newImageRect( sceneGroup, "assets/pictures/game over/trophy btn.png", 177,158)
    acheivementButton.x = display.contentWidth/3;
    acheivementButton.y = display.contentHeight/1.7;

    twitterBtn = display.newImageRect( sceneGroup, "assets/pictures/game over/twitter.png", 162.5,137.5 )
    twitterBtn.x = display.contentWidth/6;
    twitterBtn.y = display.contentHeight - display.contentHeight/5;
    twitterBtn.isVisible = true 

    facebookBtn = display.newImageRect( sceneGroup, "assets/pictures/game over/facebook.png", 162.5,137.5 )
    facebookBtn.x = display.contentWidth - display.contentWidth/6;
    facebookBtn.y = display.contentHeight - display.contentHeight/5;
    facebookBtn.isVisible = true


    sceneGroup:insert(background);
    sceneGroup:insert(overlay);
    sceneGroup:insert(scoreOverlay1)
    sceneGroup:insert(scoreOverlay2)
    sceneGroup:insert(title)
    sceneGroup:insert(playAgainBtn);
    sceneGroup:insert(menuBtn);
    sceneGroup:insert(leaderboardButton)
    sceneGroup:insert(acheivementButton)
    sceneGroup:insert(highScoreText);
    sceneGroup:insert(highText);
    sceneGroup:insert(scoreText);
    sceneGroup:insert(facebookBtn);
    sceneGroup:insert(twitterBtn);
    sceneGroup:insert(scoreValueText);
    composer.removeHidden();
end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        admanagement.hideAds();
        if(gamesettings.removeAds == false) then
            if(gamesettings.totalAdCount % 3 == 0) then
                AdBuddiz.showAd();
            end
            gamesettings.totalAdCount = gamesettings.totalAdCount + 1;
            loadsave.saveTable(gamesettings, "settings.json");
        end
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        

        if(gamesettings.highScore ~= nil) then
            if(score.get() > gamesettings.highScore) then
                gamesettings.highScore = score.get();    
            end
        else
            gamesettings.highScore = score.get();
        end
        highText.text = gamesettings.highScore;
        networksLib.achievementCheck();
        networksLib.addScoreToLeaderboard(gamesettings.highScore);
        loadsave.saveTable(gamesettings, "settings.json")
        playAgainBtn:addEventListener("touch",onPlayAgainTouch);
        menuBtn:addEventListener("touch",onMenuTouch);
        leaderboardButton:addEventListener("touch", gotoLeaderBoard);
        facebookBtn:addEventListener("touch",onfacebookButtonTouch)
        twitterBtn:addEventListener("touch",ontwitterButtonTouch)
        acheivementButton:addEventListener("touch",onAcheivementBtnTouch);
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        playAgainBtn:removeEventListener("touch",onPlayAgainTouch);
        menuBtn:removeEventListener("touch",onMenuTouch);
        leaderboardButton:removeEventListener("touch", gotoLeaderBoard);
        facebookBtn:removeEventListener("touch",onfacebookButtonTouch)
        twitterBtn:removeEventListener("touch",ontwitterButtonTouch)
        acheivementButton:removeEventListener("touch",onAcheivementBtnTouch);
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    playAgainBtn = nil;
    menu = nil;
    scoreValueText = nil;
    highText = nil;
    leaderboardButton = nil;
    acheivementButton = nil;
    facebookBtn = nil;
    twitterBtn = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene