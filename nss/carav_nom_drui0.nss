#include "mti_libreria"

void main()
{
object oPC = GetEnteringObject();
int esjugador = GetIsPC(oPC);
if ( esjugador == TRUE)
   {
   object areactual = GetArea(oPC);
   string nombrearea = GetName(areactual,FALSE);


   string criatura1 = "NW_WOLF";
   string criatura2 = "NW_BOAR";
   string criatura3 = "NW_COUGAR";
   string criatura4 = "NW_BEARBLCK";
   string criatura5 = "NW_DIREWOLF";
   string criatura6 = "NW_BEARDIRE";

   string druida = "pb_carintdruida"; //druida_corrupto_caravassar_nohos       //pnj_carintDruidaAsolador

   int otravariable = ObtenerIntPersistente(oPC, "ALCALDECARAVASAR");

   if(otravariable != 7 || otravariable == OBJECT_TYPE_INVALID || (GetItemPossessedBy(oPC, "CabezadeldruidasombriodeWeldath") != OBJECT_INVALID))
      {
      if(nombrearea == "Carretera de Tezhyr - Oeste de Caravasar")
         {
         object punto1 = GetWaypointByTag("Quest_caravasar_druidas_Punto1");

         location lTarget1 = GetLocation(punto1);
         FloatingTextStringOnCreature("¡¡¡Ves como de repente aparece un grupo de animales de todo tipo lanzandose enloquecidamente sobre ti!!!",oPC,FALSE);

         object sorpresa1 = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget1 ,FALSE);
         object sorpresa2 = CreateObject(OBJECT_TYPE_CREATURE, criatura2, lTarget1 ,FALSE);
         object sorpresa3 = CreateObject(OBJECT_TYPE_CREATURE, criatura3, lTarget1 ,FALSE);
         object sorpresa4 = CreateObject(OBJECT_TYPE_CREATURE, criatura4, lTarget1 ,FALSE);
         object sorpresa5 = CreateObject(OBJECT_TYPE_CREATURE, criatura5, lTarget1 ,FALSE);
         }
      else if(nombrearea == "Camino del Comercio - Norte de Caravasar")
         {
         object punto1 = GetWaypointByTag("Quest_caravasar_druidas_Punto2");

         location lTarget1 = GetLocation(punto1);
         FloatingTextStringOnCreature("¡¡¡Ves como de repente aparece un grupo de animales de todo tipo lanzandose enloquecidamente sobre ti!!!",oPC,FALSE);

         object sorpresa1 = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget1 ,FALSE);
         object sorpresa2 = CreateObject(OBJECT_TYPE_CREATURE, criatura2, lTarget1 ,FALSE);
         object sorpresa3 = CreateObject(OBJECT_TYPE_CREATURE, criatura3, lTarget1 ,FALSE);
         object sorpresa4 = CreateObject(OBJECT_TYPE_CREATURE, criatura4, lTarget1 ,FALSE);
         object sorpresa5 = CreateObject(OBJECT_TYPE_CREATURE, criatura5, lTarget1 ,FALSE);
         }
      else if(nombrearea == "Carretera de Tezhyr - Este de Caravasar")
         {
         object punto1 = GetWaypointByTag("questcaravasardruidaspunto5");

         location lTarget1 = GetLocation(punto1);
         FloatingTextStringOnCreature("¡¡¡Ves como de repente aparece un grupo de animales de todo tipo lanzandose enloquecidamente sobre ti!!!",oPC,FALSE);

         object sorpresa1 = CreateObject(OBJECT_TYPE_CREATURE, criatura1, lTarget1 ,FALSE);
         object sorpresa2 = CreateObject(OBJECT_TYPE_CREATURE, criatura2, lTarget1 ,FALSE);
         object sorpresa3 = CreateObject(OBJECT_TYPE_CREATURE, criatura3, lTarget1 ,FALSE);
         object sorpresa4 = CreateObject(OBJECT_TYPE_CREATURE, criatura4, lTarget1 ,FALSE);
         object sorpresa5 = CreateObject(OBJECT_TYPE_CREATURE, criatura5, lTarget1 ,FALSE);
         }
      else if(nombrearea == "Bosque de Weldazh - Linde del bosque")
         {
         object punto1 = GetWaypointByTag("questcaravasardruidaspunto4");

         location lTarget1 = GetLocation(punto1);
         FloatingTextStringOnCreature("¡¡¡Ves como de repente aparecen varios osos terribles lanzandose enloquecidamente sobre ti!!!",oPC,FALSE);

         object sorpresa1 = CreateObject(OBJECT_TYPE_CREATURE, criatura6, lTarget1 ,FALSE);
         object sorpresa2 = CreateObject(OBJECT_TYPE_CREATURE, criatura6, lTarget1 ,FALSE);
         object sorpresa3 = CreateObject(OBJECT_TYPE_CREATURE, criatura6, lTarget1 ,FALSE);
         object sorpresa4 = CreateObject(OBJECT_TYPE_CREATURE, criatura6, lTarget1 ,FALSE);
         }

      else if(nombrearea == "Bosque de Weldazh - Cueva del Círculo")
         {
         if(otravariable == 6)
            {
            object punto1 = GetWaypointByTag("Quest_caravasar_archidruida1");
            location lTarget1 = GetLocation(punto1);
            object oAsolador = CreateObject(OBJECT_TYPE_CREATURE, druida, lTarget1 ,FALSE);
            AssignCommand(oAsolador,ActionJumpToLocation(lTarget1));
            }
         }

      }
   }
}
