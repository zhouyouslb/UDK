class AAUDKAweGame_Npc extends Actor
    placeable;

var SkeletalMeshComponent Mesh;

struct NPCInformation
{
    var name NPCName;
    var bool bActivate;
};

var NPCInformation NPCInfo;

function PostBeginPlay()
{
    NPCInfo.NPCName = 'NPCName';
    NPCInfo.bActivate = true;
}

function SetNPCActivate(bool bActivate)
{
    NPCInfo.bActivate = bActivate;
}

defaultproperties
{
    
    bBlockActors=True
    bCollideActors=True

    Begin Object Class=SkeletalMeshComponent Name=FirstPersonMesh
        SkeletalMesh=SkeletalMesh'CH_IronGuard_Male.Mesh.SK_CH_IronGuard_MaleA'
    End Object
    Mesh=FirstPersonMesh
    Components.Add(FirstPersonMesh)


    Begin Object Class=CylinderComponent Name=CollisionCylinder
        CollisionRadius=64.0
        CollisionHeight=128.0
        BlockNonZeroExtent=true
        BlockZeroExtent=true
        BlockActors=true
        CollideActors=true
    End Object

    CollisionComponent=CollisionCylinder
    Components.Add(CollisionCylinder)
}