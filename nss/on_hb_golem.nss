#include "inc_sum_golem"

void main()
{
    GuardarIntPersistente(GetMaster(),GOLEM_VAR_NAME_HP,GetCurrentHitPoints());
    ExecuteScript(GOLEM_EVENT_ON_HEARBEAT_ASSOCIATE);
}
