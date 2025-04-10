//------------------------------------------------------------------------------
//  Libreria para adicion de propiedades.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................
#include "x2_inc_itemprop"
#include "pb_constantes"

//--- Metodos publicos ---------------------------------------------------------

// Debug: Comprobar propiedades aplicadas.
void DebugComprobarCorrectaAplicacionPropiedad(object oObjetoCreado, int iPropiedad, int iTipoEfecto=0, int iCD=0, int iEspecial=0)
{
    if(GetItemHasItemProperty(oObjetoCreado, iPropiedad) == FALSE)
    {
        WriteTimestampedLogEntry("[SISTEMA DE TESOROS NUEVO] Error de aplicación de propiedad en objeto. Propiedad no aplicada "+IntToString(iPropiedad)+". Resref del objeto "+GetResRef(oObjetoCreado)+". Nombre del objeto "+GetName(oObjetoCreado)+".");
        if(iPropiedad == 48) WriteTimestampedLogEntry("[SISTEMA DE TESOROS NUEVO] Análisis propiedad 48. iTipoEfecto: "+IntToString(iTipoEfecto)+"; iCD: "+IntToString(iCD)+"; iEspecial: "+IntToString(iEspecial));
    }
}

//Afila permanentemente un arma.
void setAfliadura(object oItem);

//Hace que el arma emita luz en funcion de los DG pasados.
void setLuz(object oItem, int nDG);

//Proporciona al arma una habilidad al impactar aleatoria.
void setAlImpactar(object oItem, int nDG);

//Porporciona un bono de mejora a las tiradas de salvacion en funcion de los
//DG pasados.
void setTS(object oItem, int nDG);

//Proporciona un bono de ataque o mejora en funcion de los DG pasados.
void setBonoAtaque(object oItem, int nDG);

//Proporciona un bono de ataque o mejora en funcion de los DG pasados.
//Contra un grupo de alineamiento especifico.
void setBonoAtaqueVs(object oItem, int nDG);

//Proporciona una cantidad extra de criticos maxivos.
void setCriticos(object oItem, int nDG);

//Proporciona una cantidad extra de danhos en funcion de los DG pasados.
int setDamagePrimary(object oItem, int nDG, int nType);

//Proporciona una cantidad extra de danhos en funcion de los DG pasados.
void setDamageSecundary(object oItem, int nDG);

//Proporciona una cantidad extra de danhos contra grupo de alineamiento
//especifico en funcion de los DG pasados.
int setDamagePrimaryVs(object oItem, int nDG, int nType);

//Proporciona una cantidad extra de danhos en funcion de los DG pasados.
void setDamageSecundaryVs(object oItem);

//Proporciona la propiedad reforzado con una cantidad en funcion de los DG
//pasados.
void setReforzado(object oItem, int nDG);

//Proporciona una reduccion del peso efectivo del objeto en funcion de los DG
//pasados.
void setReducirPeso(object oItem, int nDG);

//Proporciona una mejora de una puntuacion de caracteristica en funcion de los
//DG pasados.
void setCaracteristica(object oItem, int nDG);

//Proporciona una mejora de una puntuacion de habilidad en funcion de los
//DG pasados.
void setHabilidad(object oItem, int nDG);

//Proporciona una bonificacion a la CA proporcional a los DG pasados.
int setCA(object oItem, int nDG, int nProp);

//Proporciona una reduccion del danho proporcional a los DG pasados.
void setReduccion(object oItem, int nDG);

//Proporciona una regeneracion de 1 punto.
void setRegeneracion(object oItem);

//Proporciona una resistencia al danho proporcional a los DG pasados.
//void setResistencia(object oItem, int nDG);

//Reduce el fallo de conjuro arcano en un porcentaje en funcion de los DG
//pasados.
void setFalloConjuro(object oItem, int nDG);

//Proporciona un espacio de conjuro adicional en funcion de los DG pasados.
//No otorga dos veces el mismo nivel.
void setEspacioConjuro(object oItem, int nDG, int bWiz_Sorc = FALSE);

//Otorga un porcentaje de inmunidad a un tipo de danho especifico en funcion
//de los DG pasados.
void setDamageInumity(object oItem, int nDG);

//Genera un conjuro en el objeto y le anhade un numero determinado de cargas al
//mismo todo en funcion de los DG.
void setSpellUse(object oItem, int nDG);

//Regala una dote aleatoria de la lista:
void setFeat(object oItem, int nDG);

//Genera en el objeto la propiedad solo mago y hechicero.
void setOnlyMW(object oItem);
//..............................................................................

void setAfliadura(object oItem) {
    IPSafeAddItemProperty(oItem, ItemPropertyKeen());

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_KEEN);
}

void setLuz(object oItem, int nDG) {
    int nBrillo;
    int nColor;

    if(nDG <= 9) {
        nBrillo = 0;
    } else if(nDG <= 19) {
        nBrillo = IP_CONST_LIGHTBRIGHTNESS_DIM;
    } else if(nDG <= 29) {
        nBrillo = IP_CONST_LIGHTBRIGHTNESS_LOW;
    } else if(nDG <= 39) {
        nBrillo = IP_CONST_LIGHTBRIGHTNESS_NORMAL;
    } else {
        nBrillo = IP_CONST_LIGHTBRIGHTNESS_BRIGHT;
    }
    nColor = Random(7); //Cargamos un color aleatorio.
    IPSafeAddItemProperty(oItem,ItemPropertyLight(nBrillo, nColor));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_LIGHT);
}

void setAlImpactar(object oItem, int nDG) {
    int nTirada = d2();
    int nCD;
    int nPropiedad;
    int nSpecial;

    if(nDG <= 9) {
        nCD = IP_CONST_ONHIT_SAVEDC_14;
    } else if(nDG <= 19) {
        if(nTirada == 1) {
            nCD = IP_CONST_ONHIT_SAVEDC_14;
        } else {
            nCD = IP_CONST_ONHIT_SAVEDC_16;
        }
    } else if(nDG <= 29) {
        if(nTirada == 1) {
            nCD = IP_CONST_ONHIT_SAVEDC_16;
        } else {
            nCD = IP_CONST_ONHIT_SAVEDC_18;
        }
    } else if(nDG <= 39) {
        nCD = IP_CONST_ONHIT_SAVEDC_18;
    } else {
        nCD = IP_CONST_ONHIT_SAVEDC_18;
    }

    switch(d8()) {
        case 1: //Aturdimiento
            nPropiedad = IP_CONST_ONHIT_STUN;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 2: //Atontamiento
            nPropiedad = IP_CONST_ONHIT_DAZE;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 3: //Ceguera
            nPropiedad = IP_CONST_ONHIT_BLINDNESS;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 4: //Confusion
            nPropiedad = IP_CONST_ONHIT_CONFUSION;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 5: //Miedo
            nPropiedad = IP_CONST_ONHIT_FEAR;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 6: //Silencio
            nPropiedad = IP_CONST_ONHIT_SILENCE;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 7: //Sordera
            nPropiedad = IP_CONST_ONHIT_DEAFNESS;
            nSpecial = IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS;
            break;
        case 8: //Veneno
            nPropiedad = IP_CONST_ONHIT_ITEMPOISON;
            switch(d6()) {
                case 1:
                    nSpecial = IP_CONST_POISON_1D2_CHADAMAGE;
                    break;
                case 2:
                    nSpecial = IP_CONST_POISON_1D2_CONDAMAGE;
                    break;
                case 3:
                    nSpecial = IP_CONST_POISON_1D2_DEXDAMAGE;
                    break;
                case 4:
                    nSpecial = IP_CONST_POISON_1D2_INTDAMAGE;
                    break;
                case 5:
                    nSpecial = IP_CONST_POISON_1D2_STRDAMAGE;
                    break;
                case 6:
                    nSpecial = IP_CONST_POISON_1D2_WISDAMAGE;
                    break;
            }
            break;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyOnHitProps(nPropiedad, nCD, nSpecial));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_ON_HIT_PROPERTIES, nPropiedad, nCD, nSpecial);
}

void setTS(object oItem, int nDG)
{
    int nBono;
    int nTipo;
    int nProp;

    if(nDG <= 9) {
        nBono = 1;
        nTipo = d3();
    } else if(nDG <= 19) {
        nBono = d2();
        nTipo = d3();
    } else if(nDG <= 29) {
        nBono = d3();
        nTipo = d3();
    } else if(nDG <= 39) {
        nBono = d3();
        nTipo = d4();
    } else {
        nBono = 3;
        nTipo = d4();
    }
    switch(nTipo)
    {
        case 1:
            nProp = IP_CONST_SAVEBASETYPE_FORTITUDE;
            IPSafeAddItemProperty(oItem,ItemPropertyBonusSavingThrow(nProp, nBono));
            break;
        case 2:
            nProp = IP_CONST_SAVEBASETYPE_REFLEX;
            IPSafeAddItemProperty(oItem,ItemPropertyBonusSavingThrow(nProp, nBono));
            break;
        case 3:
            nProp = IP_CONST_SAVEBASETYPE_WILL;
            IPSafeAddItemProperty(oItem,ItemPropertyBonusSavingThrow(nProp, nBono));
            break;
        case 4:
            nProp = IP_CONST_SAVEVS_UNIVERSAL;
            IPSafeAddItemProperty(oItem,ItemPropertyBonusSavingThrowVsX(nProp, nBono));
            break;
    }

    if(nTipo == 1 || nTipo == 2 || nTipo == 3){DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC);}
    if(nTipo == 4){DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_SAVING_THROW_BONUS);}
}

void setBonoAtaque(object oItem, int nDG){
    int nMejora;

    if(nDG <= 9){
        nMejora = 1;
    }else if(nDG <= 19){
        nMejora = 2;
    }else if(nDG <= 29){
        nMejora = 3;
    }else if(nDG <= 39){
        nMejora = d2()+3;
    }else{
        nMejora = 5;
    }

    //Aplicamos el bono de mejora.
    IPSafeAddItemProperty(oItem,ItemPropertyEnhancementBonus(nMejora));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS);
}

void setBonoAtaqueVs(object oItem, int nDG) {
    int nMejora;
    int nAlineamiento;

    if(nDG <= 9){
        nMejora = d2();
    }else if(nDG <= 19){
        nMejora = d2()+1;
    } else if(nDG <= 29) {
        nMejora = d2()+2;
    } else if(nDG <= 39) {
        nMejora = d2()+3;
    } else {
        nMejora = 5;
    }

    switch(Random(5)) {
        case 0:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_CHAOTIC;
            break;
        case 1:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_EVIL;
            break;
        case 2:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_GOOD;
            break;
        case 3:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_LAWFUL;
            break;
        case 4:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_NEUTRAL;
            break;
    }

    //De lo contrario introduce el bono de ataque.
    IPSafeAddItemProperty(oItem,ItemPropertyEnhancementBonusVsAlign(nAlineamiento, nMejora));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS_VS_ALIGNMENT_GROUP);
}

void setCriticos(object oItem, int nDG) {
    int nDamage;

    if(nDG <= 9) {
        nDamage = IP_CONST_DAMAGEBONUS_1d6;
    } else if(nDG <= 19) {
        nDamage = IP_CONST_DAMAGEBONUS_1d8;
    } else if(nDG <= 29) {
        if(d2() == 1) {
            nDamage = IP_CONST_DAMAGEBONUS_1d8;
        } else {
            nDamage = IP_CONST_DAMAGEBONUS_1d10;
        }
    } else if(nDG <= 39) {
        if(d2() == 1) {
            nDamage = IP_CONST_DAMAGEBONUS_1d10;
        } else {
            nDamage = IP_CONST_DAMAGEBONUS_2d6;
        }
    } else {
        nDamage = IP_CONST_DAMAGEBONUS_2d6;
    }
    IPSafeAddItemProperty(oItem,ItemPropertyMassiveCritical(nDamage));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS);
}

int setDamagePrimary(object oItem, int nDG, int nType) {
    int nDamage;
    int nDamageType;

    //Revisamos todas las propiedades del objeto en busca de los de danho.
    //que no debe repetirse.
    int nLoadDamage = nType;
    int bBucle = TRUE;

    while(bBucle) {
        switch(Random(8)) {
            case 0:
                nDamageType = IP_CONST_DAMAGETYPE_ACID;
                break;
            case 1:
                nDamageType = IP_CONST_DAMAGETYPE_COLD;
                break;
            case 2:
                nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
                break;
            case 3:
                nDamageType = IP_CONST_DAMAGETYPE_FIRE;
                break;
            case 4:
                nDamageType = IP_CONST_DAMAGETYPE_SONIC;
                break;
            case 5:
                nDamageType = IP_CONST_DAMAGETYPE_VENENO;
                break;
            case 6:
                nDamageType = IP_CONST_DAMAGETYPE_PSIQUICO;
                break;
            case 7:
                nDamageType = IP_CONST_DAMAGETYPE_FUERZA;
                break;
        }
        if(nDamageType != nLoadDamage) bBucle = FALSE;
    }

    if(nDG <= 9) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
        }
    } else if(nDG <= 19) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
        }
    } else if(nDG <= 29) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d10;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                //Daño psiquico y veneno nerfeado a 1d8.
                if(nDamageType == IP_CONST_DAMAGETYPE_PSIQUICO || nDamageType == IP_CONST_DAMAGETYPE_VENENO)
                {nDamage = IP_CONST_DAMAGEBONUS_1d8;}
                break;
        }
    } else if(nDG <= 39) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d10;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                //Daño psiquico y veneno nerfeado a 1d8.
                if(nDamageType == IP_CONST_DAMAGETYPE_PSIQUICO || nDamageType == IP_CONST_DAMAGETYPE_VENENO)
                {nDamage = IP_CONST_DAMAGEBONUS_1d8;}
                break;
        }
    } else {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d10;
                //Daño fuerza nerfeado a 1d4.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d4;}
                //Daño psiquico y veneno nerfeado a 1d8.
                if(nDamageType == IP_CONST_DAMAGETYPE_PSIQUICO || nDamageType == IP_CONST_DAMAGETYPE_VENENO)
                {nDamage = IP_CONST_DAMAGEBONUS_1d8;}
                break;
        }
    }
    IPSafeAddItemProperty(oItem,ItemPropertyDamageBonus(nDamageType, nDamage));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_DAMAGE_BONUS);

    return nDamageType;
}

void setDamageSecundary(object oItem, int nDG) {
    int nDamageType, nDamage;

    switch(d2())
    {
        case 1:
            nDamageType = IP_CONST_DAMAGETYPE_NEGATIVE;
            break;
        case 2:
            nDamageType = IP_CONST_DAMAGETYPE_POSITIVE;
            break;
    }

    if(nDG <= 9) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
        }
    } else if(nDG <= 19) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
        }
    } else if(nDG <= 29) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d10;
                break;
        }
    } else if(nDG <= 39) {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
        }
    } else {
        switch(d3()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
            case 3:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                break;
        }
    }
    IPSafeAddItemProperty(oItem,ItemPropertyDamageBonus(nDamageType, nDamage));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_DAMAGE_BONUS);
}


int setDamagePrimaryVs(object oItem, int nDG, int nType) {
    int nDamage;
    int nDamageType;
    int nAlineamiento;

    //Revisamos todas las propiedades del objeto en busca de los de danho.
    //que no debe repetirse.
    int nLoadDamage = nType;
    int bBucle = TRUE;

    while(bBucle) {
        switch(Random(8)) {
            case 0:
                nDamageType = IP_CONST_DAMAGETYPE_ACID;
                break;
            case 1:
                nDamageType = IP_CONST_DAMAGETYPE_COLD;
                break;
            case 2:
                nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
                break;
            case 3:
                nDamageType = IP_CONST_DAMAGETYPE_FIRE;
                break;
            case 4:
                nDamageType = IP_CONST_DAMAGETYPE_SONIC;
                break;
            case 5:
                nDamageType = IP_CONST_DAMAGETYPE_VENENO;
                break;
            case 6:
                nDamageType = IP_CONST_DAMAGETYPE_PSIQUICO;
                break;
            case 7:
                nDamageType = IP_CONST_DAMAGETYPE_FUERZA;
                break;
        }
        if(nDamageType != nLoadDamage) bBucle = FALSE;
    }

    if(nDG <= 9) {
        nDamage = IP_CONST_DAMAGEBONUS_1d4;
    } else if(nDG <= 19) {
        switch(d2()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
                break;
        }
    } else if(nDG <= 29) {
        switch(d2()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño a fuerza nerfeado a 1d6.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d6;}
                break;
        }
    } else if(nDG <= 39) {
        switch(d2()) {
            case 1:
                nDamage = IP_CONST_DAMAGEBONUS_1d8;
                //Daño a fuerza nerfeado a 1d6.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d6;}
                break;
            case 2:
                nDamage = IP_CONST_DAMAGEBONUS_1d10;
                //Daño a fuerza nerfeado a 1d6.
                if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
                {nDamage = IP_CONST_DAMAGEBONUS_1d6;}
                break;
        }
    } else {
        nDamage = IP_CONST_DAMAGEBONUS_1d10;
        //Daño a fuerza nerfeado a 1d6.
        if(nDamageType == IP_CONST_DAMAGETYPE_FUERZA)
        {nDamage = IP_CONST_DAMAGEBONUS_1d6;}
    }

    switch(d3()) {
        case 1:
            if(nDG < 9) {
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
            } else {
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
            }
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_GOOD;
            break;
        case 2:
            if(nDG < 9) {
                nDamage = IP_CONST_DAMAGEBONUS_1d4;
            } else {
                nDamage = IP_CONST_DAMAGEBONUS_1d6;
            }
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_EVIL;
            break;
        case 3:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_NEUTRAL;
            break;
    }
    IPSafeAddItemProperty(oItem,ItemPropertyDamageBonusVsAlign(nAlineamiento, nDamageType, nDamage));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP);

    return nDamageType;
}

void setDamageSecundaryVs(object oItem) {
    int nDamageType;
    int nAlineamiento;

    //Revisamos todas las propiedades del objeto en busca de los de danho.
    //que no debe repetirse.
    int nLoadDamage;
    switch(StringToInt(Get2DAString("baseitems", "WeaponType", GetBaseItemType(oItem)))) {
        case 1: //Pearcing damage.
            if(Random(2) == 0) {
                nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
            } else {
                nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
            }
            break;
        case 2: //Bludgeoning dagame.
            if(Random(2) == 0) {
                nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
            } else {
                nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
            }
            break;
        case 3: //Splashing damage.
            if(Random(2) == 0) {
                nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
            } else {
                nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
            }
            break;
        case 4: //Piercing-slashing damage.
            nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
            break;
        case 5: //Bludgeoning-piercing damage.
            nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
            break;
    }

    switch(d2()) {
        case 1:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_CHAOTIC;
            break;
        case 2:
            nAlineamiento = IP_CONST_ALIGNMENTGROUP_LAWFUL;
            break;
    }
    IPSafeAddItemProperty(oItem,ItemPropertyDamageBonusVsAlign(nAlineamiento, nDamageType, IP_CONST_DAMAGEBONUS_1d6));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP);
}

void setReforzado(object oItem, int nDG) {
    int nRefuerzo;

    if(nDG <= 9) {
        nRefuerzo = d3();
    } else if(nDG <= 19) {
        nRefuerzo = d3()+1;
    } else if(nDG <= 29) {
        nRefuerzo = d3()+2;
    } else if(nDG <= 39) {
        nRefuerzo = 5;
    } else {
        nRefuerzo = 5;
    }
    IPSafeAddItemProperty(oItem,ItemPropertyMaxRangeStrengthMod(nRefuerzo));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_MIGHTY);
}

void setReducirPeso(object oItem, int nDG) {
    int nPeso;

    if(nDG <= 9) {
        nPeso = IP_CONST_REDUCEDWEIGHT_80_PERCENT;
    } else if(nDG <= 19) {
        nPeso = IP_CONST_REDUCEDWEIGHT_60_PERCENT;
    } else if(nDG <= 29) {
        nPeso = IP_CONST_REDUCEDWEIGHT_40_PERCENT;
    } else if(nDG <= 39) {
        nPeso = IP_CONST_REDUCEDWEIGHT_20_PERCENT;
    } else {
        nPeso = IP_CONST_REDUCEDWEIGHT_10_PERCENT;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyWeightReduction(nPeso));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION);
}

void setCaracteristica(object oItem, int nDG) {
    int nBonus;
    int nAbility;

    if(nDG <= 9) {
        nBonus = d2();
    } else if(nDG <= 19) {
        nBonus = d3()+1;
    } else if(nDG <= 29) {
        nBonus = d3()+3;
    } else if(nDG <= 39) {
        nBonus = d2()+4;
    } else {
        nBonus = 6;
    }
    switch(d6()) {
        case 1:
            nAbility = IP_CONST_ABILITY_CHA;
            break;
        case 2:
            nAbility = IP_CONST_ABILITY_CON;
            break;
        case 3:
            nAbility = IP_CONST_ABILITY_DEX;
            break;
        case 4:
            nAbility = IP_CONST_ABILITY_INT;
            break;
        case 5:
            nAbility = IP_CONST_ABILITY_STR;
            break;
        case 6:
            nAbility = IP_CONST_ABILITY_WIS;
            break;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyAbilityBonus(nAbility, nBonus));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_ABILITY_BONUS);
}

void setHabilidad(object oItem, int nDG) {
    int nBonus;
    int nSkill = Random(39);
    while(nSkill == 34) {
        //No puede salir la habilidad hablar un idioma.
        nSkill = Random(39);
    }

    if(nDG <= 9) {
        nBonus = d4()+3;
    } else if(nDG <= 19) {
        nBonus = d4()+3;
    } else if(nDG <= 29) {
        nBonus = d4()+4;
    } else if(nDG <= 39) {
        nBonus = d4()+5;
    } else {
        nBonus = 7;
    }
    if(nBonus > 7) nBonus = 7;

    IPSafeAddItemProperty(oItem,ItemPropertySkillBonus(nSkill, nBonus));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_SKILL_BONUS);
}

int setCA(object oItem, int nDG, int nProp) {
    //nProp = han de pasarse las propiedades disponibles por si sale CA 5
    int nBonus;

    if(nDG <= 9) {
        nBonus = d2();
    } else if(nDG <= 19) {
        nBonus = d2()+1;
    } else if(nDG <= 29) {
        nBonus = d2()+2;
    } else if(nDG <= 39) {
        nBonus = d2()+2;
    } else {
        nBonus = 5;
    }
    if(nProp < 2) {
        //Si solo queda una propiedad el bonus se arregla para que
        //cueste solo 1 punto.
        if(nBonus == 5) nBonus = 4;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyACBonus(nBonus));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_AC_BONUS);

    return nBonus;
}

void setReduccion(object oItem, int nDG) {
    int nBonus;
    int nAbsorcion;

    if(nDG <= 9) {
        nBonus = 0;
        nAbsorcion = 0;
    } else if(nDG <= 19) {
        if(d2() == 1) {
            nBonus = IP_CONST_DAMAGEREDUCTION_1;
        } else {
            nBonus = IP_CONST_DAMAGEREDUCTION_2;
        }
        nAbsorcion = IP_CONST_DAMAGESOAK_5_HP;
    } else if(nDG <= 29) {
        if(d2() == 1) {
            nBonus = IP_CONST_DAMAGEREDUCTION_1;
        } else {
            nBonus = IP_CONST_DAMAGEREDUCTION_2;
        }
        nAbsorcion = IP_CONST_DAMAGESOAK_10_HP;
    } else if(nDG <= 39) {
        if(d2() == 1) {
            nBonus = IP_CONST_DAMAGEREDUCTION_2;
        } else {
            nBonus = IP_CONST_DAMAGEREDUCTION_3;
        }
        nAbsorcion = IP_CONST_DAMAGESOAK_10_HP;
    } else {
        nBonus = IP_CONST_DAMAGEREDUCTION_3;
        nAbsorcion = IP_CONST_DAMAGESOAK_10_HP;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyDamageReduction(nBonus, nAbsorcion));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_DAMAGE_REDUCTION);
}

void setRegeneracion(object oItem) {
    IPSafeAddItemProperty(oItem,ItemPropertyRegeneration(1));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_REGENERATION);
}

/*void setResistencia(object oItem, int nDG) {
    int nBonus;
    int nType;
    int tirada = (Random(8)+1);
    if(nDG <= 9) {
        nBonus = 0;
    } else if(nDG <= 19) {
        nBonus = IP_CONST_DAMAGERESIST_5;
    } else if(nDG <= 29) {
        nBonus = IP_CONST_DAMAGERESIST_5;
    } else if(nDG <= 39) {
        if(d2() == 1) {
            nBonus = IP_CONST_DAMAGERESIST_5;
        } else {
            nBonus = IP_CONST_DAMAGERESIST_10;
        }
    } else {
        nBonus = IP_CONST_DAMAGERESIST_10;
    }

    switch(tirada) {
        case 1:
            nType = IP_CONST_DAMAGETYPE_ACID;
            break;
        case 2:
            nType = IP_CONST_DAMAGETYPE_BLUDGEONING; //Contundente
            break;
        case 3:
            nType = IP_CONST_DAMAGETYPE_COLD;
            break;
        case 4:
            nType = IP_CONST_DAMAGETYPE_ELECTRICAL;
            break;
        case 5:
            nType = IP_CONST_DAMAGETYPE_FIRE;
            break;
        case 6:
            nType = IP_CONST_DAMAGETYPE_PIERCING; //Perforante
            break;
        case 7:
            nType = IP_CONST_DAMAGETYPE_SLASHING;  //Cortante
            break;
        case 8:
            nType = IP_CONST_DAMAGETYPE_SONIC;
            break;
    }
    if ((nType==IP_CONST_DAMAGETYPE_SLASHING) || (nType==IP_CONST_DAMAGETYPE_BLUDGEONING) || (nType==IP_CONST_DAMAGETYPE_PIERCING)){ nBonus = IP_CONST_DAMAGERESIST_5;}

    IPSafeAddItemProperty(oItem,ItemPropertyDamageResistance(nType, nBonus));
}*/

void setFalloConjuro(object oItem, int nDG) {
    int nBonus;

    if(nDG <= 9) {
        nBonus = 0;
    } else if(nDG <= 19) {
        nBonus = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_10_PERCENT;  //5
    } else if(nDG <= 29) {
        nBonus = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_15_PERCENT; //10
    } else if(nDG <= 39) {
        nBonus = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_20_PERCENT;  //15
    } else {
        nBonus = IP_CONST_ARCANE_SPELL_FAILURE_MINUS_30_PERCENT; //20
    }

    IPSafeAddItemProperty(oItem,ItemPropertyArcaneSpellFailure(nBonus));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_ARCANE_SPELL_FAILURE);
}

void setEspacioConjuro(object oItem, int nDG, int bWiz_Sorc = FALSE){
    int nClass;
    int nSpellLevel;

    if(nDG <= 9) {
        nSpellLevel = d2();
    } else if(nDG <= 19) {
        nSpellLevel = d3();
    } else if(nDG <= 29) {
        nSpellLevel = d4()+1;
    } else if(nDG <= 39) {
        nSpellLevel = d6()+1;
    } else {
        nSpellLevel = d6()+3;
    }

    do
    {
        switch(Random(12))
        {
            case 0:
                nClass = CLASS_TYPE_BARD;
                if(nSpellLevel > 6) nSpellLevel = 6;
                break;
            case 1:
                nClass = CLASS_TYPE_CLERIC;
                break;
            case 2:
                nClass = CLASS_TYPE_DRUID;
                break;
            case 3:
                nClass = CLASS_TYPE_PALADIN;
                if(nSpellLevel > 4) nSpellLevel = 4;
                break;
            case 4:
                nClass = CLASS_TYPE_RANGER;
                if(nSpellLevel > 4) nSpellLevel = 4;
                break;
            case 5:
                nClass = CLASS_TYPE_SORCERER;
                break;
            case 6:
                nClass = CLASS_TYPE_WIZARD;
                break;
            case 7:
                nClass = CLASS_TYPE_FAVORED_SOUL;
                break;
            case 8:
                nClass = CLASS_TYPE_INGENIERO;
                if(nSpellLevel > 6) nSpellLevel = 6;
                break;
            case 9:
                nClass = CLASS_TYPE_PAL_ANTIGUO;
                if(nSpellLevel > 4) nSpellLevel = 4;
                break;
            case 10:
                nClass = CLASS_TYPE_PAL_OSCURO;
                if(nSpellLevel > 4) nSpellLevel = 4;
                break;
            case 11:
                nClass = CLASS_TYPE_PAL_VENGADOR;
                if(nSpellLevel > 4) nSpellLevel = 4;
                break;
        }
        if(bWiz_Sorc)
        {
            switch(d3())
            {
                case 1:
                    nClass = CLASS_TYPE_SORCERER;
                    break;
                case 2:
                    nClass = CLASS_TYPE_WIZARD;
                    break;
                case 3:
                    nClass = CLASS_TYPE_INGENIERO;
                    break;
            }
        }
    }while ((GetBaseItemType(oItem)==BASE_ITEM_MAGICSTAFF) && ((nClass==IP_CONST_CLASS_RANGER)||(nClass==IP_CONST_CLASS_PALADIN)||(nClass==IP_CONST_CLASS_BARD)));

    IPSafeAddItemProperty(oItem,ItemPropertyBonusLevelSpell(nClass, nSpellLevel));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_BONUS_SPELL_SLOT_OF_LEVEL_N);
}

void setDamageInumity(object oItem, int nDG) {
    int nDamageType;
    int nImmuneBonus;

    if(nDG <= 9) {
        nImmuneBonus = 0;
    } else if(nDG <= 19) {
        nImmuneBonus = IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
    } else if(nDG <= 29) {
        nImmuneBonus = IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
    } else if(nDG <= 39) {
        if(d2() == 1) {
            nImmuneBonus = IP_CONST_DAMAGEIMMUNITY_10_PERCENT;
        } else {
            nImmuneBonus = 9;
        }
    } else {
        nImmuneBonus = 9;
    }

    switch(d8()) {
        case 1:
            nDamageType = IP_CONST_DAMAGETYPE_ACID;
            break;
        case 2:
            nDamageType = IP_CONST_DAMAGETYPE_BLUDGEONING;
            break;
        case 3:
            nDamageType = IP_CONST_DAMAGETYPE_COLD;
            break;
        case 4:
            nDamageType = IP_CONST_DAMAGETYPE_ELECTRICAL;
            break;
        case 5:
            nDamageType = IP_CONST_DAMAGETYPE_FIRE;
            break;
        case 6:
            nDamageType = IP_CONST_DAMAGETYPE_PIERCING;
            break;
        case 7:
            nDamageType = IP_CONST_DAMAGETYPE_SLASHING;
            break;
        case 8:
            nDamageType = IP_CONST_DAMAGETYPE_SONIC;
            break;
        case 9:
            nDamageType = IP_CONST_DAMAGETYPE_FUERZA;
            break;
        case 10:
            nDamageType = IP_CONST_DAMAGETYPE_VENENO;
            break;
        case 11:
            nDamageType = IP_CONST_DAMAGETYPE_PSIQUICO;
            break;
    }

    IPSafeAddItemProperty(oItem,ItemPropertyDamageImmunity(nDamageType, nImmuneBonus));

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE);
}

int getSpellProp(int nLevel) {
    //Lee el fichero asociado a todas las propiedades de conjuro y devuelve
    //el primero que tenga el nivel innato indicado.

    int bBucle = TRUE;
    int rowNumber;

    while(bBucle) {
        //El fichero tiene actualmente de 0 a 600 columnas.
        //Si en una futura actualizacion se meten mas conjuros en este archivo debera
        //retocarse el random con el numero total de columnas del archivo +1.
        rowNumber = Random(601);
        int nInnateLvl = StringToInt(Get2DAString("iprp_spells","InnateLvl", rowNumber));
        int nCasterLvl = StringToInt(Get2DAString("iprp_spells","CasterLvl", rowNumber));
        int bExcludeFromShop = StringToInt(Get2DAString("iprp_spells","ExcludeFromShop", rowNumber));

        if(!bExcludeFromShop && nCasterLvl > 1 && nCasterLvl <= 8) {  //20
            //Solo se cargaran los conjuros con nivel de lanzador superior a 1
            //Ya que los que tienen nivel 1 son todos tines y cosas asi.
            //Tampoco se cargaran los conjuros con nivel de lanzador superior al
            //20 dado que estos conjuros son epicos.
            int nSpellId = StringToInt(Get2DAString("iprp_spells","SpellIndex", rowNumber));
            int nBard = StringToInt(Get2DAString("spells","Bard", nSpellId));
            int nCleric = StringToInt(Get2DAString("spells","Cleric", nSpellId));
            int nDruid = StringToInt(Get2DAString("spells","Druid", nSpellId));
            int nPaladin = StringToInt(Get2DAString("spells","Paladin", nSpellId));
            int nRanger = StringToInt(Get2DAString("spells","Ranger", nSpellId));
            int nWiz_Sorc = StringToInt(Get2DAString("spells","Wiz_Sorc", nSpellId));
            int nPaladinAntiguo = StringToInt(Get2DAString("spells","PaladinAntiguos", nSpellId));
            int nPaladinOscuro = StringToInt(Get2DAString("spells","PaladinOscuro", nSpellId));
            int nPaladinVengador = StringToInt(Get2DAString("spells","PaladinVengador", nSpellId));

            if(nBard > 0 || nCleric > 0 || nDruid > 0 || nPaladin > 0 || nRanger > 0 || nWiz_Sorc > 0 || nPaladinAntiguo > 0 || nPaladinOscuro > 0 || nPaladinVengador > 0) {
                if(nInnateLvl == nLevel) bBucle = FALSE;
            }
        }
    }

    return rowNumber;
}

void setOnlyClass(object oItem, int nClass) {
    IPSafeAddItemProperty(oItem,ItemPropertyLimitUseByClass(nClass));
}

void setSpellUse(object oItem, int nDG) {
    //Variables encargadas de dar el conjuro.
    int nNivel;
    int nCargas;
    int nNumUses;
    int nSpell;

    //Variables encargadas de poner el requisito de uso.
    int nSpellId;
    int nBard;
    int nCleric;
    int nDruid;
    int nPaladin;
    int nRanger;
    int nWiz_Sorc;
    int nPaladinAntiguo;
    int nPaladinOscuro;
    int nPaladinVengador;

    if(nDG <= 9) {
        nNivel = 1;
        nNumUses = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
        nCargas = d6(2);
    } else if(nDG <= 19) {
        nNivel = 2;
        nNumUses = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
        nCargas = d6(3);
    } else if(nDG <= 29) {
        nNivel = 3;
        nNumUses = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
        nCargas = d6(4);
    } else if(nDG <= 39) {
        nNivel = 4;
        nNumUses = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
        nCargas = d6(5);
    } else {
        nNivel = 5;
        nNumUses = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
        nCargas = d6(6);
    }

    nCargas=d6(2)+3;
    nSpell = getSpellProp(nNivel);
    nSpellId = StringToInt(Get2DAString("iprp_spells","SpellIndex", nSpell));
    nBard = StringToInt(Get2DAString("spells","Bard", nSpellId));
    nCleric = StringToInt(Get2DAString("spells","Cleric", nSpellId));
    nDruid = StringToInt(Get2DAString("spells","Druid", nSpellId));
    nPaladin = StringToInt(Get2DAString("spells","Paladin", nSpellId));
    nRanger = StringToInt(Get2DAString("spells","Ranger", nSpellId));
    nWiz_Sorc = StringToInt(Get2DAString("spells","Wiz_Sorc", nSpellId));
    nPaladinAntiguo = StringToInt(Get2DAString("spells","PaladinAntiguos", nSpellId));
    nPaladinOscuro = StringToInt(Get2DAString("spells","PaladinOscuro", nSpellId));
    nPaladinVengador = StringToInt(Get2DAString("spells","PaladinVengador", nSpellId));

    SetItemCharges(oItem, nCargas);
    IPSafeAddItemProperty(oItem,ItemPropertyCastSpell(nSpell, nNumUses));
    if(nBard > 0) setOnlyClass(oItem, IP_CONST_CLASS_BARD);
    if(nCleric > 0) setOnlyClass(oItem, IP_CONST_CLASS_CLERIC);
    if(nDruid > 0) setOnlyClass(oItem, IP_CONST_CLASS_DRUID);
    if(nPaladin > 0) setOnlyClass(oItem, IP_CONST_CLASS_PALADIN);
    if(nRanger > 0) setOnlyClass(oItem, IP_CONST_CLASS_RANGER);
    if(nWiz_Sorc > 0) setOnlyClass(oItem, IP_CONST_CLASS_SORCERER);
    if(nWiz_Sorc > 0) setOnlyClass(oItem, IP_CONST_CLASS_WIZARD);
    if(nWiz_Sorc > 0) setOnlyClass(oItem, CLASS_TYPE_INGENIERO);
    if(nPaladinAntiguo > 0) setOnlyClass(oItem, CLASS_TYPE_PAL_ANTIGUO);
    if(nPaladinOscuro > 0) setOnlyClass(oItem, CLASS_TYPE_PAL_OSCURO);
    if(nPaladinVengador > 0) setOnlyClass(oItem, CLASS_TYPE_PAL_VENGADOR);

    DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_CAST_SPELL);
}

void setFeat(object oItem, int nDG) {
    int nFeat;

    if(nDG >= 30) {
        switch(Random(11)) {
            case 0:         //Conjuros penetrantes
                nFeat = 36;
                break;
            case 1:         //Alerta
                nFeat = 0;
                break;
            case 2:         //Esquiva
                nFeat = 4;
                break;
            case 3:        //Gran fortaleza
                nFeat = 238;
                break;
            case 4:        //Pericia en combate
                nFeat = 240;
                break;
            case 5:        //Reflejos rapidos
                nFeat = 239;
                break;
            case 6:        //Voluntad de hierro
                nFeat = 237;
                break;
            case 7:        //Derribo mejorado
                nFeat = 1153;
                break;
            case 8:        //Desarme mejorado
                nFeat = 1155;
                break;
            case 9:        //Expulsión incrementada
                nFeat = 13;
                break;
            case 10:
                switch(Random(8)) {
                    case 0:
                        nFeat = FEAT_SPELL_FOCUS_ABJURATION;
                        break;
                    case 1:
                        nFeat = FEAT_SPELL_FOCUS_CONJURATION;
                        break;
                    case 2:
                        nFeat = FEAT_SPELL_FOCUS_DIVINATION;
                        break;
                    case 3:
                        nFeat = FEAT_SPELL_FOCUS_ENCHANTMENT;
                        break;
                    case 4:
                        nFeat = FEAT_SPELL_FOCUS_EVOCATION;
                        break;
                    case 5:
                        nFeat = FEAT_SPELL_FOCUS_ILLUSION;
                        break;
                    case 6:
                        nFeat = FEAT_SPELL_FOCUS_NECROMANCY;
                        break;
                    case 7:
                        nFeat = FEAT_SPELL_FOCUS_TRANSMUTATION;
                        break;
                }
                break;
        }
        IPSafeAddItemProperty(oItem,ItemPropertyBonusFeat(nFeat));

        DebugComprobarCorrectaAplicacionPropiedad(oItem, ITEM_PROPERTY_BONUS_FEAT);
    }
}


void setOnlyMW(object oItem) {
    setOnlyClass(oItem, IP_CONST_CLASS_SORCERER);
    setOnlyClass(oItem, IP_CONST_CLASS_WIZARD);
    setOnlyClass(oItem, CLASS_TYPE_INGENIERO);
}

//void main(){}
