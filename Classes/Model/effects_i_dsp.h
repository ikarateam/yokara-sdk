#pragma once
typedef struct fft_data fft_data;

typedef struct fft_data {
	int * lsx_fft_br;
	double * lsx_fft_sc;
	int fft_len;
#if defined HAVE_OPENMP
	static ccrw2_t fft_cache_ccrw;
#endif
} fft_data;


fft_data* init_fft_cache(void);
void clear_fft_cache(fft_data* fftdata);
void lsx_safe_rdft(fft_data* fftdata,int len, int type, double * d);
void lsx_safe_cdft(fft_data* fftdata, int len, int type, double * d);
void lsx_power_spectrum(fft_data* fftdata, int n, double const * in, double * out);
void lsx_power_spectrum_f(fft_data* fftdata, int n, float const * in, float * out);
void lsx_apply_hann_f(float h[], const int num_points);
void lsx_apply_hann(double h[], const int num_points);