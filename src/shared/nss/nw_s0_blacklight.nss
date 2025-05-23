//::///////////////////////////////////////////////
//:: Blacklight
//:: NW_S0_Blacklight
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    Creas un área de oscuridad parcial en el objetivo seleccionado.
    En áreas oscuras o de noche, la luz negra se tornará ligeramente verdosa.
    Podrías incluso enfocar la luz negra en un objeto que hayas tirado en el
    suelo. El conjuro se hará más potente si hay más de un objetivo encantado
    con luz negra, cerca. Se necesita un puñado de polvo de antiluz para
    lanzar el sortilegio.
*/
//:://////////////////////////////////////////////
//:: Created By: Puerta de Baldur
//:: Modified By: Mimiqp (mimiqp100@gmail.com)
//:: Modified On: May 20, 2024
//:: Modifications: MVP conversion from
//:: being a function called on object usage to
//:: a spell memorised from the spellbook and used
//:: as any other spell from the game.
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "inc_spells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    effect eAntiluz = EffectVisualEffect(VFX_DUR_ANTI_LIGHT_10);
    int iLevel = GetHitDice(oPC);

    // El conjuro falla si no tiene un objetivo
    if(GetIsObjectValid(oTarget) == FALSE)
    {
      oTarget = oPC;
    }

    float fNivel = IntToFloat(iLevel);
    float fDuracion = fNivel * 60.0;
    int nMetaMagic = GetMetaMagicFeat();

    //Check for metamagic extend
    if (nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
    {
         fDuracion = fDuracion * 2;
    }

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eAntiluz,oTarget,fDuracion);

    effect eOcultacion = EffectConcealment(10);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eOcultacion, oTarget, fDuracion);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

