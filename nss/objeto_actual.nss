int StartingConditional()
{
    object oContenedor = GetObjectByTag("spawn_encuentros");
    int sEnch = GetLocalInt(oContenedor,"Sel");
   switch(sEnch) {
   case 0: SetCustomToken(5555,"Yelmo"); break;
   case 2: SetCustomToken(5555,"Botas"); break;
   case 3: SetCustomToken(5555,"Guantes"); break;
   case 4: SetCustomToken(5555,"Arma principal"); break;
   case 5: SetCustomToken(5555,"Mano torpe"); break;
   case 6: SetCustomToken(5555,"Capa"); break;
   case 7: SetCustomToken(5555,"Anillo Derecho"); break;
   case 8: SetCustomToken(5555,"Anillo Izquierdo"); break;
   case 9: SetCustomToken(5555,"Amuleto"); break;
   case 10: SetCustomToken(5555,"Cinturón"); break;
   case 11: SetCustomToken(5555,"Flechas"); break;
   case 12: SetCustomToken(5555,"Balas"); break;
   case 13: SetCustomToken(5555,"Virotes"); break;
   case 1: SetCustomToken(5555,"Armadura"); break;
   }
    return TRUE;
}
