#include "mti_libreria"
#include "nwnx_creature"

int SiPC()
{
  object oPC = GetFirstObjectInArea();
  while(GetIsObjectValid(oPC))
  {
      if(GetIsPC(oPC)) return TRUE;

      oPC = GetNextObjectInArea();
  }

  return FALSE;
}

void main ()
{
  object oPC = GetExitingObject();
  int control = ObtenerIntPersistente(oPC, "MAR_APA_CAMBIADA");
  int control1 = ObtenerIntPersistente(oPC, "MAR_COLA_CAMBIADA");
  int control2 = ObtenerIntPersistente(oPC, "CHUTES_BARCO");
  int control5 = ObtenerIntPersistente(oPC, "MAR_ALAS_CAMBIADAS");
  int apariencia = ObtenerIntPersistente(oPC, "MAR_APA_MEMORIZADA");
  int cola = ObtenerIntPersistente(oPC, "MAR_COLA_MEMORIZADA");
  int alas = ObtenerIntPersistente(oPC, "MAR_ALAS_MEMORIZADAS");
  int control3 = ObtenerIntPersistente(oPC, "HIDE_OFF");
  int control4 = ObtenerIntPersistente(oPC, "MOVE_SILENTLY_OFF");
  effect eE = GetFirstEffect(oPC);

  if(GetIsPC(oPC))
  {
      object oArma = GetItemPossessedBy(oPC, "Canonazos");
      object oPoder = GetItemPossessedBy(oPC, "ApoyomagicoenMar");
      //object oModelo = GetItemPossessedBy(oPC, "AparienciadelBarco");

      if(GetIsObjectValid(oArma) == TRUE) DestroyObject(oArma);
      if(GetIsObjectValid(oPoder) == TRUE) DestroyObject(oPoder);
      //if(GetIsObjectValid(oModelo) == TRUE) DestroyObject(oModelo);

      if(control == TRUE)
      {
          SetCreatureAppearanceType(oPC, apariencia);
          GuardarIntPersistente(oPC, "MAR_APA_CAMBIADA", FALSE);
      }

      if (control1 == TRUE)
      {
      SetCreatureTailType(cola, oPC);
      GuardarIntPersistente(oPC, "MAR_COLA_CAMBIADA", FALSE);
      }

      if(control2 == TRUE)
      {
          while(GetIsEffectValid(eE))
          {
              if(GetEffectDurationType(eE) == DURATION_TYPE_PERMANENT) RemoveEffect(oPC, eE);

              eE = GetNextEffect(oPC);
          }

          GuardarIntPersistente(oPC, "CHUTES_BARCO", FALSE);
      }

      if(control3 == TRUE)
      {
          int rangoocul = ObtenerIntPersistente(oPC, "VALOR_HIDE");

          NWNX_Creature_SetSkillRank (oPC,SKILL_HIDE,rangoocul);
          GuardarIntPersistente(oPC,"HIDE_OFF",FALSE);
      }
      if(control4 == TRUE)
      {
          int rangomovsig = ObtenerIntPersistente(oPC, "VALOR_MOVE_SILENTLY");

          NWNX_Creature_SetSkillRank (oPC,SKILL_MOVE_SILENTLY,rangomovsig);
          GuardarIntPersistente(oPC,"MOVE_SILENTLY_OFF",FALSE);
      }

      if (control5 == TRUE)
      {
      SetCreatureWingType(alas, oPC);
      GuardarIntPersistente(oPC, "MAR_ALAS_CAMBIADAS", FALSE);
      }

      ReaplicarEfectosPB(oPC,TRUE);
  }

  if(SiPC() == TRUE) return;

  DelayCommand(30.0, ExecuteScript("limpiabichos_inc", OBJECT_SELF));
}
