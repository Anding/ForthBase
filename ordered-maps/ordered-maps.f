\ a proposal for simplified ordered maps

1024 value ordered-map.max-records

BEGIN-STRUCTURE ordered-map.record
    4   +FIELD ordered-map.key-hash     \ hashS of UPPERCASE(key) - never 0 for a valid key
    124 +FIELD ordered-map.key          \ a counted string
    256 +FIELD ordered-map.value        \ a counted string
END-STRUCTURE

: allocate-map ( -- ref | 0)
\ allocate memory for a new map of max-records and return the reference 
    ordered-map.max-records ordered-map.record * allocate
;

: free-map ( --)
\ free an map - no checks are made to ensure this was a valid map
    free
;

