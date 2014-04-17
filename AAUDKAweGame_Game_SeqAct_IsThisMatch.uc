class AAUDKAweGame_Game_SeqAct_IsThisMatch extends SequenceCondition;

var() int TargetMatch;

event Activated()
{
	`log("This Monster Match @" @ TargetMatch);
	`log("GetWorldInfo().Game).CurMonsterMatch@" @ AAUDKAweGame_Game(GetWorldInfo().Game).CurMonsterMatch);
	if(AAUDKAweGame_Game(GetWorldInfo().Game).CurMonsterMatch == TargetMatch)
	{
		
		 OutputLinks[0].bHasImpulse = true;
	}
	else
	{
		OutputLinks[1].bHasImpulse = true;
	}
}

defaultproperties
{
    ObjName="Is This Match"
    ObjCategory="AAUDKAweGame_Game"
	TargetMatch=0
    VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Target Match",PropertyName=TargetMatch)
	OutputLinks(0)=(LinkDesc="True")
	OutputLinks(1)=(LinkDesc="False")
}