void main()
{
    //CREAMOS UNA TUNICA DE LOS MAGOS ALEATORIAMENTE
    object oTunica = CreateItemOnObject("tunica_vengador", OBJECT_SELF);
    SetDroppableFlag(oTunica, TRUE);

    // Execute default OnSpawn script.
    ExecuteScript("nw_c2_default9", OBJECT_SELF);
}
