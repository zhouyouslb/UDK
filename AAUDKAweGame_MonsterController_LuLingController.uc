class AAUDKAweGame_MonsterController_LuLingController extends AAUDKAweGame_MonsterController;

//¿ØÖÆ¹¥»÷×´Ì¬ÏÂµÄÆ¯¸¡Á¦
var int AttMometumTimeLimit;
var int PlusOrMinus;
var vector AttForward;
var vector AttStrafe;
var int AttMometumOffSet;

var vector vector1 ,vector2 ,vector3;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    `log("LuLing PostBeginPlay++++++++++++++++++++++++++=");
}

state GoToAttack
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
    }

	function Tick(float DeltaTime)
    {
		super.Tick(DeltaTime);
		WhatToDoNext();
		GetAxes(Pawn.Rotation,vector1,vector2,vector3);
		vector1.z = 0;
		Pawn.Velocity += vector1*500;
		AAUDKAweGame_Monster_LuLing(Pawn).SetSpeedRateByMoreOrLess(-0.2 * DeltaTime);
		//Pawn.TakeDamage(0,none,Pawn.Location,vector1 * 5000,class'UTDmgType_LinkPlasma');
    }

	function EndState(Name PreviousStateName)
    {
		super.EndState(PreviousStateName);
    }
}

state MoveHome
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
		Pawn.GroundSpeed *= 4;
    }

	function EndState(Name PreviousStateName)
    {
		super.EndState(PreviousStateName);
		Pawn.GroundSpeed /= 4;
    }
}


function Tick(float DeltaTime)
{
	
}


defaultproperties
{
    PawnAttSightRange=1000
	SpawnerSightRange=600
}