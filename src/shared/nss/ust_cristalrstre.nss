void main()
{
  object oPC = GetLastUsedBy();
  string sEtiquetaCristal = GetTag(OBJECT_SELF);

  if(GetLocalInt(oPC, sEtiquetaCristal) == TRUE)
  {
      FloatingTextStringOnCreature("* Ya has usado el poder de este cristal *", oPC);
      return;
  }

  ForceRest(oPC);
  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HEALING_S), oPC);
  FloatingTextStringOnCreature("* Tu cuerpo y mente se recuperan *", oPC);
  SetLocalInt(oPC, sEtiquetaCristal, TRUE);
}
