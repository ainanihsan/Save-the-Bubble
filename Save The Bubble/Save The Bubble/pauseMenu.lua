----------------------------------------------------------------------------------
--
-- scenetemplate.lua
--
----------------------------------------------------------------------------------

local composer = require( "composer" )
local globals = require("globals")
local sfx = require("sfx")
local loadsave = require("loadsave")
local gamesettings = require("gamesettings")
local admanagement = require("admanagement")
local scene = composer.newScene()

---------------------------------------------------------------------------------

local resumebtn

---------------------------------------------------------------------------------

local function onSwitchSoundPress( event )
  sfx.playTouchSound();
   if(event.target.name == "checkedSound") then
      soundOnButton.isVisible = false;
      soundOffButton.isVisible = true;
      gamesettings.soundOn = false
   elseif(event.target.name == "uncheckedSound") then
      soundOnButton.isVisible = true;
      soundOffButton.isVisible = false;
      gamesettings.soundOn = true;
   end
   loadsave.saveTable(gamesettings, "settings.json")
end

local function onSwitchMusicPress( event )
    if(event.target.name == "checkedMusic") then
      musicOnButton.isVisible = false;
      musicOffButton.isVisible = true;
      gamesettings.musicOn = false;
      audio.pause()
   elseif(event.target.name == "uncheckedMusic") then
      musicOnButton.isVisible = true;
      musicOffButton.isVisible = false;
      gamesettings.musicOn = true;
      audio.resume()
      sfx.playBackgroundMusic();
   end
   loadsave.saveTable(gamesettings, "settings.json")
end


local function goBack (event)
	local phase = event.phase
	if(event.phase == "ended") then
		sfx.playTouchSound();
		composer.hideOverlay( "fade", 400 )
	end
end

local function onMenuButtonPress(event)
  if(event.phase == "ended") then
    sfx.playTouchSound();
    composer.removeScene("rotateAbout")
    composer.gotoScene( "menu", { effect = "slideLeft", time = 800 } )
  end
end

local function onRefreshButtonPress(event)
  if(event.phase == "ended") then
    sfx.playTouchSound();
    composer.removeScene("rotateAbout")
    composer.gotoScene( "powerUpsActivation", { effect = "fade", time = 800 } )
  end
end

function scene:create( event )
  local sceneGroup = self.view
  local background = display.newImageRect("assets/pictures/bg.png",display.contentWidth,display.contentHeight);
  background.x = display.contentWidth/2;
  background.y = display.contentHeight/2;
  sceneGroup:insert(background)

  local overlay = display.newImageRect("assets/pictures/pause screen/overlay.png",display.contentWidth,display.contentHeight);
  overlay.x = display.contentWidth/2;
  overlay.y = display.contentHeight/2;
  sceneGroup:insert(overlay)

  local pauseLabel = display.newImageRect("assets/pictures/pause screen/pause.png",500,140);
  pauseLabel.x = display.contentWidth/3;
  pauseLabel.y = display.contentHeight/8;
  sceneGroup:insert(pauseLabel) 

  menuButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/menu btn.png", 153.5,125.5 )
  menuButton.x = display.contentWidth/5.2;
  menuButton.y = display.contentHeight/2 + display.contentHeight/40;
  menuButton.isVisible = true
  sceneGroup:insert(menuButton)
  
  refreshButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/refresh btn.png", 153.5,125.5 )
  refreshButton.x = display.contentWidth/5.9;
  refreshButton.y = display.contentHeight/2.85;
  refreshButton.isVisible = true
  sceneGroup:insert(refreshButton)

  musicOnButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/music on.png", 153.5,125.5 )
  musicOnButton.x = display.contentWidth/3.4;
  musicOnButton.y = display.contentHeight/1.41
  musicOnButton.isVisible = false
  musicOnButton.name = "checkedMusic"
  sceneGroup:insert(musicOnButton)  

  musicOffButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/music off.png", 153.5,125.5 )
  musicOffButton.x = display.contentWidth/3.4;
  musicOffButton.y = display.contentHeight/1.41;
  musicOffButton.isVisible = false
  musicOffButton.name = "uncheckedMusic"
  sceneGroup:insert(musicOffButton)  

  soundOnButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/sound on.png", 153.5,125.5 )
  soundOnButton.x = display.contentWidth/2 + display.contentWidth/10;
  soundOnButton.y = display.contentHeight/1.23
  soundOnButton.isVisible = false
  soundOnButton.name = "checkedSound"
  sceneGroup:insert(soundOnButton)  

  soundOffButton = display.newImageRect( sceneGroup, "assets/pictures/pause screen/sound off.png", 153.5,125.5 )
  soundOffButton.x = display.contentWidth/2 + display.contentWidth/10;
  soundOffButton.y = display.contentHeight/1.23;
  soundOffButton.isVisible = false
  soundOffButton.name = "uncheckedSound"
  sceneGroup:insert(soundOffButton)  

  playButton = display.newImageRect( sceneGroup, "assets/pictures/main menu/play.png", 287.5,250 )
  playButton.x = display.contentWidth/1.7
  playButton.y = display.contentHeight/2.3
  playButton.isVisible = true
  sceneGroup:insert(playButton);   
  

  if(gamesettings.soundOn == true) then
      soundOnButton.isVisible = true;
      soundOffButton.isVisible = false;
    elseif(gamesettings.soundOn == false) then
      soundOnButton.isVisible = false;
      soundOffButton.isVisible = true;
    end

    if(gamesettings.musicOn == true) then
      musicOnButton.isVisible = true;
      musicOffButton.isVisible = false
    elseif(gamesettings.musicOn == false) then
      musicOnButton.isVisible = false;
      musicOffButton.isVisible = true;
    end
  
  playButton:addEventListener("touch",goBack);
  soundOnButton:addEventListener("tap",onSwitchSoundPress)
  soundOffButton:addEventListener("tap",onSwitchSoundPress)
  musicOnButton:addEventListener("tap",onSwitchMusicPress)
  musicOffButton:addEventListener("tap",onSwitchMusicPress)
  menuButton:addEventListener("touch",onMenuButtonPress)
  refreshButton:addEventListener("touch",onRefreshButtonPress)

end


function scene:hide( event )
  local sceneGroup = self.view
   local phase = event.phase
   local parent = event.parent  --reference to the parent scene object

   if ( phase == "will" ) then
      -- Call the "resumeGame()" function in the parent scene


    parent:resumeGame()
    playButton:removeEventListener("touch",goBack);
    soundOnButton:removeEventListener("tap",onSwitchSoundPress)
    soundOffButton:removeEventListener("tap",onSwitchSoundPress)
    musicOnButton:removeEventListener("tap",onSwitchMusicPress)
    musicOffButton:removeEventListener("tap",onSwitchMusicPress)
    menuButton:removeEventListener("touch",onMenuButtonPress)
    refreshButton:removeEventListener("touch",onRefreshButtonPress)
    loadsave.saveTable(gamesettings, "settings.json")
    end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "hide", scene )

---------------------------------------------------------------------------------

return scene