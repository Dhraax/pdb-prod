void main()
{
object oMarinero_1 = GetNearestObjectByTag("marinero_minsor_1");
object oMarinero_2 = GetNearestObjectByTag("marinero_minsor_2");
DelayCommand(1.0,AssignCommand(oMarinero_1, SpeakString("Espero que Selûne nos guíe al pescado… Siempre lo hace ¡¡¡jajajjaa!!!")));
DelayCommand(3.0,AssignCommand(oMarinero_2, SpeakString("Estas redes simpre se me enredan... ¡¡¡Tendré que volver a coserlas!!!")));
}
