//::///////////////////////////////////////////////
//:: Knock
//:: NW_S0_Knock
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Opens doors not locked by magical means.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Nov 29, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg 2003/07/31 - Added signal event and custom door flags
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "nw_i0_spells"
#include "x2_inc_spellhook"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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

    object oTarget;
    effect eVis = EffectVisualEffect(VFX_IMP_KNOCK);
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    float fDelay;
    int nResist, iCDPuerta, iTirada;

    while(GetIsObjectValid(oTarget))
    {
        SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId()));
        fDelay = GetRandomDelay(0.5, 2.5);
        if(GetLocked(oTarget) && GetLockKeyRequired(oTarget) == FALSE && GetLockKeyTag(oTarget) == "")
        {
            nResist =  GetDoorFlag(oTarget,DOOR_FLAG_RESIST_KNOCK);
            if(nResist == 0)
            {
                iCDPuerta = GetLockUnlockDC(oTarget);
                iTirada = 20 + d10();
                if(iCDPuerta <= iTirada)
                {
                   SendMessageToPC(OBJECT_SELF, "<c´þd>Éxito de apertura en "+GetName(oTarget)+": "+IntToString(iTirada)+" vs CD "+IntToString(iCDPuerta)+".</c>");
                   DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                   AssignCommand(oTarget, ActionUnlockObject(oTarget));
                }
                else
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DESTRUCTION), oTarget));
                    if(iCDPuerta > 30) SendMessageToPC(OBJECT_SELF, "<cþ<<>Apertura fracasó en "+GetName(oTarget)+": Éxito imposible vs CD "+IntToString(iCDPuerta)+".</c>");
                    else SendMessageToPC(OBJECT_SELF, "<cþ<<>Apertura fracasó en "+GetName(oTarget)+": "+IntToString(iTirada)+" vs CD "+IntToString(iCDPuerta)+".</c>");
                }
            }
            else if(nResist == 1)
            {
                FloatingTextStrRefOnCreature(83887,OBJECT_SELF);
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, 50.0, GetLocation(OBJECT_SELF), FALSE, OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
       
    }
	 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
