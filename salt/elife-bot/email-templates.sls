#
# email templates
#

install-email-templates:
    git.latest:
        - name: https://github.com/elifesciences/elife-email-templates
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - target: /opt/elife-email-templates
