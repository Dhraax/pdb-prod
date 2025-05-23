//::///////////////////////////////////////////////
//:: User Defined OnHitCastSpell code
//:: x2_s3_onhitcast
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This file can hold your module specific
    OnHitCastSpell definitions

    How to use:
    - Add the Item Property OnHitCastSpell: UniquePower (OnHit)
    - Add code to this spellscript (see below)

   WARNING!
   This item property can be a major performance hog when used
   extensively in a multi player module. Especially in higher
   levels, with each player having multiple attacks, having numerous
   of OnHitCastSpell items in your module this can be a problem.

   It is always a good idea to keep any code in this script as
   optimized as possible.


*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-22
//:://////////////////////////////////////////////

#include "x2_inc_switches"
#include "nostack_inc"
#include "war_utilities"
#include "pb_constantes"

void BorrarGolpeHorrible(object oPC, object oItem)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipLoop))
    {

        if(GetItemPropertyTag(ipLoop) == "Golpe_Horrible_CastSpell"){RemoveItemProperty(oItem,ipLoop);}
        ipLoop=GetNextItemProperty(oItem);
    }

}

void main()
{

   object oItem;        // The item casting triggering this spellscript
   object oSpellTarget; // On a weapon: The one being hit. On an armor: The one hitting the armor
   object oSpellOrigin; // On a weapon: The one wielding the weapon. On an armor: The one wearing an armor

   // fill the variables
   oSpellOrigin = OBJECT_SELF;
   oSpellTarget = GetSpellTargetObject();
   oItem        = GetSpellCastItem();
   int iItemBaseType = GetBaseItemType(oItem);

   // Berserker Frenetico
    if(iItemBaseType == BASE_ITEM_ARMOR && GetHasFeat(1443, oSpellOrigin))
    {
        if(!GetHasFeatEffect(1443, oSpellOrigin))
        {
            DelayCommand(0.01, ExecuteScript("prc_autofrenzy", oSpellOrigin) );
        }
        else if(GetCurrentHitPoints(oSpellOrigin) == 1 && GetHasFeat(1453, oSpellOrigin))
        {
            DelayCommand(0.01, ExecuteScript("prc_fb_inmortal", oSpellOrigin) );
        }
    }

    //Golpe Horrible Brujo
    if(GetLocalInt(oSpellOrigin, "GOLPEHORRIBLE") == TRUE )
    {
        int nLevel = GetLevelByClass(CLASS_TYPE_WARLOCK, oSpellOrigin);
        int nDam = GetWarlockExplosionDamage(oSpellOrigin);
        int nDamageType = GetLocalInt(oSpellOrigin, "esencia_sobrenatural");
        int nModAptitud = GetLocalInt(oSpellOrigin, "war_mod_aptitud");
        effect eVis = EffectVisualEffect(77);
        if (nModAptitud) UsoModAptitud();

        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nDamageType ? nDamageType : DAMAGE_TYPE_MAGICAL), oSpellTarget);
        AjusteEsencia(oSpellTarget, nModAptitud, oSpellOrigin, TRUE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oSpellTarget);
        DeleteLocalInt(oSpellOrigin, "GOLPEHORRIBLE");
        //IPRemoveMatchingItemProperties(oItem, ITEM_PROPERTY_ONHITCASTSPELL, DURATION_TYPE_TEMPORARY, -1 );
        BorrarGolpeHorrible(oSpellOrigin, oItem);
    }

   if (GetIsObjectValid(oItem))
   {
     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_ONHITCAST);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }
     }
   }
}

