local composer = require( "composer" )
local globals = require("globals")
local gamesettings = require("gamesettings")
local widget = require( "widget" )
local sfx = require("sfx")
local store = require("store")
local loadsave = require("loadsave")
local ads = require("ads")
local admanagement = require("admanagement")
local scene = composer.newScene()
local v3 = false;
if ( system.getInfo( "platformName" ) == "Android" ) then
    store = require( "plugin.google.iap.v3" )
    v3 = true
elseif ( system.getInfo( "platformName" ) == "iPhone OS" ) then
    store = require( "store" )
else
    native.showAlert( "Notice", "In-app purchases are not supported in the Corona Simulator.", { "OK" } )
end
---------------------------------------------------------------------------------

local resumebtn
local background
local resumebtn
local twitterBtn,facebookBtn;
local restoreButton
local removeAddsButton
local serviceID
---------------------------------------------------------------------------------

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

-- Handle press events for the checkbox
local function onSwitchSoundPress( event )
  sfx.playTouchSound();
   if(event.target.name == "checkedSound") then
      onSoundBtn.isVisible = false;
      onDarkSoundBtn.isVisible = true;
      offDarkSoundBtn.isVisible = false;
      offSoundBtn.isVisible = true;
      gamesettings.soundOn = false;
   elseif(event.target.name == "uncheckedSound") then
      onSoundBtn.isVisible = true;
      onDarkSoundBtn.isVisible = false;
      offSoundBtn.isVisible = false;
      offDarkSoundBtn.isVisible = true;
      gamesettings.soundOn = true;
   end
   loadsave.saveTable(gamesettings, "settings.json")
end

local function onSwitchMusicPress( event )
    if(event.target.name == "checkedMusic") then
      onMusicBtn.isVisible = false;
      onDarkMusicBtn.isVisible = true;
      offMusicBtn.isVisible = true;
      offDarkMusicBtn.isVisible = false;
      gamesettings.musicOn = false;
      audio.pause()
   elseif(event.target.name == "uncheckedMusic") then
      onMusicBtn.isVisible = true;
      onDarkMusicBtn.isVisible = false;
      offMusicBtn.isVisible = false;
      offDarkMusicBtn.isVisible = true;
      gamesettings.musicOn = true;
      audio.resume()
      sfx.playBackgroundMusic();
   end
   loadsave.saveTable(gamesettings, "settings.json")
end

local function goBack (event)
  local phase = event.phase;
    if(event.phase == "ended") then
    	sfx.playTouchSound();
      composer.gotoScene( "menu", "slideLeft", 800 )
  end
  loadsave.saveTable(gamesettings, "settings.json")
end

function transactionCallback( event )
    local transaction = event.transaction

    if transaction.state == "purchased" then
        print("Transaction succuessful!")
        print("productIdentifier", transaction.productIdentifier)
        print("receipt", transaction.receipt)
        print("transactionIdentifier", transaction.identifier)
        print("date", transaction.date)
        if(transaction.productIdentifier == "com.savethebubble.removeads") then
          gamesettings.removeAds = true;
          loadsave.saveTable(gamesettings, "settings.json")
        end

    elseif  transaction.state == "restored" then
        print("Transaction restored (from previous session)")
        print("productIdentifier", transaction.productIdentifier)
        print("receipt", transaction.receipt)
        print("transactionIdentifier", transaction.identifier)
        print("date", transaction.date)
        print("originalReceipt", transaction.originalReceipt)
        print("originalTransactionIdentifier", transaction.originalIdentifier)
        print("originalDate", transaction.originalDate)
        if(transaction.productIdentifier == "com.savethebubble.removeads") then
          gamesettings.removeAds = true;
          loadsave.saveTable(gamesettings, "settings.json")
        end
    elseif transaction.state == "cancelled" then
        print("User cancelled transaction")

    elseif transaction.state == "failed" then
        print("Transaction failed, type:", transaction.errorType, transaction.errorString)

    else
        print("unknown event")
    end

    -- Once we are done with a transaction, call this to tell the store
    -- we are done with the transaction.
    -- If you are providing downloadable content, wait to call this until
    -- after the download completes.
    store.finishTransaction( transaction )
end

local function purchaseCallBack( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    if ( store.target == "apple" ) then
                      store.purchase({"com.savethebubble.removeads"})
                    elseif ( store.target == "google" ) then
                      store.purchase("com.savethebubble.removeads")
                    end
                elseif 2 == i then
        
                end
            end
end

local function removeAddsButtonEventListener (event)
  if(event.phase == "ended") then
    sfx.playTouchSound();
    if(gamesettings.removeAds == false) then
        local alert = native.showAlert( "Remove Ads", "Do you want to remove Ads for 1.99$?", { "Purchase", "Cancel" }, purchaseCallBack )
    else
        local alert = native.showAlert( "Remove Ads", "Remove ads has already been purchased for this app", { "Ok", "Cancel" });
    end
  end
end

local function restoreAddsButtonEventListener (event)
  if(event.phase == "ended") then
    if(gamesettings.removeAds == false) then
      print("RESTORE")
      store.restore();   
    else
        local alert = native.showAlert( "Remove Ads", "Remove ads has already been restored for this app", { "Ok", "Cancel" });
    end
    sfx.playTouchSound();
  end
end

-- "scene:create()"
function scene:create( event )

  local sceneGroup = self.view
  local background = display.newImageRect("assets/pictures/bg.png",display.contentWidth,display.contentHeight);
  background.x = display.contentWidth/2;
  background.y = display.contentHeight/2;
  sceneGroup:insert(background)

  local overlay = display.newImageRect("assets/pictures/setting screen/overlay.png",display.contentWidth/1.1,display.contentHeight/1.7);
  overlay.x = display.contentWidth/2;
  overlay.y = display.contentHeight/2;
  sceneGroup:insert(overlay)  

  local settingsLabel = display.newImageRect("assets/pictures/setting screen/setting.png",600,150);
  settingsLabel.x = display.contentWidth/2;
  settingsLabel.y = display.contentHeight/8;
  sceneGroup:insert(settingsLabel) 

  local musicbtn = display.newImageRect("assets/pictures/setting screen/music.png",175,62.5)
  musicbtn.x = display.contentWidth/4;
  musicbtn.y = display.contentHeight/4 + display.contentHeight/16 ;
  sceneGroup:insert(musicbtn);  

  local soundbtn = display.newImageRect("assets/pictures/setting screen/sounds.png",175,62.5)
  soundbtn.x = display.contentWidth/4;
  soundbtn.y = display.contentHeight/3 + display.contentHeight/16;
  sceneGroup:insert(soundbtn);

  local scoreOverlay1 = display.newImageRect("assets/pictures/game over/overlay.png",250,53)
  scoreOverlay1.x = display.contentWidth - display.contentWidth/2.8 ;
  scoreOverlay1.y = display.contentHeight/4 + display.contentHeight/16 ;
  sceneGroup:insert(scoreOverlay1)

  local scoreOverlay2 = display.newImageRect("assets/pictures/game over/overlay.png",250,53)
  scoreOverlay2.x = display.contentWidth - display.contentWidth/2.8 ;
  scoreOverlay2.y = display.contentHeight/3 + display.contentHeight/16 ;    
  sceneGroup:insert(scoreOverlay2)

  onMusicBtn = display.newImageRect("assets/pictures/setting screen/on.png",56.25,43.75)
  onMusicBtn.x = display.contentWidth/2 + display.contentWidth/14
  onMusicBtn.y = display.contentHeight/4 + display.contentHeight/16 ;
  onMusicBtn.name = "checkedMusic"

  onSoundBtn = display.newImageRect("assets/pictures/setting screen/on.png",56.25,43.75)
  onSoundBtn.x = display.contentWidth/2 + display.contentWidth/14
  onSoundBtn.y = display.contentHeight/3 + display.contentHeight/16;
  onSoundBtn.name = "checkedSound"

  onDarkMusicBtn = display.newImageRect("assets/pictures/setting screen/on-dark.png",66.25,36.25)
  onDarkMusicBtn.x = display.contentWidth/2 + display.contentWidth/14
  onDarkMusicBtn.y = display.contentHeight/4 + display.contentHeight/16 ;
  onDarkMusicBtn.name = "uncheckedMusic"

  onDarkSoundBtn = display.newImageRect("assets/pictures/setting screen/on-dark.png",66.25,36.25)
  onDarkSoundBtn.x = display.contentWidth/2 + display.contentWidth/14
  onDarkSoundBtn.y = display.contentHeight/3 + display.contentHeight/16;
  onDarkSoundBtn.name = "uncheckedSound"

  offMusicBtn = display.newImageRect("assets/pictures/setting screen/off.png",66.25,36.25)
  offMusicBtn.x = display.contentWidth - display.contentWidth/3.5;
  offMusicBtn.y = display.contentHeight/4 + display.contentHeight/16 ;
  offMusicBtn.name = "uncheckedMusic"

  offDarkMusicBtn = display.newImageRect("assets/pictures/setting screen/off-dark.png",66.25,36.25)
  offDarkMusicBtn.x = display.contentWidth - display.contentWidth/3.5;
  offDarkMusicBtn.y = display.contentHeight/4 + display.contentHeight/16 ;
  offDarkMusicBtn.name = "checkedMusic"

  offSoundBtn = display.newImageRect("assets/pictures/setting screen/off.png",66.25,36.25)
  offSoundBtn.x = display.contentWidth - display.contentWidth/3.5;
  offSoundBtn.y = display.contentHeight/3 + display.contentHeight/16;
  offSoundBtn.name = "uncheckedSound"

  offDarkSoundBtn = display.newImageRect("assets/pictures/setting screen/off-dark.png",66.25,36.25)
  offDarkSoundBtn.x =display.contentWidth - display.contentWidth/3.5;
  offDarkSoundBtn.y = display.contentHeight/3 + display.contentHeight/16;
  offDarkSoundBtn.name = "checkedSound"

  onMusicBtn.isVisible = false;
  onSoundBtn.isVisible = false;
  onDarkSoundBtn.isVisible = false;
  onDarkMusicBtn.isVisible = false;
  offSoundBtn.isVisible = false;
  offDarkSoundBtn.isVisible = false;
  offMusicBtn.isVisible = false;
  offDarkMusicBtn.isVisible = false;

  sceneGroup:insert(onMusicBtn);
  sceneGroup:insert(onSoundBtn);
  sceneGroup:insert(onDarkSoundBtn);
  sceneGroup:insert(onDarkMusicBtn);
  sceneGroup:insert(offMusicBtn);
  sceneGroup:insert(offDarkMusicBtn);
  sceneGroup:insert(offDarkSoundBtn);
  sceneGroup:insert(offSoundBtn);

  twitterBtn = display.newImageRect( sceneGroup, "assets/pictures/game over/twitter.png", 162.5,137.5 )
  twitterBtn.x = display.contentWidth/6;
  twitterBtn.y = display.contentHeight - display.contentHeight/5;
  twitterBtn.isVisible = true 

  facebookBtn = display.newImageRect( sceneGroup, "assets/pictures/game over/facebook.png", 162.5,137.5 )
  facebookBtn.x = display.contentWidth - display.contentWidth/6;
  facebookBtn.y = display.contentHeight - display.contentHeight/5;
  facebookBtn.isVisible = true

  removeAddsButton = display.newImageRect("assets/pictures/setting screen/remove-ads.png",475,150)
  removeAddsButton.x = display.contentWidth/2;
  removeAddsButton.y = display.contentHeight/2 + display.contentHeight/20;
  sceneGroup:insert(removeAddsButton);  

  restoreAddsButton = display.newImageRect("assets/pictures/setting screen/restore-purchase.png",475,150)
  restoreAddsButton.x = display.contentWidth/2;
  restoreAddsButton.y = display.contentHeight/2 + display.contentHeight/8 + display.contentHeight/16;
  sceneGroup:insert(restoreAddsButton);    

  resumebtn = display.newImageRect("assets/pictures/setting screen/resume.png",112.5,100)
  resumebtn.x = display.contentWidth - display.contentWidth/14;
  resumebtn.y = display.contentHeight/4 - display.contentHeight/50;
  sceneGroup:insert(resumebtn);    
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        if ( store.target == "google" ) then
            store.init( "google", transactionCallback);
    end

  if(gamesettings.soundOn == true) then
    onSoundBtn.isVisible = true;
    offDarkSoundBtn.isVisible = true;
    onDarkSoundBtn.isVisible = false;
    offSoundBtn.isVisible = false;
  elseif(gamesettings.soundOn == false) then
    onDarkSoundBtn.isVisible = true;
    offSoundBtn.isVisible = true;
    onSoundBtn.isVisible = false;
    offDarkSoundBtn.isVisible = false;
  end

  if(gamesettings.musicOn == true) then
    onMusicBtn.isVisible = true;
    offDarkMusicBtn.isVisible = true;
    onDarkMusicBtn.isVisible = false;
    offMusicBtn.isVisible = false;
  elseif(gamesettings.musicOn == false) then
    onDarkMusicBtn.isVisible = true;
    offMusicBtn.isVisible = true;
    onMusicBtn.isVisible = false;
    offDarkMusicBtn.isVisible = false;
  end


  removeAddsButton:addEventListener("touch",removeAddsButtonEventListener); 
  restoreAddsButton:addEventListener("touch",restoreAddsButtonEventListener);
  resumebtn:addEventListener("touch",goBack);
  onSoundBtn:addEventListener("tap",onSwitchSoundPress);
  onDarkSoundBtn:addEventListener("tap",onSwitchSoundPress);
  onDarkMusicBtn:addEventListener("tap",onSwitchMusicPress);
  offMusicBtn:addEventListener("tap",onSwitchMusicPress);
  offSoundBtn:addEventListener("tap",onSwitchSoundPress);
  offDarkSoundBtn:addEventListener("tap",onSwitchSoundPress);
  offDarkMusicBtn:addEventListener("tap",onSwitchMusicPress);
  onMusicBtn:addEventListener("tap",onSwitchMusicPress);
  facebookBtn:addEventListener("touch",onfacebookButtonTouch);
  twitterBtn:addEventListener("touch",ontwitterButtonTouch)
  loadsave.saveTable(gamesettings, "settings.json")
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
        resumebtn:removeEventListener("touch",goBack);
        removeAddsButton:removeEventListener("touch",removeAddsButtonEventListener);
        restoreAddsButton:removeEventListener("touch",restoreAddsButtonEventListener);
        onSoundBtn:removeEventListener("tap",onSwitchSoundPress);
        onDarkSoundBtn:removeEventListener("tap",onSwitchSoundPress);
        onDarkMusicBtn:removeEventListener("tap",onSwitchMusicPress);
        facebookBtn:removeEventListener("touch",onfacebookButtonTouch)
        twitterBtn:removeEventListener("touch",ontwitterButtonTouch)
        onMusicBtn:removeEventListener("tap",onSwitchMusicPress);
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
    resumebtn = nil;
    background = nil;
    resumebtn = nil;
    twitterBtn = nil;
    facebookBtn = nil;
    restoreButton = nil;
    removeAddsButton = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
