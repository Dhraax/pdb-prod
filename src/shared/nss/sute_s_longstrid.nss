#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE){
       object oPC= GetItemActivator();

       int iDuracion= GetLevelByClass(CLASS_TYPE_DRUID, oPC);
       if (GetLevelByClass(CLASS_TYPE_RANGER, oPC)>iDuracion){
          iDuracion= GetLevelByClass(CLASS_TYPE_RANGER, oPC);
       }

       effect eVis = EffectVisualEffect(VFX_IMP_HASTE);
       effect eVelocidad = EffectMovementSpeedIncrease(5 + GetHitDice(oPC));
       AssignCommand(oPC,ActionCastFakeSpellAtObject(SPELL_HASTE,oPC,PROJECTILE_PATH_TYPE_DEFAULT));
       DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC));
       DelayCommand(8.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVelocidad, oPC, HoursToSeconds(iDuracion)));
    }
}
