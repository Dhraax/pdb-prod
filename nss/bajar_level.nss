void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iSubir = GetLocalInt(oContenedor,"intLevel");

if(iSubir==1)
{
SpeakString("No puedes bajar a más de 1");
}
else
{
SetLocalInt(oContenedor,"intLevel",iSubir-1);
}
}
