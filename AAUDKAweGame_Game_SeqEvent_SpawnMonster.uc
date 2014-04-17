class AAUDKAweGame_Game_SeqEvent_SpawnMonster extends SequenceAction;

var() int Match;

event Activated()
{
    if(AAUDKAweGame_Game(GetWorldInfo().Game) != none)
        AAUDKAweGame_Game(GetWorldInfo().Game).StartSpawn(Match);
}

defaultproperties
{
    ObjName="Spawn Monster"
    ObjCategory="AAUDKAweGame_Game"
	Match=0
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Match",PropertyName=Match)
}