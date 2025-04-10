//::///////////////////////////////////////////////
//:: Summon Shadow
//:: NW_S0_SummShad.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spell powerful ally from the shadow plane to
    battle for the wizard
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 26, 2001
//:://////////////////////////////////////////////


#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "x0_i0_henchman"
#include "lib_disguise"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
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
    object oPC = OBJECT_SELF;
    object oCopyAntiguo = GetLocalObject(oPC, "CLONSOMBRIO");
    int iHD = GetLevelByClass(27, oPC);
    int nDuration = iHD;
    int eApariencia = GetAppearanceType(oPC);
    int eGenero = GetGender(oPC);
    string eName = PB_Disguise_GetNameOverride(oPC);
    object oCreature;

    string sSummon;

       if(iHD >= 9 ) sSummon = "sombradance3";
       else if (iHD >= 6 ) sSummon = "sombradance2";
       else if (iHD >=3 ) sSummon = "sombradance";

    effect eVis = EffectVisualEffect(VFX_FNF_SUMMON_UNDEAD);
    effect eSombra = SupernaturalEffect(EffectVisualEffect(VFX_DUR_PROT_SHADOW_ARMOR));

    //Destruimos el antiguo clon si existe
    if(GetIsObjectValid(oCopyAntiguo)){ RemoveHenchman(GetMaster(oCopyAntiguo),oCopyAntiguo); AssignCommand(oCopyAntiguo,SetIsDestroyable(TRUE,FALSE,FALSE)); DestroyObject(oCopyAntiguo, 0.5); }

    //Apply VFX impact and summon effect
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, GetSpellTargetLocation());
    oCreature = CreateObject(OBJECT_TYPE_CREATURE, sSummon, GetSpellTargetLocation());
    SetStandardFactionReputation(STANDARD_FACTION_DEFENDER,100, oPC);
    SetIsTemporaryFriend(oCreature, oPC);
    DelayCommand(0.1f, ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSombra, oCreature));
    SetCreatureAppearanceType(oCreature, eApariencia);
    SetGender(oCreature, eGenero);
    SetName(oCreature, "Sombra " + eName);
    SetLocalObject(oPC, "CLONSOMBRIO", oCreature);
    DestroyObject(oCreature, TurnsToSeconds(nDuration));

    DelayCommand(1.5, AddHenchman(oPC, oCreature));
    SetLocalInt(oCreature, "X2_JUST_A_DISABLEEQUIP", TRUE);
    DelayCommand(2.5, AssignCommand(oCreature, LevelUpXP1Henchman(oPC)));

 DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

}


