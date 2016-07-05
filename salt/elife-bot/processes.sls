{% set processes = ['decider', 'worker', 'queue_worker', 'queue_workflow_starter', 'shimmy'] %}
{% for process in processes %}
elife-bot-{{ process }}s-start:
    cmd.run:
        - name: start elife-bot-{{ process }}s
        - require:
            - file: elife-bot-{{ process }}s-task
        - watch:
            - git: elife-bot-repo
{% endfor %}
