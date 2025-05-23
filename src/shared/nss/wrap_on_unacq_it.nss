//::////////////////////////////////////////////////////////////////////////:://
//::/  WRAPPER ONUNACQUIREITEM  ////////////////////////////////////////////:://
//::////////////////////////////////////////////////////////////////////////:://
#include "f_vampire_idrop"
void main()
{
  object oPC = GetModuleItemLostBy();
  object oObjetoSoltado = GetModuleItemLost();
  string sEtiquetaObjetoSoltado = GetTag(oObjetoSoltado);

  // Vampiros
  VampireItemDrop();

  // Flechas imbuidas se destruyen al soltarlas
  if(GetResRef(oObjetoSoltado) == "wp_arr_imbue_1") DestroyObject(oObjetoSoltado);

  // Soltar un cadaver al suelo
  if(GetStringLeft(sEtiquetaObjetoSoltado, 10) == "pg_cadaver")
  {
      string sNombreCadaver  = GetLocalString(oObjetoSoltado, "CAD_NOMBRE"); // Nombre del PJ muerto
      string sResrefCadaver  = GetLocalString(oObjetoSoltado, "CAD_RESREF"); // Resref del ubicado de cadaver
      object oJugadorMuerto  = GetLocalObject(oObjetoSoltado, "CAD_JUGADOR");// Jugador muerto
      object oCadaverJugador = GetLocalObject(GetModule(), "CAD_" + sNombreCadaver);  // Ubicado del cadaver

      object oCadaverJugador2 = CreateObject(OBJECT_TYPE_PLACEABLE, sResrefCadaver, GetLocation(oPC));
      SetName(oCadaverJugador2, "Cadáver de " + sNombreCadaver);

      SetLocalString(oCadaverJugador2, "CAD_NOMBRE", sNombreCadaver);
      SetLocalString(oCadaverJugador2, "CAD_RESREF", sResrefCadaver);
      SetLocalObject(oCadaverJugador2, "CAD_JUGADOR", oJugadorMuerto);
      SetLocalObject(GetModule(), "CAD_" + sNombreCadaver, oCadaverJugador2);

      DestroyObject(oObjetoSoltado);
  }
  //Varitas del brujo no se pueden mover del inventario.
  if(GetLocalString(oObjetoSoltado, "WAR_CREADOR") != ""){DestroyObject(oObjetoSoltado);}
}
