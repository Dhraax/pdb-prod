// Furia Intimidatoria
// Intimidar vs 1d20 + Nivel + Mod Sabiduria

#include "pb_nivellanzador"

int TiradaIntimidar(object oEjecutor, object oDefensor)
{
    int nSab = GetAbilityModifier(ABILITY_WISDOM, oDefensor);
    int nHD = GetHitDice(oDefensor);
    int iTiradaDefensor = d20(1) + nSab + nHD;
    int nIntimidar = d20(1) + GetSkillRank(SKILL_INTIMIDATE, oEjecutor);

    if(nIntimidar > iTiradaDefensor) {
    SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de Intimidar: *Exito*: "+IntToString(nIntimidar)+" Vs "+IntToString(iTiradaDefensor)+"</c>");
    return 1; }

    SendMessageToPC(oEjecutor, "<c›þþ>" + GetName(oEjecutor) + "</c> <cþ–2>realiza una tirada de Intimidar: *Fallo*: "+IntToString(nIntimidar)+" Vs "+IntToString(iTiradaDefensor)+"</c>");
    return 0;
}

void main()
{
    //Declare major variables
    object oPC = OBJECT_SELF;
    object oTarget = GetSpellTargetObject();
    object oMod = GetModule();
    effect eVis = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eAttackDecrease = EffectAttackDecrease(2);
    effect eSave = EffectSavingThrowDecrease(SAVING_THROW_ALL, 2);
    effect eSkill = EffectSkillDecrease(SKILL_ALL_SKILLS, 2);
    effect eLink = EffectLinkEffects(eAttackDecrease, eSave);
           eLink = EffectLinkEffects(eLink, eSkill);
    int nDur = 3 + GetAbilityModifier(ABILITY_CONSTITUTION);


// Solo a criaturas
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE)
      {
       FloatingTextStringOnCreature("<cþ<<>* Sólo puedes intimidar a criaturas *</c>", oPC, FALSE);
       return;
      }

      // Antisaturamiento, solo una vez cada 30 seg
  if(GetLocalInt(oMod, "FURIAINT" + GetName(oPC, TRUE)))
  {
      SendMessageToPC(oPC, "<cþ<<>Debes esperar 30 segundos para volver a usar esta habilidad.</c>");
      return;
  }

  SetLocalInt(oMod, "FURIAINT" + GetName(oPC, TRUE), TRUE);
  DelayCommand(30.0, DeleteLocalInt(oMod, "FURIAINT" + GetName(oPC, TRUE)));

    //Si es inmune nada
    if(GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR))
      {
       FloatingTextStringOnCreature("<cþ<<>* ¡No puedes intimidar a esta criatura! *</c>", oPC, FALSE);
       return;
      }


            //Solo si estamos en furia
            if(GetHasFeatEffect(FEAT_BARBARIAN_RAGE) || GetHasFeatEffect(1443))
            {
                //Make a saving throw check
                PlayVoiceChat(VOICE_CHAT_BATTLECRY2, oPC);
                if(TiradaIntimidar(oPC, oTarget) == 1 )
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDur));
                }

               else { ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_MAGIC_RESISTANCE_USE), oTarget); }
            }
           else FloatingTextStringOnCreature("** Debes estar en Furia para utilizar esta habilidad. **",OBJECT_SELF ,FALSE);
}
