#include "mti_libreria"
#include "carp_carp_inc"
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
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "NIVELCARPINTERIA");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro de Carpintería antes de nada*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI NO HAY UN KIT DE HERRAMIENTAS DEL CARPINTERO, EL SCRIPT NO SIGUE
  object oKit = GetItemPossessedBy(OBJECT_SELF, "carp_kitcarp");
  if(oKit == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*Necesitas colocar un kit de herramientas del carpintero para usar la tabla*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE TABLONES(S)/INGREDIENTE(S) HEMOS METIDO Y GUARDAMOS LA CANTIDAD
  int iTablonPino = 0;
  int iTablonCipres = 0;
  int iTablonAbeto = 0;
  int iTablonCedro = 0;
  int iTablonAlamo = 0;
  int iTablonOlmo = 0;
  int iTablonRoble = 0;
  int iTablonFresno = 0;
  int iPlumas = 0;
  int iBrisaSusurrante = 0;

  object oTablIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oTablIng) == TRUE)
  {
      if(GetTag(oTablIng) == "carptablon_pino") iTablonPino = iTablonPino + 1;
      else if(GetTag(oTablIng) == "carptablon_cipre") iTablonCipres = iTablonCipres + 1;
      else if(GetTag(oTablIng) == "carptablon_abeto") iTablonAbeto = iTablonAbeto + 1;
      else if(GetTag(oTablIng) == "carptablon_cedro") iTablonCedro = iTablonCedro + 1;
      else if(GetTag(oTablIng) == "carptablon_alamo") iTablonAlamo = iTablonAlamo + 1;
      else if(GetTag(oTablIng) == "carptablon_olmo") iTablonOlmo = iTablonOlmo + 1;
      else if(GetTag(oTablIng) == "carptablon_roble") iTablonRoble = iTablonRoble + 1;
      else if(GetTag(oTablIng) == "carptablon_fresn") iTablonFresno = iTablonFresno + 1;
      else if(GetTag(oTablIng) == "carpac2_plumas") iPlumas = iPlumas + 1;
      else if(GetTag(oTablIng) == "brisaSusurrante") iBrisaSusurrante = iBrisaSusurrante + 1;

      oTablIng = GetNextItemInInventory();
  }

  int iSumaTablones = iTablonPino + iTablonCipres + iTablonAbeto + iTablonCedro +
  iTablonAlamo + iTablonOlmo + iTablonRoble + iTablonFresno;

  // SI NO HAY TABLONES, EL SCRIPT NO SIGUE
  if(iSumaTablones == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningún tablón en el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // MIREMOS A VER QUE TIPO DE ACCESORIO HEMOS METIDO Y LO GUARDAMOS
  object oAccesorio = GetFirstItemInInventory();
  int iContadorAccesorios = 0;
  while(GetIsObjectValid(oAccesorio) == TRUE && iContadorAccesorios < 2)
  {
      if(GetStringLeft(GetTag(oAccesorio), 8) == "carpacc_")
      {
          SetLocalObject(OBJECT_SELF, "ACCESORIO", oAccesorio);
          iContadorAccesorios = iContadorAccesorios + 1;
      }

      oAccesorio = GetNextItemInInventory();
  }

  // SI HAY PLUMAS PERO NO PUNTAS DE FLECHA O VIROTE, EL SCRIPT NO SIGUE
  object oAccesorioGuardado = GetLocalObject(OBJECT_SELF, "ACCESORIO");
  string sTagAccesorio = GetTag(oAccesorioGuardado);
  if(iPlumas > 0 && sTagAccesorio != "carpacc_puntas1" && sTagAccesorio != "carpacc_puntas2")
  {
      FloatingTextStringOnCreature("*¡Tienes plumas pero no puntas de flecha o virote! No puedes fabricar nada sin eso*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI HAY MAS DE 1 ACCESORIO, EL SCRIPT NO SIGUE
  if(iContadorAccesorios == 2)
  {
      FloatingTextStringOnCreature("*¡Sobran accesorios, no satures el banco!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // SI NO HAY ACCESORIO, EL SCRIPT NO SIGUE
  if(oAccesorioGuardado == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*¡Sin un accesorio en el banco no puedes fabricar nada!*", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }

  // A CREAR OBJETOS!

  // ARCOS CORTOS
  if(sTagAccesorio == "carpacc_cuerda1")
  {
      // Arco corto de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de pino...",
          "pi_arcoc", "*¡Has logrado fabricar un arco corto de madera de pino!*",
          80, 30);
      }

      // Arco corto de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de cedro...",
          "ci_arcoc", "*¡Has logrado fabricar un arco corto de madera de cedro!*",
          140, 50);
      }

      // Arco corto de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de abeto...",
          "ab_arcoc", "*¡Has logrado fabricar un arco corto de madera de abeto!*",
          200, 80);
      }

      // Arco corto de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de roble...",
          "ce_arcoc", "*¡Has logrado fabricar un arco corto de madera de roble!*",
          260, 130);
      }

      // Arco corto de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de sombraalto...",
          "al_arcoc", "*¡Has logrado fabricar un arco corto de madera de sombraalto!*",
          320, 210);
      }

      // Arco corto de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de leñocaso...",
          "ol_arcoc", "*¡Has logrado fabricar un arco corto de madera de leñocaso!*",
          380, 340);
      }

      // Arco corto de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de zalantar...",
          "ro_arcoc", "*¡Has logrado fabricar un arco corto de madera de zalantar!*",
          440, 650);
      }

      // Arco corto de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco corto de madera de maderadique...",
          "fr_arcoc", "*¡Has logrado fabricar un arco corto de madera de maderadique!*",
          500, 1000);
      }


  // ARCOS LARGOS
      // Arco largo de madera pino (1)
      else if(iTablonPino == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de pino...",
          "pi_arcol", "*¡Has logrado fabricar un arco largo de madera de pino!*",
          100, 60);
      }

      // Arco largo de madera de cipres (2)
      else if(iTablonCipres == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de cedro...",
          "ci_arcol", "*¡Has logrado fabricar un arco largo de madera de cedro!*",
          160, 100);
      }

      // Arco largo de madera de abeto (3)
      else if(iTablonAbeto == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de abeto...",
          "ab_arcol", "*¡Has logrado fabricar un arco largo de madera de abeto!*",
          220, 160);
      }

      // Arco largo de madera de cedro (4)
      else if(iTablonCedro == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de roble...",
          "ce_arcol", "*¡Has logrado fabricar un arco largo de madera de roble!*",
          280, 260);
      }

      // Arco largo de madera de alamo (5)
      else if(iTablonAlamo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de sombralto...",
          "al_arcol", "*¡Has logrado fabricar un arco largo de madera de sombralto!*",
          340, 420);
      }

      // Arco largo de madera de olmo (6)
      else if(iTablonOlmo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de leñocaso...",
          "ol_arcol", "*¡Has logrado fabricar un arco largo de madera de leñocaso!*",
          400, 680);
      }

      // Arco largo de madera de roble (7)
      else if(iTablonRoble == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de zalantar...",
          "ro_arcol", "*¡Has logrado fabricar un arco largo de madera de zalantar!*",
          460, 1300);
      }

      // Arco largo de madera de fresno (8)
      else if(iTablonFresno == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un arco largo de madera de maderadique...",
          "fr_arcol", "*¡Has logrado fabricar un arco largo de madera de maderadique!*",
          520, 2000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }


  // BALLESTAS LIGERAS
  else if(sTagAccesorio == "carpacc_cuerda2")
  {
      // Ballesta ligera de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de pino...",
          "pi_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de pino!*",
          80, 30);
      }

      // Ballesta ligera  de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de cedro...",
          "ci_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de cedro!*",
          140, 50);
      }

      // Ballesta ligera  de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de abeto...",
          "ab_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de abeto!*",
          200, 80);
      }

      // Ballesta ligera  de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de roble...",
          "ce_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de roble!*",
          260, 130);
      }

      // Ballesta ligera  de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de sombralto...",
          "al_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de sombralto!*",
          320, 210);
      }

      // Ballesta ligera  de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de leñocaso...",
          "ol_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de leñocaso!*",
          380, 340);
      }

      // Ballesta ligera de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de zalantar...",
          "ro_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de zalantar!*",
          440, 650);
      }

      // Ballesta ligera de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta ligera de madera de maderadique...",
          "fr_ballestal", "*¡Has logrado fabricar una ballesta ligera de madera de maderadique!*",
          500, 1000);
      }


  // BALLESTA PESADAS
      // Ballesta pesada de madera pino (1)
      else if(iTablonPino == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de pino...",
          "pi_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de pino!*",
          100, 60);
      }

      // Ballesta pesada de madera de cipres (2)
      else if(iTablonCipres == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de cedro...",
          "ci_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de cedro!*",
          160, 100);
      }

      // Ballesta pesada de madera de abeto (3)
      else if(iTablonAbeto == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de abeto...",
          "ab_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de abeto!*",
          220, 160);
      }

      // Ballesta pesada de madera de cedro (4)
      else if(iTablonCedro == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de roble...",
          "ce_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de roble!*",
          280, 260);
      }

      // Ballesta pesada de madera de alamo (5)
      else if(iTablonAlamo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de sombralto...",
          "al_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de sombralto!*",
          340, 420);
      }

      // Ballesta pesada de madera de olmo (6)
      else if(iTablonOlmo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de leñocaso...",
          "ol_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de leñocaso!*",
          400, 680);
      }

      // Ballesta pesada de madera de roble (7)
      else if(iTablonRoble == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de zalantar...",
          "ro_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de zalantar!*",
          460, 1300);
      }

      // Ballesta pesada de madera de fresno (8)
      else if(iTablonFresno == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una ballesta pesada de madera de maderadique...",
          "fr_ballestap", "*¡Has logrado fabricar una ballesta pesada de madera de maderadique!*",
          520, 2000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }


  // FLECHAS
  else if(sTagAccesorio == "carpacc_puntas1")
  {
      if(iPlumas > 1)
      {
          FloatingTextStringOnCreature("*¡Sólo necesitas cien plumas! No pongas más*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }

      if(iPlumas == 0)
      {
          FloatingTextStringOnCreature("*¡Necesitas plumas para fabricar flechas!*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }

      // RECETA UNICA: Flecha veloz
      if(iBrisaSusurrante == 5 &&
         iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando cien flechas veloces...",
          "flechaveloz", "*¡Has logrado fabricar cien flechas veloces!*",
          250, 200);
          return;
      }

      // Flechas de madera pino (1)
      else if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de pino...",
          "pi_flecha", "*¡Has logrado fabricar cien flechas de madera de pino!*",
          80, 30);
      }

      // Flechas de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de cedro...",
          "ci_flecha", "*¡Has logrado fabricar cien flechas de madera de cedro!*",
          140, 50);
      }

      // Flechas de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de abeto...",
          "ab_flecha", "*¡Has logrado fabricar cien flechas de madera de abeto!*",
          200, 80);
      }

      // Flechas de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de roble...",
          "ce_flecha", "*¡Has logrado fabricar cien flechas de madera de roble!*",
          260, 130);
      }

      // Flechas de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de sombralto...",
          "al_flecha", "*¡Has logrado fabricar cien flechas de madera de sombralto!*",
          320, 210);
      }

      // Flechas de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de leñocaso...",
          "ol_flecha", "*¡Has logrado fabricar cien flechas de madera de leñocaso!*",
          380, 340);
      }

      // Flechas de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de zalantar...",
          "ro_flecha", "*¡Has logrado fabricar cien flechas de madera de zalantar!*",
          440, 650);
      }

      // Flechas de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando flechas de madera de maderadique...",
          "fr_flecha", "*¡Has logrado fabricar cien flechas de madera de maderadique!*",
          500, 1000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }

  // VIROTES
  else if(sTagAccesorio == "carpacc_puntas2")
  {
      if(iPlumas > 1)
      {
          FloatingTextStringOnCreature("*¡Sólo necesitas cien plumas! No pongas más*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }

      if(iPlumas == 0)
      {
          FloatingTextStringOnCreature("*¡Necesitas plumas para fabricar virotes!*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }

      // Virotes de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de pino...",
          "pi_virote", "*¡Has logrado fabricar cien virotes de madera de pino!*",
          80, 30);
      }

      // Virotes de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de cedro...",
          "ci_virote", "*¡Has logrado fabricar cien virotes de madera de cedro!*",
          140, 50);
      }

      // Virotes de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de abeto...",
          "ab_virote", "*¡Has logrado fabricar cien virotes de madera de abeto!*",
          200, 80);
      }

      // Virotes de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de roble...",
          "ce_virote", "*¡Has logrado fabricar cien virotes de madera de roble!*",
          260, 130);
      }

      // Virotes de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de sombralto...",
          "al_virote", "*¡Has logrado fabricar cien virotes de madera de sombralto!*",
          320, 210);
      }

      // Virotes de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de leñocaso...",
          "ol_virote", "*¡Has logrado fabricar cien virotes de madera de leñocaso!*",
          380, 340);
      }

      // Virotes de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de zalantar...",
          "ro_virote", "*¡Has logrado fabricar cien virotes de madera de zalantar!*",
          440, 650);
      }

      // Virotes de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando virotes de madera de maderadique...",
          "fr_virote", "*¡Has logrado fabricar cien virotes de madera de maderadique!*",
          500, 1000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }

  // CLAVAS
  else if(sTagAccesorio == "carpacc_mangoc")
  {
      // Clava de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de pino...",
          "pi_clava", "*¡Has logrado fabricar una clava de madera de pino!*",
          80, 30);
      }

      // Clava de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de cedro...",
          "ci_clava", "*¡Has logrado fabricar una clava de madera de cedro!*",
          140, 50);
      }

      // Clava de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de abeto...",
          "ab_clava", "*¡Has logrado fabricar una clava de madera de abeto!*",
          200, 80);
      }

      // Clava de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de roble...",
          "ce_clava", "*¡Has logrado fabricar una clava de madera de roble!*",
          260, 130);
      }

      // Clava de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de sombralto...",
          "al_clava", "*¡Has logrado fabricar una clava de madera de sombralto!*",
          320, 210);
      }

      // Clava de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de leñocaso...",
          "ol_clava", "*¡Has logrado fabricar una clava de madera de leñocaso!*",
          380, 340);
      }

      // Clava de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de zalantar...",
          "ro_clava", "*¡Has logrado fabricar una clava de madera de zalantar!*",
          440, 650);
      }

      // Clava de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando una clava de madera de maderadique...",
          "fr_clava", "*¡Has logrado fabricar una clava de madera de maderadique!*",
          500, 1000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }


  // BASTONES
  else if(sTagAccesorio == "carpacc_aros")
  {
      // Baston de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de pino...",
          "pi_baston", "*¡Has logrado fabricar un bastón de madera de pino!*",
          80, 30);
      }

      // Baston de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de cedro...",
          "ci_baston", "*¡Has logrado fabricar un bastón de madera de ciprés!*",
          140, 50);
      }

      // Baston de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de abeto...",
          "ab_baston", "*¡Has logrado fabricar un bastón de madera de abeto!*",
          200, 80);
      }

      // Baston de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de roble...",
          "ce_baston", "*¡Has logrado fabricar un bastón de madera de roble!*",
          260, 130);
      }

      // Baston de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de sombralto...",
          "al_baston", "*¡Has logrado fabricar un bastón de madera de sombralto!*",
          320, 210);
      }

      // Baston de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de leñocaso...",
          "ol_baston", "*¡Has logrado fabricar un bastón de madera de leñocaso!*",
          380, 340);
      }

      // Baston de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de zalantar...",
          "ro_baston", "*¡Has logrado fabricar un bastón de madera de zalantar!*",
          440, 650);
      }

      // Baston de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un bastón de madera de maderadique...",
          "fr_baston", "*¡Has logrado fabricar un bastón de madera de maderadique!*",
          500, 1000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }


  // ESCUDO PEQUENYO
  else if(sTagAccesorio == "carpacc_plancha1")
  {
      // Escudo pequeño de madera pino (1)
      if(iTablonPino == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de pino...",
          "pi_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de pino!*",
          80, 30);
      }

      // Escudo pequeño de madera de cipres (2)
      else if(iTablonCipres == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de cedro...",
          "ci_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de cedro!*",
          140, 50);
      }

      // Escudo pequeño de madera de abeto (3)
      else if(iTablonAbeto == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de abeto...",
          "ab_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de abeto!*",
          200, 80);
      }

      // Escudo pequeño de madera de cedro (4)
      else if(iTablonCedro == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de roble...",
          "ce_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de roble!*",
          260, 130);
      }

      // Escudo pequeño de madera de alamo (5)
      else if(iTablonAlamo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de sombralto...",
          "al_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de sombralto!*",
          320, 210);
      }

      // Escudo pequeño de madera de olmo (6)
      else if(iTablonOlmo == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de leñocaso...",
          "ol_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de leñocaso!*",
          380, 340);
      }

      // Escudo pequeño de madera de roble (7)
      else if(iTablonRoble == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de zalantar...",
          "ro_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de zalantar!*",
          440, 650);
      }

      // Escudo pequeño de madera de fresno (8)
      else if(iTablonFresno == 1)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pequeño de madera de maderadique...",
          "fr_escudop", "*¡Has logrado fabricar un escudo pequeño de madera de maderadique!*",
          500, 1000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }


  // ESCUDO GRANDE
  else if(sTagAccesorio == "carpacc_plancha2")
  {
      // Escudo grande de madera pino (1)
      if(iTablonPino == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de pino...",
          "pi_escudog", "*¡Has logrado fabricar un escudo grande de madera de pino!*",
          100, 60);
      }

      // Escudo grande de madera de cipres (2)
      else if(iTablonCipres == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de cedro...",
          "ci_escudog", "*¡Has logrado fabricar un escudo grande de madera de cedro!*",
          160, 100);
      }

      // Escudo grande de madera de abeto (3)
      else if(iTablonAbeto == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de abeto...",
          "ab_escudog", "*¡Has logrado fabricar un escudo grande de madera de abeto!*",
          220, 160);
      }

      // Escudo grande de madera de cedro (4)
      else if(iTablonCedro == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de roble...",
          "ce_escudog", "*¡Has logrado fabricar un escudo grande de madera de roble!*",
          280, 260);
      }

      // Escudo grande de madera de alamo (5)
      else if(iTablonAlamo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de sombralto...",
          "al_escudog", "*¡Has logrado fabricar un escudo grande de madera de sombralto!*",
          340, 420);
      }

      // Escudo grande de madera de olmo (6)
      else if(iTablonOlmo == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de leñocaso...",
          "ol_escudog", "*¡Has logrado fabricar un escudo grande de madera de leñocaso!*",
          400, 680);
      }

      // Escudo grande de madera de roble (7)
      else if(iTablonRoble == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de zalantar...",
          "ro_escudog", "*¡Has logrado fabricar un escudo grande de madera de zalantar!*",
          460, 1300);
      }

      // Escudo grande de madera de fresno (8)
      else if(iTablonFresno == 2)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo grande de madera de maderadique...",
          "fr_escudog", "*¡Has logrado fabricar un escudo grande de madera de maderadique!*",
          520, 2000);
      }


  // ESCUDO PAVES
      // Escudo pavés de madera pino (1)
      else if(iTablonPino == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de pino...",
          "pi_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de pino!*",
          120, 90);
      }

      // Escudo pavés de madera de cipres (2)
      else if(iTablonCipres == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de cedro...",
          "ci_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de cedro!*",
          180, 150);
      }

      // Escudo pavés de madera de abeto (3)
      else if(iTablonAbeto == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de abeto...",
          "ab_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de abeto!*",
          240, 240);
      }

      // Escudo pavés de madera de cedro (4)
      else if(iTablonCedro == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de roble...",
          "ce_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de roble!*",
          300, 390);
      }

      // Escudo pavés de madera de alamo (5)
      else if(iTablonAlamo == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de sombralto...",
          "al_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de sombralto!*",
          360, 630);
      }

      // Escudo pavés de madera de olmo (6)
      else if(iTablonOlmo == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de leñocaso...",
          "ol_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de leñocaso!*",
          420, 1020);
      }

      // Escudo pavés de madera de roble (7)
      else if(iTablonRoble == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de zalantar...",
          "ro_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de zalantar!*",
          480, 1950);
      }

      // Escudo pavés de madera de fresno (8)
      else if(iTablonFresno == 3)
      {
          CrearObjetosCarpinteria(oPC, "Fabricando un escudo pavés de madera de maderadique...",
          "fr_escudoe", "*¡Has logrado fabricar un escudo pavés de madera de maderadique!*",
          540, 3000);
      }

      else
      {
          FloatingTextStringOnCreature("*Esta combinación de tablones y accesorios no crea nada*", oPC, FALSE);
          EliminarVariablesBanco();
          return;
      }
  }

  // No hay accesorio?
  else
  {
      FloatingTextStringOnCreature("ERROR: Este mensaje no debería salir nunca, por favor informa a Kronos sobre esto", oPC, FALSE);
      EliminarVariablesBanco();
      return;
  }
}
