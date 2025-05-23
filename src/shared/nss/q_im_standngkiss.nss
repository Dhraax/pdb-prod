// Standing_Kiss - Script by Andarian 8/5/2009
// This script will have the player kiss a conversation partner using
//  Romantic Animations Suite animation 11 (standing kiss).

#include "q_inc_anims"

void main()
{
    Q_ExecuteKiss(Q_ANIMATION_LOOPING_KISS1, 15.0, "Q_WP_GUY1");
}
