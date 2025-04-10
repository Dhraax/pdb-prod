void TeletransporteArcanum(object oPC, location lLugar)
{
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oPC);
  DelayCommand(0.8,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DEATH_WARD), oPC));
  DelayCommand(1.6,ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BREACH), oPC));
  DelayCommand(2.1, AssignCommand(oPC, ClearAllActions()));
  DelayCommand(2.2, AssignCommand(oPC, ActionJumpToLocation(lLugar)));
}

void main()
{
  object oPC = GetLastUsedBy();
  string oPortal = GetTag(OBJECT_SELF);

  if(oPortal == "ae_portal_principal")
  {
    if(GetItemPossessedBy(oPC, "diplomaestarc") == OBJECT_INVALID)
    {
        SendMessageToPC(oPC, "<cþ<<>Necesitas poseer un diploma de estudiante asiduo en la academia para poder acceder a las habitaciones privadas.</c>");
        return;
    }

    TeletransporteArcanum(oPC, GetLocation(GetWaypointByTag("ae_interior1")));
    return;
  }

  else if(oPortal == "ae_aentrada")
  {
      TeletransporteArcanum(oPC, GetLocation(GetWaypointByTag("ae_exterior1")));
      return;
  }

  else if(oPortal == "ae_aprofesores")
  {
      if(GetItemPossessedBy(oPC, "diplomaestarc") == OBJECT_INVALID)
      {
          SendMessageToPC(oPC, "<cþ<<>Necesitas poseer un diploma de estudiante asiduo en la academia para poder acceder a las habitaciones privadas.</c>");
          return;
      }

      TeletransporteArcanum(oPC, GetLocation(GetWaypointByTag("ae_interior2")));
      return;
  }

  else if(oPortal == "ae_aentrada2")
  {
      TeletransporteArcanum(oPC, GetLocation(GetWaypointByTag("ae_exterior2")));
      return;
  }
}
