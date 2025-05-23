//::///////////////////////////////////////////////
//:: Darkfire
//:: X2_S0_Darkfire
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Gives a melee weapon 1d6 fire damage +1 per two caster
  levels to a maximum of +10.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////
//:: Updated by Andrew Nobbs May 08, 2003
//:: 2003-07-29: Rewritten, Georg Zoeller


#include "nw_i0_spells"
#include "x2_i0_spells"
#include "zep_inc_armas"
#include "x2_inc_spellhook"
#include "inc_sqlite_time"
#include "pb_nivellanzador"

//ANTIAPILAMIENTO ESPECIAL: ARMA FLAMIGERA Y FUEGO OSCURO NO DEBEN APILARSE
void TienePropiedadesProhibidas(object oPC, object oItem)
{
    itemproperty ipLoop = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(ipLoop))
    {
        //Propiedades del ARMA FLAMIGERA
        if(GetItemPropertyTag(ipLoop) == "Arma_Flamigera_CastSpell" || GetItemPropertyTag(ipLoop) == "Arma_Flamigera_Visual"){RemoveItemProperty(oItem,ipLoop);}
        //Propiedades del ARMA MALDITA
        //if(GetItemPropertyTag(ipLoop) == "Fuego_Oscuro_CastSpell" || GetItemPropertyTag(ipLoop) == "Fuego_Oscuro_Visual"){RemoveItemProperty(oItem,ipLoop);}
        ipLoop=GetNextItemProperty(oItem);
    }

}

void AddFlamingEffectToWeapon(object oTarget, float fDuration, itemproperty ipCastSpell, itemproperty ipVisual)
{
    IPSafeAddItemProperty(oTarget, ipCastSpell, fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING, FALSE);
    IPSafeAddItemProperty(oTarget, ipVisual, fDuration,X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
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
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_FIRE);
    eVis = EffectLinkEffects(EffectVisualEffect(VFX_IMP_FLAME_M),eVis);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    int nCasterLvl = GetTotalCasterLevel(OBJECT_SELF);
    int nDuration = 2 * nCasterLvl;
    int nMetaMagic = GetMetaMagicFeat();


    //Limit nCasterLvl to 10, so it max out at +10 to the damage.
    //Bugfix: Limiting nCasterLvl to *20* - the damage calculation
    //        divides it by 2.
    if(nCasterLvl > 20)
    {
        nCasterLvl = 20;
    }

    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration * 2; //Duration is +100%
    }


    itemproperty ipCastSpell = ItemPropertyOnHitCastSpell(127,GetTotalCasterLevel(OBJECT_SELF));
    itemproperty ipVisual = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
    ipCastSpell = TagItemProperty(ipCastSpell, "Arma_Flamigera_CastSpell");
    ipVisual = TagItemProperty(ipVisual, "Arma_Flamigera_Visual");

    object oMyWeapon = OBJECT_INVALID;
    object oTarget = GetSpellTargetObject();

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
            //Arma Flamígera no se acumula con Fuego Oscuro
           TienePropiedadesProhibidas(GetItemPossessor(oMyWeapon), oMyWeapon);
           //Añadimos los efectos y demases.
           AddFlamingEffectToWeapon(oMyWeapon, TurnsToSeconds(nDuration), ipCastSpell, ipVisual);
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
