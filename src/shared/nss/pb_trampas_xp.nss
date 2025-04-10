//::////////////////////////////////////////////////////////////////////////////
//:: XP al desactivar trampas
//:: Copyright (c) www.puertadebaldur.net
//::////////////////////////////////////////////////////////////////////////////
/*
  XP al desarmar trampas.
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Creado por: Monti
//:: Creado el: 6 de Enero de 2013
//:: Evento: OnDisarm
//::////////////////////////////////////////////////////////////////////////////

void main()
{
  object oPC = GetLastDisarmed();
  object oTrapCreator = GetTrapCreator(OBJECT_SELF);
  int nXP = 5 + (GetTrapDisarmDC(OBJECT_SELF)/3);

  if(!GetIsPC(oTrapCreator))
  {
      GiveXPToCreature(oPC, nXP);
      FloatingTextStringOnCreature("<c´þd>* Obtienes "+IntToString(nXP)+" XP por desactivar esta trampa *</c>", oPC, FALSE);
  }
}
