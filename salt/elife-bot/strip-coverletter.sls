#
# strip coverletter
#

install-strip-coverletter:
    git.latest:
        - name: https://github.com/elifesciences/strip-coverletter
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - target: /opt/strip-coverletter
        - force_reset: true

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

strip-coverletter-writeable-work-dir:
    file.directory:
        - name: /bot-tmp/decap
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - onlyif:
            - test -d /bot-tmp

strip-coverletter-docker-image:
    docker_image.present:
        - name: elifesciences/strip-coverletter
        - tag: latest
        - require:
            - docker-ready

strip-coverletter-docker-working:
    cmd.run:
        - runas: {{ pillar.elife.deploy_user.username }}
        - cwd: /opt/strip-coverletter
        - name: ./strip-coverletter-docker.sh /opt/strip-coverletter/dummy.pdf /tmp/dummy.pdf && rm /tmp/dummy.pdf
        - require:
            - strip-coverletter-docker-image
            - strip-coverletter-writeable-work-dir
            - strip-coverletter-docker-writable-dir

# prune content older than 2 months (2 * 28days) in /tmp/decap and /bot-tmp/decap every sunday morning.
prune-strip-coverletter-files:
    # check worker.log every five minutes for activity in the last minute
    cron.present:
        - identifier: prune-decap-work-dir
        - name: find /tmp/decap -maxdepth 1 -type f -mtime +56 -exec rm -r '{}'; /bot-tmp/decap -maxdepth 1 -type f -mtime +56 -exec rm -r '{}'
        - minute: 0
        - hour: 0
        - dayweek: 0
        - require:
            - file: strip-coverletter-writeable-work-dir
