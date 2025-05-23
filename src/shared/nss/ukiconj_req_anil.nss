#include "pb_nivellanzador"

int StartingConditional()

{ object oPC = GetPCSpeaker();
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelCaballero = GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) - 1;
  int iNivelAdepto = GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC);
  int iNivelTeurgo = GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC);
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) - 1;

  // Restricción basada en la clase de personaje
    if (iNivelHechicero >= 10)return TRUE;
    if ((iNivelHechicero + iNivelCaballero) >= 10)return TRUE;
    if ((iNivelHechicero + iNivelAdepto) >= 10) return TRUE;
    if ((iNivelHechicero + iNivelTeurgo) >= 10) return TRUE;
    if ((iNivelHechicero + iNivelMaestroLividez) >= 10) return TRUE;

    if (iNivelMago >= 9)return TRUE;
    if ((iNivelMago + iNivelCaballero) >= 9)return TRUE;
    if ((iNivelMago + iNivelAdepto) >= 9)return TRUE;
    if ((iNivelMago + iNivelTeurgo) >= 9)return TRUE;
    if ((iNivelMago + iNivelMaestroLividez) >= 9)return TRUE;

  return FALSE;
}
