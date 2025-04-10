#include "gh_black_include"

void main() {
    SetLocalInt(OBJECT_SELF, "PlayerScore", GetScore("PLAYER"));
    SetLocalInt(OBJECT_SELF, "DealerScore", GetScore("DEALER"));

    //When this reaches 2, the deck itself will be reset(shuffled) when it is Initialized().
    SetLocalInt(OBJECT_SELF, "RESHUFFLE", GetLocalInt(OBJECT_SELF, "RESHUFFLE") + 1);

    //Check for BLACKJACKs. Both Players with BLACKJACK is a draw. Otherwise
    //the lone Player with a BLACKJACK automatically wins.
    if(GetLocalInt(OBJECT_SELF, "DealerScore") == 21 && GetLocalInt(OBJECT_SELF, "DEALER_CARD_3") == 0) {
        if(GetLocalInt(OBJECT_SELF, "PlayerScore") == 21 && GetLocalInt(OBJECT_SELF, "PLAYER_CARD_3") == 0) {
            SpeakString("EMPATE: ¡Doble BlackJack! ¿Significa eso que jugamos de nuevo?");
            GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET")); //Give his bet back.
        }
        else if(GetLocalInt(OBJECT_SELF, "PlayerScore") != 21 || GetLocalInt(OBJECT_SELF, "PLAYER_CARD_3") != 0) {
            SpeakString("PIERDES: ¡BlackJack del Crupier! Parece que necesitas un poco de suerte. ¿Probamos de nuevo?");
        }
    }
    else if(GetLocalInt(OBJECT_SELF, "PlayerScore") == 21 && GetLocalInt(OBJECT_SELF, "PLAYER_CARD_3") == 0) {
        SpeakString("VICTORIA: ¡Blackjack! Una partida impresionante. ¿A por la revancha?");
        GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET") + (GetLocalInt(OBJECT_SELF, "MINIMUM_BET") / 2));
    }
    else {
        //Noone had Blackjack, so check if Dealer can draw, and then find winners.
        //Dealer hits if 16 or less, automatically.
        //Go through hand, and add another card to the appropriate
        //slot.
        while(GetLocalInt(OBJECT_SELF, "DealerScore") <= 16) {
            if(GetLocalInt(OBJECT_SELF, "DEALER_CARD_3") == 0) {
                SetLocalInt(OBJECT_SELF, "DEALER_CARD_3", Deal());
            }
            else if(GetLocalInt(OBJECT_SELF, "DEALER_CARD_4") == 0) {
                SetLocalInt(OBJECT_SELF, "DEALER_CARD_4", Deal());
            }
            else if(GetLocalInt(OBJECT_SELF, "DEALER_CARD_5") == 0) {
                SetLocalInt(OBJECT_SELF, "DEALER_CARD_5", Deal());
            }
            else if(GetLocalInt(OBJECT_SELF, "DEALER_CARD_6") == 0) {
                SetLocalInt(OBJECT_SELF, "DEALER_CARD_6", Deal());
            }
            SetLocalInt(OBJECT_SELF, "DealerScore", GetScore("DEALER"));
        }
        //Noone had a Blackjack, so go through and find out who won.
        if(GetLocalInt(OBJECT_SELF, "DealerScore") >= 22 && GetLocalInt(OBJECT_SELF, "PlayerScore") <= 21) { //Dealer over
            SpeakString("¡La Casa pierde! ¡Eres un verdadero tiburón de las cartas! Aquí están tus ganancias, 2 a 3 como prometimos.");
            GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET") + (GetLocalInt(OBJECT_SELF, "MINIMUM_BET") / 2));
        }
        else if(GetLocalInt(OBJECT_SELF, "PlayerScore") >= 22 && GetLocalInt(OBJECT_SELF, "DealerScore") <= 21) { //Player over
            SpeakString("¡Derrota! Lo siento, compañero, gana la Casa. ¡Prueba de nuevo!");
        }
        else if(GetLocalInt(OBJECT_SELF, "PlayerScore") >= 22 && GetLocalInt(OBJECT_SELF, "DealerScore") >= 22) { //Both over
            SpeakString("¡Empate! Una partida dura. ¿Jugamos de nuevo?");
            GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET")); //Give his bet back.
        }
        else if(GetLocalInt(OBJECT_SELF, "PlayerScore") > GetLocalInt(OBJECT_SELF, "DealerScore")) { //Player beats Dealer
            SpeakString("¡Buena jugada! Ganas a la Casa. Aquí están tus ganancias, dos a tres como prometimos.");
            GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET") + (GetLocalInt(OBJECT_SELF, "MINIMUM_BET") / 2));
        }
        else if(GetLocalInt(OBJECT_SELF, "DealerScore") > GetLocalInt(OBJECT_SELF, "PlayerScore")) { //Both over
            SpeakString("Ahh, la Casa gana por poco, compañero. ¡Pero ha estado cerca! ¿Probamos otra vez?");
        }
        else if(GetLocalInt(OBJECT_SELF, "DealerScore") == GetLocalInt(OBJECT_SELF, "PlayerScore")) { //Equal, tie.
            SpeakString("¡Empate! Una partida dura, ¿probamos de nuevo?");
            GiveGoldToCreature(GetPCSpeaker(), GetLocalInt(OBJECT_SELF, "MINIMUM_BET")); //Give his bet back.
        }
        else {
            SpeakString("Porras... Alguien DEBERÍA haber ganado, ¿verdad? Supongo que no soy muy buen crupier...");
        }
    }
    //Show Final score.
    ShowHandAndScores(TRUE);

    //Reset minimum bet.
    SetLocalInt(OBJECT_SELF, "MINIMUM_BET", 300);

    //After a game is over, check to make sure player has enough money to continue.
    if(GetGold(GetPCSpeaker()) < GetLocalInt(OBJECT_SELF, "MINIMUM_BET")) {
        SpeakString("Lo siento, no te queda oro para apostar.");
        DelayCommand(1.0, AssignCommand(GetPCSpeaker(), SpeakString("¿Qué puedo hacer con " + IntToString(GetGold(GetPCSpeaker())) + " monedas de oro?")));
        DelayCommand(3.0, SpeakString("¡No tengo la menor idea! ¿Visitar el burdel?"));
    }
}
