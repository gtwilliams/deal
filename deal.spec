# Copyright (c) 2022 Garry T. Williams

Name: deal
Version: 3.1.9
Release: 1%{?dist}
Summary: Bridge Hand Generator
URL: https://bridge.thomasoandrews.com/deal/
Source0: %{name}-%{version}.tar.gz
# https://github.com/gtwilliams/deal.git

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

%description
This program generates bridge hands.  It can be told to generate only
hands satisfying conditions like being balanced, having a range of
HCPs, controls, or other user-definable properties.  Hands can be
output in various formats, like pbn for feeding to other bridge
programs, deal itself, or split up into a file per player for
practise.  Extensible via Tcl.

%global debug_package %{nil}

%define build_data %{buildroot}%{_datadir}/%{name}
%define build_docs %{buildroot}%{_docdir}/%{name}

%prep
%autosetup

%build
touch Make.dep
make

%install
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
%{_datadir}/%{name}/*
%{_docdir}/%{name}/*

%changelog
* Mon Jan 10 2022 Garry T. Williams <gtwilliams@gmail.com> - 3.1.9-1
- Initial version of the package 3.1.9-1
