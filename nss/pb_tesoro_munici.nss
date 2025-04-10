//------------------------------------------------------------------------------
//  Libreria para la generacion de municion, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

//--- Metodos publicos ---------------------------------------------------------
void crearMunicion(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearMunicion(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int nTirada = Random(3);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Virotes
            bMale = TRUE;
            switch(d4()) {
                case 1: sResref = "nw_wammbo010"; break;
                case 2: sResref = "x2_wammbo001"; break;
                case 3: sResref = "nw_wammbo00" + IntToString(Random(9)+1); break;
                case 4: sResref = "x2_wammbo01" + IntToString(Random(2)+1); break;
            }

            switch(d6()) {
                case 1: sNombre = "Virotes"; break;
                case 2:
                    sNombre = "Lanzas aéreas";
                    bMale = FALSE;
                    break;
                case 3: sNombre = "Alfileres mortales"; break;
                case 4: sNombre = "Aguijones"; break;
                case 5:
                    sNombre = "Asesinas aéreas";
                    bMale = FALSE;
                    break;
                case 6: sNombre = "Gorrión sangriento"; break;
            }
            break;
        case 1: // Flechas
            bMale = FALSE;
            switch(d4()) {
                case 1: sResref = "x2_wammar001"; break;
                case 2: sResref = "nw_wammar00" + IntToString(Random(9)+1); break;
                case 3: sResref = "nw_wammar01" + IntToString(Random(2)); break;
                case 4: sResref = "x2_wammar01" + IntToString(Random(2)+2); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Flechas"; break;
                case 2:  sNombre = "Flechas de hierro"; break;
                case 3:  sNombre = "Cortadoras del viento"; break;
                case 4:
                    sNombre = "Ojos élficos";
                    bMale = TRUE;
                    break;
                case 5:
                    sNombre = "Cuernos de pegaso";
                    bMale = TRUE;
                    break;
                case 6:  sNombre = "Buscadoras sangrientas"; break;
            }
            break;
        case 2: // Balas
            bMale = FALSE;
            switch(d4()) {
                case 1: sResref = "nw_wammbu010"; break;
                case 2: sResref = "x2_wammbu009"; break;
                case 3: sResref = "x2_wammbu010"; break;
                case 4: sResref = "nw_wammbu00" + IntToString(Random(9)+1); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Balas"; break;
                case 2:  sNombre = "Balas pesadas"; break;
                case 3:  sNombre = "Rocas afiladas"; break;
                case 4:  sNombre = "Piedras gruesas"; break;
                case 5:  sNombre = "Manos medianas"; break;
                case 6:  sNombre = "Ofensiva de Gond"; break;
            }
            break;
    }

    sNombre = nombrarObjeto(sNombre, nDG, bMale);
    object oCreado = CreateItemOnObject(sResref, oTarget);
    SetDroppableFlag(oCreado, TRUE);
    SetItemCursedFlag(oCreado, FALSE);
    SetIdentified(oCreado, TRUE);
    SetItemStackSize(oCreado, 99);
    SetStolenFlag(oCreado, TRUE);
    SetPlotFlag(oCreado, FALSE);
    SetName(oCreado, sNombre);
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoMunicion(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
    SetIdentified(oCreado, TRUE);
}
