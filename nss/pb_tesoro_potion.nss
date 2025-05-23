//------------------------------------------------------------------------------
//  Libreria para la generacion de pociones, reutilizando codigo de la libreria
//  de monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

//--- Metodos publicos ---------------------------------------------------------

//Metodo para dar un numero determinado de pociones dependiendo de los DG que
//posea la criatura
void addPotion(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1);
//..............................................................................
string getPotion() {

  string sResref;

  switch(Random(76)+1) {
      case 1:
      case 2:
      case 3:
      case 4:  sResref = "x2_it_mpotion001";  break;
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13: sResref = "nw_it_mpotion00" + IntToString(Random(9)+1);  break;
      case 14:
      case 15:
      case 16:
      case 17:
      case 18:
      case 19:
      case 20:
      case 21:
      case 22: sResref = "poti_negativa2";  break;
      case 23: sResref = "poti_negativa";  break;
      case 24: sResref = "nw_it_mpotion0" + IntToString(Random(11)+10);  break;
      case 25: sResref = "sidrademanzana";  break;
      case 26: sResref = "sidradepera";  break;
      case 27: sResref = "vinopurskulcosex";  break;
      case 28: sResref = "vinopurskul";  break;
      case 29: sResref = "vinopurskulocura";  break;
      case 30: sResref = "pocindeaguant";  break;
      case 31: sResref = "pocindearmadu";  break;
      case 32: sResref = "pocindeastuci";  break;
      case 33: sResref = "it_potfoxs";  break;
      case 34: sResref = "pocindeclaria";  break;
      case 35: sResref = "pocindecustod";  break;
      case 36: sResref = "pocindeescudo";  break;
      case 37: sResref = "pocindeesplen";  break;
      case 38: sResref = "pocindefuerza";  break;
      case 39: sResref = "pocindegracia";  break;
      case 40: sResref = "pocindelibert";  break;
      case 41: sResref = "pocindemente";  break;
      case 42: sResref = "pocindepielp";  break;
      case 43: sResref = "pocindepielpma";  break;
      case 44: sResref = "pocindepoder";  break;
      case 45: sResref = "pocindepolimo";  break;
      case 46: sResref = "pocindeprotec";  break;
      case 47: sResref = "pocindeprote2";  break;
      case 48: sResref = "pocindequitarce";  break;
      case 49: sResref = "pocindequitarmi";  break;
      case 50: sResref = "pocindequitaren";  break;
      case 51: sResref = "pocindequitarma";  break;
      case 52: sResref = "pocinderesist2";  break;
      case 53: sResref = "pocinderesistcon";  break;
      case 54: sResref = "pocinderesist";  break;
      case 55: sResref = "pocinderestab";  break;
      case 56: sResref = "pocindesabidu";  break;
      case 57: sResref = "pocindesembla";  break;
      case 58: sResref = "it_potehtrl";  break;
      case 59: sResref = "pocindesoport";  break;
      case 60: sResref = "pocindetransf";  break;
      case 61: sResref = "pocindeultrav";  break;
      case 62: sResref = "pocindeverlo";  break;
      case 63: sResref = "pocindevisin";  break;
      case 64: sResref = "sangrepura";  break;
      case 65: sResref = "sangrevirgen";  break;
      case 66: sResref = "bloodvialempty";  break;
      case 67: sResref = "cervezanorteair";  break;
      case 68: sResref = "uki_bebidarisa";  break;
      case 69: sResref = "uki_bebidasueno";  break;
      case 70: sResref = "uki_bebidaadelg";  break;
      case 71: sResref = "uki_bebidaengor";  break;
      case 72: sResref = "uki_bebidaarbol";  break;
      case 73: sResref = "uki_bebidalucha";  break;
      case 74: sResref = "cervezaalientodr";  break;
      case 75: sResref = "cervezanorteair";  break;
      case 76: sResref = "siempremiel";  break;
  }

  return sResref;
}

void addPotion(object oTarget, int nDG, int iTienda=FALSE, int iAle=TRUE, int iVal=1) {
    int nCantidad;
    string sResref;

    if(nDG <= 9) {
        nCantidad = d2(1);
    } else if(nDG <= 19) {
        nCantidad = d3(1);
    } else if(nDG <= 29) {
        nCantidad = d3(2);
    } else if(nDG <= 39) {
        nCantidad = d4(2);
    } else {
        nCantidad = d6(2);
    }
    if (iAle==FALSE){nCantidad = iVal; }
    while(nCantidad > 0) {
        sResref = getPotion();
        object oPocion = CreateItemOnObject(sResref, oTarget);
        SetDroppableFlag(oPocion, TRUE);
        SetPlotFlag(oPocion, FALSE);

        SetIdentified(oPocion, TRUE);
        if(GetGoldPieceValue(oPocion) > 200) SetIdentified(oPocion, FALSE);
        if (iTienda==TRUE){SetIdentified(oPocion, TRUE);}
        SetLocalInt(oPocion, "PCItem", 1);
        nCantidad--;
    }
}
