// Da o quita los conjuros de dominios
void ConjurosDominios(object oPC);

// Devuelve TRUE si el conjuro es de tu dominio
int ConjurosDominiosUOM(object oPC, int iConjuro);

void ConjurosDominios(object oPC)
{
  // 1. DOMINIO FUERZA
  object oDominioFuerza = GetItemPossessedBy(oPC, "dominio_fuerza");
  if(GetHasFeat(FEAT_STRENGTH_DOMAIN_POWER, oPC))
  {
      if(oDominioFuerza == OBJECT_INVALID) CreateItemOnObject("dominio_fuerza", oPC);
  }
  else
  {
      if(oDominioFuerza != OBJECT_INVALID) DestroyObject(oDominioFuerza);
  }

  // 2. DOMINIO GUERRA
  object oDominioGuerra = GetItemPossessedBy(oPC, "dominio_guerra");
  if(GetHasFeat(FEAT_WAR_DOMAIN_POWER, oPC))
  {
      if(oDominioGuerra == OBJECT_INVALID) CreateItemOnObject("dominio_guerra", oPC);
  }
  else
  {
      if(oDominioGuerra != OBJECT_INVALID) DestroyObject(oDominioGuerra);
  }

  // 3. DOMINIO MUERTE
  object oDominioMuerte = GetItemPossessedBy(oPC, "dominio_muerte");
  if(GetHasFeat(FEAT_DEATH_DOMAIN_POWER, oPC))
  {
      if(oDominioMuerte == OBJECT_INVALID) CreateItemOnObject("dominio_muerte", oPC);
  }
  else
  {
      if(oDominioMuerte != OBJECT_INVALID) DestroyObject(oDominioMuerte);
  }

  // 4. DOMINIO PROTECCION
  object oDominioProteccion = GetItemPossessedBy(oPC, "dominio_protec");
  if(GetHasFeat(FEAT_PROTECTION_DOMAIN_POWER, oPC))
  {
      if(oDominioProteccion == OBJECT_INVALID) CreateItemOnObject("dominio_protec", oPC);
  }
  else
  {
      if(oDominioProteccion != OBJECT_INVALID) DestroyObject(oDominioProteccion);
  }

  // 5. DOMINIO SUPERCHERIA
  object oDominioSupercheria = GetItemPossessedBy(oPC, "dominio_superch");
  if(GetHasFeat(FEAT_TRICKERY_DOMAIN_POWER, oPC))
  {
      if(oDominioSupercheria == OBJECT_INVALID) CreateItemOnObject("dominio_superch", oPC);
  }
  else
  {
      if(oDominioSupercheria != OBJECT_INVALID) DestroyObject(oDominioSupercheria);
  }

  // 6. DOMINIO SUERTE
  object oDominioSuerte = GetItemPossessedBy(oPC, "dominio_suerte");
  if(GetHasFeat(1286, oPC))
  {
      if(oDominioSuerte == OBJECT_INVALID) CreateItemOnObject("dominio_suerte", oPC);
  }
  else
  {
      if(oDominioSuerte != OBJECT_INVALID) DestroyObject(oDominioSuerte);
  }

  // 7. DOMINIO GNOMO
  object oDominioGnomo = GetItemPossessedBy(oPC, "dominio_gnomo");
  if(GetHasFeat(1300, oPC))
  {
      if(oDominioGnomo == OBJECT_INVALID) CreateItemOnObject("dominio_gnomo", oPC);
  }
  else
  {
      if(oDominioGnomo != OBJECT_INVALID) DestroyObject(oDominioGnomo);
  }

  // 8. DOMINIO MEDIANO
  object oDominioMediano = GetItemPossessedBy(oPC, "dominio_mediano");
  if(GetHasFeat(1301, oPC))
  {
      if(oDominioMediano == OBJECT_INVALID) CreateItemOnObject("dominio_mediano", oPC);
  }
  else
  {
      if(oDominioMediano != OBJECT_INVALID) DestroyObject(oDominioMediano);
  }

  // 9. DOMINIO ORCO
  object oDominioOrco = GetItemPossessedBy(oPC, "dominio_orco");
  if(GetHasFeat(1302, oPC))
  {
      if(oDominioOrco == OBJECT_INVALID) CreateItemOnObject("dominio_orco", oPC);
  }
  else
  {
      if(oDominioOrco != OBJECT_INVALID) DestroyObject(oDominioOrco);
  }
}

int VerSiEsConjuroDeDominio(object oPC, int iConjuro)
{
  if(GetHasFeat(311, oPC)) // Aire
  {
      if(iConjuro == 75 || iConjuro == 11 || iConjuro == 995 || iConjuro == 14 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(312, oPC)) // Animal
  {
      if(iConjuro == 81 || iConjuro == 13 || iConjuro == 186 || iConjuro == 363 || iConjuro == 130 || iConjuro == 178 || iConjuro == 161) return TRUE;
  }

  if(GetHasFeat(1286, oPC)) // Suerte
  {
      if(iConjuro == 1 || iConjuro == 62 || iConjuro == 458 || iConjuro == 486 || iConjuro == 141 || iConjuro == 73) return TRUE;
  }

  if(GetHasFeat(310, oPC)) // Muerte
  {
      if(iConjuro == 54 || iConjuro == 2 || iConjuro == 38 || iConjuro == 164 || iConjuro == 127 || iConjuro == 52 || iConjuro == 29 || iConjuro == 190) return TRUE;
  }

  if(GetHasFeat(313, oPC)) // Destruccion
  {
      if(iConjuro == 433 || iConjuro == 171 || iConjuro == 1055 || iConjuro == 0 || iConjuro == 56 || iConjuro == 87) return TRUE;
  }

  if(GetHasFeat(314, oPC)) // Tierra
  {
      if(iConjuro == 172 || iConjuro == 369 || iConjuro == 74 || iConjuro == 426 || iConjuro == 996 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(315, oPC)) // Mal
  {
     if(iConjuro == 371 || iConjuro == 370 || iConjuro == 52 || iConjuro == 30 || iConjuro == 56 || iConjuro == 178) return TRUE;
  }

  if(GetHasFeat(316, oPC)) // Fuego
  {
     if(iConjuro == 10 || iConjuro == 137 || iConjuro == 191 || iConjuro == 369 || iConjuro == 57 || iConjuro == 89 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(317, oPC)) // Bien
  {
     if(iConjuro == 1 || iConjuro == 95 || iConjuro == 172 || iConjuro == 96 || iConjuro == 82 || iConjuro == 323 || iConjuro == 178) return TRUE;
  }

  if(GetHasFeat(318, oPC)) // Curacion
  {
     if(iConjuro == 34 || iConjuro == 35 || iConjuro == 31 || iConjuro == 79 || iConjuro == 70 || iConjuro == 114) return TRUE;
  }

  if(GetHasFeat(319, oPC)) // Saber
  {
     if(iConjuro == 86 || iConjuro == 93 || iConjuro == 20 || iConjuro == 186 || iConjuro == 376 || iConjuro == 134) return TRUE;
  }

  if(GetHasFeat(1288, oPC) || GetHasFeat(1287, oPC)) // Ley o Caos
  {
     if(iConjuro == 322 || iConjuro == 76 || iConjuro == 82 || iConjuro == 67 || iConjuro == 323 || iConjuro == 178) return TRUE;
  }

  if(GetHasFeat(320, oPC)) // Magia
  {
     if(iConjuro == 102 || iConjuro == 115 || iConjuro == 370 || iConjuro == 172 || iConjuro == 368 || iConjuro == 141 || iConjuro == 122) return TRUE;
  }

  if(GetHasFeat(321, oPC)) // Vegetal
  {
     if(iConjuro == 53 || iConjuro == 3 || iConjuro == 454 || iConjuro == 364 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(308, oPC)) // Proteccion
  {
     if(iConjuro == 150 || iConjuro == 137 || iConjuro == 119 || iConjuro == 369 || iConjuro == 117) return TRUE;
  }

  if(GetHasFeat(307, oPC)) // Fuerza
  {
     if(iConjuro == 9 || iConjuro == 42 || iConjuro == 119 || iConjuro == 172 || iConjuro == 461 || iConjuro == 462 || iConjuro == 463) return TRUE;
  }

  if(GetHasFeat(322, oPC)) // Solar
  {
     if(iConjuro == 150 || iConjuro == 156 || iConjuro == 47 || iConjuro == 61 || iConjuro == 183 || iConjuro == 427) return TRUE;
  }

  if(GetHasFeat(323, oPC)) // Viaje
  {
     if(iConjuro == 53 || iConjuro == 192 || iConjuro == 995 || iConjuro == 1129 || iConjuro == 991 || iConjuro == 992 || iConjuro == 1060) return TRUE;
  }

  if(GetHasFeat(324, oPC)) // Supercheria
  {
     if(iConjuro == 1139 || iConjuro == 90 || iConjuro == 92 || iConjuro == 26 || iConjuro == 88 || iConjuro == 185) return TRUE;
  }

  if(GetHasFeat(306, oPC)) // Guerra
  {
     if(iConjuro == 13 || iConjuro == 42 || iConjuro == 61 || iConjuro == 5 || iConjuro == 372 || iConjuro == 132 || iConjuro == 131) return TRUE;
  }

  if(GetHasFeat(325, oPC)) // Agua
  {
     if(iConjuro == 129 || iConjuro == 368 || iConjuro == 25 || iConjuro == 0 || iConjuro == 367 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(1298, oPC)) // Enano
  {
     if(iConjuro == 49 || iConjuro == 549 || iConjuro == 545 || iConjuro == 172 || iConjuro == 141 || iConjuro == 48) return TRUE;
  }

  if(GetHasFeat(1299, oPC)) // Elfico
  {
     if(iConjuro == 415 || iConjuro == 13 || iConjuro == 1108 || iConjuro == 994 || iConjuro == 124 || iConjuro == 427) return TRUE;
  }

  if(GetHasFeat(1300, oPC)) // Gnomo
  {
     if(iConjuro == 24 || iConjuro == 90 || iConjuro == 92 || iConjuro == 88 || iConjuro == 110 || iConjuro == 178) return TRUE;
  }

  if(GetHasFeat(1301, oPC)) // Mediano
  {
     if(iConjuro == 13 || iConjuro == 62 || iConjuro == 1129 || iConjuro == 993 || iConjuro == 426 || iConjuro == 134) return TRUE;
  }

  if(GetHasFeat(1302, oPC)) // Orco
  {
     if(iConjuro == 54 || iConjuro == 133 || iConjuro == 42 || iConjuro == 23 || iConjuro == 132 || iConjuro == 131) return TRUE;
  }

  return FALSE;
}
