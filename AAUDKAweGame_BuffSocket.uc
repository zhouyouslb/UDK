class AAUDKAweGame_BuffSocket extends Actor;

var array<AAUDKAweGame_Buff> BuffArray;

var Pawn OwnerPawn;

function PostBeginPlay()
{
	
}

//增加一个BUFF,同类型同发出者，将会刷新该BUFF的时间而不是叠加(除非该技能允许叠加)
function AAUDKAweGame_Buff CreateBuff(class<AAUDKAweGame_Buff> BuffClassName,Pawn BuffSender)
{
    local int index;
    if(BuffClassName != none)
    {
        for(index = 0 ; index < BuffArray.length ; index ++)
        {
            if(BuffSender == BuffArray[index].BuffSender)
            {
                BuffArray[index].RefreshBuff();
                return BuffArray[index];
            }
        }
        return SpawnOneBuff(BuffClassName,BuffSender);
    }
}

function AAUDKAweGame_Buff SpawnOneBuff(class<AAUDKAweGame_Buff> BuffClassName,Pawn BuffSender)
{
    BuffArray[BuffArray.length] = spawn(BuffClassName);
	
    BuffArray[BuffArray.length].BuffSender = BuffSender;
    BuffArray[BuffArray.length].BuffOwner = Pawn(owner);
	BuffArray[BuffArray.length].BuffSocket = self;
	BuffArray[BuffArray.length].BuffInit(BuffSender,Pawn(owner),self);

	return BuffArray[BuffArray.length];
}

//刷新
function RefreshBuff(AAUDKAweGame_Buff buff)
{
    buff.NowTime = 0;
    buff.NextTime = buff.Interval;
    if(Buff.MaxLevel > Buff.NowLevel)
    {
        Buff.NowLevel++;
    }
}

//减少一个BUFF
function DelOneBuff(AAUDKAweGame_Buff buff)
{
    local int index;
    for(index = 0 ; index < BuffArray.length ; index ++)
    {
        if(BuffArray[index] == buff)
        {
            BuffArray.Remove(index, 1);
        }
    }
}

//清楚所有BUFF
function DelAllBuff()
{
    BuffArray.length = 0;
}

function InitOwner(Pawn ThisOwnerPawn)
{
	OwnerPawn = ThisOwnerPawn;
}



defaultproperties
{
	
}