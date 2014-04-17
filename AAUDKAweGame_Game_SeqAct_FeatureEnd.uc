class AAUDKAweGame_Game_SeqAct_FeatureEnd extends SequenceAction;

event Activated()
{
	local AAUDKAweGame_PlayerController APC;
    AAUDKAweGame_Game(GetWorldInfo().Game).Feature = false;

	APC = AAUDKAweGame_Game(GetWorldInfo().Game).MyPC;
	APC.SetLockPawn(false);
}

defaultproperties
{
	ObjName="Feature End"
	ObjCategory="AAUDKAweGame_Game"

	OutputLinks.Empty
	VariableLinks.Empty
	//VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",PropertyName=Indices)
}