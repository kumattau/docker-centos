# docker-centos

Dockerfile to create centos image.

```
$ ./build.sh -h
SYNOPSIS
    ./build.sh -v VERSION [-t TAGNAME] [-r REPOURL] [-n] [-h]

OPTIONS
    -v VERSION  CentOS version choiced in the supported versions
    -t TAGNAME  Docker image tag name (default: centos-<VERSION>)
    -r REPOURL  CentOS repository URL (default: vault repository in japan)
    -n          Dry-run
    -h          This message

SUPPORTED VERSIONS
    3.8 3.9
    4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9
    5.0 5.1 5.2 5.3 5.4 5.5 5.6 5.7 5.8 5.9 5.10 5.11
    6.0 6.1 6.2 6.3 6.4 6.5 6.6 6.7 6.8 6.9 6.10
    7.0.1406 7.1.1503 7.2.1511 7.3.1611 7.4.1708
    7.5.1804 7.6.1810 7.7.1908 7.8.2003 7.9.2009
    8.0.1905 8.1.1911 8.2.2004 8.3.2011 8.4.2105 8.5.2111

NOTE
    7.9.2009 is selected, REPOURL also must be set to not-vault repository.
```
