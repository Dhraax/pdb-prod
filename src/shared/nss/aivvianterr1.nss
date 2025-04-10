void main()
{
object oPuerta1 = GetNearestObjectByTag("aihavann2_1");
object oPuerta2 = GetNearestObjectByTag("aihavann1_2");

ActionOpenDoor(oPuerta1);
ActionOpenDoor(oPuerta2);

DelayCommand(6.0,ActionCloseDoor(oPuerta1));
DelayCommand(6.0,ActionCloseDoor(oPuerta2));
}
