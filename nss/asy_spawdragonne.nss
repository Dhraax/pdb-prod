
void main()
{
    int iTirada = d100(1);
    string sAmuleto = "asy_amuletodrago";
    string sEspada = "asy_espadadragon";
    string sArmadura = "asy_armaduradrag";

    if (iTirada >0 && iTirada<81)
    {
       CreateItemOnObject(sEspada, OBJECT_SELF, 1);
    }
    else if (iTirada>80 && iTirada<97)
    {
         CreateItemOnObject(sArmadura, OBJECT_SELF, 1);
    }
    else if (iTirada>97 && iTirada<=100)
    {
        CreateItemOnObject(sAmuleto, OBJECT_SELF, 1);
    }
     //nw_c2_dropin9 por nw_c2_default9
    ExecuteScript("nw_c2_dropin9", OBJECT_SELF);
}
