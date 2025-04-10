void main()
{
object oPC = GetPCSpeaker();
SetLocalInt(oPC, "QUEST_SABER_POP_MERCADERES_FALLO", 1);
DelayCommand(300.0, DeleteLocalInt(oPC, "QUEST_SABER_POP_MERCADERES_FALLO"));
}
