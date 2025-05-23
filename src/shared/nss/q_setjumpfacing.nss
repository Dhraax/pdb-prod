void main()
{
    string sTag = GetLocalString(OBJECT_SELF, "Q_JUMP_FACING");
    object oFace = GetObjectByTag(sTag);
    vector vFace = GetPosition(oFace);
    if (GetIsObjectValid(oFace))
    AssignCommand(OBJECT_SELF, SetFacingPoint(vFace));
}
