#include "pb_nivellanzador"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nPos = 1;
    while(nPos<4) {
        int nClass = GetClassByPosition(nPos, oPC);
        nPos++;
        if (nClass != CLASS_TYPE_CLERIC && nClass != CLASS_TYPE_DRUID && nClass != CLASS_TYPE_WIZARD && nClass != CLASS_TYPE_SORCERER)
            continue;
        if(GetTotalCasterLevel(oPC, nClass) >= 24)
            return TRUE;
    }
  /*int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);

  if(iNivelClerigo >= 24) return TRUE;
  if((iNivelMago + iNivelMaestroLividez) >= 24) return TRUE;
  if((iNivelHechicero + iNivelMaestroLividez) >= 24) return TRUE;*/

    return FALSE;
}