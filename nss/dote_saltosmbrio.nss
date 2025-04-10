//::///////////////////////////////////////////////
//:: DOTE SALTO SOMBRIO
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Este script regula la nueva dote "Salto Sombrio"
    de los danzarines sombrios.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 29 de Marzo de 2011
//:://////////////////////////////////////////////

#include "x2_inc_spellhook"
#include "mti_libreria"

void main()
{
  /*
    Spellcast Hook Code
    Added 2003-07-07 by Georg Zoeller
    If you want to make changes to all spells,
    check x2_inc_spellhook.nss to find out more
  */

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }

  // End of Spell Cast Hook

  //Declare major variables
  object oLanzador = OBJECT_SELF;
  location lObjetivo = GetSpellTargetLocation();
  float fMetros = 60.0;
  int iDoteAAumentar = 1275;

  if(GetHasFeat(1278, oLanzador) == TRUE) { fMetros = 60.0; iDoteAAumentar = 1278;}
  else if(GetHasFeat(1277, oLanzador) == TRUE) { fMetros = 45.0; iDoteAAumentar = 1277;}
  else if(GetHasFeat(1276, oLanzador) == TRUE) { fMetros = 30.0; iDoteAAumentar = 1276;}
  else if(GetHasFeat(1275, oLanzador) == TRUE) { fMetros = 15.0; iDoteAAumentar = 1275;}

  // Ancla dimensional
  if(GetHasSpellEffect(990))
  {
      FloatingTextStringOnCreature("<cþ<<>El ancla dimensional te impide usar Salto sombrío.</c>", OBJECT_SELF);
	  IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // Sobre montura nanay
  if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
  {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>No puedes realizar un salto sombrío cuando estás montado a caballo.</c>");
	  IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // En ciertas areas no se podra hacer el salto sombrio
  if(GetLocalInt(GetArea(oLanzador), "NOPUERTADIMENSIONAL") == 1)
  {
      SendMessageToPC(oLanzador, "Este conjuro no se puede usar aquí, algo te lo impide.");
      IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oLanzador) || GetLocalInt(oLanzador, "DERRIBADO") || GetLocalInt(oLanzador, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oLanzador);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oLanzador);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes saltar en las sombras *</c>", OBJECT_SELF, FALSE);
	  IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // No puedes saltar donde no ves
  vector oVector1 = GetPositionFromLocation(GetLocation(oLanzador));
  vector oVector2 = GetPositionFromLocation(lObjetivo);
  if(!LineOfSightVector(oVector1, oVector2))
  {
      FloatingTextStringOnCreature("<cþ<<>* No puedes saltar donde no ves *</c>", OBJECT_SELF, FALSE);
	  IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // Limitacion de distancia
  if(GetDistanceBetweenLocations(GetLocation(oLanzador), lObjetivo) > fMetros)
  {
      SendMessageToPC(oLanzador, "¡No puedes hacer un salto sombrío tan largo! Sólo puedes saltar "+FloatToString(fMetros, 2, 0)+" metros.");
      IncrementRemainingFeatUses(oLanzador, iDoteAAumentar);
      return;
  }

  // Vamos con el salto
  effect eGrasa = EffectAreaOfEffect(AOE_PER_GREASE, "****", "****", "****");
  effect eNegrata = EffectVisualEffect(1599);
  effect eEstelaNegra = EffectVisualEffect(816);

  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oLanzador, 2.2);
  ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eGrasa, GetLocation(oLanzador), 2.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eNegrata, oLanzador, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEstelaNegra, oLanzador, 5.0);
  AssignCommand(oLanzador, PlayAnimation(ANIMATION_FIREFORGET_STEAL));
  DelayCommand(2.0, AssignCommand(oLanzador, ActionJumpToLocation(lObjetivo)));
  DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eGrasa, lObjetivo, 4.0));
}

