void main()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iCantidad = GetLocalInt(oContenedor,"Ench");
if(iCantidad == 0) {
SpeakString("Límite alcanzado");
}
else
{
SetLocalInt(oContenedor,"Ench",iCantidad-1);
}

}
