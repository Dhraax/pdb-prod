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


void MuroFuego(object oTarget)
{
    int nDamage = d6(4) + GetTotalCasterLevel(GetAreaOfEffectCreator());
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));
    float fDelay;

    if(PB_Race_GetIsUndead(oTarget)) nDamage = nDamage*2;

    if(nMuroFuego > 0)
    {
       fDelay = GetRandomDelay(1.0, 2.2);
       effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
       effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_FIRE);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
       ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
       DelayCommand(6.0, MuroFuego(oTarget));
    }
}

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    //Declare major variables
    int nMetaMagic = GetMetaMagicFeat();
    int nDamage;
    effect eDam;

    //Capture the first target object in the shape.
    object oTarget = GetEnteringObject();

    //Declare and assign personal impact visual effect.
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);

    // Leer el contador de muros de fuego activos simultaneamente
    int nMuroFuego = GetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE));

    // Si el jugador est dentro de un muro de fuego, no aplicar ms dao de entrada al muro de fuego pero aumentar
    if (nMuroFuego > 0) {
        SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego + 1);
        return;
    }


    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_WALL_OF_FIRE));

        //Make SR check, and appropriate saving throw(s).
        if(!MyResistSpell(GetAreaOfEffectCreator(), oTarget))
        {
            //Roll damage.
            nDamage = d6(4) + GetTotalCasterLevel(GetAreaOfEffectCreator());

            //Enter Metamagic conditions
            if (nMetaMagic == METAMAGIC_MAXIMIZE)
            {
                nDamage = 24 + GetTotalCasterLevel(GetAreaOfEffectCreator());//Damage is at max
            }
            if (nMetaMagic == METAMAGIC_EMPOWER)
            {
                nDamage = nDamage + (nDamage/2); //Damage/Healing is +50%
            }

            if(PB_Race_GetIsUndead(oTarget)) nDamage * 2;
            if(nDamage > 0)
            {
                // Apply effects to the currently selected target.
                eDam = EffectDamage(nDamage, ChangedElementalDamage(GetAreaOfEffectCreator(), DAMAGE_TYPE_FIRE));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                SetLocalInt(oTarget, "AOE_" + IntToString(AOE_PER_WALLFIRE), nMuroFuego + 1);
                DelayCommand(6.0, MuroFuego(oTarget));

            }
        }
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
