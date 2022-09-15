#include "sox.h"
#include "noiseprof.h"

const sox_effect_handler_t* handlerEffect = NULL;

void Java_co_ikara_codec_NoiseProf_nativeInit
() {
	
	handlerEffect = lsx_noiseprof_effect_fn();
	
}


long Java_co_ikara_codec_NoiseProf_nativeStart
( const char *nativeProfilePath ) {
	sox_effect_t *  effp = NULL;
	effp = sox_create_effect(sox_find_effect("noiseprof"));
	effp->fftdata = init_fft_cache();
	effp->obuf = lsx_realloc(effp->obuf, sox_globals.bufsiz * sizeof(*effp->obuf));
	noiseprof_priv_t * p = (noiseprof_priv_t *)effp->priv;
	effp->in_signal.channels = 2;
	effp->in_signal.precision = 16;
	effp->in_signal.rate = 44100;
	
	effp->out_signal.channels = 2;
	effp->out_signal.precision = 16;
	effp->out_signal.rate = 44100;
	effp->flows = 1;
	effp->clips = 0;
	effp->imin = 0;

	char * argv[] = { "noiseprof", nativeProfilePath };
	handlerEffect->getopts(effp, 2, argv);

	handlerEffect->start(effp);

	return (long)effp;
}

void Java_co_ikara_codec_NoiseProf_nativeProcess
(long handler, int* pcmData, int* processedData,long length) {

	sox_effect_t *  effp = (sox_effect_t *)handler;

    int intputSize =length;
    int* inputArray = &(pcmData[0]);
    
    int outputSize = length;
    int* outputArray =&(processedData[0]);
	handlerEffect->flow(effp, inputArray, outputArray, intputSize, outputSize);
}

void Java_co_ikara_codec_NoiseProf_nativeStop
(long handler) {
	sox_effect_t *  effp = (sox_effect_t *)handler;
	int outputSize = 0;
	handlerEffect->drain(effp, NULL, outputSize);
	handlerEffect->stop(effp);
	clear_fft_cache(effp->fftdata);
}
