// Golpe Horrible Brujo //

#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "war_utilities"
#include "inc_timelock"
void ApplyGolpeHorrible(object oPC, object oWeapon, itemproperty ipCastSpell)
{
     IPSafeAddItemProperty(oWeapon, ipCastSpell, 999999.0, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE, FALSE);
}

void main()
{
    // Cooldown check.
    if(GetIsTimelocked(OBJECT_SELF, "Golpe Horrible"))
    {
        TimelockErrorMessage(OBJECT_SELF, "Golpe Horrible");
        return;
    }
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

   if (!CheckWarlockSpellCharisma()) return;

    // End of Spell Cast Hook

    //Declare major variables
    object oTarget = GetSpellTargetObject();
    object oPC = OBJECT_SELF;
    effect eVis = EffectVisualEffect(911);
    effect eVis2 = EffectVisualEffect(89);
    effect eLink = EffectLinkEffects(eVis, eVis2);

    itemproperty ipCastSpell = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
    ipCastSpell = TagItemProperty(ipCastSpell, "Golpe_Horrible_CastSpell");

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));

    if(oTarget == oPC)
    {
        object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
        if(oWeapon == OBJECT_INVALID) {oWeapon = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);}
        if(oWeapon != OBJECT_INVALID && !GetWeaponRanged(oWeapon))
        {
            ApplyGolpeHorrible(oPC, oWeapon, ipCastSpell);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oPC);
            SetTimelock(oPC, 6, "Golpe Horrible", 0, 0);
            SetLocalInt(oPC, "GOLPEHORRIBLE", TRUE);
        }
        else SendMessageToPC(oPC, "<c´$$>No puedes utilizar Golpe Horrible sin un arma cuerpo a cuerpo o guantes.</c>");
    }

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

