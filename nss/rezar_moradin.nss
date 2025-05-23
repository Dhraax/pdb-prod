// REZAR A LOS DIOSES ENANOS
#include "pb_oraciones"
void main()
{
  object oPC = GetLastUsedBy();

  int iUnaVez = Rezar_Dios(oPC);
  if(iUnaVez == TRUE)
  {
      SendMessageToPC(oPC, "Ya he rezado una vez, probaré más tarde.");
      return;
  }

    int iAli1 = GetAlignmentLawChaos(oPC);
    int iAli2 = GetAlignmentGoodEvil(oPC);

    if(iAli1 == ALIGNMENT_LAWFUL && iAli2 == ALIGNMENT_EVIL ||  //legal maligno
       iAli1 == ALIGNMENT_CHAOTIC && iAli2 == ALIGNMENT_EVIL    //caotico maligno
       )
       {
       FloatingTextStringOnCreature("*Tu alineamiento no te permite rezar a ninguna de las deidades presentes.*", oPC, FALSE);
       }
    else
      {
      SetLocalInt(oPC, "REZARMoradin", 1);
      DelayCommand(1440.0, DeleteLocalInt(oPC, "REZARMoradin"));

      SetCutsceneMode(oPC, TRUE);
      DelayCommand(20.0, SetCutsceneMode(oPC, FALSE));

      SetCameraMode(oPC, CAMERA_MODE_STIFF_CHASE_CAMERA);
      SetCutsceneCameraMoveRate(oPC, 0.1);

      AssignCommand(oPC, ActionDoCommand(SetFacingPoint(GetPositionFromLocation(GetLocation(OBJECT_SELF)))));
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0, 20.0));

      int iProb = d100();
      int iSab = GetAbilityModifier(ABILITY_WISDOM, oPC);
      if(iProb <= 25 + iSab)
      {
          effect eEfecto1 = EffectSkillIncrease(SKILL_SPOT,d10(1));
          effect eEfecto2 = EffectVisualEffect(VFX_FNF_TIME_STOP);

          DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEfecto1, oPC, 1000.0));
          DelayCommand(20.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEfecto2, oPC));

          DelayCommand(20.0, FloatingTextStringOnCreature("*¡Los Dioses te han bendecido!*", oPC, FALSE));
          GiveXPToCreature(oPC,100);
          return;
      }
      else
      {
          DelayCommand(20.0, FloatingTextStringOnCreature("*Tus rezos no han llegado a los Dioses.*", oPC, FALSE));
          GiveXPToCreature(oPC,10);
          return;
      }
  }
}
