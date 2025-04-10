//------------------------------------------------------------------------------
//  Libreria para la generacion de propiedades en objetos.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................
#include "pb_tesoro_propie"

//--- Metodos publicos ---------------------------------------------------------
void sorteoArmasCC(object oItem, int nDG, int bAtVs);
void sorteoArmasDI(object oItem, int nDG);
void sorteoMunicion(object oItem, int nDG);
void sorteoBastones(object oItem, int nDG);
void sorteoCetros(object oItem, int nDG);
void sorteoArmaduras(object oItem, int nDG);
void sorteoEscudos(object oItem, int nDG);

//Anillos, amuletos, botas, capas, cinturones, guanteles, yelmos
void sorteoMiscelaneas(object oItem, int nDG, int nCA, int nAbility, int bDote);

//Limpiar objeto.
void limpiarObjeto(object oItem);
//..............................................................................

void limpiarObjeto(object oItem) {
    itemproperty iSearch = GetFirstItemProperty(oItem);
    while(GetIsItemPropertyValid(iSearch)) {
        RemoveItemProperty(oItem, iSearch);
        iSearch = GetNextItemProperty(oItem);
    }
}

int getPropiedades(int nDG) {
    int nPropiedades;

    if(nDG <= 9) {
        nPropiedades = d2();//d3() 1 ó 2
    } else if(nDG <= 19) {
        nPropiedades = 2; //d3();  2
    } else if(nDG <= 29) {
        nPropiedades = d2()+1; // 2 ó 3
    } else if(nDG <= 39) {
        nPropiedades = 3; //d2()+2  3
    } else {
        nPropiedades = d2()+2;  //d2()+3   3 ó 4
    }

    return nPropiedades;
}

void sorteoArmasCC(object oItem, int nDG, int bAtVs) {
    int nProp = getPropiedades(nDG);
    int bAfilada = FALSE;
    int bLuz = FALSE;
    int bImpactar = FALSE;
    int bAtaque = FALSE;
    int nDamage = 0;
    int nDamage2 = 0;
    int nDamageVs = 0;
    int bCriticos = FALSE;
    int bReduccionPeso = FALSE;
    int nDamageType = 0;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    while(nProp > 0) {
        switch(Random(7)) {
            case 0:
                if(!bAfilada) {
                    setAfliadura(oItem);
                    bAfilada = TRUE;
                    nProp--;
                }
                break;

            case 1:
                if(!bImpactar) {
                    setAlImpactar(oItem, nDG);
                    bImpactar = TRUE;
                    nProp--;
                }
                break;
            case 2:
                if(!bAtaque) {
                    setBonoAtaque(oItem, nDG);
                    bAtaque = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(bAtVs) {
                    if(!bAtaque) {
                        setBonoAtaqueVs(oItem, nDG);
                        bAtaque = TRUE;
                        nProp--;
                    }
                }
                break;

            case 4:
                if(nDG >= 30) {
                    if(nDamage == 1 && nDamage2==0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage = 2;
                        //nProp--;
                    }
                }
                if(nDamage == 0 && nDamage2<2) {
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage = 1;
                   // nProp--;
                }
                nProp--;
                break;

            case 5:
                if(bAtVs) {
                    if(!bCriticos) {
                        setCriticos(oItem, nDG);
                        bCriticos = TRUE;
                        nProp--;
                    }
                }
                break;
            case 6:
                if(nDG >= 30) {
                    if(nDamage2 == 1 && nDamage == 0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage2 = 2;
                        //nProp--;
                    }
                }
                if(nDamage2 == 0 && nDamage <2) {
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage2 = 1;
                    //nProp--;
                }
                nProp--;
                break;
           /*case 8:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;
           case 9:
                if(d100() <= 30) {
                    if(!bReduccionPeso) {
                        setReducirPeso(oItem, nDG);
                        bReduccionPeso = TRUE;
                    }
                }
                break;
           case 5:
                if(nDG >= 20) {
                    if(nDamageVs == 1) {
                        setDamageSecundaryVs(oItem);
                        nDamageVs = 2;
                        nProp--;
                    }
                }
                if(nDamageVs == 0) {
                    nDamageType = setDamagePrimaryVs(oItem, nDG, nDamageType);
                    nDamageVs = 1;
                    nProp--;
                }
                break;  */
        }
    }
}

void sorteoArmasDI(object oItem, int nDG) {
    int nProp = getPropiedades(nDG);
    int bAfilada = FALSE;
    int bLuz = FALSE;
    int bImpactar = FALSE;
    int bAtaque = FALSE;
    int nDamage = 0;
    int nDamage2=0;
    int nDamageVs = 0;
    int bCriticos = FALSE;
    int bReforzado = FALSE;
    int bReduccionPeso = FALSE;
    int nDamageType = 0;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    while(nProp > 0) {
        switch(Random(8)) {
            case 0:
                if(!bAfilada) {
                    setAfliadura(oItem);
                    bAfilada = TRUE;
                    nProp--;
                }
                break;

            case 1:
                if(!bImpactar) {
                    setAlImpactar(oItem, nDG);
                    bImpactar = TRUE;
                    nProp--;
                }
                break;
            case 2:
                if(!bAtaque) {
                    setBonoAtaque(oItem, nDG);
                    bAtaque = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(!bAtaque) {
                    setBonoAtaqueVs(oItem, nDG);
                    bAtaque = TRUE;
                    nProp--;
                }
                break;
            case 4:
                if(nDG >= 30) {
                    if(nDamage == 1 && nDamage2==0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage = 2;
                        nProp--;
                    }
                }
                if(nDamage == 0 && nDamage2<2) {
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage = 1;
                    nProp--;
                }
                break;

            case 5:
                if(!bCriticos) {
                    setCriticos(oItem, nDG);
                    bCriticos = TRUE;
                    nProp--;
                }
                break;
            case 6:
                if(!bReforzado) {
                    setReforzado(oItem, nDG);
                    bReforzado = TRUE;
                    nProp--;
                }
                break;
             case 7:
                if(nDG >= 30) {
                    if(nDamage2 == 1 && nDamage==0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage2 = 2;
                        nProp--;
                    }
                }
                if(nDamage2 == 0 && nDamage<2) {
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage2 = 1;
                    nProp--;
                }
                break;
            /*case 1:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;

            case 9:
                if(d100() <= 30) {
                    if(!bReduccionPeso) {
                        setReducirPeso(oItem, nDG);
                        bReduccionPeso = TRUE;
                    }
                }
                break;
            case 5:
                if(nDG >= 20) {
                    if(nDamageVs == 1) {
                        setDamageSecundaryVs(oItem);
                        nDamageVs = 2;
                        nProp--;
                    }
                }
                if(nDamageVs == 0) {
                    nDamageType = setDamagePrimaryVs(oItem, nDG, nDamageType);
                    nDamageVs = 1;
                    nProp--;
                }
                break; */
        }
    }
}

void sorteoMunicion(object oItem, int nDG) {
    int nProp = getPropiedades(nDG);
    int bImpactar = FALSE;
    int nDamage = 0;
    int nDamage2= 0;
    int nDamageVs = 0;
    int nDamageType = 0;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    while(nProp > 0) {
        switch(Random(3)) {
            case 0:
                if(!bImpactar) {
                    setAlImpactar(oItem, nDG);
                    bImpactar = TRUE;
                    nProp--;
                }
                break;
            case 1:
                if(nDG >= 30) {
                    if(nDamage == 1 && nDamage2==0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage = 2;
                        //nProp--;
                    }
                }
                if(nDamage == 0 && nDamage2<1) {//2
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage = 1;
                    //nProp--;
                }
                nProp--;
                break;

           case 2:
                if(nDG >= 30) {
                    if(nDamage2 == 1 && nDamage==0) {
                        setDamageSecundary(oItem, nDG);
                        nDamage2 = 2;
                        //nProp--;
                    }
                }
                if(nDamage2 == 0 && nDamage<1) {//2
                    nDamageType = setDamagePrimary(oItem, nDG, nDamageType);
                    nDamage2 = 1;
                    //nProp--;
                }
                nProp--;
                break;

          /* case 2:
                if(nDG >= 20) {
                    if(nDamageVs == 1) {
                        setDamageSecundaryVs(oItem);
                        nDamageVs = 2;
                        nProp--;
                    }
                }
                if(nDamageVs == 0) {
                    nDamageType = setDamagePrimaryVs(oItem, nDG, nDamageType);
                    nDamageVs = 1;
                    nProp--;
                }
                break; */
        }
    }
}

void sorteoBastones(object oItem, int nDG) {
    int nProp = getPropiedades(nDG);
    int bLuz = FALSE;
    int bImpactar = FALSE;
    int bTS = FALSE;
    int bAbility = FALSE;
    int bSkill = FALSE;
    int bSpellSpace = FALSE;
    int bReduccionPeso = FALSE;
    int bSpellUse = FALSE;
    int bCA = FALSE;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    while(nProp > 0) {
        switch(Random(7)) {

            case 0:
                if(!bImpactar) {
                    setAlImpactar(oItem, nDG);
                    bImpactar = TRUE;
                    nProp--;
                }
                break;
            case 1:
                if(!bTS) {
                    setTS(oItem, nDG);
                    bTS = TRUE;
                    nProp--;
                }
                break;
            case 2:
                if(!bAbility) {
                    setCaracteristica(oItem, nDG);
                    bAbility = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(!bSkill) {
                    setHabilidad(oItem, nDG);
                    bSkill = TRUE;
                    nProp--;
                }
                break;
            case 4:
                if(!bSpellSpace) {
                    setEspacioConjuro(oItem, nDG, TRUE);
                    bSpellSpace = TRUE;
                    nProp--;
                }
                break;

            case 5:
                if(!bSpellUse) {
                    setSpellUse(oItem, nDG);
                    bSpellUse = TRUE;
                    nProp--;
                }
                break;
            case 6:
                if(!bCA) {
                    if(nProp < 2 && nDG >= 40) {
                        //Los objetos titanicos siempre dan CA 5, por lo
                        //tanto, no pueden salir si no quedan huecos.
                    } else {
                        int nVal = setCA(oItem, nDG, nProp);
                        bCA = TRUE;
                        /*if(nVal == 5) {
                            nProp -= 2;
                        } else { */
                            nProp--;
                        //}
                    }
                }
                break;
             /*case 7:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;

                case 8:
                if(d100() <= 30) {
                    if(!bReduccionPeso) {
                        setReducirPeso(oItem, nDG);
                        bReduccionPeso = TRUE;
                    }
                }
                break;*/
        }
    }
    setOnlyMW(oItem);
}

void sorteoCetros(object oItem, int nDG) {
    setSpellUse(oItem, nDG);
}

void sorteoArmaduras(object oItem, int nDG){
    int nProp = getPropiedades(nDG);
    int bLuz = FALSE;
    int bTS = FALSE;
    int bCA = FALSE;
    int bAbility = FALSE;
    int bSkill = FALSE;
    int bSpellFailure = FALSE;
    int bSpellSpace = FALSE;
    int bReduccionDamage = FALSE;
    int bReduccionPeso = FALSE;
    int bRegeneracion = FALSE;
    //int bResistenciaDamage = FALSE;
    int bImmunidadDamage = FALSE;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    if(d100() <= 90) {
        if(nProp < 2 && nDG >= 40) {
            //Los objetos titanicos siempre dan CA 5, por lo
            //tanto, no pueden salir si no quedan huecos.
        } else {
            int nVal = setCA(oItem, nDG, nProp);
            bCA = TRUE;
            /*if(nVal == 5) {
                nProp -= 2;
            } else { */
                nProp--;
            //}
        }
    }
    while(nProp > 0) {
        switch(Random(9)) {

            case 0:
                if(!bTS) {
                    setTS(oItem, nDG);
                    bTS = TRUE;
                    nProp--;
                }
                break;
            case 1:
                if(!bCA) {
                    if(nProp < 2 && nDG >= 40) {
                        //Los objetos titanicos siempre dan CA 5, por lo
                        //tanto, no pueden salir si no quedan huecos.
                    } else {
                        int nVal = setCA(oItem, nDG, nProp);
                        bCA = TRUE;
                        /*if(nVal == 5) {
                            nProp -= 2;
                        } else {*/
                            nProp--;
                       // }
                    }
                }
                break;
            case 2:
                if(!bAbility) {
                    setCaracteristica(oItem, nDG);
                    bAbility = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(!bSkill) {
                    setHabilidad(oItem, nDG);
                    bSkill = TRUE;
                    nProp--;
                }
                break;
            case 4:
                if(nDG >= 10) {
                    if(!bSpellFailure) {
                        setFalloConjuro(oItem, nDG);
                        bSpellFailure = TRUE;
                        nProp--;
                    }
                }
                break;
            case 5:
                if(!bSpellSpace) {
                    setEspacioConjuro(oItem, nDG);
                    bSpellSpace = TRUE;
                    nProp--;
                }
                break;
            case 6:
                if(nDG >= 10) {
                    if(!bReduccionDamage) {
                        if(nProp >= 2) {
                            setReduccion(oItem, nDG);
                            bReduccionDamage = TRUE;
                            nProp -= 2;
                        }
                    }
                }
                break;

            case 7:
                if(nDG >= 20){
                    if(!bRegeneracion) {
                        setRegeneracion(oItem);
                        bRegeneracion = TRUE;
                        nProp--;
                    }
                }
                break;
            case 8:
                if(nDG >= 10) {
                    if(!bImmunidadDamage) {
                        setDamageInumity(oItem, nDG);
                        bImmunidadDamage = TRUE;
                        nProp--;
                    }
                }
                break;
            /*case 0:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;
                case 8:
                if(d100() <= 30) {
                    if(!bReduccionPeso) {
                        setReducirPeso(oItem, nDG);
                        bReduccionPeso = TRUE;
                    }
                }
                break;
                case 8:
                if(nDG >= 10) {
                    if(!bResistenciaDamage) {
                        setResistencia(oItem, nDG);
                        bResistenciaDamage = TRUE;
                        nProp--;
                    }
                }
                break;
                */
        }
    }
}

void sorteoEscudos(object oItem, int nDG){
    int nProp = getPropiedades(nDG);
    int bLuz = FALSE;
    int bTS = FALSE;
    int bCA = FALSE;
    int bAbility = FALSE;
    int bSkill = FALSE;
    int bSpellFailure = FALSE;
    int bReduccionDamage = FALSE;
    int bReduccionPeso = FALSE;
    int bRegeneracion = FALSE;
    //int bResistenciaDamage = FALSE;
    int bImmunidadDamage = FALSE;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    if(d100() <= 70) {  //90
        if(nProp < 2 && nDG >= 40) {
            //Los objetos titanicos siempre dan CA 5, por lo
            //tanto, no pueden salir si no quedan huecos.
        } else {
            int nVal = setCA(oItem, nDG, nProp);
            bCA = TRUE;
            /*if(nVal == 5) {
                nProp -= 2;
            } else { */
                nProp--;
            //}
        }
    }
    while(nProp > 0) {
        switch(Random(8)) {

            case 0:
                if(!bTS) {
                    setTS(oItem, nDG);
                    bTS = TRUE;
                    nProp--;
                }
                break;
            case 1:
                if(!bCA) {
                    if(nProp < 2 && nDG >= 40) {
                        //Los objetos titanicos siempre dan CA 5, por lo
                        //tanto, no pueden salir si no quedan huecos.
                    } else {
                        int nVal = setCA(oItem, nDG, nProp);
                        bCA = TRUE;
                        /*if(nVal == 5) {
                            nProp -= 2;
                        } else {*/
                            nProp--;
                        //}
                    }
                }
                break;
            case 2:
                if(!bAbility) {
                    setCaracteristica(oItem, nDG);
                    bAbility = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(!bSkill) {
                    setHabilidad(oItem, nDG);
                    bSkill = TRUE;
                    nProp--;
                }
                break;
            case 4:
                if(nDG >= 10) {
                    if(!bSpellFailure) {
                        setFalloConjuro(oItem, nDG);
                        bSpellFailure = TRUE;
                        nProp--;
                    }
                }
                break;
            case 5:
                if(nDG >= 10) {
                    if(!bReduccionDamage) {
                        if(nProp >= 2) {
                            setReduccion(oItem, nDG);
                            bReduccionDamage = TRUE;
                            nProp -= 2;
                        }
                    }
                }
                break;

            case 6:
                if(nDG >= 20){
                    if(!bRegeneracion) {
                        setRegeneracion(oItem);
                        bRegeneracion = TRUE;
                        nProp--;
                    }
                }
                break;
            case 7:
                if(nDG >= 10) {
                    if(!bImmunidadDamage) {
                        setDamageInumity(oItem, nDG);
                        bImmunidadDamage = TRUE;
                        nProp--;
                    }
                }
                break;
             /*case 0:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;
             case 7:
                if(d100() <= 30) {
                    if(!bReduccionPeso) {
                        setReducirPeso(oItem, nDG);
                        bReduccionPeso = TRUE;
                    }
                }
                break;
                case 7:
                if(nDG >= 10) {
                    if(!bResistenciaDamage) {
                        setResistencia(oItem, nDG);
                        bResistenciaDamage = TRUE;
                        nProp--;
                    }
                }
                break;*/
        }
    }
}

void sorteoMiscelaneas(object oItem, int nDG, int nCA, int nAbility, int bDote){
    int nProp = getPropiedades(nDG);
    int bLuz = FALSE;
    int bTS = FALSE;
    int bCA = FALSE;
    int bAbility = FALSE;
    int bSkill = FALSE;
    int bSpellSpace = FALSE;
    int bReduccionDamage = FALSE;
    int bRegeneracion = FALSE;
    int bImmunidadDamage = FALSE;
    //int bResistenciaDamage = FALSE;
    //Si el objeto tiene más de tres propiedades asegurarse que el objeto solo puede ser usado por pj con más de 15 de nivel.
    if (nProp>3) { SetLocalInt(oItem, "masNivel15", 1);}

    if(d100() <= nCA) {
        if(nProp < 2 && nDG >= 40) {
            //Los objetos titanicos siempre dan CA 5, por lo
            //tanto, no pueden salir si no quedan huecos.
        } else {
            int nVal = setCA(oItem, nDG, nProp);
            bCA = TRUE;
            /*if(nVal == 5) {
                nProp -= 2;
            } else {  */
                nProp--;
            //}
        }
    }
    if(d100() <= nAbility) {
        setCaracteristica(oItem, nDG);
        bAbility = TRUE;
        nProp--;
    }
    while(nProp > 0) {
        switch(Random(9)) {

            case 0:
                if(!bTS) {
                    setTS(oItem, nDG);
                    bTS = TRUE;
                    nProp--;
                }
                break;
            case 1:
                if(!bCA) {
                    if(nProp < 2 && nDG >= 40) {
                        //Los objetos titanicos siempre dan CA 5, por lo
                        //tanto, no pueden salir si no quedan huecos.
                    } else {
                        int nVal = setCA(oItem, nDG, nProp);
                        bCA = TRUE;
                        /*if(nVal == 5) {
                            nProp -= 2;
                        } else {  */
                            nProp--;
                        //}
                    }
                }
                break;
            case 2:
                if(!bAbility) {
                    setCaracteristica(oItem, nDG);
                    bAbility = TRUE;
                    nProp--;
                }
                break;
            case 3:
                if(!bSkill) {
                    setHabilidad(oItem, nDG);
                    bSkill = TRUE;
                    nProp--;
                }
                break;
            case 4:
                if(!bSpellSpace) {
                    setEspacioConjuro(oItem, nDG);
                    bSpellSpace = TRUE;
                    nProp--;
                }
                break;
            case 5:
                if(nDG >= 10) {
                    if(!bReduccionDamage) {
                        if(nProp >= 2) {
                            setReduccion(oItem, nDG);
                            bReduccionDamage = TRUE;
                            nProp -= 2;
                        }
                    }
                }
                break;
            case 6:
                if(nDG >= 20){
                    if(!bRegeneracion) {
                        setRegeneracion(oItem);
                        bRegeneracion = TRUE;
                        nProp--;
                    }
                }
                break;
            case 7:
                if(nDG >= 10) {
                    if(!bImmunidadDamage) {
                        setDamageInumity(oItem, nDG);
                        bImmunidadDamage = TRUE;
                        nProp--;
                    }
                }
                break;
            case 8:
                if(nDG >= 10) {
                    if(bDote) {
                        setFeat(oItem, nDG);
                        bDote = FALSE;
                        nProp--;
                    }
                }
                break;
            /*case 0:
                if(nDG >= 10) {
                    if(d100() <= 30) {
                        if(!bLuz) {
                            setLuz(oItem, nDG);
                            bLuz = TRUE;
                        }
                    }
                }
                break;
                case 7:
                if(nDG >= 10) {
                    if(!bResistenciaDamage) {
                        setResistencia(oItem, nDG);
                        bResistenciaDamage = TRUE;
                        nProp--;
                    }
                }
                break;*/
        }
    }
}

//void main(){}
