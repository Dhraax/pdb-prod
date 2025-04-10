void main()
{
object oBola1 = GetNearestObjectByTag("mebolakossun1");
object oBola2 = GetNearestObjectByTag("mebolakossun2");
object oBola3 = GetNearestObjectByTag("mebolakossun3");
object oBola4 = GetNearestObjectByTag("mebolakossun4");
object oBola5 = GetNearestObjectByTag("mebolakossun5");

object oWP = GetObjectByTag("WP_kossun_vuelta");

object oUser = GetLastUsedBy();

effect eBeam1 = EffectBeam(VFX_BEAM_BLACK,oBola1,BODY_NODE_CHEST,FALSE);
effect eBeam2 = EffectBeam(VFX_BEAM_BLACK,oBola2,BODY_NODE_CHEST,FALSE);
effect eBeam3 = EffectBeam(VFX_BEAM_BLACK,oBola3,BODY_NODE_CHEST,FALSE);
effect eBeam4 = EffectBeam(VFX_BEAM_BLACK,oBola4,BODY_NODE_CHEST,FALSE);
effect eBeam5 = EffectBeam(VFX_BEAM_BLACK,oBola5,BODY_NODE_CHEST,FALSE);
effect e2 = EffectVisualEffect(VFX_FNF_PWSTUN);

ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oBola2,5.0);
ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oBola5,5.0);

DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oBola2,5.0));
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oBola5,5.0));
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oBola5,5.0));
DelayCommand(1.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oBola2,5.0));

DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oBola2,4.0));
DelayCommand(2.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oBola5,4.0));

DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oBola2,3.0));
DelayCommand(3.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oBola5,3.0));

DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam1,oUser,2.0));
DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam2,oUser,2.0));
DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam3,oUser,2.0));
DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam4,oUser,2.0));
DelayCommand(4.0,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eBeam5,oUser,2.0));
DelayCommand(4.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e2,oUser,2.0));
DelayCommand(5.0,AssignCommand(oUser, ActionJumpToObject(oWP)));
}
