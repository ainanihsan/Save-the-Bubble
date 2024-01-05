local composer = require ("composer")

local rotateAbout = {};
local returnAngle;
local counter = 0;
rotateAbout.currentAngleValue = function ()
	return returnAngle;
end

local function vecScale( x, y, s )
   return x *s, y * s
end

local function angle2Vec( angle )
    local screenAngle = math.rad( -(angle+90) )
    return -math.cos( screenAngle ), math.sin( screenAngle )
end
rotateAbout.getRotateAbout = function( obj, x, y, params  )	
    
    x = x or display.contentCenterX
	y = y or display.contentCenterY
	params = params or {}
    
    local radius 		= params.radius or 117
	obj._pathRot 		= params.startA or 0
	local endA 			= params.endA or (obj._pathRot + 360 )
	local time 			= params.time or 1000
	local myEasing 		= params.myEasing or easing.linear
	local debugEn 		= params.debugEn
	local delay 		= params.delay
	local onComplete 	= params.onComplete

	-- Start at right position
	local vx,vy = angle2Vec( obj._pathRot )
	vx,vy = vecScale( vx, vy, radius )
	obj.x = x + vx 
	obj.y = y + vy
	
    -- remove 'enterFrame' listener when we finish the transition.
	obj.onComplete = function( self )	
		Runtime:removeEventListener( "enterFrame", self )
		if( onComplete ) then onComplete( self ) end
	end

	-- Update position every frame
	obj.enterFrame = function ( self )
		local vx,vy = angle2Vec( self._pathRot )
		vx,vy = vecScale( vx, vy, radius )
		self.x = x + vx 
		self.y = y + vy
		if(counter%40 == 0) then
			--print(self._pathRot)
		end
		counter = counter + 1;
		returnAngle = self._pathRot;

		if( debugEn ) then
			if(self.parent ~= nil) then
				local tmp = display.newCircle( self.parent, self.x, self.y, 1 )
				tmp:toBack()
			end
		end
	end
	
	Runtime:addEventListener( "enterFrame", obj )

	-- Use transition to change the angle (gives us access to nice effects)
	transition.to( obj, { _pathRot = endA, delay = delay, time = 1300,tag = "rotateTag", transition = myEasing, onComplete = obj } )
end


return rotateAbout