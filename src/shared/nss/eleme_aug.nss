void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iBono = GetLocalInt(oContenedor, "elementovalor");
if(iBono==10) {
SpeakString("Límite máximo alcanzado");
}
else
{
SetLocalInt(oContenedor, "elementovalor", iBono+1);
}
}
