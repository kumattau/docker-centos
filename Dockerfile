# ============================================================================
FROM rockylinux:9 AS chroot
SHELL ["/bin/bash", "-eu", "-o", "pipefail", "-c"]

ARG REPOURL="https://ftp.iij.ad.jp/pub/linux/centos-vault/"
ARG VERSION="8.5.2111"
ARG RELEASE="centos-release"

RUN <<'EOT'
set -x
if [ "${VERSION%%.*}" -le 7 ]; then
    dirpath="os/x86_64/"
else
    dirpath="BaseOS/x86_64/os/"
fi
cat <<EOF | tee /etc/yum.repos.d/chroot.repo
[$VERSION]
name=$VERSION
baseurl=$REPOURL/$VERSION/$dirpath
enabled=0
gpgcheck=0
EOF
EOT

# download RPMs
RUN dnf -y install "$RELEASE" yum bash curl vim-minimal findutils diffutils grep sed gawk less \
    --repo=$VERSION --downloadonly --downloaddir=/chroot/pkg/ --installroot=/dummy/ && rm -fr /dummy/

# deploy essentials into chroot
RUN rpm --root=/chroot/ -ivh /chroot/pkg/*.rpm

# remove config to avoid generating *.rpmnew at installation
RUN rpm --root=/chroot/ -qa --configfiles | xargs -I{} rm -f /chroot/{}

# https://serverfault.com/questions/911781/yum-rpm-failed-to-initialize-nss-library-in-chroot
RUN dd if=/dev/urandom bs=1024 count=1 > /chroot/dev/urandom

# do clean(-like) installation in chroot
RUN chroot /chroot/ bash -c 'rm -fr /var/lib/rpm && rpm -ivh /pkg/*.rpm && ldconfig'

# import gpgkey for yum and dnf (optional)
# hadolint ignore=SC2016
RUN chroot /chroot/ bash -c 'rpm --import $(rpm -qal | grep /RPM-GPG-KEY | grep -ivE "testing|debug|beta")'

# delete data not required for container
RUN shopt -s nullglob && shopt -s dotglob && shopt -s globstar && \
    rm -fr /chroot/{pkg/,{dev,proc,sys,tmp}/*,**/{tmp,cache,log}/*}

# At least, CentOS-3.8 and CentOS-4.1 requires /var/cache/yum directory
RUN if [ "${VERSION%%.*}" -le 7 ]; then mkdir -p /chroot/var/cache/yum; else mkdir -p /chroot/var/cache/dnf; fi

# ============================================================================
FROM scratch
COPY --from=chroot /chroot/ /

# ============================================================================
