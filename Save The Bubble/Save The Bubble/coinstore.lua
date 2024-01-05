local composer = require( "composer" )
local globals = require("globals")
local scene = composer.newScene()
local store = require( "store" )
local loadsave = require("loadsave")
local gamesettings = require("gamesettings")
local v3 = false

if ( system.getInfo( "platformName" ) == "Android" ) then
    store = require( "plugin.google.iap.v3" )
    v3 = true
elseif ( system.getInfo( "platformName" ) == "iPhone OS" ) then
    store = require( "store" )
else
    native.showAlert( "Notice", "In-app purchases are not supported in the Corona Simulator.", { "OK" } )
end
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local background;
local coinPackage1,coinPackage2,coinPackage3,coinPackage4,coinPackage5;
local coins50,coins150,coins500,coins1000,coins1000000;
local menuBtn;
local coinImage,coinText;
local goToPowerUpStoreBtn;
-- -------------------------------------------------------------------------------

local function onMenuTouch(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.gotoScene( "menu", { effect = "slideRight", time = 800 } )
    end
end


local function goToPowerUpStoreBtnListener(event)
    if(event.phase == "began") then
        sfx.playTouchSound();
        composer.gotoScene( "powerupstore", { effect = "slideRight", time = 800 } )
    end
end

function transactionCallback( event )
    local transaction = event.transaction

    if transaction.state == "purchased" then
        print("Transaction succuessful!")
        print("productIdentifier", transaction.productIdentifier)
        print("receipt", transaction.receipt)
        print("transactionIdentifier", transaction.identifier)
        print("date", transaction.date)
        if(transaction.productIdentifier == "com.savethebubble.50coins") then
            -- add 50 coins to score
            store.consumePurchase("com.savethebubble.50coins");
            gamesettings.totalCoins = gamesettings.totalCoins + 50;
        elseif(transaction.productIdentifier == "com.savethebubble.150coins") then
            -- add 150 coins to score
            store.consumePurchase("com.savethebubble.150coins");
            gamesettings.totalCoins = gamesettings.totalCoins + 150;
        elseif(transaction.productIdentifier == "com.savethebubble.500coins") then
            -- add 500 coins to score
            store.consumePurchase("com.savethebubble.500coins");
            gamesettings.totalCoins = gamesettings.totalCoins + 500;
        elseif(transaction.productIdentifier == "com.savethebubble.1000coins") then
            -- add 1000 coins to score
            store.consumePurchase("com.savethebubble.1000coins");
            gamesettings.totalCoins = gamesettings.totalCoins + 1000;
        elseif(transaction.productIdentifier == "com.savethebubble.100000coins") then
            -- add 100000 coins to score
            store.consumePurchase("com.savethebubble.100000coins");
            gamesettings.totalCoins = gamesettings.totalCoins + 100000;
        end
        coinText.text = gamesettings.totalCoins;
        loadsave.saveTable(gamesettings, "settings.json");
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
local function purchaseCoins50 (event)
    if(event.phase == "ended") then
    sfx.playTouchSound();
        local function purchaseCallBackCoins50( event )
            print("coins50")
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    --globals.purchaseInProcess = "coins50";
                    if ( store.target == "apple" ) then
                        print("apple")
                        store.purchase({"com.savethebubble.50coins"});
                    elseif( store.target == "google" ) then
                        print("google")
                        store.purchase("com.savethebubble.50coins");
                    end
                elseif 2 == i then

                end
            end
        end
        local alert = native.showAlert( "Purchase 50 coins", "Do you want to purchase 50 coins for 0.99$?", { "Purchase","Cancel" }, purchaseCallBackCoins50 )
    end
end

local function purchaseCoins150 (event)
    if(event.phase == "ended") then
    sfx.playTouchSound();
        local function purchaseCallBack150coins( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    --globals.purchaseInProcess = "coins50";
                    if ( store.target == "apple" ) then
                        store.purchase({"com.savethebubble.150coins"});
                    elseif( store.target == "google" ) then
                        store.purchase("com.savethebubble.150coins");
                    end
                    
                elseif 2 == i then
                    
                end
            end
        end
        local alert = native.showAlert( "Purchase 150 coins", "Do you want to purchase 150 coins for 1.99$?", { "Purchase","Cancel" }, purchaseCallBack150coins )
    end
end

local function purchaseCoins500 (event)
    if(event.phase == "ended") then
    sfx.playTouchSound();
        local function purchaseCallBack500coins( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    --globals.purchaseInProcess = "coins50";
                    if ( store.target == "apple" ) then
                        store.purchase({"com.savethebubble.500coins"});
                    elseif( store.target == "google" ) then
                        store.purchase("com.savethebubble.500coins");
                    end
                    
                elseif 2 == i then
                    
                end
            end
        end
        local alert = native.showAlert( "Purchase 500 coins", "Do you want to purchase 500 coins for 2.99$?", { "Purchase","Cancel" }, purchaseCallBack500coins )
    end
end

local function purchaseCoins1000 (event)
    if(event.phase == "ended") then
    sfx.playTouchSound();
        local function purchaseCallBack1000coins( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    --globals.purchaseInProcess = "coins50";
                    if ( store.target == "apple" ) then
                        store.purchase({"com.savethebubble.1000coins"});
                    elseif( store.target == "google" ) then
                        store.purchase("com.savethebubble.1000coins");
                    end
                elseif 2 == i then
                   
                end
            end
        end
        local alert = native.showAlert( "Purchase 1000 coins", "Do you want to purchase 1000 coins for 5.99$?", { "Purchase","Cancel" }, purchaseCallBack1000coins )
    end
end

local function purchaseCoins100000 (event)
    if(event.phase == "ended") then
    sfx.playTouchSound();
        local function purchaseCallBack100000coins( event )
            if "clicked" == event.action then
                local i = event.index
                if 1 == i then
                    -- comment the following three lines
                    --globals.purchaseInProcess = "coins50";
                    if ( store.target == "apple" ) then
                        store.purchase({"com.savethebubble.100000coins"});
                    elseif( store.target == "google" ) then
                        store.purchase("com.savethebubble.100000coins");
                    end
                elseif 2 == i then
                    
                end
            end
        end
        local alert = native.showAlert( "Purchase 100000 coins", "Do you want to purchase 100000 coins for 99$?", { "Purchase","Cancel" }, purchaseCallBack100000coins )
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

    local powerupslabel = display.newImageRect( sceneGroup, "assets/pictures/store2/coins.png", 490,120 )
    powerupslabel.x = display.contentWidth/2
    powerupslabel.y = display.contentHeight/3.5
    powerupslabel.isVisible = true
    sceneGroup:insert(powerupslabel) 

    coinPackage1 = display.newImageRect( sceneGroup, "assets/pictures/store2/50.png", 180,160)
    coinPackage1.x = display.contentWidth/4;
    coinPackage1.y = display.contentHeight/2.5;
    sceneGroup:insert(coinPackage1);

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

    local dollar1 = display.newImageRect( sceneGroup, "assets/pictures/store2/dollar-sign.png", 50,50 );
    dollar1.x = display.contentWidth/5.5
    dollar1.y = display.contentHeight/2;
    sceneGroup:insert(dollar1);

    local coinPackage1Cost1 = display.newImageRect( imageSheet, 10, 50,60 )
    coinPackage1Cost1.x = display.contentWidth/4.4;
    coinPackage1Cost1.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage1Cost1);

    local dot1 = display.newImageRect( imageSheet, 10, 15,15 )
    dot1.x = display.contentWidth/3.8;
    dot1.y = display.contentHeight/1.95;
    sceneGroup:insert(dot1);

    local coinPackage1Cost2 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage1Cost2.x = display.contentWidth/3.5
    coinPackage1Cost2.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage1Cost2);

    local coinPackage1Cost3 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage1Cost3.x = display.contentWidth/3.1
    coinPackage1Cost3.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage1Cost3);   

    coinPackage2 = display.newImageRect( sceneGroup, "assets/pictures/store2/150.png", 180,160)
    coinPackage2.x = display.contentWidth/2;
    coinPackage2.y = display.contentHeight/2.5;
    sceneGroup:insert(coinPackage2);

    local dollar2 = display.newImageRect( sceneGroup, "assets/pictures/store2/dollar-sign.png", 50,50 );
    dollar2.x = display.contentWidth/4 + display.contentWidth/5.5
    dollar2.y = display.contentHeight/2;
    sceneGroup:insert(dollar2);

    local coinPackage2Cost1 = display.newImageRect( imageSheet, 1, 50,60 )
    coinPackage2Cost1.x = display.contentWidth/4 + display.contentWidth/4.2;
    coinPackage2Cost1.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage2Cost1);

    local dot2 = display.newImageRect( imageSheet, 10, 15,15 )
    dot2.x = display.contentWidth/4 + display.contentWidth/3.8;
    dot2.y = display.contentHeight/1.95;
    sceneGroup:insert(dot2);

    local coinPackage2Cost2 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage2Cost2.x = display.contentWidth/4 + display.contentWidth/3.5
    coinPackage2Cost2.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage2Cost2);

    local coinPackage2Cost3 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage2Cost3.x = display.contentWidth/4 + display.contentWidth/3.1
    coinPackage2Cost3.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage2Cost3);

    coinPackage3 = display.newImageRect( sceneGroup, "assets/pictures/store2/500.png", 180,160)
    coinPackage3.x = display.contentWidth - display.contentWidth/4;
    coinPackage3.y = display.contentHeight/2.5;
    sceneGroup:insert(coinPackage3);

    local dollar3 = display.newImageRect( sceneGroup, "assets/pictures/store2/dollar-sign.png", 50,50 );
    dollar3.x = display.contentWidth/2 + display.contentWidth/5.5
    dollar3.y = display.contentHeight/2;
    sceneGroup:insert(dollar3);

    local coinPackage3Cost1 = display.newImageRect( imageSheet, 2, 50,60 )
    coinPackage3Cost1.x = display.contentWidth/2 + display.contentWidth/4.2;
    coinPackage3Cost1.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage3Cost1);

    local dot3 = display.newImageRect( imageSheet, 10, 15,15 )
    dot3.x = display.contentWidth/2 + display.contentWidth/3.8;
    dot3.y = display.contentHeight/1.95;
    sceneGroup:insert(dot3);

    local coinPackage3Cost2 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage3Cost2.x = display.contentWidth/2 + display.contentWidth/3.5
    coinPackage3Cost2.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage3Cost2);

    local coinPackage3Cost3 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage3Cost3.x = display.contentWidth/2 + display.contentWidth/3.1
    coinPackage3Cost3.y = display.contentHeight/2;
    sceneGroup:insert(coinPackage3Cost3);

    coinPackage4 = display.newImageRect( sceneGroup, "assets/pictures/store2/1000.png", 180,160)
    coinPackage4.x = display.contentWidth/2.7;
    coinPackage4.y = display.contentHeight/1.6;
    sceneGroup:insert(coinPackage4);    

    local dollar4 = display.newImageRect( sceneGroup, "assets/pictures/store2/dollar-sign.png", 50,50 );
    dollar4.x = display.contentWidth/8 + display.contentWidth/5.5
    dollar4.y = display.contentHeight/5 + display.contentHeight/2;
    sceneGroup:insert(dollar4);

    local coinPackage4Cost1 = display.newImageRect( imageSheet, 5, 50,60 )
    coinPackage4Cost1.x = display.contentWidth/8 + display.contentWidth/4.2;
    coinPackage4Cost1.y = display.contentHeight/5 +display.contentHeight/2;
    sceneGroup:insert(coinPackage4Cost1);

    local dot4 = display.newImageRect( imageSheet, 10, 15,15 )
    dot4.x = display.contentWidth/8 + display.contentWidth/3.8;
    dot4.y = display.contentHeight/5 + display.contentHeight/1.95;
    sceneGroup:insert(dot4);

    local coinPackage4Cost2 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage4Cost2.x =  display.contentWidth/8 + display.contentWidth/3.5
    coinPackage4Cost2.y = display.contentHeight/5 + display.contentHeight/2;
    sceneGroup:insert(coinPackage4Cost2);

    local coinPackage5Cost3 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage5Cost3.x = display.contentWidth/8 + display.contentWidth/3.1
    coinPackage5Cost3.y = display.contentHeight/5 + display.contentHeight/2;
    sceneGroup:insert(coinPackage5Cost3);

    coinPackage5 = display.newImageRect( sceneGroup, "assets/pictures/store2/100000.png", 180,160)
    coinPackage5.x = display.contentWidth - display.contentWidth/2.7;
    coinPackage5.y = display.contentHeight/1.6;
    sceneGroup:insert(coinPackage5);       

    local dollar5 = display.newImageRect( sceneGroup, "assets/pictures/store2/dollar-sign.png", 50,50 );
    dollar5.x = display.contentWidth/2.5 + display.contentWidth/5.5
    dollar5.y = display.contentHeight/5 + display.contentHeight/2;
    sceneGroup:insert(dollar5);

    local coinPackage5Cost1 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage5Cost1.x = display.contentWidth/2.5 + display.contentWidth/4.2;
    coinPackage5Cost1.y = display.contentHeight/5 +display.contentHeight/2;
    sceneGroup:insert(coinPackage5Cost1);

    local coinPackage5Cost2 = display.newImageRect( imageSheet, 9, 50,60 )
    coinPackage5Cost2.x =  display.contentWidth/2.5 + display.contentWidth/3.6
    coinPackage5Cost2.y = display.contentHeight/5 + display.contentHeight/2;
    sceneGroup:insert(coinPackage5Cost2);   

    goToPowerUpStoreBtn = display.newImageRect( sceneGroup, "assets/pictures/store2/powerups.png",  490,120);
    goToPowerUpStoreBtn.x = display.contentCenterX;
    goToPowerUpStoreBtn.y = display.contentHeight - display.contentCenterY/6;     
    sceneGroup:insert(goToPowerUpStoreBtn)      

    menuBtn = display.newImageRect( sceneGroup, "assets/pictures/store/cross.png", 112.5,100);
    menuBtn.x = display.contentWidth - display.contentWidth/14;
    menuBtn.y = display.contentHeight/4 - display.contentHeight/50;  
    sceneGroup:insert(menuBtn)

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
        if ( store.target == "apple" ) then
            store.init( "apple", transactionCallback);
        elseif ( store.target == "google" ) then
                store.init( "google", transactionCallback);
        end
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        coinPackage1:addEventListener("touch",purchaseCoins50);
        coinPackage2:addEventListener("touch",purchaseCoins150);
        coinPackage3:addEventListener("touch",purchaseCoins500);
        coinPackage4:addEventListener("touch",purchaseCoins1000);
        coinPackage5:addEventListener("touch",purchaseCoins100000);
        menuBtn:addEventListener("touch",onMenuTouch);
        loadsave.saveTable(gamesettings, "settings.json");
        goToPowerUpStoreBtn:addEventListener("touch",goToPowerUpStoreBtnListener)
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
        coinPackage1:removeEventListener("touch",purchaseCoins50);
        coinPackage2:removeEventListener("touch",purchaseCoins150);
        coinPackage3:removeEventListener("touch",purchaseCoins500);
        coinPackage4:removeEventListener("touch",purchaseCoins1000);
        coinPackage5:removeEventListener("touch",purchaseCoins100000);
        goToPowerUpStoreBtn:removeEventListener("touch",goToPowerUpStoreBtnListener)
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
    coinPackage1 = nil;
    coinPackage2 = nil;
    coinPackage3 = nil;
    coinPackage4 = nil;
    coinPackage5 = nil;
    coins50 = nil;
    coins150 = nil;
    coins500 = nil;
    coins1000 = nil;
    coins1000000 = nil;
    goToPowerUpStoreBtn = nil;
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene