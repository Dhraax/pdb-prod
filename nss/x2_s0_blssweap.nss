//::///////////////////////////////////////////////
//:: Bless Weapon
//:: X2_S0_BlssWeap
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

  If cast on a crossbow bolt, it adds the ability to
  slay rakshasa's on hit

  If cast on a melee weapon, it will add the
      grants a +1 enhancement bonus.
      grants a +2d6 damage divine to undead

  will add a holy vfx when command becomes available

  If cast on a creature it will pick the first
  melee weapon without these effects

*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Nov 28, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 09, 2003
//:: 2003-07-07: Stacking Spell Pass, Georg Zoeller
//:: 2003-07-15: Complete Rewrite to make use of Item Property System

#include "nw_i0_spells"
#include "x2_i0_spells"
#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"

void AddBlessEffectToWeapon(object oTarget, float fDuration, itemproperty ipBono, itemproperty ipCastSpell, itemproperty ipVisual)
{
    IPSafeAddItemProperty(oTarget, ipBono, fDuration, X2_IP_ADDPROP_POLICY_KEEP_EXISTING,FALSE);
    IPSafeAddItemProperty(oTarget, ipCastSpell, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE);
    IPSafeAddItemProperty(oTarget, ipVisual, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
    return;
}

//ANTIAPILAMIENTO ESPECIAL: ARMA FEERICA, ARMA MALDITA y BENDECIR ARMA, NO DEBERÍAN PODER COMBINARSE.
void TienePropiedadesProhibidas(object oPC, object oItem)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipLoop))
    {
        //Propiedades del ARMA FEERICA
        if(GetItemPropertyTag(ipLoop) == "Arma_Feerica_CastSpell" || GetItemPropertyTag(ipLoop) == "Arma_Feerica_Visual" || GetItemPropertyTag(ipLoop) == "Arma_Feerica_BonoAtaque"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ARMA MALDITA
        if(GetItemPropertyTag(ipLoop) == "Arma_Maldita_CastSpell" || GetItemPropertyTag(ipLoop) == "Arma_Maldita_Visual" || GetItemPropertyTag(ipLoop) == "Arma_Maldita_BonoAtaque"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ARMA CAZADORA
        if(GetItemPropertyTag(ipLoop) == "Arma_Cazadora_CastSpell" || GetItemPropertyTag(ipLoop) == "Arma_Cazadora_Visual" || GetItemPropertyTag(ipLoop) == "Arma_Cazadora_BonoAtaque"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del BENDECIR ARMA
        //if(GetItemPropertyTag(ipLoop) == "Bendecir_Arma_CastSpell" || GetItemPropertyTag(ipLoop) == "Bendecir_Arma_Visual" || GetItemPropertyTag(ipLoop) == "Bendecir_Arma_BonoAtaque"){RemoveItemProperty(oItem,ipLoop);}
        ipLoop=GetNextItemProperty(oItem);
    }
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
    effect eVis = EffectVisualEffect(VFX_IMP_SUPER_HEROISM);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    object oTarget = GetSpellTargetObject();
    int nDuration = 2 * GetTotalCasterLevel(OBJECT_SELF);
    int nMetaMagic = GetMetaMagicFeat();
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
       nDuration = nDuration * 2; //Duration is +100%
    }

    // ---------------- TARGETED ON BOLT  -------------------
    /*if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM)
    {
        // special handling for blessing crossbow bolts that can slay rakshasa's
        if (GetBaseItemType(oTarget) ==  BASE_ITEM_BOLT)
        {
           SignalEvent(GetItemPossessor(oTarget), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));
           IPSafeAddItemProperty(oTarget, ItemPropertyOnHitCastSpell(123,1), RoundsToSeconds(nDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oTarget));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oTarget), RoundsToSeconds(nDuration));
           return;
        }
    }*/
   //Enlistamos Propiedades.
   itemproperty ipBono = ItemPropertyEnhancementBonus(1);
   itemproperty ipCastSpell = ItemPropertyOnHitCastSpell(148,GetTotalCasterLevel(OBJECT_SELF));
   itemproperty ipVisual = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
   ipBono = TagItemProperty(ipBono, "Bendecir_Arma_BonoAtaque");
   ipCastSpell = TagItemProperty(ipCastSpell, "Bendecir_Arma_CastSpell");
   ipVisual = TagItemProperty(ipVisual, "Bendecir_Arma_Visual");

   object oMyWeapon = OBJECT_INVALID;

    /*if(GetIsObjectValid(oTarget) && GetObjectType(oTarget) == OBJECT_TYPE_ITEM && GetBaseItemType(oTarget) == BASE_ITEM_GLOVES) {
        oMyWeapon = oTarget;
    }*/

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
        SignalEvent(GetItemPossessor(oMyWeapon), EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

        if (nDuration>0)
        {
          //Bendecir arma no se acumula con otros conjuros de nivel 1 del Paladín.
           TienePropiedadesProhibidas(GetItemPossessor(oMyWeapon), oMyWeapon);
           //Añadimos los efectos y demases.
           AddBlessEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration), ipBono, ipCastSpell, ipVisual);
           ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, GetItemPossessor(oMyWeapon));
           ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, GetItemPossessor(oMyWeapon), TurnsToSeconds(nDuration));
           int nTimer = StringToInt(SQLite_GetSystemTime()) + FloatToInt(TurnsToSeconds(nDuration));
            if(nTimer > GetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR"))
                SetLocalInt(oMyWeapon, "FIN_TEMPORIZADOR", nTimer);
           DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        }
        return;
    }
        else
    {
           FloatingTextStrRefOnCreature(83615, OBJECT_SELF);
           return;
    }
}
