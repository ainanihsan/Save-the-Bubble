module(..., package.seeall)

local gamesettings = require("gamesettings")

local musicHandle;
if (system.getInfo( "platformName" ) == "Android") then
	musicHandle = audio.loadStream("assets/audio/main_theme.mp3");
else
	musicHandle = audio.loadStream("assets/audio/main_theme.mp3");
end

local touchSound;
if (system.getInfo( "platformName" ) == "Android") then
	touchSound = audio.loadSound("assets/audio/btn.mp3");
else
	touchSound = audio.loadSound("assets/audio/btn.mp3");
end

local collisionSound;
if (system.getInfo( "platformName" ) == "Android") then
	collisionSound = audio.loadSound("assets/audio/hit.mp3");
else
	collisionSound = audio.loadSound("assets/audio/hit.mp3");
end

local gameOverSound;
if (system.getInfo( "platformName" ) == "Android") then
	gameOverSound = audio.loadSound("assets/audio/gameOverSFX.mp3");
else
	gameOverSound = audio.loadSound("assets/audio/gameOverSFX.mp3");
end

local turnOverSound;
if (system.getInfo( "platformName" ) == "Android") then
	turnOverSound = audio.loadSound("assets/audio/swipe.mp3");
else
	turnOverSound = audio.loadSound("assets/audio/swipe.mp3");
end

--[[Initailizes the sfx by specifying a channel for all the different sounds that can be required]]
function init ()
    audio.reserveChannels(4);
    audio.setVolume(0.2, {channel = 1})     -- music
    audio.setVolume(0.7, {channel = 2})     -- touch
    audio.setVolume(0.7, {channel = 3})     -- collision
    audio.setVolume(0.7, {channel = 3})     -- gameover
    audio.setVolume(0.7, {channel = 4})     -- turn
end

--[[Play the background music if the music is set on by the user]]
function playBackgroundMusic ()
	if (gamesettings.musicOn == false) then
		return false;
	end
	audio.play(musicHandle, {channel = 1, loops = -1,fadein=5000 });
end

--[[ Play a sound only if sounds are set ON ]]
function playTouchSound ( )
	if (gamesettings.soundOn == false) then
		return false;
	end
	audio.play(touchSound, {channel = 2});
end

--[[ Play a sound only if sounds are set ON ]]
function playCollisionSound ( )
	if (gamesettings.soundOn == false) then
		return false;
	end
	audio.play(collisionSound, {channel = 3});
end

--[[ Play a sound only if sounds are set ON ]]
function playGameOverSound ( )
	if (gamesettings.soundOn == false) then
		return false;
	end
	audio.play(gameOverSound, {channel = 3});
end

--[[ Play a sound only if sounds are set ON ]]
function playTurnOverSound ( )
	if (gamesettings.soundOn == false) then
		return false;
	end
	audio.play(turnOverSound, {channel = 4});
end

function stopBackGroundMusic( ... )
	audio.stop(musicHandle)
end