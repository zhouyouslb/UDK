class AAUDKAweGame_Monster_BookChildr extends AAUDKAweGame_Monster;

var name AtkReadyAnimNodeName;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
	AddBeamEmitter('BookSocket');
	//AttParticle = Spawn(class'AwesomeBookChildAttParticle',self);
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	super.PostInitAnimTree(SkelComp);

	if (SkelComp == Mesh)
	{
		CustomAnim = AnimNodePlayCustomAnim(SkelComp.FindAnimNode('BookChildAnim'));
	}
}

//站立
function PlayStand()
{
	CustomAnim.PlayCustomAnim('Book_Child_Stand',1,,,true,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
}

//行走
function PlayMove()
{
	CustomAnim.PlayCustomAnim('Book_Child_Walk',1,,,true,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
}

//受伤
function PlayDamage()
{
	CustomAnim.PlayCustomAnim('Book_Child_Damage01',1,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//死亡
function PlayDeath()
{
	CustomAnim.PlayCustomAnim('Book_Child_death02',1,,100,false,false);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//攻击准备
function PlayAttReady()
{
	CustomAnim.PlayCustomAnim('01',1,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
}

//攻击
function PlayAtt()
{
	CustomAnim.PlayCustomAnim('02',1,,,false,true);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = true;
	
}


simulated event OnAnimEnd(AnimNodeSequence SeqNode,float PlayedTime,float ExcessTime)
{
	if(SeqNode.AnimSeqName == '01')
	{
		if(Owner != none)
			Owner.GotoState('Attacking');
	}
	else if(SeqNode.AnimSeqName == '02')
	{
		if(Owner != none)
			Owner.GotoState('GotoAttack');
	}
}

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
vector Momentum, class<DamageType> DamageType,optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
}

defaultproperties
{
    ThisMonsterName="BookChildMonster"

	bBlockActors=true
	bCollideActors=true

    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment1
        bEnabled=TRUE
    End Object
    Components.Add(MyLightEnvironment1)

    //整体的网格
    Begin Object Class=SkeletalMeshComponent Name=BookChildSkeMesh
        SkeletalMesh=SkeletalMesh'Awe_Monster.skemesh.Book_Child_Attack01'
		CollideActors=true
		BlockZeroExtent=true
		Translation=(z=-32)
        LightEnvironment=MyLightEnvironment1
		AnimTreeTemplate=AnimTree'Awe_Monster.Anim.Book_Child'
		AnimSets(0)=AnimSet'Awe_Monster.2_gu'
    End Object
	Mesh=BookChildSkeMesh
    Components.Add(BookChildSkeMesh)
    

    Begin Object Class=CylinderComponent Name=BookChildCollisionCylinder
        CollisionRadius=24.0
        CollisionHeight=32.0
        //BlockNonZeroExtent=false
        //BlockZeroExtent=false
        //BlockActors=true
        //CollideActors=true
        //HiddenGame=false
    End Object
	CollisionComponent=BookChildCollisionCylinder
	CylinderComponent=CollisionCylinder
    Components.Add(BookChildCollisionCylinder)

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
	
	NPCController=class'AAUDKAweGame_MonsterController_BookChildController'

	Acceleration=(X=0,Y=0,Z=0)

	//动画节点名字
	StandAnimNodeName="Book_Child_Stand"
	MoveAnimNodeName="Book_Child_Walk"
	AtkAnimNodeName="02"
	AtkReadyAnimNodeName="01"
	DamageAnimNodeName="Book_Child_Damage01"
	DeathAnimNodeName="Book_Child_death02"
}