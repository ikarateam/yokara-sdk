#ifndef reverb_included
#define reverb_included
#include "sox.h"
#include "util.h"
#include "fifo.h"

static const size_t /* Filter delay lengths in samples (44100Hz sample-rate) */
comb_lengths[] = { 1116, 1188, 1277, 1356, 1422, 1491, 1557, 1617 },
allpass_lengths[] = { 225, 341, 441, 556 };
#define stereo_adjust 12


typedef struct {
	size_t  size;
	float   * buffer;
	float *ptr;
	float   store;
} reverb_filter_t;

typedef struct {
	reverb_filter_t comb[array_length(comb_lengths)];
	reverb_filter_t allpass[array_length(allpass_lengths)];
} reverb_filter_array_t;

typedef struct {
	float feedback;
	float hf_damping;
	float gain;
	fifo_t input_fifo;
	reverb_filter_array_t chan[2];
	float * out[2];
} reverb_t;
typedef struct {
	double reverberance, hf_damping, pre_delay_ms;
	double stereo_depth, wet_gain_dB, room_scale;
	sox_bool wet_only;

	size_t ichannels, ochannels;
	struct {
		reverb_t reverb;
		float * dry, *wet[2];
	} chan[2];
} reverb_priv_t;

sox_effect_handler_t const *lsx_reverb_effect_fn(void);

#endif