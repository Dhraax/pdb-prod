#include "mti_libreria"
#include "tall_tall_inc"
void main()
{
  object oPC = GetLastClosedBy();

  // SI EL BANCO YA ESTA OCUPADO POR OTRA PERSONA, NADA OCURRE
  string sNombreMemorizado = GetLocalString(OBJECT_SELF, "BANCOOCUPADO");
  if(sNombreMemorizado != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("*El banco ya está siendo usada por otra persona*", oPC, FALSE);
      return;
  }

  // SI EL BANCO ESTA VACIO, NADA OCURRE
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*No hay nada en el banco, nada ocurre*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA USAR EL BANCO
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELTALLADOR");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Orfebrería antes de nada*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }
  // SI NO TE EQUIPAS UNA PUNZON DE DIAMANTE, EL SCRIPT NO SIGUE
  object oPunzon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetTag(oPunzon) != "punzon_tall"  &&
     GetTag(oPunzon) != "punzon_tall2" &&
     GetTag(oPunzon) != "punzon_tall3")
  {
      FloatingTextStringOnCreature("*No tienes equipado ningún punzón de diamante*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI NO HAY UN KIT DE HERRAMIENTAS DEL TALLADOR EL SCRIPT NO SIGUE
  object oKit = GetItemPossessedBy(OBJECT_SELF, "tall_kittall");
  if(oKit == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*Necesitas colocar un kit de herramientas del tallador para usar la tabla*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE GEMA(S) BRUTA(S) HEMOS METIDO Y GUARDAMOS LA CANTIDAD
int iCuarzo = 0;
int iObsidiana = 0;
int iAzabache = 0;
int iAmatista = 0;
int iCorvidar = 0;
int iEsmeralda = 0;
int iOpalocomun = 0;
int iOpalodeagua = 0;
int iOpalodefuego = 0;
int iOpalonegro = 0;
int iLagrimaroja = 0;
int iOrblen = 0;
int iOrlo = 0;
int iZendalur = 0;
int iBeljuril = 0;
int iLagrimaRey = 0;
int iPiedrapicara = 0;
int iJadetumba = 0;
int iAmarazha = 0;
int iBarralunar = 0;
int iZafiro = 0;
int iRubi = 0;
int iJacinto = 0;
int iZafironegro = 0;
int iZafiroestrella = 0;
int iRubiestrella = 0;
int iDiamante = 0;
int iTopacio = 0;



  object oTablIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oTablIng) == TRUE)
  {
      if(GetTag(oTablIng) == "bru_cuarzo") iCuarzo = iCuarzo + 1;
      else if(GetTag(oTablIng) == "bru_obs") iObsidiana = iObsidiana + 1;
      else if(GetTag(oTablIng) == "bru_aza") iAzabache = iAzabache + 1;
      else if(GetTag(oTablIng) == "bru_per") iAmatista = iAmatista + 1;
      else if(GetTag(oTablIng) == "bru_cor") iCorvidar = iCorvidar + 1;
      else if(GetTag(oTablIng) == "bru_esme") iEsmeralda = iEsmeralda + 1;
      else if(GetTag(oTablIng) == "bru_opalo") iOpalocomun = iOpalocomun + 1;
      else if(GetTag(oTablIng) == "bru_opaloa") iOpalodeagua = iOpalodeagua + 1;
      else if(GetTag(oTablIng) == "bru_opalof") iOpalodefuego = iOpalodefuego + 1;
      else if(GetTag(oTablIng) == "bru_opalon") iOpalonegro = iOpalonegro + 1;
      else if(GetTag(oTablIng) == "bru_lagrimar") iLagrimaroja = iLagrimaroja + 1;
      else if(GetTag(oTablIng) == "bru_orblen") iOrblen = iOrblen + 1;
      else if(GetTag(oTablIng) == "bru_orlo") iOrlo = iOrlo + 1;
      else if(GetTag(oTablIng) == "bru_zen") iZendalur = iZendalur + 1;
      else if(GetTag(oTablIng) == "bru_bel") iBeljuril = iBeljuril + 1;
      else if(GetTag(oTablIng) == "bru_lagrey") iLagrimaRey = iLagrimaRey + 1;
      else if(GetTag(oTablIng) == "bru_picara") iPiedrapicara = iPiedrapicara + 1;
      else if(GetTag(oTablIng) == "bru_jade") iJadetumba = iJadetumba + 1;
      else if(GetTag(oTablIng) == "bru_amar") iAmarazha = iAmarazha + 1;
      else if(GetTag(oTablIng) == "bru_barra") iBarralunar = iBarralunar + 1;
      else if(GetTag(oTablIng) == "bru_zaf") iZafiro = iZafiro + 1;
      else if(GetTag(oTablIng) == "bru_rubi") iRubi = iRubi + 1;
      else if(GetTag(oTablIng) == "bru_jac") iJacinto = iJacinto + 1;
      else if(GetTag(oTablIng) == "bru_zafnegro") iZafironegro = iZafironegro + 1;
      else if(GetTag(oTablIng) == "bru_zafestre") iZafiroestrella = iZafiroestrella + 1;
      else if(GetTag(oTablIng) == "bru_rubiestre") iRubiestrella = iRubiestrella + 1;
      else if(GetTag(oTablIng) == "bru_diam") iDiamante = iDiamante + 1;
      else if(GetTag(oTablIng) == "bru_top") iTopacio = iTopacio + 1;

      oTablIng = GetNextItemInInventory();
  }

  int iSumaGemas = iCuarzo + iObsidiana + iAzabache + iAmatista + iCorvidar + iEsmeralda + iOpalocomun + iOpalodeagua +
                   iOpalodefuego + iOpalonegro + iLagrimaroja + iOrblen + iOrlo + iZendalur + iBeljuril + iLagrimaRey +
                   iPiedrapicara + iJadetumba + iAmarazha + iBarralunar + iZafiro + iRubi + iJacinto + iZafironegro + iZafiroestrella + iRubiestrella + iDiamante + iTopacio;

  // SI NO HAY GEMAS BRUTAS, EL SCRIPT NO SIGUE
  if(iSumaGemas == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ninguna gema bruta en el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI HAY MAS DE UN PACK DE GEMAS BRUTAS, EL SCRIPT NO SIGUE
  if(iSumaGemas == 2)
  {
      FloatingTextStringOnCreature("*¡Hay demasiadas gemas en el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // A CREAR OBJETOS!

  //1. GEMAS TALLADAS:

  // ZAFIRO:
  if(iCuarzo == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Cuarzo hilaino en bruto...",
          "pu_cuarzo", "*¡Has logrado tallar un Cuarzo hilaino!*",
          60, 0);
      }

  // AMATISTA:
  else if(iObsidiana == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Obsidiana en bruto...",
          "pu_obs", "*¡Has logrado tallar una Obsidiana!*",
          80, 0);
      }

   // OBSIDIANA:
  else if(iAzabache == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Azabache en bruto...",
          "pu_aza", "*¡Has logrado tallar una Azabache!*",
          100, 0);
      }

   // RUBI:
  else if(iAmatista == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Amatista en bruto...",
          "pu_per", "*¡Has logrado tallar un Amatista!*",
          120, 0);
      }

  // TOPACIO:
  else if(iCorvidar == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Corvidar en bruto...",
          "pu_cor", "*¡Has logrado tallar un Corvidar!*",
          140, 0);
      }

    // DIAMANTE:
  else if(iEsmeralda)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Esmeralda en bruto...",
          "pu_esme", "*¡Has logrado tallar un Esmeralda!*",
          160, 0);
      }

   // AZABACHE:
  else if(iOpalocomun == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un cristal de Ópalo común en bruto...",
          "pu_opalo", "*¡Has logrado tallar un cristal de Ópalo común!*",
          180, 0);
      }

   // CUARZO HIALINO:
  else if(iOpalodeagua == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Ópalo de agua en bruto...",
          "pu_opaloa", "*¡Has logrado tallar un Ópalo de agua!*",
          200, 0);
      }

      else if(iOpalodefuego == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Ópalo de fuego en bruto...",
          "pu_opalof", "*¡Has logrado tallar un Ópalo de fuego!*",
          220, 0);
      }
      else if(iOpalonegro == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Ópalo negro en bruto...",
          "pu_opalon", "*¡Has logrado tallar un Ópalo negro!*",
          240, 0);
      }
      else if(iLagrimaroja == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Lágrima roja en bruto...",
          "pu_lagrimar", "*¡Has logrado tallar una Lágrima roja!*",
          260, 0);
      }
      else if(iOrblen == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Orblen en bruto...",
          "pu_orblen", "*¡Has logrado tallar un Orblen de agua!*",
          280, 0);
      }
      else if(iOrlo == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Orlo en bruto...",
          "pu_orlo", "*¡Has logrado tallar un Orlo!*",
          300, 0);
      }
      else if(iZendalur == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Zendalur en bruto...",
          "pu_zen", "*¡Has logrado tallar un Zendalur!*",
          320, 0);
      }
      else if(iBeljuril == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Beljuril en bruto...",
          "pu_bel", "*¡Has logrado tallar un Beljuril!*",
          340, 0);
      }

      else if(iLagrimaRey == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Lágrima del Rey en bruto...",
          "pu_lagrey", "*¡Has logrado tallar una Lágrima del Rey!*",
          360, 0);
      }
      else if(iPiedrapicara == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Piedra pícara en bruto...",
          "pu_picara", "*¡Has logrado tallar una Piedra pícara!*",
          380, 0);
      }
      else if(iJadetumba == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Jade de tumba en bruto...",
          "pu_jade", "*¡Has logrado tallar un Jade de tumba!*",
          400, 0);
      }
      else if(iAmarazha == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Amarazha en bruto...",
          "pu_amar", "*¡Has logrado tallar una Amarazha de agua!*",
          420, 0);
      }
      else if(iBarralunar == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando una Barra lunar en bruto...",
          "pu_barra", "*¡Has logrado tallar una Barra lunar!*",
          440, 0);
      }
      else if(iZafiro == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Zafiro en bruto...",
          "pu_zaf", "*¡Has logrado tallar un Zafiro!*",
          460, 0);
      }
       else if(iRubi == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Rubí en bruto...",
          "pu_rubi", "*¡Has logrado tallar un Rubí!*",
          480, 0);
      }

      else if(iJacinto == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Jacinto en bruto...",
          "pu_jac", "*¡Has logrado tallar un Jacinto!*",
          500, 0);
      }
      else if(iZafironegro == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Zafiro negro en bruto...",
          "pu_zafnegro", "*¡Has logrado tallar un Zafiro negro!*",
          510, 0);
      }
      else if(iZafiroestrella == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Zafiro estrella en bruto...",
          "pu_zafestre", "*¡Has logrado tallar un Zafiro estrella roja!*",
          510, 0);
      }
      else if(iRubiestrella == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Rubí estrella...",
          "pu_rubiestre", "*¡Has logrado tallar un Rubí estrella!*",
          515, 0);
      }
      else if(iDiamante == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Diamante...",
          "pu_diam", "*¡Has logrado tallar un Diamante!*",
          520, 0);
      }
      else if(iTopacio == 1)
      {
          TallarObjetosOrfebreria(oPC, "Tallando un Topacio...",
          "pu_top", "*¡Has logrado tallar un Topacio!*",
          110, 0);
      }
      else SendMessageToPC(oPC, "No deberias ver este mensaje, avisa a Darth");

}

