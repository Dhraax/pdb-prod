#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  if(GetMaster(OBJECT_SELF) == oPC) return FALSE;

  // No se pueden tener mas de 3 de ayudantes
  object oAyudante1 = GetHenchman(oPC, 1);
  object oAyudante2 = GetHenchman(oPC, 2);
  object oAyudante3 = GetHenchman(oPC, 3);
  if(oAyudante1 != OBJECT_INVALID &&
     oAyudante2 != OBJECT_INVALID &&
     oAyudante3 != OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "<cþ>¡No puedes tener más de 3 ayudantes a la vez!</c>");
      return TRUE;
  }

  // Si ya tenemos una montura, nanay
  if(VerSiEsMontura(OBJECT_SELF) == TRUE &&
    (VerSiEsMonturaConvocada(oAyudante1) == TRUE ||
     VerSiEsMonturaConvocada(oAyudante2) == TRUE ||
     VerSiEsMonturaConvocada(oAyudante3) == TRUE))
  {
      SendMessageToPC(oPC, "<cþ>Ya tienes una montura convocada, sólo puedes tener una montura.</c>");
      return TRUE;
  }

  // Si ya tenemos una montura, nanay
  if(VerSiEsMonturaConvocada(OBJECT_SELF) == TRUE &&
    (VerSiEsMontura(oAyudante1) == TRUE ||
     VerSiEsMontura(oAyudante2) == TRUE ||
     VerSiEsMontura(oAyudante3) == TRUE))
  {
      SendMessageToPC(oPC, "<cþ>Ya tienes una montura, sólo puedes tener una.</c>");
      return TRUE;
  }

  return FALSE;
}
