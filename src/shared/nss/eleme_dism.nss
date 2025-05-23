void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iBono = GetLocalInt(oContenedor, "elementovalor");
if(iBono==1) {
SpeakString("Límite mínimo alcanzado!");
}
else
{
SetLocalInt(oContenedor, "elementovalor", iBono-1);
}
}
