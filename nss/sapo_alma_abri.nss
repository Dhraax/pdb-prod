#include "sapo_cons_alma"
#include "mti_libreria"

int RecorreIngredientes(object oUbicado, object oPC, int iCrea);
int Ngru;

void main()
{
    //object oPJ = GetLastOpenedBy();
    object oPJ = GetLastUsedBy();
    object oUbicado=OBJECT_SELF;

    if (GetLocalInt(oUbicado,"abierto")==1)
    {
    //SendMessageToPC(oPJ,"¡abierto!");
    FloatingTextStringOnCreature("*El almacen lo está usando alguien. Intentalo de nuevo cuando acabe*", oPJ);
    return;
    }
    //crea el objeto invisible
    object oCofre = CreateObject(OBJECT_TYPE_PLACEABLE, "sapo_alma_u", GetLocation(oUbicado));
    SetLocalObject(oCofre, "chest_use", oUbicado);
    SetLocalObject(oCofre, "user", oPJ);
    //

    //carga en el cofre invisible el array
    CargaArray(oCofre);
    //construye en el cofre invisible los ingredientes de oficios
    Ngru=0;
    int iIng =RecorreIngredientes(oCofre,oPJ, 0);
    if (iIng==0)
    { SendMessageToPC(oPJ,"¡No tienes nada guardado");
    }
    else
    {
      int iI =RecorreIngredientes(oCofre,oPJ, 1);
    }
    //obliga al pj a interaccionar con el cofre invisible
    AssignCommand(oPJ, ActionInteractObject(oCofre));
}

int RecorreIngredientes(object oUbicado, object oPC, int iCrea) {

  int nTotal=0;
  int iTipos=0;
  int nCount;
  for ( nCount = 1; nCount <= NUM_DIST_INGRED; nCount++ )
    {   int i=0;
        string sVar=GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
        string sTag=GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);
        i= ObtenerIntPersistente(oPC, sVar);

        if(i>0){
        iTipos=iTipos+1;
        nTotal = nTotal + i;
           if (iCrea==0){
              string sNom=GetLocalArrayString(oUbicado, "sNomIngOficio", nCount);
              SendMessageToPC(oPC, sNom + IntToString(i));
           }
        }

        if (iCrea==1)
        {//creamos el objeto en el contenedor
          if (i>0){CreateItemOnObject(sTag, oUbicado);}
        }
    }

  return nTotal;
}
