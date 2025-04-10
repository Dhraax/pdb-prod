//::///////////////////////////////////////////////
//:: MIL_TAILOR Include
//::  restricted items list(s)
//:://////////////////////////////////////////////
/*
//:://////////////////////////////////////////////
//:: Created By: bloodsong from milambus' tailor stuff
//:://////////////////////////////////////////////
/*
  Restriction Lists add-on

  you can create a list of part numbers you do not wish
people to access on the tailoring models.  this is set
up for the neck, torso, belt, and hip.
  remember to remove the // before any lines you are using.

  To Restrict Individual Numbers:

place a list of case statements above the return TRUE; line.
 ie:
        case 1:
        case 53:
        case 42:
          return TRUE;

  To Restrict Number Ranges:

replace the [low#] and [high#] with your starting and ending numbers
(inclusive), in the if statement.  copy the base if statment for more
ranges.
ie, to exclude 1, 2, 3, 4, and 5:

       if( n >= 1 && n <= 5)  return TRUE;


  To Find the Numbers to Restrict:

edit a piece of clothing/armor and cycle through the body part lists.
note down any numbers you want people not to use. also note which gender
they are on.  put female parts in the first segment of each section.
*/

//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int NeckIsInvalid(int n, int g)
{

  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}

//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int TorsoIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int BeltIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int HipIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List

    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}


//checks if n is a valid number; TRUE is INvalid, FALSE is valid
int RobeIsInvalid(int n, int g)
{
  if(g == GENDER_FEMALE)
  {//-- this is the female part list
    switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;
  }
  //--This is the Everybody Else Part List
  switch(n)
    {
      //case #:
      //  return TRUE;
    }

    // if(n >= [low#] && n<= [high#])  return TRUE;

    return FALSE;

}





//-- MILAMBUS' COLOUR CODES: do not touch anything below this line--------------------------------

// Returns the name of a color given is index.
string ClothColor(int iColor) {
    switch (iColor) {
        case 00: return "Marrón/Curtido Más Claro";
        case 01: return "Marrón/Curtido Claro";
        case 02: return "Marrón/Curtido Oscuro";
        case 03: return "Más Oscuro Marrón/Curtido";

        case 04: return "Rojo/Curtido Más Claro";
        case 05: return "Rojo/Curtido Claro";
        case 06: return "Rojo/Curtido Oscuro";
        case 07: return "Rojo/Curtido Más Oscuro";

        case 08: return "Amarillo/Curtido Más Claro";
        case 09: return "Amarillo/Curtido Claro";
        case 10: return "Amarillo/Curtido Oscuro";
        case 11: return "Amarillo/Curtido Más Oscuro";

        case 12: return "Gris/Curtido Más Claro";
        case 13: return "Gris/Curtido Claro";
        case 14: return "Gris/Curtido Oscuro";
        case 15: return "Gris/Curtido Más Oscuro";

        case 16: return "Oliva Más Claro";
        case 17: return "Oliva Claro";
        case 18: return "Oliva Oscuro";
        case 19: return "Oliva Más Oscuro";

        case 20: return "Blanco";
        case 21: return "Gris Claro";
        case 22: return "Gris Oscuro";
        case 23: return "Carbón";

        case 24: return "Azul Claro";
        case 25: return "Azul Oscuro";

        case 26: return "Aguamarina Claro";
        case 27: return "Aguamarina Oscuro";

        case 28: return "Azul Turquesa Claro";
        case 29: return "Azul Turquesa Oscuro";

        case 30: return "Verde Claro";
        case 31: return "Verde Oscuro";

        case 32: return "Amarillo Claro";
        case 33: return "Amarillo Oscuro";

        case 34: return "Naranja Claro";
        case 35: return "Naranja Oscuro";

        case 36: return "Rojo Claro";
        case 37: return "Rojo Oscuro";

        case 38: return "Rosa Claro";
        case 39: return "Rosa Oscuro";

        case 40: return "Púrpura Claro";
        case 41: return "Púrpura Oscuro";

        case 42: return "Violeta Claro";
        case 43: return "Violeta Oscuro";

        case 44: return "Blanco Brillante";
        case 45: return "Negro Brillante";

        case 46: return "Azul Brillante";
        case 47: return "Aguamarina Brillante";

        case 48: return "Azul Turquesa Brillante";
        case 49: return "Verde Brillante";

        case 50: return "Amarillo Brillante";
        case 51: return "Naranja Brillante";

        case 52: return "Rojo Brillante";
        case 53: return "Rosa Brillante";

        case 54: return "Púrpura Brillante";
        case 55: return "Violeta Brillante";

        case 56: return "Plateado";
        case 57: return "Obsidiana";
        case 58: return "Dorado";
        case 59: return "Cobre";
        case 60: return "Gris";
        case 61: return "Espejo";
        case 62: return "Blanco Puro";
        case 63: return "Negro Puro";

        case 64: return "Rosa Ahumado";
        case 65: return "Gris Pardo Ahumado";
        case 66: return "Dorado Ahumado";
        case 67: return "Verde Hoja Ahumado";
        case 68: return "Verde Ahumado";
        case 69: return "Verde Oscuro Ahumado";
        case 70: return "Púrpura Real Ahumado";
        case 71: return "Anochecer Ahumado";
        case 72: return "Ciruela Ahumado";
        case 73: return "Wisteria Ahumado";
        case 74: return "Marrón Ahumado";
        case 75: return "Gris Ahumado";
        case 76: return "Verde Mar Ahumado";
        case 77: return "Hoja Eucalipto Ahumado";
        case 78: return "Azul Ahumado";
        case 79: return "Azul Obsidiana Ahumado";
        case 80: return "Verde Cazador Ahumado";
        case 81: return "Verde Tomillo Ahumado";
        case 82: return "Azul Hielo Ahumado";
        case 83: return "Azul Cobalto Ahumado";
        case 84: return "Verde Ala de Saltamontes Ahumado";
        case 85: return "Piedra Ahumado";
        case 86: return "Champiñón Ahumado";
        case 87: return "Verde Musgo Ahumado";
        case 88: return "Rojo Más Claro Ahumado";
        case 89: return "Rojo Claro Ahumado";
        case 90: return "Rojo Ahumado";
        case 91: return "Rojo Oscuro Ahumado";
        case 92: return "Latón Más Claro Ahumado";
        case 93: return "Latón Claro Ahumado";
        case 94: return "Latón Ahumado";
        case 95: return "Latón Ahumado Oscuro";
        case 96: return "Negro Cereza Más Claro";
        case 97: return "Negro Claro Cereza";
        case 98: return "Negro Cereza";
        case 99: return "Negro Oscuro Cereza";
        case 100: return "Canela Más Claro";
        case 101: return "Canela Claro";
        case 102: return "Canela";
        case 103: return "Canela Oscuro";
        case 104: return "Verde Cazador Más Claro";
        case 105: return "Verde Cazador Claro";
        case 106: return "Verde Cazador";
        case 107: return "Verde Cazador Oscuro";
        case 108: return "Verde Druida Más Claro";
        case 109: return "Verde Druida Claro";
        case 110: return "Verde Druida";
        case 111: return "Verde Druida Oscuro";
        case 112: return "Niebla de Cementerio Más Claro";
        case 113: return "Niebla de Cementerio Claro";
        case 114: return "Niebla de Cementerio";
        case 115: return "Niebla de Cementerio Oscuro";
        case 116: return "Castaño Más Claro";
        case 117: return "Castaño Claro";
        case 118: return "Castaño";
        case 119: return "Castaño Oscuro";
        case 120: return "Arcilla Más Claro";
        case 121: return "Arcilla Claro";
        case 122: return "Arcilla";
        case 123: return "Oscuro Arcilla";
        case 124: return "Ceniza Tostado Más Claro";
        case 125: return "Ceniza Tostado Claro";
        case 126: return "Tostado Ceniza";
        case 127: return "Ceniza Tostado Oscuro";
        case 128: return "Marrón Caracol Más Claro";
        case 129: return "Marrón Caracol Claro";
        case 130: return "Marrón Caracol";
        case 131: return "Marrón Caracol Oscuro";
        case 132: return "Azul Cobalto Más Claro";
        case 133: return "Azul Cobalto Claro";
        case 134: return "Azul Cobalto";
        case 135: return "Azul Cobalto Oscuro";
        case 136: return "Azul Medianoche Más Claro";
        case 137: return "Azul Medianoche Claro";
        case 138: return "Azul Medianoche";
        case 139: return "Azul Medianoche Oscuro";
        case 140: return "Verde Pavo Real Más Claro";
        case 141: return "Verde Pavo Real Claro";
        case 142: return "Verde Pavo Real";
        case 143: return "Verde Pavo Real Oscuro";
        case 144: return "Púrpura Real Más Claro";
        case 145: return "Púrpura Real Claro";
        case 146: return "Púrpura Real";
        case 147: return "Púrpura Real Oscuro";
        case 148: return "Azul Montaña";
        case 149: return "Azul Montaña Oscuro";
        case 150: return "Espuma Verdemar";
        case 151: return "Espuma Verdemar Oscura";
        case 152: return "Verde Primavera";
        case 153: return "Verde Primavera Oscuro";
        case 154: return "Dorado Miel";
        case 155: return "Dorado Miel Oscuro";
        case 156: return "Moneda de Cobre";
        case 157: return "Moneda de Cobre Oscuro";
        case 158: return "Baya Hielo";
        case 159: return "Baya Hielo Oscuro";
        case 160: return "Ciruela Caramelo";
        case 161: return "Ciruela Caramelo Oscuro";
        case 162: return "Baya Hielo Claro";
        case 163: return "Ciruela";
        case 164: return "Azul Hielo";
        case 165: return "Azul Cadete";
        case 166: return "Blanco Hielo";
        case 167: return "Negro Ónice";
        case 168: return "Tallo de Apio";
        case 169: return "Perenne";
        case 170: return "Púrpura Místico";
        case 171: return "Azul Místico";
        case 172: return "Dorado Verdoso";
        case 173: return "Chocolate frambuesa";
        case 174: return "Marrón Cuero";
        case 175: return "Dorado Moteado";
    }

    return "";
}

// Returns the name of a color given is index.
string MetalColor(int iColor) {
    switch (iColor) {
        case 00: return "Plateado Brillante Más Claro";
        case 01: return "Plateado Brillante Claro";
        case 02: return "Obsidiana Brillante Oscuro";
        case 03: return "Obsidiana Brillante Más Oscuro";

        case 04: return "Plateado Opaco Más Claro";
        case 05: return "Plateado Opaco Claro";
        case 06: return "Obsidiana Opaco Oscuro";
        case 07: return "Obsidiana Opaco Más Oscuro";

        case 08: return "Dorado Más Claro";
        case 09: return "Dorado Claro";
        case 10: return "Dorado Oscuro";
        case 11: return "Dorado Más Oscuro";

        case 12: return "Dorado Celestial Más Claro";
        case 13: return "Dorado Celestial Claro";
        case 14: return "Dorado Celestial Oscuro";
        case 15: return "Dorado Celestial Más Oscuro";

        case 16: return "Cobre Más Claro";
        case 17: return "Cobre Claro";
        case 18: return "Cobre Oscuro";
        case 19: return "Cobre Más Oscuro";

        case 20: return "Latón Más Claro";
        case 21: return "Latón Claro";
        case 22: return "Latón Oscuro";
        case 23: return "Latón Más Oscuro";

        case 24: return "Rojo Claro";
        case 25: return "Rojo Oscuro";
        case 26: return "Rojo Opaco Claro";
        case 27: return "Rojo Opaco Oscuro";

        case 28: return "Púrpura Claro";
        case 29: return "Púrpura Oscuro";
        case 30: return "Púrpura Opaco Claro";
        case 31: return "Púrpura Opaco Oscuro";

        case 32: return "Azul Claro";
        case 33: return "Azul Oscuro";
        case 34: return "Azul Opaco Claro";
        case 35: return "Azul Opaco Oscuro";

        case 36: return "Azul Turquesa Claro";
        case 37: return "Azul Turquesa Oscuro";
        case 38: return "Azul Turquesa Opaco Claro";
        case 39: return "Azul Turquesa Opaco Oscuro";

        case 40: return "Verde Claro";
        case 41: return "Verde Oscuro";
        case 42: return "Verde Opaco Claro";
        case 43: return "Verde Opaco Oscuro";

        case 44: return "Oliva Claro";
        case 45: return "Oliva Oscuro";
        case 46: return "Oliva Opaco Claro";
        case 47: return "Oliva Opaco Oscuro";

        case 48: return "Prismático Claro";
        case 49: return "Prismático Oscuro";

        case 50: return "Ladrillo Más Claro";
        case 51: return "Ladrillo Claro";
        case 52: return "Ladrillo Oscuro";
        case 53: return "Ladrillo Más Oscuro";

        case 54: return "Metal Envejecido Claro";
        case 55: return "Metal Envejecido Oscuro";

        case 56: return "Plateado";
        case 57: return "Obsidiana";
        case 58: return "Dorado";
        case 59: return "Cobre";
        case 60: return "Gris";
        case 61: return "Espejo";
        case 62: return "Blanco Puro";
        case 63: return "Negro Puro";

        case 64: return "Rosa Ahumado";
        case 65: return "Gris Pardo Ahumado";
        case 66: return "Dorado Ahumado";
        case 67: return "Verde Hoja Ahumado";
        case 68: return "Verde Ahumado";
        case 69: return "Verde Oscuro Ahumado";
        case 70: return "Real Púrpura Ahumado";
        case 71: return "Anochecer Ahumado";
        case 72: return "Ciruela Ahumado";
        case 73: return "Wisteria Ahumado";
        case 74: return "Marrón Ahumado";
        case 75: return "Gris Ahumado";
        case 76: return "Verde Mar Ahumado";
        case 77: return "Hoja Eucalipto Ahumado";
        case 78: return "Azul Ahumado";
        case 79: return "Azul pizarra Ahumado";
        case 80: return "Verde Cazador Ahumado";
        case 81: return "Verde Tomillo Ahumado";
        case 82: return "Azul Hielo Ahumado";
        case 83: return "Azul Cobalto Ahumado";
        case 84: return "Ala Verde de Saltamontes Ahumado";
        case 85: return "Piedra Ahumado";
        case 86: return "Champiñón Ahumado";
        case 87: return "Verde Musgo Ahumado";
        case 88: return "Rojo Más Claro Ahumado";
        case 89: return "Rojo Claro Ahumado";
        case 90: return "Rojo Ahumado";
        case 91: return "Rojo Oscuro Ahumado";
        case 92: return "Latón Más Claro Ahumado";
        case 93: return "Latón Claro Ahumado";
        case 94: return "Latón Ahumado";
        case 95: return "Latón Oscuro Ahumado";
        case 96: return "Negro Cereza Más Claro";
        case 97: return "Negro Cereza Claro";
        case 98: return "Negro Cereza";
        case 99: return "Negro Cereza Oscuro";
        case 100: return "Canela Más Claro";
        case 101: return "Canela Claro";
        case 102: return "Canela";
        case 103: return "Canela Oscuro";
        case 104: return "Verde Cazador Más Claro";
        case 105: return "Verde Cazador Claro";
        case 106: return "Verde Cazador";
        case 107: return "Verde Cazador Oscuro";
        case 108: return "Verde Druida Más Claro";
        case 109: return "Verde Druida Claro";
        case 110: return "Verde Druida";
        case 111: return "Verde Druida Oscuro";
        case 112: return "Niebla de Cementerio Más Claro";
        case 113: return "Niebla de Cementerio Claro";
        case 114: return "Niebla de Cementerio";
        case 115: return "Niebla de Cementerio Oscuro";
        case 116: return "Castaño Más Claro";
        case 117: return "Castaño Claro";
        case 118: return "Castaño";
        case 119: return "Castaño Oscuro";
        case 120: return "Arcilla Más Claro";
        case 121: return "Arcilla Claro";
        case 122: return "Arcilla";
        case 123: return "Arcilla Oscuro";
        case 124: return "Ceniza Tostado Más Claro";
        case 125: return "Ceniza Tostado Claro";
        case 126: return "Ceniza Tostado";
        case 127: return "Ceniza Tostado Oscuro";
        case 128: return "Marrón Caracol Más Claro";
        case 129: return "Marrón Caracol Claro";
        case 130: return "Marrón Caracol";
        case 131: return "Marrón Caracol Oscuro";
        case 132: return "Azul Cobalto Más Claro";
        case 133: return "Azul Cobalto Claro";
        case 134: return "Azul Cobalto";
        case 135: return "Azul Cobalto Oscuro";
        case 136: return "Azul Medianoche Más Claro";
        case 137: return "Azul Medianoche Claro";
        case 138: return "Azul Medianoche";
        case 139: return "Azul Medianoche Oscuro";
        case 140: return "Verde Pavo Real Más Claro";
        case 141: return "Verde Pavo Real Claro";
        case 142: return "Verde Pavo Real";
        case 143: return "Verde Pavo Real Oscuro";
        case 144: return "Púrpura Real Más Claro";
        case 145: return "Púrpura Real Claro";
        case 146: return "Púrpura Real";
        case 147: return "Púrpura Real Oscuro";
        case 148: return "Azul Montaña";
        case 149: return "Azul Montaña Oscuro";
        case 150: return "Espuma Verdemar";
        case 151: return "Espuma Verdemar Oscuro";
        case 152: return "Verde Primavera";
        case 153: return "Verde Primavera Oscuro";
        case 154: return "Dorado Miel";
        case 155: return "Dorado Miel Oscuro";
        case 156: return "Cobre Moneda";
        case 157: return "Cobre Moneda Oscuro";
        case 158: return "Baya Hielo";
        case 159: return "Baya Hielo Oscuro";
        case 160: return "Ciruela Caramelo";
        case 161: return "Ciruela Caramelo Oscuro";
        case 162: return "Baya Hielo Claro";
        case 163: return "Ciruela";
        case 164: return "Azul Hielo";
        case 165: return "Azul Cadete";
        case 166: return "Blanco Hielo";
        case 167: return "Negro Ónice";
        case 168: return "Tallo de Apio";
        case 169: return "Perenne";
        case 170: return "Púrpura Místico";
        case 171: return "Azul Místico";
        case 172: return "Dorado Verdoso";
        case 173: return "Chocolate frambuesa";
        case 174: return "Marrón Cuero Marrón";
        case 175: return "Dorado Moteado";
    }

    return "";
}

// void main() {}
