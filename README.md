# deal
Thomas Andrews' deal 3.1.9 Forked

This repository contains changes to the original deal sources that
allow the program to be compiled without comoiler warnings.  A
deal.spec file to package the program for inclusion in Fedora releases
has been added.  The start-up code now includes a chdir() to the
/usr/share/deal directory so that files assumed to be in the current
directory path will load successfully.
