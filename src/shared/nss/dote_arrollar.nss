//::///////////////////////////////////////////////
//:: DOTE ARROLLAR Y ARROLLAR MEJORADO
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Dote Arrollar y Arrollar Mejorado.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 30 de Mayo de 2011
//:://////////////////////////////////////////////

void main()
{
  int iConjuro = GetSpellId();
  string sMensaje;

  if(iConjuro == 892) sMensaje = "<cþ<<>Dote [Arrollar] todavía no creada. Por favor, sé paciente, la habilitaremos tan pronto como nos sea posible.</c>";
  else if(iConjuro == 893) sMensaje = "<cþ<<>Dote [Arrollar mejorado] todavía no creada. Por favor, sé paciente, la habilitaremos tan pronto como nos sea posible.</c>";

  SendMessageToPC(OBJECT_SELF, sMensaje);
}
