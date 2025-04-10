//::///////////////////////////////////////////////
//:: Poison
//:: NW_S0_Poison.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Must make a touch attack. If successful the target
    is struck down with wyvern poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);
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

// End of Spell Cast Hook


    //Declare major variables
    object oItem = GetSpellCastItem();
    object oTarget = GetSpellTargetObject();
    object oPj = GetLastAttacker(oTarget);

    int nType = GetBaseItemType(oItem);
    if (!IPGetIsMeleeWeapon(oItem) &&
    !IPGetIsProjectile(oItem)   &&
    nType != BASE_ITEM_SHURIKEN &&
    nType != BASE_ITEM_DART &&
    nType != BASE_ITEM_THROWINGAXE)
    {
        //vamos a intentar ajustar el tipo de veneno segun la CD que mas se ajuste al nivel del lanzador y su modificador
        //la formula original era CD 10 +1/2nivel +modificador de SAB

        int nVenom;
        int nCaster = (GetCasterLevel(OBJECT_SELF) / 2 );
        int nSabMod = (GetAbilityModifier(ABILITY_WISDOM, OBJECT_SELF));
        int nIntMod = (GetAbilityModifier(ABILITY_INTELLIGENCE, OBJECT_SELF));
        int nMod = nSabMod;
            if (GetLastSpellCastClass() == CLASS_TYPE_ASSASSIN) nMod = nIntMod;
        int nCD = (nCaster + nMod + 10);

        if (nCD <= 15)
           {
           nVenom = POISON_PHASE_SPIDER_VENOM;
           }
        else if ((nCD > 15) && (nCD <= 18))
           {
           nVenom = POISON_DARK_REAVER_POWDER;
           }
        else if ((nCD > 18) && (nCD <= 20))
           {
           nVenom = POISON_DEATHBLADE;
           }
        else if ((nCD > 20) && (nCD < 26))
           {
           nVenom = POISON_PIT_FIEND_ICHOR;
           }
        else if ((nCD >= 26) && (nCD <= 30))
           {
           nVenom = POISON_HUGE_SPIDER_VENOM;
           }
        else if (nCD > 30)
           {
           nVenom = POISON_COLOSSAL_SPIDER_VENOM;
           }


        effect ePoison = EffectPoison(nVenom);

        //conjuro
        int nTouch = TouchAttackMelee(oTarget);//
        if(!GetIsReactionTypeFriendly(oTarget))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_POISON));
            //Make touch attack
            if (nTouch > 0)
            {
                //Make SR Check
                if (!MyResistSpell(OBJECT_SELF, oTarget))
                {
                    //Apply the poison effect and VFX impact
                    ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
                 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
                }
            }
        }
    } else {
        int idVeneno = GetLocalInt(oItem, "idVeneno");
        if (idVeneno == 0) idVeneno = 1;
        effect ePoison = EffectPoison(idVeneno);
        //Apply the poison effect and VFX impact
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget);
    }
}

