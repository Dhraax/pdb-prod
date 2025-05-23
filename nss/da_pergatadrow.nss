void main()
{
  object oPC = GetPlaceableLastClickedBy();

  if(GetDistanceBetween(oPC, OBJECT_SELF) > 4.0)
  {
      SendMessageToPC(oPC, "¡Debes acercarte más al obelisco!");
      AssignCommand(oPC, ClearAllActions(TRUE));
      return;
  }

  if(GetLocalInt(oPC, "PERGADROW") == FALSE)
  {
      SetLocalInt(oPC, "PERGADROW", TRUE);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_PWKILL), oPC);
      CreateItemOnObject("thormmallem", oPC);
      FloatingTextStringOnCreature("* Retiras un pergamino del obelisco *", oPC);
      AssignCommand(oPC, ClearAllActions(TRUE));
  }

  else
  {
      SendMessageToPC(oPC, "Ya has cogido el pergamino.");
      AssignCommand(oPC, ClearAllActions(TRUE));
  }
}
