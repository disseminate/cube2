DeriveGamemode( "fretta" );

GM.Name		= "Cube 2.3"
GM.Author	= "Disseminate"
GM.Email	= ""
GM.Website	= "http://luaforfood.com/"
GM.Help     = [[You're trapped in a giant maze, named the Cube. Your goal is to navigate this maze and reach the exit through the 'bridge cube', a moving cube that takes you to the exit.

However, some of these rooms contain death traps which kill you instantly. Luckily, you have your boots which are heavy enough to trigger the pressure sensors of most traps, so you can check if a room is trapped by throwing them. This won't disable the trap though! Boots are the only way to detect traps, so work together to preserve them.

To use voice commands, type the words "help", "hi", "over here", or "lets go" and you will say the line.

Escape the cube the fastest in 15 minutes to win, or in classic mode, just escape with your friends.]]

-- Project begin: December 28, 2009

GM.TeamBased 					= false;
GM.AllowAutoTeam 				= true;
GM.AllowSpectating 				= true;  
GM.SelectClass 					= false;
GM.SecondsBetweenTeamSwitches 	= 0;
GM.GameLength 					= 15;
GM.VotingDelay 					= 8;
GM.NoPlayerDamage 				= false;
GM.NoPlayerSelfDamage 			= false;
GM.NoPlayerTeamDamage 			= false;
GM.NoPlayerPlayerDamage 		= false;
GM.NoNonPlayerPlayerDamage 		= false;
GM.ValidSpectatorModes = { OBS_MODE_CHASE, OBS_MODE_IN_EYE };
GM.SuicideString = "took their own life"

GIB_MODELS = {
	"models/Gibs/HGIBS.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_rib.mdl",
	"models/Gibs/HGIBS_scapula.mdl",
	"models/Gibs/HGIBS_spine.mdl",
	"models/gibs/antlion_gib_small_3.mdl"
};

F_DEATH_SOUNDS = { -- I hate this sort of inefficient hardcoded stuff, but without it, girly man screams.
	"vo/npc/female01/help01.wav",
	"vo/npc/female01/ow01.wav",
	"vo/npc/female01/ow02.wav"
}

M_DEATH_SOUNDS = {
	"vo/npc/male01/help01.wav",
	"vo/npc/male01/no02.wav",
	"vo/npc/male01/ow01.wav",
	"vo/npc/male01/pain07.wav",
	"vo/npc/male01/pain08.wav",
	"vo/npc/male01/pain09.wav"
}

F_PLAYERMODELS = {
	"models/player/alyx.mdl",
	"models/player/mossman.mdl",
	"models/player/group01/female_01.mdl",
	"models/player/group01/female_02.mdl",
	"models/player/group01/female_03.mdl",
	"models/player/group01/female_04.mdl",
	"models/player/group01/female_06.mdl",
	"models/player/group01/female_07.mdl",
	"models/player/group03/female_01.mdl",
	"models/player/group03/female_02.mdl",
	"models/player/group03/female_03.mdl",
	"models/player/group03/female_04.mdl",
	"models/player/group03/female_06.mdl",
	"models/player/group03/female_07.mdl"
};

BystanderLines = {
	"fantastic01.wav",
	"goodgod.wav",
	"gordead_ans02.wav",
	"gordead_ans04.wav",
	"gordead_ans05.wav",
	"gordead_ans07.wav",
	"gordead_ans08.wav",
	"gordead_ans16.wav",
	"gordead_ans19.wav",
	"gordead_ques01.wav",
	"gordead_ques02.wav",
	"gordead_ques07.wav",
	"gordead_ques10.wav",
	"nice01.wav",
	"ohno.wav",
	"question26.wav",
	"startle01.wav",
	"startle02.wav",
	"whoops01.wav",
};

CUBESHIFT = { };

CUBESHIFT.red = { };
CUBESHIFT.green = { };
CUBESHIFT.blue = { };
CUBESHIFT.white = { };

local CLASS = {}

CLASS.DisplayName			= "Escapees"
CLASS.CanUseFlashlight      = false
CLASS.AvoidPlayers			= true

function CLASS:Loadout( pl )
	
	if( pl:Team() != TEAM_SPECTATOR ) then
		
		pl:Give( "weapon_boot" );
		pl.Boots = 1;
		umsg.Start( "RBC", pl ); umsg.End();
		pl:GetActiveWeapon():SetNoDraw( false );
		
	end
	
end

function CLASS:OnSpawn( ply )
	
	ply:SetPos( table.Random( CU_Spawnpoints ) );
	
	umsg.Start( "SetStartTime", ply );
	umsg.End();
	ply.StartTime = CurTime();
	
	ply:ResetCameraPos();
	ply:SetNoDraw( false );
	
	umsg.Start( "FrozenOverlayOff", ply ); umsg.End();
	
	umsg.Start( "ResetVars", ply );
	umsg.End();
	
	ply.Falling = false;
	
	for _, v in pairs( ply.SpawnRemoveEnts ) do
		
		if( v and v:IsValid() ) then
			
			v:Remove();
			
		end
		
	end
	
	ply.SpawnRemoveEnts = { };
	
	function ply.BuildBonePositions() end
	
end

function GM:PlayerInitialSpawn( ply )
	
	ply:SetNWInt( "BestTime", 900 );
	ply:SetNWInt( "NextSpeech", 0 );
	ply.SpawnRemoveEnts = { };
	
	self.BaseClass:PlayerInitialSpawn( ply );
	
end

function GM:GetFallDamage( ply, flFallSpeed ) -- no fall damage
	return 0;
end

function GM:PlayerSpray() -- no cheating
	return true;
end

function CLASS:OnDeath( ply, attacker, dmginfo )
	
	if( dmginfo:IsDamageType( DMG_SLASH ) or attacker:GetClass() == "trigger_cube_acid" or attacker:GetClass() == "func_door" or attacker:GetClass() == "func_door_rotating" or attacker:GetClass() == "func_movelinear" ) then
		
		ply:GibDeath();
		return;
		
	elseif( dmginfo:IsDamageType( DMG_CRUSH ) ) then
		
		ply:CrushDeath();
		return;
		
	elseif( dmginfo:IsDamageType( DMG_BURN ) or attacker:GetClass() == "cube_flashflame" ) then
		
		ply:BurnDeath();
		return;
		
	elseif( attacker:GetClass() == "cube_flashfreeze" ) then
		
		ply:FreezeDeath();
		return;
		
	elseif( dmginfo:IsDamageType( DMG_ENERGYBEAM ) ) then
		
		ply:DissolveDeath();
		return;
		
	elseif( dmginfo:IsDamageType( DMG_CLUB ) ) then
		
		ply:DecapitateDeath();
		return;
		
	elseif( dmginfo:IsDamageType( DMG_BLAST ) ) then
		
		ply:ExplodeDeath();
		return;
		
	end
	
	for color, cubes in pairs( CUBESHIFT ) do
		
		if( attacker:GetClass() == "trigger_cube_" .. color .. "shift" ) then
			
			ply:GibDeath();
			return;
			
		end
		
	end
	
	ply:CreateRagdoll();
	
end

function CLASS:Think( ply )
end

function CLASS:Move( pl, mv )
end

function CLASS:OnKeyPress( pl, key )
end

function CLASS:OnKeyRelease( pl, key )
end

function CLASS:ShouldDrawLocalPlayer( pl )
	
	if( CamOverridePos and !ImFalling ) then return true end
	
	return false;
	
end

function CLASS:CalcView( ply, origin, angles, fov )
	
	if( CamOverridePos and CamOverrideAng ) then
		
		CamCurPos = LerpVector( math.Clamp( FrameTime(), .005, math.huge ) * 4, CamCurPos, CamOverridePos );
		CamCurAng = LerpAngle( math.Clamp( FrameTime(), .005, math.huge ) * 4, CamCurAng, CamOverrideAng ); -- snazzy glide
		
		return { origin = CamCurPos, angles = CamCurAng, fov = fov };
		
	else
		
		CamCurPos = origin;
		CamCurAng = angles;
		
	end
	
end

player_class.Register( "Default", CLASS );

function GM:ShouldCollide( ent1, ent2 )
	
	if( ent1:IsPlayer() and ent2:IsPlayer() ) then
		
		return false;
		
	end
	
	return true;
	
end
