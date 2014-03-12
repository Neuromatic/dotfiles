/**
 *      ioup.c - upload files to pub.iotek.org
 *
 *  
 *
 *      Copyright (c) 2013, IOTek <deadcat (at) iotek (dot) org>
 *
 *
 *      Permission to use, copy, modify, and/or distribute this software for any
 *      purpose with or without fee is hereby granted, provided that the above
 *      copyright notice and this permission notice appear in all copies.
 *
 *      THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *      WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *      MERCHANTABILITY AND FITNESS IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *      ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *      WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *      ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *      OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *
**/

#include <stdio.h>
#include <string.h>
#include <curl/curl.h>
#include <sys/stat.h>

#define TOKEN	"mxjxA5oWox"

#ifndef TOKEN
#error "missing line in ioup.c"
#endif

typedef struct {
	char *token;
	char *name;
	char *file;
	const char *xt;
} io_t;

const char *get_xt (const char *s) {
	const char *d = strrchr(s, '.');
	return ! d || d == s ? NULL : d + 1;
}

void io_post (io_t io) {
	CURL		*c;
	CURLcode	res;
	FILE *in,*out;
	int chr;

	struct curl_httppost *formpost	= NULL;
	struct curl_httppost *lastptr	= NULL;
	struct curl_slist *headerlist	= NULL;
	struct stat sstat;
	static const char buf[] = "Expect:";

	/* checks go here */
	if (!io.file) {
		fstat(0, &sstat);
		puts(S_ISCHR(sstat.st_mode) ? "^C: exit, ^D: post" : "");
		
		io.file	= "/tmp/ioup.tmp";
		io.name	= "stdin";
		out	= fopen(io.file, "w");
		in	= stdin;

		if (in && out) {
			while (!feof(in)) {
				chr = fgetc(in);
				if (chr != EOF) {
					fputc(chr, out);
				}
			}
		}

		fclose(in);
		fclose(out);
	}

	if (!io.token) io.token = "notok";

	/* checks end */

	curl_global_init(CURL_GLOBAL_ALL);

	curl_formadd(	&formpost,
			&lastptr,
			CURLFORM_COPYNAME, "token",
			CURLFORM_COPYCONTENTS, io.token,
			CURLFORM_END);

	curl_formadd(	&formpost,
			&lastptr,
			CURLFORM_COPYNAME, "is_ioup",
			CURLFORM_COPYCONTENTS, "1",
			CURLFORM_END);

	curl_formadd(	&formpost,
			&lastptr,
			CURLFORM_COPYNAME, "xt",
			CURLFORM_COPYCONTENTS, io.xt,
			CURLFORM_END);

	curl_formadd(	&formpost,
			&lastptr,
			CURLFORM_COPYNAME, "pdata",
			CURLFORM_FILE, io.file,
			CURLFORM_END);

	curl_formadd(	&formpost,
			&lastptr,
			CURLFORM_COPYNAME, "submit",
			CURLFORM_COPYCONTENTS, "sent",
			CURLFORM_END);


	/* more formadd */

	c = curl_easy_init();
	headerlist = curl_slist_append(headerlist, buf);

	if (c) {
		curl_easy_setopt(c, CURLOPT_URL, "http://pub.iotek.org/post.php");
		curl_easy_setopt(c, CURLOPT_HTTPHEADER, headerlist);
		curl_easy_setopt(c, CURLOPT_HTTPPOST, formpost);

		res = curl_easy_perform(c);

		curl_easy_cleanup(c);
		curl_formfree(formpost);
		curl_slist_free_all(headerlist);
	}
}


int main (int argc, char *argv[]) {
	
	io_t io;
	io.token = TOKEN;
	io.file = (argc >= 2) ? argv[1] : NULL;
	io.name = (argc >= 2) ? argv[1] : "stdin";
	

	io_post(io);

	return 0;
}
