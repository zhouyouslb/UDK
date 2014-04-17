Class AAUDKAweGame_Properties extends Object;

enum DamageBreakRes
{
	Res_A,
	Res_B,
	Res_C,
	Res_D
};

enum DamageFallRes
{
	Res_A,
	Res_B,
	Res_C,
	Res_D
};


var(res) int m_DamageBreakHit[4];
var(res) int m_DamageFallHit[4];
//硬直减少率
var(res) float m_ReduceCriP;
//击飞减少
var(res) float m_ReduceFallP;
//打断减少
var(res) float m_ReduceBreakP;

var(PawnName) AAUDKAweGame_Monster OwnerPawn;
var(PawnName) name MonsterPropertiesName;

var(ability) int m_MaxHP;
var(ability) int m_ATK;
var(ability) int m_MAGIC;
var(ability) int m_DEF;
var(ability) int m_MAC;
var(ability) float m_Special;
var(ability) int m_Lv;
var(ability) DamageBreakRes m_DamageBreakRes;
var(ability) DamageFallRes m_DamageFallRes;


var int CurHP;

//速度类
var(speed) float MaxRunSpeed;
//MaxRunSpeed * SpeedRate
var float CurRunSpeed;
var float SpeedRate;

//攻击速度默认为1
var(speed) float AtkSpeed;
var float AtkRate;

function InitForPawn()
{
	UpdataRunSpeed();
	UpdataAtkSpeed();
	OwnerPawn.HealthMax = m_MaxHP;
}

//设置速度(每次更新速率时都必须执行)
function UpdataRunSpeed()
{
	CurRunSpeed = MaxRunSpeed * SpeedRate;
	OwnerPawn.GroundSpeed = CurRunSpeed;
}

//设置速率
function AddRunSpeedRate(float AddOrSub)
{
	SpeedRate = SpeedRate + AddOrSub;
	UpdataRunSpeed();
}

function float UpdataAtkSpeed()
{
	AtkSpeed = AtkSpeed * AtkRate;
	return AtkSpeed;
}

defaultproperties
{

}