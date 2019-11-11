# WARNING - this can be a little buggy.
# temporary files accumulate like crazy in production elife-bot
# on AWS we mount the /bot-tmp dir on a separate EBS volume

# dir is a mount point
#- grep -qs '/var/lib/docker/' /proc/mounts

# volume to mount exists and is block special (-b)
#- test -b /dev/xvdh

format-temp-volume:
    cmd.run: 
        - name: mkfs -t ext4 /dev/xvdh
        - onlyif:
            # disk exists
            - test -b /dev/xvdh
        - unless:
            # volume exists and is already formatted
            - file --special-files /dev/xvdh | grep ext4

mount-temp-volume:
    mount.mounted:
        - name: /bot-tmp
        - device: /dev/xvdh
        - fstype: ext4
        - mkmnt: True
        - opts:
            - defaults
        - require:
            - cmd: format-temp-volume
        - onlyif:
            # disk exists
            - test -b /dev/xvdh
        - unless:
            # mount point already has a volume mounted
            - cat /proc/mounts | grep --quiet --no-messages /bot-tmp/

    cmd.run:
        - name: mkdir -p /bot-tmp && chmod -R 777 /bot-tmp
        - require:
            - mount: mount-temp-volume

mount-temp-volume-linked-to-ext:
    # TODO: temporary for the switch, remove after porting
    # all elife-bot instances
    cmd.run:
        - name: |
            set -e
            if systemctl status docker; then
                systemctl stop docker
            fi
            # if it's not a link
            # (meaning it is a directory, and
            # not a link to a directory)
            if [[ ! -L /ext ]]; then
                mv /ext/docker /bot-tmp/docker
                ln -s /bot-tmp/docker /ext/docker
            fi
            # best effort, docker may not be available
            # or already running
            systemctl start docker || true
        - require:
            - cmd: mount-temp-volume

    file.symlink:
        - name: /ext
        - target: /bot-tmp
        - require:
            - cmd: mount-temp-volume-linked-to-ext

