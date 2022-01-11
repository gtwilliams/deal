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

%prep
%autosetup

%build
touch Make.dep
make

%install
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_mandir}/man6
mkdir -p %{buildroot}%{_datadir}/%{name}/input
mkdir -p %{buildroot}%{_datadir}/%{name}/format
mkdir -p %{buildroot}%{_datadir}/%{name}/lib
mkdir -p %{buildroot}%{_datadir}/%{name}/ex
mkdir -p %{buildroot}%{_docdir}/%{name}/html
mkdir -p %{buildroot}%{_docdir}/%{name}/graphics
install -p -m 0755 deal            %{buildroot}%{_bindir}
install -p -m 0444 deal.6          %{buildroot}%{_mandir}/man6
install -p -m 0444 deal.tcl        %{buildroot}%{_datadir}/%{name}
install -p -m 0444 input/*         %{buildroot}%{_datadir}/%{name}/input
install -p -m 0444 format/*        %{buildroot}%{_datadir}/%{name}/format
install -p -m 0444 lib/*           %{buildroot}%{_datadir}/%{name}/lib
install -p -m 0444 docs/html/*.*   %{buildroot}%{_docdir}/%{name}/html
install -p -m 0444 docs/html/ex/*  %{buildroot}%{_datadir}/%{name}/ex
install -p -m 0444 docs/graphics/* %{buildroot}%{_docdir}/%{name}/graphics

%files
%{_bindir}/deal
%{_mandir}/man6/deal.6*
%{_datadir}/%{name}/*
%{_docdir}/%{name}/*

%changelog
* Mon Jan 10 2022 Garry T. Williams <gtwilliams@gmail.com> - 3.1.9-1
- Initial version of the package 3.1.9-1
