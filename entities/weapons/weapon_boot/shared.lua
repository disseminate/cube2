SWEP.Author			= "Disseminate"
SWEP.Contact		= ""
SWEP.Purpose		= "It's a boot."
SWEP.Instructions	= "Primary Fire to throw. Use to pick up."
SWEP.Category		= "Cube"

SWEP.Base			= "weapon_base"
SWEP.HoldType		= "grenade"

SWEP.Spawnable		= false
SWEP.AdminSpawnable	= false

SWEP.ViewModel		= "models/weapons/v_boot.mdl"
SWEP.WorldModel		= "models/w_boot.mdl"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HasBoot = true;

function SWEP:Initialize() 
	
	self:SetWeaponHoldType( self.HoldType );
	
end

function SWEP:Precache()

	util.PrecacheModel( "models/weapons/v_boot.mdl" );
	util.PrecacheModel( "models/w_boot.mdl" );

end

function SWEP:RaiseBoot()
	
	self:SetWeaponHoldType( self.HoldType );
	
	if( SERVER ) then
		
		self:CallOnClient( "RaiseBoot", "" );
		
	end
	
end

function SWEP:LowerHand()
	
	self:SetWeaponHoldType( "normal" );
	
	if( SERVER ) then
		
		self:CallOnClient( "LowerHand", "" );
		
	end
	
end

function SWEP:PlayBootThrow()
	
	self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE );
	
	if( SERVER ) then
		
		self:CallOnClient( "PlayBootThrow", "" );
		
	end
	
end

function SWEP:Think()
	
	if( not self.Reloading and not self.HasBoot ) then
		
		if( SERVER ) then
			
			if( self.Owner.Boots > 0 ) then
				
				self.Owner.Boots = self.Owner.Boots - 1;
				self.HasBoot = true;
				self:SendWeaponAnim( ACT_VM_DRAW );
				self:SetNoDraw( false );
				
				self:RaiseBoot();
				
			else
				
				self:LowerHand();
				
			end
			
		end
		
	end

end

function SWEP:PrimaryAttack()
	
	if( SERVER ) then
		
		if( self.HasBoot ) then
			
			local vec = Vector( 0, 0, 8 );
			
			if( self.Owner:Crouching() ) then
				
				vec = Vector( 0, 0, 4 );
				
			end
			
			local boot = ents.Create( "cube_boot" );
			boot:SetPos( ( self.Owner:EyePos() - vec ) + ( self.Owner:GetForward() * 16 ) );
			boot:SetAngles( self.Owner:EyeAngles() );
			boot:Spawn();
			
			local bootphys = boot:GetPhysicsObject();
			bootphys:ApplyForceCenter( self.Owner:GetAimVector():GetNormalized() * 1600 );
			
			self.HasBoot = false;
			self.Reloading = true;
			self.Weapon:SendWeaponAnim( ACT_VM_THROW );
			self.Owner:ViewPunch( Angle( 5, 5, 5 ) );
			
			self:PlayBootThrow();
			
			umsg.Start( "DBC", self.Owner ); umsg.End();
			
			timer.Simple( 0.3, function()
				
				if( self and self:IsValid() ) then
					
					self.Reloading = false;
					
				end
				
				if( self and self:IsValid() and self.Owner and self.Owner.Boots > 0 ) then
					
					self.Owner.Boots = self.Owner.Boots - 1;
					self.HasBoot = true;
					self:SendWeaponAnim( ACT_VM_DRAW );
					self:SetNoDraw( false );
					
				else
					
					self:SetNoDraw( true );
					
				end
				
			end );
			
		end
		
	end
	
end
