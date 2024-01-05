local networksLib = require "networksLib";
local composer = require "composer";
--local GA = require ( "plugin.gameanalytics")
local globals = require("globals")
local AdBuddiz = require "plugin.adbuddiz"
local admanagement = require("admanagement")

AdBuddiz.setAndroidPublisherKey( "8dfcc243-a1e9-45c5-9ba2-fc38aea5485c" )
AdBuddiz.setIOSPublisherKey( "f2c531f7-0a07-425b-878b-2c690cc55c01" )
globals.addMobandroidAppID = "ca-app-pub-9831354956955959/8485924229"
globals.addMobiOSAppID = "ca-app-pub-9831354956955959/3916123823"
globals.vungleVideoiOSAppID =   "560fcf214f09c064440001c7";
globals.vungleVideoAndroidAppID = "56363ab40f29b96c55000015";
globals.chartboostiOSAppID = "55859b480d60252df5a85003";
globals.chartboostiOSAppSig = "d726c5a59b3ccedd85e98bd5da3e10d95243c4b3";
globals.chartboostAndroidAppID = "5635f90ef6cd4568cbd0ba1a";
globals.chartboostAndroidAppSig = "10e453e929dde60255899b24cc008086d9923576";
globals.addMobAndroidInterstitialAppID = "ca-app-pub-9831354956955959/3203479827";
globals.rateUsPopupFrequency = 10;
globals.vungleAdCached = false;
globals.colored = false;
AdBuddiz.cacheAds();
admanagement.initAdMobBannerAd();
admanagement.initadmobinterstitial();
admanagement.loadAdmobInterstitial();
local activeNetworksProviders = {
  ["Android"] = {"google", "CgkIsbWi-ZkaEAIQAQ"}, --replace "google" with "none" if you don't use any leaderboard!
  ["iPhone OS"] = {"gamecenter", "savethebubble.highscore"} --replace "gamecenter" with "none" if you don't use any leaderboard!
};


local function systemEvents( event )
   if ( event.type == "applicationSuspend" ) then
   elseif ( event.type == "applicationResume" ) then
   elseif ( event.type == "applicationExit" ) then
   elseif ( event.type == "applicationStart" ) then
     networksLib.init(activeNetworksProviders);
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )