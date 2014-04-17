class AAUDKAweGame_Game_SeqAct_InitMonsterQueue extends SequenceAction;

event Activated()
{
    AAUDKAweGame_Game(GetWorldInfo().Game).InitMonstersQueue();
	 OutputLinks[0].bHasImpulse = true;
}

defaultproperties
{
    ObjName="Init Monster Queue"
    ObjCategory="AAUDKAweGame_Game"

	VariableLinks.Empty
	OutputLinks(0)=(LinkDesc="Finished")
}