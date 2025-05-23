void main()
{
    object oPC = GetLastUsedBy();
    object oPuerta = GetObjectByTag("arcania_fuera");
    if (GetItemPossessedBy(oPC,"llavearcania1") != OBJECT_INVALID)
    {

        DelayCommand(1.9, AssignCommand(oPC, ClearAllActions()));
        DelayCommand(4.0, ActionCloseDoor(oPuerta));
        DelayCommand(4.0, SetLocked(oPuerta,TRUE));
        DelayCommand(4.0, ActionCloseDoor(GetObjectByTag("arcania_dentro")));
        DelayCommand(4.0, SendMessageToPC(oPC, "*Escucha una serie de clics, indicando que las cerraduras de la puertas se estan cerrando*."));

    }
}
