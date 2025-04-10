//::///////////////////////////////////////////////
//:: Store Open Script
//:: nw_d1_startstore
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Althor de Malavir
//:: Created On: 24/09/2015
//:://////////////////////////////////////////////
void main()
{
    object oCurrentItem = GetFirstItemInInventory();
    string sItemTag;
    int iItemCount = 0;
    int iPCItem;
    string sNombreItem;
    int iNumObjetosMax = 2; //Maximo de objetos identicos en el mercader.
    int nNivelObjeto;

    while(oCurrentItem != OBJECT_INVALID){

        sItemTag = GetTag(oCurrentItem);
        iPCItem = GetLocalInt(oCurrentItem, "PCItem");  //Objeto obtenido por jugador
        iItemCount = GetLocalInt(OBJECT_SELF, "count_" + sItemTag);

        if(iItemCount >= iNumObjetosMax && iPCItem == 1){
            DestroyObject(oCurrentItem);
        }else{
            ++iItemCount;
            SetLocalInt(OBJECT_SELF, "count_" + sItemTag ,iItemCount );
        }
        oCurrentItem = GetNextItemInInventory();
    }

    oCurrentItem = GetFirstItemInInventory();
    //Recuento para el siguiente OnOpen
    while(oCurrentItem != OBJECT_INVALID)
        {
        SetLocalInt(OBJECT_SELF, "count_" + GetTag(oCurrentItem) , 0);
        //Marcar el nivel del objeto en el nombre del objeto
        //nNivelObjeto = CF_ObtenNivelObjeto(oCurrentItem);
        //sNombreItem = GetName(oCurrentItem);
        //if(FindSubString(sNombreItem, "nivel") > 0) {}
        //else SetName(oCurrentItem, GetName(oCurrentItem)+" (nivel "+IntToString(nNivelObjeto)+")");
        oCurrentItem = GetNextItemInInventory();
        }//end while
}//end main()
