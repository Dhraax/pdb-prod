#include "inc_sqlite_time"

void main()
{
    object oPC = GetPCSpeaker();

    if(GetGold(oPC) >= 1000) {
        AssignCommand(oPC, TakeGoldFromCreature(1000, oPC, TRUE));
        int nSystemTime = SQLite_GetTimeStamp();
        if(GetLocalInt(oPC,"DONATION2_LASTTIME")+400 < nSystemTime) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 400.0);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(2), oPC, 400.0);
            FloatingTextStringOnCreature("* Recibes la bendición de la deidad *", oPC);
            SetLocalInt(oPC,"DONATION2_LASTTIME", nSystemTime);
        } else {
            FloatingTextStringOnCreature("* Te reconforta contribuir a la causa, pero ya recibiste una bendición hace poco tiempo *", oPC);
        }
  }
  else FloatingTextStringOnCreature("¡No tienes 1000 monedas de oro!", oPC);
}
