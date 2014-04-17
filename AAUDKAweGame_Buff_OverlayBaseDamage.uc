class AAUDKAweGame_Buff_OverlayBaseDamage extends AAUDKAweGame_Buff;

//到达界限会被击飞
var int BreakLimit;
var int CurBreak;

var int FallLimit;
var int CurFall;

//击飞力度
var vector FallMomentum;


auto state Activate
{
	function BeginState(Name PreviousStateName)
    {
		InitSelf();
		SetTimer(Interval,false,'OverlayDamage');	
    }
}

function InitSelf()
{
	CurFall+=GetFallVal();
	CurBreak+=GetBreakVal();
}

function RefreshBuff()
{
	ClearTimer('OverlayDamage');
	CurFall+=GetFallVal();
	CurBreak+=GetBreakVal();
	if(CurFall >= FallLimit)
		BuffOwner.TakeDamage(0,BuffSender.Controller,BuffOwner.Location,vect(0,0,500),class'UTDmgType_LinkPlasma');
	//if(CurBreak >= CurBreak)



}

function SetFallMomentum(vector Fall)
{
	FallMomentum = Fall;
}

function int GetBreakVal()
{
	return SenderPro.m_DamageBreakHit[SelfPro.m_DamageBreakRes];
}

function int GetFallVal()
{
	return SenderPro.m_DamageFallHit[SelfPro.m_DamageFallRes];
}

function OverlayDamage()
{
	
}

defaultproperties
{
	
}