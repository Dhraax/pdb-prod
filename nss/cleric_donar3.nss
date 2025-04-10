#include "inc_sqlite_time"

void main()
{
    object oPC = GetPCSpeaker();

    if(GetGold(oPC) >= 10000) {
        AssignCommand(oPC, TakeGoldFromCreature(10000, oPC, TRUE));
        int nSystemTime = SQLite_GetTimeStamp();
        if(GetLocalInt(oPC,"DONATION3_LASTTIME")+500 < nSystemTime) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 500.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oPC, 500.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(DAMAGE_BONUS_1d4, DAMAGE_TYPE_DIVINE), oPC, 500.0);
            FloatingTextStringOnCreature("* Recibes la bendición de la deidad *", oPC);
            SetLocalInt(oPC,"DONATION3_LASTTIME", nSystemTime);
        } else {
            FloatingTextStringOnCreature("* Te reconforta contribuir a la causa, pero ya recibiste una bendición hace poco tiempo *", oPC);
        }
  }
  else FloatingTextStringOnCreature("¡No tienes 10000 monedas de oro!", oPC);
}
