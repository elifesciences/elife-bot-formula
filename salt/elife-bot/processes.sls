{% set processes = ['decider', 'worker', 'queue_worker', 'queue_workflow_starter', 'shimmy', 'lax_response_adapter'] %}
{% for process in processes %}
elife-bot-{{ process }}s-start:
    cmd.run:
        - name: start elife-bot-{{ process }}s
        - require:
            - file: elife-bot-{{ process }}s-task
        - watch:
            - elife-bot-repo
{% endfor %}
