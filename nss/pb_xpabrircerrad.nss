//::////////////////////////////////////////////////////////////////////////////
//:: XP al abrir cerraduras
//:: Copyright (c) www.puertadebaldur.net
//::////////////////////////////////////////////////////////////////////////////
/*
  La XP sera: 10 + CD Abrir cerraduras / 3
  El cierre es automatico a los 50 min
*/
//::////////////////////////////////////////////////////////////////////////////
//:: Creado por: Monti
//:: Creado el: 19 de Enero de 2013
//:: Evento: OnUnLock
//::////////////////////////////////////////////////////////////////////////////

void main()
{
  object oPC = GetLastUnlocked();

  // Solo los ubicados se cierran con este script (las puertas suelen usar otro evento para esto)
  if(GetObjectType(OBJECT_SELF) != OBJECT_TYPE_DOOR) DelayCommand(3000.0, SetLocked(OBJECT_SELF, TRUE));

  // Solo se obtiene una vez XP por ubicado o puerta
  if(GetLocalString(OBJECT_SELF, "YA_HE_RECIBIDO_XP") == GetName(oPC)) return;

  int iXP = 5 + (GetLockUnlockDC(OBJECT_SELF)/3);
  SetXP(oPC, GetXP(oPC) + iXP);
  FloatingTextStringOnCreature("<c´þd>* Obtienes "+IntToString(iXP)+" XP por abrir esta cerradura *</c>", oPC, FALSE);
  SetLocalString(OBJECT_SELF, "YA_HE_RECIBIDO_XP", GetName(oPC));
}
