// 1. Minusculo (Fine, 21)
// 2. Diminuto (Diminutive, 20)
// 3. Menudo (Tiny, 1)
// 4. Pequenyo (Small, 2)
// 5. Mediano (Medium, 3)
// 6. Grande (Large, 4)
// 7. Enorme (Huge, 5)
// 8. Gargantuesco (Gargantuesco, 22)
// 9. Colosal (Colosal, 23)
int VerSiEsTamanyoValido(object oEjecutador, object oObjetivo)
{
  int iTamanyoEjecutador = GetCreatureSize(oEjecutador);
  int iTamanyoObjetivo   = GetCreatureSize(oObjetivo);

  if(iTamanyoEjecutador == 21) // 1. Minusculo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 20) // 2. Diminuto
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 1) // 3. Menudo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 2) // 4. Pequenyo
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 3) // 5. Mediano
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 4) // 6. Grande
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4 || iTamanyoObjetivo == 5) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 5) // 7. Enorme
  {
      if(iTamanyoObjetivo == 21 || iTamanyoObjetivo == 20 || iTamanyoObjetivo == 1 || iTamanyoObjetivo == 2 || iTamanyoObjetivo == 3 || iTamanyoObjetivo == 4 || iTamanyoObjetivo == 5 || iTamanyoObjetivo == 22) return TRUE;
      else return FALSE;
  }
  if(iTamanyoEjecutador == 22 || iTamanyoEjecutador == 23) return TRUE; // 8. Gargantuesco y 9. Colosal

  else return FALSE;
}

void AtaqueOportunidad(object oO)
{
  FloatingTextStringOnCreature("<c´þd>¡Ataque de oportunidad!</c>", oO);
  ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectModifyAttacks(1), oO, 9.0);
}

int BonoTamanyoArma(object oCriaturaConArma, object oArma)
{
  int iBonoTamanyoArma = 0;

  int iTamanyoArmaEquipada = StringToInt(Get2DAString("baseitems", "WeaponSize", GetBaseItemType(oArma))); // 1 = tiny; 2 = small; 3 = medium; 4 = large.
  int iTamanyoJugador = GetCreatureSize(oCriaturaConArma);  // 1 = tiny; 2 = small; 3 = medium; 4 = large.
  if((iTamanyoJugador == 1 && iTamanyoArmaEquipada >= 2) ||
     (iTamanyoJugador == 2 && iTamanyoArmaEquipada >= 3) ||
     (iTamanyoJugador == 3 && iTamanyoArmaEquipada >= 4)) iBonoTamanyoArma += 4;
  else if((iTamanyoJugador == 4 && iTamanyoArmaEquipada <= 3) ||
          (iTamanyoJugador == 3 && iTamanyoArmaEquipada <= 2) ||
          (iTamanyoJugador == 2 && iTamanyoArmaEquipada <= 1)) iBonoTamanyoArma -= 4;

  return iBonoTamanyoArma;
}

int BonoTiradaAtaque(object oCriatura)
{
  int iNivelCriatura = GetHitDice(oCriatura);

  if(iNivelCriatura <= 3) return 1;
  else if(iNivelCriatura <= 6) return 1;
  else if(iNivelCriatura <= 9) return 2;
  else if(iNivelCriatura <= 12) return 3;
  else if(iNivelCriatura <= 15) return 4;
  else if(iNivelCriatura <= 18) return 5;
  else if(iNivelCriatura <= 21) return 6;
  else if(iNivelCriatura <= 25) return 7;
  else if(iNivelCriatura <= 30) return 8;
  else return 9;
}

int AtaqueCriatura(object oCriatura, object oArmaCriatura)
{
  int iCaracteristica;
  if(GetWeaponRanged(oArmaCriatura))
  {
      if(GetHasFeat(FEAT_ZEN_ARCHERY, oCriatura))
      {
          int iDes = GetAbilityModifier(ABILITY_DEXTERITY, oCriatura);
          int iSab = GetAbilityModifier(ABILITY_WISDOM, oCriatura);

          if(iSab > iDes) iCaracteristica = ABILITY_WISDOM;
          else iCaracteristica = ABILITY_DEXTERITY;
      }
      else iCaracteristica = ABILITY_DEXTERITY;
  }
  else
  {
      if(GetHasFeat(FEAT_WEAPON_FINESSE, oCriatura) && BonoTamanyoArma(oCriatura, oArmaCriatura) < 0) iCaracteristica = ABILITY_DEXTERITY;
      else iCaracteristica = ABILITY_STRENGTH;
  }

  int iBonosMalusConjuros = 0;
  if(GetHasSpellEffect(898, oCriatura)) // Ataque poderoso
  {
      int iAtaquePoderoso = GetLocalInt(oCriatura, "DOTE_AP_AJUSTE");
      if(iAtaquePoderoso == 0) iAtaquePoderoso == GetBaseAttackBonus(oCriatura) / 2;
      if(iAtaquePoderoso > 20) iAtaquePoderoso = 20;
      else if(iAtaquePoderoso < 1) iAtaquePoderoso = 1;
      iBonosMalusConjuros -= iAtaquePoderoso;
  }
  if(GetHasSpellEffect(885, oCriatura)) iBonosMalusConjuros += 2; // Carga
  if(GetHasSpellEffect(884, oCriatura)) iBonosMalusConjuros -= 20;// Defensa total
  if(GetHasSpellEffect(912, oCriatura)) iBonosMalusConjuros -= 2; // Disparo localizado
  if(GetHasSpellEffect(901, oCriatura) || GetHasSpellEffect(904, oCriatura)) // Pericia
  {
      int iPericia = GetLocalInt(oCriatura, "DOTE_PERICIA_AJUSTE");
      if(iPericia == 0) iPericia = GetBaseAttackBonus(oCriatura) / 2;
      if(iPericia > 20) iPericia = 20;
      else if(iPericia < 1) iPericia = 1;
      iBonosMalusConjuros -= iPericia;
  }
  if(GetHasSpellEffect(895, oCriatura)) iBonosMalusConjuros += 2; // Prestar ayuda (ataque)

  int iAtaque = GetBaseAttackBonus(oCriatura) + GetAbilityModifier(iCaracteristica, oCriatura) + d20() + BonoTiradaAtaque(oCriatura) + iBonosMalusConjuros;

  return iAtaque;
}

int BonoTamanyoCriatura(object oCriatura1, object oCriatura2)
{
  int iTamanyoCriatura1 = GetCreatureSize(oCriatura1);
  int iTamanyoCriatura2 = GetCreatureSize(oCriatura2);

  if(iTamanyoCriatura2 == 21) // 1. Minusculo
  {
      if(iTamanyoCriatura1 == 20) return 4;
      else if(iTamanyoCriatura1 == 1) return 8;
      else if(iTamanyoCriatura1 == 2) return 12;
      else if(iTamanyoCriatura1 == 3) return 16;
      else if(iTamanyoCriatura1 == 4) return 20;
      else if(iTamanyoCriatura1 == 5) return 24;
      else if(iTamanyoCriatura1 == 22) return 28;
      else if(iTamanyoCriatura1 == 23) return 32;
  }
  if(iTamanyoCriatura2 == 20) // 2. Diminuto
  {
      if(iTamanyoCriatura1 == 1) return 4;
      else if(iTamanyoCriatura1 == 2) return 8;
      else if(iTamanyoCriatura1 == 3) return 12;
      else if(iTamanyoCriatura1 == 4) return 16;
      else if(iTamanyoCriatura1 == 5) return 20;
      else if(iTamanyoCriatura1 == 22) return 24;
      else if(iTamanyoCriatura1 == 23) return 28;
  }
  if(iTamanyoCriatura2 == 1) // 3. Menudo
  {
      if(iTamanyoCriatura1 == 2) return 4;
      else if(iTamanyoCriatura1 == 3) return 8;
      else if(iTamanyoCriatura1 == 4) return 12;
      else if(iTamanyoCriatura1 == 5) return 16;
      else if(iTamanyoCriatura1 == 22) return 20;
      else if(iTamanyoCriatura1 == 23) return 24;
  }
  if(iTamanyoCriatura2 == 2) // 4. Pequenyo
  {
      if(iTamanyoCriatura1 == 3) return 4;
      else if(iTamanyoCriatura1 == 4) return 8;
      else if(iTamanyoCriatura1 == 5) return 12;
      else if(iTamanyoCriatura1 == 22) return 16;
      else if(iTamanyoCriatura1 == 23) return 20;
  }
  if(iTamanyoCriatura2 == 3) // 5. Mediano
  {
      if(iTamanyoCriatura1 == 4) return 4;
      else if(iTamanyoCriatura1 == 5) return 8;
      else if(iTamanyoCriatura1 == 22) return 12;
      else if(iTamanyoCriatura1 == 23) return 16;
  }
  if(iTamanyoCriatura2 == 4) // 6. Grande
  {
      if(iTamanyoCriatura1 == 5) return 4;
      else if(iTamanyoCriatura1 == 22) return 8;
      else if(iTamanyoCriatura1 == 23) return 12;
  }
  if(iTamanyoCriatura2 == 5) // 7. Enorme
  {
      if(iTamanyoCriatura1 == 22) return 4;
      else if(iTamanyoCriatura1 == 23) return 8;
  }
  if(iTamanyoCriatura2 == 22) // 8. Gargantuesco
  {
      if(iTamanyoCriatura1 == 23) return 4;
  }

  return 0;
}

int BonoAtaqueMejoraMasAlto(object oArma)
{
  int iValor = 0;
  itemproperty ipPropiedad = GetFirstItemProperty(oArma);
  while(GetIsItemPropertyValid(ipPropiedad))
  {
      if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_ENHANCEMENT_BONUS ||
         GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_ATTACK_BONUS)
      {
          if(GetItemPropertyCostTableValue(ipPropiedad) > iValor) iValor = GetItemPropertyCostTableValue(ipPropiedad);
      }

      ipPropiedad = GetNextItemProperty(oArma);
  }

  return iValor;
}

int CargaMaxima(object oPC)
{
  int iPeso = GetWeight()/10;
  int iFuerza = GetAbilityScore(oPC, ABILITY_STRENGTH);
  int iCargaMaxima;
  switch(iFuerza)
  {
      case 1: iCargaMaxima =  6; break;
      case 2: iCargaMaxima =  13; break;
      case 3: iCargaMaxima =  20; break;
      case 4: iCargaMaxima =  26; break;
      case 5: iCargaMaxima =  33; break;
      case 6: iCargaMaxima =  60; break;
      case 7: iCargaMaxima =  66; break;
      case 8: iCargaMaxima =  73; break;
      case 9: iCargaMaxima =  80; break;
      case 10: iCargaMaxima = 86; break;
      case 11: iCargaMaxima = 92; break;
      case 12: iCargaMaxima = 100; break;
      case 13: iCargaMaxima = 110; break;
      case 14: iCargaMaxima = 116; break;
      case 15: iCargaMaxima = 133; break;
      case 16: iCargaMaxima = 153; break;
      case 17: iCargaMaxima = 173; break;
      case 18: iCargaMaxima = 200; break;
      case 19: iCargaMaxima = 233; break;
      case 20: iCargaMaxima = 266; break;
      case 21: iCargaMaxima = 306; break;
      case 22: iCargaMaxima = 346; break;
      case 23: iCargaMaxima = 400; break;
      case 24: iCargaMaxima = 466; break;
      case 25: iCargaMaxima = 533; break;
      case 26: iCargaMaxima = 613; break;
      case 27: iCargaMaxima = 693; break;
      case 28: iCargaMaxima = 800; break;
      case 29: iCargaMaxima = 933; break;
      case 30: iCargaMaxima = 1213; break;
      case 31: iCargaMaxima = 1493; break;
      case 32: iCargaMaxima = 1773; break;
      case 33: iCargaMaxima = 2053; break;
      case 34: iCargaMaxima = 2333; break;
      case 35: iCargaMaxima = 2613; break;
      case 36: iCargaMaxima = 2893; break;
      case 37: iCargaMaxima = 3173; break;
      case 38: iCargaMaxima = 3453; break;
      case 39: iCargaMaxima = 3733; break;
      case 40: iCargaMaxima = 4853; break;
      case 41: iCargaMaxima = 5973; break;
      case 42: iCargaMaxima = 7093; break;
      case 43: iCargaMaxima = 8213; break;
      case 44: iCargaMaxima = 9333; break;
      case 45: iCargaMaxima = 10453; break;
      case 46: iCargaMaxima = 11573; break;
      case 47: iCargaMaxima = 12693; break;
      case 48: iCargaMaxima = 13813; break;
      case 49: iCargaMaxima = 14933; break;
      case 50: iCargaMaxima = 16053; break;
      default: iCargaMaxima = 17173; break;
  }

  if(iPeso > iCargaMaxima) return TRUE;

  return FALSE;
}

int GetBonoAtaque(object oCriatura, object oArma, object oTarget);
int GetWeaponSize(object oArma);

int GetBonoAtaque(object oCriatura, object oArma, object oTarget){
    int nAbility = ABILITY_STRENGTH;
    int nDes = GetAbilityModifier(ABILITY_DEXTERITY, oCriatura);
    int bSutileza = FALSE;
    int nBono = GetBaseAttackBonus(oCriatura);

    if(!GetIsObjectValid(oArma)){
        bSutileza = TRUE;
    } else {
        if(GetWeaponSize(oArma) <= 1){
            bSutileza = TRUE;
        }
    }

    if(GetWeaponRanged(oArma)){
        nAbility = ABILITY_DEXTERITY;
        if(GetHasFeat(FEAT_ZEN_ARCHERY, oCriatura)){
            int nSab = GetAbilityModifier(ABILITY_WISDOM, oCriatura);

            if(nSab > nDes) nAbility = ABILITY_WISDOM;
        }
    }

    if(GetHasFeat(FEAT_WEAPON_FINESSE, oCriatura) && bSutileza){
        int nStr = GetAbilityModifier(ABILITY_STRENGTH, oCriatura);

        if(nDes > nStr) nAbility = ABILITY_DEXTERITY;
    }
    nBono += GetAbilityModifier(nAbility, oCriatura);

    if(GetHasSpellEffect(898, oCriatura)){
        //Ataque poderoso.
        int iAtaquePoderoso = GetLocalInt(oCriatura, "DOTE_AP_AJUSTE");
        if(iAtaquePoderoso == 0) iAtaquePoderoso == GetBaseAttackBonus(oCriatura) / 2;
        if(iAtaquePoderoso > 20) iAtaquePoderoso = 20;
        if(iAtaquePoderoso < 1) iAtaquePoderoso = 1;
        nBono -= iAtaquePoderoso;
    }
    if(GetHasSpellEffect(885, oCriatura)) nBono += 2; // Carga
    if(GetHasSpellEffect(884, oCriatura)) nBono -= 20;// Defensa total
    if(GetHasSpellEffect(912, oCriatura)) nBono -= 2; // Disparo localizado
    if(GetHasSpellEffect(901, oCriatura) || GetHasSpellEffect(904, oArma)){
        //Pericia.
        int iPericia = GetLocalInt(oCriatura, "DOTE_PERICIA_AJUSTE");
        if(iPericia == 0) iPericia = GetBaseAttackBonus(oCriatura) / 2;
        if(iPericia > 20) iPericia = 20;
        if(iPericia < 1) iPericia = 1;
        nBono -= iPericia;
    }
    if(GetHasSpellEffect(895, oCriatura)) nBono += 2; // Prestar ayuda (ataque)

    //Variables para el chequeo de las propiedades del arma
    int nValor = 0;
    int nAtaque = 0;
    int nAtAlin = 0;
    int nAtRazi = 0;
    int nAtAlEs = 0;
    int nPenals = 0;
    int nMiAlin = 0;

    // Hace un bucle por todas las propiedades del arma en busca de las de mejora.
    itemproperty iProp = GetFirstItemProperty(oArma);
    while (GetIsItemPropertyValid(iProp)){
        //Obtiene el mejor bonificador de ataque o mejora..
        if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ATTACK_BONUS ||
        GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS){
            if(GetItemPropertyCostTableValue(iProp) > nAtaque){
                nAtaque = GetItemPropertyCostTableValue(iProp);
            }
        }
        //Obtiene el mejor bonificador de ataque o mejora contra el alineamiento
        if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ATTACK_BONUS_VS_ALIGNMENT_GROUP ||
        GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP){
            if(GetItemPropertySubType(iProp) == GetAlignmentGoodEvil(oTarget) ||
            GetItemPropertySubType(iProp) == GetAlignmentLawChaos(oTarget)){
                if(GetItemPropertyCostTableValue(iProp) > nAtAlin){
                    nAtAlin = GetItemPropertyCostTableValue(iProp);
                }
            }
        }
        //Obtiene el mejor bonificador de ataque o mejora contra grupo racial.
        if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ATTACK_BONUS_VS_RACIAL_GROUP ||
        GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_RACIAL_GROUP){
            if(GetItemPropertySubType(iProp) == GetRacialType(oTarget)){
                if(GetItemPropertyCostTableValue(iProp) > nAtRazi){
                    nAtRazi = GetItemPropertyCostTableValue(iProp);
                }
            }
        }
        //Obtiene el mejor bonificador de ataque contra alineamiento especifico.
        if(GetItemPropertyType(iProp) == ITEM_PROPERTY_ATTACK_BONUS_VS_SPECIFIC_ALIGNMENT ||
        GetItemPropertyType(iProp) == ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_SPECIFIC_ALIGNEMENT){
            switch(GetAlignmentLawChaos(oTarget)){
                case ALIGNMENT_LAWFUL:
                    nMiAlin = 0;
                    break;
                case ALIGNMENT_NEUTRAL:
                    nMiAlin = 3;
                    break;
                case ALIGNMENT_CHAOTIC:
                    nMiAlin = 6;
                    break;
            }
            switch(GetAlignmentGoodEvil(oTarget)){
                case ALIGNMENT_GOOD:
                    nMiAlin += 0;
                    break;
                case ALIGNMENT_NEUTRAL:
                    nMiAlin += 1;
                    break;
                case ALIGNMENT_EVIL:
                    nMiAlin += 2;
                    break;
            }
            if(GetItemPropertySubType(iProp) == nMiAlin){
                if(GetItemPropertyCostTableValue(iProp) > nAtAlEs){
                    nAtAlEs = GetItemPropertyCostTableValue(iProp);
                }
            }
        }
        //Obtiene el peor penalizador de ataque y mejora.
        if(GetItemPropertyType(iProp) == ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER ||
        GetItemPropertyType(iProp) == ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER){
            if(GetItemPropertyCostTableValue(iProp) > nPenals){
                nPenals = GetItemPropertyCostTableValue(iProp);
            }
        }
        iProp = GetNextItemProperty(oArma);
    }

    //Aplica el mayor bonificador posible.
    if(nAtaque > nValor) nValor = nAtaque;
    if(nAtAlin > nValor) nValor = nAtAlin;
    if(nAtRazi > nValor) nValor = nAtRazi;
    if(nAtAlEs > nValor) nValor = nAtAlEs;
    //Resta la penalizacion de ataque si es aplicable
    nValor -= nPenals;
    nBono += nValor;
    return nBono;
}

int GetWeaponSize(object oArma){
    int nIdArma = GetBaseItemType(oArma);
    string sId = Get2DAString("baseitems.2da", "WeaponSize", nIdArma);
    int nSize = StringToInt(sId);
    return nSize;
}
