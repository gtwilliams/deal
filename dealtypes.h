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
#include "keywords.h"
#include "deal.h"

extern Tcl_ObjType CardType, HoldingType,CardRankType;

void initializeDealTypes(Tcl_Interp *);
void initializeLengths();

int getHandNumFromObj(Tcl_Interp *interp, Tcl_Obj *hand);
Tcl_Obj *getHandKeywordObj(Tcl_Interp *interp, int num);
Tcl_Obj *getLengthObj(int i);

int getSuitNumFromObj(Tcl_Interp *interp, Tcl_Obj *suit);
int getDenomNumFromObj(Tcl_Interp *interp, Tcl_Obj *suit);
int getCardNumFromObj(Tcl_Interp *interp, Tcl_Obj *card);
int getCardRankNumFromObj(Tcl_Interp *interp, Tcl_Obj *card);
int getHoldingNumFromObj(Tcl_Interp *interp, Tcl_Obj *card);
Tcl_Obj *Tcl_NewHoldingObj(int holding);
Tcl_Obj * const *getAllSuitObjs();
char *getStringForHoldingNum(int holding,int *lenPtr);
int getHandHoldingsFromObj(Tcl_Interp *interp,Tcl_Obj *obj, Tcl_Size *harray);
int getHandHoldingsFromObjv(Tcl_Interp *interp,Tcl_Obj * const *objv, Tcl_Size *harray);
