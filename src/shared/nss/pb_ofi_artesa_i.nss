//::///////////////////////////////////////////////
//:: OFICIO DE ARTESANIA URDIMBRICA, INCLUDE
//:: Copyright (c) www.puertadebladur.net
//:://////////////////////////////////////////////
/*
  3er Oficio de Artesania Urdimbrica.
  Funciones principales del sistema. Contiene la mayoria de
  comprobaciones y todos los encantamientos
*/
//:://////////////////////////////////////////////
//:: Created By: Monti
//:: Created On: 16 de Agosto de 2013
//:://////////////////////////////////////////////

#include "pb_nivellanzador"
#include "sute_libreria"
#include "x2_inc_itemprop"
#include "colors_inc"
#include "lib_race"

struct OficioArtesaniaUrdimbrica
{
    int iDificultad;
    int iAumentoOroVenta;
    int iXPExito;
    int iCosteXP;
};

struct OficioArtesaniaUrdimbrica ObtenerDatosNivel(int iNivel)
{
    struct OficioArtesaniaUrdimbrica ValorADevolver;

    switch(iNivel)
    {
        case 1:  { ValorADevolver.iDificultad = 101; ValorADevolver.iAumentoOroVenta = 25;   ValorADevolver.iXPExito = 40;   ValorADevolver.iCosteXP = 20; } break;
        case 2:  { ValorADevolver.iDificultad = 104; ValorADevolver.iAumentoOroVenta = 37;   ValorADevolver.iXPExito = 80;   ValorADevolver.iCosteXP = 22; } break;
        case 3:  { ValorADevolver.iDificultad = 108; ValorADevolver.iAumentoOroVenta = 49;   ValorADevolver.iXPExito = 120;  ValorADevolver.iCosteXP = 24; } break;
        case 4:  { ValorADevolver.iDificultad = 111; ValorADevolver.iAumentoOroVenta = 61;   ValorADevolver.iXPExito = 160;  ValorADevolver.iCosteXP = 27; } break;
        case 5:  { ValorADevolver.iDificultad = 115; ValorADevolver.iAumentoOroVenta = 73;   ValorADevolver.iXPExito = 200;  ValorADevolver.iCosteXP = 29; } break;
        case 6:  { ValorADevolver.iDificultad = 118; ValorADevolver.iAumentoOroVenta = 84;   ValorADevolver.iXPExito = 240;  ValorADevolver.iCosteXP = 31; } break;
        case 7:  { ValorADevolver.iDificultad = 122; ValorADevolver.iAumentoOroVenta = 96;   ValorADevolver.iXPExito = 280;  ValorADevolver.iCosteXP = 33; } break;
        case 8:  { ValorADevolver.iDificultad = 125; ValorADevolver.iAumentoOroVenta = 108;  ValorADevolver.iXPExito = 320;  ValorADevolver.iCosteXP = 35; } break;
        case 9:  { ValorADevolver.iDificultad = 129; ValorADevolver.iAumentoOroVenta = 120;  ValorADevolver.iXPExito = 360;  ValorADevolver.iCosteXP = 38; } break;
        case 10: { ValorADevolver.iDificultad = 132; ValorADevolver.iAumentoOroVenta = 132;  ValorADevolver.iXPExito = 400;  ValorADevolver.iCosteXP = 40; } break;
        case 11: { ValorADevolver.iDificultad = 135; ValorADevolver.iAumentoOroVenta = 143;  ValorADevolver.iXPExito = 440;  ValorADevolver.iCosteXP = 42; } break;
        case 12: { ValorADevolver.iDificultad = 139; ValorADevolver.iAumentoOroVenta = 156;  ValorADevolver.iXPExito = 480;  ValorADevolver.iCosteXP = 44; } break;
        case 13: { ValorADevolver.iDificultad = 142; ValorADevolver.iAumentoOroVenta = 168;  ValorADevolver.iXPExito = 520;  ValorADevolver.iCosteXP = 46; } break;
        case 14: { ValorADevolver.iDificultad = 146; ValorADevolver.iAumentoOroVenta = 180;  ValorADevolver.iXPExito = 560;  ValorADevolver.iCosteXP = 48; } break;
        case 15: { ValorADevolver.iDificultad = 149; ValorADevolver.iAumentoOroVenta = 191;  ValorADevolver.iXPExito = 600;  ValorADevolver.iCosteXP = 51; } break;
        case 16: { ValorADevolver.iDificultad = 152; ValorADevolver.iAumentoOroVenta = 203;  ValorADevolver.iXPExito = 640;  ValorADevolver.iCosteXP = 53; } break;
        case 17: { ValorADevolver.iDificultad = 156; ValorADevolver.iAumentoOroVenta = 215;  ValorADevolver.iXPExito = 680;  ValorADevolver.iCosteXP = 55; } break;
        case 18: { ValorADevolver.iDificultad = 159; ValorADevolver.iAumentoOroVenta = 227;  ValorADevolver.iXPExito = 720;  ValorADevolver.iCosteXP = 57; } break;
        case 19: { ValorADevolver.iDificultad = 163; ValorADevolver.iAumentoOroVenta = 239;  ValorADevolver.iXPExito = 760;  ValorADevolver.iCosteXP = 59; } break;
        case 20: { ValorADevolver.iDificultad = 166; ValorADevolver.iAumentoOroVenta = 251;  ValorADevolver.iXPExito = 800;  ValorADevolver.iCosteXP = 62; } break;
        case 21: { ValorADevolver.iDificultad = 169; ValorADevolver.iAumentoOroVenta = 263;  ValorADevolver.iXPExito = 840;  ValorADevolver.iCosteXP = 64; } break;
        case 22: { ValorADevolver.iDificultad = 173; ValorADevolver.iAumentoOroVenta = 275;  ValorADevolver.iXPExito = 880;  ValorADevolver.iCosteXP = 66; } break;
        case 23: { ValorADevolver.iDificultad = 176; ValorADevolver.iAumentoOroVenta = 287;  ValorADevolver.iXPExito = 920;  ValorADevolver.iCosteXP = 68; } break;
        case 24: { ValorADevolver.iDificultad = 180; ValorADevolver.iAumentoOroVenta = 298;  ValorADevolver.iXPExito = 960;  ValorADevolver.iCosteXP = 70; } break;
        case 25: { ValorADevolver.iDificultad = 183; ValorADevolver.iAumentoOroVenta = 310;  ValorADevolver.iXPExito = 1000; ValorADevolver.iCosteXP = 73; } break;
        case 26: { ValorADevolver.iDificultad = 186; ValorADevolver.iAumentoOroVenta = 322;  ValorADevolver.iXPExito = 1040; ValorADevolver.iCosteXP = 75; } break;
        case 27: { ValorADevolver.iDificultad = 190; ValorADevolver.iAumentoOroVenta = 334;  ValorADevolver.iXPExito = 1080; ValorADevolver.iCosteXP = 77; } break;
        case 28: { ValorADevolver.iDificultad = 193; ValorADevolver.iAumentoOroVenta = 346;  ValorADevolver.iXPExito = 1120; ValorADevolver.iCosteXP = 79; } break;
        case 29: { ValorADevolver.iDificultad = 197; ValorADevolver.iAumentoOroVenta = 357;  ValorADevolver.iXPExito = 1160; ValorADevolver.iCosteXP = 81; } break;
        case 30: { ValorADevolver.iDificultad = 200; ValorADevolver.iAumentoOroVenta = 369;  ValorADevolver.iXPExito = 1200; ValorADevolver.iCosteXP = 84; } break;
        case 31: { ValorADevolver.iDificultad = 203; ValorADevolver.iAumentoOroVenta = 382;  ValorADevolver.iXPExito = 1240; ValorADevolver.iCosteXP = 86; } break;
        case 32: { ValorADevolver.iDificultad = 207; ValorADevolver.iAumentoOroVenta = 394;  ValorADevolver.iXPExito = 1280; ValorADevolver.iCosteXP = 88; } break;
        case 33: { ValorADevolver.iDificultad = 210; ValorADevolver.iAumentoOroVenta = 405;  ValorADevolver.iXPExito = 1320; ValorADevolver.iCosteXP = 90; } break;
        case 34: { ValorADevolver.iDificultad = 213; ValorADevolver.iAumentoOroVenta = 417;  ValorADevolver.iXPExito = 1360; ValorADevolver.iCosteXP = 92; } break;
        case 35: { ValorADevolver.iDificultad = 217; ValorADevolver.iAumentoOroVenta = 439;  ValorADevolver.iXPExito = 1400; ValorADevolver.iCosteXP = 96; } break;
        case 36: { ValorADevolver.iDificultad = 220; ValorADevolver.iAumentoOroVenta = 441;  ValorADevolver.iXPExito = 1440; ValorADevolver.iCosteXP = 97; } break;
        case 37: { ValorADevolver.iDificultad = 224; ValorADevolver.iAumentoOroVenta = 453;  ValorADevolver.iXPExito = 1480; ValorADevolver.iCosteXP = 99; } break;
        case 38: { ValorADevolver.iDificultad = 227; ValorADevolver.iAumentoOroVenta = 465;  ValorADevolver.iXPExito = 1520; ValorADevolver.iCosteXP = 101; } break;
        case 39: { ValorADevolver.iDificultad = 231; ValorADevolver.iAumentoOroVenta = 477;  ValorADevolver.iXPExito = 1560; ValorADevolver.iCosteXP = 103; } break;
        case 40: { ValorADevolver.iDificultad = 234; ValorADevolver.iAumentoOroVenta = 489;  ValorADevolver.iXPExito = 1600; ValorADevolver.iCosteXP = 105; } break;
        case 41: { ValorADevolver.iDificultad = 237; ValorADevolver.iAumentoOroVenta = 501;  ValorADevolver.iXPExito = 1640; ValorADevolver.iCosteXP = 108; } break;
        case 42: { ValorADevolver.iDificultad = 241; ValorADevolver.iAumentoOroVenta = 512;  ValorADevolver.iXPExito = 1680; ValorADevolver.iCosteXP = 110; } break;
        case 43: { ValorADevolver.iDificultad = 244; ValorADevolver.iAumentoOroVenta = 524;  ValorADevolver.iXPExito = 1720; ValorADevolver.iCosteXP = 112; } break;
        case 44: { ValorADevolver.iDificultad = 248; ValorADevolver.iAumentoOroVenta = 536;  ValorADevolver.iXPExito = 1760; ValorADevolver.iCosteXP = 114; } break;
        case 45: { ValorADevolver.iDificultad = 251; ValorADevolver.iAumentoOroVenta = 548;  ValorADevolver.iXPExito = 1800; ValorADevolver.iCosteXP = 116; } break;
        case 46: { ValorADevolver.iDificultad = 254; ValorADevolver.iAumentoOroVenta = 560;  ValorADevolver.iXPExito = 1840; ValorADevolver.iCosteXP = 119; } break;
        case 47: { ValorADevolver.iDificultad = 258; ValorADevolver.iAumentoOroVenta = 572;  ValorADevolver.iXPExito = 1880; ValorADevolver.iCosteXP = 121; } break;
        case 48: { ValorADevolver.iDificultad = 261; ValorADevolver.iAumentoOroVenta = 584;  ValorADevolver.iXPExito = 1920; ValorADevolver.iCosteXP = 123; } break;
        case 49: { ValorADevolver.iDificultad = 265; ValorADevolver.iAumentoOroVenta = 596;  ValorADevolver.iXPExito = 1960; ValorADevolver.iCosteXP = 125; } break;
        case 50: { ValorADevolver.iDificultad = 269; ValorADevolver.iAumentoOroVenta = 608;  ValorADevolver.iXPExito = 2000; ValorADevolver.iCosteXP = 127; } break;
        case 51: { ValorADevolver.iDificultad = 273; ValorADevolver.iAumentoOroVenta = 620;  ValorADevolver.iXPExito = 2040; ValorADevolver.iCosteXP = 130; } break;
        case 52: { ValorADevolver.iDificultad = 276; ValorADevolver.iAumentoOroVenta = 631;  ValorADevolver.iXPExito = 2080; ValorADevolver.iCosteXP = 132; } break;
        case 53: { ValorADevolver.iDificultad = 280; ValorADevolver.iAumentoOroVenta = 643;  ValorADevolver.iXPExito = 2120; ValorADevolver.iCosteXP = 134; } break;
        case 54: { ValorADevolver.iDificultad = 283; ValorADevolver.iAumentoOroVenta = 655;  ValorADevolver.iXPExito = 2160; ValorADevolver.iCosteXP = 136; } break;
        case 55: { ValorADevolver.iDificultad = 287; ValorADevolver.iAumentoOroVenta = 667;  ValorADevolver.iXPExito = 2200; ValorADevolver.iCosteXP = 138; } break;
        case 56: { ValorADevolver.iDificultad = 290; ValorADevolver.iAumentoOroVenta = 679;  ValorADevolver.iXPExito = 2240; ValorADevolver.iCosteXP = 141; } break;
        case 57: { ValorADevolver.iDificultad = 294; ValorADevolver.iAumentoOroVenta = 691;  ValorADevolver.iXPExito = 2280; ValorADevolver.iCosteXP = 143; } break;
        case 58: { ValorADevolver.iDificultad = 297; ValorADevolver.iAumentoOroVenta = 703;  ValorADevolver.iXPExito = 2320; ValorADevolver.iCosteXP = 145; } break;
        case 59: { ValorADevolver.iDificultad = 301; ValorADevolver.iAumentoOroVenta = 715;  ValorADevolver.iXPExito = 2360; ValorADevolver.iCosteXP = 147; } break;
        case 60: { ValorADevolver.iDificultad = 304; ValorADevolver.iAumentoOroVenta = 727;  ValorADevolver.iXPExito = 2400; ValorADevolver.iCosteXP = 149; } break;
        case 61: { ValorADevolver.iDificultad = 308; ValorADevolver.iAumentoOroVenta = 738;  ValorADevolver.iXPExito = 2440; ValorADevolver.iCosteXP = 151; } break;
        case 62: { ValorADevolver.iDificultad = 311; ValorADevolver.iAumentoOroVenta = 750;  ValorADevolver.iXPExito = 2480; ValorADevolver.iCosteXP = 154; } break;
        case 63: { ValorADevolver.iDificultad = 315; ValorADevolver.iAumentoOroVenta = 763;  ValorADevolver.iXPExito = 2520; ValorADevolver.iCosteXP = 156; } break;
        case 64: { ValorADevolver.iDificultad = 318; ValorADevolver.iAumentoOroVenta = 774;  ValorADevolver.iXPExito = 2560; ValorADevolver.iCosteXP = 158; } break;
        case 65: { ValorADevolver.iDificultad = 322; ValorADevolver.iAumentoOroVenta = 785;  ValorADevolver.iXPExito = 2600; ValorADevolver.iCosteXP = 160; } break;
        case 66: { ValorADevolver.iDificultad = 325; ValorADevolver.iAumentoOroVenta = 798;  ValorADevolver.iXPExito = 2640; ValorADevolver.iCosteXP = 162; } break;
        case 67: { ValorADevolver.iDificultad = 329; ValorADevolver.iAumentoOroVenta = 809;  ValorADevolver.iXPExito = 2680; ValorADevolver.iCosteXP = 165; } break;
        case 68: { ValorADevolver.iDificultad = 332; ValorADevolver.iAumentoOroVenta = 822;  ValorADevolver.iXPExito = 2720; ValorADevolver.iCosteXP = 167; } break;
        case 69: { ValorADevolver.iDificultad = 335; ValorADevolver.iAumentoOroVenta = 834;  ValorADevolver.iXPExito = 2760; ValorADevolver.iCosteXP = 169; } break;
        case 70: { ValorADevolver.iDificultad = 338; ValorADevolver.iAumentoOroVenta = 845;  ValorADevolver.iXPExito = 2800; ValorADevolver.iCosteXP = 171; } break;
        case 71: { ValorADevolver.iDificultad = 342; ValorADevolver.iAumentoOroVenta = 857;  ValorADevolver.iXPExito = 2840; ValorADevolver.iCosteXP = 173; } break;
        case 72: { ValorADevolver.iDificultad = 346; ValorADevolver.iAumentoOroVenta = 869;  ValorADevolver.iXPExito = 2880; ValorADevolver.iCosteXP = 176; } break;
        case 73: { ValorADevolver.iDificultad = 350; ValorADevolver.iAumentoOroVenta = 881;  ValorADevolver.iXPExito = 2920; ValorADevolver.iCosteXP = 178; } break;
        case 74: { ValorADevolver.iDificultad = 354; ValorADevolver.iAumentoOroVenta = 892;  ValorADevolver.iXPExito = 2960; ValorADevolver.iCosteXP = 180; } break;
        case 75: { ValorADevolver.iDificultad = 357; ValorADevolver.iAumentoOroVenta = 905;  ValorADevolver.iXPExito = 3000; ValorADevolver.iCosteXP = 182; } break;
        case 76: { ValorADevolver.iDificultad = 360; ValorADevolver.iAumentoOroVenta = 917;  ValorADevolver.iXPExito = 3040; ValorADevolver.iCosteXP = 184; } break;
        case 77: { ValorADevolver.iDificultad = 363; ValorADevolver.iAumentoOroVenta = 929;  ValorADevolver.iXPExito = 3080; ValorADevolver.iCosteXP = 187; } break;
        case 78: { ValorADevolver.iDificultad = 367; ValorADevolver.iAumentoOroVenta = 941;  ValorADevolver.iXPExito = 3120; ValorADevolver.iCosteXP = 189; } break;
        case 79: { ValorADevolver.iDificultad = 370; ValorADevolver.iAumentoOroVenta = 953;  ValorADevolver.iXPExito = 3160; ValorADevolver.iCosteXP = 191; } break;
        case 80: { ValorADevolver.iDificultad = 374; ValorADevolver.iAumentoOroVenta = 965;  ValorADevolver.iXPExito = 3200; ValorADevolver.iCosteXP = 193; } break;
        case 81: { ValorADevolver.iDificultad = 377; ValorADevolver.iAumentoOroVenta = 976;  ValorADevolver.iXPExito = 3240; ValorADevolver.iCosteXP = 195; } break;
        case 82: { ValorADevolver.iDificultad = 380; ValorADevolver.iAumentoOroVenta = 988;  ValorADevolver.iXPExito = 3280; ValorADevolver.iCosteXP = 198; } break;
        case 83: { ValorADevolver.iDificultad = 383; ValorADevolver.iAumentoOroVenta = 1000; ValorADevolver.iXPExito = 3320; ValorADevolver.iCosteXP = 200; } break;
    }

    return ValorADevolver;
}

int CalculoSiguienteNivelXPArtesaniaUrdimbrica(int iNivelArtesano)
{
  return iNivelArtesano * (iNivelArtesano + 1) * 100;
}

int ConjurosTerceraEsfera(object oPC)
{
  int iNivelMago = GetLevelByClass(CLASS_TYPE_WIZARD, oPC);
  if(iNivelMago > 0)
  {
      if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC)       > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
      if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC)    > 0) iNivelMago += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelMago += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC)    > 0) iNivelMago += GetLevelByClass(CLASS_TYPE_TEURGO_MIST, oPC);
  }

  int iNivelHechi = GetLevelByClass(CLASS_TYPE_SORCERER, oPC);
  if(iNivelHechi > 0)
  {
      if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC)       > 0) iNivelHechi += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
      if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC)    > 0) iNivelHechi += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelHechi += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
  }

  int iNivelBardo = GetLevelByClass(CLASS_TYPE_BARD, oPC);
  if(iNivelBardo > 0)
  {
      if(GetLevelByClass(CLASS_TYPE_PALEMASTER, oPC)       > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_PALEMASTER, oPC);
      if(GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC)    > 0) iNivelBardo += GetLevelByClass(CLASS_TYPE_BRIBON_ARCANO, oPC);
      if(GetLevelByClass(CLASS_TYPE_CABALLERO_ARCANO, oPC) > 0) iNivelBardo += GetSpecialCasterLevel(CLASS_TYPE_CABALLERO_ARCANO, oPC);
  }

  int iNivelClerigo     = GetLevelByClass(CLASS_TYPE_CLERIC, oPC);
  int iNivelDruida      = GetLevelByClass(CLASS_TYPE_DRUID, oPC);
  int iNivelExplo       = GetLevelByClass(CLASS_TYPE_RANGER, oPC);
  int iNivelPaladin     = GetLevelByClass(CLASS_TYPE_PALADIN, oPC);
  int iNivelGNegro      = GetLevelByClass(CLASS_TYPE_BLACKGUARD, oPC);
  int iNivelAsesino     = GetLevelByClass(CLASS_TYPE_ASSASSIN, oPC);
  int iNivelArpista     = GetLevelByClass(CLASS_TYPE_HARPER, oPC);
  int iNivelIngeniero   = GetLevelByClass(CLASS_TYPE_INGENIERO, oPC);

  if(iNivelMago    < 5  && // Int
     iNivelHechi   < 6  && // Car
     iNivelBardo   < 7  && // Car
     iNivelClerigo < 5  && // Sab
     iNivelDruida  < 5  && // Sab
     iNivelExplo   < 11 && // Sab
     iNivelPaladin < 11 && // Sab
     iNivelGNegro  < 5  && // Sab
     iNivelAsesino < 5  && // Int
     iNivelIngeniero < 9  && // Int
     iNivelArpista < 5)    // Car
  {
      SendMessageToPC(oPC, "<cþ<<>Debes ser un lanzador de conjuros de 3ª esfera para poder ser artesano urdímbrico.</c>");
      return FALSE;
  }

// Ya de paso calculamos su caracteristica principal
string sCaracteristica = "Sabiduría";
int iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_WISDOM, oPC);

    if(iNivelMago >= iNivelHechi && iNivelMago >= iNivelBardo   && iNivelMago >= iNivelClerigo && iNivelMago >= iNivelDruida &&
    iNivelMago >= iNivelExplo && iNivelMago >= iNivelPaladin && iNivelMago >= iNivelGNegro  && iNivelMago >= iNivelArpista &&
    iNivelMago >= iNivelIngeniero && iNivelMago >= iNivelAsesino) {
        sCaracteristica = "Inteligencia";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
    }
    else if(iNivelIngeniero >= iNivelMago && iNivelIngeniero >= iNivelHechi && iNivelIngeniero >= iNivelBardo &&
            iNivelIngeniero >= iNivelClerigo && iNivelIngeniero >= iNivelDruida && iNivelIngeniero >= iNivelExplo &&
            iNivelIngeniero >= iNivelPaladin && iNivelIngeniero >= iNivelGNegro && iNivelIngeniero >= iNivelArpista &&
            iNivelIngeniero >= iNivelAsesino) {
        sCaracteristica = "Inteligencia";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
    }
    else if(iNivelHechi >= iNivelMago    && iNivelHechi >= iNivelClerigo && iNivelHechi >= iNivelDruida && iNivelHechi >= iNivelExplo &&
            iNivelHechi >= iNivelPaladin && iNivelHechi >= iNivelGNegro  && iNivelHechi >= iNivelAsesino && iNivelHechi >= iNivelIngeniero) {
        sCaracteristica = "Carisma";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_CHARISMA, oPC);
    }
    else if(iNivelBardo >= iNivelMago    && iNivelBardo >= iNivelClerigo && iNivelBardo >= iNivelDruida && iNivelBardo >= iNivelExplo &&
            iNivelBardo >= iNivelPaladin && iNivelBardo >= iNivelGNegro  && iNivelBardo >= iNivelAsesino && iNivelBardo >= iNivelIngeniero) {
        sCaracteristica = "Carisma";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_CHARISMA, oPC);
    }
    else if(iNivelAsesino >= iNivelHechi && iNivelAsesino >= iNivelBardo   && iNivelAsesino >= iNivelClerigo && iNivelAsesino >= iNivelDruida &&
            iNivelAsesino >= iNivelExplo && iNivelAsesino >= iNivelPaladin && iNivelAsesino >= iNivelGNegro  && iNivelAsesino >= iNivelArpista &&
            iNivelAsesino >= iNivelIngeniero) {
        sCaracteristica = "Inteligencia";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_INTELLIGENCE, oPC);
    }
    else if(iNivelArpista >= iNivelMago    && iNivelArpista >= iNivelClerigo && iNivelArpista >= iNivelDruida && iNivelArpista >= iNivelExplo &&
            iNivelArpista >= iNivelPaladin && iNivelArpista >= iNivelGNegro  && iNivelArpista >= iNivelAsesino && iNivelArpista >= iNivelIngeniero) {
        sCaracteristica = "Carisma";
        iPuntuacion = bonoRealCaracteristicaPJ(ABILITY_CHARISMA, oPC);
    }

  SetLocalString(oPC, "ARTESA_CARACTERISTICA", sCaracteristica);
  SetLocalInt(oPC, "ARTESA_CARACTERISTICA_PUNT", iPuntuacion);

  return TRUE;
}

void AnimacionEncantamiento(object oPC, string sMensaje, int iAnimacionFinal, int iEfectoFinal, int iTipo = 0)
{
  object oArea = GetArea(OBJECT_SELF);
  vector vPosition = GetPosition(OBJECT_SELF);
  float fOrientation = GetFacing(OBJECT_SELF);

  location myLocation = Location(oArea, vPosition + Vector(0.0, 0.0, 1.0), fOrientation);
  object oUbicadoInvisible = CreateObject(OBJECT_TYPE_PLACEABLE, "nonstaticinvis", myLocation);

  SetLocked(OBJECT_SELF, TRUE);
  SetLockKeyRequired(OBJECT_SELF, TRUE);
  SetLockKeyTag(OBJECT_SELF, "xxxx");

  AssignCommand(oPC, ClearAllActions());

  if(iTipo == 0)
  {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 16.5));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 18.0);
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oUbicadoInvisible, BODY_NODE_CHEST), oPC, 17.0));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
      DelayCommand(4.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
      DelayCommand(6.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
      DelayCommand(8.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(10.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
      DelayCommand(10.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(12.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
      DelayCommand(12.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(14.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
      DelayCommand(14.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(16.5, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(257 + Random(6)), myLocation));
      DelayCommand(16.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(18.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoFinal), myLocation));
      DelayCommand(18.0, AssignCommand(oPC, ActionPlayAnimation(iAnimacionFinal)));
      DelayCommand(18.0, DeleteLocalInt(OBJECT_SELF, "ANTI_SPAM"));
      DelayCommand(18.5, SendMessageToPC(oPC, sMensaje));
      DelayCommand(18.5, DeleteLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR"));
      DelayCommand(18.5, SetLockKeyTag(OBJECT_SELF, ""));
      DelayCommand(18.5, SetLockKeyRequired(OBJECT_SELF, FALSE));
      DelayCommand(18.5, SetLocked(OBJECT_SELF, FALSE));
      DestroyObject(oUbicadoInvisible, 18.6);
  }
  else
  {
      AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0, 2.5));
      ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCutsceneImmobilize(), oPC, 3.0);
      DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBeam(VFX_BEAM_LIGHTNING, oUbicadoInvisible, BODY_NODE_CHEST), oPC, 2.5));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(194 + Random(11)), myLocation));
      DelayCommand(2.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(86 + Random(4)), myLocation));
      DelayCommand(3.0, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEfectoFinal), myLocation));
      DelayCommand(3.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamage(d6(3), FloatToInt(pow(2.0, IntToFloat(d10())))), oPC));
      DelayCommand(3.0, AssignCommand(oPC, ActionPlayAnimation(iAnimacionFinal)));
      DelayCommand(3.0, DeleteLocalInt(OBJECT_SELF, "ANTI_SPAM"));
      DelayCommand(3.5, SendMessageToPC(oPC, sMensaje));
      DelayCommand(3.5, DeleteLocalObject(OBJECT_SELF, "OBJETO_A_ENCANTAR"));
      DelayCommand(3.5, SetLockKeyTag(OBJECT_SELF, ""));
      DelayCommand(3.5, SetLockKeyRequired(OBJECT_SELF, FALSE));
      DelayCommand(3.5, SetLocked(OBJECT_SELF, FALSE));
      DestroyObject(oUbicadoInvisible, 3.6);
  }
}

void DestruirTodoExceptoObjetoEncantable()
{
  string sTag, sTag1, sTag2, sTag3, sTag4, sTag5;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sTag = GetTag(oComponente);
      sTag1 = GetStringLeft(sTag, 7);
      sTag2 = GetStringLeft(sTag, 3);
      sTag3 = GetStringLeft(sTag, 8);
      sTag4 = GetStringLeft(sTag, 4);
      sTag5 = GetStringLeft(sTag, 6);

      if(sTag1 != "anillo_" && // Orfebreria
         sTag4 != "amu_" &&
         sTag3 != "platino_" &&
         sTag2 != "pi_"      && // Carpinteria
         sTag2 != "ci_"      &&
         sTag2 != "ab_"      &&
         sTag2 != "ce_"      &&
         sTag2 != "al_"      &&
         sTag2 != "ol_"      &&
         sTag2 != "ro_"      &&
         sTag2 != "fr_"      &&
         sTag2 != "hr_"      && // Herreria
         sTag2 != "co_"      &&
         sTag2 != "ac_"      &&
         sTag2 != "pl_"      &&
         sTag2 != "hf_"      &&
         sTag2 != "or_"      &&
         sTag2 != "mi_"      &&
         sTag2 != "ad_"      &&
         sTag2 != "dl_"      &&
         sTag2 != "hi_"      &&
         sTag2 != "ac_"      &&
         sTag2 != "me_"      &&
         sTag5 != "meteo_"   &&
         sTag4 != "aco_"   &&
         sTag2 != "mi_"      )
      {
          DestroyObject(oComponente);
      }

      oComponente = GetNextItemInInventory();
  }
}

int BuclePropiedades(object oObjeto)
{
  int iContadorPropiedades = 0;
  itemproperty iPropiedad = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(iPropiedad))
  {
      if(GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_LIGHT                             &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_USE_LIMITATION_ALIGNMENT_GROUP    &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_USE_LIMITATION_CLASS              &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_USE_LIMITATION_RACIAL_TYPE        &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_USE_LIMITATION_SPECIFIC_ALIGNMENT &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_USE_LIMITATION_TILESET            &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_WEIGHT_INCREASE                   &&
         //GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION      &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_VISUALEFFECT                      &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_ADDITIONAL                        &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_ABILITY_SCORE           &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_AC                      &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_ATTACK_MODIFIER         &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_DAMAGE                  &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_ENHANCEMENT_MODIFIER    &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_SAVING_THROWS           &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_SAVING_THROWS_SPECIFIC  &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_DECREASED_SKILL_MODIFIER          &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_MATERIAL                          &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_QUALITY                           &&
         GetItemPropertyType(iPropiedad) != ITEM_PROPERTY_NO_DAMAGE                         &&
         GetItemPropertyType(iPropiedad) != 150                                             && // Limitacion uso genero
         GetItemPropertyType(iPropiedad) != 155                                             && // Valor disminuido
         GetItemPropertyType(iPropiedad) != 156)                                               // Valor aumentado
      {
          iContadorPropiedades = iContadorPropiedades + 1;
      }

      iPropiedad = GetNextItemProperty(oObjeto);
  }

  return iContadorPropiedades;
}

void ProbabilidadRotura(object oObjeto)
{
  int iRoturaObjeto = GetLocalInt(oObjeto, "ENCANTAMIENTO_ROTURA");
  if(iRoturaObjeto >= 3)
  {
      DestroyObject(oObjeto);
      CreateItemOnObject("pb_artesa_rotura", OBJECT_SELF);
  }
  else SetLocalInt(oObjeto, "ENCANTAMIENTO_ROTURA", iRoturaObjeto + d2());
}

int RequisitosCristalesEsencias(object oPC, object oObjeto, int iContadorCristales, int iContadorEsencias)
{
  if(iContadorCristales == 0)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! No hay ningún cristal urdímbrico válido para el encantamiento escogido.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return FALSE;
  }
  else if(iContadorEsencias == 0 || iContadorEsencias > 1)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Debe de haber una esencia válida para el encantamiento escogido.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return FALSE;
  }

  return TRUE;
}

int RequisitoConocimientoConjuros(object oPC, object oObjeto, int iCD)
{
  int iConocimientoConjurosBase = GetSkillRank(SKILL_SPELLCRAFT, oPC, TRUE);
  if(iConocimientoConjurosBase < iCD)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Conocimientos de conjuros insuficiente. Necesitas "+IntToString(iCD)+" o más para este encantamiento.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return FALSE;
  }

  return TRUE;
}

int Material(int iGrado, string sTag3Derecha, string sTag3Izquierda)
{
  switch(iGrado)
  {
      //case 1: return TRUE; break; // No hace falta nunca comprobar el material 1, todos los materiales pueden en tal caso

      case 2: { if(sTag3Derecha != "zaf" && sTag3Izquierda != "pi_" && sTag3Izquierda != "hr_") return TRUE; } break;

      case 3: { if(sTag3Derecha != "zaf" && sTag3Izquierda != "pi_" && sTag3Izquierda != "hr_" &&
                   sTag3Derecha != "per" && sTag3Izquierda != "ci_" && sTag3Izquierda != "co_") return TRUE; } break;

      case 4: { if(sTag3Derecha != "zaf" && sTag3Izquierda != "pi_" && sTag3Izquierda != "hr_" &&
                   sTag3Derecha != "per" && sTag3Izquierda != "ci_" && sTag3Izquierda != "co_" &&
                   sTag3Derecha != "obs" && sTag3Izquierda != "ab_" && sTag3Izquierda != "ac_") return TRUE; } break;

      case 5: { if(sTag3Derecha == "top" || sTag3Izquierda == "al_" || sTag3Izquierda == "hf_" ||
                   sTag3Derecha == "dia" || sTag3Izquierda == "ol_" || sTag3Izquierda == "or_" ||
                   sTag3Derecha == "aza" || sTag3Izquierda == "ro_" || sTag3Izquierda == "mi_" ||
                   sTag3Derecha == "cua" || sTag3Izquierda == "fr_" || sTag3Izquierda == "ad_") return TRUE; } break;

      case 6: { if(sTag3Derecha == "dia" || sTag3Izquierda == "ol_" || sTag3Izquierda == "or_" ||
                   sTag3Derecha == "aza" || sTag3Izquierda == "ro_" || sTag3Izquierda == "mi_" ||
                   sTag3Derecha == "cua" || sTag3Izquierda == "fr_" || sTag3Izquierda == "ad_") return TRUE; } break;

      case 7: { if(sTag3Derecha == "aza" || sTag3Izquierda == "ro_" || sTag3Izquierda == "mi_" ||
                   sTag3Derecha == "cua" || sTag3Izquierda == "fr_" || sTag3Izquierda == "ad_") return TRUE; } break;

      case 8: { if(sTag3Derecha == "cua" || sTag3Izquierda == "fr_" || sTag3Izquierda == "ad_") return TRUE; } break;
  }

  return FALSE;
}

int CadenasAnillosOrfebreria(string sTag3Izquierda)
{
  if(sTag3Izquierda == "bro" || sTag3Izquierda == "pla" || sTag3Izquierda == "oro" )return TRUE;

  return FALSE;
}

int CadenasAnillosHerreria(string sTag3Derecha)
{
  /*if(sTag3Derecha == "aro" || sTag3Derecha == "ena") */return TRUE;

  return FALSE;
}

int ArmadurasEscudosYelmos(string sTag3Derecha, string sTag4Derecha) // Incluyo el baston ya que quiero que tenga propiedades defensivas
{
 /* if(sTag3Derecha == "dop" || sTag3Derecha == "dog" || sTag3Derecha == "doe"  ||
     sTag3Derecha == "orc" || sTag3Derecha == "rpm" || sTag3Derecha == "orl"  ||
     sTag3Derecha == "esc" || sTag3Derecha == "all" || sTag3Derecha == "raza" ||
     sTag3Derecha == "lmo" || sTag3Derecha == "opq" || sTag3Derecha == "opv"  ||
     sTag3Derecha == "ton") */return TRUE;

  return FALSE;
}

int Municion(string sTag3Derecha)
{
  /*if(sTag3Derecha == "cha" || sTag3Derecha == "ote" || sTag3Derecha == "ala")*/ return TRUE;

  return FALSE;
}

int ArmasDistancia(string sTag3Derecha)
{
  /*if(sTag3Derecha == "tal" || sTag3Derecha == "tap" || sTag3Derecha == "coc" ||
     sTag3Derecha == "col")*/ return TRUE;

  return FALSE;
}

int ArmasCuerpoACuerpo(string sTag3Derecha, string sTag4Derecha, string sTag3Izquierda) // Tambien incluyen las armas arrojadizas
{
  if(!CadenasAnillosOrfebreria(sTag3Izquierda)               &&
     !CadenasAnillosHerreria(sTag3Derecha)                   &&
     !ArmadurasEscudosYelmos(sTag3Derecha, sTag4Derecha)     &&
     !Municion(sTag3Derecha)                                 &&
     !ArmasDistancia(sTag3Derecha)) return TRUE;

  return FALSE;
}

int RequisitosMaterialObjeto(object oPC, object oObjeto, int iEncantamiento, int iSubtipoEncantamiento=0)
{
  string sTag = GetTag(oObjeto);
  string sTag3Izquierda = GetStringLeft(sTag, 3);
  string sTag3Derecha = GetStringRight(sTag, 3);
  string sTag4Derecha = GetStringRight(sTag, 4);

  switch(iEncantamiento)
  {
      // 1. Luz
      case 1: { if(CadenasAnillosOrfebreria(sTag3Izquierda) || CadenasAnillosHerreria(sTag3Derecha)) return TRUE; } break;

      // 2. Bonificador de habilidad
      case 2: { if(ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda)) return TRUE; } break;

      // 3. Limitacion de uso
      case 3: { if(Material(2, sTag3Derecha,sTag3Izquierda)) return TRUE; } break;

      // 4. Bonificados de salvacion
      case 4:
      {
          if(iSubtipoEncantamiento == 1)      { if(Material(2, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } // Especificos
          else if(iSubtipoEncantamiento == 2) { if(Material(3, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } // Normales
          else if(iSubtipoEncantamiento == 3) { if(Material(6, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } // Universales
      } break;

      // 5. Bonificador de CA
      case 5:
      {
          if(iSubtipoEncantamiento == 1 || iSubtipoEncantamiento == 2)      { if(Material(4, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } // Contra alineamiento y daño
          else if(iSubtipoEncantamiento == 3)                               { if(Material(6, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } // Universal
      } break;

      // 6. Bonificador de caracteristica
      case 6: { if(Material(5, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 7. Regeneracion
      case 7: { if(Material(7, sTag3Derecha,sTag3Izquierda) && CadenasAnillosOrfebreria(sTag3Izquierda)) return TRUE; } break;

      // 8. Huecos de conjuro
      case 8: { if(Material(2, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 9. Bonificador de daño
      case 9: { if(Material(3, sTag3Derecha,sTag3Izquierda) && (ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda) || Municion(sTag3Derecha))) return TRUE; } break;

      // 10. Resistencia al daño
      case 10: { if(Material(3, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 11. Resistencia a conjuros
      case 11: { if(Material(2, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 12. Reduccion al daño
      case 12: { if(Material(5, sTag3Derecha,sTag3Izquierda) && ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha)) return TRUE; } break;

      // 13. Inmunidad de conjuros por nivel
      case 13: { if(Material(8, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 14. Bonificador de ataque
      case 14:
      {
          if(iSubtipoEncantamiento == 1)      { if(Material(2, sTag3Derecha,sTag3Izquierda) && (ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda) || ArmasDistancia(sTag3Derecha))) return TRUE; } // Contra alineamiento
          else if(iSubtipoEncantamiento == 2) { if(Material(3, sTag3Derecha,sTag3Izquierda) && (ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda) || ArmasDistancia(sTag3Derecha))) return TRUE; } // Universal
      } break;

      // 15. Bonificador de mejora
      case 15:
      {
          if(iSubtipoEncantamiento == 1)      { if(Material(4, sTag3Derecha,sTag3Izquierda) && ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda)) return TRUE; } // Contra alineamiento
          else if(iSubtipoEncantamiento == 2) { if(Material(5, sTag3Derecha,sTag3Izquierda) && ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda)) return TRUE; } // Universal
      } break;

      // 16. Reg.vampirica
      case 16: { if(Material(2, sTag3Derecha,sTag3Izquierda) && ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda)) return TRUE; } break;

      // 17. Criticos masivos
      case 17: { if(ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda) || ArmasDistancia(sTag3Derecha)) return TRUE; } break;

      // 18. Efectos al golpear
      case 18: { if(Material(6, sTag3Derecha,sTag3Izquierda) && ArmasCuerpoACuerpo(sTag3Derecha,sTag4Derecha,sTag3Izquierda)) return TRUE; } break;

      // 19. Inmunidad al daño
      case 19: { if(Material(4, sTag3Derecha,sTag3Izquierda) && ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha)) return TRUE; } break;

      // 20. Vision en la oscuridad
      case 20: { if(Material(3, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 21. Peso reducido
      case 21: { if(ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha)) return TRUE; } break;

      // 22. Lanzar conjuro
      case 22: { if(Material(6, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 23. Inmunidad conjuro
      case 23: { if(Material(7, sTag3Derecha,sTag3Izquierda) && (ArmadurasEscudosYelmos(sTag3Derecha,sTag4Derecha) || CadenasAnillosOrfebreria(sTag3Izquierda))) return TRUE; } break;

      // 24. Municion infinita
      case 24: { if(Material(7, sTag3Derecha,sTag3Izquierda) && ArmasDistancia(sTag3Derecha)) return TRUE; } break;

      // 25. Reforzado
      case 25: { if(ArmasDistancia(sTag3Derecha)) return TRUE; } break;

  }

  AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El encantamiento no es apto para este tipo de objeto o material.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
  DestruirTodoExceptoObjetoEncantable();
  ProbabilidadRotura(oObjeto);
  return FALSE;
}

void AplicarRestriccionesClaseas(object oObjeto, int iConjuro)
{
  IPRemoveMatchingItemProperties(oObjeto, ITEM_PROPERTY_USE_LIMITATION_CLASS, DURATION_TYPE_PERMANENT);

  string sBardo      = Get2DAString("spells", "Bard",     iConjuro);
  string sClerigo    = Get2DAString("spells", "Cleric",   iConjuro);
  string sDruida     = Get2DAString("spells", "Druid",    iConjuro);
  string sPaladin    = Get2DAString("spells", "Paladin",  iConjuro);
  string sExplorador = Get2DAString("spells", "Ranger",   iConjuro);
  string sMagoHechi  = Get2DAString("spells", "Wiz_Sorc", iConjuro);

  if(sBardo != "")      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD));
  if(sClerigo != "")    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC));
  if(sDruida != "")     IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID));
  if(sPaladin != "")    IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN));
  if(sExplorador != "") IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER));
  if(sMagoHechi != "")
  {
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD));
      IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(IP_CONST_CLASS_SORCERER));
  }

  if(iConjuro == 165 || iConjuro == 16   || iConjuro == 1106 || iConjuro == 1127 || iConjuro == 1128 ||
     iConjuro == 354 || iConjuro == 13   || iConjuro == 90   || iConjuro == 157  || iConjuro == 365  ||
     iConjuro ==  20 || iConjuro == 1100 || iConjuro == 62   || iConjuro == 15   || iConjuro == 41) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_HARPER));

  if(iConjuro == 165 || iConjuro == 415  || iConjuro == 1138 || iConjuro == 1139 || iConjuro == 1127 ||
     iConjuro == 356 || iConjuro == 90   || iConjuro == 13   || iConjuro == 36   || iConjuro == 1100 ||
     iConjuro == 105 || iConjuro == 1136 || iConjuro == 1137 || iConjuro == 15   || iConjuro == 998  ||
     iConjuro == 20  || iConjuro == 88   || iConjuro == 62   || iConjuro == 129  || iConjuro == 1129) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_ASSASSIN));

  if(iConjuro == 54 || iConjuro == 32  || iConjuro == 432 || iConjuro == 174 || iConjuro == 999 ||
     iConjuro == 36 || iConjuro == 34  || iConjuro == 433 || iConjuro == 175 || iConjuro == 9   ||
     iConjuro == 35 || iConjuro == 434 || iConjuro == 176 || iConjuro == 137 || iConjuro == 27  ||
     iConjuro == 31 || iConjuro == 435 || iConjuro == 177 || iConjuro == 62  || iConjuro == 129) IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByClass(CLASS_TYPE_BLACKGUARD));
}

int ObtenerInmunidadConjuro(int iConjuro)
{
  int iInmunidadConjuro;

  switch(iConjuro)
  {
      case 0    : iInmunidadConjuro = 0  ; break; // Acid_Fog
      case 1    : iInmunidadConjuro = 1  ; break; // Aid
      case 4    : iInmunidadConjuro = 3  ; break; // Bestow_Curse
      case 8    : iInmunidadConjuro = 6  ; break; // Blindness_and_Deafness
      case 10   : iInmunidadConjuro = 8  ; break; // Burning_Hands
      case 11   : iInmunidadConjuro = 9  ; break; // Call_Lightning
      case 14   : iInmunidadConjuro = 12 ; break; // Chain_Lightning
      case 15   : iInmunidadConjuro = 13 ; break; // Charm_Monster
      case 16   : iInmunidadConjuro = 14 ; break; // Charm_Person
      case 17   : iInmunidadConjuro = 15 ; break; // Charm_Person_or_Animal
      case 18   : iInmunidadConjuro = 16 ; break; // Circle_of_Death
      case 19   : iInmunidadConjuro = 17 ; break; // Circle_of_Doom
      case 23   : iInmunidadConjuro = 21 ; break; // Cloudkill
      case 24   : iInmunidadConjuro = 22 ; break; // Color_Spray
      case 25   : iInmunidadConjuro = 23 ; break; // Cone_of_Cold
      case 26   : iInmunidadConjuro = 24 ; break; // Confusion
      case 27   : iInmunidadConjuro = 25 ; break; // Contagion
      case 28   : iInmunidadConjuro = 26 ; break; // Control_Undead
      case 31   : iInmunidadConjuro = 27 ; break; // Cure_Critical_Wounds
      case 32   : iInmunidadConjuro = 28 ; break; // Cure_Light_Wounds
      case 33   : iInmunidadConjuro = 29 ; break; // Cure_Minor_Wounds
      case 34   : iInmunidadConjuro = 30 ; break; // Cure_Moderate_Wounds
      case 35   : iInmunidadConjuro = 31 ; break; // Cure_Serious_Wounds
      case 36   : iInmunidadConjuro = 32 ; break; // Darkness
      case 37   : iInmunidadConjuro = 33 ; break; // Daze
      case 38   : iInmunidadConjuro = 34 ; break; // Death_Ward
      case 39   : iInmunidadConjuro = 35 ; break; // Delayed_Blast_Fireball
      case 40   : iInmunidadConjuro = 36 ; break; // Dismissal
      case 41   : iInmunidadConjuro = 37 ; break; // Dispel_Magic
      case 43   : iInmunidadConjuro = 39 ; break; // Dominate_Animal
      case 44   : iInmunidadConjuro = 40 ; break; // Dominate_Monster
      case 45   : iInmunidadConjuro = 41 ; break; // Dominate_Person
      case 46   : iInmunidadConjuro = 42 ; break; // Doom
      case 51   : iInmunidadConjuro = 46 ; break; // Energy_Drain
      case 52   : iInmunidadConjuro = 47 ; break; // Enervation
      case 53   : iInmunidadConjuro = 48 ; break; // Entangle
      case 54   : iInmunidadConjuro = 49 ; break; // Fear
      case 55   : iInmunidadConjuro = 50 ; break; // Feeblemind
      case 56   : iInmunidadConjuro = 51 ; break; // Finger_of_Death
      case 57   : iInmunidadConjuro = 52 ; break; // Fire_Storm
      case 58   : iInmunidadConjuro = 53 ; break; // Fireball
      case 59   : iInmunidadConjuro = 54 ; break; // Flame_Arrow
      case 60   : iInmunidadConjuro = 55 ; break; // Flame_Lash
      case 61   : iInmunidadConjuro = 56 ; break; // Flame_Strike
      case 62   : iInmunidadConjuro = 57 ; break; // Freedom_of_Movement
      case 66   : iInmunidadConjuro = 59 ; break; // Grease
      case 67   : iInmunidadConjuro = 60 ; break; // Greater_Dispelling
      case 69   : iInmunidadConjuro = 62 ; break; // Greater_Planar_Binding
      case 71   : iInmunidadConjuro = 64 ; break; // Greater_Shadow_Conjuration
      case 72   : iInmunidadConjuro = 65 ; break; // Greater_Spell_Breach
      case 76   : iInmunidadConjuro = 68 ; break; // Hammer_of_the_Gods
      case 77   : iInmunidadConjuro = 69 ; break; // Harm
      case 79   : iInmunidadConjuro = 71 ; break; // Heal
      case 80   : iInmunidadConjuro = 72 ; break; // Healing_Circle
      case 81   : iInmunidadConjuro = 73 ; break; // Hold_Animal
      case 82   : iInmunidadConjuro = 74 ; break; // Hold_Monster
      case 83   : iInmunidadConjuro = 75 ; break; // Hold_Person
      case 87   : iInmunidadConjuro = 78 ; break; // Implosion
      case 88   : iInmunidadConjuro = 79 ; break; // Improved_Invisibility
      case 89   : iInmunidadConjuro = 80 ; break; // Incendiary_Cloud
      case 91   : iInmunidadConjuro = 82 ; break; // Invisibility_Purge
      case 94   : iInmunidadConjuro = 84 ; break; // Lesser_Dispel
      case 96   : iInmunidadConjuro = 86 ; break; // Lesser_Planar_Binding
      case 98   : iInmunidadConjuro = 88 ; break; // Lesser_Spell_Breach
      case 101  : iInmunidadConjuro = 91 ; break; // Lightning_Bolt
      case 107  : iInmunidadConjuro = 97 ; break; // Magic_Missile
      case 115  : iInmunidadConjuro = 105; break; // Melfs_Acid_Arrow
      case 116  : iInmunidadConjuro = 106; break; // Meteor_Swarm
      case 118  : iInmunidadConjuro = 108; break; // Mind_Fog
      case 122  : iInmunidadConjuro = 112; break; // Mordenkainens_Disjunction
      case 127  : iInmunidadConjuro = 116; break; // Phantasmal_Killer
      case 128  : iInmunidadConjuro = 117; break; // Planar_Binding
      case 129  : iInmunidadConjuro = 118; break; // Poison
      case 131  : iInmunidadConjuro = 120; break; // Power_Word,_Kill
      case 132  : iInmunidadConjuro = 121; break; // Power_Word,_Stun
      case 135  : iInmunidadConjuro = 124; break; // Prismatic_Spray
      case 143  : iInmunidadConjuro = 131; break; // Ray_of_Enfeeblement
      case 144  : iInmunidadConjuro = 132; break; // Ray_of_Frost
      case 155  : iInmunidadConjuro = 142; break; // Scare
      case 156  : iInmunidadConjuro = 143; break; // Searing_Light
      case 158  : iInmunidadConjuro = 145; break; // Shades
      case 159  : iInmunidadConjuro = 146; break; // Shadow_Conjuration
      case 163  : iInmunidadConjuro = 150; break; // Silence
      case 164  : iInmunidadConjuro = 151; break; // Slay_Living
      case 165  : iInmunidadConjuro = 152; break; // Sleep
      case 166  : iInmunidadConjuro = 153; break; // Slow
      case 167  : iInmunidadConjuro = 154; break; // Sound_Burst
      case 171  : iInmunidadConjuro = 158; break; // Stinking_Cloud
      case 172  : iInmunidadConjuro = 159; break; // Stoneskin
      case 173  : iInmunidadConjuro = 160; break; // Storm_of_Vengeance
      case 183  : iInmunidadConjuro = 161; break; // Sunbeam
      case 190  : iInmunidadConjuro = 166; break; // Wail_of_the_Banshee
      case 192  : iInmunidadConjuro = 167; break; // Web
      case 193  : iInmunidadConjuro = 168; break; // Weird
      case 194  : iInmunidadConjuro = 169; break; // Word_of_Faith
      case 322  : iInmunidadConjuro = 171; break; // Magic_Circle_against_Alignment
      case 373  : iInmunidadConjuro = 183; break; // War_Cry
      case 375  : iInmunidadConjuro = 185; break; // Evards_Black_Tentacles
      case 416  : iInmunidadConjuro = 190; break; // Flare
      case 424  : iInmunidadConjuro = 192; break; // Acid_Splash
      case 425  : iInmunidadConjuro = 193; break; // Quillfire
      case 427  : iInmunidadConjuro = 194; break; // Sunburst
      case 430  : iInmunidadConjuro = 195; break; // Banishment
      case 431  : iInmunidadConjuro = 196; break; // Inflict_Minor_Wounds
      case 432  : iInmunidadConjuro = 197; break; // Inflict_Light_Wounds
      case 433  : iInmunidadConjuro = 198; break; // Inflict_Moderate_Wounds
      case 434  : iInmunidadConjuro = 199; break; // Inflict_Serious_Wounds
      case 435  : iInmunidadConjuro = 200; break; // Inflict_Critical_Wounds
      case 437  : iInmunidadConjuro = 201; break; // Drown
      case 439  : iInmunidadConjuro = 202; break; // Electric_Jolt
      case 440  : iInmunidadConjuro = 203; break; // Firebrand
      case 445  : iInmunidadConjuro = 204; break; // Dirge
      case 446  : iInmunidadConjuro = 205; break; // Inferno
      case 447  : iInmunidadConjuro = 206; break; // Isaacs_Lesser_Missile_Storm
      case 448  : iInmunidadConjuro = 207; break; // Isaacs_Greater_Missile_Storm
      case 449  : iInmunidadConjuro = 208; break; // Bane
      case 454  : iInmunidadConjuro = 209; break; // Spike_Growth
      case 457  : iInmunidadConjuro = 210; break; // Tashas_Hideous_Laughter
      case 460  : iInmunidadConjuro = 211; break; // Bigbys_Forceful_Hand
      case 461  : iInmunidadConjuro = 212; break; // Bigbys_Grasping_Hand
      case 462  : iInmunidadConjuro = 213; break; // Bigbys_Clenched_Fist
      case 463  : iInmunidadConjuro = 214; break; // Bigbys_Crushing_Hand
      case 480  : iInmunidadConjuro = 215; break; // Sleep
      case 485  : iInmunidadConjuro = 216; break; // Flesh_to_stone
      case 512  : iInmunidadConjuro = 221; break; // Crumble
      case 513  : iInmunidadConjuro = 222; break; // Infestation_of_Maggots
      case 515  : iInmunidadConjuro = 224; break; // Great_Thunderclap
      case 516  : iInmunidadConjuro = 225; break; // Ball_Lightning
      case 517  : iInmunidadConjuro = 226; break; // Battletide
      case 518  : iInmunidadConjuro = 227; break; // Combust
      case 520  : iInmunidadConjuro = 228; break; // Gedlees_Electric_Loop
      case 521  : iInmunidadConjuro = 229; break; // Horizikauls_Boom
      case 523  : iInmunidadConjuro = 230; break; // Mestils_Acid_Breath
      case 526  : iInmunidadConjuro = 231; break; // Scintillating_Sphere
      case 528  : iInmunidadConjuro = 232; break; // Undeath_to_Death
      case 529  : iInmunidadConjuro = 233; break; // Vine_Mine
      case 543  : iInmunidadConjuro = 234; break; // Ice_Dagger
      case 547  : iInmunidadConjuro = 235; break; // Stonehold
      case 549  : iInmunidadConjuro = 236; break; // Glyph_of_Warding
      case 569  : iInmunidadConjuro = 237; break; // Cloud_of_Bewilderment
      case 686  : iInmunidadConjuro = 238; break; // CaptivatingSong
      case 713  : iInmunidadConjuro = 239; break; // Mindblast10
      case 459  : iInmunidadConjuro = 240; break; // Bigbys_Interposing_Hand
      case 1029 : iInmunidadConjuro = 242; break; // OrbeMenorDeAcido
      case 1030 : iInmunidadConjuro = 243; break; // OrbeMenorDeFrio
      case 1031 : iInmunidadConjuro = 244; break; // OrbeMenorDeElectricidad
      case 1032 : iInmunidadConjuro = 245; break; // OrbeMenorDeFuego
      case 1033 : iInmunidadConjuro = 246; break; // OrbeMenorDeSonido
      case 1034 : iInmunidadConjuro = 247; break; // OrbeDeAcido
      case 1035 : iInmunidadConjuro = 248; break; // OrbeDeFrio
      case 1036 : iInmunidadConjuro = 249; break; // OrbeDeElectricidad
      case 1037 : iInmunidadConjuro = 250; break; // OrbeDeFuego
      case 1038 : iInmunidadConjuro = 251; break; // OrbeDeSonido
      case 990  : iInmunidadConjuro = 289; break; // AnclaDimensional
      default: iInmunidadConjuro = -1; break;
  }

  return iInmunidadConjuro;
}

int ContarHabilidad(object oObjeto)
{
  int iHabilidad = 0;

  itemproperty ipPropiedad = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ipPropiedad))
  {
      if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_SKILL_BONUS)
      {
          iHabilidad = iHabilidad + GetItemPropertyCostTableValue(ipPropiedad);
      }

      ipPropiedad = GetNextItemProperty(oObjeto);
  }

  return iHabilidad;
}

int ContarSalvacion(object oObjeto)
{
  int iSalvacion = 0;

  itemproperty ipPropiedad = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ipPropiedad))
  {
      if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_SAVING_THROW_BONUS ||
         GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC)
      {
          iSalvacion = iSalvacion + GetItemPropertyCostTableValue(ipPropiedad);
      }

      ipPropiedad = GetNextItemProperty(oObjeto);
  }

  return iSalvacion;
}

int ContarSalvacionUniversal(object oObjeto)
{
  int iSalvacionUniversal = 0;

  itemproperty ipPropiedad = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ipPropiedad))
  {
      if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_SAVING_THROW_BONUS_SPECIFIC && GetItemPropertySubType(ipPropiedad) == 0)
      {
          iSalvacionUniversal = iSalvacionUniversal + GetItemPropertyCostTableValue(ipPropiedad);
      }

      ipPropiedad = GetNextItemProperty(oObjeto);
  }

  return iSalvacionUniversal;
}

int ContarCaracteristica(object oObjeto)
{
  int iCaracteristica = 0;

  itemproperty ipPropiedad = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ipPropiedad))
  {
      if(GetItemPropertyType(ipPropiedad) == ITEM_PROPERTY_ABILITY_BONUS)
      {
          iCaracteristica = iCaracteristica + GetItemPropertyCostTableValue(ipPropiedad);
      }

      ipPropiedad = GetNextItemProperty(oObjeto);
  }

  return iCaracteristica;
}

int ExitoEncantamiento(object oPC, object oObjeto, string sNombrePropiedad, int iDificultad, int iAumentoOroVenta, int iXPExito, int iCosteXP)
{
  // Ajustes generales
  DestruirTodoExceptoObjetoEncantable();

  // Lesiones
  int iLesion = FALSE;
  int iDadoCien = d100();
  if(iDadoCien <= 3)
  {
      ProbabilidadRotura(oObjeto);

      if(iDadoCien == 1) // Explosion magica
      {
          DelayCommand(18.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION), oPC));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(GetCurrentHitPoints(oPC) - d4(), DAMAGE_TYPE_ELECTRICAL), oPC));
          AnimacionEncantamiento(oPC, "<cþ<<>¡Algo falló y hubo una explosión mágica!</c>", ANIMATION_LOOPING_DEAD_BACK, 81);
          iLesion = TRUE;
      }
      else if(iDadoCien == 2) // Polimorfacion aleatoria
      {
          int iPolimorfacion = 51 + Random(56);
          if(d2() == 1) iPolimorfacion = Random(46);
          DelayCommand(18.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_POLYMORPH), oPC));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(iPolimorfacion, TRUE), oPC, 100.0));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 10.0));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 30.0));
          AnimacionEncantamiento(oPC, "<cþ<<>¡Algo falló y te has polimorfado en una criatura!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
      else // Invisivilidad DM
      {
          effect eLink = EffectLinkEffects(EffectCutsceneGhost(), EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
          DelayCommand(18.5, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(80), oPC));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(d2(), TRUE), oPC, 400.0));
          DelayCommand(18.6, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(d3(), d3(), d3(), d3(), d3(), d3()), oPC, 400.0));
          AnimacionEncantamiento(oPC, "<cþ<<>¡Algo falló y te has vuelto invisible!</c>", ANIMATION_FIREFORGET_TAUNT, 81);
          iLesion = TRUE;
      }
  }

  // Tirada de exito
  string sCaracteristica = GetLocalString(oPC, "ARTESA_CARACTERISTICA");
  int iBonoCaracteristica = GetLocalInt(oPC, "ARTESA_CARACTERISTICA_PUNT");
  int iNivelHabilidad = ObtenerIntPersistente(oPC, "Profesion15");
  int iArtesaniaBase  = GetSkillRank(22, oPC, TRUE);
  int iArtesaniaBonus = GetSkillRank(22, oPC) - iArtesaniaBase;
  int iRaza = GetRacialType(oPC);
  int iXPFracaso = iXPExito / 10;
  int iDificultadBase = iDificultad;
  int iBonusRacial, iExito, iXP;
  iDadoCien = d100();

  if(iRaza == RACIAL_TYPE_GNOME) iBonusRacial = 10;
  else if(PB_Race_GetIsElf(oPC)) iBonusRacial = 8;
  else if(PB_Race_GetIsUndead(oPC) || iRaza == RACIAL_TYPE_HALFELF) iBonusRacial = 6;
  else if(iRaza == RACIAL_TYPE_HUMANOID_GOBLINOID || iRaza == RACIAL_TYPE_HUMANOID_REPTILIAN) iBonusRacial = 4;
  else if(iRaza == RACIAL_TYPE_OUTSIDER || iRaza == RACIAL_TYPE_SHAPECHANGER || iRaza == RACIAL_TYPE_HUMAN || PB_Race_GetIsHalfling(oPC)) iBonusRacial = 2;
  else if(iRaza == RACIAL_TYPE_DWARF || iRaza == RACIAL_TYPE_HALFORC) iBonusRacial = 1;

  int iNumeroEncantamientos = GetLocalInt(oObjeto, "ENCANTAMIENTOS_REALIZADOS");
  if(iNumeroEncantamientos == 1) iDificultad + 10;
  else if(iNumeroEncantamientos == 2) iDificultad + 25;

  int iSumaBonos = iDadoCien + iBonoCaracteristica*2 + iBonusRacial + iArtesaniaBase*2 + iArtesaniaBonus/2 + iNivelHabilidad*3;
  int iPorcentaje =     (101 + iBonoCaracteristica*2 + iBonusRacial + iArtesaniaBase*2 + iArtesaniaBonus/2 + iNivelHabilidad*3) - iDificultad;

  if(iPorcentaje > 66) // Maximo 66% de exito
  {
      iDificultad = iDificultad + (iPorcentaje - 66);
      iPorcentaje = 66;
  }
  else if(iPorcentaje <= 0)
  {
      iXPFracaso = 0;
      iPorcentaje = 0;
  }

  SendMessageToPC(oPC, "<c›þþ>Encantando objeto con " + sNombrePropiedad + "...</c>");
  //SendMessageToPC(oPC, "<cþ>Dado:</c> <c´þd>" + IntToString(iDadoCien) + "</c>");
  SendMessageToPC(oPC, "<cþ>Tirada:</c> <cÍþ><c´þd>1d100 + " + IntToString(iBonoCaracteristica*2) + "</c> ("+sCaracteristica+") <c´þd>+ " + IntToString(iBonusRacial) + "</c> (Raza) <c´þd>+ " + IntToString(iArtesaniaBase*2 + iArtesaniaBonus/2) + "</c> (Artesanía) <c´þd>+ " + IntToString(iNivelHabilidad*3) + "</c> (Nivel Oficio)</c>");
  SendMessageToPC(oPC, "<cþ>Dificultad:</c> <c´þd>" + IntToString(iDificultadBase) + "</c>");
  SendMessageToPC(oPC, "<cþ>Probabilidad de éxito:</c> <c´þd>" + IntToString(iPorcentaje) + "%</c>");

  if(iLesion == TRUE)
  {
      DeleteLocalInt(oObjeto, "NO_SUMAR_ENCANTAMIENTO");
      return FALSE;
  }

  if(iSumaBonos >= iDificultad)
  {
      int iOroVentaArtesaniaUrd = GetLocalInt(oObjeto, "ARTESANIA_VENTA");
      int iOroVentaOrfebreria = GetLocalInt(oObjeto, "OROVENTAO");
      int iOroVentaHerreria = GetLocalInt(oObjeto, "OROVENTA");
      int iOroVentaCarpinteria = GetLocalInt(oObjeto, "OROVENTAC");

           if(iOroVentaOrfebreria  > 0)  { SetLocalInt(oObjeto, "ARTESANIA_VENTA", iOroVentaOrfebreria   + iAumentoOroVenta + iNivelHabilidad); DeleteLocalInt(oObjeto, "OROVENTAO"); }
      else if(iOroVentaHerreria    > 0)  { SetLocalInt(oObjeto, "ARTESANIA_VENTA", iOroVentaHerreria     + iAumentoOroVenta + iNivelHabilidad); DeleteLocalInt(oObjeto, "OROVENTA"); }
      else if(iOroVentaCarpinteria > 0)  { SetLocalInt(oObjeto, "ARTESANIA_VENTA", iOroVentaCarpinteria  + iAumentoOroVenta + iNivelHabilidad); DeleteLocalInt(oObjeto, "OROVENTAC"); }
      else SetLocalInt(oObjeto, "ARTESANIA_VENTA", iOroVentaArtesaniaUrd + iAumentoOroVenta + iNivelHabilidad);

      // Nombre
      string sNombreObjeto = GetName(oObjeto);
      if(iNumeroEncantamientos == 0 && GetStringRight(sNombreObjeto, 15) != "(encantado)</c>")
      {
          if(GetStringLeft(sNombreObjeto, 1) == "<")
          {
              int iLongitudNombre = GetStringLength(sNombreObjeto);
              string sNombreSinColorFinal = GetStringLeft(sNombreObjeto, iLongitudNombre - 4);
              SetName(oObjeto, sNombreSinColorFinal + " (encantado)</c>");
          }
          else SetName(oObjeto, ColorToken(255, 153, 255) + GetName(oObjeto) + " (encantado)</c>");
      }

      // Descripcion
      if(iNivelHabilidad > 50 && GetLocalInt(oObjeto, "ARTESANIA_DESC_FIJA") == FALSE)
      {
          string sFirma;
          if(iNivelHabilidad < 95)
          {
              if(GetGender(oPC) == GENDER_FEMALE) sFirma = "de la artesana urdímbrica " + GetName(oPC) + ".";
              else sFirma = "del artesano urdímbrico " + GetName(oPC) + ".";
          }
          else
          {
              if(GetGender(oPC) == GENDER_FEMALE) sFirma = "de la reputada maestra artesana urdímbrica " + GetName(oPC) + ".";
              else sFirma = "del reputado maestro artesano urdímbrico " + GetName(oPC) + ".";
          }

          string sDescripcionOriginal = GetLocalString(oObjeto, "ARTESANIA_DESC_ORIGINAL");
          if(sDescripcionOriginal == "")
          {
              string sDescripcionActual = GetDescription(oObjeto);
              SetLocalString(oObjeto, "ARTESANIA_DESC_ORIGINAL", sDescripcionActual);
              sDescripcionOriginal = sDescripcionActual;
          }

          SetDescription(oObjeto, sDescripcionOriginal + " Además ha sido encantado por uno o varios encantamientos adicionales. Se puede distinguir la firma " + sFirma);
      }

      if(GetLocalInt(oObjeto, "masNivel15") == FALSE && BuclePropiedades(oObjeto) > 3) SetLocalInt(oObjeto, "masNivel15", TRUE);
      if(GetLocalInt(oObjeto, "NO_SUMAR_ENCANTAMIENTO") == FALSE) SetLocalInt(oObjeto, "ENCANTAMIENTOS_REALIZADOS", iNumeroEncantamientos + 1);

      AnimacionEncantamiento(oPC, "<c´þd>¡ÉXITO! Objeto encantado correctamente.", ANIMATION_FIREFORGET_VICTORY1, 55);

      iXP = iXPExito + iNivelHabilidad + d20();
      iExito = TRUE;
  }
  else
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! No lograste encantar el objeto.</c>", ANIMATION_FIREFORGET_TAUNT, 81);
      ProbabilidadRotura(oObjeto);
      iXP = iXPFracaso;
      iCosteXP = iCosteXP / 2;
      iExito = FALSE;
  }

  DeleteLocalInt(oObjeto, "NO_SUMAR_ENCANTAMIENTO");

  // XP y limitaciones
  int iNivelPJ = GetHitDice(oPC);
  if(iNivelPJ <= 5 && iNivelHabilidad == 25) DelayCommand(19.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 5 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 10 && iNivelHabilidad == 50) DelayCommand(19.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 10 o menos.</c>", oPC, FALSE));
  else if(iNivelPJ <= 15 && iNivelHabilidad == 75) DelayCommand(19.8, FloatingTextStringOnCreature("<cþ<<>No puedes subir más experiencia en este oficio siendo nivel 15 o menos.</c>", oPC, FALSE));
  else if(iPorcentaje < 50 && iNivelHabilidad < 100)
  {
      int iXPArtesaniaUrdimbrica = ObtenerIntPersistente(oPC, "Profesion15XP");
      int iXPSigNivel = CalculoSiguienteNivelXPArtesaniaUrdimbrica(iNivelHabilidad);

      DelayCommand(19.5, AssignCommand(oPC, ClearAllActions(TRUE)));
      DelayCommand(19.6, AssignCommand(oPC, PlaySound("gui_journaladd")));
      DelayCommand(19.7, GuardarIntPersistente(oPC, "Profesion15XP", iXPArtesaniaUrdimbrica + iXP));
      DelayCommand(19.8, FloatingTextStringOnCreature("<c´þd>+"+IntToString(iXP)+" XP de Artesanía Urdímbrica</c>", oPC, FALSE));

      if(iXPArtesaniaUrdimbrica + iXP >= iXPSigNivel)
      {
          int iNivelesSubidosDeGolpe = 1;
          while(iXPArtesaniaUrdimbrica + iXP > CalculoSiguienteNivelXPArtesaniaUrdimbrica(iNivelHabilidad+iNivelesSubidosDeGolpe))
          {
              iNivelesSubidosDeGolpe = iNivelesSubidosDeGolpe + 1;
          }

          int iNuevoNivelHabilidad = iNivelHabilidad + iNivelesSubidosDeGolpe;
          if(iNivelPJ <= 5 && iNuevoNivelHabilidad > 25) iNuevoNivelHabilidad = 25;
          else if(iNivelPJ <= 10 && iNuevoNivelHabilidad > 50) iNuevoNivelHabilidad = 50;
          else if(iNivelPJ <= 15 && iNuevoNivelHabilidad > 75) iNuevoNivelHabilidad = 75;
          else if(iNuevoNivelHabilidad > 100) iNuevoNivelHabilidad = 100;

          DelayCommand(22.4, AssignCommand(oPC, ClearAllActions(TRUE)));
          DelayCommand(22.5, AssignCommand(oPC, PlaySound("gui_level_up")));
          DelayCommand(22.6, FloatingTextStringOnCreature("<c þ >¡Has subido al nivel "+IntToString(iNuevoNivelHabilidad)+" de Artesanía Urdímbrica!</c>", oPC, FALSE));
          DelayCommand(22.8, GuardarIntPersistente(oPC, "Profesion15", iNuevoNivelHabilidad));

          int iXPReal = ((iNivelHabilidad + 1)/2) * iNivelesSubidosDeGolpe;
          DelayCommand(22.7, SetXP(oPC, GetXP(oPC) + iXPReal));
      }
  }

  DelayCommand(18.5, SetXP(oPC, GetXP(oPC) - iCosteXP));
  if(iExito == TRUE) return TRUE;
  else return FALSE;
}

// -- ENCANTAMIENTOS --
// 1. LUZ
void EncantamientoLuz(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_LIGHT) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de luz.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(GetStringLeft(GetTag(oComponente), 15) == "pb_artesa_gemco" && iContadorEsencias < 2)
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 1)) return;

  int iReduccionDificultad, iNivelDificultad;
  int iColor = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 1));

  switch(iColor)
  {
      case 0: { if(iConjuro == 1061 || iConjuro == 1066) iReduccionDificultad = 10; } break; // Luz azul
      case 5: { if(iConjuro == 1062 || iConjuro == 1067) iReduccionDificultad = 10; } break; // Luz naranja
      case 2: { if(iConjuro == 1063 || iConjuro == 1068) iReduccionDificultad = 10; } break; // Luz purpura
      case 3: { if(iConjuro == 1064 || iConjuro == 1069) iReduccionDificultad = 10; } break; // Luz roja
      case 1: { if(iConjuro == 1065 || iConjuro == 1070) iReduccionDificultad = 10; } break; // Luz amarilla
  }

  if(iContadorCristales > 4) iContadorCristales = 4;

  if(iContadorCristales == 1)      iNivelDificultad = 1;
  else if(iContadorCristales == 2) iNivelDificultad = 4;
  else if(iContadorCristales == 3) iNivelDificultad = 7;
  else if(iContadorCristales == 4) iNivelDificultad = 10;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  SetLocalInt(oObjeto, "NO_SUMAR_ENCANTAMIENTO", TRUE);
  if(ExitoEncantamiento(oPC, oObjeto, "luz", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyLight(iContadorCristales, iColor));
}

// 2. BONIFICADOR HABILIDAD
void EncantamientoHabilidad(object oPC, object oObjeto, int iConjuro)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_hab" && iContadorEsencias < 2)
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 2)) return;

  int iSumaHabilidadActual = ContarHabilidad(oObjeto);
  if(iContadorCristales > 8) iContadorCristales = 8;
  if(iSumaHabilidadActual + iContadorCristales > 10)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El oficio no admite más de un total de +10 en los bonificadores de habilidad.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iReduccionDificultad, iNivelDificultad;
  int iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  switch(iConjuro)
  {
      case SPELL_AMPLIFY:                        { if(iTipo == 6)  iReduccionDificultad = 10; } break; // Amplificar
      case SPELL_CLAIRAUDIENCE_AND_CLAIRVOYANCE: { if(iTipo == 17) iReduccionDificultad = 10; } break; // Clarividencia/clariaudicencia
  }

  if(iContadorCristales == 1)      iNivelDificultad = 3;
  else if(iContadorCristales == 2) iNivelDificultad = 9;
  else if(iContadorCristales == 3) iNivelDificultad = 16;
  else if(iContadorCristales == 4) iNivelDificultad = 24;
  else if(iContadorCristales == 5) iNivelDificultad = 35;
  else if(iContadorCristales == 6) iNivelDificultad = 44;
  else if(iContadorCristales == 7) iNivelDificultad = 56;
  else if(iContadorCristales == 8) iNivelDificultad = 67;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de habilidad", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertySkillBonus(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 3. LIMITACION DE USO
void EncantamientoLimitacionUso(object oPC, object oObjeto, int iConjuro)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_lim" && iContadorEsencias < 2)
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 3)) return;

  int iLimitacionDeEncantamiento = GetLocalInt(oObjeto, "ARTESA_LIMITACION_USO");
  if(iLimitacionDeEncantamiento >= 2)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El oficio no admite más de dos encantamientos limitación de uso por objeto.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iReduccionDificultad;
  int iLimitacion = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  switch(iConjuro)
  {
      case 138:  { if(iLimitacion == 4) iReduccionDificultad = 10; } break; // Proteccion contra el mal  (bueno)
      case 139:  { if(iLimitacion == 5) iReduccionDificultad = 10; } break; // Proteccion contra el bien (malo)
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(22);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  SetLocalInt(oObjeto, "NO_SUMAR_ENCANTAMIENTO", TRUE);
  if(ExitoEncantamiento(oPC, oObjeto, "limitación de uso", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyLimitUseByAlign(iLimitacion), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  SetLocalInt(oObjeto, "ARTESA_LIMITACION_USO", iLimitacionDeEncantamiento + 1);
}

// 4. BONIFICADOR SALVACION
void EncantamientoSalvacion(object oPC, object oObjeto, int iConjuro, int iTipoSalvacion)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_sal" && iContadorEsencias < 2)
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 4, iTipoSalvacion)) return;

  if(iTipoSalvacion == 3) // Universal
  {
      int iSumaSalvacionUniversalActual = ContarSalvacionUniversal(oObjeto);
      if(iContadorCristales > 1) iContadorCristales = 1;

      else if(iSumaSalvacionUniversalActual > 0)
      {
          AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El oficio no admite más de un +1 en los tiros de salvación universal.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
          DestruirTodoExceptoObjetoEncantable();
          ProbabilidadRotura(oObjeto);
          return;
      }
  }
  else if(iContadorCristales > 3) iContadorCristales = 3;

  int iSumaSalvacionActual = ContarSalvacion(oObjeto);
  if(iSumaSalvacionActual + iContadorCristales > 5)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El oficio no admite más de un total de +5 en los tiros de salvación.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iReduccionDificultad, iNivelDificultad;
  int iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  if(iTipoSalvacion == 1 && GetStringLeft(GetTag(oEsenciaGuardada), 14) == "pb_artesa_sal2" && GetTag(oEsenciaGuardada) != "pb_artesa_sal200") // Especificas
  {
      if(iContadorCristales == 1)      iNivelDificultad = 6;
      else if(iContadorCristales == 2) iNivelDificultad = 19;
      else if(iContadorCristales == 3) iNivelDificultad = 34;
  }
  else if(iTipoSalvacion == 2 && GetStringLeft(GetTag(oEsenciaGuardada), 14) == "pb_artesa_sal1") // Normales
  {
      if(iContadorCristales == 1)      iNivelDificultad = 31;
      else if(iContadorCristales == 2) iNivelDificultad = 48;
      else if(iContadorCristales == 3) iNivelDificultad = 61;
  }
  else if(iTipoSalvacion == 3 && GetTag(oEsenciaGuardada) == "pb_artesa_sal200") iNivelDificultad = 63; // Universal
  else
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Esencia incorrecta para el conjuro lanzado.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de salvación", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  if(iTipoSalvacion == 2) IPSafeAddItemProperty(oObjeto, ItemPropertyBonusSavingThrow(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  else IPSafeAddItemProperty(oObjeto, ItemPropertyBonusSavingThrowVsX(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 5. BONIFICADOR CA
void EncantamientoCA(object oPC, object oObjeto, int iConjuro, int iTipoCA)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2)
      {
          if(sEtiquetaComponente == "pb_artesa_ca"     || sEtiquetaComponente == "pb_artesa_dano00" ||
             sEtiquetaComponente == "pb_artesa_dano01" || sEtiquetaComponente == "pb_artesa_dano02" ||
             GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_lim")

          {
              iContadorEsencias = iContadorEsencias + 1;
              oEsenciaGuardada = oComponente;
          }
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 5, iTipoCA)) return;

  int iNivelDificultad;
  int iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));
  if(iContadorCristales > 4) iContadorCristales = 4;

  if(iTipoCA == 1 && GetStringLeft(GetTag(oEsenciaGuardada), 15) == "pb_artesa_dano0") // CA contra daño
  {
      if(iContadorCristales == 1)      iNivelDificultad = 15;
      else if(iContadorCristales == 2) iNivelDificultad = 27;
      else if(iContadorCristales == 3) iNivelDificultad = 52;
      else if(iContadorCristales == 4) iNivelDificultad = 77;
  }
  else if(iTipoCA == 2 && GetStringLeft(GetTag(oEsenciaGuardada), 13) == "pb_artesa_lim") // CA contra alineamiento
  {
      if(iContadorCristales == 1)      iNivelDificultad = 15;
      else if(iContadorCristales == 2) iNivelDificultad = 27;
      else if(iContadorCristales == 3) iNivelDificultad = 52;
      else if(iContadorCristales == 4) iNivelDificultad = 77;
  }
  else if(iTipoCA == 3 && GetTag(oEsenciaGuardada) == "pb_artesa_ca") // CA universal
  {
      if(iContadorCristales == 1)      iNivelDificultad = 23;
      else if(iContadorCristales == 2) iNivelDificultad = 42;
      else if(iContadorCristales == 3) iNivelDificultad = 60;
      else if(iContadorCristales == 4) iNivelDificultad = 83;
  }
  else
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Esencia incorrecta para el conjuro lanzado.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de clase de armadura", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

       if(iTipoCA == 1) IPSafeAddItemProperty(oObjeto, ItemPropertyACBonusVsDmgType(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  else if(iTipoCA == 2) IPSafeAddItemProperty(oObjeto, ItemPropertyACBonusVsAlign(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  else if(iTipoCA == 3) IPSafeAddItemProperty(oObjeto, ItemPropertyACBonus(iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 6. BONIFICADOR CARACTERISTICA
void EncantamientoCaracteristica(object oPC, object oObjeto, int iConjuro)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_car" && iContadorEsencias < 2)
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 6)) return;

  int iSumaCaracteristicaActual = ContarCaracteristica(oObjeto);
  if(iContadorCristales > 6) iContadorCristales = 6;
  if(iSumaCaracteristicaActual + iContadorCristales > 6)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El oficio no admite más de un total de +6 en los bonificadores de característica.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iReduccionDificultad, iNivelDificultad;
  int iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 1));

  switch(iConjuro)
  {
      case SPELL_BULLS_STRENGTH: { if(iTipo == 0) iReduccionDificultad = 10; } break; // Fuerza de toro
      case SPELL_CATS_GRACE:     { if(iTipo == 1) iReduccionDificultad = 10; } break; // Gracia felina
      case SPELL_ENDURANCE:      { if(iTipo == 2) iReduccionDificultad = 10; } break; // Aguante de oso
      case SPELL_FOXS_CUNNING:   { if(iTipo == 3) iReduccionDificultad = 10; } break; // Astucia de zoro
      case SPELL_OWLS_WISDOM:    { if(iTipo == 4) iReduccionDificultad = 10; } break; // Sabiduria de lechuza
      case SPELL_EAGLE_SPLEDOR:  { if(iTipo == 5) iReduccionDificultad = 10; } break; // Esplendor de aguila
  }

  if(iContadorCristales == 1)      iNivelDificultad = 17;
  else if(iContadorCristales == 2) iNivelDificultad = 30;
  else if(iContadorCristales == 3) iNivelDificultad = 45;
  else if(iContadorCristales == 4) iNivelDificultad = 62;
  else if(iContadorCristales == 5) iNivelDificultad = 81;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de característica", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyAbilityBonus(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 7. REGENERACION
void EncantamientoRegeneracion(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_REGENERATION) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de regeneración.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  if(BuclePropiedades(oObjeto) > 0)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Regeneración debe ser la única propiedad del objeto.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten4") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetTag(oComponente) == "pb_artesa_reg")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 7)) return;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(80);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "regeneración", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  SetLocalInt(oObjeto, "REGENERACION_PROPIEDAD_UNICA", TRUE);
  IPSafeAddItemProperty(oObjeto, ItemPropertyRegeneration(1));
}

// 8. HUECO DE CONJURO
void EncantamientoHuecoConjuro(object oPC, object oObjeto, int iConjuro)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetStringLeft(GetTag(oComponente), 14) == "pb_artesa_clas")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 8)) return;

  int iReduccionDificultad, iNivelDificultad;
  int iPuntuacion = iContadorEsencias;
  int iClase = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  switch(iConjuro)
  {
      case SPELL_MAGIC_MISSILE: { if(iClase == 9 || iClase == 10) iReduccionDificultad = 10; } break; // Proyectil mágico
      case SPELL_DOOM:          { if(iClase == 2) iReduccionDificultad = 10; } break; // Fatalidad
      case SPELL_FLAME_LASH:    { if(iClase == 3) iReduccionDificultad = 10; } break; // Azote flamigero
  }

  if((iClase == 6 || iClase == 7) && iContadorCristales > 4) iContadorCristales = 4;
  else if(iContadorCristales > 6) iContadorCristales = 6;

  if(iContadorCristales == 1)      iNivelDificultad = 12;
  else if(iContadorCristales == 2) iNivelDificultad = 20;
  else if(iContadorCristales == 3) iNivelDificultad = 33;
  else if(iContadorCristales == 4) iNivelDificultad = 43;
  else if(iContadorCristales == 5) iNivelDificultad = 55;
  else if(iContadorCristales == 6) iNivelDificultad = 73;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "huecos de conjuros", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyBonusLevelSpell(iClase, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 9. BONIFICADOR DE DAÑO
void EncantamientoDanyo(object oPC, object oObjeto, int iConjuro)
{
  /*if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS) == TRUE || GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP) == TRUE ||
     GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP) == TRUE || GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de bonificador de daño.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }*/

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetStringLeft(GetTag(oComponente), 14) == "pb_artesa_dano")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 9)) return;

  int iReduccionDificultad, iNivelDificultad, iPuntuacion;
  int iTipoDanyo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  switch(iConjuro)
  {
      case 1034: { if(iTipoDanyo == 9) iReduccionDificultad = 10; } break; // Orbe de acido
      case 1035: { if(iTipoDanyo == 2) iReduccionDificultad = 10; } break; // Orbe de frio
      case 1036: { if(iTipoDanyo == 3) iReduccionDificultad = 10; } break; // Orbe de electricidad
      case 1037: { if(iTipoDanyo == 1) iReduccionDificultad = 10; } break; // Orbe de fuego
      case 1038: { if(iTipoDanyo == 7) iReduccionDificultad = 10; } break; // Orbe de sonido
  }

  if(iContadorCristales == 1)      { iNivelDificultad = 14; iPuntuacion = IP_CONST_DAMAGEBONUS_1;   }
  else if(iContadorCristales == 2) { iNivelDificultad = 25; iPuntuacion = IP_CONST_DAMAGEBONUS_2;   }
  else if(iContadorCristales == 3) { iNivelDificultad = 37; iPuntuacion = IP_CONST_DAMAGEBONUS_1d4; }
  else if(iContadorCristales == 4) { iNivelDificultad = 46; iPuntuacion = IP_CONST_DAMAGEBONUS_3;   }
  else if(iContadorCristales == 5) { iNivelDificultad = 58; iPuntuacion = IP_CONST_DAMAGEBONUS_1d6; }
  else if(iContadorCristales == 6) { iNivelDificultad = 69; iPuntuacion = IP_CONST_DAMAGEBONUS_4;   }
  else if(iContadorCristales >= 7) { iNivelDificultad = 79; iPuntuacion = IP_CONST_DAMAGEBONUS_1d8; }

  if((iTipoDanyo == 5 || iTipoDanyo == 8 || iTipoDanyo == 11 || iTipoDanyo == 12) && iContadorCristales > 2) { iNivelDificultad = 25; iPuntuacion = IP_CONST_DAMAGEBONUS_2; } // Fix para adaptarse al reglamento

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de daño", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  itemproperty ipDanyoABorrar = GetFirstItemProperty(oObjeto);
  while(GetIsItemPropertyValid(ipDanyoABorrar))
  {
      if(GetItemPropertyType(ipDanyoABorrar) == ITEM_PROPERTY_DAMAGE_BONUS                    ||
         GetItemPropertyType(ipDanyoABorrar) == ITEM_PROPERTY_DAMAGE_BONUS_VS_ALIGNMENT_GROUP ||
         GetItemPropertyType(ipDanyoABorrar) == ITEM_PROPERTY_DAMAGE_BONUS_VS_RACIAL_GROUP    ||
         GetItemPropertyType(ipDanyoABorrar) == ITEM_PROPERTY_DAMAGE_BONUS_VS_SPECIFIC_ALIGNMENT)
      {
          RemoveItemProperty(oObjeto, ipDanyoABorrar);
      }

      ipDanyoABorrar = GetNextItemProperty(oObjeto);
  }

  IPSafeAddItemProperty(oObjeto, ItemPropertyDamageBonus(iTipoDanyo, iPuntuacion));
}

// 10. RESISTENCIA DANYO
void EncantamientoResistenciaDanyo(object oPC, object oObjeto, int iConjuro)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      if(GetTag(oComponente) == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetStringLeft(GetTag(oComponente), 14) == "pb_artesa_dano")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 10)) return;

  int iReduccionDificultad;
  int iTipoDanyo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));

  switch(iConjuro)
  {
      case SPELL_ENDURE_ELEMENTS:          { if(iTipoDanyo == 6 || iTipoDanyo == 7 || iTipoDanyo == 9 || iTipoDanyo == 10 || iTipoDanyo == 13) iReduccionDificultad = 5;  } break; // Soportar los elementos
      case SPELL_RESIST_ELEMENTS:          { if(iTipoDanyo == 6 || iTipoDanyo == 7 || iTipoDanyo == 9 || iTipoDanyo == 10 || iTipoDanyo == 13) iReduccionDificultad = 7;  } break; // Resistencia a los elementos
      case SPELL_PROTECTION_FROM_ELEMENTS: { if(iTipoDanyo == 6 || iTipoDanyo == 7 || iTipoDanyo == 9 || iTipoDanyo == 10 || iTipoDanyo == 13) iReduccionDificultad = 10; } break; // Proteccion contra los elementos
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(26);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "resistencia al daño", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyDamageResistance(iTipoDanyo, IP_CONST_DAMAGERESIST_5), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 11. RESISTENCIA A CONJUROS
void EncantamientoResistenciaConjuros(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_SPELL_RESISTANCE) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de resistencia a conjuros.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente =GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_rc")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 11)) return;

  int iNivelDificultad, iPuntuacion;
  if(iContadorCristales == 1)      { iNivelDificultad = 11; iPuntuacion = IP_CONST_SPELLRESISTANCEBONUS_10; }
  else if(iContadorCristales == 2) { iNivelDificultad = 21; iPuntuacion = IP_CONST_SPELLRESISTANCEBONUS_12; }
  else if(iContadorCristales == 3) { iNivelDificultad = 39; iPuntuacion = IP_CONST_SPELLRESISTANCEBONUS_14; }
  else if(iContadorCristales == 4) { iNivelDificultad = 52; iPuntuacion = IP_CONST_SPELLRESISTANCEBONUS_16; }
  else if(iContadorCristales >= 5) { iNivelDificultad = 75; iPuntuacion = IP_CONST_SPELLRESISTANCEBONUS_18; }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "resistencia a conjuros", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyBonusSpellResistance(iPuntuacion));
}

// 12. REDUCCION DANYO
void EncantamientoReduccionDanyo(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DAMAGE_REDUCTION) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de reducción de daño.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_rd")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 12)) return;

  int iNivelDificultad, iPuntuacion;
  if(iContadorCristales == 1)      { iNivelDificultad = 32; iPuntuacion = IP_CONST_DAMAGEREDUCTION_1; }
  else if(iContadorCristales == 2) { iNivelDificultad = 41; iPuntuacion = IP_CONST_DAMAGEREDUCTION_2; }
  else if(iContadorCristales == 3) { iNivelDificultad = 54; iPuntuacion = IP_CONST_DAMAGEREDUCTION_3; }
  else if(iContadorCristales >= 4) { iNivelDificultad = 71; iPuntuacion = IP_CONST_DAMAGEREDUCTION_4; }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "reducción de daño", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyDamageReduction(iPuntuacion, IP_CONST_DAMAGESOAK_5_HP));
}

// 13. INMUNIDAD A CONJUROS (nivel 1)
void EncantamientoInmunidadConjuros(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_IMMUNITY_SPELLS_BY_LEVEL) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de immunidad a conjuros por nivel.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten4") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_inconj")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 13)) return;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(75);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "immunidad a conjuros por nivel", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyImmunityToSpellLevel(1));
}

// 14. BONIFICADOR ATAQUE
void EncantamientoAtaque(object oPC, object oObjeto, int iConjuro, int iTipoAtaque)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2)
      {
          if(sEtiquetaComponente == "pb_artesa_at" ||
             GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_lim")
          {
              iContadorEsencias = iContadorEsencias + 1;
              oEsenciaGuardada = oComponente;
          }
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 14, iTipoAtaque)) return;

  int iNivelDificultad;
  int iTipo = iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));
  if(iContadorCristales > 1) iContadorCristales = 1;

       if(iTipoAtaque == 1 && iTipo != 0) iNivelDificultad = 11; // Ataque contra alineamiento
  else if(iTipoAtaque == 2 && iTipo == 0) iNivelDificultad = 15; // Ataque universal
  else
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Esencia incorrecta para el conjuro lanzado.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de ataque", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

       if(iTipoAtaque == 1) IPSafeAddItemProperty(oObjeto, ItemPropertyAttackBonusVsAlign(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  else if(iTipoAtaque == 2) IPSafeAddItemProperty(oObjeto, ItemPropertyAttackBonus(iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 15. BONIFICADOR MEJORA
void EncantamientoMejora(object oPC, object oObjeto, int iConjuro, int iTipoMejora)
{
  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2)
      {
          if(sEtiquetaComponente == "pb_artesa_mej" ||
             GetStringLeft(GetTag(oComponente), 13) == "pb_artesa_lim")

          {
              iContadorEsencias = iContadorEsencias + 1;
              oEsenciaGuardada = oComponente;
          }
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 15, iTipoMejora)) return;

  int iNivelDificultad;
  int iTipo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));
  if(iContadorCristales > 4) iContadorCristales = 4;

  if(iTipoMejora == 1 && iTipo != 0)     // Mejora contra alineamiento
  {
      if(iContadorCristales == 1)      iNivelDificultad = 43;
      else if(iContadorCristales == 2) iNivelDificultad = 53;
      else if(iContadorCristales == 3) iNivelDificultad = 62;
      else if(iContadorCristales == 4) iNivelDificultad = 78;
  }
  else if(iTipoMejora == 2 && iTipo == 0) // Mejora universal
  {
      if(iContadorCristales == 1)      iNivelDificultad = 47;
      else if(iContadorCristales == 2) iNivelDificultad = 57;
      else if(iContadorCristales == 3) iNivelDificultad = 66;
      else if(iContadorCristales == 4) iNivelDificultad = 82;
  }
  else
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! Esencia incorrecta para el conjuro lanzado.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "bonificador de mejora", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

       if(iTipoMejora == 1) IPSafeAddItemProperty(oObjeto, ItemPropertyEnhancementBonusVsAlign(iTipo, iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
  else if(iTipoMejora == 2) IPSafeAddItemProperty(oObjeto, ItemPropertyEnhancementBonus(iContadorCristales), 0.0, X2_IP_ADDPROP_POLICY_IGNORE_EXISTING);
}

// 16. REG. VAMPIRICA
void EncantamientoRegVampirica(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_REGENERATION_VAMPIRIC) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de regeneración vampírica.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_rv")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 16)) return;

  int iNivelDificultad;
  if(iContadorCristales > 4) iContadorCristales = 4;
  if(iContadorCristales == 1)      iNivelDificultad = 13;
  else if(iContadorCristales == 2) iNivelDificultad = 28;
  else if(iContadorCristales == 3) iNivelDificultad = 51;
  else if(iContadorCristales == 4) iNivelDificultad = 72;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "regeneración vampírica", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyVampiricRegeneration(iContadorCristales));
}

// 17. CRITICOS MASIVOS
void EncantamientoCriticosMasivos(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_MASSIVE_CRITICALS) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de críticos masivos.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_cm")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 17)) return;

  int iNivelDificultad, iPuntuacion;
  if(iContadorCristales == 1)      { iNivelDificultad = 8;  iPuntuacion = IP_CONST_DAMAGEBONUS_1d4;  }
  else if(iContadorCristales == 2) { iNivelDificultad = 18; iPuntuacion = IP_CONST_DAMAGEBONUS_1d6;  }
  else if(iContadorCristales == 3) { iNivelDificultad = 38; iPuntuacion = IP_CONST_DAMAGEBONUS_1d8;  }
  else if(iContadorCristales >= 4) { iNivelDificultad = 53; iPuntuacion = IP_CONST_DAMAGEBONUS_1d10; }

  string sTagObjeto = GetStringRight(GetTag(oObjeto), 5); // Fix para estoques, cimitarras y kukris
  if((sTagObjeto == "kukri" || sTagObjeto == "tarra" || sTagObjeto == "toque") &&
      iContadorCristales > 2) { iNivelDificultad = 18; iPuntuacion = IP_CONST_DAMAGEBONUS_1d6;  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "críticos masivos", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyMassiveCritical(iPuntuacion));
}

// 18. EFECTOS AL GOLPEAR
void EncantamientoEfectoAlGolpear(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_ON_HIT_PROPERTIES) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de efecto al golpear.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten4") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetStringLeft(sEtiquetaComponente, 13) == "pb_artesa_efe")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 18)) return;

  int iReduccionDificultad, iNivelDificultad, iCD;
  int iTipoEfecto = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));
  int iEspecial = Random(3)+2;

  switch(iTipoEfecto)
  {
      case IP_CONST_ONHIT_ABILITYDRAIN: { iEspecial = Random(6);  if(iConjuro == SPELL_FEEBLEMIND) iReduccionDificultad = 10; } break;
      case IP_CONST_ONHIT_DISEASE:      { iEspecial = Random(17); if(iConjuro == SPELL_CONTAGION)  iReduccionDificultad = 10; } break;
      case IP_CONST_ONHIT_ITEMPOISON:   { iEspecial = Random(6);  if(iConjuro == SPELL_POISON)     iReduccionDificultad = 10; } break;
      case IP_CONST_ONHIT_WOUNDING:       iEspecial = Random(4)+1;                                                              break;
  }

  if(iContadorCristales == 1)      { iNivelDificultad = 59;  iCD = IP_CONST_ONHIT_SAVEDC_14; }
  else if(iContadorCristales >= 2) { iNivelDificultad = 76;  iCD = IP_CONST_ONHIT_SAVEDC_16; }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "efecto al golpear", sEstructura.iDificultad - iReduccionDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyOnHitProps(iTipoEfecto, iCD, iEspecial));
}

// 19. INMUNIDAD DAÑO
void EncantamientoInmunidadDanyo(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_IMMUNITY_DAMAGE_TYPE) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de inmunidad al daño.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && GetStringLeft(sEtiquetaComponente, 14) == "pb_artesa_dano")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 19)) return;


  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(36);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "inmunidad al daño", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  int iTipoDanyo = StringToInt(GetStringRight(GetTag(oEsenciaGuardada), 2));
  IPSafeAddItemProperty(oObjeto, ItemPropertyDamageImmunity(iTipoDanyo, IP_CONST_DAMAGEIMMUNITY_5_PERCENT));
}

// 20. VISION EN LA OSCURIDAD
void EncantamientoVisionOscuridad(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_DARKVISION) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de visión en la oscuridad.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten2") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_vo")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 20)) return;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(40);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "visión en la oscuridad", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyDarkvision());
}

// 21. PESO REDUCIDO
void EncantamientoPesoReducido(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_BASE_ITEM_WEIGHT_REDUCTION) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de peso reducido.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_peso")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 21)) return;

  int iNivelDificultad;
  if(iContadorCristales > 4) iContadorCristales = 4;
  if(iContadorCristales == 1)      iNivelDificultad = 2;
  else if(iContadorCristales == 2) iNivelDificultad = 27;
  else if(iContadorCristales == 3) iNivelDificultad = 50;
  else if(iContadorCristales == 4) iNivelDificultad = 64;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "peso reducido", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyWeightReduction(iContadorCristales));
}

// 22. LANZAR CONJURO (Necesario Infusionamiento)
void EncantamientoLanzarConjuro(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_CAST_SPELL) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de lanzar conjuro.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  string sEscuelaMagia;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      sEscuelaMagia = GetLocalString(oComponente, "OFI_INFUSION_ESCUELA");
      if(sEtiquetaComponente == "pb_artesa_poten3") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEscuelaMagia != "")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 22)) return;

  // Miramos si existe la propiedad para el conjuro seleccionado
  int iConjuroInfusion = GetLocalInt(oEsenciaGuardada, "OFI_INFUSION_CONJURO");
  int iPropiedad = IPGetIPConstCastSpellFromSpellID(iConjuroInfusion);
  if(iPropiedad == -1)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! No existe propiedad de objeto para este conjuro.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  // La dificultad esta vez se calcula a partir de la esfera del conjuro, no por el numero de cristales
  int iEsferaInfusion =  GetLocalInt(oObjeto, "OFI_INFUSION_ESFERA");
  int iNivelDificultad;
  switch(iEsferaInfusion)
  {
      case 0: iNivelDificultad = 20; break;
      case 1: iNivelDificultad = 30; break;
      case 2: iNivelDificultad = 47; break;
      case 3: iNivelDificultad = 61; break;
      case 4: iNivelDificultad = 75; break;
      case 5: iNivelDificultad = 80; break;
      default: iNivelDificultad = 80; break;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "lanzar conjuro", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  // Propiedad, usos y cargas
  int iUsos, iCargas;
  if(iContadorCristales > 5) iContadorCristales = 5;

  if(iContadorCristales == 1) iUsos = IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE;
  else if(iContadorCristales == 2) iUsos = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
  else if(iContadorCristales == 3) iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
  else if(iContadorCristales == 4)
  {
      if(iEsferaInfusion <= 4) iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
      else iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
  }
  else if(iContadorCristales == 5)
  {
      if(iEsferaInfusion <= 2) iUsos = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
      else if(iEsferaInfusion <= 4) iUsos = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
      else iUsos = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
  }

  iCargas = 10 + d6(3) + (iContadorCristales * 3);
  SetItemCharges(oObjeto, iCargas);

  IPSafeAddItemProperty(oObjeto, ItemPropertyCastSpell(iPropiedad, iUsos));
  AplicarRestriccionesClaseas(oObjeto, iConjuroInfusion);
}

// 23. INMUNIDAD A CONJURO (Necesario Infusionamiento)
void EncantamientoInmunidadConjuro(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_IMMUNITY_SPECIFIC_SPELL) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de inmunidad a conjuro.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  string sEscuelaMagia;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      sEscuelaMagia = GetLocalString(oComponente, "OFI_INFUSION_ESCUELA");
      if(sEtiquetaComponente == "pb_artesa_poten4") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEscuelaMagia != "")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 23)) return;

  int iConjuroInfusion = GetLocalInt(oEsenciaGuardada, "OFI_INFUSION_CONJURO");
  iConjuroInfusion = ObtenerInmunidadConjuro(iConjuroInfusion);
  if(iConjuroInfusion == -1)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! No existe propiedad de objeto para este conjuro.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  // La dificultad esta vez se calcula a partir de la esfera del conjuro, no por el numero de cristales
  int iEsferaInfusion =  GetLocalInt(oObjeto, "OFI_INFUSION_ESFERA");
  int iNivelDificultad;
  switch(iEsferaInfusion)
  {
      case 0: iNivelDificultad = 22; break;
      case 1: iNivelDificultad = 32; break;
      case 2: iNivelDificultad = 49; break;
      case 3: iNivelDificultad = 63; break;
      case 4: iNivelDificultad = 77; break;
      case 5: iNivelDificultad = 82; break;
      default: iNivelDificultad = 82; break;
  }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "inmunidad a conjuro", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertySpellImmunitySpecific(iConjuroInfusion));
}

// 24. MUNICION INFINITA
void EncantamientoMunicionInfinita(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_UNLIMITED_AMMUNITION) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de munición infinita.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten4") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_muni")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 24)) return;

  int iNivelDificultad, iPuntuacion;
  if(iContadorCristales > 3) iContadorCristales = 3;
  if(iContadorCristales == 1)      { iNivelDificultad = 65; iPuntuacion = IP_CONST_UNLIMITEDAMMO_BASIC; }
  else if(iContadorCristales == 2) { iNivelDificultad = 76; iPuntuacion = IP_CONST_UNLIMITEDAMMO_PLUS1; }
  else if(iContadorCristales == 3) { iNivelDificultad = 83; iPuntuacion = IP_CONST_UNLIMITEDAMMO_PLUS2; }

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "munición infinita", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyUnlimitedAmmo(iPuntuacion));
}

// 25. REFORZADO
void EncantamientoReforzado(object oPC, object oObjeto, int iConjuro)
{
  if(GetItemHasItemProperty(oObjeto, ITEM_PROPERTY_MIGHTY) == TRUE)
  {
      AnimacionEncantamiento(oPC, "<cþ<<>¡FRACASO! El objeto ya tenía la propiedad de reforzado.</c>", ANIMATION_FIREFORGET_TAUNT, 772, 1);
      DestruirTodoExceptoObjetoEncantable();
      ProbabilidadRotura(oObjeto);
      return;
  }

  int iContadorCristales = 0;
  int iContadorEsencias  = 0;
  object oEsenciaGuardada;
  object oComponente = GetFirstItemInInventory();
  string sEtiquetaComponente;
  while(GetIsObjectValid(oComponente) == TRUE)
  {
      sEtiquetaComponente = GetTag(oComponente);
      if(sEtiquetaComponente == "pb_artesa_poten1") iContadorCristales = iContadorCristales + 1;
      else if(iContadorEsencias < 2 && sEtiquetaComponente == "pb_artesa_refor")
      {
          iContadorEsencias = iContadorEsencias + 1;
          oEsenciaGuardada = oComponente;
      }

      oComponente = GetNextItemInInventory();
  }

  if(!RequisitosCristalesEsencias(oPC, oObjeto, iContadorCristales, iContadorEsencias)) return;
  if(!RequisitosMaterialObjeto(oPC, oObjeto, 25)) return;

  int iNivelDificultad;
  if(iContadorCristales > 4) iContadorCristales = 4;
  if(iContadorCristales == 1)      iNivelDificultad = 10;
  else if(iContadorCristales == 2) iNivelDificultad = 29;
  else if(iContadorCristales == 3) iNivelDificultad = 50;
  else if(iContadorCristales == 4) iNivelDificultad = 68;

  struct OficioArtesaniaUrdimbrica sEstructura = ObtenerDatosNivel(iNivelDificultad);
  if(!RequisitoConocimientoConjuros(oPC, oObjeto, sEstructura.iCosteXP / 10)) return;
  if(ExitoEncantamiento(oPC, oObjeto, "reforzado", sEstructura.iDificultad, sEstructura.iAumentoOroVenta, sEstructura.iXPExito, sEstructura.iCosteXP) == FALSE) return;

  IPSafeAddItemProperty(oObjeto, ItemPropertyMaxRangeStrengthMod(iContadorCristales));
}
