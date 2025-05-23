void main()
{
//::////////////////////////////////////////////////////////////////////////:://
/*SCRIPT PARA DORMIR A PNJs, SITUALO EN EL ONSPAWN DEL PNJ*/
//::////////////////////////////////////////////////////////////////////////:://

//Definimos los objetos
effect eEfecto1 = SupernaturalEffect(EffectVisualEffect(VFX_IMP_SLEEP));

AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 0.0,999999999999999.9));
ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEfecto1, OBJECT_SELF);

DelayCommand(3.5, ExecuteScript("dormir_exe", OBJECT_SELF));
}
