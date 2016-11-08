newrelic-license-configuration:
    cmd.run:
        - name: venv/bin/newrelic-admin generate-config {{ pillar.elife.newrelic.license }} newrelic.ini
        - cwd: /opt/elife-bot
        - user: {{ pillar.elife.deploy_user.username }}
        - require: 
            - elife-bot-virtualenv

newrelic-ini-configuration-appname:
    file.replace:
        - name: /opt/elife-bot/newrelic.ini
        - pattern: '^app_name.*'
        - repl: app_name = {{ salt['elife.cfg']('project.stackname', 'cfn.stack_id', 'Python application') }}
        - require:
            - newrelic-license-configuration

newrelic-ini-configuration-logfile:
    file.replace:
        - name: /opt/elife-bot/newrelic.ini
        - pattern: '^#?log_file.*'
        - repl: log_file = /tmp/newrelic-python-agent.log
        - require:
            - newrelic-license-configuration

