class AAUDKAweGame_Monster_GhostMan extends AAUDKAweGame_Monster;

//箱子
var SkeletalMeshComponent SkeBox;

var name AtkReadyAnimNodeName;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
	Mesh.AttachComponentToSocket( SkeBox,'ManHand');
	SetLatendGroundSpeed(256);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh)
	{
		CustomAnim = AnimNodePlayCustomAnim(SkelComp.FindAnimNode('GhostManAnim'));
		
	}
}

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
vector Momentum, class<DamageType> DamageType,optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}



//站立
function PlayStand()
{
	CustomAnim.PlayCustomAnim('man_001_still',1,,,true,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
}

//行走
function PlayMove()
{
	CustomAnim.PlayCustomAnim('man_001_walk',1,,,true,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
}

//受伤
function PlayDamage()
{
	CustomAnim.PlayCustomAnim('man_001_damage',0.3,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//死亡
function PlayDeath()
{
	CustomAnim.PlayCustomAnim('man_001_Died',1,,100,false,false);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//攻击准备
function PlayAttReady()
{
	CustomAnim.PlayCustomAnim('man_001_atk01',1,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//攻击
function PlayAtt()
{
	CustomAnim.PlayCustomAnim('man_001_atk02',1,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//显示或隐藏箱子
function SetBoxHidden(bool bBoxHidden)
{
	SkeBox.SetHidden(bBoxHidden);
	AAUDKAweGame_MonsterController_GhostManController(Owner).bHasBoxState = !bBoxHidden;
}

simulated event OnAnimEnd(AnimNodeSequence SeqNode,float PlayedTime,float ExcessTime)
{
	if(SeqNode.AnimSeqName == 'man_001_atk01')
	{
		Owner.GotoState('Attacking');
		//BeamEmitter.SetHidden(true);
	}
	else if(SeqNode.AnimSeqName == 'man_001_atk02')
	{
		Owner.GotoState('GotoAttack');
	}
	else if(SeqNode.AnimSeqName == 'man_001_damage')
	{
		PlayMove();
		Owner.GotoState('GotoAttack');
	}
}

//暂停动画
function PauseAnim()
{
	
	Mesh.bPauseAnims = true;
	SetTimer(1,false,'ContinuePlayAnim');
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, vector HitLocation, vector HitNormal)
{
	super.Touch(Other,OtherComp,HitLocation,HitNormal);
	if(Owner!= none && !AAUDKAweGame_MonsterController_GhostManController(Owner).bHasBoxState 
    && Owner.GetStateName() == 'FindBox' 
    && Other == AAUDKAweGame_MonsterController_GhostManController(Owner).MyBox)
	{
		AAUDKAweGame_MonsterController_GhostManController(Owner).TakeTheBox();
	}
}




defaultproperties
{
    ThisMonsterName="GhostManMonster"

	bBlockActors=true
	bCollideActors=true

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment1
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment1)

    //整体的网格
    Begin Object Class=SkeletalMeshComponent Name=GhostManSkeMesh
        SkeletalMesh=SkeletalMesh'Awe_Monster.skemesh.man_001_atk'
		CollideActors=true
		BlockZeroExtent=true
		Translation=(z=-32)
		Scale3D=(X=0.4,Y=0.4,Z=0.4)
        LightEnvironment=MyLightEnvironment1
		AnimTreeTemplate=AnimTree'Awe_Monster.Anim.Ghost_Man'
		AnimSets(0)=AnimSet'Awe_Monster.Bip001'
    End Object
	Mesh=GhostManSkeMesh
    Components.Add(GhostManSkeMesh)

	Begin Object Class=SkeletalMeshComponent Name=BoxSkeMesh
		SkeletalMesh=SkeletalMesh'Awe_Monster.skemesh.Dpy_Cargo_Box_Fbx'
		LightEnvironment=MyLightEnvironment1
	End Object
	SkeBox=BoxSkeMesh
    

    Begin Object Class=CylinderComponent Name=GhostManCollisionCylinder
        CollisionRadius=24.0
        CollisionHeight=32.0
        //BlockNonZeroExtent=false
        //BlockZeroExtent=false
        //BlockActors=true
        //CollideActors=true
        //HiddenGame=false
    End Object
	CollisionComponent=GhostManCollisionCylinder
	CylinderComponent=CollisionCylinder
    Components.Add(GhostManCollisionCylinder)

	//发射物材质
    ParticleTemplate=ParticleSystem'WP_ShockRifle.Particles.P_WP_ShockRifle_Ball'
    

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
	
	NPCController=class'AAUDKAweGame_MonsterController_GhostManController'

	Acceleration=(X=0,Y=0,Z=0)

	//动画节点名字
	StandAnimNodeName="man_001_still"
	MoveAnimNodeName="man_001_walk"
	AtkAnimNodeName="man_001_atk02"
	AtkReadyAnimNodeName="man_001_atk01"
	DamageAnimNodeName="man_001_damage"
	DeathAnimNodeName="man_001_Died"

}