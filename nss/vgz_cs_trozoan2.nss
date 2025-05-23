void main()
{
object oWay = GetWaypointByTag("cs_trozodeanill2");
location lWay = GetLocation(oWay);

CreateObject(OBJECT_TYPE_ITEM,"cs_trozodeanill2",lWay);
}
