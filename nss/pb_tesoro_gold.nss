//------------------------------------------------------------------------------
//  Libreria para la generacion de tesoro monetario y gemas.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

//--- Metodos publicos ---------------------------------------------------------

//Metodo para dar monedas de oro.
void addGold(object oTarget, int nDG);

//Metodo para dar una gema
void addGem(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1);
//..............................................................................

void addGold(object oTarget, int nDG) {
    int nGold = 0;
    int nMonton;

    if(nDG <= 9) {
        nGold = (50 * nDG) + d10(1); //nGold = (500 * nDG) + d10(1);
    } else if(nDG <= 19) {
        nGold = (100 * nDG) + (d6(2) * 100) + d10(1); //nGold = (750 * nDG) + (d6(2) * 100) + d10(1);
    } else if(nDG <= 29) {
        nGold = (200 * nDG) + (d6(3) * 100) + d10(2); //nGold = (1000 * nDG) + (d6(3) * 100) + d10(2);
    } else if(nDG <= 39) {
        nGold = (300 * nDG) + (d6(4) * 100) + d10(3); //nGold = (1250 * nDG) + (d6(4) * 100) + d10(3);
    } else {
        nGold = (500 * nDG) + (d6(5) * 100) + d10(4); //nGold = (1500 * nDG) + (d6(5) * 100) + d10(4);
    }

    while(nGold > 0) {
        //Crea el oro en montones de 50.000 piezas de oro, pues no permite
        //generar montones de oro de mayor cantidad pese a que luego si
        //se apila dentro de la criatura.
        if(nGold > 50000) {
            nMonton = 50000;
            nGold -= 50000;
        } else {
            nMonton = nGold;
            nGold = 0;
        }
        CreateItemOnObject("NW_IT_GOLD001", oTarget, nMonton);
    }
}

//Metodo privado para sortear un tipo de gema.
string getGem(){
    string sResref;
    switch(Random(42)+1) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:  sResref = "nw_it_gem00" + IntToString(Random(9)+1);  break;
        case 10:
        case 11:
        case 12:
        case 13:
        case 14:
        case 15: sResref = "nw_it_gem0" + IntToString(Random(6)+10);  break;
        case 16: sResref = "aguamarina"; break;
        case 17: sResref = "ambar"; break;
        case 18: sResref = "crisoberilo"; break;
        case 19: sResref = "diopsidoestrella"; break;
        case 20: sResref = "jacinto"; break;
        case 21: sResref = "lapislazuli"; break;
        case 22: sResref = "perla"; break;
        case 23: sResref = "piedralunar"; break;
        case 24: sResref = "piedrasangrienta"; break;
        case 25: sResref = "shandon"; break;
        case 26: sResref = "turquesa"; break;
        case 27: sResref = "zafiroestrellado"; break;
        case 28: sResref = "azurita"; break;
        case 29: sResref = "rodocrosita"; break;
        case 30: sResref = "cornalina"; break;
        case 31: sResref = "espinelaroja"; break;
        case 32: sResref = "perlanegra"; break;
        case 33: sResref = "corindonviolado"; break;
        case 34: sResref = "diamanteazulado"; break;
        case 35: sResref = "iolita"; break;
        case 36: sResref = "ojodetigre"; break;
        case 37: sResref = "crisoprasa"; break;
        case 38: sResref = "circon"; break;
        case 39: sResref = "calcedonia"; break;
        case 40: sResref = "jaspe"; break;
        case 41: sResref = "jade"; break;
        case 42: sResref = "turmalina"; break;
    }

    return sResref;
}

void addGem(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1) {
    int nCantidad;
    object oGema;

    //Obtenemos la cantidad de gemas en funcion del nivel del personaje
    if(nDG <= 9) {
        nCantidad = d3(1);
    } else if(nDG <= 19) {
        nCantidad = d6(1);
    } else if(nDG <= 29) {
        nCantidad = d4(2);
    } else if(nDG <= 39) {
        nCantidad = d4(2)+2;
    } else {
        nCantidad = d6(2)+3;
    }
    if (iAle==FALSE){nCantidad = iVal; }
    while(nCantidad > 0) {
        //Sorteamos tantas gemas aleatorias como nos de la cantidad.
        oGema = CreateItemOnObject(getGem(), oTarget);

        //Establecemos sus propiedades.
        SetDroppableFlag(oGema, TRUE);  //Tirable
        SetPlotFlag(oGema, FALSE);      //Objeto de trama
        SetIdentified(oGema, TRUE);     //Identificado

        //Si la gema tiene un valor superior a 200 monedas sale sin identificar
        if(GetGoldPieceValue(oGema) > 200) SetIdentified(oGema, FALSE);
        if (iTienda==TRUE){SetIdentified(oGema, TRUE);}
        SetLocalInt(oGema, "PCItem", 1);
        nCantidad--;
    }
}

