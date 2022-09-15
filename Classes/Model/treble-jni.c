
#include "biquads.h"
#include "biquad.h"

const sox_effect_handler_t* handlerTreble = NULL;
void  Java_co_ikara_codec_Treble_nativeInit
() {
	
	handlerTreble = lsx_treble_effect_fn();
}

void  Java_co_ikara_codec_Treble_nativeUpdateEffect
(long handler,const char *nativeTreble) {
	sox_effect_t *  effpTreble = (sox_effect_t *)handler;
	char * argv[] = { "treble",nativeTreble };
	handlerTreble->getopts(effpTreble, 2, argv);
	handlerTreble->start(effpTreble);

}


long Java_co_ikara_codec_Treble_nativeStart
( const char *nativeTreble) {
	sox_effect_t *  effpTreble = NULL;
	effpTreble = sox_create_effect(sox_find_effect("treble"));
	effpTreble->obuf = lsx_realloc(effpTreble->obuf, sox_globals.bufsiz * sizeof(*effpTreble->obuf));
	char * argv[] = { "treble",nativeTreble };
	handlerTreble->getopts(effpTreble, 2, argv);

	effpTreble->in_signal.channels = 2;
	effpTreble->in_signal.precision = 16;
	effpTreble->in_signal.rate = 44100;
	
	effpTreble->out_signal.channels = 2;
	effpTreble->out_signal.precision = 16;
	effpTreble->out_signal.rate = 44100;
	effpTreble->flows = 1;
	effpTreble->clips = 0;
	effpTreble->imin = 0;

	handlerTreble->start(effpTreble);
	return (long)effpTreble;
}

void Java_co_ikara_codec_Treble_nativeProcess
(long handler, int pcmData[], int processedData[],long length) {
	sox_effect_t *  effpTreble =  (sox_effect_t *) handler;
    size_t intputSize =length;
    int* inputArray = pcmData;
    
    size_t outputSize = length;
    int* outputArray =processedData;
	handlerTreble->flow(effpTreble, inputArray, outputArray, &intputSize,&outputSize);
}

void Java_co_ikara_codec_Treble_nativeStop
(long handler) {
	if (handlerTreble->stop != NULL) {
		sox_effect_t *  effpTreble = (sox_effect_t *)handler;
		handlerTreble->stop(effpTreble);
	}
}


