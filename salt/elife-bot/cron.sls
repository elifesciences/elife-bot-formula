#
# cron jobs
#

elife-bot-cron-file:
    cron.present:
        - identifier: elife-bot-cron
        - name: cd /opt/elife-bot && venv/bin/python cron.py -e {{ pillar.elife.env }} >> /tmp/elife-bot-cron.log
        - user: {{ pillar.elife.deploy_user.username }}
        - minute: "*/5"
