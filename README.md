# deal

<a href="https://repology.org/project/deal/versions">
    <img
      src="https://repology.org/badge/vertical-allrepos/deal.svg?columns=2"
      alt="Distribution packaging status for deal"
      align="right"
    >
</a>

Thomas Andrews' deal 3.1.9 Forked

This repository contains changes to the original deal sources[^1] that
allow the program to be compiled without compiler errors.  A deal.spec
file to package the program for inclusion in Fedora releases has been
added.  The original dependency on the current working directory has
been removed.  Now certain paths are prepended with the installation
directory to get the TCL files to load no matter what the PWD happens
to be.

[^1]:https://bridge.thomasoandrews.com/deal/
