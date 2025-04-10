
//Crear Varita Imbuir Objeto Brujo//

#include "x2_inc_craft"

void main()
{
    object oCaster = GetPCSpeaker();
    int iDado = d20();
    int iUOM = GetSkillRank(SKILL_USE_MAGIC_DEVICE, oCaster);
    int iTirada = iDado + iUOM;
    int iSpell = StringToInt(GetScriptParam("ID"));
    int iCD = StringToInt(GetScriptParam("CD"));

    //Solo una cada 24h por motor
    object oMod = GetModule();

    DelayCommand(8320.0, DeleteLocalInt(oMod, "NOMASVARITAS" + GetName(oCaster)));

    if(iTirada > iCD) //CD Conjuro Divino
    {
        CICraftCraftWand(oCaster, iSpell);
        effect eVis = EffectVisualEffect(VFX_IMP_HEAD_ODD);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetPCSpeaker());
    }

    else FloatingTextStringOnCreature("¡Algo ha salido mal!.", oCaster, FALSE);

}
