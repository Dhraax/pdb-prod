#include "nwnx_creature"

void HidraDeath(object oHidra)
{
  if(GetLocalInt(oHidra, "HidraDeath") ==  0)
   {
        effect eVis = EffectVisualEffect(VFX_IMP_DUST_EXPLOSION);
        effect eVis2 = EffectVisualEffect(1243);
        effect eLink = EffectLinkEffects(eVis, eVis2);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oHidra);
        effect eDeath = EffectDeath(TRUE);
        SetImmortal(oHidra, FALSE);
        SetLocalInt(oHidra, "HidraDeath", 1);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oHidra);
        return;
    }
}

void HidraBonus(object oHidra)
{
  if(GetLocalInt(oHidra, "HidraBonus") == 1 && GetLocalInt(OBJECT_SELF, "Cauterizada") == 0)
    {
        int iFue = NWNX_Creature_GetRawAbilityScore(oHidra, ABILITY_STRENGTH);
        int iCon = NWNX_Creature_GetRawAbilityScore(oHidra, ABILITY_CONSTITUTION);
        NWNX_Creature_SetRawAbilityScore(oHidra, ABILITY_CONSTITUTION, iCon + 4);
        NWNX_Creature_SetRawAbilityScore(oHidra, ABILITY_STRENGTH, iFue + 2);
        effect eVis = EffectVisualEffect(VFX_IMP_HOLY_AID);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oHidra);
        SetLocalInt(OBJECT_SELF, "HidraBonus", 0);
        return;
    }

}

void main()
{

int nUser = GetUserDefinedEventNumber();
int nCaido = GetLocalInt(OBJECT_SELF, "HidraCaido");
int nCabezas = GetLocalInt(OBJECT_SELF, "CabezasHidra");


if(nUser == EVENT_DAMAGED) // OnDamaged Event
    {
        object oDamager = GetLastDamager();

        int nFireDamage = GetDamageDealtByType(DAMAGE_TYPE_FIRE);
        int nAcidDamage = GetDamageDealtByType(DAMAGE_TYPE_ACID);
        int nOriginalHPs = GetMaxHitPoints(OBJECT_SELF);
        int nCurrentHPs = GetCurrentHitPoints(OBJECT_SELF);
        int n40Hp = (nOriginalHPs*40/100);  //40% de la vida total

        //Efecto de caida
        effect eKnockdown = EffectKnockdown();
        effect eParalize = EffectCutsceneParalyze();
        effect eHeal = EffectHeal(n40Hp);
        effect eVis = EffectVisualEffect(VFX_IMP_HEALING_X);
        effect eVis2 = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
        effect eLink = EffectLinkEffects(eKnockdown, eParalize);
        effect eLink2 = EffectLinkEffects(eHeal, eVis);
        eLink2 = EffectLinkEffects(eLink2, eVis2);

        //Aplicamos caida y nueva cabeza
        if (nCurrentHPs < 5 && nCaido == 0)
        {
            //Contamos cabezas
            if(nCabezas >= 5) HidraDeath(OBJECT_SELF);
            else if (nCabezas > 0 ) SetLocalInt(OBJECT_SELF, "CabezasHidra", nCabezas + 1);
            else if(nCabezas == 0) SetLocalInt(OBJECT_SELF, "CabezasHidra", 1);

            ClearAllActions();
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(5));

            SetLocalInt(OBJECT_SELF, "HidraCaido", 1);
            SetLocalInt(OBJECT_SELF, "Cauterizada", 0);
            DelayCommand(RoundsToSeconds(5), SetLocalInt(OBJECT_SELF, "HidraCaido", 0));
            DelayCommand(RoundsToSeconds(5), ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink2, OBJECT_SELF));
            DelayCommand(RoundsToSeconds(5), SpeakString("¡¡De la cabeza cercenada aparecen dos nuevas cabezas!!"));
            DelayCommand(RoundsToSeconds(5), HidraBonus(OBJECT_SELF));
        }

        //Si ha caido y recibe daño fuego o acido mayor de 10 no aplicamos bonus
        if(nCaido == 1 && GetLocalInt(OBJECT_SELF, "Cauterizada") == 0 && nFireDamage > 10 || nAcidDamage > 10)
            {
                SetLocalInt(OBJECT_SELF, "Cauterizada", 1);
            }
        //Si esta caido y no recibe daño acido o fuego...
        else if(nCaido == 1 && GetLocalInt(OBJECT_SELF, "Cauterizada") == 0)
            {
                FloatingTextStringOnCreature("No has cauterizado el corte de la cabeza cercenada...", oDamager, FALSE);
                SetLocalInt(OBJECT_SELF, "HidraBonus", 1);
            }
    }

}
