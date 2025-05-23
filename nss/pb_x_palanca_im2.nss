/*PALANCA DEL OTRO LADO IMNESCAR XAVI*/
void ActivarMecanismo()
{
DelayCommand(0.1, PlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
DelayCommand(5.0, PlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));
}

void main()
{
string sPuerta = "puerta_band_final";
object oPuerta = GetObjectByTag(sPuerta);

ActivarMecanismo();
SetLocked(oPuerta, FALSE);
AssignCommand(oPuerta, ActionOpenDoor(oPuerta));
}
