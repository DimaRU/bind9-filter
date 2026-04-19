# BIND9 conditional filter

Filter AAAA or A in DNS responses based on domain name.

## Getting Started

### Sample configuration

```bind9
plugin query "filter-a-cond.so" {
   filter-a-on-v6 yes;
   filter-a-on-v4 yes;
   filter-a { any; };
   only-for-domains { "youtube.com."; "youtu.be."; "accounts.youtube.com"; "i.ytimg.com."; "wide-youtube.l.google.com."; "www3.l.google.com."; "clients.l.google.com."; "yt3.googleusercontent.com."; "googlevideo.com."; "accounts.google.com."; "youtube-ui.l.google.com."; };
};

plugin query "filter-aaaa-cond.so" {
   filter-aaaa-on-v6 yes;
   filter-aaaa-on-v4 yes;
   filter-aaaa { any; };
   only-for-domains_exact { "www.google.com."; };
};
```

In this configuration, we forces youtube run in IPv6 mode. This is particularly important for using IPV6 on the Apple TV set-top box. We also use Google search in IPv4 mode to avoid annoying captchas.


### Build

Assumed, that you use stable bind version from BIND9 PPA: 
https://launchpad.net/~isc/+archive/ubuntu/bind

Use `docker-build.sh` bash script for building filter plugins for Ubuntu 24.04 "Noble"
```bash
./docker-build.sh "9.20.22"
```
Bind9 sources downloaded from here: https://ppa.launchpadcontent.net/isc/bind/ubuntu/pool/main/b/bind9/

### Install

After build, you will have `filter-aaaa-cond.so` and  `filter-a-cond.so` files in the build directory.
Execute in terminaL 
`sudo make install`
to copy files into appopriate directory or
`sudo make run`
to copy files into appopriate directory and restart bind9 service.

## Usage

### Synopsis

**plugin query** "filter-a-cond.so" [{ parameters }];
**plugin query** "filter-aaaa-cond.so" [{ parameters }];

## **filter-aaaa-cond.so**
#### Description

**filter-aaaa-cond.so** is a query plugin module for [`named`](https://bind9.readthedocs.io/en/stable/manpages.html#std-iscman-named), enabling [`named`](https://bind9.readthedocs.io/en/stable/manpages.html#std-iscman-named) to omit some IPv6 addresses when responding to clients.

####  Options

**`filter-aaaa`**

This option specifies a list of client addresses for which AAAA filtering is to be applied. The default is `any`.

**`filter-aaaa-on-v4`**

If set to `yes`, this option indicates that the DNS client is at an IPv4 address, in `filter-aaaa`. If the response does not include DNSSEC signatures, then all AAAA records are deleted from the response. This filtering applies to all responses, not only authoritative ones.

If set to `break-dnssec`, then AAAA records are deleted even when DNSSEC is enabled. As suggested by the name, this causes the response to fail to verify, because the DNSSEC protocol is designed to detect deletions.

This mechanism can erroneously cause other servers not to give AAAA records to their clients. If a recursing server with both IPv6 and IPv4 network connections queries an authoritative server using this mechanism via IPv4, it is denied AAAA records even if its client is using IPv6.

**`filter-aaaa-on-v6`**

This option is identical to `filter-aaaa-on-v4`, except that it filters AAAA responses to queries from IPv6 clients instead of IPv4 clients. To filter all responses, set both options to `yes`.

**`only-for-domains`**

This option specifies a list of domains for which AAAA filtering is to be applied. Filtering also applies to all subdomains.

**`only-for-domains_exact`**

This option specifies a list of domains for which AAAA filtering is to be applied. Domain names specified exactly, so subdomains are not included in the filtering.

## **filter-a-cond.so**
### Description

**filter-a-cond.so** is a query plugin module for [`named`](https://bind9.readthedocs.io/en/stable/manpages.html#std-iscman-named), enabling [`named`](https://bind9.readthedocs.io/en/stable/manpages.html#std-iscman-named) to omit some IPv4 addresses when responding to clients.

This module is intended to aid transition from IPv4 to IPv6 by
withholding IPv4 addresses from DNS clients which are not connected to
the IPv4 Internet, when the name being looked up has an IPv6 address
available. Use of this module is not recommended unless absolutely
necessary.

Note: This mechanism can erroneously cause other servers not to give A
records to their clients. If a recursing server with both IPv6 and IPv4
network connections queries an authoritative server using this mechanism
via IPv6, it is denied A records even if its client is using IPv4.

### Options

**`filter-a`**

This option specifies a list of client addresses for which A
filtering is to be applied. The default is `any`.

**`filter-a-on-v6`**

If set to `yes`, this option indicates that the DNS client is at an
IPv6 address, in `filter-a`. If the response does not include DNSSEC
signatures, then all A records are deleted from the response. This
filtering applies to all responses, not only authoritative ones.

If set to **`break-dnssec`**, then A records are deleted even when
DNSSEC is enabled. As suggested by the name, this causes the
response to fail to verify, because the DNSSEC protocol is designed
to detect deletions.

This mechanism can erroneously cause other servers not to give A
records to their clients. If a recursing server with both IPv6 and
IPv4 network connections queries an authoritative server using this
mechanism via IPv6, it is denied A records even if its client is
using IPv4.

**`filter-a-on-v4`**

This option is identical to `filter-a-on-v6`, except that it filters
A responses to queries from IPv4 clients instead of IPv6 clients. To
filter all responses, set both options to `yes`.

**`only-for-domains`**

This option specifies a list of domains for which A filtering is to be applied. Filtering also applies to all subdomains.

**`only-for-domains_exact`**

This option specifies a list of domains for which A filtering is to be applied. Domain names specified exactly, so subdomains are not included in the filtering.

## License

This code is licensed under the GNU License.
