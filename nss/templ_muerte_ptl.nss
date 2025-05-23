void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "activador_portal")== OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "Parace que necesitas algo para activar el portal.");
      return;
  }

  if(GetLevelByClass(CLASS_TYPE_CLERIC, oPC) >0 ||
     GetLevelByClass(CLASS_TYPE_PALADIN, oPC)>0)
  {
      object oTarget = GetWaypointByTag("cielo_muerte");
      location lTarget = GetLocation(oTarget);

      if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

      DelayCommand(2.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oTarget));

      object oItem = GetItemPossessedBy(oPC, "activador_portal");
      if(GetIsObjectValid(oItem)) DestroyObject(oItem);
  }

  else
  {
      FloatingTextStringOnCreature("Una poderosa magia te impide usar el portal. Por lo visto, sólo los cazadores de muertos vivientes pueden atravesarlo.", oPC);
  }
}
