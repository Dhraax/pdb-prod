void main()
{

int iVar = GetLocalInt(OBJECT_SELF,"placa");

if (iVar == 1)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta01");
ActionCloseDoor(oPuerta);
}
if (iVar == 2)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta02");
ActionCloseDoor(oPuerta);
}
if (iVar == 3)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta03");
ActionCloseDoor(oPuerta);
}
if (iVar == 4)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta04");
ActionCloseDoor(oPuerta);
}
if (iVar == 5)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta05");
ActionCloseDoor(oPuerta);
}
if (iVar == 6)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta06");
ActionCloseDoor(oPuerta);
}
if (iVar == 7)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta07");
ActionCloseDoor(oPuerta);
}
if (iVar == 8)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta08");
ActionCloseDoor(oPuerta);
}
if (iVar == 9)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta9");
ActionCloseDoor(oPuerta);
}
if (iVar == 10)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta10");
ActionCloseDoor(oPuerta);
}
if (iVar == 11)
{
object oPuerta = GetNearestObjectByTag("puertaruinascosta11");
ActionCloseDoor(oPuerta);
}
SendMessageToPC(GetEnteringObject(),"*Oyes algo cerrarse...*");
}
