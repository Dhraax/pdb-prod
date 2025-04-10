#include "x2_inc_switches"

void main()
{
    int nEvent = GetUserDefinedItemEventNumber();    //Which event triggered this
    if(nEvent==X2_ITEM_EVENT_ACTIVATE)
    {
    object oPC= GetItemActivator();

    DelayCommand(1.0,SetCutsceneMode(oPC,TRUE));
        DelayCommand(1.1, SetPlotFlag(oPC, FALSE));
    DelayCommand(1.5,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK,1.0)));
    DelayCommand(3.7,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.0,5.0)));
    DelayCommand(3.8,PlayVoiceChat(VOICE_CHAT_LAUGH,oPC));
    DelayCommand(4.0,AssignCommand(oPC,SpeakString("Jajajajajajajajaja")));
    DelayCommand(5.7,PlayVoiceChat(VOICE_CHAT_LAUGH,oPC));
    DelayCommand(5.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_VICTORY3,1.0)));
    DelayCommand(6.0,AssignCommand(oPC,ActionPlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING,1.5,7.0)));
    DelayCommand(6.7,PlayVoiceChat(VOICE_CHAT_LAUGH,oPC));
    DelayCommand(8.7,PlayVoiceChat(VOICE_CHAT_LAUGH,oPC));
    DelayCommand(9.0,AssignCommand(oPC,SpeakString("Jaaaajajaja")));
    DelayCommand(13.7,PlayVoiceChat(VOICE_CHAT_LAUGH,oPC));
    DelayCommand(16.0,SetCutsceneMode(oPC,FALSE));
    }
}
