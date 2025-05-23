//Dote Golpe con Escudo de PdB//


#include "NW_I0_SPELLS"
#include "x2_inc_spellhook"

void main()
{

    object oEjecutor = OBJECT_SELF;
    object oDefensor = GetSpellTargetObject();
    object oMod = GetModule();
    int nHD = (GetHitDice(oEjecutor) / 2 );
    int nDC = 10 + nHD + GetAbilityModifier(ABILITY_STRENGTH, oEjecutor);
    effect eVis = EffectVisualEffect(VFX_IMP_STUN);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eStun = EffectStunned();

    effect eLink = EffectLinkEffects(eMind, eDur);
    eLink = EffectLinkEffects(eLink, eStun);
    float fContador;

    // No puedes noquear a uno mismo
    if(oEjecutor == oDefensor) {
        FloatingTextStringOnCreature("<cþ<<>* ¡No puedes noquearte a ti mismo! *</c>", oEjecutor, FALSE);
        return;
    }

   // Antisaturamiento, solo una vez cada 15 minutos
  if(GetLocalInt(oMod, "GLPE" + GetName(oEjecutor, TRUE)))
  {
      SendMessageToPC(oEjecutor, "<cþ<<>Debes esperar 40 segundos para volver a usar esta habilidad.</c>");
      return;
  }

  SetLocalInt(oMod, "GLPE" + GetName(oEjecutor, TRUE), TRUE);
  DelayCommand(40.0, DeleteLocalInt(oMod, "GLPE" + GetName(oEjecutor, TRUE)));


    // Con efectos dayninos no puedes usarla
    int iFalloDote = FALSE;
    if(GetIsResting(oEjecutor) || GetLocalInt(oEjecutor, "DERRIBADO") || GetLocalInt(oEjecutor, "SLIDING")) iFalloDote = TRUE;

      effect eEfecto = GetFirstEffect(oEjecutor);
      while(GetIsEffectValid(eEfecto))
        {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oEjecutor);
        }

     if(iFalloDote == TRUE)
      {
      FloatingTextStringOnCreature("<cþ<<>* En tu estado no puedes activar esta dote *</c>", OBJECT_SELF, FALSE);
      return;
      }

    // Si ya tiene derribo, nanay
     if(GetLocalInt(oDefensor, "DERRIBADO") || GetLocalInt(oDefensor, "SLIDING"))
      {
      FloatingTextStringOnCreature("<cþ<<>* Golpe de Escudo: fracaso, criatura ya esta noqueada *</c>", oEjecutor, FALSE);
      return;
      }

     // Si es inmune, nanay
     if(GetIsImmune(oDefensor, IMMUNITY_TYPE_STUN) || GetIsImmune(oDefensor, IMMUNITY_TYPE_MIND_SPELLS ))
      {
      FloatingTextStringOnCreature("<cþ<<>* Golpe de Escudo: fracaso, criatura inmune *</c>", oEjecutor, FALSE);
      return;
      }
    //Revisamos que tengamos escudo equipado
    object oArma = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oEjecutor);
    int iArma = GetBaseItemType(oArma);
 if(iArma == BASE_ITEM_SMALLSHIELD || iArma == BASE_ITEM_TOWERSHIELD || iArma == BASE_ITEM_LARGESHIELD )
   {
      //Realizamos la animacion de atacar
      AssignCommand(oEjecutor, ActionAttack(oDefensor, FALSE));

      //Si intentamos darle a un NPC neutral
    if(!GetIsEnemy(oEjecutor, oDefensor) && !GetIsPC(oDefensor))
        {
         AdjustReputation(oEjecutor, oDefensor, -100);
         AssignCommand(oDefensor, ActionAttack(oEjecutor));
        }
     //Realizamos el golpe
     if(TouchAttackMelee(oDefensor, TRUE) > 0 )
         {
           if(!MySavingThrow(SAVING_THROW_FORT, oDefensor, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
             {
                 FloatingTextStringOnCreature("<c´þd>* GolpeEscudo: éxito *</c>", oEjecutor, FALSE); // Exito GolpeEscudo
                 SetLocalInt(oDefensor, "NOQUEADO", TRUE);
                 DelayCommand(9.0, DeleteLocalInt(oDefensor, "NOQUEADO"));
                 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oDefensor);
                 ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oDefensor, 9.0);
                 //AssignCommand(oDefensor, PlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0, 6.0));
                 AssignCommand(oEjecutor, ActionAttack(oDefensor, TRUE));
          }
        else // Si fallamos
          {
                 FloatingTextStringOnCreature("<cþ<<>* GolpeEscudo: fracaso *</c>", oEjecutor, FALSE);
                 AssignCommand(oDefensor, PlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 1.5));
                 AssignCommand(oDefensor, ActionAttack(oEjecutor, TRUE));
          }
      }
  }
  else FloatingTextStringOnCreature("<cþ<<>* Sólo se puede usar esta dote con Escudo *</c>", OBJECT_SELF, FALSE); return;
}






