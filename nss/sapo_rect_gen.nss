
//Funcion generica para comprobar materiales
//Se llama usando ExecuteScript com el objeto Ubicado
//Comprueba cada variable fnMaterialMascaraX (donde X va de 1 a...)
//Si acaba en "*" la mascara asume que es un prefijo
//Si no acaba en "*" asume que buscamos el nombre exacto.
//Si usa una mascara y encuentra mas de un objeto que coincide con la mascara devuelve false. La formula no es valida.
//Al final devuelve:
//  fnMaterialRetornoX (donde X va de 1 a...) con el Tag o ResRef del material valido encontrado.
//  fnMaterialRetornoTotalX (donde X va de 1 a...) el numero de unidades encontrado de dicho material.
//  fnMaterialesRetornoTotal con el numero total de unidades en el inventario.
//  fnRetorno con TRUE o FALSE si la formula puede ser valida.
//Una formula no sera valida si buscamos por mascara y encontramos mas de un tupo de objeto para una mascara
//En cualquier otro caso la formula es valida. Sera en la fucnion que llame a este script quien compruebe si realmente es una formula

string ComprobarObjetoPorMascara(string sMaterialMascara, string sTag, string sResRef, string sMaterialEncontrado);
string ComprobarObjetoPorNombre(string sMaterialMascara, string sTag, string sResRef);
void BorrarVariables(object oUbicado);
void MostrarVariables(object oUbicado);

void main() {

    int x;
    object oUbicado=OBJECT_SELF;
    string sMaterialMascara;
    string sMaterialEncontrado;
    int iTotMaterial;
    int iTotMateriales=0;

    object oObjeto = GetFirstItemInInventory(oUbicado);
    while(GetIsObjectValid(oObjeto) == TRUE) {
        //hay un problema con perdida de variables internas en las herramientas
        //al ser vendido por comerciante, por si acaso se inicializan
        string sTag=GetTag(oObjeto);
        string sRes=GetResRef(oObjeto);
        if (sTag=="sapo_kitcuero"||sRes=="sapo_kitcuero")
        {  if (GetLocalInt(oObjeto,"Herramienta")!=1)
           {  SetLocalInt(oObjeto,"Herramienta",1);           }
        }
        if (sTag=="sapo_ing_tanino"||sRes=="sapo_ing_tanino")
        {  if (GetLocalInt(oObjeto,"Herramienta")!=1)
           {  SetLocalInt(oObjeto,"Herramienta",1);           }
        }
        if (sTag=="sapo_ing_sal"||sRes=="sapo_ing_sal")
        {  if (GetLocalInt(oObjeto,"Herramienta")!=1)
           {  SetLocalInt(oObjeto,"Herramienta",1);           }
        }
        if (sTag=="sapo_ing_cera"||sRes=="sapo_ing_cera")
        {  if (GetLocalInt(oObjeto,"Herramienta")!=1)
           {  SetLocalInt(oObjeto,"Herramienta",1);           }
        }
        ///////////////////////
        if (GetLocalInt(oObjeto,"Herramienta")!=1) {
            x=1;
            sMaterialMascara=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
            while(sMaterialMascara!="") {
                sMaterialEncontrado=GetLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x));
                if (GetStringRight(sMaterialMascara,1)=="*")
                    sMaterialEncontrado=ComprobarObjetoPorMascara(sMaterialMascara, GetTag(oObjeto), GetResRef(oObjeto),sMaterialEncontrado);
                else
                    sMaterialEncontrado=ComprobarObjetoPorNombre(sMaterialMascara, GetTag(oObjeto), GetResRef(oObjeto));

                if(sMaterialEncontrado=="Repetido") {
                    SetLocalInt(oUbicado,"fnRetorno",FALSE);
                    BorrarVariables(oUbicado);
                    return;
                }
                if (sMaterialEncontrado!="") {
                    SetLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x), sMaterialEncontrado);
                    iTotMaterial=GetLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x));
                    //verificamos si es un apilado
                    int iStack;
                    iStack =GetNumStackedItems(oObjeto);
                    if (iStack > 1)
                    {
                      SetLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x),iTotMaterial+iStack);
                    }
                    else
                    {
                      SetLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x),iTotMaterial+1);
                    }
                    //SetLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x),iTotMaterial+1);
                }
                x++;
                sMaterialMascara=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
            }
            iTotMateriales++;
        }
        oObjeto=GetNextItemInInventory(oUbicado);
    }
    SetLocalInt(oUbicado,"fnMaterialesRetornoTotal",iTotMateriales);
    SetLocalInt(oUbicado,"fnRetorno",TRUE);


}

string ComprobarObjetoPorMascara(string sMaterialMascara, string sTag, string sResRef, string sMaterialEncontrado) {


    string sMascara=GetStringLeft(sMaterialMascara,GetStringLength(sMaterialMascara)-1);

    if(GetStringLeft(sTag,GetStringLength(sMascara))==sMascara) {
        if(sMaterialEncontrado!="" && sMaterialEncontrado!=sTag && sMaterialEncontrado!=sResRef) return "Repetido";
        return sTag;
    }

    if(GetStringLeft(sResRef,GetStringLength(sMascara))==sMascara) {
        if(sMaterialEncontrado!="" && sMaterialEncontrado!=sTag && sMaterialEncontrado!=sResRef) return "Repetido";
        return sResRef;
    }

    return "";


}

string ComprobarObjetoPorNombre(string sMaterialMascara, string sTag, string sResRef) {

    if(sTag==sMaterialMascara) return sTag;
    if(sResRef==sMaterialMascara) return sResRef;

    return "";

}

void BorrarVariables(object oUbicado) {

    int x=1;
    string sTmp=GetLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x));
    while (sTmp!="") {
        DeleteLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x));
        DeleteLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x));
        x++;
        sTmp=GetLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x));
    }

}

void MostrarVariables(object oUbicado) {

    int x=1;
    string sTmp=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
    while (sTmp!="") {
        SpeakString(
            "***Variable fnMaterialRetorno"
            + IntToString(x)
            + ": "
            + GetLocalString(oUbicado,"fnMaterialRetorno" + IntToString(x))
            + "/Unidades:"
            + IntToString(GetLocalInt(oUbicado,"fnMaterialRetornoTotal" + IntToString(x)))
            );
        x++;
        sTmp=GetLocalString(oUbicado,"fnMaterialMascara" + IntToString(x));
    }

}

