#include "pb_nivellanzador"

void main()
{
    object oCaster = GetLastSpellCaster();
    object oTarget = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCaster);
    string sItem = GetTag(oItem);
    string sTarget =  GetTag(oTarget);
    //SendMessageToPC(oCaster, sTarget);

    if ((GetHasFeat(FEAT_MASTERY_SHAPES, oCaster)) && (GetLocalInt(oCaster, "archmage_mastery_shaping") == 1) && (!GetIsReactionTypeHostile(oTarget, oCaster) || oTarget == oCaster || GetMaster(oTarget) == oCaster))
    {
        SetLocalInt(oTarget,"X2_L_LAST_RETVAR", 3);
        return;
    }
    // This part is to screen friendly targets.
    // Set it to:
    // 1 if you want the spell resistance vfx to fire
    // 2 for globe vfx
    // 3 for spell mantle vfx
    // 4 or higher for no vfx at all.

    SetLocalInt(oTarget,"X2_L_LAST_RETVAR", 0);
}





