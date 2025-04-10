//::///////////////////////////////////////////////
//:: Bigby's Forceful Hand
//:: [x0_s0_bigby2]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Embiste con un bono de +14.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 7, 2002
//:://////////////////////////////////////////////
//:: Last Updated By: Andrew Nobbs May 01, 2003

#include "x0_i0_spells"
#include "x2_inc_spellhook"
#include "pb_nivellanzador"
#include "colors_inc"

//This function makes the caller repel a target creature.
//object oTarget= The creature being repelled.
//float fDistance= The distance to repel (10.0 = 10m = 1tile)
//float fTime= The duration of repelling (seconds)
//This may be called by creatures or placeables, though placeables
//may only repel one creature at a time. Creatures may repel several.
//
//The function repels, and only repels the target.
//It assumes the target is not immune to sliding.
//Sliding cannot be resisted. Any extra features must be added
//by the end user (YOU) afterwards, outside of this function.
void ActionRepel(object oTarget, float fDistance, float fTime);

//This internal function of the repelling is not for general use.
location NewLoc(object oTarget, float fDistance);

//the actual code.
void ActionRepel(object oTarget, float fDistance, float fTime)
{
 if(GetLocalInt(oTarget, "SLIDING")==TRUE)
  return;
 float fPause= 0.9; //edit this built-in delay time at your own
 //risk. It controls how muc time passes before the target is
 //frozen and moved.

 //to make sure that two slide orders are not given at once.
 SetLocalInt(oTarget, "SLIDING", TRUE);

 //initial fall-down.
 AssignCommand(oTarget, ClearAllActions());
 AssignCommand(oTarget, PlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0, fTime));

 //application of effects to make the slide look better.
 effect eIncorporeo = EffectCutsceneGhost();
 effect eFreeze= EffectVisualEffect(VFX_DUR_FREEZE_ANIMATION);
 effect eMove= EffectMovementSpeedIncrease(99);

 DelayCommand(fPause, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eIncorporeo, oTarget, fTime-fPause));
 DelayCommand(fPause, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eFreeze, oTarget, fTime-fPause));
 DelayCommand(fPause, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eMove, oTarget, fTime-fPause));

//giving the orders to "run" to the new location.
 location lLoc;
 lLoc= NewLoc(oTarget, fDistance);

 AssignCommand(oTarget, DelayCommand(fPause-0.1, ClearAllActions()));
 AssignCommand(oTarget, DelayCommand(fPause, ActionMoveToLocation(lLoc, TRUE)));

//making sure that the effects wear off.
  AssignCommand(oTarget, DelayCommand(fTime, SetLocalInt(oTarget, "SLIDING", FALSE)));
  AssignCommand(oTarget, DelayCommand(fTime, SetCommandable(TRUE)));
  AssignCommand(oTarget, DelayCommand(fPause, SetCommandable(FALSE)));
}

location NewLoc(object oTarget, float fDistance)
{
 vector v1= GetPosition(oTarget);
 vector v2= GetPosition(OBJECT_SELF);
 vector v3;
 vector v4= v2*-1.0;
 vector vn= v1+v4;
 vn= VectorNormalize(vn);
 vn= vn*fDistance;
 vn= vn+v1;
 int nNth=1;

 object oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 while(GetIsObjectValid(oWp))
 {
 nNth++;
 v3= GetPosition(oWp);
 if(((v3.x<vn.x)&&(v2.x<v3.x))||((v3.x>vn.x)&&(v2.x>v3.x)))
 vn.x=v3.x;
 if(((v3.y<vn.y)&&(v2.y<v3.y))||((v3.y>vn.y)&&(v2.y>v3.y)))
 vn.y=v3.y;
 oWp= GetNearestObjectByTag("repel_limit_marker", oTarget, nNth);
 }

 return Location(GetArea(OBJECT_SELF), vn, GetFacing(OBJECT_SELF));
}

int VerSiEsTamanyoValido(object oObjetivo)
{
  int iTamanyoObjetivo   = GetCreatureSize(oObjetivo);

  if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 ||
     iTamanyoObjetivo == 2  || iTamanyoObjetivo == 3  || iTamanyoObjetivo == 4 ||
     iTamanyoObjetivo == 5) return TRUE;

  else return FALSE;
}

int BonificadorEmbestida(object oCriatura)
{
  int iBonificadorEmbestida;
  int iTamanyoCriatura = GetCreatureSize(oCriatura);

  if(GetRacialType(oCriatura) == RACIAL_TYPE_DWARF) iBonificadorEmbestida +=4;

  switch(iTamanyoCriatura)
  {
      case 21: iBonificadorEmbestida -=16;  break;
      case 20: iBonificadorEmbestida -=12;  break;
      case 1:  iBonificadorEmbestida -=8;  break;
      case 2:  iBonificadorEmbestida -=4;  break;
      case 4:  iBonificadorEmbestida +=4; break;
      case 5:  iBonificadorEmbestida +=8; break;
      case 22: iBonificadorEmbestida +=12; break;
      case 23: iBonificadorEmbestida +=16; break;
      default: iBonificadorEmbestida +=0;  break;
  }

  return iBonificadorEmbestida;
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

  if (!X2PreSpellCastCode())
  {
      // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
      return;
  }
  // End of Spell Cast Hook

  // COMPONENTE MATERIAL
  object oItm = GetSpellCastItem();
  if(GetIsPC(OBJECT_SELF) == TRUE &&
     oItm == OBJECT_INVALID &&
     GetIsDM(OBJECT_SELF) == FALSE &&
     GetIsDMPossessed(OBJECT_SELF) == FALSE)
  {
      // Si tienes la dote Abstencion de materiales, no necesitas componentes
      if(GetHasFeat(1200, OBJECT_SELF) == TRUE) SendMessageToPC(OBJECT_SELF, ColorToken(180,254,100) +"Gracias a la dote 'Abestención de materiales' puedes lanzar el conjuro sin necesitar ningún componente.</c>");
      else
      {
          if(GetItemPossessedBy(OBJECT_SELF, "guantearcano")==OBJECT_INVALID)
          {
              SendMessageToPC(OBJECT_SELF,"¡Necesitas un guante arcano para lanzar el conjuro!");
              return;
          }
          else
          {
              object oIngrediente = GetItemPossessedBy(OBJECT_SELF,"guantearcano");
              int iUsosIngrediente = GetLocalInt(oIngrediente, "USOS");

              if(iUsosIngrediente == 0)
              {
                  SetLocalInt(oIngrediente, "USOS", 1 + d2());
                  SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para lanzar este conjuro.");
              }
              else if(iUsosIngrediente == 1)
              {
                  DestroyObject(oIngrediente);
                  SendMessageToPC(OBJECT_SELF,"Consumes todo un guante arcano para lanzar este conjuro.");
              }
              else
              {
                  SetLocalInt(oIngrediente, "USOS", iUsosIngrediente - 1);
                  SendMessageToPC(OBJECT_SELF,"Utilizas parte de un guante arcano para lanzar este conjuro.");
              }
          }
      }
  }

  //Declare major variables
  object oTarget = GetSpellTargetObject();
  int nDuration = GetTotalCasterLevel(OBJECT_SELF);
  int nMetaMagic = GetSpellCastItem()==OBJECT_INVALID?GetMetaMagicFeat():METAMAGIC_NONE;

  //--------------------------------------------------------------------------
  // This spell no longer stacks. If there is one hand, that's enough
  //--------------------------------------------------------------------------
  if(GetHasSpellEffect(459, oTarget) ||  GetHasSpellEffect(460, oTarget) ||
     GetHasSpellEffect(461, oTarget) ||  GetHasSpellEffect(462, oTarget) ||
     GetHasSpellEffect(463, oTarget))
  {
      FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
      return;
  }

  //Check for metamagic extend
  if(nMetaMagic == METAMAGIC_EXTEND) //Duration is +100%
  {
      nDuration = nDuration * 2;
  }
  if(!GetIsReactionTypeFriendly(oTarget))
  {
      // Apply the impact effect
      effect eImpact = EffectVisualEffect(VFX_IMP_BIGBYS_FORCEFUL_HAND);
      ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, oTarget);
      //Fire cast spell at event for the specified target
      SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 460, TRUE));
      if(!MyResistSpell(OBJECT_SELF, oTarget))
      {
          int nCasterRoll = d20(1) + 14;
          int nTargetRoll = d20(1) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + BonificadorEmbestida(oTarget);

          if(nCasterRoll >= nTargetRoll)
          {
              // No puedes embestir a alguien muy grande con relacion a tu tamanyo
              if(VerSiEsTamanyoValido(oTarget) == FALSE)
              {
                  SendMessageToPC(OBJECT_SELF, ColorToken(155,254,254) + "La Mano forzuda de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de fuerza enfrentada: *fallo, tamaño demasiado grande para embestir*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
                  SendMessageToPC(oTarget, "<c���>La Mano forzuda de Bigby</c> <c��2>realiza una tirada de fuerza enfrentada: *fallo, tamaño demasiado grande para embestir*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
                  return;
              }

              ActionRepel(oTarget, 8.0 + ((nCasterRoll - nTargetRoll)/5), 10.0);
              SendMessageToPC(OBJECT_SELF, ColorToken(155,254,254) + "La Mano forzuda de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de fuerza enfrentada: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
              SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano forzuda de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de fuerza enfrentada: *éxito*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
          }
          else
          {
              SendMessageToPC(OBJECT_SELF, ColorToken(155,254,254) + "La Mano forzuda de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de fuerza enfrentada: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
              SendMessageToPC(oTarget, ColorToken(155,254,254) + "La Mano forzuda de Bigby</c> "+ ColorToken(254,150,50) + "realiza una tirada de fuerza enfrentada: *fallo*: "+IntToString(nCasterRoll)+" vs "+IntToString(nTargetRoll)+"</c>");
              DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");

          }
      }
  }
}
