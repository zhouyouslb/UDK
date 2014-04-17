class AAUDKAweGame_Buff extends Actor;



enum BHitType
{
    HT_physics,
    HT_Magic,
};

    //名称
    var name BuffName;
    //伤害类型
    var BHitType HitType;
    //每次每层伤害
    var float Damage;
    //支持最大层数
    var int MaxLevel;
    //当前层数
    var int NowLevel;
    //持续次数
    var float BuffTime;
    //当前时间
    var float NowTime;
    //下一次触发的时间(一般为触发的时间+间隔)
    var float NextTime;
    //间隔
    var float Interval;
    //技能强度
    var int BuffRank;

//属于哪个BUFF栏
var AAUDKAweGame_BuffSocket BuffSocket;

//属于谁
var Pawn BuffOwner;

//谁放出的
var Pawn BuffSender;

var AAUDKAweGame_Properties SenderPro;
var AAUDKAweGame_Properties SelfPro;



function BuffInit(Pawn Sender,Pawn tBuffOwner,AAUDKAweGame_BuffSocket Socket)
{
	BuffSender = Sender;
    BuffOwner = tBuffOwner;
	BuffSocket = Socket;

	if(AAUDKAweGame_Pawn(BuffSocket.OwnerPawn) != none)
		SelfPro = AAUDKAweGame_Pawn(BuffSocket.OwnerPawn).m_Pro;
	if(AAUDKAweGame_Monster(BuffSocket.OwnerPawn) != none)
		SelfPro = AAUDKAweGame_Monster(BuffSocket.OwnerPawn).m_MonsterProperties;

	if(AAUDKAweGame_Pawn(BuffSender) != none)
		SenderPro = AAUDKAweGame_Pawn(BuffSender).m_Pro;
	if(AAUDKAweGame_Monster(BuffSender) != none)
		SenderPro = AAUDKAweGame_Monster(BuffSender).m_MonsterProperties;		
}

function RefreshBuff()
{

}


defaultproperties
{

}