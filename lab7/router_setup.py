from subprocess import run

routes = {
    "router0": [
        "ip route add 129.168.1.8/29 via 129.168.1.3",
        "ip route add 129.168.1.16/29 via 129.168.1.3",
    ],
    "router1": [
        "ip route add 129.168.1.16/29 via 129.168.1.11",
        "ip route add 129.168.1.0/29 via 129.168.1.11",
        "ip route add 129.100.1.0/29 via 129.168.1.11",
    ],
    "router2": [
        "ip route add 129.100.1.0/29 via 129.168.1.19",
        "ip route add 129.168.1.0/29 via 129.168.1.19",
        "ip route add 129.168.1.24/29 via 129.168.1.19",
        "ip route add 129.168.1.8/29 via 129.168.1.19",
    ],
    "router3": [
        "ip route add 129.100.1.0/29 via 129.168.1.2",
        "ip route add 129.100.1.24/29 via 129.168.1.2",
    ]
}

def get_container_name(container: str):
    return run("docker ps --format 'table {{.Image}}\t{{.Names}}' | grep " + container + " | awk '{print $2}'", shell=True, text=True, capture_output=True).stdout.strip()

def setup_static_routes():
    for router, cmds in routes.items():
        container = get_container_name(router)

        if not container:
            print(f"Container {router} not found")
            continue
        
        for cmd in cmds:
            route = cmd.replace("ip route add", "").strip()

            # Check if the route already exists
            check_cmd = f"docker exec {container} sh -c 'ip route show | grep \"{route}\"'"
            check_result = run(check_cmd, shell=True, text=True, capture_output=True)

            if check_result.returncode == 0:
                print(f"Skipping {route} on {router}, already configured.")
                continue

            # Add route if it doesn't exist
            result = run(f"docker exec {container} sh -c '{cmd}'", shell=True)

            if result.returncode == 0:
                print(f"Added {route} on {router}")
            else:
                print(f"Failed to add {route} on {router}")

if __name__ == "__main__":
    setup_static_routes()