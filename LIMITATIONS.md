# Limitations

This cookbook manages HAProxy from distribution packages or from an upstream
source archive. It does not configure the HAProxy Technologies Enterprise
repositories.

## Upstream lifecycle

HAProxy publishes both stable and long-term-support branches. The source
installer defaults to the 3.2 LTS branch; exact patch releases are tracked in
`resources/install.rb` and the integration test recipes.

See the [HAProxy release table](https://www.haproxy.org/) for current branch
support dates and patch releases.

## Package availability

The `package` installation path uses the package named `haproxy` from the
configured operating-system repositories. The version and architecture
therefore depend on the distribution release and enabled repositories.

### APT (Debian and Ubuntu)

* Debian and Ubuntu publish HAProxy in their normal archives.
* The Debian HAProxy packaging team publishes newer supported branches through
  [haproxy.debian.net](https://haproxy.debian.net/).
* Vincent Bernat's Ubuntu PPAs publish branch-specific builds where available.
  The cookbook does not add these APT repositories automatically.
* Debian 12 and 13 and Ubuntu 22.04 and 24.04 provide HAProxy packages for
  multiple architectures through their distribution archives.

### DNF and YUM (RHEL family, Fedora, and Amazon Linux)

* RHEL-family, Fedora, and Amazon Linux installations use the package available
  from their configured distribution repositories.
* `enable_epel_repo true` enables EPEL through the `yum-epel` cookbook before
  package installation on RHEL-family and Amazon platforms.
* The legacy IUS path only applies to RHEL 6 and 7. Those releases are
  unsupported, so `enable_ius_repo` is retained only for compatibility and
  should not be used for current deployments.
* Package versions and architectures vary by distribution and repository; use
  source installation when a specific HAProxy release is required.

### Zypper (openSUSE Leap)

* openSUSE Leap installations use the package from configured distribution
  repositories.
* The cookbook does not add an HAProxy-specific Zypper repository.

## Architecture limitations

* Source installation uses `node['kernel']['machine']` as HAProxy's `CPU` value
  unless `source_target_cpu` is overridden.
* Distribution package architecture coverage is controlled by each
  distribution repository.
* The cookbook's integration matrix primarily exercises x86_64 containers;
  other architectures require separate validation.

## Source installation

HAProxy source archives are downloaded from
`https://www.haproxy.org/download/<branch>/src/`.

### Build dependencies

| Platform family | Required packages |
| --- | --- |
| Debian | `build-essential`, OpenSSL, zlib, systemd, and PCRE development packages |
| RHEL, Fedora, Amazon | compiler/build tools, OpenSSL, zlib, systemd, and PCRE development packages |
| SUSE | compiler/build tools, OpenSSL, zlib, systemd, and PCRE development packages |

Optional Lua and custom OpenSSL builds require the matching development headers
and libraries. HAProxy build flags such as `USE_OPENSSL`, `USE_LUA`,
`USE_SYSTEMD`, `USE_PCRE` or `USE_PCRE2`, and `USE_PROMEX` are exposed through
resource properties.

## Known constraints

* PCRE1 packages are unavailable on newer platform releases. The cookbook
  selects PCRE2 for Debian 13 and RHEL-family version 10 or newer.
* The default source checksum is coupled to the default source version; custom
  versions must supply their matching checksum.
* Source installation compiles in Chef's file cache and installs under
  `bin_prefix`. Removal must account for those installed artifacts.
* The source installer supports systemd only; SysV and Upstart service
  management are outside the supported migration scope.
