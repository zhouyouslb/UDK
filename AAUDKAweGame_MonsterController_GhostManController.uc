class AAUDKAweGame_MonsterController_GhostManController extends AAUDKAweGame_MonsterController;

var AnimNodeSequence CurSeqNode;

var vector HitAimLocation;
var rotator HitAimRotation;

var AAUDKAweGame_Monster_Other_GhostManBox MyBox;

var bool bHasBoxState;



state GoToAttack
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
		AAUDKAweGame_Monster_GhostMan(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster_GhostMan(Pawn).MoveAnimNodeName,
			AAUDKAweGame_Monster_GhostMan(Pawn).m_MonsterProperties.AtkSpeed,,,true,true,false);
		if(!bHasBoxState)
		{
			GoToState('FindBox');
		}
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		if(CheckEnemyInAttSightRange())
		{
			GotoState('AttackReady');
		}
	}

	function EndState(Name PreviousStateName)
    {
		super.EndState(PreviousStateName);
    }
}

state AttackReady
{
	function BeginState(Name PreviousStateName)
    {
		//停止移动
		StopMovement();
		
		//攻击准备动画
		AAUDKAweGame_Monster_GhostMan(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster_GhostMan(Pawn).AtkReadyAnimNodeName,
			AAUDKAweGame_Monster_GhostMan(Pawn).m_MonsterProperties.AtkSpeed,,,false,true,true);
		
		HitAimLocation = Enemy.Location;
		HitAimRotation = rotator(Enemy.Location - Pawn.Location);
		Pawn.SetDesiredRotation(HitAimRotation,true);
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		//Pawn.SetDesiredRotation(rot(0,0,0));
	}

	function EndState(Name PreviousStateName)
    {
		if(Pawn != none)
			Pawn.LockDesiredRotation(false);
    }
}

state Attacking
{
	function BeginState(Name PreviousStateName)
    {
		Pawn.SetDesiredRotation(HitAimRotation,true);
		AAUDKAweGame_Monster_GhostMan(Pawn).PlayMonsterAnim(AAUDKAweGame_Monster_GhostMan(Pawn).AtkAnimNodeName,
			AAUDKAweGame_Monster_GhostMan(Pawn).m_MonsterProperties.AtkSpeed,,,false,true,true);
		//设置箱子隐藏
		AAUDKAweGame_Monster_GhostMan(Pawn).SetBoxHidden(true);

        MyBox = spawn(class'AAUDKAweGame_Monster_Other_GhostManBox', self,, AAUDKAweGame_Monster_GhostMan(Pawn).GetHitSocketLocation('ManHand'));
		//往前丢
        MyBox.Init( (vect(100,0,0) >> Pawn.Rotation)/200);
		
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
	}

	function EndState(Name PreviousStateName)
    {
		if(Pawn != none)
			Pawn.LockDesiredRotation(false);
		//RemoveHitActors();
    }
}

state FindBox
{
	function BeginState(Name PreviousStateName)
    {

    }
	function WhatToDoNext()
	{
		GoToState('FindBox','Begin');
	}
Begin:
	TargetA = MyBox;
	NavigationHandle.SetFinalDestination(TargetA.Location);
	if(GeneratePathToA(TargetA) && NavigationHandle.GetNextMoveLocation( tempLocation, Pawn.GetCollisionRadius()))
	{
		Moveto(tempLocation);
	}
	else
		MoveToward(TargetA);
	WhatToDoNext();
}


state MoveHome
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
		Pawn.LockDesiredRotation(false);
    }
}

function TakeTheBox()
{
	MyBox.Destroy();
	AAUDKAweGame_Monster_GhostMan(Pawn).SetBoxHidden(false);
	GotoState('GotoAttack');
}

//重写该函数，使此怪不会脱离战斗
function SetTheMonsterOutFight()
{

}

defaultproperties
{
	PawnAttSightRange=500
	AttSightRange=400
	bHasBoxState=true	
}