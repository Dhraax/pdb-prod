int ContarItem (int iTipo, object oPC)
{
    int iCont=0;
    object oItem = GetFirstItemInInventory(oPC);
    object oItem2;
    while (GetIsObjectValid(oItem)==TRUE)
    {
        if (GetBaseItemType(oItem)==iTipo) //GetTag(oItem) == sAdqui)
        {
            iCont++;
        }
        else if (GetHasInventory(oItem)==TRUE)
        {
            oItem2 = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oItem2)==TRUE)
            {
                if (GetBaseItemType(oItem2)==iTipo)//(GetTag(oItem2)== sAdqui)
                {
                    iCont++;
                }
                oItem2 = GetNextItemInInventory(oItem);
            }

        }
        oItem = GetNextItemInInventory(oPC);
    }


    return iCont;
}

void LimpiarTipoItem (object oPC, int iMax=0, int iTotal=0, int iSubTipo =0)
{

    int iCont=0, iAuxTotal=0, iBorrar=iTotal;
    object oItem = GetFirstItemInInventory(oPC);
    object oItem2;
    while (GetIsObjectValid(oItem)==TRUE)
    {
        if (iSubTipo==1)
        {

            if ((GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_WAND))// || (GetBaseItemType(oItem)==BASE_ITEM_MAGICWAND))
            {

                if(iBorrar>iMax)
                {
                    iBorrar--;
                    DestroyObject(oItem);
                    //SendMessageToPC(oPC, "<c–0Z>1. Varitas a Borrar: " + IntToString(iBorrar) + " Contador: " + IntToString(iCont) + ".</c>");
                }

            }
            else if (GetHasInventory(oItem)==TRUE)
            {
                oItem2 = GetFirstItemInInventory(oItem);
                while (GetIsObjectValid(oItem2)==TRUE)
                {
                    if ((GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_WAND))// || (GetBaseItemType(oItem2)==BASE_ITEM_MAGICWAND))
                    {
                        //iCont++;

                        if(iBorrar>iMax)
                        {
                            iBorrar--;
                            DestroyObject(oItem2);
                            //SendMessageToPC(oPC, "<c–0Z>2. Varitas a Borrar: " + IntToString(iBorrar) + " Contador: " + IntToString(iCont) + ".</c>");
                        }

                    }
                oItem2 = GetNextItemInInventory(oItem);
                }

            }

        }
        if (iSubTipo==2)
        {

            if ((GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_SCROLL)) //|| (GetBaseItemType(oItem)==BASE_ITEM_SPELLSCROLL))
            {

                if(iBorrar>iMax)
                {
                    iBorrar--;
                    DestroyObject(oItem);

                }

            }
            else if (GetHasInventory(oItem)==TRUE)
            {
                oItem2 = GetFirstItemInInventory(oItem);
                while (GetIsObjectValid(oItem2)==TRUE)
                {
                    if ((GetBaseItemType(oItem2)==BASE_ITEM_SPELLSCROLL) || (GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_SCROLL))
                    {


                        if(iBorrar>iMax)
                        {
                            iBorrar--;
                            DestroyObject(oItem2);

                        }

                    }
                oItem2 = GetNextItemInInventory(oItem);
                }

            }

        }
        if (iSubTipo==3)
        {

            if ((GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_POTION))// || (GetBaseItemType(oItem)==BASE_ITEM_POTIONS))
            {

                if(iBorrar>iMax)
                {
                    iBorrar--;
                    DestroyObject(oItem);

                }

            }
            else if (GetHasInventory(oItem)==TRUE)
            {
                oItem2 = GetFirstItemInInventory(oItem);
                while (GetIsObjectValid(oItem2)==TRUE)
                {
                    if ((GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_POTION)) //|| (GetBaseItemType(oItem2)==BASE_ITEM_POTIONS))
                    {


                        if(iBorrar>iMax)
                        {
                            iBorrar--;
                            DestroyObject(oItem2);

                        }

                    }
                oItem2 = GetNextItemInInventory(oItem);
                }

            }

        }
    oItem = GetNextItemInInventory(oPC);
    }
    iAuxTotal = ContarItem(BASE_ITEM_ENCHANTED_WAND, oPC); //ContarItem(BASE_ITEM_MAGICWAND, oPC) +
    iMax=10;
    if (iAuxTotal>0)
    {
            SendMessageToPC(oPC, "<c–0Z>Varitas de Crafteo: " + IntToString(iAuxTotal) + ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " varitas de crafteo.</c>");

    }
    iAuxTotal = ContarItem(BASE_ITEM_ENCHANTED_SCROLL, oPC); //ContarItem(BASE_ITEM_SPELLSCROLL, oPC) +
    iMax=50;
    if (iAuxTotal>0)
    {
            SendMessageToPC(oPC, "<c–0Z>Pergaminos de Crafteo: " + IntToString(iAuxTotal) + ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " pergaminos de crafteo.</c>");

    }
    iAuxTotal = ContarItem(BASE_ITEM_ENCHANTED_POTION, oPC);//ContarItem(BASE_ITEM_POTIONS, oPC) +
    iMax=50;
    if (iAuxTotal>0)
    {
            SendMessageToPC(oPC, "<c–0Z>Pociones de Crafteo: " + IntToString(iAuxTotal) + ". Te recordamos que no puedes tener más de " + IntToString(iMax) + " pociones de crafteo.</c>");

    }
}


/*void LimpiarObjetos(object oPC)
{

  object oItem = GetFirstItemInInventory(oPC);
  object oItem2;
  int iCont = 0, iCont2=0, iCont3=0, iMax=0, iContVar1=0, iContVar2=0;

  while (GetIsObjectValid(oItem)==TRUE)
  {
    if (GetTag(oItem) == "NW_IT_MPOTION012" || GetTag(oItem) == "sangrevampiro")
    {
        DestroyObject(oItem);
        SendMessageToPC(oPC, "Eliminado " + GetName(oItem) + ". Objeto no legal.");
    }

    if ((GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_WAND) || (GetBaseItemType(oItem)==BASE_ITEM_MAGICWAND))  //(GetTag(oItem) == "x2_it_pcwand")
    {

            iMax=10;
            if (GetTag(oItem) == "x2_it_pcwand")
            {
                if(GetItemCharges(oItem)>16)
                {
                    SetItemCharges(oItem, 16);
                }

            }
            if (GetBaseItemType(oItem)==BASE_ITEM_MAGICWAND)
            {

                iContVar1 = ContarTipoItem(BASE_ITEM_MAGICWAND, oPC, iMax, FALSE);
                //SendMessageToPC(oPC, "BASE_ITEM_MAGICWAND: " + IntToString(iContVar1));
            }
            if (GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_WAND)
            {


                iContVar2 =  ContarTipoItem(BASE_ITEM_ENCHANTED_WAND, oPC, iMax, FALSE);
                //SendMessageToPC(oPC, "BASE_ITEM_ENCHANTED_WAND: " + IntToString(iContVar2));
            }
            iCont = iContVar1 + iContVar2;
            //SendMessageToPC(oPC, "Varitas: " + IntToString(iCont));
            //iCont = ContarTipoItem(iTipo, oPC, iMax, FALSE);
            //if (iCont>0)
            //{

                //SendMessageToPC(oPC, "Tienes " + IntToString(iCont) + " varitas. Recuerda que no puedes tener más de " + IntToString(iMax) + " varitas.");
                if (iCont>iMax) //15
                {
                    iCont = ContarTipoItem(BASE_ITEM_MAGICWAND, oPC, iMax, TRUE, iCont, 1);
                    SendMessageToPC(oPC, "Ahora tienes " + IntToString(iCont) + " varitas. Recuerda que no puedes tener más de " + IntToString(iMax) + " varitas.");
                    iCont=0;

                }

            //}
    }
    else if (GetBaseItemType(oItem)==BASE_ITEM_SPELLSCROLL || GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_SCROLL) //GetBaseItemType(oItem)==BASE_ITEM_SCROLL || )//(GetTag(oItem) == "x2_it_pcscroll")
    {
            iMax=50;
            /*if (GetBaseItemType(oItem)==BASE_ITEM_SCROLL)
            {

                iContVar1 = ContarTipoItem(BASE_ITEM_SCROLL, oPC, iMax, FALSE);
                SendMessageToPC(oPC, "BASE_ITEM_SCROLL: " + IntToString(iContVar1));
            }
            if (GetBaseItemType(oItem)==BASE_ITEM_SPELLSCROLL)
            {

                iContVar1 =  ContarTipoItem(BASE_ITEM_SPELLSCROLL, oPC, iMax, FALSE);
                //SendMessageToPC(oPC, "BASE_ITEM_SPELLSCROLL: " + IntToString(iContVar1));
            }
            if (GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_SCROLL)
            {
                iContVar2 =  ContarTipoItem(BASE_ITEM_ENCHANTED_SCROLL, oPC, iMax, FALSE);
                //SendMessageToPC(oPC, "BASE_ITEM_ENCHANTED_SCROLL: " + IntToString(iContVar2));
            }
            iCont2=iContVar1+iContVar2;
            //SendMessageToPC(oPC, "Pergaminos: " + IntToString(iCont2));
            //if (iCont2>0)
            //{
                //SendMessageToPC(oPC, "Tienes " + IntToString(iCont2) + " pergaminos. Recuerda que no puedes tener más de " + IntToString(iMax) + " pergaminos.");
                if (iCont2>iMax)  // 50
                {
                        iCont2=ContarTipoItem(BASE_ITEM_SPELLSCROLL, oPC, iMax, TRUE, iCont2, 2);
                        SendMessageToPC(oPC, "Ahora tienes " + IntToString(iCont2) + " pergaminos. Recuerda que no puedes tener más de " + IntToString(iMax) + " pergaminos.");
                        iCont2=0;

                }
            //}
    }
    else if (GetBaseItemType(oItem)==BASE_ITEM_POTIONS || GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_POTION)
    {
            iMax=50;
            if (GetBaseItemType(oItem)==BASE_ITEM_POTIONS)
            {

                iContVar1 =  ContarTipoItem(BASE_ITEM_POTIONS, oPC, iMax, FALSE);

            }
            if (GetBaseItemType(oItem)==BASE_ITEM_ENCHANTED_POTION)
            {
                iContVar2 =  ContarTipoItem(BASE_ITEM_ENCHANTED_POTION, oPC, iMax, FALSE);

            }
            iCont3=iContVar1+iContVar2;
            if (iCont3>iMax)  // 50
            {
                iCont3=ContarTipoItem(BASE_ITEM_POTIONS, oPC, iMax, TRUE, iCont3, 3);
                SendMessageToPC(oPC, "Ahora tienes " + IntToString(iCont2) + " pociones. Recuerda que no puedes tener más de " + IntToString(iMax) + " pociones.");
                iCont3=0;

            }
    }
    else if (GetHasInventory(oItem)==TRUE)
    {
            oItem2 = GetFirstItemInInventory(oItem);
            while (GetIsObjectValid(oItem2)==TRUE)
            {

                    if (GetTag(oItem2) == "NW_IT_MPOTION012" || GetTag(oItem2) == "sangrevampiro")
                    {
                        DestroyObject(oItem2);
                        SendMessageToPC(oPC, "Eliminado " + GetName(oItem2) + ". Objeto no legal.");
                    }
                    if ((GetBaseItemType(oItem2)==BASE_ITEM_MAGICWAND) || (GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_WAND))//(GetTag(oItem2) == "x2_it_pcwand")
                    {
                        iMax=10;
                        if (GetTag(oItem2) == "x2_it_pcwand")
                        {
                            if(GetItemCharges(oItem2)>16)
                            {
                                SetItemCharges(oItem2, 16);
                            }

                        }
                        if (GetBaseItemType(oItem2)==BASE_ITEM_MAGICWAND)
                        {

                            iContVar1 = ContarTipoItem(BASE_ITEM_MAGICWAND, oPC, iMax, FALSE);
                            //SendMessageToPC(oPC, "BASE_ITEM_MAGICWAND: " + IntToString(iContVar1));
                        }
                        if (GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_WAND)
                        {


                            iContVar2 = ContarTipoItem(BASE_ITEM_ENCHANTED_WAND, oPC, iMax, FALSE);
                            //SendMessageToPC(oPC, "BASE_ITEM_ENCHANTED_WAND: " + IntToString(iContVar2));
                        }

                        iCont = iContVar1+iContVar2;
                        //SendMessageToPC(oPC, "Varitas: " + IntToString(iContVar3));
                        //if (iCont>0)
                        //{

                            //SendMessageToPC(oPC, "Tienes " + IntToString(iCont) + " varitas. Recuerda que no puedes tener más de " + IntToString(iMax) + " varitas.");
                            if (iCont>iMax) //15
                            {
                                iCont = ContarTipoItem(BASE_ITEM_MAGICWAND, oPC, iMax, TRUE, iCont, 1);
                                SendMessageToPC(oPC, "Ahora tienes " + IntToString(iCont) + " varitas. Recuerda que no puedes tener más de " + IntToString(iMax) + " varitas.");
                                iCont=0;

                            }

                        //}

                    }
                    else if (GetBaseItemType(oItem2)==BASE_ITEM_SPELLSCROLL || GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_SCROLL) //GetBaseItemType(oItem2)==BASE_ITEM_SCROLL || //(GetTag(oItem) == "x2_it_pcscroll")
                    {
                                iMax=50;
                                /*if (GetBaseItemType(oItem2)==BASE_ITEM_SCROLL)
                                {

                                    iContVar1 = ContarTipoItem(BASE_ITEM_SCROLL, oPC, iMax, FALSE);
                                    SendMessageToPC(oPC, "BASE_ITEM_SCROLL: " + IntToString(iContVar1));
                                }
                                if (GetBaseItemType(oItem2)==BASE_ITEM_SPELLSCROLL)
                                {


                                    iContVar1 =  ContarTipoItem(BASE_ITEM_SPELLSCROLL, oPC, iMax, FALSE);
                                    //SendMessageToPC(oPC, "BASE_ITEM_SPELLSCROLL: " + IntToString(iContVar1));
                                }
                                if (GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_SCROLL)
                                {

                                    iContVar2 =  ContarTipoItem(BASE_ITEM_ENCHANTED_SCROLL, oPC, iMax, FALSE);
                                    //SendMessageToPC(oPC, "BASE_ITEM_ENCHANTED_SCROLL: " + IntToString(iContVar2));
                                }
                                //iMax=50;
                                iCont2=iContVar1+iContVar2;
                                //SendMessageToPC(oPC, "Pergaminos: " + IntToString(iCont2));
                                //if (iCont2>0)
                                //{
                                   //SendMessageToPC(oPC, "Tienes " + IntToString(iCont2) + " pergaminos. Recuerda que no puedes tener más de " + IntToString(iMax) + " pergaminos.");
                                    if (iCont2>iMax)  // 50
                                    {
                                            iCont2= ContarTipoItem(BASE_ITEM_SPELLSCROLL, oPC, iMax, TRUE, iCont2, 2);
                                            SendMessageToPC(oPC, "Tienes " + IntToString(iCont2) + " pergaminos. Recuerda que no puedes tener más de " + IntToString(iMax) + " pergaminos.");
                                            iCont2=0;

                                    }
                               //}

                    }
                    else if (GetBaseItemType(oItem2)==BASE_ITEM_POTIONS || GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_POTION)
                    {
                            iMax=50;
                            if (GetBaseItemType(oItem2)==BASE_ITEM_POTIONS)
                            {

                                iContVar1 =  ContarTipoItem(BASE_ITEM_POTIONS, oPC, iMax, FALSE);

                            }
                            if (GetBaseItemType(oItem2)==BASE_ITEM_ENCHANTED_POTION)
                            {
                                iContVar2 =  ContarTipoItem(BASE_ITEM_ENCHANTED_POTION, oPC, iMax, FALSE);

                            }
                            iCont3=iContVar1+iContVar2;
                            if (iCont3>iMax)  // 50
                            {
                                iCont3=ContarTipoItem(BASE_ITEM_POTIONS, oPC, iMax, TRUE, iCont3, 3);
                                SendMessageToPC(oPC, "Ahora tienes " + IntToString(iCont2) + " pociones. Recuerda que no puedes tener más de " + IntToString(iMax) + " pociones.");
                                iCont3=0;

                            }
                    }
                    oItem2 = GetNextItemInInventory(oItem);
            }
    }
    oItem = GetNextItemInInventory(oPC);
  }
}       */
