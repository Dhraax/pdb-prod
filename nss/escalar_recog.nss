void main()
{
if(GetLocalInt(GetModule(), "SACERDOTEPURSKUL") == 0)
    {
     SetLocalInt(GetModule(), "SACERDOTEPURSKUL", 1);
     CreateObject(OBJECT_TYPE_CREATURE, "sacerdoresupremo", GetLocation(GetWaypointByTag("POST_SacerdoreSupremodeKhauntea")), TRUE);
    }
}
