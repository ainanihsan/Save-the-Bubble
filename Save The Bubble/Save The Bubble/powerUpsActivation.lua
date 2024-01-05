local composer = require( "composer" )
local gamesettings = require("gamesettings")
local loadsave = require("loadsave")
local admanagement = require("admanagement")
local globals = require("globals")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local background,playBtn;
local powerUp1,powerUp2,powerUp3;
local powerUp1Present = false;
local powerUp2Present = false;
local powerUp3Present = false;
local coinText;
local powerUp1Label,powerUp2Label,powerUp3Label;
-- -------------------------------------------------------------------------------


local function playBtnListener(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.removeScene("rotateAbout")
        composer.removeScene("game")
        composer.gotoScene( "game", "slideLeft", 800 )
    end
end

local function powerUp1Listener(event)
    if(event.phase == "began") then
    sfx.playTouchSound();
        if(gamesettings.slowTorpedoes ~= 0 and powerUp1.alpha ~= 0.2) then
            sfx.playTouchSound();
            gamesettings.slowTorpedoes = gamesettings.slowTorpedoes - 1;
            gamesettings.torpedoSpeed = gamesettings.torpedoSpeed + 700;
            powerUp1Label.text = gamesettings.slowTorpedoes;
            powerUp1.alpha = 0.2;
            powerUp1Present = true;
            loadsave.saveTable(gamesettings, "settings.json");
        elseif (powerUp1Present == true and powerUp1.alpha == 0.2) then
            sfx.playTouchSound();
            gamesettings.slowTorpedoes = gamesettings.slowTorpedoes + 1;
            gamesettings.torpedoSpeed = gamesettings.torpedoSpeed - 700;
            powerUp1Label.text = gamesettings.slowTorpedoes;
            powerUp1.alpha = 1;
            powerUp1Present = false;
            loadsave.saveTable(gamesettings, "settings.json");
        end
    end
end

local function powerUp2Listener(event)
    if(event.phase == "began") then
        if(gamesettings.bubbleLife ~= 0 and powerUp2.alpha ~= 0.2) then
            sfx.playTouchSound();
            gamesettings.bubbleLife = gamesettings.bubbleLife - 1;
            powerUp2Label.text = gamesettings.bubbleLife;
            globals.extraBubbleLife = true;
            powerUp2.alpha = 0.2;
            powerUp2Present = true;
            loadsave.saveTable(gamesettings, "settings.json");
        elseif (powerUp2Present == true and powerUp2.alpha == 0.2) then
            sfx.playTouchSound();
            gamesettings.bubbleLife = gamesettings.bubbleLife + 1;
            powerUp2Label.text = gamesettings.bubbleLife;
            globals.extraBubbleLife = false;
            powerUp2.alpha = 1;
            powerUp2Present = false;
            loadsave.saveTable(gamesettings, "settings.json");
        end
    end
end

local function powerUp3Listener(event)
    if(event.phase == "began") then
        if(gamesettings.sheildColor ~= 0 and powerUp3.alpha ~= 0.2) then
            sfx.playTouchSound();
            gamesettings.sheildColor = gamesettings.sheildColor - 1;
            powerUp3Label.text = gamesettings.sheildColor;
            globals.colored = true;
            powerUp3.alpha = 0.2;
            powerUp3Present = true;
            loadsave.saveTable(gamesettings, "settings.json");
        elseif (powerUp3Present == true and powerUp3.alpha == 0.2) then
            sfx.playTouchSound();
            gamesettings.sheildColor = gamesettings.sheildColor + 1;
            powerUp3Label.text = gamesettings.sheildColor;
            globals.colored = false;
            powerUp3.alpha = 1;
            powerUp3Present = false;
            loadsave.saveTable(gamesettings, "settings.json");
        end
    end
end

local function storeBtnListener( event )
    if(event.phase == "began")then
        sfx.playTouchSound();
        composer.gotoScene( "powerupstore", "slideLeft", 800 )
    end
end
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    background = display.newImageRect("assets/pictures/bg.png",display.contentWidth,display.contentHeight);
    background.x = display.contentWidth/2;
    background.y = display.contentHeight/2;
    sceneGroup:insert(background)

    local overlay = display.newImageRect("assets/pictures/setting screen/overlay.png",display.contentWidth/1.1,display.contentHeight/1.7);
    overlay.x = display.contentWidth/2;
    overlay.y = display.contentHeight/2;
    sceneGroup:insert(overlay)  

    local powerupslabel = display.newImageRect( sceneGroup, "assets/pictures/store/powerups.png", 490,120 )
    powerupslabel.x = display.contentWidth/2
    powerupslabel.y = display.contentHeight/3.5
    powerupslabel.isVisible = true
    sceneGroup:insert(powerupslabel)    

    powerUp1 = display.newImageRect( sceneGroup, "assets/pictures/store/powerUp1.png", 177,158)
    powerUp1.x = display.contentWidth/2.7
    powerUp1.y = display.contentHeight/2.2;
    sceneGroup:insert(powerUp1);    

    powerUp2 = display.newImageRect( sceneGroup, "assets/pictures/store/health.png", 177,158)
    powerUp2.x = display.contentWidth - display.contentWidth/2.7;
    powerUp2.y = display.contentHeight/2.2;
    sceneGroup:insert(powerUp2);   

    powerUp3 = display.newImageRect( sceneGroup, "assets/pictures/store/powerUp3.png", 177,158)
    powerUp3.x = display.contentWidth/2;
    powerUp3.y = display.contentHeight/1.6;
    sceneGroup:insert(powerUp3);  

    powerUp1Label = display.newText( gamesettings.slowTorpedoes,display.contentWidth/15 + display.contentWidth/2.7,display.contentHeight/30 + display.contentHeight/2.2,"Segoe Script", 40 )
    powerUp1Label:setFillColor( 0,0,0 )
    sceneGroup:insert(powerUp1Label);

    powerUp2Label = display.newText( gamesettings.bubbleLife,display.contentWidth/15 + display.contentWidth - display.contentWidth/2.7,display.contentHeight/30 + display.contentHeight/2.2, "Segoe Script",40)
    powerUp2Label:setFillColor( 0,0,0)
    sceneGroup:insert(powerUp2Label);

    powerUp3Label = display.newText( gamesettings.sheildColor, display.contentWidth/15 + display.contentWidth/2,display.contentHeight/30 + display.contentHeight/1.6,"Segoe Script", 40)
    powerUp3Label:setFillColor( 0,0,0 )
    sceneGroup:insert(powerUp3Label);  

    storeBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/store.png", 162.5,137.5 )
    storeBtn.x = display.contentWidth/6;
    storeBtn.y = display.contentHeight - display.contentHeight/5;
    storeBtn.isVisible = true 
    sceneGroup:insert(storeBtn)

    playBtn = display.newImageRect( sceneGroup, "assets/pictures/main menu/play.png", 140,125 )
    playBtn.x = display.contentWidth - display.contentWidth/6;
    playBtn.y = display.contentHeight - display.contentHeight/5;
    playBtn.isVisible = true  
    sceneGroup:insert(playBtn)

    local coinImage = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 )
    coinImage.x = display.contentWidth - display.contentWidth*.125;
    coinImage.y = display.contentHeight/22;
    coinText = display.newText(gamesettings.totalCoins, display.contentWidth - display.contentWidth/13, display.contentHeight/20, native.systemFontBold, 40)
    sceneGroup:insert(coinImage)
    sceneGroup:insert(coinText)

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        
        --loadsave.loadTable("settings.json");
        powerUp1Label.text = gamesettings.slowTorpedoes;
        powerUp2Label.text = gamesettings.bubbleLife;
        powerUp3Label.text = gamesettings.sheildColor;
        coinText.text = gamesettings.totalCoins;
        if(gamesettings.slowTorpedoes == 0) then
            powerUp1.alpha = 0.2;
        end
        if(gamesettings.bubbleLife == 0) then
            powerUp2.alpha = 0.2;
        end
        if(gamesettings.sheildColor == 0) then
            powerUp3.alpha = 0.2;
        end
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        
        globals.extraBubbleLife = false;
        playBtn:addEventListener("touch",playBtnListener);
        powerUp1:addEventListener("touch",powerUp1Listener);
        powerUp2:addEventListener("touch",powerUp2Listener);
        powerUp3:addEventListener("touch",powerUp3Listener);
        storeBtn:addEventListener("touch",storeBtnListener);
        loadsave.saveTable(gamesettings, "settings.json");
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
        playBtn:removeEventListener("touch",playBtnListener);
        powerUp1:removeEventListener("touch",powerUp1Listener);
        powerUp2:removeEventListener("touch",powerUp2Listener);
        powerUp3:removeEventListener("touch",powerUp3Listener);
        storeBtn:removeEventListener("touch",storeBtnListener);
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    background = nil;
    playBtn = nil;
    storeBtn = nil;
    powerUp1 = nil;
    powerUp2 = nil;
    powerUp3 = nil;
    coinText = nil;
    powerUp1Label = nil;
    powerUp2Label = nil;
    powerUp3Label = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene