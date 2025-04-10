//::///////////////////////////////////////////////
//:: Explosion de Energia Positiva
//:: sol_tempositiva
//:://::///////////////////////////////////////////
/*
    El lanzador conjura una explosion de energa positiva
    que hara 8d6 puntos de danyo a muertos-vivientes y
    4d6 al resto. Admite salvacion de reflejos.
*/
//:://////////////////////////////////////////////


#include "X0_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

  // Hay que tener usos de Expulsar o reprender muertos vivientes
  if(!GetHasFeat(FEAT_TURN_UNDEAD, OBJECT_SELF))
  {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>" + GetStringByStrRef(40550) + "</c>");
      return;
  }

  // Se restan usos de Expulsar
  DecrementRemainingFeatUses(OBJECT_SELF, FEAT_TURN_UNDEAD);



    //Declarar variables
    effect eVis = EffectVisualEffect(VFX_IMP_DEATH);
    effect eVis2 = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eStrike = EffectVisualEffect(VFX_FNF_SUNBEAM);
    effect eDam;
    int nCasterLevel = 8;
    int nDamage;
    int nOrgDam;
    float fDelay;

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eStrike, GetSpellTargetLocation());
    //Primer target
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    while(GetIsObjectValid(oTarget))
    {
        // No fuego amigo
        if(GetIsEnemy(oTarget))
        {
            fDelay = GetRandomDelay(1.0, 2.0);
            //Se activa en el primer target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_SUNBEAM));
            //Tirada de RC
            if ( ! MyResistSpell(OBJECT_SELF, oTarget, 1.0))
            {
                if (PB_Race_GetIsUndead(oTarget) || GetRacialType(oTarget) == RACIAL_TYPE_OOZE)
                {
                    //Danyo undeads y limos
                    nDamage = d8(nCasterLevel);
                }

                else
                {
                    //Danyo reducido en caso de no ser undead o limo
                    nDamage = d8(3);
                    nOrgDam = nDamage;
                    nCasterLevel = 3;
                }


                //Ajuste del danyo por reflejos
                if(MySavingThrow(SAVING_THROW_REFLEX, oTarget, 18, SAVING_THROW_TYPE_POSITIVE, OBJECT_SELF, 1.0) == 0)
                {
                    nDamage = GetReflexAdjustedDamage(nDamage, oTarget, 0, SAVING_THROW_TYPE_POSITIVE);
                }
                //Hace efecto el danyo
                eDam = EffectDamage(nDamage, DAMAGE_TYPE_POSITIVE);
                if(nDamage > 0)
                {
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget));
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                }
            }
        }
        //Siguiente target
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetSpellTargetLocation());
    }
}


