// INICIO MUNDO, TELETRANSPORTE A CIUDAD SEGUN SUBRAZA

#include "inicio_mundo_inc"

void main()
{
  object oPC = GetPCSpeaker();
  int nRacialType = GetRacialType(oPC);
  string sSubraza = GetStringLowerCase(GetSubRace(oPC));
  int iDrowSuperficie = ObtenerIntPersistente(oPC, "DROWSUPERFICIE");
  int iSemidrowSuperficie = ObtenerIntPersistente(oPC, "SEMIDROWSUPERFICIE");

  // Comprobaciones iniciales...
  if(ComprobarRestriccionesIniciales(oPC) == FALSE) return;

  // DEFINIMOS LOCALIZACIONES
  location lAbismo = GetLocation(GetWaypointByTag("abismo"));
  location lAthkatla = GetLocation(GetWaypointByTag("atk_inicio"));
  location lMascarasNocturnas = GetLocation(GetWaypointByTag("WP_espejo_mansion"));
  location lTorreInvertida = GetLocation(GetWaypointByTag("torre_invertida_tel"));
  location lMinotauros = GetLocation(GetWaypointByTag("inicio_minotauros"));
  location lTrasgos = GetLocation(GetWaypointByTag("inicio_trasgos"));
  location lOgros = GetLocation(GetWaypointByTag("inicio_ogros"));
  location lGhouls = GetLocation(GetWaypointByTag("inicio_ghouls"));
  location lDrows = GetLocation(GetWaypointByTag("inicio_drows"));
  location lLytharis = GetLocation(GetWaypointByTag("inicio_lythari"));

  // VAMPIROS Y ENGENDROS VAMPÍRICOS
  if(sSubraza == "vampiro" || sSubraza == "engendro")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lMascarasNocturnas)));
      return;
  }

  // MINOTAUROS, ORCOS Y OSGOS a ARENA DE MURANN
  else if(sSubraza == "minotauro" || sSubraza == "orco" || sSubraza == "osgo" || sSubraza == "orco gris")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lMinotauros)));
      return;
  }

  // TRASGOS, KOBOLDS y GNOLLS a DISTRITO SUR DE MURANN
  else if(sSubraza == "trasgo" || sSubraza == "gran trasgo" || sSubraza == "kobold" || sSubraza == "gnoll")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lTrasgos)));
      return;
  }

  // OGROS, SEMIOGROS Y SEMIINFERNALES a DISTRITO NORTE DE MURANN
  else if(sSubraza == "ogro" || sSubraza == "ogro hechicero" || sSubraza == "semiogro" || sSubraza == "semiinfernal")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lOgros)));
      return;
  }

  // GHULS
  else if(sSubraza == "ghul")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lGhouls)));
      return;
  }

    // LICHES Y TUMULARIOS
  else if(nRacialType == RACIAL_TYPE_WIGHT || sSubraza == "liche")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lTorreInvertida)));
      return;
  }

  // LYTHARIS
  else if(sSubraza == "lythari")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lLytharis)));
      return;
  }

  // SEMIFATAS
  else if(sSubraza == "semifata")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lLytharis)));
      return;
  }

  // SUBRAZAS DE LA ANTIPODA OSCURA (drows, semidrows, duergars, svirfneblins, githyankis y orogs)
  else if((sSubraza == "drow" && iDrowSuperficie == 0) ||
          (sSubraza == "semidrow" && iSemidrowSuperficie == 0) ||
           sSubraza == "duergar" || sSubraza == "svirfneblin" ||
           sSubraza == "githyanki" || sSubraza == "orog")
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lDrows)));
      return;
  }

  // SIN AREA DE INICIO
  else
  {
      DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
      DelayCommand(2.0, AssignCommand(oPC, ActionJumpToLocation(lAthkatla)));
      return;
  }
}
