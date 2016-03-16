#include <CoreFoundation/CoreFoundation.h>
#include <pcre.h>

#define OVECSIZE 30

static const char *const kPattern = "^(\\d{1,2}):(\\d{1,2})$";
static const char *const kStrings[] = {
	"12:30",
	"4:20",
	"111:12345",
	NULL
};

static pcre *re = NULL;
static const char *hour = NULL, *minute = NULL;

CF_FORMAT_FUNCTION(1, 2)
static void CFShowf(CFStringRef format, ...) {
	if (format == NULL) {
		return;
	}

	va_list arguments;
	va_start(arguments, format);

	CFStringRef output = CFStringCreateWithFormatAndArguments(
			kCFAllocatorDefault, NULL, format, arguments);
	CFShow(output);
	CFRelease(output);
	output = NULL;

	va_end(arguments);
}

static inline void cleanup_captures(void) {
	if (hour != NULL) {
		pcre_free_substring(hour);
		hour = NULL;
	}
	if (minute != NULL) {
		pcre_free_substring(minute);
		minute = NULL;
	}
}

static inline void cleanup(void) {
	cleanup_captures();

	if (re != NULL) {
		pcre_free(re);
		re = NULL;
	}
}

int main(void) {
	int erroffset;
	const char *errptr;
	re = pcre_compile(kPattern, 0, &errptr, &erroffset, NULL);
	if (re == NULL) {
		goto error;
	}

	const char *str;
	int rc, ovector[OVECSIZE];
	for (const char *const *ptr = kStrings; *ptr != NULL; ++ptr) {
		str = *ptr;

		rc = pcre_exec(re, NULL, str, strlen(str), 0, 0, ovector, OVECSIZE);
		if (rc == PCRE_ERROR_NOMATCH) {
			CFShowf(CFSTR("No matches in '%s'!"), str);
			continue;
		} else if (rc < 0) {
			goto error;
		} else if (rc < 3) {
			CFShowf(CFSTR("Insufficient matches in '%s'!"), str);
			continue;
		}

		pcre_get_substring(str, ovector, rc, 1, &hour);
		if (hour == NULL) {
			goto error;
		}
		pcre_get_substring(str, ovector, rc, 2, &minute);
		if (minute == NULL) {
			goto error;
		}

		CFShowf(CFSTR("Matches in '%s': hour is %s, minute is %s!"),
				str, hour, minute);
		cleanup_captures();
	}

	cleanup();
	return EXIT_SUCCESS;

error:
	cleanup();
	exit(EXIT_FAILURE);
}
