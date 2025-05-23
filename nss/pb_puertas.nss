/*  PUERTAS GENERICAS, CON LLAVE O SIN LLAVE
  - Llama al script pb_puertas
  - El ubicado debe ser utilizable y de trama.
  - Coloca este guion en el evento OnUsed del ubicado.
  - Puedes configurar si la puerta puede requerir llave o no.
  - Si la quieres con llave, debes configurar 2 cosas: el ubicado tiene que tener la casilla activada de "Cerrado con llave" y también se le tiene que poner una etiqueta de llave válida en "Etiqueta de llave". Todo esto se encuentra en las Propiedades del ubicado, pestaña Cerradura.
  - Si no la quieres con llave, asegúrate de que no tiene nada de lo anterior activado.
  - El destino de la puerta debe ser un punto de ruta que tenga de etiqueta "WP_" + EtiquetaDelUbicado.
  - Si quieres que la llave se consuma al abrir la puerta, coloca en el ubicado de la puerta la variable int "UNSOLOUSO" con valor de 1*/

void main()
{
    object oPC = GetLastUsedBy();
    string sEtiquetaLlave = GetLockKeyTag(OBJECT_SELF);
    object oDestino = GetWaypointByTag("WP_" + GetTag(OBJECT_SELF));
    int oUnSoloUso = GetLocalInt (OBJECT_SELF, "UNSOLOUSO");
    object oLlave = GetItemPossessedBy(oPC, sEtiquetaLlave);

    // Si la Puerta requiere llave
    if(GetLocked(OBJECT_SELF) == TRUE)
    {
        if(GetItemPossessedBy(oPC, sEtiquetaLlave) == OBJECT_INVALID)
        {
            SendMessageToPC(oPC, "<cþ<<>* Necesitas una llave concreta para abrir esta puerta *</c>");
            return;
        }
        // Si la llave se consume al abrir la puerta
        if (oUnSoloUso== TRUE)
        {
            DestroyObject(oLlave);
        }
        SendMessageToPC(oPC, "<c´þd>* Usas una llave *</c>");
    }

    //Apartado para el gremio de aventureros.//
    if(GetTag(OBJECT_SELF) == "Entrada_Gremio_Sede_1")
    {
        SetLocalInt(oPC,"Entrada_Gremio_Sede",1);
        oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede");
    }
    if(GetTag(OBJECT_SELF) == "Entrada_Gremio_Sede_2")
    {
        SetLocalInt(oPC,"Entrada_Gremio_Sede",2);
        oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede");
    }
    if(GetTag(OBJECT_SELF) == "Entrada_Gremio_Sede_3")
    {
        SetLocalInt(oPC,"Entrada_Gremio_Sede",3);
        oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede");
    }
    if(GetTag(OBJECT_SELF) == "Entrada_Gremio_Sede")
    {
        int iEntrada = GetLocalInt(oPC,"Entrada_Gremio_Sede");
        if(iEntrada == 1){oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede_1");}
        if(iEntrada == 2){oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede_2");}
        if(iEntrada == 3){oDestino = GetWaypointByTag("WP_Entrada_Gremio_Sede_3");}
    }
    //Fin apartado del Gremio de Aventureros.

    // Teleport
    PlayAnimation(ANIMATION_PLACEABLE_OPEN);
    DelayCommand(1.0, PlayAnimation(ANIMATION_PLACEABLE_CLOSE));
    DelayCommand(0.1, AssignCommand(oPC, ClearAllActions()));
    DelayCommand(0.2, AssignCommand(oPC, JumpToObject(oDestino)));

}
