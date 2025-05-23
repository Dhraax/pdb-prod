//::////////////////////////////////////////////////////////////////////////:://
//::// LIBRERIA DE LAS SUBRAZAS DE MONTI                                  //:://
//::////////////////////////////////////////////////////////////////////////:://

#include "x2_inc_itemprop"
#include "mti_libreria"
#include "pb_constantes"

int VerSiIncumploRequisitosSubrazas(object oPC)
{
  int iRacialType = GetRacialType(oPC);
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  // 1. MINOTAUROS
  // 2. ORCOS
  // 3. OSGOS
  // 4. TRASGOS
  // 5. GRANDES TRASGOS
  // 6. KOBOLDS
  // 7. OGROS
  // 8. SEMIOGROS
  // 9. OGRO HECHICERO
  // 10. SVIRFNEBLINS
  // 11. SEMIDROWS
  // 12. GHULS
  // 13. DROWS
  // 14. VAMPIROS
  // 15. TIFLINS
  // 16. DUERGARS
  // 17. SEMIINFERNAL
  // 18. GITHYANKI
  // 19. ORCO GRIS
  // 20. OROG
  // 21. GNOLL
  // 22. LICHE
  // 23. UMBRA
  // Restricciones: nunca buenos
if (iRacialType == RACIAL_TYPE_MINOTAURO   || iRacialType == RACIAL_TYPE_ORCO_MONTANA  || iRacialType == RACIAL_TYPE_OSGO          ||
    iRacialType == RACIAL_TYPE_TRASGO      || iRacialType == RACIAL_TYPE_GRAN_TRASGO   || iRacialType == RACIAL_TYPE_KOBOLD        ||
    iRacialType == RACIAL_TYPE_OGRO        || iRacialType == RACIAL_TYPE_SEMIOGRO      || iRacialType == RACIAL_TYPE_OGROHECHICERO ||
    iRacialType == RACIAL_TYPE_DROW        || iRacialType == RACIAL_TYPE_DUERGAR       || iRacialType == RACIAL_TYPE_GNOLL         ||
    sSubraza == "svirfneblin"              || sSubraza == "semidrow"                   || sSubraza == "ghul"                       ||
    sSubraza == "vampiro"                  || sSubraza == "semiinfernal"               || sSubraza == "githyanki"                  ||
    sSubraza == "orco gris"                || sSubraza == "orog"                       || sSubraza == "liche"                      ||
    sSubraza == "necropolita"              || sSubraza == "deathknight"                || sSubraza == "umbra")
  {
      // Restricciones: Ninguna si es drow o semidrow de superficie
      int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");
      int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
      if(iSemidrowSuperficie == 1) return FALSE;
      if(iDrowSuperficie == 1) return FALSE;

      if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;

      return FALSE;
  }

  // 24. LYTHARI
  // 25. AASIMAR
  // 26. SEMICELESTIAL
  // Restricciones: nunca malignos
  else if(sSubraza == "lythari" || iRacialType == RACIAL_TYPE_AASIMAR || sSubraza == "semicelestial")
  {
      if(GetGoodEvilValue(oPC) == ALIGNMENT_EVIL) return TRUE;

      return FALSE;
  }

  // 27. SEMIFATA
  // Restricciones: nunca legales
  else if(sSubraza == "semifata")
  {
      if(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) return TRUE;

      return FALSE;
  }

  // 28. LICANTROPO
  // Restricciones: alineamientos especiales en cada tipo
  else if(sSubraza == "licantropo")
  {
      if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "gato")
      {
          if(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) return TRUE;
          if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) return TRUE;
      }
      else if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "lobo")
      {
          if(GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) return TRUE;
          if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;
      }
      else if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "murcielago")
      {
          if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;
      }
      else if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "oso")
      {
          if(GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC) return TRUE;
          if(GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL) return TRUE;
      }
      else if(ObtenerStringPersistente(oPC, "TIPOLICANTROPO") == "rata")
      {
          if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;
          if (GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC) return TRUE;
          if (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) return TRUE;
      }

      return FALSE;
  }

  // NUEVAS RAZAS
  // 29. FEY'RI
  // Restricciones: No buenos y no neutrales (excepto NM)
  else if (iRacialType == RACIAL_TYPE_FEYRI) {
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;
    if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) return TRUE;
    if (GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL && GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL) return TRUE;

    return FALSE;
  }

  // 30. KENKU
  // Restricciones: Neutrales auténticos o neutrales malignos
  else if (iRacialType == RACIAL_TYPE_KENKU) {
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_GOOD) return TRUE;

    return FALSE;
  }

  // 31. MEDIANO FORTECOR
  // Restricciones: No malignos
  else if (iRacialType == RACIAL_TYPE_FORTECOR) {
    if (GetGoodEvilValue(oPC) == ALIGNMENT_EVIL) return TRUE;

    return FALSE;
  }

  // 32. TANARUKK
  // Restricciones: No buenos, caóticos o neutrales malignos
  else if (iRacialType == RACIAL_TYPE_TANARUKK) {
    if (GetGoodEvilValue(oPC) == ALIGNMENT_GOOD) return TRUE;
    if (GetAlignmentLawChaos(oPC) == ALIGNMENT_LAWFUL) return TRUE;
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_NEUTRAL && GetAlignmentLawChaos(oPC) == ALIGNMENT_NEUTRAL) return TRUE;

    return FALSE;
  }

  // 32. ENANO AZERBLOOD
  // Restricciones: Legales no malignos
  else if (iRacialType == RACIAL_TYPE_AZERBLOOD) {
    if (GetGoodEvilValue(oPC) == ALIGNMENT_EVIL) return TRUE;
    if (GetAlignmentLawChaos(oPC) != ALIGNMENT_LAWFUL) return TRUE;

    return FALSE;
  }

  // 33. TUMULARIO
  // Restricciones: Legales malignos o neutrales maligno
  else if (iRacialType == RACIAL_TYPE_WIGHT) {
    if (GetGoodEvilValue(oPC) == ALIGNMENT_GOOD) return TRUE;
    if (GetGoodEvilValue(oPC) == ALIGNMENT_NEUTRAL) return TRUE;
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL && GetAlignmentLawChaos(oPC) == ALIGNMENT_CHAOTIC) return TRUE;

    return FALSE;
  }

  // 34. ENGENDRO VAMPÍRICO
  // Restricciones: Malignos
  else if (sSubraza == "engendro") {
    if (GetGoodEvilValue(oPC) == ALIGNMENT_GOOD) return TRUE;
    if (GetGoodEvilValue(oPC) == ALIGNMENT_NEUTRAL) return TRUE;

    return FALSE;
  }

  return FALSE;
}

void DestruirCopiarObjetosManosTransformacionesSubrazas(object oPC)
{
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  object oManoDer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(oManoIzq != OBJECT_INVALID)
  {
      CopyItem(oManoIzq, oPC, TRUE);
      DestroyObject(oManoIzq, 0.1);
  }
  if(oManoDer != OBJECT_INVALID) AssignCommand(oPC, ActionUnequipItem(oManoDer));
  {
      CopyItem(oManoDer, oPC, TRUE);
      DestroyObject(oManoDer, 0.1);
  }
}

void DestruirCopiarArmaduraTransformacionesSubrazas(object oPC)
{
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
  int iCABase = GetArmorType(oArmadura);
  if(oArmadura != OBJECT_INVALID && iCABase > 5)
  {
      CopyItem(oArmadura, oPC, TRUE);
      DestroyObject(oArmadura, 0.1);
  }
}

void DesequiparObjetosManosTransformacionesSubrazas(object oPC)
{
  object oManoIzq = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
  object oManoDer = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(oManoIzq != OBJECT_INVALID) AssignCommand(oPC, ActionUnequipItem(oManoIzq));
  if(oManoDer != OBJECT_INVALID) AssignCommand(oPC, ActionUnequipItem(oManoDer));
}

void DesequiparObjetosArmaduraTransformacionesSubrazas(object oPC)
{
  object oArmadura = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
  int iCABase = GetArmorType(oArmadura);
  if(oArmadura != OBJECT_INVALID && iCABase > 5) AssignCommand(oPC, ActionUnequipItem(oArmadura));
}

void AplicarNombreRazaBase(object oPC)
{
  if(GetRacialType(oPC) == RACIAL_TYPE_ELF) {
    SetSubRace(oPC, "Elfo Lunar");
    GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);
  }

  else if(GetRacialType(oPC) == RACIAL_TYPE_DWARF) {
    SetSubRace(oPC, "Enano Escudo");
    GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);
  }

  else if(GetRacialType(oPC) == RACIAL_TYPE_GNOME) {
    SetSubRace(oPC, "Gnomo de las Rocas");
    GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);
  }

  else if(GetRacialType(oPC) == RACIAL_TYPE_HALFLING) {
    SetSubRace(oPC, "Mediano Piesligeros");
    GuardarIntPersistente(oPC, "LETO_APLICADO", TRUE);
  }
}

//void main(){}
