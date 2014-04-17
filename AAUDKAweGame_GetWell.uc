class AAUDKAweGame_GetWell extends Actor
    placeable;

var bool bActivate;

var Pawn TempPawn;

var() bool bSetFeature;
// 保存了光束粒子发射体
var ParticleSystemComponent ParticleEmitter;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();
}


event Bump(Actor Other, PrimitiveComponent OtherComp, vector
HitNormal)
{
    if(Pawn(Other) != none && bActivate)
    {
        `log("Health Get Well");
        bActivate = false;
        Pawn(Other).Health = Pawn(Other).HealthMax;
        ParticleEmitter.SetHidden(true);
        //设置角色无敌一段时间
        TempPawn = Pawn(Other);
        Pawn(Other).Controller.bGodMode = true;
        //4秒无敌
        SetTimer(4,false,'EndTheGodMode');
        
        //触发KISMET信号
        TriggerGlobalEventClass(class'AAUDKAweGame_GetWell_SeqEvent', self);
    }
    super.Bump(Other,OtherComp,HitNormal);
}

function EndTheGodMode()
{
    TempPawn.Controller.bGodMode = false;
}

function SetActivate()
{
    ParticleEmitter.SetHidden(false);
    bActivate = true;
}
defaultproperties
{
   

    bBlockActors=True
    bCollideActors=True

    Begin Object Class=StaticMeshComponent Name=Navi
		StaticMesh=StaticMesh'Pickups.WeaponBase.S_Pickups_WeaponBase'
		Scale3D=(X=1.0,Y=1.0,Z=1.0)
	End Object
	Components.Add(Navi)

	Begin Object Class=CylinderComponent Name=CollisionCylinder
                CollisionRadius=32.0
                CollisionHeight=1.0
                BlockNonZeroExtent=true
                BlockZeroExtent=true
                BlockActors=true
                CollideActors=true
    End Object
    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)

    Begin Object Class=ParticleSystemComponent Name=haha
        Template=ParticleSystem'Castle_Assets.FX.P_FX_Fire_SubUV_01'
    End Object
    ParticleEmitter=haha
    Components.Add(haha);
   
	bActivate=true
    
    //ParticleTemplate=ParticleSystem'CTF_Flag_IronGuard.Effects.P_CTF_Flag_IronGuard_Spawn_Red'
}