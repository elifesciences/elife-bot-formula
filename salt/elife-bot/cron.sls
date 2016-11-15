#
# cron jobs
#
elife-bot-cron-file:
    cron.present:
        - identifier: elife-bot-cron
        {% if pillar.elife.newrelic.enabled %}
        - name: NEW_RELIC_CONFIG_FILE=/opt/elife-bot/newrelic.ini /opt/elife-bot/venv/bin/newrelic-admin run-program /opt/elife-bot/venv/bin/python cron.py -e {{ pillar.elife.env }}
        {% else %}
        - name: /opt/elife-bot/venv/bin/python cron.py -e {{ pillar.elife.env }}
        {% endif %}
        - user: {{ pillar.elife.deploy_user.username }}
        - minute: "*/5"
        - require:
            - file: elife-poa-xml-generation-settings # arbitrary
