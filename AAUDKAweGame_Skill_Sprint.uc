class AAUDKAweGame_Skill_Sprint extends AAUDKAweGame_Skill;
/*突进技能*/
//释放技能前进的距离方向
var vector SkillStart,SkillAim,SkillCurrent;
var float Distance , TempDistance , OldGroundSpeed;

//在Controller中的tick中调用
function bool IsUseSkill()
{
    if(bSkillBreak)
        return false;
}

function UseSkill()
{
    local vector X,Y,Z;
    GetAxes(SkillOwner.Rotation,X,Y,Z);
    //设置起点
    SkillStart = SkillOwner.Location;
    //设置终点,Distance是前进的距离
    SkillAim = SkillOwner.Location + X * Distance;

    TempDistance = Distance;

    GotoState('BeActivate');

    OldGroundSpeed = Pawn(SkillOwner).GroundSpeed;

    Pawn(SkillOwner).GroundSpeed *= 4;

    SkillOwner.Acceleration = vect(0,0,0);

    SetTimer(1, false, 'EndSkill');
}

function EndSkill()
{
    bSkillBreak=true;
}

auto state NoActivate
{
    function BeginState(Name PreviousStateName)
    {

    }

    function EndState(Name PreviousStateName)
    {

    }
}

state BeActivate
{
    function BeginState(Name PreviousStateName)
    {
        `log("sprint BeActivate ");
        bSkillBreak=false;
		`log(PlayerController(SkillOwner.Owner).IsKeyboardAvailable() @ "dfhkjsdhfsjk");
		PlayerController(SkillOwner.Owner).SetControllerTiltActive(false);
    } 

    function Tick(float DeltaTime)
    {
        local vector X,Y,Z;
        if(Pawn(SkillOwner) == none  || bSkillBreak )//|| SkillOwner.Physics != PHYS_Walking)
        {
            bSkillBreak=true;
            GotoState('NoActivate');
            return;
        }
        GetAxes(SkillOwner.Rotation, X, Y, Z);

        SkillOwner.velocity = (SkillAim - SkillStart) + X *700;

        if( Distance <= (VSize(SkillOwner.Location - SkillStart)))
        {
            GotoState('NoActivate');
            return;
        }
    }

    function EndState(Name PreviousStateName)
    {
        `log("sprint end");
        bSkillBreak=false;
        Controller(SkillOwner.owner).GotoState('PlayerWalking');
        Pawn(SkillOwner).GroundSpeed = OldGroundSpeed;
    }
}

defaultproperties
{
    bSkillBreak=false
    Distance=500.0
}