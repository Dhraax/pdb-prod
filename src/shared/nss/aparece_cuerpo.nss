void main()
{
location lCuerpo = GetLocation(GetWaypointByTag("Nedron"));
object oCuerpo = GetObjectByTag("corpsenedron");
CreateObject(OBJECT_TYPE_PLACEABLE, "corpsenedron", lCuerpo);
}

