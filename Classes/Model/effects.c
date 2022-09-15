#include "sox.h"
#include "xmalloc.h"
#include "util.h"
#include <assert.h>
#include "reverb.h"
#include "biquads.h"
#include "fft4g.h"
#include "noiseprof.h"
#include "noisered.h"
#include "tempo.h"
#include "effects_i.h"


typedef int omp_lock_t;
#define omp_init_lock(omp_lock_t) (void)0
#define ccrw2_become_reader(x) (void)0
#define ccrw2_cease_reading(x) (void)0
#define ccrw2_become_writer(x) (void)0
#define ccrw2_cease_writing(x) (void)0
#define ccrw2_init(x) (void)0
#define ccrw2_clear(x) (void)0

#define ccrw2_init(x) (void)0
#define ccrw2_init(p) do {\
  omp_init_lock(&p.mutex_1);\
  omp_init_lock(&p.mutex_2);\
  omp_init_lock(&p.mutex_3);\
  omp_init_lock(&p.w);\
  omp_init_lock(&p.r);\
} while (0)
#define ccrw2_clear(p) do {\
  omp_destroy_lock(&p.r);\
  omp_destroy_lock(&p.w);\
  omp_destroy_lock(&p.mutex_3);\
  omp_destroy_lock(&p.mutex_2);\
  omp_destroy_lock(&p.mutex_1);\
} while (0)
#define ccrw2_clear(x) (void)0


typedef struct {
	int readcount, writecount; /* initial value = 0 */
	omp_lock_t mutex_1, mutex_2, mutex_3, w, r; /* initial value = 1 */
} ccrw2_t; /* Problem #2: `writers-preference' */



/* Find a named effect in the effects library */
sox_effect_handler_t const * sox_find_effect(char const * name)
{
	int e;
	sox_effect_fn_t const * fns = sox_get_effect_fns();
	for (e = 0; fns[e]; ++e) {
		const sox_effect_handler_t *eh = fns[e]();
		if (eh && eh->name && strcasecmp(eh->name, name) == 0)
			return eh;                 /* Found it. */
	}
	return NULL;
}
static int default_getopts(sox_effect_t * effp, int argc, char **argv UNUSED)
{
	return --argc ? lsx_usage(effp) : SOX_SUCCESS;
}

/* Inform no more samples to drain */
static int default_drain(sox_effect_t * effp UNUSED, sox_sample_t *obuf UNUSED, size_t *osamp)
{
	*osamp = 0;
	return SOX_EOF;
}
static int default_function(sox_effect_t * effp UNUSED)
{
	return SOX_SUCCESS;
}

static double calc_note_freq(double note, int key)
{
	if (key != INT_MAX) {                         /* Just intonation. */
		static const int n[] = { 16, 9, 6, 5, 4, 7 }; /* Numerator. */
		static const int d[] = { 15, 8, 5, 4, 3, 5 }; /* Denominator. */
		static double j[13];                        /* Just semitones */
		int i, m = floor(note);

		if (!j[1]) for (i = 1; i <= 12; ++i)
			j[i] = i <= 6 ? log((double)n[i - 1] / d[i - 1]) / log(2.) : 1 - j[12 - i];
		note -= m;
		m -= key = m - ((INT_MAX / 2 - ((INT_MAX / 2) % 12) + m - key) % 12);
		return 440 * pow(2., key / 12. + j[m] + (j[m + 1] - j[m]) * note);
	}
	return 440 * pow(2., note / 12);
}

/* Pass through samples verbatim */
int lsx_flow_copy(sox_effect_t * effp UNUSED, const sox_sample_t * ibuf,
	sox_sample_t * obuf, size_t * isamp, size_t * osamp)
{
	*isamp = *osamp = min(*isamp, *osamp);
	memcpy(obuf, ibuf, *isamp * sizeof(*obuf));
	return SOX_SUCCESS;
}

sox_effect_t * sox_create_effect(sox_effect_handler_t const * eh)
{
	sox_effect_t * effp = lsx_calloc(1, sizeof(*effp));
	effp->obuf = NULL;

	effp->global_info = sox_get_effects_globals();
	effp->handler = *eh;
	if (!effp->handler.getopts) effp->handler.getopts = default_getopts;
	if (!effp->handler.start) effp->handler.start = default_function;
	if (!effp->handler.flow) effp->handler.flow = lsx_flow_copy;
	if (!effp->handler.drain) effp->handler.drain = default_drain;
	if (!effp->handler.stop) effp->handler.stop = default_function;
	if (!effp->handler.kill) effp->handler.kill = default_function;

	effp->priv = lsx_calloc(1, effp->handler.priv_size);

	return effp;
} /* sox_create_effect */


static sox_effect_fn_t s_sox_effect_fns[] = {
#define EFFECT(f) lsx_##f##_effect_fn,
#include "effects.h"
#undef EFFECT
	NULL
};



const sox_effect_fn_t*
sox_get_effect_fns(void)
{
	return s_sox_effect_fns;
}

