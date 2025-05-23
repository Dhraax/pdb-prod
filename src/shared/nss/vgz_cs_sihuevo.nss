int StartingConditional()
{

    // Inspeccionar las variables locales
    if(!(GetItemPossessedBy(GetPCSpeaker(),"HuevosdeDragn") != OBJECT_INVALID))
        return FALSE;

    return TRUE;
}
