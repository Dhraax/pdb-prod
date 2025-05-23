// En el On Usedde un ubicado
// Se iniciara la conversacion que tenga el ubicado con el PJ
#include "NW_O2_CONINCLUDE"
#include "NW_I0_GENERIC"
void main()
 {
   SetListenPattern(OBJECT_SELF, "**", 777);
   SetListening(OBJECT_SELF, TRUE);

   ActionStartConversation(GetLastUsedBy());
   /*int nMatch = GetListenPatternNumber();
   object oShouter = GetLastUsedBy();
   object oIntruder;
    if (nMatch == -1 && GetCommandable(OBJECT_SELF))
    {
        ClearAllActions();
        BeginConversation();
        //ActionStartConversation(GetLastUsedBy());
    }
    else
    if(nMatch == 777 && GetIsObjectValid(oShouter) && GetIsPC(oShouter))
  //     && GetIsFriend(oShouter)
    {
      if (oShouter == GetLocalObject(OBJECT_SELF, "Customer")) {
        string sSaid = GetMatchedSubstring(0);
        SetLocalString(OBJECT_SELF, "Stack", sSaid);
      }
    }*/

 }
