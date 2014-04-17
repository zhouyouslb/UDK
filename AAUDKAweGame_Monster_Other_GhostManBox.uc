class AAUDKAweGame_Monster_Other_GhostManBox extends UTProjectile;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	RandSpin(100000);
}

function Init(vector Direction)
{
	SetRotation(Rotator(Direction));

	Velocity = Speed * Direction;
	TossZ = TossZ + (FRand() * TossZ / 2.0) - (TossZ / 4.0);
	Velocity.Z += TossZ;
	Acceleration = AccelRate * Normal(Velocity);
}

simulated function Timer()
{
	//Explode(Location, vect(0,0,1));
}

simulated event HitWall(vector HitNormal, Actor Wall, PrimitiveComponent WallComp)
{
	bBlockedByInstigator = true;

	if ( WorldInfo.NetMode != NM_DedicatedServer )
	{
		PlaySound(ImpactSound, true);
	}

	// check to make sure we didn't hit a pawn

	if ( Pawn(Wall) == none )
	{
		Velocity = 0.75*(( Velocity dot HitNormal ) * HitNormal * -2.0 + Velocity);   // Reflect off Wall w/damping
		Speed = VSize(Velocity);

		if (Velocity.Z > 400)
		{
			Velocity.Z = 0.5 * (400 + Velocity.Z);
		}

		if ( Speed < 40 || Pawn(Wall) != none )
		{
			ImpactedActor = Wall;
			SetPhysics(PHYS_None);
		}
	}
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
	Destroy();
}

simulated function ProcessTouch(Actor Other, Vector HitLocation, Vector HitNormal)
{
	if(AAUDKAweGame_Pawn(Other) != none)
	{
		Other.TakeDamage(Damage,InstigatorController,HitLocation,MomentumTransfer * Normal(Velocity), MyDamageType,, self);
	}

	//ÉèÖÃ»Øµ¯
	Velocity = 0.75*(( Velocity dot HitNormal ) * HitNormal * -2.0 + Velocity);   // Reflect off Wall w/damping
	Speed = VSize(Velocity);
	if (Velocity.Z > 400)
	{
		Velocity.Z = 0.5 * (400 + Velocity.Z);
	}
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	if(Physics != PHYS_None)
		super.Touch(Other,OtherComp,HitLocation,HitNormal);
	if(Other != Controller(Owner).Pawn)
		`log("Box Touch");
}

simulated function Shutdown()
{
	`log("Shutdown");
}



/**
 * When a grenade enters the water, kill effects/velocity and let it sink
 */
simulated function PhysicsVolumeChange( PhysicsVolume NewVolume )
{
	if ( WaterVolume(NewVolume) != none )
	{
		Velocity *= 0.25;
	}

	Super.PhysicsVolumeChange(NewVolume);
}

defaultproperties
{
	bCollideActors=true

	Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment1
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment1)

	Begin Object Class=SkeletalMeshComponent Name=BoxSkeMesh
		SkeletalMesh=SkeletalMesh'Awe_Monster.skemesh.Dpy_Cargo_Box_Fbx'
		LightEnvironment=MyLightEnvironment1
		Scale3D=(X=0.5,Y=0.5,Z=0.5)
		CollideActors=true
	End Object
	Components.Add(BoxSkeMesh)
	//Mesh=BoxSkeMesh
	
	Begin Object Class=CylinderComponent Name=CollisionCylinder1
		CollisionRadius=20
		CollisionHeight=20
		BlockActors=true
        CollideActors=true
	End Object
	CollisionComponent=CollisionCylinder1
	CylinderComponent=CollisionCylinder1
	//ZeroColliderComponent=CollisionCylinder1
	Components.Add(CollisionCylinder1)

	speed=700
	MaxSpeed=1000.0
	Damage=20.0
	bCollideWorld=true
	bBounce=true
	TossZ=+160.0
	Physics=PHYS_Falling
	bSwitchToZeroCollision=false
	LifeSpan=0.0


	ExplosionSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_Impact_Cue'
	ExplosionDecal=MaterialInstanceTimeVarying'WP_RocketLauncher.Decals.MITV_WP_RocketLauncher_Impact_Decal01'
	ImpactSound=SoundCue'A_Weapon_RocketLauncher.Cue.A_Weapon_RL_GrenadeFloor_Cue'



}