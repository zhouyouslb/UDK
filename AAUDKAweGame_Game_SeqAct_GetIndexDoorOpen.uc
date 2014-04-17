class AAUDKAweGame_Game_SeqAct_GetIndexDoorOpen extends SeqAct_Switch;

event Activated()
{
    local int idx,i;
    idx = AAUDKAweGame_Game(GetWorldInfo().Game).GetOpenDoorIndex();

    //设置out口输出响应
    `log("open the door index!!" @ idx);

    for(i = 0 ;i < LinkCount;i++)
    {
        if(i == idx -1 )
            OutputLinks[i].bHasImpulse = true;
        else
            OutputLinks[i].bHasImpulse = false;
    }
}

defaultproperties
{
	ObjName="GetIndexDoorOpen"
	ObjCategory="AAUDKAweGame_Game"

	//Indices(0)=1
	LinkCount=3
	IncrementAmount=100
	OutputLinks(0)=(LinkDesc="Link 1")
	OutputLinks(1)=(LinkDesc="Link 2")
    OutputLinks(2)=(LinkDesc="Link 3")
    OutputLinks(3)=(LinkDesc="Link 4")
    OutputLinks(4)=(LinkDesc="Link 5")
    OutputLinks(5)=(LinkDesc="Link 6")
    OutputLinks(6)=(LinkDesc="Link 7")
    OutputLinks(7)=(LinkDesc="Link 8")
    OutputLinks(8)=(LinkDesc="Link 9")
    OutputLinks(9)=(LinkDesc="Link 10")
	//bAutoDisableLinks=true
	//VariableLinks.Empty
	//VariableLinks(0)=(ExpectedType=class'SeqVar_Int',LinkDesc="Index",PropertyName=Indices)
}