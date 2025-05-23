void main()
{
location lCuerpo = GetLocation(GetWaypointByTag("Nedron"));
object oCuerpo = GetObjectByTag("corpsenedron");
DelayCommand(1.0, DestroyObject(oCuerpo));
DelayCommand(10.0, ExecuteScript("aparece_cuerpo", OBJECT_SELF));
}

