//DOTES PASIVAS DEL CAVALIER (ms_leto_cavalier)

#include "mti_libreria"
#include "nwnx_creature"

void main()
{

object oPC = OBJECT_SELF;
int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
effect eMonta2    = SupernaturalEffect(EffectSkillIncrease(SKILL_RIDE, 2));
effect eMonta4    = SupernaturalEffect(EffectSkillIncrease(SKILL_RIDE, 4));
effect eMonta6    = SupernaturalEffect(EffectSkillIncrease(SKILL_RIDE, 6));
effect eMonta8    = SupernaturalEffect(EffectSkillIncrease(SKILL_RIDE, 8));
effect eSaber     = SupernaturalEffect(EffectSkillIncrease(18       ,1+ GetLevelByClass(52, oPC)));

//Añadimos la subida de Equitacion solo una vez
if(GetLevelByClass(52, oPC) > 0 )
  {
  if(ObtenerIntPersistente(oPC, "DOTE_CAVALIER") == FALSE )
    {
      GuardarIntPersistente(oPC, "NIVELEQUITACION", iNivelEquitacion + 20 );
      GuardarIntPersistente(oPC, "DOTE_CAVALIER", TRUE);
      return;
    }
  }


//Aplicamos los bonos a las habilidades por nivel
if(GetHasFeat(1413, oPC))
  {
            if(GetLevelByClass(52, oPC) == 1 || GetLevelByClass(52, oPC) == 2 || GetLevelByClass(52, oPC) == 3 )
              {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaber, oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonta2, oPC);
              }
            else if(GetLevelByClass(52, oPC) == 4 || GetLevelByClass(52, oPC) == 5 || GetLevelByClass(52, oPC) == 6 )
              {
                RemoveEffect(oPC, eMonta2);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaber, oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonta4, oPC);
              }
            else if(GetLevelByClass(52, oPC) == 7 || GetLevelByClass(52, oPC) == 8 )
              {
                RemoveEffect(oPC, eMonta4);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaber, oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonta6, oPC);
              }

            else if(GetLevelByClass(52, oPC) > 8 )
              {
                RemoveEffect(oPC, eMonta6);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eMonta8, oPC);
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eSaber, oPC);

              }

   }

   //Indicar que ya se le ha dado los efectos.
  GuardarIntPersistente(oPC, "bSubRaza", 1);
}
