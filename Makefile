all: tarball
	
tarball:
	git archive --format=tar HEAD | gzip > jenkins-in-house-plugins-gearman-plugin.tar.gz

clean:
	git fetch origin
	git reset --hard origin/SETI-4077-test
	rm -rf /root/rpmbuild/SOURCES/jenkins-in-house-plugins-gearman-plugin.tar.gz jenkins-in-house-plugins-gearman-plugin.tar.gz
	rm -rf /var/lib/juseppe/unz/*
	rm -rf /root/rpmbuild/SOURCES/jenkins-in-house-plugins-gearman-plugin.tar.gz 
	yum remove -y jenkins-in-house-plugins-gearman-plugin
	yum clean all

build:
	cp jenkins-in-house-plugins-gearman-plugin.tar.gz /root/rpmbuild/SOURCES/jenkins-in-house-plugins-gearman-plugin.tar.gz
	rpmbuild -ba gearman-plugin.spec

check:
	createrepo -v /root/rpmbuild/RPMS/x86_64/
	yum install jenkins-in-house-plugins-gearman-plugin
	mv /var/lib/juseppe/gearman-plugin.hpi /var/lib/juseppe/unz/
	unzip /var/lib/juseppe/unz/gearman-plugin.hpi -d /var/lib/juseppe/unz/
	cat /var/lib/juseppe/unz/META-INF/MANIFEST.MF

test:
	rpm2cpio /root/rpmbuild/RPMS/x86_64/jenkins-in-house-plugins-gearman-plugin-2.0.9-1.el7.x86_64.rpm | cpio -idmv
	unzip var/lib/juseppe/stork-pi-pool.hpi -d var/lib/juseppe/unz/
	cat var/lib/juseppe/unz/META-INF/MANIFEST.MF

.PHONY: all tarball clean test build check
