class AAUDKAweGame_Monster_LuLing extends AAUDKAweGame_Monster;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    `log(ThisMonsterName @ "!%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
    SetLatendGroundSpeed(512);
}


defaultproperties
{
    ThisMonsterName="LuLing"

	bBlockActors=True
    bCollideActors=True

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment1
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment1)

    //整体的网格
    Begin Object Class=SkeletalMeshComponent Name=LuLingSkeMesh
        SkeletalMesh=SkeletalMesh'Awe_Monster.skemesh.LuLing'
        Scale3D=(X=0.5,Y=0.5,Z=0.5)
		Translation=(z=16)
		CollideActors=true
		BlockZeroExtent=true
        LightEnvironment=MyLightEnvironment1
    End Object
    Components.Add(LuLingSkeMesh)
	Mesh=LuLingSkeMesh
    BaseSkelComponent=LuLingSkeMesh

    Begin Object Class=CylinderComponent Name=LuLingCollisionCylinder
        CollisionRadius=32.0
        CollisionHeight=64.0
        //BlockNonZeroExtent=true
        BlockZeroExtent=false
        BlockActors=true
        CollideActors=true
        HiddenGame=true
    End Object
    Components.Add(LuLingCollisionCylinder)
    CollisionComponent=LuLingCollisionCylinder

    //RotationRate=(Pitch=20000,Yaw=20000,Roll=20000)
    //Flags
    bCanBeDamaged=true
	bCanCrouch=false
	bCanFly=false
	bCanJump=true
	bCanSwim=false
	bCanTeleport=false
	bCanWalk=true
	bJumpCapable=false
	bProjTarget=false
	bSimulateGravity=true
	bShouldBaseAtStartup=true
	
	NPCController=class'AAUDKAweGame_MonsterController_LuLingController'

	Acceleration=(X=0,Y=0,Z=0)

}