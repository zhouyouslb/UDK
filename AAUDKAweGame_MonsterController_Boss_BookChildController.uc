class AAUDKAweGame_MonsterController_Boss_BookChildController extends AAUDKAweGame_MonsterController;

var AnimNodeSequence CurSeqNode;

state GoToAttack
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
		AAUDKAweGame_Monster_Boss_BookChild(Pawn).PlayMove();
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		if(CheckEnemyInAttSightRange())
			GotoState('AttackReady');
	}
}

state AttackReady
{
	function BeginState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster_Boss_BookChild(Pawn).PlayAttReady();
		AAUDKAweGame_Monster_Boss_BookChild(Pawn).ParticleEmitter.SetHidden(false);
		//Í£Ö¹ÒÆ¶¯
		StopMovement();
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
	}
}

state Attacking
{
	function BeginState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster_Boss_BookChild(Pawn).PlayAtt();
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		TraceAtt();
	}

	function EndState(Name PreviousStateName)
    {
		RemoveHitActors();
    }
}

function TraceAtt()
{
	local Actor HitActor;
	local Vector HitLoc, HitNorm, HitTip, HitHilt;
	//local int DamageAmount;

	HitTip = AAUDKAweGame_Monster_Boss_BookChild(Pawn).GetHitSocketLocation('att1');
	HitHilt = AAUDKAweGame_Monster_Boss_BookChild(Pawn).GetHitSocketLocation('att2');

	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, HitTip, HitHilt)
	{
		if (HitActor != self && AddToHitActors(HitActor))
		{
			if(AAUDKAweGame_Pawn(HitActor) != none)
				HitActor.TakeDamage(10, Instigator.Controller, HitLoc, vect(0,100,100), class'DamageType');
		}
	}
}



defaultproperties
{
	PawnAttSightRange=300
	AttSightRange=80
}