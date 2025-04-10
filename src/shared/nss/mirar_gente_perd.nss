void main()
{
//Grupo 1
object oPerdicion_1 = GetObjectByTag("SacerdotedelaPerdicin");
object oPerdicion_2 = GetObjectByTag("Fiel_perdicion_1");
object oPerdicion_3 = GetObjectByTag("Fiel_perdicion_2");
object oPerdicion_4 = GetObjectByTag("Fiel_perdicion_3");
object oPerdicion_5 = GetObjectByTag("Fiel_perdicion_4");
object oPerdicion_6 = GetObjectByTag("Fiel_perdicion_5");
//Grupo 2
object oPerdicion_7 = GetObjectByTag("Practic_perdi_1");
object oPerdicion_8 = GetObjectByTag("Practic_perdi_2");
object oPerdicion_9 = GetObjectByTag("Practic_perdi_3");
object oPerdicion_10 = GetObjectByTag("Practic_perdi_4");
//Florista
object oFlorista = GetObjectByTag("florista_esmelt");
object oTag_Flor = GetWaypointByTag("mirar_florista");
//Mirar al objectivo Grupo 1
AssignCommand(oPerdicion_1, SetFacingPoint(GetPosition(oPerdicion_3)));
AssignCommand(oPerdicion_2, SetFacingPoint(GetPosition(oPerdicion_1)));
AssignCommand(oPerdicion_3, SetFacingPoint(GetPosition(oPerdicion_1)));
AssignCommand(oPerdicion_4, SetFacingPoint(GetPosition(oPerdicion_1)));
AssignCommand(oPerdicion_5, SetFacingPoint(GetPosition(oPerdicion_1)));
AssignCommand(oPerdicion_6, SetFacingPoint(GetPosition(oPerdicion_1)));
//Mirar al objetivo Grupo 2
AssignCommand(oPerdicion_7, SetFacingPoint(GetPosition(oPerdicion_7)));
AssignCommand(oPerdicion_8, SetFacingPoint(GetPosition(oPerdicion_7)));
AssignCommand(oPerdicion_9, SetFacingPoint(GetPosition(oPerdicion_7)));
AssignCommand(oPerdicion_10, SetFacingPoint(GetPosition(oPerdicion_7)));
//Mirar Florista
AssignCommand(oFlorista, SetFacingPoint(GetPosition(oTag_Flor)));
}
