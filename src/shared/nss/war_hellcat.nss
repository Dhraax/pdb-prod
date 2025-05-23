// Golpe Horrible Brujo //

#include "x2_inc_spellhook"
#include "mti_libreria"
#include "pb_nivellanzador"
#include "war_utilities"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more
*/
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    if (!CheckWarlockSpellCharisma()) return;

    // NO NOS PODEMOS POLIMORFAR CUANDO YA LO ESTAMOS O ESTAMOS MONTADO A CABALLO
    if(ObtenerIntPersistente(OBJECT_SELF, "CAB_MONTADO") > 0)
    {
        SendMessageToPC(OBJECT_SELF, "No puedes polimorfarte cuando estás montado a caballo.</c>");
        return;
    }
    if(ObtenerIntPersistente(OBJECT_SELF, "APA_CAMBIADA") == TRUE)
    {
        SendMessageToPC(OBJECT_SELF, "Despolimórfate antes de usar ese conjuro.</c>");
        return;
    }


    //Declare major variables
    object oTarget = GetSpellTargetObject();
    effect eVis = EffectVisualEffect(1632);
    effect eOculto = EffectConcealment(50);
    effect eVelocidad = EffectMovementSpeedIncrease(75);
    effect eFx1 = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
    effect eFx2 = EffectInvisibility(INVISIBILITY_TYPE_DARKNESS);
    effect eFx3 = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect ePoly;
    int nPoly;
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);

    //Gato del Infierno
    nPoly = 131;
    ePoly = EffectPolymorph(nPoly);

    effect eLink = EffectLinkEffects(eOculto, eFx1);
    eLink = EffectLinkEffects(eLink, eFx2);
    eLink = EffectLinkEffects(eLink, eFx3);
    eLink = EffectLinkEffects(eLink, eVelocidad);
    eLink = EffectLinkEffects(eLink, ePoly);

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POLYMORPH_SELF, FALSE));

    //Apply the VFX impact and effects
    AssignCommand(oTarget, ClearAllActions()); // prevents an exploit
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration));
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}






