//::///////////////////////////////////////////////
//:: OFICIO DE ARTESANIA URDIMBRICA, ON SPELL CAST
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  3er Oficio de Artesania Urdimbrica.
  Se ejecuta cuando se lanza un conjuro sobre la mesa de
  Artesanía Urdímbrica. Realiza unas pocas comprobaciones y
  escoge un encantamiento segun el conjuro lanzado.
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 16 de Agosto de 2013
//:://////////////////////////////////////////////

#include "pb_ofi_artesa_i"


void main()
{
  object oPC = GetLastSpellCaster();
  int iConjuro = GetLastSpell();

  // Debemos cerrar la mesa antes de encantar
  if(GetIsOpen(OBJECT_SELF) == TRUE) return;

  // Antisaturamiento de la mesa
  if(GetLocalInt(OBJECT_SELF, "ANTI_SPAM") == TRUE) return;

  // Nivel 1 necesario
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion15");
  if(iNivelHabilidad == 0)
  {
      SendMessageToPC(oPC, "<cþ<<>Deberías hablar con algún maestro de Artesanía Urdímbrica antes de usar esto.</c>");
      return;
  }

  // Solo 3ª esfera de conjuros
  if(ConjurosTerceraEsfera(oPC) == FALSE) return;

  // Errores al cerrar la mesa que persisten
  int iErrorEncantamiento = GetLocalInt(OBJECT_SELF, "ERRORENCANTAMIENTO");
  if(iErrorEncantamiento > 0)
  {
      if(iErrorEncantamiento == 1) SendMessageToPC(oPC, "<cþ<<>Debe de haber un único objeto susceptible al encantamiento sobre la mesa.</c>");
      else if(iErrorEncantamiento == 2) SendMessageToPC(oPC, "<cþ<<>No puedes encantar con notas/libros sobre la mesa.</c>");
      else if(iErrorEncantamiento == 3) SendMessageToPC(oPC, "<cþ<<>No puedes encantar más este objeto, ya ha llegado al límite de capacidad de propiedades que admite.</c>");
      return;
  }

  // No se lanza conjuro desde objeto (no funciona, y ahora tampoco yam e interesa)
  /*if(GetIsObjectValid(GetSpellCastItem()) == TRUE)
  {
      SendMessageToPC(oPC, "<cþ<<>Los conjuros de los objetos no son aptos para el encantamiento.</c>");
      return;
  }*/

  // Antisaturamiento de la mesa
  SetLocalInt(OBJECT_SELF, "ANTI_SPAM", TRUE);

  // A ENCANTAR !! -------------------------------------------------------------

  object oObjetoAEncantar = GetLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR");

  // 1. Luz (luz y llama continua)
  if(iConjuro >= 1061 && iConjuro <= 1070) EncantamientoLuz(oPC, oObjetoAEncantar, iConjuro);

  // 2. Bonificador de habilidad  (Amplificar, Claridad, Clarividencia/clariaudiencia, Curar heridas leves) (Mago,hechicero,bardo,clerigo,druida,paladin,explorador)
  else if(iConjuro == SPELL_AMPLIFY || iConjuro == SPELL_CLARITY ||
          iConjuro == SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE || iConjuro == SPELL_CURE_LIGHT_WOUNDS) EncantamientoHabilidad(oPC, oObjetoAEncantar, iConjuro);

  // 3. Limitacion de uso (Proteccion contra el alineamiento)
  else if(iConjuro == 138 || iConjuro == 139) EncantamientoLimitacionUso(oPC, oObjetoAEncantar, iConjuro);

  // 4. Bonificador tiros de salvacion (Resistencia | Auxilio divino, Estómago de hierro, Quitar enfermedad | Ligadura menor de planos, Restablecimiento, Restablecimiento menor)
  else if(iConjuro == SPELL_RESISTANCE) EncantamientoSalvacion(oPC, oObjetoAEncantar, iConjuro, 1);
  else if(iConjuro == SPELL_AID || iConjuro == SPELL_IRONGUTS || iConjuro == SPELL_REMOVE_DISEASE) EncantamientoSalvacion(oPC, oObjetoAEncantar, iConjuro, 2);
  else if(iConjuro == SPELL_LESSER_PLANAR_BINDING || iConjuro == SPELL_RESTORATION || iConjuro == SPELL_LESSER_RESTORATION) EncantamientoSalvacion(oPC, oObjetoAEncantar, iConjuro, 3);

  // 5. Bonificador CA (Armadura de mago, Piel robliza | Huesos de piedra, Santuario | Invisibilidad mejorada, Libertad de movimiento)
  else if(iConjuro == SPELL_MAGE_ARMOR || iConjuro == SPELL_BARKSKIN) EncantamientoCA(oPC, oObjetoAEncantar, iConjuro, 1);
  else if(iConjuro == SPELL_STONE_BONES || iConjuro == SPELL_SANCTUARY) EncantamientoCA(oPC, oObjetoAEncantar, iConjuro, 2);
  else if(iConjuro == SPELL_IMPROVED_INVISIBILITY || iConjuro == SPELL_FREEDOM_OF_MOVEMENT) EncantamientoCA(oPC, oObjetoAEncantar, iConjuro, 3);

  // 6. Bonificador Caracteristica (Fuerza de toro, Gracia felina, Resistencia de oso, Astucia de zorro, Sabiduria de lechuza, Esplendor de aguila)
  else if(iConjuro == SPELL_BULLS_STRENGTH || iConjuro == SPELL_CATS_GRACE  || iConjuro == SPELL_ENDURANCE ||
          iConjuro == SPELL_FOXS_CUNNING   || iConjuro == SPELL_OWLS_WISDOM || iConjuro == SPELL_EAGLE_SPLEDOR) EncantamientoCaracteristica(oPC, oObjetoAEncantar, iConjuro);

  // 7. Regeneracion (Mente en blanco, curar heridas críticas)
  else if(iConjuro == SPELL_MIND_BLANK || iConjuro == SPELL_CURE_CRITICAL_WOUNDS) EncantamientoRegeneracion(oPC, oObjetoAEncantar, iConjuro);

  // 8. Huecos de conjuro (Proyectil magico, Fatalidad, Azote flamígero)
  else if(iConjuro == SPELL_MAGIC_MISSILE || iConjuro == SPELL_DOOM || iConjuro == SPELL_FLAME_LASH) EncantamientoHuecoConjuro(oPC, oObjetoAEncantar, iConjuro);

  // 9. Bonificador  de danyo (Orbes, Luz abrasadora, Disipar magia)
  else if(iConjuro == 1034 || iConjuro == 1035 || iConjuro == 1036 || iConjuro == 1037 || iConjuro == 1038 ||
          iConjuro == SPELL_SEARING_LIGHT || iConjuro == SPELL_DISPEL_MAGIC) EncantamientoDanyo(oPC, oObjetoAEncantar, iConjuro);

  // 10. Resistencia al daño (soportar/resistencia/proteccion a los elementos)
  else if(iConjuro == SPELL_ENDURE_ELEMENTS || iConjuro == SPELL_RESIST_ELEMENTS || iConjuro == SPELL_PROTECTION_FROM_ELEMENTS) EncantamientoResistenciaDanyo(oPC, oObjetoAEncantar, iConjuro);

  // 11. Resistencia a conjuros (Ancla dimensional, Resistente a conjuros)
  else if(iConjuro == 990 || iConjuro == SPELL_SPELL_RESISTANCE) EncantamientoResistenciaConjuros(oPC, oObjetoAEncantar, iConjuro);

  // 12. Reduccion al danyo (Inmovilizar persona, Hechizar persona o animal, Semblante fantasmal)
  else if(iConjuro == SPELL_HOLD_PERSON || iConjuro == SPELL_CHARM_PERSON_OR_ANIMAL || iConjuro == SPELL_GHOSTLY_VISAGE) EncantamientoReduccionDanyo(oPC, oObjetoAEncantar, iConjuro);

  // 13. Inmunidad a conjuros por nivel (Disipación Mayor, Mano interpuesta de Bigby)
  else if(iConjuro == SPELL_GREATER_DISPELLING || iConjuro == SPELL_BIGBYS_INTERPOSING_HAND) EncantamientoInmunidadConjuros(oPC, oObjetoAEncantar, iConjuro);

  // 14. Bonificador de ataque (Circulo magico contra el bien | Hechizar monstruo)
  else if(iConjuro == 105) EncantamientoAtaque(oPC, oObjetoAEncantar, iConjuro, 1);
  else if(iConjuro == SPELL_CHARM_MONSTER) EncantamientoAtaque(oPC, oObjetoAEncantar, iConjuro, 2);

  // 15. Bonificador de mejora (Circulo magico contra el mal | Dominar persona, Infierno)
  else if(iConjuro == 104) EncantamientoMejora(oPC, oObjetoAEncantar, iConjuro, 1);
  else if(iConjuro == SPELL_DOMINATE_PERSON || iConjuro == SPELL_INFERNO) EncantamientoMejora(oPC, oObjetoAEncantar, iConjuro, 2);

  // 16. Regeneracion vampirica (Toque de necrófago, Infligir heridas críticas)
  else if(iConjuro == SPELL_GHOUL_TOUCH || iConjuro == SPELL_INFLICT_CRITICAL_WOUNDS) EncantamientoRegVampirica(oPC, oObjetoAEncantar, iConjuro);

  // 17. Criticos masivos (Incendiar, Rayo de energía negativa, Llamarada)
  else if(iConjuro == SPELL_COMBUST || iConjuro == SPELL_NEGATIVE_ENERGY_RAY || iConjuro == SPELL_FLARE) EncantamientoCriticosMasivos(oPC, oObjetoAEncantar, iConjuro);

  // 18. Efecto al golpear (Veneno, Contagio, Debilidad mental)
  else if(iConjuro == SPELL_POISON || iConjuro == SPELL_CONTAGION || iConjuro == SPELL_FEEBLEMIND) EncantamientoEfectoAlGolpear(oPC, oObjetoAEncantar, iConjuro);

  // 19. Inmunidad al danyo (Piel pétrea, Neutralizar veneno)
  else if(iConjuro == SPELL_STONESKIN || iConjuro == SPELL_NEUTRALIZE_POISON) EncantamientoInmunidadDanyo(oPC, oObjetoAEncantar, iConjuro);

  // 20. Vision en la oscuridad (Ver lo invisible, Visión verdadera, Perspicacia del buho)
  else if(iConjuro == SPELL_SEE_INVISIBILITY || iConjuro == SPELL_TRUE_SEEING || iConjuro == SPELL_OWLS_INSIGHT) EncantamientoVisionOscuridad(oPC, oObjetoAEncantar, iConjuro);

  // 21. Peso reducido (Rayo de debilitamiento, Virtud)
  else if(iConjuro == SPELL_RAY_OF_ENFEEBLEMENT || iConjuro == SPELL_VIRTUE) EncantamientoPesoReducido(oPC, oObjetoAEncantar, iConjuro);

  // 22. Lanzar conjuro (requiere infusionamiento) (Ruptura de conjuro menor, Revivir a los muertos)
  else if(iConjuro == SPELL_LESSER_SPELL_BREACH || iConjuro == SPELL_RAISE_DEAD) EncantamientoLanzarConjuro(oPC, oObjetoAEncantar, iConjuro);

  // 23. Inmunidad conjuro (requiere infusionamiento) (Quitar maldición, Custodia contra la muerte)
  else if(iConjuro == SPELL_REMOVE_CURSE || iConjuro == SPELL_DEATH_WARD) EncantamientoInmunidadConjuro(oPC, oObjetoAEncantar, iConjuro);

  // 24. Municion infinita (Combustion, Zancada arbórea)
  else if(iConjuro == SPELL_COMBUST || iConjuro == 994) EncantamientoMunicionInfinita(oPC, oObjetoAEncantar, iConjuro);

  // 25. Reforzado (Daga de hielo, Espinas arrojadizas)
  else if(iConjuro == SPELL_ICE_DAGGER || iConjuro == SPELL_QUILLFIRE) EncantamientoReforzado(oPC, oObjetoAEncantar, iConjuro);

  else
  {
      SendMessageToPC(oPC, "<cþ<<>No ocurre nada.</c>");
      DeleteLocalInt(OBJECT_SELF, "ANTI_SPAM");
      return;
  }
}
