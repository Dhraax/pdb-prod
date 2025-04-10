// MONTI: GUION PARA CERRAR PUERTAS CON LLAVE EN BASTANTES SEGUNDOS

void main()
{
  DelayCommand(800.0, AssignCommand(OBJECT_SELF, ActionCloseDoor(OBJECT_SELF)));
  DelayCommand(801.0, SetLocked(OBJECT_SELF, TRUE));
}
