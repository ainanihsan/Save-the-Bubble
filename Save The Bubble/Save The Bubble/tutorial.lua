local composer = require( "composer" )
local globals = require("globals")
local gamesettings = require("gamesettings")
local sfx = require("sfx")
local loadsave = require("loadsave")
local scene = composer.newScene()

---------------------------------------------------------------------------------
local resumebtn;


local function onMenuTouch(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.gotoScene( "menu", { effect = "slideRight", time = 800 } )
    end
end

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local background = display.newImageRect("assets/pictures/bg.png",display.contentWidth,display.contentHeight);
  background.x = display.contentWidth/2;
  background.y = display.contentHeight/2;
  sceneGroup:insert(background)

  local overlay = display.newImageRect("assets/pictures/setting screen/overlay.png",display.contentWidth/1.1,display.contentHeight/1.2);
  overlay.x = display.contentWidth/2;
  overlay.y = display.contentHeight/2;
  sceneGroup:insert(overlay)  

  local options = 
{
    --parent = textGroup,
    text = "Save your Bubble from incoming torpedoes!\n\nTap the screen to change your sheild's direction!\n\nSecure 10 coins after successfull deflection of 10 torpedoes!\n\nUse your coins to buy powerups that help you score higher than your friends!\n\nThe powerups help decrease speed, give an extra life to the bubble or give 30 seconds of immunity!\n\nSo what are you waiting for?\nGo save your bubble!!",     
    x = display.contentWidth/2,
    y = display.contentHeight/2,
    width = display.contentWidth/1.5,     --required for multi-line and alignment
    font = native.systemFont,   
    fontSize = 33,
    align = "center"  --new alignment parameter
}

  local myText = display.newText( options )
  myText:setFillColor( 0, 0, 0 )
  sceneGroup:insert(myText)
  resumebtn = display.newImageRect("assets/pictures/setting screen/resume.png",112.5,100)
  resumebtn.x = display.contentWidth - display.contentWidth/14;
  resumebtn.y = display.contentHeight/8;
  sceneGroup:insert(resumebtn);    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        resumebtn:addEventListener("touch",onMenuTouch);
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
        resumebtn:removeEventListener("touch",onMenuTouch);
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    resumebtn = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
