void main()
{
    object oPC = GetLastUsedBy();
    AssignCommand(oPC,ActionPlayAnimation(ANIMATION_FIREFORGET_BOW,1.0,2.0));
    string sAlianza = "alian_eldur";
    CreateItemOnObject(sAlianza, oPC, 1);

}
