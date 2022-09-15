void sox_format_quit(void) /* Cleanup things.  */
{
#ifdef HAVE_LIBLTDL
	int ret;
	if (plugins_initted && (ret = lt_dlexit()) != 0)
		lsx_fail("lt_dlexit failed with %d error(s): %s", ret, lt_dlerror());
	plugins_initted = sox_false;
	nformats = NSTATIC_FORMATS;
#endif
}