class AAUDKAweGame_MonsterSpawner extends Actor
    placeable;

//产生的怪物
var AAUDKAweGame_Monster MySpawnedEnemy;

//怪物队列控制组
var AAUDKAweGame_MonstersQueue MonstersQueue;


//怪物属于哪个组
var() int Match;

var() class<AAUDKAweGame_Monster> AwesomeMonsterBaseClass;

//怪物的原型
var() const archetype AAUDKAweGame_Monster AwesomeMonsterArchetype;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}

//产生一个怪物
function SpawnEnemy()
{
	local rotator aa;
    //如果怪物为空
    if(MySpawnedEnemy == none)
    {
		//随机一个方向
		aa.Yaw = Rand(32768);
		SetRotation(aa);
        //产生一个怪物
		if(AwesomeMonsterArchetype != none)
		{
			MySpawnedEnemy = spawn(AwesomeMonsterArchetype.Class,,, Location);
		}
		else
		{
			MySpawnedEnemy = spawn(AwesomeMonsterBaseClass,,, Location);
		}

        //设置怪怪物的队组
        MySpawnedEnemy.MonsterInfo.Match = Match;


        //设置怪物的产生者
        MySpawnedEnemy.SetMyMonsterSpawner(self);

        //设置控制组怪物的数量+1
        MonstersQueue.AddOneMonster(MySpawnedEnemy.MonsterInfo.Match,MySpawnedEnemy.MonsterInfo);
    }
    else
        `log("MySpawnedEnemy" @ MySpawnedEnemy);
}



function EnemyDied()
{

    //向游戏控制类发送是第几组怪减少
    MonstersQueue.MinusOneMonster(MySpawnedEnemy.MonsterInfo.Match,MySpawnedEnemy.MonsterInfo);
    
    MySpawnedEnemy = none;
  //  SpawnEnemy();
}

function AAUDKAweGame_Monster SpawnBoss()
{
    //local AwesomeBoss TheBoss;
    //TheBoss = spawn(class'AwesomeBoss', self,, Location);
    //return TheBoss;
}

function MakeEnemyRunAway()
{
    //if(MySpawnedEnemy != none)
        //MySpawnedEnemy.RunAway();
}

function bool CanSpawnEnemy()
{
    return MySpawnedEnemy == none;
}

defaultproperties
{
    Begin Object Class=SpriteComponent Name=Sprite
        Sprite=Texture2D'EditorResources.S_NavP'
        HiddenGame=True
    End Object
    Components.Add(Sprite)
    
    bHidden=false
    
    AwesomeMonsterBaseClass=class'AAUDKAweGame_Monster';
    
}