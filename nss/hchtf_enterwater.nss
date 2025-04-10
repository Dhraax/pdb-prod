// sr5.2
//hchtf_enterwater  (on enter event for trigger painted around body of water)
#include "hc_inc_htf"
void main()
{
    object oPC=GetEnteringObject();
    SendMessageToPC(oPC, CANFILLCANTEEN);
    SetLocalString(oPC,"WATERSRC",GetTag(OBJECT_SELF));
    if(GetLevelByClass(CLASS_TYPE_RANGER,oPC)||GetLevelByClass(CLASS_TYPE_DRUID,oPC))
     {
      string sTag=GetTag(OBJECT_SELF);
      if(TestStringAgainstPattern("**(POISON)**",sTag))
       SendMessageToPC(oPC, POISON);
      if(TestStringAgainstPattern("**(DISEASE)**",sTag))
       SendMessageToPC(oPC, DISEASE);
      if(TestStringAgainstPattern("**(ENERGY|HPBONUS)**",sTag))
       SendMessageToPC(oPC, REFRESHING);
     }
}
