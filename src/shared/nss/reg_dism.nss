void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iBono = GetLocalInt(oContenedor, "Reg");
if(iBono==1) {
SpeakString("Límite mínimo alcanzado");
}
else
{
SetLocalInt(oContenedor, "Reg", iBono-1);
}
}
