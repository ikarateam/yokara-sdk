/* libSoX Biquad filter common definitions (c) 2006-7 robs@users.sourceforge.net
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or (at
 * your option) any later version.
 *
 * This library is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser
 * General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */


#ifndef biquads_included
#define biquads_included
#include "biquad.h"
typedef biquad_t priv_t;

extern int hilo1_getopts(sox_effect_t * effp, int argc, char **argv);
extern int hilo2_getopts(sox_effect_t * effp, int argc, char **argv);
extern int bandpass_getopts(sox_effect_t * effp, int argc, char **argv);
extern int bandrej_getopts(sox_effect_t * effp, int argc, char **argv);
extern int allpass_getopts(sox_effect_t * effp, int argc, char **argv);
extern int tone_getopts(sox_effect_t * effp, int argc, char **argv);
extern int equalizer_getopts(sox_effect_t * effp, int argc, char **argv);
extern int band_getopts(sox_effect_t * effp, int argc, char **argv);
extern int deemph_getopts(sox_effect_t * effp, int argc, char **argv);
extern int riaa_getopts(sox_effect_t * effp, int argc, char **argv);
extern int start(sox_effect_t * effp);

sox_effect_handler_t const * lsx_bass_effect_fn(void);
sox_effect_handler_t const * lsx_treble_effect_fn(void);


#endif
