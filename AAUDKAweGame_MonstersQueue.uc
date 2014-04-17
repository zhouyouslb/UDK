//该类控制怪生产器如何刷新以及消亡状态
//可以继承该类，对怪物死亡事件进行编辑特殊处理
class AAUDKAweGame_MonstersQueue extends Actor;

struct MonsterInfoArray
{
    //该结构体在MonsterBase中
    var array<MonsterInfo_A> MonsterInfo;
    var int Num;
    var int Match;
    var bool bHaveSpawned;
};

//场景拥有的怪物生产期
var array<AAUDKAweGame_MonsterSpawner>  OccupyEnemySpawners;

//怪物实际存在的数量
var array<MonsterInfoArray> MonsterArray;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}


function GetOccupyEnemySpawners()
{
    local AAUDKAweGame_MonsterSpawner AMS;

    foreach DynamicActors(class'AAUDKAweGame_MonsterSpawner', AMS)
    {
        //储存生产器
        OccupyEnemySpawners[OccupyEnemySpawners.length] = AMS;
        `log("AMS" @ AMS);
        //关联怪物控制组
        AMS.MonstersQueue = self;
    }
}

function bool IsHaveOccupyEnemySpawners()
{
    if(OccupyEnemySpawners.length <= 0)
        return false;
    return true;
}

function ClearQueue()
{
	OccupyEnemySpawners.length = 0;
}

//开始产生怪物
//参数：Match 第几组怪物 
function StartSpawn(int Match)
{
    local int i;
    for(i = 0 ; i < OccupyEnemySpawners.length ; i ++)
    {
        `log("OccupyEnemySpawners[i]" @ OccupyEnemySpawners[i]);
        if(OccupyEnemySpawners[i].Match == Match)
        {
            OccupyEnemySpawners[i].SpawnEnemy();
        }
    }
}
/*
function AwesomeMonstersQueue SetQueueOccupy(AwesomeMonsterSpawner Spawner)
{
    local int i;
    for(i = 0 ; i < OccupyEnemySpawners.length ; i++)
    {
        if(OccupyEnemySpawners[i] == Spawner)
            return none;
    }
    //将怪物生产器储存至怪物管理队列
    OccupyEnemySpawners[OccupyEnemySpawners.length] = Spawner;
    return self;
}*/


//增加一个怪物
function AddOneMonster(int Match,MonsterInfo_A MInfo)
{
    local bool bIsNewMatchMonster;
    local MonsterInfoArray TempMonsterInfoArray;
    local int i;

    //`log("Add a Monster! this team" @ Match);
    bIsNewMatchMonster = true;
    if(MInfo.MonsterName == '')
    {
        `log("The monster have not a name");
        return;
    }


    //检测该组的怪物
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        if(Match == MonsterArray[i].Match)
        {
            //将已有的组的怪物的值保存，组里的怪物数+1
            MonsterArray[i].MonsterInfo[MonsterArray[i].MonsterInfo.length] = MInfo;
            MonsterArray[i].Num++;
            bIsNewMatchMonster = false;
        }
    }

	//怪物为新的一组，而不是加入到原有组中
    if(bIsNewMatchMonster)
    {
        //将没有的组的怪物的值保存
        TempMonsterInfoArray.MonsterInfo[TempMonsterInfoArray.MonsterInfo.length] = MInfo;
        TempMonsterInfoArray.Match = Match;
        TempMonsterInfoArray.Num = 1;
        MonsterArray[MonsterArray.length] = TempMonsterInfoArray;
        i = MonsterArray.length -1;
    }
    
    //检测事件
    CheckEvent("add",i,Match,MInfo);

    //MonsterArray[MonsterArray.length].MonsterInfo[MonsterArray[MonsterArray.length].MonsterInfo.length] = MInfo;
    //MonsterArray[MonsterArray.length].Match = Match;
    //MonsterArray[MonsterArray.length].Num = 1;
    /*
    //test
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        `log("Match & Num" @ MonsterArray[i].Match @ MonsterArray[i].Num);
        for(x = 0 ; x < MonsterArray[i].MonsterInfo.length ; x ++)
        {
            `log(MonsterArray[i].MonsterInfo[x].MonsterName);
            `log(MonsterArray[i].MonsterInfo[x].Match);
        }
    }*/
}

//减少一个怪物
function bool MinusOneMonster(int Match,MonsterInfo_A MInfo)
{
    local int i;
    for(i = 0 ; i < MonsterArray.length ; i ++)
    {
        if(Match == MonsterArray[i].Match)
        {
            //检测事件
            CheckEvent("sub",i,Match,MInfo);
            MonsterArray[i].Num--;
            if(MonsterArray[i].Num < 0)
                return false;
            return true;
        }
    }
    return false;
}

//配合游戏类(gameinfo)，控制(怪物)事件发生
//例如，开门，刷出宝物
/* EventCode 怪物增加时间还是减少事件
 * WhichIndexMonster 怪物属于哪一组
 * Match 匹配的事件
 * MInfo 怪物属性
 */
function CheckEvent(string EventCode,optional int WhichIndexMonster,optional int Match,optional MonsterInfo_A MInfo)
{
    //游戏流程设置
    if(EventCode == "sub")
    {//num为减1之后
		//意思为当WhichIndexMonster组的怪物最后一个怪物死亡时，开启Match事件
        if(MonsterArray[WhichIndexMonster].Num - 1 == 0)
        {
			`log("AAUDKAweGame_Game(WorldInfo.Game).DiedAllMonster(Match);");
			AAUDKAweGame_Game(WorldInfo.Game).DiedAllMonster(Match);
        }
    }
/*
    if(EventCode == "add")
    {//num为+1之后
        `log("wwwwaaaaaa" @ WhichIndexMonster);
        `log("wwwwaaaaaa" @ MonsterArray.length);
        if(MonsterArray[WhichIndexMonster].Num == 1 && Match == 1 && MonsterArray[WhichIndexMonster].bHaveSpawned == false)
        {
            MonsterArray[WhichIndexMonster].bHaveSpawned = true;
            if(AwesomeGameBase(WorldInfo.Game) != none)
                AwesomeGameBase(WorldInfo.Game).OpenWhichDoor(Match);
        }
    }*/
}

defaultproperties
{

}

