# XenServerScripts
Scripts created to automate common Xen Server Admin



## Xen VM Backup Setup

#### Add Depencencies

##### Setup Compile Evnironment

- Enable Base Repo [EDIT ```/etc/yum.repos.d/CentOS-Base.repo```]
  - change to enabled=1 [true]
  - uncomment baseurl

  ```
  [base]
  name=CentOS-$releasever - Base
  mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
  baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
  enabled=1
  exclude=kernel kernel-abi-whitelists kernel-debug kernel-debug-devel kernel-devel kernel-doc kernel-tools kernel-tools-libs kernel-tools-libs-devel linux-firmware biosdevname centos-release systemd* stunnel kexec-tools ocaml*
  gpgcheck=1
  gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
  ```

- Update repo ```yum repolist all```

- Install gcc ```yum install -y gcc```

##### Download & Install Dependencies

+ Zlib
  + Download latest from http://zlib.net/
  + Extract & ./configure & make & make install
+ Pigz
  + Download latest from http://zlib.net/pigz/
  + Extract & make
  + Move executable ```pigz``` to perminate location [/usr/local/bin]


#### Setup Backup Script

+ Modify script config vars for environment
+ Move ```xenvmbackup.sh``` script to perminate location [e.g. /usr/local/scripts]
+ Test Script by running ```/usr/local/scripts/xenvmbackup.sh```
+ Add crontab entry [e.g. ``` @weekly /usr/local/scripts/xenvmbackup.sh```]





