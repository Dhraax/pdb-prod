void main()
{
object oPC = GetPCSpeaker();

if (GetGold(oPC) < 5)
     {
        FloatingTextStringOnCreature("¡No tienes 5 monedas de oro!", oPC, FALSE);
        return;
     }

AssignCommand(oPC, TakeGoldFromCreature(5, oPC, TRUE));

SetLocalInt(oPC, "DONACIONTEATRO", 1);
DelayCommand(10000.0, DeleteLocalInt(oPC, "DONACIONTEATRO"));
PlayVoiceChat(VOICE_CHAT_THANKS, OBJECT_SELF);
}
