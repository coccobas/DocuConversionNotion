Free up space on Ubuntu
=======================

1. Get rid of packages that are no longer needed

    ..code-block: bash

        sudo apt-get autoremove

1. Clean up APT cache (downloaded packages)

    ..code-block: bash

        sudo du -sh /var/cache/apt
        sudo apt-get autoclean
        # or delete entirely
        sudo apt-get clean

1. Clear systemd journal logs
    
    ..code-block: bash

        journalctl --disk-usage
        sudo journalctl --vacuum-time=3d

1. Remove docker temprorary images

    ..code-block: bash

        docker system prune -a





