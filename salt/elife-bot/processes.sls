
# these are the states multiservice.sls depends on
# we can use it to make sure other states are executed before the service is started/restarted
{% for process in pillar.elife.multiservice.services %}
elife-bot-{{ process }}-service:
    file.managed:
        - name: /lib/systemd/system/{{ process }}@.service
        - source: salt://elife-bot/templates/lib-systemd-system-botprocess@.service
        - template: jinja
        - context:
            process: {{ process }}
        - require:
            - cmd: register-swf
{% endfor %}

{% if "worker" in pillar.elife.multiservice.services %}
backup-script:
    file.managed:
        - name: /usr/bin/backup.sh
        - source: salt://elife-bot/config/usr-bin-backup.sh
        - mode: 754
        - require_in:
            - elife-bot-worker-service
{% endif %}
