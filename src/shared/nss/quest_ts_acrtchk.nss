int StartingConditional()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();
  int iComprobacionAcertijos = GetLocalInt(oPC, "QUEST_CONTADOR_ACERTIJOS");
  int iContadorAcertijos = GetLocalInt(oMod, "QUEST_CONTADOR_ACERTIJOS") + 1;

  // Si fallas un acertijo la estatua se bloquea unos segundos, o bien la estatua completo exitosamente todos los acertijos
  if(GetLocalInt(OBJECT_SELF, "QUEST_ACERTIJOS_STOP") == TRUE) return TRUE;

  // Determinados acertijos solo los muestran ciertas estatuas
       if((GetTag(OBJECT_SELF) == "quest_estatua_ejercicios1") && iContadorAcertijos != 1  && iContadorAcertijos != 2) return TRUE;
  else if((GetTag(OBJECT_SELF) == "quest_estatua_ejercicios2") && iContadorAcertijos != 3  && iContadorAcertijos != 4) return TRUE;
  else if((GetTag(OBJECT_SELF) == "quest_estatua_ejercicios3") && iContadorAcertijos != 5  && iContadorAcertijos != 6) return TRUE;
  else if((GetTag(OBJECT_SELF) == "quest_estatua_ejercicios4") && iContadorAcertijos != 7  && iContadorAcertijos != 8  && iContadorAcertijos != 9)  return TRUE;
  else if((GetTag(OBJECT_SELF) == "quest_estatua_ejercicios5") && iContadorAcertijos != 10 && iContadorAcertijos != 11 && iContadorAcertijos != 12) return TRUE;

  // Vamos apareciendo o no los acertijos segun el que toque
  if(iComprobacionAcertijos == iContadorAcertijos)
  {
      DeleteLocalInt(oPC, "QUEST_CONTADOR_ACERTIJOS");
      return TRUE;
  }
  else
  {
      SetLocalInt(oPC, "QUEST_CONTADOR_ACERTIJOS", iComprobacionAcertijos + 1);
      return FALSE;
  }
}
