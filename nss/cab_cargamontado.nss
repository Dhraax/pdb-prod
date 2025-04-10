#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetMaster(OBJECT_SELF) == oPC) return FALSE;

  // No puedes hacer que se una un animal de carga mientras estas montado en una montura
  if(VerSiEsAnimalDeCarga() == TRUE &&
     GetMaster(OBJECT_SELF) == OBJECT_INVALID &&
     GetLocalString(OBJECT_SELF, "AMO") == GetName(oPC, TRUE) &&
     ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      SendMessageToPC(oPC, "<cþ>¡Tu animal de carga no puede seguirte mientras estás montado!</c>");
      return TRUE;
  }

  return FALSE;
}
