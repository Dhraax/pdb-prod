#include "mti_libreria"
#include "yunque_inc"

void main()
{
  object oPC = GetLastClosedBy();

  // LA MESA YA ESTA OCUPADO POR OTRA PERSONA, NADA OCURRE
  string sNombreMemorizado = GetLocalString(OBJECT_SELF, "YUNQUEOCUPADO");
  if(sNombreMemorizado != GetName(oPC, TRUE))
  {
      FloatingTextStringOnCreature("*La mesa ya está siendo usada por otra persona*", oPC, FALSE);
      return;
  }

  // ESTA VACIO, NADA OCURRE
  if(GetFirstItemInInventory() == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*No hay nada en la mesa, nada ocurre*", oPC, FALSE);
      return;
  }

  // NECESITAS TENER NIVEL 1 O MAS PARA USAR EL YUNQUE
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion12");
  if(iNivelHabilidad == 0)
  {
      FloatingTextStringOnCreature("*Quizás debería hablar con algún maestro peletero antes de nada*", oPC, FALSE);
      return;
  }

  // SI NO TE EQUIPAS UNA AGUJA, EL SCRIPT NO SIGUE
  object oAguja = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
  // aguja_cost: las agujas basicas pasaron al CNR y comparten ese tag. Se
  // acepta aqui para que el peletero antiguo siga funcionando con ellas.
  if(GetTag(oAguja) != "aguja_hierro"  &&
     GetTag(oAguja) != "aguja_cost" &&
     GetTag(oAguja) != "aguja_acero" &&
     GetTag(oAguja) != "aguja_aceroscuro" &&
     GetTag(oAguja) != "aguja_grande" &&
     GetTag(oAguja) != "aguja_mithril")
  {
      FloatingTextStringOnCreature("*No tienes equipado ningúna aguja de peletero*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO DE MOLDE HEMOS METIDO Y LO GUARDAMOS
  object oMolde;
  oMolde = GetFirstItemInInventory();
  int iContadorMoldes;
  iContadorMoldes = 0;
  while(GetIsObjectValid(oMolde) == TRUE && iContadorMoldes < 2)
  {
      if(GetStringLeft(GetTag(oMolde), 12) == "sapo_plnt12_")
      {
          SetLocalObject(OBJECT_SELF, "MOLDE", oMolde);
          iContadorMoldes = iContadorMoldes + 1;
      }

      oMolde = GetNextItemInInventory();
  }

  // SI HAY MAS DE 1 MOLDE, EL SCRIPT NO SIGUE
  if(iContadorMoldes == 2)
  {
      FloatingTextStringOnCreature("*Sólo necesitas usar un tipo de plantilla*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // SI NO HAY MOLDE, EL SCRIPT NO SIGUE
  object oMoldeGuardado = GetLocalObject(OBJECT_SELF, "MOLDE");
  if(oMoldeGuardado == OBJECT_INVALID)
  {
      FloatingTextStringOnCreature("*¡Sin una plantilla no puedes crear nada¡*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  // MIREMOS A VER QUE TIPO(S) DE CUERO(S)/INGREDIENTE(S) HEMOS METIDO Y
  // GUARDAMOS LA CANTIDAD
  int iRoedor = 0;
  int iHerbivoro = 0;
  int iBestia = 0;
  int iBestiaGrande = 0;
  int iMitica = 0;
  int iMiticaGrande = 0;
  int iDracoFuego = 0;
  int iDracoHielo = 0;
  int iDracoAcido = 0;
  int iDracoRayo = 0;
  int iTachones = 0;
  int iSeda = 0;
  int iCorreas = 0;
  int iTachonReforzado = 0;

  object oLingIng = GetFirstItemInInventory();
  while(GetIsObjectValid(oLingIng) == TRUE)
  {
      if(GetTag(oLingIng) == "cuero_roedor") iRoedor = iRoedor + 1;
      else if(GetTag(oLingIng) == "cuero_herbivoro") iHerbivoro = iHerbivoro + 1;
      else if(GetTag(oLingIng) == "cuero_bestia") iBestia = iBestia + 1;
      else if(GetTag(oLingIng) == "cuero_bestiag") iBestiaGrande = iBestiaGrande + 1;
      else if(GetTag(oLingIng) == "cuero_mitica") iMitica = iMitica + 1;
      else if(GetTag(oLingIng) == "cuero_miticag") iMiticaGrande = iMiticaGrande + 1;
      else if(GetTag(oLingIng) == "cuero_dragof") iDracoFuego = iDracoFuego + 1;
      else if(GetTag(oLingIng) == "cuero_dragoh") iDracoHielo = iDracoHielo + 1;
      else if(GetTag(oLingIng) == "cuero_dragoa") iDracoAcido = iDracoAcido + 1;
      else if(GetTag(oLingIng) == "cuero_dragor") iDracoRayo = iDracoRayo + 1;
      else if(GetTag(oLingIng) == "sapo_ing_tachon") iTachones = iTachones + 1;
      else if(GetTag(oLingIng) == "sedas") iSeda = iSeda + 1;
      else if(GetTag(oLingIng) == "correas") iCorreas = iCorreas + 1;
      else if(GetTag(oLingIng) == "tachones_reforza") iTachonReforzado = iTachonReforzado + 1;

      oLingIng = GetNextItemInInventory();
  }

  int iSumaLingotes = iRoedor + iHerbivoro + iBestia +
      iBestiaGrande + iMitica + iMiticaGrande + iDracoFuego +
      iDracoHielo + iDracoAcido + iDracoRayo;

  // SI NO HAY CUEROS, EL SCRIPT NO SIGUE
  if(iSumaLingotes == 0)
  {
      FloatingTextStringOnCreature("*¡No hay ningún cuero con el que trabajar!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

  //DEPENDE DEL TIPO DE CUERO ES NECESARIO UNA AGUJA U OTRA
    if(iBestia >= 1 && GetTag(oAguja) != "aguja_acero" || iBestiaGrande >= 1 && GetTag(oAguja) != "aguja_acero") {
      FloatingTextStringOnCreature("*¡Para trabajar este material necesitas una aguja de acero!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
    }
    else if(iMitica >= 1 && GetTag(oAguja) != "aguja_aceroscuro" || iMiticaGrande >= 1 && GetTag(oAguja) != "aguja_aceroscuro") {
      FloatingTextStringOnCreature("*¡Para trabajar este material necesitas una aguja de acerooscuro!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
    }
    else if(iDracoFuego >= 1 && GetTag(oAguja) != "aguja_mithril" || iDracoHielo >= 1 && GetTag(oAguja) != "aguja_mithril" || iDracoAcido >= 1 || iDracoRayo >= 1 && GetTag(oAguja) != "aguja_mithril") {
      FloatingTextStringOnCreature("*¡Para trabajar este material necesitas una aguja de mithril!*", oPC, FALSE);
      EliminarVariablesYunque();
      return;
    }

  // A CREAR OBJETOS!
  string sTagMolde = GetTag(oMoldeGuardado);

  // ARMADURAS
  if(sTagMolde == "sapo_plnt12_armd")
  {
      // Armadura de roedor CA3
      if(iRoedor == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de roedor...",
          "cu_roedor", "*¡Has logrado fabricar una armadura de cuero de roedor!*",
          126, 100, "contenedor_peletero");
      }

      // Armadura de hervivoroCA3
      else if(iHerbivoro == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de herbivoro...",
          "cu_herbivoro", "*¡Has logrado fabricar una armadura de cuero de herbivoro!*",
          180, 150, "contenedor_peletero");
      }

      //  Armadura de bestia   CA3
      else if(iBestia == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje...",
          "cu_bestia", "*¡Has logrado fabricar una armadura de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  Armadura de bestia grande  CA3
      else if(iBestiaGrande == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje grande...",
          "cu_bestiag", "*¡Has logrado fabricar una armadura de cuero de bestia salvaje grande!*",
          320, 350, "contenedor_peletero");
      }
      //  Armadura de bestia mitica  CA3
      else if(iMitica == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica...",
          "cu_mitica", "*¡Has logrado fabricar una armadura de cuero de bestia mitica!*",
          375, 450, "contenedor_peletero");
      }
      //  Armadura de bestia mitica grande   CA3
      else if(iMiticaGrande == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica gruesa...",
          "cu_miticag", "*¡Has logrado fabricar una armadura de cuero de bestia mitica gruesa!*",
          455, 550, "contenedor_peletero");
      }
      //  Armadura de draco de fuego    CA3
      else if(iDracoFuego == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de fuego...",
          "cu_fuego", "*¡Has logrado fabricar una armadura de cuero de draco de fuego!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de hielo   CA3
      else if(iDracoHielo == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de hielo...",
          "cu_hielo", "*¡Has logrado fabricar una armadura de cuero de draco de hielo!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de acido   CA3
      else if(iDracoAcido == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de acido...",
          "cu_acido", "*¡Has logrado fabricar una armadura de cuero de draco de acido!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de rayo   CA3
      else if(iDracoRayo == 3 && iTachonReforzado >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de rayo...",
          "cu_rayo", "*¡Has logrado fabricar una armadura de cuero de draco de rayo!*",
          500, 650, "contenedor_peletero");
      }
      // Armadura de roedor  CA 0
      else if(iRoedor == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de roedor...",
          "cu_roedor0", "*¡Has logrado fabricar una armadura de cuero de roedor!*",
          126, 100, "contenedor_peletero");
      }

      // Armadura de hervivoro CA 0
      else if(iHerbivoro == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de herbivoro...",
          "cu_herbivoro0", "*¡Has logrado fabricar una armadura de cuero de herbivoro!*",
          180, 150, "contenedor_peletero");
      }

      //  Armadura de bestia CA 0
      else if(iBestia == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje...",
          "cu_bestia0", "*¡Has logrado fabricar una armadura de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  Armadura de bestia grandeCA 0
      else if(iBestiaGrande == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje grande...",
          "cu_bestiag0", "*¡Has logrado fabricar una armadura de cuero de bestia salvaje grande!*",
          320, 350, "contenedor_peletero");
      }
      //  Armadura de bestia mitica   CA 0
      else if(iMitica == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica...",
          "cu_mitica0", "*¡Has logrado fabricar una armadura de cuero de bestia mitica!*",
          375, 450, "contenedor_peletero");
      }
      //  Armadura de bestia mitica grande  CA 0
      else if(iMiticaGrande == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica gruesa...",
          "cu_miticag0", "*¡Has logrado fabricar una armadura de cuero de bestia mitica gruesa!*",
          455, 550, "contenedor_peletero");
      }
      //  Armadura de draco de fuego   CA 0
      else if(iDracoFuego == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de fuego...",
          "cu_fuego0", "*¡Has logrado fabricar una armadura de cuero de draco de fuego!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de hielo   CA 0
      else if(iDracoHielo == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de hielo...",
          "cu_hielo0", "*¡Has logrado fabricar una armadura de cuero de draco de hielo!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de acido   CA 0
      else if(iDracoAcido == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de acido...",
          "cu_acido0", "*¡Has logrado fabricar una armadura de cuero de draco de acido!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de rayo  CA 0
      else if(iDracoRayo == 3 && iSeda >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de rayo...",
          "cu_rayo0", "*¡Has logrado fabricar una armadura de cuero de draco de rayo!*",
          500, 650, "contenedor_peletero");
      }
            // Armadura de roedor  CA 1
      else if(iRoedor == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de roedor...",
          "cu_roedor1", "*¡Has logrado fabricar una armadura de cuero de roedor!*",
          126, 100, "contenedor_peletero");
      }

      // Armadura de hervivoro CA 1
      else if(iHerbivoro == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de herbivoro...",
          "cu_herbivoro1", "*¡Has logrado fabricar una armadura de cuero de herbivoro!*",
          180, 150, "contenedor_peletero");
      }

      //  Armadura de bestia CA 1
      else if(iBestia == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje...",
          "cu_bestia1", "*¡Has logrado fabricar una armadura de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  Armadura de bestia grandeCA 1
      else if(iBestiaGrande == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje grande...",
          "cu_bestiag1", "*¡Has logrado fabricar una armadura de cuero de bestia salvaje grande!*",
          320, 350, "contenedor_peletero");
      }
      //  Armadura de bestia mitica   CA 1
      else if(iMitica == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica...",
          "cu_mitica1", "*¡Has logrado fabricar una armadura de cuero de bestia mitica!*",
          375, 450, "contenedor_peletero");
      }
      //  Armadura de bestia mitica grande  CA 1
      else if(iMiticaGrande == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica gruesa...",
          "cu_miticag1", "*¡Has logrado fabricar una armadura de cuero de bestia mitica gruesa!*",
          455, 550, "contenedor_peletero");
      }
      //  Armadura de draco de fuego   CA 1
      else if(iDracoFuego == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de fuego...",
          "cu_fuego1", "*¡Has logrado fabricar una armadura de cuero de draco de fuego!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de hielo   CA 1
      else if(iDracoHielo == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de hielo...",
          "cu_hielo1", "*¡Has logrado fabricar una armadura de cuero de draco de hielo!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de acido   CA 1
      else if(iDracoAcido == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de acido...",
          "cu_acido1", "*¡Has logrado fabricar una armadura de cuero de draco de acido!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de rayo  CA 1
      else if(iDracoRayo == 3 && iCorreas >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de rayo...",
          "cu_rayo1", "*¡Has logrado fabricar una armadura de cuero de draco de rayo!*",
          500, 650, "contenedor_peletero");
      }
        // Armadura de roedor  CA 2
      else if(iRoedor == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de roedor...",
          "cu_roedor2", "*¡Has logrado fabricar una armadura de cuero de roedor!*",
          126, 100, "contenedor_peletero");
      }

      // Armadura de hervivoro CA 2
      else if(iHerbivoro == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de herbivoro...",
          "cu_herbivoro2", "*¡Has logrado fabricar una armadura de cuero de herbivoro!*",
          180, 150, "contenedor_peletero");
      }

      //  Armadura de bestia CA 2
      else if(iBestia == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje...",
          "cu_bestia2", "*¡Has logrado fabricar una armadura de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  Armadura de bestia grandeCA 2
      else if(iBestiaGrande == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia salvaje grande...",
          "cu_bestiag2", "*¡Has logrado fabricar una armadura de cuero de bestia salvaje grande!*",
          320, 350, "contenedor_peletero");
      }
      //  Armadura de bestia mitica   CA 2
      else if(iMitica == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica...",
          "cu_mitica2", "*¡Has logrado fabricar una armadura de cuero de bestia mitica!*",
          375, 450, "contenedor_peletero");
      }
      //  Armadura de bestia mitica grande  CA2
      else if(iMiticaGrande == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de bestia mitica gruesa...",
          "cu_miticag2", "*¡Has logrado fabricar una armadura de cuero de bestia mitica gruesa!*",
          455, 550, "contenedor_peletero");
      }
      //  Armadura de draco de fuego   CA 2
      else if(iDracoFuego == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de fuego...",
          "cu_fuego2", "*¡Has logrado fabricar una armadura de cuero de draco de fuego!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de hielo   CA2
      else if(iDracoHielo == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de hielo...",
          "cu_hielo2", "*¡Has logrado fabricar una armadura de cuero de draco de hielo!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de acido   CA 2
      else if(iDracoAcido == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de acido...",
          "cu_acido2", "*¡Has logrado fabricar una armadura de cuero de draco de acido!*",
          500, 650, "contenedor_peletero");
      }
      //  Armadura de draco de rayo  CA 2
      else if(iDracoRayo == 3 && iTachones >= 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una armadura de cuero de draco de rayo...",
          "cu_rayo2", "*¡Has logrado fabricar una armadura de cuero de draco de rayo!*",
          500, 650, "contenedor_peletero");
      }
  }
else if(sTagMolde == "sapo_plnt12_bota")
  {
      // botas de roedor
      if(iRoedor == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de roedor...",
          "bo_roedor", "*¡Has logrado fabricar una botas de cuero de roedor!*",
          90, 100, "contenedor_peletero");
      }

      // botas de hervivoro
      else if(iHerbivoro == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de herbivoro...",
          "bo_herbivoro", "*¡Has logrado fabricar una botas de cuero de herbivoro!*",
          128, 150, "contenedor_peletero");
      }

      //  botas de bestia
      else if(iBestia == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de bestia salvaje...",
          "bo_bestia", "*¡Has logrado fabricar una botas de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  botas de bestia grande
      else if(iBestiaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de bestia salvaje grande...",
          "bo_bestiag", "*¡Has logrado fabricar una botas de cuero de bestia salvaje grande!*",
          295, 350, "contenedor_peletero");
      }
      //  botas de bestia mitica
      else if(iMitica == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de bestia mitica...",
          "bo_mitica", "*¡Has logrado fabricar una botas de cuero de bestia mitica!*",
          365, 450, "contenedor_peletero");
      }
      //  botas de bestia mitica grande
      else if(iMiticaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de bestia mitica gruesa...",
          "bo_miticag", "*¡Has logrado fabricar una botas de cuero de bestia mitica gruesa!*",
          425, 550, "contenedor_peletero");
      }
      //  botas de draco de fuego
      else if(iDracoFuego == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de draco de fuego...",
          "bo_fuego", "*¡Has logrado fabricar una botas de cuero de draco de fuego!*",
          490, 650, "contenedor_peletero");
      }
      //  botas de draco de hielo
      else if(iDracoHielo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de draco de hielo...",
          "bo_hielo", "*¡Has logrado fabricar una botas de cuero de draco de hielo!*",
          490, 650, "contenedor_peletero");
      }
      //  botas de draco de acido
      else if(iDracoAcido == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de draco de acido...",
          "bo_acido", "*¡Has logrado fabricar una botas de cuero de draco de acido!*",
          490, 650, "contenedor_peletero");
      }
      //  botas de draco de rayo
      else if(iDracoRayo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una botas de cuero de draco de rayo...",
          "bo_rayo", "*¡Has logrado fabricar una botas de cuero de draco de rayo!*",
          490, 650, "contenedor_peletero");
      }
  }
else if(sTagMolde == "sapo_plnt12_capa")
  {
      // capa de roedor
      if(iRoedor == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de roedor...",
          "ca_roedor", "*¡Has logrado fabricar una capa de cuero de roedor!*",
          90, 100, "contenedor_peletero");
      }

      // capa de hervivoro
      else if(iHerbivoro == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de herbivoro...",
          "ca_herbivoro", "*¡Has logrado fabricar una capa de cuero de herbivoro!*",
          128, 150, "contenedor_peletero");
      }

      //  capa de bestia
      else if(iBestia == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de bestia salvaje...",
          "ca_bestia", "*¡Has logrado fabricar una capa de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  capa de bestia grande
      else if(iBestiaGrande == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de bestia salvaje grande...",
          "ca_bestiag", "*¡Has logrado fabricar una capa de cuero de bestia salvaje grande!*",
          295, 350, "contenedor_peletero");
      }
      //  capa de bestia mitica
      else if(iMitica == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de bestia mitica...",
          "ca_mitica", "*¡Has logrado fabricar una capa de cuero de bestia mitica!*",
          365, 450, "contenedor_peletero");
      }
      //  capa de bestia mitica grande
      else if(iMiticaGrande == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de bestia mitica gruesa...",
          "ca_miticag", "*¡Has logrado fabricar una capa de cuero de bestia mitica gruesa!*",
          425, 550, "contenedor_peletero");
      }
      //  capa de draco de fuego
      else if(iDracoFuego == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de draco de fuego...",
          "ca_fuego", "*¡Has logrado fabricar una capa de cuero de draco de fuego!*",
          490, 650, "contenedor_peletero");
      }
      //  capa de draco de hielo
      else if(iDracoHielo == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de draco de hielo...",
          "ca_hielo", "*¡Has logrado fabricar una capa de cuero de draco de hielo!*",
          490, 650, "contenedor_peletero");
      }
      //  capa de draco de acido
      else if(iDracoAcido == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de draco de acido...",
          "ca_acido", "*¡Has logrado fabricar una capa de cuero de draco de acido!*",
          490, 650, "contenedor_peletero");
      }
      //  capa de draco de rayo
      else if(iDracoRayo == 2)
      {
          CrearEquipoPeleteria(oPC, "Fabricando una capa de cuero de draco de rayo...",
          "ca_rayo", "*¡Has logrado fabricar una capa de cuero de draco de rayo!*",
          490, 650, "contenedor_peletero");
      }
  }

else if(sTagMolde == "sapo_plnt12_cint")
  {
      // cinturon de roedor
      if(iRoedor == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de roedor...",
          "ci_roedor", "*¡Has logrado fabricar un cinturon de cuero de roedor!*",
          90, 100, "contenedor_peletero");
      }

      // cinturon de hervivoro
      else if(iHerbivoro == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de herbivoro...",
          "ci_herbivoro", "*¡Has logrado fabricar un cinturon de cuero de herbivoro!*",
          128, 150, "contenedor_peletero");
      }

      //  cinturon de bestia
      else if(iBestia == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de bestia salvaje...",
          "ci_bestia", "*¡Has logrado fabricar un cinturon de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  cinturon de bestia grande
      else if(iBestiaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de bestia salvaje grande...",
          "ci_bestiag", "*¡Has logrado fabricar un cinturon de cuero de bestia salvaje grande!*",
          295, 350, "contenedor_peletero");
      }
      //  cinturon de bestia mitica
      else if(iMitica == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de bestia mitica...",
          "ci_mitica", "*¡Has logrado fabricar un cinturon de cuero de bestia mitica!*",
          365, 450, "contenedor_peletero");
      }
      //  cinturon de bestia mitica grande
      else if(iMiticaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de bestia mitica gruesa...",
          "ci_miticag", "*¡Has logrado fabricar un cinturon de cuero de bestia mitica gruesa!*",
          425, 550, "contenedor_peletero");
      }
      //  cinturon de draco de fuego
      else if(iDracoFuego == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de draco de fuego...",
          "ci_fuego", "*¡Has logrado fabricar un cinturon de cuero de draco de fuego!*",
          490, 650, "contenedor_peletero");
      }
      //  cinturon de draco de hielo
      else if(iDracoHielo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de draco de hielo...",
          "ci_hielo", "*¡Has logrado fabricar un cinturon de cuero de draco de hielo!*",
          490, 650, "contenedor_peletero");
      }
      //  cinturon de draco de acido
      else if(iDracoAcido == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de draco de acido...",
          "ci_acido", "*¡Has logrado fabricar un cinturon de cuero de draco de acido!*",
          490, 650, "contenedor_peletero");
      }
      //  cinturon de draco de rayo
      else if(iDracoRayo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando un cinturon de cuero de draco de rayo...",
          "ci_rayo", "*¡Has logrado fabricar un cinturon de cuero de draco de rayo!*",
          490, 650, "contenedor_peletero");
      }
  }
else if(sTagMolde == "sapo_plnt12_guan")
  {
      // guantes de roedor
      if(iRoedor == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de roedor...",
          "pu_roedor", "*¡Has logrado fabricar unos guantes de cuero de roedor!*",
          90, 100, "contenedor_peletero");
      }

      // guantes de hervivoro
      else if(iHerbivoro == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de herbivoro...",
          "pu_herbivoro", "*¡Has logrado fabricar unos guantes de cuero de herbivoro!*",
          128, 150, "contenedor_peletero");
      }

      //  guantes de bestia
      else if(iBestia == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de bestia salvaje...",
          "pu_bestia", "*¡Has logrado fabricar unos guantes de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  guantes de bestia grande
      else if(iBestiaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de bestia salvaje grande...",
          "pu_bestiag", "*¡Has logrado fabricar unos guantes de cuero de bestia salvaje grande!*",
          295, 350, "contenedor_peletero");
      }
      //  guantes de bestia mitica
      else if(iMitica == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de bestia mitica...",
          "pu_mitica", "*¡Has logrado fabricar unos guantes de cuero de bestia mitica!*",
          365, 450, "contenedor_peletero");
      }
      //  guantes de bestia mitica grande
      else if(iMiticaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de bestia mitica gruesa...",
          "pu_miticag", "*¡Has logrado fabricar unos guantes de cuero de bestia mitica gruesa!*",
          425, 550, "contenedor_peletero");
      }
      //  guantes de draco de fuego
      else if(iDracoFuego == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de draco de fuego...",
          "pu_fuego", "*¡Has logrado fabricar unos guantes de cuero de draco de fuego!*",
          490, 650, "contenedor_peletero");
      }
      //  guantes de draco de hielo
      else if(iDracoHielo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de draco de hielo...",
          "pu_hielo", "*¡Has logrado fabricar unos guantes de cuero de draco de hielo!*",
          490, 650, "contenedor_peletero");
      }
      //  guantes de draco de acido
      else if(iDracoAcido == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de draco de acido...",
          "pu_acido", "*¡Has logrado fabricar unos guantes de cuero de draco de acido!*",
          490, 650, "contenedor_peletero");
      }
      //  guantes de draco de rayo
      else if(iDracoRayo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos guantes de cuero de draco de rayo...",
          "pu_rayo", "*¡Has logrado fabricar unos guantes de cuero de draco de rayo!*",
          490, 650, "contenedor_peletero");
      }
      else
      {
          FloatingTextStringOnCreature("*Esta combinación de plantilla y cuero(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }
else if(sTagMolde == "sapo_plnt12_bra")
  {
      // brazales de roedor
      if(iRoedor == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de roedor...",
          "gu_roedor", "*¡Has logrado fabricar unos brazales de cuero de roedor!*",
          90, 100, "contenedor_peletero");
      }

      // brazales de hervivoro
      else if(iHerbivoro == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de herbivoro...",
          "gu_herbivoro", "*¡Has logrado fabricar unos brazales de cuero de herbivoro!*",
          128, 150, "contenedor_peletero");
      }

      //  brazales de bestia
      else if(iBestia == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de bestia salvaje...",
          "gu_bestia", "*¡Has logrado fabricar unos brazales de cuero de besrtia salvaje!*",
          235, 250, "contenedor_peletero");
      }

      //  brazales de bestia grande
      else if(iBestiaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de bestia salvaje grande...",
          "gu_bestiag", "*¡Has logrado fabricar unos brazales de cuero de bestia salvaje grande!*",
          295, 350, "contenedor_peletero");
      }
      //  brazales de bestia mitica
      else if(iMitica == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de bestia mitica...",
          "gu_mitica", "*¡Has logrado fabricar unos brazales de cuero de bestia mitica!*",
          365, 450, "contenedor_peletero");
      }
      //  brazales de bestia mitica grande
      else if(iMiticaGrande == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de bestia mitica gruesa...",
          "gu_miticag", "*¡Has logrado fabricar unos brazales de cuero de bestia mitica gruesa!*",
          425, 550, "contenedor_peletero");
      }
      //  brazales de draco de fuego
      else if(iDracoFuego == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de draco de fuego...",
          "gu_fuego", "*¡Has logrado fabricar unos brazales de cuero de draco de fuego!*",
          490, 650, "contenedor_peletero");
      }
      //  brazales de draco de hielo
      else if(iDracoHielo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de draco de hielo...",
          "gu_hielo", "*¡Has logrado fabricar unos brazales de cuero de draco de hielo!*",
          490, 650, "contenedor_peletero");
      }
      //  brazales de draco de acido
      else if(iDracoAcido == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de draco de acido...",
          "gu_acido", "*¡Has logrado fabricar unos brazales de cuero de draco de acido!*",
          490, 650, "contenedor_peletero");
      }
      //  brazales de draco de rayo
      else if(iDracoRayo == 1)
      {
          CrearEquipoPeleteria(oPC, "Fabricando unos brazales de cuero de draco de rayo...",
          "gu_rayo", "*¡Has logrado fabricar unos brazales de cuero de draco de rayo!*",
          490, 650, "contenedor_peletero");
      }
      else
      {
          FloatingTextStringOnCreature("*Esta combinación de plantilla y cuero(s) no crea nada*", oPC, FALSE);
          EliminarVariablesYunque();
          return;
      }
  }
  // No hay molde?
  else
  {
      FloatingTextStringOnCreature("ERROR: Este mensaje no debería salir nunca, por favor informa a Darth sobre esto", oPC, FALSE);
      EliminarVariablesYunque();
      return;
  }

}

