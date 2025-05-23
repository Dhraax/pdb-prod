#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    object oPC= GetItemActivator();

    DelayCommand(1.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));

if(GetHasFeat(FEAT_IMMUNITY_TO_SLEEP,oPC) == FALSE)
    {
    effect eDormir = EffectSleep();
    effect eSueno = EffectVisualEffect(VFX_IMP_SLEEP);
    DelayCommand(4.0,AssignCommand(oPC,SpeakString("*Bostezo*")));
    DelayCommand(4.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED,1.0)));
    DelayCommand(10.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDormir,oPC,120.0));
    DelayCommand(20.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSueno,oPC));
    DelayCommand(40.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSueno,oPC));
    DelayCommand(60.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSueno,oPC));
    DelayCommand(80.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSueno,oPC));
    DelayCommand(100.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSueno,oPC));
    }
else
    {
    {
    DelayCommand(6.0,AssignCommand(oPC,SpeakString("*El elixir parece no afectarte*")));
    }
    }
   }
}
