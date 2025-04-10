#include "pb_constantes"

// FACCIONES PERSONALIZADAS EN JUGADORES
void main()
{
  object oPC = GetEnteringObject();
  object oDef =   GetObjectByTag("faccion_defensor");
  object oDrow =  GetObjectByTag("faccion_drow");
  object oVamp =  GetObjectByTag("faccion_vampiro");
  object oRazas = GetObjectByTag("faccion_razas");
  object oPlebeyos =GetObjectByTag("faccion_plebeyo");
  int nRacialType = GetRacialType(oPC);
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  // Siempre amigos de las Razas Antiguas
  AdjustReputation(oPC,oRazas,100); // Amigos con las Razas antiguas
  AdjustReputation(oRazas,oPC,100);

  // Siempre amigos de los plebeyos
  AdjustReputation(oPC, oPlebeyos, 100);
  AdjustReputation(oPlebeyos, oPC, 100);

  // Aliado de los Vampiros (si tienes el objeto, los vampiros no te salen hostiles)
  if (GetItemPossessedBy(oPC, "aliadovampis") != OBJECT_INVALID ||
      GetItemPossessedBy(oPC, "runa_retorcida") != OBJECT_INVALID ||
      GetItemPossessedBy(oPC, "mascara_nocturna") != OBJECT_INVALID ||
      GetItemPossessedBy(oPC, "lugarteniente_mascaras") != OBJECT_INVALID)
  {
      AdjustReputation(oPC,oVamp,100); // Amigos con los vampiros
      AdjustReputation(oVamp,oPC,100);
  }

  // Aliado de Murann (si tienes el objeto, las razas antiguas no te salen hostiles)
  if (GetItemPossessedBy(oPC, "aliadomurann") != OBJECT_INVALID)
  {
      AdjustReputation(oPC,oRazas,100); // Amigos con las Razas antiguas
      AdjustReputation(oRazas,oPC,100);
  }

  // Aliado de los drows (si tienes el objeto, los drows no te salen hostiles)
  if (GetItemPossessedBy(oPC, "aliadodrow") != OBJECT_INVALID)
  {
      AdjustReputation(oPC,oDrow,100); // Amigos con los drows
      AdjustReputation(oDrow,oPC,100);
  }

  // Ajustes antipoda oscura
  if (sSubraza == "drow" || sSubraza == "duergar" || sSubraza == "svirfneblin" ||
     sSubraza == "semidrow" || sSubraza == "githyanki")
  {
      AdjustReputation(oPC,oDrow,100); // Amigos con los drows
      AdjustReputation(oDrow,oPC,100);

      // Aliado de los Defensores (si tienes el objeto, los defensores no te salen hostiles)
      if(GetItemPossessedBy(oPC, "aliadoanm") != OBJECT_INVALID)
      {
          AdjustReputation(oPC, oDef, 100); // Amigos con los defensores
          AdjustReputation(oDef, oPC, 100);
      }
      else
      {
          AdjustReputation(oPC,oDef,-100); // Enemigos con los defensores
          AdjustReputation(oDef,oPC,-100);
      }
  }

  // Ajustes vampiros
  else if (sSubraza == "vampiro" || sSubraza == "engendro" || nRacialType == RACIAL_TYPE_WIGHT)
  {
      AdjustReputation(oPC,oVamp,100); // Amigos con los vampiros
      AdjustReputation(oVamp,oPC,100);
  }

  // El resto de PJs son amigos con los defensores
  else
  {
      AdjustReputation(oPC, oDef, 100); // Amigos con los defensores
      AdjustReputation(oDef, oPC, 100);
  }
}
