void main()
{
object oBorracho_1 = GetObjectByTag("hombre_botella_esmel_1");
object oBorracho_2 = GetObjectByTag("hombre_botella_esmel_2");
PlaySound("as_cv_gongring2");
AssignCommand(oBorracho_1, SpeakString("Tócalo otra vez *hip* Tócalo otra vez *hip*"));
AssignCommand(oBorracho_2, SpeakString("Gonggggggg, gonggggg ¡¡¡jajjajjaja!!!"));
}
