#include "x0_i0_position"
#include "lib_disguise"

// Vacia todo el inventario
void VaciarInventario(object oPC);

// Elimina la parada del mercader (ubicados)
void EliminarUbicadosTJ(object oPC);

// Elimina todas las variables de este sistema
void EliminarVariablesTJ(object oPC);

// Consigue la resref del ubicado que tiene el mismo color del actual cartel
string ColorCartel(object oPC);

// Consigue el actual nombre del cartel
string NombreCartel(object oPC);

// Busca si enemigos entre el rango y la criatura
int VerSiHayEnemigosEnRango(object oCriatura, float fRango);

void TJVaciarInventario(object oPC)
{
  object oItem = GetFirstItemInInventory(oPC);
  while(GetIsObjectValid(oItem))
  {
      DestroyObject(oItem);
      oItem = GetNextItemInInventory(oPC);
  }
}

void EliminarUbicadosTJ(object oPC)
{
  object oUbicado1 = GetLocalObject(oPC, "TJUBICADO1");
  object oUbicado2 = GetLocalObject(oPC, "TJUBICADO2");
  object oUbicado3 = GetLocalObject(oPC, "TJUBICADO3");
  object oUbicado4 = GetLocalObject(oPC, "TJUBICADO4");
  object oUbicado5 = GetLocalObject(oPC, "TJUBICADO5");
  object oUbicado6 = GetLocalObject(oPC, "TJUBICADO6");
  object oUbicado7 = GetLocalObject(oPC, "TJUBICADO7");

  TJVaciarInventario(oUbicado1);

  DestroyObject(oUbicado1, 0.5);
  DestroyObject(oUbicado2, 2.5);
  DestroyObject(oUbicado3, 1.0);
  DestroyObject(oUbicado4, 4.0);
  DestroyObject(oUbicado5, 3.0);
  DestroyObject(oUbicado6, 5.5);
  DestroyObject(oUbicado7, 5.0);
}

void EliminarVariablesTJ(object oPC)
{
  if(GetLocalInt(oPC, "TJACTIVADA") == 0) return;

  DeleteLocalObject(oPC, "TJUBICADO1");
  DeleteLocalObject(oPC, "TJUBICADO2");
  DeleteLocalObject(oPC, "TJUBICADO3");
  DeleteLocalObject(oPC, "TJUBICADO4");
  DeleteLocalObject(oPC, "TJUBICADO5");
  DeleteLocalObject(oPC, "TJUBICADO6");
  DeleteLocalObject(oPC, "TJUBICADO7");

  DeleteLocalInt(oPC, "TJACTIVADA");
  DeleteLocalInt(oPC, "TJNOMBRE");
  DeleteLocalInt(oPC, "TJCOLOR");

  DeleteLocalLocation(oPC, "TJLUGARPC");
  DeleteLocalLocation(oPC, "TJLUGARMOSTRADOR");
}

string ColorCartel(object oPC)
{
  string sColor;
  int iVariable = GetLocalInt(oPC, "TJCOLOR");

  if(iVariable == 1) return sColor = "tj_cartel3";
  else if(iVariable == 2) return sColor = "tj_cartel2";
  else if(iVariable == 3) return sColor = "tj_cartel4";
  else return sColor = "tj_cartel";
}

string NombreCartel(object oPC)
{
  string sNombre;
  string sNombreJugador = PB_Disguise_GetNameOverride(oPC);
  int iVariable = GetLocalInt(oPC, "TJNOMBRE");

  if(iVariable == 1) return sNombre = "¡Bienvenidos a la tienda de " + sNombreJugador + "!";
  else if(iVariable == 2) return sNombre = sNombreJugador + ", a su servicio";
  else if(iVariable == 3) return sNombre = "¡No encontrará ninguna otra tienda con mejores precios!";
  else if(iVariable == 4) return sNombre = "¡Despilfarre, despilfarre! ¡Cómpreme algo por favor!";
  else if(iVariable == 5) return sNombre = "Objetos de gran calidad a precio asequible";
  else if(iVariable == 6) return sNombre = "¡Las mejores armas de toda Amn en mi tienda!";
  else if(iVariable == 7) return sNombre = "¡Objetos mágicos nunca vistos delante de sus ojos señoraa!";
  else if(iVariable == 8) return sNombre = "¿Tú le pondrías precio a ''esto''? Yo sí";
  else if(iVariable == 9) return sNombre = "Chusma, dudo que encontreis algo aquí por menos de 50.000 po";
  else if(iVariable == 10) return sNombre = "Utensilios, herramientas, aparatos, artilugios... Todo lo que no usaría nunca, ¡aquí!";
  else if(iVariable == 11) return sNombre = "Mire, compare y juzgue. ¡Le devolveremos el doble de lo que pagó si no está satisfecho!";
  else if(iVariable == 12) return sNombre = "Tápese los ojos al ver mi mostrador, el brillo de mis objetos le deslumbrará";
  else if(iVariable == 13) return sNombre = "Yo que tú vendría con algún milloncillo de más aquí";
  else if(iVariable == 14) return sNombre = "Mi extraordinaria tienda épica es única";
  else if(iVariable == 15) return sNombre = "¡Admito regateos! ¡¡Admito regateoos!!";
  else return sNombre = "¡Bienvenidos a la tienda de " + sNombreJugador + "!";
}

int VerSiHayEnemigosEnRango(object oCriatura, float fRango)
{
    object oNextCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCriatura);
    float fDist;
    if(oNextCreature != OBJECT_INVALID) fDist = GetDistanceBetween(oCriatura, oNextCreature);
    int nLooper;
    while(fDist <= fRango && oNextCreature != OBJECT_INVALID)
    {
        if(GetIsEnemy(oNextCreature, oCriatura)) return TRUE;
        oNextCreature = GetNearestCreature(CREATURE_TYPE_IS_ALIVE, TRUE, oCriatura, ++nLooper);
        if(oNextCreature != OBJECT_INVALID) fDist = GetDistanceBetween(oCriatura, oNextCreature);
    }
    return FALSE;
}

location PosicionMostrador(object oTarget)
{
    float fDir = GetFacing(oTarget);
    return GenerateNewLocation(oTarget, 1.0, fDir, fDir + 180.0);
}

location PosicionCajaIzq(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetLeftDirection(fDir);
    return GenerateNewLocation(oTarget, 1.0, fAngle, fDir + 75.0);
}

location PosicionCartel(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetRightDirection(fDir);
    return GenerateNewLocation(oTarget, 0.7, fAngle, fDir + 155.0);
}

location PosicionBarril(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetRightDirection(fDir);
    return GenerateNewLocation(oTarget, 1.1, fAngle, fDir + 155.0);
}

location PosicionCajaPequenyaDerecha(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngle = GetHalfRightDirection(fDir);
    float fFaceAngle = GetOppositeDirection(fAngle);
    return GenerateNewLocation(oTarget, 1.2, fAngle, fFaceAngle);
}

location PosicionVallaIzq(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngleToLeftFlank = GetFarLeftDirection(fDir);
    return GenerateNewLocation(oTarget, 1.1, fAngleToLeftFlank, fDir);
}

location PosicionVallaDer(object oTarget)
{
    float fDir = GetFacing(oTarget);
    float fAngleToRightFlank = GetFarRightDirection(fDir);
    return GenerateNewLocation(oTarget, 1.1, fAngleToRightFlank, fDir);
}
