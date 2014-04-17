class AAUDKAweGame_ActorInterface extends Actor;


//获取pawn面向的Actor
function Actor GetFaceActor(Pawn P , optional float TraceLen)
{
    local Vector X,Y,Z,HitLocation,StartLocation, HitNormal ,EndLocation;
    local Actor AimActor;
    GetAxes(P.Rotation,X,Y,Z);
    if(TraceLen == 0)
        EndLocation = P.Location +(X * 200);
    else
        EndLocation = P.Location +(X * TraceLen);
    StartLocation = P.Location;
    //检测面前（默认前方200的范围内的Actor）
    AimActor = Trace(HitLocation,HitNormal,StartLocation,EndLocation,true);
    if(AimActor != P)
        return AimActor;
    else
        return none;
}

//交换两个Actor的坐标
function SwapLocation(Actor A,Actor B)
{
    local Vector x;
    x = A.Location;
    A.SetLocation(B.Location);
    B.SetLocation(x);
}


//在ProcessMove中设置游戏中行动面向根据键盘方向（暂时不用管）
//(必须重写PlayerController的GetPlayerViewPoint函数才可使用（out_Location = Pawn.Location + PlayerViewOffset;）)
function SetPlayerForward(PlayerController PC)
{
    if(PC.PlayerInput.aForward != 0.f)
    {
        if( PC.PlayerInput.aForward > 0.f)
        {
            if( PC.PlayerInput.aStrafe > 0.f )
                PC.Pawn.SetRotation(rot(0,8192,0));
            else if(PC.PlayerInput.aStrafe < 0.f)
                PC.Pawn.SetRotation(rot(0,-8192,0));
            else
                PC.Pawn.SetRotation(rot(0,0,0));
        }
        if( PC.PlayerInput.aForward < 0.f )
        {
            if( PC.PlayerInput.aStrafe > 0.f )
                PC.Pawn.SetRotation(rot(0,24576,0));
            else if( PC.PlayerInput.aStrafe < 0.f )
                PC.Pawn.SetRotation(rot(0,-24576,0));
            else
                PC.Pawn.SetRotation(rot(0,32768,0));
        }
    }
    else
    {
        if(PC.PlayerInput.aStrafe > 0.f)
            PC.Pawn.SetRotation(rot(0,16384,0));
        else if(PC.PlayerInput.aStrafe < 0.f)
            PC.Pawn.SetRotation(rot(0,-16384,0));
    }
    PC.SetRotation(PC.Pawn.Rotation);
}


defaultproperties
{

}