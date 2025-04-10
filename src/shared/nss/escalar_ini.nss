#include "mti_libreria"

void main()
{
  object oPC = GetPCSpeaker();

  // No se trepa a caballo
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      SendMessageToPC(oPC, "<cþ>No puedes trepar por la cuerda montado en una montura.</c>");
      return;
  }

  object oTarget = GetLocalObject(OBJECT_SELF, "T1_TARGET_OBJECT");
  if(oTarget != OBJECT_INVALID)
  {
      ActionWait(2.0f);

      // Tirada de Trepar...
      int iBono = 0;
      if(GetHasFeat(1248, oPC)) iBono = 10;      // Soltura epica
      else if(GetHasFeat(1236, oPC)) iBono = 3;  // Soltura normal

      int iTirada = GetSkillRank(37, oPC) + iBono + d20();
      int iDificultad = 15;

      // Fracaso
      if(iTirada < iDificultad)
      {
          SendMessageToPC(oPC, "<cþ  >Trepar: "+IntToString(iTirada)+" vs CD "+IntToString(iDificultad)+": Fracaso. ¡No consigues trepar por la cuerda!</c>");
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 3.0f);
          ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d12(), DAMAGE_TYPE_BLUDGEONING) ,oPC, 3.0f);
      }

      // Exito
      else
      {
          SendMessageToPC(oPC, "<c þ >Trepar: "+IntToString(iTirada)+" vs CD "+IntToString(iDificultad)+": éxito. ¡Trepas por la cuerda!</c>");

          ActionWait(0.5f);

          AssignCommand(oPC, JumpToObject(oTarget));
      }
  }
}
