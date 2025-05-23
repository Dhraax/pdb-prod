#include "f_vampire_h"
#include "f_vampirepenta_h"
#include "inc_timelock"

void VampireItemCheck()
{
string sTag = GetTag(GetItemActivated());
effect eRegen = SupernaturalEffect(EffectRegenerate(1, 3.0));
effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
object oPC = GetItemActivator();
object oTarget = GetItemActivatedTarget();
int isVampire = GetIsVampire(oPC);

//////////////These can be used by anyone........
if (sTag == "sangrevampiro")
    {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sangre de Vampiro"))
    {
        TimelockErrorMessage(oPC, "Sangre de Vampiro");
        return;
    }
    if(isVampire)
        {
        eVis = EffectVisualEffect(VFX_IMP_HARM);
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        FloatingTextStringOnCreature("El delicioso gusto de la sangre de otro vampiro te hace más fuerte.", oPC, FALSE);
        eVis = SupernaturalEffect(EffectTemporaryHitpoints(Determine_Vampire_Level(oPC) * 10));
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, 60.0);

        AssignCommand(oPC, ClearAllActions(TRUE));
        AssignCommand(oPC, ActionCastSpellAtObject(SPELL_BULLS_STRENGTH, oPC, METAMAGIC_ANY, TRUE, 3, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        DelayCommand(0.2, SetCommandable(FALSE, oPC));
        DelayCommand(2.0, SetCommandable(TRUE, oPC));

        Vampire_Fresh_Blood(oPC); //for the blood hunger system
        }
    else
        {

        FloatingTextStringOnCreature("La sangre parece salada, y sientes un leve dolor de estómago.", oPC, FALSE);
        }
    SetTimelock(oPC, 10, "Sangre de Vampiro", 0, 0);
    }
else if (sTag == "sangreninyo")
    {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sangre de Niño"))
    {
        TimelockErrorMessage(oPC, "Sangre de Niño");
        return;
    }
    if(isVampire)
        {
        effect eApp = EffectHeal(d12()+10);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC);;
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        FloatingTextStringOnCreature("El delicioso gusto de la sangre de niño te sacia la sed.", oPC, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, IntToFloat(18));
        Vampire_Fresh_Blood(oPC); //for the blood hunger system
        }
    else
        {

        FloatingTextStringOnCreature("La sangre parece salada, y sientes un leve dolor de estómago.", oPC, FALSE);
        }
    SetTimelock(oPC, 10, "Sangre de Niño", 0, 0);
    }
else if (sTag == "sangrevirgen")
    {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sangre de Virgen"))
    {
        TimelockErrorMessage(oPC, "Sangre de Virgen");
        return;
    }
    if(isVampire)
        {
        effect eApp = EffectHeal(d12(2)+15);
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oPC));
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, IntToFloat(18));
        FloatingTextStringOnCreature("El delicioso gusto de la sangre de virgen te sacia la sed.", oPC, FALSE);
        Vampire_Fresh_Blood(oPC); //for the blood hunger system
        }
    else
        {

        FloatingTextStringOnCreature("La sangre parece salada, y sientes un leve dolor de estómago.", oPC, FALSE);
        }
    SetTimelock(oPC, 10, "Sangre de Virgen", 0, 0);
    }
else if (sTag == "sangrepura")
    {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sangre Pura"))
    {
        TimelockErrorMessage(oPC, "Sangre Pura");
        return;
    }
    if(isVampire)
        {
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        FloatingTextStringOnCreature("La sangre fresca te refuerza.", oPC, FALSE);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, IntToFloat(15 + Random(31)));
        Vampire_Fresh_Blood(oPC); //for the blood hunger system
        }
    else
        {
        FloatingTextStringOnCreature("La sangre parece salada, y sientes un leve dolor de estómago.", oPC, FALSE);
        }
    SetTimelock(oPC, 10, "Sangre Pura", 0, 0);
    }
else if (sTag == "sangreimpura")
    {
    // Cooldown check.
    if(GetIsTimelocked(oPC, "Sangre Impura"))
    {
        TimelockErrorMessage(oPC, "Sangre Impura");
        return;
    }
    if(isVampire)
        {
        eRegen = SupernaturalEffect(EffectLinkEffects(eVis, eRegen));
        isVampire = Random(61);
        if(isVampire < 44) eVis = EffectPoison(isVampire);
            else eVis = EffectDisease(isVampire - 44);
        FloatingTextStringOnCreature("La sangre era impura.", oPC, FALSE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRegen, oPC, IntToFloat(1 + Random(16)));
        Vampire_Fresh_Blood(oPC); //for the blood hunger system
        }
    else
        {
        isVampire = Random(61);
        if(isVampire < 44) eVis = EffectPoison(isVampire);
            else eVis = EffectDisease(isVampire - 44);
        FloatingTextStringOnCreature("La sangre parece salada, y sientes un leve dolor de estómago.", oPC, FALSE);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eVis, oPC);
        }
    SetTimelock(oPC, 10, "Sangre Impura", 0, 0);
    }
else if (sTag == "FALLEN_VAMPIRE_CURE")
    {
    if(isVampire)
        {
        FloatingTextStringOnCreature("El líquido te purifica del vampirismo.", oPC, FALSE);
        eVis = EffectVisualEffect(VFX_FNF_STRIKE_HOLY);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
        SetIsVampire(FALSE, oPC);
        }
    else
        {
        FloatingTextStringOnCreature("El líquido sabe algo amargo, pero no parece hacer algo.", oPC, FALSE);
        }
    }
else if (sTag == "FALLEN_VAMPIRE_SUNSTONE")
    {
    if(GetIsDawn()) FloatingTextStringOnCreature("La piedra solar se calienta lentamente.", oPC, FALSE);
    else if(GetIsDay()) FloatingTextStringOnCreature("La piedra solar está caliente al tacto.", oPC, FALSE);
    else if(GetIsDusk()) FloatingTextStringOnCreature("La piedra solar se enfría lentamente.", oPC, FALSE);
    else if(GetIsNight()) FloatingTextStringOnCreature("La piedra solar está fría al tacto.", oPC, FALSE);
    }
else if (sTag == "FALLEN_VAMPIRE_BITE_TOKEN")
    {
    SetLocalInt(oPC, "FALLEN_VAMPIRE_BITE_PERMISSION", TRUE);
    DelayCommand(30.0, DeleteLocalInt(oPC, "FALLEN_VAMPIRE_BITE_PERMISSION"));
    FloatingTextStringOnCreature("Tu amigo vampiro es capaz de morderte durante los próximos 30 segundos.", oPC, FALSE);
    }

/////////////////The following are vampire only....
if(!isVampire) return;






if (sTag == "FALLEN_VAMPIRE_MIST_ABILITY")
    {
    ExecuteScript("f_vampiremist", oPC);
    }
else if (sTag == "FALLEN_VAMPIRE_WOLF_ABILITY")
    {
    ExecuteScript("f_vampirewolf", oPC);
    }
else if (sTag == "FALLEN_VAMPIRE_BAT_ABILITY")
    {
        if(GetLocalInt(GetArea(oPC), "NOTELEPORT") == 1)
        {
          SendMessageToPC(oPC, "Este conjuro no se puede usar aquí, una barrera te lo impide.");
          return;
        }
        ExecuteScript("f_vampirebat", oPC);
    }
else if (sTag == "FALLEN_VAMPIRE_FANGS")
    {
    string sSubraza = GetStringLowerCase(GetSubRace(oTarget));
    object oNearest;
    //if(!GetIsObjectValid(oTarget) || !GetIsPlayableRacialType(oTarget)) { FloatingTextStringOnCreature("¡No puedes morder a esta criatura!", oPC, FALSE); return; }
    if(!GetIsObjectValid(oTarget) || !GetIsRaceBite(oTarget)) { FloatingTextStringOnCreature("¡No puedes morder a esta criatura!", oPC, FALSE); return; }
    if(GetIsUnableToBite(oPC)) { FloatingTextStringOnCreature("¡No estás en condiciones de morder a alguien!", oPC, FALSE); return; }
    if(!GetObjectSeen(oTarget, oPC)) { FloatingTextStringOnCreature("¡No puedes ver tu objetivo!", oPC, FALSE); return; }
    if(GetIsVampire(oTarget)) { FloatingTextStringOnCreature(GetName(oTarget) + " ya es un vampiro.", oPC, FALSE); return; }
    if(GetIsPC(oTarget) && sSubraza == "ghul") { FloatingTextStringOnCreature("No puedes morder a un personaje ghoul.", oPC, FALSE); return; }
    if(GetHasGarlicProtection(oTarget)) { FloatingTextStringOnCreature(GetName(oTarget) + " ha comido recientemente ajo y no puede ser mordido.", oPC, FALSE); return; }
    if(!GetIsBitable(oTarget))
        {
        if(GetIsPC(oTarget) && GetIsFriend(oTarget, oPC) && GetIsFriend(oPC, oTarget))
            {
            if(GetLocalInt(oPC, "FALLEN_VAMPIRE_TOKEN_DELAY"))
                { //prevent token spamming...
                FloatingTextStringOnCreature("Sólo puedes dar a conocer 1 señal de vampirismo cada 5 minutos.", oPC, FALSE);
                }
            SetLocalInt(oPC, "FALLEN_VAMPIRE_TOKEN_DELAY", TRUE);
            DelayCommand(600.0, DeleteLocalInt(oPC, "FALLEN_VAMPIRE_TOKEN_DELAY"));
            FloatingTextStringOnCreature(GetName(oTarget) + " ha recibido una señal de permiso vampírica.", oPC, FALSE);
            FloatingTextStringOnCreature(GetName(oPC) + " te ha dado una señal de permiso de mordedura de vampiro, por favor comprueba la descripción con cuidado antes de utilizarlo.", oTarget, FALSE);
            oPC = CreateItemOnObject("vampirismtoken", oTarget);
            DelayCommand(60.0, DestroyObject(oPC));
            return;
            }
        FloatingTextStringOnCreature("Tu objetivo debe de estar paralizado, durmiendo o atontado.", oPC, FALSE);
        return;
        }
    if(CheckForVampireSeen)
        {
        oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oTarget, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        if(GetIsObjectValid(oNearest) && oNearest == oPC) oNearest = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oTarget, 2, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
        if(GetIsObjectValid(oNearest) && GetObjectSeen(oPC, oNearest))
        //if(GetIsObjectValid(oNearest))// && GetObjectSeen(oPC, oNearest))

            {
            doVampireRevealed(oPC, oNearest, oTarget);
            /*if ((!(oNearest == oPC)) && (!GetIsBitable(oNearest))) { return; }*/

            }
        }
    SetLocalObject(oPC, "FALLEN_VAMPIRE_VICTIM", oTarget);
    AssignCommand(oTarget, ClearAllActions(TRUE));
    AssignCommand(oPC, ClearAllActions(TRUE));
    AssignCommand(oPC, ActionStartConversation(OBJECT_SELF, "f_vampirebite", TRUE, FALSE));
    }
else if (sTag == "FALLEN_VAMPIRE_AURA_ABILITY")
    {
    if(!Vampire_Remove_Aura(oPC)) ExecuteScript("f_vampireaura2", oPC);
    }
}
