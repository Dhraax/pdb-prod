void main()
{
    object oPC=GetEnteringObject();
    if(GetIsPC(oPC))
    {
        if(GetItemPossessedBy(oPC,"atk_hab_avent")!=OBJECT_INVALID )
        {
           object oLlave1 = GetItemPossessedBy(oPC,"atk_hab_avent");
          AssignCommand(oPC, DestroyObject(oLlave1,0.1));
        }

         if(GetItemPossessedBy(oPC,"atk_hab_pleb")!=OBJECT_INVALID )
        {
           object oLlave2 = GetItemPossessedBy(oPC,"atk_hab_pleb");
          AssignCommand(oPC, DestroyObject(oLlave2,0.1));
        }
    }
}
