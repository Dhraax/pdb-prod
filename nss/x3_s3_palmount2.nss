//::///////////////////////////////////////////////
//:: Summon Paladin Mount
//:: x3_s3_palmount
//:: Copyright (c) 2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     This script handles the summoning of the paladin mount.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: 2007-18-12
//:: Last Update: March 29th, 2008
//:://////////////////////////////////////////////

#include "cab_inc"

void main()
{
  object oPC = OBJECT_SELF;
  string sMontura;
  int iNivelPaladin = GetLevelByClass(CLASS_TYPE_PAL_ANTIGUO, oPC);

  if(GetSpellId() != 1432) return;

  // Desconvocar montura
  object oAyudante1 = GetHenchman(oPC, 1);
  object oAyudante2 = GetHenchman(oPC, 2);
  object oAyudante3 = GetHenchman(oPC, 3);
  if(VerSiEsMonturaConvocada(oAyudante1) == TRUE ||
     VerSiEsMonturaConvocada(oAyudante2) == TRUE ||
     VerSiEsMonturaConvocada(oAyudante3) == TRUE)
  {
      object oMonturaDesconvocada = GetHenchman(oPC);
      if(GetTag(GetHenchman(oPC, 2)) == "cab_monturaconv") oMonturaDesconvocada = GetHenchman(oPC, 2);
      else if(GetTag(GetHenchman(oPC, 3)) == "cab_monturaconv") oMonturaDesconvocada = GetHenchman(oPC, 3);

      FloatingTextStringOnCreature("* Desconvocas tu montura *", oPC, FALSE);
      RemoveHenchman(oPC, oMonturaDesconvocada);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oMonturaDesconvocada);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), oMonturaDesconvocada);
      return;
  }

  // Si no sabemos montar a caballo, nanay
  if(ObtenerIntPersistente(oPC, "NIVELEQUITACION") == 0)
  {
      DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
      FloatingTextStringOnCreature("<cüGB>No sabes montar a caballo, necesitas que alguien te enseñe.</c>", oPC, FALSE);
      return;
  }

  // Ya estamos montados en cualquier montura
  // Posibles situaciones:
  // 1. No podemos usar la habilidad (monturas normales)
  // 2. Nos desmontamos (monturas convocadas)
  int iMontado = ObtenerIntPersistente(oPC, "CAB_MONTADO");
  if(iMontado > 0)
  {
      if(iMontado == 1 || iMontado == 2)
      {
          DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
          FloatingTextStringOnCreature("<cüGB>No puedes convocar tu montura cuando ya tienes una.</c>", oPC, FALSE);
          return;
      }
      else
      {
          // Cuatros aspectos basicos a la normalidad
          int iMontado = ObtenerIntPersistente(oPC, "CAB_MONTADO");
          if(iMontado == 3)
          {
              int iAparienciaguardada = ObtenerIntPersistente(oPC, "CABAPARIENCIA");
              int iColaGuardada = ObtenerIntPersistente(oPC, "CABCOLA");
              SetCreatureAppearanceType(oPC, iAparienciaguardada);
              SetCreatureTailType(iColaGuardada, oPC);
          }

          int iFenotipoGuardado = ObtenerIntPersistente(oPC, "CABFENTIPO");
          int iSonidosPasosGuardados = ObtenerIntPersistente(oPC, "CABSONIDOSPASOS");
          SetPhenoType(iFenotipoGuardado, oPC);
          SetFootstepType(iSonidosPasosGuardados, oPC);

          // Creamos la montura y la unimos
          int iAparienciaNuevaPJ = GetAppearanceType(oPC);
          if(iAparienciaNuevaPJ == 2 || iAparienciaNuevaPJ == 3) sMontura = "cab_cabraconvo"; // Poni de guerra
          else sMontura = "cab_ciervoconvo"; // Caballo de guerra pesado
          object oMontura = CreateObject(OBJECT_TYPE_CREATURE, sMontura, GetLocation(oPC));
          AddHenchman(oPC, oMontura);

          // Nombres y variables
          SetName(oMontura, GetName(oMontura) + " de " + GetName(oPC));
          SetLocalObject(oPC, "MONTURACONVOCADA", oMontura);
          SetLocalString(oMontura, "AMO", GetName(oPC));
          GuardarIntPersistente(oPC, "CAB_MONTADO", 0);

          // Niveles de la montura
          while(iNivelPaladin != 1)
          {
              LevelUpHenchman(oMontura, CLASS_TYPE_MAGICAL_BEAST);
              iNivelPaladin = iNivelPaladin - 1;
          }

          // Vida de la montura
          effect eDanyo = EffectDamage(GetMaxHitPoints(oMontura) - ObtenerIntPersistente(oPC, "CABVIDA"));
          ApplyEffectToObject(DURATION_TYPE_INSTANT, eDanyo, oMontura);
          GuardarIntPersistente(oPC, "CABVIDA", 0);

          // Quitamos efectos monturas
          ReaplicarEfectosPB(oPC,TRUE,FALSE, TRUE);

          // Usos de la dote
          DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
          return;
      }
  }

  // No se pueden tener mas de 3 de ayudantes
  if(oAyudante1 != OBJECT_INVALID &&
     oAyudante2 != OBJECT_INVALID &&
     oAyudante3 != OBJECT_INVALID)
  {
      DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
      FloatingTextStringOnCreature("<cüGB>No puedes tener más de 3 ayudantes a la vez.</c>", oPC, FALSE);
      return;
  }

  // No nos podemos montar cuando tenemos alguna forma rara
  int iAparienciaPJ = GetAppearanceType(oPC);
  int iFenotipoPJ = GetPhenoType(oPC);
  if(iAparienciaPJ > 6 || (iFenotipoPJ > 2 && iFenotipoPJ != 4))
  {
      DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
      FloatingTextStringOnCreature("<cüGB>No puedes llamar a una montura con esa apariencia o fenotipo.</c>", oPC, FALSE);
      return;
  }

  // Intentamos convocar la montura pero ya llamamos anteriormente otra
  // Posibles situaciones:
  // 1. Que nos avisen de que antes de continuar fijemos como muerta la otra montura si es que no la tenemos en el grupo
  // 2. Que no nos dejen usar la montura porque ya tenemos otra activa y viva
  object oMonturaUsada = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oMonturaUsada) == TRUE)
  {
      if(GetTag(oMonturaUsada) == "cab_montura" &&
         GetItemCursedFlag(oMonturaUsada) == TRUE &&
         GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
      {
          if(VerSiEsMontura(oAyudante1) == FALSE &&
             VerSiEsMontura(oAyudante2) == FALSE &&
             VerSiEsMontura(oAyudante3) == FALSE)
          {
              DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
              SetLocalInt(oPC, "CAB_POSIBLEMUERTO", 2);
              SetLocalObject(oPC, "CAB_POSIBLEMUERTO", oMonturaUsada);
              AssignCommand(oPC, ClearAllActions(TRUE));
              AssignCommand(oPC, ActionStartConversation(oPC, "cab_animalmuerto", TRUE, FALSE));
              return;
          }

          else
          {
              DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
              FloatingTextStringOnCreature("<cüGB>No puedes convocar tu montura cuando ya tienes una.</c>", oPC, FALSE);
              return;
          }
      }

      oMonturaUsada = GetNextItemInInventory(oPC);
  }

  // Sin usos, hay que dormir
  if(ObtenerIntPersistente(oPC, "MONTURACONVOCADA") == TRUE)
  {
      DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));
      FloatingTextStringOnCreature("<cüGB>Tendrás que dormir para usar la habilidad de nuevo.</c>", oPC, FALSE);
      return;
  }

  // CREAMOS LA MONTURA PERFECTAMENTE!

  // Antes de nada, destruimos la anterior montura convocada, si existe
  object oMonturaGuardada = GetLocalObject(oPC, "MONTURACONVOCADA");
  if(oMonturaGuardada != OBJECT_INVALID)
  {
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), oMonturaGuardada);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), oMonturaGuardada);
  }

  // Apariencias, efectos, variables y demas ajustes varios
  if(iAparienciaPJ == 2 || iAparienciaPJ == 3) sMontura = "cab_cabraconvo"; // Poni de guerra
  else sMontura = "cab_ciervoconvo"; // Caballo de guerra pesado
  object oMontura = CreateObject(OBJECT_TYPE_CREATURE, sMontura, GetLocation(oPC));
  ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_MONSTER_2), GetLocation(oMontura));
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY), oMontura, 2.2);
  SetName(oMontura, GetName(oMontura) + " de " + GetName(oPC));
  AddHenchman(oPC, oMontura);
  SetLocalString(oMontura, "AMO", GetName(oPC));
  SetLocalObject(oPC, "MONTURACONVOCADA", oMontura);
  GuardarIntPersistente(oPC, "MONTURACONVOCADA", TRUE);
  DelayCommand(1.0,IncrementRemainingFeatUses(oPC,1731));

  // Niveles de la montura
  while(iNivelPaladin != 1)
  {
      LevelUpHenchman(oMontura, CLASS_TYPE_MAGICAL_BEAST);
      iNivelPaladin = iNivelPaladin - 1;
  }
}
