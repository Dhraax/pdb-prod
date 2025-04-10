//::///////////////////////////////////////////////
//:: Ice Skin
//:: NW_S0_IceSkin
//:: Copyright (c) 2024 Puerta de Baldur
//:://////////////////////////////////////////////
/*
    El lanzador transmuta su cuerpo y lo hace helado e inmune al frío, aunque
    muy débil contra cualquier tipo de fuego. Además, el transmutado tendrá
    resistencia al daño contra armas normales.
    Al expirar, su cuerpo volverá a la normalidad.
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
#include "pb_nivellanzador"

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

    object oPC = OBJECT_SELF;
    effect eHielo = EffectVisualEffect(VFX_DUR_ICESKIN);
    effect eInmunidad1 = EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,100);
    effect eInmunidad2 = EffectDamageImmunityDecrease(DAMAGE_TYPE_FIRE,100);
    effect ePremo = EffectVisualEffect(VFX_DUR_PROT_PREMONITION);
    effect eDispel1 = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
    effect eReduc = EffectDamageReduction(10,DAMAGE_TYPE_BASE_WEAPON,0);

    int nSpell       = GetSpellId();
    int nCasterLevel = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic   = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;
    int nDuration    = nCasterLevel;

    //raise event
    SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, nSpell, FALSE));

    //affection check
    if (! gsSPGetIsAffected(GS_SP_TYPE_BENEFICIAL, OBJECT_SELF, oPC)) return;

    //duration
    if (nMetaMagic == METAMAGIC_EXTEND) nDuration *= 2;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHielo, oPC,RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmunidad1, oPC,RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eInmunidad2, oPC,RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eReduc, oPC,RoundsToSeconds(nDuration));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePremo, oPC,1.0);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDispel1, oPC);

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
