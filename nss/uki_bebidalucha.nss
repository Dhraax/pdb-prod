#include "x2_inc_switches"
#include "inc_timelock"

void main()
{
    object oPC= GetItemActivator();
    string sPotion = "uki_bebidalucha";
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Elixir de Marthiba"))
    {
        TimelockErrorMessage(oPC, "Elixir de Marthiba");
        return;
    }
    SetTimelock(oPC, 30, "Elixir de Marthiba", 29, 6);

    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    DelayCommand(1.0,SetCutsceneMode(oPC,TRUE));
    DelayCommand(1.1, SetPlotFlag(oPC, FALSE));

    effect eAtaque = EffectAttackIncrease(2);
    effect eResistir = EffectTemporaryHitpoints(d10(2));
    DelayCommand(1.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));
    DelayCommand(3.7,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY1,1.2)));
    DelayCommand(3.7,PlayVoiceChat(VOICE_CHAT_BATTLECRY1,oPC));

    DelayCommand(4.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY2,1.2)));
    DelayCommand(5.2,AssignCommand(oPC,SpeakString("¡Quiero luchar!")));

    DelayCommand(5.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAtaque,oPC,30.0));
    DelayCommand(5.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eResistir,oPC,30.0));

    DelayCommand(6.0,SetCutsceneMode(oPC,FALSE));
    DelayCommand(30.0f, DeleteLocalInt(oPC, sPotion));
    }
}
