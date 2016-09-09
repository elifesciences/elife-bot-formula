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

{% set processes = ['decider', 'worker', 'queue_worker', 'queue_workflow_starter', 'shimmy'] %}
{% for process in processes %}
elife-bot-{{ process }}s-start:
    cmd.run:
        - name: start elife-bot-{{ process }}s
        - require:
            - file: elife-bot-{{ process }}s-task
        - watch:
            - elife-bot-repo
{% endfor %}
