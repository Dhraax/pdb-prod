void main()
{
object oAspas = GetNearestObjectByTag("aspas_trampa");
int iVar = GetLocalInt(OBJECT_SELF,"palanca");
int iVar2 = GetLocalInt(oAspas,"palanca");


if (iVar2 == 1)
    {
    SetLocalInt(oAspas,"palanca",2);
    AssignCommand(OBJECT_SELF,PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
    SendMessageToPC(GetLastUsedBy(),"Algo se ha abierto.");

    if(iVar == 1)
    {
    object oPuerta = GetObjectByTag("puertarob01");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));

    }
    if(iVar == 2)
    {
    object oPuerta = GetObjectByTag("puertarob02");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 3)
    {
    object oPuerta = GetObjectByTag("puertarob03");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 4)
    {
    object oPuerta = GetObjectByTag("puertarob04");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 5)
    {
    object oPuerta = GetObjectByTag("puertarob05");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 6)
    {
    object oPuerta = GetObjectByTag("puertarob06");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 7)
    {
    object oPuerta = GetObjectByTag("puertarob07");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    if(iVar == 8)
    {
    object oPuerta = GetObjectByTag("puertarob08");
    DelayCommand(1.0,ActionOpenDoor(oPuerta));
    }
    }
else
    {
    SendMessageToPC(GetLastUsedBy(),"La palanca está atascada.");
    PlaySound("it_softplate");
    }

}
