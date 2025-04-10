void main()
{
effect eUnsummon = EffectVisualEffect(VFX_IMP_UNSUMMON);
location lLugar = GetLocation(OBJECT_SELF);
DelayCommand(1.0,RemoveHenchman(GetMaster(OBJECT_SELF),OBJECT_SELF));
DelayCommand(1.0,DestroyObject(OBJECT_SELF));
DelayCommand(1.0,SetIsDestroyable(TRUE,FALSE,FALSE));
ApplyEffectAtLocation(DURATION_TYPE_INSTANT,eUnsummon,lLugar);

}
