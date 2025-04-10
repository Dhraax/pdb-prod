// Frenesi - Berseker Frenetico //

#include "nw_i0_spells"
#include "nostack_inc"
#include "inc_sqlite_time"

void TurnBasedDamage(object oTarget, object oCaster);
void AttackNearestForDuration();
void EndOfFrenzyDamage(object oSelf);

void AjustesFatiga(object oPC, effect eEffect)
{
    if(GetLocalInt(oPC, "FATIGADO2") == TRUE)
      {
          if(GetIsInCombat(oPC) == TRUE) DelayCommand(10.0f, AjustesFatiga(oPC, eEffect));
          else
          {
              RemoveEffect(oPC, eEffect);
              DeleteLocalInt(oPC, "FATIGADO2");
          }
      }
    else DelayCommand(10.0f, AjustesFatiga(oPC, eEffect));
}

int GetEnemyFrenzy(object oPC)
{
    object oTarget;
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(oPC));
        while (GetIsObjectValid(oTarget))
        {
             if(GetIsEnemy(oTarget, oPC) && !GetIsDead(oTarget))
             {
               return 1;
             }
             else if(GetIsReactionTypeHostile(oTarget, oPC) && !GetIsDead(oTarget)) //Doble Check
             {
               return 1;
             }

    oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(oPC));
        }

     //Si no hay enemigos...
     return 0;
}

int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster);
int GetDelayedSpellEffectsExpired(int nSpell_ID, object oTarget, object oCaster)
{

    if (!GetHasSpellEffect(nSpell_ID,oTarget) )
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    //--------------------------------------------------------------------------
    // GZ: 2003-Oct-15
    // If the caster is dead or no longer there, cancel the spell, as it is
    // directed
    //--------------------------------------------------------------------------
    if( !GetIsObjectValid(oCaster))
    {
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        return TRUE;
    }

    if (GetIsDead(oCaster))
    {
        DeleteLocalInt(oTarget,"XP2_L_SPELL_SAVE_DC_" + IntToString (nSpell_ID));
        RemoveSpellEffects(nSpell_ID, oTarget, oTarget);
        return TRUE;
    }

    return FALSE;

}

void main()
{

    object oMod = GetModule();
    int iCurTime = SQLite_GetTimeStamp();
    int iCoolDown = GetLocalInt(oMod, "FRENZY" + GetName(OBJECT_SELF));

    if(GetLocalInt(OBJECT_SELF, "FATIGADO2") == TRUE)  //Fatigado no hay frenesi
      {
       SendMessageToPC(OBJECT_SELF, "<cþ<<>Estás fatigado a causa del frenesi, deja de combatir y volverás a la normalidad.</c>");
       IncrementRemainingFeatUses(OBJECT_SELF, 1443);
       return;
      }

    // Antisaturamiento, solo una vez cada 5 MINUTOS
    if (iCurTime - iCoolDown < 180)
      {
      SendMessageToPC(OBJECT_SELF, "<cþ<<>Debes esperar 3 minutos para volver a usar esta habilidad.</c>");
      IncrementRemainingFeatUses(OBJECT_SELF, 1443);
      return;
      }

    if(!GetHasFeatEffect(1443)) // Frenesi
    {

        SetLocalInt(OBJECT_SELF, "PC_Damage", 0);
        SetLocalInt(oMod, "FRENZY" + GetName(OBJECT_SELF), SQLite_GetTimeStamp());
        DelayCommand(180.0, DeleteLocalInt(oMod, "FRENZY" + GetName(OBJECT_SELF)));
        DelayCommand(180.0, SendMessageToPC(OBJECT_SELF, "<cþ<<>Ya puedes volver a usar Frenesi.</c>"));


        // Declare major variables
        int nLevel = GetLevelByClass(56); // Berseker Frenetico
        int nIncrease;
        int acDecrease;
        int hasHaste;
        int nSlot;  // item slots


        object oTarget = GetSpellTargetObject();

        if(GetHasFeat(1453, oTarget) ) // Frenesi Inmortal
        {
              SetImmortal(oTarget, TRUE);
        }

         // Desactivacion del modo pericia
         if(GetHasSpellEffect(901) || GetHasSpellEffect(904))
        {
          FloatingTextStringOnCreature("<cþ<<>* Modo Pericia en combate desactivado *</c>", OBJECT_SELF, FALSE);
          RemoveEffectsFromSpell(OBJECT_SELF, 901);
          RemoveEffectsFromSpell(OBJECT_SELF, 904);
                }

        hasHaste = 0;
        acDecrease = 4;

        // El bonus de fuerza aumenta al 8
        if (nLevel < 8)
            nIncrease = 6;
        else
            nIncrease = 10;

         // Esta acelerado ?
         if(GetHasSpellEffect(113, oTarget) == TRUE) //Acelerar a las masas
         {
          hasHaste = 1;
         }
         if(GetHasSpellEffect(647, oTarget) == TRUE) // blinding speed
         {
              hasHaste = 1;
         }
         if(GetHasSpellEffect(78, oTarget) == TRUE) // Acelerar
         {
              hasHaste = 1;
         }

         // Que no tenga items de acelerar
         for (nSlot=0; nSlot<NUM_INVENTORY_SLOTS; nSlot++)
             {
             object oItem = GetItemInSlot(nSlot, OBJECT_SELF);

            if (GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE))
                hasHaste = 1;
             }

        PlayVoiceChat(VOICE_CHAT_BATTLECRY1);

        //Determine the duration
        int nCon = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);
       // int nBonoAtaque = (GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, FALSE) - GetAbilityScore(OBJECT_SELF, ABILITY_STRENGTH, TRUE) + nIncrease -12) / 2;

        effect eStr = EffectAbilityIncrease(ABILITY_STRENGTH, nIncrease);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eGlow = EffectVisualEffect(VFX_DUR_AURA_PULSE_RED_ORANGE);
        effect eFallo = EffectSpellFailure(100);
        effect eAC = EffectACDecrease(acDecrease, AC_DODGE_BONUS);


        effect eLink = EffectLinkEffects(eStr, eDur);
        eLink = EffectLinkEffects(eLink, eGlow);
              eLink = EffectLinkEffects(eLink, eAC);
              eLink = EffectLinkEffects(eLink, eFallo);

          /*/Si tiene los bonos magicos a las caracterisitcas da bono de ataque y danyo.
          if(nBonoAtaque > 0)
            {
             eLink = EffectLinkEffects(eLink, EffectAttackIncrease(nBonoAtaque));
             eLink = EffectLinkEffects(eLink, EffectDamageIncrease(nBonoAtaque, iTipoDanyo1));
            } */

        if(hasHaste == 0)
           {
            /*effect eHaste = EffectHaste();
            effect eMove = EffectMovementSpeedDecrease(40);
            effect eAC2 = EffectACDecrease(acDecrease, AC_DODGE_BONUS);
            eLink = EffectLinkEffects(eLink, eHaste);
            eLink = EffectLinkEffects(eLink, eMove);
            eLink = EffectLinkEffects(eLink, eAC2);
           */

            effect eAttacks = EffectModifyAttacks(1);
            eLink = EffectLinkEffects(eLink, eAttacks);
           }

        SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_EPIC_MIGHTY_RAGE, FALSE));

        //Make effect extraordinary
        eLink = ExtraordinaryEffect(eLink);
        effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE); //Cambiar por algun efecto de furia

        if (nCon > 0)
            {
            //Apply the VFX impact and effects
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, RoundsToSeconds(nCon));
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);

            object oSelf = OBJECT_SELF;
            DelayCommand(6.0f, TurnBasedDamage(oTarget, oSelf) );
            DelayCommand(6.0f, AttackNearestForDuration()); //Ataca al mas cercano!

            DelayCommand(RoundsToSeconds(nCon), EndOfFrenzyDamage(oSelf)); //Finaliza la furia
            }
    }
}

void EndOfFrenzyDamage(object oSelf)
     {

     SetImmortal(oSelf, FALSE);

     int iDam = GetLocalInt(oSelf, "PC_Damage");
     effect eDam = EffectDamage(iDam, DAMAGE_TYPE_MAGICAL, DAMAGE_POWER_ENERGY);
     ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oSelf);

     DelayCommand(0.5, SetLocalInt(oSelf, "PC_Damage", 0));


     }

void TurnBasedDamage(object oTarget, object oCaster)
{
    if(GetDelayedSpellEffectsExpired(1329, oTarget, oCaster)) // Si ya no estamos en furia, paramos
    {
        int nLevel = GetLevelByClass(56);  // Berseker Frenetico

        // Aplicamos fatiga si es menor de nivel 10
        if(nLevel < 10)
        {
             effect eStrPen = EffectAbilityDecrease(ABILITY_STRENGTH, 4);
             effect eDexPen = EffectAbilityDecrease(ABILITY_DEXTERITY, 4);
             effect eMove = EffectMovementSpeedDecrease(25);
             effect eLink2 = EffectLinkEffects(eStrPen, eDexPen);
             eLink2 = EffectLinkEffects(eLink2, eMove);

             ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink2, oTarget);
             SetLocalInt(oTarget, "FATIGADO2", TRUE);
             DelayCommand(10.0f, AjustesFatiga(oTarget, eLink2));
        }

        return;
    }

    if(GetIsDead(oTarget) == FALSE)
    {
      int oHP = GetCurrentHitPoints(oTarget);
      int oDam = (oHP*6/100);
      effect eDam = EffectDamage(oDam, DAMAGE_TYPE_MAGICAL);

        ApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,TurnBasedDamage(oTarget,oCaster));

        int iDam = GetLocalInt(oTarget, "PC_Damage");

        if(iDam)
          FloatingTextStringOnCreature(GetName(oTarget)+" tiene "+IntToString(iDam)+" de daño acumulado al finalizar el frenesi.",oTarget,FALSE);
    }
}

void AttackNearestForDuration()
{
    object oCaster = OBJECT_SELF;
    object oCerca = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCaster, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, -1, -1);
    object oCercaEnemy = GetNearestCreature(CREATURE_TYPE_REPUTATION, REPUTATION_TYPE_ENEMY, oCaster, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN, CREATURE_TYPE_IS_ALIVE, TRUE);
    object oEnemy = GetLocalObject(oCaster, "Enemigo");

    // Si ya no estamos en furia, paramos.
    if(GetDelayedSpellEffectsExpired(1329, oCaster, oCaster))
    {
        AssignCommand(oCaster, ClearAllActions(TRUE));
        return;
    }

        //Check enemigos
        if(GetEnemyFrenzy(oCaster) == 1)
        {
            if(GetIsInCombat(oCaster)) DelayCommand(4.0f, AttackNearestForDuration());//Si hay enemigos y estamos combatiendo, volvemos después
            else if(!GetIsInCombat(oCaster)) //Si hay enemigos y no estamos en combate, atacamos y volvemos después
                {
                    AssignCommand(oCaster, ActionAttack(oCercaEnemy, FALSE));
                    DelayCommand(8.0f, AttackNearestForDuration());
                }
        }
        else //Si no hay enemigos...
        {
            AssignCommand(oCaster, ActionAttack(oCerca, FALSE));
            AssignCommand(oCaster, DelayCommand(0.5, SetCommandable(FALSE)));
            AssignCommand(oCaster, DelayCommand(5.0, SetCommandable(TRUE)));
            DelayCommand(8.0f, AttackNearestForDuration());
        }
}
