Azure Policy uses ARM aliases to determine the availability of the Private Link. Private Link hooks into a specific Storage Account service (like Blob, Table, dfs).
This means this Policy will audit the 'Status' of a Private Link, but not it being connected to each service. This is something I'm still looking into.
To use this properly, determine Storage Accounts based on service usage.
