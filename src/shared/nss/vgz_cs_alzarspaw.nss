#include "x0_inc_henai"
void main()
{
object oCompi = OBJECT_SELF;
location lLugarActivado = GetLocation(OBJECT_SELF);
string sTag = GetLocalString(GetMaster(OBJECT_SELF),"alzado");
object oObjetivo = GetNearestObjectByTag(sTag,OBJECT_SELF);

        int iTipo = GetAppearanceType(oObjetivo);
        string sNombre = GetName(oObjetivo);
        int iSTR = GetAbilityScore(oObjetivo,ABILITY_STRENGTH);
        int iDEX = GetAbilityScore(oObjetivo,ABILITY_DEXTERITY);
        int iCON = GetAbilityScore(oObjetivo,ABILITY_CONSTITUTION);
        int iHitDice = GetHitDice(oObjetivo);
        int iAB = GetBaseAttackBonus(oObjetivo);
        int iFort = GetFortitudeSavingThrow(oObjetivo);
        int iRefle = GetReflexSavingThrow(oObjetivo);
        int iWill = GetWillSavingThrow(oObjetivo);
        int iVida = GetMaxHitPoints(oObjetivo);
        int iAC = GetAC(oObjetivo);
        float fDireccion = GetFacing(oObjetivo);

        effect eSubeSTR = EffectAbilityIncrease(ABILITY_STRENGTH,iSTR - GetAbilityScore(oCompi,ABILITY_STRENGTH));
        effect eSubeDEX = EffectAbilityIncrease(ABILITY_DEXTERITY,iDEX - GetAbilityScore(oCompi,ABILITY_DEXTERITY));
        effect eSubeCON = EffectAbilityIncrease(ABILITY_CONSTITUTION,iCON - GetAbilityScore(oCompi,ABILITY_CONSTITUTION));
        effect eAC = EffectACIncrease(iAC - GetAC(oCompi));
        effect eDamage = EffectDamageIncrease(1*iHitDice,DAMAGE_TYPE_NEGATIVE);
            if (iHitDice >= 30) eDamage = EffectDamageIncrease(30,DAMAGE_TYPE_NEGATIVE);
        effect eLanzador2 = EffectVisualEffect(560);
        effect ePupa = EffectDamage(d2(iVida*2));
        effect eSangre2 = EffectVisualEffect(91);

        SetCreatureAppearanceType(oCompi,iTipo);
        SetName(oCompi,sNombre + " alzado");
        AssignCommand(oCompi,SetFacing(fDireccion));
        AssignCommand(oCompi,ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 0.0,2.0));
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSubeSTR,oCompi);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSubeDEX,oCompi);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eSubeCON,oCompi);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eAC,oCompi);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT,eDamage,oCompi);
        DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_INSTANT,eSangre2,oCompi));
        DelayCommand(2.5,ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eLanzador2,oCompi,4.0));
        while (iHitDice > 1)
        {
        LevelUpHenchman(oCompi,CLASS_TYPE_UNDEAD);
        iHitDice = iHitDice -1;
        }
        SetBaseAttackBonus(iAB,oCompi);
        SetFortitudeSavingThrow(oCompi,iFort);
        SetReflexSavingThrow(oCompi,iRefle);
        SetWillSavingThrow(oCompi,iWill);

SetAssociateState(NW_ASC_DISTANCE_2_METERS);
}
