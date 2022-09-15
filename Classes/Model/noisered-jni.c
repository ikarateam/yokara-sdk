#include "sox.h"
#include "noisered.h"

const sox_effect_handler_t* handlerNoisered = NULL;

void Java_co_ikara_codec_Noisered_nativeInit
() {
	handlerNoisered = lsx_noisered_effect_fn();
}


long Java_co_ikara_codec_Noisered_nativeStart
(const char *nativeProfilePath, const char *nativeAmount) {
	
	sox_effect_t *  effp = NULL;
	effp = sox_create_effect(sox_find_effect("noisered"));
	effp->obuf = lsx_realloc(effp->obuf, sox_globals.bufsiz * sizeof(*effp->obuf));
	effp->fftdata = init_fft_cache();
	noisered_priv_t * p = (noisered_priv_t *)effp->priv;
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

	char * argv[] = { "noisered", nativeProfilePath, nativeAmount };
	handlerNoisered->getopts(effp, 3, argv);

	handlerNoisered->start(effp);
	return (long)effp;
}

 void Java_co_ikara_codec_Noisered_nativeProcess
( long handler, int* pcmData, int* processedData,int length) {

	sox_effect_t *  effp = (sox_effect_t *)handler;

	int inputSize = length;
	int* inputArray = &( pcmData[0]);
	int finalInputSize = inputSize;
	int outputSize = length;
	int finalOutputSize = outputSize;
	int* outputArray = &(processedData[ 0]);
	int* originalInputArray = inputArray;
	int* originalOutputArray = outputArray;
	do {
		handlerNoisered->flow(effp, inputArray, outputArray, inputSize, outputSize);
		inputArray += inputSize;
		outputArray += outputSize;
		finalInputSize = finalInputSize - inputSize;
		inputSize = finalInputSize;
		outputSize = finalOutputSize;
	} while (inputSize != 0);

}

void Java_co_ikara_codec_Noisered_nativeStop
(long handler) {
	sox_effect_t *  effp = (sox_effect_t *)handler;
	int outputSize = 0;
	handlerNoisered->stop(effp);
	clear_fft_cache(effp->fftdata);
	
}

 void Java_co_ikara_codec_Noisered_nativeUpdateEffect
(long handler, const char *nativeProfilePath, const char *nativeAmount) {
	sox_effect_t *  effp = (sox_effect_t *)handler;
	char * argv[] = { "noisered", nativeProfilePath, nativeAmount };
	handlerNoisered->getopts(effp, 3, argv);

	handlerNoisered->start(effp);
}


