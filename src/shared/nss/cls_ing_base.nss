#include "mti_libreria"
void main()
{
    object oPC = OBJECT_SELF;
    ActionStartConversation(oPC,"cls_ing_conv",TRUE);
    SetLocalObject(oPC, "CLS_ING_DOTE", GetSpellTargetObject());
}
