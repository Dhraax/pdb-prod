int StartingConditional()
{
object oContenedor = GetObjectByTag("spawn_encuentros");
int iDmg = GetLocalInt(oContenedor, "Dmg");
switch(iDmg)
{
case 0: { SetCustomToken(6001,"Ninguno"); } break;
case 1: { SetCustomToken(6001,"Daño 1"); } break;
case 2: { SetCustomToken(6001,"Daño 2"); } break;
case 3: { SetCustomToken(6001,"Daño 3"); } break;
case 4: { SetCustomToken(6001,"Daño 4"); } break;
case 5: { SetCustomToken(6001,"Daño 5"); } break;
case 16: { SetCustomToken(6001,"Daño 6"); } break;
case 17: { SetCustomToken(6001,"Daño 7"); } break;
case 18: { SetCustomToken(6001,"Daño 8"); } break;
case 19: { SetCustomToken(6001,"Daño 9"); } break;
case 20: { SetCustomToken(6001,"Daño 10"); } break;
case 6: { SetCustomToken(6001,"Daño 1d4"); } break;
case 7: { SetCustomToken(6001,"Daño 1d6"); } break;
case 8: { SetCustomToken(6001,"Daño 1d8"); } break;
case 9: { SetCustomToken(6001,"Daño 1d10"); } break;
case 10: { SetCustomToken(6001,"Daño 2d6"); } break;
case 11: { SetCustomToken(6001,"Daño 2d8"); } break;
case 12: { SetCustomToken(6001,"Daño 2d4"); } break;
case 13: { SetCustomToken(6001,"Daño 2d10"); } break;
case 14: { SetCustomToken(6001,"Daño 1d12"); } break;
case 15: { SetCustomToken(6001,"Daño 2d12"); } break;
}

    return TRUE;
}
