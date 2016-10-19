{% set processes = {'decider': 3, 'worker': 5, 'queue_worker': 3, 'queue_workflow_starter': 5, 'shimmy': 1, 'lax_response_adapter': 1} %}
{% for process, number in processes.iteritems() %}
elife-bot-{{ process }}s-task:
    file.managed:
        - name: /etc/init/elife-bot-{{ process }}s.conf
        - source: salt://elife/config/etc-init-multiple-processes.conf
        - template: jinja
        - context:
            process: elife-bot-{{ process }}
            number: {{ number }}
        - require:
            - file: elife-bot-{{ process }}-service

elife-bot-{{ process }}s-start:
    cmd.run:
        - name: start elife-bot-{{ process }}s
        - require:
            - file: elife-bot-{{ process }}s-task
        - watch:
            - elife-bot-repo
{% endfor %}
