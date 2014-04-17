class AAUDKAweGame_MonsterController_BookChildController extends AAUDKAweGame_MonsterController;

var AnimNodeSequence CurSeqNode;

state GoToAttack
{
	function BeginState(Name PreviousStateName)
    {
		super.BeginState(PreviousStateName);
		AAUDKAweGame_Monster_BookChildr(Pawn).PlayMove();
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
		AAUDKAweGame_Monster_BookChildr(Pawn).PlayAttReady();
		AAUDKAweGame_Monster_BookChildr(Pawn).ParticleEmitter.SetHidden(false);
		//Í£Ö¹ÒÆ¶¯
		StopMovement();
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
	}

	function EndState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster_BookChildr(Pawn).ParticleEmitter.SetHidden(true);
    }
}

state Attacking
{
	function BeginState(Name PreviousStateName)
    {
		AAUDKAweGame_Monster_BookChildr(Pawn).PlayAtt();
		AAUDKAweGame_Monster_BookChildr(Pawn).ParticleEmitter.SetHidden(false);
    }

	function Tick(float DeltaTime)
	{
		super.Tick(DeltaTime);
		TraceAtt();
	}

	function EndState(Name PreviousStateName)
    {
		RemoveHitActors();
		AAUDKAweGame_Monster_BookChildr(Pawn).ParticleEmitter.SetHidden(true);
    }
}

function TraceAtt()
{
	local Actor HitActor;
	local Vector HitLoc, HitNorm, HitTip, HitHilt;
	//local int DamageAmount;

	HitTip = AAUDKAweGame_Monster_BookChildr(Pawn).GetHitSocketLocation('att1');
	HitHilt = AAUDKAweGame_Monster_BookChildr(Pawn).GetHitSocketLocation('att2');
	foreach TraceActors(class'Actor', HitActor, HitLoc, HitNorm, HitTip, HitHilt)
	{
		if (HitActor != self && AddToHitActors(HitActor))
		{
			if(AAUDKAweGame_Pawn(HitActor) != none)
			{
				SendDamage(HitActor,self,HitLoc,vect(0,100,100), class'DamageType');
				//HitActor.TakeDamage(20, Instigator.Controller, HitLoc, , class'DamageType');
			}
		}
	}
}



defaultproperties
{
	PawnAttSightRange=300
	AttSightRange=50
}