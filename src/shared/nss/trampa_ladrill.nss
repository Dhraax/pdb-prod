void main()
{
object oEntering = GetEnteringObject();
int iPC = GetIsPC(oEntering);
object oLadrillos = GetNearestObjectByTag("ladrillos_trampa");

if(iPC == TRUE)
{

int iVar = GetLocalInt(oLadrillos,"CEP_L_AMION");

    if(iVar == 0)
    {
AssignCommand(oEntering, ClearAllActions());
SetLocalInt(oLadrillos,"CEP_L_AMION",1);

effect eDano = EffectDamage(d100(1),DAMAGE_TYPE_BLUDGEONING);
ApplyEffectToObject(DURATION_TYPE_INSTANT,eDano,oEntering);
AssignCommand(oEntering, ClearAllActions());
AssignCommand(oLadrillos,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
AssignCommand(oEntering, ClearAllActions());
SetCutsceneMode(oEntering,TRUE);
AssignCommand(oEntering,PlayAnimation(ANIMATION_LOOPING_DEAD_FRONT,1.0,16.0));
DelayCommand(15.0,SetCutsceneMode(oEntering,FALSE));
    }
}
}
