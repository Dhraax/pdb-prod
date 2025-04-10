void main()
{
if(GetLocalInt(GetModule(), "CHICO_PLANO_AGUA") == 0)
    {
     SetLocalInt(GetModule(), "CHICO_PLANO_AGUA", 1);
     CreateObject(OBJECT_TYPE_CREATURE, "nino_planar_agua", GetLocation(GetWaypointByTag("WP_nino_planar_agua_01")), TRUE);
    }
}
