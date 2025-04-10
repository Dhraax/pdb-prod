#include "pb_nivellanzador"

int StartingConditional()
{
    object oPC = GetPCSpeaker();
    int nPos = 1;
    while(nPos<4) {
        int nClass = GetClassByPosition(nPos, oPC);
        nPos++;
        if (nClass != CLASS_TYPE_CLERIC && nClass != CLASS_TYPE_DRUID && nClass != CLASS_TYPE_WIZARD && nClass != CLASS_TYPE_SORCERER &&  nClass != CLASS_TYPE_BARD && nClass != CLASS_TYPE_BLACKGUARD &&
            nClass != CLASS_TYPE_WARLOCK)
            continue;
        if(GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC)>=14)
            return TRUE;
        if(GetTotalCasterLevel(oPC, nClass) >= 14)
            return TRUE;
    }

  /*int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
  int iNivelGuardiaNegro = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  int iNivelMaestroLividez = GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC);
  int iNivelOrcus = GetLevelByClass(47, oPC);

  if(iNivelClerigo + iNivelGuardiaNegro >= 14) return TRUE;
  if(iNivelClerigo + iNivelOrcus >= 14) return TRUE;
  if((iNivelMago + iNivelMaestroLividez) >= 14) return TRUE;
  if((iNivelHechicero + iNivelMaestroLividez) >= 14) return TRUE;*/

    return FALSE;
}
