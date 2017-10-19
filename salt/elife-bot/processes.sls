{% if pillar.elife.env == 'end2end' %}
{% set processes = {'elife-bot-decider': 5, 'elife-bot-worker': 10, 'elife-bot-queue_worker': 5, 'elife-bot-queue_workflow_starter': 5, 'elife-bot-shimmy': 1, 'elife-bot-lax_response_adapter': 2} %}
{% else %}
{% set processes = {'elife-bot-decider': 3, 'elife-bot-worker': 5, 'elife-bot-queue_worker': 3, 'elife-bot-queue_workflow_starter': 5, 'elife-bot-shimmy': 1, 'elife-bot-lax_response_adapter': 1} %}
{% endif %}

{% for process, number in processes.iteritems() %}
{{process}}-old-restart-tasks:
    file.absent:
        - name: /etc/init/{{ process }}s.conf
{% endfor %}

elife-bot-processes-task:
    file.managed:
        - name: /etc/init/elife-bot-processes.conf
        - source: salt://elife/config/etc-init-multiple-processes-parallel.conf
        - template: jinja
        - context:
            processes: {{ processes }}
            # ResizeImages and other activities run for a very long time
            timeout: 300
        - require:
            {% for process, _number in processes.iteritems() %}
            - file: {{ process }}-service
            {% endfor %}

elife-bot-processes-start:
    cmd.run:
        - name: start elife-bot-processes
        - require:
            - elife-bot-processes-task
        - watch:
            - elife-bot-repo
        - listen:
            - newrelic-ini-configuration-appname
            - newrelic-ini-configuration-logfile
