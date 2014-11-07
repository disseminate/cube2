
local Help = nil 
function GM:ShowHelp() -- sorry, but need to kill the timer

	if ( !IsValid( Help ) ) then
	
		Help = vgui.CreateFromTable( vgui_Splash )
		Help:SetHeaderText( GAMEMODE.Name or "Untitled Gamemode" )
		Help:SetHoverText( GAMEMODE.Help or "No Help Avaliable" );
		
		Help.lblFooterText.Think = function( panel ) 
										local tl = GAMEMODE:GetGameTimeLeft()
										if ( tl == -1 ) then return end
										if( GetGlobalBool( "IsEndOfGame", false ) ) then panel:SetText( "Game has ended..." ) return end
										if( GetConVar( "c2_classic" ):GetInt() == 1 ) then panel:SetText( "" ) return end -- diss edit
										panel:SetText( "Time Left: " .. string.ToMinutesSeconds( tl ) ) 
									end

		if ( GetConVarNumber( "fretta_voting" ) != 0 ) then
			local btn = Help:AddSelectButton( "Vote For Change", function() RunConsoleCommand( "voteforchange" ) end )
			btn.m_colBackground = Color( 255, 200, 100 )
			btn:SetDisabled( LocalPlayer():GetNWBool( "WantsVote" ) ) 
		end
		
		if ( LocalPlayer():Team() == TEAM_SPECTATOR ) then
		
			local btn = Help:AddSelectButton( "Join Game", function() RunConsoleCommand( "changeteam", TEAM_UNASSIGNED ) end )
			btn.m_colBackground = Color( 120, 255, 100 )
		
		else
	
			local btn = Help:AddSelectButton( "Spectate", function() RunConsoleCommand( "changeteam", TEAM_SPECTATOR ) end )
			btn.m_colBackground = Color( 200, 200, 200 )
			
		end
		
		Help:AddCancelButton()
		
		local function CreateModelPanel()
						
			local pnl = vgui.Create( "DGrid" )
		
			pnl:SetCols( 6 )
			pnl:SetColWide( 66 )
			pnl:SetRowHeight( 66 )
		
			for name, model in pairs( list.Get( "PlayerOptionsModel" ) ) do
				
				local icon = vgui.Create( "SpawnIcon" )
				icon.DoClick = function() surface.PlaySound( "ui/buttonclickrelease.wav" ) RunConsoleCommand( "cl_playermodel", name ) end
				icon.PaintOver = function() if ( GetConVarString( "cl_playermodel" ) == name ) then surface.SetDrawColor( Color( 255, 210 + math.sin(RealTime()*10)*40, 0 ) ) surface.DrawOutlinedRect( 4, 4, icon:GetWide()-8, icon:GetTall()-8 ) surface.DrawOutlinedRect( 3, 3, icon:GetWide()-6, icon:GetTall()-6 ) end end
				icon:SetModel( model )
				icon:SetSize( 64, 64 )
				icon:SetTooltip( name )
					
				pnl:AddItem( icon )
				
			end
			
			return pnl
			
		end
		
		Help:AddPanelButton( "gui/silkicons/user", "Choose Player Model", CreateModelPanel )
		
	end
	
	Help:MakePopup()
	Help:NoFadeIn()
	
end
