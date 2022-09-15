#include "sox.h"
#include "tempo.h"

const sox_effect_handler_t* handlerPitch = NULL;

 void  Java_co_ikara_codec_Pitch_nativeInit
() {
	handlerPitch = lsx_pitch_effect_fn();
}


long Java_co_ikara_codec_Pitch_nativeStart
( const char *nativeCents) {
	sox_effect_t *  effp = NULL;
	effp = sox_create_effect(sox_find_effect("pitch"));
	effp->obuf = lsx_realloc(effp->obuf, sox_globals.bufsiz * sizeof(*effp->obuf));
	//tempo_priv_t * p = (tempo_priv_t *)effp->priv;
	effp->in_signal.channels = 2;
	effp->in_signal.precision = 16;
	effp->in_signal.rate = 44100;
	
	effp->out_signal.channels = 2;
	effp->out_signal.precision = 16;
	effp->out_signal.rate = 44100;
	effp->out_signal.length = SOX_UNKNOWN_LEN;
	effp->flows = 1;
	effp->clips = 0;
	effp->imin = 0;

	char * argv[] = { "pitch", nativeCents};
	handlerPitch->getopts(effp, 2, argv);

	handlerPitch->start(effp);
	return (long)effp;
}

void Java_co_ikara_codec_Pitch_nativeProcess
(long handler, int* pcmData, int* processedData, long length) {

	sox_effect_t *  effp = (sox_effect_t *)handler;

    int inputSize = length;
    int* inputArray = pcmData;
   // int finalInputSize = inputSize;
    int outputSize = length;
   // int finalOutputSize = outputSize;
    int* outputArray = processedData;
    //int* originalInputArray = inputArray;
    //int* originalOutputArray = outputArray;
	handlerPitch->flow(effp, inputArray, outputArray,inputSize,outputSize);

}

void Java_co_ikara_codec_Pitch_nativeStop
(long handler) {
	sox_effect_t *  effp = (sox_effect_t *)handler;
	int outputSize = 0;
	handlerPitch->stop(effp);
}


