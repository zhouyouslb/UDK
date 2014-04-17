class AAUDKAweGame_NPCInterface extends AAUDKAweGame_ActorInterface;

struct NPCInformation
{
    var name NPCName;
    var bool bActivate;
};

//获取是否有NPC在面前
//NPCInformation Param,指定某个NPC
function bool IsHasNpcFront(Pawn P ,out AAUDKAweGame_Npc out_NPCActor,optional NPCInformation Param)
{
    local Actor NPC;
    NPC = GetFaceActor(P);
    if(AAUDKAweGame_Npc(NPC) != none)
    {
        if(Param.NPCName != '')
        {
            //判断是否是指定NPC，并且判断NPC是否激活
            if(Param.NPCName != AAUDKAweGame_Npc(NPC).NPCInfo.NPCName || !AAUDKAweGame_Npc(NPC).NPCInfo.bActivate)
                return false;
        }
        out_NPCActor = AAUDKAweGame_Npc(NPC);
        return true;
    }
    return false;
}

defaultproperties
{

}