#include "hc_inc_htf"
#include "hc_text_rest"

void main()
{
    object oUser=OBJECT_SELF;
    object oOther=GetLocalObject(oUser,"OTHER");
    object oItem=GetLocalObject(oUser,"ITEM");
    string sItemTag=GetLocalString(oUser,"TAG");
    int iHUNGERSYSTEM = GetLocalInt(oMod,"HUNGERSYSTEM");

    // COMIDAS
    if(FindSubString(GetStringUpperCase(sItemTag),"FOOD") != -1)
    {
        if(iHUNGERSYSTEM) UseFoodOrDrinkItem(oUser,oItem);
        else
        {
            SendMessageToPC(oUser,EATFOOD + " [" + GetName(oItem) + "]");
            DestroyObject(oItem);
        }
        return;
    }

    // BEBIDAS
    else if (FindSubString(GetStringUpperCase(sItemTag),"DRINK") != -1)
    {
        if(iHUNGERSYSTEM) UseFoodOrDrinkItem(oUser,oItem);
        else
        {
            SendMessageToPC(oUser,GULPDRINK + " [" + GetName(oItem) + "]");
            if(FindSubString(GetStringUpperCase(sItemTag),"ALCOHOL") != -1) MakePCDrunk(oUser,1,BURP);
            DestroyObject(oItem);
        }
        return;
    }

    // CANTIMPLORAS
    else if(sItemTag == "WaterCanteen")
    {
        if(iHUNGERSYSTEM)
        {
            location loc;
            if(oOther == OBJECT_INVALID) loc = GetItemActivatedTargetLocation();
            UseWaterCanteen(oUser,oItem,oOther,loc);
        }
        else
        {
            //The water canteen really has no purpose unless HUNGERSYSTEM is on,
            //but if it isn't give it some cool effects anyway.
            AssignCommand(oUser,ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK));
            DelayCommand(1.5,FloatingTextStringOnCreature(GULP, oUser));
        }
        return;
    }

    DeleteLocalString(oUser,"TAG");
    DeleteLocalObject(oUser,"ITEM");
    DeleteLocalObject(oUser,"OTHER");
}
