void main()
{
    object oPc = GetEnteringObject();
    location lEntering = GetLocation(oPc);
    object oDoor = GetNearestObjectToLocation(OBJECT_TYPE_DOOR, lEntering);
    SetLocked(oDoor, FALSE);
    DelayCommand(5.0, SetLocked(oDoor, TRUE));
}
