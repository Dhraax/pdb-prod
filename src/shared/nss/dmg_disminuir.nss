void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iDmg = GetLocalInt(oContenedor, "Dmg");
if (iDmg == 1)
{
SpeakString("Límite mínimo alcanzado");
}
else
{
SetLocalInt(oContenedor,"Dmg",iDmg-1);
}
}
