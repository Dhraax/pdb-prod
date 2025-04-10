void main()
{
object oPuerta1 = GetNearestObjectByTag("aihavann4_3");
object oPuerta2 = GetNearestObjectByTag("aihavann3_4");

ActionOpenDoor(oPuerta1);
ActionOpenDoor(oPuerta2);

DelayCommand(6.0,ActionCloseDoor(oPuerta1));
DelayCommand(6.0,ActionCloseDoor(oPuerta2));
}
