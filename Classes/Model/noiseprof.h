#pragma once

#include "sox.h"
#include <stdio.h>

typedef struct {
	float *sum;
	int   *profilecount;

	float *window;
} noiseprof_chandata_t;

typedef struct {
	char* output_filename;
	FILE* output_file;

	noiseprof_chandata_t *chandata;
	size_t bufdata;

} noiseprof_priv_t;

const sox_effect_handler_t *lsx_noiseprof_effect_fn(void);