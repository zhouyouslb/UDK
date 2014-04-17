class AAUDKAweGame_Game extends  UTGame;

var int NextWaveTime;

var int SpawnersMatching[10];

//几号门应该被打开(这个值用在kismet中)
var int IndexDoorJustBeOpen;

var int CurMonsterMatch;

//怪物控制
var AAUDKAweGame_MonstersQueue MonstersQueue;

//为true时，无视playerController的镜头重写，以调用另外一个相机
var bool Feature;

var AAUDKAweGame_PlayerController MyPC;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
	//`log("11111111111111111111111111111111");
    MonstersQueue = spawn(class'AAUDKAweGame_MonstersQueue',self,, Location);
}

/************ 流程控制 ************/
function RestartPlayer(Controller aPlayer)
{
	 if(PlayerController(aPlayer) != none)
    {
        //显示屏幕字幕
        SetTimer(0,false,'ShowDialog');
    }
    super.RestartPlayer(aPlayer);
}

function InitMonstersQueue()
{
	if(MonstersQueue.IsHaveOccupyEnemySpawners() == false)
	{
        MonstersQueue.GetOccupyEnemySpawners();
    }
	else
	{
		MonstersQueue.ClearQueue();
		MonstersQueue.GetOccupyEnemySpawners();
	}
}

function Actor GetMonstersQueue()
{
    return MonstersQueue;
}

//显示屏幕字幕
function ShowDialog()
{
    Broadcast(self,"welcome to the game,start spawn monster");
}

//开始刷怪
function StartSpawn(int matching)
{
    //local int i;
    MonstersQueue.StartSpawn(matching);
}

function int GetOpenDoorIndex()
{
    return IndexDoorJustBeOpen;
}

function DiedAllMonster(int matching)
{
	CurMonsterMatch = matching;
	TriggerGlobalEventClass(class'AAUDKAweGame_Game_SeqEvent_DiedAllMonster', self);

}

function OpenWhichDoor(int matching)
{
    //SpawnersMatching[matching]--;
    //`log("SpawnersMatching num === " @ SpawnersMatching[matching]);
    //if(SpawnersMatching[matching] == 0)
    //{
        IndexDoorJustBeOpen = matching;

        `log("OpenDoor");
        //开启门的事件
        TriggerGlobalEventClass(class'AAUDKAweGame_Game_SeqEvent_OpenDoor', self);

    //}
}

event PlayerController Login(string Portal, string Options, const UniqueNetID UniqueID, out string ErrorMessage)
{
	MyPC = AAUDKAweGame_PlayerController(super.Login(Portal,Options,UniqueID,ErrorMessage));	
	return MyPC;
}

/***************** 状态控制 ******************/

state MatchInProgress
{

}

defaultproperties
{
    PlayerControllerClass=class'AAUDKAweGame_Game.AAUDKAweGame_PlayerController'
    bScoreDeaths=false
    DefaultInventory(0)=None
    DefaultPawnClass=class'AAUDKAweGame_Game.AAUDKAweGame_Pawn'

    NextWaveTime=2
    
    Feature = false
}