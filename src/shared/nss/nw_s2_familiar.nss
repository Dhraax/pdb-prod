//::///////////////////////////////////////////////
//:: Summon Familiar
//:: NW_S2_Familiar
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This spell summons an Arcane casters familiar
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Sept 27, 2001
//:://////////////////////////////////////////////

#include "mti_libreria"

void PHBF_HB_FamiliarBonus(effect eFam, object oMaster)
{
    // eFam - the effect the familiar's presense is giving the master.
    // oMaster - the master.
    // Functions calls itself every 60s until the familiar dies/unsummoned.

    object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, oMaster);
    if (!GetIsObjectValid(oFam))
    {
        // The familiar has died or been unsummoned.
        RemoveEffect(oMaster, eFam);
        return;
    }
    else
    {
        DelayCommand(60.0, PHBF_HB_FamiliarBonus(ExtraordinaryEffect(eFam), oMaster));
    }
}

void PHBF_DaytimeBonus (object oMaster, object oFam, int iNight)
{
    // oFam - the familiar
    // iNight - if 1 then the familiar gets bonus at night,
    //  if 0 the familiar gets bonus during the day
    // Function calls itself every 4 game hours.

    if (!GetIsObjectValid(oFam)) return;

    // Hawks and owls get bonuses depending on the time of day.
    float fTimestep = HoursToSeconds(2); // how often to check
    int iHour = GetTimeHour();
    // day time is between 7 to 18
    // night time is between 19 to 6
    int iCheck = (iHour >= 7) && (iHour < 19);
    if(iNight) iCheck = (iHour >= 19) || (iHour < 7);

    if (iCheck)
    {
        effect eBono = EffectSkillIncrease (SKILL_SPOT, 3);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eBono), oMaster, fTimestep);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    DelayCommand (fTimestep, PHBF_DaytimeBonus(oMaster, oFam, iNight));
}

void main()
{
    // check to see if the PC has the familiar token, if not then charge them
    int iFamiliarVivo = ObtenerIntPersistente(OBJECT_SELF, "FAMILIAR_VIVO");
    if (iFamiliarVivo == FALSE)
    {
        // Familiars cost 100gp to summon
        if (GetGold(OBJECT_SELF) < 100)
        {
            SendMessageToPC(OBJECT_SELF, "Necesitas pagar 100 monedas de oro debido a los materiales que necesitas para convocar un familiar.");
            return;
        }
        else
        {
            // take the gold from the PC and destroy the gold
            TakeGoldFromCreature(100, OBJECT_SELF, TRUE);
            // give the PC a token to track that they have paid for their familiar
            GuardarIntPersistente(OBJECT_SELF, "FAMILIAR_VIVO", TRUE);
        }
    }

    SummonFamiliar();

    // BONOS DE LOS FAMILIARES
    object oFam = GetAssociate(ASSOCIATE_TYPE_FAMILIAR, OBJECT_SELF);
    object oMaster = OBJECT_SELF;
    string sEtiquetaFamiliar = GetTag(oFam);
    effect eBono;

    // 1. Murcielago: +3 escuchar
    if (sEtiquetaFamiliar == "PHBF_BAT")
    {
        eBono = EffectSkillIncrease (SKILL_LISTEN, 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 2. Gato: +3 moverse
    else if (sEtiquetaFamiliar == "PHBF_CAT")
    {
        eBono = EffectSkillIncrease (SKILL_MOVE_SILENTLY, 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 3. Halcon: +3 Avistar de dia
    else if (sEtiquetaFamiliar == "PHBF_HAWK") AssignCommand (oFam, PHBF_DaytimeBonus (oMaster, oFam, 0));

    // 4. Buho: +3 Avistar de noche
    else if (sEtiquetaFamiliar == "PHBF_OWL")  AssignCommand (oFam, PHBF_DaytimeBonus (oMaster, oFam, 1));

    // 5. Rata: +2 Fortaleza
    else if (sEtiquetaFamiliar == "PHBF_RAT")
    {
        eBono = EffectSavingThrowIncrease(SAVING_THROW_FORT, 2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 6. Cuervo: +3 Tasacion
    else if (sEtiquetaFamiliar == "PHBF_OWL")
    {
        eBono = EffectSkillIncrease (SKILL_APPRAISE, 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 7. Serpiente: +3 Enganyar
    else if (sEtiquetaFamiliar == "PHBF_SNAKE")
    {
        eBono = EffectSkillIncrease (SKILL_BLUFF, 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 8. Sapo: +3 Puntos de golpe
    else if (sEtiquetaFamiliar == "PHBF_TOAD")
    {
        eBono = EffectTemporaryHitpoints(3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 9. Comadreja: +2 Reflejos
    else if (sEtiquetaFamiliar == "PHBF_WSL")
    {
        eBono = EffectSavingThrowIncrease(SAVING_THROW_REFLEX, 2);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // 10. Lagarto: +3 Trepar
    else if (sEtiquetaFamiliar == "PHBF_LAGAR")
    {
        eBono = EffectSkillIncrease (37, 3);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eBono), oMaster);
        PHBF_HB_FamiliarBonus (eBono, oMaster);
    }

    // Familiar Saving Throws: The familiar uses the master's base saving throw
    // Note: check the master's save BEFORE giving him a save increase from the familiar
    int iMasterSave;
    int iFamiliarSave;
    int iSaveDiff;
    // Check Fortitude save.
    iMasterSave = GetFortitudeSavingThrow(oMaster);
    iFamiliarSave = GetFortitudeSavingThrow(oFam);
    iSaveDiff = iMasterSave - iFamiliarSave;
    if (iSaveDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_FORT, iSaveDiff)), oFam));
    // Check Reflex save.
    iMasterSave = GetReflexSavingThrow(oMaster);
    iFamiliarSave = GetReflexSavingThrow(oFam);
    iSaveDiff = iMasterSave - iFamiliarSave;
    if (iSaveDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_REFLEX, iSaveDiff)), oFam));
    // Check Will save.
    iMasterSave = GetWillSavingThrow(oMaster);
    iFamiliarSave = GetWillSavingThrow(oFam);
    iSaveDiff = iMasterSave - iFamiliarSave;
    if (iSaveDiff > 0)  AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSavingThrowIncrease(SAVING_THROW_WILL, iSaveDiff)), oFam));

    // Familiar Skills: Use the normal skills for an animal or the master's
    // Note: check the master's skill BEFORE giving him a skill increase from the familiar
    int iMasterSkill;
    int iFamiliarSkill;
    int iSkillDiff;
    // Check Hide skill.
    int nSkill = SKILL_HIDE;
    iMasterSkill = GetSkillRank(nSkill, oMaster);
    iFamiliarSkill = GetSkillRank(nSkill, oFam);
    iSkillDiff = iMasterSkill - iFamiliarSkill;
    if (iSkillDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(nSkill, iSkillDiff)), oFam));
    // Check Listen skill.
    nSkill = SKILL_LISTEN;
    iMasterSkill = GetSkillRank(nSkill, oMaster);
    iFamiliarSkill = GetSkillRank(nSkill, oFam);
    iSkillDiff = iMasterSkill - iFamiliarSkill;
    if (iSkillDiff > 0)  AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(nSkill, iSkillDiff)), oFam));
    // Check Move Silently skill.
    nSkill = SKILL_MOVE_SILENTLY;
    iMasterSkill = GetSkillRank(nSkill, oMaster);
    iFamiliarSkill = GetSkillRank(nSkill, oFam);
    iSkillDiff = iMasterSkill - iFamiliarSkill;
    if (iSkillDiff > 0)  AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(nSkill, iSkillDiff)), oFam));
    // Check Spot skill.
    nSkill = SKILL_SPOT;
    iMasterSkill = GetSkillRank(nSkill, oMaster);
    iFamiliarSkill = GetSkillRank(nSkill, oFam);
    iSkillDiff = iMasterSkill - iFamiliarSkill;
    if (iSkillDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(nSkill, iSkillDiff)), oFam));
    // Check Spellcraft skill. (improves save vs spells)
    nSkill = SKILL_SPELLCRAFT;
    iMasterSkill = GetSkillRank(nSkill, oMaster);
    iFamiliarSkill = GetSkillRank(nSkill, oFam);
    iSkillDiff = iMasterSkill - iFamiliarSkill;
    if (iSkillDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSkillIncrease(nSkill, iSkillDiff)), oFam));

    // Familiar Hit Points: One-half the master's total, rounded down.
    int iVidaFamiliar = GetCurrentHitPoints(oFam);
    int iMitadVidaMaster = GetMaxHitPoints(oMaster)/2;
    if (iVidaFamiliar < iMitadVidaMaster) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectTemporaryHitpoints(iMitadVidaMaster - iVidaFamiliar)), oFam));

    // Familiar Attacks: Use the master's base attack bonus.
    // Increase familiar's basic attack bonus if is is less than the master's.
    int iFamiliarBAB = GetBaseAttackBonus(oFam);
    int iMasterBAB = GetBaseAttackBonus(oMaster);
    int iBABDiff = iMasterBAB - iFamiliarBAB;
    if (iBABDiff > 0) AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectAttackIncrease(iBABDiff)), oFam));

    // Alerta: The presence of the familiar sharpens its master's senses.
    // Give the master the equivalent to the Alertness feat.
    if(GetHasFeat(FEAT_ALERTNESS) == FALSE)
    {
        effect eAlertness = EffectLinkEffects (EffectSkillIncrease(SKILL_SPOT, 2), EffectSkillIncrease(SKILL_LISTEN, 2));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(eAlertness), oMaster);
        PHBF_HB_FamiliarBonus (eAlertness, oMaster);
    }

    // Spell Resistance:  master >= 11th level, the familiar gains spell resistance equal to the master's level + 5.
    int iMasterLevel = GetLevelByClass(CLASS_TYPE_SORCERER, oMaster) + GetLevelByClass(CLASS_TYPE_WIZARD, oMaster);
    if (iMasterLevel >= 11)  AssignCommand(oFam, ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectSpellResistanceIncrease(iMasterLevel + 5)), oFam));
}
