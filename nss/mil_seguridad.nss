int StartingConditional()
{
    int iSeguridad = GetLocalInt(OBJECT_SELF,"MilSeguridad");

    if(iSeguridad == 0) return TRUE;
    else return FALSE;
}
