#include "q_inc_anims"

void main()
{
    object oPC = GetPCSpeaker();
    Q_ExecutePartneredDance(oPC,OBJECT_SELF,1.0,80.0);
}

