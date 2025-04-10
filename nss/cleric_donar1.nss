#include "inc_sqlite_time"

void main()
{
    object oPC = GetPCSpeaker();

    if(GetGold(oPC) >= 500) {
        AssignCommand(oPC, TakeGoldFromCreature(500, oPC, TRUE));
        int nSystemTime = SQLite_GetTimeStamp();
        if(GetLocalInt(oPC,"DONATION1_LASTTIME")+300 < nSystemTime) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_ALL_SKILLS, 2), oPC, 300.0);
            FloatingTextStringOnCreature("* Recibes la bendición de la deidad *", oPC);
            SetLocalInt(oPC,"DONATION1_LASTTIME", nSystemTime);
        } else {
            FloatingTextStringOnCreature("* Te reconforta contribuir a la causa, pero ya recibiste una bendición hace poco tiempo *", oPC);
        }
  }
  else FloatingTextStringOnCreature("¡No tienes 500 monedas de oro!", oPC);
}
