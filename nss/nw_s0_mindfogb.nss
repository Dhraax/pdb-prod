#include "X0_I0_SPELLS"
#include "inc_spells"

void main()
{
    gsSPRemoveEffect(
    GetExitingObject(),
    GetSpellId(),
    GetAreaOfEffectCreator());

    //Borramos en el área de efecto al objetivo, para saber si aún está dentro.
    if(GetIsPC(GetExitingObject())){DeleteLocalObject(OBJECT_SELF,GetName(GetExitingObject()));}
    else if(!GetIsPC(GetExitingObject())){DeleteLocalInt(GetExitingObject(), "AOE_PER_FOGMIND");}

    int bValid = FALSE;
    effect eAOE = GetFirstEffect(GetExitingObject());
    if(GetHasSpellEffect(SPELL_MIND_FOG, GetExitingObject()) || GetHasSpellEffect(1547, GetExitingObject()))
    {
        while (GetIsEffectValid(eAOE))
        {

            if ((GetEffectSpellId(eAOE) == SPELL_MIND_FOG || GetEffectSpellId(eAOE) == 1547) && GetAreaOfEffectCreator() == GetEffectCreator(eAOE))
            {
                if(GetEffectType(eAOE) == EFFECT_TYPE_SAVING_THROW_DECREASE)
                {
                    RemoveEffect(GetExitingObject(), eAOE);
                    bValid = TRUE;
                }
            }
            eAOE = GetNextEffect(GetExitingObject());
        }
    }
    if(bValid == TRUE)
    {
        gsSPApplyEffect(GetExitingObject(), EffectSavingThrowDecrease(SAVING_THROW_WILL, 10), GetSpellId(), RoundsToSeconds(d6(2)));
    }
}
