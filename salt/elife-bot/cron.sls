#
# cron jobs
#
elife-bot-cron-env:
    cron.env_present:
        - name: NEW_RELIC_CONFIG_FILE
        - user: {{ pillar.elife.deploy_user.username }}
        - value: /opt/elife-bot/newrelic.ini

elife-bot-cron-file:
    cron.present:
        - identifier: elife-bot-cron
        {% if pillar.elife.newrelic.enabled %}
        - name: /opt/elife-bot/venv/bin/newrelic-admin run-program /opt/elife-bot/venv/bin/python cron.py -e {{ pillar.elife.env }} >> /tmp/elife-bot-cron.log
        {% else %}
        - name: /opt/elife-bot/venv/bin/python cron.py -e {{ pillar.elife.env }} >> /tmp/elife-bot-cron.log
        {% endif %}
        - user: {{ pillar.elife.deploy_user.username }}
        - minute: "*/5"
        - require:
            - elife-bot-cron-env
            - file: elife-poa-xml-generation-settings # arbitrary
