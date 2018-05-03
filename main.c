#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <libpq-fe.h>

int main(int argc, char *argv[])
{
	if (argc < 2) {
		fprintf(stderr, "Usage: %s <string>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	size_t len = strlen(argv[1]);

	// This formula for calculating the buffer size (len * 2 + 1) is part
	// of PQescapeString's contract.
	char *buf = calloc(len * 2 + 1, sizeof(char));
	// PQescapeString has no error contract whatsoever, its return value is
	// of no use to us.
	PQescapeString(buf, argv[1], len);

	puts(buf);

	free(buf);

	return 0;
}
