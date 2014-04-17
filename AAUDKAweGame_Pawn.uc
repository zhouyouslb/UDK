class AAUDKAweGame_Pawn extends UTPawn;

var bool bInvulnerable;
var float InvulnerableTime;
//记录谁最近造成过伤害的
var array<Actor> LateDamageName;

var Actor TempLateDamageName;

var AAUDKAweGame_BuffSocket BuffSocket;

var AAUDKAweGame_Player_Properties m_Pro;

var Bool IsGod;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    if(ArmsMesh[0] != none)
        ArmsMesh[0].SetHidden(true);
    if(ArmsMesh[1] != none)
        ArmsMesh[1].SetHidden(true);

	InitBuffSocket();
}

function InitBuffSocket()
{
	BuffSocket = Spawn(Class'AAUDKAweGame_BuffSocket');
	BuffSocket.InitOwner(self);
}

function SendBuffToTargetPawn(Actor TargetPawn,class<AAUDKAweGame_Buff> buff,AAUDKAweGame_Properties MyPro)
{
	if(AAUDKAweGame_Pawn(TargetPawn) != none)
		AAUDKAweGame_Pawn(TargetPawn).BuffSocket.CreateBuff(buff,self);
	if(AAUDKAweGame_Monster(TargetPawn) != none)
		AAUDKAweGame_Monster(TargetPawn).BuffSocket.CreateBuff(buff,self);
}


event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
vector Momentum, class<DamageType> DamageType,optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}


//设置第三人称视角s
simulated function bool CalcCamera( float fDeltaTime, out vector out_CamLoc, out rotator out_CamRot, out float out_FOV )
{
   local vector CamStart, HitLocation, HitNormal, CamDirX, CamDirY, CamDirZ, CurrentCamOffset;
   local float DesiredCameraZOffset;

   CamStart = Location;
   CurrentCamOffset = CamOffset;


   DesiredCameraZOffset = (Health > 0) ? 1.2 * GetCollisionHeight() + Mesh.Translation.Z : 0.f;
   CameraZOffset = (fDeltaTime < 0.2) ? DesiredCameraZOffset * 5 * fDeltaTime + (1 - 5*fDeltaTime) * CameraZOffset : DesiredCameraZOffset;
   
   if ( Health <= 0 )
   {
      CurrentCamOffset = vect(0,0,0);
      CurrentCamOffset.X = GetCollisionRadius();
   }

   CamStart.Z += CameraZOffset;
   GetAxes(out_CamRot, CamDirX, CamDirY, CamDirZ);
   CamDirX *= CurrentCameraScale;

   if ( (Health <= 0) || bFeigningDeath )
   {
      // 调整相机位置，确保它没有剪切到世界中
      // @todo fixmesteve.  注意：如果 FindSpot 失败，您仍然可以获得剪切（很少发生）
      FindSpot(GetCollisionExtent(),CamStart);
   }
   if (CurrentCameraScale < CameraScale)
   {
      CurrentCameraScale = FMin(CameraScale, CurrentCameraScale + 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
   }
   else if (CurrentCameraScale > CameraScale)
   {
      CurrentCameraScale = FMax(CameraScale, CurrentCameraScale - 5 * FMax(CameraScale - CurrentCameraScale, 0.3)*fDeltaTime);
   }

   if (CamDirX.Z > GetCollisionHeight())
   {
      CamDirX *= square(cos(out_CamRot.Pitch * 0.0000958738)); // 0.0000958738 = 2*PI/65536
   }

   out_CamLoc = CamStart - CamDirX*CurrentCamOffset.X + CurrentCamOffset.Y*CamDirY + CurrentCamOffset.Z*CamDirZ;

   if (Trace(HitLocation, HitNormal, out_CamLoc, CamStart, false, vect(12,12,12)) != None)
   {
      out_CamLoc = HitLocation;
   }

   return true;
}


simulated function SetMeshVisibility(bool bVisible)
{
    //super.SetMeshVisibility(bVisible);
    Mesh.SetOwnerNoSee(false);
}

event Bump(Actor Other, PrimitiveComponent OtherComp, vector
HitNormal)
{
   /* if(AwesomeEnemy(Other) != none && !bInvulnerable)
    {
        bInvulnerable = true;
        SetTimer(InvulnerableTime, false, 'EndInvulnerable');
        TakeDamage(AwesomeEnemy(Other).BumpDamage, none, Location ,
        vect(0,0,0),class'UTDmgType_LinkPlasma');
    }*/
}

//设置角色是否无敌
function SetGod(bool Is)
{
    IsGod=True;
}

function Tick(float DeltaTime)
{
}

defaultproperties
{
    InvulnerableTime=0.6

    CamOffset=(X=25,Y=50,Z=-13)
    JumpZ=+600
    //GroundSpeed=600

	IsGod=false
/*
	Begin Object Name=WPawnSkeletalMeshComponent
		bCacheAnimSequenceNodes=FALSE
		AlwaysLoadOnClient=true
		AlwaysLoadOnServer=true
		bOwnerNoSee=true
		CastShadow=true
		BlockRigidBody=TRUE
		bUpdateSkelWhenNotRendered=false
		bIgnoreControllersWhenNotRendered=TRUE
		bUpdateKinematicBonesFromAnimation=true
		bCastDynamicShadow=true
		Translation=(Z=8.0)
		RBChannel=RBCC_Untitled3
		RBCollideWithChannels=(Untitled3=true)
		LightEnvironment=MyLightEnvironment
		bOverrideAttachmentOwnerVisibility=true
		bAcceptsDynamicDecals=FALSE
		AnimTreeTemplate=AnimTree'CH_AnimHuman_Tree.AT_CH_Human'
		bHasPhysicsAssetInstance=true
		TickGroup=TG_PreAsyncWork
		MinDistFactorForKinematicUpdate=0.2
		bChartDistanceFactor=true
		//bSkipAllUpdateWhenPhysicsAsleep=TRUE
		RBDominanceGroup=20
		Scale=1.075
		// Nice lighting for hair
		bUseOnePassLightingOnTranslucency=TRUE
		bPerBoneMotionBlur=true
	End Object
	Mesh=WPawnSkeletalMeshComponent
	Components.Add(WPawnSkeletalMeshComponent)*/
}