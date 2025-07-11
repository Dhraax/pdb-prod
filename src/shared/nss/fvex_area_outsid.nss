////////////////////////////////////////////////////////////////////////////////
//:: SCRIPT DE GUARDADO DE CIUDADES                                         :://
//:: Nota: fvex_mod_clntent y fvex_area_outsid deben ser iguales            :://
////////////////////////////////////////////////////////////////////////////////

#include "f_vampire_area_h"
#include "mti_libreria"
#include "cle_inc"
#include "alintemplos_inc"
#include "meteo_library"
#include "X0_I0_SPELLS"
#include "inc_generic"
#include "pb_inc_mmf"

void main()
{

  object oPC = GetEnteringObject();

  //Scripts para añadir los pnj del área.
  ExecuteScript("z0_area_onenter", oPC);

 //Encuentros aleatorios
  if(GetLocalInt(OBJECT_SELF, "SPAWN_ENCUENTRO") > 0) ExecuteScript ("enc_onenter", OBJECT_SELF);

   //Trampas aleatorias
  if(GetLocalInt(OBJECT_SELF, "TRAMPA_TIPO") > 0) ExecuteScript("pb_trampas_enter", OBJECT_SELF);

   //Area de PVP
  if(GetLocalInt(OBJECT_SELF, "AREA_PVP") > 0) ExecuteScript("cambatalla_enter", OBJECT_SELF);

  //Cambiar el clima del area según la estación de año y la zona geográfica
  //Cuando un pj entra en un área exterior comprobar si se le ha cambiado el clima
  //según se ha establecido para su zona geográfica.
  object oArea = GetArea(oPC);
  if (GetLocalInt(oArea, "CAMB_CLIMA")==0)
  {
        Obtener_Clima(GetLocalInt(oArea,"ZONA_CLIMA"), oArea, oPC);

  }
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));

  // Subrazas: Bonos de los vampiros
  Vampire_Enter(oPC, TRUE);

  // Maestro Multiples Formas
  OnEnterLoadPolymorphed(oPC);

  // Subrazas: Bonos de los umbras
  if(sSubraza == "umbra")
  {
      int iBonosUmbra = GetLocalInt(oPC, "BONOS_UMBRA");

      if(iBonosUmbra == FALSE && GetIsNight()) // Se aplican los bonos en areas de exterior solo si es de noche
      {
          FloatingTextStringOnCreature("<c´þd>* Te sientes fortalecido en las sombras *</c>", oPC, FALSE);
          SetLocalInt(oPC, "BONOS_UMBRA", TRUE);
          ReaplicarEfectosPB(oPC, TRUE);
      }

      else if(iBonosUmbra == TRUE && !GetIsNight()) // Se disipan los bonos en areas de exterior si es de dia
      {
          FloatingTextStringOnCreature("<cþ<<>* Te sientes débil expuesto a la luz *</c>", oPC, FALSE);
          DeleteLocalInt(oPC, "BONOS_UMBRA");
          ReaplicarEfectosPB(oPC, TRUE);
      }
  }


  // Subrazas: Ceguera de las razas de la antipoda oscura
  ExecuteScript("pb_subceguera", oPC);

  // Aviso para los propietarios de Palabra de Regreso
  cle_warning(oPC);

  // Areas sacralizadas
  alineamiento_templo(oPC);

    // Areas exploradas
    if(GetLocalInt(OBJECT_SELF, "AREA_EXPLORADA") == TRUE) ExploreAreaForPlayer(OBJECT_SELF, oPC, TRUE);

    // MEMORIZAR CIUDAD VISITADA
    // 1. Athkatla
    string sArea = GetTag(GetArea(oPC));
    if(sArea == "aht_llanos")
    {
        if(ObtenerIntPersistente(oPC, "TEL_ATHKATLA") == FALSE) GuardarIntPersistente(oPC, "TEL_ATHKATLA", TRUE);
    }
    // 2. Agujas de Oro
    else if(sArea == "gls_aguaoro")
    {
        if(ObtenerIntPersistente(oPC, "TEL_AGUJASORO") == FALSE) GuardarIntPersistente(oPC, "TEL_AGUJASORO", TRUE);
    }
    // 3. Crimmor
    else if(sArea == "CMMO")
    {
        if(ObtenerIntPersistente(oPC, "TEL_CRIMMOR") == FALSE) GuardarIntPersistente(oPC, "TEL_CRIMMOR", TRUE);
    }
    // 4. Purskul
    else if(sArea == "kro_pursk")
    {
        if(ObtenerIntPersistente(oPC, "TEL_PURSKUL") == FALSE) GuardarIntPersistente(oPC, "TEL_PURSKUL", TRUE);
    }
    // 5. Imnescar
    else if(sArea == "tyr_imnescar")
    {
        if(ObtenerIntPersistente(oPC, "TEL_IMNESCAR") == FALSE) GuardarIntPersistente(oPC, "TEL_IMNESCAR", TRUE);
    }
    // 6. Nashkel
    else if(sArea == "ko_nashkel")
    {
        if(ObtenerIntPersistente(oPC, "TEL_NASHKEL") == FALSE) GuardarIntPersistente(oPC, "TEL_NASHKEL", TRUE);
    }
    // 8. Caravasar
     else if(sArea == "kro_mercadere001")
    {
        if(ObtenerIntPersistente(oPC, "TEL_CARAVASAR") == FALSE) GuardarIntPersistente(oPC, "TEL_CARAVASAR", TRUE);
    }
    // 9. Murann
     else if(sArea == "kro_murann_port")
    {
        if(ObtenerIntPersistente(oPC, "TEL_MURANN") == FALSE) GuardarIntPersistente(oPC, "TEL_MURANN", TRUE);
    }
    // 10. Gambiton
    else if(sArea == "kro_gambiton")
    {
        if(ObtenerIntPersistente(oPC, "TEL_GAMBITON") == FALSE) GuardarIntPersistente(oPC, "TEL_GAMBITON", TRUE);
    }
    // 11. Suldanessalar
    else if(sArea =="luc_sulda_01")
    {
        if(ObtenerIntPersistente(oPC, "TEL_SULDA") == FALSE) GuardarIntPersistente(oPC, "TEL_SULDA", TRUE);
    }

//EVENTO PARA GUARDAR EL PJ AL CAMBIAR DE AREA
  string sEtiquetaDeAreaGuardada = GetLocalString(oPC, "AREA_GUARDARPJ");
  if(sEtiquetaDeAreaGuardada != sArea)
    {
     if (GetIsObjectValid(oPC) && GetIsPC(oPC) && !GetHasEffect(EFFECT_TYPE_POLYMORPH, oPC)){
        SetLocalString(oPC, "AREA_GUARDARPJ", sArea);
        ExportSingleCharacter(oPC);
        }
    }

    //Parche de Varacho.
    if(GetLocalInt(oPC,"ARENA") > 0)
    {
        if(GetEventScript(OBJECT_SELF, EVENT_SCRIPT_AREA_ON_ENTER) != "arena_entrar")
        {
            DeleteLocalInt(oPC, "ARENA");
        }
    }
}

