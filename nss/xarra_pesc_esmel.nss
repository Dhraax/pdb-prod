void main()
{
object oPescadero = GetObjectByTag("pescadero_esmel");
DelayCommand(1.0, AssignCommand(oPescadero, SpeakString("¡Pescado, PESCADOOOO FRESCOOO OYEEE!")));
DelayCommand(4.0, AssignCommand(oPescadero, PlayAnimation(ANIMATION_LOOPING_TALK_LAUGHING)));
DelayCommand(4.0, AssignCommand(oPescadero, SpeakString("¡El mejor PESCADOOOO a la parrilla, EL MEJOOOR!")));
DelayCommand(7.0, AssignCommand(oPescadero, PlayAnimation(ANIMATION_FIREFORGET_VICTORY2)));
DelayCommand(7.0, AssignCommand(oPescadero, SpeakString("¡¡No encontrarás mejor manjar, oye, a solo 40po!!")));
}
