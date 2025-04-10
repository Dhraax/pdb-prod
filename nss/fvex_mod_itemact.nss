// Portales de la Bolsa Planar

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetLastUsedBy();

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC, 1) == FALSE) return;

  // LOCALIZACIONES
  string sMensaje = "<cö-->No puedes teletransportarte sin haber estado en dicho sitio antes.</c>";
  string sPortal = GetTag(OBJECT_SELF);
  location lCrimmor = GetLocation(GetWaypointByTag("crimmor_tel"));
  location lImnescar = GetLocation(GetWaypointByTag("imnescar_tel"));
  location lPurskul = GetLocation(GetWaypointByTag("purskul_tel"));
  location lAmnagua = GetLocation(GetWaypointByTag("amnagua_tel"));
  location lNashkel = GetLocation(GetWaypointByTag("nashkel_tel"));
  location lBrynnley = GetLocation(GetWaypointByTag("brynnley_tel"));
  location lValleMisnor = GetLocation(GetWaypointByTag("vallemisnor_tel"));
  location lCaravasar = GetLocation(GetWaypointByTag("caravasar_tel"));
  location lIdeepton = GetLocation(GetWaypointByTag("ideepton_tel"));
  location lEsmeltaran = GetLocation(GetWaypointByTag("esmeltaran_tel"));
  location lEdive = GetLocation(GetWaypointByTag("edive_tel"));
  location lSkaug = GetLocation(GetWaypointByTag("skaug_tel"));
  location lMintarn = GetLocation(GetWaypointByTag("uri_Mintarn_tel"));
  location lEmnekhul = GetLocation(GetWaypointByTag("asy_Emnekhul_tel"));

  // CRIMMOR
  if(sPortal == "bp_portal_crimmor")
  {
      if(ObtenerIntPersistente(oPC, "TEL_CRIMMOR") == TRUE) Teletransporte(oPC, lCrimmor);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // IMNESCAR
  else if(sPortal == "imnescar")
  {
      if(ObtenerIntPersistente(oPC, "TEL_IMNESCAR") == TRUE) Teletransporte(oPC, lImnescar);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // PURSKUL
  else if(sPortal == "purskul")
  {
      if(ObtenerIntPersistente(oPC, "TEL_PURSKUL") == TRUE) Teletransporte(oPC, lPurskul);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // AMNAGUA
  else if(sPortal == "amnagua")
  {
      if(ObtenerIntPersistente(oPC, "TEL_AMNAGUA") == TRUE) Teletransporte(oPC, lAmnagua);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // NASHKEL
  else if(sPortal == "nashkel")
  {
      if(ObtenerIntPersistente(oPC, "TEL_NASHKEL") == TRUE) Teletransporte(oPC, lNashkel);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // BRYNNLEY
  else if(sPortal == "brynnley")
  {
      if(ObtenerIntPersistente(oPC, "TEL_BRYNNLEY") == TRUE) Teletransporte(oPC, lBrynnley);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // VALLE MISNOR
  else if(sPortal == "valle_misnor")
  {
      if(ObtenerIntPersistente(oPC, "TEL_VALLEMISNOR") == TRUE) Teletransporte(oPC, lValleMisnor);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // ESMELTARAN
  else if(sPortal == "esmeltaran")
  {
      if(ObtenerIntPersistente(oPC, "TEL_ESMELTARAN") == TRUE) Teletransporte(oPC, lEsmeltaran);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // EDIVE
  else if(sPortal == "edive")
  {
      if(ObtenerIntPersistente(oPC, "TEL_EDIVE") == TRUE) Teletransporte(oPC, lEdive);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // SKAUG
  else if(sPortal == "skaug")
  {
      if(ObtenerIntPersistente(oPC, "TEL_SKAUG") == TRUE) Teletransporte(oPC, lSkaug);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

  // MINTARN
  else if(sPortal == "mintarn")
  {
      if(ObtenerIntPersistente(oPC, "TEL_MINTARN") == TRUE) Teletransporte(oPC, lMintarn);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }


  // CARAVASAR
  else if(sPortal == "caravasar")
  {
      if(ObtenerIntPersistente(oPC, "TEL_CARAVASAR") == TRUE) Teletransporte(oPC, lCaravasar);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

 // EMNEKHUL
  else if(sPortal == "emnekhul")
  {
      if(ObtenerIntPersistente(oPC, "TEL_NECRO") == TRUE) Teletransporte(oPC, lEmnekhul);
      else FloatingTextStringOnCreature(sMensaje, oPC);
  }

}
