#include "sapo_constantes"


int TotalMaterialEnInventario(object oUbicado, int iSaltarHerramientas=TRUE) {

    object oObjeto;
    int iTotalMaterial=0;
    int iEsHerramienta;

    oObjeto=GetFirstItemInInventory(oUbicado);
    while(oObjeto!=OBJECT_INVALID) {
        iEsHerramienta=GetLocalInt(oObjeto,"Herramienta");
        if (iEsHerramienta!=1 || iSaltarHerramientas==FALSE) iTotalMaterial++;
        oObjeto=GetNextItemInInventory(oUbicado);
    }

    return iTotalMaterial;

}


int TotalMaterialEnInventarioSegunNombre(object oUbicado, string sNombre, int iSaltarHerramientas=TRUE) {

    object oObjeto;
    int iTotalMaterial=0;
    int iEsHerramienta;

    oObjeto=GetFirstItemInInventory(oUbicado);
    while(oObjeto!=OBJECT_INVALID) {
        iEsHerramienta=GetLocalInt(oObjeto,"Herramienta");
        if (iEsHerramienta!=1 || iSaltarHerramientas==FALSE) {
            if(GetTag(oObjeto)==sNombre || GetResRef(oObjeto)==sNombre) iTotalMaterial++;
        }
        oObjeto=GetNextItemInInventory(oUbicado);
    }

    return iTotalMaterial;

}

void BorrarVariablesParaScript_sapo_rect_gen(object oUbicado) {

    int x=1;
    string sTmp=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
    while (sTmp!="") {
        DeleteLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
        DeleteLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x));
        DeleteLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x));
        x++;
        sTmp=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
    }

    DeleteLocalInt(oUbicado,"fnRetorno" + IntToString(x));

}

void MostrarPistas(object oProcesado, int iBorrarPistas = TRUE) {

    if (DEBUG_FRACASO) SpeakString("----Entrando en MostrarPistas----");
    int x=1;
    string sPista=GetLocalString(oProcesado,"Pista" + IntToString(x));
    if (DEBUG_FRACASO) SpeakString("Primera pista: " + sPista);
    while(sPista!="") {
        SpeakString(sPista);
        if (iBorrarPistas==TRUE) DeleteLocalString(oProcesado,"Pista" + IntToString(x));
        x++;
        sPista=GetLocalString(oProcesado,"Pista" + IntToString(x));
    }
    if (DEBUG_FRACASO) SpeakString("----Saliendo de MostrarPistas----");
}

void BorrarPistas(object oProcesado) {

    if (DEBUG_FRACASO) SpeakString("----Entrando en BorrarPistas----");
    int x=1;
    string sPista=GetLocalString(oProcesado,"Pista" + IntToString(x));
    while(sPista!="") {
        DeleteLocalString(oProcesado,"Pista" + IntToString(x));
        x++;
        sPista=GetLocalString(oProcesado,"Pista" + IntToString(x));
    }
    if (DEBUG_FRACASO) SpeakString("----Saliendo de BorrarPistas----");

}

//int GetHasEffect(object oObjeto, int iEfectoComprobar) {
//int GetHasEffect( int iEfectoComprobar,object oObjeto) {
//    effect eEfecto = GetFirstEffect(oObjeto);
//    int iEfecto=0;
//    while(GetIsEffectValid(eEfecto))
//   {
//        iEfecto = GetEffectType(eEfecto);
//        if(iEfecto == iEfectoComprobar) return TRUE;
//        eEfecto = GetNextEffect(GetFirstPC());
//   }
//
//    return FALSE;
//
//}

int GetItemLevelRequirementByCost(int nCost)

{ if( nCost == 0)             return 0;
  if( nCost <= 2400000)
  { if( nCost <= 65000)
    { if( nCost <= 15000)
      { if( nCost <= 5000)
        { if( nCost <= 1000)  return 1;
          if( nCost <= 1500)  return 2;
          if( nCost <= 2500)  return 3;
          if( nCost <= 3500)  return 4;
          else                return 5;
        }
        if( nCost <= 6500)    return 6;
        if( nCost <= 9000)    return 7;
        if( nCost <= 12000)   return 8;
        else                  return 9;
      }
      if( nCost <= 35000)
      { if( nCost <= 19500)   return 10;
        if( nCost <= 25000)   return 11;
        if( nCost <= 30000)   return 12;
        else                  return 13;
      }
      if( nCost <= 40000)     return 14;
      if( nCost <= 50000)     return 15;
      else                    return 16;
    }
    if( nCost <= 1000000)
    { if( nCost <= 130000)
      { if( nCost <= 75000)   return 17;
        if( nCost <= 90000)   return 18;
        if( nCost <= 110000)  return 19;
        else                  return 20;
      }
      if( nCost <= 250000)    return 21;
      if( nCost <= 500000)    return 22;
      if( nCost <= 750000)    return 23;
      else                    return 24;
    }
    if( nCost <= 1600000)     return 27;
    { if( nCost <= 1000000)   return 24;
      if( nCost <= 1200000)   return 25;
      if( nCost <= 1400000)   return 26;
      else                    return 27;
    }
    if( nCost <= 1800000)     return 28;
    if( nCost <= 2000000)     return 29;
    if( nCost <= 2200000)     return 30;
    else                      return 31;
  }
  if( nCost <= 5400000)
  { if( nCost <= 4000000)
    { if( nCost <= 3200000)
      { if( nCost <= 2600000) return 32;
        if( nCost <= 2800000) return 33;
        if( nCost <= 3000000) return 34;
        else                  return 35;
      }
      if( nCost <= 3400000)   return 36;
      if( nCost <= 3600000)   return 37;
      if( nCost <= 3800000)   return 38;
      else                    return 39;
    }
    if( nCost <= 4800000)
    { if( nCost <= 4200000)   return 40;
      if( nCost <= 4400000)   return 41;
      if( nCost <= 4600000)   return 42;
      else                    return 43;
    }
    if( nCost <= 5000000)     return 44;
    if( nCost <= 5200000)     return 45;
    else                      return 46;
  }
  if( nCost <= 7000000)
  { if( nCost <= 6200000)
    { if( nCost <= 5600000)   return 47;
      if( nCost <= 5800000)   return 48;
      if( nCost <= 6000000)   return 49;
      else                    return 50;
    }
    if( nCost <= 6400000)     return 51;
    if( nCost <= 6600000)     return 52;
    if( nCost <= 6800000)     return 53;
    else                      return 54;
  }
  if( nCost <= 7800000)
  { if( nCost <= 7200000)     return 55;
    if( nCost <= 7400000)     return 56;
    if( nCost <= 7600000)     return 57;
    else                      return 58;
  }
  if( nCost <= 8000000)       return 59;
  if( nCost <= 8200000)       return 60;
  return 61;
}

object PlantillaDesdeContenedor(string sContenedor, string sObjetoCrear) {

    object oContenedor = GetObjectByTag(sContenedor);
    object oObjeto = GetFirstItemInInventory(oContenedor);
    while(oObjeto != OBJECT_INVALID)
    {
        if(GetTag(oObjeto) == sObjetoCrear || GetResRef(oObjeto) == sObjetoCrear) {
            if(DEBUG) SpeakString("Objeto plantilla encontrado: " + GetName(oObjeto));
            return oObjeto;
        }
        oObjeto = GetNextItemInInventory(oContenedor);
    }
    return OBJECT_INVALID;
}

object ObjetoEnInventario(object oContenedor, string sObjeto) {

    if(DEBUG) SpeakString("Buscando " + sObjeto + " en "  + GetName(oContenedor));
    object oObjeto = GetFirstItemInInventory(oContenedor);
    while(oObjeto != OBJECT_INVALID)
    {
        if(DEBUG) SpeakString("Comparando " + GetName(oObjeto) + " con ResRef " + GetResRef(oObjeto) + " y Tag " + GetTag(oObjeto) + " con " + sObjeto  );
        if(GetTag(oObjeto) == sObjeto || GetResRef(oObjeto) == sObjeto) {
            if(DEBUG) SpeakString("Objeto plantilla encontrado: " + GetName(oObjeto));
            return oObjeto;
        }
        oObjeto = GetNextItemInInventory(oContenedor);
    }
    if(DEBUG) SpeakString("No se encontro");
    return OBJECT_INVALID;
}

int NivelParaUsoPorObjeto(object oObjeto) {

    SetIdentified(oObjeto,TRUE);
    int iValorOro=GetGoldPieceValue(oObjeto);
    int iNivel=GetItemLevelRequirementByCost(iValorOro);
    return iNivel;

}

int NivelParaUsoPorTagYContenedor(string sObjeto, string sContenedor) {

    object oPlantilla=PlantillaDesdeContenedor(sContenedor, sObjeto);
    return NivelParaUsoPorObjeto(oPlantilla);

}

int NivelParaUsoPorResRef(string sResRef) {

    object oContenedor = GetObjectByTag(SAPO_CONTENEDOR_CREAR);
    object oPlantilla=CreateItemOnObject(sResRef, oContenedor);
    int iDificultad = NivelParaUsoPorObjeto(oPlantilla);
    DestroyObject(oPlantilla);
    return iDificultad;

}

int DificultadPorObjeto(object oObjeto) {

    int iNivel=NivelParaUsoPorObjeto(oObjeto);
    return iNivel*34;

}

int DificultadPorTagYContenedor(string sObjeto, string sContenedor) {

    object oPlantilla=PlantillaDesdeContenedor(sContenedor, sObjeto);
    return DificultadPorObjeto(oPlantilla);

}

int DificultadPorResRef(string sResRef) {

    object oContenedor = GetObjectByTag(SAPO_CONTENEDOR_CREAR);
    object oPlantilla=CreateItemOnObject(sResRef, oContenedor);
    int iDificultad = DificultadPorObjeto(oPlantilla);
    DestroyObject(oPlantilla);
    return iDificultad;

}

int ValorOroPorObjeto(object oObjeto) {

    SetIdentified(oObjeto,TRUE);
    float fValorOro=IntToFloat(GetGoldPieceValue(oObjeto));
    fValorOro=sqrt(sqrt(fValorOro));
    fValorOro=pow(fValorOro,3.0);
    return FloatToInt(fValorOro);

}

int ValorOroPorTagYContenedor(string sObjeto, string sContenedor) {

    object oPlantilla=PlantillaDesdeContenedor(sContenedor, sObjeto);
    return ValorOroPorObjeto(oPlantilla);

}

int ValorOroPorResRef(string sResRef) {

    object oContenedor = GetObjectByTag(SAPO_CONTENEDOR_CREAR);
    object oPlantilla=CreateItemOnObject(sResRef, oContenedor);
    int iValorOro = ValorOroPorObjeto(oPlantilla);
    DestroyObject(oPlantilla);
    return iValorOro;

}


int DevolverValorSegunDado(string sTipo) {

    int iPosOperador=FindSubString(sTipo,"+");
    if (iPosOperador!=-1) {
        string sParte1=GetStringLeft(sTipo,iPosOperador);
        string sParte2=GetStringRight(sTipo, GetStringLength(sTipo) - iPosOperador - 1);
        if (DEBUG) SpeakString("Inicializando por formula. iPosOperador=" + IntToString(iPosOperador) + " Parte 1: " + sParte1 + " parte 2: " + sParte2);
        return DevolverValorSegunDado(sParte1) + DevolverValorSegunDado(sParte2);
    }

//Aqui no llega si encuentra operador
    int iPosLetra_d=FindSubString(sTipo,"d");
    if (iPosLetra_d == -1) return StringToInt(sTipo);

    int iPosParentesis1=FindSubString(sTipo,"(");
    int iPosParentesis2=FindSubString(sTipo,")");

    int iNumDados;
    string sFuncion;
    if ( (iPosParentesis1 == -1) || (iPosParentesis1+1 == iPosParentesis2) ) {
        iNumDados=1;
        if (iPosParentesis1 == -1) sFuncion=sTipo;
        else sFuncion=GetStringLeft(sTipo,iPosParentesis1);
    } else {
        iNumDados=StringToInt(GetSubString(sTipo,iPosParentesis1+1,iPosParentesis2-iPosParentesis1-1));
        sFuncion=GetStringLeft(sTipo,iPosParentesis1);
    }

    if (sFuncion=="d10") return d10(iNumDados);
    if (sFuncion=="d100") return d100(iNumDados);
    if (sFuncion=="d12") return d12(iNumDados);
    if (sFuncion=="d2") return d2(iNumDados);
    if (sFuncion=="d20") return d20(iNumDados);
    if (sFuncion=="d3") return d3(iNumDados);
    if (sFuncion=="d4") return d4(iNumDados);
    if (sFuncion=="d6") return d6(iNumDados);
    if (sFuncion=="d8") return d8(iNumDados);


    return 0;
}



void BorrarInventario(object oProcesado) {

    if (GetIsPC(oProcesado)==TRUE) {
        SendMessageToPC(oProcesado, "------ERROR GRAVE!!!!!!------");
        SendMessageToPC(oProcesado, "------INTENTO DE BORRAR INVENTARIO DE PJ!!!!!!!!!------");
        return;
    }

    if (GetHasInventory(oProcesado)==FALSE) return;

    object oBorrado = GetFirstItemInInventory(oProcesado);
    while(GetIsObjectValid(oBorrado))
    {
        if (DEBUG_BORRAR_INVENTARIO) SpeakString("Comprobando para destruir " + GetName(oBorrado));
        if(GetLocalInt(oBorrado,"Herramienta")!=1) {
            if (DEBUG_BORRAR_INVENTARIO) SpeakString("Destruyendo " + GetName(oBorrado));
            DestroyObject(oBorrado);
        }
        oBorrado = GetNextItemInInventory(oProcesado);
    }

}

int BonoRealCaracteristicaPJ(int iCaracteristica, object oPJ) {

    int iCaracteristicaReal= GetAbilityScore(oPJ, iCaracteristica, TRUE);
    int iBonoReal= ((iCaracteristicaReal-10)/2);
    return iBonoReal;

}

//int GetCharacterLevel(object oCriatura) {
//
//    return GetLevelByPosition(1,oCriatura) + GetLevelByPosition(2,oCriatura) + GetLevelByPosition(3,oCriatura);
//
//}

int NivelConjuro(int iConjuro) {

    return StringToInt(Get2DAString("spells","Innate",iConjuro));

}

int EscuelaConjuro(int iConjuro) {

    string sEscuela=Get2DAString("spells","School",iConjuro);
    if(sEscuela=="A") return SPELL_SCHOOL_ABJURATION;
    if(sEscuela=="C") return SPELL_SCHOOL_CONJURATION;
    if(sEscuela=="D") return SPELL_SCHOOL_DIVINATION;
    if(sEscuela=="E") return SPELL_SCHOOL_ENCHANTMENT;
    if(sEscuela=="V") return SPELL_SCHOOL_EVOCATION;
    if(sEscuela=="I") return SPELL_SCHOOL_ILLUSION;
    if(sEscuela=="N") return SPELL_SCHOOL_NECROMANCY;
    if(sEscuela=="T") return SPELL_SCHOOL_TRANSMUTATION;

    return -1;
}


int ObjetoEquipable(object oItem)
{
    int nBaseType =GetBaseItemType(oItem);

    // fix, if we get BASE_ITEM_INVALID (usually because oItem is invalid), we
    // need to make sure that this function returns FALSE
    if(nBaseType==BASE_ITEM_INVALID) return FALSE;

    string sResult = Get2DAString("baseitems","EquipableSlots",nBaseType);
    return  (sResult != "0x00000");
}

//void CreateObjectVoid(int nObjectType, string sTemplate, location lLoc, int bUseAppearAnimation = FALSE)
//{
//    CreateObject(nObjectType, sTemplate, lLoc, bUseAppearAnimation);
//}

void AgregarPista(object oUbicado, string sPista) {

    if (DEBUG_FRACASO) SpeakString("----Entrando en AgregarPista----");
    int x=1;
    string sTemp=GetLocalString(oUbicado, "Pista" + IntToString(x));
    while(sTemp!="") {
        if(sTemp==sPista) {
            if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPista: Pista repetida----");
            return;
        }
        x++;
        sTemp=GetLocalString(oUbicado, "Pista" + IntToString(x));
    }

    if (DEBUG_FRACASO) SpeakString("Agregando Pista" + IntToString(x) + ": " + sPista);
    SetLocalString(oUbicado,"Pista" + IntToString(x),sPista);
    if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPista----");


}

void AgregarPistaFalsa(object oUbicado, object oPJ) {

    if (DEBUG_FRACASO) SpeakString("----Entrando en AgregarPistaFalsa----");
    int iNivelPJSaberPopular=GetSkillRank(SKILL_LORE, oPJ);
    if((d20()+iNivelPJSaberPopular)>=15) {
        AgregarPista(oUbicado, "*Si hubieras estudiado mas saber popular como te dijo tu madre...*");
        if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPistaFalsa: Pista mediocierta. Necesita mas saber popular----");
        return;
    }

    string sPistaFalsa;
    int iPistaFalsa=Random(13);
    switch (iPistaFalsa) {
        case 0: sPistaFalsa="*Esto va a ser la trocola...*"; break;
        case 1: sPistaFalsa="*Tal vez dandole unos golpecitos...*"; break;
        case 2: sPistaFalsa="*has probado a cerrarlo y abrirlo?*"; break;
        case 3: sPistaFalsa="*El laudano funciona con los hombres lobos*"; break;
        case 4: sPistaFalsa="*El ajo funciona con los vampiros*"; break;
        case 5: sPistaFalsa="*Dicen que el aloe vera ayuda a curar las heridas*"; break;
        case 6: sPistaFalsa="*Tal vez usando una palabra de activacion...*"; break;
        case 7: sPistaFalsa="*Si sigues por ahi lo vas a romper...*"; break;
        case 8: sPistaFalsa="*recuerdas que en una ocsasion tu maestro dijo... algo mientras estabas dormido*"; break;
        case 9: sPistaFalsa="*Azufre, salitre, carbon y un manos ardientes.*"; break;
        case 10: sPistaFalsa="*Necesitas las lagrimas de un DM bueno*"; break;
        case 11: sPistaFalsa="*Una esfera y algo de grasa tal vez...*"; break;
        case 12: sPistaFalsa="*Si Lust te sonrie podras hacer cualquier cosa*"; break;
    }
    AgregarPista(oUbicado, sPistaFalsa);
    if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPistaFalsa: Pista falsa: " + sPistaFalsa + "----");

}

void AgregarPistaSegunSaberPopular(object oUbicado, string sPista, object oPJ, int iNivelNecesarioSaberPopular, int iDarPistasFalsas=TRUE) {

    if (DEBUG_FRACASO) SpeakString("----Entrando en AgregarPistaSegunSaberPopular----");
    int iNivelPJSaberPopular=GetSkillRank(SKILL_LORE, oPJ,TRUE);
    if (DEBUG_FRACASO) SpeakString("Requerido: " + IntToString(iNivelNecesarioSaberPopular) + "/Nivel PJ: " + IntToString(iNivelPJSaberPopular));
    if (iNivelPJSaberPopular>=iNivelNecesarioSaberPopular) {
        AgregarPista(oUbicado, sPista);
        if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPistaSegunSaberPopular: Saber popular suficiente----");
        return;
    }

    if (iDarPistasFalsas==FALSE) {
        if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPistaSegunSaberPopular: No se dan pistas falsas----");
        return;
    }
    AgregarPistaFalsa(oUbicado, oPJ);
    if (DEBUG_FRACASO) SpeakString("----Saliendo de AgregarPistaSegunSaberPopular: Se dan pistas falsas----");

}

