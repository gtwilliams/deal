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

#define KEYWORD_INVALID_ID -1
#define KEYWORD_SET_DEFAULT 1
#define KEYWORD_SET_NODUPLICATE 2

long Keyword_getId(char *key);
int Keyword_alias(char *alias,char *oldKey,int flags);
int Keyword_addKey(char *key);
const char *Keyword_getKey(long id);
Tcl_Obj *Keyword_NewObj(int id);
int Keyword_Init(Tcl_Interp *interp);
int Keyword_getIdFromObj(Tcl_Interp *interp,Tcl_Obj *obj);
extern Tcl_ObjType KeywordType;
