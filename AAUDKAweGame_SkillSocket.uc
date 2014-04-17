class AAUDKAweGame_SkillSocket extends Actor;

var array<AAUDKAweGame_Skill> MyPlayerSkill;

//检测该人物是否拥有此技能
function bool IsHaveThisSkill(name SkillName)
{
    local int index;
    for (index = 0; index < MyPlayerSkill.length; index++)
    {
        `log(MyPlayerSkill[index].MySkilllnfo.SKillClassName @ "==========");
        if (MyPlayerSkill[index].MySkilllnfo.SKillClassName == SkillName)
        {
            return true;
        }
    }
    return false;
}

function AddSkill(Actor mOwner,name SkillName ,class<AAUDKAweGame_Skill> SkillClassName)
{
    local AAUDKAweGame_Skill mAS;
    mAS = spawn(SkillClassName,self);
    mAs.SkillOwner = mOwner;
    mAS.MySkilllnfo.SKillClassName = SkillName;
    MyPlayerSkill[MyPlayerSkill.length] = mAS;
}

function ActivatedSkill(name SkillName)
{
    local int index;
    for (index = 0; index < MyPlayerSkill.length; index++)
    {
        if (MyPlayerSkill[index].MySkilllnfo.SKillClassName == SkillName)
        {
            MyPlayerSkill[index].UseSkill();
        }
    }
}

defaultproperties
{

}