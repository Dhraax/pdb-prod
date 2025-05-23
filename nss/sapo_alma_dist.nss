#include "sapo_cons_alma"
#include "mti_libreria"

void GuardarIngrediente(object oJugador, object oIngrediente, string sVariable)
{
  SendMessageToPC(oJugador,"Almacenado: "+ GetName(oIngrediente));
  int iTotalIngrediente = ObtenerIntPersistente(oJugador, sVariable);
  GuardarIntPersistente(oJugador, sVariable, iTotalIngrediente + 1);
}

void SacarIngrediente(object oJugador, object oIngrediente, string sVariable)
{
  SendMessageToPC(oJugador,"Sacado: "+ GetName(oIngrediente));
  int iTotalIngrediente = ObtenerIntPersistente(oJugador, sVariable);
  GuardarIntPersistente(oJugador, sVariable, iTotalIngrediente - 1);
}

void main()
{
  int iTipoDisturbio = GetInventoryDisturbType();
  object oPC = GetLastDisturbed();
  object oUbicado=OBJECT_SELF;
  //




  object oIngOficios = GetInventoryDisturbItem();
  string sTagIngOficio = GetTag(oIngOficios);
//verifica que no sea un contenedor lo metido
object oTest = GetFirstItemInInventory(oIngOficios);
if (GetIsObjectValid(oTest))
    {
    FloatingTextStringOnCreature("*¡No puedes guardar un recipiente dentro de otro!*", oPC, FALSE);
    while (GetIsObjectValid(oTest))
        {
        CopyItem(oTest, oPC);
        DestroyObject(oTest, 0.0);
        oTest = GetNextItemInInventory(oIngOficios);
        }
    //CreateItemOnObject("it_contain002", oPC, 1);
    CopyItem(oIngOficios, oPC,TRUE);
    DestroyObject(oIngOficios, 0.0);
    return;
    }
//



  if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_ADDED)
  {

    int iValido=0;


    int nCount;
    for ( nCount = 1; nCount <= NUM_DIST_INGRED; nCount++ )
      {
         string sVar=GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
          string sTag=GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);


          if (sTagIngOficio ==sTag){
                 GuardarIngrediente(oPC, oIngOficios, sVar);
                 int iNq= ObtenerIntPersistente(oPC, sVar);
                 if (iNq>1){DestroyObject(oIngOficios, 0.0);}
                 iValido=1;
                 return;
             }
      }

    if (iValido==0)
      {
          CopyItem(oIngOficios, oPC, TRUE);
          DestroyObject(oIngOficios);
          SendMessageToPC(oPC,"¡No puedes guardar eso ahí!");
      }
  }
  else
  {
     if(iTipoDisturbio == INVENTORY_DISTURB_TYPE_REMOVED)
     {
       int iValido=0;

        int nCount;
        for ( nCount = 1; nCount <= NUM_DIST_INGRED; nCount++ )
        {
         string sVar=GetLocalArrayString(oUbicado, "sVarIngOficio", nCount);
         string sTag=GetLocalArrayString(oUbicado, "sTagIngOficio", nCount);

          if (sTagIngOficio ==sTag){
                 //cobramos
                 int iOro = GetGold(oPC);
                 if(iOro >= 5)
                    {TakeGoldFromCreature(5, oPC, TRUE);
                     SacarIngrediente(oPC, oIngOficios, sVar);
                     //si tiene mas elementos en su contabilidad le genera otro
                     int iNq= ObtenerIntPersistente(oPC, sVar);
                     if (iNq>0){CopyItem(oIngOficios, oUbicado, TRUE);}
                     //
                     }
                 else
                    {//CopyItem(oIngOficios, oUbicado, TRUE);
                     //TakeNumItems(oPC,sTagIngOficio,1);
                     ///
                        SendMessageToPC(oPC, "¡No tienes suficiente oro!");
                        object oTest2 = GetFirstItemInInventory(oPC);
                        if (GetIsObjectValid(oTest2))
                        {

                            while (GetIsObjectValid(oTest2))
                            {   string sTagAux = GetTag(oTest2);
                                if (sTagIngOficio ==sTagAux){
                                    DestroyObject(oTest2, 0.0);
                                    return;
                                    }
                                 oTest2 = GetNextItemInInventory(oPC);
                            }
                            CopyItem(oIngOficios, oUbicado, TRUE);
                            return;
                        }
                    //
                    //SendMessageToPC(oPC, "¡No tienes suficiente oro!");
                    }

                 iValido=1;
                 return;
                }
        }

     }
  }
}



//
