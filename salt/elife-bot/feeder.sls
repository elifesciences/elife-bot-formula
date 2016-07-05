ppp-feeder:
    file.directory:
        - user: {{ pillar.elife.deploy_user.username }}
        - group: {{ pillar.elife.deploy_user.username }}
        - name: /opt/ppp-feeder

    git.latest:
        - user: {{ pillar.elife.deploy_user.username }}
        - name: https://github.com/elifesciences/ppp-feeder
        - target: /opt/ppp-feeder
        - require:
            - file: ppp-feeder

ppp-feeder-config:
    cmd.run:
        - cwd: /opt/ppp-feeder
        - name: ./install.sh
        - require:
            - git: ppp-feeder
