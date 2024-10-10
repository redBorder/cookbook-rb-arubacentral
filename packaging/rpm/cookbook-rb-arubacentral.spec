%undefine __brp_mangle_shebangs

Name: cookbook-rb-arubacentral
Version: %{__version}
Release: %{__release}%{?dist}
BuildArch: noarch
Summary: rb-arubacentral cookbook to install and configure it in redborder environments

License: AGPL 3.0
URL: https://github.com/redBorder/cookbook-rb-arubacentral
Source0: %{name}-%{version}.tar.gz

%description
%{summary}

%prep
%setup -qn %{name}-%{version}

%build

%install
mkdir -p %{buildroot}/var/chef/cookbooks/rb-arubacentral
cp -f -r  resources/* %{buildroot}/var/chef/cookbooks/rb-arubacentral/
chmod -R 0755 %{buildroot}/var/chef/cookbooks/rb-arubacentral
install -D -m 0644 README.md %{buildroot}/var/chef/cookbooks/rb-arubacentral/README.md

%pre
if [ -d /var/chef/cookbooks/rb-arubacentral ]; then
    rm -rf /var/chef/cookbooks/rb-arubacentral
fi

%post
case "$1" in
  1)
    # This is an initial install.
    :
  ;;
  2)
    # This is an upgrade.
    su - -s /bin/bash -c 'source /etc/profile && rvm gemset use default && env knife cookbook upload rb-arubacentral'
  ;;
esac

%postun
# Deletes directory when uninstall the package
if [ "$1" = 0 ] && [ -d /var/chef/cookbooks/rb-arubacentral ]; then
  rm -rf /var/chef/cookbooks/rb-arubacentral
fi

%files
%defattr(0755,root,root)
/var/chef/cookbooks/rb-arubacentral
%defattr(0644,root,root)
/var/chef/cookbooks/rb-arubacentral/README.md

%doc

%changelog
* Thu Oct 10 2024 Miguel Negrón <manegron@redborder.com>
- Add pre and postun

* Mon Jan 15 2024 David Vanhoucke <dvanhoucke@redborder.com>
- first spec version
