//::////////////////////////////////////////////////////////////////////////////
//::// Evento OnHora del modulo
//::////////////////////////////////////////////////////////////////////////////

#include "cab_inc"
#include "nwnx_player"
#include "inc_sqlite_time"
void main()
{
  object oPC = OBJECT_SELF;

  if(oPC == OBJECT_INVALID) return;

  // SISTEMA DE MUERTE
  // Espera en el Plano de Fuga
  int iHorasPlanoFuga = ObtenerIntPersistente(oPC, "ESTOY_EN_PLANOFUGA");
  if(iHorasPlanoFuga > 1)
  {
      int iSegundosRestantes = iHorasPlanoFuga - SQLite_GetTimeStamp();
      if(iSegundosRestantes >= 0)
      {
        SendMessageToPC(oPC, "<c þ >Te queda menos rato de espera. Tiempo restante: "+IntToString(iSegundosRestantes)+" segundos.</c>");
      }
      if(iSegundosRestantes < 0)
      {
        SendMessageToPC(oPC, "<c þ >Tu tiempo de espera ha pasado, puedes marchar.</c>");
      }
  }

  // CABALLOS
  // Nuestro nivel de equitacion o de montura aumenta
  if(ObtenerIntPersistente(oPC, "CAB_MONTADO") > 0)
  {
      string sEtiquetaDeAreaGuardada = GetLocalString(oPC, "CAB_ETIQUETAAREA");
      string sEtiquetaDeAreaActual = GetTag(GetArea(oPC));
      if(sEtiquetaDeAreaGuardada != sEtiquetaDeAreaActual)
      {
          // Marcamos la nueva area
          SetLocalString(oPC, "CAB_ETIQUETAAREA", sEtiquetaDeAreaActual);

          // Subimos nivel de jinete
          int iNivelEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACION");
          int iXPEquitacion = ObtenerIntPersistente(oPC, "NIVELEQUITACIONXP");
          int iXPEquitacionSigNivel = CalculoSiguienteNivelXPEquitacion(iNivelEquitacion);
          if(iXPEquitacion < iXPEquitacionSigNivel && iNivelEquitacion < 100)
          {
              int PuntosXEquitacion = d4() + iNivelEquitacion/5;
              NWNX_Player_PlaySound(oPC, "as_fanfare_intro");
              FloatingTextStringOnCreature("<c´þd>+"+IntToString(PuntosXEquitacion)+" XP de Equitación</c>", oPC, FALSE);
              GuardarIntPersistente(oPC, "NIVELEQUITACIONXP", iXPEquitacion + PuntosXEquitacion);
              if(iXPEquitacion + PuntosXEquitacion >= iXPEquitacionSigNivel)
              {
                  DelayCommand(3.4, NWNX_Player_PlaySound(oPC, "as_fanfare_long"));

                  if(iNivelEquitacion == 9 || iNivelEquitacion == 24 || iNivelEquitacion == 49 ||
                     iNivelEquitacion == 69 || iNivelEquitacion == 89 || iNivelEquitacion == 99)
                  {
                      DelayCommand(3.5, SendMessageToPC(oPC, "<c þ >¡Enhorabuena! Estás listo para alcanzar el nivel "+IntToString(iNivelEquitacion+1)+" de equitación, pero para ello tendrás que pedir a algún cuidador de establos que te siga entrenando.</c>"));
                  }
                  else
                  {
                      DelayCommand(3.5, FloatingTextStringOnCreature("<c þ >¡Has subido al nivel "+IntToString(iNivelEquitacion+1)+" de Equitación!</c>", oPC, FALSE));
                      DelayCommand(3.6, SetXP(oPC, GetXP(oPC) + 25 + iNivelEquitacion));
                      DelayCommand(3.7, GuardarIntPersistente(oPC, "NIVELEQUITACION", iNivelEquitacion + 1));
                      DelayCommand(4.0, ReaplicarEfectosPB(oPC,TRUE));
                  }
              }
          }

          object oMonturaUsada = GetFirstItemInInventory(oPC);
          int iUnaSolaVez, iPuntosXMontura;
          while(GetIsObjectValid(oMonturaUsada) == TRUE && iUnaSolaVez == FALSE)
          {
              if(GetTag(oMonturaUsada) == "cab_montura" &&
                 GetItemCursedFlag(oMonturaUsada) == TRUE &&
                 GetLocalInt(oMonturaUsada, "CAB_MUERTO") == FALSE)
              {
                  // Subimos nivel de montura
                  int iNivelMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURA");
                  int iXPMontura = GetLocalInt(oMonturaUsada, "NIVELMONTURAXP");
                  int iXPMonturaSigNivel = CalculoSiguienteNivelXPMontura(iNivelMontura);
                  if(iXPMontura < iXPMonturaSigNivel && iNivelMontura < 20)
                  {
                      iPuntosXMontura = d4() + iNivelMontura/5;
                      DelayCommand(10.5, NWNX_Player_PlaySound(oPC, "as_fanfare_intro"));
                      DelayCommand(10.6, FloatingTextStringOnCreature("<c´þd>+"+IntToString(iPuntosXMontura)+" XP de Montura</c>", oPC, FALSE));
                      DelayCommand(10.7, SetLocalInt(oMonturaUsada, "NIVELMONTURAXP", iXPMontura + iPuntosXMontura));
                      DelayCommand(10.8, DescripcionMontura(oMonturaUsada));
                      if(iXPMontura + iPuntosXMontura >= iXPMonturaSigNivel)
                      {
                          DelayCommand(14.0, NWNX_Player_PlaySound(oPC, "as_fanfare_long"));
                          DelayCommand(14.1, SendMessageToPC(oPC, "<c þ >¡Enhorabuena! Tu montura está lista para alcanzar el nivel "+IntToString(iNivelMontura+1)+", pero para ello tendrás que pedir a algún cuidador de establos que te la entrene.</c>"));
                      }
                  }

                  iUnaSolaVez = TRUE;
              }

              oMonturaUsada = GetNextItemInInventory(oPC);
          }
      }
  }
}
