const string USEOBJECT_LVAR_OBJECTTAG = "useobject_tag";

const string USEOBJECT_LVAR_ISUSER    = "useobject_isuser";

void main()
{
    object oEnteringObject = GetEnteringObject();

    if (GetIsPC(oEnteringObject) || GetIsDM(oEnteringObject))
        return;

    if (GetLocalInt(oEnteringObject, USEOBJECT_LVAR_ISUSER) <= 0)
        return;

    object oObjectToUse = GetObjectByTag(GetLocalString(OBJECT_SELF, USEOBJECT_LVAR_OBJECTTAG));

    AssignCommand(oEnteringObject, DoPlaceableObjectAction(oObjectToUse, PLACEABLE_ACTION_USE));
}
