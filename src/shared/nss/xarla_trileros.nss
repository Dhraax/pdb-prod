void main()
{
object oTrilero = GetObjectByTag("Medianotrilero");
object oHombre1 = GetObjectByTag("Hombrecurioso_1");
object oHombre2 = GetObjectByTag("Hombrecurioso_2");
object oHombre3 = GetObjectByTag("Hombrecurioso_3");
DelayCommand(1.0, AssignCommand(oHombre1, SetFacingPoint(GetPosition(oTrilero))));
DelayCommand(1.0, AssignCommand(oHombre2, SetFacingPoint(GetPosition(oTrilero))));
DelayCommand(1.0, AssignCommand(oHombre3, SetFacingPoint(GetPosition(oTrilero))));
DelayCommand(2.0, AssignCommand(oHombre1, PlayAnimation(ANIMATION_LOOPING_TALK_FORCEFUL)));
DelayCommand(2.0, AssignCommand(oHombre1, SpeakString("¡¡¡Otra vez he ganado!!!")));
DelayCommand(4.0, AssignCommand(oHombre2, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING)));
DelayCommand(4.0, AssignCommand(oHombre2, SpeakString("¡¡¡Este juego parece un buen negocio!!!")));
DelayCommand(6.0, AssignCommand(oHombre3, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2)));
DelayCommand(6.0, AssignCommand(oHombre3, SpeakString("¡¡¡Aposté y gané!!!")));
DelayCommand(8.0, AssignCommand(oTrilero, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2)));
DelayCommand(8.0, AssignCommand(oTrilero, SpeakString("¡¡¡Hagan sus apuestas, hagan sus apuestas!!!")));
}
