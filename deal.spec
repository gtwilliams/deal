# Copyright (c) 2022 Garry T. Williams

Name: deal
Version: 3.1.9
Release: 1%{?dist}
Summary: Bridge Hand Generator
URL: https://github.com/gtwilliams/deal
Source0: https://github.com/gtwilliams/deal/archive/refs/tags/v3.1.9-1.tar.gz

# Original source is at:
# https://bridge.thomasoandrews.com/deal/deal319.zip

# The source in this package has been modified to build without
# compiler errors.  It was also modified to change its working
# directory to the installed directory, /usr/share/deal since the
# program relies on the current directory to find some files.

License: GPLv2+

BuildRequires: gcc
BuildRequires: g++
BuildRequires: make
BuildRequires: tcl-devel
BuildRequires: perl-podlators

Requires: tcl

%description
This program generates bridge hands.  It can be told to generate only
hands satisfying conditions like being balanced, having a range of
HCPs, controls, or other user-definable properties.  Hands can be
output in various formats, like pbn for feeding to other bridge
programs, deal itself, or split up into a file per player for
practise.  Extensible via Tcl.

%global build_data %{buildroot}%{_datadir}/%{name}
%global build_docs %{buildroot}%{_docdir}/%{name}

%prep
%autosetup

%build
touch Make.dep
%make_build

%install
# Original source has no install target in its Makefile.  The original
# author didn't anticipate running the program from anywhere other
# than the source directory after doing a make command.  Pretty crude.
# We encode the install target here:
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_mandir}/man6
mkdir -p %{build_data}/input
mkdir -p %{build_data}/format
mkdir -p %{build_data}/lib
mkdir -p %{build_data}/ex
mkdir -p %{build_docs}/html
mkdir -p %{build_docs}/graphics

install -p -m 0755 deal            %{buildroot}%{_bindir}
install -p -m 0644 deal.6          %{buildroot}%{_mandir}/man6
install -p -m 0644 deal.tcl        %{build_data}
install -p -m 0644 input/*         %{build_data}/input
install -p -m 0644 format/*        %{build_data}/format
install -p -m 0644 lib/*           %{build_data}/lib
install -p -m 0644 ex/*            %{build_data}/ex
install -p -m 0644 docs/html/*.*   %{build_docs}/html
install -p -m 0644 docs/graphics/* %{build_docs}/graphics

%files
%{_bindir}/deal
%{_mandir}/man6/deal.6*
%{_datadir}/%{name}/
%doc %{_docdir}/%{name}/

%changelog
* Mon Jan 10 2022 Garry T. Williams <gtwilliams@gmail.com> 3.1.9-1
- Initial version of the package 3.1.9-1
