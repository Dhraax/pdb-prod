#include "mti_libreria"
#include "mti_subrazas_inc"

// Se crea esta funcion dado los multiples lugares en que se chekean todas estas opciones
int ComprobarRestriccionesIniciales(object oPC, int iEfectos=0);

int ComprobarRestriccionesIniciales(object oPC, int iEfectos=0)
{
  int iRacialType = GetRacialType(oPC);
  int bNeedsApproval = StringToInt(Get2DAString("racialtypes", "NeedsApproval", iRacialType));
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  int bSubrazaAceptada = ObtenerIntPersistente(oPC, "SUBRAZAACEPTADA");

  // RESTRICCIONES DE CARGA DE HAKS (Si no tienes las dotes que deberias tener, te quedas en la Bolsa planar)
  if(GetHasFeat(1109, oPC) == FALSE) // (PB) Guardar PJ, por ejemplo, esta dote la deberian tener todos al crear el PJ
  {
      SendMessageToPC(oPC, "<cö-->Tu PJ no está configurado correctamente ya que te lo has creado sin que los haks del servidor hayan cargado correctamente. Consulta el foro sobre cómo debes crearte el PJ para que puedas jugar sin errores, o pregunta a algún DM para que pueda ayudarte.</c>");
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
      return FALSE;
  }

  // RESTRICCIONES DE SUBRAZAS (alineamiento)
  if(VerSiIncumploRequisitosSubrazas(oPC) && !bSubrazaAceptada)
  {
      SendMessageToPC(oPC, "<cö-->Tu PJ incumple el requisito de alineamiento de su subraza. Pregunta a los DMs qué puedes hacer.</c>");
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
      return FALSE;
  }

  // LAS SUBRAZAS QUE AUN NO HAN SIDO DESBLOQUEADAS NO SE MUEVEN DE LA BOLSA PLANAR!
  if(ObtenerIntPersistente(oPC, "SUBRAZAACEPTADA") == 0 &&
    (bNeedsApproval ||
     sSubraza == "avariel" ||
     sSubraza == "artico" ||
     sSubraza == "aasimar" ||
     sSubraza == "tiflin" ||
     sSubraza == "licantropo" ||
     sSubraza == "lythari" ||
    (sSubraza == "drow" && GetGender(oPC) == GENDER_FEMALE && GetLevelByClass(CLASS_TYPE_CLERIC, oPC) > 0) ||
     sSubraza == "drow" ||
     sSubraza == "semidrow" ||
     sSubraza == "ghul" ||
     sSubraza == "necropolita" ||
     sSubraza == "minotauro" ||
     sSubraza == "ogro" ||
     sSubraza == "ogro hechicero" ||
     sSubraza == "osgo" ||
     sSubraza == "genasi de aire" ||
     sSubraza == "genasi de agua" ||
     sSubraza == "genasi de tierra" ||
     sSubraza == "genasi de fuego" ||
     sSubraza == "githzerai" ||
     sSubraza == "githyanki" ||
     sSubraza == "semicelestial" ||
     sSubraza == "semiinfernal" ||
     sSubraza == "liche" ||
     sSubraza == "umbra" ||
     sSubraza == "orog" ||
     sSubraza == "svirfneblin" ||
     sSubraza == "deathknight" ||
     sSubraza == "semifata" ||
     sSubraza == "vampiro"))
  {
      SendMessageToPC(oPC, "<cö-->Tu subraza no ha sido aprobada. Contacta con nosotros via canal DM o en su correspondiente foro para obtener el permiso.</c>");
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
      return FALSE;
  }

  // CARCELES
  object oCarcelS = GetItemPossessedBy(oPC, "encarcelado_san");
  object oCarcelA = GetItemPossessedBy(oPC, "encarcelado_athk");
  location lCSanatorio = GetLocation(GetWaypointByTag("carcel_sanatorio"));
  location lCPrisionAthk = GetLocation(GetWaypointByTag("carcel_athk"));

  // ENCACERLADO EN EL SANATORIO
  if(oCarcelS != OBJECT_INVALID)
  {
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
      DelayCommand(0.5, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(0.6, AssignCommand(oPC, ActionJumpToLocation(lCSanatorio)));
      return FALSE;
  }

  // ENCACERLADO EN ATHKATLA
  else if(oCarcelA != OBJECT_INVALID)
  {
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_LOS_EVIL_30), GetLocation(oPC));
      DelayCommand(0.5, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(0.6, AssignCommand(oPC, ActionJumpToLocation(lCPrisionAthk)));
      return FALSE;
  }

  if(iEfectos == 0)
  {
      // EFECTOS VISUALES
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_UNSUMMON), GetLocation(oPC));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_SUMMON_CELESTIAL), GetLocation(oPC));
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_NATURES_BALANCE), GetLocation(oPC));
  }

  return TRUE;
}
