//::///////////////////////////////////////////////
//:: FileName dar_jaulasombria
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
//:: Created By: Script Wizard
//:: Created On: 23/04/2006 14:27:20
//:://////////////////////////////////////////////
void main()
{
    // Quitar algunos PX al jugador
    int iXP = GetXP(GetPCSpeaker());
    SetXP(GetPCSpeaker(), iXP -5000);
    // Dar los objetos al que habla
    CreateItemOnObject("jaulasombria01", GetPCSpeaker(), 1);

effect e1 = EffectVisualEffect(VFX_FNF_TIME_STOP);
effect e2 = EffectVisualEffect(VFX_IMP_DEATH_L);
effect e3 = EffectVisualEffect(VFX_IMP_HARM);

ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,GetPCSpeaker());
ApplyEffectToObject(DURATION_TYPE_INSTANT,e2,GetPCSpeaker());
ApplyEffectToObject(DURATION_TYPE_INSTANT,e3,GetPCSpeaker());

DelayCommand(1.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,e3,OBJECT_SELF));
}
