/*  cpubar - ascii cpu usage bar, best used with dzen
 * 
 *  Copyright (C) 2007 by Robert Manea, <rob dot manea at gmail dot com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version
 *
 *  This program is distributed in the hope that it will be useful, but 
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU 
 *  General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
 *  USA
 *
 *  Compile it with:
 *  gcc cpubar.c -o cpubar
 *
 */

#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>

void pbar (double, int, char);

struct cpu_info {
	unsigned long long user;
	unsigned long long system;
	unsigned long long idle;
	unsigned long long iowait;
} ncpu, ocpu;

void
pbar(double perc, int maxc, char sym) {
	int i, rp;
	double l;

	l = perc * ((double)maxc / 100);

	if( (int)(perc + 0.5) >= (int)perc)
		rp = (int)(perc + 0.5);
	else
		rp = (int)perc;

	printf("CPU: %3d%% [", rp);

	for(i=0; i < (int)l; i++)
		printf("%c", sym);

	for(; i < maxc; i++)
		printf(" ");
	printf("]\n");
	fflush(stdout);
}

int 
main(int argc, char *argv[])
{
	int i;
	double total;
	struct cpu_info mcpu;
	FILE *statfp;
	char buf[256];

	/* defaults */
	int maxchars=25;
	int ival=1;
	char psym='=';

	for(i=1; i < argc; i++) {
		if(!strncmp(argv[i], "-c", 3)) {
			if(++i < argc)
				maxchars = atoi(argv[i]);
		}
		else if(!strncmp(argv[i], "-s", 3)) {
			if(++i < argc)
				psym = argv[i][0];
		}
		else if(!strncmp(argv[i], "-i", 3)) {
			if(++i < argc)
				ival = atoi(argv[i]);
		}
		else {
			printf("usage: cpubar [-c <charcount>] [-s <symbol>] [-i <interval>]\n");
			return EXIT_FAILURE;
		}
	}


	if(!(statfp = fopen("/proc/stat", "r"))) {
		printf("cpubar: error opening '/proc/stat'\n");
		return EXIT_FAILURE;
	}

	while(1) {
		rewind(statfp); 
		while(fgets(buf, sizeof buf, statfp)) {
			if(!strncmp(buf, "cpu ", 4)) {
				unsigned long long unice;
				double myload;
				/* linux >= 2.6 */
				if((sscanf(buf, "cpu %llu %llu %llu %llu %llu", 
						&ncpu.user, &unice, &ncpu.system, &ncpu.idle, &ncpu.iowait)) < 5) {
					printf("cpubar: wrong field count in /proc/stat\n");
					return EXIT_FAILURE;
				}
				ncpu.user += unice;

				mcpu.user   = ncpu.user - ocpu.user;
				mcpu.system = ncpu.system - ocpu.system;
				mcpu.idle   = ncpu.idle - ocpu.idle;
				mcpu.iowait = ncpu.iowait - ocpu.iowait;

				total  = (mcpu.user + mcpu.system + mcpu.idle + mcpu.iowait) / 100.0;
				myload = (mcpu.user + mcpu.system + mcpu.iowait) / total;

				pbar(myload, maxchars, psym);
				ocpu = ncpu;
			}
		}
		sleep(ival);
	}
  
  return EXIT_SUCCESS;
}

