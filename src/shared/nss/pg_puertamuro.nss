void main()
{
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) == FALSE) return;

  effect eInmo = EffectCutsceneImmobilize();
  object   oPlanoFuga = GetWaypointByTag("pg_fueramuro");
  float    fPlanoFuga = GetFacing(oPlanoFuga);
  location lPlanoFuga = GetLocation(oPlanoFuga);

  object oPilar1 = GetNearestObjectByTag("pg_pilar1");
  object oPilar2 = GetNearestObjectByTag("pg_pilar2");
  object oPilar3 = GetNearestObjectByTag("pg_pilar3");
  object oPilar4 = GetNearestObjectByTag("pg_pilar4");
  object oPilar5 = GetNearestObjectByTag("pg_pilar5");
  object oPilar6 = GetNearestObjectByTag("pg_pilar6");
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar1, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar2, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar3, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar4, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar5, 5.0);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_HOLY, oPC, BODY_NODE_CHEST), oPilar6, 5.0);

  if(GetDeity(oPC) == "")
  {
      //SetCameraMode(oPC, CAMERA_MODE_TOP_DOWN);
      //AssignCommand(oPC, SetCameraFacing(fPlanoFuga, 25.0, 20.0, CAMERA_TRANSITION_TYPE_FAST));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmo, oPC, 5.0);
      SendMessageToPC(oPC, "<cþ>¡Eres un Infiel! ¡Kélemvor te castiga a formar parte del Muro de los Infieles durante el resto de la eternidad!</c>");
      DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(24), oPC));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(30), oPC));
      //DelayCommand(4.0, AssignCommand(oPC, ActionJumpToLocation(lPlanoFuga)));
      //DelayCommand(4.0, AssignCommand(oPC, SetCameraFacing(fPlanoFuga, 5.0, 89.0, CAMERA_TRANSITION_TYPE_FAST)));
  }
  else
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oPC);
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oPC));
      DelayCommand(4.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE), oPC));
  }
}
