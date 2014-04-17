class AAUDKAweGame_Buff_stun extends AAUDKAweGame_Buff;

function PostBeginPlay()
{
    //local Pawn Pa;
    BuffName = 'stun';
    HitType = HT_Magic;
    Damage = 10;
    BuffTime = 15;
    Interval = 3;
    BuffRank = 5;

}

defaultproperties
{

}