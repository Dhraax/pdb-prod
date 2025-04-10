//::////////////////////////////////////////////////////////////////////////////
//:: TRAMPAS ALEATORIAS, libreria
//:: Copyright (c) www.puertadebaldur.net
//::////////////////////////////////////////////////////////////////////////////
/*
  Libreria de las trampas aleatorias

  INSTRUCCIONES
  -------------

  1. Coloca el script pb_trampas_enter en el OnEnter del Area.

  2. (Opcional) Ajusta las siguientes variables de area, sino se tomaran los valores por defecto:
  "TRAMPA_REGENERACION", float. Cada cuantos segundos se regeneran las trampas del area. Por defecto 3000 segundos.
  "TRAMPA_PROBABILIDAD", int, 0-100. Porcentage de aparicion de trampas en ubicados y puertas. Por defecto 30%.
  "TRAMPA_TIPO", int, 1-5. Categoria de trampas (menores, corrientes, fuertes, mortiferas y epicas) que tendra toda el area. Por defecto corrientes.
  "TRAMPA_TIPO_ESPECIFICO" 1-47, int. Trampa especifica que tendra toda el area. Se recomienda consultar las constantes TRAP_BASE_TYPE_* del Lexicon para conocer el int.
  "TRAMPA_SUELO_INCREMENTO", int. Nº de trampas en el suelo que se sumaran a las 15 trampas base aleatorias. Por defecto 5. Se recomienda no excederse.

  3. (Opcional) Ajusta las siguientes variables en los ubicados o puertas:
  "TRAMPA_SIEMPRE", int, 1. El ubicado o puerta siempre tendra trampa.
  "TRAMPA_NUNCA", int, 1. El ubicado o puerta nunca tendra trampa.

*/
//::////////////////////////////////////////////////////////////////////////////
//:: Creado por: Monti
//:: Creado el: 7 de Enero de 2013
//::////////////////////////////////////////////////////////////////////////////

// -----------------------------------------------------------------------------
//  CONSTANTES
// -----------------------------------------------------------------------------

// Regeneracion de trampas en segundos por defecto
const float PB_TRAMPAS_REGENERACION = 4000.0; // 66 minutos

// Caracteristicas generales de las trampas por defecto
const float PB_TRAMPAS_TAMANYO          = 3.0;   // 3 metros de tamanyo (las del suelo)
const int   PB_TRAMPAS_PROBABILIDAD     = 30;    // 30% de probabilidad (en ubicados y puertas)
const int   PB_TRAMPAS_TIPO             = 2;     // Tipo de danyo de todas las trampas del area (por defecto: corrientes)
const int   PB_TRAMPAS_SUELO_BASE       = 15;    // Nº de trampas en el suelo base aleatorias
const int   PB_TRAMPAS_SUELO_INCREMENTO = 5;     // Nº de trampas en el suelo que se pueden anyadir
const int   PB_TRAMPAS_DETECTABLES      = TRUE;  // Sí detectables
const int   PB_TRAMPAS_DESARMABLES      = TRUE;  // Sí desarmables
const int   PB_TRAMPAS_RECUPERABLES     = FALSE; // No recuperables
const int   PB_TRAMPAS_1UNICOUSO        = TRUE;  // Solo se disparan una vez

// Constantes de Desarme
const int PB_TRAMPA_CD_DESARME_BASE      = 25;
const int PB_TRAMPA_CD_DESARME_ALEATORIO = 10;

// Constantes de Deteccion
const int PB_TRAMPA_CD_DETECCION_BASE      = 15;
const int PB_TRAMPA_CD_DETECCION_ALEATORIO = 5;

// Modificadores de Desarme y Deteccion
const int PB_TRAMPA_MOD_MENOR     = 5;
const int PB_TRAMPA_MOD_CORRIENTE = 10;
const int PB_TRAMPA_MOD_FUERTE    = 15;
const int PB_TRAMPA_MOD_MORTIFERA = 20;
const int PB_TRAMPA_MOD_EPICA     = 25;

// -----------------------------------------------------------------------------
//  DEFINICIONES
// -----------------------------------------------------------------------------

// Obtiene un lugar aleatorio del area, usado en las trampas en el suelo
location PBTrampaLugarAleatorioArea(object oArea=OBJECT_SELF);

// Obtiene el tipo de trampa (menores, corrientes, fuertes, etc.)
// 1º se mira en el Area, si es valor nulo se toma valor por defecto
int PBTrampaTipo();

// Obtiene el tipo especifico de trampa (acido, fuego, frio, etc.)
// 1º se mira en el Area, si es valor nulo se toma valor por defecto
int PBTrampaTipoEspecifico(int iTrampaTipo);

// Obtiene el valor de Desarme segun las constantes de arriba
int PBTrampaCDDesarme(int iTipo);

// Obtiene el valor de Deteccion segun las constantes de arriba
int PBTrampaCDDeteccion(int iTipo);

// Obtiene el incremento de las trampas en el suelo
int PBTrampaSueloIncremento();

// Obtiene la regeneracion de las trampas
float PBTrampaRegeneracion();

// Configura las distintas opciones de las trampas segun las constantes de arriba
void PBTrampaAjustes(object oTrampa, int iTrampaTipo);

// -----------------------------------------------------------------------------
//  FUNCIONES
// -----------------------------------------------------------------------------

location PBTrampaLugarAleatorioArea(object oArea=OBJECT_SELF)
{
   float fAreaH = IntToFloat(GetAreaSize(AREA_HEIGHT, oArea));
   float fAreaW = IntToFloat(GetAreaSize(AREA_WIDTH, oArea));
   float fMaxAreaSizeH = 32.0;
   float fMaxAreaSizeW = 32.0;
   float fScaleAreaH = fMaxAreaSizeH/fAreaH;
   float fScaleAreaW = fMaxAreaSizeW/fAreaW;
   float fXLoc32 = IntToFloat(((d8()-1)*4 + (d4()-1))*10 + d10());
   float fYLoc32 = IntToFloat(((d8()-1)*4 + (d4()-1))*10 + d10());
   float fXLoc = fXLoc32/fScaleAreaW;
   float fYLoc = fYLoc32/fScaleAreaH;
   vector vPosition = Vector(fXLoc, fYLoc, 0.0f);
   float fOrientation = IntToFloat(((d6()-1)*6 +(d6()-1))*10 + (d10()-1));

   return Location(oArea, vPosition , fOrientation);
}

int PBTrampaTipo()
{
  int iTrampaTipo = GetLocalInt(OBJECT_SELF, "TRAMPA_TIPO");
  if(iTrampaTipo == 0)
  {
      iTrampaTipo = PB_TRAMPAS_TIPO;
      SetLocalInt(OBJECT_SELF, "TRAMPA_TIPO", PB_TRAMPAS_TIPO);
  }

  return iTrampaTipo;
}

int PBTrampaTipoEspecifico(int iTrampaTipo)
{
  int iTipoEspecifico;

  iTipoEspecifico = GetLocalInt(OBJECT_SELF, "TRAMPA_TIPO_ESPECIFICO");
  if(iTipoEspecifico > 0) return iTipoEspecifico;

  iTipoEspecifico = Random(11) + 1;
  switch(iTrampaTipo)
  {
      case 1: switch(iTipoEspecifico)// Minor
              {
                  case 1:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_ACID;       return iTipoEspecifico;
                  case 2:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_ACID_SPLASH;return iTipoEspecifico;
                  case 3:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_ELECTRICAL; return iTipoEspecifico;
                  case 4:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_FIRE;       return iTipoEspecifico;
                  case 5:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_FROST;      return iTipoEspecifico;
                  case 6:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_GAS;        return iTipoEspecifico;
                  case 7:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_HOLY;       return iTipoEspecifico;
                  case 8:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_NEGATIVE;   return iTipoEspecifico;
                  case 9:  iTipoEspecifico = TRAP_BASE_TYPE_MINOR_SONIC;      return iTipoEspecifico;
                  case 10: iTipoEspecifico = TRAP_BASE_TYPE_MINOR_SPIKE;      return iTipoEspecifico;
                  case 11: iTipoEspecifico = TRAP_BASE_TYPE_MINOR_TANGLE;     return iTipoEspecifico;
              }

      case 2: switch(iTipoEspecifico)// Average
              {
                  case 1: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_ACID;       return iTipoEspecifico;
                  case 2: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_ACID_SPLASH;return iTipoEspecifico;
                  case 3: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_ELECTRICAL; return iTipoEspecifico;
                  case 4: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_FIRE;       return iTipoEspecifico;
                  case 5: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_FROST;      return iTipoEspecifico;
                  case 6: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_GAS;        return iTipoEspecifico;
                  case 7: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_HOLY;       return iTipoEspecifico;
                  case 8: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_NEGATIVE;   return iTipoEspecifico;
                  case 9: iTipoEspecifico  = TRAP_BASE_TYPE_AVERAGE_SONIC;      return iTipoEspecifico;
                  case 10: iTipoEspecifico = TRAP_BASE_TYPE_AVERAGE_SPIKE;      return iTipoEspecifico;
                  case 11: iTipoEspecifico = TRAP_BASE_TYPE_AVERAGE_TANGLE;     return iTipoEspecifico;
              }

      case 3: switch(iTipoEspecifico)// Strong
              {
                  case 1: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_ACID;       return iTipoEspecifico;
                  case 2: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_ACID_SPLASH;return iTipoEspecifico;
                  case 3: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_ELECTRICAL; return iTipoEspecifico;
                  case 4: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_FIRE;       return iTipoEspecifico;
                  case 5: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_FROST;      return iTipoEspecifico;
                  case 6: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_GAS;        return iTipoEspecifico;
                  case 7: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_HOLY;       return iTipoEspecifico;
                  case 8: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_NEGATIVE;   return iTipoEspecifico;
                  case 9: iTipoEspecifico  = TRAP_BASE_TYPE_STRONG_SONIC;      return iTipoEspecifico;
                  case 10: iTipoEspecifico = TRAP_BASE_TYPE_STRONG_SPIKE;      return iTipoEspecifico;
                  case 11: iTipoEspecifico = TRAP_BASE_TYPE_STRONG_TANGLE;     return iTipoEspecifico;
              }

      case 4: switch(iTipoEspecifico)// Deadly
              {
                  case 1: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_ACID;       return iTipoEspecifico;
                  case 2: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_ACID_SPLASH;return iTipoEspecifico;
                  case 3: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_ELECTRICAL; return iTipoEspecifico;
                  case 4: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_FIRE;       return iTipoEspecifico;
                  case 5: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_FROST;      return iTipoEspecifico;
                  case 6: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_GAS;        return iTipoEspecifico;
                  case 7: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_HOLY;       return iTipoEspecifico;
                  case 8: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_NEGATIVE;   return iTipoEspecifico;
                  case 9: iTipoEspecifico  = TRAP_BASE_TYPE_DEADLY_SONIC;      return iTipoEspecifico;
                  case 10: iTipoEspecifico = TRAP_BASE_TYPE_DEADLY_SPIKE;      return iTipoEspecifico;
                  case 11: iTipoEspecifico = TRAP_BASE_TYPE_DEADLY_TANGLE;     return iTipoEspecifico;
              }

      case 5: iTipoEspecifico = Random(4) + 1;

              switch(iTipoEspecifico)// Epic
              {
                  case 1: iTipoEspecifico = TRAP_BASE_TYPE_EPIC_ELECTRICAL;return iTipoEspecifico;
                  case 2: iTipoEspecifico = TRAP_BASE_TYPE_EPIC_FIRE;      return iTipoEspecifico;
                  case 3: iTipoEspecifico = TRAP_BASE_TYPE_EPIC_FROST;     return iTipoEspecifico;
                  case 4: iTipoEspecifico = TRAP_BASE_TYPE_EPIC_SONIC;     return iTipoEspecifico;
              }
    }
    return TRAP_BASE_TYPE_AVERAGE_SPIKE;
}

int PBTrampaCDDesarme(int iTipo)
{
  int iCD = PB_TRAMPA_CD_DESARME_BASE;
  switch(iTipo)
  {
      case 1: iCD += PB_TRAMPA_MOD_MENOR;     break;
      case 2: iCD += PB_TRAMPA_MOD_CORRIENTE; break;
      case 3: iCD += PB_TRAMPA_MOD_FUERTE;    break;
      case 4: iCD += PB_TRAMPA_MOD_MORTIFERA; break;
      case 5: iCD += PB_TRAMPA_MOD_EPICA;     break;
  }
  iCD += Random(PB_TRAMPA_CD_DESARME_ALEATORIO) + 1;
  return iCD;
}

int PBTrampaCDDeteccion(int iTipo)
{
  int iCD = PB_TRAMPA_CD_DETECCION_BASE;
  switch(iTipo)
  {
      case 1: iCD += PB_TRAMPA_MOD_MENOR;     break;
      case 2: iCD += PB_TRAMPA_MOD_CORRIENTE; break;
      case 3: iCD += PB_TRAMPA_MOD_FUERTE;    break;
      case 4: iCD += PB_TRAMPA_MOD_MORTIFERA; break;
      case 5: iCD += PB_TRAMPA_MOD_EPICA;     break;
  }
  iCD += Random(PB_TRAMPA_CD_DETECCION_ALEATORIO) + 1;
  return iCD;
}

int PBTrampaSueloIncremento()
{
  int iTrampaSueloIncremento = GetLocalInt(OBJECT_SELF, "TRAMPA_SUELO_INCREMENTO");
  if(iTrampaSueloIncremento == 0)
  {
      iTrampaSueloIncremento = PB_TRAMPAS_SUELO_INCREMENTO;
      SetLocalInt(OBJECT_SELF, "TRAMPA_SUELO_INCREMENTO", PB_TRAMPAS_SUELO_INCREMENTO);
  }

  return iTrampaSueloIncremento;
}

float PBTrampaRegeneracion()
{
  float iTrampaRegeneracion = GetLocalFloat(OBJECT_SELF, "TRAMPA_REGENERACION");
  if(iTrampaRegeneracion == 0.0)
  {
      iTrampaRegeneracion = PB_TRAMPAS_REGENERACION;
      SetLocalFloat(OBJECT_SELF, "TRAMPA_REGENERACION", PB_TRAMPAS_REGENERACION);
  }

  return iTrampaRegeneracion;
}

int PBTrampaProbabilidad()
{
  int iTrampaProbabilidad = GetLocalInt(OBJECT_SELF, "TRAMPA_PROBABILIDAD");
  if(iTrampaProbabilidad == 0)
  {
      iTrampaProbabilidad = PB_TRAMPAS_PROBABILIDAD;
      SetLocalInt(OBJECT_SELF, "TRAMPA_PROBABILIDAD", PB_TRAMPAS_PROBABILIDAD);
  }

  return iTrampaProbabilidad;
}

void PBTrampaAjustes(object oTrampa, int iTrampaTipo)
{
  SetTrapDetectable(oTrampa, PB_TRAMPAS_DETECTABLES);
  SetTrapDetectDC(oTrampa, PBTrampaCDDeteccion(iTrampaTipo));
  SetTrapDisarmable(oTrampa, PB_TRAMPAS_DESARMABLES);
  SetTrapDisarmDC(oTrampa, PBTrampaCDDesarme(iTrampaTipo));
  SetTrapRecoverable(oTrampa, PB_TRAMPAS_RECUPERABLES);
  SetTrapOneShot(oTrampa, PB_TRAMPAS_1UNICOUSO);
}

void PBEliminarTrampasDelArea()
{
  object oCreadorTrampa;
  object oObjeto = GetFirstObjectInArea();

  // Variables
  SetLocalInt(OBJECT_SELF, "PB_TRAMPAS_REG", TRUE);
  DelayCommand(PBTrampaRegeneracion(), DeleteLocalInt(OBJECT_SELF, "PB_TRAMPAS_REG"));

  if(GetLocalInt(OBJECT_SELF, "PB_TRAMPAS_INI") == FALSE)
  {
      SetLocalInt(OBJECT_SELF, "PB_TRAMPAS_INI", TRUE);
      return;
  }

  while(GetIsObjectValid(oObjeto))
  {
      // 1. Quita trampas (ubicados, puertas y suelo)
      // La primera vez no se ejecuta
      if(GetIsTrapped(oObjeto))
      {
          oCreadorTrampa = GetTrapCreator(oObjeto);
          if(!GetIsPC(oCreadorTrampa) && !GetLocalInt(oObjeto, "TRAMPA_SIEMPRE"))
          {
              SetTrapDisabled(oObjeto);
          }
      }

      oObjeto = GetNextObjectInArea();
  }
}

void PBTrampasColocarTrampasEnElArea()
{
  int iTrampaTipo = PBTrampaTipo();
  int iProbabilidad = PBTrampaProbabilidad();
  int iTipoObjeto, iTrampasSuelo, iTrampaTipoEspecifico;
  object oTrampaSuelo;
  object oObjeto = GetFirstObjectInArea();

  while(GetIsObjectValid(oObjeto))
  {
      // 2. Se ponen trampas en ubicados y puertas
      iTipoObjeto = GetObjectType(oObjeto);
      if(!GetIsTrapped(oObjeto) && !GetLocalInt(oObjeto, "TRAMPA_NUNCA") &&
        (iTipoObjeto == OBJECT_TYPE_DOOR ||
        (iTipoObjeto == OBJECT_TYPE_PLACEABLE && GetUseableFlag(oObjeto))))
      {
          if(GetLocalInt(oObjeto, "TRAMPA_SIEMPRE") || Random(100)+1 <= iProbabilidad)
          {
              CreateTrapOnObject(PBTrampaTipoEspecifico(iTrampaTipo), oObjeto, STANDARD_FACTION_HOSTILE, "pb_trampas_xp");
              PBTrampaAjustes(oObjeto, iTrampaTipo);
          }
      }

      // 3. Se Ponen trampas en el suelo
      if(iTrampasSuelo <= (Random(PB_TRAMPAS_SUELO_BASE) + PBTrampaSueloIncremento()))
      {
          oTrampaSuelo = CreateTrapAtLocation(PBTrampaTipoEspecifico(iTrampaTipo), PBTrampaLugarAleatorioArea(), PB_TRAMPAS_TAMANYO, "", STANDARD_FACTION_HOSTILE, "pb_trampas_xp");
          PBTrampaAjustes(oTrampaSuelo, iTrampaTipo);

          iTrampasSuelo++;
      }

      oObjeto = GetNextObjectInArea();
  }
}
