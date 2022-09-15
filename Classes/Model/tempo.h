#pragma once

#include "sox.h"
#include "util.h"
#include <stdio.h>
#include "fifo.h"

typedef struct {
	/* Configuration parameters: */
	size_t channels;
	sox_bool quick_search; /* Whether to quick search or linear search */
	double factor;         /* 1 for no change, < 1 for slower, > 1 for faster. */
	size_t search;         /* Wide samples to search for best overlap position */
	size_t segment;        /* Processing segment length in wide samples */
	size_t overlap;        /* In wide samples */

	size_t process_size;   /* # input wide samples needed to process 1 segment */

						   /* Buffers: */
	fifo_t input_fifo;
	float * overlap_buf;
	fifo_t output_fifo;

	/* Counters: */
	uint64_t samples_in;
	uint64_t samples_out;
	uint64_t segments_total;
	uint64_t skip_total;
} tempo_t;

typedef struct {
	tempo_t     * tempo;
	sox_bool    quick_search;
	double      factor, segment_ms, search_ms, overlap_ms;
} tempo_priv_t;

sox_effect_handler_t const * lsx_pitch_effect_fn(void);