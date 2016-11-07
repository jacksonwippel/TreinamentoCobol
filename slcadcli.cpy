             select clientes assign to "clientes.dat"
             organization is indexed
             access mode is dynamic
             record key is codigo
             lock mode       is manual with lock on multiple record
             alternate key is nome with duplicates
             file status is fs-clientes.

