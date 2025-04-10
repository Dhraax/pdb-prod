#include "mti_libreria"

void main()
{
  object oPC = GetPCChatSpeaker();
  string sTexto = GetPCChatMessage();

  string sBonusMalusDotes = GetStringRight(sTexto, GetStringLength(sTexto) - 2);
  int iBonusMalusDotes = StringToInt(sBonusMalusDotes);

  int iMaximoNumeroEnPericia = 5;
  if(GetHasFeat(1226, oPC)) iMaximoNumeroEnPericia = 20;

  if(iBonusMalusDotes > GetBaseAttackBonus(oPC) || iBonusMalusDotes > iMaximoNumeroEnPericia || iBonusMalusDotes < 1)
  {
      FloatingTextStringOnCreature("<cþ<<>* Bonificador / penalizador para [Pericia en combate] inválido *</c>", oPC, FALSE);
      if(GetHasFeat(1226, oPC)) SendMessageToPC(oPC, "<cÍþ>Escribe 'PC + un número entre 1 y 20' para establecer el bonificador / penalizador deseado en Pericia en combate, por ejemplo, 'PC 8' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
      else SendMessageToPC(oPC, "<cÍþ>Escribe 'PC + un número entre 1 y 5' para establecer el bonificador / penalizador deseado en Pericia en combate, por ejemplo, 'PC 3' (sin comillas). Recuerda que este número nunca podrá ser mayor al de tu ataque base.</c>");
  }
  else
  {
      FloatingTextStringOnCreature("<c´þd>* Bonificador / penalizador para [Pericia en combate] ajustado a ["+IntToString(iBonusMalusDotes)+"] *</c>", oPC, FALSE);
//      SetLocalInt(oPC, "DOTE_PERICIA_AJUSTE", iBonusMalusDotes);
      GuardarIntPersistente(oPC, "DOTE_PERICIA_AJUSTE", iBonusMalusDotes);
  }
}
