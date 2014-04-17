class AAUDKAweGame_Buff_Poison extends AAUDKAweGame_Buff;

function PostBeginPlay()
{
    BuffName = 'Poison';
    HitType = HT_Magic;
    Damage = 10;
    BuffTime = 15;
    MaxLevel = 3;
    NowLevel = 1;
    Interval = 3;
    BuffRank = 5;
    NextTime = 3;
    NowTime = 0;
    
}

function Tick(float DeltaTime)
{
    //每次执行的时间计算
    NowTime += DeltaTime;
    if(BuffOwner != none && NowTime > NextTime)
    {
        NextTime+=Interval;
        BuffOwner.TakeDamage(Damage * NowLevel, none,Location,vect(0,0,0),class'UTDmgType_LinkPlasma');
    }
    //如果总时间超过，状态取消
    if(NowTime > BuffTime)
    {
        if(BuffSocket != none)
            BuffSocket.DelOneBuff(self);
        Destroy();
        return;
    }
}


defaultproperties
{

}