//::///////////////////////////////////////////////
//:: SENTIDO CIEGO
//:: Copyright (c) www.puertadebaldur.net
//:://////////////////////////////////////////////
/*
    Sentido ciego de discipulo de dragon
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 17/08/2012
//:://////////////////////////////////////////////

void PercibirCriatura(float fDireccionRastreador, object oRastreador, object oCriatura, float fDistancia)
{
  string sRaza;
  string sDistancia;
  string sDireccion;

  // Informacion de la criatura
  switch(GetCreatureSize(oCriatura))
  {
      case 21:  sRaza = "Una criatura minúscula";  break;
      case 20:  sRaza = "Una criatura diminuta";  break;
      case CREATURE_SIZE_TINY: sRaza = "Una criatura menuda"; break;
      case CREATURE_SIZE_SMALL: sRaza = "Una criatura pequeña"; break;
      case CREATURE_SIZE_MEDIUM: sRaza = "Una criatura de tamaño medio"; break;
      case CREATURE_SIZE_LARGE: sRaza = "Una criatura grande"; break;
      case CREATURE_SIZE_HUGE: sRaza = "Una criatura enorme"; break;
      case 22:  sRaza = "Una criatura gargantuesca"; break;
      case 23:  sRaza = "Una criatura colosal"; break;
      default: sRaza = "Una criatura extraña"; break;
  }

  // Informacion de la distancia
  sDistancia = " parece estar a unos " + IntToString(FloatToInt(fDistancia))+ " metros ";

  // Informacion de la direccion
  if(fDireccionRastreador >= 360.0) fDireccionRastreador = 720.0 - fDireccionRastreador;
  if(fDireccionRastreador < 0.0) fDireccionRastreador += 360.0;
  int iDireccionRastreador = FloatToInt(fDireccionRastreador);

  if(iDireccionRastreador >= 338 || iDireccionRastreador <=  22) sDireccion = "al este";
  else if(iDireccionRastreador >=  23 && iDireccionRastreador <=  67) sDireccion = "al noreste";
  else if(iDireccionRastreador >=  68 && iDireccionRastreador <= 112) sDireccion = "al norte";
  else if(iDireccionRastreador >= 113 && iDireccionRastreador <= 157) sDireccion = "al noroeste";
  else if(iDireccionRastreador >= 158 && iDireccionRastreador <= 202) sDireccion = "al oeste";
  else if(iDireccionRastreador >= 203 && iDireccionRastreador <= 247) sDireccion = "al suroeste";
  else if(iDireccionRastreador >= 248 && iDireccionRastreador <= 292) sDireccion = "al sur";
  else if(iDireccionRastreador >= 293 && iDireccionRastreador <= 337) sDireccion = "al sureste";


  DelayCommand(6.0, SendMessageToPC(oRastreador, "<c»ðª>" + sRaza + sDistancia + sDireccion + ".</c>"));
}

void main()
{
  object oRastreador = OBJECT_SELF;
  object oArea = GetArea(oRastreador);

  // Con efectos dayninos no puedes usarla
  int iFalloDote = FALSE;
  if(GetIsResting(oRastreador) || GetLocalInt(oRastreador, "DERRIBADO") || GetLocalInt(oRastreador, "SLIDING")) iFalloDote = TRUE;

  effect eEfecto = GetFirstEffect(oRastreador);
  while(GetIsEffectValid(eEfecto))
  {
      if(GetEffectType(eEfecto) == EFFECT_TYPE_CHARMED ||           GetEffectType(eEfecto) == EFFECT_TYPE_CONFUSED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENE_PARALYZE || GetEffectType(eEfecto) == EFFECT_TYPE_CUTSCENEIMMOBILIZE ||
         GetEffectType(eEfecto) == EFFECT_TYPE_DAZED ||             GetEffectType(eEfecto) == EFFECT_TYPE_DOMINATED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_ENTANGLE ||          GetEffectType(eEfecto) == EFFECT_TYPE_FRIGHTENED ||
         GetEffectType(eEfecto) == EFFECT_TYPE_PARALYZE ||          GetEffectType(eEfecto) == EFFECT_TYPE_PETRIFY ||
         GetEffectType(eEfecto) == EFFECT_TYPE_SLEEP ||             GetEffectType(eEfecto) == EFFECT_TYPE_STUNNED) iFalloDote = TRUE;

      eEfecto = GetNextEffect(oRastreador);
  }

  if(iFalloDote == TRUE)
  {
      FloatingTextStringOnCreature("<cþ•w>* En tu estado no puedes percibir las criaturas cercanas *</c>", OBJECT_SELF, FALSE);
      return;
  }

  // No puedes concentrarte para percibir en combate
  if(GetIsInCombat(oRastreador))
  {
      SendMessageToPC(oRastreador, "<cþ•w>No puedes percibir las criaturas cercanas en combate.</c>");
      return;
  }

  // Anti-saturamiento de sentido ciego
  if(GetLocalInt(oRastreador, "SENTIDOCIEGO_NOSATURAR") == TRUE)
  {
      SendMessageToPC(oRastreador, "<cþ•w>No puedes percibir criaturas tan rápidamente.</c>");
      return;
  }

  SetLocalInt(oRastreador, "SENTIDOCIEGO_NOSATURAR", TRUE);
  DelayCommand(10.0, DeleteLocalInt(oRastreador, "SENTIDOCIEGO_NOSATURAR"));

  // EMPIEZA EL PERCIBIR!!
  // Animacion y mensaje inicial
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oRastreador, 6.0);
  DelayCommand(0.2, FloatingTextStringOnCreature("<cþþþ>* Te concentras para percibir las criaturas cercanas *</c>", oRastreador));
  DelayCommand(0.3, AssignCommand(oRastreador, ClearAllActions()));
  DelayCommand(0.4, AssignCommand(oRastreador, PlayAnimation(ANIMATION_LOOPING_CUSTOM16, 1.0, 5.8)));

  // Metros maximos
  float fMetrosMaximos;
  if(GetLevelByClass(37, OBJECT_SELF) >= 10) fMetrosMaximos = 20.0;
  else fMetrosMaximos = 10.0;

  // Declaracion de variables
  int iCriaturasRastreadas;
  float fDistancia;
  int iPosicionCriaturaCercana = 1;
  object oCriatura = GetNearestObject(OBJECT_TYPE_CREATURE, oRastreador, iPosicionCriaturaCercana);

  // Comprueba todas las criaturas del area
  while(GetIsObjectValid(oCriatura))
  {
      fDistancia = GetDistanceBetween(oRastreador, oCriatura);

      // Solamente si se encuentra a menos de 10 o 20 metros
      if(/*GetObjectSeen(oCriatura, oRastreador) == TRUE && */fDistancia <= fMetrosMaximos)
      {
          iCriaturasRastreadas++;
          PercibirCriatura(GetFacing(oRastreador), oRastreador, oCriatura, fDistancia);
      }

      iPosicionCriaturaCercana++;
      oCriatura = GetNearestObject(OBJECT_TYPE_CREATURE, oRastreador, iPosicionCriaturaCercana);
  }

  // Mensaje de que no percibes nada
  if(iCriaturasRastreadas == 0) DelayCommand(6.0, SendMessageToPC(oRastreador, "<cþ•w>No percibes ninguna criatura cercana.</c>"));
}
