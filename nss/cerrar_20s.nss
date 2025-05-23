// Comprobar si el cierre de la puerta está en cola (con o sin destino de transición)
int GetIsClosureEnqueued(object oDoor) {
    // Comprobar si el cierre de la puerta está en cola
    int bIsClosureEnqueued = GetLocalInt(oDoor, "CLOSURE_ENQUEUED");

    // Si el cierre está en cola, devolver TRUE
    if (bIsClosureEnqueued) return TRUE;

    // Comprobar si la puerta tiene un destino de transición, y si lo tiene, comprobar si el cierre está en cola para el destino
    oDoor = GetTransitionTarget(oDoor);
    if (GetIsObjectValid(oDoor) && GetObjectType(oDoor) == OBJECT_TYPE_DOOR) {
        bIsClosureEnqueued = GetLocalInt(oDoor, "CLOSURE_ENQUEUED");

        if (bIsClosureEnqueued) return TRUE;
    }

    return FALSE;
}

// Ejecución principal
void main()
{
    // Si no estamos en el evento de apertura de una puerta o el cierre de la puerta ya está en cola, cancelar cierre automático
    if (GetCurrentlyRunningEvent() != EVENT_SCRIPT_DOOR_ON_OPEN || GetIsClosureEnqueued(OBJECT_SELF)) return;

    // Añadir cierre de la puerta a la cola
    SetLocalInt(OBJECT_SELF, "CLOSURE_ENQUEUED", TRUE);
    DelayCommand(20.0, ActionCloseDoor(OBJECT_SELF));
    DelayCommand(20.0, DeleteLocalInt(OBJECT_SELF, "CLOSURE_ENQUEUED"));
}
