class AAUDKAweGame_PlayerController extends UTPlayerController;

var vector PlayerViewOffset;
var vector CurrentCameraLocation, DesiredCameraLocation;
var rotator CurrentCameraRotation;
var bool bViewSlowMove;
var AAUDKAweGame_NPCInterface ANI;
var AAUDKAweGame_ActorInterface AAI;
var AAUDKAweGame_SkillSocket ASS;

state PlayerWalking
{/*
    function ProcessMove( float DeltaTime, vector newAccel,eDoubleClickDir DoubleClickMove, rotator DeltaRot)
    {
        //控制移动根据摄像机位置
        local vector X, Y, Z, AltAccel;
        GetAxes(CurrentCameraRotation, X, Y, Z);
        AltAccel = PlayerInput.aForward * Z + PlayerInput.aStrafe * Y;
        AltAccel.Z = 0;
        //AltAccel.x = 0;
        AltAccel = Pawn.AccelRate * Normal(AltAccel);

        //改变玩家前进面向(要成功修改，需要修改GetPlayerViewPoint)
        //AAI.SetPlayerForward(self);

        super.ProcessMove(DeltaTime, AltAccel, DoubleClickMove,DeltaRot);
    }
    //控制玩家行走
    function PlayerMove( float DeltaTime )
    {
        super.PlayerMove(DeltaTime);
    }*/
	function PlayerMove(float DeltaTime)
	{
		if(!AAUDKAweGame_Game(WorldInfo.Game).Feature)
			super.PlayerMove(DeltaTime);
	}
}

state UseSkill
{
    function BeginState(Name PreviousStateName)
    {

    }

    function EndState(Name PreviousStateName)
    {

    }
}

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
    bNoCrosshair = true;
    //AAI = spawn(class'AwesomeActorInterface', self,, Location);
    ANI = spawn(class'AAUDKAweGame_NPCInterface', self,, Location);
    ASS = spawn(class'AAUDKAweGame_SkillSocket', self,, Location);
}

/*************         镜头相关         *************/
function PlayerTick(float DeltaTime)
{
    super.PlayerTick(DeltaTime);
    if(Pawn != none)
    {
        //DesiredCameraLocation = Pawn.Location + (PlayerViewOffset >> Pawn.Rotation);
        CurrentCameraLocation += (DesiredCameraLocation - CurrentCameraLocation) * DeltaTime * 6;
    }
}



simulated event GetPlayerViewPoint(out vector out_Location, out Rotator out_Rotation)
{
    super.GetPlayerViewPoint(out_Location, out_Rotation);
    
    return;
}

//设置玩家视角移动面向
function SetPlayerForward()
{
    if(PlayerInput.aForward != 0.f)
    {
        if( PlayerInput.aForward > 0.f)
        {

            if( PlayerInput.aStrafe > 0.f )
                Pawn.SetRotation(rot(0,8192,0));
            else if(PlayerInput.aStrafe < 0.f)
                Pawn.SetRotation(rot(0,-8192,0));
            else
                Pawn.SetRotation(rot(0,0,0));
        }
        if( PlayerInput.aForward < 0.f )
        {
            if( PlayerInput.aStrafe > 0.f )
                Pawn.SetRotation(rot(0,24576,0));
            else if( PlayerInput.aStrafe < 0.f )
                Pawn.SetRotation(rot(0,-24576,0));
            else
                Pawn.SetRotation(rot(0,32768,0));
        }
    }
    else
    {
        if(PlayerInput.aStrafe > 0.f)
            Pawn.SetRotation(rot(0,16384,0));
        else if(PlayerInput.aStrafe < 0.f)
            Pawn.SetRotation(rot(0,-16384,0));
    }
    SetRotation(Pawn.Rotation);
}

/************* 攻击相关 *************/

exec function StartFire( optional byte FireModeNum )
{
    super.StartFire(FireModeNum);
    if(Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none)
    {
        Pawn.SetHidden(false);
        SetTimer(1, false, 'MakeMeInvisible');
    }
}

//默认按"K"调用技能
exec function Sprint()
{
    //测试
    if(ASS.MyPlayerSkill.length == 0)
        ASS.AddSkill(Pawn,'AAUDKAweGame_Skill_Sprint',Class'AAUDKAweGame_Skill_Sprint');
    //测试
    if(AAUDKAweGame_Pawn(Pawn) != none && ASS.IsHaveThisSkill('AAUDKAweGame_Skill_Sprint'))
    {
        GotoState('UseSkill');
        //根据返回的值来启动这个技能
        ASS.ActivatedSkill('AAUDKAweGame_Skill_Sprint');
    }


}
/*
//改变返回值来达到修改开火方向只会向前
function Rotator GetAdjustedAimFor( Weapon W, vector StartFireLoc)
{
    return Pawn.Rotation;
}*/

function NotifyChangedWeapon(Weapon PrevWeapon, Weapon NewWeapon)
{
    super.NotifyChangedWeapon(PrevWeapon, NewWeapon);
   /* NewWeapon.SetHidden(true);

    if(Pawn == none)
        return;
    if(UTWeap_RocketLauncher(NewWeapon) != none)
        Pawn.SetHidden(true);
    else
        Pawn.SetHidden(false);*/
}

function MakeMeInvisible()
{
    if(Pawn != none && UTWeap_RocketLauncher(Pawn.Weapon) != none)
        Pawn.SetHidden(true);
}

/**************   HUD相关  *************/

reliable client function ClientSetHUD(class<HUD> newHUDType)
{
    super.ClientSetHUD(newHUDType);
}

/**************   人物控制  *************/
function SetLockPawn(bool IsLock)
{
	if(IsLock)
	{
		Pawn.SetPhysics(PHYS_None);
	}
	else
	{
		Pawn.SetPhysics(PHYS_Walking);
	}
}

/*********** 声音相关 ****************/
function PlayAnnouncement(class<UTLocalMessage> InMessageClass, int MessageIndex, optional PlayerReplicationInfo PRI, optional Object OptionalObject)
{
	return;
}
defaultproperties
{
    //PlayerViewOffset=(X=-500,Y=0,Z=500)
    PlayerViewOffset=(X=-200,Y=30,Z=40)

}