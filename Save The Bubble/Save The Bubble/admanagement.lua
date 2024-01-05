module(..., package.seeall)

local composer = require( "composer" )
local loadsave = require("loadsave");
local globals = require("globals");
local ads = require ("ads");
local sfx = require("sfx")
local gamesettings = require("gamesettings")
local loadsave = require("loadsave")
local chartboost = require( "plugin.chartboost" )
require("timer_transition_cancellation");

local appid
local appSignature
local listener


function handleIncentivizedAdPlay( event )
        print("handle")
        ads:setCurrentProvider("vungle")
        ads.show( "incentivized" ,{isBackButtonEnabled =true})
end

function vungleAdListener( event )
    if ( event.type == "adStart" and event.isError ) then
        -- Ad has not finished caching and will not play
    end
    if ( event.type == "adStart" and not event.isError ) then
        -- Ad will play
        print("adStart")
    end
    if ( event.type == "cachedAdAvailable" ) then
        -- Ad has finished caching and is ready to play
        print("cachedAdAvailable")
       globals.vungleAdCached = true;
    end
    if ( event.type == "adView" ) then
        -- An ad has completed
        
    end
    if ( event.type == "adEnd" ) then
        -- The ad experience has been closed- this
        -- is a good place to resume your app
            print("adEnd")
            gamesettings.totalCoins = gamesettings.totalCoins + 10;
            loadsave.saveTable(gamesettings, "settings.json");
    end
end

function initVungleVideoAd()
    if (system.getInfo("platformName") == "Android") then
        ads.init( "vungle", globals.vungleVideoAndroidAppID, vungleAdListener )
    else
        ads.init( "vungle", globals.vungleVideoiOSAppID, vungleAdListener )
    end
    
end

function initAdMobBannerAd ()
    local function adListener( event )
        if event.isError then
            -- Failed to receive an ad.
        end
    end

    if (system.getInfo("platformName") == "Android") then
        ads.init( "admob", globals.addMobandroidAppID, adListener );
    else
        ads.init( "admob", globals.addMobiOSAppID, adListener );
    end
end

function initadmobinterstitial( ... )
    ads.init( "admob", globals.addMobAndroidInterstitialAppID, adListener );
end


function hideAds()
    ads.hide();
end

function loadAdmobInterstitial()
    ads.load( "interstitial", { testMode=false } )
end

function showAdMobInterstitialAd (adX, adY)
    ads:setCurrentProvider("admob")
    if (system.getInfo("platformName") == "Android") then
        ads.show( "interstitial", { x=0, y=0, appId=globals.addMobAndroidInterstitialAppID } )  -- standard interval for "inneractive" is 60 seconds
    else  
        
    end
end


function showAdMobBannerAd (adX, adY)
    ads:setCurrentProvider("admob")
    if (system.getInfo("platformName") == "Android") then
        ads.show( "banner", { x=adX, y=adY, interval=60, appId=globals.addMobandroidAppID} )   -- standard interval for "inneractive" is 60 seconds
    else  
        ads.show( "banner", { x=adX, y=adY, interval=60, appId=globals.addMobiOSAppID} ) 
    end
end

-- -- The ChartBoost listener function
-- local function chartBoostListener( event )
--     for k, v in pairs( event ) do
--         print( tostring(k).. "=".. tostring(v) )
--     end
-- end

-- function cacheChartboostFullScreenAd( )
--         chartboost.cache( "interstitial" )
-- end

-- function systemEvent( event )
--     local phase = event.response
--     local yourAppID        = globals.chartboostiOSAppID;
--     local yourAppSignature = globals.chartboostiOSAppSig;
--     if event.type == "applicationResume" then
--         -- Start a ChartBoost session
--         chartboost.startSession( yourAppID, yourAppSignature )
--     end
    
--     return true
-- end

-- function initChartboostFullScreenAd ()
-- -- Your Chartboost app id and signature for iOS
-- local yourAppID        = globals.chartboostiOSAppID;
-- local yourAppSignature = globals.chartboostiOSAppSig;

-- -- Change the appid/sig for Android
-- if system.getInfo( "platformName" ) == "Android" then
--     yourAppID        = globals.chartboostAndroidAppID;
--     yourAppSignature = globals.chartboostAndroidAppSig;
-- end

-- print( "Chartboost plugin version: ".. chartboost.getPluginVersion() )

-- -- Initialise ChartBoost
-- chartboost.init {
--         appID        = yourAppID,
--         appSignature = yourAppSignature, 
--         listener     = chartBoostListener
--     }

-- Runtime:addEventListener( "system", systemEvent )
-- end

-- function showChartboostFullScreenAd( )

--         print( "has cached Ad?: "..tostring( chartboost.hasCachedInterstitial() ))
--         print( "has cached more apps?: ".. tostring( chartboost.hasCachedMoreApps() ))
--         chartboost.show( "interstitial" )
-- end