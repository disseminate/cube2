include( "shared.lua" );
include( "chat.lua" );
include( "endgame.lua" );
include( "fade.lua" );
include( "finish.lua" );
include( "gib.lua" );
include( "shift.lua" );
include( "view.lua" );
include( "miclimit.lua" );

AddCSLuaFile( "cl_init.lua" );
AddCSLuaFile( "shared.lua" );
AddCSLuaFile( "cl_hud.lua" );
AddCSLuaFile( "cl_help.lua" );
AddCSLuaFile( "cl_gib.lua" );
AddCSLuaFile( "cl_effects.lua" );

game.ConsoleCommand( "net_maxfilesize 64\n" );

resource.AddFile( "maps/" .. game.GetMap() .. ".bsp" );

resource.AddFile( "sound/cube/click.wav" );
resource.AddFile( "sound/cube/icecrack.wav" );

resource.AddFile( "models/weapons/v_Boot.mdl" );
resource.AddFile( "models/w_Boot.mdl" );
resource.AddFile( "materials/Shoe001a.vmt" );
resource.AddFile( "materials/v_boot_sheet.vmt" );

resource.AddFile( "models/cube/sonicdish.mdl" );
resource.AddFile( "materials/cube/ice_overlay.vmt" );

resource.AddFile( "materials/cube/metalwall_exit.vmt" );
resource.AddFile( "materials/cube/outerwall.vmt" );
resource.AddFile( "materials/cube/outerwall_normal.vtf" );
resource.AddFile( "materials/cube/tunnelwall_blank.vmt" );
resource.AddFile( "materials/cube/tunnelwall_numb.vmt" );
resource.AddFile( "materials/cube/tunnelwall_prime.vmt" );
resource.AddFile( "materials/cube/wall_blue.vmt" );
resource.AddFile( "materials/cube/wall_green.vmt" );
resource.AddFile( "materials/cube/wall_red.vmt" );
resource.AddFile( "materials/cube/wall_white.vmt" );

CU_Spawnpoints = { };

CreateConVar( "c2_classic", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY } )

function GM:EndOfGame( bGamemodeVote )
	
	if( GetConVar( "c2_classic" ):GetInt() == 1 ) then return end -- disseminate edit
	
	if GAMEMODE.IsEndOfGame then return end
	
	GAMEMODE.IsEndOfGame = true
	SetGlobalBool( "IsEndOfGame", true );
	
	GAMEMODE:OnEndOfGame();
	
	if ( bGamemodeVote ) then
	
		MsgN( "Starting gamemode voting..." )
		PrintMessage( HUD_PRINTTALK, "Starting gamemode voting..." );
		timer.Simple( GAMEMODE.VotingDelay, function() GAMEMODE:StartGamemodeVote() end )
		
	end

end

function GM:GetTimeLimit()

	if( GetConVar( "c2_classic" ):GetInt() == 0 ) then
		return GAMEMODE.GameLength * 60;
	end
	
	return -1;
	
end