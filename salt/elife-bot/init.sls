elife-bot-deps:
    pkg.installed:
        - pkgs:
            - libxml2-dev 
            - libxslt1-dev
            - lzma-dev # provides 'lz' for compiling lxml
            - imagemagick
            - ghostscript
            - libmagickwand-dev
        - require:
            - pkg: python-dev

imagemagick-policy:
    file.managed:
        - name: /etc/ImageMagick-6/policy.xml
        - source: salt://elife-bot/config/etc-ImageMagick-6-policy.xml

elife-bot-repo:    
    builder.git_latest:
        - name: git@github.com:elifesciences/elife-bot.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: {{ salt['elife.cfg']('project.revision', 'project.branch', 'master') }}
        - branch: {{ salt['elife.branch']() }}
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - target: /opt/elife-bot

    file.directory:
        - name: /opt/elife-bot
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user
            - group
        - require:
            - builder: elife-bot-repo

elife-bot-tmp-link:
    file.symlink:
        - name: /opt/elife-bot/tmp
        - target: /bot-tmp
        - require:
            - elife-bot-repo

elife-bot-virtualenv:
    cmd.run:
        - name: ./install.sh
        - cwd: /opt/elife-bot
        - runas: {{ pillar.elife.deploy_user.username }}
        - require:
            # Pillow depends on libjpeg + zlib that imagemagick pulls in
            - elife-bot-deps 
            - elife-bot-repo
            - python-3

elife-bot-settings:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/settings.py
        - source: salt://elife-bot/config/opt-elife-bot-settings.py
        - template: jinja
        - require:
            - elife-bot-repo

elife-bot-crossref-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/crossref.cfg
        - source: salt://elife-bot/config/opt-elife-bot-crossref.cfg
        - require:
            - elife-bot-repo

elife-bot-pubmed-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/pubmed.cfg
        - source: salt://elife-bot/config/opt-elife-bot-pubmed.cfg
        - require:
            - elife-bot-repo

elife-bot-publication_types-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/publication_types.yaml
        - source: salt://elife-bot/config/opt-elife-bot-publication_types.yaml
        - require:
            - elife-bot-repo

elife-bot-jatsgenerator-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/jatsgenerator.cfg
        - source: salt://elife-bot/config/opt-elife-bot-jatsgenerator.cfg
        - require:
            - elife-bot-repo

elife-bot-packagepoa-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/packagepoa.cfg
        - source: salt://elife-bot/config/opt-elife-bot-packagepoa.cfg
        - require:
            - elife-bot-repo

elife-bot-digest-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/digest.cfg
        - source: salt://elife-bot/config/opt-elife-bot-digest.cfg
        - template: jinja
        - require:
            - elife-bot-repo

elife-bot-letterparser-cfg:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-bot/letterparser.cfg
        - source: salt://elife-bot/config/opt-elife-bot-letterparser.cfg
        - template: jinja
        - require:
            - elife-bot-repo

elife-email-templates-repo:
    builder.git_latest:
        - name: git@github.com:elifesciences/elife-email-templates.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: master
        - branch: master
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - target: /opt/elife-email-templates

#
# clean up the temporary files that accumulate
#

elife-bot-temporary-files-cleaner:
    # 2am, every day
    cron.present:
        - identifier: temp-files-cleaner
        - name: find /bot-tmp -maxdepth 1 -type d -name '20*' -mtime +{{ pillar.elife_bot.temporary_files_cleaner.days }} -exec rm -r '{}' \; 2>&1 | tee -a /tmp/elife-bot-temporary-files-cleaner.log
        - minute: random
        - hour: '*'


# WARNING - this can be a little buggy.
# temporary files accumulate like crazy in production elife-bot
# on AWS we mount the /bot-tmp dir on a separate EBS volume

# dir is a mount point
#- grep -qs '/var/lib/docker/' /proc/mounts

# volume to mount exists and is block special (-b)
#- test -b /dev/xvdh

format-temp-volume:
    cmd.run: 
        - name: mkfs -t ext4 /dev/xvdh
        - onlyif:
            # disk exists
            - test -b /dev/xvdh
        - unless:
            # volume exists and is already formatted
            - file --special-files /dev/xvdh | grep ext4

mount-temp-volume:
    mount.mounted:
        - name: /bot-tmp
        - device: /dev/xvdh
        - fstype: ext4
        - mkmnt: True
        - opts:
            - defaults
        - require:
            - cmd: format-temp-volume
        - onlyif:
            # disk exists
            - test -b /dev/xvdh
        - unless:
            # mount point already has a volume mounted
            - cat /proc/mounts | grep --quiet --no-messages /bot-tmp/

    cmd.run:
        - name: mkdir -p /bot-tmp && chmod -R 777 /bot-tmp
        - require:
            - mount: mount-temp-volume

elife-bot-log-files:
    cmd.run:
        - name: chown -f {{ pillar.elife.deploy_user.username }}:{{ pillar.elife.deploy_user.username }} *.log || true
        - cwd: /opt/elife-bot
        - require:
            - elife-bot-repo

    file.managed:
        - name: /etc/logrotate.d/elife-bot
        - source: salt://elife-bot/config/etc-logrotate.d-elife-bot

app-done:
    cmd.run: 
        - name: echo "app is done installing"
        - require:
            - file: elife-bot-settings
            - service: redis-server
            - file: elife-bot-tmp-link
            - elife-bot-virtualenv
            - cmd: mount-temp-volume
            - cmd: elife-bot-log-files

{% set stack_name = salt['elife.cfg']('cfn.stack_name') %}

register-swf:
    cmd.run:
        {% if salt['elife.only_on_aws']() %}
        - name: venv/bin/python register.py -e {{ pillar.elife.env }}
        {% else %}
        - name: echo "register.py cannot run locally as it requires AWS credentials"
        {% endif %}
        - runas: {{ pillar.elife.deploy_user.username }}
        - cwd: /opt/elife-bot
        - require:
            - cmd: app-done

elife-bot-gcp-credentials:
    file.managed:
        - name: /etc/gcp-credentials.json
        - contents: '{{ pillar.elife_bot.gcp.credentials_json }}'

elife-bot-gcp-credentials-environment-variables:
    file.managed:
        - name: /etc/profile.d/elife-bot-gcp-credentials.sh
        - contents: |
            export GOOGLE_APPLICATION_CREDENTIALS=/etc/gcp-credentials.json
        - require:
            - elife-bot-gcp-credentials

worker-log-modified:
    file.managed:
        - name: /usr/bin/check-file-for-modification.sh
        - source: salt://elife-bot/config/usr-bin-check-file-for-modification.sh
        - mode: 755
    
    # check worker.log every five minutes for activity in the last minute
    cron.present:
        - identifier: worker-log-modified-checker
        - name: /usr/bin/check-file-for-modification.sh /opt/elife-bot/worker.log 60
        - minute: "*/5"
        - require:
            - file: worker-log-modified
