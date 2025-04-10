//------------------------------------------------------------------------------
//  Libreria para la generacion de propios de mago, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

//--- Metodos publicos ---------------------------------------------------------
void crearBastonMago(object oTarget, int nDG, int iTienda=FALSE);
void crearCetrosVaras(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearBastonMago(object oTarget, int nDG, int iTienda=FALSE) {
    string sResref;
    string sNombre;
    int bMale;

    switch(Random(14)) {
        case 1: sResref = "nw_wmgst00" + IntToString(Random(5)+2); break;
        case 2: sResref = "nw_it_novel008"; break;
        case 3: sResref = "x2_wmgst001"; break;
        case 4: sResref = "x0_cheatstick"; break;
        case 5: sResref = "zep_dragonclawf"; break;
        case 6: sResref = "zep_dragonclawm"; break;
        case 7: sResref = "zep_druidstf"; break;
        case 8: sResref = "zep_druidstm"; break;
        case 9: sResref = "zep_gnarledstaff"; break;
        case 10: sResref = "quarterstaff1"; break;
        case 11: sResref = "item_dagahechi"; break;
        case 12: sResref = "item_dagahechi"; break;
        case 13: sResref = "item_dagahechi"; break;
        case 14: sResref = "item_dagahechi"; break;
    }

    switch(d6()) {
        case 1:
            sNombre = "Bastón de control";
            bMale = TRUE;
            break;
        case 2:
            sNombre = "Canalizador de energía";
            bMale = TRUE;
            break;
        case 3:
            sNombre = "Ira de la naturaleza";
            bMale = FALSE;
            break;
        case 4:
            sNombre = "Castigo divino";
            bMale = TRUE;
            break;
        case 5:
            sNombre = "La mano divina del Dios";
            bMale = FALSE;
            break;
        case 6:
            sNombre = "Cayado de huesos podridos";
            bMale = TRUE;
            break;
    }

    sNombre = nombrarObjeto(sNombre, nDG, bMale);
    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);
    SetName(oCreado, sNombre);
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoBastones(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
}

void crearCetrosVaras(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0){
    string sResref;
    string sNombre;
    int bMale;
    int nTirada = Random(2);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Varitas
            bMale = FALSE;
            switch(Random(9)) {
                case 0: sResref = "nw_wmgwn00" + IntToString(Random(8)+2); break;
                case 1: sResref = "nw_wmgwn01" + IntToString(Random(4)); break;
                case 2: sResref = "varitaderociada"; break;
                case 3: sResref = "varitadeproye3_1"; break;
                case 4: sResref = "drow_proy_m"; break;
                case 5: sResref = "varitacurativa" + IntToString(Random(4)+1); break;
                case 6: sResref = "varitadecontag"; break;
                case 7: sResref = "varitadeidenti"; break;
                case 8: sResref = "varitamanosard"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Varita conjuradora"; break;
                case 2:  sNombre = "Varita aplastante"; break;
                case 3:  sNombre = "Varita astral"; break;
                case 4:  sNombre = "Varita tenaz"; break;
                case 5:  sNombre = "Varita psíquica"; break;
                case 6:  sNombre = "Varita tronante"; break;
            }
            break;
        case 1: // Cetros
            bMale = TRUE;
            switch(Random(7)) {
                case 1: sResref = "nw_wmgrd002"; break;
                case 2: sResref = "x2_it_wmgrd001"; break;
                case 3: sResref = "x0_wmgmrd007"; break;
                case 4: sResref = "nw_wmgmrd00" + IntToString(Random(5)+2); break;
                case 5: sResref = "cetroaracnido"; break;
                case 6: sResref = "cs_cetronudill"; break;
                case 7: sResref = "dondelloth"; break;
            }

            switch(d6()) {
                case 1:  sNombre = "Cetro de control mental"; break;
                case 2:  sNombre = "Bastón de mando"; break;
                case 3:  sNombre = "Canalizador de conjuros"; break;
                case 4:  sNombre = "Cetro demoníaco"; break;
                case 5:
                    sNombre = "Vara de hueso";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "Cetro de supremacía"; break;
            }
            break;
    }

    sNombre = nombrarObjeto(sNombre, nDG, bMale);
    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);
    SetName(oCreado, sNombre);
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoCetros(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
}

//void main(){}
