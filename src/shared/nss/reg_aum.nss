void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iBono = GetLocalInt(oContenedor, "Reg");
if(iBono==20) {
SpeakString("Límite máximo alcanzado");
}
else
{
SetLocalInt(oContenedor, "Reg", iBono+1);
}
}
