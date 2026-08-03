// Script: mago_rojo_bark
// Evento: OnConversation
// Descripción: El NPC dice una frase aleatoria al ser clicado y no abre diálogo.

void main()
{
    // Obtenemos quién intentó hablar con el NPC
    object oPC = GetLastSpeaker();

    // (Opcional) Si quieres que solo reaccionen a Jugadores, descomenta esto:
    // if (!GetIsPC(oPC)) return;

    // Hacemos que el NPC se gire hacia el jugador
    SetFacingPoint(GetPosition(oPC));

    // Definimos la cantidad de frases disponibles (cámbialo si añades más)
    int nFrases = 8;

    // Variable para guardar la frase elegida
    string sFrase = "";

    // Elegimos un número al azar entre 1 y el total de frases
    int nRandom = Random(nFrases) + 1;

    // Asignamos el texto según el número que haya salido
    switch (nRandom)
    {
        case 1: sFrase = "No estorbes, extranjero. Mis pensamientos valen más que tu vida."; break;
        case 2: sFrase = "¿Acaso parezco un mercader? Habla con los aprendices si buscas atención."; break;
        case 3: sFrase = "No fijes tu vista en mis tatuajes, necio."; break;
        case 4: sFrase = "En Thay, alguien de tu estatus estaría limpiando jaulas."; break;
        case 5: sFrase = "Mi tiempo es arcano y precioso. El tuyo... es irrelevante."; break;
        case 6: sFrase = "Apártate. La Urdimbre fluye a través de mí."; break;
        case 7: sFrase = "Una palabra mía y tu piel se separará de tu carne."; break;
        case 8: sFrase = "¿Crees que tu acero te protege? Qué ingenuo."; break;
    }

    // El NPC dice la frase (Talk Volume Talk = texto blanco normal)
    SpeakString(sFrase, TALKVOLUME_TALK);

    // Reproducir una animación simple (opcional)
    // El NPC hará un gesto de 'hablar' o 'desdén'
    ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT);
}
