void main()
{
  int iProb = d10(1);
  object oPC = GetEnteringObject();

  if(GetIsPC(oPC) != TRUE) return;

  if(GetLocalInt(OBJECT_SELF,"NOSATURAR") == 1) return;
  SetLocalInt(OBJECT_SELF, "NOSATURAR", 1);
  DelayCommand(12.0, DeleteLocalInt(OBJECT_SELF, "NOSATURAR"));

  if(iProb <= 3)
  {
      effect aoe1 = EffectAreaOfEffect(AOE_PER_FOGMIND);
      effect aoe2 = EffectAreaOfEffect(AOE_PER_FOG_OF_BEWILDERMENT);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,aoe1,GetLocation(oPC),10.0);
      ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,aoe2,GetLocation(oPC),10.0);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectPoison(POISON_BEBILITH_VENOM), oPC);
  }
}
