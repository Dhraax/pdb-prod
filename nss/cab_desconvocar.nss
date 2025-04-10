void main()
{
  if(GetMaster(OBJECT_SELF) != OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("* Desconvocas tu montura *", GetMaster(OBJECT_SELF), FALSE);
      RemoveHenchman(GetMaster(OBJECT_SELF), OBJECT_SELF);
  }

  ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), OBJECT_SELF);
  ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDisappear(), OBJECT_SELF);
}
