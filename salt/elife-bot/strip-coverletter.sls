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

strip-coverletter-docker-writable-dir:
    file.directory:
        - name: /opt/strip-coverletter/vol
        - user: root
        - group: {{ pillar.elife.deploy_user.username }}
        - dir_mode: 777 # TODO: permissions problem here. what user is this script run as?
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

# TODO: this would be a better test if it were run as the user calling strip-coverletter
strip-coverletter-docker-working:
    cmd.run:
        - cwd: /opt/strip-coverletter
        - name: ./strip-coverletter-docker.sh /opt/strip-coverletter/dummy.pdf tmp.pdf && rm tmp.pdf
        - require:
            - strip-coverletter-docker-image
            - strip-coverletter-docker-writable-dir
