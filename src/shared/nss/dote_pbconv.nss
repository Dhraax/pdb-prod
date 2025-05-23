#include "x3_inc_horse"
#include "x2_inc_itemprop"

void main()
{
    object oPC = OBJECT_SELF;
    object oSkin=SKIN_SupportGetSkin(oPC);
    itemproperty ipAdd;
    if (GetIsPC(oPC)&&!GetHasFeat(FEAT_PLAYER_TOOL_06,oPC))
    {
        ipAdd=ItemPropertyBonusFeat(IP_CONST_FEAT_PLAYER_TOOL_06);
        IPSafeAddItemProperty(oSkin, ipAdd);
       SendMessageToPC(oPC, "(PB)Convocado agregado");
    }
}

