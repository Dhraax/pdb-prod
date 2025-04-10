//:://////////////////////////////////////////////////
//:: ONPERCP_CORROMPEAGUA
/*
By: Sevaerus
Date: Dec. 10, 2005
Este scripts va en el evento On Perception de la creatura.
Imita la capacidad de corromperer el agua que tiene los Dragones Negros.
Utiliza el valor de la pocion para hacer una tirada DC en lugar un hechizo sobre la pocion.
Este valor puede ser aumentado o disminuido en las linea numero 48 y 50.
RECUERDE! Debe crear un objeto de Miscelanea para similar la pocion corrompida,
no puede ser otra pocion (O generar un bucle infinito).
El ResRef de este objeto se coloca en la linea 51;
*/
//:://////////////////////////////////////////////////

void PudrirAgua (object oObjeto, int nBajo, int nAlto, object oDueno, string sDueno, string sCorruptor, string sCorrupto, object oJugador)
{
  string sPotion = GetName(oObjeto);
  string sCadena2;
  int i;
  int nStack= GetItemStackSize(oObjeto);
  if(GetGoldPieceValue(oObjeto)<nBajo)
  {
      sCadena2 = "<cþ<<>" + IntToString(nStack) + " " + sPotion + " " + " de "+ " " + sDueno + " " + "se ha corrompido en presendia de " + sCorruptor + "</c>" ;
      SendMessageToPC(oJugador, sCadena2);
      CreateItemOnObject(sCorrupto, oDueno, nStack);
      DestroyObject(oObjeto);
      oObjeto = GetNextItemInInventory(oDueno);
  }

  else if(GetGoldPieceValue(oObjeto) > nBajo && GetGoldPieceValue(oObjeto) < nAlto)
  {
      int nSave = d100();
      if(nSave >= 50)
      {
          sCadena2 = "<cþ<<>" + IntToString(nStack) + " " + sPotion + " " + " de "+ " " + sDueno + " " + "se ha corrompido en presendia de " + sCorruptor + "</c>" ;
          SendMessageToPC(oJugador, sCadena2);
          CreateItemOnObject(sCorrupto, oDueno, nStack);
          DestroyObject(oObjeto);
          oObjeto = GetNextItemInInventory(oDueno);
      }
  }
}

void main()
{
  ExecuteScript("nw_c2_default2",OBJECT_SELF);
  int nLow = 3000;    //Cualquier cosa por debajo de este límite está dañado.
  //Lo que se encuentre entre los dos límites tiene un 50 por ciento de posibilidades de salvarse.
  int nHigh = 20000;  //Cualquier cosa por encima de este límite no puede ser dañado.
  string sFoul ="liquidocorrompid";//Aqui se pone el objeto que va ser usado como una pocion corrupta

  //No cambie ninguno de los código de más abajo
  object oSeen = GetLastPerceived();
  object oPC;
  string sSeen = GetName(oSeen, TRUE);
  string sSelf = GetName(OBJECT_SELF, TRUE);
  string sCadena;
  float fFar = GetDistanceBetween(OBJECT_SELF, oSeen);
  int nFouled = GetLocalInt(oSeen, "FOULED");

  if(fFar > 20.0) return;

  if(nFouled == TRUE) return;

  if(GetIsPC(oSeen) == TRUE) oPC = oSeen;
  else oPC = GetMaster(oSeen);

  sCadena= "<cþ<<>¡Cuidado! ¡" + sSelf + " puede corromper tus pociones!</c>";
  FloatingTextStringOnCreature(sCadena, oSeen, TRUE);
  object oItem;

  oItem = GetFirstItemInInventory(oSeen);
  while(GetIsObjectValid(oItem))
  {
      if(GetBaseItemType(oItem)==BASE_ITEM_POTIONS) PudrirAgua(oItem, nLow, nHigh, oSeen, sSeen, sSelf, sFoul, oPC);
      else
      {
          if(GetStringLeft(GetName(oItem,TRUE),6)=="Elixir") PudrirAgua(oItem, nLow, nHigh, oSeen, sSeen, sSelf, sFoul, oPC);
          else
          {
              if(GetStringLeft(GetName(oItem,TRUE),11)== "Cantimplora")
              {
                  int iCharges = GetLocalInt(oItem,"CHARGES");
                  if (iCharges>0)
                  {
                      PudrirAgua(oItem, nLow, nHigh, oSeen, sSeen, sSelf, sFoul, oPC);
                      SendMessageToPC(oPC, "<cþ<<>El agua que contenía la cantimplora se ha corrompido provocando que la cantimplora quede inutilizable.</c>");
                  }
              }
          }
      }

      oItem = GetNextItemInInventory(oSeen);
  }

  SetLocalInt(oSeen, "FOULED", TRUE);
}
