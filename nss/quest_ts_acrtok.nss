#include "x0_i0_petrify"

void ReinicioEstatuasAcertijos(object oPC, object oMod)
{
    DeleteLocalInt(oMod, "QUEST_CONTADOR_ACERTIJOS");

    object oEstatuas = GetFirstObjectInArea(GetArea(oPC));
    while(GetIsObjectValid(oEstatuas))
    {
        if(GetStringLeft(GetTag(oEstatuas), 24) == "quest_estatua_ejercicios")
        {
            RemoveEffectOfType(oEstatuas, EFFECT_TYPE_VISUALEFFECT);
            DeleteLocalInt(oEstatuas, "QUEST_ACERTIJOS_STOP");
        }

        oEstatuas = GetNextObjectInArea(GetArea(oPC));
    }
}

void main()
{
  object oPC = GetPCSpeaker();
  object oMod = GetModule();
  int iContadorAcertijos = GetLocalInt(oMod, "QUEST_CONTADOR_ACERTIJOS");

  SetLocalInt(oMod, "QUEST_CONTADOR_ACERTIJOS", iContadorAcertijos + 1);

  SetXP(oPC, GetXP(oPC) + 10);

  if(iContadorAcertijos == 1 || iContadorAcertijos == 3 || iContadorAcertijos == 5 ||
     iContadorAcertijos == 8 || iContadorAcertijos == 11)
  {
      ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SCREEN_SHAKE), oPC);
      ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_AURA_PULSE_MAGENTA_YELLOW), OBJECT_SELF);
      SetLocalInt(OBJECT_SELF, "QUEST_ACERTIJOS_STOP", TRUE);

      if(iContadorAcertijos == 11)
      {
          CreateItemOnObject("quest_ts_simb2", oPC);
          DelayCommand(1000.0, ReinicioEstatuasAcertijos(oPC, oMod));
      }
  }
}
