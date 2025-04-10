
//:://////////////////////////////////////////////
/*
    DobleSombrio para Puerta de Baldur EE
*/
//:://////////////////////////////////////////////
//:: Created By: Darth
//:://////////////////////////////////////////////

#include "nw_i0_generic"
#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void CleanCopy(object oImage)
{
     SetLootable(oImage, FALSE);
     object oItem = GetFirstItemInInventory(oImage);
     while(GetIsObjectValid(oItem))
     {
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
        oItem = GetNextItemInInventory(oImage);
     }
     int i;
     for(i=0;i<NUM_INVENTORY_SLOTS;i++)//equipment
     {
        oItem = GetItemInSlot(i, oImage);
        SetDroppableFlag(oItem, FALSE);
        SetItemCursedFlag(oItem, TRUE);
     }
     TakeGoldFromCreature(GetGold(oImage), oImage, TRUE);
}

void main()
{

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ILLUSION);
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
	object oCopyAntiguo = GetLocalObject(oPC, "CLONSOMBRIO");
    int nDuration = 10; //Entedemos que tiene 10 niveles de Adepto

    //Penalizadores e inmunidades
	effect eFallo = SupernaturalEffect(EffectSpellFailure(100));
	effect eInmunity1 = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
	effect eInmunity2 = SupernaturalEffect(EffectImmunity(IMMUNITY_TYPE_DEATH));
	effect eAttackDecrease = SupernaturalEffect(EffectAttackDecrease(50));

	effect eInmuni = EffectLinkEffects(eInmunity1, eInmunity2);
	effect eLink = EffectLinkEffects(eFallo, eAttackDecrease);

	eLink = EffectLinkEffects(eLink, eInmuni);

	//Destruimos el antiguo clon si existe
    if(GetIsObjectValid(oCopyAntiguo)){ RemoveHenchman(GetMaster(oCopyAntiguo),oCopyAntiguo); AssignCommand(oCopyAntiguo,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oCopyAntiguo, 0.5); }

    object oCopy = CopyObject(OBJECT_SELF, GetSpellTargetLocation(), OBJECT_INVALID, "Clone"+GetName(OBJECT_SELF));

    DelayCommand(0.1f, CleanCopy(oCopy)); //Inventario no drop
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCopy));

    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER, 100, OBJECT_SELF);
    SetIsTemporaryFriend(oCopy, OBJECT_SELF);
	   SetLocalObject(oPC, "CLONSOMBRIO", oCopy);
    DestroyObject(oCopy, TurnsToSeconds(nDuration));

    DelayCommand(1.0, AddHenchman(oPC, oCopy));

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

}


