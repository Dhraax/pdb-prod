/* Script for the Avatar object from the deck of many things,
 * which allows the user to polymorph into an avatar at will.
 */

#include "mti_libreria"
#include "x0_i0_deckmany"

int GetIsPolymorphed(object oTarget)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if (GetEffectType(eEff) == EFFECT_TYPE_POLYMORPH)
            return TRUE;
        eEff = GetNextEffect(oTarget);
    }
    return FALSE;
}

void main()
{
    // Get the stored target
    object oTarget = OBJECT_SELF;
    if (!GetIsObjectValid(oTarget))
        return;

    // Don't reapply if we're already polymorphed
    if (GetIsPolymorphed(oTarget))
        return;

    // NO NOS PODEMOS POLIMORFAR CUANDO YA LO ESTAMOS O ESTAMOS MONTADO A CABALLO
    if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, "<cþ>No puedes polimorfarte cuando estás montado a caballo.</c>");
        return;
    }
    if(ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE)
    {
        SendMessageToPC(OBJECT_SELF, "<cþ>Despolimórfate antes de usar esta habilidad.</c>");
        return;
    }

    DoAvatarDeckCardTransform(oTarget);
}
