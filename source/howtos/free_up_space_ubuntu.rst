Free up space on Ubuntu
=======================

1. Get rid of packages that are no longer needed

    .. code-block:: sh

        sudo apt-get autoremove


2. Clean up APT cache (downloaded packages)

    .. code-block:: sh

        sudo du -sh /var/cache/apt
        sudo apt-get autoclean
        # or delete entirely
        sudo apt-get clean

3. Clear systemd journal logs more than 3 days old
    
    .. code-block:: sh

        journalctl --disk-usage
        sudo journalctl --vacuum-time=3d

4. Remove docker temprorary images

    .. code-block:: sh

        docker system prune -a





