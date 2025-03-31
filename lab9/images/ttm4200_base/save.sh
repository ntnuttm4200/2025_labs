if command -v vtysh > /dev/null 2>&1; then
    echo "Saving vtysh configuration..."
    if ! sudo vtysh -w > /dev/null 2> vtysh_error.log; then
        echo "Failed to save vtysh configuration. Error:"
        cat vtysh_error.log
    else
        echo "vtysh configuration saved."
    fi
    rm -f vtysh_error.log
fi

if command -v nft > /dev/null 2>&1; then
    echo "Saving nftables ruleset..."
    if ! sudo nft list ruleset | sudo tee /etc/nftables.conf > /dev/null 2> nft_error.log; then
        echo "Failed to save nftables ruleset. Error:"
        cat nft_error.log
    else
        echo "nftables ruleset saved."
    fi
    rm -f nft_error.log
fi