#include "sapo_inc_variab"

void CargarVariablesComunes(object oUbicado) {

    DanoHerramientaPorUso(oUbicado,"1");

    BonoAtributo(oUbicado, 1, ABILITY_DEXTERITY);
    //BonoAtributo(oUbicado, 2, ABILITY_DEXTERITY);
    BonoAtributo(oUbicado, 2, ABILITY_CONSTITUTION);

    AnimacionExito(oUbicado,1,72);
    AnimacionFracaso(oUbicado,1,123);
    AnimacionPJ(oUbicado,1,ANIMATION_LOOPING_GET_MID);
    EjecutaTodosLosSonidosProcesado(oUbicado,TRUE);
    SonidoProcesado(oUbicado,1,"as_cv_ropecreak2");
    SonidoProcesado(oUbicado,2,"cb_bu_materlrg");
    SonidoProcesado(oUbicado,3,"as_cv_ropecreak2");
    SonidoProcesado(oUbicado,4,"as_cv_ropepully1");
    SonidoProcesado(oUbicado,5,"cb_bu_matersml");

    Herramienta(oUbicado, 1, "sapo_herr_aguja");

    BonoRacial(oUbicado, 1, RACIAL_TYPE_DWARF, "d4");
    BonoRacial(oUbicado, 2, RACIAL_TYPE_HUMAN, "d6");
    BonoRacial(oUbicado, 3, RACIAL_TYPE_GNOME, "d4");
    BonoRacial(oUbicado, 4, RACIAL_TYPE_HALFLING, "d3");


    LesionesPorcentaje(oUbicado,2);

    LesionEfectoEspecial(oUbicado, 1,1,EFFECTO_ESPECIAL_MATERIAL_DESTRUIDO);
    LesionMensaje(oUbicado,1,"*¡Los cueros estaba podridos! Han quedado inservibles.*");

    LesionHabilidad(oUbicado, 2, 1, ABILITY_CONSTITUTION, 2);
    LesionDano(oUbicado, 2, 1, DAMAGE_TYPE_PIERCING, 6);
    LesionMensaje(oUbicado,2,"*¡Te has pinchado!*");

}

