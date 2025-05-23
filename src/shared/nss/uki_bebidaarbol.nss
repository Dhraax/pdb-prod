#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    object oPC= GetItemActivator();

    DelayCommand(1.0,SetCutsceneMode(oPC,TRUE));
    DelayCommand(1.1, SetPlotFlag(oPC, FALSE));

    effect eArbol = EffectVisualEffect(VFX_DUR_PROT_BARKSKIN);
    effect eResistir = EffectTemporaryHitpoints(d20(10));
    effect eParalizar = EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
    effect eRegenerar = EffectRegenerate(10,5.0);
    effect eRaices = EffectVisualEffect(VFX_DUR_ENTANGLE);

    DelayCommand(1.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));
    DelayCommand(3.7,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0)));

    DelayCommand(6.0,AssignCommand(oPC,SpeakString("Uggg...")));
    DelayCommand(6.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,3.0)));

    DelayCommand(7.0,SetCommandable(FALSE,oPC));
    DelayCommand(7.0,PlayVoiceChat(VOICE_CHAT_DEATH,oPC));
    DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eArbol,oPC,240.0));
    DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRegenerar,oPC,240.0));
    DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eRaices,oPC,240.0));
    DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eResistir,oPC,240.0));
    DelayCommand(7.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eParalizar,oPC,240.0));

    DelayCommand(8.0,SetCutsceneMode(oPC,FALSE));

        DelayCommand(248.0,SetCommandable(TRUE,oPC));
    }
}
