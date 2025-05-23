#include "pb_nivellanzador"

int ObtenerPropiedadSlotValido(object oPC, int iSlotClase, int iSlotEsfera)
{
    if(iSlotClase == CLASS_TYPE_PAL_ANTIGUO || iSlotClase == CLASS_TYPE_PAL_OSCURO || iSlotClase != CLASS_TYPE_PAL_VENGADOR || iSlotClase != CLASS_TYPE_PALADIN)
    {
        return iSlotEsfera <= GetCasterMaxSpellLevel(iSlotClase, oPC, FALSE);
    }
    else return iSlotEsfera <= GetCasterMaxSpellLevel(iSlotClase, oPC);



  /*int iNivelNecesario;

  // clerigo, druida, mago
  if(iSlotClase == 2 || iSlotClase == 3 || iSlotClase == 10)
  {
      if(iSlotEsfera == 1) iNivelNecesario = 1;
      else if(iSlotEsfera == 2) iNivelNecesario = 3;
      else if(iSlotEsfera == 3) iNivelNecesario = 5;
      else if(iSlotEsfera == 4) iNivelNecesario = 7;
      else if(iSlotEsfera == 5) iNivelNecesario = 9;
      else if(iSlotEsfera == 6) iNivelNecesario = 11;
      else if(iSlotEsfera == 7) iNivelNecesario = 13;
      else if(iSlotEsfera == 8) iNivelNecesario = 15;
      else if(iSlotEsfera == 9) iNivelNecesario = 17;

      int iNivelClerigo = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
      int iNivelDruida  = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
      int iNivelMago    = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);

      if(iSlotClase == 2) // Clerigo
      {
          if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC) > 0) iNivelClerigo += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oPC);
          if(GetLevelByClass(CLASS_TYPE_ORCUS, oPC) > 0) iNivelClerigo += GetSpecialCasterLevel(CLASS_TYPE_ORCUS, oPC);

          if(iNivelClerigo >= iNivelNecesario || iNivelClerigo == 0) return TRUE;
          else return FALSE;
      }

      else if(iSlotClase == 3) // Druida
      {
          if(iNivelDruida >= iNivelNecesario || iNivelDruida == 0) return TRUE;
          else return FALSE;
      }

      else // Mago
      {
          if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
          if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelMago += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
          if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
          if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oPC);
          if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_TEURGO_MIST, oPC);

          if(iNivelMago >= iNivelNecesario || iNivelMago == 0) return TRUE;
          else return FALSE;
      }
  }

  // Hechicero
  else if(iSlotClase == 9)
  {
      if(iSlotEsfera == 1) iNivelNecesario = 1;
      else if(iSlotEsfera == 2) iNivelNecesario = 4;
      else if(iSlotEsfera == 3) iNivelNecesario = 6;
      else if(iSlotEsfera == 4) iNivelNecesario = 8;
      else if(iSlotEsfera == 5) iNivelNecesario = 10;
      else if(iSlotEsfera == 6) iNivelNecesario = 12;
      else if(iSlotEsfera == 7) iNivelNecesario = 14;
      else if(iSlotEsfera == 8) iNivelNecesario = 16;
      else if(iSlotEsfera == 9) iNivelNecesario = 18;

      int iNivelHechicero = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);

      if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelHechicero += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
      if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelHechicero += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelHechicero += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC) > 0) iNivelHechicero += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oPC);

      if(iNivelHechicero >= iNivelNecesario || iNivelHechicero == 0) return TRUE;
      else return FALSE;
  }

  // Bardo
  else if(iSlotClase == 1)
  {
      if(iSlotEsfera == 1) iNivelNecesario = 2;
      else if(iSlotEsfera == 2) iNivelNecesario = 4;
      else if(iSlotEsfera == 3) iNivelNecesario = 7;
      else if(iSlotEsfera == 4) iNivelNecesario = 10;
      else if(iSlotEsfera == 5) iNivelNecesario = 13;
      else if(iSlotEsfera == 6) iNivelNecesario = 16;

      int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);

      if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
      if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC) > 0) iNivelBardo += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_SHADOW_ADEPT, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_SHADOW_ADEPT, oPC);

      if(iNivelBardo >= iNivelNecesario || iNivelBardo == 0) return TRUE;
      else return FALSE;
  }

  // Paladin / Explorador
  else if(iSlotClase == 6 || iSlotClase == 7)
  {
      if(iSlotEsfera == 1) iNivelNecesario = 4;
      else if(iSlotEsfera == 2) iNivelNecesario = 8;
      else if(iSlotEsfera == 3) iNivelNecesario = 11;
      else if(iSlotEsfera == 4) iNivelNecesario = 14;

      int iNivelPaladin     = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
      int iNivelExplorador  = GetLevelByClass(CLASS_TYPE_RANGER, oPC);

      if(iSlotClase == 6) // Paladin
      {
          if(iNivelPaladin >= iNivelNecesario || iNivelPaladin == 0) return TRUE;
          else return FALSE;
      }

      else // Explorador
      {
          if(iNivelExplorador >= iNivelNecesario || iNivelExplorador == 0) return TRUE;
          else return FALSE;
      }
  }

  return FALSE;*/
}
