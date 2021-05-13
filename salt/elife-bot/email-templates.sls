#
# email templates
#

install-email-templates:
    builder.git_latest:
        - name: git@github.com:elifesciences/elife-email-templates.git
        - identity: {{ pillar.elife.projects_builder.key or '' }}
        - rev: {{ salt['elife.cfg']('project.revision', 'project.branch', 'master') }}
        - branch: {{ salt['elife.branch']() }}
        - force_fetch: True
        - force_checkout: True
        - force_reset: True
        - target: /opt/elife-email-templates
