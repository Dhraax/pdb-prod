void main()
{
  object oMod = GetModule();
  if(GetLocalInt(oMod, "MISNEFECTOS") == 1) return;

  SetLocalInt(oMod, "MISNEFECTOS", 1);
  DelayCommand(18.0, DeleteLocalInt(oMod, "MISNEFECTOS"));

  location lnube_1 = GetLocation(GetWaypointByTag("nube_1"));
  location lnube_2 = GetLocation(GetWaypointByTag("nube_2"));
  location lnube_3 = GetLocation(GetWaypointByTag("nube_3"));
  location lnube_4 = GetLocation(GetWaypointByTag("nube_4"));
  effect eVis = EffectVisualEffect(VFX_IMP_DOOM);

  DelayCommand(1.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_1, 100.0f));
  DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_2, 100.0f));
  DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_3, 100.0f));
  DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_4, 100.0f));
  DelayCommand(5.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_1, 100.0f));
  DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_2, 100.0f));
  DelayCommand(7.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_3, 100.0f));
  DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_4, 100.0f));
  DelayCommand(9.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_1, 100.0f));
  DelayCommand(10.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_2, 100.0f));
  DelayCommand(11.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_3, 100.0f));
  DelayCommand(12.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_4, 100.0f));
  DelayCommand(13.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_1, 100.0f));
  DelayCommand(14.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_2, 100.0f));
  DelayCommand(15.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_3, 100.0f));
  DelayCommand(16.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_4, 100.0f));
  DelayCommand(17.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, lnube_1, 100.0f));
}
