void main()
{
DelayCommand(5.0, ActionCloseDoor(OBJECT_SELF));
DelayCommand(5.0, SetLocked(OBJECT_SELF,TRUE));
}
