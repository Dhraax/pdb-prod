#include "mti_libreria"

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  string sBonusMalusDotes = GetStringRight(sTexto, GetStringLength(sTexto) - 2);
  int iBonusMalusDotes = StringToInt(sBonusMalusDotes);

  if(iBonusMalusDotes > GetBaseAttackBonus(oPC) || iBonusMalusDotes > 20 || iBonusMalusDotes < 1)
  {
      FloatingTextStringOnCreature("<cþ<<>* Bonificador / penalizador para [Ataque poderoso] inválido *</c>", oPC, FALSE);
      SendMessageToPC(oPC, "<cÍþ>Escribe 'AP + un número entre 1 y 20' para establecer el bonificador / penalizador deseado en el Ataque poderoso, por ejemplo, 'AP 7' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
  }
  else
  {
      FloatingTextStringOnCreature("<c´þd>* Bonificador / penalizador para [Ataque poderoso] ajustado a ["+IntToString(iBonusMalusDotes)+"] *</c>", oPC, FALSE);
//      SetLocalInt(oPC, "DOTE_AP_AJUSTE", iBonusMalusDotes);
      GuardarIntPersistente(oPC, "DOTE_AP_AJUSTE", iBonusMalusDotes);
  }
}
