/*游戏中拥有攻击性的物体的基类*/
class AAUDKAweGame_Aggressive extends Actor;

//再次触发伤害的时间
var() float InvulnerableTime;

//接触之后改变速率的倍数，负数则后退
var() float MoveVelocityMultiple;


//用来保存已经造成过伤害的物体
var array<Actor> LateDamageActor;

//改变接触之后反应(回弹之类的)
function SetActorVelocity(Actor TakeDamageActor,out Vector out_momentum)
{

}

//判断是否可以造成伤害 (短时间内只能造成一次伤害)
function bool IsCanTakeDamageAgain(Actor HitActor)
{
    local int i;
    //检测是否最近已经造成过伤害
    for(i = 0 ; i < LateDamageActor.length ; i ++)
    {
        if(LateDamageActor[i] == HitActor)
            return false;
    }
    LateDamageActor[LateDamageActor.length] = HitActor;
    SetTimer(InvulnerableTime,false,'EndAcotrInvulnerable');
    return true;
}

//将最近造成伤害的Actor取消，以便再次触发伤害
function EndAcotrInvulnerable()
{
    LateDamageActor.Remove(0, 1);
}

defaultproperties
{
    InvulnerableTime=0
    MoveVelocityMultiple=0
}