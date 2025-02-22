/*
 * Copyright (C) 1996-2001, Thomas Andrews
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#include "tcl_incl.h"
typedef struct {
    int count;
    double weight;
    double sum,sumsquared;
    double max, min;
} SDev;

typedef struct {
    int count;
    double weight;
    double maxx, maxy;
    double minx, miny;
    double sumx,sumy,sumxx,sumyy,sumxy;
} Correlation;

double sdev(SDev *);
double sdevAverage(SDev *);
void sdevReset(SDev *);
void sdevAddData(SDev *,double,double);
SDev *sdevNew();
void sdevFree(ClientData);
int tcl_rand_cmd (TCLOBJ_PARAMS);
int tcl_sdev_define(TCL_PARAMS);
int tcl_correlation_define(TCLOBJ_PARAMS);


Correlation *correlationNew();
void corrAddData(Correlation *,double,double,double);
double corrResult(Correlation *corr);
void corrReset(Correlation *);
void correlationFree(ClientData);
