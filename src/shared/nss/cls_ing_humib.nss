#include "x2_inc_spellhook"
#include "nw_i0_spells"
#include "inc_spells"

void main()
{
    gsSPRemoveEffect(
        GetExitingObject(),
        GetSpellId(),
        GetAreaOfEffectCreator());

    //Borramos en el área de efecto al objetivo, para saber si aún está dentro.
    if(GetIsPC(GetExitingObject())){DeleteLocalObject(OBJECT_SELF,GetName(GetExitingObject()));}
    else if(!GetIsPC(GetExitingObject())){DeleteLocalInt(GetExitingObject(), "VFX_PER_ING_HUMIFICADOR");}
}


