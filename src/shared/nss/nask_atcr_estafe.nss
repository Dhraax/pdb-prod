void main()
{
object oGuardia = GetObjectByTag("carp_naskel");
object oEstafermo = GetObjectByTag("est_naskel");
AssignCommand(oGuardia, ActionAttack(oEstafermo));
}
