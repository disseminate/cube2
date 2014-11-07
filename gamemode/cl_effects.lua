FrozenOverlay = false;
StartTime = 0;

local function Fade( um )
	
	local col = Color( 255, 255, 255, 255 );
	local tin = um:ReadShort();
	local tout = um:ReadShort();
	
	FadeStart = CurTime();
	FadeColor = col;
	FadeTimeIn = tin;
	FadeTimeOut = tout;
	
end
usermessage.Hook( "Fade", Fade );

local function StartFlashFlame()
	
	StartFlashEffect = CurTime();
	
end
usermessage.Hook( "FlashFlame", StartFlashFlame );

local function ImFalling()
	
	ImFalling = true;
	
end
usermessage.Hook( "ImFalling", ImFalling );

local function PlayClSound( um )
	
	local n = um:ReadShort();
	
	if( n == 1 ) then -- lag reduction
		
		surface.PlaySound( Sound( "physics/nearmiss/whoosh_huge2.wav" ) );
		
	elseif( n == 2 ) then
		
		surface.PlaySound( Sound( "ambient/atmosphere/thunder" .. math.random( 1, 2 ) .. ".wav" ) );
		
	end
	
end
usermessage.Hook( "PlayClSound", PlayClSound );

local function msgGameOver()
	
	surface.PlaySound( Sound( "weapons/mortar/mortar_explode2.wav" ) );
	GameOver = true;
	
end
usermessage.Hook( "msgGameOver", msgGameOver );

local function ResetVars()
	
	StartFlashEffect = 0;
	ImFalling = false;
	
end
usermessage.Hook( "ResetVars", ResetVars );

local function SetViewLocation( um )
	
	local vec = um:ReadVector();
	local ang = um:ReadAngle();
	
	if( vec == Vector( 0, 0, 0 ) ) then
		
		CamOverridePos = nil;
		
	else
		
		CamOverridePos = vec;
		
	end
	
	if( ang == Vector( 0, 0, 0 ) ) then
		
		CamOverrideAng = nil;
		
	else
		
		CamOverrideAng = ang;
		
	end
	
end
usermessage.Hook( "SetViewLocation", SetViewLocation );

local function FrozenOverlayOn()
	
	FrozenOverlay = true;
	
end
usermessage.Hook( "FrozenOverlayOn", FrozenOverlayOn );

local function FrozenOverlayOff()
	
	FrozenOverlay = false;
	
end
usermessage.Hook( "FrozenOverlayOff", FrozenOverlayOff );

local function SetStartTime()
	
	local t = CurTime();
	StartTime = t;
	
end
usermessage.Hook( "SetStartTime", SetStartTime );