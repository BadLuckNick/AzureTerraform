Azure Policy uses ARM aliases to determine the availability of the Private Link. Private Link hooks into a specific Storage Account service (like Blob, Table, dfs) on the service specific level.
This means this Policy will audit the 'Status' of a Private Link on the Storage Account, but not it being connected to each specific service. This is something I'm still looking into.
To use this properly, separate Storage Accounts based on service usage, then this will work like a charm :).
