void main()
{
  object oPC = GetLastUsedBy();

  if(GetItemPossessedBy(oPC, "uri_runashatar")== OBJECT_INVALID)
  {
      SendMessageToPC(oPC, "Algo te impide usar el portal, parace que necesitas algo para activarlo.");
      return;
  }

  else
  {
      object oTarget = GetWaypointByTag("uri_portalshatar2");
      location lTarget = GetLocation(oTarget);

      if(GetAreaFromLocation(lTarget)==OBJECT_INVALID) return;

      DelayCommand(2.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(3.0, AssignCommand(oPC, ActionJumpToLocation(lTarget)));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), GetLocation(oTarget));

      object oItem = GetItemPossessedBy(oPC, "uri_runashatar");
      if(GetIsObjectValid(oItem)) DestroyObject(oItem);

      FloatingTextStringOnCreature("El portal se activa al detectar la runa de activación, la cual es consumida una vez terminado el portal de activarse.", oPC);
  }
}
