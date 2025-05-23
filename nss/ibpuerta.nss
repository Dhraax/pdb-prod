void main()
{
DelayCommand(4.0, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)));
DelayCommand(6.0, AssignCommand(OBJECT_SELF, SetLocked(OBJECT_SELF, TRUE)));
}
