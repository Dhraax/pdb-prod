//::///////////////////////////////////////////////
//::///////////////////////////////////////////////
//:: Wall of Fire: On Enter
//:: NW_S0_WallFireA.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Person within the AoE take 4d6 fire damage
    per round.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"
#include "war_utilities"
#include "pb_constantes"


void MuroFuego(object oTarget)
{
    int nDamage = d6()+ (GetLevelByClass(CLASS_TYPE_WARLOCK, GetAreaOfEffectCreator()) / 2);
    int nDamage2 = d6()+ (GetLevelByClass(CLASS_TYPE_WARLOCK, GetAreaOfEffectCreator()) / 2);
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE));
    float fDelay;

    if(PB_Race_GetIsUndead(oTarget)) nDamage = nDamage * 2;

    if(nMuroFuego > 0 )
    {
       fDelay = GetRandomDelay(1.0, 2.2);
       effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
       effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
       effect eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_MAGICAL);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       DelayCommand(6.0, MuroFuego(oTarget));
    }
}


void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    // Declare major variables
    int nDamage;
    int nDamage2;
    int iCarisma = GetAbilityModifier(ABILITY_CHARISMA, GetAreaOfEffectCreator());
    effect eDam;
    effect eDam2;

    // Capture the first target object in the shape.
    object oTarget = GetEnteringObject();

    // Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);


    // Leer el contador de muros de fuego activos simultaneamente
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE));

    // Si el jugador está dentro de un muro de fuego, no aplicar más daño de entrada al muro de fuego pero aumentar
    if (nMuroFuego > 0) {
        SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE), nMuroFuego + 1);
        return;
    }

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        // Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));

        // Make SR check, and appropriate saving throw(s).
        if (!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            // Roll damage.
            nDamage = d6(2)+ (GetLevelByClass(CLASS_TYPE_WARLOCK, GetAreaOfEffectCreator())/2);
            nDamage2 = d6(2) + (GetLevelByClass(CLASS_TYPE_WARLOCK, GetAreaOfEffectCreator())/2);
            if (PB_Race_GetIsUndead(oTarget)) nDamage = nDamage*2;
            if (nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
                eDam2 = EffectDamage(nDamage2, DAMAGE_TYPE_MAGICAL);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam2, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WARLOCK_WALLFIRE), nMuroFuego + 1);
                DelayCommand(6.0, MuroFuego(oTarget));
            }
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

