int StartingConditional()
{
   object oContenedor = GetObjectByTag("spawn_encuentros");
   int iVar = GetLocalInt(oContenedor,"elementovalor");
   switch(iVar) {
   case 0: { SetCustomToken(6969,"Nada"); } break;
   case 1: { SetCustomToken(6969,"5"); } break;
   case 2: { SetCustomToken(6969,"10"); } break;
   case 3: { SetCustomToken(6969,"15"); } break;
   case 4: { SetCustomToken(6969,"20"); } break;
   case 5: { SetCustomToken(6969,"25"); } break;
   case 6: { SetCustomToken(6969,"30"); } break;
   case 7: { SetCustomToken(6969,"35"); } break;
   case 8: { SetCustomToken(6969,"40"); } break;
   case 9: { SetCustomToken(6969,"45"); } break;
   case 10: { SetCustomToken(6969,"50"); } break;

   }



  // SetCustomToken(6969,IntToString(iVar));

    return TRUE;
}
