#
# strip coverletter
#

strip-coverletter-deps:
    pkg.removed:
        - pkgs:
            - poppler-utils # aka xpdf-utils
            - ghostscript
            - oracle-java8-installer
            - openjdk-7-jre-headless
            - openjdk7-jre

install-strip-coverletter:
    git.latest:
        - name: https://github.com/elifesciences/strip-coverletter
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - target: /opt/strip-coverletter

#
# dockerised version
#

strip-coverletter-docker-writable-dir:
    file.directory:
        - name: /opt/strip-coverletter/vol
        - user: {{ pillar.elife.deploy_user.username }}
        - group: 1001 # see Dockerfile and the 'worker' user
        - dir_mode: 774 # rwxrwxr--
        - recurse: # shouldn't be necessary, dir is cleared out after each call
            - user
            - group
            - mode
        - require:
            - install-strip-coverletter

strip-coverletter-docker-image:
    cmd.run:
        - cwd: /opt/strip-coverletter
        - name: ./build-image.sh
        - require:
            - docker-ready

strip-coverletter-docker-working:
    cmd.run:
        - runas: {{ pillar.elife.deploy_user.username }}
        - cwd: /opt/strip-coverletter
        - name: ./strip-coverletter-docker.sh /opt/strip-coverletter/dummy.pdf /tmp/dummy.pdf && rm /tmp/dummy.pdf
        - require:
            - strip-coverletter-docker-image
            - strip-coverletter-docker-writable-dir
