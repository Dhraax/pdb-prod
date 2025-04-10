//------------------------------------------------------------------------------
//  Libreria para el coloreado de los objetos. Codigo reutilizado de monti.
//  Creado por: cerril
//  Creado el: 10/01/2017
//..............................................................................

//Constante obtenida del guion pb_tesoro_inc para no tener que importar la libreria.
const string COLORTOKEN ="     !##$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]]^_`abcdefghijklmnopqrstuvwxyz{|}~€‚ƒ„…†‡ˆ‰Š‹Œ‘’“”•–—˜™š›œŸ ¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışş";

string nombrarObjeto(string sNombre, int nDG, int bMale);

//Metodo obtenido y renombrado del guion pb_tesoro_inc para no tener que importar la libreria.
string rgbColor(string sText, int nRed=255, int nGreen=255, int nBlue=255) {
    return "<c" + GetSubString(COLORTOKEN, nRed, 1) + GetSubString(COLORTOKEN, nGreen, 1) + GetSubString(COLORTOKEN, nBlue, 1) + ">" + sText + "</c>";
}

string nombrarObjeto(string sNombre, int nDG, int bMale) {
    string sRetorno;

    if(nDG <= 9) {
        sRetorno = rgbColor(sNombre+" superior", 159, 182, 205);
    } else if(nDG <= 19) {
        if(bMale) {
            sRetorno = rgbColor(sNombre+" encantado", 0, 243, 243);
        } else {
            sRetorno = rgbColor(sNombre+" encantada", 0, 243, 243);
        }
    } else if(nDG <= 29) {
        if(bMale) {
            sRetorno = rgbColor(sNombre+" poderoso", 65, 105, 225);
        } else {
            sRetorno = rgbColor(sNombre+" poderosa", 65, 105, 225);
        }
    } else if(nDG <= 39) {
        if(bMale) {
            sRetorno = rgbColor(sNombre+" legendario", 218, 165, 32);
        } else {
            sRetorno = rgbColor(sNombre+" legendaria", 218, 165, 32);
        }
    } else {
        if(bMale) {
            sRetorno = rgbColor(sNombre+" titánico", 255, 0, 255);
        } else {
            sRetorno = rgbColor(sNombre+" titánica", 255, 0, 255);
        }
    }

    return sRetorno;
}

