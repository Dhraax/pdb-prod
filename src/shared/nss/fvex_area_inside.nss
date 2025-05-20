#include "f_vampire_area_h"
#include "cle_inc"
#include "alintemplos_inc"
#include "X0_I0_SPELLS"
#include "inc_generic"
#include "pb_inc_mmf"

void main()
{

  object oPC = GetEnteringObject();
  //Scripts para añadir los pnj del área.
  ExecuteScript ("z0_area_onenter", oPC);
  // Subrazas: Bonos de los vampiros
  Vampire_Enter(oPC, FALSE);

  // Maestro Multiples Formas
  OnEnterLoadPolymorphed(oPC);

  //Encuentros aleatorios
  if(GetLocalInt(OBJECT_SELF, "SPAWN_ENCUENTRO") > 0) ExecuteScript ("enc_onenter", OBJECT_SELF);

  //Trampas aleatorias
  if(GetLocalInt(OBJECT_SELF, "TRAMPA_TIPO") > 0) ExecuteScript("pb_trampas_enter", OBJECT_SELF);

   //Area de PVP
  if(GetLocalInt(OBJECT_SELF, "AREA_PVP") > 0) ExecuteScript("cambatalla_enter", OBJECT_SELF);

  // Subrazas: Bonos de los umbras
  if(GetStringLowerCase(GetSubRace(oPC)) == "umbra")
  {
      int iBonosUmbra = GetLocalInt(oPC, "BONOS_UMBRA");

      if(iBonosUmbra == FALSE) // Se aplican los bonos en areas de interior siempre
      {
          FloatingTextStringOnCreature("<c´þd>* Te sientes fortalecido en las sombras *</c>", oPC, FALSE);
          SetLocalInt(oPC, "BONOS_UMBRA", TRUE);
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
  string sArea = GetTag(GetArea(oPC));
 // 1. Emnekhul
  if(sArea =="sad_emnekhul")
  {
      if(ObtenerIntPersistente(oPC, "TEL_NECRO") == FALSE) GuardarIntPersistente(oPC, "TEL_NECRO", TRUE);
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
