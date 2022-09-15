//
//  effects_i.h
//  AudioTapProcessor
//
//  Created by Rain Nguyen on 9/14/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

#ifndef effects_i_h
#define effects_i_h
#include "sox.h"
#include <stdio.h>
#include "effects_i_dsp.h"
int lsx_effects_quit();

int lsx_effects_init();

FILE * lsx_open_input_file(sox_effect_t * effp, char const * filename, sox_bool text_mode);

double lsx_parse_frequency_k(char const * text, char * * end_ptr, int key);

int lsx_parse_note(char const * text, char * * end_ptr);

static double calc_note_freq(double note, int key);

char const * lsx_parseposition(sox_rate_t rate, const char *str0, uint64_t *samples, uint64_t latest, uint64_t end, int def);

static char const * parsesamples(sox_rate_t rate, const char *str0, uint64_t *samples, int def, int combine);

char const * lsx_parsesamples(sox_rate_t rate, const char *str0, uint64_t *samples, int def);

int lsx_usage(sox_effect_t * effp);
#endif /* effects_i_h */
