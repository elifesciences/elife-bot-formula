#
# strip coverletter
#

strip-coverletter-deps:
    pkg.installed:
        - pkgs:
            - xpdf-utils
            - ghostscript

pdfsam-absent:
    file.absent:
        - name: /opt/pdfsam
 
pdfsam-exec-absent:
    file.absent:
        - name: /usr/bin/pdfsam-console

install-strip-coverletter:
    git.latest:
        - name: https://github.com/elifesciences/strip-coverletter
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - target: /opt/strip-coverletter

    cmd.run:
        - cwd: /opt/strip-coverletter
        #- user: {{ pillar.elife.deploy_user.username }}
        - name: ./download-sejda.sh
        - onlyif:
            # download script exists and symlink doesn't exist
            - test -e download-sejda.sh && test ! -h /opt/strip-coverletter/sejda-console
        - require:
            - git: install-strip-coverletter

strip-coverletter-working:
    cmd.run:
        - cwd: /opt/strip-coverletter
        - name: |
            ./strip-coverletter.sh /opt/strip-coverletter/dummy.pdf tmp.pdf && rm tmp.pdf
        - require:
            - install-strip-coverletter

#
# dockerised version
#

strip-coverletter-docker-image:
    cmd.run:
        - cwd: /opt/strip-coverletter
        - name: ./build-image.sh

strip-coverletter-docker-working:
    cmd.run:
        - cwd: /opt/strip-coverletter
        - name: ./strip-coverletter-docker.sh /opt/strip-coverletter/dummy.pdf tmp.pdf && rm tmp.pdf
        - require:
            - strip-coverletter-docker-image
