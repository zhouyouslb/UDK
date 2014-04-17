class AAUDKAweGame_Game_SeqAct_FeatureStart extends SequenceAction;

event Activated()
{
	local AAUDKAweGame_PlayerController APC;
    AAUDKAweGame_Game(GetWorldInfo().Game).Feature = true;

	APC = AAUDKAweGame_Game(GetWorldInfo().Game).MyPC;
	APC.SetLockPawn(true);
}

defaultproperties
{
	ObjName="Feature Start"
	ObjCategory="AAUDKAweGame_Game"

	OutputLinks.Empty
	VariableLinks.Empty
	//VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",PropertyName=Indices)
}