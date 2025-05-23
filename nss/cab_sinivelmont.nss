#include "cab_inc"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Obtenemos el nivel del caballo
  object oMonturaUsada = GetFirstItemInInventory(oPC);
  int iNivelMontura, iXPMontura, iXPMonturaNivSig, iUnaSolaVez;
  while(GetIsObjectValid(oMonturaUsada) == TRUE && iUnaSolaVez == FALSE)
  {
      if(GetTag(oMonturaUsada) == "cab_montura" &&
         GetItemCursedFlag(oMonturaUsada) == TRUE &&
         GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
      {
          iNivelMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURA");
          iXPMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURAXP");
          iXPMonturaNivSig = CalculoSiguienteNivelXPMontura(iNivelMontura);
          iUnaSolaVez == TRUE;
      }

      oMonturaUsada = GetNextItemInInventory(oPC);
  }

  if(iNivelMontura == 0 || iNivelMontura == 20 || iXPMontura == 0) return FALSE;

  if(iXPMontura >= CalculoSiguienteNivelXPMontura(iNivelMontura)) return TRUE;

  return FALSE;
}
