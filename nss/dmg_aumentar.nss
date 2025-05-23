void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iDmg = GetLocalInt(oContenedor, "Dmg");
if (iDmg == 20)
{
SpeakString("Límite máximo alcanzado");
}
else
{
SetLocalInt(oContenedor,"Dmg",iDmg+1);
}
}
