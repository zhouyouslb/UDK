class AAUDKAweGame_Game_SeqAct_TrunOnOffBeam extends SequenceAction;

var() array<AAUDKAweGame_Aggressive_BeamEmitter> Beam;

var() bool bOn;

event Activated()
{
	local int i;
	//`log("Beam" @ Beam);
	for(i = 0 ; i < Beam.Length ; i++)
	{
		Beam[i].bCanOpen = bOn;
	}
}

defaultproperties
{
	ObjName="Trun On Off Beam"
	ObjCategory="AAUDKAweGame_Game"

	bOn=true

	OutputLinks.Empty
	VariableLinks.Empty
	VariableLinks(0)=(ExpectedType=class'SeqVar_Object',LinkDesc="Beam",PropertyName=Beam)
}