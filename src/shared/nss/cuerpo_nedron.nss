void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
{
CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
}
void main()
{
location lCuerpo = GetLocation(GetWaypointByTag("Nedron"));
object oCuerpo = GetObjectByTag("corpsenedron");
DelayCommand(1.0, DestroyObject(oCuerpo));
DelayCommand(5.0, CreateObjectVoid(OBJECT_TYPE_PLACEABLE, "corpsenedron", lCuerpo));
}
