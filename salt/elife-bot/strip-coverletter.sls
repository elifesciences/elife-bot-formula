#
# strip coverletter
#

strip-coverletter-deps:
    pkg.installed:
        - pkgs:
            - xpdf-utils
            - ghostscript

    # TODO: remove when strip-coverletter moves to sejda
    archive.extracted:
        - name: /opt/pdfsam/
        - source: https://github.com/torakiki/pdfsam-v2/releases/download/v2.2.4/pdfsam-2.2.4-out.zip
        - archive_format: zip
        - source_hash: md5=29ab520b1bf453af7394760b66d43453
        - unless:
            - test -d /opt/pdfsam/

    # TODO: remove when strip-coverletter moves to sejda
    cmd.run:
        - name: |
            echo -e '#!/bin/bash\ncd /opt/pdfsam/bin/\nsh run-console.sh "$@"' > /usr/bin/pdfsam-console
            chmod +x /usr/bin/pdfsam-console
        - unless:
            - test -f /usr/bin/pdfsam-console

# TODO: enable when strip-coverletter changes are merged in
#pdfsam-absent:
#    file.absent:
#        - name: /opt/pdfsam
 
# TODO: enable when strip-coverletter changes are merged in       
#pdfsam-exec-absent:
#    file.absent:
#        - name: /usr/bin/pdfsam-console

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
