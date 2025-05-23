//------------------------------------------------------------------------------
//  Libreria para la generacion de armas a distancia, reutilizado codigo de
//  monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

#include "pb_tesoro_sorteo"
#include "pb_tesoro_nombre"

//--- Metodos publicos ---------------------------------------------------------
void crearArmaDI(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0);
//..............................................................................

void crearArmaDI(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=0) {
    string sResref;
    string sNombre;
    int bMale;
    int nCantidad = 0;
    int nTirada = Random(5);
    if (iAle==FALSE){nTirada = iVal; }

    switch(nTirada) {
        case 0: // Dardos
            bMale = TRUE;
            switch(d3()) {
                case 1: sResref = "nw_wthmdt00" + IntToString(Random(8)+2); break;
                case 2: sResref = "x0_wthmdt00" + IntToString(Random(2)+1); break;
                case 3: sResref = "x2_wthmdt00" + IntToString(Random(2)+3); break;
            }

            switch(d6()){
                case 1:  sNombre = "Dardo"; break;
                case 2:
                    sNombre = "Cornadas";
                    bMale = FALSE;
                    break;
                case 3:  sNombre = "Golpetazo de draco"; break;
                case 4:
                    sNombre = "Astillas de hierro";
                    bMale = FALSE;
                    break;
                case 5:
                    sNombre = "Púas de mantícora";
                    bMale = FALSE;
                    break;
                case 6:  sNombre = "El último suspiro"; break;
            }
            nCantidad = 50;
            break;
        case 1: // Shuriken
            bMale = FALSE;
            switch(d3()) {
                case 1: sResref = "nw_wthmsh00" + IntToString(Random(8)+2); break;
                case 2: sResref = "x0_wthmsh00" + IntToString(Random(2)+1); break;
                case 3: sResref = "x2_wthmsh00" + IntToString(Random(2)+3); break;
            }

            switch(d6()) {
                case 1:
                    sNombre = "Shuriken";
                    bMale = TRUE;
                    break;
                case 2:  sNombre = "Estrella ninja"; break;
                case 3:  sNombre = "Amenaza oriental"; break;
                case 4:  sNombre = "Estrellas"; break;
                case 5:
                    sNombre = "Cortacuellos";
                    bMale = TRUE;
                    break;
                case 6:  sNombre = "Trituradoras"; break;
            }
            nCantidad = 50;
            break;
        case 2: // Ballestas
            bMale = FALSE;
            switch(d6()) {
                case 1: sResref = "nw_wbwmxl00" + IntToString(Random(8)+2); break;
                case 2: sResref = "x0_wbwmxl00" + IntToString(Random(2)+1); break;
                case 3: sResref = "x2_wbwmxl00" + IntToString(Random(3)+3); break;
                case 4: sResref = "nw_wbwmxh00" + IntToString(Random(8)+2); break;
                case 5: sResref = "x0_wbwmxh00" + IntToString(Random(2)+1); break;
                case 6: sResref = "x2_wbwmxh00" + IntToString(Random(3)+3);break;
            }

            switch(d6()) {
                case 1:  sNombre = "Cuerdas de acero"; break;
                case 2:  sNombre = "Ballesta de batalla"; break;
                case 3:
                    sNombre = "Lanza-proyectiles";
                    bMale = TRUE;
                    break;
                case 4:  sNombre = "Ballesta de la guardia de Amn"; break;
                case 5:
                    sNombre = "Honor del Imperio";
                    bMale = TRUE;
                    break;
                case 6:  sNombre = "Tiradora de la Espesura"; break;
            }
            break;
        case 3: // Arcos
            bMale = TRUE;
            switch(Random(11)) {
                case 0: sResref = "zep_wolbw_001"; break;
                case 1: sResref = "zep_daikyu"; break;
                case 2: sResref = "x2_wbwmln010"; break;
                case 3: sResref = "nw_wbwmln00" + IntToString(Random(8)+2); break;
                case 4: sResref = "nw_wbwmln01" + IntToString(Random(3)); break;
                case 5: sResref = "x0_wbwmln00" + IntToString(Random(4)+1); break;
                case 6: sResref = "x2_wbwmln00" + IntToString(Random(5)+5); break;
                case 7: sResref = "nw_wbwmsh00" + IntToString(Random(8)+2); break;
                case 8: sResref = "nw_wbwmsh01" + IntToString(Random(3)); break;
                case 9: sResref = "x0_wbwmsh00" + IntToString(Random(4)+1); break;
                case 10: sResref = "x2_wbwmsh00" + IntToString(Random(5)+5); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Arco de asedio"; break;
                case 2:  sNombre = "Arco élfico de batalla"; break;
                case 3:  sNombre = "Unión de la naturaleza"; break;
                case 4:
                    sNombre = "Cuerda sangrienta";
                    bMale = FALSE;
                    break;
                case 5:  sNombre = "Arco de guerra de mediano"; break;
                case 6:  sNombre = "Ojo avizor"; break;
            }
            break;
        case 4: // Hondas
            bMale = FALSE;
            switch(d4()) {
                case 1: sResref = "nw_wbwmsl010"; break;
                case 2: sResref = "nw_wbwmsl00" + IntToString(Random(6)+3); break;
                case 3: sResref = "x0_wbwmsl00" + IntToString(Random(2)+1); break;
                case 4: sResref = "x2_wbwmsl00" + IntToString(Random(3)+3); break;
            }

            switch(d6()) {
                case 1:  sNombre = "Honda buscadora"; break;
                case 2:  sNombre = "Lanzapiedras"; break;
                case 3:  sNombre = "Ira del mediano"; break;
                case 4:
                    sNombre = "Corazón de Arvorín";
                    bMale = TRUE;
                    break;
                case 5:
                    sNombre = "Cuero tensado";
                    bMale = TRUE;
                    break;
                case 6:  sNombre = "Persecución nómada"; break;
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
    if(nCantidad > 0) {
        SetItemStackSize(oCreado, nCantidad);
    }
    SetDescription(oCreado, "Puedes notar cómo este objeto contiene encantamientos, pero no lleva el sello de ningún fabricante. Su historia y leyenda son aparentemente desconocidas, sólo conoces que lo rescataste de las garras de "+GetName(OBJECT_SELF)+". A partir de ahora tú serás su nuevo propietario, el amo y señor de los relatos venideros de este objeto mágico.");

    limpiarObjeto(oCreado);
    sorteoArmasDI(oCreado, nDG);
    if (iTienda==TRUE){SetIdentified(oCreado, TRUE);} else {SetIdentified(oCreado, FALSE);}
    SetLocalInt(oCreado, "PCItem", 1);
}
