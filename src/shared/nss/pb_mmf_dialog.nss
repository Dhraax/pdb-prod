#include "pb_inc_mmf"

void SetCustomAppearanceAndPortrait(object oPC,int iRace, int iAppearance)
{
    if(iRace == 0 || iAppearance == 0) return;

    int iCreatureSkin = 0;
    int iPortrait =  0;

    switch(iRace)
    {
        case MDF_RACIALTYPE_ORC:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 1105; iPortrait = 271;}
            else if(iAppearance == 2){  iCreatureSkin = 136;  iPortrait = 271;}
            else if(iAppearance == 3){  iCreatureSkin = 140;  iPortrait = 272;}
            else if(iAppearance == 4){  iCreatureSkin = 1258; iPortrait = 273;}
            else if(iAppearance == 5){  iCreatureSkin = 1259; iPortrait = 274;}
            else if(iAppearance == 6){  iCreatureSkin = 1102; iPortrait = 277;}
            else if(iAppearance == 7){  iCreatureSkin = 2129; iPortrait = 278;}
            else if(iAppearance == 8){  iCreatureSkin = 1101; iPortrait = 278;}
            else if(iAppearance == 9){  iCreatureSkin = 141;  iPortrait = 278;}
            else if(iAppearance == 10){ iCreatureSkin = 137;  iPortrait = 278;}
            break;
        }
        case MDF_RACIALTYPE_TROGLODYTE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 451;  iPortrait = 821;}
            else if(iAppearance == 2){  iCreatureSkin = 452;  iPortrait = 821;}
            else if(iAppearance == 3){  iCreatureSkin = 453;  iPortrait = 821;}
            else if(iAppearance == 4){  iCreatureSkin = 1130; iPortrait = 734;}
            else if(iAppearance == 5){  iCreatureSkin = 1131; iPortrait = 734;}
            else if(iAppearance == 6){  iCreatureSkin = 869;  iPortrait = 734;}
            else if(iAppearance == 7){  iCreatureSkin = 1133; iPortrait = 734;}
            else if(iAppearance == 8){  iCreatureSkin = 870;  iPortrait = 734;}
            else if(iAppearance == 9){  iCreatureSkin = 1134; iPortrait = 734;}
            else if(iAppearance == 10){ iCreatureSkin = 1135; iPortrait = 734;}
            break;
        }
        case MDF_RACIALTYPE_LIZARMAN:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 353;  iPortrait = 749;}
            else if(iAppearance == 2){  iCreatureSkin = 354;  iPortrait = 749;}
            else if(iAppearance == 3){  iCreatureSkin = 355;  iPortrait = 749;}
            else if(iAppearance == 4){  iCreatureSkin = 131; iPortrait = 266;}
            else if(iAppearance == 5){  iCreatureSkin = 133; iPortrait = 268;}
            else if(iAppearance == 6){  iCreatureSkin = 135;  iPortrait = 270;}
            else if(iAppearance == 7){  iCreatureSkin = 130; iPortrait = 265;}
            else if(iAppearance == 8){  iCreatureSkin = 132;  iPortrait = 267;}
            else if(iAppearance == 9){  iCreatureSkin = 134;  iPortrait = 269;}
            break;
        }
        case MDF_RACIALTYPE_GOBLIN:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 87;   iPortrait = 221;}
            else if(iAppearance == 2){  iCreatureSkin = 82;   iPortrait = 2000;}
            else if(iAppearance == 3){  iCreatureSkin = 86;   iPortrait = 220;}
            else if(iAppearance == 4){  iCreatureSkin = 83;   iPortrait = 220;}
            else if(iAppearance == 5){  iCreatureSkin = 2162; iPortrait = 222;}
            else if(iAppearance == 6){  iCreatureSkin = 2163; iPortrait = 2002;}
            else if(iAppearance == 7){  iCreatureSkin = 84;   iPortrait = 225;}
            else if(iAppearance == 8){  iCreatureSkin = 919;  iPortrait = 172;}
            else if(iAppearance == 9){  iCreatureSkin = 2142; iPortrait = 2001;}
            else if(iAppearance == 10){ iCreatureSkin = 85;   iPortrait = 2000;}
            break;
        }
        case MDF_RACIALTYPE_KOBOLD:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 303;  iPortrait = 568;}
            else if(iAppearance == 2){  iCreatureSkin = 2164; iPortrait = 566;}
            else if(iAppearance == 3){  iCreatureSkin = 304;  iPortrait = 2053;}
            else if(iAppearance == 4){  iCreatureSkin = 2165; iPortrait = 2055;}
            else if(iAppearance == 5){  iCreatureSkin = 2166; iPortrait = 2055;}
            else if(iAppearance == 6){  iCreatureSkin = 301;  iPortrait = 567;}
            else if(iAppearance == 7){  iCreatureSkin = 305;  iPortrait = 567;}
            else if(iAppearance == 8){  iCreatureSkin = 924;  iPortrait = 569;}
            else if(iAppearance == 9){  iCreatureSkin = 300;  iPortrait = 569;}
            else if(iAppearance == 10){ iCreatureSkin = 302;  iPortrait = 569;}
            break;
        }
        case MDF_RACIALTYPE_DROW:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 476;  iPortrait = 2262;}
            else if(iAppearance == 2){  iCreatureSkin = 1148; iPortrait = 2262;}
            else if(iAppearance == 3){  iCreatureSkin = 1139; iPortrait = 970;}
            else if(iAppearance == 4){  iCreatureSkin = 4512; iPortrait = 970;}
            else if(iAppearance == 5){  iCreatureSkin = 4517; iPortrait = 1020;}
            else if(iAppearance == 6){  iCreatureSkin = 4516; iPortrait = 2268;}
            else if(iAppearance == 7){  iCreatureSkin = 478;  iPortrait = 1065;}
            else if(iAppearance == 8){  iCreatureSkin = 4514; iPortrait = 2270;}
            else if(iAppearance == 9){  iCreatureSkin = 1141; iPortrait = 2277;}
            else if(iAppearance == 10){ iCreatureSkin = 4518; iPortrait = 2268;}
            else if(iAppearance == 11)
            {
                iCreatureSkin = 1;
                iPortrait = 2264;
                GuardarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DROW),TRUE);
                GuardarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DROW),GENDER_MALE);
            }
             else if(iAppearance == 12)
            {
                iCreatureSkin = 1;
                iPortrait = 1020;
                GuardarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DROW),TRUE);
                GuardarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DROW),GENDER_FEMALE);
            }

            if(iAppearance < 11 ){
                BorrarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DROW));
                BorrarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DROW));
            }
            break;
        }
        case MDF_RACIALTYPE_DUERGAR:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 412;  iPortrait = 973;}
            else if(iAppearance == 2){  iCreatureSkin = 1156; iPortrait = 973;}
            else if(iAppearance == 3){  iCreatureSkin = 217;  iPortrait = 973;}
            else if(iAppearance == 4){  iCreatureSkin = 1155; iPortrait = 973;}
            else if(iAppearance == 5){  iCreatureSkin = 1151; iPortrait = 973;}
            else if(iAppearance == 6){  iCreatureSkin = 1152; iPortrait = 18113;}
            else if(iAppearance == 7){  iCreatureSkin = 1153; iPortrait = 972;}
            else if(iAppearance == 8){ iCreatureSkin = 1154; iPortrait = 18113;}
            else if(iAppearance == 9)
            {
                iCreatureSkin = 0;
                iPortrait = 973;
                GuardarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DUERGAR),TRUE);
                GuardarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DUERGAR),GENDER_MALE);
                GuardarIntPersistente(oPC,"MMF_DINAMIC_DWARF",TRUE);
            }
             else if(iAppearance == 10)
            {
                iCreatureSkin = 0;
                iPortrait = 972;
                GuardarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DUERGAR),TRUE);
                GuardarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DUERGAR),GENDER_FEMALE);
                GuardarIntPersistente(oPC,"MMF_DINAMIC_DWARF",TRUE);
            }

            if(iAppearance < 9 ){
                BorrarIntPersistente(oPC,"GENDER_RELATED"+IntToString(MDF_RACIALTYPE_DUERGAR));
                BorrarIntPersistente(oPC,"FORM_GENDER"+IntToString(MDF_RACIALTYPE_DUERGAR));
                BorrarIntPersistente(oPC,"MMF_DINAMIC_DWARF");
            }
            break;
        }
        case MDF_RACIALTYPE_OGRE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 208;  iPortrait = 1294;}
            else if(iAppearance == 2){  iCreatureSkin = 1098; iPortrait = 1294;}
            else if(iAppearance == 3){  iCreatureSkin = 1107; iPortrait = 1294;}
            else if(iAppearance == 4){  iCreatureSkin = 75;   iPortrait = 1294;}
            else if(iAppearance == 5){  iCreatureSkin = 128;  iPortrait = 1294;}
            else if(iAppearance == 6){  iCreatureSkin = 925;  iPortrait = 1294;}
            else if(iAppearance == 7){  iCreatureSkin = 922;  iPortrait = 1294;}
            else if(iAppearance == 8){  iCreatureSkin = 127;  iPortrait = 1294;}
            else if(iAppearance == 9){  iCreatureSkin = 207;  iPortrait = 1294;}
            else if(iAppearance == 10){ iCreatureSkin = 7378; iPortrait = 1294;}
            break;
        }
        case MDF_RACIALTYPE_ETTIN:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 72;   iPortrait = 205;}
            break;
        }
        case MDF_RACIALTYPE_TROLL:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 2255; iPortrait = 307;}
            else if(iAppearance == 2){  iCreatureSkin = 165;  iPortrait = 308;}
            else if(iAppearance == 3){  iCreatureSkin = 3503; iPortrait = 308;}
            else if(iAppearance == 4){  iCreatureSkin = 2059; iPortrait = 307;}
            else if(iAppearance == 5){  iCreatureSkin = 3504; iPortrait = 306;}
            else if(iAppearance == 6){  iCreatureSkin = 938;  iPortrait = 12599;}
            else if(iAppearance == 7){  iCreatureSkin = 3505; iPortrait = 12599;}
            else if(iAppearance == 8){  iCreatureSkin = 4058; iPortrait = 12599;}
            else if(iAppearance == 9){  iCreatureSkin = 3502; iPortrait = 12599;}
            else if(iAppearance == 10){ iCreatureSkin = 164;  iPortrait = 306;}
            break;
        }
        case MDF_RACIALTYPE_OGRE_MAGE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 129;  iPortrait = 1294;}
            else if(iAppearance == 2){  iCreatureSkin = 209;  iPortrait = 1294;}
            else if(iAppearance == 3){  iCreatureSkin = 909;  iPortrait = 1294;}
            else if(iAppearance == 4){  iCreatureSkin = 1096; iPortrait = 1294;}
            else if(iAppearance == 5){  iCreatureSkin = 4462; iPortrait = 1294;}
            else if(iAppearance == 6){  iCreatureSkin = 4461; iPortrait = 545;}
            else if(iAppearance == 7){  iCreatureSkin = 4460; iPortrait = 545;}
            else if(iAppearance == 8){  iCreatureSkin = 1099; iPortrait = 545;}
            else if(iAppearance == 9){  iCreatureSkin = 1108; iPortrait = 1294;}
            break;
        }
        case MDF_RACIALTYPE_GIANT_HILL:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 78;   iPortrait = 217;}
            else if(iAppearance == 2){  iCreatureSkin = 978;  iPortrait = 217;}
            else if(iAppearance == 3){  iCreatureSkin = 2705; iPortrait = 217;}
            else if(iAppearance == 4){  iCreatureSkin = 2708; iPortrait = 3193;}
            else if(iAppearance == 5){  iCreatureSkin = 2706; iPortrait = 3192;}
            else if(iAppearance == 6){  iCreatureSkin = 2707; iPortrait = 3193;}
            break;
        }
        case MDF_RACIALTYPE_GIANT_FIRE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 80;   iPortrait = 215;}
            else if(iAppearance == 2){  iCreatureSkin = 2743; iPortrait = 3204;}
            else if(iAppearance == 3){  iCreatureSkin = 2740; iPortrait = 3204;}
            else if(iAppearance == 4){  iCreatureSkin = 2746; iPortrait = 3201;}
            else if(iAppearance == 5){  iCreatureSkin = 2742; iPortrait = 3203;}
            else if(iAppearance == 6){  iCreatureSkin = 2739; iPortrait = 3203;}
            else if(iAppearance == 7){  iCreatureSkin = 2745; iPortrait = 3205;}
            else if(iAppearance == 8){  iCreatureSkin = 2741; iPortrait = 3202;}
            else if(iAppearance == 9){  iCreatureSkin = 2738; iPortrait = 3202;}
            else if(iAppearance == 10){ iCreatureSkin = 2746; iPortrait = 3202;}
            break;
        }
        case MDF_RACIALTYPE_GIANT_FROST:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 2737; iPortrait = 3210;}
            else if(iAppearance == 2){  iCreatureSkin = 2731; iPortrait = 3208;}
            else if(iAppearance == 3){  iCreatureSkin = 2728; iPortrait = 3210;}
            else if(iAppearance == 4){  iCreatureSkin = 2735; iPortrait = 3209;}
            else if(iAppearance == 5){  iCreatureSkin = 2729; iPortrait = 3208;}
            else if(iAppearance == 6){  iCreatureSkin = 2723; iPortrait = 3206;}
            else if(iAppearance == 7){  iCreatureSkin = 2736; iPortrait = 3207;}
            else if(iAppearance == 8){  iCreatureSkin = 2730; iPortrait = 3207;}
            else if(iAppearance == 9){  iCreatureSkin = 81;   iPortrait = 216;}
            else if(iAppearance == 10){ iCreatureSkin = 350;  iPortrait = 216;}
            break;
        }
        case MDF_RACIALTYPE_MINOTAUR:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 122;  iPortrait = 256;}
            else if(iAppearance == 2){  iCreatureSkin = 121;  iPortrait = 255;}
            else if(iAppearance == 3){  iCreatureSkin = 120;  iPortrait = 253;}
            else if(iAppearance == 4){  iCreatureSkin = 1266; iPortrait = 253;}
            break;
        }
        case MDF_RACIALTYPE_YETI:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 2780; iPortrait = 3344;}
            else if(iAppearance == 2){  iCreatureSkin = 2781; iPortrait = 3342;}
            else if(iAppearance == 3){  iCreatureSkin = 4501; iPortrait = 3414;}
            break;
        }
        case MDF_RACIALTYPE_CENTAUR:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 4330; iPortrait = 3444;}
            else if(iAppearance == 2){  iCreatureSkin = 4331; iPortrait = 3444;}
            else if(iAppearance == 3){  iCreatureSkin = 4332; iPortrait = 3444;}
            else if(iAppearance == 4){  iCreatureSkin = 4333; iPortrait = 3444;}
            else if(iAppearance == 5){  iCreatureSkin = 4334; iPortrait = 3444;}
            else if(iAppearance == 6){  iCreatureSkin = 4325; iPortrait = 3446;}
            else if(iAppearance == 7){  iCreatureSkin = 4326; iPortrait = 3446;}
            else if(iAppearance == 8){  iCreatureSkin = 4327; iPortrait = 3446;}
            else if(iAppearance == 9){  iCreatureSkin = 4328; iPortrait = 3446;}
            else if(iAppearance == 10){ iCreatureSkin = 4329; iPortrait = 3446;}
            break;
        }
        case MDF_RACIALTYPE_STINGER:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 357;  iPortrait = 613;}
            else if(iAppearance == 2){  iCreatureSkin = 356;  iPortrait = 612;}
            else if(iAppearance == 3){  iCreatureSkin = 358;  iPortrait = 614;}
            else if(iAppearance == 4){  iCreatureSkin = 359;  iPortrait = 615;}
            else if(iAppearance == 5){  iCreatureSkin = 4972; iPortrait = 10004;}
            else if(iAppearance == 6){  iCreatureSkin = 4973; iPortrait = 10003;}
            break;
        }
        case MDF_RACIALTYPE_GARGOYLE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 73;   iPortrait = 210;}
            else if(iAppearance == 2){  iCreatureSkin = 4882; iPortrait = 210;}
            break;
        }
        case MDF_RACIALTYPE_HARPY:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 419;  iPortrait = 715;}
            break;
        }
        case MDF_RACIALTYPE_MEDUSA:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 352;  iPortrait = 608;}
            else if(iAppearance == 2){  iCreatureSkin = 3971; iPortrait = 608;}
            else if(iAppearance == 3){  iCreatureSkin = 3972; iPortrait = 608;}
            break;
        }
        case MDF_RACIALTYPE_DRYAD:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 51;   iPortrait = 201;}
            break;
        }
        case MDF_RACIALTYPE_NYMPH:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 126;  iPortrait = 261;}
            break;
        }
        case MDF_RACIALTYPE_PIXIE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 55;   iPortrait = 559;}
            break;
        }
        case MDF_RACIALTYPE_SATYR:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 32;   iPortrait = 1295;}
            else if(iAppearance == 2){  iCreatureSkin = 33;   iPortrait = 1295;}
            else if(iAppearance == 3){  iCreatureSkin = 2005; iPortrait = 2214;}
            else if(iAppearance == 4){  iCreatureSkin = 143;  iPortrait = 1295;}
            else if(iAppearance == 5){  iCreatureSkin = 2004; iPortrait = 2214;}
            break;
        }
        case MDF_RACIALTYPE_SPIDER_GIANT:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 7278; iPortrait = 2220;}
            else if(iAppearance == 2){  iCreatureSkin = 161;  iPortrait = 303;}
            else if(iAppearance == 3){  iCreatureSkin = 1063; iPortrait = 300;}
            else if(iAppearance == 4){  iCreatureSkin = 7284; iPortrait = 300;}
            else if(iAppearance == 5){  iCreatureSkin = 159;  iPortrait = 300;}
            else if(iAppearance == 6){  iCreatureSkin = 158;  iPortrait = 300;}
            else if(iAppearance == 7){  iCreatureSkin = 1061; iPortrait = 300;}
            else if(iAppearance == 8){  iCreatureSkin = 2249; iPortrait = 300;}
            else if(iAppearance == 9){  iCreatureSkin = 2898; iPortrait = 301;}
            else if(iAppearance == 10){ iCreatureSkin = 2169; iPortrait = 2040;}
            break;
        }
        case MDF_RACIALTYPE_SCARAB:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 18;   iPortrait = 155;}
            break;
        }
        case MDF_RACIALTYPE_SPIDER_GARGAN:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 4999; iPortrait = 300;}
            else if(iAppearance == 2){  iCreatureSkin = 7277; iPortrait = 300;}
            else if(iAppearance == 3){  iCreatureSkin = 7305; iPortrait = 2040;}
            else if(iAppearance == 4){  iCreatureSkin = 4998; iPortrait = 300;}
            break;
        }
        case MDF_RACIALTYPE_DRIDER:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 446;  iPortrait = 2081;}
            else if(iAppearance == 2){  iCreatureSkin = 4543; iPortrait = 2079;}
            else if(iAppearance == 3){  iCreatureSkin = 4542; iPortrait = 2017;}
            else if(iAppearance == 4){  iCreatureSkin = 2208; iPortrait = 2015;}
            else if(iAppearance == 5){  iCreatureSkin = 1145; iPortrait = 986;}
            else if(iAppearance == 6){  iCreatureSkin = 407;  iPortrait = 2078;}
            else if(iAppearance == 7){  iCreatureSkin = 4550; iPortrait = 2080;}
            else if(iAppearance == 8){  iCreatureSkin = 1144; iPortrait = 2020;}
            else if(iAppearance == 9){  iCreatureSkin = 2207; iPortrait = 2019;}
            else if(iAppearance == 10){ iCreatureSkin = 2212; iPortrait = 2021;}
            break;
        }
        case MDF_RACIALTYPE_HOOKHORROR:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 102;  iPortrait = 236;}
            else if(iAppearance == 2){  iCreatureSkin = 7312; iPortrait = 236;}
            break;
        }
        case MDF_RACIALTYPE_MINDFLAYER:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 1024; iPortrait = 2013;}
            else if(iAppearance == 2){  iCreatureSkin = 1023; iPortrait = 2101;}
            else if(iAppearance == 3){  iCreatureSkin = 1026; iPortrait = 2099;}
            else if(iAppearance == 4){  iCreatureSkin = 1027; iPortrait = 2100;}
            else if(iAppearance == 5){  iCreatureSkin = 1022; iPortrait = 709;}
            break;
        }
        case MDF_RACIALTYPE_MYCONID:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 944;  iPortrait = 2045;}
            else if(iAppearance == 2){  iCreatureSkin = 942;  iPortrait = 2045;}
            else if(iAppearance == 3){  iCreatureSkin = 943;  iPortrait = 2045;}
            break;
        }
        case MDF_RACIALTYPE_ENT:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 923;  iPortrait = 2030;}
            else if(iAppearance == 2){  iCreatureSkin = 7439; iPortrait = 2030;}
            else if(iAppearance == 3){  iCreatureSkin = 4493; iPortrait = 2030;}
            else if(iAppearance == 4){  iCreatureSkin = 2493; iPortrait = 10413;}
            break;
        }
        case MDF_RACIALTYPE_OOZE_B_W:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 2461; iPortrait = 2246;}
            else if(iAppearance == 2){  iCreatureSkin = 1250; iPortrait = 2251;}
            else if(iAppearance == 3){  iCreatureSkin = 2464; iPortrait = 2250;}
            else if(iAppearance == 4){  iCreatureSkin = 1247; iPortrait = 2247;}
            else if(iAppearance == 5){  iCreatureSkin = 2455; iPortrait = 2252;}
            else if(iAppearance == 6){  iCreatureSkin = 1217; iPortrait = 2246;}
            else if(iAppearance == 7){  iCreatureSkin = 1211; iPortrait = 735;}
            else if(iAppearance == 8){  iCreatureSkin = 1243; iPortrait = 2248;}
            else if(iAppearance == 9){  iCreatureSkin = 2473; iPortrait = 2248;}
            else if(iAppearance == 10){ iCreatureSkin = 2479; iPortrait = 2249;}
            break;
        }
        case MDF_RACIALTYPE_OOZE_CUBE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 4975; iPortrait = 937;}
            else if(iAppearance == 2){  iCreatureSkin = 4979; iPortrait = 937;}
            else if(iAppearance == 3){  iCreatureSkin = 4974; iPortrait = 937;}
            else if(iAppearance == 4){  iCreatureSkin = 4976; iPortrait = 937;}
            else if(iAppearance == 5){  iCreatureSkin = 4977; iPortrait = 937;}
            else if(iAppearance == 6){  iCreatureSkin = 4978; iPortrait = 937;}
            else if(iAppearance == 7){  iCreatureSkin = 4980; iPortrait = 937;}
            else if(iAppearance == 8){  iCreatureSkin = 4981; iPortrait = 937;}
            break;
        }
        case MDF_RACIALTYPE_ELEMENTAL_FIRE_E:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 60;   iPortrait = 2177;}
            else if(iAppearance == 2){  iCreatureSkin = 2359; iPortrait = 2177;}
            break;
        }
        case MDF_RACIALTYPE_ELEMENTAL_WIND_E:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 52;   iPortrait = 140;}
            else if(iAppearance == 2){  iCreatureSkin = 2344; iPortrait = 141;}
            break;
        }
        case MDF_RACIALTYPE_ELEMENTAL_EARTH_E:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 56;   iPortrait = 202;}
            else if(iAppearance == 2){  iCreatureSkin = 2362; iPortrait = 209;}
            break;
        }
        case MDF_RACIALTYPE_ELEMENTAL_WATER_E:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 69;   iPortrait = 2188;}
            else if(iAppearance == 2){  iCreatureSkin = 2357; iPortrait = 2188;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_RED:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 49;   iPortrait = 198;}
            else if(iAppearance == 2){  iCreatureSkin = 2674; iPortrait = 198;}
            else if(iAppearance == 3){  iCreatureSkin = 4623; iPortrait = 198;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_BLUE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 47;   iPortrait = 192;}
            else if(iAppearance == 2){  iCreatureSkin = 2603; iPortrait = 192;}
            else if(iAppearance == 3){  iCreatureSkin = 4599; iPortrait = 192;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_BLACK:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 41;   iPortrait = 191;}
            else if(iAppearance == 2){  iCreatureSkin = 2591; iPortrait = 191;}
            else if(iAppearance == 3){  iCreatureSkin = 4587; iPortrait = 191;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_GREEN:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 48;   iPortrait = 197;}
            else if(iAppearance == 2){  iCreatureSkin = 2663; iPortrait = 197;}
            else if(iAppearance == 3){  iCreatureSkin = 4611; iPortrait = 197;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_WHITE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 50;   iPortrait = 200;}
            else if(iAppearance == 2){  iCreatureSkin = 2699; iPortrait = 200;}
            else if(iAppearance == 3){  iCreatureSkin = 4635; iPortrait = 200;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_GOLD:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 46;   iPortrait = 196;}
            else if(iAppearance == 2){  iCreatureSkin = 4754; iPortrait = 196;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_BRASS:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 42;   iPortrait = 193;}
            else if(iAppearance == 2){  iCreatureSkin = 4719; iPortrait = 193;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_BRONZE:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 45;   iPortrait = 194;}
            else if(iAppearance == 2){  iCreatureSkin = 4731; iPortrait = 194;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_COPPER:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 43;   iPortrait = 195;}
            else if(iAppearance == 2){  iCreatureSkin = 4743; iPortrait = 195;}
            break;
        }
        case MDF_RACIALTYPE_DRAGON_SILVER:
        {
            if(iAppearance == 1)     {  iCreatureSkin = 44;   iPortrait = 199;}
            else if(iAppearance == 2){  iCreatureSkin = 4767; iPortrait = 199;}
            break;
        }


    }
    GuardarIntPersistente(oPC,IntToString(iRace),iCreatureSkin);
    GuardarIntPersistente(oPC,IntToString(iRace)+"portrait",iPortrait);

}




void main()
{
    int iRace = StringToInt(GetScriptParam("RACE"));
    int iAppearance = StringToInt(GetScriptParam("APPEARANCE"));
    SetCustomAppearanceAndPortrait(GetPCSpeaker(),iRace,iAppearance);


}
