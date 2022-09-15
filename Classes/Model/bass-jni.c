#include "biquads.h"
#include "biquad.h"

const sox_effect_handler_t* handlerBass = NULL;

void Java_co_ikara_codec_Bass_nativeInit() {
	handlerBass = lsx_bass_effect_fn();
}

void Java_co_ikara_codec_Bass_nativeUpdateEffect
(long handler, const char * nativeBass) {
	sox_effect_t *  effpBass = (sox_effect_t *)handler;
	char * argv[] = { "bass",nativeBass };
	handlerBass->getopts(effpBass, 2, argv);
	handlerBass->start(effpBass);
}

long  Java_co_ikara_codec_Bass_nativeStart
(  const char *nativeBass) {
	sox_effect_t *  effpBass = NULL;
	effpBass = sox_create_effect(sox_find_effect("bass"));
	effpBass->obuf = lsx_realloc(effpBass->obuf, sox_globals.bufsiz * sizeof(*effpBass->obuf));
	char * argv[] = { "bass",nativeBass };
	handlerBass->getopts(effpBass, 2, argv);
	effpBass->in_signal.channels = 2;
	effpBass->in_signal.precision = 16;
	effpBass->in_signal.rate = 44100;
	
	effpBass->out_signal.channels = 2;
	effpBass->out_signal.precision = 16;
	effpBass->out_signal.rate = 44100;
	effpBass->flows = 1;
	effpBass->clips = 0;
	effpBass->imin = 0;

	handlerBass->start(effpBass);
	return (long)effpBass;
}

void Java_co_ikara_codec_Bass_nativeProcess
(long handler, int pcmData[], int processedData[] ,long length) {
	sox_effect_t *  effpBass = (sox_effect_t *)handler;
	size_t intputSize =length;
	int* inputArray = pcmData;

	size_t outputSize = length;
	int* outputArray =processedData;
	handlerBass->flow(effpBass, inputArray, outputArray,(size_t*) &intputSize, (size_t*)&outputSize);
	
}

void Java_co_ikara_codec_Bass_nativeStop
(  long handler) {
	if (handlerBass->stop != NULL) {
		sox_effect_t *  effpBass = (sox_effect_t *)handler;
		handlerBass->stop(effpBass);
	}
}


