void main()
{
object oPuerta1 = GetNearestObjectByTag("aihavann6_5");
object oPuerta2 = GetNearestObjectByTag("aihavann5_6");

ActionOpenDoor(oPuerta1);
ActionOpenDoor(oPuerta2);

DelayCommand(6.0,ActionCloseDoor(oPuerta1));
DelayCommand(6.0,ActionCloseDoor(oPuerta2));
}
