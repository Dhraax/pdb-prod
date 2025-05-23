void main()
{
    DeleteLocalObject(OBJECT_SELF, "DM_DESEN_TARGET");
    DeleteLocalLocation(OBJECT_SELF, "DM_DESEN_LTARGET");
    DeleteLocalInt(OBJECT_SELF, "DM_DESEN_CONTEO");
    DeleteLocalObject(OBJECT_SELF, "DM_DESEN_MAS");
    DeleteLocalObject(OBJECT_SELF, "DM_DESEN_STRING");
    DeleteLocalObject(OBJECT_SELF, "DM_DESEN_VALOR");

    int iLoop = 0;
    while( iLoop < 10)
    {
        DeleteLocalObject(OBJECT_SELF, "DM_DESEN_UBICADO" + IntToString(iLoop));
        iLoop++;
    }
}
