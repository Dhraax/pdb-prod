void main()
{
  object oPJ = GetClickingObject();
  object oCriptas = GetObjectByTag("celdas_crip_v_velada");
  object oSalida = GetObjectByTag("salida_hab_merc_vv");
  object oAliadoVampis = GetItemPossessedBy(oPJ, "aliadovampis");
  effect eAparece1 = EffectVisualEffect(VFX_IMP_EVIL_HELP);
  effect eAparece2 = EffectVisualEffect(VFX_DUR_PARALYZE_HOLD);
  effect eParalizar1 = EffectVisualEffect(VFX_DUR_PARALYZED);
  effect eParalizar2 = EffectVisualEffect(VFX_DUR_WEB);
  string sSubraza = GetStringLowerCase(GetSubRace(oPJ));
  location lVampira = GetLocation(GetWaypointByTag("vampira_hab_merc_vv"));

  if(d100() > 70 && sSubraza != "vampiro" && sSubraza != "ghul" && GetIsObjectValid(oAliadoVampis) == FALSE)
  {
      SetCommandable(FALSE, oPJ);
      object oVampira = CreateObject(OBJECT_TYPE_CREATURE, "esm_vv_vampira", lVampira);
      SendMessageToAllDMs(GetName(oPJ)+" ha sido raptado por los Vampiros de La Vampiresa Velada. No estaría mal echarle un ojo.");
      FloatingTextStringOnCreature("*Te dispones a abrir la puerta de la habitación, pero algo te lo impide*", oPJ);
      DelayCommand(6.0, FloatingTextStringOnCreature("*Notas como un escalofrío que te recorre toda la espalda*", oPJ));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar1, oPJ, 23.0));
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eParalizar2, oPJ, 24.0));
      DelayCommand(11.0, FloatingTextStringOnCreature("*De repente te percatas de una figura que yace en tu espalda*", oPJ));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAparece1, lVampira);
      DelayCommand(2.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAparece2, oVampira, 21.5));
      DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eAparece1, lVampira));
      DelayCommand(12.0, AssignCommand(oVampira, PlayAnimation(ANIMATION_FIREFORGET_STEAL, 1.0, 11.5)));
      DelayCommand(15.0, AssignCommand(oVampira, PlaySound("as_cv_ropecreak1")));
      DelayCommand(15.1, SetCommandable(TRUE, oPJ));
      DelayCommand(16.0, FloatingTextStringOnCreature("*Te atan y te quedas inmovil en el suelo*", oPJ));
      DelayCommand(16.1, AssignCommand(oPJ, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 4.9)));
      DelayCommand(18.0, FadeToBlack(oPJ, FADE_SPEED_SLOW));
      DelayCommand(20.5, AssignCommand(oPJ, ClearAllActions()));
      DelayCommand(21.0, AssignCommand(oPJ, JumpToObject(oCriptas)));
      DelayCommand(23.0, AssignCommand(oPJ, PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0, 20.0)));
      DelayCommand(24.0, FadeFromBlack(oPJ, FADE_SPEED_SLOW));
      DestroyObject(oVampira, 24.0);
      DelayCommand(24.1, SetLocalInt(oPJ, "GHOUL_CIRIPT_VV", 1));
  }

  else
  {
      AssignCommand(oPJ, JumpToObject(oSalida));
  }
}
