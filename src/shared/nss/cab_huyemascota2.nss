#include "x0_inc_henai"

void main()
{
  // IA de los convocados mascotas, animales de carga y monturas
  SetAssociateListenPatterns();//Sets up the special henchmen listening patterns
  bkSetListeningPatterns();      // Goes through and sets up which shouts the NPC will listen to.
  SetAssociateStartLocation();

  // * Feb 2003: Set official campaign henchmen to have no inventory
  SetLocalInt(OBJECT_SELF, "X0_L_NOTALLOWEDTOHAVEINVENTORY", 10) ;

  SetAssociateState(NW_ASC_DISTANCE_2_METERS);
  SetCombatCondition(X0_COMBAT_FLAG_COWARDLY);
  //SetBehaviorState(NW_FLAG_BEHAVIOR_SPECIAL);
  //SetBehaviorState(NW_FLAG_BEHAVIOR_HERBIVORE);
}
