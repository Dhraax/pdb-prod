#include "pb_nivellanzador"

int StartingConditional()
{
  object oPC = GetPCSpeaker();
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelCaballero = GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) - 1;
  int iNivelAdepto = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC);
  int iNivelTeurgo = GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC);
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) - 1;

  // Restricción basada en la clase de personaje
    if (iNivelHechicero >= 12)return TRUE;
    if ((iNivelHechicero + iNivelCaballero) >= 12)return TRUE;
    if ((iNivelHechicero + iNivelAdepto) >= 12) return TRUE;
    if ((iNivelHechicero + iNivelTeurgo) >= 12) return TRUE;
    if ((iNivelHechicero + iNivelMaestroLividez) >= 12) return TRUE;

    if (iNivelMago >= 11)return TRUE;
    if ((iNivelMago + iNivelCaballero) >= 11)return TRUE;
    if ((iNivelMago + iNivelAdepto) >= 11)return TRUE;
    if ((iNivelMago + iNivelTeurgo) >= 11)return TRUE;
    if ((iNivelMago + iNivelMaestroLividez) >= 11)return TRUE;

  return FALSE;
}
