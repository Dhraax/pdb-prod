void main()
{
object oPC = GetLastSpeaker();
object anciana = GetObjectByTag("pnj_carintIhtafeer"); //Ihtafeercamuflada
string criatura1 = "Ihtafeer";
object punto1 = GetWaypointByTag("Quest_Ihtafeer_01");
object punto2 = GetWaypointByTag("Quest_Ihtafeer_02");
location lTarget1 = GetLocation(punto1);
location lTarget2 = GetLocation(punto2);
effect eEfectos = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);

ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfectos, anciana);
AssignCommand(anciana,ActionJumpToLocation(lTarget2));
FloatingTextStringOnCreature("Para tu sorpresa la anciana se transforma delante de tus ojos en una bestia sanguinaria de tremendo poder dispuesto a devorarte",oPC,FALSE);
object sorpresa = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget1 ,FALSE);
//La anciana desaparece tras aslir el bichito.
DestroyObject(anciana);
}
