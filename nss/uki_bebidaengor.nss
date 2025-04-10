#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    object oPC= GetItemActivator();


    effect eMagia = EffectVisualEffect(VFX_IMP_RESTORATION_GREATER);
    effect eMagia2 = EffectVisualEffect(VFX_IMP_HEALING_X);

    DelayCommand(1.5,AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));
if(GetIsPlayableRacialType(oPC) == TRUE)
    {
    if(GetPhenoType(oPC) == PHENOTYPE_NORMAL)
        {
    DelayCommand(15.0,AssignCommand(oPC,SpeakString("Tengo hambre.")));


    DelayCommand(25.0,AssignCommand(oPC,SpeakString("Ufff...¡Qué hambre!")));
    DelayCommand(25.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,3.0)));


    DelayCommand(36.0,SetCommandable(FALSE,oPC));
    DelayCommand(34.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_SPASM,1.0,10.0)));
    DelayCommand(41.0,AssignCommand(oPC,SpeakString("¡Quiero comeeer!")));

    DelayCommand(42.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eMagia,oPC));
    DelayCommand(42.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eMagia2,oPC));

    DelayCommand(43.0,SetPhenoType(PHENOTYPE_BIG,oPC));
    DelayCommand(44.0,AssignCommand(oPC,PlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD,1.0)));
    DelayCommand(45.0,SetCommandable(TRUE,oPC));
        }
    else
        {
    effect eDano = EffectDamage(GetCurrentHitPoints(oPC)-1);
    DelayCommand(2.0,SetCutsceneMode(oPC,TRUE));
    DelayCommand(2.1, SetPlotFlag(oPC, FALSE));
    DelayCommand(6.0,AssignCommand(oPC,SpeakString("*El elixir parece no sentarte muy bien*")));
    DelayCommand(6.0,PlayVoiceChat(VOICE_CHAT_PAIN3,oPC));
    DelayCommand(6.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK,1.0,3.0)));

    DelayCommand(8.0,PlayVoiceChat(VOICE_CHAT_PAIN1,oPC));


    DelayCommand(10.0,PlayVoiceChat(VOICE_CHAT_DEATH,oPC));
    DelayCommand(10.0,ApplyEffectToObject(DURATION_TYPE_INSTANT,eDano,oPC));
    DelayCommand(10.0,AssignCommand(oPC,PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,10.0)));
    DelayCommand(18.0,SetCutsceneMode(oPC,FALSE));
        }
    }
else
    {
    DelayCommand(6.0,AssignCommand(oPC,SpeakString("*El elixir parece no afectarte*")));
    }
    }
}
