#include "mti_libreria"
#include "orf_orf_inc"
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
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELENGARZADOR");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Orfebrería antes de nada*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }
  // SI NO TE EQUIPAS UN PUNZON, EL SCRIPT NO SIGUE
  object oPunzon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  if(GetTag(oPunzon) != "punzon_engar"  &&
     GetTag(oPunzon) != "punzon_engar2" &&
     GetTag(oPunzon) != "punzon_engar3")
  {
      FloatingTextStringOnCreature("*No tienes equipado ningún punzón de engarzar*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI NO HAY UN KIT DE HERRAMIENTAS DEL ENGARZADOR, EL SCRIPT NO SIGUE
  object oKit = GetItemPossessedBy(OBJECT_SELF, "eng_kiteng");
  if(oKit == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*Necesitas colocar un kit de herramientas del engarzador para usar la tabla*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE GEMA(S)/JOYA(S) HEMOS METIDO Y GUARDAMOS LA CANTIDAD
  int iAroBronce = 0;
  int iAroPlata = 0;
  int iAroPlatino = 0;
  int iAroOro = 0;
  int iCadenaBronce = 0;
  int iCadenaPlata = 0;
  int iCadenaPlatino = 0;
  int iCadenaOro = 0;


  object oTablIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oTablIng) == TRUE)
  {
      if(GetTag(oTablIng) == "bronce_aro") iAroBronce = iAroBronce + 1;
      else if(GetTag(oTablIng) == "plata_aro") iAroPlata = iAroPlata + 1;
      else if(GetTag(oTablIng) == "platino_aro") iAroPlatino = iAroPlatino + 1;
      else if(GetTag(oTablIng) == "oro_aro") iAroOro = iAroOro + 1;
      else if(GetTag(oTablIng) == "bronce_cadena") iCadenaBronce = iCadenaBronce + 1;
      else if(GetTag(oTablIng) == "plata_cadena") iCadenaPlata = iCadenaPlata + 1;
      else if(GetTag(oTablIng) == "platino_cadena") iCadenaPlatino = iCadenaPlatino + 1;
      else if(GetTag(oTablIng) == "oro_cadena") iCadenaOro = iCadenaOro + 1;

      oTablIng = GetNextItemInInventory();
  }

  int iSumaTablones = iAroBronce + iAroPlata + iAroPlatino + iAroOro + iCadenaBronce +
  iCadenaPlata + iCadenaPlatino + iCadenaOro;

  // SI NO HAY AROS O CADENAS, EL SCRIPT NO SIGUE
  if(iSumaTablones == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningún aro o cadena en el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

 // MIREMOS A VER QUE TIPO DE ACCESORIO (GEMA) HEMOS METIDO Y LO GUARDAMOS
  object oAccesorio = GetFirstItemInInventory();
  int iContadorAccesorios = 0;
  while(GetIsObjectValid(oAccesorio) == TRUE && iContadorAccesorios < 2)
  {
  if(GetStringLeft(GetTag(oAccesorio), 3) == "pu_")
      {

          SetLocalObject(OBJECT_SELF, "ACCESORIO", oAccesorio);
          iContadorAccesorios = iContadorAccesorios + 1;

      }

      oAccesorio = GetNextItemInInventory();
  }

  object oAccesorioGuardado = GetLocalObject(OBJECT_SELF, "ACCESORIO");
  string sTagAccesorio = GetTag(oAccesorioGuardado);

  // SI HAY MAS DE 1 ACCESORIO, EL SCRIPT NO SIGUE
  if(iContadorAccesorios == 2)
  {
      FloatingTextStringOnCreature("*¡Sobran gemas talladas, no satures el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI NO HAY ACCESORIO, EL SCRIPT NO SIGUE
  if(oAccesorioGuardado == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*¡Sin una gema tallada en el banco no puedes engarzar nada!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

// A CREAR OBJETOS!

  //1. AROS y CADENAS:

    if(iAroBronce == 1)
    {
        if(sTagAccesorio == "pu_cuarzo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo cobrizo de Cuarzo hilaino...",
          "anillo_cuarzo", "*¡Has logrado fabricar un anillo cobrizo de Cuarzo hilaino!*",
          80, 205);
        }
        else if(sTagAccesorio == "pu_obs")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo cobrizo de Obsidiana...",
          "anillo_obsidiana", "*¡Has logrado fabricar un anillo cobrizo de Obsidiana!*",
          90, 205);
        }
        else if(sTagAccesorio == "pu_aza")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo cobrizo de Azabache...",
          "anillo_azabache", "*¡Has logrado fabricar un anillo cobrizo de Azabache!*",
          100, 205);
        }
        else if(sTagAccesorio == "pu_per")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo cobrizo de Amatista...",
          "anillo_amatista", "*¡Has logrado fabricar un anillo cobrizo de Amatista!*",
          110, 205);
        }
        else if(sTagAccesorio == "pu_top")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo cobrizo de Topacio...",
          "anillo_topacio", "*¡Has logrado fabricar un anillo cobrizo de Topacio!*",
          120, 205);
        }

    }

    else if(iAroPlata == 1)
    {
        if(sTagAccesorio == "pu_jade")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Jade de tumba...",
          "anillo_jade", "*¡Has logrado fabricar un anillo plateado de Jade de tumba!*",
          140, 220);
        }
        else if(sTagAccesorio == "pu_opalo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Ópalo...",
          "anillo_opalo", "*¡Has logrado fabricar un anillo plateado de Ópalo!*",
          160, 240);
        }
        else if(sTagAccesorio == "pu_lagrimar")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Lágrima roja...",
          "anillo_lagrimar", "*¡Has logrado fabricar un anillo plateado de Lágrima roja!*",
          180, 260);
        }
        else if(sTagAccesorio == "pu_opalon")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Ópalo negro...",
          "anillo_opalon", "*¡Has logrado fabricar un anillo plateado de Ópalo negro!*",
          200, 280);
        }
        else if(sTagAccesorio == "pu_orblen")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Orblen...",
          "anillo_orblen", "*¡Has logrado fabricar un anillo plateado de Orblen!*",
          220, 300);
        }

        else if(sTagAccesorio == "pu_opalof")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Ópalo de fuego...",
          "anillo_opalof", "*¡Has logrado fabricar un anillo plateado de Ópalo de fuego!*",
          240, 320);
        }

        else if(sTagAccesorio == "pu_cor")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Corvidar...",
          "anillo_corvidar", "*¡Has logrado fabricar un anillo plateado de Corvidar!*",
          260, 340);
        }

        else if(sTagAccesorio == "pu_bel")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Beljuril...",
          "anillo_beljuril", "*¡Has logrado fabricar un anillo plateado de Beljuril!*",
          280, 360);
        }

        else if(sTagAccesorio == "pu_orlo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Orlo...",
          "anillo_orlo", "*¡Has logrado fabricar un anillo plateado de Orlo!*",
          300, 380);
        }

        else if(sTagAccesorio == "pu_zaf")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Zafiro...",
          "anillo_zafiro", "*¡Has logrado fabricar un anillo plateado de Zafiro!*",
          320, 400);
        }

        else if(sTagAccesorio == "pu_opaloa")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo plateado de Ópalo de agua...",
          "anillo_opaloa", "*¡Has logrado fabricar un anillo plateado de Ópalo de agua!*",
          340, 420);
        }

    }

    else if(iAroOro == 1)
    {
        if(sTagAccesorio == "pu_zen")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Zendalur...",
          "anillo_zendalur", "*¡Has logrado fabricar un anillo dorado de Zendalur!*",
          340, 440);
        }
        else if(sTagAccesorio == "pu_barra")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Barra lunar...",
          "anillo_barra", "*¡Has logrado fabricar un anillo dorado de Barra lunar!*",
          360, 460);
        }
        else if(sTagAccesorio == "pu_jac")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Jacinto...",
          "anillo_jacinto", "*¡Has logrado fabricar un anillo dorado de Jacinto!*",
          380, 480);
        }
        else if(sTagAccesorio == "pu_amar")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Amarazha...",
          "anillo_amarazha", "*¡Has logrado fabricar un anillo dorado de Amarazha!*",
          390, 500);
        }
        else if(sTagAccesorio == "pu_picara")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Piedra pícara...",
          "anillo_picara", "*¡Has logrado fabricar un anillo dorado de Piedra pícara!*",
          390, 500);
        }

        else if(sTagAccesorio == "pu_esme")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Esmeralda...",
          "anillo_esmeralda", "*¡Has logrado fabricar un anillo dorado de Esmeralda!*",
          400, 500);
        }

        else if(sTagAccesorio == "pu_zafnegro")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Zafiro negro...",
          "anillo_zafiron", "*¡Has logrado fabricar un anillo dorado de Zafiro negro!*",
          400, 500);
        }

        else if(sTagAccesorio == "pu_diam")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Diamante...",
          "anillo_diamante", "*¡Has logrado fabricar un anillo dorado de Diamante!*",
          420, 500);
        }

        else if(sTagAccesorio == "pu_rubi")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Rubí...",
          "anillo_rubi", "*¡Has logrado fabricar un anillo dorado de Rubí!*",
          440, 500);
        }

        else if(sTagAccesorio == "pu_lagrey")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Lágrimas del rey...",
          "anillo_lagrimrey", "*¡Has logrado fabricar un anillo dorado de Lágrimas del rey!*",
          460, 500);
        }

    }

    else if(iAroPlatino == 1)
    {
        if(sTagAccesorio == "pu_zafestre")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Zafiro estrella...",
          "anillo_zafiroe", "*¡Has logrado fabricar un anillo dorado de Zafiro estrella!*",
          500, 600);
        }
        else if(sTagAccesorio == "pu_rubiestre")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un anillo dorado de Rubí estrella...",
          "anillo_rubie", "*¡Has logrado fabricar un anillo dorado de Rubí estrella!*",
          500, 600);
        }

    }

   else if(iCadenaBronce == 1)
    {
        if(sTagAccesorio == "pu_cuarzo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto cobrizo de Cuarzo hilaino...",
          "amu_cuarzo", "*¡Has logrado fabricar un amuleto cobrizo de Cuarzo hilaino!*",
          80, 205);
        }
        else if(sTagAccesorio == "pu_obs")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto cobrizo de Obsidiana...",
          "amu_obsidiana", "*¡Has logrado fabricar un amuleto cobrizo de Obsidiana!*",
          90, 205);
        }
        else if(sTagAccesorio == "pu_aza")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto cobrizo de Azabache...",
          "amu_azabache", "*¡Has logrado fabricar un amuleto cobrizo de Azabache!*",
          100, 205);
        }
        else if(sTagAccesorio == "pu_per")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto cobrizo de Amatista...",
          "amu_amatista", "*¡Has logrado fabricar un amuleto cobrizo de Amatista!*",
          110, 205);
        }
        else if(sTagAccesorio == "pu_top")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto cobrizo de Topacio...",
          "amu_topacio", "*¡Has logrado fabricar un amuleto cobrizo de Topacio!*",
          120, 205);
        }

    }

    else if(iCadenaPlata == 1)
    {
        if(sTagAccesorio == "pu_jade")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Jade de tumba...",
          "amu_jade", "*¡Has logrado fabricar un amuleto plateado de Jade de tumba!*",
          140, 220);
        }
        else if(sTagAccesorio == "pu_opalo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Ópalo...",
          "amu_opalo", "*¡Has logrado fabricar un amuleto plateado de Ópalo!*",
          160, 240);
        }
        else if(sTagAccesorio == "pu_lagrimar")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Lágrima roja...",
          "amu_lagrimar", "*¡Has logrado fabricar un amuleto plateado de Lágrima roja!*",
          180, 260);
        }
        else if(sTagAccesorio == "pu_opalon")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Ópalo negro...",
          "amu_opalon", "*¡Has logrado fabricar un amuleto plateado de Ópalo negro!*",
          200, 280);
        }
        else if(sTagAccesorio == "pu_orblen")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Orblen...",
          "amu_orblen", "*¡Has logrado fabricar un amuleto plateado de Orblen!*",
          220, 300);
        }

        else if(sTagAccesorio == "pu_opalof")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Ópalo de fuego...",
          "amu_opalof", "*¡Has logrado fabricar un amuleto plateado de Ópalo de fuego!*",
          240, 320);
        }

        else if(sTagAccesorio == "pu_cor")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Corvidar...",
          "amu_corvidar", "*¡Has logrado fabricar un amuleto plateado de Corvidar!*",
          260, 340);
        }

        else if(sTagAccesorio == "pu_bel")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Beljuril...",
          "amu_beljuril", "*¡Has logrado fabricar un amuleto plateado de Beljuril!*",
          280, 360);
        }

        else if(sTagAccesorio == "pu_orlo")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Orlo...",
          "amu_orlo", "*¡Has logrado fabricar un amuleto plateado de Orlo!*",
          300, 380);
        }

        else if(sTagAccesorio == "pu_zaf")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Zafiro...",
          "amu_zafiro", "*¡Has logrado fabricar un amuleto plateado de Zafiro!*",
          320, 400);
        }

        else if(sTagAccesorio == "pu_opaloa")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto plateado de Ópalo de agua...",
          "amu_opaloa", "*¡Has logrado fabricar un amuleto plateado de Ópalo de agua!*",
          340, 420);
        }

    }

    else if(iCadenaOro == 1)
    {
        if(sTagAccesorio == "pu_zen")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Zendalur...",
          "amu_zendalur", "*¡Has logrado fabricar un amuleto dorado de Zendalur!*",
          340, 440);
        }
        else if(sTagAccesorio == "pu_barra")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Barra lunar...",
          "amu_barra", "*¡Has logrado fabricar un amuleto dorado de Barra lunar!*",
          360, 460);
        }
        else if(sTagAccesorio == "pu_jac")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Jacinto...",
          "amu_jacinto", "*¡Has logrado fabricar un amuleto dorado de Jacinto!*",
          380, 480);
        }
        else if(sTagAccesorio == "pu_amar")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Amarazha...",
          "amu_amarazha", "*¡Has logrado fabricar un amuleto dorado de Amarazha!*",
          390, 500);
        }
        else if(sTagAccesorio == "pu_picara")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Piedra pícara...",
          "amu_picara", "*¡Has logrado fabricar un amuleto dorado de Piedra pícara!*",
          390, 500);
        }

        else if(sTagAccesorio == "pu_esme")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Esmeralda...",
          "amu_esmeralda", "*¡Has logrado fabricar un amuleto dorado de Esmeralda!*",
          400, 500);
        }

        else if(sTagAccesorio == "pu_zafnegro")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Zafiro negro...",
          "amu_zafiron", "*¡Has logrado fabricar un amuleto dorado de Zafiro negro!*",
          400, 500);
        }

        else if(sTagAccesorio == "pu_diam")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Diamante...",
          "amu_diamante", "*¡Has logrado fabricar un amuleto dorado de Diamante!*",
          420, 500);
        }

        else if(sTagAccesorio == "pu_rubi")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Rubí...",
          "amu_rubi", "*¡Has logrado fabricar un amuleto dorado de Rubí!*",
          440, 500);
        }

        else if(sTagAccesorio == "pu_lagrey")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto dorado de Lágrimas del rey...",
          "amu_lagrimrey", "*¡Has logrado fabricar un amuleto dorado de Lágrimas del rey!*",
          460, 500);
        }

    }

    else if(iCadenaPlatino == 1)
    {
        if(sTagAccesorio == "pu_zafestre")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto platino de Zafiro estrella...",
          "amu_zafiroe", "*¡Has logrado fabricar un amuleto platino de Zafiro estrella!*",
          500, 600);
        }
        else if(sTagAccesorio == "pu_rubiestre")
        {
          CrearObjetosOrfebreria(oPC, "Fabricando un amuleto platino de Rubí estrella...",
          "amu_rubie", "*¡Has logrado fabricar un amuleto platino de Rubí estrella!*",
          500, 600);
        }

    }

else SendMessageToPC(oPC, "No has añadido los objetos correctos para engarzar nada.");
}
