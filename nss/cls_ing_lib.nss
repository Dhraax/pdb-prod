#include "pb_constantes"
#include "x2_inc_itemprop"
#include "mti_libreria"
#include "X0_I0_SPELLS"
#include "inc_sqlite_time"
#include "nwnx_creature"

//Esta función lee la cantidad de infusiones que tiene el Artífice, según el nivel.
int iLeerInfusiones (object oPC, int iNivel);

//Esta función indica si el artífice aún puede aprender infusiones del nivel pedido.
int iLeerRestantes (object oPC, int iNivel);

//Esta función cambia el tipo de "poder único" que tiene el objeto del artífice.
//1 = Personal, 2 = Toque, 3 = Corto , 4 = largo
void AdaptarLongitudItem(object oItem, int iDistancia);

//Esta función se usa en el ingeniero para aplicar los efectos de los estados quemado (entre otras).
void ImpactosSecundarios(object oPC, object oTarget, int iDanoTipo, int iDano, int iCD, int iVisual, int iSpell);

//Esta función se usa en el ingeniero, para borrar las áreas de efecto, evitando acumularlas.
void BorrarAreasEfecto (object oPC, string iTag);

int iLeerInfusiones (object oPC, int iNivel)
{
    int iContador;
    if(iNivel == 1)
    {
        //Artillero
        if(GetHasFeat(1740, oPC) == TRUE){iContador = iContador + 1;}  //Lanzallamas.
        if(GetHasFeat(1741, oPC) == TRUE){iContador = iContador + 1;}  //Humificador.
        if(GetHasFeat(1742, oPC) == TRUE){iContador = iContador + 1;}  //Bazooka.

        //Armero
        if(GetHasFeat(1749, oPC) == TRUE){iContador = iContador + 1;}  //Guanteletes de Trueno.
        if(GetHasFeat(1750, oPC) == TRUE){iContador = iContador + 1;}  //Ciborg.
        if(GetHasFeat(1751, oPC) == TRUE){iContador = iContador + 1;}  //Campo de detección.

        //Armero
        if(GetHasFeat(1758, oPC) == TRUE){iContador = iContador + 1;}  //Elixir del conocimiento
        if(GetHasFeat(1759, oPC) == TRUE){iContador = iContador + 1;}  //Bomba de raíces.
        if(GetHasFeat(1760, oPC) == TRUE){iContador = iContador + 1;}  //Bomba de gas
    }
    if(iNivel == 2)
    {
        //Artillero
        if(GetHasFeat(1743, oPC) == TRUE){iContador = iContador + 1;}  //Apaga incendios.
        if(GetHasFeat(1744, oPC) == TRUE){iContador = iContador + 1;}  //Ariete.
        if(GetHasFeat(1745, oPC) == TRUE){iContador = iContador + 1;}  //Electrocutador.

        //Armero
        if(GetHasFeat(1752, oPC) == TRUE){iContador = iContador + 1;}  //Propulsores.
        if(GetHasFeat(1753, oPC) == TRUE){iContador = iContador + 1;}  //Romperrocas.
        if(GetHasFeat(1754, oPC) == TRUE){iContador = iContador + 1;}  //Goma viscosa.

        //Armero
        if(GetHasFeat(1761, oPC) == TRUE){iContador = iContador + 1;}  //Elixir del berserker.
        if(GetHasFeat(1762, oPC) == TRUE){iContador = iContador + 1;}  //Fuego de alquimista.
        if(GetHasFeat(1763, oPC) == TRUE){iContador = iContador + 1;}  //Rociador del amor.
    }
    if(iNivel == 3)
    {
        //Artillero
        if(GetHasFeat(1746, oPC) == TRUE){iContador = iContador + 1;}  //Bazooka de fuerza.
        if(GetHasFeat(1747, oPC) == TRUE){iContador = iContador + 1;}  //Protector.
        if(GetHasFeat(1748, oPC) == TRUE){iContador = iContador + 1;}  //Disipador.

        //Armero
        if(GetHasFeat(1755, oPC) == TRUE){iContador = iContador + 1;}  //Campo antimagia.
        if(GetHasFeat(1756, oPC) == TRUE){iContador = iContador + 1;}  //Campo antidaño.
        if(GetHasFeat(1757, oPC) == TRUE){iContador = iContador + 1;}  //Repeler.

        //Armero
        if(GetHasFeat(1764, oPC) == TRUE){iContador = iContador + 1;}  //Bomba de potenciación.
        if(GetHasFeat(1765, oPC) == TRUE){iContador = iContador + 1;}  //Bomba TNT.
        if(GetHasFeat(1766, oPC) == TRUE){iContador = iContador + 1;}  //Bomba del cambiazo.
    }
    return iContador;
}

int iLeerRestantes (object oPC, int iNivel)
{
    int iHuecos1, iHuecos2, iHuecos3;
    int iContador;

    //¿Cuántos huecos puede tener?
    if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 5 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <7)
    {
        iHuecos1 = 1;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 7 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <9)
    {
        iHuecos1 = 2;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 9 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <10)
    {
        iHuecos1 = 3;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 10 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <12)
    {
        iHuecos1 = 3;
        iHuecos2 = 1;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 12 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <14)
    {
        iHuecos1 = 3;
        iHuecos2 = 2;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 14 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <15)
    {
        iHuecos1 = 3;
        iHuecos2 = 3;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 15 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <17)
    {
        iHuecos1 = 3;
        iHuecos2 = 3;
        iHuecos3 = 1;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 17 && GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) <19)
    {
        iHuecos1 = 3;
        iHuecos2 = 3;
        iHuecos3 = 2;
    }
    else if(GetLevelByClass(CLASS_TYPE_INGENIERO, oPC) >= 19)
    {
        iHuecos1 = 3;
        iHuecos2 = 3;
        iHuecos3 = 3;
    }

    if(iNivel == 1)
    {
        iContador = iHuecos1 - iLeerInfusiones (oPC, 1);
    }
    if(iNivel == 2)
    {
        iContador = iHuecos2 - iLeerInfusiones (oPC, 2);
    }
    if(iNivel == 3)
    {
        iContador = iHuecos3 - iLeerInfusiones (oPC, 3);
    }
    return iContador;
}

void AdaptarLongitudItem(object oItem, int iDistancia)
{
    //Primero borramos las propiedades.
    RemoveItemProperty(oItem,ItemPropertyCastSpell(335,13));   //Activamos sobre sí mismo.
    RemoveItemProperty(oItem,ItemPropertyCastSpell(537,13));   //Activamos en toque.
    RemoveItemProperty(oItem,ItemPropertyCastSpell(329,13));   //Activamos en corta distancia.
    RemoveItemProperty(oItem,ItemPropertyCastSpell(513,13));   //Activamos a larga distancia

    itemproperty iProp;
    if(iDistancia == 1)
    {
        iProp = ItemPropertyCastSpell(335,13);
    }
    else if(iDistancia == 2)
    {
        iProp = ItemPropertyCastSpell(537,13);
    }
    else if(iDistancia == 3)
    {
        iProp = ItemPropertyCastSpell(329,13);
    }
    else if(iDistancia == 4)
    {
        iProp = ItemPropertyCastSpell(513,13);
    }
    IPSafeAddItemProperty(oItem, iProp);
}

void ImpactosSecundarios(object oPC, object oTarget, int iDanoTipo, int iDano, int iCD, int iVisual, int iSpell)
{
    int nHit;
    iDano = d6(2);
    //Si son PJs, la variable antispam, se guarda en el Modulo.
    if (!GetIsDead(oTarget))
    {
        if(!MySavingThrow(SAVING_THROW_REFLEX, oTarget, iCD,  SAVING_THROW_TYPE_FIRE, oPC))
        {
            //Aplicamos los efectos correspondientes.
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(iDano, iDanoTipo), oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iVisual), oTarget);
            SetLocalInt(oTarget,"CLS_ING_IMPACTOS",GetLocalInt(oTarget, "CLS_ING_IMPACTOS") + 1);
            if(GetLocalInt(oTarget, "CLS_ING_IMPACTOS") <6)
            {
                DelayCommand(6.0,ImpactosSecundarios(oPC, oTarget, iDanoTipo, iDano, iCD, iVisual, iSpell));
            }
            if(GetLocalInt(oTarget, "CLS_ING_IMPACTOS") == 6){DeleteLocalInt(oTarget,"CLS_ING_IMPACTOS");}
        }
        else DeleteLocalInt(oTarget,"CLS_ING_IMPACTOS");
    }
    else DeleteLocalInt(oTarget,"CLS_ING_IMPACTOS");
}

void BorrarAreasEfecto (object oPC, string iTag)
{
    object oArea = GetFirstObjectInArea(GetArea(oPC));
    while(GetIsObjectValid(oArea))
    {
        if(GetObjectType(oArea) == OBJECT_TYPE_AREA_OF_EFFECT && GetTag(oArea) == iTag && GetAreaOfEffectCreator(oArea) == oPC)
        {
            DestroyObject(oArea);
        }
        oArea = GetNextObjectInArea(GetArea(oPC));
    }
}

int iCDING (object oPC)
{
    //Calculo de CDs.
    //10 + (Nivel Artífice/2) + Inteligencia.
    int iNivelClase = GetLevelByClass(CLASS_TYPE_INGENIERO,oPC)/2;
    if(iNivelClase > 10){iNivelClase = 10;}
    int iCantidad = 10 + iNivelClase + GetAbilityModifier(ABILITY_INTELLIGENCE,oPC);
    //+2 si tiene la dote Nacido en Lantan.
    if(NWNX_Creature_GetKnowsFeat(oPC,1590)){iCantidad = iCantidad + 2;}
    return iCantidad;
}

int iDANOING (object oPC)
{
    int iDamage;
    //Artillero, más daño.
    if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") == 1)
    {
        iDamage =  d8(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC)/2);
        //Añadimos un 1d6 por cada dote de Mejorar Artificio.
        if(NWNX_Creature_GetKnowsFeat(oPC,1591)){iDamage = iDamage + d8();}
        if(NWNX_Creature_GetKnowsFeat(oPC,1592)){iDamage = iDamage + d8();}
        if(NWNX_Creature_GetKnowsFeat(oPC,1594)){iDamage = iDamage + d8();}
    }
    if(ObtenerIntPersistente(oPC,"CLS_ING_TIPO") > 1)
    {
        iDamage =  d6(GetLevelByClass(CLASS_TYPE_INGENIERO,oPC)/2);
        //Añadimos un 1d6 por cada dote de Mejorar Artificio.
        //Añadimos un 1d6 por cada dote de Mejorar Artificio.
        if(NWNX_Creature_GetKnowsFeat(oPC,1591)){iDamage = iDamage + d6();}
        if(NWNX_Creature_GetKnowsFeat(oPC,1592)){iDamage = iDamage + d6();}
        if(NWNX_Creature_GetKnowsFeat(oPC,1594)){iDamage = iDamage + d6();}
    }
    return iDamage;
}

void AlturaBerserker(object oPC, float faltura)
{
    SetObjectVisualTransform(oPC, OBJECT_VISUAL_TRANSFORM_SCALE, faltura);
}

void Tiempo (object oPC, string sNombre)
{
    //Si el tiempo ha pasado.
    if(GetLocalInt(oPC,"CLS_ING_TSPELLUSADO") <= SQLite_GetTimeStamp())
    {
        SendMessageToPC(oPC, "<c þ >¡Ya puedes cambiar de Infusión!</c>");
    }

}


//void main(){}
