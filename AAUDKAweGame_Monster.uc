class AAUDKAweGame_Monster extends UDKPawn
    placeable;

var float BumpDamage;
var Pawn Enemy;
var float AttackDistance;
var float MovementSpeed;
var bool bAttacking;

//速度控制(需要赋值给GroudSpeed等)
var float SpeedRate;
var float LatendGroundSpeed;

//AI的控制类
var class<AIController> NPCController;

//储存这个怪物的生成器
var AAUDKAweGame_MonsterSpawner MyMonsterSpawner;

var Material SeekingMat, AttackingMat, FleeingMat;

//怪物受伤害
var bool bCanTakeDamage;
var bool bTakeDamaging;
var bool bDied;

//自定义动画节点
var AnimNodePlayCustomAnim CustomAnim;
var AnimNodeSequence CurSeqNode;
//节点动画name
var name StandAnimNodeName;
var name MoveAnimNodeName;
var name AtkAnimNodeName;
var name DamageAnimNodeName;
var name DeathAnimNodeName;

var AAUDKAweGame_BuffSocket BuffSocket;


// 光束粒子系统模板
var particleSystem ParticleTemplate;
// 保存了光束粒子发射体
var ParticleSystemComponent ParticleEmitter;

//属性类原型
var() const archetype AAUDKAweGame_MonsterProperties PropertiesArchetype;
var() AAUDKAweGame_MonsterProperties m_MonsterProperties;

var name ThisMonsterName;
struct MonsterInfo_A
{
    var int Match;
    var name MonsterName;
};

var MonsterInfo_A MonsterInfo;


/*************************** 初始化和关联 **************************/

simulated event PostBeginPlay()
{
    //给怪物的名字赋值
    MonsterInfo.MonsterName = ThisMonsterName;
    if(NPCController != none)
    {
        //set the existing ControllerClass to our new NPCController class
        //Controller = Spawn(class'UDNBot', self);
        ControllerClass = NPCController;
    }
    Super.PostBeginPlay();
    //关联Controller
    if(Controller == none)
    {
        Controller = Spawn(ControllerClass);
        Controller.Possess(self,false);
		`log("Controller@@@@@@@HHHHHHHHHHHHHHHHHHHHHHHHHH" @ Controller.Pawn);
    }

	if(!ConnectMonsterProperties())
		`log("Connect Monster Properties false PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");

	InitBuffSocket();
}

function InitBuffSocket()
{
	BuffSocket = Spawn(Class'AAUDKAweGame_BuffSocket');
	BuffSocket.InitOwner(self);
}

//连接怪物属性
function bool ConnectMonsterProperties()
{
	if(PropertiesArchetype != none)
	{
		m_MonsterProperties = new(Outer) PropertiesArchetype.Class;
		m_MonsterProperties.OwnerPawn = self;
		m_MonsterProperties.InitForPawn();
		`log("GroudSpeed" @ GroundSpeed);
		return true;
	}
	return false;
}


function SetMyMonsterSpawner(AAUDKAweGame_MonsterSpawner MonsterSpawner)
{
    MyMonsterSpawner = MonsterSpawner;
}

/*************************** takedamage **************************/

event TakeDamage(int DamageAmount,Controller EventInstigator,vector HitLocation,
vector Momentum, class<DamageType> DamageType,optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local Controller Killer;
    //super.TakeDamage(DamageAmount,EventInstigator,HitLocation,Momentum,DamageType,HitInfo,DamageCauser);
	

	Health -= DamageAmount;

	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
	{
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	}
	momentum = momentum/Mass;

	if ( Health <= 0 )
	{
		// pawn died
		Killer = SetKillInstigator(EventInstigator, DamageType);
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		HandleMomentum( momentum, HitLocation, DamageType, HitInfo );
	}

	//当前正在受到伤害
	bTakeDamaging=true;
	SetTimer(1,false,'TakeDamageEnd');

	if(CheckThisActionIsBreak())
	{
		if(GetStateName() != 'Dying' && bDied == false)
		{
			`log("PlayDamage");
			if(CustomAnim != none && m_MonsterProperties != none)
				PlayMonsterAnim(DamageAnimNodeName,m_MonsterProperties.AtkSpeed,,,false,true,true);
		}
	}
	else
	{
		//暂停动画
		PauseAnim();
	}

	if(Owner != none)
	{
		if(Owner.GetStateName() == 'Standing' || Owner.GetStateName() == 'Hover')
		{
			Owner.GotoState('GoToAttack');
		}
	}
	SetPhysics(PHYS_None);
}

function TakeDamageEnd()
{
	bTakeDamaging=false;
}

function SendBuffToTargetPawn(Actor TargetPawn,class<AAUDKAweGame_Buff> buff,AAUDKAweGame_Properties MyPro)
{
	if(AAUDKAweGame_Pawn(TargetPawn) != none)
		AAUDKAweGame_Pawn(TargetPawn).BuffSocket.CreateBuff(buff,self);
	if(AAUDKAweGame_Monster(TargetPawn) != none)
		AAUDKAweGame_Monster(TargetPawn).BuffSocket.CreateBuff(buff,self);
}

//获取插槽的坐标
function Vector GetHitSocketLocation(Name SocketName)
{
	local Vector SocketLocation;
	local Rotator SwordRotation;
	local SkeletalMeshComponent SMC;

	SMC = Mesh;

	if (SMC != none && SMC.GetSocketByName(SocketName) != none)
	{
		SMC.GetSocketWorldLocationAndRotation(SocketName, SocketLocation, SwordRotation);
	}

	return SocketLocation;
}

/*************************** 速度控制 ***************************/

//设置移动速度比率的增加和减少
function SetSpeedRateByMoreOrLess(float add)
{
	if(SpeedRate < 0)
		return;
	SpeedRate+=add;
	UpdateGroundSpeed();
}

//设置移动速度最大值
function SetLatendGroundSpeed(float Speed)
{
	if(Speed < 0)
		return;
	LatendGroundSpeed = Speed;
	UpdateGroundSpeed();
}

//更新当前移动速度
function UpdateGroundSpeed()
{
	GroundSpeed = LatendGroundSpeed * SpeedRate;
}

event Tick(float DeltaTime)
{
	//被攻击则暂停一下
	if(bTakeDamaging)
	{
		velocity = vect(0,0,0);
	}
}


/*************************** 播放动画 *******************************/

//暂停动画
function PauseAnim()
{
	Mesh.bPauseAnims = true;
	SetTimer(1,false,'ContinuePlayAnim');
}

//继续动画
function ContinuePlayAnim()
{
	Mesh.bPauseAnims = false;
	//CurSeqNode.PlayAnim(CurSeqNode.bLooping,1,CurSeqNode.CurrentTime);
}

//播放动画
function PlayMonsterAnim(name AnimNodeName,float AnimRate ,
	optional	float	BlendInTime,
	optional	float	BlendOutTime,
	optional	bool	bLooping,
	optional	bool	bOverride,
	optional bool bIsCauseActorAnimEnd = false)
{
	if(AnimNodeName == '' || CustomAnim == none)
		return;
	CustomAnim.PlayCustomAnim(AnimNodeName,AnimRate,BlendInTime,BlendOutTime,bLooping,bOverride);
	CurSeqNode = CustomAnim.GetCustomAnimNodeSeq();
	CurSeqNode.bCauseActorAnimEnd = bIsCauseActorAnimEnd;
}
/*
//站立
function PlayStand()
{
	
}

//行走
function PlayMove()
{
	
}

//受伤
function PlayDamage()
{
	
}

//死亡
function PlayDeath()
{
	
}

//攻击准备
function PlayAttReady()
{

}

//攻击
function PlayAtt()
{

}*/

simulated event OnAnimEnd(AnimNodeSequence SeqNode,float PlayedTime,float ExcessTime)
{
	
}

function bool CheckThisActionIsBreak()
{
	return true;
}

/*****************************************************/

state Dying
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);

		MyMonsterSpawner.EnemyDied();

		//播放死亡动画
		if(CustomAnim != none && m_MonsterProperties != none)
		{
			if(DeathAnimNodeName != '')
				PlayMonsterAnim(DeathAnimNodeName,m_MonsterProperties.AtkSpeed,,100,false,false,true);
		}
	}
}
/*********************** 添加粒子特效 **********************/

function AddBeamEmitter(name socket)
{
	if(ParticleTemplate != None)
	{
        ParticleEmitter = new(Outer) class'UTParticleSystemComponent';
        ParticleEmitter.bUpdateComponentInTick = true;
        ParticleEmitter.SetTemplate(ParticleTemplate);

		ParticleEmitter.SetDepthPriorityGroup(SDPG_World );
		ParticleEmitter.SetTickGroup( TG_PostUpdateWork );

		Mesh.AttachComponentToSocket( ParticleEmitter,socket);

		//BeamEmitter.ActivateSystem();
		ParticleEmitter.SetVectorParameter('LinkBeamEnd',vect(0,0,0));
		ParticleEmitter.SetHidden(true);
	}
}

defaultproperties
{
	bCanBeBaseForPawns=true
/*
    Begin Object Class=DynamicLightEnvironmentComponent Name=MyLightEnvironment
		bSynthesizeSHLight=true
		bIsCharacterLightEnvironment=true
		bUseBooleanEnvironmentShadowing=false
	End Object
	Components.Add(MyLightEnvironment)*/
	//LightEnvironment=MyLightEnvironment
/*
    Begin Object Class=StaticMeshComponent Name=EnemyMesh
      StaticMesh=StaticMesh'UN_SimpleMeshes.TexPropCube_Dup'
      //Materials(0)=Material'EditorMaterials.WidgetMaterial_X'
      LightEnvironment=MyLightEnvironment
      Scale3D=(X=0.25,Y=0.25,Z=0.5)
    End Object
    Components.Add(EnemyMesh)
    MyMesh=EnemyMesh*/

    BumpDamage=5.0
    AttackDistance=96.0
    //MovementSpeed=256.0;
/*
    SeekingMat=Material'EditorMaterials.WidgetMaterial_X'
    AttackingMat=Material'EditorMaterials.WidgetMaterial_Z'
    FleeingMat=Material'EditorMaterials.WidgetMaterial_Y'*/

    NPCController=class'AAUDKAweGame_MonsterController'
    
    bDied=false
    ThisMonsterName="fangkuai"
    
    bBlockActors=True
    bCollideActors=True
    //MonsterInfo.MonsterName="fangkuai"

	bCanTakeDamage=true

	SpeedRate=1
	LatendGroundSpeed=100

	DamageAnimNodeName="fdfdfdf"

	DeathAnimNodeName=""

	PropertiesArchetype=AAUDKAweGame_MonsterProperties'Awe_Monster.MonsterPro.BasePro'
}