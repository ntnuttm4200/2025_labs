#!/bin/bash
if [ -f "/usr/bin/startup.sh" ]; then
    chmod +x /usr/bin/startup.sh
    /usr/bin/startup.sh
    /bin/bash
fi
