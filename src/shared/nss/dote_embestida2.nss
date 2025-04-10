#include "lib_disguise"
//::///////////////////////////////////////////////
//:: DOTE EMBESTIDA Y EMBESTIDA MEJORADA
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
    Embestida.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 15 de Junio de 2011
//:://////////////////////////////////////////////

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

// 1. Minusculo (Fine, 21)
// 2. Diminuto (Diminutive, 20)
// 3. Menudo (Tiny, 1)
// 4. Pequenyo (Small, 2)
// 5. Mediano (Medium, 3)
// 6. Grande (Large, 4)
// 7. Enorme (Huge, 5)
// 8. Gargantuesco (Gargantuesco, 22)
// 9. Colosal (Colosal, 23)
int VerSiEsTamanyoValido(object oEjecutador, object oObjetivo)
{
  int iTamanyoEjecutador = GetCreatureSize(oEjecutador);
  int iTamanyoObjetivo   = GetCreatureSize(oObjetivo);

  if(iTamanyoEjecutador == 21) // 1. Minusculo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 20) // 2. Diminuto
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 1) // 3. Menudo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 2) // 4. Pequenyo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 3) // 5. Mediano
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 4) // 6. Grande
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4 || iTamanyoObjetivo == 5) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 5) // 7. Enorme
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4 || iTamanyoObjetivo == 5 || iTamanyoObjetivo == 22) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 22 || iTamanyoEjecutador == 23) return TRUE; // 8. Gargantuesco y 9. Colosal

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
  object oPC = OBJECT_SELF;
  object oObjetivo = GetLocalObject(oPC, "EMBESTIDA_DEFENSOR");

  // Comprobacion de distancia cercana (4 metros)
  float fdistanciaEmbestida = GetDistanceBetween(oPC, oObjetivo);
  float fDistanciaRequerida = 2.5;

  if(GetCreatureSize(oObjetivo) == 4) fDistanciaRequerida = 5.0;
  else if(GetCreatureSize(oObjetivo) == 5) fDistanciaRequerida = 7.5;
  else if(GetCreatureSize(oObjetivo) == 22) fDistanciaRequerida = 10.0;
  else if(GetCreatureSize(oObjetivo) == 23) fDistanciaRequerida = 12.5;

  //SendMessageToPC(oPC, "Distancia cercana: " + FloatToString(fdistanciaEmbestida,2,2));

  if(fdistanciaEmbestida > fDistanciaRequerida)
  {
      FloatingTextStringOnCreature("<cþ<<>* Intento de embestir anulado, objetivo demasiado lejos *</c>", OBJECT_SELF, FALSE);
      return;
  }

  int iDado20Ejecutor = d20();
  int iDado20Defensor = d20();
  int iBonoEmbestidaMejoradaEjecutor = 0;
  if(GetHasFeat(1157, oPC)) iBonoEmbestidaMejoradaEjecutor = 4;
  int iBonoCarga = GetLocalInt(oPC, "EMBESTIDA_BONOCARGA");
  int iBonosEjecutor = GetAbilityModifier(ABILITY_STRENGTH, oPC) + BonificadorEmbestida(oPC) + iBonoEmbestidaMejoradaEjecutor + iBonoCarga;
  int iBonosDefensor = GetAbilityModifier(ABILITY_STRENGTH, oObjetivo) + BonificadorEmbestida(oObjetivo);

  int iTiradaEjecutor = iDado20Ejecutor + iBonosEjecutor;
  int iTiradaDefensor = iDado20Defensor + iBonosDefensor;

  if(iTiradaEjecutor >= iTiradaDefensor) // Exito
  {
      // No puedes embestir a alguien muy grande con relacion a tu tamanyo
      if(VerSiEsTamanyoValido(oPC, oObjetivo) == FALSE)
      {
          //DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
          FloatingTextStringOnCreature("<cþ<<>* No puedes embestir a criaturas con ese tamaño *</c>", OBJECT_SELF, FALSE);
          SendMessageToPC(oObjetivo, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: ("+IntToString(iDado20Ejecutor)+" + "+IntToString(iBonosEjecutor)+" = "+IntToString(iTiradaEjecutor)+")</c>");
          FloatingTextStringOnCreature("<c´þd>* ¡Has resistido el intento de embestir de ["+PB_Disguise_GetNameOverride(oPC)+"]! *</c>", oObjetivo);
          return;
      }

      ActionRepel(oObjetivo, 3.0 + ((iTiradaDefensor - iTiradaEjecutor)/5), 3.0);
      SendMessageToPC(oPC, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *éxito*: ("+IntToString(iDado20Ejecutor)+" + "+IntToString(iBonosEjecutor)+" = "+IntToString(iTiradaEjecutor)+")</c>");
      FloatingTextStringOnCreature("<c´þd>* ¡Embistes a ["+PB_Disguise_GetNameOverride(oObjetivo)+"] con éxito! *</c>", oPC);
      SendMessageToPC(oObjetivo, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *éxito*: ("+IntToString(iDado20Ejecutor)+" + "+IntToString(iBonosEjecutor)+" = "+IntToString(iTiradaEjecutor)+")</c>");
      FloatingTextStringOnCreature("<cþ<<>* ¡["+PB_Disguise_GetNameOverride(oPC)+"] te ha embestido! *</c>", oObjetivo);
  }
  else // Fracaso
  {
      SendMessageToPC(oPC, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: ("+IntToString(iDado20Ejecutor)+" + "+IntToString(iBonosEjecutor)+" = "+IntToString(iTiradaEjecutor)+")</c>");
      FloatingTextStringOnCreature("<cþ<<>* ¡["+PB_Disguise_GetNameOverride(oObjetivo)+"] ha resistido tu intento de embestir! *</c>", oPC);
      SendMessageToPC(oObjetivo, "<c›þþ>" + PB_Disguise_GetNameOverride(oPC) + "</c> <cþ–2>realiza una tirada de fuerza enfrentada: *fallo*: ("+IntToString(iDado20Ejecutor)+" + "+IntToString(iBonosEjecutor)+" = "+IntToString(iTiradaEjecutor)+")</c>");
      FloatingTextStringOnCreature("<c´þd>* ¡Has resistido el intento de embestir de ["+PB_Disguise_GetNameOverride(oPC)+"]! *</c>", oObjetivo);

      if(d100() <= 25) // Al fracasar, 25% probabilidad de que rebotes
      {
          AssignCommand(oObjetivo, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 5.0, 1.0));
          DelayCommand(1.0, AssignCommand(oObjetivo, PlayAnimation(ANIMATION_LOOPING_CUSTOM19, 1.0, 0.1)));
          DelayCommand(1.0, AssignCommand(oObjetivo, ActionRepel(oPC, 3.0 + ((iTiradaDefensor - iTiradaEjecutor)/5), 3.0)));
          DelayCommand(1.0, FloatingTextStringOnCreature("<cþ<<>* ¡Rebotas hacia atrás! *</c>", oPC));
      }
  }
}
