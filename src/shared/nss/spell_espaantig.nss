//::///////////////////////////////////////////////
//:: Holy Sword
//:: X2_S0_HolySwrd
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Grants holy avenger properties.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "x2_inc_toollib"
#include "pb_nivellanzador"

//ANTIAPILAMIENTO ESPECIAL: ESPADA VENGADORA, ESPADA SACRÍLEGA, ESPADA DE LOS ANTIGUOS
void TienePropiedadesProhibidas(object oPC, object oItem)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipLoop))
    {
        //Propiedades del ESPADA VENGADORA
        if(GetItemPropertyTag(ipLoop) == "Espada_Vengadora_BonoAtaque" || GetItemPropertyTag(ipLoop) == "Espada_Vengadora_CastSpell" || GetItemPropertyTag(ipLoop) == "Espada_Vengadora_Visual" || GetItemPropertyTag(ipLoop) == "Espada_Vengadora_RC"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ESPADA DE LOS ANTIGUOS
        //if(GetItemPropertyTag(ipLoop) == "Espada_Antiguos_BonoAtaque" || GetItemPropertyTag(ipLoop) == "Espada_Antiguos_CastSpell" || GetItemPropertyTag(ipLoop) == "Espada_Antiguos_Visual" || GetItemPropertyTag(ipLoop) == "Espada_Antiguos_RC"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ESPADA SACRILEGA
        if(GetItemPropertyTag(ipLoop) == "Espada_Sacrilega_BonoAtaque" || GetItemPropertyTag(ipLoop) == "Espada_Sacrilega_CastSpell" || GetItemPropertyTag(ipLoop) == "Espada_Sacrilega_Visual" || GetItemPropertyTag(ipLoop) == "Espada_Sacrilega_RC"){RemoveItemProperty(oItem,ipLoop);}
        ipLoop=GetNextItemProperty(oItem);
    }

}

void AddBlessEffectToWeapon(object oTarget, float fDuration, itemproperty ipBono, itemproperty ipCastSpell, itemproperty ipVisual, itemproperty ipRC)
{
    IPSafeAddItemProperty(oTarget, ipBono, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE);
    IPSafeAddItemProperty(oTarget, ipCastSpell, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE);
    IPSafeAddItemProperty(oTarget, ipVisual, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE);
    IPSafeAddItemProperty(oTarget, ipRC, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE);
    return;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
/*
  Spellcast Hook Code
  Added 2003-07-07 by Georg Zoeller
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
    effect eVis = EffectVisualEffect(VFX_IMP_GOOD_HELP);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nDuration = GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();

   if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }

    object oMyWeapon = OBJECT_INVALID;
    object oTarget = GetSpellTargetObject();

    itemproperty ipBono = ItemPropertyEnhancementBonus(5);
    itemproperty ipCastSpell = ItemPropertyOnHitCastSpell(145,GetTotalCasterLevel(OBJECT_SELF));
    itemproperty ipVisual = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
    itemproperty ipRC = ItemPropertyBonusSpellResistance(IP_CONST_SPELLRESISTANCEBONUS_16);
    ipBono = TagItemProperty(ipBono, "Espada_Antiguos_BonoAtaque");
    ipCastSpell = TagItemProperty(ipCastSpell, "Espada_Antiguos_CastSpell");
    ipVisual = TagItemProperty(ipVisual, "Espada_Antiguos_Visual");
    ipRC = TagItemProperty(ipRC, "Espada_Antiguos_RC");

    if(oMyWeapon == OBJECT_INVALID) {
        oMyWeapon = ArmaCuerpoACuerpoObjetivoOEquipada();
        if(oMyWeapon != OBJECT_INVALID) {
            int nItemBase = GetBaseItemType(oMyWeapon);
            object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
            if(oGloves != OBJECT_INVALID && GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 0 && (nItemBase == BASE_ITEM_CBLUDGWEAPON || nItemBase == BASE_ITEM_CPIERCWEAPON ||
                nItemBase == BASE_ITEM_CSLASHWEAPON || nItemBase == BASE_ITEM_CSLSHPRCWEAP) ) {
                oMyWeapon = oGloves;
            }
        } else {
            object oGloves = GetItemInSlot(INVENTORY_SLOT_ARMS, oTarget);
            if(oGloves != OBJECT_INVALID && GetLevelByClass(CLASS_TYPE_MONK, oTarget) > 0) {
                oMyWeapon = oGloves;
            }
        }
    }



    if(GetIsObjectValid(oMyWeapon) )
    {
        SignalEvent(oMyWeapon, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
            //Arma Feerica no se acumula con otros conjuros de nivel 1 del Paladín.
            TienePropiedadesProhibidas(GetItemPossessor(oMyWeapon), oMyWeapon);
            //Añadimos los efectos y demases.
            AddBlessEffectToWeapon(oMyWeapon, RoundsToSeconds(nDuration), ipBono, ipCastSpell, ipVisual, ipRC);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), RoundsToSeconds(nDuration));
            SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", StringToInt(SQLite_GetSystemTime()) + FloatToInt(RoundsToSeconds(nDuration)));
        }
        TLVFXPillar(VFX_IMP_GOOD_HELP, GetLocation(GetSpellTargetObject()), 4, 0.0f, 6.0f);
        DelayCommand(1.0f, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_SUPER_HEROISM),GetLocation(GetSpellTargetObject())));
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }

}
