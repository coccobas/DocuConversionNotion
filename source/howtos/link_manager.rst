Set up Link Manager on a drone
==============================

Overview
--------
The Link Manager coordinates network connectivity on the drone across multiple interfaces (e.g. Wi‑Fi, LTE) and selects the best available uplink based on health and priority. Configuration lives in Redis under the namespace ``root:link_manager``.

What you need
-------------
- Drone IP address and access to Redis UI (``http://<drone-ip>:7843``).
- SSH access to the drone shell for discovering interface names.
- The names of the network interfaces that should be managed (e.g. ``eth0``, ``wlan0``, ``wwan0``, ``enx…``).


Set up on a new drone
---------------------
1) Identify interfaces
   - SSH to the drone and run ``ip -br link``. Note the names to be managed (e.g. ``eth0``, ``wlan0``, ``wwan0``).

2) Fill Redis configuration
   - Open Redis UI at ``http://<drone-ip>:7843``.
   - Under ``root:link_manager``, check the keys (``ping_count``, ``ping_interval``, ``max_rtt_ms``, ``max_loss_pct``, ``switching_hysteresis_ms``, ``vpn_route_metric``, ``default_route_metric``, ``vpn_server``). Normally these defaults do not need changing.
   - Set ``network_adapters`` to a JSON array listing each uplink with its ``type``, ``interface`` names, and ``ping`` target.

3) Apply and verify
   - Reboot the drone or restart link_manager container.
   - Check BeagleGroundControl UI for current link status and metrics. Check if link switching works in BGC.
   - Force test: disconnect the preferred link and confirm automatic failover to the next healthy interface; reconnect and ensure it switches back.

Redis keys used by Link Manager
-------------------------------
All keys below are under the ``root:link_manager`` namespace in Redis UI. Example: ``root:link_manager:ping_count``.

- ``ping_count`` (int): How many ICMP echo requests to send per cycle.
- ``ping_interval`` (float, seconds): Interval between evaluation cycles. Each cycle runs ``fping`` with ``-C <ping_count>``.
- ``max_rtt_ms`` (int): Maximum acceptable round‑trip time in milliseconds. Exceeded RTT contributes to a degraded/unhealthy decision.
- ``max_loss_pct`` (int, percent): Maximum acceptable packet loss over the probe window before the link is treated as unhealthy.
- ``switching_hysteresis_ms`` (int, milliseconds): Minimum ping difference between links before switching happens. Increase if you see frequent toggling, decrease to make switching more sensitive.
- ``vpn_route_metric`` (int): Route metric to apply when routing through the VPN interface. Lower metrics are preferred by the kernel.
- ``default_route_metric`` (int): Route metric for non‑VPN uplinks.
- ``vpn_server`` (string): IP/hostname of the VPN server used by the drone.
- ``network_adapters`` (JSON array): List of managed uplinks with their interface names and probe target.
  - Each entry:
    - ``type``: ``cellular`` | ``wifi`` | ``ethernet`` (as applicable).
    - ``interface``: array of kernel interface names for this uplink, e.g. ``["eth1"]`` or ``["enx00e04c68020a"]``. Use the exact names from ``ip -br link``.
    - ``ping``: IP/host to probe for this uplink’s health, e.g. ``"8.8.8.8"``.

Example values
--------------
Set the following keys in Redis UI under ``root:link_manager``. For ``network_adapters``, paste the JSON array as the value.

.. code-block:: text

   # Scalars
   root:link_manager:ping_count              = 10
   root:link_manager:ping_interval           = 0.5
   root:link_manager:max_rtt_ms              = 250
   root:link_manager:max_loss_pct            = 50
   root:link_manager:switching_hysteresis_ms = 20
   root:link_manager:vpn_route_metric        = 5
   root:link_manager:default_route_metric    = 50
   root:link_manager:vpn_server              = 3.124.171.78

   # Array (JSON)
   root:link_manager:network_adapters = [
     { "type": "cellular", "interface": ["eth1"],  "ping": "8.8.8.8" },
     { "type": "wifi",     "interface": ["wlan0"], "ping": "8.8.8.8" }
   ]
