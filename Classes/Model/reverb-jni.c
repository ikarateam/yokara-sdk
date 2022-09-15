
#include "sox.h"
#include "reverb.h"

const sox_effect_handler_t* handlerReverb = NULL;

void  Java_co_ikara_codec_Freeverb_nativeInit
() {
	
	handlerReverb = lsx_reverb_effect_fn();
}

void Java_co_ikara_codec_Freeverb_nativeUpdateEffect
(long handler, const char *nativeReverb) {
	sox_effect_t *  effpReverb = (sox_effect_t *)handler;
	reverb_priv_t * p = (reverb_priv_t *)effpReverb->priv;
	char * argv[] = { "reverb", nativeReverb };
	handlerReverb->getopts(effpReverb, 2, argv);
	handlerReverb->start(effpReverb);
}

long Java_co_ikara_codec_Freeverb_nativeStart
(const char *nativeReverb) {
	sox_effect_t *  effpReverb = NULL;

	effpReverb = sox_create_effect(sox_find_effect("reverb"));
	int maxInt = (((unsigned)-1) >> (33 - (32)));

	effpReverb->obuf = lsx_realloc(effpReverb->obuf, sox_globals.bufsiz * sizeof(*effpReverb->obuf));
	reverb_priv_t * p = (reverb_priv_t *)effpReverb->priv;
	effpReverb->in_signal.channels = 2;
	effpReverb->in_signal.precision = 16;
	effpReverb->in_signal.rate = 44100;
	
	effpReverb->out_signal.channels = 2;
	effpReverb->out_signal.precision = 16;
	effpReverb->out_signal.rate = 44100;
	effpReverb->flows = 1;
	effpReverb->clips = 0;
	effpReverb->imin = 0;

	char * argv[] = { "reverb", nativeReverb };
	handlerReverb->getopts(effpReverb, 2, argv);
	handlerReverb->start(effpReverb);

	return (long)effpReverb;
}

 void Java_co_ikara_codec_Freeverb_nativeProcess
(long handler, int pcmData[], int processedData[],long length) {

	sox_effect_t *  effpReverb = (sox_effect_t *)handler;

    size_t intputSize =length;
    int* inputArray = pcmData;
    
    size_t outputSize = length;
    int* outputArray =processedData;
	handlerReverb->flow(effpReverb, inputArray, outputArray, (size_t*)&intputSize,(size_t*) &outputSize);
	
}

void Java_co_ikara_codec_Freeverb_nativeStop
(long handler) {
	sox_effect_t *  effpReverb = (sox_effect_t *)handler;
	handlerReverb->stop(effpReverb);
}


