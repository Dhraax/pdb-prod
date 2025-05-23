void main()
{
  object oMinero_1 = GetNearestObjectByTag("Minero_nask_2");
  object oMinero_2 = GetNearestObjectByTag("Minero_nask_3");
  AssignCommand(oMinero_1, ActionSpeakString("Han muerto muchos compañeros en las minas… ¡¡¡No sabemos lo que pasa!!!"));
  AssignCommand(oMinero_2, ActionSpeakString("¡¡¡Yo no vuelvo a entrar en las minas, he escuchado ruidos muy extraños!!!"));
}
