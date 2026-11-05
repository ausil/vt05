Name:           vt05
Version:        1.0
Release:        1%{?dist}
Summary:        SDL-based emulators of classic serial terminals
License:        MIT
URL:            https://github.com/aap/vt05
# Produced by `make dist` (git archive) from this project.
Source0:        %{name}-%{version}.tar.gz
Source1:        %{name}.1

BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  SDL2-devel

%description
Emulators of classic serial terminals: the DEC VT05, VT50 and VT52,
the DP3300 and GECON consoles, and the Datamedia Elite 2500.
Each program opens an SDL window and runs a command attached to a
pseudo-terminal, rendered with phosphor glow and scan line
effects.

%prep
%setup -q

%build
make %{?_smp_mflags}

%check
for bin in vt05 vt52 vt50 dp3300 gecon dm2500; do
    test -x ${bin} || exit 1
done

%install
rm -rf %{buildroot}
install -d -m 0755 %{buildroot}%{_bindir}
for bin in vt05 vt52 vt50 dp3300 gecon dm2500; do
    install -m 0755 ${bin} %{buildroot}%{_bindir}/${bin}
    install -D -m 0644 %{SOURCE1} %{buildroot}%{_mandir}/man1/${bin}.1
done

%files
%license LICENSE
%{_bindir}/vt05
%{_bindir}/vt52
%{_bindir}/vt50
%{_bindir}/dp3300
%{_bindir}/gecon
%{_bindir}/dm2500
%{_mandir}/man1/vt05.1*
%{_mandir}/man1/vt52.1*
%{_mandir}/man1/vt50.1*
%{_mandir}/man1/dp3300.1*
%{_mandir}/man1/gecon.1*
%{_mandir}/man1/dm2500.1*

%changelog
* Thu Nov 05 2026 Dennis <dennis@ausil.us> - 1.0-1
- Initial packaging
