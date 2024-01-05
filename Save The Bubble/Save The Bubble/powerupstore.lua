local composer = require( "composer" )
local globals = require("globals")
local scene = composer.newScene()
local loadsave = require("loadsave")
local gamesettings = require("gamesettings")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local background;
local powerUp1,powerUp2,powerUp3;
local menuBtn,bubbleLife,sheildColor,sheildLength,torpedoColor,torpedoSpeed;
local coinImage,coinText;
local goToCoinStoreBtn;
-- -------------------------------------------------------------------------------

local function onMenuTouch(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.gotoScene( "menu", { effect = "slideRight", time = 800 } )
    end
end

local function goToCoinStoreBtnListener(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.gotoScene( "coinstore", { effect = "slideLeft", time = 800 } )
    end
end

local function powerUp1Purchase(event)
   if "clicked" == event.action then
        local i = event.index
                if 1 == i then
                    sfx.playTouchSound();
                    if(gamesettings.totalCoins >= 100) then
                        gamesettings.totalCoins = gamesettings.totalCoins - 100;
                        gamesettings.slowTorpedoes = gamesettings.slowTorpedoes + 1;
                        loadsave.saveTable(gamesettings, "settings.json");
                        print("gamesettings.slowTorpedoes",gamesettings.slowTorpedoes);
                        coinText.text = gamesettings.totalCoins;
                        native.showAlert( "PowerUp Added", "Power up added to decrease torpedo speed", { "Ok" } )
                    else
                        native.showAlert( "Insufficient coins", "You have insufficient number of coins. You can buy more coins from our store", { "Ok" } )
                    end
                elseif 2 == i then
                    sfx.playTouchSound();
                end 
    end
end

local function powerUp2Purchase(event)
   if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            sfx.playTouchSound();
            if(gamesettings.totalCoins >= 150) then
                gamesettings.totalCoins = gamesettings.totalCoins - 150;
                gamesettings.bubbleLife = gamesettings.bubbleLife + 1;
                loadsave.saveTable(gamesettings, "settings.json");
                coinText.text = gamesettings.totalCoins;
                native.showAlert( "PowerUp Added", "Power up added to add bubble life", { "Ok" } )
            else
                native.showAlert( "Insufficient coins", "You have insufficient number of coins. You can buy more coins from our store", { "Ok" } )
            end
        elseif 2 == i then
            sfx.playTouchSound();
        end 
    end 
end


local function powerUp3Purchase(event)
   if "clicked" == event.action then
        local i = event.index
        if 1 == i then
            sfx.playTouchSound();
            if(gamesettings.totalCoins >= 500) then
                gamesettings.totalCoins = gamesettings.totalCoins - 500;
                gamesettings.sheildColor = gamesettings.sheildColor + 1;
                loadsave.saveTable(gamesettings, "settings.json");
                print("gamesettings.sheildColor",gamesettings.sheildColor);
                coinText.text = gamesettings.totalCoins;
                native.showAlert( "PowerUp Added", "Power up added to make the bubble strong for 30 seconds.", { "Ok" } )
            else
                native.showAlert( "Insufficient coins", "You have insufficient number of coins. You can buy more coins from our store", { "Ok" } )
            end
        elseif 2 == i then
            sfx.playTouchSound();
        end 
    end 
end

local function powerUp1Decision(event)
    if(event.phase == "ended") then
        sfx.playTouchSound();
        native.showAlert( "PowerUp Addition", "Do you want to add a powerup to decrease torpedo speed?", { "Yes","No" } ,powerUp1Purchase )
    end
end

local function powerUp2Decision(event)
    if(event.phase == "ended") then
        sfx.playTouchSound();
        native.showAlert( "PowerUp Addition", "Do you want to add a powerup to add bubble life?", { "Yes","No" },powerUp2Purchase )
    end
end

local function powerUp3Decision(event)
    if(event.phase == "ended") then
        sfx.playTouchSound();
        native.showAlert( "PowerUp Addition", "Do you want to add a powerup to make the bubble strong for 30 seconds?", { "Yes","No" },powerUp3Purchase )
    end
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    -- create background image
    background = display.newImageRect( sceneGroup, "assets/pictures/bg.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY
    sceneGroup:insert(background);

    local overlay = display.newImageRect("assets/pictures/setting screen/overlay.png",display.contentWidth/1.1,display.contentHeight/1.7);
    overlay.x = display.contentWidth/2;
    overlay.y = display.contentHeight/2;
    sceneGroup:insert(overlay)  

    local title = display.newImageRect( sceneGroup, "assets/pictures/store/store.png", 450,150 )
    title.x = display.contentWidth/2
    title.y = display.contentHeight/8
    title.isVisible = true
    sceneGroup:insert(title)


    local options =
{
    -- The params below are required

    width = 63.4,
    height = 78,
    numFrames = 10,

    -- The params below are optional (used for dynamic image sheet selection)

    sheetContentWidth = 634,  -- width of original 1x size of entire sheet
    sheetContentHeight = 78  -- height of original 1x size of entire sheet
}

    local imageSheet = graphics.newImageSheet( "assets/pictures/store/numbers.png", options )

    local powerupslabel = display.newImageRect( sceneGroup, "assets/pictures/store/powerups.png", 490,120 )
    powerupslabel.x = display.contentWidth/2
    powerupslabel.y = display.contentHeight/3.5
    powerupslabel.isVisible = true
    sceneGroup:insert(powerupslabel)    

    powerUp1 = display.newImageRect( sceneGroup, "assets/pictures/store/powerUp1.png", 177,158)
    powerUp1.x = display.contentWidth/2.7
    powerUp1.y = display.contentHeight/2.5;
    sceneGroup:insert(powerUp1);    

    local coin1 = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 );
    coin1.x = display.contentWidth/3.25;
    coin1.y = display.contentHeight/2;
    sceneGroup:insert(coin1);

    local powerUp1Cost1 = display.newImageRect( imageSheet, 1, 50,60 )
    powerUp1Cost1.x = display.contentWidth/2.75;
    powerUp1Cost1.y = display.contentHeight/2;
    sceneGroup:insert(powerUp1Cost1);

    local powerUp1Cost2 = display.newImageRect( imageSheet, 10, 50,60 )
    powerUp1Cost2.x = display.contentWidth/2.6;
    powerUp1Cost2.y = display.contentHeight/2;
    sceneGroup:insert(powerUp1Cost2);

    local powerUp1Cost3 = display.newImageRect( imageSheet, 10, 50,60 )
    powerUp1Cost3.x = display.contentWidth/2.35;
    powerUp1Cost3.y = display.contentHeight/2;
    sceneGroup:insert(powerUp1Cost3);    

    powerUp2 = display.newImageRect( sceneGroup, "assets/pictures/store/health.png", 177,158)
    powerUp2.x = display.contentWidth - display.contentWidth/2.7;
    powerUp2.y = display.contentHeight/2.5;
    sceneGroup:insert(powerUp2);   

    local coin2 = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 );
    coin2.x = display.contentWidth/4 + display.contentWidth/3.25;
    coin2.y = display.contentHeight/2;
    sceneGroup:insert(coin2);

    local powerUp2Cost1 = display.newImageRect( imageSheet, 1, 50,60 )
    powerUp2Cost1.x = display.contentWidth/4 + display.contentWidth/2.75;
    powerUp2Cost1.y = display.contentHeight/2;
    sceneGroup:insert(powerUp2Cost1);

    local powerUp2Cost2 = display.newImageRect( imageSheet, 5, 50,60 )
    powerUp2Cost2.x = display.contentWidth/4 + display.contentWidth/2.55;
    powerUp2Cost2.y = display.contentHeight/2;
    sceneGroup:insert(powerUp2Cost2);

    local powerUp2Cost3 = display.newImageRect( imageSheet, 10, 50,60 )
    powerUp2Cost3.x = display.contentWidth/4 + display.contentWidth/2.35;
    powerUp2Cost3.y = display.contentHeight/2;
    sceneGroup:insert(powerUp2Cost3);    

    powerUp3 = display.newImageRect( sceneGroup, "assets/pictures/store/powerUp3.png", 177,158)
    powerUp3.x = display.contentWidth/2;
    powerUp3.y = display.contentHeight/1.6;
    sceneGroup:insert(powerUp3);

    local coin3 = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 );
    coin3.x = display.contentWidth/7 + display.contentWidth/3.4;
    coin3.y = display.contentHeight/4.5 + display.contentHeight/2;
    sceneGroup:insert(coin3);

    local powerUp3Cost1 = display.newImageRect( imageSheet, 5, 50,60 )
    powerUp3Cost1.x = display.contentWidth/7 + display.contentWidth/2.9;
    powerUp3Cost1.y = display.contentHeight/4.5 + display.contentHeight/2;
    sceneGroup:insert(powerUp3Cost1);

    local powerUp3Cost2 = display.newImageRect( imageSheet, 10, 50,60 )
    powerUp3Cost2.x = display.contentWidth/7 + display.contentWidth/2.65;
    powerUp3Cost2.y = display.contentHeight/4.5 + display.contentHeight/2;
    sceneGroup:insert(powerUp3Cost2);

    local powerUp3Cost3 = display.newImageRect( imageSheet, 10, 50,60 )
    powerUp3Cost3.x = display.contentWidth/7 + display.contentWidth/2.37;
    powerUp3Cost3.y = display.contentHeight/4.5 + display.contentHeight/2 ;
    sceneGroup:insert(powerUp3Cost3);    


    menuBtn = display.newImageRect( sceneGroup, "assets/pictures/store/cross.png", 112.5,100);
    menuBtn.x = display.contentWidth - display.contentWidth/14;
    menuBtn.y = display.contentHeight/4 - display.contentHeight/50;  
    sceneGroup:insert(menuBtn)

    goToCoinStoreBtn = display.newImageRect( sceneGroup, "assets/pictures/store/coinstore.png",  490,120);
    goToCoinStoreBtn.x = display.contentCenterX;
    goToCoinStoreBtn.y = display.contentHeight - display.contentCenterY/6;     
    sceneGroup:insert(goToCoinStoreBtn)    

    coinImage = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 )
    coinImage.x = display.contentWidth - display.contentWidth/8;
    coinImage.y = display.contentHeight/22;
    coinText = display.newText(gamesettings.totalCoins, display.contentWidth - display.contentWidth/16, display.contentHeight/20, native.systemFontBold, 40)
    sceneGroup:insert(coinImage);
    sceneGroup:insert(coinText)
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
        coinText.text = gamesettings.totalCoins;
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        powerUp1:addEventListener("touch",powerUp1Decision);
        powerUp2:addEventListener("touch",powerUp2Decision);
        powerUp3:addEventListener("touch",powerUp3Decision);
        menuBtn:addEventListener("touch",onMenuTouch);
        goToCoinStoreBtn:addEventListener("touch",goToCoinStoreBtnListener)
        loadsave.saveTable(gamesettings, "settings.json");
        print("gamesettings.torpedoSpeed",gamesettings.torpedoSpeed)
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
        powerUp1:removeEventListener("touch",powerUp1Decision);
        powerUp2:removeEventListener("touch",powerUp2Decision);
        powerUp3:removeEventListener("touch",powerUp3Decision);
        goToCoinStoreBtn:removeEventListener("touch",goToCoinStoreBtnListener)
        menuBtn:removeEventListener("touch",onMenuTouch);
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    background = nil;
    powerUp1 = nil;
    powerUp2 = nil;
    powerUp3 = nil;
    goToCoinStoreBtn = nil;
    menuBtn = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene