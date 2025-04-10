// woman_top_kiss - Script by Andarian 8/5/2009
// This script will have the player kiss a conversation partner using
//  Romantic Animations Suite animation 13 (lying kiss - woman on top).

#include "q_inc_anims"

void main()
{
    Q_ExecuteKiss(Q_ANIMATION_LOOPING_KISS3, 60.0, "Q_WP_GUY2");
}

