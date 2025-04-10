#include "mti_libreria"

int StartingConditional()
{
  object oPC = GetPCSpeaker();

  // Si tenemos 5 o mas animales de carga sin devolver... multa. El precio varia si reincides.
  int iAnimalesSinDevolver = ObtenerIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER");
  if(iAnimalesSinDevolver >= 5)
  {
      int iMultasPagadas = ObtenerIntPersistente(oPC, "ANIMALES_SIN_DEVOLVER_MULTAS");
      int PrecioMulta = (iMultasPagadas + 1) * 5000;
      SetCustomToken(490, IntToString(PrecioMulta));

      return TRUE;
  }

  return FALSE;
}
