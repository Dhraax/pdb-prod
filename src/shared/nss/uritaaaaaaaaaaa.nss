//::///////////////////////////////////////////////
//:: Name  WHEELER
//::    this is called on the conversation for the wheel of fortune operator
//:://////////////////////////////////////////////
/*
  1: take 100gp to play (make sure they don't stiff you)
  2: pick a random prize to land on. (note: the wheel is cheated to pay out lower prizes more often)
  3: if the prize includes a random goodie (or baddie), pick one of those
  4: if the random goodie/baddie includes magic, zap the pc
  NOTE: the zapping has to go on another script.
  set a local variable on the WHEELER to do it.
  5: go back to the conversation, announce/give prizes, play again, etc.

*/
//:://////////////////////////////////////////////
//:: Created By: bloodsong
//::   this swipes heavily from the slots script by steve hunter
//:://////////////////////////////////////////////

//-- tokens personalizados
//-- 90001 = Token de resultados USE sPrize
//-- 90002 = Token de victoria/derrota/error establecido en cada uno.
#include "inc_timelock"

void main()
{
    object oPC = GetPCSpeaker();  //-- Nuestro jugador
    object oWheeler = GetObjectByTag("WHEELER"); //-- El operador de la rueda
    object oBouncer = GetObjectByTag("Bouncer"); //-- Él se queda con las ganancias
    int bet = 500;                //-- 100 gp to play
    string sPrize = "Si estas leyendo esto, ha ocurrido un error.";
    int payout = 0;
    int nRandom; //-- numero random

    // Cooldown check.
    if(GetIsTimelocked(oPC, "Rueda de la Fortuna"))
    {
        TimelockErrorMessage(oPC, "Rueda de la Fortuna");
        return;
    }
//-- DEPURACIÓN----------------------
// int goodie = 333999;
// int beastie = 333999;
// SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc23");
//----------------------------------

    SetCustomToken(90001, "Lastima. ");   //-- resultado preestablecido


//-- Paso uno: ¡consigue el botín!

   if (GetGold(oPC) < bet) //¡No se otorga ningún crédito!
    {
      SetCustomToken(90002, "No tienes suficiente oro para jugar conmigo, cariño. Vuelve cuando tengas un poco más..");
      return;
    }

    TakeGoldFromCreature(bet, oPC, FALSE);
    GiveGoldToCreature(oBouncer, FloatToInt(IntToFloat(bet)/3.0)); //-- 1/3 es ganancia


//-- Paso 2: elige un premio
//-- 2a: decide entre una opción alta o baja.

   int nHiLo = Random(100);
   int nPrize;

   if (nHiLo < 70)  //-- mayor probabilidad de un premio bajo
   {
     nPrize = Random(9);

     switch (nPrize)
     {
        case 0:  //-- El primer premio es: PERDER
        sPrize = "Perdida";
        payout = 0;
        break;

        case 1:  //-- El segundo premio es: INFORTUNIO
        sPrize = "100";
        payout = 100;
        break;

        case 2:  //--  Son obvias, ¿no?
        sPrize = "250";
        payout = 250;
        break;

        case 3:
        sPrize = "500";
        payout = 500;
        break;

        case 4:
        sPrize = "0";
        payout = 0;
        break;

        case 5:
        sPrize = "0";
        payout = 0;
        break;

        case 6:
        sPrize = "200";
        payout = 200;
        break;

        case 7:
        sPrize = "1000";
        payout = 1000;
        break;

        case 8:
        sPrize = "PREMIO ESPECIAL";
        payout = 5000;
        break;
      }
   }

   else //-- Si HiLo indica premio alto
    {

     nPrize = Random(4);

       switch (nPrize)
      {
          case 0:
          sPrize = "Perdida   ";
          payout = 0;
          break;

          case 1:
          sPrize = "Infortunio";
          payout = 0;
          break;

          case 2:
          sPrize = "1,500";
          payout = 1500;
          break;

          case 3:
          sPrize = "BOTE";
          payout = 1000;
          break;
       }
    }

//-- Paso 4...informar el resultado:

   SetCustomToken(90001, sPrize +"!     "); //-- Primera parte, ¿qué es el punto de la rueda?

//-- paso 3, versión 2
//-- Ahora vamos a enviar el pago y el premio al WHEELER.

    SetLocalInt(oWheeler, "payout", payout);
    SetLocalString(oWheeler, "sPrize", sPrize);

//-- Paso 3, versión 1, elige los obsequios al azar
//-- Paso 3: si el pago no es monetario, haz las cosas especiales.



   if (payout == 0)
   {
      if (sPrize == "Perdida")
      {
         SetCustomToken(90002, "Pierdes! Gana la casa.");
         return;
      }


  if (payout == 100)

      if (sPrize == "100")
      {
         SetCustomToken(90002, "Recuperas 100 monedas.");
         return;
      }


  if (payout == 250)

      if (sPrize == "250")
      {
         SetCustomToken(90002, "Recuperas 250 monedas.");
         return;
      }


  if (payout == 500)

      if (sPrize == "500")
      {
         SetCustomToken(90002, "Recuperas 500 tu inversion.");
         return;
      }


  if (payout == 1000)

      if (sPrize == "1000")
      {
         SetCustomToken(90002, "Ganas 1000 monedas.");
         return;
      }


  if (payout == 0)

      if (sPrize == "0")
      {
         SetCustomToken(90002, "Pierdes! Gana la casa.");
         return;
      }


  if (payout == 1)

      if (sPrize == "200")
      {
         SetCustomToken(90002, "Ganas 200 monedas.");
         return;
      }


  if (payout == 300)

      if (sPrize == "300")
      {
         SetCustomToken(90002, "Ganas 300 monedas..");
         return;
      }


  if (payout == 5000)

      if (sPrize == "5000")
      {
         SetCustomToken(90002, "GANAS EL PREMIO ESPECIAL.");
         return;
      }
 }

/*    else if (sPrize == "INFORTUNIO")
      {
         SetCustomToken(90002, "La Ruleta libera su INFORTUNIO.");

         nRandom = Random(11);

         switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "goodie", SPELL_BESTOW_CURSE);
           break;

           case 1:
           SetLocalInt(oWheeler, "goodie", SPELL_BLINDNESS_AND_DEAFNESS);
           break;

           case 2:
           SetLocalInt(oWheeler, "goodie", SPELL_CONFUSION);
           break;

           case 3:
           SetLocalInt(oWheeler, "goodie", SPELL_DAZE);
           break;

           case 4:
           SetLocalInt(oWheeler, "goodie", SPELL_ENERGY_DRAIN);
           break;

           case 5:
           SetLocalInt(oWheeler, "goodie", SPELL_FEAR);
           break;

           case 6:
           SetLocalInt(oWheeler, "goodie", SPELL_FEEBLEMIND);
           break;

           case 7:
           SetLocalInt(oWheeler, "goodie", SPELL_HARM);
           break;

           case 8:
           SetLocalInt(oWheeler, "goodie", SPELL_HOLD_PERSON);
           break;

           case 9:
           SetLocalInt(oWheeler, "goodie", SPELL_POISON);
           break;

           case 10:
           SetLocalInt(oWheeler, "goodie", SPELL_SCARE);
           break;
         }
      } //-- end Curse IF
      else if (sPrize == "Regalo sorpresa")
      {
         nHiLo = Random(100);  //-- these come in 2 sizes
         string sMP;  //-- to tell the pigeon what he won

         if (nHiLo < 70)  //-- greater chance of low prize
         {
           nRandom = Random(5);

           switch (nRandom)
           {
            case 0:
            sMP = "Hoja de Belladona";
            SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc23");
            break;

            case 1:
            sMP = "Diente de Ajo";
            SetLocalString(oWheeler, "sPotionID", "nw_it_msmlmisc24");
            break;

            case 2:
            sMP = "Granate";
            SetLocalString(oWheeler, "sPotionID", "nw_it_gem011");
            break;

            case 3:
            sMP = "Colgante de cobre";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mneck020");
            break;

            case 4:
            sMP = "Anillo de plata";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring022");
            break;

           }
         }
         else //-- higher mystery prizes
         {
           nRandom = Random(5);

           switch (nRandom)
           {
            case 0:
            sMP = "Anillo de oro";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring023");
            break;

            case 1:
            sMP = "Rubi";
            SetLocalString(oWheeler, "sPotionID", "nw_it_gem006");
            break;

            case 2:
            sMP = "Anillo de resistencia";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mring031");
            break;

            case 3:
            sMP = "Anillo de picaro";
            SetLocalString(oWheeler, "sPotionID", "nw_hen_gal1rw");
            break;

            case 4:
            sMP = "Vaina de bendicion";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mmidmisc04");
            break;

           }
         }
          SetCustomToken(90002, "Tu regalo misterioso es un... " + sMP + ". ");
      }  //-- end Mystery Prize IF

      else if (sPrize == "Pocion")
      {
         nHiLo = Random(100);  //-- good prize or cheap prize
         string sPotion;

         if (nHiLo < 70)  //-- cheap prizes
         {
           nRandom = Random(4);

           switch (nRandom)
           {
            case 0:
            sPotion = "Cerveza";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion021");
            break;

            case 1:
            sPotion = "Curar heridas leves";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion001");
            break;

            case 2:
            sPotion = "Pocion de velocidad";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion004");
            break;

            case 3:
            sPotion = "Licores";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion022");
            break;
           }
         }
         else  //-- good potion prizes
         {
           nRandom = Random(3);


           switch (nRandom)
           {
            case 0:
            sPotion = "Pocion de Auxilio Divino";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion016");
            break;

            case 1:
            sPotion = "Curar heridas graves";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion002");
            break;

            case 2:
            sPotion = "Pocion de invisibilidad";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion008");
            break;

            case 3:
            sPotion = "Pocion de piel robliza";
            SetLocalString(oWheeler, "sPotionID", "nw_it_mpotion005");
            break;
           }

         }
        SetLocalString(oWheeler, "sPotion", sPotion);
        SetCustomToken(90002, "Ganas una pocion: " + sPotion + ".");

      } //-- end Potions IF

      else if (sPrize == "Premio divertido")
      {
         nRandom = Random(7);

         switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_BADGER);
           break;

           case 1:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_BOAR);
           break;

           case 2:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_COW);
           break;

           case 3:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_GIANT_SPIDER);
           break;

           case 4:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_IMP);
           break;

           case 5:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_PENGUIN);
           break;

           case 6:
           SetLocalInt(oWheeler, "beastie", POLYMORPH_TYPE_PIXIE);
           break;
          }

         SetCustomToken(90002, "Has ganado el premio divertido!");

      }//-- end Booby Prize IF

       else if (sPrize == "Magia")
       {
          nRandom = Random(12);
          switch (nRandom)
         {
           case 0:
           SetLocalInt(oWheeler, "goodie", SPELL_AID);
           break;

           case 1:
           SetLocalInt(oWheeler, "goodie", SPELL_AURA_OF_VITALITY);
           break;

           case 2:
           SetLocalInt(oWheeler, "goodie", SPELL_BLESS);
           break;

           case 3:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_BULLS_STRENGTH);
           break;

           case 4:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_CATS_GRACE);
           break;

           case 5:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_FOXS_CUNNING);
           break;

           case 6:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_EAGLE_SPLENDOR);
           break;

           case 7:
           SetLocalInt(oWheeler, "goodie", SPELL_GREATER_OWLS_WISDOM);
           break;

           case 8:
           SetLocalInt(oWheeler, "goodie", SPELL_CLARITY);
           break;

           case 9:
           SetLocalInt(oWheeler, "goodie", SPELL_FREEDOM_OF_MOVEMENT);
           break;

           case 10:
           SetLocalInt(oWheeler, "goodie", SPELL_GHOSTLY_VISAGE);
           break;

           case 11:
           SetLocalInt(oWheeler, "goodie", SPELL_HASTE);
           break;
         }
         SetCustomToken(90002, "La Ruleta libera su magia.");
       } //-- end Magic IF   */
   //}  //-- end of payout = 0 IF

   else  //-- if the payout is NOT zero
   {
      if (payout == 20000)  //-- if it is the jackpot
      {
      SetCustomToken(90002, "Enhorabuena, has ganado las tres mil piezas de oro!");
      // GiveGoldToCreature(oPC, payout);
      }
      else
      {
      SetCustomToken(90002, " Ganas " + sPrize + " piezas de oro!");
      // GiveGoldToCreature(oPC, payout);
      }
   }
}






