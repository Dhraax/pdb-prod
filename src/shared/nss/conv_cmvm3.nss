#include "pb_nivellanzador"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nPos = 1;
    while(nPos<4) {
        int nClass = GetClassByPosition(nPos, oPC);
        nPos++;
        if (nClass != CLASS_TYPE_CLERIC && nClass != CLASS_TYPE_DRUID && nClass != CLASS_TYPE_WIZARD && nClass != CLASS_TYPE_SORCERER &&  nClass != CLASS_TYPE_BARD && nClass != CLASS_TYPE_BLACKGUARD)
            continue;
        if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC)>=20)
            return TRUE;
        if(GetTotalCasterLevel(oPC, nClass) >= 20)
            return TRUE;
    }

  /*int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);

  if(iNivelClerigo >= 20) return TRUE;
  if((iNivelMago + iNivelMaestroLividez) >= 20) return TRUE;
  if((iNivelHechicero + iNivelMaestroLividez) >= 20) return TRUE;*/

    return FALSE;
}