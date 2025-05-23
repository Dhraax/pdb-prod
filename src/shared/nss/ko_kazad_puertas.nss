void main()
{
    object oPC = GetClickingObject();

    if(GetRacialType(oPC) == RACIAL_TYPE_DWARF)
       ActionOpenDoor (OBJECT_SELF);
}
