//::///////////////////////////////////////////////
//:: ACELERAR EXPULSION
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Acelerar expulsion.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 10 de Octubre de 2011
//:://////////////////////////////////////////////

void main()
{
  // Hay que tener usos de Expulsar o reprender muertos vivientes
  if(!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
  {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>" + GetStringByStrRef(40550) + "</c>");
      return;
  }

  SetLocalInt(OBJECT_SELF, "ACELERAR_EXPULSION", TRUE);
  ExecuteScript("nw_s2_turndead", OBJECT_SELF);

  // Se restan usos de Expulsar
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);
}
