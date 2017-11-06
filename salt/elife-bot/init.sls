elife-bot-deps:
    pkg.installed:
        - pkgs:
            - libxml2-dev 
            - libxslt-dev
            - lzma-dev # provides 'lz' for compiling lxml
            - imagemagick
            - libmagickwand-dev
        - require:
            - pkg: python-dev

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
        - user: {{ pillar.elife.deploy_user.username }}
        - require:
            - elife-bot-repo
            - pkg: python-pip

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

#
#
#

elife-poa-xml-generation-repo:
    git.latest:
        - name: https://github.com/elifesciences/elife-poa-xml-generation
        - rev: master
        - branch: master
        - target: /opt/elife-poa-xml-generation
        - force_fetch: True
        - force_checkout: True
        - force_reset: True

    file.directory:
        - name: /opt/elife-poa-xml-generation
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - recurse:
            - user
            - group
        - require:
            - git: elife-poa-xml-generation-repo

    cmd.run:
        - name: ./pin.sh /opt/elife-bot/elife-poa-xml-generation.sha1
        - user: {{ pillar.elife.deploy_user.username }}
        - cwd: /opt/elife-poa-xml-generation
        - require:
            - file: elife-poa-xml-generation-repo

elife-poa-xml-generation-settings:
    file.managed:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: /opt/elife-poa-xml-generation/settings.py
        - source: salt://elife-bot/config/opt-elife-poa-xml-generation-settings.py
        - require:
            - elife-poa-xml-generation-repo

#
# strip coverletter
#

strip-coverletter-deps:
    pkg.installed:
        - pkgs:
            - xpdf-utils

    archive.extracted:
        - name: /opt/pdfsam/
        - source: https://github.com/torakiki/pdfsam-v2/releases/download/v2.2.4/pdfsam-2.2.4-out.zip
        - archive_format: zip
        - source_hash: md5=29ab520b1bf453af7394760b66d43453
        - unless:
            - test -d /opt/pdfsam/

    cmd.run:
        - name: |
            echo -e '#!/bin/bash\ncd /opt/pdfsam/bin/\nsh run-console.sh "$@"' > /usr/bin/pdfsam-console
            chmod +x /usr/bin/pdfsam-console
        - unless:
            - test -f /usr/bin/pdfsam-console

install-strip-coverletter:
    git.latest:
        - name: https://github.com/elifesciences/strip-coverletter
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - target: /opt/strip-coverletter

#
# clean up the temporary files that accumulate
#

elife-bot-temporary-files-cleaner:
    file.managed:
        - name: /opt/rmrf_enter/elife-bot.py
        - source: salt://elife-bot/config/opt-rmrf_enter-elife-bot.py
        - template: jinja
        - makedirs: True
        - require:
            - pip: global-python-requisites

    # 2am, every day
    cron.present:
        - identifier: temp-files-cleaner
        - name: python /opt/rmrf_enter/elife-bot.py > /dev/null
        - minute: random
        - hour: '*'
        - require:
            - file: elife-bot-temporary-files-cleaner


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
        {% if stack_name != 'elife-bot--silent-corrections' %}
        - name: venv/bin/python register.py -e {{ pillar.elife.env }}
        {% else %}
        - name: echo "register.py should not run on this old branch"
        {% endif %}
        - user: {{ pillar.elife.deploy_user.username }}
        - cwd: /opt/elife-bot
        - require:
            - cmd: app-done


{% set processes = ['decider', 'worker', 'queue_worker', 'queue_workflow_starter', 'shimmy', 'lax_response_adapter'] %}
{% for process in processes %}
elife-bot-{{ process }}-service:
    file.managed:
        - name: /etc/init/elife-bot-{{ process }}.conf
        - source: salt://elife-bot/config/etc-init-elife-bot-process.conf
        - template: jinja
        - context:
            process: {{ process }}
        - require:
            - cmd: register-swf
{% endfor %}

