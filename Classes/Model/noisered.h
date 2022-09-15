/* noiseprof.h - Headers for SoX Noise Profiling Effect.
 *
 * Written by Ian Turner (vectro@vectro.org)
 * Copyright 1999 Ian Turner and others
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

#include "sox.h"

#include "util.h"
#include "xmalloc.h"
#include <math.h>

#define WINDOWSIZE 2048
#define HALFWINDOW (WINDOWSIZE / 2)
#define FREQCOUNT  (HALFWINDOW + 1)



typedef struct {
	float *window;
	float *lastwindow;
	float *noisegate;
	float *smoothing;
} noisered_chandata_t;

/* Holds profile information */
typedef struct {
	char* profile_filename;
	float threshold;

	noisered_chandata_t *chandata;
	size_t bufdata;
} noisered_priv_t;

const sox_effect_handler_t *lsx_noisered_effect_fn(void);
