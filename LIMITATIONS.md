# Limitations

## Package Availability

HAProxy is available as a package on all major Linux distributions. The version
available depends on the distribution release.

### APT (Debian/Ubuntu)

- **Debian 11 (Bullseye)**: HAProxy 2.2 (default), 2.4–2.8 via haproxy.debian.net
- **Debian 12 (Bookworm)**: HAProxy 2.6 (default), 2.8–3.0 via haproxy.debian.net
- **Ubuntu 20.04 (Focal)**: HAProxy 2.0 (default), newer via PPA `ppa:vbernat/haproxy-X.Y`
- **Ubuntu 22.04 (Jammy)**: HAProxy 2.4 (default), newer via PPA
- **Ubuntu 24.04 (Noble)**: HAProxy 2.8 (default), newer via PPA

Architectures: amd64, arm64, i386 (varies by release).

### DNF/YUM (RHEL family)

- **RHEL 8 / AlmaLinux 8 / Rocky 8 / Oracle 8**: HAProxy 1.8 (base), newer via EPEL or AppStream
- **RHEL 9 / AlmaLinux 9 / Rocky 9 / Oracle 9**: HAProxy 2.4 (AppStream)
- **AlmaLinux 10 / CentOS Stream 10**: HAProxy 3.0+ (AppStream)
- **CentOS Stream 9**: HAProxy 2.4 (AppStream)
- **Amazon Linux 2023**: HAProxy 2.8 (default repos)
- **Fedora**: Latest stable (default repos)

Architectures: x86_64, aarch64.

EPEL is required for RHEL-family platforms when the base/AppStream version is insufficient.
The `yum-epel` cookbook dependency handles this.

### Zypper (SUSE)

- **openSUSE Leap 15**: HAProxy 2.x (default repos)

Architectures: x86_64.

## Source/Compiled Installation

HAProxy can be compiled from source on all supported platforms. The cookbook supports
source installation with configurable version, build flags, and optional features
(Lua, OpenSSL, PCRE, Prometheus exporter).

### Build Dependencies

| Platform Family | Packages                                                              |
|-----------------|-----------------------------------------------------------------------|
| Debian          | build-essential, libpcre3-dev, libssl-dev, zlib1g-dev, libsystemd-dev |
| RHEL (< 10)     | pcre-devel, openssl-devel, zlib-devel, systemd-devel, tar             |
| RHEL (>= 10)    | pcre2-devel, openssl-devel, zlib-devel, systemd-devel, tar            |
| SUSE            | pcre-devel, libopenssl-devel, zlib-devel, systemd-devel               |

### Optional Build Dependencies

| Feature   | Debian              | RHEL           |
|-----------|---------------------|----------------|
| Lua       | liblua5.3-dev       | lua-devel      |
| OpenSSL 3 | libssl-dev (>= 3.0) | openssl3-devel |

## Architecture Limitations

- All platforms provide amd64/x86_64 packages
- arm64/aarch64 packages available on Debian 11+, Ubuntu 20.04+, RHEL 9+
- Source compilation works on all architectures with appropriate cross-compiler

## Known Issues

- PCRE1 (`pcre-devel`) is deprecated on RHEL/CentOS/AlmaLinux/Rocky >= 10; the cookbook
  automatically selects PCRE2 (`pcre2-devel`) on those platforms
- IUS repository support is limited to RHEL 6/7 (both EOL) and should be considered deprecated
- OpenSSL source compilation has known issues (see [#503](https://github.com/sous-chefs/haproxy/issues/503))
- The `haproxy-systemd-wrapper` binary is only used for HAProxy versions < 1.8
