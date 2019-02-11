iw macro op,reg,count
 local fbyte,cbyte
fbyte:
     op reg,1
cbyte:
     org cs:fbyte
     db 0c1h
     org cs:cbyte
     db count
     endm

ib macro op,reg,count
 local fbyte,cbyte
fbyte:
     op reg,1
cbyte:
     org cs:fbyte
     db 0c0h
     org cs:cbyte
     db count
     endm

