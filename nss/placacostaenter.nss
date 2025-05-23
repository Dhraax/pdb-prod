void main()
{
int iVar = GetLocalInt(OBJECT_SELF,"placa");

if (iVar == 1)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta01");
ActionOpenDoor(oPuerta);
}
if (iVar == 2)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta02");
ActionOpenDoor(oPuerta);
}
if (iVar == 3)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta03");
ActionOpenDoor(oPuerta);
}
if (iVar == 4)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta04");
ActionOpenDoor(oPuerta);
}
if (iVar == 5)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta05");
ActionOpenDoor(oPuerta);
}
if (iVar == 6)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta06");
ActionOpenDoor(oPuerta);
}
if (iVar == 7)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta07");
ActionOpenDoor(oPuerta);
}
if (iVar == 8)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta08");
ActionOpenDoor(oPuerta);
}
if (iVar == 9)
{
object oPuerta1 = GetNearestObjectByTag("puertaruinascosta09");

ActionOpenDoor(oPuerta1);

}
if (iVar == 10)
{
object oPuerta1 = GetNearestObjectByTag("puertaruinascosta10");
ActionOpenDoor(oPuerta1);
}
if (iVar == 11)
{
object oPuerta1 = GetNearestObjectByTag("puertaruinascosta11");
ActionOpenDoor(oPuerta1);
}


SendMessageToPC(GetEnteringObject(),"*Oyes algo abrirse...*");
}
