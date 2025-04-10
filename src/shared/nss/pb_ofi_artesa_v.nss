//::///////////////////////////////////////////////
//:: OFICIO DE ARTESANIA URDIMBRICA, ON DISTURB ITEM
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  3er Oficio de Artesania Urdimbrica.
  Se coloca en el evento OnDisturb del ubicado donde queremos
  que se vendan los objetos encantados de Artesanía Urdímbrica.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 16 de Agosto de 2013
//:://////////////////////////////////////////////

void main()
{
  object oPC = GetLastDisturbed();
  object oObjeto = GetInventoryDisturbItem();
  int iOroVenta = GetLocalInt(oObjeto, "ARTESANIA_VENTA");

  if(iOroVenta > 0)
  {
      GiveGoldToCreature(oPC, iOroVenta);
      FloatingTextStringOnCreature("<c þ >Has vendido el objeto por " + IntToString(iOroVenta) + " po.</c>", oPC, FALSE);
      DestroyObject(oObjeto);
      return;
  }
  else
  {
      CopyItem(oObjeto, oPC, TRUE);
      DestroyObject(oObjeto);
      FloatingTextStringOnCreature("<cþ<<>¡No puedes vender este objeto!</c>", oPC, FALSE);
  }
}
