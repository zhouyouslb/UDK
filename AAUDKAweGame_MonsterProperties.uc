class AAUDKAweGame_MonsterProperties extends AAUDKAweGame_Properties;

var(ability) int m_CardRarity;
var(ability) int m_ItemRarity1;
var(ability) int m_ItemRarity2;

var float SeedValue;

var int GoldDrop;
var float CardDropP;
var int OriginalDrop;
var float SpecialItemDropP1;
var float SpecialItemDropP2;

var(Test) array<Actor> Test;

var int m_EXP;

//掉落的特殊道具
//var(item) array<AwesomeSpecialItem> m_SpecialItems;
//掉落的素材道具
//var(item) array<AwesomeOriginalItem> m_OriginalItems;
//掉落的技能符卡
//var(item) array<AwesoemSpecialItem> m_SpecialItem;



/*     几率计算，须要按顺序执行    */
//设置并获取种值
function float GetSeedValue()
{
	SeedValue = sqrt(FMax(m_ATK,m_MAGIC)) * m_MaxHP * (1 + (m_DEF+m_MAC)/2) * m_Special * 3;
	`log("SeedValue =" @ SeedValue);
	return SeedValue;
}
//金钱
function int GetGoldDrop()
{
	// 0 ~ SeedValue*0.0001*(15 + m_Lv)
	GoldDrop = SeedValue*0.0001*(15 + m_Lv) - Rand(SeedValue*0.0001*(15 + m_Lv));
	`log("GoldDrop =" @ GoldDrop);
	return GoldDrop;
}
//素材
function int GetOriginalDrop()
{
	// 0 ~ GoldDrop * 10
	OriginalDrop = (GoldDrop * 10) - Rand(GoldDrop * 10);
	`log("OriginalDrop =" @ OriginalDrop);
	return OriginalDrop;
}

//符卡
function bool GetCardDrop()
{
	CardDropP = (1/m_CardRarity * SeedValue/300000) * (15 + m_Lv);
	`log("CardDropP = " @ CardDropP);
	return FRand() <= CardDropP;
}

//特殊物品1
function bool GetSpecialItemDropP1()
{
	SpecialItemDropP1 = (1 / m_ItemRarity1 * SeedValue/3000) * (15 + m_Lv);
	`log("SpecialItemDropP1 = " @ SpecialItemDropP1);
	return FRand() <= SpecialItemDropP1;
}

//特殊物品2
function bool GetSpecialItemDropP2()
{
	SpecialItemDropP2 = (1 / m_ItemRarity2 * SeedValue/3000) * (15 + m_Lv);
	`log("SpecialItemDropP2 = " @ SpecialItemDropP2);
	return FRand() <= SpecialItemDropP2;
}

//经验
function int GetExp()
{
	m_EXP = SeedValue * (15 + m_Lv)^3 / 100000;
	`log("m_EXP = " @ m_EXP);
	return m_EXP;
}

defaultproperties
{
	AtkSpeed=1.0
	AtkRate=1.0
	SpeedRate=1.0
	MaxRunSpeed=300
	m_DamageBreakHit(0)=0
	m_DamageBreakHit(1)=10
	m_DamageBreakHit(2)=20
	m_DamageBreakHit(3)=30
	

}