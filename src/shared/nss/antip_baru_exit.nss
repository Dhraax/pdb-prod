void main()
{
object oPC = GetExitingObject();

DelayCommand(3.0,RemoveEffect(oPC,EffectAreaOfEffect(AOE_PER_FOGKILL)));
}
