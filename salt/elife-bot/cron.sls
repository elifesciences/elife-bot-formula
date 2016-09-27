#
# cron jobs
#
elife-bot-cron-file:
    cron.present:
        - identifier: elife-bot-cron
        - name: cd /opt/elife-bot && /opt/elife-bot/scripts/run_cron_env.sh {{ pillar.elife.env }}
        - user: {{ pillar.elife.deploy_user.username }}
        - minute: "*/5"
        - require:
            - file: elife-poa-xml-generation-settings # arbitrary
