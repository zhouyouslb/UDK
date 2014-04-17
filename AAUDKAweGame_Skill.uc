class AAUDKAweGame_Skill extends Actor;

//是否被中断技能
var bool bSkillBreak;

var Actor SkillOwner;

Struct Skilllnfo
{
    var name SKillClassName;
};

var Skilllnfo MySkilllnfo;

//在Controller中的tick中调用
function bool IsUseSkill()
{

}

function UseSkill()
{
    `log("this skill clasee is flase");
}



defaultproperties
{
    bSkillBreak=false
}