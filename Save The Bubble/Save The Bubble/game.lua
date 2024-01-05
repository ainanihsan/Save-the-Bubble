local composer = require( "composer" )
local rotateAbout = require ("rotateAbout")
local physics = require("physics");
require("timer_transition_cancellation")
local loadsave = require("loadsave")
local sfx = require("sfx")
local score = require("score");
local gamesettings = require("gamesettings")
local globals = require("globals");
local admanagement = require("admanagement")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local bubbleObj,blocker
local starts,ends;
local pauseBtn;
local switch = true;
local bullets = {};
local i = 0;
local j =0;
local timerText;
local coinText;
local extraLife;
local paused = false;
local timerVal = 30;
local powerUpButton;
local powerUpActivated = false;
-- -------------------------------------------------------------------------------

--set physics environment
physics.start();
physics.setGravity( 0, 0 ); -- no gravity in any direction

----------------------------------------------------------------------------------

local function onComplete( self )
    rotateAbout.getRotateAbout( self, centerX, centerY, { radius = 150 , startA = starts,endA = ends ,onComplete = onComplete } ) 
end

local function increaseSpeed()
    if(gamesettings.torpedoSpeed > 100) then
        gamesettings.torpedoSpeed = gamesettings.torpedoSpeed - 100;
        loadsave.saveTable(gamesettings, "settings.json");
    end
end

local function printMemUsage()          
        local memUsed = (collectgarbage("count")) / 1000
        local texUsed = system.getInfo( "textureMemoryUsed" ) / 1000000
        
        print("\n---------MEMORY USAGE INFORMATION---------")
    print("System Memory Used:", string.format("%.03f", memUsed), "Mb")
        print("Texture Memory Used:", string.format("%.03f", texUsed), "Mb")
    print("------------------------------------------\n")
     
    return true
end

local function onPauseBtnTouch(event)
    local phase = event.phase
    if(event.phase == "ended") then
        sfx.playTouchSound();
        transition.pause();
        paused = true;
        local options = {
                isModal = true,
                effect = "fade",
                time = 400,
            }   
            -- By some method (a pause button, for example), show the overlay
        composer.showOverlay( "pauseMenu", options )
    end
end

local function resumeTransition()
    transition.resume();
    paused = false;
end

function scene:resumeGame()
    --code to resume game
    timerStash[#timerStash + 1] = timer.performWithDelay( 2000,resumeTransition )
end

local function onScreenTouch(event)
    -- body
    if(event.phase == "began") then
        sfx.playTurnOverSound();
        starts = rotateAbout.currentAngleValue();
        if(switch) then
            ends = starts - 360;
            switch = false;
        else
            ends = starts + 360;
            switch = true;
        end
        transition.cancel("rotateTag");
        rotateAbout.getRotateAbout( blocker, display.contentCenterX, display.contentCenterY, { radius = 150, delay = 0,startA = starts,endA = ends, debugEn = false, onComplete = onComplete } )
    end
end


local function randomGenerator(xCoord,yCoord,rotVal)
    local randValue = math.random(1,4);
    if(randValue == 1) then
        -- consider right side of screen
        xCoord = display.contentWidth;
        yCoord = math.random(0,display.contentHeight)
        if(yCoord <display.contentHeight/2) then
            rotVal = -(45 - (yCoord / display.contentHeight/2)*45);
        else
            rotVal = -((yCoord / display.contentHeight/2)*45 - 45);
        end
    elseif (randValue == 2) then
        -- consider left side of screen
        xCoord = 0;
        yCoord = math.random(0,display.contentHeight)
        rotVal =  yCoord;
        if(yCoord <display.contentHeight/2) then
            rotVal = (45 - (yCoord / display.contentHeight/2)*45) + 180;
        else
            rotVal = ((yCoord / display.contentHeight/2)*45 - 45) + 180;
        end
    elseif (randValue == 3) then
        -- consider top side of screen
        xCoord = math.random(0,display.contentWidth)
        yCoord = 0;
        rotVal = -(135 - (xCoord/display.contentWidth)*90);        
    elseif (randValue == 4) then    
        -- consider bottom side of screen
        xCoord = math.random(0,display.contentWidth)
        yCoord = display.contentHeight;
        rotVal = (135 - (xCoord/display.contentWidth)*90); 
    end
    return xCoord,yCoord,rotVal;
end


local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end


local function coinAdder()
    if(score.get() % 10 == 0) then
        gamesettings.totalCoins = gamesettings.totalCoins + 10;
        loadsave.saveTable(gamesettings, "settings.json");
        coinText.text = gamesettings.totalCoins;
    end
end

local function powerUpDisable()
    bubbleObj.fill.effect = ""
    globals.colored = false;
    timerText.isVisible = false;
    timerVal = 30;
    powerUpButton.isVisible = false;
end

local function updateText()
    timerVal = timerVal - 1;
    timerText.text = timerVal;
end

local function onCollision(event)
    if(event.phase == "began" and event.object1 == blocker and event.object2.nameTag == "bullet") then
        -- if bullet hits the sheild remove the bullet
        sfx.playCollisionSound();
        display.remove(object2)
        event.object2:removeSelf();
        table.remove(bullets);
        event.object2 = nil;
        score.add(1);
        gamesettings.totalScore = gamesettings.totalScore + 1;
        coinAdder();
        loadsave.saveTable(gamesettings, "settings.json") 
    elseif(event.phase == "began" and event.object2 == blocker and event.object1.nameTag == "bullet") then
        -- if bullet hits the sheild remove the bullet
        sfx.playCollisionSound();
        display.remove(object1)
        event.object1:removeSelf();
        table.remove(bullets);
        event.object1 = nil;
        score.add(1);
        gamesettings.totalScore = gamesettings.totalScore + 1;
        coinAdder();
        loadsave.saveTable(gamesettings, "settings.json") 
    elseif(event.phase == "began" and event.object1 == bubbleObj and event.object2.nameTag == "bullet") then
        -- if bullet hits the bubble the game is over
        --composer.removeScene( "game" );
        sfx.playGameOverSound();
        display.remove(object2)
        event.object2:removeSelf();
        table.remove(bullets);
        event.object2 = nil;
        print("timerText",timerText.isVisible)
        if(extraLife.isVisible==true and timerText.isVisible == false) then
            extraLife.isVisible = false;
        elseif(extraLife.isVisible==true and timerText.isVisible == true) then

        elseif(timerText.isVisible) then
            -- do nothing
        else
            composer.gotoScene( "gameover", { effect = "fade", time = 300 } )
        end
    elseif(event.phase == "began" and event.object2 == bubbleObj and event.object1.nameTag == "bullet") then
        -- if bullet hits the bubble the game is over
        --composer.removeScene( "game" );
        sfx.playGameOverSound();
        display.remove(object1)
        event.object1:removeSelf();
        table.remove(bullets);
        event.object1 = nil;
        if(extraLife.isVisible==true and timerText.isVisible == false) then
            extraLife.isVisible = false;
        elseif(extraLife.isVisible==true and timerText.isVisible == true) then

        elseif(timerText.isVisible) then
            -- do nothing
        else
            composer.gotoScene( "gameover", { effect = "fade", time = 300 } )
        end
    end
end

function onPowerBtnTouch( event )
    if(event.phase == "ended") then
        sfx.playTouchSound();
        bubbleObj.fill.effect = "filter.sobel"
        bubbleObj.fill.effect.intensity = 0.2
        transition.to( bubbleObj.fill.effect, { time=2000, intensity=0.8 } )
        timerText.isVisible = true;
        powerUpButton.isVisible = false;
        powerUpActivated = true;
        timerStash[#timerStash + 1] = timer.performWithDelay(1000,updateText,30);
        timerStash[#timerStash + 1] = timer.performWithDelay(30000,powerUpDisable);
    end
end

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
    
    -- create background image
    local background = display.newImageRect( sceneGroup, "assets/pictures/bg.png", display.contentWidth, display.contentHeight)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    -- create bubble image
    bubbleObj = display.newImageRect( sceneGroup, "assets/pictures/Bubble.png", 100,100 )
    bubbleObj.x = display.contentWidth * 0.5
    bubbleObj.y = display.contentHeight * 0.5
    bubbleObj.isVisible = false

    -- create blocker/sheild image
    blocker = display.newImageRect( sceneGroup, "assets/pictures/main game screen/shield.png", 100,100 )
    blocker.x = display.contentWidth * 0.5
    blocker.y = display.contentHeight * 0.5
    blocker.isVisible = false        

    local scoreText = score.init({
       fontSize = 45,
       font = "Helvetica",
       x = display.contentCenterX,
       y = display.contentHeight/20,
       maxDigits = 7,
       leadingZeros = true,
       filename = "scorefile.txt",
    })
    local coinImage = display.newImageRect( sceneGroup, "assets/pictures/store/coin.png", 50,50 )
    coinImage.x = display.contentWidth - display.contentWidth*.125;
    coinImage.y = display.contentHeight/22;
    coinText = display.newText(gamesettings.totalCoins, display.contentWidth - display.contentWidth/13, display.contentHeight/20, native.systemFontBold, 40)

    extraLife = display.newImageRect( sceneGroup, "assets/pictures/life.png", 90,60 )
    extraLife.x = display.contentWidth/4;
    extraLife.y = display.contentHeight/20;
    extraLife.isVisible = false;

    pauseBtn = display.newImageRect( sceneGroup, "assets/pictures/main game screen/pause.png", 100,100 )
    pauseBtn.x = display.contentWidth/10;
    pauseBtn.y = display.contentHeight/20;
    pauseBtn.isVisible = true;   

    physics.addBody( bubbleObj, "static" ,{ density=0.3, radius=15.0 ,friction=0.6 } )
    physics.addBody( blocker, { density=0.3, friction=0.6, radius=30.0 } )

    timerText = display.newText( "30", display.contentWidth/2,display.contentHeight - display.contentHeight/6, labelFontBold, 50 )
    timerText.isVisible = false;

    powerUpButton = display.newImageRect( sceneGroup, "assets/pictures/store/powerUp3.png", 100,90 )
    powerUpButton.x = display.contentWidth/10;
    powerUpButton.y = display.contentHeight/6;
    powerUpButton.isVisible = false;

    sceneGroup:insert(background);
    sceneGroup:insert(bubbleObj);
    sceneGroup:insert(blocker);
    sceneGroup:insert(scoreText);
    sceneGroup:insert(coinImage);
    sceneGroup:insert(coinText);
    sceneGroup:insert(extraLife);
    sceneGroup:insert(pauseBtn);
    sceneGroup:insert(timerText);
    sceneGroup:insert(powerUpButton)
    composer.removeHidden();
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase
    local tweenTime = 2000
    local throwTorpedoes = 1200;
    local function throwBullet()
        if(paused ~= true) then
            i = i + 1;
            if(i % 20 == 0) then
                if(throwTorpedoes >100) then
                    throwTorpedoes = throwTorpedoes - 100;
                end
            end
            local rotateVal,xCoordinate,yCoordinate;
            -- create the bullet
            xCoordinate,yCoordinate,rotateVal= randomGenerator(xCoordinate,yCoordinate);
            bullets[i] = display.newImage( "assets/pictures/main game screen/torpedo.png", xCoordinate,yCoordinate);
            bullets[i].xScale = .5;
            bullets[i].yScale = .5;
            bullets[i].rotation = rotateVal;
            physics.addBody( bullets[i], { density=3.0, friction=1, bounce=0.05 } )
            bullets[i].isBullet = true;
            bullets[i].nameTag = "bullet";
            sceneGroup:insert(bullets[i]);
            print("gamesettings.torpedoSpeed",gamesettings.torpedoSpeed)
            transitionStash[#transitionStash + 1] = transition.to( bullets[i], { time=gamesettings.torpedoSpeed, x=display.contentCenterX, y=display.contentCenterY } )
        end
    end

    local function startGame()
        -- throw 3 bullets
        timerStash[#timerStash + 1] = timer.performWithDelay( throwTorpedoes, throwBullet, 30000 )
    end
    if ( phase == "will" ) then
            
        coinText.text = gamesettings.totalCoins;
        -- Called when the scene is still off screen (but is about to come on screen).
            if(globals.reset) then
                globals.reset = false;
                i = 0;
                switch = true;
                score.set(0);
            end

        -- initially minimize the image          
            bubbleObj.alpha = 1
            bubbleObj.xScale = 0.1;
            bubbleObj.yScale = 0.1;
            bubbleObj.isVisible = true;

            -- same as above for bubble
            blocker.xScale = 0.1;
            blocker.yScale = 0.1;
            blocker.isVisible = true;
           

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
            admanagement.hideAds();
            if(globals.extraBubbleLife) then
                extraLife.isVisible = true;
                globals.extraBubbleLife = false;
            end
            -- transition to full size to create a nice effect
            transitionStash[#transitionStash + 1] = transition.to( bubbleObj, { time=tweenTime, xScale = 1 , yScale = 1, transition=easing.outExpo } )
            transitionStash[#transitionStash + 1] = transition.to( blocker, { time=tweenTime, xScale = 1 , yScale = 1, transition=easing.outExpo, onComplete = addRuntimeListener } )

            -- rotate the sheild around the bubble using rotateAbout
            rotateAbout.getRotateAbout( blocker, display.contentCenterX, display.contentCenterY, { radius = 150, delay = 0, debugEn = false, onComplete = onComplete } )
            if(globals.colored) then
                powerUpButton.isVisible = true;
            end
            timerStash[#timerStash + 1] = timer.performWithDelay( 800, startGame )
            timerStash[#timerStash + 1] = timer.performWithDelay(20000,increaseSpeed);
            -- add listeners to register touch
            Runtime:addEventListener("touch",onScreenTouch);
            Runtime:addEventListener("collision",onCollision);
            pauseBtn:addEventListener("touch",onPauseBtnTouch);
            powerUpButton:addEventListener("touch",onPowerBtnTouch);
            
            --timerStash[#timerStash + 1] = timer.performWithDelay( 1000, printMemUsage, 0 )
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

        -- remove all timers and transitions
        cancelAllTransitions();
        cancelAllTimers();

        -- remove all bullets from scene
        for a = #bullets,1,-1 do
            display.remove(bullets[a]);
            bullets[a] = nil;
            table.remove(bullets,a);
        end
        gamesettings.torpedoSpeed = 1500;
        loadsave.saveTable(gamesettings, "settings.json");
        -- remove all listeners
        Runtime:removeEventListener("touch",onScreenTouch);
        Runtime:removeEventListener("collision",onCollision);
--        pauseBtn:removeEventListener("touch",onPauseBtnTouch);
--        powerUpButton:removeEventListener("touch",onPowerBtnTouch);
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        
        
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    bubbleObj = nil;
    blocker = nil;
    starts = nil;
    ends = nil;
    switch = nil;
    tweenTime = nil;
    coinText = nil;
    bullets = nil;
    extraLife = nil;
    pauseBtn = nil;
    paused = nil;
    powerUpButton = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene