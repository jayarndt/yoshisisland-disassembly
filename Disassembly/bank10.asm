org $108000

    PHB                 ; $108000   |
    PHK                 ; $108001   |
    PLB                 ; $108002   |
    REP #$20            ; $108003   |
    LDX #$04            ; $108005   | \

CODE_108007:
    JSR CODE_108018     ; $108007   |  |
    DEX                 ; $10800A   |  | check checksums loop
    DEX                 ; $10800B   |  |
    BPL CODE_108007     ; $10800C   | /
    SEP #$20            ; $10800E   |
    PLB                 ; $108010   |
    RTL                 ; $108011   |

DATA_108012:        dw $7C00, $7C68, $7CD0


CODE_108018:
    STX $0E             ; $108018   |  store save file number
    LDA $8012,x         ; $10801A   | \
    STA $3014           ; $10801D   | / load high score table index into r10
    LDX #$08            ; $108020   | \
    LDA #$DE83          ; $108022   |  | generate checksum
    JSL $7EDE44         ; $108025   | / GSU init

    LDX $0E             ; $108029   |  load save file
    LDA $3000           ; $10802B   | \
    CMP $707E70,x       ; $10802E   |  | check if checksum is correct
    BEQ CODE_108039     ; $108032   | / return if it is
    JSR CODE_1080A8     ; $108034   |  if not, double-check checksum with the table copy
    BRA CODE_108018     ; $108037   |  generate new checksum


CODE_108039:
    RTS                 ; $108039   |  return

DATA_10803A:        dw $7D38, $7DA0, $7E08

; initialization state for high scores saved in sram
DATA_108040:         dw $0003, $0080, $0000, $0000
DATA_108048:         dw $0000, $0000, $8000, $0080
DATA_108050:         dw $0000, $0000, $0000, $0000
DATA_108058:         dw $8000, $0080, $0000, $0000
DATA_108060:         dw $0000, $0000, $8000, $0080
DATA_108068:         dw $0000, $0000, $0000, $0000
DATA_108070:         dw $8000, $0080, $0000, $0000
DATA_108078:         dw $0000, $0000, $8000, $0080
DATA_108080:         dw $0000, $0000, $0000, $0000
DATA_108088:         dw $8000, $0080, $0000, $0000
DATA_108090:         dw $0000, $0000, $0000, $0000
DATA_108098:         dw $0000, $0000, $0000, $0000
DATA_1080A0:         dw $0000, $0000, $0000, $0000


CODE_1080A8:
    LDA $803A,x         ; $1080A8   | \ load high score table copy into r10
    STA $3014           ; $1080AB   | /
    LDX #$08            ; $1080AE   | \
    LDA #$DE83          ; $1080B0   |  | generate checksum
    JSL $7EDE44         ; $1080B3   | / GSU init

    LDX $0E             ; $1080B7   |  load save file
    LDA $3000           ; $1080B9   | \
    CMP $707E76,x       ; $1080BC   |  | check if checksum is correct
    BEQ CODE_1080EB     ; $1080C0   | / branch if it is

    LDA #$8040          ; $1080C2   | \
    STA $3002           ; $1080C5   |  |
    LDA #$0010          ; $1080C8   |  |
    AND #$00FF          ; $1080CB   |  |
    STA $3004           ; $1080CE   |  | clears high scores and generates a new checksum
    LDA $803A,x         ; $1080D1   |  |
    STA $3014           ; $1080D4   |  |
    LDX #$08            ; $1080D7   |  |
    LDA #$DE59          ; $1080D9   |  |
    JSL $7EDE44         ; $1080DC   | / GSU init

    LDX $0E             ; $1080E0   |  load save file
    LDA $3000           ; $1080E2   | \
    STA $707E76,x       ; $1080E5   | / store new checksum
    BRA CODE_1080A8     ; $1080E9   |  check checksum again


CODE_1080EB:
    LDA $803A,x         ; $1080EB   | \
    STA $3002           ; $1080EE   |  |
    LDA $8012,x         ; $1080F1   |  | copy the high score table and generate a new checksum
    STA $3014           ; $1080F4   |  |
    LDX #$08            ; $1080F7   |  |
    LDA #$DE73          ; $1080F9   |  |
    JSL $7EDE44         ; $1080FC   | / GSU init

    LDX $0E             ; $108100   |  load save file
    LDA $3000           ; $108102   | \
    STA $707E70,x       ; $108105   | / store new checksum
    RTS                 ; $108109   |

    PHB                 ; $10810A   |
    PHK                 ; $10810B   |
    PLB                 ; $10810C   |
    LDA #$70            ; $10810D   |
    STA $02             ; $10810F   |
    STA $05             ; $108111   |
    LDX $030E           ; $108113   |
    REP #$20            ; $108116   |
    PHX                 ; $108118   |
    JSR CODE_108018     ; $108119   |
    PLX                 ; $10811C   |
    LDA $8012,x         ; $10811D   |
    STA $00             ; $108120   |
    SEP #$20            ; $108122   |
    LDA [$00]           ; $108124   |
    STA $0379           ; $108126   |
    REP #$20            ; $108129   |
    INC $00             ; $10812B   |
    INC $00             ; $10812D   |
    SEP #$20            ; $10812F   |
    LDY #$00            ; $108131   |
    LDA [$00]           ; $108133   |
    STA $021A           ; $108135   |
    AND #$7F            ; $108138   |

CODE_10813A:
    CMP #$0C            ; $10813A   |
    BCC CODE_108144     ; $10813C   |
    SBC #$0C            ; $10813E   |
    INY                 ; $108140   |
    INY                 ; $108141   |
    BRA CODE_10813A     ; $108142   |

CODE_108144:
    STA $1112           ; $108144   |
    STY $0218           ; $108147   |
    REP #$20            ; $10814A   |
    INC $00             ; $10814C   |
    SEP #$20            ; $10814E   |
    LDY #$00            ; $108150   |

CODE_108152:
    LDA [$00]           ; $108152   |
    PHA                 ; $108154   |
    AND #$7F            ; $108155   |
    STA $02B8,y         ; $108157   |
    LDA #$00            ; $10815A   |
    STA $0222,y         ; $10815C   |
    PLA                 ; $10815F   |
    AND #$80            ; $108160   |
    BEQ CODE_108169     ; $108162   |
    LDA #$01            ; $108164   |
    STA $0222,y         ; $108166   |

CODE_108169:
    REP #$20            ; $108169   |
    INC $00             ; $10816B   |
    SEP #$20            ; $10816D   |
    INY                 ; $10816F   |
    CPY #$48            ; $108170   |
    BCC CODE_108152     ; $108172   |
    LDA $021A           ; $108174   |
    AND #$7F            ; $108177   |
    TAY                 ; $108179   |
    CPY #$35            ; $10817A   |
    BCC CODE_108183     ; $10817C   |
    LDA $02B8,y         ; $10817E   |
    BNE CODE_108188     ; $108181   |

CODE_108183:
    LDA #$80            ; $108183   |
    STA $0222,y         ; $108185   |

CODE_108188:
    LDY #$00            ; $108188   |
    STZ $04             ; $10818A   |
    INC $04             ; $10818C   |

CODE_10818E:
    LDA $0222,y         ; $10818E   |
    BEQ CODE_1081A3     ; $108191   |
    TYA                 ; $108193   |
    ASL A               ; $108194   |
    TAX                 ; $108195   |
    REP #$20            ; $108196   |
    LDA $81E9,x         ; $108198   |
    STA $10             ; $10819B   |
    SEP #$20            ; $10819D   |
    LDA $04             ; $10819F   |
    STA ($10)           ; $1081A1   |

CODE_1081A3:
    LDA $04             ; $1081A3   |
    INC A               ; $1081A5   |
    CMP #$0D            ; $1081A6   |
    BCC CODE_1081AC     ; $1081A8   |
    LDA #$01            ; $1081AA   |

CODE_1081AC:
    STA $04             ; $1081AC   |
    INY                 ; $1081AE   |
    CPY #$48            ; $1081AF   |
    BCC CODE_10818E     ; $1081B1   |
    LDY #$00            ; $1081B3   |

CODE_1081B5:
    LDA [$00]           ; $1081B5   |
    STA $0357,y         ; $1081B7   |
    REP #$20            ; $1081BA   |
    INC $00             ; $1081BC   |
    SEP #$20            ; $1081BE   |
    INY                 ; $1081C0   |
    CPY #$1B            ; $1081C1   |
    BCC CODE_1081B5     ; $1081C3   |
    REP #$20            ; $1081C5   |
    LDA [$00]           ; $1081C7   |
    AND #$00FF          ; $1081C9   |
    STA $6082           ; $1081CC   |
    INC $00             ; $1081CF   |
    LDA [$00]           ; $1081D1   |
    AND #$00FF          ; $1081D3   |
    STA $0372           ; $1081D6   |
    SEP #$20            ; $1081D9   |
    PLB                 ; $1081DB   |
    RTL                 ; $1081DC   |

DATA_1081DD:         dw $81E9
DATA_1081DF:         dw $8201
DATA_1081E1:         dw $8219
DATA_1081E3:         dw $8231
DATA_1081E5:         dw $8249
DATA_1081E7:         dw $8261

DATA_1081E9:         dw $030F, $0310, $0311, $0312
DATA_1081F1:         dw $0313, $0314, $0315, $0316
DATA_1081F9:         dw $0317, $0318, $0319, $031A

DATA_108201:         dw $031B, $031C, $031D, $031E
DATA_108209:         dw $031F, $0320, $0321, $0322
DATA_108211:         dw $0323, $0324, $0325, $0326

DATA_108219:         dw $0327, $0328, $0329, $032A
DATA_108221:         dw $032B, $032C, $032D, $032E
DATA_108229:         dw $032F, $0330, $0331, $0332

DATA_108231:         dw $0333, $0334, $0335, $0336
DATA_108239:         dw $0337, $0338, $0339, $033A
DATA_108241:         dw $033B, $033C, $033D, $033E

DATA_108249:         dw $033F, $0340, $0341, $0342
DATA_108251:         dw $0343, $0344, $0345, $0346
DATA_108259:         dw $0347, $0348, $0349, $034A

DATA_108261:         dw $034B, $034C, $034D, $034E
DATA_108269:         dw $034F, $0350, $0351, $0352
DATA_108271:         dw $0353, $0354, $0355, $0356

    PHB                 ; $108279   |
    PHK                 ; $10827A   |
    PLB                 ; $10827B   |
    LDA #$70            ; $10827C   |
    STA $02             ; $10827E   |
    REP #$20            ; $108280   |
    LDA $030E           ; $108282   |
    AND #$00FF          ; $108285   |
    TAX                 ; $108288   |
    LDA $8012,x         ; $108289   |
    STA $00             ; $10828C   |
    LDA $0379           ; $10828E   |
    STA [$00]           ; $108291   |
    INC $0000           ; $108293   |
    INC $0000           ; $108296   |
    LDA $1135           ; $108299   |
    AND #$007F          ; $10829C   |
    BNE CODE_1082AF     ; $10829F   |
    LDY $021A           ; $1082A1   |
    LDA $0222,y         ; $1082A4   |
    AND #$000F          ; $1082A7   |
    BNE CODE_1082AF     ; $1082AA   |
    TYA                 ; $1082AC   |
    STA [$00]           ; $1082AD   |

CODE_1082AF:
    INC $00             ; $1082AF   |
    SEP #$20            ; $1082B1   |

; high score sram save loop
    LDY #$00            ; $1082B3   |

CODE_1082B5:
    LDA $0222,y         ; $1082B5   |\
    AND #$01            ; $1082B8   | | branch if you've beaten the level

    BEQ CODE_1082C3     ; $1082BA   |/
    LDA $02B8,y         ; $1082BC   |\
    ORA #$80            ; $1082BF   | | sets the high bit of the high score address to indicate the level has been beaten
    STA [$00]           ; $1082C1   |/ store high score for the level in RAM

CODE_1082C3:
    REP #$20            ; $1082C3   |
    INC $00             ; $1082C5   |
    SEP #$20            ; $1082C7   |
    INY                 ; $1082C9   |
    CPY #$48            ; $1082CA   |
    BCC CODE_1082B5     ; $1082CC   |

; bonus item sram save loop
    LDY #$00            ; $1082CE   |\

CODE_1082D0:
    LDA $0357,y         ; $1082D0   | |
    STA [$00]           ; $1082D3   | |
    REP #$20            ; $1082D5   | |
    INC $00             ; $1082D7   | | save all of your bonus items to sram
    SEP #$20            ; $1082D9   | |
    INY                 ; $1082DB   | |
    CPY #$1B            ; $1082DC   | |
    BCC CODE_1082D0     ; $1082DE   |/
    REP #$20            ; $1082E0   |
    LDA $6082           ; $1082E2   |
    STA [$00]           ; $1082E5   |
    INC $00             ; $1082E7   |
    LDA $0372           ; $1082E9   |
    STA [$00]           ; $1082EC   |
    SEP #$20            ; $1082EE   |
    REP #$20            ; $1082F0   |

    PHX                 ; $1082F2   |\
    PHX                 ; $1082F3   | |
    LDA $8012,x         ; $1082F4   | |
    STA $3014           ; $1082F7   | | get high score checksum before a new high score is added
    LDX #$08            ; $1082FA   | |
    LDA #$DE83          ; $1082FC   | |
    JSL $7EDE44         ; $1082FF   |/ GSU init
    PLX                 ; $108303   |
    LDA $3000           ; $108304   |\
    STA $707E70,x       ; $108307   |/ store high score checksum

    LDA $8012,x         ; $10830B   |\
    STA $3002           ; $10830E   | |
    LDA $803A,x         ; $108311   | |
    STA $3014           ; $108314   | | store high scores and get new checksum
    LDX #$08            ; $108317   | |
    LDA #$DE73          ; $108319   | |
    JSL $7EDE44         ; $10831C   |/ GSU init
    PLX                 ; $108320   |
    LDA $3000           ; $108321   |\
    STA $707E76,x       ; $108324   |/ store new high score checksum
    SEP #$20            ; $108328   |
    PLB                 ; $10832A   |
    RTL                 ; $10832B   |

    PHB                 ; $10832C   |
    PHK                 ; $10832D   |
    PLB                 ; $10832E   |
    REP #$20            ; $10832F   |
    LDA $111D           ; $108331   |
    ASL A               ; $108334   |
    TAX                 ; $108335   |
    LDA $1134           ; $108336   |
    ASL A               ; $108339   |
    TAY                 ; $10833A   |

    PHX                 ; $10833B   |
    PHX                 ; $10833C   |
    LDA $8012,y         ; $10833D   |
    STA $3002           ; $108340   |
    LDA $803A,x         ; $108343   |
    STA $3014           ; $108346   |
    LDX #$08            ; $108349   |
    LDA #$DE73          ; $10834B   |
    JSL $7EDE44         ; $10834E   | GSU init
    PLX                 ; $108352   |
    LDA $3000           ; $108353   |
    STA $707E76,x       ; $108356   |
    LDA $803A,x         ; $10835A   |
    STA $3002           ; $10835D   |
    LDA $8012,x         ; $108360   |
    STA $3014           ; $108363   |
    LDX #$08            ; $108366   |
    LDA #$DE73          ; $108368   |
    JSL $7EDE44         ; $10836B   | GSU init
    PLX                 ; $10836F   |
    LDA $3000           ; $108370   |
    STA $707E70,x       ; $108373   |
    SEP #$20            ; $108377   |
    PLB                 ; $108379   |
    RTL                 ; $10837A   |

DATA_10837B:         db $60, $60, $00, $00, $70, $60, $02, $00
DATA_108383:         db $80, $60, $04, $00, $90, $60, $06, $00

.gamemode00
    JSL $0082D0         ; $10838B   |
    JSL $008277         ; $10838F   |
    LDX #$02            ; $108393   |
    JSL $00BDA2         ; $108395   |
    LDA #$10            ; $108399   |
    STA $212C           ; $10839B   |
    LDA $213F           ; $10839E   |
    AND #$10            ; $1083A1   |
    BEQ CODE_1083AB     ; $1083A3   |
    JSR CODE_1086EC     ; $1083A5   |
    JMP CODE_1083E5     ; $1083A8   |


CODE_1083AB:
    REP #$10            ; $1083AB   |
    LDY #$0068          ; $1083AD   |
    JSL $00B3EE         ; $1083B0   |
    REP #$30            ; $1083B4   |
    LDX #$0040          ; $1083B6   |
    JSL $00BB05         ; $1083B9   |
    JSR CODE_108A6D     ; $1083BD   |

    LDX #$0F            ; $1083C0   |

CODE_1083C2:
    LDA $837B,x         ; $1083C2   |
    STA $006A00,x       ; $1083C5   |
    DEX                 ; $1083C9   |
    BPL CODE_1083C2     ; $1083CA   |
    LDA #$AA            ; $1083CC   |
    STA $006C00         ; $1083CE   |
    JSL $108000         ; $1083D2   |

    STZ $0202           ; $1083D6   |
    LDA #$80            ; $1083D9   |
    STA $011A           ; $1083DB   |
    JSL $008245         ; $1083DE   |

    INC $0118           ; $1083E2   |

CODE_1083E5:
    PLB                 ; $1083E5   |
    RTL                 ; $1083E6   |

.gamemode03
    DEC $011A           ; $1083E7   |
    BNE CODE_1083E5     ; $1083EA   |
    JML $1083E2         ; $1083EC   |

; gsu table
DATA_1083F0:         db $FE, $00, $FD, $00, $FC, $30, $BD, $B1
DATA_1083F8:         db $B2, $BC, $D0, $B0, $AA, $B6, $AE, $D0
DATA_108400:         db $B9, $AA, $B4, $D0, $B2, $BC, $D0, $B7
DATA_108408:         db $B8, $BD, $FE, $01, $FD, $08, $FC, $28
DATA_108410:         db $AD, $AE, $BC, $B2, $B0, $B7, $AE, $AD
DATA_108418:         db $D0, $AF, $B8, $BB, $D0, $C2, $B8, $BE
DATA_108420:         db $BB, $FE, $02, $FD, $10, $FC, $4C, $BC
DATA_108428:         db $BE, $B9, $AE, $BB, $D0, $AF, $AA, $B6
DATA_108430:         db $B2, $AC, $B8, $B6, $FE, $03, $FD, $18
DATA_108438:         db $FC, $74, $B8, $BB, $FF

; gsu table
DATA_10843D:         db $FE, $00, $FD, $00, $FC, $14, $BC, $BE
DATA_108445:         db $B9, $AE, $BB, $D0, $B7, $AE, $BC, $F3
DATA_10844D:         db $FE, $01, $FD, $08, $FC, $10, $B7, $B2
DATA_108455:         db $B7, $BD, $AE, $B7, $AD, $B8, $D0, $AC
DATA_10845D:         db $B8, $F3, $FC, $64, $CF, $D0, $FC, $74
DATA_108465:         db $B5, $BD, $AD, $F3, $FF, $4F, $00, $00
DATA_10846D:         db $00, $01, $00, $02, $00, $03, $00, $04
DATA_108475:         db $00, $05, $00, $06, $00, $07, $00, $08
DATA_10847D:         db $00, $09, $00, $0A, $00, $0B, $00, $0C
DATA_108485:         db $00, $0D, $00, $0E, $00, $0F, $00, $40
DATA_10848D:         db $00, $41, $00, $42, $00, $43, $00, $44
DATA_108495:         db $00, $45, $00, $46, $00, $47, $00, $48
DATA_10849D:         db $00, $49, $00, $4A, $00, $4B, $00, $4C
DATA_1084A5:         db $00, $4D, $00, $00, $04, $01, $04, $02
DATA_1084AD:         db $04, $03, $04, $04, $04, $05, $04, $06
DATA_1084B5:         db $04, $07, $04, $08, $04, $09, $04, $0A
DATA_1084BD:         db $04, $0B, $04, $0C, $04, $0D, $04, $0E
DATA_1084C5:         db $04, $0F, $04, $40, $04, $41, $04, $42
DATA_1084CD:         db $04, $43, $04, $44, $04, $45, $04, $46
DATA_1084D5:         db $04, $47, $04, $48, $04, $49, $04, $4A
DATA_1084DD:         db $04, $4B, $04, $4C, $04, $4D, $04, $10
DATA_1084E5:         db $00, $11, $00, $12, $00, $13, $00, $14
DATA_1084ED:         db $00, $15, $00, $16, $00, $17, $00, $18
DATA_1084F5:         db $00, $19, $00, $1A, $00, $1B, $00, $1C
DATA_1084FD:         db $00, $1D, $00, $1E, $00, $1F, $00, $50
DATA_108505:         db $00, $51, $00, $52, $00, $53, $00, $54
DATA_10850D:         db $00, $55, $00, $56, $00, $57, $00, $58
DATA_108515:         db $00, $59, $00, $5A, $00, $10, $04, $11
DATA_10851D:         db $04, $12, $04, $13, $04, $14, $04, $15
DATA_108525:         db $04, $16, $04, $17, $04, $18, $04, $19
DATA_10852D:         db $04, $1A, $04, $1B, $04, $1C, $04, $1D
DATA_108535:         db $04, $1E, $04, $1F, $04, $50, $04, $51
DATA_10853D:         db $04, $52, $04, $53, $04, $54, $04, $55
DATA_108545:         db $04, $56, $04, $57, $04, $58, $04, $59
DATA_10854D:         db $04, $5A, $04, $20, $00, $21, $00, $22
DATA_108555:         db $00, $23, $00, $24, $00, $25, $00, $26
DATA_10855D:         db $00, $27, $00, $28, $00, $29, $00, $2A
DATA_108565:         db $00, $2B, $00, $2C, $00, $2D, $00, $2E
DATA_10856D:         db $00, $2F, $00, $60, $00, $61, $00, $62
DATA_108575:         db $00, $63, $00, $64, $00, $65, $00, $66
DATA_10857D:         db $00, $67, $00, $68, $00, $69, $00, $6A
DATA_108585:         db $00, $6B, $00, $6C, $00, $6D, $00, $20
DATA_10858D:         db $04, $21, $04, $22, $04, $23, $04, $24
DATA_108595:         db $04, $25, $04, $26, $04, $27, $04, $28
DATA_10859D:         db $04, $29, $04, $2A, $04, $2B, $04, $2C
DATA_1085A5:         db $04, $2D, $04, $2E, $04, $2F, $04, $60
DATA_1085AD:         db $04, $61, $04, $62, $04, $63, $04, $64
DATA_1085B5:         db $04, $65, $04, $66, $04, $67, $04, $68
DATA_1085BD:         db $04, $69, $04, $6A, $04, $6B, $04, $6C
DATA_1085C5:         db $04, $6D, $04, $30, $00, $31, $00, $32
DATA_1085CD:         db $00, $33, $00, $34, $00, $35, $00, $36
DATA_1085D5:         db $00, $37, $00, $38, $00, $39, $00, $3A
DATA_1085DD:         db $00, $3B, $00, $3C, $00, $3D, $00, $3E
DATA_1085E5:         db $00, $3F, $00, $70, $00, $71, $00, $72
DATA_1085ED:         db $00, $73, $00, $74, $00, $75, $00, $76
DATA_1085F5:         db $00, $77, $00, $78, $00, $79, $00, $7A
DATA_1085FD:         db $00, $7B, $00, $7C, $00, $7D, $00, $7E
DATA_108605:         db $00, $30, $04, $31, $04, $32, $04, $33
DATA_10860D:         db $04, $34, $04, $35, $04, $36, $04, $37
DATA_108615:         db $04, $38, $04, $39, $04, $3A, $04, $3B
DATA_10861D:         db $04, $3C, $04, $3D, $04, $3E, $04, $3F
DATA_108625:         db $04, $70, $04, $71, $04, $72, $04, $73
DATA_10862D:         db $04, $74, $04, $75, $04, $76, $04, $77
DATA_108635:         db $04, $78, $04, $79, $04, $7A, $04, $7B
DATA_10863D:         db $04, $7C, $04, $7D, $04, $7E, $04, $80
DATA_108645:         db $00, $81, $00, $82, $00, $83, $00, $84
DATA_10864D:         db $00, $85, $00, $86, $00, $87, $00, $88
DATA_108655:         db $00, $89, $00, $8A, $00, $8B, $00, $8C
DATA_10865D:         db $00, $8D, $00, $8E, $00, $8F, $00, $C0
DATA_108665:         db $00, $C1, $00, $80, $04, $81, $04, $82
DATA_10866D:         db $04, $83, $04, $84, $04, $85, $04, $86
DATA_108675:         db $04, $87, $04, $88, $04, $89, $04, $8A
DATA_10867D:         db $04, $8B, $04, $8C, $04, $8D, $04, $8E
DATA_108685:         db $04, $8F, $04, $C0, $04, $C1, $04, $90
DATA_10868D:         db $00, $91, $00, $92, $00, $93, $00, $94
DATA_108695:         db $00, $95, $00, $96, $00, $97, $00, $98
DATA_10869D:         db $00, $99, $00, $9A, $00, $9B, $00, $9C
DATA_1086A5:         db $00, $9D, $00, $9E, $00, $9F, $00, $D0
DATA_1086AD:         db $00, $D1, $00, $D2, $00, $D3, $00, $D4
DATA_1086B5:         db $00, $D5, $00, $D6, $00, $D7, $00, $90
DATA_1086BD:         db $04, $91, $04, $92, $04, $93, $04, $94
DATA_1086C5:         db $04, $95, $04, $96, $04, $97, $04, $98
DATA_1086CD:         db $04, $99, $04, $9A, $04, $9B, $04, $9C
DATA_1086D5:         db $04, $9D, $04, $9E, $04, $9F, $04, $D0
DATA_1086DD:         db $04, $D1, $04, $D2, $04, $D3, $04, $D4
DATA_1086E5:         db $04, $D5, $04, $D6, $04, $D7, $04

CODE_1086EC:
    LDA #$04            ; $1086EC   |
    STA $212C           ; $1086EE   |
    STA $0967           ; $1086F1   |
    LDA $012E           ; $1086F4   |
    AND #$FC            ; $1086F7   |
    STA $012E           ; $1086F9   |
    LDA #$13            ; $1086FC   |
    STA $012D           ; $1086FE   |
    LDA #$10            ; $108701   |
    STA $60AA           ; $108703   |
    REP #$20            ; $108706   |
    LDA #$83F0          ; $108708   |
    STA $60A8           ; $10870B   |
    LDX #$09            ; $10870E   |
    LDA #$E9AF          ; $108710   |
    JSL $7EDE44         ; $108713   | GSU init
    SEP #$20            ; $108717   |
    JSR CODE_1087C4     ; $108719   |
    LDA #$10            ; $10871C   |
    STA $60AA           ; $10871E   |
    REP #$20            ; $108721   |
    LDA #$843D          ; $108723   |
    STA $60A8           ; $108726   |
    LDX #$09            ; $108729   |
    LDA #$E9AF          ; $10872B   |
    JSL $7EDE44         ; $10872E   | GSU init
    LDX #$80            ; $108732   |
    STX $2115           ; $108734   |
    LDA #$6400          ; $108737   |
    STA $2116           ; $10873A   |
    LDA #$1801          ; $10873D   |
    STA $4300           ; $108740   |
    LDA #$4C00          ; $108743   |
    STA $4302           ; $108746   |
    LDX #$70            ; $108749   |
    STX $4304           ; $10874B   |
    LDA #$0800          ; $10874E   |
    STA $4305           ; $108751   |
    LDY #$01            ; $108754   |
    STY $420B           ; $108756   |
    LDA #$7A29          ; $108759   |
    STA $2116           ; $10875C   |
    LDA #$1801          ; $10875F   |
    STA $4300           ; $108762   |
    LDA #$8644          ; $108765   |
    STA $4302           ; $108768   |
    LDX #$10            ; $10876B   |
    STX $4304           ; $10876D   |
    LDA #$0024          ; $108770   |
    STA $4305           ; $108773   |
    STY $420B           ; $108776   |
    LDA #$7A49          ; $108779   |
    STA $2116           ; $10877C   |
    LDA #$8668          ; $10877F   |
    STA $4302           ; $108782   |
    LDA #$0024          ; $108785   |
    STA $4305           ; $108788   |
    STY $420B           ; $10878B   |
    LDA #$7AC6          ; $10878E   |
    STA $2116           ; $108791   |
    LDA #$868C          ; $108794   |
    STA $4302           ; $108797   |
    LDA #$0030          ; $10879A   |
    STA $4305           ; $10879D   |
    STY $420B           ; $1087A0   |
    LDA #$7AE6          ; $1087A3   |
    STA $2116           ; $1087A6   |
    LDA #$86BC          ; $1087A9   |
    STA $4302           ; $1087AC   |
    LDA #$0030          ; $1087AF   |
    STA $4305           ; $1087B2   |
    STY $420B           ; $1087B5   |
    SEP #$20            ; $1087B8   |
    LDA #$43            ; $1087BA   |
    STA $0118           ; $1087BC   |
    JSL $008245         ; $1087BF   |
    RTS                 ; $1087C3   |

CODE_1087C4:
    REP #$20            ; $1087C4   |
    LDX #$80            ; $1087C6   |
    STX $2115           ; $1087C8   |
    LDA #$6000          ; $1087CB   |
    STA $2116           ; $1087CE   |
    LDA #$1801          ; $1087D1   |
    STA $4300           ; $1087D4   |
    LDA #$4C00          ; $1087D7   |
    STA $4302           ; $1087DA   |
    LDX #$70            ; $1087DD   |
    STX $4304           ; $1087DF   |
    LDA #$0800          ; $1087E2   |
    STA $4305           ; $1087E5   |
    LDY #$01            ; $1087E8   |
    STY $420B           ; $1087EA   |
    LDX #$00            ; $1087ED   |
    STX $2115           ; $1087EF   |
    LDA #$7800          ; $1087F2   |
    STA $2116           ; $1087F5   |
    LDA #$1809          ; $1087F8   |
    STA $4300           ; $1087FB   |
    LDA #$846A          ; $1087FE   |
    STA $4302           ; $108801   |
    LDX #$10            ; $108804   |
    STX $4304           ; $108806   |
    LDA #$0800          ; $108809   |
    STA $4305           ; $10880C   |

    STY $420B           ; $10880F   |
    LDX #$80            ; $108812   |
    STX $2115           ; $108814   |
    LDA #$7800          ; $108817   |
    STA $2116           ; $10881A   |
    LDA #$1909          ; $10881D   |
    STA $4300           ; $108820   |
    LDA #$846B          ; $108823   |
    STA $4302           ; $108826   |
    LDA #$0800          ; $108829   |
    STA $4305           ; $10882C   |
    STY $420B           ; $10882F   |
    LDA #$78A1          ; $108832   |
    STA $2116           ; $108835   |
    LDA #$1801          ; $108838   |
    STA $4300           ; $10883B   |
    LDA #$846C          ; $10883E   |
    STA $4302           ; $108841   |
    LDX #$10            ; $108844   |
    STX $4304           ; $108846   |
    LDA #$003C          ; $108849   |
    STA $4305           ; $10884C   |
    STY $420B           ; $10884F   |
    LDA #$78C1          ; $108852   |
    STA $2116           ; $108855   |
    LDA #$84A8          ; $108858   |
    STA $4302           ; $10885B   |
    LDA #$003C          ; $10885E   |
    STA $4305           ; $108861   |
    STY $420B           ; $108864   |
    LDA #$7903          ; $108867   |
    STA $2116           ; $10886A   |
    LDA #$84E4          ; $10886D   |
    STA $4302           ; $108870   |
    LDA #$0036          ; $108873   |
    STA $4305           ; $108876   |
    STY $420B           ; $108879   |
    LDA #$7923          ; $10887C   |
    STA $2116           ; $10887F   |
    LDA #$851A          ; $108882   |
    STA $4302           ; $108885   |
    LDA #$0036          ; $108888   |
    STA $4305           ; $10888B   |
    STY $420B           ; $10888E   |
    LDA #$7960          ; $108891   |
    STA $2116           ; $108894   |
    LDA #$8550          ; $108897   |
    STA $4302           ; $10889A   |
    LDA #$003C          ; $10889D   |
    STA $4305           ; $1088A0   |
    STY $420B           ; $1088A3   |
    LDA #$7980          ; $1088A6   |
    STA $2116           ; $1088A9   |
    LDA #$858C          ; $1088AC   |
    STA $4302           ; $1088AF   |
    LDA #$003C          ; $1088B2   |
    STA $4305           ; $1088B5   |
    STY $420B           ; $1088B8   |
    LDA #$79C0          ; $1088BB   |
    STA $2116           ; $1088BE   |
    LDA #$85C8          ; $1088C1   |
    STA $4302           ; $1088C4   |
    LDA #$003E          ; $1088C7   |
    STA $4305           ; $1088CA   |
    STY $420B           ; $1088CD   |
    LDA #$79E0          ; $1088D0   |
    STA $2116           ; $1088D3   |
    LDA #$8606          ; $1088D6   |
    STA $4302           ; $1088D9   |
    LDA #$003E          ; $1088DC   |
    STA $4305           ; $1088DF   |
    STY $420B           ; $1088E2   |
    LDA #$7FFF          ; $1088E5   |
    STA $702002         ; $1088E8   |
    STA $702006         ; $1088EC   |
    STA $70200C         ; $1088F0   |
    STA $70200E         ; $1088F4   |
    SEP #$20            ; $1088F8   |
    RTS                 ; $1088FA   |

    REP #$20            ; $1088FB   |
    LDA $702002         ; $1088FD   |
    INC A               ; $108901   |
    CMP #$8000          ; $108902   |
    BCC CODE_10890A     ; $108905   |
    LDA #$0000          ; $108907   |

CODE_10890A:
    STA $702002         ; $10890A   |
    STA $702006         ; $10890E   |
    STA $70200C         ; $108912   |
    STA $70200E         ; $108916   |
    SEP #$20            ; $10891A   |
    PLB                 ; $10891C   |
    RTL                 ; $10891D   |

.gamemode01
    JSR CODE_108987     ; $10891E   |
    LDA $00             ; $108921   |
    CMP #$FF            ; $108923   |
    BNE CODE_10892D     ; $108925   |
    LDA $01             ; $108927   |
    CMP #$FF            ; $108929   |
    BNE CODE_108953     ; $10892B   |

CODE_10892D:
    LDA $02             ; $10892D   |
    CMP #$FF            ; $10892F   |
    BNE CODE_108939     ; $108931   |
    LDA $03             ; $108933   |
    CMP #$FF            ; $108935   |
    BNE CODE_108953     ; $108937   |

CODE_108939:
    LDA $4218           ; $108939   |
    AND #$0F            ; $10893C   |
    CMP #$01            ; $10893E   |
    BEQ CODE_108953     ; $108940   |
    CMP #$0F            ; $108942   |
    BEQ CODE_108953     ; $108944   |
    LDA $421A           ; $108946   |
    AND #$0F            ; $108949   |
    CMP #$01            ; $10894B   |
    BEQ CODE_108953     ; $10894D   |
    CMP #$0F            ; $10894F   |
    BNE CODE_10897E     ; $108951   |

CODE_108953:
    JSL $0394B8         ; $108953   |
    JSL $008259         ; $108957   |  init OAM buffer
    REP #$20            ; $10895B   |
    PHB                 ; $10895D   |
    LDX #$70            ; $10895E   |
    PHX                 ; $108960   |
    PLB                 ; $108961   |
    LDX #$7E            ; $108962   |

CODE_108964:
    STZ $2000,x         ; $108964   |
    STZ $2080,x         ; $108967   |
    STZ $2100,x         ; $10896A   |
    STZ $2180,x         ; $10896D   |
    DEX                 ; $108970   |
    DEX                 ; $108971   |
    BPL CODE_108964     ; $108972   |
    PLB                 ; $108974   |
    SEP #$20            ; $108975   |
    LDA #$41            ; $108977   |
    STA $0118           ; $108979   |
    BRA CODE_108985     ; $10897C   |


CODE_10897E:
    LDA #$09            ; $10897E   |
    STA $53             ; $108980   |
    INC $0118           ; $108982   |

CODE_108985:
    PLB                 ; $108985   |
    RTL                 ; $108986   |

CODE_108987:
    LDA $4016           ; $108987   |\
    ORA #$01            ; $10898A   | | latch controller 1
    STA $4016           ; $10898C   |/
    STZ $00             ; $10898F   |
    STZ $02             ; $108991   |
    LDX #$07            ; $108993   |

CODE_108995:
    ASL $00             ; $108995   |
    LDA $4016           ; $108997   |
    AND #$02            ; $10899A   |
    LSR A               ; $10899C   |
    ORA $00             ; $10899D   |
    STA $00             ; $10899F   |
    ASL $02             ; $1089A1   |
    LDA $4017           ; $1089A3   |
    AND #$02            ; $1089A6   |
    LSR A               ; $1089A8   |
    ORA $02             ; $1089A9   |
    STA $02             ; $1089AB   |
    DEX                 ; $1089AD   |
    BPL CODE_108995     ; $1089AE   |
    LDA $4016           ; $1089B0   |
    AND #$FE            ; $1089B3   |
    STA $4016           ; $1089B5   |
    STZ $01             ; $1089B8   |
    STZ $03             ; $1089BA   |
    STZ $03             ; $1089BC   |
    LDX #$07            ; $1089BE   |

CODE_1089C0:
    ASL $01             ; $1089C0   |
    LDA $4016           ; $1089C2   |
    AND #$02            ; $1089C5   |
    LSR A               ; $1089C7   |
    ORA $01             ; $1089C8   |
    STA $01             ; $1089CA   |
    ASL $03             ; $1089CC   |
    LDA $4017           ; $1089CE   |
    AND #$02            ; $1089D1   |
    LSR A               ; $1089D3   |
    ORA $03             ; $1089D4   |
    STA $03             ; $1089D6   |
    DEX                 ; $1089D8   |
    BPL CODE_1089C0     ; $1089D9   |
    RTS                 ; $1089DB   |

DATA_1089DC:         db $FE, $00, $FD, $00, $FC, $00, $BD, $B1
DATA_1089E4:         db $B2, $BC, $D0, $B0, $AA, $B6, $AE, $D0
DATA_1089EC:         db $B2, $BC, $D0, $AD, $AE, $BC, $B2, $B0
DATA_1089F4:         db $B7, $AE, $AD, $D0, $B8, $B7, $B5, $C2
DATA_1089FC:         db $D0, $BD, $B8, $D0, $B9, $B5, $AA, $C2
DATA_108A04:         db $D0, $FE, $01, $FD, $08, $FC, $06, $C0
DATA_108A0C:         db $B2, $BD, $B1, $D0, $AA, $D0, $B7, $B8
DATA_108A14:         db $BB, $B6, $AA, $B5, $D0, $AC, $B8, $B7
DATA_108A1C:         db $BD, $BB, $B8, $B5, $B5, $AE, $BB, $F3
DATA_108A24:         db $FE, $02, $FD, $10, $FC, $20, $B9, $B5
DATA_108A2C:         db $AE, $AA, $BC, $AE, $D0, $AD, $B2, $BC
DATA_108A34:         db $AC, $B8, $B7, $B7, $AE, $AC, $BD, $D0
DATA_108A3C:         db $B6, $B8, $BE, $BC, $AE, $CF, $D0, $FE
DATA_108A44:         db $03, $FD, $18, $FC, $00, $BC, $BE, $B9
DATA_108A4C:         db $AE, $BB, $D0, $BC, $AC, $B8, $B9, $AE
DATA_108A54:         db $CF, $D0, $AE, $BD, $AC, $F3, $D0, $BD
DATA_108A5C:         db $B8, $D0, $BC, $BD, $AA, $BB, $BD, $D0
DATA_108A64:         db $B9, $B5, $AA, $C2, $B2, $B7, $B0, $F3
DATA_108A6C:         db $FF

CODE_108A6D:
    STZ $41             ; $108A6D   |
    STZ $42             ; $108A6F   |
    LDA $012E           ; $108A71   |
    AND #$FC            ; $108A74   |
    STA $012E           ; $108A76   |
    LDA #$13            ; $108A79   |
    STA $012D           ; $108A7B   |
    LDA #$10            ; $108A7E   |
    STA $60AA           ; $108A80   |
    REP #$20            ; $108A83   |
    LDA #$89DC          ; $108A85   |
    STA $60A8           ; $108A88   |
    LDX #$09            ; $108A8B   |
    LDA #$E9AF          ; $108A8D   |
    JSL $7EDE44         ; $108A90   | GSU init
    SEP #$20            ; $108A94   |
    JSR CODE_1087C4     ; $108A96   |
    RTS                 ; $108A99   |

    REP #$20            ; $108A9A   |
    LDA $702002         ; $108A9C   |
    INC A               ; $108AA0   |
    CMP #$8000          ; $108AA1   |
    BCC CODE_108AA9     ; $108AA4   |
    LDA #$0000          ; $108AA6   |

CODE_108AA9:
    STA $702002         ; $108AA9   |
    STA $702006         ; $108AAD   |
    STA $70200C         ; $108AB1   |
    STA $70200E         ; $108AB5   |
    SEP #$20            ; $108AB9   |
    JSR CODE_108987     ; $108ABB   |
    LDA $00             ; $108ABE   |
    CMP #$FF            ; $108AC0   |
    BNE CODE_108ACA     ; $108AC2   |
    LDA $01             ; $108AC4   |
    CMP #$FF            ; $108AC6   |
    BNE CODE_108AFB     ; $108AC8   |

CODE_108ACA:
    LDA $02             ; $108ACA   |
    CMP #$FF            ; $108ACC   |
    BNE CODE_108AD6     ; $108ACE   |
    LDA $03             ; $108AD0   |
    CMP #$FF            ; $108AD2   |
    BNE CODE_108AFB     ; $108AD4   |

CODE_108AD6:
    LDA $4218           ; $108AD6   |
    AND #$0F            ; $108AD9   |
    CMP #$01            ; $108ADB   |
    BEQ CODE_108AFB     ; $108ADD   |
    CMP #$0F            ; $108ADF   |
    BEQ CODE_108AFB     ; $108AE1   |
    LDA $421A           ; $108AE3   |
    AND #$0F            ; $108AE6   |
    CMP #$01            ; $108AE8   |
    BEQ CODE_108AFB     ; $108AEA   |
    CMP #$0F            ; $108AEC   |
    BEQ CODE_108AFB     ; $108AEE   |
    STZ $0201           ; $108AF0   |
    STZ $0200           ; $108AF3   |
    STZ $0118           ; $108AF6   |
    BRA CODE_108B03     ; $108AF9   |

CODE_108AFB:
    LDA #$04            ; $108AFB   |
    STA $212C           ; $108AFD   |
    STA $0967           ; $108B00   |

CODE_108B03:
    PLB                 ; $108B03   |
    RTL                 ; $108B04   |

; table: #'s of bits to copy from level header
DATA_108B05:         db $05, $04, $05, $05
DATA_108B09:         db $06, $06, $06, $07
DATA_108B0D:         db $04, $05, $06, $05
DATA_108B11:         db $05, $04, $02, $00

; level header:
; packed format, rather than 8- or 16-bit pieces
; it is variable-bit pieces of data packed tightly.
; the table above at $10/8B05 contains the # of bits
; of each piece of data. it totals 75 so the tables
; are each 75 bits long, which occupies 10 bytes.
; this routine copies each sized piece of data
; into separate word addresses in RAM starting at $0134

; level header is as follows:
; TYPE                LEN    ADDR
; BG Color              5   $0134
; BG 1 Tileset          4   $0136
; BG 1 Palette          5   $0138
; BG 2 Tileset          5   $013A
; BG 2 Palette          6   $013C
; BG 3 Tileset          6   $013E
; BG 3 Palette          6   $0140
; Sprite Tileset        7   $0142
; Sprite Palette        4   $0144
; Level Mode            5   $0146
; Animation Tileset     6   $0148
; Animation Palette     5   $014A
; BG Scrolling          5   $014C
; Music                 4   $014E
; Item Memory           2   $0150
; Unused                5   $0152

    PHB                 ; $108B15   |
    PHK                 ; $108B16   |
    PLB                 ; $108B17   |
    REP #$10            ; $108B18   |
    LDY #$0000          ; $108B1A   |
    LDX #$0000          ; $108B1D   |
    STX $99             ; $108B20   |
    STZ $02             ; $108B22   |
    LDA $8B05,x         ; $108B24   |

CODE_108B27:
    STA $04             ; $108B27   | \ begin data unpack/copy
    LDA #$00            ; $108B29   |  |

CODE_108B2B:
    DEC $02             ; $108B2B   |   \ begin inner loop (copy one bit)
    BPL CODE_108B40     ; $108B2D   |    |
    PHA                 ; $108B2F   |    |
    LDA #$07            ; $108B30   |    |
    STA $02             ; $108B32   |    |
    PHY                 ; $108B34   |    |
    LDY $99             ; $108B35   |    | load in next byte to continue copying chunks
    LDA [$32],y         ; $108B37   |    | at stage_table[y]
    STA $06             ; $108B39   |    |
    INY                 ; $108B3B   |    | increment stage_table index
    STY $99             ; $108B3C   |    |
    PLY                 ; $108B3E   |    |
    PLA                 ; $108B3F   |    |

CODE_108B40:
    ASL $06             ; $108B40   |    | take next bit from stage_table
    ROL A               ; $108B42   |    |
    DEC $0004           ; $108B43   |    |
    BNE CODE_108B2B     ; $108B46   |   /
    STA $0134,y         ; $108B48   |  | store variable-sized piece at current spot in RAM table
    INY                 ; $108B4B   |  |
    INY                 ; $108B4C   |  | go to next entry in $0134
    INX                 ; $108B4D   |  | as well as next in size table
    LDA $8B05,x         ; $108B4E   |  | load next # of bits to copy
    BNE CODE_108B27     ; $108B51   | /  ($00 ends the loop)
    LDA $0150           ; $108B53   |
    STA $03BE           ; $108B56   |
    SEP #$10            ; $108B59   |
    PLB                 ; $108B5B   |
    RTL                 ; $108B5C   |

    JSL $108B15         ; $108B5D   |

    PHB                 ; $108B61   |
    PHK                 ; $108B62   |
    PLB                 ; $108B63   |
    JSL $109257         ; $108B64   |
    REP #$20            ; $108B68   |
    PHB                 ; $108B6A   |
    LDX #$70            ; $108B6B   |
    PHX                 ; $108B6D   |
    PLB                 ; $108B6E   |
    LDX #$00            ; $108B6F   |

CODE_108B71:
    STZ $449E,x         ; $108B71   |
    INX                 ; $108B74   |
    INX                 ; $108B75   |
    CPX #$78            ; $108B76   |
    BCC CODE_108B71     ; $108B78   |
    LDX #$7F            ; $108B7A   |
    PHX                 ; $108B7C   |
    PLB                 ; $108B7D   |
    REP #$10            ; $108B7E   |
    LDX #$8200          ; $108B80   |

CODE_108B83:
    STZ $7DFE,x         ; $108B83   |
    DEX                 ; $108B86   |
    DEX                 ; $108B87   |
    BNE CODE_108B83     ; $108B88   |
    PLB                 ; $108B8A   |
    LDX #$000E          ; $108B8B   |

CODE_108B8E:
    STZ $0D4E,x         ; $108B8E   |
    STZ $0D5E,x         ; $108B91   |
    STZ $0D6E,x         ; $108B94   |
    STZ $0D7E,x         ; $108B97   |
    DEX                 ; $108B9A   |
    DEX                 ; $108B9B   |
    BPL CODE_108B8E     ; $108B9C   |
    SEP #$30            ; $108B9E   |
    STZ $0D4D           ; $108BA0   |
    LDA #$80            ; $108BA3   |
    LDX #$7F            ; $108BA5   |

CODE_108BA7:
    STA $6CAA,x         ; $108BA7   |
    DEX                 ; $108BAA   |
    BPL CODE_108BA7     ; $108BAB   |
    STZ $97             ; $108BAD   |
    REP #$30            ; $108BAF   |
    LDA #$0001          ; $108BB1   |
    STA $2A             ; $108BB4   |
    STA $2E             ; $108BB6   |
    STZ $15             ; $108BB8   |
    SEP #$20            ; $108BBA   |
    LDY $99             ; $108BBC   |
    LDA [$32],y         ; $108BBE   |
    STA $15             ; $108BC0   |
    INY                 ; $108BC2   |
    LDA [$32],y         ; $108BC3   |
    STA $1C             ; $108BC5   |
    INY                 ; $108BC7   |
    LDA [$32],y         ; $108BC8   |
    STA $1B             ; $108BCA   |
    LDA $15             ; $108BCC   |
    BEQ CODE_108C13     ; $108BCE   |
    CMP #$FF            ; $108BD0   |
    BNE CODE_108C33     ; $108BD2   |
    LDA $1C             ; $108BD4   |
    BMI CODE_108C04     ; $108BD6   |
    REP #$20            ; $108BD8   |

CODE_108BDA:
    AND #$007F          ; $108BDA   |
    ASL A               ; $108BDD   |
    ASL A               ; $108BDE   |
    TAX                 ; $108BDF   |
    LDA [$32],y         ; $108BE0   |
    STA $7F7E00,x       ; $108BE2   |
    INY                 ; $108BE6   |
    LDA [$32],y         ; $108BE7   |
    STA $7F7E01,x       ; $108BE9   |
    INY                 ; $108BED   |
    LDA [$32],y         ; $108BEE   |
    STA $7F7E02,x       ; $108BF0   |
    INY                 ; $108BF4   |
    LDA [$32],y         ; $108BF5   |
    INY                 ; $108BF7   |
    INY                 ; $108BF8   |
    XBA                 ; $108BF9   |
    AND #$00FF          ; $108BFA   |
    CMP #$00FF          ; $108BFD   |
    BNE CODE_108BDA     ; $108C00   |
    SEP #$20            ; $108C02   |

CODE_108C04:
    SEP #$10            ; $108C04   |
    LDX #$7F            ; $108C06   |

CODE_108C08:
    LDA $6CAA,x         ; $108C08   |
    STA $6D6A,x         ; $108C0B   |
    DEX                 ; $108C0E   |
    BPL CODE_108C08     ; $108C0F   |
    PLB                 ; $108C11   |
    RTL                 ; $108C12   |

CODE_108C13:
    PHK                 ; $108C13   |
    PEA $8BAE           ; $108C14   |
    LDA #$12            ; $108C17   |
    PHA                 ; $108C19   |
    PHA                 ; $108C1A   |
    PLB                 ; $108C1B   |
    INY                 ; $108C1C   |
    LDA [$32],y         ; $108C1D   |
    STA $15             ; $108C1F   |
    INY                 ; $108C21   |
    STY $99             ; $108C22   |
    REP #$20            ; $108C24   |
    AND #$00FF          ; $108C26   |
    ASL A               ; $108C29   |
    TAX                 ; $108C2A   |
    LDA $128000,x       ; $108C2B   |
    PHA                 ; $108C2F   |
    SEP #$30            ; $108C30   |
    RTL                 ; $108C32   |

CODE_108C33:
    PHK                 ; $108C33   |
    PEA $8BAE           ; $108C34   |
    REP #$20            ; $108C37   |
    LDX $15             ; $108C39   |
    LDA $1284EC,x       ; $108C3B   |
    AND #$0003          ; $108C3F   |
    CMP #$0001          ; $108C42   |
    BEQ CODE_108C6D     ; $108C45   |
    TAX                 ; $108C47   |
    INY                 ; $108C48   |
    LDA [$32],y         ; $108C49   |
    STA $0A             ; $108C4B   |
    BIT #$0080          ; $108C4D   |
    BEQ CODE_108C62     ; $108C50   |
    LDA $0136           ; $108C52   |
    CMP #$0002          ; $108C55   |
    BEQ CODE_108C62     ; $108C58   |
    LDA $0A             ; $108C5A   |
    ORA #$FF00          ; $108C5C   |
    DEC A               ; $108C5F   |
    BRA CODE_108C68     ; $108C60   |

CODE_108C62:
    LDA $0A             ; $108C62   |
    AND #$00FF          ; $108C64   |
    INC A               ; $108C67   |

CODE_108C68:
    STA $2A             ; $108C68   |
    TXA                 ; $108C6A   |
    BEQ CODE_108C81     ; $108C6B   |

CODE_108C6D:
    INY                 ; $108C6D   |
    LDA [$32],y         ; $108C6E   |
    BIT #$0080          ; $108C70   |
    BEQ CODE_108C7B     ; $108C73   |
    ORA #$FF00          ; $108C75   |
    DEC A               ; $108C78   |
    BRA CODE_108C7F     ; $108C79   |

CODE_108C7B:
    AND #$00FF          ; $108C7B   |
    INC A               ; $108C7E   |

CODE_108C7F:
    STA $2E             ; $108C7F   |

CODE_108C81:
    INY                 ; $108C81   |
    STY $99             ; $108C82   |
    LDA $15             ; $108C84   |
    ASL A               ; $108C86   |
    TAX                 ; $108C87   |
    SEP #$20            ; $108C88   |
    LDA #$12            ; $108C8A   |
    PHA                 ; $108C8C   |
    PHA                 ; $108C8D   |
    PLB                 ; $108C8E   |
    LDA $81FF,x         ; $108C8F   |
    PHA                 ; $108C92   |
    LDA $81FE,x         ; $108C93   |
    PHA                 ; $108C96   |
    SEP #$10            ; $108C97   |
    RTL                 ; $108C99   |

    LDA $013E           ; $108C9A   |
    CMP #$0A            ; $108C9D   |
    BEQ CODE_108CA2     ; $108C9F   |

CODE_108CA1:
    RTL                 ; $108CA1   |

CODE_108CA2:
    LDA $77             ; $108CA2   |
    ORA $79             ; $108CA4   |
    BEQ CODE_108CA1     ; $108CA6   |
    PHB                 ; $108CA8   |
    PHK                 ; $108CA9   |
    PLB                 ; $108CAA   |
    REP #$20            ; $108CAB   |
    LDA #$C07F          ; $108CAD   |
    STA $300C           ; $108CB0   |
    LDA #$2100          ; $108CB3   |
    STA $300E           ; $108CB6   |
    LDA $7D             ; $108CB9   |
    BIT #$0400          ; $108CBB   |
    BEQ CODE_108CC3     ; $108CBE   |
    ORA #$0020          ; $108CC0   |

CODE_108CC3:
    AND #$003E          ; $108CC3   |
    STA $3010           ; $108CC6   |
    LDX #$08            ; $108CC9   |
    LDA #$BC36          ; $108CCB   |
    JSL $7EDE44         ; $108CCE   | GSU init
    LDX #$7E            ; $108CD2   |
    PHX                 ; $108CD4   |
    PLB                 ; $108CD5   |
    REP #$10            ; $108CD6   |
    LDX $4800           ; $108CD8   |
    LDA $77             ; $108CDB   |
    BEQ CODE_108D14     ; $108CDD   |
    LDA $7B             ; $108CDF   |
    AND #$07FF          ; $108CE1   |
    BIT #$0400          ; $108CE4   |
    BEQ CODE_108CEC     ; $108CE7   |
    EOR #$0420          ; $108CE9   |

CODE_108CEC:
    LSR A               ; $108CEC   |
    ORA #$3400          ; $108CED   |
    STA $0000,x         ; $108CF0   |
    LDA #$0181          ; $108CF3   |
    STA $0002,x         ; $108CF6   |
    LDA #$0418          ; $108CF9   |
    STA $0004,x         ; $108CFC   |
    LDA #$7026          ; $108CFF   |
    STA $0006,x         ; $108D02   |
    LDA #$0040          ; $108D05   |
    STA $0008,x         ; $108D08   |
    TXA                 ; $108D0B   |
    CLC                 ; $108D0C   |
    ADC #$000C          ; $108D0D   |
    STA $000A,x         ; $108D10   |
    TAX                 ; $108D13   |

CODE_108D14:
    LDA $79             ; $108D14   |
    BEQ CODE_108D45     ; $108D16   |
    LDA $8B             ; $108D18   |
    AND #$01F0          ; $108D1A   |
    ASL A               ; $108D1D   |
    ORA #$3400          ; $108D1E   |
    STA $0000,x         ; $108D21   |
    LDA #$0180          ; $108D24   |
    STA $0002,x         ; $108D27   |
    LDA #$4418          ; $108D2A   |
    STA $0004,x         ; $108D2D   |
    LDA #$7026          ; $108D30   |
    STA $0006,x         ; $108D33   |
    LDA #$0040          ; $108D36   |
    STA $0008,x         ; $108D39   |
    TXA                 ; $108D3C   |
    CLC                 ; $108D3D   |
    ADC #$000C          ; $108D3E   |
    STA $000A,x         ; $108D41   |
    TAX                 ; $108D44   |

CODE_108D45:
    STX $4800           ; $108D45   |

    SEP #$30            ; $108D48   |
    PLB                 ; $108D4A   |
    RTL                 ; $108D4B   |

.gamemode0E
    LDA $8D             ; $108D4C   |
    BEQ CODE_108D75     ; $108D4E   |
    REP #$30            ; $108D50   |
    JSR CODE_108F88     ; $108D52   |
    SEP #$30            ; $108D55   |
    JSL $00C71E         ; $108D57   |
    DEC $8D             ; $108D5B   |
    BNE CODE_108D73     ; $108D5D   |
    JSL $03954E         ; $108D5F   |
    LDX #$5C            ; $108D63   |

CODE_108D65:
    LDA $74A2,x         ; $108D65   |
    ORA #$80            ; $108D68   |
    STA $74A2,x         ; $108D6A   |
    DEX                 ; $108D6D   |
    DEX                 ; $108D6E   |
    DEX                 ; $108D6F   |
    DEX                 ; $108D70   |
    BNE CODE_108D65     ; $108D71   |

CODE_108D73:
    PLB                 ; $108D73   |
    RTL                 ; $108D74   |

CODE_108D75:
    LDA $0B4C           ; $108D75   |
    BEQ CODE_108D8A     ; $108D78   |
    REP #$20            ; $108D7A   |
    LDY $0B54           ; $108D7C   |
    INY                 ; $108D7F   |
    BEQ CODE_108DBB     ; $108D80   |
    SEP #$20            ; $108D82   |
    JSL $108E00         ; $108D84   |
    BRA CODE_108DE8     ; $108D88   |

CODE_108D8A:
    SEP #$20            ; $108D8A   |
    LDA $021A           ; $108D8C   |
    CMP #$04            ; $108D8F   |
    BEQ CODE_108D9B     ; $108D91   |
    CMP #$12            ; $108D93   |
    BEQ CODE_108D9B     ; $108D95   |
    CMP #$36            ; $108D97   |
    BNE CODE_108DA0     ; $108D99   |

CODE_108D9B:
    LDX #$02            ; $108D9B   |
    STX $60C4           ; $108D9D   |

CODE_108DA0:
    CMP #$0B            ; $108DA0   |
    BNE CODE_108DB5     ; $108DA2   |
    LDA $35             ; $108DA4   |
    AND #$F0            ; $108DA6   |
    ORA $36             ; $108DA8   |
    BEQ CODE_108DE8     ; $108DAA   |
    INC $0D0F           ; $108DAC   |
    LDA #$25            ; $108DAF   |
    STA $704070         ; $108DB1   |

CODE_108DB5:
    INC $0118           ; $108DB5   |
    STZ $60AC           ; $108DB8   |

CODE_108DBB:
    STZ $0B4C           ; $108DBB   |
    SEP #$20            ; $108DBE   |
    STZ $0969           ; $108DC0   |
    STZ $096A           ; $108DC3   |
    STZ $0964           ; $108DC6   |
    STZ $0965           ; $108DC9   |
    STZ $0966           ; $108DCC   |
    LDA #$20            ; $108DCF   |
    TRB $094A           ; $108DD1   |
    LDX #$5C            ; $108DD4   |

CODE_108DD6:
    LDA $74A2,x         ; $108DD6   |
    CMP #$FF            ; $108DD9   |
    BEQ CODE_108DE2     ; $108DDB   |
    AND #$7F            ; $108DDD   |
    STA $74A2,x         ; $108DDF   |

CODE_108DE2:
    DEX                 ; $108DE2   |
    DEX                 ; $108DE3   |
    DEX                 ; $108DE4   |
    DEX                 ; $108DE5   |
    BNE CODE_108DD6     ; $108DE6   |

CODE_108DE8:
    SEP #$20            ; $108DE8   |
    JSL $01C0CE         ; $108DEA   |
    PLB                 ; $108DEE   |
    RTL                 ; $108DEF   |

DATA_108DF0:         db $33, $23, $17, $15, $00

DATA_108DF5:         db $0C, $04, $02, $02, $01

DATA_108DFA:         db $20, $10, $00

DATA_108DFD:         db $20, $10, $08

    PHB                 ; $108E00   |
    PHK                 ; $108E01   |
    PLB                 ; $108E02   |
    LDX $0B54           ; $108E03   |
    BEQ CODE_108E1D     ; $108E06   |
    CPX #$FF            ; $108E08   |
    BEQ CODE_108E80     ; $108E0A   |
    LDA #$00            ; $108E0C   |
    STA $0B54           ; $108E0E   |
    LDA #$FF            ; $108E11   |
    STA $0B50           ; $108E13   |
    LDA #$FF            ; $108E16   |
    STA $0B51           ; $108E18   |
    BRA CODE_108E67     ; $108E1B   |

CODE_108E1D:
    LDA $0B50           ; $108E1D   |
    BEQ CODE_108E3E     ; $108E20   |
    LDX $0B52           ; $108E22   |
    LDA $0B50           ; $108E25   |
    CMP $8DF0,x         ; $108E28   |
    BCS CODE_108E2E     ; $108E2B   |
    INX                 ; $108E2D   |

CODE_108E2E:
    LDA $0B50           ; $108E2E   |
    SEC                 ; $108E31   |
    SBC $8DF5,x         ; $108E32   |
    BCS CODE_108E39     ; $108E35   |
    LDA #$00            ; $108E37   |

CODE_108E39:
    STA $0B50           ; $108E39   |
    BRA CODE_108E67     ; $108E3C   |

CODE_108E3E:
    LDX $0B52           ; $108E3E   |
    LDA $0B51           ; $108E41   |
    BEQ CODE_108E55     ; $108E44   |
    CMP $8DFA,x         ; $108E46   |
    BCS CODE_108E4C     ; $108E49   |
    INX                 ; $108E4B   |

CODE_108E4C:
    LDA $0B51           ; $108E4C   |
    SEC                 ; $108E4F   |
    SBC $8DFD,x         ; $108E50   |
    BCS CODE_108E64     ; $108E53   |

CODE_108E55:
    LDX #$FF            ; $108E55   |
    STX $0B54           ; $108E57   |
    STX $0B50           ; $108E5A   |
    LDX #$00            ; $108E5D   |
    STX $0B51           ; $108E5F   |
    BRA CODE_108E67     ; $108E62   |

CODE_108E64:
    STA $0B51           ; $108E64   |

CODE_108E67:
    REP #$20            ; $108E67   |
    LDY $0B50           ; $108E69   |
    TYA                 ; $108E6C   |
    STA $3002           ; $108E6D   |
    LDY $0B51           ; $108E70   |
    TYA                 ; $108E73   |
    STA $3004           ; $108E74   |
    LDX #$08            ; $108E77   |
    LDA #$967D          ; $108E79   |
    JSL $7EDE44         ; $108E7C   | GSU init

CODE_108E80:
    REP #$20            ; $108E80   |
    JML $108F5D         ; $108E82   |

.gamemode11
    REP #$20            ; $108E86   |
    LDA $0B4C           ; $108E88   |
    BNE CODE_108EDE     ; $108E8B   |
    LDX #$5C            ; $108E8D   |

CODE_108E8F:
    LDA $6F00,x         ; $108E8F   |
    BEQ CODE_108EC3     ; $108E92   |
    LDA $6FA0,x         ; $108E94   |
    AND #$0100          ; $108E97   |
    BEQ CODE_108EC3     ; $108E9A   |
    STZ $6F00,x         ; $108E9C   |
    LDA #$00FF          ; $108E9F   |
    STA $74A2,x         ; $108EA2   |
    LDY $013A           ; $108EA5   |
    CPY #$16            ; $108EA8   |
    BNE CODE_108EB2     ; $108EAA   |
    LDA #$0202          ; $108EAC   |
    TRB $0967           ; $108EAF   |

CODE_108EB2:
    LDY $013E           ; $108EB2   |
    CPY #$02            ; $108EB5   |
    BEQ CODE_108EBD     ; $108EB7   |
    CPY #$16            ; $108EB9   |
    BNE CODE_108EC3     ; $108EBB   |

CODE_108EBD:
    LDA #$0404          ; $108EBD   |
    TRB $0967           ; $108EC0   |

CODE_108EC3:
    DEX                 ; $108EC3   |
    DEX                 ; $108EC4   |
    DEX                 ; $108EC5   |
    DEX                 ; $108EC6   |
    BPL CODE_108E8F     ; $108EC7   |
    LDA $702000         ; $108EC9   |
    BEQ CODE_108EDE     ; $108ECD   |
    STA $0948           ; $108ECF   |
    LDA #$0000          ; $108ED2   |
    STA $702000         ; $108ED5   |
    LDX #$20            ; $108ED9   |
    STX $096C           ; $108EDB   |


CODE_108EDE:
    SEP #$20            ; $108EDE   |
    JSL $01C0CE         ; $108EE0   |
    JSL $108F49         ; $108EE4   |

    LDA #$1F            ; $108EE8   |
    STA $0969           ; $108EEA   |
    STA $096A           ; $108EED   |
    REP #$30            ; $108EF0   |
    LDA $0B4C           ; $108EF2   |
    CLC                 ; $108EF5   |
    ADC #$0006          ; $108EF6   |
    STA $0B4C           ; $108EF9   |
    CMP #$0400          ; $108EFC   |
    BCC CODE_108F45     ; $108EFF   |

    LDA $0379           ; $108F01   |
    BNE CODE_108F0B     ; $108F04   |
    LDY #$003F          ; $108F06   |
    BRA CODE_108F16     ; $108F09   |


CODE_108F0B:
    LDY #$003A          ; $108F0B   |
    LDA $03AC           ; $108F0E   |
    BEQ CODE_108F16     ; $108F11   |
    LDY #$0032          ; $108F13   |

CODE_108F16:
    STY $0118           ; $108F16   |
    STZ $0B4C           ; $108F19   |
    PHB                 ; $108F1C   |
    PEA $7058           ; $108F1D   |
    PLB                 ; $108F20   |
    PLB                 ; $108F21   |
    LDX #$00FE          ; $108F22   |

CODE_108F25:
    STZ $5800,x         ; $108F25   |
    STZ $5900,x         ; $108F28   |
    STZ $5A00,x         ; $108F2B   |
    STZ $5B00,x         ; $108F2E   |
    STZ $5C00,x         ; $108F31   |
    STZ $5D00,x         ; $108F34   |
    STZ $5E00,x         ; $108F37   |
    STZ $5F00,x         ; $108F3A   |
    DEX                 ; $108F3D   |
    DEX                 ; $108F3E   |
    BNE CODE_108F25     ; $108F3F   |
    PLB                 ; $108F41   |
    INC $0CF9           ; $108F42   |

CODE_108F45:
    SEP #$30            ; $108F45   |
    PLB                 ; $108F47   |
    RTL                 ; $108F48   |

    PHB                 ; $108F49   |
    PHK                 ; $108F4A   |
    PLB                 ; $108F4B   |
    REP #$20            ; $108F4C   |
    LDA $0B4C           ; $108F4E   |
    STA $3002           ; $108F51   |
    LDX #$08            ; $108F54   |
    LDA #$8EF3          ; $108F56   |
    JSL $7EDE44         ; $108F59   |  GSU init routines

    JSL $00BE39         ; $108F5D   |

DATA_108F61:         dw $56D0, $027E, $703A, $0348

    STZ $094C           ; $108F69   |
    SEP #$20            ; $108F6C   |
    LDA #$0F            ; $108F6E   |
    STA $0969           ; $108F70   |
    STA $096A           ; $108F73   |
    LDA #$22            ; $108F76   |
    STA $0964           ; $108F78   |
    STA $0965           ; $108F7B   |
    STA $0966           ; $108F7E   |
    LDA #$20            ; $108F81   |
    TSB $094A           ; $108F83   |
    PLB                 ; $108F86   |
    RTL                 ; $108F87   |

CODE_108F88:
    LDA $60A4           ; $108F88   |
    JSR CODE_109089     ; $108F8B   |
    LDA $60A4           ; $108F8E   |
    CLC                 ; $108F91   |
    ADC #$0010          ; $108F92   |
    STA $60A4           ; $108F95   |
    SEP #$30            ; $108F98   |
    JSL $108C9A         ; $108F9A   |
    REP #$30            ; $108F9E   |
    RTS                 ; $108FA0   |

    PHB                 ; $108FA1   |
    PHK                 ; $108FA2   |
    PLB                 ; $108FA3   |
    STZ $77             ; $108FA4   |
    STZ $79             ; $108FA6   |
    STZ $73             ; $108FA8   |
    REP #$30            ; $108FAA   |
    LDA #$0011          ; $108FAC   |
    STA $8D             ; $108FAF   |
    LDA $3B             ; $108FB1   |
    STA $60A6           ; $108FB3   |
    LDA $39             ; $108FB6   |
    SEC                 ; $108FB8   |
    SBC #$0100          ; $108FB9   |
    STA $60A4           ; $108FBC   |

CODE_108FBF:
    JSR CODE_108F88     ; $108FBF   |
    SEP #$30            ; $108FC2   |
    JSL $00E3D7         ; $108FC4   |
    JSL $00DB94         ; $108FC8   |
    REP #$30            ; $108FCC   |
    DEC $8D             ; $108FCE   |
    BNE CODE_108FBF     ; $108FD0   |
    SEP #$30            ; $108FD2   |
    PLB                 ; $108FD4   |
    RTL                 ; $108FD5   |

    PHB                 ; $108FD6   |
    PHK                 ; $108FD7   |
    PLB                 ; $108FD8   |
    LDA $0146           ; $108FD9   |
    CMP #$09            ; $108FDC   |
    BNE CODE_108FE3     ; $108FDE   |
    JMP CODE_109056     ; $108FE0   |

CODE_108FE3:
    STZ $77             ; $108FE3   |
    STZ $79             ; $108FE5   |
    STZ $73             ; $108FE7   |
    REP #$30            ; $108FE9   |
    LDA #$0011          ; $108FEB   |
    STA $8D             ; $108FEE   |
    LDA $038C           ; $108FF0   |
    BEQ CODE_109016     ; $108FF3   |
    LDA $3B             ; $108FF5   |
    STA $60A6           ; $108FF7   |
    LDA $39             ; $108FFA   |
    SEC                 ; $108FFC   |
    SBC #$0100          ; $108FFD   |
    STA $60A4           ; $109000   |

CODE_109003:
    JSR CODE_108F88     ; $109003   |
    SEP #$30            ; $109006   |
    JSL $00E3D7         ; $109008   |
    JSL $00DB94         ; $10900C   |
    REP #$30            ; $109010   |
    DEC $8D             ; $109012   |
    BNE CODE_109003     ; $109014   |

CODE_109016:
    LDA $013E           ; $109016   |
    CMP #$000A          ; $109019   |
    BNE CODE_109054     ; $10901C   |
    PHB                 ; $10901E   |
    PEA $7E40           ; $10901F   |
    PLB                 ; $109022   |
    PLB                 ; $109023   |
    LDY $4000           ; $109024   |
    LDA #$2800          ; $109027   |
    STA $4002,y         ; $10902A   |
    LDA #$27FF          ; $10902D   |
    STA $4004,y         ; $109030   |
    LDA #$5DA6          ; $109033   |
    STA $4006,y         ; $109036   |
    LDA #$007E          ; $109039   |
    STA $4008,y         ; $10903C   |
    LDA #$FFFF          ; $10903F   |
    STA $4009,y         ; $109042   |
    TYA                 ; $109045   |
    CLC                 ; $109046   |
    ADC #$0007          ; $109047   |
    STA $4000           ; $10904A   |
    PLB                 ; $10904D   |
    SEP #$30            ; $10904E   |
    JSL $00E37B         ; $109050   |

CODE_109054:
    SEP #$30            ; $109054   |

CODE_109056:
    PLB                 ; $109056   |
    RTL                 ; $109057   |

; loading a new row/column of level info
    PHB                 ; $109058   |
    PHK                 ; $109059   |
    PLB                 ; $10905A   |
    LDA $0146           ; $10905B   |
    CMP #$09            ; $10905E   |
    BNE CODE_109065     ; $109060   |
    JMP CODE_109083     ; $109062   |

CODE_109065:
    REP #$30            ; $109065   |
    LDA $39             ; $109067   |
    AND #$FFF0          ; $109069   |
    CMP $60A4           ; $10906C   |
    BEQ CODE_109074     ; $10906F   |
    JSR CODE_109089     ; $109071   |

CODE_109074:
    LDA $3B             ; $109074   |
    AND #$FFF0          ; $109076   |
    CMP $60A6           ; $109079   |
    BEQ CODE_109081     ; $10907C   |
    JSR CODE_109163     ; $10907E   |

CODE_109081:
    SEP #$30            ; $109081   |

CODE_109083:
    PLB                 ; $109083   |
    RTL                 ; $109084   |

DATA_109085:         dw $0100, $0000

CODE_109089:
    INC $77             ; $109089   |
    STA $60A4           ; $10908B   |
    LDY $73             ; $10908E   |
    CLC                 ; $109090   |
    ADC $9085,y         ; $109091   |
    TAY                 ; $109094   |
    AND #$01F0          ; $109095   |
    TAX                 ; $109098   |
    LSR A               ; $109099   |
    LSR A               ; $10909A   |
    LSR A               ; $10909B   |
    STA $0A             ; $10909C   |
    TXA                 ; $10909E   |
    BIT #$0100          ; $10909F   |
    BEQ CODE_1090A7     ; $1090A2   |
    EOR #$2100          ; $1090A4   |

CODE_1090A7:
    LSR A               ; $1090A7   |
    LSR A               ; $1090A8   |
    LSR A               ; $1090A9   |
    TAX                 ; $1090AA   |
    ADC #$6800          ; $1090AB   |
    STA $7B             ; $1090AE   |
    INC A               ; $1090B0   |
    STA $7F             ; $1090B1   |
    TYA                 ; $1090B3   |
    AND #$0F00          ; $1090B4   |
    XBA                 ; $1090B7   |
    STA $00             ; $1090B8   |
    TXA                 ; $1090BA   |
    AND #$001E          ; $1090BB   |
    STA $02             ; $1090BE   |
    LDA $3B             ; $1090C0   |
    AND #$00F0          ; $1090C2   |
    TAY                 ; $1090C5   |
    ASL A               ; $1090C6   |
    ASL A               ; $1090C7   |
    TSB $0A             ; $1090C8   |
    TYA                 ; $1090CA   |
    LSR A               ; $1090CB   |
    LSR A               ; $1090CC   |
    LSR A               ; $1090CD   |
    LSR A               ; $1090CE   |
    STA $3006           ; $1090CF   |
    EOR #$000F          ; $1090D2   |
    INC A               ; $1090D5   |
    STA $06             ; $1090D6   |
    STA $3018           ; $1090D8   |
    TYA                 ; $1090DB   |
    ASL A               ; $1090DC   |
    STA $0E             ; $1090DD   |
    LDA $3B             ; $1090DF   |
    LSR A               ; $1090E1   |
    LSR A               ; $1090E2   |
    TAY                 ; $1090E3   |
    LSR A               ; $1090E4   |
    LSR A               ; $1090E5   |
    AND #$0070          ; $1090E6   |
    ORA $00             ; $1090E9   |
    STA $04             ; $1090EB   |
    TAX                 ; $1090ED   |
    LDA $6CA9,x         ; $1090EE   |
    AND #$3F00          ; $1090F1   |
    ASL A               ; $1090F4   |
    ORA $0E             ; $1090F5   |
    ORA $02             ; $1090F7   |
    TAX                 ; $1090F9   |
    TYA                 ; $1090FA   |
    AND #$003C          ; $1090FB   |
    STA $3014           ; $1090FE   |
    LDY $0A             ; $109101   |
    STY $3002           ; $109103   |
    PHB                 ; $109106   |
    PEA $7040           ; $109107   |
    PLB                 ; $10910A   |
    PLB                 ; $10910B   |
    JSR CODE_109147     ; $10910C   |
    LDA $003006         ; $10910F   |
    BEQ CODE_109138     ; $109113   |
    STA $06             ; $109115   |
    TYA                 ; $109117   |
    AND #$03FF          ; $109118   |
    TAY                 ; $10911B   |
    STA $003004         ; $10911C   |
    LDA $04             ; $109120   |
    CLC                 ; $109122   |
    ADC #$0010          ; $109123   |
    AND #$007F          ; $109126   |
    TAX                 ; $109129   |
    LDA $006CA9,x       ; $10912A   |
    AND #$3F00          ; $10912E   |
    ASL A               ; $109131   |
    ORA $02             ; $109132   |
    TAX                 ; $109134   |
    JSR CODE_109147     ; $109135   |

CODE_109138:
    PLB                 ; $109138   |
    SEP #$10            ; $109139   |
    LDX #$09            ; $10913B   |
    LDA #$F9E8          ; $10913D   |
    JSL $7EDE44         ; $109140   | GSU init
    REP #$10            ; $109144   |
    RTS                 ; $109146   |

CODE_109147:
    LDA $7F8000,x       ; $109147   |
    STA $409E,y         ; $10914B   |
    TYA                 ; $10914E   |
    CLC                 ; $10914F   |
    ADC #$0040          ; $109150   |
    TAY                 ; $109153   |
    TXA                 ; $109154   |
    CLC                 ; $109155   |
    ADC #$0020          ; $109156   |
    TAX                 ; $109159   |
    DEC $06             ; $10915A   |
    BNE CODE_109147     ; $10915C   |
    RTS                 ; $10915E   |

DATA_10915F:         dw $00E0, $0000

CODE_109163:
    INC $79             ; $109163   |
    STA $60A6           ; $109165   |
    LDY $75             ; $109168   |
    CLC                 ; $10916A   |
    ADC $915F,y         ; $10916B   |
    STA $8B             ; $10916E   |
    TAY                 ; $109170   |
    ASL A               ; $109171   |
    AND #$01E0          ; $109172   |
    STA $02             ; $109175   |
    ASL A               ; $109177   |
    STA $0A             ; $109178   |
    STA $00             ; $10917A   |
    TYA                 ; $10917C   |
    LSR A               ; $10917D   |
    LSR A               ; $10917E   |
    LSR A               ; $10917F   |
    LSR A               ; $109180   |
    AND #$0070          ; $109181   |
    STA $04             ; $109184   |
    LDA $39             ; $109186   |
    LSR A               ; $109188   |
    LSR A               ; $109189   |
    TAX                 ; $10918A   |
    AND #$003C          ; $10918B   |
    TAY                 ; $10918E   |
    LSR A               ; $10918F   |
    LSR A               ; $109190   |
    STA $08             ; $109191   |
    EOR #$000F          ; $109193   |
    INC A               ; $109196   |
    STA $06             ; $109197   |
    STA $3018           ; $109199   |
    TYA                 ; $10919C   |
    CLC                 ; $10919D   |
    ADC #$0004          ; $10919E   |
    STA $87             ; $1091A1   |
    TYA                 ; $1091A3   |
    LSR A               ; $1091A4   |
    STA $0E             ; $1091A5   |
    TXA                 ; $1091A7   |
    LSR A               ; $1091A8   |
    AND #$003E          ; $1091A9   |
    TAY                 ; $1091AC   |
    TSB $0A             ; $1091AD   |
    TYA                 ; $1091AF   |
    BIT #$0020          ; $1091B0   |
    BEQ CODE_1091B8     ; $1091B3   |
    EOR #$0420          ; $1091B5   |

CODE_1091B8:
    ORA $00             ; $1091B8   |
    TAX                 ; $1091BA   |
    CLC                 ; $1091BB   |
    ADC #$6800          ; $1091BC   |
    STA $7D             ; $1091BF   |
    CLC                 ; $1091C1   |
    ADC #$0020          ; $1091C2   |
    STA $85             ; $1091C5   |
    TXA                 ; $1091C7   |
    EOR #$0400          ; $1091C8   |
    AND #$FFE0          ; $1091CB   |
    CLC                 ; $1091CE   |
    ADC #$6800          ; $1091CF   |
    STA $81             ; $1091D2   |
    CLC                 ; $1091D4   |
    ADC #$0020          ; $1091D5   |
    STA $89             ; $1091D8   |
    LDA #$0044          ; $1091DA   |
    SEC                 ; $1091DD   |
    SBC $87             ; $1091DE   |
    STA $83             ; $1091E0   |
    LDY #$2A            ; $1091E2   |
    ROR $3AA5           ; $1091E4   |
    AND #$000F          ; $1091E7   |
    STA $0C             ; $1091EA   |
    ORA $04             ; $1091EC   |
    TAX                 ; $1091EE   |
    LDA $6CA9,x         ; $1091EF   |
    AND #$3F00          ; $1091F2   |
    ASL A               ; $1091F5   |
    ORA $0E             ; $1091F6   |
    ORA $02             ; $1091F8   |
    TAX                 ; $1091FA   |
    LDY $0A             ; $1091FB   |
    STY $3002           ; $1091FD   |
    PHB                 ; $109200   |
    PEA $7040           ; $109201   |
    PLB                 ; $109204   |
    PLB                 ; $109205   |
    JSR CODE_109247     ; $109206   |
    LDA $08             ; $109209   |
    INC A               ; $10920B   |
    STA $06             ; $10920C   |
    STA $003006         ; $10920E   |
    TYA                 ; $109212   |
    BIT #$003E          ; $109213   |
    BNE CODE_10921D     ; $109216   |
    SEC                 ; $109218   |
    SBC #$0040          ; $109219   |
    TAY                 ; $10921C   |

CODE_10921D:
    STA $003004         ; $10921D   |
    LDA $0C             ; $109221   |
    INC A               ; $109223   |
    AND #$000F          ; $109224   |
    ORA $04             ; $109227   |
    TAX                 ; $109229   |
    LDA $006CA9,x       ; $10922A   |
    AND #$3F00          ; $10922E   |
    ASL A               ; $109231   |
    ORA $02             ; $109232   |
    TAX                 ; $109234   |
    JSR CODE_109247     ; $109235   |
    PLB                 ; $109238   |
    SEP #$10            ; $109239   |
    LDX #$09            ; $10923B   |
    LDA #$FA68          ; $10923D   |
    JSL $7EDE44         ; $109240   | GSU init
    REP #$10            ; $109244   |
    RTS                 ; $109246   |

CODE_109247:
    LDA $7F8000,x       ; $109247   |
    STA $409E,y         ; $10924B   |
    INY                 ; $10924E   |
    INY                 ; $10924F   |
    INX                 ; $109250   |
    INX                 ; $109251   |
    DEC $06             ; $109252   |
    BNE CODE_109247     ; $109254   |
    RTS                 ; $109256   |

    LDA #$00            ; $109257   |
    STA $02             ; $109259   |
    REP #$30            ; $10925B   |
    LDX #$0000          ; $10925D   |

CODE_109260:
    STX $03             ; $109260   |
    LDA $4CD61A,x       ; $109262   |
    AND #$00FF          ; $109266   |
    BEQ CODE_109292     ; $109269   |
    TAY                 ; $10926B   |
    LDA $4CD61B,x       ; $10926C   |
    STA $00             ; $109270   |
    LDA $0136           ; $109272   |
    ASL A               ; $109275   |
    ADC $03             ; $109276   |
    TAX                 ; $109278   |
    LDA $4CD61D,x       ; $109279   |
    TYX                 ; $10927D   |
    LDY #$0000          ; $10927E   |

CODE_109281:
    STA [$00],y         ; $109281   |
    INC A               ; $109283   |
    INY                 ; $109284   |
    INY                 ; $109285   |
    DEX                 ; $109286   |
    BNE CODE_109281     ; $109287   |
    LDA $03             ; $109289   |
    CLC                 ; $10928B   |
    ADC #$0023          ; $10928C   |
    TAX                 ; $10928F   |
    BRA CODE_109260     ; $109290   |

CODE_109292:
    SEP #$30            ; $109292   |
    RTL                 ; $109294   |

    PHP                 ; $109295   |
    PHB                 ; $109296   |
    PHK                 ; $109297   |
    PLB                 ; $109298   |
    PHD                 ; $109299   |
    LDA #$0000          ; $10929A   |
    TCD                 ; $10929D   |
    REP #$30            ; $10929E   |
    LDA $91             ; $1092A0   |
    AND #$FFF0          ; $1092A2   |
    SEC                 ; $1092A5   |
    SBC $60A4           ; $1092A6   |
    CLC                 ; $1092A9   |
    ADC #$0010          ; $1092AA   |
    STA $12             ; $1092AD   |
    LDA $93             ; $1092AF   |
    AND #$FFF0          ; $1092B1   |
    SEC                 ; $1092B4   |
    SBC $60A6           ; $1092B5   |
    CLC                 ; $1092B8   |
    ADC #$0010          ; $1092B9   |
    STA $14             ; $1092BC   |
    LDA $93             ; $1092BE   |
    TAY                 ; $1092C0   |
    AND #$0700          ; $1092C1   |
    LSR A               ; $1092C4   |
    LSR A               ; $1092C5   |
    LSR A               ; $1092C6   |
    LSR A               ; $1092C7   |
    STA $00             ; $1092C8   |
    TYA                 ; $1092CA   |
    AND #$00F0          ; $1092CB   |
    ASL A               ; $1092CE   |
    STA $02             ; $1092CF   |
    ASL A               ; $1092D1   |
    STA $07             ; $1092D2   |
    LDA $91             ; $1092D4   |
    TAY                 ; $1092D6   |
    AND #$00F0          ; $1092D7   |
    LSR A               ; $1092DA   |
    LSR A               ; $1092DB   |
    LSR A               ; $1092DC   |
    TSB $02             ; $1092DD   |
    TYA                 ; $1092DF   |
    AND #$01F0          ; $1092E0   |
    LSR A               ; $1092E3   |
    LSR A               ; $1092E4   |
    LSR A               ; $1092E5   |
    BIT #$0020          ; $1092E6   |
    BEQ CODE_1092EE     ; $1092E9   |
    EOR #$0420          ; $1092EB   |

CODE_1092EE:
    TSB $07             ; $1092EE   |
    TYA                 ; $1092F0   |
    AND #$0F00          ; $1092F1   |
    XBA                 ; $1092F4   |
    ORA $00             ; $1092F5   |
    STA $10             ; $1092F7   |
    TAX                 ; $1092F9   |
    LDA $6CA9,x         ; $1092FA   |
    AND #$3F00          ; $1092FD   |
    ASL A               ; $109300   |
    TSB $02             ; $109301   |
    LDA $8F             ; $109303   |
    ASL A               ; $109305   |
    TAX                 ; $109306   |
    JSR ($930E,x)       ; $109307   |

    PLD                 ; $10930A   |
    PLB                 ; $10930B   |
    PLP                 ; $10930C   |
    RTL                 ; $10930D   |

DATA_10930E:         dw $931E
DATA_109310:         dw $98D0
DATA_109312:         dw $955B
DATA_109314:         dw $962C
DATA_109316:         dw $96DF
DATA_109318:         dw $98E9
DATA_10931A:         dw $990B
DATA_10931C:         dw $98CD

    LDA $07             ; $10931E   |
    STA $04             ; $109320   |
    LDA $12             ; $109322   |
    STA $16             ; $109324   |
    LDA $14             ; $109326   |
    STA $18             ; $109328   |
    LDX $02             ; $10932A   |
    LDA $7F8000,x       ; $10932C   |
    TAY                 ; $109330   |
    AND #$FF00          ; $109331   |
    XBA                 ; $109334   |
    SEC                 ; $109335   |
    SBC #$001A          ; $109336   |
    CMP #$0003          ; $109339   |
    BCC CODE_10933F     ; $10933C   |
    RTS                 ; $10933E   |

CODE_10933F:
    PHB                 ; $10933F   |
    SEP #$20            ; $109340   |
    LDA #$13            ; $109342   |
    PHA                 ; $109344   |
    PLB                 ; $109345   |
    REP #$20            ; $109346   |
    TYA                 ; $109348   |
    AND #$00FF          ; $109349   |
    ASL A               ; $10934C   |
    TAY                 ; $10934D   |
    LDA $B7A8,y         ; $10934E   |
    BEQ CODE_109357     ; $109351   |
    TAY                 ; $109353   |
    LDA $0000,y         ; $109354   |

CODE_109357:
    STA $7F8000,x       ; $109357   |
    JSR CODE_109A2A     ; $10935B   |
    JSR CODE_109438     ; $10935E   |
    LDA $00             ; $109361   |
    BNE CODE_109391     ; $109363   |
    LDA $7F8000,x       ; $109365   |
    TAY                 ; $109369   |
    AND #$FF00          ; $10936A   |
    XBA                 ; $10936D   |
    SEC                 ; $10936E   |
    SBC #$001A          ; $10936F   |
    CMP #$0003          ; $109372   |
    BCS CODE_109391     ; $109375   |
    TYA                 ; $109377   |
    AND #$00FF          ; $109378   |
    ASL A               ; $10937B   |
    TAY                 ; $10937C   |
    LDA $B1B0,y         ; $10937D   |
    TAY                 ; $109380   |
    LDA $0000,y         ; $109381   |
    CMP $7F8000,x       ; $109384   |
    BEQ CODE_109391     ; $109388   |
    STA $7F8000,x       ; $10938A   |
    JSR CODE_109A2A     ; $10938E   |

CODE_109391:
    JSR CODE_109481     ; $109391   |
    LDA $00             ; $109394   |
    BNE CODE_1093C4     ; $109396   |
    LDA $7F8000,x       ; $109398   |
    TAY                 ; $10939C   |
    AND #$FF00          ; $10939D   |
    XBA                 ; $1093A0   |
    SEC                 ; $1093A1   |
    SBC #$001A          ; $1093A2   |
    CMP #$0003          ; $1093A5   |
    BCS CODE_1093C4     ; $1093A8   |
    TYA                 ; $1093AA   |
    AND #$00FF          ; $1093AB   |
    ASL A               ; $1093AE   |
    TAY                 ; $1093AF   |
    LDA $B62A,y         ; $1093B0   |
    TAY                 ; $1093B3   |
    LDA $0000,y         ; $1093B4   |
    CMP $7F8000,x       ; $1093B7   |
    BEQ CODE_1093C4     ; $1093BB   |
    STA $7F8000,x       ; $1093BD   |
    JSR CODE_109A2A     ; $1093C1   |

CODE_1093C4:
    JSR CODE_1094CC     ; $1093C4   |
    LDA $00             ; $1093C7   |
    BNE CODE_1093F7     ; $1093C9   |
    LDA $7F8000,x       ; $1093CB   |
    TAY                 ; $1093CF   |
    AND #$FF00          ; $1093D0   |
    XBA                 ; $1093D3   |
    SEC                 ; $1093D4   |
    SBC #$001A          ; $1093D5   |
    CMP #$0003          ; $1093D8   |
    BCS CODE_1093F7     ; $1093DB   |
    TYA                 ; $1093DD   |
    AND #$00FF          ; $1093DE   |
    ASL A               ; $1093E1   |
    TAY                 ; $1093E2   |
    LDA $B4AC,y         ; $1093E3   |
    TAY                 ; $1093E6   |
    LDA $0000,y         ; $1093E7   |
    CMP $7F8000,x       ; $1093EA   |
    BEQ CODE_1093F7     ; $1093EE   |
    STA $7F8000,x       ; $1093F0   |
    JSR CODE_109A2A     ; $1093F4   |

CODE_1093F7:
    JSR CODE_109512     ; $1093F7   |
    LDA $00             ; $1093FA   |
    BNE CODE_10942A     ; $1093FC   |
    LDA $7F8000,x       ; $1093FE   |
    TAY                 ; $109402   |
    AND #$FF00          ; $109403   |
    XBA                 ; $109406   |
    SEC                 ; $109407   |
    SBC #$001A          ; $109408   |
    CMP #$0003          ; $10940B   |
    BCS CODE_10942A     ; $10940E   |
    TYA                 ; $109410   |
    AND #$00FF          ; $109411   |
    ASL A               ; $109414   |
    TAY                 ; $109415   |
    LDA $B32E,y         ; $109416   |
    TAY                 ; $109419   |
    LDA $0000,y         ; $10941A   |
    CMP $7F8000,x       ; $10941D   |
    BEQ CODE_10942A     ; $109421   |
    STA $7F8000,x       ; $109423   |
    JSR CODE_109A2A     ; $109427   |

CODE_10942A:
    LDA $0009ED         ; $10942A   |
    TAX                 ; $10942E   |
    LDA #$FFFF          ; $10942F   |
    STA $0009EF,x       ; $109432   |
    PLB                 ; $109436   |
    RTS                 ; $109437   |

CODE_109438:
    LDA $18             ; $109438   |
    SEC                 ; $10943A   |
    SBC #$0010          ; $10943B   |
    STA $14             ; $10943E   |
    STZ $00             ; $109440   |
    LDA $04             ; $109442   |
    SEC                 ; $109444   |
    SBC #$0040          ; $109445   |
    STA $07             ; $109448   |
    LDA $02             ; $10944A   |
    SEC                 ; $10944C   |
    SBC #$0020          ; $10944D   |
    TAX                 ; $109450   |
    AND #$01E0          ; $109451   |
    CMP #$01E0          ; $109454   |
    BNE CODE_109480     ; $109457   |
    LDA $10             ; $109459   |
    SEC                 ; $10945B   |
    SBC #$0010          ; $10945C   |
    BPL CODE_109463     ; $10945F   |
    INC $00             ; $109461   |

CODE_109463:
    TXY                 ; $109463   |
    TAX                 ; $109464   |
    LDA $07             ; $109465   |
    CLC                 ; $109467   |
    ADC #$0400          ; $109468   |
    AND #$07FF          ; $10946B   |
    STA $07             ; $10946E   |
    LDA $6CA9,x         ; $109470   |
    AND #$3F00          ; $109473   |
    ASL A               ; $109476   |
    STA $09             ; $109477   |
    TYA                 ; $109479   |
    AND #$01FF          ; $10947A   |
    ORA $09             ; $10947D   |
    TAX                 ; $10947F   |

CODE_109480:
    RTS                 ; $109480   |

CODE_109481:
    LDA $16             ; $109481   |
    SEC                 ; $109483   |
    SBC #$0010          ; $109484   |
    STA $12             ; $109487   |
    STZ $00             ; $109489   |
    LDA $04             ; $10948B   |
    DEC A               ; $10948D   |
    DEC A               ; $10948E   |
    STA $07             ; $10948F   |
    LDA $02             ; $109491   |
    DEC A               ; $109493   |
    DEC A               ; $109494   |
    TAX                 ; $109495   |
    AND #$001E          ; $109496   |
    CMP #$001E          ; $109499   |
    BNE CODE_1094CB     ; $10949C   |
    LDA $10             ; $10949E   |
    BIT #$000F          ; $1094A0   |
    BNE CODE_1094A7     ; $1094A3   |
    INC $00             ; $1094A5   |

CODE_1094A7:
    LDA $10             ; $1094A7   |
    DEC A               ; $1094A9   |
    TXY                 ; $1094AA   |
    TAX                 ; $1094AB   |
    LDA $07             ; $1094AC   |
    CLC                 ; $1094AE   |
    ADC #$0420          ; $1094AF   |
    AND #$07FF          ; $1094B2   |
    STA $07             ; $1094B5   |
    LDA $6CA9,x         ; $1094B7   |
    AND #$3F00          ; $1094BA   |
    ASL A               ; $1094BD   |
    STA $09             ; $1094BE   |
    TYA                 ; $1094C0   |
    CLC                 ; $1094C1   |
    ADC #$0020          ; $1094C2   |
    AND #$01FF          ; $1094C5   |
    ORA $09             ; $1094C8   |
    TAX                 ; $1094CA   |

CODE_1094CB:
    RTS                 ; $1094CB   |

CODE_1094CC:
    LDA $16             ; $1094CC   |
    CLC                 ; $1094CE   |
    ADC #$0010          ; $1094CF   |
    STA $12             ; $1094D2   |
    STZ $00             ; $1094D4   |
    LDA $04             ; $1094D6   |
    INC A               ; $1094D8   |
    INC A               ; $1094D9   |
    STA $07             ; $1094DA   |
    LDA $02             ; $1094DC   |
    INC A               ; $1094DE   |
    INC A               ; $1094DF   |
    TAX                 ; $1094E0   |
    AND #$001E          ; $1094E1   |
    BNE CODE_109511     ; $1094E4   |
    LDA $10             ; $1094E6   |
    INC A               ; $1094E8   |
    BIT #$000F          ; $1094E9   |
    BNE CODE_1094F0     ; $1094EC   |
    INC $00             ; $1094EE   |

CODE_1094F0:
    TXY                 ; $1094F0   |
    TAX                 ; $1094F1   |
    LDA $07             ; $1094F2   |
    SEC                 ; $1094F4   |
    SBC #$0420          ; $1094F5   |
    AND #$07FF          ; $1094F8   |
    STA $07             ; $1094FB   |
    LDA $6CA9,x         ; $1094FD   |
    AND #$3F00          ; $109500   |
    ASL A               ; $109503   |
    STA $09             ; $109504   |
    TYA                 ; $109506   |
    SEC                 ; $109507   |
    SBC #$0020          ; $109508   |
    AND #$01FF          ; $10950B   |
    ORA $09             ; $10950E   |
    TAX                 ; $109510   |

CODE_109511:
    RTS                 ; $109511   |

CODE_109512:
    LDA $18             ; $109512   |
    CLC                 ; $109514   |
    ADC #$0010          ; $109515   |
    STA $14             ; $109518   |
    STZ $00             ; $10951A   |
    LDA $04             ; $10951C   |
    CLC                 ; $10951E   |
    ADC #$0040          ; $10951F   |
    STA $07             ; $109522   |
    LDA $02             ; $109524   |
    CLC                 ; $109526   |
    ADC #$0020          ; $109527   |
    TAX                 ; $10952A   |
    AND #$01E0          ; $10952B   |
    BNE CODE_10955A     ; $10952E   |
    LDA $10             ; $109530   |
    CLC                 ; $109532   |
    ADC #$0010          ; $109533   |
    BIT #$0070          ; $109536   |
    BNE CODE_10953D     ; $109539   |
    INC $00             ; $10953B   |

CODE_10953D:
    TXY                 ; $10953D   |
    TAX                 ; $10953E   |
    LDA $07             ; $10953F   |
    SEC                 ; $109541   |
    SBC #$0400          ; $109542   |
    AND #$07FF          ; $109545   |
    STA $07             ; $109548   |
    LDA $6CA9,x         ; $10954A   |
    AND #$3F00          ; $10954D   |
    ASL A               ; $109550   |
    STA $09             ; $109551   |
    TYA                 ; $109553   |
    AND #$01FF          ; $109554   |
    ORA $09             ; $109557   |
    TAX                 ; $109559   |

CODE_10955A:
    RTS                 ; $10955A   |

    LDY #$0000          ; $10955B   |

CODE_10955E:
    LDX $02             ; $10955E   |
    LDA $7F8000,x       ; $109560   |
    STA $0020,y         ; $109564   |
    AND #$FF00          ; $109567   |
    CMP #$6100          ; $10956A   |
    BEQ CODE_10957C     ; $10956D   |
    CMP #$6200          ; $10956F   |
    BEQ CODE_10957C     ; $109572   |
    LDA #$6106          ; $109574   |
    STA $0020,y         ; $109577   |
    BRA CODE_109588     ; $10957A   |

CODE_10957C:
    LDA $0095           ; $10957C   |
    STA $7F8000,x       ; $10957F   |
    PHY                 ; $109583   |
    JSR CODE_109A2A     ; $109584   |
    PLY                 ; $109587   |

CODE_109588:
    INC $0095           ; $109588   |
    LDA $12             ; $10958B   |
    CLC                 ; $10958D   |
    ADC #$0010          ; $10958E   |
    STA $12             ; $109591   |
    LDA $07             ; $109593   |
    INC A               ; $109595   |
    INC A               ; $109596   |
    STA $07             ; $109597   |
    LDA $02             ; $109599   |
    INC A               ; $10959B   |
    INC A               ; $10959C   |
    STA $02             ; $10959D   |
    BIT #$001E          ; $10959F   |
    BNE CODE_1095C4     ; $1095A2   |
    SEC                 ; $1095A4   |
    SBC #$0020          ; $1095A5   |
    AND #$01FF          ; $1095A8   |
    STA $02             ; $1095AB   |
    LDA $07             ; $1095AD   |
    SEC                 ; $1095AF   |
    SBC #$0420          ; $1095B0   |
    AND #$07FF          ; $1095B3   |
    STA $07             ; $1095B6   |
    LDX $10             ; $1095B8   |
    INX                 ; $1095BA   |
    LDA $6CA9,x         ; $1095BB   |
    AND #$3F00          ; $1095BE   |
    ASL A               ; $1095C1   |
    TSB $02             ; $1095C2   |

CODE_1095C4:
    INY                 ; $1095C4   |
    INY                 ; $1095C5   |
    CPY #$0006          ; $1095C6   |
    BCC CODE_10955E     ; $1095C9   |
    LDA $0009ED         ; $1095CB   |
    TAX                 ; $1095CF   |
    LDA #$FFFF          ; $1095D0   |
    STA $0009EF,x       ; $1095D3   |
    RTS                 ; $1095D7   |

DATA_1095D8:         dw $0000, $A55C, $0000, $0000
DATA_1095E0:         dw $0000, $A55D, $0000, $A55C
DATA_1095E8:         dw $0000, $A55D, $A55B, $0000
DATA_1095F0:         dw $A55A, $A55C, $A55B, $0000
DATA_1095F8:         dw $0000, $0000, $A55A, $0000
DATA_109600:         dw $0000, $0000, $A55B, $0000
DATA_109608:         dw $A55A, $0000, $0000, $0000
DATA_109610:         dw $A55B, $0000, $0000, $A55C
DATA_109618:         dw $0000, $0000, $A55B, $A55D
DATA_109620:         dw $0000, $A55C, $0000, $0000
DATA_109628:         dw $0000, $A55D

    LDY $0095           ; $10962C   |

CODE_10962F:
    PHY                 ; $10962F   |
    LDX $02             ; $109630   |
    TYA                 ; $109632   |
    BEQ CODE_10963D     ; $109633   |
    CPY $0095           ; $109635   |
    BNE CODE_10966C     ; $109638   |
    LDA #$0002          ; $10963A   |

CODE_10963D:
    STA $00             ; $10963D   |
    LDA $7F8000,x       ; $10963F   |
    BEQ CODE_109676     ; $109643   |
    PHX                 ; $109645   |
    SEP #$10            ; $109646   |
    JSL $0DA485         ; $109648   |
    REP #$10            ; $10964C   |
    PLX                 ; $10964E   |
    LDA $93             ; $10964F   |
    SEC                 ; $109651   |
    SBC #$07C0          ; $109652   |
    AND #$FFF0          ; $109655   |
    LSR A               ; $109658   |
    LSR A               ; $109659   |
    TSB $00             ; $10965A   |
    LDA $1070           ; $10965C   |
    ASL A               ; $10965F   |
    ADC $1070           ; $109660   |
    ASL A               ; $109663   |
    ADC $00             ; $109664   |
    TAY                 ; $109666   |
    LDA $95CC,y         ; $109667   |
    BRA CODE_10966F     ; $10966A   |

CODE_10966C:
    LDA #$0000          ; $10966C   |

CODE_10966F:
    STA $7F8000,x       ; $10966F   |
    JSR CODE_109A2A     ; $109673   |

CODE_109676:
    LDA $12             ; $109676   |
    CLC                 ; $109678   |
    ADC #$0010          ; $109679   |
    STA $12             ; $10967C   |
    LDA $91             ; $10967E   |
    CLC                 ; $109680   |
    ADC #$0010          ; $109681   |
    STA $91             ; $109684   |
    LDA $07             ; $109686   |
    INC A               ; $109688   |
    INC A               ; $109689   |
    STA $07             ; $10968A   |
    LDA $02             ; $10968C   |
    INC A               ; $10968E   |
    INC A               ; $10968F   |
    STA $02             ; $109690   |
    BIT #$001E          ; $109692   |
    BNE CODE_1096B7     ; $109695   |
    SEC                 ; $109697   |
    SBC #$0020          ; $109698   |
    AND #$01FF          ; $10969B   |
    STA $02             ; $10969E   |
    LDA $07             ; $1096A0   |
    SEC                 ; $1096A2   |
    SBC #$0420          ; $1096A3   |
    AND #$07FF          ; $1096A6   |
    STA $07             ; $1096A9   |
    LDX $10             ; $1096AB   |
    INX                 ; $1096AD   |
    LDA $6CA9,x         ; $1096AE   |
    AND #$3F00          ; $1096B1   |
    ASL A               ; $1096B4   |
    TSB $02             ; $1096B5   |

CODE_1096B7:
    PLY                 ; $1096B7   |
    DEY                 ; $1096B8   |
    BMI CODE_1096BE     ; $1096B9   |
    JMP CODE_10962F     ; $1096BB   |

CODE_1096BE:
    LDA $0009ED         ; $1096BE   |
    TAX                 ; $1096C2   |
    LDA #$FFFF          ; $1096C3   |
    STA $0009EF,x       ; $1096C6   |
    RTS                 ; $1096CA   |

DATA_1096CB:         db $00, $00, $03, $03, $04, $04, $07, $07
DATA_1096D3:         db $08, $08, $0B, $0B, $0C, $0C, $0F, $0F
DATA_1096DB:         db $10, $10, $13, $13

    LDA $0146           ; $1096DF   |
    CMP #$0009          ; $1096E2   |
    BNE CODE_1096EA     ; $1096E5   |
    JMP CODE_1097D9     ; $1096E7   |

CODE_1096EA:
    LDX $02             ; $1096EA   |
    LDA $7F8000,x       ; $1096EC   |
    AND #$FF00          ; $1096F0   |
    CMP #$A300          ; $1096F3   |
    BNE CODE_109711     ; $1096F6   |
    LDA $00             ; $1096F8   |
    PHA                 ; $1096FA   |
    LDA $02             ; $1096FB   |
    PHA                 ; $1096FD   |
    LDA $07             ; $1096FE   |
    PHA                 ; $109700   |
    JSR CODE_1098A2     ; $109701   |
    JSL $00E013         ; $109704   |
    PLA                 ; $109708   |
    STA $07             ; $109709   |
    PLA                 ; $10970B   |
    STA $02             ; $10970C   |
    PLA                 ; $10970E   |
    STA $00             ; $10970F   |

CODE_109711:
    LDX $02             ; $109711   |
    LDA $95             ; $109713   |
    STA $7F8000,x       ; $109715   |
    JSR CODE_109A2A     ; $109719   |
    LDA $07             ; $10971C   |
    STA $04             ; $10971E   |
    LDA $14             ; $109720   |
    STA $18             ; $109722   |
    JSR CODE_109512     ; $109724   |
    LDA $00             ; $109727   |
    BNE CODE_10975C     ; $109729   |
    LDA $7F8000,x       ; $10972B   |
    AND #$00FF          ; $10972F   |
    TAY                 ; $109732   |
    LDA $96CB,y         ; $109733   |
    AND #$00FF          ; $109736   |
    TAY                 ; $109739   |
    LDA $7F8000,x       ; $10973A   |
    AND #$FF00          ; $10973E   |
    CMP #$6B00          ; $109741   |
    BEQ CODE_109751     ; $109744   |
    CMP #$A300          ; $109746   |
    BNE CODE_10975C     ; $109749   |
    TYA                 ; $10974B   |
    ORA #$A300          ; $10974C   |
    BRA CODE_109755     ; $10974F   |

CODE_109751:
    TYA                 ; $109751   |
    ORA #$6B00          ; $109752   |

CODE_109755:
    STA $7F8000,x       ; $109755   |
    JSR CODE_109A2A     ; $109759   |

CODE_10975C:
    LDA $0009ED         ; $10975C   |
    TAX                 ; $109760   |
    LDA #$FFFF          ; $109761   |
    STA $0009EF,x       ; $109764   |
    RTS                 ; $109768   |

DATA_109769:         dw $05C8, $05DC, $05D2, $07C6
DATA_109771:         dw $8686, $86B0, $B186, $C6B6
DATA_109779:         dw $B7C6, $C6C6, $8AC2, $C38A
DATA_109781:         dw $8B8B, $8A8A, $8BBC, $BD8B
DATA_109789:         dw $AEAC, $AD03, $04AF, $B243
DATA_109791:         dw $44B4, $B5B3, $BE23, $2CBF
DATA_109799:         dw $C1C0, $B9B8, $BA1F, $24BB

DATA_1097A1:         dw $0B9F, $121F, $0F25, $0F18

DATA_1097A9:         dw $0BA0, $1220, $0FA5, $0F98

DATA_1097B1:         dw $0003, $0003, $0000, $0000

DATA_1097B9:         dw $9771, $9777, $977D, $9783

DATA_1097C1:         dw $9774, $977A, $9780, $9786

DATA_1097C9:         dw $9789, $978F, $9795, $979B

DATA_1097D1:         dw $978C, $9792, $9798, $979E

CODE_1097D9:
    LDX $02             ; $1097D9   |
    LDA $7F8000,x       ; $1097DB   |
    BNE CODE_1097E4     ; $1097DF   |
    JMP CODE_10986A     ; $1097E1   |

CODE_1097E4:
    STA $00             ; $1097E4   |

    LDA #$0000          ; $1097E6   |
    STA $7F8000,x       ; $1097E9   |
    LDA #$0002          ; $1097ED   |
    STA $0D07           ; $1097F0   |
    TXA                 ; $1097F3   |
    LDX #$0000          ; $1097F4   |

CODE_1097F7:
    CMP $9769,x         ; $1097F7   |
    BEQ CODE_109803     ; $1097FA   |
    INX                 ; $1097FC   |
    INX                 ; $1097FD   |
    CPX #$FFF8          ; $1097FE   |
    BCC CODE_1097F7     ; $109801   |

CODE_109803:
    STX $08             ; $109803   |
    TXA                 ; $109805   |
    EOR #$0002          ; $109806   |
    TAX                 ; $109809   |
    LDA $9769,x         ; $10980A   |
    TAX                 ; $10980D   |
    LDA $00             ; $10980E   |
    STA $7F8000,x       ; $109810   |
    LDY $08             ; $109814   |
    LDA $97A1,y         ; $109816   |
    STA $00             ; $109819   |
    LDA $97B1,y         ; $10981B   |
    STA $02             ; $10981E   |
    LDA $97B9,y         ; $109820   |
    STA $04             ; $109823   |
    JSR CODE_10986B     ; $109825   |
    LDY $08             ; $109828   |
    LDA $97A9,y         ; $10982A   |
    STA $00             ; $10982D   |
    LDA $97B1,y         ; $10982F   |
    STA $02             ; $109832   |
    LDA $97C1,y         ; $109834   |
    STA $04             ; $109837   |
    JSR CODE_10986B     ; $109839   |
    LDA $08             ; $10983C   |
    EOR #$0002          ; $10983E   |
    TAY                 ; $109841   |
    STA $08             ; $109842   |
    LDA $97A1,y         ; $109844   |
    STA $00             ; $109847   |
    LDA $97B1,y         ; $109849   |
    STA $02             ; $10984C   |
    LDA $97C9,y         ; $10984E   |
    STA $04             ; $109851   |
    JSR CODE_10986B     ; $109853   |
    LDY $08             ; $109856   |
    LDA $97A9,y         ; $109858   |
    STA $00             ; $10985B   |
    LDA $97B1,y         ; $10985D   |
    STA $02             ; $109860   |
    LDA $97D1,y         ; $109862   |
    STA $04             ; $109865   |
    JSR CODE_10986B     ; $109867   |

CODE_10986A:
    RTS                 ; $10986A   |

CODE_10986B:
    PHB                 ; $10986B   |
    PEA $7E48           ; $10986C   |
    PLB                 ; $10986F   |
    PLB                 ; $109870   |
    LDX $4800           ; $109871   |
    LDA $00             ; $109874   |
    STA $0000,x         ; $109876   |
    LDA $02             ; $109879   |
    STA $0002,x         ; $10987B   |
    LDA #$0018          ; $10987E   |
    STA $0004,x         ; $109881   |
    LDA #$0010          ; $109884   |
    STA $0007,x         ; $109887   |
    LDA #$0003          ; $10988A   |
    STA $0008,x         ; $10988D   |
    LDA $04             ; $109890   |
    STA $0005,x         ; $109892   |
    TXA                 ; $109895   |
    CLC                 ; $109896   |
    ADC #$000C          ; $109897   |
    STA $000A,x         ; $10989A   |
    STA $4800           ; $10989D   |
    PLB                 ; $1098A0   |
    RTS                 ; $1098A1   |

CODE_1098A2:
    LDA $0150           ; $1098A2   |
    ASL A               ; $1098A5   |
    TAX                 ; $1098A6   |
    LDA $01E4D9,x       ; $1098A7   |
    STA $00             ; $1098AB   |
    LDX $10             ; $1098AD   |
    LDA $6CAA,x         ; $1098AF   |
    AND #$003F          ; $1098B2   |
    ASL A               ; $1098B5   |
    ADC $00             ; $1098B6   |
    STA $00             ; $1098B8   |
    LDA $02             ; $1098BA   |
    AND #$001E          ; $1098BC   |
    TAX                 ; $1098BF   |
    LDA $01E4E1,x       ; $1098C0   |
    STA $04             ; $1098C4   |
    LDA ($00)           ; $1098C6   |
    ORA $04             ; $1098C8   |
    STA ($00)           ; $1098CA   |
    RTS                 ; $1098CC   |

    JSR CODE_1098A2     ; $1098CD   |
    LDX $02             ; $1098D0   |
    LDA $0095           ; $1098D2   |
    STA $7F8000,x       ; $1098D5   |
    JSR CODE_109A2A     ; $1098D9   |
    LDA $0009ED         ; $1098DC   |
    TAX                 ; $1098E0   |
    LDA #$FFFF          ; $1098E1   |
    STA $0009EF,x       ; $1098E4   |
    RTS                 ; $1098E8   |

    LDX $02             ; $1098E9   |
    LDA $7F8000,x       ; $1098EB   |
    CMP #$0000          ; $1098EF   |
    BNE CODE_10990A     ; $1098F2   |
    LDA $0095           ; $1098F4   |
    STA $7F8000,x       ; $1098F7   |
    JSR CODE_109A2A     ; $1098FB   |
    LDA $0009ED         ; $1098FE   |
    TAX                 ; $109902   |
    LDA #$FFFF          ; $109903   |
    STA $0009EF,x       ; $109906   |

CODE_10990A:
    RTS                 ; $10990A   |

    LDX $02             ; $10990B   |
    LDA $7F8000,x       ; $10990D   |
    CMP #$7C00          ; $109911   |
    BEQ CODE_109919     ; $109914   |
    JMP CODE_109A1D     ; $109916   |

CODE_109919:
    STZ $0E             ; $109919   |
    LDA $07             ; $10991B   |
    STA $04             ; $10991D   |
    LDA $12             ; $10991F   |
    STA $16             ; $109921   |
    LDA $14             ; $109923   |
    STA $18             ; $109925   |
    JSR CODE_109438     ; $109927   |
    LDA $00             ; $10992A   |
    BNE CODE_10995F     ; $10992C   |
    LDA $7F8000,x       ; $10992E   |
    AND #$FF00          ; $109932   |
    TAY                 ; $109935   |
    CMP #$7C00          ; $109936   |
    BNE CODE_109942     ; $109939   |
    LDA #$0008          ; $10993B   |
    STA $0E             ; $10993E   |
    BRA CODE_10995F     ; $109940   |

CODE_109942:
    TYA                 ; $109942   |
    CMP #$7700          ; $109943   |
    BNE CODE_10995F     ; $109946   |
    LDA $7F8000,x       ; $109948   |
    DEC A               ; $10994C   |
    DEC A               ; $10994D   |
    DEC A               ; $10994E   |
    DEC A               ; $10994F   |
    CMP #$777D          ; $109950   |
    BCS CODE_109958     ; $109953   |
    LDA #$0000          ; $109955   |

CODE_109958:
    STA $7F8000,x       ; $109958   |
    JSR CODE_109A2A     ; $10995C   |

CODE_10995F:
    JSR CODE_109481     ; $10995F   |
    LDA $00             ; $109962   |
    BNE CODE_109997     ; $109964   |
    LDA $7F8000,x       ; $109966   |
    AND #$FF00          ; $10996A   |
    TAY                 ; $10996D   |
    CMP #$7C00          ; $10996E   |
    BNE CODE_10997C     ; $109971   |
    LDA $0E             ; $109973   |
    ORA #$0001          ; $109975   |
    STA $0E             ; $109978   |
    BRA CODE_109997     ; $10997A   |

CODE_10997C:
    TYA                 ; $10997C   |
    CMP #$7700          ; $10997D   |
    BNE CODE_109997     ; $109980   |
    LDA $7F8000,x       ; $109982   |
    DEC A               ; $109986   |
    DEC A               ; $109987   |
    CMP #$777D          ; $109988   |
    BCS CODE_109990     ; $10998B   |
    LDA #$0000          ; $10998D   |

CODE_109990:
    STA $7F8000,x       ; $109990   |
    JSR CODE_109A2A     ; $109994   |

CODE_109997:
    JSR CODE_1094CC     ; $109997   |
    LDA $00             ; $10999A   |
    BNE CODE_1099CE     ; $10999C   |
    LDA $7F8000,x       ; $10999E   |
    AND #$FF00          ; $1099A2   |
    TAY                 ; $1099A5   |
    CMP #$7C00          ; $1099A6   |
    BNE CODE_1099B4     ; $1099A9   |
    LDA $0E             ; $1099AB   |
    ORA #$0002          ; $1099AD   |
    STA $0E             ; $1099B0   |
    BRA CODE_1099CE     ; $1099B2   |

CODE_1099B4:
    TYA                 ; $1099B4   |
    CMP #$7700          ; $1099B5   |
    BNE CODE_1099CE     ; $1099B8   |
    LDA $7F8000,x       ; $1099BA   |
    DEC A               ; $1099BE   |
    CMP #$777D          ; $1099BF   |
    BCS CODE_1099C7     ; $1099C2   |
    LDA #$0000          ; $1099C4   |

CODE_1099C7:
    STA $7F8000,x       ; $1099C7   |
    JSR CODE_109A2A     ; $1099CB   |

CODE_1099CE:
    JSR CODE_109512     ; $1099CE   |
    LDA $00             ; $1099D1   |
    BNE CODE_109A08     ; $1099D3   |
    LDA $7F8000,x       ; $1099D5   |
    AND #$FF00          ; $1099D9   |
    TAY                 ; $1099DC   |
    CMP #$7C00          ; $1099DD   |
    BNE CODE_1099EB     ; $1099E0   |
    LDA $0E             ; $1099E2   |
    ORA #$0004          ; $1099E4   |
    STA $0E             ; $1099E7   |
    BRA CODE_109A08     ; $1099E9   |

CODE_1099EB:
    TYA                 ; $1099EB   |
    CMP #$7700          ; $1099EC   |
    BNE CODE_109A08     ; $1099EF   |
    LDA $7F8000,x       ; $1099F1   |
    SEC                 ; $1099F5   |
    SBC #$0008          ; $1099F6   |
    CMP #$777D          ; $1099F9   |
    BCS CODE_109A01     ; $1099FC   |
    LDA #$0000          ; $1099FE   |

CODE_109A01:
    STA $7F8000,x       ; $109A01   |
    JSR CODE_109A2A     ; $109A05   |

CODE_109A08:
    LDX $02             ; $109A08   |
    LDA $04             ; $109A0A   |
    STA $07             ; $109A0C   |
    LDA $0E             ; $109A0E   |
    BEQ CODE_109A16     ; $109A10   |
    CLC                 ; $109A12   |
    ADC #$777C          ; $109A13   |

CODE_109A16:
    STA $7F8000,x       ; $109A16   |
    JSR CODE_109A2A     ; $109A1A   |

CODE_109A1D:
    LDA $0009ED         ; $109A1D   |
    TAX                 ; $109A21   |
    LDA #$FFFF          ; $109A22   |
    STA $0009EF,x       ; $109A25   |
    RTS                 ; $109A29   |

CODE_109A2A:
    TAY                 ; $109A2A   |
    LDA $12             ; $109A2B   |
    CMP #$0130          ; $109A2D   |
    BCS CODE_109A84     ; $109A30   |
    LDA $14             ; $109A32   |
    CMP #$0100          ; $109A34   |
    BCS CODE_109A84     ; $109A37   |
    PHB                 ; $109A39   |
    PEA $0009           ; $109A3A   |
    PLB                 ; $109A3D   |
    PLB                 ; $109A3E   |
    LDA $07             ; $109A3F   |
    BIT #$0400          ; $109A41   |
    BEQ CODE_109A49     ; $109A44   |
    EOR #$0420          ; $109A46   |

CODE_109A49:
    TAX                 ; $109A49   |
    TYA                 ; $109A4A   |
    STA $70409E,x       ; $109A4B   |
    TYA                 ; $109A4F   |
    AND #$FF00          ; $109A50   |
    XBA                 ; $109A53   |
    ASL A               ; $109A54   |
    TAX                 ; $109A55   |
    LDA $4C32A4,x       ; $109A56   |
    STA $00             ; $109A5A   |
    TYA                 ; $109A5C   |
    AND #$00FF          ; $109A5D   |
    ASL A               ; $109A60   |
    ASL A               ; $109A61   |
    ASL A               ; $109A62   |
    ADC $00             ; $109A63   |
    CLC                 ; $109A65   |
    ADC #$33F2          ; $109A66   |
    STA $00             ; $109A69   |
    LDY $09ED           ; $109A6B   |
    LDA $07             ; $109A6E   |
    ORA #$6800          ; $109A70   |
    STA $09EF,y         ; $109A73   |
    LDA $00             ; $109A76   |
    STA $09F1,y         ; $109A78   |
    TYA                 ; $109A7B   |
    CLC                 ; $109A7C   |
    ADC #$0004          ; $109A7D   |
    STA $09ED           ; $109A80   |
    PLB                 ; $109A83   |

CODE_109A84:
    RTS                 ; $109A84   |

CODE_109A85:
    BRA CODE_109A85     ; $109A85   |

    RTL                 ; $109A87   |

DATA_109A88:         dw $401C, $410C, $41FC, $4274
DATA_109A90:         dw $4184, $4094

DATA_109A94:         dw $4076, $4166, $4256, $42CE
DATA_109A9C:         dw $41DE, $40EE

DATA_109AA0:         dw $2860, $2860, $2860, $2860
DATA_109AA8:         dw $2860, $2860

DATA_109AAC:         dw $2860, $2860, $2860, $2860
DATA_109AB4:         dw $2860, $2860

DATA_109AB8:         dw $0089, $008D, $0091, $0093
DATA_109AC0:         dw $008F, $008B

DATA_109AC4:         dw $008A, $008E, $0092, $0094
DATA_109ACC:         dw $0090, $008C

DATA_109AD0:         dw $0095, $0095, $0095, $0095
DATA_109AD8:         dw $0095, $0095

DATA_109ADC:         dw $2644, $5B18, $E97E, $56D0
DATA_109AE4:         dw $74E9, $0058

.gamemode2A
    JSL $008277         ; $109AE8   |
    JSL $00831C         ; $109AEC   |
    JSL $0394B8         ; $109AF0   |
    JSL $008259         ; $109AF4   |
    JSL $00BE26         ; $109AF8   |
    REP #$10            ; $109AFC   |
    LDY $0212           ; $109AFE   |
    LDX $9AB8,y         ; $109B01   |
    STX $10             ; $109B04   |
    LDX $9AC4,y         ; $109B06   |
    STX $12             ; $109B09   |
    LDX $9AD0,y         ; $109B0B   |
    STX $14             ; $109B0E   |
    LDY #$00F3          ; $109B10   |
    JSL $00B3EE         ; $109B13   |
    REP #$30            ; $109B17   |
    LDX $0212           ; $109B19   |
    LDA $9A88,x         ; $109B1C   |
    STA $10             ; $109B1F   |
    LDA $9A94,x         ; $109B21   |
    STA $12             ; $109B24   |
    LDA $9AA0,x         ; $109B26   |
    STA $14             ; $109B29   |
    LDA $9AAC,x         ; $109B2B   |
    STA $16             ; $109B2E   |
    LDA $0383           ; $109B30   |
    ASL A               ; $109B33   |
    TAX                 ; $109B34   |
    LDA $00BA14,x       ; $109B35   |
    STA $18             ; $109B39   |
    LDX #$0094          ; $109B3B   |
    JSL $00BB05         ; $109B3E   |

    LDX #$2A            ; $109B42   |
    JSL $00BDA2         ; $109B44   |
    LDX #$04            ; $109B48   |

CODE_109B4A:
    LDA $9ADC,x         ; $109B4A   |
    STA $4350,x         ; $109B4D   |
    DEX                 ; $109B50   |
    BPL CODE_109B4A     ; $109B51   |
    LDA #$7E            ; $109B53   |
    STA $4377           ; $109B55   |
    LDX #$06            ; $109B58   |

CODE_109B5A:
    LDA $9AE1,x         ; $109B5A   |
    STA $7E5B18,x       ; $109B5D   |
    DEX                 ; $109B61   |
    BPL CODE_109B5A     ; $109B62   |
    LDA #$20            ; $109B64   |
    STA $094A           ; $109B66   |
    REP #$30            ; $109B69   |
    LDA #$0028          ; $109B6B   |
    STA $8F             ; $109B6E   |
    LDA #$00B4          ; $109B70   |
    STA $8D             ; $109B73   |
    STZ $85             ; $109B75   |
    LDA #$0002          ; $109B77   |
    STA $83             ; $109B7A   |
    LDA #$0018          ; $109B7C   |
    STA $10E0           ; $109B7F   |
    LDA #$7FFF          ; $109B82   |
    STA $0948           ; $109B85   |
    STZ $39             ; $109B88   |
    STZ $3D             ; $109B8A   |
    STZ $41             ; $109B8C   |
    LDA #$0100          ; $109B8E   |
    STA $3B             ; $109B91   |
    STA $3F             ; $109B93   |
    STZ $43             ; $109B95   |
    STZ $10DE           ; $109B97   |
    LDY #$0000          ; $109B9A   |
    STY $60F8           ; $109B9D   |
    LDA $A29D,y         ; $109BA0   |
    STA $60BE           ; $109BA3   |
    LDA $A2F5,y         ; $109BA6   |
    STA $61D2           ; $109BA9   |
    LDA #$00D0          ; $109BAC   |
    STA $608C           ; $109BAF   |
    LDA #$00A8          ; $109BB2   |
    STA $6090           ; $109BB5   |
    LDA #$0002          ; $109BB8   |
    STA $60C4           ; $109BBB   |
    SEP #$10            ; $109BBE   |
    LDY #$04            ; $109BC0   |
    LDA #$FFFF          ; $109BC2   |

CODE_109BC5:
    STA $6EB6,y         ; $109BC5   |
    DEY                 ; $109BC8   |
    DEY                 ; $109BC9   |
    BPL CODE_109BC5     ; $109BCA   |
    LDA #$0061          ; $109BCC   |
    LDY #$00            ; $109BCF   |
    JSL $03A366         ; $109BD1   |
    LDA #$0004          ; $109BD5   |
    STA $79D6           ; $109BD8   |
    LDA #$2000          ; $109BDB   |
    STA $61B2           ; $109BDE   |
    LDA #$0000          ; $109BE1   |
    STA $7402           ; $109BE4   |
    LDA #$0020          ; $109BE7   |
    STA $70E2           ; $109BEA   |
    LDA #$00B8          ; $109BED   |
    STA $7182           ; $109BF0   |
    LDA #$0002          ; $109BF3   |
    STA $7400           ; $109BF6   |
    LDA #$003A          ; $109BF9   |
    STA $7042           ; $109BFC   |
    SEP #$20            ; $109BFF   |
    LDA $A772           ; $109C01   |
    STA $10F6           ; $109C04   |
    LDA $A775           ; $109C07   |
    STA $10F7           ; $109C0A   |
    STZ $10F8           ; $109C0D   |
    STZ $10F9           ; $109C10   |
    STZ $10FA           ; $109C13   |
    STZ $10FB           ; $109C16   |
    STZ $10FC           ; $109C19   |
    STZ $10FD           ; $109C1C   |
    STZ $10FE           ; $109C1F   |
    STZ $10FF           ; $109C22   |
    REP #$20            ; $109C25   |
    STZ $6094           ; $109C27   |
    STZ $609C           ; $109C2A   |
    LDX #$08            ; $109C2D   |
    LDA #$B3D9          ; $109C2F   |
    JSL $7EDE44         ; $109C32   |  GSU init routines

    REP #$10            ; $109C36   |
    JSR CODE_109CB2     ; $109C38   |
    JSR CODE_109D74     ; $109C3B   |
    SEP #$30            ; $109C3E   |
    JSL $00E3D7         ; $109C40   |
    REP #$30            ; $109C44   |
    LDX $0212           ; $109C46   |
    JSR ($9C74,x)       ; $109C49   |

    SEP #$30            ; $109C4C   |
    LDX #$06            ; $109C4E   |
    JSL $008543         ; $109C50   |
    LDA #$01            ; $109C54   |
    STA $4D             ; $109C56   |
    STZ $0121           ; $109C58   |
    LDA #$02            ; $109C5B   |
    STA $0125           ; $109C5D   |
    LDA #$50            ; $109C60   |
    STA $4207           ; $109C62   |
    LDA #$D8            ; $109C65   |
    STA $4209           ; $109C67   |
    LDA #$B1            ; $109C6A   |
    STA $4200           ; $109C6C   |
    INC $0118           ; $109C6F   |
    PLB                 ; $109C72   |
    RTL                 ; $109C73   |

DATA_109C74:         dw $9E78
DATA_109C76:         dw $9EF6
DATA_109C78:         dw $A000
DATA_109C7A:         dw $A0BD
DATA_109C7C:         dw $9FB5
DATA_109C7E:         dw $9F3F

; add item to free slot, A: item ID

CODE_109C80:
    PHP                 ; $109C80   |
    SEP #$30            ; $109C81   |
    PHA                 ; $109C83   |
    LDY #$00            ; $109C84   |

CODE_109C86:
    LDA $0357,y         ; $109C86   |
    BEQ CODE_109CA0     ; $109C89   |
    INY                 ; $109C8B   |
    CPY #$1B            ; $109C8C   |
    BNE CODE_109C86     ; $109C8E   |
    LDY #$00            ; $109C90   |
    LDX #$01            ; $109C92   |

CODE_109C94:
    LDA $0357,x         ; $109C94   |
    STA $0357,y         ; $109C97   |
    INX                 ; $109C9A   |
    INY                 ; $109C9B   |
    CPY #$1A            ; $109C9C   |
    BNE CODE_109C94     ; $109C9E   |

CODE_109CA0:
    PLA                 ; $109CA0   |
    STA $0357,y         ; $109CA1   |
    PLP                 ; $109CA4   |
    RTS                 ; $109CA5   |

    JSR CODE_109C80     ; $109CA6   |
    RTL                 ; $109CA9   |

DATA_109CAA:         dw $0020, $0000

DATA_109CAE:         dw $0002, $FFFE


CODE_109CB2:
    SEP #$10            ; $109CB2   |
    STZ $87             ; $109CB4   |
    LDY $83             ; $109CB6   |
    LDA $85             ; $109CB8   |
    CMP $9CAA,y         ; $109CBA   |
    BEQ CODE_109CC7     ; $109CBD   |
    INC $87             ; $109CBF   |
    CLC                 ; $109CC1   |
    ADC $9CAE,y         ; $109CC2   |
    STA $85             ; $109CC5   |

CODE_109CC7:
    STA $3018           ; $109CC7   |
    LDA #$0017          ; $109CCA   |
    STA $3000           ; $109CCD   |
    LDA #$A48C          ; $109CD0   |
    STA $3008           ; $109CD3   |
    LDA $8D             ; $109CD6   |
    SEC                 ; $109CD8   |
    SBC #$0008          ; $109CD9   |
    STA $3004           ; $109CDC   |
    LDA $8F             ; $109CDF   |
    STA $3002           ; $109CE1   |
    LDA #$0000          ; $109CE4   |
    STA $3016           ; $109CE7   |
    LDX #$08            ; $109CEA   |
    LDA #$B348          ; $109CEC   |
    JSL $7EDE44         ; $109CEF   |  GSU init

    LDA $85             ; $109CF3   |
    STA $3018           ; $109CF5   |
    LDA #$0017          ; $109CF8   |
    STA $3000           ; $109CFB   |
    LDA #$A48C          ; $109CFE   |
    STA $3008           ; $109D01   |
    LDA $8D             ; $109D04   |
    SEC                 ; $109D06   |
    SBC #$0008          ; $109D07   |
    STA $3004           ; $109D0A   |
    LDA $8F             ; $109D0D   |
    CLC                 ; $109D0F   |
    ADC #$00B0          ; $109D10   |
    STA $3002           ; $109D13   |
    LDA #$0002          ; $109D16   |
    STA $3016           ; $109D19   |
    LDX #$08            ; $109D1C   |
    LDA #$B348          ; $109D1E   |
    JSL $7EDE44         ; $109D21   |

    REP #$10            ; $109D25   |

CODE_109D27:
    JSL $00BE39         ; $109D27   |

DATA_109D2B:         dw $56D0, $027E, $703A, $0348

    RTS                 ; $109D33   |

DATA_109D34:         dw $68D8, $68D8, $68D8, $68D9
DATA_109D3C:         dw $68D8, $68D8, $3CD6, $FCD6
DATA_109D44:         dw $3CC0, $3CD0, $3CC1, $3CD1
DATA_109D4C:         dw $3CC2, $3CD2, $3CC3, $3CD3
DATA_109D54:         dw $3CC4, $3CD4, $3CC5, $3CD5
DATA_109D5C:         dw $3CC2, $3CD0, $3CC6, $3CD5
DATA_109D64:         dw $FCD5, $FCC5, $0385, $0385
DATA_109D6C:         dw $0385, $0385, $037B, $037B

CODE_109D74:
    LDA $0212           ; $109D74   |
    CMP #$0008          ; $109D77   |
    BNE CODE_109D87     ; $109D7A   |
    LDA $0118           ; $109D7C   |
    CMP #$002A          ; $109D7F   |
    BNE CODE_109D87     ; $109D82   |
    DEC $0379           ; $109D84   |

CODE_109D87:
    LDY #$0000          ; $109D87   |
    LDX #$0000          ; $109D8A   |
    LDA $0379           ; $109D8D   |

CODE_109D90:
    LDY #$0000          ; $109D90   |

CODE_109D93:
    CMP #$000A          ; $109D93   |
    BCC CODE_109D9E     ; $109D96   |
    SBC #$000A          ; $109D98   |
    INY                 ; $109D9B   |
    BRA CODE_109D93     ; $109D9C   |

CODE_109D9E:
    ASL A               ; $109D9E   |
    ASL A               ; $109D9F   |
    STA $00,x           ; $109DA0   |
    TYA                 ; $109DA2   |
    INX                 ; $109DA3   |
    INX                 ; $109DA4   |
    CPX #$0006          ; $109DA5   |
    BNE CODE_109D90     ; $109DA8   |
    LDX $0212           ; $109DAA   |
    LDA $109D34,x       ; $109DAD   |
    PHB                 ; $109DB1   |
    LDX #$007E          ; $109DB2   |
    PHX                 ; $109DB5   |
    PLB                 ; $109DB6   |
    LDY $4800           ; $109DB7   |
    STA $0000,y         ; $109DBA   |
    CLC                 ; $109DBD   |
    ADC #$0020          ; $109DBE   |
    STA $0012,y         ; $109DC1   |
    LDA #$0180          ; $109DC4   |
    STA $0002,y         ; $109DC7   |
    STA $0014,y         ; $109DCA   |
    LDA #$0018          ; $109DCD   |
    STA $0004,y         ; $109DD0   |
    STA $0016,y         ; $109DD3   |
    TYA                 ; $109DD6   |
    CLC                 ; $109DD7   |
    ADC #$000C          ; $109DD8   |
    STA $0005,y         ; $109DDB   |
    CLC                 ; $109DDE   |
    ADC #$0012          ; $109DDF   |
    STA $0017,y         ; $109DE2   |
    LDA #$007E          ; $109DE5   |
    STA $0007,y         ; $109DE8   |
    STA $0019,y         ; $109DEB   |
    LDA #$0006          ; $109DEE   |
    STA $0008,y         ; $109DF1   |
    STA $001A,y         ; $109DF4   |
    TYA                 ; $109DF7   |
    CLC                 ; $109DF8   |
    ADC #$0012          ; $109DF9   |
    STA $000A,y         ; $109DFC   |
    CLC                 ; $109DFF   |
    ADC #$0012          ; $109E00   |
    STA $001C,y         ; $109E03   |
    STA $4800           ; $109E06   |
    PLB                 ; $109E09   |
    PLB                 ; $109E0A   |
    TYA                 ; $109E0B   |
    SEC                 ; $109E0C   |
    SBC #$4802          ; $109E0D   |
    TAX                 ; $109E10   |
    LDY #$0004          ; $109E11   |
    STY $06             ; $109E14   |
    STZ $08             ; $109E16   |
    STZ $0A             ; $109E18   |

CODE_109E1A:
    LDA $0000,y         ; $109E1A   |
    BNE CODE_109E23     ; $109E1D   |
    LDA $08             ; $109E1F   |
    BEQ CODE_109E3D     ; $109E21   |

CODE_109E23:
    LDA $0000,y         ; $109E23   |
    TAY                 ; $109E26   |
    LDA $9D40,y         ; $109E27   |
    STA $7E480E,x       ; $109E2A   |
    LDA $9D42,y         ; $109E2E   |
    STA $7E4820,x       ; $109E31   |
    STA $08             ; $109E35   |
    INC $0A             ; $109E37   |
    INC $0A             ; $109E39   |
    INX                 ; $109E3B   |
    INX                 ; $109E3C   |

CODE_109E3D:
    DEC $06             ; $109E3D   |
    DEC $06             ; $109E3F   |
    LDY $06             ; $109E41   |
    BEQ CODE_109E23     ; $109E43   |
    BPL CODE_109E1A     ; $109E45   |
    LDA #$3C7D          ; $109E47   |
    LDY $0A             ; $109E4A   |

CODE_109E4C:
    CPY #$0006          ; $109E4C   |
    BEQ CODE_109E5F     ; $109E4F   |
    STA $7E480E,x       ; $109E51   |
    STA $7E4820,x       ; $109E55   |
    INX                 ; $109E59   |
    INX                 ; $109E5A   |
    INY                 ; $109E5B   |
    INY                 ; $109E5C   |
    BRA CODE_109E4C     ; $109E5D   |

CODE_109E5F:
    RTS                 ; $109E5F   |

; GSU table
DATA_109E60:         dw $1111, $1111, $1111, $1111
DATA_109E68:         dw $1111, $1111, $1111, $1111
DATA_109E70:         dw $1111, $1515, $1515, $1515

    SEP #$10            ; $109E78   |
    LDY #$80            ; $109E7A   |
    STY $2115           ; $109E7C   |
    LDA #$1801          ; $109E7F   |
    STA $4300           ; $109E82   |
    LDA #$9E60          ; $109E85   |
    STA $6002           ; $109E88   |
    LDA #$0010          ; $109E8B   |
    STA $6000           ; $109E8E   |
    LDA #$0012          ; $109E91   |
    STA $3012           ; $109E94   |
    LDX #$08            ; $109E97   |
    LDA #$D995          ; $109E99   |
    JSL $7EDE44         ; $109E9C   | GSU init
    STZ $2116           ; $109EA0   |
    LDA #$5800          ; $109EA3   |
    STA $4302           ; $109EA6   |
    LDY #$70            ; $109EA9   |
    STY $4304           ; $109EAB   |
    LDA #$1000          ; $109EAE   |
    STA $4305           ; $109EB1   |
    LDY #$01            ; $109EB4   |
    STY $420B           ; $109EB6   |
    LDA #$9E6C          ; $109EB9   |
    STA $6002           ; $109EBC   |
    LDA #$0010          ; $109EBF   |
    STA $6000           ; $109EC2   |
    LDA #$0014          ; $109EC5   |
    STA $3012           ; $109EC8   |
    LDX #$08            ; $109ECB   |
    LDA #$D995          ; $109ECD   |
    JSL $7EDE44         ; $109ED0   | GSU init
    LDA #$0800          ; $109ED4   |
    STA $2116           ; $109ED7   |
    LDA #$5800          ; $109EDA   |
    STA $4302           ; $109EDD   |
    LDY #$70            ; $109EE0   |
    STY $4304           ; $109EE2   |
    LDA #$1000          ; $109EE5   |
    STA $4305           ; $109EE8   |
    LDY #$01            ; $109EEB   |
    STY $420B           ; $109EED   |
    REP #$10            ; $109EF0   |
    JSR CODE_10A68F     ; $109EF2   |
    RTS                 ; $109EF5   |

    SEP #$10            ; $109EF6   |
    LDY #$80            ; $109EF8   |
    STY $2115           ; $109EFA   |
    LDA #$1801          ; $109EFD   |
    STA $4300           ; $109F00   |
    LDA #$9E60          ; $109F03   |
    STA $6002           ; $109F06   |
    LDA #$0010          ; $109F09   |
    STA $6000           ; $109F0C   |
    LDA #$0012          ; $109F0F   |
    STA $3012           ; $109F12   |
    LDX #$08            ; $109F15   |
    LDA #$D995          ; $109F17   |
    JSL $7EDE44         ; $109F1A   | GSU init
    STZ $2116           ; $109F1E   |
    LDY #$70            ; $109F21   |
    STY $4304           ; $109F23   |
    LDY #$01            ; $109F26   |
    LDX #$07            ; $109F28   |

CODE_109F2A:
    LDA #$6100          ; $109F2A   |
    STA $4302           ; $109F2D   |
    LDA #$0120          ; $109F30   |
    STA $4305           ; $109F33   |
    STY $420B           ; $109F36   |
    DEX                 ; $109F39   |
    BNE CODE_109F2A     ; $109F3A   |
    JMP CODE_10B76B     ; $109F3C   |

    SEP #$20            ; $109F3F   |
    LDA $BFB7           ; $109F41   |
    STA $1126           ; $109F44   |
    LDA $BFB8           ; $109F47   |
    STA $1127           ; $109F4A   |
    LDA $BFB9           ; $109F4D   |
    STA $1128           ; $109F50   |
    LDA $BFBA           ; $109F53   |
    STA $1129           ; $109F56   |
    LDA $BFBF           ; $109F59   |
    STA $112A           ; $109F5C   |
    LDA $BFC0           ; $109F5F   |
    STA $112B           ; $109F62   |
    LDA $BFC1           ; $109F65   |
    STA $112C           ; $109F68   |
    LDA $BFC2           ; $109F6B   |
    STA $112D           ; $109F6E   |
    LDA $BFC7           ; $109F71   |
    STA $112E           ; $109F74   |
    LDA $BFC8           ; $109F77   |
    STA $112F           ; $109F7A   |
    LDA $BFC9           ; $109F7D   |
    STA $1130           ; $109F80   |
    LDA $BFCA           ; $109F83   |
    STA $1131           ; $109F86   |
    LDA #$04            ; $109F89   |
    STA $113E           ; $109F8B   |
    STA $113F           ; $109F8E   |
    STA $1140           ; $109F91   |
    STZ $114D           ; $109F94   |
    REP #$20            ; $109F97   |
    LDA #$5800          ; $109F99   |
    STA $1132           ; $109F9C   |
    STA $1134           ; $109F9F   |
    STA $1136           ; $109FA2   |
    LDA #$5000          ; $109FA5   |
    STA $114E           ; $109FA8   |
    STA $1150           ; $109FAB   |
    STA $1152           ; $109FAE   |
    JSR CODE_10BD7F     ; $109FB1   |
    RTS                 ; $109FB4   |

    LDA $0379           ; $109FB5   |
    STA $1176           ; $109FB8   |
    SEP #$30            ; $109FBB   |
    STZ $1165           ; $109FBD   |
    STZ $1166           ; $109FC0   |
    STZ $1167           ; $109FC3   |
    STZ $1183           ; $109FC6   |
    STZ $1174           ; $109FC9   |
    LDA #$60            ; $109FCC   |
    STA $1168           ; $109FCE   |
    LDA #$80            ; $109FD1   |
    STA $1169           ; $109FD3   |
    STZ $116E           ; $109FD6   |
    STZ $116F           ; $109FD9   |
    LDA #$09            ; $109FDC   |
    STA $1179           ; $109FDE   |
    STA $117A           ; $109FE1   |
    STZ $117B           ; $109FE4   |
    LDA #$01            ; $109FE7   |
    STA $1178           ; $109FE9   |
    STZ $117C           ; $109FEC   |
    STZ $117D           ; $109FEF   |
    STZ $117E           ; $109FF2   |
    LDA #$40            ; $109FF5   |
    STA $1180           ; $109FF7   |
    STZ $117F           ; $109FFA   |
    REP #$30            ; $109FFD   |
    RTS                 ; $109FFF   |

    SEP #$10            ; $10A000   |
    LDY #$80            ; $10A002   |
    STY $2115           ; $10A004   |
    LDA #$1801          ; $10A007   |
    STA $4300           ; $10A00A   |
    LDA #$9E6C          ; $10A00D   |
    STA $6002           ; $10A010   |
    LDA #$0010          ; $10A013   |
    STA $6000           ; $10A016   |
    LDA #$0014          ; $10A019   |
    STA $3012           ; $10A01C   |
    LDX #$08            ; $10A01F   |
    LDA #$D995          ; $10A021   |
    JSL $7EDE44         ; $10A024   | GSU init
    STZ $2116           ; $10A028   |
    LDY #$70            ; $10A02B   |
    STY $4304           ; $10A02D   |
    LDY #$01            ; $10A030   |
    LDX #$06            ; $10A032   |

CODE_10A034:
    LDA #$5FE0          ; $10A034   |
    STA $4302           ; $10A037   |
    LDA #$0120          ; $10A03A   |
    STA $4305           ; $10A03D   |
    STY $420B           ; $10A040   |
    DEX                 ; $10A043   |
    BNE CODE_10A034     ; $10A044   |
    LDA #$9E60          ; $10A046   |
    STA $6002           ; $10A049   |
    LDA #$0010          ; $10A04C   |
    STA $6000           ; $10A04F   |
    LDA #$0012          ; $10A052   |
    STA $3012           ; $10A055   |
    LDX #$08            ; $10A058   |
    LDA #$D995          ; $10A05A   |
    JSL $7EDE44         ; $10A05D   | GSU init
    LDA #$5800          ; $10A061   |
    STA $4302           ; $10A064   |
    LDY #$70            ; $10A067   |
    STY $4304           ; $10A069   |
    LDA #$0900          ; $10A06C   |
    STA $4305           ; $10A06F   |
    LDY #$01            ; $10A072   |
    STY $420B           ; $10A074   |
    LDA #$9E6C          ; $10A077   |
    STA $6002           ; $10A07A   |
    LDA #$0010          ; $10A07D   |
    STA $6000           ; $10A080   |
    LDA #$0014          ; $10A083   |
    STA $3012           ; $10A086   |
    LDX #$08            ; $10A089   |
    LDA #$D995          ; $10A08B   |
    JSL $7EDE44         ; $10A08E   | GSU init
    LDA #$0800          ; $10A092   |
    STA $2116           ; $10A095   |
    LDA #$5800          ; $10A098   |
    STA $4302           ; $10A09B   |
    LDY #$70            ; $10A09E   |
    STY $4304           ; $10A0A0   |
    LDA #$1000          ; $10A0A3   |
    STA $4305           ; $10A0A6   |
    LDY #$01            ; $10A0A9   |
    STY $420B           ; $10A0AB   |
    JMP CODE_10CDA4     ; $10A0AE   |

; GSU table
DATA_10A0B1:         dw $1115, $1111, $1111, $1111
DATA_10A0B9:         dw $1111, $1111

    SEP #$10            ; $10A0BD   |
    LDY #$80            ; $10A0BF   |
    STY $2115           ; $10A0C1   |
    LDA #$1801          ; $10A0C4   |
    STA $4300           ; $10A0C7   |
    LDA #$A0B1          ; $10A0CA   |
    STA $6002           ; $10A0CD   |
    LDA #$0010          ; $10A0D0   |
    STA $6000           ; $10A0D3   |
    LDA #$0016          ; $10A0D6   |
    STA $3012           ; $10A0D9   |
    LDX #$08            ; $10A0DC   |
    LDA #$D995          ; $10A0DE   |
    JSL $7EDE44         ; $10A0E1   | GSU init
    STZ $2116           ; $10A0E5   |
    LDA #$5800          ; $10A0E8   |
    STA $4302           ; $10A0EB   |
    LDY #$70            ; $10A0EE   |
    STY $4304           ; $10A0F0   |
    LDA #$1000          ; $10A0F3   |
    STA $4305           ; $10A0F6   |
    LDY #$01            ; $10A0F9   |
    STY $420B           ; $10A0FB   |
    LDA #$9E6C          ; $10A0FE   |
    STA $6002           ; $10A101   |
    LDA #$0010          ; $10A104   |
    STA $6000           ; $10A107   |
    LDA #$0014          ; $10A10A   |
    STA $3012           ; $10A10D   |
    LDX #$08            ; $10A110   |
    LDA #$D995          ; $10A112   |
    JSL $7EDE44         ; $10A115   | GSU init
    LDA #$0800          ; $10A119   |
    STA $2116           ; $10A11C   |
    LDA #$5800          ; $10A11F   |
    STA $4302           ; $10A122   |
    LDY #$70            ; $10A125   |
    STY $4304           ; $10A127   |
    LDA #$1000          ; $10A12A   |
    STA $4305           ; $10A12D   |
    LDY #$01            ; $10A130   |
    STY $420B           ; $10A132   |
    REP #$10            ; $10A135   |
    JSR CODE_10D205     ; $10A137   |
    RTS                 ; $10A13A   |

.gamemode2C
    JSL $008259         ; $10A13B   |
    JSL $0394CF         ; $10A13F   |
    REP #$30            ; $10A143   |
    JSR CODE_10A175     ; $10A145   |
    LDX $0212           ; $10A148   |
    JSR ($A169,x)       ; $10A14B   |

    JSR CODE_10A21C     ; $10A14E   |
    JSR CODE_10A33D     ; $10A151   |
    SEP #$30            ; $10A154   |
    JSL $04FA67         ; $10A156   |
    REP #$20            ; $10A15A   |
    LDX #$08            ; $10A15C   |
    LDA #$B1EF          ; $10A15E   |
    JSL $7EDE44         ; $10A161   |  GSU init

    SEP #$20            ; $10A165   |
    PLB                 ; $10A167   |
    RTL                 ; $10A168   |

DATA_10A169:         dw $A26F
DATA_10A16B:         dw $B5CE
DATA_10A16D:         dw $CD4F
DATA_10A16F:         dw $D181
DATA_10A171:         dw $C497
DATA_10A173:         dw $BD5D

CODE_10A175:
    LDY $6092           ; $10A175   |
    LDA #$00C8          ; $10A178   |
    STA $6000,y         ; $10A17B   |
    STA $6008,y         ; $10A17E   |
    LDA #$00D8          ; $10A181   |
    STA $6010,y         ; $10A184   |
    STA $6018,y         ; $10A187   |
    LDA #$0018          ; $10A18A   |
    STA $6020,y         ; $10A18D   |
    STA $6028,y         ; $10A190   |
    LDA #$0028          ; $10A193   |
    STA $6030,y         ; $10A196   |
    STA $6038,y         ; $10A199   |
    LDA #$00C0          ; $10A19C   |
    STA $6002,y         ; $10A19F   |
    STA $6012,y         ; $10A1A2   |
    STA $6022,y         ; $10A1A5   |
    STA $6032,y         ; $10A1A8   |
    LDA #$00D0          ; $10A1AB   |
    STA $600A,y         ; $10A1AE   |
    STA $601A,y         ; $10A1B1   |
    STA $602A,y         ; $10A1B4   |
    STA $603A,y         ; $10A1B7   |
    LDA #$0F0D          ; $10A1BA   |
    STA $6004,y         ; $10A1BD   |
    STA $6024,y         ; $10A1C0   |
    LDA #$0F2D          ; $10A1C3   |
    STA $600C,y         ; $10A1C6   |
    STA $602C,y         ; $10A1C9   |
    LDA #$4F0D          ; $10A1CC   |
    STA $6014,y         ; $10A1CF   |
    STA $6034,y         ; $10A1D2   |
    LDA #$4F2D          ; $10A1D5   |
    STA $601C,y         ; $10A1D8   |
    STA $603C,y         ; $10A1DB   |
    LDA #$4002          ; $10A1DE   |
    STA $6006,y         ; $10A1E1   |
    STA $600E,y         ; $10A1E4   |
    STA $6016,y         ; $10A1E7   |
    STA $601E,y         ; $10A1EA   |
    STA $6026,y         ; $10A1ED   |
    STA $602E,y         ; $10A1F0   |
    STA $6036,y         ; $10A1F3   |
    STA $603E,y         ; $10A1F6   |
    TYA                 ; $10A1F9   |
    CLC                 ; $10A1FA   |
    ADC #$0040          ; $10A1FB   |
    STA $6092           ; $10A1FE   |
    RTS                 ; $10A201   |

DATA_10A202:         dw $44A6, $48C7, $4CE8, $5109

DATA_10A20A:         dw $001F, $023F, $037F, $03F3
DATA_10A212:         dw $0327, $7F20, $7E66, $7D77
DATA_10A21A:         dw $7C1F

CODE_10A21C:
    LDA $30             ; $10A21C   |
    AND #$0007          ; $10A21E   |
    BNE CODE_10A26E     ; $10A221   |
    INC $10E2           ; $10A223   |
    LDA $10E2           ; $10A226   |
    ASL A               ; $10A229   |
    TAY                 ; $10A22A   |
    CPY #$0012          ; $10A22B   |
    BNE CODE_10A236     ; $10A22E   |
    LDY #$0000          ; $10A230   |
    STY $10E2           ; $10A233   |

CODE_10A236:
    LDX #$0010          ; $10A236   |

CODE_10A239:
    LDA $A20A,y         ; $10A239   |
    STA $702026,x       ; $10A23C   |
    INY                 ; $10A240   |
    INY                 ; $10A241   |
    CPY #$0012          ; $10A242   |
    BNE CODE_10A24A     ; $10A245   |
    LDY #$0000          ; $10A247   |

CODE_10A24A:
    DEX                 ; $10A24A   |
    DEX                 ; $10A24B   |
    BPL CODE_10A239     ; $10A24C   |
    INC $10E4           ; $10A24E   |
    LDA $10E4           ; $10A251   |
    AND #$0003          ; $10A254   |
    ASL A               ; $10A257   |
    TAY                 ; $10A258   |
    LDX #$0006          ; $10A259   |

CODE_10A25C:
    LDA $A202,y         ; $10A25C   |
    STA $702038,x       ; $10A25F   |
    DEY                 ; $10A263   |
    DEY                 ; $10A264   |
    BPL CODE_10A26A     ; $10A265   |
    LDY #$0006          ; $10A267   |

CODE_10A26A:
    DEX                 ; $10A26A   |
    DEX                 ; $10A26B   |
    BPL CODE_10A25C     ; $10A26C   |

CODE_10A26E:
    RTS                 ; $10A26E   |

    LDA $10DE           ; $10A26F   |
    ASL A               ; $10A272   |
    TAX                 ; $10A273   |
    JMP ($A277,x)       ; $10A274   |

DATA_10A277:         dw $A41C
DATA_10A279:         dw $A427
DATA_10A27B:         dw $A444
DATA_10A27D:         dw $A466
DATA_10A27F:         dw $A481
DATA_10A281:         dw $A4EC
DATA_10A283:         dw $A549
DATA_10A285:         dw $A5B3
DATA_10A287:         dw $A70A
DATA_10A289:         dw $AE80
DATA_10A28B:         dw $AB90
DATA_10A28D:         dw $ABCD
DATA_10A28F:         dw $A5C7
DATA_10A291:         dw $A9BE
DATA_10A293:         dw $B00E
DATA_10A295:         dw $B046
DATA_10A297:         dw $A621
DATA_10A299:         dw $B49E
DATA_10A29B:         dw $B4BB

DATA_10A29D:         dw $0046, $0047, $0046, $004D
DATA_10A2A5:         dw $0044, $0045, $0044, $002F
DATA_10A2AD:         dw $002C, $002D, $002E, $002F
DATA_10A2B5:         dw $0030, $0031, $0032, $0033
DATA_10A2BD:         dw $0034, $004C, $00DA, $00DB
DATA_10A2C5:         dw $00DC, $00DD, $0011, $0012
DATA_10A2CD:         dw $0011, $00DE, $006B, $006C
DATA_10A2D5:         dw $006D, $006E, $00DF, $00E0

DATA_10A2DD:         dw $0000, $000E, $0022, $0032
DATA_10A2E5:         dw $003C, $003E

DATA_10A2E9:         dw $000E, $0022, $0032, $003C
DATA_10A2F1:         dw $0040, $0040

DATA_10A2F5:         dw $0006, $0006, $0006, $0006
DATA_10A2FD:         dw $0006, $0006, $0006, $0001
DATA_10A305:         dw $0001, $0004, $0001, $0008
DATA_10A30D:         dw $0004, $0001, $0001, $0001
DATA_10A315:         dw $0005, $0004, $0008, $0004
DATA_10A31D:         dw $0008, $000C, $0004, $0004
DATA_10A325:         dw $0004, $0008, $0020, $0004
DATA_10A32D:         dw $0004, $8000, $0010, $0010
DATA_10A335:         dw $0004, $0004, $0004, $0004

CODE_10A33D:
    LDA #$0030          ; $10A33D   |
    STA $6126           ; $10A340   |
    LDX $10F0           ; $10A343   |
    JSR ($A37C,x)       ; $10A346   |

    LDA $30             ; $10A349   |
    AND #$0007          ; $10A34B   |
    BNE CODE_10A35E     ; $10A34E   |
    LDA $30             ; $10A350   |
    AND #$0018          ; $10A352   |
    LSR A               ; $10A355   |
    LSR A               ; $10A356   |
    TAY                 ; $10A357   |
    LDA $A335,y         ; $10A358   |
    STA $7402           ; $10A35B   |

CODE_10A35E:
    SEP #$10            ; $10A35E   |
    PHB                 ; $10A360   |
    LDX #$06            ; $10A361   |
    PHX                 ; $10A363   |
    PLB                 ; $10A364   |
    PHD                 ; $10A365   |
    LDA #$7960          ; $10A366   |
    TCD                 ; $10A369   |
    LDX #$00            ; $10A36A   |
    STX $7972           ; $10A36C   |
    JSL $06BCEC         ; $10A36F   |
    JSL $008AB6         ; $10A373   |
    PLD                 ; $10A377   |
    PLB                 ; $10A378   |
    REP #$10            ; $10A379   |
    RTS                 ; $10A37B   |

DATA_10A37C:         dw $A388
DATA_10A37E:         dw $A3AB
DATA_10A380:         dw $A3CA
DATA_10A382:         dw $A388
DATA_10A384:         dw $A388
DATA_10A386:         dw $A388

    DEC $61D2           ; $10A388   |
    BNE CODE_10A3AA     ; $10A38B   |
    LDA $60F8           ; $10A38D   |
    INC A               ; $10A390   |
    INC A               ; $10A391   |
    CMP $A2E9,x         ; $10A392   |
    BNE CODE_10A39A     ; $10A395   |
    LDA $A2DD,x         ; $10A397   |

CODE_10A39A:
    STA $60F8           ; $10A39A   |
    TAY                 ; $10A39D   |
    LDA $A29D,y         ; $10A39E   |
    STA $60BE           ; $10A3A1   |
    LDA $A2F5,y         ; $10A3A4   |
    STA $61D2           ; $10A3A7   |

CODE_10A3AA:
    RTS                 ; $10A3AA   |

    DEC $61D2           ; $10A3AB   |
    BNE CODE_10A3AA     ; $10A3AE   |
    LDA $60F8           ; $10A3B0   |
    INC A               ; $10A3B3   |
    INC A               ; $10A3B4   |
    CMP $A2E9,x         ; $10A3B5   |
    BNE CODE_10A39A     ; $10A3B8   |
    LDA #$0020          ; $10A3BA   |\ play sound #$0020
    JSL $0085D2         ; $10A3BD   |/
    LDX #$0000          ; $10A3C1   |
    STX $10F0           ; $10A3C4   |
    TXA                 ; $10A3C7   |
    BRA CODE_10A39A     ; $10A3C8   |

    DEC $61D2           ; $10A3CA   |
    BNE CODE_10A3FA     ; $10A3CD   |
    LDA $60F8           ; $10A3CF   |
    INC A               ; $10A3D2   |
    INC A               ; $10A3D3   |
    CMP $A2E9,x         ; $10A3D4   |
    BNE CODE_10A3DC     ; $10A3D7   |
    LDA $A2DD,x         ; $10A3D9   |

CODE_10A3DC:
    STA $60F8           ; $10A3DC   |
    TAY                 ; $10A3DF   |
    CMP #$0024          ; $10A3E0   |
    BNE CODE_10A3EE     ; $10A3E3   |
    LDA #$FC00          ; $10A3E5   |
    STA $60AA           ; $10A3E8   |
    INC $60C0           ; $10A3EB   |

CODE_10A3EE:
    LDA $A29D,y         ; $10A3EE   |
    STA $60BE           ; $10A3F1   |
    LDA $A2F5,y         ; $10A3F4   |
    STA $61D2           ; $10A3F7   |

CODE_10A3FA:
    LDA $60C0           ; $10A3FA   |
    BEQ CODE_10A41B     ; $10A3FD   |
    LDA $60AA           ; $10A3FF   |
    CLC                 ; $10A402   |
    ADC #$0040          ; $10A403   |
    STA $60AA           ; $10A406   |
    CLC                 ; $10A409   |
    ADC $608F           ; $10A40A   |
    CMP #$A800          ; $10A40D   |
    BCC CODE_10A418     ; $10A410   |
    STZ $60C0           ; $10A412   |
    LDA #$A800          ; $10A415   |

CODE_10A418:
    STA $608F           ; $10A418   |

CODE_10A41B:
    RTS                 ; $10A41B   |

    DEC $10E0           ; $10A41C   |
    BNE CODE_10A426     ; $10A41F   |
    INC $10DE           ; $10A421   |
    STZ $83             ; $10A424   |

CODE_10A426:
    RTS                 ; $10A426   |

    JSR CODE_109CB2     ; $10A427   |
    LDA $87             ; $10A42A   |
    BNE CODE_10A437     ; $10A42C   |
    LDA #$0030          ; $10A42E   |
    STA $10E0           ; $10A431   |
    INC $10DE           ; $10A434   |

CODE_10A437:
    RTS                 ; $10A437   |

DATA_10A438:         dw $0028, $0058, $00E8, $0118
DATA_10A440:         dw $00B8, $0088

    DEC $10E0           ; $10A444   |
    BNE CODE_10A459     ; $10A447   |
    LDX $0212           ; $10A449   |
    LDA $A438,x         ; $10A44C   |
    STA $704070         ; $10A44F   |
    INC $0D0F           ; $10A453   |
    INC $10DE           ; $10A456   |

CODE_10A459:
    RTS                 ; $10A459   |

DATA_10A45A:         dw $0010, $000D, $000C, $000D
DATA_10A462:         dw $0009, $000C

    SEP #$30                A:0000 X:0000 Y:0000 P:EnvmXdIzc; $10A466   |
    JSL $01DE54         ; $10A468   |
    REP #$30            ; $10A46C   |
    JSR CODE_109CB2     ; $10A46E   |
    LDA $0D0F           ; $10A471   |
    BNE CODE_10A480     ; $10A474   |
    LDY $0212           ; $10A476   |
    LDX $10DE           ; $10A479   |
    INX                 ; $10A47C   |
    STX $10DE           ; $10A47D   |

CODE_10A480:
    RTS                 ; $10A480   |

    LDA $30             ; $10A481   |
    AND #$0001          ; $10A483   |
    BNE CODE_10A4CB     ; $10A486   |
    LDA $0948           ; $10A488   |
    SEC                 ; $10A48B   |
    SBC #$0421          ; $10A48C   |
    STA $0948           ; $10A48F   |
    BNE CODE_10A4CB     ; $10A492   |
    LDA #$0046          ; $10A494   |\ play sound #$0046
    JSL $0085D2         ; $10A497   |/
    INC $10DE           ; $10A49B   |
    LDY $0212           ; $10A49E   |
    CPY #$000A          ; $10A4A1   |
    BNE CODE_10A4CB     ; $10A4A4   |
    SEP #$20            ; $10A4A6   |
    LDA #$10            ; $10A4A8   |
    STA $0969           ; $10A4AA   |
    LDA #$91            ; $10A4AD   |
    STA $096C           ; $10A4AF   |
    LDA #$30            ; $10A4B2   |
    STA $0966           ; $10A4B4   |
    STZ $0964           ; $10A4B7   |
    STZ $0965           ; $10A4BA   |
    LDY #$4A53          ; $10A4BD   |
    INC $114D           ; $10A4C0   |
    STY $0948           ; $10A4C3   |
    REP #$20            ; $10A4C6   |
    JMP CODE_10A51C     ; $10A4C8   |

CODE_10A4CB:
    LDY $0212           ; $10A4CB   |
    CPY #$0008          ; $10A4CE   |
    BNE CODE_10A4EB     ; $10A4D1   |
    LDA $0379           ; $10A4D3   |
    INC A               ; $10A4D6   |
    CMP #$0001          ; $10A4D7   |
    BNE CODE_10A4EB     ; $10A4DA   |
    LDA #$0001          ; $10A4DC   |
    STA $0379           ; $10A4DF   |
    LDA #$001F          ; $10A4E2   |
    STA $0118           ; $10A4E5   |
    STZ $0385           ; $10A4E8   |

CODE_10A4EB:
    RTS                 ; $10A4EB   |

    LDA $3B             ; $10A4EC   |
    SEC                 ; $10A4EE   |
    SBC #$0008          ; $10A4EF   |
    STA $3B             ; $10A4F2   |
    STA $3F             ; $10A4F4   |
    BNE CODE_10A514     ; $10A4F6   |
    LDA #$0046          ; $10A4F8   |\ play sound #$0046
    JSL $0085D2         ; $10A4FB   |/
    INC $10DE           ; $10A4FF   |
    STZ $10EC           ; $10A502   |
    LDY $10EC           ; $10A505   |
    LDA $A535,y         ; $10A508   |
    STA $10E6           ; $10A50B   |
    LDA $A53F,y         ; $10A50E   |
    STA $10E8           ; $10A511   |

CODE_10A514:
    LDX $0212           ; $10A514   |
    CPX #$000A          ; $10A517   |
    BNE CODE_10A534     ; $10A51A   |

CODE_10A51C:
    SEP #$10            ; $10A51C   |
    LDA $3B             ; $10A51E   |
    STA $3002           ; $10A520   |
    LDX #$08            ; $10A523   |
    LDA #$B3F5          ; $10A525   |
    JSL $7EDE44         ; $10A528   | GSU init
    REP #$10            ; $10A52C   |
    JSR CODE_109D27     ; $10A52E   |
    JMP CODE_10C017     ; $10A531   |

CODE_10A534:
    RTS                 ; $10A534   |

DATA_10A535:         dw $0000, $0000, $0000, $0000
DATA_10A53D:         dw $0000

DATA_10A53F:         dw $0005, $0004, $0003, $0002
DATA_10A547:         dw $0001

    LDA $10E6           ; $10A549   |
    SEC                 ; $10A54C   |
    SBC #$8000          ; $10A54D   |
    STA $10E6           ; $10A550   |
    LDA $10E8           ; $10A553   |
    SBC #$0000          ; $10A556   |
    STA $10E8           ; $10A559   |
    LDA $10E6           ; $10A55C   |
    CLC                 ; $10A55F   |
    ADC $10EA           ; $10A560   |
    STA $10EA           ; $10A563   |
    LDA $3B             ; $10A566   |
    ADC $10E8           ; $10A568   |
    STA $3B             ; $10A56B   |
    STA $3F             ; $10A56D   |
    BPL CODE_10A5A4     ; $10A56F   |
    LDA #$0046          ; $10A571   |\ play sound #$0046
    JSL $0085D2         ; $10A574   |/
    STZ $10EA           ; $10A578   |
    STZ $3B             ; $10A57B   |
    STZ $3F             ; $10A57D   |
    LDA $10EC           ; $10A57F   |
    INC A               ; $10A582   |
    INC A               ; $10A583   |
    STA $10EC           ; $10A584   |
    TAY                 ; $10A587   |
    CPY #$000A          ; $10A588   |
    BNE CODE_10A598     ; $10A58B   |
    INC $10DE           ; $10A58D   |
    LDA #$0030          ; $10A590   |
    STA $10E0           ; $10A593   |
    BRA CODE_10A5A4     ; $10A596   |

CODE_10A598:
    LDA $A535,y         ; $10A598   |
    STA $10E6           ; $10A59B   |
    LDA $A53F,y         ; $10A59E   |
    STA $10E8           ; $10A5A1   |

CODE_10A5A4:
    JMP CODE_10A514     ; $10A5A4   |

DATA_10A5A7:         dw $0005, $0005, $0010, $0015
DATA_10A5AF:         dw $0010, $0029

    DEC $10E0           ; $10A5B3   |
    BNE CODE_10A5C4     ; $10A5B6   |
    LDY $0212           ; $10A5B8   |
    LDA $A5A7,y         ; $10A5BB   |
    STA $10E0           ; $10A5BE   |
    INC $10DE           ; $10A5C1   |

CODE_10A5C4:
    JMP CODE_10A514     ; $10A5C4   |

    SEP #$30            ; $10A5C7   |
    JSL $01DE5A         ; $10A5C9   |
    REP #$30            ; $10A5CD   |
    JSR CODE_109D27     ; $10A5CF   |
    LDA $0D0F           ; $10A5D2   |
    BNE CODE_10A620     ; $10A5D5   |
    JSR CODE_10AE80     ; $10A5D7   |
    LDX #$0008          ; $10A5DA   |
    LDA $704094         ; $10A5DD   |
    BEQ CODE_10A61D     ; $10A5E1   |
    LDY $0212           ; $10A5E3   |
    CPY #$0000          ; $10A5E6   |
    BNE CODE_10A619     ; $10A5E9   |
    SEP #$30            ; $10A5EB   |
    LDY #$06            ; $10A5ED   |

CODE_10A5EF:
    LDA $10F9,y         ; $10A5EF   |
    BNE CODE_10A5F9     ; $10A5F2   |
    DEY                 ; $10A5F4   |
    BPL CODE_10A5EF     ; $10A5F5   |
    BRA CODE_10A617     ; $10A5F7   |

CODE_10A5F9:
    REP #$30            ; $10A5F9   |
    LDA #$0005          ; $10A5FB   |
    STA $4D             ; $10A5FE   |
    LDA #$0090          ; $10A600   |
    STA $10E0           ; $10A603   |
    LDX #$0004          ; $10A606   |
    STX $10F0           ; $10A609   |
    LDA $A2DD,x         ; $10A60C   |
    JSR CODE_10A39A     ; $10A60F   |
    SEP #$30            ; $10A612   |
    JSR CODE_10A8F6     ; $10A614   |

CODE_10A617:
    REP #$30            ; $10A617   |

CODE_10A619:
    LDX $10DE           ; $10A619   |
    INX                 ; $10A61C   |

CODE_10A61D:
    STX $10DE           ; $10A61D   |

CODE_10A620:
    RTS                 ; $10A620   |

    JSR CODE_10AE80     ; $10A621   |
    LDA $37             ; $10A624   |
    AND #$00F0          ; $10A626   |
    ORA $38             ; $10A629   |
    BNE CODE_10A632     ; $10A62B   |
    DEC $10E0           ; $10A62D   |
    BNE CODE_10A643     ; $10A630   |

CODE_10A632:
    LDA #$001F          ; $10A632   |
    STA $0118           ; $10A635   |
    STZ $0385           ; $10A638   |
    SEP #$30            ; $10A63B   |
    JSL $108279         ; $10A63D   |
    REP #$30            ; $10A641   |

CODE_10A643:
    LDX $0212           ; $10A643   |
    CPX #$000A          ; $10A646   |
    BNE CODE_10A64E     ; $10A649   |
    JMP CODE_10C017     ; $10A64B   |

CODE_10A64E:
    RTS                 ; $10A64E   |

DATA_10A64F:         dw $060A, $0805, $0900, $0102
DATA_10A657:         dw $060A, $0807, $0900, $0101
DATA_10A65F:         dw $0A0A, $0207, $0B03, $0101
DATA_10A667:         dw $0A0A, $0706, $0506, $0101
DATA_10A66F:         dw $070A, $0302, $010B, $0101
DATA_10A677:         dw $0A0A, $070A, $0707, $0101
DATA_10A67F:         dw $060A, $0006, $0109, $0101
DATA_10A687:         dw $0A0A, $0606, $0907, $0101

CODE_10A68F:
    JSL $008408         ; $10A68F   |
    SEP #$30            ; $10A693   |
    LDA $7970           ; $10A695   |
    AND #$07            ; $10A698   |
    TAX                 ; $10A69A   |
    LDA #$00            ; $10A69B   |

CODE_10A69D:
    DEX                 ; $10A69D   |
    BMI CODE_10A6A5     ; $10A69E   |
    CLC                 ; $10A6A0   |
    ADC #$08            ; $10A6A1   |
    BRA CODE_10A69D     ; $10A6A3   |

CODE_10A6A5:
    TAY                 ; $10A6A5   |
    REP #$20            ; $10A6A6   |
    LDA $A64F,y         ; $10A6A8   |
    STA $00             ; $10A6AB   |
    LDA $A651,y         ; $10A6AD   |
    STA $02             ; $10A6B0   |
    LDA $A653,y         ; $10A6B2   |
    STA $04             ; $10A6B5   |
    LDA $A655,y         ; $10A6B7   |
    STA $06             ; $10A6BA   |
    LDA $A657,y         ; $10A6BC   |
    STA $08             ; $10A6BF   |
    SEP #$20            ; $10A6C1   |
    LDA #$08            ; $10A6C3   |
    STA $0A             ; $10A6C5   |
    LDY #$00            ; $10A6C7   |

CODE_10A6C9:
    JSL $008408         ; $10A6C9   |
    LDA $0A             ; $10A6CD   |
    STA $4202           ; $10A6CF   |
    LDA $7970           ; $10A6D2   |
    STA $4203           ; $10A6D5   |
    NOP                 ; $10A6D8   |
    NOP                 ; $10A6D9   |
    NOP                 ; $10A6DA   |
    NOP                 ; $10A6DB   |
    REP #$20            ; $10A6DC   |
    LDA $4216           ; $10A6DE   |
    XBA                 ; $10A6E1   |
    SEP #$20            ; $10A6E2   |
    AND #$0F            ; $10A6E4   |
    TAX                 ; $10A6E6   |
    LDA $00,x           ; $10A6E7   |
    STA $1104,y         ; $10A6E9   |
    INY                 ; $10A6EC   |
    CPY #$07            ; $10A6ED   |
    BEQ CODE_10A6FE     ; $10A6EF   |
    DEC $0A             ; $10A6F1   |

CODE_10A6F3:
    CPX $0A             ; $10A6F3   |
    BEQ CODE_10A6C9     ; $10A6F5   |
    LDA $01,x           ; $10A6F7   |
    STA $00,x           ; $10A6F9   |
    INX                 ; $10A6FB   |
    BRA CODE_10A6F3     ; $10A6FC   |

CODE_10A6FE:
    TXA                 ; $10A6FE   |
    EOR #$01            ; $10A6FF   |
    TAX                 ; $10A701   |
    LDA $00,x           ; $10A702   |
    STA $110B           ; $10A704   |
    REP #$30            ; $10A707   |
    RTS                 ; $10A709   |

    SEP #$30            ; $10A70A   |
    LDA $7978           ; $10A70C   |
    BEQ CODE_10A716     ; $10A70F   |
    JSR CODE_10AE80     ; $10A711   |
    BRA CODE_10A76F     ; $10A714   |

CODE_10A716:
    LDA $10F3           ; $10A716   |
    CMP #$0A            ; $10A719   |
    BNE CODE_10A739     ; $10A71B   |
    REP #$30            ; $10A71D   |
    LDX #$0006          ; $10A71F   |
    STX $10F0           ; $10A722   |
    LDA $A2DD,x         ; $10A725   |
    JSR CODE_10A39A     ; $10A728   |
    SEP #$30            ; $10A72B   |
    LDA #$10            ; $10A72D   |
    STA $10DE           ; $10A72F   |
    LDA #$C0            ; $10A732   |
    STA $10E0           ; $10A734   |
    BRA CODE_10A76F     ; $10A737   |

CODE_10A739:
    LDA $1148           ; $10A739   |
    CMP #$07            ; $10A73C   |
    BNE CODE_10A75F     ; $10A73E   |
    JSR CODE_10A8F6     ; $10A740   |
    REP #$30            ; $10A743   |
    LDX #$0004          ; $10A745   |
    STX $10F0           ; $10A748   |
    LDA $A2DD,x         ; $10A74B   |
    JSR CODE_10A39A     ; $10A74E   |
    SEP #$30            ; $10A751   |
    LDA #$0E            ; $10A753   |
    STA $10DE           ; $10A755   |
    LDA #$60            ; $10A758   |
    STA $10E0           ; $10A75A   |
    BRA CODE_10A76F     ; $10A75D   |

CODE_10A75F:
    LDA $10F8           ; $10A75F   |
    BEQ CODE_10A769     ; $10A762   |
    JSR CODE_10A77A     ; $10A764   |
    BRA CODE_10A76C     ; $10A767   |

CODE_10A769:
    JSR CODE_10A7C3     ; $10A769   |

CODE_10A76C:
    JSR CODE_10A928     ; $10A76C   |

CODE_10A76F:
    REP #$30            ; $10A76F   |
    RTS                 ; $10A771   |

DATA_10A772:         db $58, $78, $98

DATA_10A775:         db $60, $80, $A0

DATA_10A778:         db $02, $FE

CODE_10A77A:
    SEP #$30            ; $10A77A   |
    LDA $10F8           ; $10A77C   |
    CMP #$03            ; $10A77F   |
    BCS CODE_10A7A0     ; $10A781   |
    LDX $110D           ; $10A783   |
    LDA $A772,x         ; $10A786   |
    CMP $10F6           ; $10A789   |
    BEQ CODE_10A7BD     ; $10A78C   |
    LDA $10F8           ; $10A78E   |
    AND #$01            ; $10A791   |
    TAX                 ; $10A793   |
    LDA $10F6           ; $10A794   |
    CLC                 ; $10A797   |
    ADC $A778,x         ; $10A798   |
    STA $10F6           ; $10A79B   |
    BRA CODE_10A7C0     ; $10A79E   |

CODE_10A7A0:
    LDX $110E           ; $10A7A0   |
    LDA $A775,x         ; $10A7A3   |
    CMP $10F7           ; $10A7A6   |
    BEQ CODE_10A7BD     ; $10A7A9   |
    LDA $10F8           ; $10A7AB   |
    AND #$01            ; $10A7AE   |
    TAX                 ; $10A7B0   |
    LDA $10F7           ; $10A7B1   |
    CLC                 ; $10A7B4   |
    ADC $A778,x         ; $10A7B5   |
    STA $10F7           ; $10A7B8   |
    BRA CODE_10A7C0     ; $10A7BB   |

CODE_10A7BD:
    STZ $10F8           ; $10A7BD   |

CODE_10A7C0:
    REP #$30            ; $10A7C0   |
    RTS                 ; $10A7C2   |

CODE_10A7C3:
    SEP #$30            ; $10A7C3   |
    LDA $093F           ; $10A7C5   |
    AND #$C0            ; $10A7C8   |
    BNE CODE_10A7D6     ; $10A7CA   |
    LDA $093E           ; $10A7CC   |
    AND #$80            ; $10A7CF   |
    BNE CODE_10A7D6     ; $10A7D1   |
    JMP CODE_10A838     ; $10A7D3   |

CODE_10A7D6:
    LDA $110E           ; $10A7D6   |
    ASL A               ; $10A7D9   |
    ORA $110E           ; $10A7DA   |
    CLC                 ; $10A7DD   |
    ADC $110D           ; $10A7DE   |
    STA $10F2           ; $10A7E1   |
    CMP #$04            ; $10A7E4   |
    BNE CODE_10A7F2     ; $10A7E6   |
    LDA #$01            ; $10A7E8   |
    STA $7978           ; $10A7EA   |
    INC $10DE           ; $10A7ED   |
    BRA CODE_10A821     ; $10A7F0   |

CODE_10A7F2:
    BMI CODE_10A7F5     ; $10A7F2   |
    DEC A               ; $10A7F4   |

CODE_10A7F5:
    TAX                 ; $10A7F5   |
    LDA $1104,x         ; $10A7F6   |
    CMP #$FF            ; $10A7F9   |
    BNE CODE_10A800     ; $10A7FB   |

CODE_10A7FD:
    JMP CODE_10A8F3     ; $10A7FD   |

CODE_10A800:
    STA $10F3           ; $10A800   |
    LDA #$FF            ; $10A803   |
    STA $1104,x         ; $10A805   |
    LDA #$01            ; $10A808   |
    STA $7978           ; $10A80A   |
    INC $1148           ; $10A80D   |
    INC $10DE           ; $10A810   |
    LDA $10F3           ; $10A813   |
    CMP #$01            ; $10A816   |
    BEQ CODE_10A821     ; $10A818   |
    CMP #$0A            ; $10A81A   |
    BEQ CODE_10A821     ; $10A81C   |
    JSR CODE_10A916     ; $10A81E   |

CODE_10A821:
    JSR CODE_10AD77     ; $10A821   |
    REP #$30            ; $10A824   |
    LDA #$002B          ; $10A826   |
    STA $60BE           ; $10A829   |
    LDX #$0002          ; $10A82C   |
    STX $10F0           ; $10A82F   |
    LDA $A2DD,x         ; $10A832   |
    JMP CODE_10A39A     ; $10A835   |

CODE_10A838:
    SEP #$30            ; $10A838   |
    LDA $093F           ; $10A83A   |
    AND #$0F            ; $10A83D   |
    BEQ CODE_10A7FD     ; $10A83F   |
    LDA #$5C            ; $10A841   |\ play sound #$005C
    JSL $0085D2         ; $10A843   |/
    LDA $093F           ; $10A847   |
    AND #$03            ; $10A84A   |
    BEQ CODE_10A8B4     ; $10A84C   |
    AND #$02            ; $10A84E   |
    BEQ CODE_10A882     ; $10A850   |
    LDA $110D           ; $10A852   |
    BNE CODE_10A877     ; $10A855   |
    LDX #$02            ; $10A857   |
    STX $110D           ; $10A859   |
    LDA $A772,x         ; $10A85C   |
    STA $10F6           ; $10A85F   |
    LDA $110E           ; $10A862   |
    DEC A               ; $10A865   |
    BPL CODE_10A86A     ; $10A866   |
    LDA #$02            ; $10A868   |

CODE_10A86A:
    STA $110E           ; $10A86A   |
    TAX                 ; $10A86D   |
    LDA $A775,x         ; $10A86E   |
    STA $10F7           ; $10A871   |
    JMP CODE_10A8F3     ; $10A874   |

CODE_10A877:
    DEC $110D           ; $10A877   |
    LDA #$01            ; $10A87A   |
    STA $10F8           ; $10A87C   |
    JMP CODE_10A8F3     ; $10A87F   |

CODE_10A882:
    LDA $110D           ; $10A882   |
    CMP #$02            ; $10A885   |
    BNE CODE_10A8AA     ; $10A887   |
    LDX #$00            ; $10A889   |
    STX $110D           ; $10A88B   |
    LDA $A772,x         ; $10A88E   |
    STA $10F6           ; $10A891   |
    LDA $110E           ; $10A894   |
    INC A               ; $10A897   |
    CMP #$03            ; $10A898   |
    BNE CODE_10A89E     ; $10A89A   |
    LDA #$00            ; $10A89C   |

CODE_10A89E:
    STA $110E           ; $10A89E   |
    TAX                 ; $10A8A1   |
    LDA $A775,x         ; $10A8A2   |
    STA $10F7           ; $10A8A5   |
    BRA CODE_10A8F3     ; $10A8A8   |

CODE_10A8AA:
    INC $110D           ; $10A8AA   |
    LDA #$02            ; $10A8AD   |
    STA $10F8           ; $10A8AF   |
    BRA CODE_10A8F3     ; $10A8B2   |

CODE_10A8B4:
    LDA $093F           ; $10A8B4   |
    AND #$08            ; $10A8B7   |
    BEQ CODE_10A8D7     ; $10A8B9   |
    LDA $110E           ; $10A8BB   |
    BNE CODE_10A8CD     ; $10A8BE   |
    LDX #$02            ; $10A8C0   |
    STX $110E           ; $10A8C2   |
    LDA $A775,x         ; $10A8C5   |
    STA $10F7           ; $10A8C8   |
    BRA CODE_10A8F3     ; $10A8CB   |

CODE_10A8CD:
    DEC $110E           ; $10A8CD   |
    LDA #$03            ; $10A8D0   |
    STA $10F8           ; $10A8D2   |
    BRA CODE_10A8F3     ; $10A8D5   |

CODE_10A8D7:
    LDA $110E           ; $10A8D7   |
    CMP #$02            ; $10A8DA   |
    BNE CODE_10A8EB     ; $10A8DC   |
    LDX #$00            ; $10A8DE   |
    STX $110E           ; $10A8E0   |
    LDA $A775,x         ; $10A8E3   |
    STA $10F7           ; $10A8E6   |
    BRA CODE_10A8F3     ; $10A8E9   |

CODE_10A8EB:
    INC $110E           ; $10A8EB   |
    LDA #$04            ; $10A8EE   |
    STA $10F8           ; $10A8F0   |

CODE_10A8F3:
    REP #$30            ; $10A8F3   |
    RTS                 ; $10A8F5   |

CODE_10A8F6:
    SEP #$30            ; $10A8F6   |
    LDX #$00            ; $10A8F8   |

CODE_10A8FA:
    LDA $10F9,x         ; $10A8FA   |
    BEQ CODE_10A909     ; $10A8FD   |
    PHX                 ; $10A8FF   |
    JSR CODE_109C80     ; $10A900   |
    PLX                 ; $10A903   |
    INX                 ; $10A904   |
    CPX #$07            ; $10A905   |
    BNE CODE_10A8FA     ; $10A907   |

CODE_10A909:
    RTS                 ; $10A909   |

DATA_10A90A:         dw $0006, $0907, $0400, $0201
DATA_10A912:         dw $0503, $0800

CODE_10A916:
    SEP #$30            ; $10A916   |
    LDY $1100           ; $10A918   |
    LDX $10F3           ; $10A91B   |
    LDA $A90A,x         ; $10A91E   |
    STA $10F9,y         ; $10A921   |
    INC $1100           ; $10A924   |
    RTS                 ; $10A927   |

CODE_10A928:
    REP #$30            ; $10A928   |
    LDY $6092           ; $10A92A   |
    LDA $30             ; $10A92D   |
    AND #$0008          ; $10A92F   |
    LSR A               ; $10A932   |
    LSR A               ; $10A933   |
    LSR A               ; $10A934   |
    STA $00             ; $10A935   |
    LDA $30             ; $10A937   |
    AND #$0010          ; $10A939   |
    BEQ CODE_10A946     ; $10A93C   |
    LDA $00             ; $10A93E   |
    EOR #$FFFF          ; $10A940   |
    INC A               ; $10A943   |
    STA $00             ; $10A944   |

CODE_10A946:
    LDA $10F6           ; $10A946   |
    INC A               ; $10A949   |
    CLC                 ; $10A94A   |
    ADC $00             ; $10A94B   |
    AND #$00FF          ; $10A94D   |
    STA $6000,y         ; $10A950   |
    STA $6010,y         ; $10A953   |
    LDA $10F6           ; $10A956   |
    DEC A               ; $10A959   |
    CLC                 ; $10A95A   |
    ADC #$0010          ; $10A95B   |
    SEC                 ; $10A95E   |
    SBC $00             ; $10A95F   |
    AND #$00FF          ; $10A961   |
    STA $6008,y         ; $10A964   |
    STA $6018,y         ; $10A967   |
    LDA $10F7           ; $10A96A   |
    INC A               ; $10A96D   |
    CLC                 ; $10A96E   |
    ADC $00             ; $10A96F   |
    AND #$00FF          ; $10A971   |
    STA $6002,y         ; $10A974   |
    STA $600A,y         ; $10A977   |
    LDA $10F7           ; $10A97A   |
    DEC A               ; $10A97D   |
    CLC                 ; $10A97E   |
    ADC #$0010          ; $10A97F   |
    SEC                 ; $10A982   |
    SBC $00             ; $10A983   |
    AND #$00FF          ; $10A985   |
    STA $6012,y         ; $10A988   |
    STA $601A,y         ; $10A98B   |
    LDA #$309F          ; $10A98E   |
    STA $6004,y         ; $10A991   |
    LDA #$709F          ; $10A994   |
    STA $600C,y         ; $10A997   |
    LDA #$B09F          ; $10A99A   |
    STA $6014,y         ; $10A99D   |
    LDA #$F09F          ; $10A9A0   |
    STA $601C,y         ; $10A9A3   |
    LDA #$0000          ; $10A9A6   |
    STA $6006,y         ; $10A9A9   |
    STA $600E,y         ; $10A9AC   |
    STA $6016,y         ; $10A9AF   |
    STA $601E,y         ; $10A9B2   |
    TYA                 ; $10A9B5   |
    CLC                 ; $10A9B6   |
    ADC #$0020          ; $10A9B7   |
    STA $6092           ; $10A9BA   |
    RTS                 ; $10A9BD   |

    JSR CODE_10AE80     ; $10A9BE   |
    DEC $10E0           ; $10A9C1   |
    BNE CODE_10AA09     ; $10A9C4   |
    LDA $1102           ; $10A9C6   |
    AND #$00FF          ; $10A9C9   |
    BNE CODE_10A9DC     ; $10A9CC   |
    LDA #$0080          ; $10A9CE   |
    STA $10E0           ; $10A9D1   |
    LDA #$0010          ; $10A9D4   |
    STA $10DE           ; $10A9D7   |
    BRA CODE_10AA09     ; $10A9DA   |

CODE_10A9DC:
    LDA $0379           ; $10A9DC   |
    CMP #$03E7          ; $10A9DF   |
    BNE CODE_10A9F0     ; $10A9E2   |
    SEP #$20            ; $10A9E4   |
    STZ $1102           ; $10A9E6   |
    REP #$20            ; $10A9E9   |
    INC $10E0           ; $10A9EB   |
    BRA CODE_10AA09     ; $10A9EE   |

CODE_10A9F0:
    SEP #$20            ; $10A9F0   |
    DEC $1102           ; $10A9F2   |
    LDA #$08            ; $10A9F5   |\ play sound #$0008
    JSL $0085D2         ; $10A9F7   |/
    REP #$20            ; $10A9FB   |
    INC $0379           ; $10A9FD   |
    JSR CODE_109D74     ; $10AA00   |
    LDA #$0030          ; $10AA03   |
    STA $10E0           ; $10AA06   |

CODE_10AA09:
    RTS                 ; $10AA09   |

DATA_10AA0A:         db $6D, $6E, $7A, $7B, $78, $6F, $70, $79
DATA_10AA12:         db $71, $72, $73, $7A, $09, $0D, $0A, $0D
DATA_10AA1A:         db $0B, $0D, $0C, $0D, $0D, $0D, $0E, $0D
DATA_10AA22:         db $0F, $0D, $10, $0D, $11, $0D, $12, $15
DATA_10AA2A:         db $13, $15, $14, $15, $15, $15, $16, $15
DATA_10AA32:         db $17, $15, $18, $15, $19, $15, $1A, $15
DATA_10AA3A:         db $92, $11, $93, $11, $94, $11, $95, $11
DATA_10AA42:         db $96, $11, $97, $11, $98, $11, $99, $11
DATA_10AA4A:         db $9A, $11, $9B, $15, $9C, $15, $9D, $15
DATA_10AA52:         db $9E, $15, $9F, $15, $A0, $15, $A1, $15
DATA_10AA5A:         db $A2, $15, $A3, $15, $80, $0D, $81, $0D
DATA_10AA62:         db $82, $0D, $83, $0D, $84, $0D, $85, $0D
DATA_10AA6A:         db $86, $0D, $87, $0D, $88, $0D, $1B, $0D
DATA_10AA72:         db $1C, $0D, $1D, $0D, $1E, $0D, $1F, $0D
DATA_10AA7A:         db $20, $0D, $21, $0D, $22, $0D, $23, $0D
DATA_10AA82:         db $24, $0D, $25, $0D, $26, $0D, $27, $0D
DATA_10AA8A:         db $28, $0D, $29, $0D, $2A, $0D, $2B, $0D
DATA_10AA92:         db $2C, $0D, $89, $15, $8A, $15, $8B, $15
DATA_10AA9A:         db $8C, $15, $8D, $15, $8E, $15, $8F, $15
DATA_10AAA2:         db $90, $15, $91, $15, $2D, $15, $2E, $15
DATA_10AAAA:         db $2F, $15, $30, $15, $31, $15, $32, $15
DATA_10AAB2:         db $33, $15, $34, $15, $35, $15, $36, $0D
DATA_10AABA:         db $37, $0D, $38, $0D, $39, $0D, $3A, $0D
DATA_10AAC2:         db $3B, $0D, $3C, $0D, $3D, $0D, $3E, $0D
DATA_10AACA:         db $3F, $15, $40, $15, $41, $15, $42, $15
DATA_10AAD2:         db $43, $15, $44, $15, $45, $15, $46, $15
DATA_10AADA:         db $47, $15, $92, $0D, $93, $0D, $94, $0D
DATA_10AAE2:         db $95, $0D, $96, $0D, $97, $0D, $98, $0D
DATA_10AAEA:         db $99, $0D, $9A, $0D, $00, $0D, $01, $0D
DATA_10AAF2:         db $02, $0D, $03, $0D, $04, $0D, $05, $0D
DATA_10AAFA:         db $06, $0D, $07, $0D, $08, $0D

DATA_10AB00:         dw $698B, $698F, $6993, $6A0B
DATA_10AB08:         dw $6A0F, $6A13, $6A8B, $6A8F
DATA_10AB10:         dw $6A93

DATA_10AB12:         db $00, $00, $00, $00, $00, $00

DATA_10AB18:         db $54, $74, $94, $54, $74, $94, $54, $74
DATA_10AB20:         db $94

DATA_10AB21:         db $5C, $5C, $5C, $7C, $7C, $7C, $9C, $9C
DATA_10AB29:         db $9C

DATA_10AB2A:         db $36, $32, $36, $32, $36, $32, $36, $32
DATA_10AB32:         db $36

DATA_10AB33:         db $32, $36, $34, $36, $32, $32, $32, $36
DATA_10AB3B:         db $36, $36, $36, $32

CODE_10AB3F:
    LDA $10F2           ; $10AB3F   |
    AND #$00FF          ; $10AB42   |
    PHA                 ; $10AB45   |
    ASL A               ; $10AB46   |
    TAX                 ; $10AB47   |
    LDA #$0003          ; $10AB48   |
    STA $0E             ; $10AB4B   |
    LDY $AB00,x         ; $10AB4D   |

CODE_10AB50:
    LDA #$0010          ; $10AB50   |
    STA $01             ; $10AB53   |
    LDX #$AB12          ; $10AB55   |
    LDA #$0006          ; $10AB58   |
    PHY                 ; $10AB5B   |
    JSL $00BEA6         ; $10AB5C   |
    PLA                 ; $10AB60   |
    CLC                 ; $10AB61   |
    ADC #$0020          ; $10AB62   |
    TAY                 ; $10AB65   |
    DEC $0E             ; $10AB66   |
    BNE CODE_10AB50     ; $10AB68   |
    PLA                 ; $10AB6A   |
    TAX                 ; $10AB6B   |
    CLC                 ; $10AB6C   |
    ADC #$AB2A          ; $10AB6D   |
    STA $00             ; $10AB70   |
    TXA                 ; $10AB72   |
    CLC                 ; $10AB73   |
    ADC #$AB18          ; $10AB74   |
    STA $02             ; $10AB77   |
    TXA                 ; $10AB79   |
    CLC                 ; $10AB7A   |
    ADC #$AB21          ; $10AB7B   |
    STA $04             ; $10AB7E   |
    JSR CODE_10ACB7     ; $10AB80   |
    STZ $10F4           ; $10AB83   |
    LDA #$006C          ; $10AB86   |
    LDX #$0011          ; $10AB89   |
    JSR CODE_10AC94     ; $10AB8C   |
    RTS                 ; $10AB8F   |

    JSR CODE_10AE80     ; $10AB90   |
    LDA $10F4           ; $10AB93   |
    CLC                 ; $10AB96   |
    ADC #$0008          ; $10AB97   |
    STA $10F4           ; $10AB9A   |
    CMP #$0080          ; $10AB9D   |
    BMI CODE_10ABA6     ; $10ABA0   |
    INC $10DE           ; $10ABA2   |
    RTS                 ; $10ABA5   |

CODE_10ABA6:
    LDA $10F2           ; $10ABA6   |
    AND #$00FF          ; $10ABA9   |
    TAX                 ; $10ABAC   |
    CLC                 ; $10ABAD   |
    ADC #$AB2A          ; $10ABAE   |
    STA $00             ; $10ABB1   |
    TXA                 ; $10ABB3   |
    CLC                 ; $10ABB4   |
    ADC #$AB18          ; $10ABB5   |
    STA $02             ; $10ABB8   |
    TXA                 ; $10ABBA   |
    CLC                 ; $10ABBB   |
    ADC #$AB21          ; $10ABBC   |
    STA $04             ; $10ABBF   |
    JSR CODE_10ACB7     ; $10ABC1   |
    LDA #$006C          ; $10ABC4   |
    LDX #$0011          ; $10ABC7   |
    JMP CODE_10AC94     ; $10ABCA   |

    JSR CODE_10AE80     ; $10ABCD   |
    LDA $10F4           ; $10ABD0   |
    SEC                 ; $10ABD3   |
    SBC #$0008          ; $10ABD4   |
    STA $10F4           ; $10ABD7   |
    BMI CODE_10ABDF     ; $10ABDA   |
    JMP CODE_10AC67     ; $10ABDC   |

CODE_10ABDF:
    LDA $10F2           ; $10ABDF   |
    AND #$00FF          ; $10ABE2   |
    ASL A               ; $10ABE5   |
    TAX                 ; $10ABE6   |
    LDY $AB00,x         ; $10ABE7   |
    LDA $10F3           ; $10ABEA   |
    AND #$00FF          ; $10ABED   |
    STA $00             ; $10ABF0   |
    ASL A               ; $10ABF2   |
    ASL A               ; $10ABF3   |
    ASL A               ; $10ABF4   |
    ASL A               ; $10ABF5   |
    CLC                 ; $10ABF6   |
    ADC $00             ; $10ABF7   |
    CLC                 ; $10ABF9   |
    ADC $00             ; $10ABFA   |
    CLC                 ; $10ABFC   |
    ADC #$AA16          ; $10ABFD   |
    TAX                 ; $10AC00   |
    LDA #$0003          ; $10AC01   |
    STA $0E             ; $10AC04   |

CODE_10AC06:
    LDA #$0010          ; $10AC06   |
    STA $01             ; $10AC09   |
    LDA #$0006          ; $10AC0B   |
    PHX                 ; $10AC0E   |
    PHY                 ; $10AC0F   |
    JSL $00BEA6         ; $10AC10   |
    PLA                 ; $10AC14   |
    CLC                 ; $10AC15   |
    ADC #$0020          ; $10AC16   |
    TAY                 ; $10AC19   |
    PLA                 ; $10AC1A   |
    CLC                 ; $10AC1B   |
    ADC #$0006          ; $10AC1C   |
    TAX                 ; $10AC1F   |
    DEC $0E             ; $10AC20   |
    BNE CODE_10AC06     ; $10AC22   |
    LDA $10DE           ; $10AC24   |
    CMP #$000D          ; $10AC27   |
    BEQ CODE_10AC66     ; $10AC2A   |
    LDA $1148           ; $10AC2C   |
    CMP #$0009          ; $10AC2F   |
    BNE CODE_10AC3F     ; $10AC32   |
    LDA #$0020          ; $10AC34   |
    STA $10E0           ; $10AC37   |
    LDA #$000F          ; $10AC3A   |
    BRA CODE_10AC63     ; $10AC3D   |

CODE_10AC3F:
    LDA $10F3           ; $10AC3F   |
    AND #$00FF          ; $10AC42   |
    CMP #$0001          ; $10AC45   |
    BNE CODE_10AC4F     ; $10AC48   |
    LDA #$0090          ; $10AC4A   |
    BRA CODE_10AC5C     ; $10AC4D   |

CODE_10AC4F:
    CMP #$000A          ; $10AC4F   |
    BNE CODE_10AC59     ; $10AC52   |
    LDA #$007D          ; $10AC54   |
    BRA CODE_10AC5C     ; $10AC57   |

CODE_10AC59:
    LDA #$008F          ; $10AC59   |\ play sound #$008F

CODE_10AC5C:
    JSL $0085D2         ; $10AC5C   |/
    LDA #$0008          ; $10AC60   |

CODE_10AC63:
    STA $10DE           ; $10AC63   |

CODE_10AC66:
    RTS                 ; $10AC66   |

CODE_10AC67:
    LDA $10F3           ; $10AC67   |
    AND #$00FF          ; $10AC6A   |
    TAY                 ; $10AC6D   |
    CLC                 ; $10AC6E   |
    ADC #$AB33          ; $10AC6F   |
    STA $00             ; $10AC72   |
    LDA $10F2           ; $10AC74   |
    AND #$00FF          ; $10AC77   |
    TAX                 ; $10AC7A   |
    CLC                 ; $10AC7B   |
    ADC #$AB18          ; $10AC7C   |
    STA $02             ; $10AC7F   |
    TXA                 ; $10AC81   |
    CLC                 ; $10AC82   |
    ADC #$AB21          ; $10AC83   |
    STA $04             ; $10AC86   |
    JSR CODE_10ACB7     ; $10AC88   |
    LDA $AA0A,y         ; $10AC8B   |
    AND #$00FF          ; $10AC8E   |
    LDX #$0011          ; $10AC91   |

CODE_10AC94:
    STA $3006           ; $10AC94   |
    STX $3002           ; $10AC97   |
    LDA $10F4           ; $10AC9A   |
    STA $3004           ; $10AC9D   |
    LDA #$0100          ; $10ACA0   |
    STA $3016           ; $10ACA3   |
    SEP #$10            ; $10ACA6   |
    LDX #$08            ; $10ACA8   |
    LDA #$DE98          ; $10ACAA   |
    JSL $7EDE44         ; $10ACAD   | GSU init
    REP #$10            ; $10ACB1   |
    JSR CODE_10AD19     ; $10ACB3   |
    RTS                 ; $10ACB6   |

CODE_10ACB7:
    PHY                 ; $10ACB7   |
    LDY $6092           ; $10ACB8   |
    LDA ($02)           ; $10ACBB   |
    AND #$00FF          ; $10ACBD   |
    STA $6000,y         ; $10ACC0   |
    STA $6010,y         ; $10ACC3   |
    CLC                 ; $10ACC6   |
    ADC #$0010          ; $10ACC7   |
    STA $6008,y         ; $10ACCA   |
    STA $6018,y         ; $10ACCD   |
    LDA ($04)           ; $10ACD0   |
    AND #$00FF          ; $10ACD2   |
    STA $6002,y         ; $10ACD5   |
    STA $600A,y         ; $10ACD8   |
    CLC                 ; $10ACDB   |
    ADC #$0010          ; $10ACDC   |
    STA $6012,y         ; $10ACDF   |
    STA $601A,y         ; $10ACE2   |
    LDA ($00)           ; $10ACE5   |
    XBA                 ; $10ACE7   |
    AND #$FF00          ; $10ACE8   |
    ORA #$01E8          ; $10ACEB   |
    STA $6004,y         ; $10ACEE   |
    INC A               ; $10ACF1   |
    INC A               ; $10ACF2   |
    STA $600C,y         ; $10ACF3   |
    INC A               ; $10ACF6   |
    INC A               ; $10ACF7   |
    STA $6014,y         ; $10ACF8   |
    INC A               ; $10ACFB   |
    INC A               ; $10ACFC   |
    STA $601C,y         ; $10ACFD   |
    LDA #$0002          ; $10AD00   |
    STA $6006,y         ; $10AD03   |
    STA $600E,y         ; $10AD06   |
    STA $6016,y         ; $10AD09   |
    STA $601E,y         ; $10AD0C   |
    TYA                 ; $10AD0F   |
    CLC                 ; $10AD10   |
    ADC #$0020          ; $10AD11   |
    STA $6092           ; $10AD14   |
    PLY                 ; $10AD17   |
    RTS                 ; $10AD18   |

CODE_10AD19:
    LDA #$0070          ; $10AD19   |
    STA $01             ; $10AD1C   |
    LDY #$5E80          ; $10AD1E   |
    LDX #$5800          ; $10AD21   |
    LDA #$0080          ; $10AD24   |
    JSL $00BEA6         ; $10AD27   |
    LDY #$5F80          ; $10AD2B   |
    LDX #$5A00          ; $10AD2E   |
    LDA #$0080          ; $10AD31   |
    JSL $00BEA6         ; $10AD34   |
    LDY #$5EC0          ; $10AD38   |
    LDX #$5C00          ; $10AD3B   |
    LDA #$0080          ; $10AD3E   |
    JSL $00BEA6         ; $10AD41   |
    LDY #$5FC0          ; $10AD45   |
    LDX #$5E00          ; $10AD48   |
    LDA #$0080          ; $10AD4B   |
    JSL $00BEA6         ; $10AD4E   |
    RTS                 ; $10AD52   |

DATA_10AD53:         dw $0007, $000D, $000C, $000A
DATA_10AD5B:         dw $0008, $0008, $0003, $FFFD
DATA_10AD63:         dw $FFF6

DATA_10AD65:         dw $000A, $0010, $0010, $000C
DATA_10AD6D:         dw $000B, $0004, $0003, $0003
DATA_10AD75:         dw $0003

CODE_10AD77:
    REP #$20            ; $10AD77   |
    SEP #$10            ; $10AD79   |
    LDY #$04            ; $10AD7B   |
    LDA #$0022          ; $10AD7D   |
    JSL $03A366         ; $10AD80   |
    LDA $608C           ; $10AD84   |
    CLC                 ; $10AD87   |
    ADC $AD53           ; $10AD88   |
    STA $70E6           ; $10AD8B   |
    LDA $6090           ; $10AD8E   |
    CLC                 ; $10AD91   |
    ADC $AD65           ; $10AD92   |
    STA $7186           ; $10AD95   |
    STZ $7224           ; $10AD98   |
    STZ $7226           ; $10AD9B   |
    LDA #$0001          ; $10AD9E   |
    STA $74A6           ; $10ADA1   |
    LDA #$0030          ; $10ADA4   |
    STA $7046           ; $10ADA7   |
    STZ $7A36           ; $10ADAA   |
    REP #$10            ; $10ADAD   |
    RTS                 ; $10ADAF   |

DATA_10ADB0:         dw $0060, $0080, $00A0

DATA_10ADB6:         dw $0068, $0088, $00A8

CODE_10ADBC:
    SEP #$10            ; $10ADBC   |
    LDA $70E6           ; $10ADBE   |
    STA $3006           ; $10ADC1   |
    LDA $7186           ; $10ADC4   |
    STA $3008           ; $10ADC7   |
    LDA $110D           ; $10ADCA   |
    AND #$00FF          ; $10ADCD   |
    ASL A               ; $10ADD0   |
    TAX                 ; $10ADD1   |
    LDA $ADB0,x         ; $10ADD2   |
    STA $3002           ; $10ADD5   |
    LDA $110E           ; $10ADD8   |
    AND #$00FF          ; $10ADDB   |
    ASL A               ; $10ADDE   |
    TAX                 ; $10ADDF   |
    LDA $ADB6,x         ; $10ADE0   |
    STA $3004           ; $10ADE3   |
    LDA #$0600          ; $10ADE6   |
    SEP #$10            ; $10ADE9   |
    STA $300C           ; $10ADEB   |
    LDX #$09            ; $10ADEE   |
    LDA #$907C          ; $10ADF0   |
    JSL $7EDE44         ; $10ADF3   | GSU init
    LDA $3002           ; $10ADF7   |
    STA $7224           ; $10ADFA   |
    LDA $3004           ; $10ADFD   |
    STA $7226           ; $10AE00   |
    REP #$10            ; $10AE03   |
    RTS                 ; $10AE05   |

DATA_10AE06:         dw $003C, $005C, $007C, $009C
DATA_10AE0E:         dw $00BC, $002C, $004C, $00AC
DATA_10AE16:         dw $00CC, $003C, $005C, $007C
DATA_10AE1E:         dw $009C, $00BC

DATA_10AE22:         dw $005C, $005C, $005C, $005C
DATA_10AE2A:         dw $005C, $007C, $007C, $007C
DATA_10AE32:         dw $007C, $009C, $009C, $009C
DATA_10AE3A:         dw $009C, $009C

CODE_10AE3E:
    SEP #$10            ; $10AE3E   |
    LDA $70E6           ; $10AE40   |
    STA $3006           ; $10AE43   |
    LDA $7186           ; $10AE46   |
    STA $3008           ; $10AE49   |
    LDA $1154           ; $10AE4C   |
    AND #$00FF          ; $10AE4F   |
    ASL A               ; $10AE52   |
    TAX                 ; $10AE53   |
    LDA $AE06,x         ; $10AE54   |
    STA $3002           ; $10AE57   |
    LDA $AE22,x         ; $10AE5A   |
    STA $3004           ; $10AE5D   |
    LDA #$0600          ; $10AE60   |
    SEP #$10            ; $10AE63   |
    STA $300C           ; $10AE65   |
    LDX #$09            ; $10AE68   |
    LDA #$907C          ; $10AE6A   |
    JSL $7EDE44         ; $10AE6D   | GSU init
    LDA $3002           ; $10AE71   |
    STA $7224           ; $10AE74   |
    LDA $3004           ; $10AE77   |
    STA $7226           ; $10AE7A   |
    REP #$10            ; $10AE7D   |
    RTS                 ; $10AE7F   |

CODE_10AE80:
    REP #$20            ; $10AE80   |
    SEP #$10            ; $10AE82   |
    LDA $7978           ; $10AE84   |
    BNE CODE_10AE8C     ; $10AE87   |

    JMP CODE_10AF37     ; $10AE89   |

CODE_10AE8C:
    CMP #$0002          ; $10AE8C   |
    BEQ CODE_10AEDE     ; $10AE8F   |
    CMP #$0003          ; $10AE91   |
    BNE CODE_10AE99     ; $10AE94   |
    JMP CODE_10AF18     ; $10AE96   |

CODE_10AE99:
    LDA $60BE           ; $10AE99   |
    CMP #$0034          ; $10AE9C   |
    BNE CODE_10AEBE     ; $10AE9F   |
    LDA #$004A          ; $10AEA1   |\ play sound #$004A
    JSL $0085D2         ; $10AEA4   |/
    LDA $0212           ; $10AEA8   |
    CMP #$0006          ; $10AEAB   |
    BEQ CODE_10AEB5     ; $10AEAE   |
    JSR CODE_10ADBC     ; $10AEB0   |
    BRA CODE_10AEB8     ; $10AEB3   |

CODE_10AEB5:
    JSR CODE_10AE3E     ; $10AEB5   |

CODE_10AEB8:
    INC $7978           ; $10AEB8   |
    JMP CODE_10AF37     ; $10AEBB   |

CODE_10AEBE:
    LDY #$02            ; $10AEBE   |
    LDA $60F8           ; $10AEC0   |
    SEC                 ; $10AEC3   |
    SBC $A2DD,y         ; $10AEC4   |
    TAX                 ; $10AEC7   |
    LDA $608C           ; $10AEC8   |
    CLC                 ; $10AECB   |
    ADC $AD53,x         ; $10AECC   |
    STA $70E6           ; $10AECF   |
    LDA $6090           ; $10AED2   |
    CLC                 ; $10AED5   |
    ADC $AD65,x         ; $10AED6   |
    STA $7186           ; $10AED9   |
    BRA CODE_10AF31     ; $10AEDC   |

CODE_10AEDE:
    JSR CODE_10AFD4     ; $10AEDE   |
    LDA $0212           ; $10AEE1   |
    CMP #$0006          ; $10AEE4   |
    BEQ CODE_10AEEE     ; $10AEE7   |
    JSR CODE_10AF3A     ; $10AEE9   |
    BRA CODE_10AEF1     ; $10AEEC   |

CODE_10AEEE:
    JSR CODE_10AF9C     ; $10AEEE   |

CODE_10AEF1:
    CPY #$00            ; $10AEF1   |
    BEQ CODE_10AF31     ; $10AEF3   |
    LDA #$FF00          ; $10AEF5   |
    STA $7224           ; $10AEF8   |
    LDA #$FC00          ; $10AEFB   |
    STA $7226           ; $10AEFE   |
    INC $7978           ; $10AF01   |
    LDA $10DE           ; $10AF04   |
    CMP #$0011          ; $10AF07   |
    BEQ CODE_10AF31     ; $10AF0A   |
    LDA #$0067          ; $10AF0C   |\ play sound #$0067
    JSL $0085D2         ; $10AF0F   |/
    INC $10DE           ; $10AF13   |
    BRA CODE_10AF31     ; $10AF16   |

CODE_10AF18:
    LDA $7186           ; $10AF18   |
    CMP #$00E0          ; $10AF1B   |
    BCS CODE_10AF2C     ; $10AF1E   |
    LDA $7226           ; $10AF20   |
    CLC                 ; $10AF23   |
    ADC #$0040          ; $10AF24   |
    STA $7226           ; $10AF27   |
    BRA CODE_10AF31     ; $10AF2A   |

CODE_10AF2C:
    STZ $7978           ; $10AF2C   |
    BRA CODE_10AF37     ; $10AF2F   |

CODE_10AF31:
    LDX #$04            ; $10AF31   |
    JSL $03B69D         ; $10AF33   |

CODE_10AF37:
    REP #$10            ; $10AF37   |
    RTS                 ; $10AF39   |

CODE_10AF3A:
    SEP #$10            ; $10AF3A   |
    LDY #$00            ; $10AF3C   |
    LDA $110D           ; $10AF3E   |
    AND #$00FF          ; $10AF41   |
    ASL A               ; $10AF44   |
    TAX                 ; $10AF45   |
    LDA $70E6           ; $10AF46   |
    CMP $ADB0,x         ; $10AF49   |
    BCC CODE_10AF5E     ; $10AF4C   |
    LDA $110E           ; $10AF4E   |
    AND #$00FF          ; $10AF51   |
    ASL A               ; $10AF54   |
    TAX                 ; $10AF55   |
    LDA $7186           ; $10AF56   |
    CMP $ADB6,x         ; $10AF59   |
    BCS CODE_10AF99     ; $10AF5C   |

CODE_10AF5E:
    SEP #$20            ; $10AF5E   |
    REP #$10            ; $10AF60   |
    LDA $110E           ; $10AF62   |
    ASL A               ; $10AF65   |
    ORA $110E           ; $10AF66   |
    CLC                 ; $10AF69   |
    ADC $110D           ; $10AF6A   |
    CMP #$04            ; $10AF6D   |
    BNE CODE_10AF91     ; $10AF6F   |
    REP #$20            ; $10AF71   |
    JSR CODE_10B56F     ; $10AF73   |
    JSR CODE_10B4F1     ; $10AF76   |
    LDA #$0100          ; $10AF79   |
    STA $10F4           ; $10AF7C   |
    JSR CODE_10B54F     ; $10AF7F   |
    LDA #$0008          ; $10AF82   |\ play sound #$0008
    JSL $0085D2         ; $10AF85   |/
    LDA #$0011          ; $10AF89   |
    STA $10DE           ; $10AF8C   |
    BRA CODE_10AF96     ; $10AF8F   |

CODE_10AF91:
    REP #$20            ; $10AF91   |
    JSR CODE_10AB3F     ; $10AF93   |

CODE_10AF96:
    LDY #$0001          ; $10AF96   |

CODE_10AF99:
    SEP #$10            ; $10AF99   |
    RTS                 ; $10AF9B   |

CODE_10AF9C:
    SEP #$10            ; $10AF9C   |
    LDY #$00            ; $10AF9E   |
    LDA $1154           ; $10AFA0   |
    AND #$00FF          ; $10AFA3   |
    CMP #$0008          ; $10AFA6   |
    BEQ CODE_10AFBF     ; $10AFA9   |
    ASL A               ; $10AFAB   |
    TAX                 ; $10AFAC   |
    LDA $70E6           ; $10AFAD   |
    CMP $AE06,x         ; $10AFB0   |
    BCC CODE_10AFC9     ; $10AFB3   |
    LDA $7186           ; $10AFB5   |
    CMP $AE22,x         ; $10AFB8   |
    BCS CODE_10AFD1     ; $10AFBB   |
    BRA CODE_10AFC9     ; $10AFBD   |

CODE_10AFBF:
    ASL A               ; $10AFBF   |
    TAX                 ; $10AFC0   |
    LDA $70E6           ; $10AFC1   |
    CMP $AE06,x         ; $10AFC4   |
    BCC CODE_10AFD1     ; $10AFC7   |

CODE_10AFC9:
    REP #$10            ; $10AFC9   |
    JSR CODE_10D588     ; $10AFCB   |
    LDY #$0001          ; $10AFCE   |

CODE_10AFD1:
    SEP #$10            ; $10AFD1   |
    RTS                 ; $10AFD3   |

CODE_10AFD4:
    LDA $0030           ; $10AFD4   |
    AND #$0001          ; $10AFD7   |
    BNE CODE_10B00D     ; $10AFDA   |
    LDA #$01DF          ; $10AFDC   |
    JSL $008B21         ; $10AFDF   |
    LDA $70E6           ; $10AFE3   |
    STA $70A2,y         ; $10AFE6   |
    LDA $7186           ; $10AFE9   |
    STA $7142,y         ; $10AFEC   |
    LDA #$0005          ; $10AFEF   |
    STA $7E4C,y         ; $10AFF2   |
    LDA #$0005          ; $10AFF5   |
    STA $73C2,y         ; $10AFF8   |
    LDA #$0004          ; $10AFFB   |
    STA $7782,y         ; $10AFFE   |
    LDA #$0006          ; $10B001   |
    STA $7462,y         ; $10B004   |
    LDA #$002C          ; $10B007   |
    STA $7002,y         ; $10B00A   |

CODE_10B00D:
    RTS                 ; $10B00D   |

    DEC $10E0           ; $10B00E   |
    BPL CODE_10B045     ; $10B011   |
    SEP #$30            ; $10B013   |
    LDA #$06            ; $10B015   |
    STA $4D             ; $10B017   |
    LDX #$00            ; $10B019   |

CODE_10B01B:
    LDA $1104,x         ; $10B01B   |
    CMP #$FF            ; $10B01E   |
    BNE CODE_10B025     ; $10B020   |
    INX                 ; $10B022   |
    BRA CODE_10B01B     ; $10B023   |

CODE_10B025:
    STA $10F3           ; $10B025   |
    CPX #$04            ; $10B028   |
    BMI CODE_10B02D     ; $10B02A   |
    INX                 ; $10B02C   |

CODE_10B02D:
    STX $10F2           ; $10B02D   |
    INC $1148           ; $10B030   |
    INC $10DE           ; $10B033   |
    REP #$30            ; $10B036   |
    LDA #$0100          ; $10B038   |
    STA $10F4           ; $10B03B   |
    LDA #$0051          ; $10B03E   |\ play sound #$0051
    JSL $0085D2         ; $10B041   |/

CODE_10B045:
    RTS                 ; $10B045   |

    JSR CODE_10B050     ; $10B046   |
    JSR CODE_10B1CD     ; $10B049   |
    JSR CODE_10B2DE     ; $10B04C   |
    RTS                 ; $10B04F   |

CODE_10B050:
    LDA $1184           ; $10B050   |
    ASL A               ; $10B053   |
    TAX                 ; $10B054   |
    JMP ($B058,x)       ; $10B055   |

DATA_10B058:         dw $B062
DATA_10B05A:         dw $B083
DATA_10B05C:         dw $B0F3
DATA_10B05E:         dw $B123
DATA_10B060:         dw $B04F

    JSR CODE_10B0B4     ; $10B062   |
    LDA $10F4           ; $10B065   |
    CMP #$0150          ; $10B068   |
    BNE CODE_10B079     ; $10B06B   |
    LDA #$0053          ; $10B06D   |\ play sound #$0053
    JSL $0085D2         ; $10B070   |/
    INC $1184           ; $10B074   |
    BRA CODE_10B080     ; $10B077   |

CODE_10B079:
    CLC                 ; $10B079   |
    ADC #$0004          ; $10B07A   |
    STA $10F4           ; $10B07D   |

CODE_10B080:
    JMP CODE_10B0D3     ; $10B080   |

    LDA $10F4           ; $10B083   |
    CMP #$0120          ; $10B086   |
    BNE CODE_10B09A     ; $10B089   |
    INC $1186           ; $10B08B   |
    INC $1188           ; $10B08E   |
    LDA #$0004          ; $10B091   |\ play sound #$0004
    JSL $0085D2         ; $10B094   |/
    BRA CODE_10B0A4     ; $10B098   |

CODE_10B09A:
    CMP #$0100          ; $10B09A   |
    BNE CODE_10B0A4     ; $10B09D   |
    INC $1184           ; $10B09F   |
    BRA CODE_10B0B1     ; $10B0A2   |

CODE_10B0A4:
    JSR CODE_10B0B4     ; $10B0A4   |
    LDA $10F4           ; $10B0A7   |
    SEC                 ; $10B0AA   |
    SBC #$0004          ; $10B0AB   |
    STA $10F4           ; $10B0AE   |

CODE_10B0B1:
    JMP CODE_10B0D3     ; $10B0B1   |

CODE_10B0B4:
    LDA $10F2           ; $10B0B4   |
    AND #$00FF          ; $10B0B7   |
    TAX                 ; $10B0BA   |
    CLC                 ; $10B0BB   |
    ADC #$AB2A          ; $10B0BC   |
    STA $00             ; $10B0BF   |
    TXA                 ; $10B0C1   |
    CLC                 ; $10B0C2   |
    ADC #$AB18          ; $10B0C3   |
    STA $02             ; $10B0C6   |
    TXA                 ; $10B0C8   |
    CLC                 ; $10B0C9   |
    ADC #$AB21          ; $10B0CA   |
    STA $04             ; $10B0CD   |
    JSR CODE_10ACB7     ; $10B0CF   |
    RTS                 ; $10B0D2   |

CODE_10B0D3:
    STA $300C           ; $10B0D3   |
    LDA #$0011          ; $10B0D6   |
    STA $3002           ; $10B0D9   |
    LDA #$006C          ; $10B0DC   |
    STA $3006           ; $10B0DF   |
    SEP #$10            ; $10B0E2   |
    LDX #$08            ; $10B0E4   |
    LDA #$DBDE          ; $10B0E6   |
    JSL $7EDE44         ; $10B0E9   | GSU init
    REP #$10            ; $10B0ED   |
    JSR CODE_10AD19     ; $10B0EF   |
    RTS                 ; $10B0F2   |

    LDA $70E6           ; $10B0F3   |
    CMP $118C           ; $10B0F6   |
    BCS CODE_10B122     ; $10B0F9   |
    SEP #$20            ; $10B0FB   |
    LDA #$04            ; $10B0FD   |
    STA $10F3           ; $10B0FF   |
    LDA #$0A            ; $10B102   |
    STA $1102           ; $10B104   |
    REP #$20            ; $10B107   |
    STZ $7978           ; $10B109   |
    LDA #$0040          ; $10B10C   |
    STA $118E           ; $10B10F   |
    STZ $1190           ; $10B112   |
    JSR CODE_10AB3F     ; $10B115   |
    LDA #$0051          ; $10B118   |\ play sound #$0051
    JSL $0085D2         ; $10B11B   |/
    INC $1184           ; $10B11F   |

CODE_10B122:
    RTS                 ; $10B122   |

    LDA $1190           ; $10B123   |
    AND #$0001          ; $10B126   |
    BNE CODE_10B148     ; $10B129   |
    LDA $10F4           ; $10B12B   |
    CLC                 ; $10B12E   |
    ADC $118E           ; $10B12F   |
    CMP #$0080          ; $10B132   |
    BCC CODE_10B1AE     ; $10B135   |
    SEC                 ; $10B137   |
    SBC #$0080          ; $10B138   |
    STA $00             ; $10B13B   |
    LDA #$0080          ; $10B13D   |
    SEC                 ; $10B140   |
    SBC $00             ; $10B141   |
    STA $10F4           ; $10B143   |
    BRA CODE_10B18B     ; $10B146   |

CODE_10B148:
    LDA $10F4           ; $10B148   |
    SEC                 ; $10B14B   |
    SBC $118E           ; $10B14C   |
    BPL CODE_10B1AE     ; $10B14F   |
    STA $00             ; $10B151   |
    LDA $1190           ; $10B153   |
    AND #$0003          ; $10B156   |
    CMP #$0001          ; $10B159   |
    BNE CODE_10B182     ; $10B15C   |
    LDX $118E           ; $10B15E   |
    CPX #$0004          ; $10B161   |
    BNE CODE_10B182     ; $10B164   |
    STZ $1148           ; $10B166   |
    LDA $10F9           ; $10B169   |
    CLC                 ; $10B16C   |
    ADC #$000A          ; $10B16D   |
    STA $10F9           ; $10B170   |
    LDA #$000D          ; $10B173   |
    STA $10DE           ; $10B176   |
    LDA #$0090          ; $10B179   |
    STA $10E0           ; $10B17C   |
    JMP CODE_10ABDF     ; $10B17F   |

CODE_10B182:
    LDA $00             ; $10B182   |
    EOR #$FFFF          ; $10B184   |
    INC A               ; $10B187   |
    STA $10F4           ; $10B188   |

CODE_10B18B:
    LDA $118E           ; $10B18B   |
    CMP #$0004          ; $10B18E   |
    BEQ CODE_10B19A     ; $10B191   |
    SEC                 ; $10B193   |
    SBC #$0002          ; $10B194   |
    STA $118E           ; $10B197   |

CODE_10B19A:
    INC $1190           ; $10B19A   |
    LDA $1190           ; $10B19D   |
    AND #$0001          ; $10B1A0   |
    BNE CODE_10B1B1     ; $10B1A3   |
    LDA #$0007          ; $10B1A5   |\ play sound #$0007
    JSL $0085D2         ; $10B1A8   |/
    BRA CODE_10B1B1     ; $10B1AC   |

CODE_10B1AE:
    STA $10F4           ; $10B1AE   |

CODE_10B1B1:
    LDA $10F4           ; $10B1B1   |
    CMP #$007C          ; $10B1B4   |
    BCC CODE_10B1BA     ; $10B1B7   |
    RTS                 ; $10B1B9   |

CODE_10B1BA:
    LDA $1190           ; $10B1BA   |
    AND #$0003          ; $10B1BD   |
    ASL A               ; $10B1C0   |
    TAX                 ; $10B1C1   |
    JMP ($B1C5,x)       ; $10B1C2   |

DATA_10B1C5:         dw $ABA6
DATA_10B1C7:         dw $AC67
DATA_10B1C9:         dw $AC67
DATA_10B1CB:         dw $ABA6

CODE_10B1CD:
    LDA $1186           ; $10B1CD   |
    BEQ CODE_10B1DD     ; $10B1D0   |
    CMP #$0018          ; $10B1D2   |
    BCS CODE_10B1DD     ; $10B1D5   |
    JSR CODE_10B211     ; $10B1D7   |
    INC $1186           ; $10B1DA   |

CODE_10B1DD:
    RTS                 ; $10B1DD   |

DATA_10B1DE:         dw $2CE1, $2CE2, $2CF0, $2CF1
DATA_10B1E6:         dw $2CF2

DATA_10B1E8:         db $04, $04, $04, $01, $01, $01, $01, $01
DATA_10B1F0:         db $01, $02, $02, $02, $02, $03, $03, $03
DATA_10B1F8:         db $03, $03, $00, $00, $00, $00, $00

DATA_10B1FF:         db $61, $81, $A1, $61, $81, $A1, $61, $81, $A1

DATA_10B208:         db $69, $69, $69, $89, $89, $89, $A9, $A9, $A9

CODE_10B211:
    LDA $1186           ; $10B211   |
    DEC A               ; $10B214   |
    AND #$FFFC          ; $10B215   |
    LSR A               ; $10B218   |
    LSR A               ; $10B219   |
    CLC                 ; $10B21A   |
    ADC #$0011          ; $10B21B   |
    STA $0E             ; $10B21E   |
    LDA $10F2           ; $10B220   |
    AND #$00FF          ; $10B223   |

    TAX                 ; $10B226   |
    LDA $B1FF,x         ; $10B227   |
    AND #$00FF          ; $10B22A   |
    STA $04             ; $10B22D   |
    TAY                 ; $10B22F   |
    SEC                 ; $10B230   |
    SBC $0E             ; $10B231   |
    STA $00             ; $10B233   |
    TYA                 ; $10B235   |
    CLC                 ; $10B236   |
    ADC $0E             ; $10B237   |
    STA $02             ; $10B239   |
    LDA $B208,x         ; $10B23B   |
    AND #$00FF          ; $10B23E   |
    STA $0A             ; $10B241   |
    TAY                 ; $10B243   |
    SEC                 ; $10B244   |
    SBC $0E             ; $10B245   |
    STA $06             ; $10B247   |
    TYA                 ; $10B249   |
    CLC                 ; $10B24A   |
    ADC $0E             ; $10B24B   |
    STA $08             ; $10B24D   |
    JSR CODE_10B253     ; $10B24F   |
    RTS                 ; $10B252   |

CODE_10B253:
    LDY $6092           ; $10B253   |
    LDA $00             ; $10B256   |
    STA $6000,y         ; $10B258   |
    STA $6018,y         ; $10B25B   |
    STA $6028,y         ; $10B25E   |
    LDA $02             ; $10B261   |
    STA $6010,y         ; $10B263   |
    STA $6020,y         ; $10B266   |
    STA $6038,y         ; $10B269   |
    LDA $04             ; $10B26C   |
    STA $6008,y         ; $10B26E   |
    STA $6030,y         ; $10B271   |
    LDA $06             ; $10B274   |
    STA $6002,y         ; $10B276   |
    STA $600A,y         ; $10B279   |
    STA $6012,y         ; $10B27C   |
    LDA $08             ; $10B27F   |
    STA $602A,y         ; $10B281   |
    STA $6032,y         ; $10B284   |
    STA $603A,y         ; $10B287   |
    LDA $0A             ; $10B28A   |
    STA $601A,y         ; $10B28C   |
    STA $6022,y         ; $10B28F   |
    LDA $1186           ; $10B292   |
    DEC A               ; $10B295   |
    TAX                 ; $10B296   |
    LDA $B1E8,x         ; $10B297   |
    AND #$00FF          ; $10B29A   |
    ASL A               ; $10B29D   |
    TAX                 ; $10B29E   |
    LDA $B1DE,x         ; $10B29F   |
    STA $6004,y         ; $10B2A2   |
    STA $600C,y         ; $10B2A5   |
    STA $6014,y         ; $10B2A8   |
    STA $601C,y         ; $10B2AB   |
    STA $6024,y         ; $10B2AE   |
    STA $602C,y         ; $10B2B1   |
    STA $6034,y         ; $10B2B4   |
    STA $603C,y         ; $10B2B7   |
    LDA #$0000          ; $10B2BA   |
    STA $6006,y         ; $10B2BD   |
    STA $600E,y         ; $10B2C0   |
    STA $6016,y         ; $10B2C3   |
    STA $601E,y         ; $10B2C6   |
    STA $6026,y         ; $10B2C9   |
    STA $602E,y         ; $10B2CC   |
    STA $6036,y         ; $10B2CF   |
    STA $603E,y         ; $10B2D2   |
    TYA                 ; $10B2D5   |
    CLC                 ; $10B2D6   |
    ADC #$0040          ; $10B2D7   |
    STA $6092           ; $10B2DA   |
    RTS                 ; $10B2DD   |

CODE_10B2DE:
    LDA $1188           ; $10B2DE   |
    ASL A               ; $10B2E1   |
    TAX                 ; $10B2E2   |
    JMP ($B2E6,x)       ; $10B2E3   |

DATA_10B2E6:         dw $B04F
DATA_10B2E8:         dw $B316
DATA_10B2EA:         dw $B356
DATA_10B2EC:         dw $B44F
DATA_10B2EE:         dw $B47A
DATA_10B2F0:         dw $B04F

DATA_10B2F2:         dw $6000, $8000, $A000, $6000
DATA_10B2FA:         dw $8000, $A000, $6000, $8000
DATA_10B302:         dw $A000

DATA_10B304:         dw $5800, $5800, $5800, $7800
DATA_10B30C:         dw $7800, $7800, $9800, $9800
DATA_10B314:         dw $9800

    SEP #$20            ; $10B316   |
    LDA #$FF            ; $10B318   |
    STA $74A6           ; $10B31A   |
    REP #$20            ; $10B31D   |
    STZ $6F04           ; $10B31F   |
    LDA $10F2           ; $10B322   |
    AND #$00FF          ; $10B325   |
    ASL A               ; $10B328   |
    TAX                 ; $10B329   |
    LDA $B2F2,x         ; $10B32A   |
    STA $70E6           ; $10B32D   |
    SEC                 ; $10B330   |
    SBC #$2000          ; $10B331   |
    STA $118C           ; $10B334   |
    LDA $B304,x         ; $10B337   |
    STA $7186           ; $10B33A   |
    LDA #$0500          ; $10B33D   |
    STA $7224           ; $10B340   |
    LDA #$FD00          ; $10B343   |
    STA $7226           ; $10B346   |
    LDA #$0020          ; $10B349   |
    STA $7978           ; $10B34C   |
    JSR CODE_10B3D6     ; $10B34F   |
    INC $1188           ; $10B352   |
    RTS                 ; $10B355   |

    JSR CODE_10B398     ; $10B356   |
    JSR CODE_10B3B2     ; $10B359   |
    LDA $7224           ; $10B35C   |
    BPL CODE_10B372     ; $10B35F   |
    LDA #$0020          ; $10B361   |
    STA $7224           ; $10B364   |
    LDA #$0040          ; $10B367   |
    STA $7226           ; $10B36A   |
    INC $1188           ; $10B36D   |
    BRA CODE_10B378     ; $10B370   |

CODE_10B372:
    JSR CODE_10B37C     ; $10B372   |
    JSR CODE_10B387     ; $10B375   |

CODE_10B378:
    JSR CODE_10B3D6     ; $10B378   |
    RTS                 ; $10B37B   |

CODE_10B37C:
    LDA $70E6           ; $10B37C   |
    CLC                 ; $10B37F   |
    ADC $7224           ; $10B380   |
    STA $70E6           ; $10B383   |
    RTS                 ; $10B386   |

CODE_10B387:
    LDA $7186           ; $10B387   |
    CLC                 ; $10B38A   |
    ADC $7226           ; $10B38B   |
    STA $7186           ; $10B38E   |
    RTS                 ; $10B391   |

DATA_10B392:         dw $FFC0, $0000, $FFE0

CODE_10B398:
    LDA $1188           ; $10B398   |
    SEC                 ; $10B39B   |
    SBC #$0002          ; $10B39C   |
    ASL A               ; $10B39F   |
    TAX                 ; $10B3A0   |
    LDA $B392,x         ; $10B3A1   |
    CLC                 ; $10B3A4   |
    ADC $7224           ; $10B3A5   |
    STA $7224           ; $10B3A8   |
    RTS                 ; $10B3AB   |

DATA_10B3AC:         dw $0010, $0006, $FFF0

CODE_10B3B2:
    LDA $1188           ; $10B3B2   |
    SEC                 ; $10B3B5   |
    SBC #$0002          ; $10B3B6   |
    ASL A               ; $10B3B9   |
    TAX                 ; $10B3BA   |
    LDA $B3AC,x         ; $10B3BB   |
    CLC                 ; $10B3BE   |
    ADC $7226           ; $10B3BF   |
    STA $7226           ; $10B3C2   |
    RTS                 ; $10B3C5   |

DATA_10B3C6:         dw $3709, $370B, $3729, $372B
DATA_10B3CE:         dw $3749, $374B, $3769, $376B

CODE_10B3D6:
    LDY $6092           ; $10B3D6   |
    LDA $70E6           ; $10B3D9   |
    AND #$FF00          ; $10B3DC   |
    CMP #$E000          ; $10B3DF   |
    BCC CODE_10B3E7     ; $10B3E2   |
    ORA #$00FF          ; $10B3E4   |

CODE_10B3E7:
    XBA                 ; $10B3E7   |
    STA $6000,y         ; $10B3E8   |
    STA $6010,y         ; $10B3EB   |
    CLC                 ; $10B3EE   |
    ADC #$0010          ; $10B3EF   |
    STA $6008,y         ; $10B3F2   |
    STA $6018,y         ; $10B3F5   |
    LDA $7186           ; $10B3F8   |
    AND #$FF00          ; $10B3FB   |
    XBA                 ; $10B3FE   |
    STA $6002,y         ; $10B3FF   |
    STA $600A,y         ; $10B402   |
    CLC                 ; $10B405   |
    ADC #$0010          ; $10B406   |
    STA $6012,y         ; $10B409   |
    STA $601A,y         ; $10B40C   |
    LDA $1188           ; $10B40F   |
    CMP #$0004          ; $10B412   |
    BEQ CODE_10B41C     ; $10B415   |
    LDX #$0000          ; $10B417   |
    BRA CODE_10B41F     ; $10B41A   |

CODE_10B41C:
    LDX #$0008          ; $10B41C   |

CODE_10B41F:
    LDA $B3C6,x         ; $10B41F   |
    STA $6004,y         ; $10B422   |
    LDA $B3C8,x         ; $10B425   |
    STA $600C,y         ; $10B428   |
    LDA $B3CA,x         ; $10B42B   |
    STA $6014,y         ; $10B42E   |
    LDA $B3CC,x         ; $10B431   |
    STA $601C,y         ; $10B434   |
    LDA #$0002          ; $10B437   |
    STA $6006,y         ; $10B43A   |
    STA $600E,y         ; $10B43D   |
    STA $6016,y         ; $10B440   |
    STA $601E,y         ; $10B443   |
    TYA                 ; $10B446   |
    CLC                 ; $10B447   |
    ADC #$0020          ; $10B448   |
    STA $6092           ; $10B44B   |
    RTS                 ; $10B44E   |

    DEC $7978           ; $10B44F   |
    BPL CODE_10B46A     ; $10B452   |
    LDA #$FFF0          ; $10B454   |
    STA $7224           ; $10B457   |
    LDA #$0200          ; $10B45A   |
    STA $7226           ; $10B45D   |
    LDA #$0019          ; $10B460   |\ play sound #$0019
    JSL $0085D2         ; $10B463   |/
    INC $1188           ; $10B467   |

CODE_10B46A:
    JSR CODE_10B398     ; $10B46A   |
    JSR CODE_10B3B2     ; $10B46D   |
    JSR CODE_10B37C     ; $10B470   |
    JSR CODE_10B387     ; $10B473   |
    JSR CODE_10B3D6     ; $10B476   |
    RTS                 ; $10B479   |

    LDA $70E6           ; $10B47A   |
    BPL CODE_10B48E     ; $10B47D   |
    CMP #$E000          ; $10B47F   |
    BCC CODE_10B48E     ; $10B482   |
    CMP #$F000          ; $10B484   |
    BCS CODE_10B48E     ; $10B487   |
    INC $1188           ; $10B489   |
    BRA CODE_10B49D     ; $10B48C   |

CODE_10B48E:
    JSR CODE_10B398     ; $10B48E   |
    JSR CODE_10B3B2     ; $10B491   |
    JSR CODE_10B37C     ; $10B494   |
    JSR CODE_10B387     ; $10B497   |
    JSR CODE_10B3D6     ; $10B49A   |

CODE_10B49D:
    RTS                 ; $10B49D   |

    JSR CODE_10AE80     ; $10B49E   |
    JSR CODE_10B4F1     ; $10B4A1   |
    LDA $10F4           ; $10B4A4   |
    CMP #$00C0          ; $10B4A7   |
    BNE CODE_10B4B1     ; $10B4AA   |
    INC $10DE           ; $10B4AC   |
    BRA CODE_10B4B8     ; $10B4AF   |

CODE_10B4B1:
    SEC                 ; $10B4B1   |
    SBC #$0020          ; $10B4B2   |
    STA $10F4           ; $10B4B5   |

CODE_10B4B8:
    JMP CODE_10B54F     ; $10B4B8   |

    JSR CODE_10AE80     ; $10B4BB   |
    LDA $10F4           ; $10B4BE   |
    CMP #$0100          ; $10B4C1   |
    BNE CODE_10B4E1     ; $10B4C4   |
    JSR CODE_10B5A4     ; $10B4C6   |
    LDA #$0029          ; $10B4C9   |
    STA $704070         ; $10B4CC   |
    INC $0D0F           ; $10B4D0   |
    LDA #$000C          ; $10B4D3   |
    STA $10DE           ; $10B4D6   |
    LDA #$0001          ; $10B4D9   |
    STA $10E0           ; $10B4DC   |
    BRA CODE_10B4EE     ; $10B4DF   |

CODE_10B4E1:
    JSR CODE_10B4F1     ; $10B4E1   |
    LDA $10F4           ; $10B4E4   |
    CLC                 ; $10B4E7   |
    ADC #$0010          ; $10B4E8   |
    STA $10F4           ; $10B4EB   |

CODE_10B4EE:
    JMP CODE_10B54F     ; $10B4EE   |

CODE_10B4F1:
    PHY                 ; $10B4F1   |
    LDY $6092           ; $10B4F2   |
    LDA $AB1C           ; $10B4F5   |
    AND #$00FF          ; $10B4F8   |
    STA $6000,y         ; $10B4FB   |
    STA $6010,y         ; $10B4FE   |
    CLC                 ; $10B501   |
    ADC #$0010          ; $10B502   |
    STA $6008,y         ; $10B505   |
    STA $6018,y         ; $10B508   |
    LDA $AB25           ; $10B50B   |
    AND #$00FF          ; $10B50E   |
    STA $6002,y         ; $10B511   |
    STA $600A,y         ; $10B514   |
    CLC                 ; $10B517   |
    ADC #$0010          ; $10B518   |
    STA $6012,y         ; $10B51B   |
    STA $601A,y         ; $10B51E   |
    LDA #$39E8          ; $10B521   |
    STA $6004,y         ; $10B524   |
    INC A               ; $10B527   |
    INC A               ; $10B528   |
    STA $600C,y         ; $10B529   |
    INC A               ; $10B52C   |
    INC A               ; $10B52D   |
    STA $6014,y         ; $10B52E   |
    INC A               ; $10B531   |
    INC A               ; $10B532   |
    STA $601C,y         ; $10B533   |
    LDA #$0002          ; $10B536   |
    STA $6006,y         ; $10B539   |
    STA $600E,y         ; $10B53C   |
    STA $6016,y         ; $10B53F   |
    STA $601E,y         ; $10B542   |
    TYA                 ; $10B545   |
    CLC                 ; $10B546   |
    ADC #$0020          ; $10B547   |
    STA $6092           ; $10B54A   |
    PLY                 ; $10B54D   |
    RTS                 ; $10B54E   |

CODE_10B54F:
    STA $300C           ; $10B54F   |
    LDA #$0015          ; $10B552   |
    STA $3002           ; $10B555   |
    LDA #$0081          ; $10B558   |
    STA $3006           ; $10B55B   |
    SEP #$10            ; $10B55E   |
    LDX #$08            ; $10B560   |
    LDA #$DBDE          ; $10B562   |
    JSL $7EDE44         ; $10B565   | GSU init
    REP #$10            ; $10B569   |
    JSR CODE_10AD19     ; $10B56B   |
    RTS                 ; $10B56E   |

CODE_10B56F:
    LDA #$0003          ; $10B56F   |
    STA $0E             ; $10B572   |
    LDY $AB08           ; $10B574   |

CODE_10B577:
    LDA #$0010          ; $10B577   |
    STA $01             ; $10B57A   |
    LDX #$AB12          ; $10B57C   |
    LDA #$0006          ; $10B57F   |
    PHY                 ; $10B582   |
    JSL $00BEA6         ; $10B583   |
    PLA                 ; $10B587   |
    CLC                 ; $10B588   |
    ADC #$0020          ; $10B589   |
    TAY                 ; $10B58C   |
    DEC $0E             ; $10B58D   |
    BNE CODE_10B577     ; $10B58F   |
    RTS                 ; $10B591   |

DATA_10B592:         dw $19D1, $19D2, $19D3, $19D4
DATA_10B59A:         dw $19D5, $19D6, $19D7, $19D8
DATA_10B5A2:         dw $19D9

CODE_10B5A4:
    LDA #$0003          ; $10B5A4   |
    STA $0E             ; $10B5A7   |
    LDY $AB08           ; $10B5A9   |
    LDX #$B592          ; $10B5AC   |

CODE_10B5AF:
    LDA #$0010          ; $10B5AF   |
    STA $01             ; $10B5B2   |
    LDA #$0006          ; $10B5B4   |
    PHX                 ; $10B5B7   |
    PHY                 ; $10B5B8   |
    JSL $00BEA6         ; $10B5B9   |
    PLA                 ; $10B5BD   |
    CLC                 ; $10B5BE   |
    ADC #$0020          ; $10B5BF   |
    TAY                 ; $10B5C2   |
    PLA                 ; $10B5C3   |
    CLC                 ; $10B5C4   |
    ADC #$0006          ; $10B5C5   |
    TAX                 ; $10B5C8   |
    DEC $0E             ; $10B5C9   |
    BNE CODE_10B5AF     ; $10B5CB   |
    RTS                 ; $10B5CD   |

    LDA $10DE           ; $10B5CE   |
    ASL A               ; $10B5D1   |
    TAX                 ; $10B5D2   |
    JMP ($B5D6,x)       ; $10B5D3   |

DATA_10B5D6:         dw $A41C
DATA_10B5D8:         dw $A427
DATA_10B5DA:         dw $A444
DATA_10B5DC:         dw $A466
DATA_10B5DE:         dw $A481
DATA_10B5E0:         dw $A4EC
DATA_10B5E2:         dw $A549
DATA_10B5E4:         dw $A5B3
DATA_10B5E6:         dw $B7F1
DATA_10B5E8:         dw $B8B9
DATA_10B5EA:         dw $B97F
DATA_10B5EC:         dw $BC8C
DATA_10B5EE:         dw $B9F8
DATA_10B5F0:         dw $A621

DATA_10B5F2:         dw $3987, $398B, $3A05, $3A09
DATA_10B5FA:         dw $3A0D, $3A87, $3A8B

DATA_10B600:         dw $0A23, $0A24, $0A25, $0A33
DATA_10B608:         dw $0A34, $0A35, $0A43, $0A44
DATA_10B610:         dw $0A45, $0A20, $0A21, $0A22
DATA_10B618:         dw $0A30, $0A31, $0A32, $0A40
DATA_10B620:         dw $0A41, $0A42

DATA_10B624:         dw $B600

DATA_10B626:         db $10, $12, $B6, $10

DATA_10B62A:         db $03, $00, $00, $03, $00, $00, $03

DATA_10B631:         db $38, $58, $28, $48, $68, $38, $58

DATA_10B638:         db $60, $60, $80, $80, $80, $A0, $A0

DATA_10B63F:         db $00, $01, $FF, $00

DATA_10B643:         db $05, $05, $FE, $FE, $FD, $FD, $FD

DATA_10B64A:         db $02, $02, $03, $03, $02, $FB, $FB

DATA_10B651:         dw $0000, $0090, $0120, $01B0
DATA_10B659:         dw $0240, $02D0, $0360, $0000
DATA_10B661:         dw $1700, $0001, $1701, $0003
DATA_10B669:         dw $1703, $0005, $1705, $0007
DATA_10B671:         dw $1707, $0009, $1709, $000B
DATA_10B679:         dw $170B, $000D, $170D, $000F
DATA_10B681:         dw $170F, $0011, $1711, $0013
DATA_10B689:         dw $1713, $0015, $1715, $0017
DATA_10B691:         dw $1717, $01FF, $0000, $0301
DATA_10B699:         dw $0000, $0503, $0000, $0705
DATA_10B6A1:         dw $0000, $0907, $0000, $0B09
DATA_10B6A9:         dw $0000, $0D0B, $0000, $0F0D
DATA_10B6B1:         dw $0000, $110F, $0000, $1311
DATA_10B6B9:         dw $0000, $1513, $0000, $1715
DATA_10B6C1:         dw $0000, $1617, $1717, $1416
DATA_10B6C9:         dw $1717, $1214, $1717, $1012
DATA_10B6D1:         dw $1717, $0E10, $1717, $0C0E
DATA_10B6D9:         dw $1717, $0A0C, $1717, $080A
DATA_10B6E1:         dw $1717, $0608, $1717, $0406
DATA_10B6E9:         dw $1717, $0204, $1717, $0002
DATA_10B6F1:         dw $1717, $FF00, $0000, $1717
DATA_10B6F9:         dw $0017, $1700, $0001, $1702
DATA_10B701:         dw $0003, $1704, $0005, $1706
DATA_10B709:         dw $0007, $1708, $0009, $170A
DATA_10B711:         dw $000B, $170C, $000D, $170E
DATA_10B719:         dw $000F, $1710, $0011, $1712
DATA_10B721:         dw $0013, $1714, $0015, $1716
DATA_10B729:         dw $0017, $1717, $00FF, $1717
DATA_10B731:         dw $0017, $1715, $0015, $1713
DATA_10B739:         dw $0013, $1711, $0011, $170F
DATA_10B741:         dw $000F, $170D, $000D, $170B
DATA_10B749:         dw $000B, $1709, $0009, $1707
DATA_10B751:         dw $0007, $1705, $0005, $1703
DATA_10B759:         dw $0003, $1701, $0001, $1700
DATA_10B761:         dw $FF00

DATA_10B763:         dw $B65F, $B694, $B6F5, $B72E

CODE_10B76B:
    SEP #$30            ; $10B76B   |
    LDA #$00            ; $10B76D   |
    STA $1114           ; $10B76F   |
    TAY                 ; $10B772   |
    LDA $B631,y         ; $10B773   |
    STA $10F6           ; $10B776   |
    LDA $B638,y         ; $10B779   |
    STA $10F7           ; $10B77C   |
    LDX #$06            ; $10B77F   |
    TXY                 ; $10B781   |

CODE_10B782:
    LDA $B62A,x         ; $10B782   |
    STA $00,x           ; $10B785   |
    DEX                 ; $10B787   |
    BPL CODE_10B782     ; $10B788   |
    LDA #$15            ; $10B78A   |
    STA $2D             ; $10B78C   |
    LDA #$11            ; $10B78E   |
    STA $2E             ; $10B790   |
    JSR CODE_10BD2A     ; $10B792   |
    STZ $111D           ; $10B795   |
    STZ $111C           ; $10B798   |
    LDY #$06            ; $10B79B   |
    LDA #$00            ; $10B79D   |

CODE_10B79F:
    STA $111E,y         ; $10B79F   |
    DEY                 ; $10B7A2   |
    BPL CODE_10B79F     ; $10B7A3   |
    REP #$30            ; $10B7A5   |
    LDY #$0006          ; $10B7A7   |

CODE_10B7AA:
    PHY                 ; $10B7AA   |
    LDA $1115,y         ; $10B7AB   |
    AND #$00FF          ; $10B7AE   |
    TAX                 ; $10B7B1   |
    LDA $B626,x         ; $10B7B2   |
    AND #$00FF          ; $10B7B5   |
    STA $01             ; $10B7B8   |
    LDA $B624,x         ; $10B7BA   |
    TAX                 ; $10B7BD   |
    TYA                 ; $10B7BE   |
    ASL A               ; $10B7BF   |
    TAY                 ; $10B7C0   |
    LDA $B5F2,y         ; $10B7C1   |
    TAY                 ; $10B7C4   |
    LDA #$0003          ; $10B7C5   |
    STA $1E             ; $10B7C8   |

CODE_10B7CA:
    PHY                 ; $10B7CA   |
    PHX                 ; $10B7CB   |
    LDA #$0006          ; $10B7CC   |
    JSL $00BEA6         ; $10B7CF   |
    PLA                 ; $10B7D3   |
    CLC                 ; $10B7D4   |
    ADC #$0006          ; $10B7D5   |
    TAX                 ; $10B7D8   |
    PLA                 ; $10B7D9   |
    CLC                 ; $10B7DA   |
    ADC #$0020          ; $10B7DB   |
    TAY                 ; $10B7DE   |
    DEC $1E             ; $10B7DF   |
    BNE CODE_10B7CA     ; $10B7E1   |
    PLY                 ; $10B7E3   |
    DEY                 ; $10B7E4   |
    BPL CODE_10B7AA     ; $10B7E5   |
    LDA #$0080          ; $10B7E7   |
    STA $1110           ; $10B7EA   |
    STA $1112           ; $10B7ED   |
    RTS                 ; $10B7F0   |

    JSL $008408         ; $10B7F1   |
    SEP #$20            ; $10B7F5   |
    LDA $110F           ; $10B7F7   |
    BEQ CODE_10B7FF     ; $10B7FA   |
    DEC $110F           ; $10B7FC   |

CODE_10B7FF:
    REP #$20            ; $10B7FF   |
    LDA $10F6           ; $10B801   |
    AND #$00FF          ; $10B804   |
    CLC                 ; $10B807   |
    ADC #$0014          ; $10B808   |
    STA $00             ; $10B80B   |
    LDA $10F7           ; $10B80D   |
    AND #$00FF          ; $10B810   |
    CLC                 ; $10B813   |
    ADC #$0014          ; $10B814   |
    STA $02             ; $10B817   |
    LDA #$3564          ; $10B819   |
    STA $04             ; $10B81C   |
    JSR CODE_10BBF9     ; $10B81E   |
    LDA $093E           ; $10B821   |
    AND #$C080          ; $10B824   |
    BNE CODE_10B82C     ; $10B827   |
    JMP CODE_10B8B5     ; $10B829   |

CODE_10B82C:
    LDA $1114           ; $10B82C   |
    AND #$00FF          ; $10B82F   |
    TAX                 ; $10B832   |
    LDA $111E,x         ; $10B833   |
    AND #$00FF          ; $10B836   |
    BEQ CODE_10B844     ; $10B839   |
    LDA #$002A          ; $10B83B   |\ play sound #$002A
    JSL $0085D2         ; $10B83E   |/
    BRA CODE_10B8B5     ; $10B842   |

CODE_10B844:
    LDA #$0009          ; $10B844   |\ play sound #$0009
    JSL $0085D2         ; $10B847   |/
    LDY #$000A          ; $10B84B   |
    STY $10F0           ; $10B84E   |
    LDA $A2DD,y         ; $10B851   |
    JSR CODE_10A39A     ; $10B854   |
    SEP #$30            ; $10B857   |
    LDA #$18            ; $10B859   |
    STA $110F           ; $10B85B   |
    INC $111E,x         ; $10B85E   |
    INC $10DE           ; $10B861   |
    JSL $008408         ; $10B864   |
    LDA $7970           ; $10B868   |
    STA $4202           ; $10B86B   |
    LDA #$04            ; $10B86E   |
    STA $4203           ; $10B870   |
    NOP                 ; $10B873   |
    NOP                 ; $10B874   |
    NOP                 ; $10B875   |
    NOP                 ; $10B876   |
    LDA $4217           ; $10B877   |
    ASL A               ; $10B87A   |
    TAX                 ; $10B87B   |
    REP #$20            ; $10B87C   |
    LDY #$00            ; $10B87E   |
    LDA $B763,x         ; $10B880   |
    STA $A3             ; $10B883   |
    LDA ($A3),y         ; $10B885   |
    INY                 ; $10B887   |
    AND #$00FF          ; $10B888   |
    XBA                 ; $10B88B   |
    STA $1110           ; $10B88C   |
    LDA ($A3),y         ; $10B88F   |
    INY                 ; $10B891   |
    STY $111C           ; $10B892   |
    AND #$00FF          ; $10B895   |
    XBA                 ; $10B898   |
    STA $1112           ; $10B899   |
    LDA #$0053          ; $10B89C   |
    STA $3000           ; $10B89F   |
    LDA #$84E4          ; $10B8A2   |
    STA $3006           ; $10B8A5   |
    LDX #$08            ; $10B8A8   |
    LDA #$DF7E          ; $10B8AA   |
    JSL $7EDE44         ; $10B8AD   | GSU init
    REP #$10            ; $10B8B1   |
    BRA CODE_10B8B8     ; $10B8B3   |

CODE_10B8B5:
    JSR CODE_10BB07     ; $10B8B5   |

CODE_10B8B8:
    RTS                 ; $10B8B8   |

    SEP #$20            ; $10B8B9   |
    LDA $110F           ; $10B8BB   |
    BNE CODE_10B8CD     ; $10B8BE   |
    LDA #$20            ; $10B8C0   |
    STA $110F           ; $10B8C2   |
    LDA #$32            ; $10B8C5   |\ play sound #$32
    JSL $0085D2         ; $10B8C7   |/
    BRA CODE_10B8D0     ; $10B8CB   |

CODE_10B8CD:
    DEC $110F           ; $10B8CD   |

CODE_10B8D0:
    LDA $10F6           ; $10B8D0   |
    CLC                 ; $10B8D3   |
    ADC $1111           ; $10B8D4   |
    STA $00             ; $10B8D7   |
    LDA $10F7           ; $10B8D9   |
    CLC                 ; $10B8DC   |
    ADC $1113           ; $10B8DD   |
    STA $02             ; $10B8E0   |
    STZ $01             ; $10B8E2   |
    STZ $03             ; $10B8E4   |
    REP #$20            ; $10B8E6   |
    LDA #$3564          ; $10B8E8   |
    STA $04             ; $10B8EB   |
    JSR CODE_10BBF9     ; $10B8ED   |
    SEP #$10            ; $10B8F0   |
    LDA $1111           ; $10B8F2   |
    AND #$00FF          ; $10B8F5   |
    STA $3006           ; $10B8F8   |
    LDA $1113           ; $10B8FB   |
    AND #$00FF          ; $10B8FE   |
    STA $3008           ; $10B901   |
    LDX #$08            ; $10B904   |
    LDA #$DFA2          ; $10B906   |
    JSL $7EDE44         ; $10B909   | GSU init
    REP #$10            ; $10B90D   |
    LDA #$0070          ; $10B90F   |
    STA $01             ; $10B912   |
    LDA $1114           ; $10B914   |
    AND #$00FF          ; $10B917   |
    ASL A               ; $10B91A   |
    TAX                 ; $10B91B   |
    LDY $B651,x         ; $10B91C   |
    LDX #$5800          ; $10B91F   |
    LDA #$0003          ; $10B922   |
    STA $0E             ; $10B925   |

CODE_10B927:
    LDA #$0060          ; $10B927   |
    PHX                 ; $10B92A   |
    PHY                 ; $10B92B   |
    JSL $00BEA6         ; $10B92C   |
    PLA                 ; $10B930   |
    CLC                 ; $10B931   |
    ADC #$0030          ; $10B932   |
    TAY                 ; $10B935   |
    PLA                 ; $10B936   |
    CLC                 ; $10B937   |
    ADC #$0200          ; $10B938   |
    TAX                 ; $10B93B   |
    DEC $0E             ; $10B93C   |
    BNE CODE_10B927     ; $10B93E   |
    SEP #$30            ; $10B940   |
    LDY $111C           ; $10B942   |
    LDA ($A3),y         ; $10B945   |
    BPL CODE_10B979     ; $10B947   |
    LDA #$90            ; $10B949   |
    LDX $1114           ; $10B94B   |
    LDY $1115,x         ; $10B94E   |
    BEQ CODE_10B955     ; $10B951   |
    LDA #$8F            ; $10B953   |\ play sound #$008F

CODE_10B955:
    JSL $0085D2         ; $10B955   |/
    INC $111D           ; $10B959   |
    LDA $111D           ; $10B95C   |
    CMP #$03            ; $10B95F   |
    BNE CODE_10B968     ; $10B961   |
    INC $10DE           ; $10B963   |
    BRA CODE_10B97C     ; $10B966   |

CODE_10B968:
    DEC $10DE           ; $10B968   |
    REP #$30            ; $10B96B   |
    LDY #$0000          ; $10B96D   |
    STY $10F0           ; $10B970   |
    LDA $A2DD,y         ; $10B973   |
    JMP CODE_10A39A     ; $10B976   |

CODE_10B979:
    JSR CODE_10BB72     ; $10B979   |

CODE_10B97C:
    REP #$30            ; $10B97C   |
    RTS                 ; $10B97E   |

    SEP #$30            ; $10B97F   |
    STZ $1125           ; $10B981   |
    LDY #$06            ; $10B984   |

CODE_10B986:
    LDA $111E,y         ; $10B986   |
    BEQ CODE_10B993     ; $10B989   |
    LDA $1115,y         ; $10B98B   |
    BEQ CODE_10B993     ; $10B98E   |
    INC $1125           ; $10B990   |

CODE_10B993:
    DEY                 ; $10B993   |
    BPL CODE_10B986     ; $10B994   |
    LDY $1125           ; $10B996   |
    LDA $B9E0,y         ; $10B999   |
    STA $1148           ; $10B99C   |
    STZ $1149           ; $10B99F   |
    LDA $B9F0,y         ; $10B9A2   |
    STA $10E0           ; $10B9A5   |
    LDA $B9F4,y         ; $10B9A8   |
    STA $10E1           ; $10B9AB   |
    STZ $A3             ; $10B9AE   |
    STZ $A4             ; $10B9B0   |
    STZ $A5             ; $10B9B2   |
    STZ $A6             ; $10B9B4   |
    LDA $B9E4,y         ; $10B9B6   |
    CPY #$00            ; $10B9B9   |
    BNE CODE_10B9C5     ; $10B9BB   |
    PHY                 ; $10B9BD   |
    JSL $0085D2         ; $10B9BE   |
    PLY                 ; $10B9C2   |
    BRA CODE_10B9C8     ; $10B9C3   |

CODE_10B9C5:
    STA $004D           ; $10B9C5   |

CODE_10B9C8:
    INC $10DE           ; $10B9C8   |
    REP #$30            ; $10B9CB   |
    TYA                 ; $10B9CD   |
    ASL A               ; $10B9CE   |
    TAY                 ; $10B9CF   |
    LDA $B9E8,y         ; $10B9D0   |
    STA $10F0           ; $10B9D3   |
    TAY                 ; $10B9D6   |
    LDA $A2DD,y         ; $10B9D7   |
    JMP CODE_10A39A     ; $10B9DA   |

    REP #$30            ; $10B9DD   |
    RTS                 ; $10B9DF   |

DATA_10B9E0:         db $00, $01, $02, $05

DATA_10B9E4:         db $7D, $05, $05, $05, $06, $00, $04, $00
DATA_10B9EC:         db $04, $00, $04, $00

DATA_10B9F0:         db $78, $78, $78, $78

DATA_10B9F4:         db $00, $00, $00, $00

CODE_10B9F8:
    LDA $10E0           ; $10B9F8   |
    BEQ CODE_10BA02     ; $10B9FB   |
    DEC $10E0           ; $10B9FD   |
    BRA CODE_10BA7E     ; $10BA00   |

CODE_10BA02:
    LDA $1148           ; $10BA02   |
    BNE CODE_10BA12     ; $10BA05   |

CODE_10BA07:
    LDA #$0080          ; $10BA07   |
    STA $10E0           ; $10BA0A   |
    INC $10DE           ; $10BA0D   |
    BRA CODE_10BA7E     ; $10BA10   |

CODE_10BA12:
    LDY $0379           ; $10BA12   |
    CPY #$03E7          ; $10BA15   |
    BEQ CODE_10BA07     ; $10BA18   |
    PHA                 ; $10BA1A   |
    LDA #$0008          ; $10BA1B   |\ play sound #$0008
    JSL $0085D2         ; $10BA1E   |/
    PLA                 ; $10BA22   |
    LDY #$0030          ; $10BA23   |
    STY $10E0           ; $10BA26   |
    CMP #$006F          ; $10BA29   |
    BCS CODE_10BA5F     ; $10BA2C   |
    CMP #$000B          ; $10BA2E   |
    BCS CODE_10BA3E     ; $10BA31   |
    INC $0379           ; $10BA33   |
    JSR CODE_109D74     ; $10BA36   |
    DEC $1148           ; $10BA39   |
    BRA CODE_10BA7E     ; $10BA3C   |

CODE_10BA3E:
    LDA $0379           ; $10BA3E   |
    CLC                 ; $10BA41   |
    ADC #$000A          ; $10BA42   |
    CMP #$03E8          ; $10BA45   |
    BCC CODE_10BA4D     ; $10BA48   |
    LDA #$03E7          ; $10BA4A   |

CODE_10BA4D:
    STA $0379           ; $10BA4D   |
    JSR CODE_109D74     ; $10BA50   |
    LDA $1148           ; $10BA53   |
    SEC                 ; $10BA56   |
    SBC #$000A          ; $10BA57   |
    STA $1148           ; $10BA5A   |
    BRA CODE_10BA7E     ; $10BA5D   |

CODE_10BA5F:
    LDA $0379           ; $10BA5F   |
    CLC                 ; $10BA62   |
    ADC #$0064          ; $10BA63   |
    CMP #$03E8          ; $10BA66   |
    BCC CODE_10BA6E     ; $10BA69   |
    LDA #$03E7          ; $10BA6B   |

CODE_10BA6E:
    STA $0379           ; $10BA6E   |
    JSR CODE_109D74     ; $10BA71   |
    LDA $1148           ; $10BA74   |
    SEC                 ; $10BA77   |
    SBC #$0064          ; $10BA78   |
    STA $1148           ; $10BA7B   |

CODE_10BA7E:
    RTS                 ; $10BA7E   |

    LDA $10E0           ; $10BA7F   |
    BEQ CODE_10BA8A     ; $10BA82   |
    DEC $10E0           ; $10BA84   |
    JMP CODE_10BB06     ; $10BA87   |

CODE_10BA8A:
    LDA $0379           ; $10BA8A   |
    BEQ CODE_10BA94     ; $10BA8D   |
    LDA $1148           ; $10BA8F   |
    BNE CODE_10BA9F     ; $10BA92   |

CODE_10BA94:
    LDA #$0080          ; $10BA94   |
    STA $10E0           ; $10BA97   |
    INC $10DE           ; $10BA9A   |
    BRA CODE_10BB06     ; $10BA9D   |

CODE_10BA9F:
    LDY #$0030          ; $10BA9F   |
    STY $10E0           ; $10BAA2   |
    CMP #$006F          ; $10BAA5   |
    BCS CODE_10BAE7     ; $10BAA8   |
    CMP #$000B          ; $10BAAA   |
    BCS CODE_10BAC6     ; $10BAAD   |
    LDA $0379           ; $10BAAF   |
    DEC A               ; $10BAB2   |
    CMP #$0001          ; $10BAB3   |
    BPL CODE_10BABB     ; $10BAB6   |
    LDA #$0001          ; $10BAB8   |

CODE_10BABB:
    STA $0379           ; $10BABB   |
    JSR CODE_109D74     ; $10BABE   |
    DEC $1148           ; $10BAC1   |
    BRA CODE_10BB06     ; $10BAC4   |

CODE_10BAC6:
    LDA $0379           ; $10BAC6   |
    SEC                 ; $10BAC9   |
    SBC #$000A          ; $10BACA   |
    CMP #$0001          ; $10BACD   |
    BPL CODE_10BAD5     ; $10BAD0   |
    LDA #$0001          ; $10BAD2   |

CODE_10BAD5:
    STA $0379           ; $10BAD5   |
    JSR CODE_109D74     ; $10BAD8   |
    LDA $1148           ; $10BADB   |
    SEC                 ; $10BADE   |
    SBC #$000A          ; $10BADF   |
    STA $1148           ; $10BAE2   |
    BRA CODE_10BB06     ; $10BAE5   |

CODE_10BAE7:
    LDA $0379           ; $10BAE7   |
    SEC                 ; $10BAEA   |
    SBC #$0064          ; $10BAEB   |
    CMP #$0001          ; $10BAEE   |
    BPL CODE_10BAF6     ; $10BAF1   |
    LDA #$0001          ; $10BAF3   |

CODE_10BAF6:
    STA $0379           ; $10BAF6   |
    JSR CODE_109D74     ; $10BAF9   |
    LDA $1148           ; $10BAFC   |
    SEC                 ; $10BAFF   |
    SBC #$0064          ; $10BB00   |
    STA $1148           ; $10BB03   |

CODE_10BB06:
    RTS                 ; $10BB06   |

CODE_10BB07:
    SEP #$30            ; $10BB07   |
    LDA $093F           ; $10BB09   |
    AND #$0F            ; $10BB0C   |
    BEQ CODE_10BB14     ; $10BB0E   |
    LDY #$20            ; $10BB10   |
    BRA CODE_10BB1B     ; $10BB12   |

CODE_10BB14:
    LDY $110F           ; $10BB14   |
    BNE CODE_10BB6F     ; $10BB17   |
    LDY #$10            ; $10BB19   |

CODE_10BB1B:
    STY $110F           ; $10BB1B   |
    LDA $093D           ; $10BB1E   |
    AND #$0F            ; $10BB21   |
    BNE CODE_10BB27     ; $10BB23   |
    BRA CODE_10BB6F     ; $10BB25   |

CODE_10BB27:
    PHA                 ; $10BB27   |
    AND #$03            ; $10BB28   |
    TAY                 ; $10BB2A   |
    LDA $1114           ; $10BB2B   |
    CLC                 ; $10BB2E   |
    ADC $B63F,y         ; $10BB2F   |
    BPL CODE_10BB38     ; $10BB32   |
    LDA #$06            ; $10BB34   |
    BRA CODE_10BB3E     ; $10BB36   |

CODE_10BB38:
    CMP #$07            ; $10BB38   |
    BCC CODE_10BB3E     ; $10BB3A   |
    LDA #$00            ; $10BB3C   |

CODE_10BB3E:
    STA $1114           ; $10BB3E   |
    TAY                 ; $10BB41   |
    PLA                 ; $10BB42   |
    LSR A               ; $10BB43   |
    LSR A               ; $10BB44   |
    BIT #$01            ; $10BB45   |
    BEQ CODE_10BB50     ; $10BB47   |
    TYA                 ; $10BB49   |
    CLC                 ; $10BB4A   |
    ADC $B64A,y         ; $10BB4B   |
    BRA CODE_10BB59     ; $10BB4E   |

CODE_10BB50:
    BIT #$02            ; $10BB50   |
    BEQ CODE_10BB5D     ; $10BB52   |
    TYA                 ; $10BB54   |
    CLC                 ; $10BB55   |
    ADC $B643,y         ; $10BB56   |

CODE_10BB59:
    STA $1114           ; $10BB59   |
    TAY                 ; $10BB5C   |

CODE_10BB5D:
    LDA $B631,y         ; $10BB5D   |
    STA $10F6           ; $10BB60   |
    LDA $B638,y         ; $10BB63   |
    STA $10F7           ; $10BB66   |
    LDA #$5C            ; $10BB69   |\ play sound #$005C
    JSL $0085D2         ; $10BB6B   |/

CODE_10BB6F:
    REP #$30            ; $10BB6F   |
    RTS                 ; $10BB71   |

CODE_10BB72:
    REP #$20            ; $10BB72   |
    LDA ($A3),y         ; $10BB74   |
    AND #$00FF          ; $10BB76   |
    STA $3002           ; $10BB79   |
    INY                 ; $10BB7C   |
    LDA ($A3),y         ; $10BB7D   |
    AND #$00FF          ; $10BB7F   |
    STA $3004           ; $10BB82   |
    LDA $1111           ; $10BB85   |
    AND #$00FF          ; $10BB88   |
    STA $3006           ; $10BB8B   |
    LDA $1113           ; $10BB8E   |
    AND #$00FF          ; $10BB91   |
    STA $3008           ; $10BB94   |
    LDA #$0200          ; $10BB97   |
    STA $300C           ; $10BB9A   |
    LDX #$09            ; $10BB9D   |
    LDA #$907C          ; $10BB9F   |
    JSL $7EDE44         ; $10BBA2   | GSU init
    LDA $1110           ; $10BBA6   |
    CLC                 ; $10BBA9   |
    ADC $3002           ; $10BBAA   |
    STA $1110           ; $10BBAD   |
    LDA $1112           ; $10BBB0   |
    CLC                 ; $10BBB3   |
    ADC $3004           ; $10BBB4   |
    STA $1112           ; $10BBB7   |
    LDY $111C           ; $10BBBA   |
    LDA ($A3),y         ; $10BBBD   |
    AND #$00FF          ; $10BBBF   |
    XBA                 ; $10BBC2   |
    SEC                 ; $10BBC3   |
    SBC $1110           ; $10BBC4   |
    BEQ CODE_10BBD7     ; $10BBC7   |
    EOR $3002           ; $10BBC9   |
    BPL CODE_10BBF6     ; $10BBCC   |
    LDA ($A3),y         ; $10BBCE   |
    AND #$00FF          ; $10BBD0   |
    XBA                 ; $10BBD3   |
    STA $1110           ; $10BBD4   |

CODE_10BBD7:
    INY                 ; $10BBD7   |
    LDA ($A3),y         ; $10BBD8   |
    AND #$00FF          ; $10BBDA   |
    XBA                 ; $10BBDD   |
    SEC                 ; $10BBDE   |
    SBC $1112           ; $10BBDF   |
    BEQ CODE_10BBF2     ; $10BBE2   |
    EOR $3004           ; $10BBE4   |
    BPL CODE_10BBF6     ; $10BBE7   |
    LDA ($A3),y         ; $10BBE9   |
    AND #$00FF          ; $10BBEB   |
    XBA                 ; $10BBEE   |
    STA $1112           ; $10BBEF   |

CODE_10BBF2:
    INY                 ; $10BBF2   |
    STY $111C           ; $10BBF3   |

CODE_10BBF6:
    SEP #$20            ; $10BBF6   |
    RTS                 ; $10BBF8   |

CODE_10BBF9:
    LDY $6092           ; $10BBF9   |
    LDA $00             ; $10BBFC   |
    SEC                 ; $10BBFE   |
    SBC #$0007          ; $10BBFF   |
    STA $6000,y         ; $10BC02   |
    LDA $02             ; $10BC05   |
    STA $6002,y         ; $10BC07   |
    LDA $04             ; $10BC0A   |
    STA $6004,y         ; $10BC0C   |
    LDA #$0002          ; $10BC0F   |
    STA $6006,y         ; $10BC12   |
    TYA                 ; $10BC15   |
    CLC                 ; $10BC16   |
    ADC #$0008          ; $10BC17   |
    STA $6092           ; $10BC1A   |
    RTS                 ; $10BC1D   |

DATA_10BC1E:         dw $0CFC, $0CFC, $0CFC, $0CFC
DATA_10BC26:         dw $0CFC, $0CFC, $0CFC

DATA_10BC2C:         dw $0A50, $0A51, $0CFC, $0A62
DATA_10BC34:         dw $0CCB, $0EE0, $0EE1, $0A60
DATA_10BC3C:         dw $0A61, $0A52, $0A64, $0CDB
DATA_10BC44:         dw $0EF0, $0EF1

DATA_10BC48:         dw $0A50, $0A51, $0CFC, $0A62
DATA_10BC50:         dw $0CC8, $0EE0, $0EE1, $0A60
DATA_10BC58:         dw $0A61, $0A52, $0A63, $0CD8
DATA_10BC60:         dw $0EF0, $0EF1

DATA_10BC64:         dw $0A50, $0A51, $0CFC, $0A53
DATA_10BC6C:         dw $0CC7, $0EE0, $0EE1, $0A60
DATA_10BC74:         dw $0A61, $0A52, $0A54, $0CD7
DATA_10BC7C:         dw $0EF0, $0EF1

DATA_10BC80:         dw $BC64
DATA_10BC82:         dw $BC48
DATA_10BC84:         dw $BC2C

DATA_10BC86:         dw $3A92, $3A32, $39D2

    LDA $1125           ; $10BC8C   |
    AND #$00FF          ; $10BC8F   |
    BNE CODE_10BCA8     ; $10BC92   |
    LDA $10E0           ; $10BC94   |
    BEQ CODE_10BC9D     ; $10BC97   |
    DEC $10E0           ; $10BC99   |
    RTS                 ; $10BC9C   |

CODE_10BC9D:
    LDA #$0080          ; $10BC9D   |
    STA $10E0           ; $10BCA0   |
    INC $10DE           ; $10BCA3   |
    BRA CODE_10BCB9     ; $10BCA6   |

CODE_10BCA8:
    DEC A               ; $10BCA8   |
    ASL A               ; $10BCA9   |
    TAY                 ; $10BCAA   |
    LDA $10E0           ; $10BCAB   |
    BNE CODE_10BCBD     ; $10BCAE   |
    LDA #$0020          ; $10BCB0   |
    STA $10E0           ; $10BCB3   |
    JSR CODE_10BCDD     ; $10BCB6   |

CODE_10BCB9:
    INC $10DE           ; $10BCB9   |
    RTS                 ; $10BCBC   |

CODE_10BCBD:
    DEC $10E0           ; $10BCBD   |
    LDA $A3             ; $10BCC0   |
    BEQ CODE_10BCC8     ; $10BCC2   |
    DEC $A3             ; $10BCC4   |
    BRA CODE_10BCD8     ; $10BCC6   |

CODE_10BCC8:
    LDA $A5             ; $10BCC8   |
    EOR #$0002          ; $10BCCA   |
    STA $A5             ; $10BCCD   |
    TAX                 ; $10BCCF   |
    JSR ($BCD9,x)       ; $10BCD0   |

    LDA #$0005          ; $10BCD3   |
    STA $A3             ; $10BCD6   |

CODE_10BCD8:
    RTS                 ; $10BCD8   |

DATA_10BCD9:         dw $BD06
DATA_10BCDB:         dw $BCDD

CODE_10BCDD:
    LDA #$0010          ; $10BCDD   |
    STA $01             ; $10BCE0   |
    LDX $BC80,y         ; $10BCE2   |
    LDA $BC86,y         ; $10BCE5   |
    TAY                 ; $10BCE8   |
    LDA #$000E          ; $10BCE9   |
    PHX                 ; $10BCEC   |
    PHY                 ; $10BCED   |
    JSL $00BEA6         ; $10BCEE   |
    PLA                 ; $10BCF2   |
    CLC                 ; $10BCF3   |
    ADC #$0020          ; $10BCF4   |
    TAY                 ; $10BCF7   |
    PLA                 ; $10BCF8   |
    CLC                 ; $10BCF9   |
    ADC #$000E          ; $10BCFA   |
    TAX                 ; $10BCFD   |
    LDA #$000E          ; $10BCFE   |
    JSL $00BEA6         ; $10BD01   |
    RTS                 ; $10BD05   |

    LDA #$0010          ; $10BD06   |
    STA $01             ; $10BD09   |
    LDX #$1E            ; $10BD0B   |
    LDY $86B9,x         ; $10BD0D   |
    LDY $A9A8,x         ; $10BD10   |
    ASL $DA00           ; $10BD13   |
    PHY                 ; $10BD16   |
    JSL $00BEA6         ; $10BD17   |
    PLA                 ; $10BD1B   |
    CLC                 ; $10BD1C   |
    ADC #$0020          ; $10BD1D   |
    TAY                 ; $10BD20   |
    PLX                 ; $10BD21   |
    LDA #$000E          ; $10BD22   |
    JSL $00BEA6         ; $10BD25   |
    RTS                 ; $10BD29   |

CODE_10BD2A:
    PHP                 ; $10BD2A   |
    SEP #$30            ; $10BD2B   |

CODE_10BD2D:
    JSL $008408         ; $10BD2D   |
    LDA $7970           ; $10BD31   |
    STA $4202           ; $10BD34   |
    TYA                 ; $10BD37   |
    INC A               ; $10BD38   |
    STA $4203           ; $10BD39   |
    NOP                 ; $10BD3C   |
    NOP                 ; $10BD3D   |
    NOP                 ; $10BD3E   |
    NOP                 ; $10BD3F   |
    LDX $4217           ; $10BD40   |
    LDA $00,x           ; $10BD43   |
    STA ($2D),y         ; $10BD45   |
    STY $2F             ; $10BD47   |

CODE_10BD49:
    CPX $2F             ; $10BD49   |
    BEQ CODE_10BD54     ; $10BD4B   |
    LDA $01,x           ; $10BD4D   |
    STA $00,x           ; $10BD4F   |
    INX                 ; $10BD51   |
    BRA CODE_10BD49     ; $10BD52   |

CODE_10BD54:
    DEY                 ; $10BD54   |
    BNE CODE_10BD2D     ; $10BD55   |
    LDA $00             ; $10BD57   |
    STA ($2D),y         ; $10BD59   |
    PLP                 ; $10BD5B   |
    RTS                 ; $10BD5C   |

    LDA $10DE           ; $10BD5D   |
    ASL A               ; $10BD60   |
    TAX                 ; $10BD61   |
    JMP ($BD65,x)       ; $10BD62   |

DATA_10BD65:         dw $A41C
DATA_10BD67:         dw $A427
DATA_10BD69:         dw $A444
DATA_10BD6B:         dw $A466
DATA_10BD6D:         dw $A481
DATA_10BD6F:         dw $A4EC
DATA_10BD71:         dw $A549
DATA_10BD73:         dw $A5B3
DATA_10BD75:         dw $BDB1
DATA_10BD77:         dw $BDE8
DATA_10BD79:         dw $C397
DATA_10BD7B:         dw $C219
DATA_10BD7D:         dw $A621

CODE_10BD7F:
    LDA #$0000          ; $10BD7F   |
    STA $1138           ; $10BD82   |
    STA $113A           ; $10BD85   |
    STA $113C           ; $10BD88   |
    STZ $1148           ; $10BD8B   |
    SEP #$20            ; $10BD8E   |
    STZ $1141           ; $10BD90   |
    STZ $1142           ; $10BD93   |
    STZ $1143           ; $10BD96   |
    STZ $1144           ; $10BD99   |
    STZ $1145           ; $10BD9C   |
    STZ $1146           ; $10BD9F   |
    STZ $1147           ; $10BDA2   |
    STZ $114A           ; $10BDA5   |
    STZ $114B           ; $10BDA8   |
    STZ $114C           ; $10BDAB   |
    REP #$20            ; $10BDAE   |
    RTS                 ; $10BDB0   |

    LDA $1138           ; $10BDB1   |
    BNE CODE_10BDC4     ; $10BDB4   |
    LDX #$0008          ; $10BDB6   |
    STX $10F0           ; $10BDB9   |
    LDA $A2DD,x         ; $10BDBC   |
    JSR CODE_10A39A     ; $10BDBF   |
    BRA CODE_10BDCE     ; $10BDC2   |

CODE_10BDC4:
    CMP #$0380          ; $10BDC4   |
    BNE CODE_10BDCE     ; $10BDC7   |
    INC $10DE           ; $10BDC9   |
    BRA CODE_10BDDB     ; $10BDCC   |

CODE_10BDCE:
    CLC                 ; $10BDCE   |
    ADC #$0010          ; $10BDCF   |
    STA $1138           ; $10BDD2   |
    STA $113A           ; $10BDD5   |
    STA $113C           ; $10BDD8   |

CODE_10BDDB:
    JSR CODE_10BF12     ; $10BDDB   |
    JSR CODE_10BF2E     ; $10BDDE   |
    JSR CODE_10C31D     ; $10BDE1   |
    JSR CODE_10C017     ; $10BDE4   |
    RTS                 ; $10BDE7   |

    LDA $1138           ; $10BDE8   |
    ORA $113A           ; $10BDEB   |
    ORA $113C           ; $10BDEE   |
    BNE CODE_10BE16     ; $10BDF1   |
    JSR CODE_10C1B7     ; $10BDF3   |
    LDA #$0080          ; $10BDF6   |
    STA $10E0           ; $10BDF9   |
    INC $10DE           ; $10BDFC   |
    LDA $1148           ; $10BDFF   |
    BEQ CODE_10BE11     ; $10BE02   |
    LDA #$0090          ; $10BE04   |
    STA $118A           ; $10BE07   |
    LDA #$0005          ; $10BE0A   |
    STA $4D             ; $10BE0D   |
    BRA CODE_10BE28     ; $10BE0F   |

CODE_10BE11:
    INC $10DE           ; $10BE11   |
    BRA CODE_10BE28     ; $10BE14   |

CODE_10BE16:
    JSR CODE_10BE2C     ; $10BE16   |
    JSR CODE_10BEF2     ; $10BE19   |
    JSR CODE_10BF12     ; $10BE1C   |
    JSR CODE_10BF2E     ; $10BE1F   |
    JSR CODE_10C31D     ; $10BE22   |
    JSR CODE_10C16C     ; $10BE25   |

CODE_10BE28:
    JSR CODE_10C017     ; $10BE28   |
    RTS                 ; $10BE2B   |

CODE_10BE2C:
    SEP #$30            ; $10BE2C   |
    LDA $114A           ; $10BE2E   |
    BEQ CODE_10BE3D     ; $10BE31   |
    LDA $114B           ; $10BE33   |
    BEQ CODE_10BE3D     ; $10BE36   |
    LDA $114C           ; $10BE38   |
    BNE CODE_10BEBA     ; $10BE3B   |

CODE_10BE3D:
    LDA $1141           ; $10BE3D   |
    STA $00             ; $10BE40   |
    LDA $093F           ; $10BE42   |
    AND #$03            ; $10BE45   |
    BEQ CODE_10BE7A     ; $10BE47   |
    AND #$02            ; $10BE49   |
    BEQ CODE_10BE5C     ; $10BE4B   |
    LDX $1141           ; $10BE4D   |

CODE_10BE50:
    DEX                 ; $10BE50   |
    BPL CODE_10BE55     ; $10BE51   |
    LDX #$02            ; $10BE53   |

CODE_10BE55:
    LDA $114A,x         ; $10BE55   |
    BNE CODE_10BE50     ; $10BE58   |
    BRA CODE_10BE6B     ; $10BE5A   |

CODE_10BE5C:
    LDX $1141           ; $10BE5C   |

CODE_10BE5F:
    INX                 ; $10BE5F   |
    CPX #$03            ; $10BE60   |
    BNE CODE_10BE66     ; $10BE62   |
    LDX #$00            ; $10BE64   |

CODE_10BE66:
    LDA $114A,x         ; $10BE66   |
    BNE CODE_10BE5F     ; $10BE69   |

CODE_10BE6B:
    STX $1141           ; $10BE6B   |
    CPX $00             ; $10BE6E   |
    BEQ CODE_10BEBA     ; $10BE70   |
    LDA #$5C            ; $10BE72   |\ play sound #$005C
    JSL $0085D2         ; $10BE74   |/
    BRA CODE_10BEBA     ; $10BE78   |

CODE_10BE7A:
    LDA $093F           ; $10BE7A   |
    AND #$C0            ; $10BE7D   |
    BNE CODE_10BE88     ; $10BE7F   |
    LDA $093E           ; $10BE81   |
    AND #$80            ; $10BE84   |
    BEQ CODE_10BEBA     ; $10BE86   |

CODE_10BE88:
    LDX $1141           ; $10BE88   |
    LDA $114A,x         ; $10BE8B   |
    BNE CODE_10BEBA     ; $10BE8E   |
    INC $114A,x         ; $10BE90   |
    JSR CODE_10BECF     ; $10BE93   |
    LDA #$33            ; $10BE96   |\ play sound #$0033
    JSL $0085D2         ; $10BE98   |/
    REP #$30            ; $10BE9C   |
    JSR CODE_10C33D     ; $10BE9E   |
    SEP #$30            ; $10BEA1   |
    LDX $1141           ; $10BEA3   |

CODE_10BEA6:
    INX                 ; $10BEA6   |
    CPX #$03            ; $10BEA7   |
    BNE CODE_10BEAD     ; $10BEA9   |
    LDX #$00            ; $10BEAB   |

CODE_10BEAD:
    CPX $1141           ; $10BEAD   |
    BEQ CODE_10BEBA     ; $10BEB0   |
    LDA $114A,x         ; $10BEB2   |
    BNE CODE_10BEA6     ; $10BEB5   |
    STX $1141           ; $10BEB7   |

CODE_10BEBA:
    REP #$30            ; $10BEBA   |
    RTS                 ; $10BEBC   |

ATA_10BEBD:         db $02, $04, $06, $08, $0A, $0C

DATA_10BEC3:         dw $0310, $02A0, $0230, $01C0
DATA_10BECB:         dw $0150, $00E0

CODE_10BECF:
    SEP #$30            ; $10BECF   |
    INC $1142,x         ; $10BED1   |

    LDY $1142,x         ; $10BED4   |
    DEY                 ; $10BED7   |
    LDA $BEBD,y         ; $10BED8   |
    STA $1145,x         ; $10BEDB   |
    REP #$20            ; $10BEDE   |
    TXA                 ; $10BEE0   |
    ASL A               ; $10BEE1   |
    TAY                 ; $10BEE2   |
    LDA $1142,x         ; $10BEE3   |
    DEC A               ; $10BEE6   |
    ASL A               ; $10BEE7   |
    TAX                 ; $10BEE8   |
    LDA $BEC3,x         ; $10BEE9   |
    STA $1138,y         ; $10BEEC   |
    SEP #$20            ; $10BEEF   |
    RTS                 ; $10BEF1   |

CODE_10BEF2:
    SEP #$30            ; $10BEF2   |
    LDX #$02            ; $10BEF4   |

CODE_10BEF6:
    LDA $1142,x         ; $10BEF6   |
    BEQ CODE_10BF0C     ; $10BEF9   |
    DEC $1145,x         ; $10BEFB   |
    BPL CODE_10BF0C     ; $10BEFE   |
    LDA $1142,x         ; $10BF00   |
    CMP #$06            ; $10BF03   |
    BEQ CODE_10BF0C     ; $10BF05   |
    PHX                 ; $10BF07   |
    JSR CODE_10BECF     ; $10BF08   |
    PLX                 ; $10BF0B   |

CODE_10BF0C:
    DEX                 ; $10BF0C   |
    BPL CODE_10BEF6     ; $10BF0D   |
    REP #$30            ; $10BF0F   |
    RTS                 ; $10BF11   |

CODE_10BF12:
    LDX #$0004          ; $10BF12   |

CODE_10BF15:
    LDA $1132,x         ; $10BF15   |
    CLC                 ; $10BF18   |
    ADC $1138,x         ; $10BF19   |
    STA $1132,x         ; $10BF1C   |
    LDA $114E,x         ; $10BF1F   |
    CLC                 ; $10BF22   |
    ADC $1138,x         ; $10BF23   |
    STA $114E,x         ; $10BF26   |
    DEX                 ; $10BF29   |
    DEX                 ; $10BF2A   |
    BPL CODE_10BF15     ; $10BF2B   |
    RTS                 ; $10BF2D   |

CODE_10BF2E:
    SEP #$30            ; $10BF2E   |
    LDX #$02            ; $10BF30   |

CODE_10BF32:
    TXA                 ; $10BF32   |
    ASL A               ; $10BF33   |
    TAY                 ; $10BF34   |
    LDA $1133,y         ; $10BF35   |
    CMP #$58            ; $10BF38   |
    BNE CODE_10BF60     ; $10BF3A   |
    LDA $1142,x         ; $10BF3C   |
    CMP #$06            ; $10BF3F   |
    BCC CODE_10BF60     ; $10BF41   |
    LDA $1145,x         ; $10BF43   |
    BPL CODE_10BF60     ; $10BF46   |
    REP #$20            ; $10BF48   |
    LDA #$0000          ; $10BF4A   |
    STA $1138,y         ; $10BF4D   |
    LDA #$5800          ; $10BF50   |
    STA $1132,y         ; $10BF53   |
    LDA #$5000          ; $10BF56   |
    STA $114E,y         ; $10BF59   |
    SEP #$20            ; $10BF5C   |
    BRA CODE_10BF7C     ; $10BF5E   |

CODE_10BF60:
    LDA $1133,y         ; $10BF60   |
    CMP #$68            ; $10BF63   |
    BCC CODE_10BF7C     ; $10BF65   |
    LDA #$06            ; $10BF67   |\ play sound #$0006
    JSL $0085D2         ; $10BF69   |/
    JSR CODE_10BF82     ; $10BF6D   |
    TXA                 ; $10BF70   |
    ASL A               ; $10BF71   |
    TAY                 ; $10BF72   |
    LDA $1133,y         ; $10BF73   |
    SEC                 ; $10BF76   |
    SBC #$20            ; $10BF77   |
    STA $1133,y         ; $10BF79   |

CODE_10BF7C:
    DEX                 ; $10BF7C   |
    BPL CODE_10BF32     ; $10BF7D   |
    REP #$30            ; $10BF7F   |
    RTS                 ; $10BF81   |

CODE_10BF82:
    SEP #$30            ; $10BF82   |
    LDA $113E,x         ; $10BF84   |
    CLC                 ; $10BF87   |
    ADC #$01            ; $10BF88   |
    AND #$07            ; $10BF8A   |
    STA $113E,x         ; $10BF8C   |
    TXA                 ; $10BF8F   |
    ASL A               ; $10BF90   |
    ASL A               ; $10BF91   |
    TAY                 ; $10BF92   |
    LDA $1128,y         ; $10BF93   |
    STA $1129,y         ; $10BF96   |
    LDA $1127,y         ; $10BF99   |
    STA $1128,y         ; $10BF9C   |
    LDA $1126,y         ; $10BF9F   |
    STA $1127,y         ; $10BFA2   |
    PHY                 ; $10BFA5   |
    TXA                 ; $10BFA6   |
    ASL A               ; $10BFA7   |
    ASL A               ; $10BFA8   |
    ASL A               ; $10BFA9   |
    CLC                 ; $10BFAA   |
    ADC $113E,x         ; $10BFAB   |
    TAY                 ; $10BFAE   |
    LDA $BFB7,y         ; $10BFAF   |
    PLY                 ; $10BFB2   |
    STA $1126,y         ; $10BFB3   |
    RTS                 ; $10BFB6   |

DATA_10BFB7:         db $00, $01, $02, $03, $04, $05, $00, $01
DATA_10BFBF:         db $01, $00, $03, $04, $05, $00, $01, $02
DATA_10BFC7:         db $02, $03, $04, $05, $00, $01, $02, $03

DATA_10BFCF:         dw $0030, $0038, $0040, $0030
DATA_10BFD7:         dw $0050, $0058, $0060, $0050
DATA_10BFDF:         dw $0070, $0078, $0080, $0070
DATA_10BFE7:         dw $2100, $2111, $2102, $2120
DATA_10BFEF:         dw $2103, $2114, $2105, $2123
DATA_10BFF7:         dw $2106, $2117, $2108, $2126
DATA_10BFFF:         dw $2133, $2144, $2135, $2153
DATA_10C007:         dw $2136, $2147, $2138, $2156
DATA_10C00F:         dw $2130, $2141, $2132, $2150

CODE_10C017:
    LDY $6092           ; $10C017   |
    LDA #$0000          ; $10C01A   |
    STA $00             ; $10C01D   |

CODE_10C01F:
    LDA $00             ; $10C01F   |
    ASL A               ; $10C021   |
    ASL A               ; $10C022   |
    ASL A               ; $10C023   |
    TAX                 ; $10C024   |
    LDA $BFCF,x         ; $10C025   |
    STA $6000,y         ; $10C028   |
    STA $6020,y         ; $10C02B   |
    STA $6040,y         ; $10C02E   |
    LDA $BFD1,x         ; $10C031   |
    STA $6008,y         ; $10C034   |
    STA $6028,y         ; $10C037   |
    STA $6048,y         ; $10C03A   |
    LDA $BFD3,x         ; $10C03D   |
    STA $6010,y         ; $10C040   |
    STA $6030,y         ; $10C043   |
    STA $6050,y         ; $10C046   |
    LDA $BFD5,x         ; $10C049   |
    STA $6018,y         ; $10C04C   |
    STA $6038,y         ; $10C04F   |
    STA $6058,y         ; $10C052   |
    LDA $00             ; $10C055   |
    ASL A               ; $10C057   |
    TAX                 ; $10C058   |
    LDA $1132,x         ; $10C059   |
    XBA                 ; $10C05C   |
    DEC A               ; $10C05D   |
    AND #$00FF          ; $10C05E   |
    SEC                 ; $10C061   |
    SBC $3B             ; $10C062   |
    SEC                 ; $10C064   |
    SBC #$0008          ; $10C065   |
    STA $6002,y         ; $10C068   |
    STA $6012,y         ; $10C06B   |
    CLC                 ; $10C06E   |
    ADC #$0008          ; $10C06F   |
    STA $600A,y         ; $10C072   |
    CLC                 ; $10C075   |
    ADC #$0008          ; $10C076   |
    STA $601A,y         ; $10C079   |
    CLC                 ; $10C07C   |
    ADC #$0010          ; $10C07D   |
    STA $6022,y         ; $10C080   |
    STA $6032,y         ; $10C083   |
    CLC                 ; $10C086   |
    ADC #$0008          ; $10C087   |
    STA $602A,y         ; $10C08A   |
    CLC                 ; $10C08D   |
    ADC #$0008          ; $10C08E   |
    STA $603A,y         ; $10C091   |
    CLC                 ; $10C094   |
    ADC #$0010          ; $10C095   |
    STA $6042,y         ; $10C098   |
    STA $6052,y         ; $10C09B   |
    CLC                 ; $10C09E   |
    ADC #$0008          ; $10C09F   |
    STA $604A,y         ; $10C0A2   |
    CLC                 ; $10C0A5   |
    ADC #$0008          ; $10C0A6   |
    STA $605A,y         ; $10C0A9   |
    LDA $00             ; $10C0AC   |
    ASL A               ; $10C0AE   |
    ASL A               ; $10C0AF   |
    STA $02             ; $10C0B0   |
    TAX                 ; $10C0B2   |
    LDA $1126,x         ; $10C0B3   |
    AND #$00FF          ; $10C0B6   |
    ASL A               ; $10C0B9   |
    ASL A               ; $10C0BA   |
    ASL A               ; $10C0BB   |
    TAX                 ; $10C0BC   |
    LDA $BFE7,x         ; $10C0BD   |
    STA $6004,y         ; $10C0C0   |
    LDA $BFE9,x         ; $10C0C3   |
    STA $600C,y         ; $10C0C6   |
    LDA $BFEB,x         ; $10C0C9   |
    STA $6014,y         ; $10C0CC   |
    LDA $BFED,x         ; $10C0CF   |
    STA $601C,y         ; $10C0D2   |
    LDX $02             ; $10C0D5   |
    LDA $1127,x         ; $10C0D7   |
    AND #$00FF          ; $10C0DA   |
    ASL A               ; $10C0DD   |
    ASL A               ; $10C0DE   |
    ASL A               ; $10C0DF   |
    TAX                 ; $10C0E0   |
    LDA $BFE7,x         ; $10C0E1   |
    STA $6024,y         ; $10C0E4   |
    LDA $BFE9,x         ; $10C0E7   |
    STA $602C,y         ; $10C0EA   |
    LDA $BFEB,x         ; $10C0ED   |
    STA $6034,y         ; $10C0F0   |
    LDA $BFED,x         ; $10C0F3   |
    STA $603C,y         ; $10C0F6   |
    LDX $02             ; $10C0F9   |
    LDA $1128,x         ; $10C0FB   |
    AND #$00FF          ; $10C0FE   |
    ASL A               ; $10C101   |
    ASL A               ; $10C102   |
    ASL A               ; $10C103   |
    TAX                 ; $10C104   |
    LDA $BFE7,x         ; $10C105   |
    STA $6044,y         ; $10C108   |
    LDA $BFE9,x         ; $10C10B   |
    STA $604C,y         ; $10C10E   |
    LDA $BFEB,x         ; $10C111   |
    STA $6054,y         ; $10C114   |
    LDA $BFED,x         ; $10C117   |
    STA $605C,y         ; $10C11A   |
    LDA #$0002          ; $10C11D   |
    STA $6006,y         ; $10C120   |
    STA $600E,y         ; $10C123   |
    STA $6026,y         ; $10C126   |
    STA $602E,y         ; $10C129   |
    STA $6046,y         ; $10C12C   |
    STA $604E,y         ; $10C12F   |
    LDA #$0000          ; $10C132   |
    STA $6016,y         ; $10C135   |
    STA $601E,y         ; $10C138   |
    STA $6036,y         ; $10C13B   |
    STA $603E,y         ; $10C13E   |
    STA $6056,y         ; $10C141   |
    STA $605E,y         ; $10C144   |
    INC $00             ; $10C147   |
    LDA $00             ; $10C149   |
    CMP #$0003          ; $10C14B   |
    BEQ CODE_10C159     ; $10C14E   |
    TYA                 ; $10C150   |
    CLC                 ; $10C151   |
    ADC #$0060          ; $10C152   |
    TAY                 ; $10C155   |
    JMP CODE_10C01F     ; $10C156   |

CODE_10C159:
    LDA $6092           ; $10C159   |
    CLC                 ; $10C15C   |
    ADC #$0120          ; $10C15D   |
    STA $6092           ; $10C160   |
    JMP CODE_10C25C     ; $10C163   |

DATA_10C166:         dw $0034, $0054, $0074

CODE_10C16C:
    LDA $114D           ; $10C16C   |
    BEQ CODE_10C1B6     ; $10C16F   |
    LDY $6092           ; $10C171   |
    LDA $1141           ; $10C174   |
    AND #$00FF          ; $10C177   |
    ASL A               ; $10C17A   |
    TAX                 ; $10C17B   |
    LDA $C166,x         ; $10C17C   |
    STA $6000,y         ; $10C17F   |
    LDA #$00B0          ; $10C182   |
    SEC                 ; $10C185   |
    SBC $3B             ; $10C186   |
    STA $6002,y         ; $10C188   |
    LDA $093D           ; $10C18B   |
    AND #$00C0          ; $10C18E   |
    BNE CODE_10C19B     ; $10C191   |
    LDA $093C           ; $10C193   |
    AND #$0080          ; $10C196   |
    BEQ CODE_10C1A0     ; $10C199   |

CODE_10C19B:
    LDA #$3162          ; $10C19B   |
    BRA CODE_10C1A3     ; $10C19E   |

CODE_10C1A0:
    LDA #$3160          ; $10C1A0   |

CODE_10C1A3:
    STA $6004,y         ; $10C1A3   |
    LDA #$0002          ; $10C1A6   |
    STA $6006,y         ; $10C1A9   |
    LDA $6092           ; $10C1AC   |
    CLC                 ; $10C1AF   |
    ADC #$0008          ; $10C1B0   |
    STA $6092           ; $10C1B3   |

CODE_10C1B6:
    RTS                 ; $10C1B6   |

CODE_10C1B7:
    SEP #$30            ; $10C1B7   |
    LDA $1127           ; $10C1B9   |
    CMP #$02            ; $10C1BC   |
    BNE CODE_10C1D0     ; $10C1BE   |
    LDA $112B           ; $10C1C0   |
    CMP #$03            ; $10C1C3   |
    BNE CODE_10C1D0     ; $10C1C5   |
    LDA $112F           ; $10C1C7   |
    CMP #$04            ; $10C1CA   |
    BNE CODE_10C204     ; $10C1CC   |
    BRA CODE_10C1F5     ; $10C1CE   |

CODE_10C1D0:
    LDA $1127           ; $10C1D0   |
    CMP $112B           ; $10C1D3   |
    BNE CODE_10C204     ; $10C1D6   |
    CMP $112F           ; $10C1D8   |
    BNE CODE_10C204     ; $10C1DB   |
    CMP #$00            ; $10C1DD   |
    BNE CODE_10C1E5     ; $10C1DF   |
    LDA #$02            ; $10C1E1   |
    BRA CODE_10C1F7     ; $10C1E3   |

CODE_10C1E5:
    CMP #$01            ; $10C1E5   |
    BNE CODE_10C1ED     ; $10C1E7   |
    LDA #$03            ; $10C1E9   |
    BRA CODE_10C1F7     ; $10C1EB   |

CODE_10C1ED:
    CMP #$05            ; $10C1ED   |
    BNE CODE_10C1F5     ; $10C1EF   |
    LDA #$05            ; $10C1F1   |
    BRA CODE_10C1F7     ; $10C1F3   |

CODE_10C1F5:
    LDA #$01            ; $10C1F5   |

CODE_10C1F7:
    STA $1148           ; $10C1F7   |
    REP #$30            ; $10C1FA   |
    LDX #$0004          ; $10C1FC   |
    STX $10F0           ; $10C1FF   |
    BRA CODE_10C212     ; $10C202   |

CODE_10C204:
    LDA #$7D            ; $10C204   |\ play sound #$007D
    JSL $0085D2         ; $10C206   |/
    REP #$30            ; $10C20A   |
    LDX #$0006          ; $10C20C   |
    STX $10F0           ; $10C20F   |

CODE_10C212:
    LDA $A2DD,x         ; $10C212   |
    JSR CODE_10A39A     ; $10C215   |
    RTS                 ; $10C218   |

    DEC $10E0           ; $10C219   |
    BNE CODE_10C252     ; $10C21C   |
    LDA $1148           ; $10C21E   |
    AND #$00FF          ; $10C221   |
    BNE CODE_10C231     ; $10C224   |

CODE_10C226:
    LDA #$0080          ; $10C226   |
    STA $10E0           ; $10C229   |
    INC $10DE           ; $10C22C   |
    BRA CODE_10C252     ; $10C22F   |

CODE_10C231:
    LDA $0379           ; $10C231   |
    CMP #$03E7          ; $10C234   |
    BEQ CODE_10C226     ; $10C237   |
    DEC $1148           ; $10C239   |
    INC $0379           ; $10C23C   |
    JSR CODE_109D74     ; $10C23F   |
    SEP #$20            ; $10C242   |
    LDA #$08            ; $10C244   |\ play sound #$0008
    JSL $0085D2         ; $10C246   |/
    REP #$20            ; $10C24A   |
    LDA #$0030          ; $10C24C   |
    STA $10E0           ; $10C24F   |

CODE_10C252:
    JSR CODE_10C017     ; $10C252   |
    RTS                 ; $10C255   |

DATA_10C256:         dw $0030, $0050, $0070

CODE_10C25C:
    LDY $6092           ; $10C25C   |
    LDA #$0000          ; $10C25F   |
    STA $00             ; $10C262   |

CODE_10C264:
    LDA $00             ; $10C264   |
    ASL A               ; $10C266   |
    TAX                 ; $10C267   |
    LDA $C256,x         ; $10C268   |
    STA $6000,y         ; $10C26B   |
    STA $6018,y         ; $10C26E   |
    STA $6030,y         ; $10C271   |
    CLC                 ; $10C274   |
    ADC #$0008          ; $10C275   |
    STA $6008,y         ; $10C278   |
    STA $6020,y         ; $10C27B   |
    STA $6038,y         ; $10C27E   |
    CLC                 ; $10C281   |
    ADC #$0008          ; $10C282   |
    STA $6010,y         ; $10C285   |
    STA $6028,y         ; $10C288   |
    STA $6040,y         ; $10C28B   |
    LDA $00             ; $10C28E   |
    ASL A               ; $10C290   |
    TAX                 ; $10C291   |
    LDA $114E,x         ; $10C292   |
    XBA                 ; $10C295   |
    DEC A               ; $10C296   |
    AND #$00FF          ; $10C297   |
    SEC                 ; $10C29A   |
    SBC $3B             ; $10C29B   |
    SEC                 ; $10C29D   |
    SBC #$0008          ; $10C29E   |
    STA $6002,y         ; $10C2A1   |
    STA $600A,y         ; $10C2A4   |
    STA $6012,y         ; $10C2A7   |
    CLC                 ; $10C2AA   |
    ADC #$0020          ; $10C2AB   |
    STA $601A,y         ; $10C2AE   |
    STA $6022,y         ; $10C2B1   |
    STA $602A,y         ; $10C2B4   |
    CLC                 ; $10C2B7   |
    ADC #$0020          ; $10C2B8   |
    STA $6032,y         ; $10C2BB   |
    STA $603A,y         ; $10C2BE   |
    STA $6042,y         ; $10C2C1   |
    LDA #$2D68          ; $10C2C4   |
    STA $6004,y         ; $10C2C7   |
    STA $600C,y         ; $10C2CA   |
    STA $6014,y         ; $10C2CD   |
    STA $601C,y         ; $10C2D0   |
    STA $6024,y         ; $10C2D3   |
    STA $602C,y         ; $10C2D6   |
    STA $6034,y         ; $10C2D9   |
    STA $603C,y         ; $10C2DC   |
    STA $6044,y         ; $10C2DF   |
    LDA #$0000          ; $10C2E2   |
    STA $6006,y         ; $10C2E5   |
    STA $600E,y         ; $10C2E8   |
    STA $6016,y         ; $10C2EB   |
    STA $601E,y         ; $10C2EE   |
    STA $6026,y         ; $10C2F1   |
    STA $602E,y         ; $10C2F4   |
    STA $6036,y         ; $10C2F7   |
    STA $603E,y         ; $10C2FA   |
    STA $6046,y         ; $10C2FD   |
    INC $00             ; $10C300   |
    LDA $00             ; $10C302   |
    CMP #$0003          ; $10C304   |
    BEQ CODE_10C312     ; $10C307   |
    TYA                 ; $10C309   |
    CLC                 ; $10C30A   |
    ADC #$0080          ; $10C30B   |
    TAY                 ; $10C30E   |
    JMP CODE_10C264     ; $10C30F   |

CODE_10C312:
    LDA $6092           ; $10C312   |
    CLC                 ; $10C315   |
    ADC #$0090          ; $10C316   |
    STA $6092           ; $10C319   |
    RTS                 ; $10C31C   |

CODE_10C31D:
    LDX #$0004          ; $10C31D   |

CODE_10C320:
    LDA $114E,x         ; $10C320   |
    CMP #$6800          ; $10C323   |
    BCC CODE_10C332     ; $10C326   |
    LDA $114E,x         ; $10C328   |
    SEC                 ; $10C32B   |
    SBC #$2000          ; $10C32C   |
    STA $114E,x         ; $10C32F   |

CODE_10C332:
    DEX                 ; $10C332   |
    DEX                 ; $10C333   |
    BPL CODE_10C320     ; $10C334   |
    RTS                 ; $10C336   |

DATA_10C337:         dw $6AA6, $6AAA, $6AAE

CODE_10C33D:
    LDA $1141           ; $10C33D   |
    AND #$00FF          ; $10C340   |
    ASL A               ; $10C343   |
    TAY                 ; $10C344   |
    LDA $7E4000         ; $10C345   |
    TAX                 ; $10C349   |
    LDA $C337,y         ; $10C34A   |
    STA $7E4002,x       ; $10C34D   |
    CLC                 ; $10C351   |
    ADC #$0020          ; $10C352   |
    STA $7E400C,x       ; $10C355   |
    LDA #$0005          ; $10C359   |
    STA $7E4004,x       ; $10C35C   |
    STA $7E400E,x       ; $10C360   |
    LDA #$3CF4          ; $10C364   |
    STA $7E4006,x       ; $10C367   |
    INC A               ; $10C36B   |
    STA $7E4008,x       ; $10C36C   |
    INC A               ; $10C370   |
    STA $7E400A,x       ; $10C371   |
    LDA #$3CF7          ; $10C375   |
    STA $7E4010,x       ; $10C378   |
    INC A               ; $10C37C   |
    STA $7E4012,x       ; $10C37D   |
    INC A               ; $10C381   |
    STA $7E4014,x       ; $10C382   |
    LDA #$FFFF          ; $10C386   |
    STA $7E4016,x       ; $10C389   |
    TXA                 ; $10C38D   |
    CLC                 ; $10C38E   |
    ADC #$0014          ; $10C38F   |
    STA $7E4000         ; $10C392   |
    RTS                 ; $10C396   |

    JSR CODE_10C017     ; $10C397   |
    DEC $118A           ; $10C39A   |
    BPL CODE_10C3A9     ; $10C39D   |
    LDA #$0001          ; $10C39F   |
    STA $10E0           ; $10C3A2   |
    INC $10DE           ; $10C3A5   |
    RTS                 ; $10C3A8   |

CODE_10C3A9:
    LDA $1148           ; $10C3A9   |
    AND #$00FF          ; $10C3AC   |
    DEC A               ; $10C3AF   |
    ASL A               ; $10C3B0   |
    TAX                 ; $10C3B1   |
    JMP ($C3B5,x)       ; $10C3B2   |

DATA_10C3B5:         dw $C421
DATA_10C3B7:         dw $C3C9
DATA_10C3B9:         dw $C3C9
DATA_10C3BB:         dw $C396
DATA_10C3BD:         dw $C3C9

DATA_10C3BF:         dw $69F3, $69B3, $6973

DATA_10C3C5:         dw $0000, $2CFC

    LDA $1148           ; $10C3C9   |
    AND #$00FF          ; $10C3CC   |
    SEC                 ; $10C3CF   |
    SBC #$0002          ; $10C3D0   |
    CMP #$0003          ; $10C3D3   |
    BNE CODE_10C3D9     ; $10C3D6   |
    DEC A               ; $10C3D8   |

CODE_10C3D9:
    ASL A               ; $10C3D9   |
    TAY                 ; $10C3DA   |
    LDA $7E4000         ; $10C3DB   |
    TAX                 ; $10C3DF   |
    LDA $C3BF,y         ; $10C3E0   |
    STA $7E4002,x       ; $10C3E3   |
    CLC                 ; $10C3E7   |
    ADC #$0020          ; $10C3E8   |
    STA $7E4008,x       ; $10C3EB   |
    LDA #$000E          ; $10C3EF   |
    ORA #$4000          ; $10C3F2   |
    STA $7E4004,x       ; $10C3F5   |
    STA $7E400A,x       ; $10C3F9   |
    LDA $118A           ; $10C3FD   |
    AND #$0004          ; $10C400   |
    LSR A               ; $10C403   |
    TAY                 ; $10C404   |
    LDA $C3C5,y         ; $10C405   |
    STA $7E4006,x       ; $10C408   |
    STA $7E400C,x       ; $10C40C   |
    LDA #$FFFF          ; $10C410   |
    STA $7E400E,x       ; $10C413   |
    TXA                 ; $10C417   |
    CLC                 ; $10C418   |
    ADC #$000C          ; $10C419   |
    STA $7E4000         ; $10C41C   |
    RTS                 ; $10C420   |

    LDA $7E4000         ; $10C421   |
    TAX                 ; $10C425   |
    LDA #$6A33          ; $10C426   |
    STA $7E4002,x       ; $10C429   |
    CLC                 ; $10C42D   |
    ADC #$0020          ; $10C42E   |
    STA $7E4008,x       ; $10C431   |
    CLC                 ; $10C435   |
    ADC #$0020          ; $10C436   |
    STA $7E400E,x       ; $10C439   |
    CLC                 ; $10C43D   |
    ADC #$0020          ; $10C43E   |
    STA $7E4014,x       ; $10C441   |
    CLC                 ; $10C445   |
    ADC #$0020          ; $10C446   |
    STA $7E401A,x       ; $10C449   |
    LDA #$000E          ; $10C44D   |
    ORA #$4000          ; $10C450   |
    STA $7E4004,x       ; $10C453   |
    STA $7E400A,x       ; $10C457   |
    STA $7E4010,x       ; $10C45B   |
    STA $7E4016,x       ; $10C45F   |
    STA $7E401C,x       ; $10C463   |
    LDA $118A           ; $10C467   |
    AND #$0004          ; $10C46A   |
    LSR A               ; $10C46D   |
    TAY                 ; $10C46E   |
    LDA $C3C5,y         ; $10C46F   |
    STA $7E4006,x       ; $10C472   |
    STA $7E400C,x       ; $10C476   |
    STA $7E4012,x       ; $10C47A   |
    STA $7E4018,x       ; $10C47E   |
    STA $7E401E,x       ; $10C482   |
    LDA #$FFFF          ; $10C486   |
    STA $7E4020,x       ; $10C489   |
    TXA                 ; $10C48D   |
    CLC                 ; $10C48E   |
    ADC #$001E          ; $10C48F   |
    STA $7E4000         ; $10C492   |
    RTS                 ; $10C496   |

    LDA $10DE           ; $10C497   |
    ASL A               ; $10C49A   |
    TAX                 ; $10C49B   |
    JMP ($C49F,x)       ; $10C49C   |

DATA_10C49F:         dw $A41C
DATA_10C4A1:         dw $A427
DATA_10C4A3:         dw $A444
DATA_10C4A5:         dw $A466
DATA_10C4A7:         dw $A481
DATA_10C4A9:         dw $A4EC
DATA_10C4AB:         dw $A549
DATA_10C4AD:         dw $A5B3
DATA_10C4AF:         dw $C4BF

DATA_10C4B3:         db $21, $A6, $E3, $74, $AF, $1C

DATA_10C4B7:         db $C4, $C5, $C5, $C6

DATA_10C4BB:         db $10, $10, $10, $10

    SEP #$30            ; $10C4BF   |
    JSL $10C4CB         ; $10C4C1   |
    JSR CODE_10CC3A     ; $10C4C5   |
    REP #$30            ; $10C4C8   |
    RTS                 ; $10C4CA   |

    LDX $1165           ; $10C4CB   |
    LDA $10C4B3,x       ; $10C4CE   |
    STA $03             ; $10C4D2   |
    LDA $10C4B7,x       ; $10C4D4   |
    STA $04             ; $10C4D8   |
    LDA $10C4BB,x       ; $10C4DA   |
    STA $05             ; $10C4DE   |
    JML [$0003]         ; $10C4E0   |

    LDA $37             ; $10C4E3   |
    AND #$80            ; $10C4E5   |
    BNE CODE_10C4EF     ; $10C4E7   |
    LDA $38             ; $10C4E9   |
    BIT #$C0            ; $10C4EB   |
    BEQ CODE_10C511     ; $10C4ED   |

CODE_10C4EF:
    SEP #$20            ; $10C4EF   |
    LDA #$01            ; $10C4F1   |
    STA $1165           ; $10C4F3   |
    LDA #$1C            ; $10C4F6   |\ play sound #$001C
    JSL $0085D2         ; $10C4F8   |/
    REP #$30            ; $10C4FC   |
    LDA #$0008          ; $10C4FE   |
    STA $10F0           ; $10C501   |
    TAY                 ; $10C504   |
    LDA $A2DD,y         ; $10C505   |
    JSR CODE_10A39A     ; $10C508   |
    SEP #$30            ; $10C50B   |
    JSR CODE_10C641     ; $10C50D   |
    RTL                 ; $10C510   |

CODE_10C511:
    AND #$0C            ; $10C511   |
    BNE CODE_10C52C     ; $10C513   |
    LDA $36             ; $10C515   |
    AND #$0C            ; $10C517   |
    BNE CODE_10C51F     ; $10C519   |
    STZ $117E           ; $10C51B   |
    RTL                 ; $10C51E   |

CODE_10C51F:
    INC $117E           ; $10C51F   |
    LDX $117E           ; $10C522   |
    CPX #$20            ; $10C525   |
    BNE CODE_10C573     ; $10C527   |
    DEC $117E           ; $10C529   |

CODE_10C52C:
    STA $0F             ; $10C52C   |
    LDA $117E           ; $10C52E   |
    CMP #$1F            ; $10C531   |
    BNE CODE_10C53B     ; $10C533   |
    LDA $30             ; $10C535   |
    AND #$01            ; $10C537   |
    BEQ CODE_10C554     ; $10C539   |

CODE_10C53B:
    LDA $1177           ; $10C53B   |
    BNE CODE_10C54E     ; $10C53E   |
    LDA $1176           ; $10C540   |
    CMP #$01            ; $10C543   |
    BNE CODE_10C54E     ; $10C545   |
    LDA $1178           ; $10C547   |
    CMP #$01            ; $10C54A   |
    BEQ CODE_10C557     ; $10C54C   |

CODE_10C54E:
    LDA #$09            ; $10C54E   |\ play sound #$0009
    JSL $0085D2         ; $10C550   |/

CODE_10C554:
    JSR CODE_10C8CE     ; $10C554   |

CODE_10C557:
    REP #$30            ; $10C557   |
    LDA $1178           ; $10C559   |
    AND #$00FF          ; $10C55C   |
    STA $00             ; $10C55F   |
    LDA $1176           ; $10C561   |
    SEC                 ; $10C564   |
    SBC $00             ; $10C565   |
    INC A               ; $10C567   |
    STA $0379           ; $10C568   |
    JSR CODE_109D74     ; $10C56B   |
    SEP #$30            ; $10C56E   |
    JSR CODE_10CC80     ; $10C570   |

CODE_10C573:
    RTL                 ; $10C573   |

    LDA $1183           ; $10C574   |
    BNE CODE_10C590     ; $10C577   |
    LDA $37             ; $10C579   |
    AND #$80            ; $10C57B   |
    BNE CODE_10C585     ; $10C57D   |
    LDA $38             ; $10C57F   |
    AND #$C0            ; $10C581   |
    BEQ CODE_10C590     ; $10C583   |

CODE_10C585:
    INC $1183           ; $10C585   |
    LDA #$50            ; $10C588   |
    STA $1168           ; $10C58A   |
    STA $1169           ; $10C58D   |

CODE_10C590:
    LDX #$00            ; $10C590   |

CODE_10C592:
    LDA $1174           ; $10C592   |
    DEC A               ; $10C595   |
    STA $00             ; $10C596   |
    CPX $00             ; $10C598   |
    BEQ CODE_10C59F     ; $10C59A   |
    JSR CODE_10C917     ; $10C59C   |

CODE_10C59F:
    INX                 ; $10C59F   |
    CPX #$02            ; $10C5A0   |
    BNE CODE_10C592     ; $10C5A2   |
    REP #$30            ; $10C5A4   |
    JSR CODE_109D74     ; $10C5A6   |
    SEP #$30            ; $10C5A9   |
    JSR CODE_10CC80     ; $10C5AB   |
    RTL                 ; $10C5AE   |

    DEC $1180           ; $10C5AF   |
    BNE CODE_10C61B     ; $10C5B2   |
    JSR CODE_10C624     ; $10C5B4   |
    LDA #$40            ; $10C5B7   |
    STA $1180           ; $10C5B9   |
    INC $117F           ; $10C5BC   |
    LDA $117F           ; $10C5BF   |
    CMP #$01            ; $10C5C2   |
    BNE CODE_10C61B     ; $10C5C4   |
    LDA #$03            ; $10C5C6   |
    STA $1165           ; $10C5C8   |
    REP #$20            ; $10C5CB   |
    LDA #$0040          ; $10C5CD   |
    STA $10E0           ; $10C5D0   |
    LDA $117C           ; $10C5D3   |
    STA $1148           ; $10C5D6   |
    SEP #$20            ; $10C5D9   |
    BEQ CODE_10C5F0     ; $10C5DB   |
    LDA $117D           ; $10C5DD   |
    BNE CODE_10C5EA     ; $10C5E0   |
    LDA $1178           ; $10C5E2   |
    CMP $117C           ; $10C5E5   |
    BCS CODE_10C5F6     ; $10C5E8   |

CODE_10C5EA:
    LDA #$05            ; $10C5EA   |
    STA $4D             ; $10C5EC   |
    BRA CODE_10C5F6     ; $10C5EE   |

CODE_10C5F0:
    LDA #$7D            ; $10C5F0   |\ play sound #$007D
    JSL $0085D2         ; $10C5F2   |/

CODE_10C5F6:
    REP #$30            ; $10C5F6   |
    LDX #$0004          ; $10C5F8   |
    LDA $1178           ; $10C5FB   |
    AND #$00FF          ; $10C5FE   |
    CMP $117C           ; $10C601   |
    BCC CODE_10C610     ; $10C604   |
    PHP                 ; $10C606   |
    LDX #$0000          ; $10C607   |
    PLP                 ; $10C60A   |
    BEQ CODE_10C610     ; $10C60B   |
    LDX #$0006          ; $10C60D   |

CODE_10C610:
    STX $10F0           ; $10C610   |
    LDA $A2DD,x         ; $10C613   |
    JSR CODE_10A39A     ; $10C616   |
    SEP #$30            ; $10C619   |

CODE_10C61B:
    RTL                 ; $10C61B   |

    REP #$30            ; $10C61C   |
    JSR CODE_10B9F8     ; $10C61E   |
    SEP #$30            ; $10C621   |
    RTL                 ; $10C623   |

CODE_10C624:
    LDA $117F           ; $10C624   |
    JSL $008365         ; $10C627   |

DATA_10C62B:         dw $C7B2
DATA_10C62D:         dw $C6C5

DATA_10C62F:         db $F5, $39, $03, $00, $FC, $2C, $FC, $2C
DATA_10C637:         db $15, $3A, $03, $00, $FC, $2C, $FC, $2C
DATA_10C63F:         db $FF, $FF

CODE_10C641:
    LDA $1178           ; $10C641   |
    STA $0E             ; $10C644   |
    STZ $0F             ; $10C646   |
    JSR CODE_10CD09     ; $10C648   |
    STZ $03             ; $10C64B   |
    STZ $05             ; $10C64D   |
    LDA $1179           ; $10C64F   |
    ASL A               ; $10C652   |
    STA $04             ; $10C653   |
    LDA $117A           ; $10C655   |
    ASL A               ; $10C658   |
    STA $02             ; $10C659   |
    REP #$30            ; $10C65B   |
    LDA $7E4000         ; $10C65D   |
    CLC                 ; $10C661   |
    ADC #$0011          ; $10C662   |
    TAX                 ; $10C665   |
    DEC A               ; $10C666   |
    STA $7E4000         ; $10C667   |
    LDY #$0011          ; $10C66B   |
    SEP #$20            ; $10C66E   |

CODE_10C670:
    LDA $C62F,y         ; $10C670   |
    STA $7E4002,x       ; $10C673   |
    DEX                 ; $10C677   |
    DEY                 ; $10C678   |
    BPL CODE_10C670     ; $10C679   |
    REP #$20            ; $10C67B   |
    LDA $7E4000         ; $10C67D   |
    SEC                 ; $10C681   |
    SBC #$000C          ; $10C682   |
    TAX                 ; $10C685   |
    LDY $02             ; $10C686   |
    BEQ CODE_10C694     ; $10C688   |
    LDA $D159,y         ; $10C68A   |
    ORA #$0C00          ; $10C68D   |
    STA $7E4002,x       ; $10C690   |

CODE_10C694:
    LDY $04             ; $10C694   |
    LDA $D159,y         ; $10C696   |
    ORA #$0C00          ; $10C699   |
    STA $7E4004,x       ; $10C69C   |
    LDA $7E4000         ; $10C6A0   |
    SEC                 ; $10C6A4   |
    SBC #$0004          ; $10C6A5   |
    TAX                 ; $10C6A8   |
    LDY $02             ; $10C6A9   |
    BEQ CODE_10C6B7     ; $10C6AB   |
    LDA $D16D,y         ; $10C6AD   |
    ORA #$0C00          ; $10C6B0   |
    STA $7E4002,x       ; $10C6B3   |

CODE_10C6B7:
    LDY $04             ; $10C6B7   |
    LDA $D16D,y         ; $10C6B9   |
    ORA #$0C00          ; $10C6BC   |
    STA $7E4004,x       ; $10C6BF   |
    SEP #$30            ; $10C6C3   |
    RTS                 ; $10C6C5   |

DATA_10C6C6:         db $F7, $39, $01, $00, $FC, $2C, $17, $3A
DATA_10C6CE:         db $01, $00, $FC, $2C, $FF, $FF

DATA_10C6D4:         dw $3EF8, $3EF6

DATA_10C6D8:         dw $3EF9, $3EF7

CODE_10C6DC:
    PHX                 ; $10C6DC   |
    REP #$30            ; $10C6DD   |
    LDA $7E4000         ; $10C6DF   |
    CLC                 ; $10C6E3   |
    ADC #$000D          ; $10C6E4   |
    TAX                 ; $10C6E7   |
    DEC A               ; $10C6E8   |
    STA $7E4000         ; $10C6E9   |
    LDY #$000D          ; $10C6ED   |
    SEP #$20            ; $10C6F0   |

CODE_10C6F2:
    LDA $C6C6,y         ; $10C6F2   |
    STA $7E4002,x       ; $10C6F5   |
    DEX                 ; $10C6F9   |
    DEY                 ; $10C6FA   |
    BPL CODE_10C6F2     ; $10C6FB   |
    LDA $1166           ; $10C6FD   |
    TAY                 ; $10C700   |
    LDA $C869,y         ; $10C701   |
    ASL A               ; $10C704   |
    TAY                 ; $10C705   |
    REP #$20            ; $10C706   |
    LDA $7E4000         ; $10C708   |
    SEC                 ; $10C70C   |
    SBC #$0008          ; $10C70D   |
    TAX                 ; $10C710   |
    LDA $C6D4,y         ; $10C711   |
    STA $7E4002,x       ; $10C714   |
    LDA $7E4000         ; $10C718   |
    SEC                 ; $10C71C   |
    SBC #$0002          ; $10C71D   |
    TAX                 ; $10C720   |
    LDA $C6D8,y         ; $10C721   |
    STA $7E4002,x       ; $10C724   |
    SEP #$30            ; $10C728   |
    PLX                 ; $10C72A   |
    RTS                 ; $10C72B   |

DATA_10C72C:         db $F8, $39, $01, $00, $FC, $2C, $18, $3A
DATA_10C734:         db $01, $00, $FC, $2C, $FF, $FF

CODE_10C73A:
    PHX                 ; $10C73A   |
    STZ $03             ; $10C73B   |
    LDY $1167           ; $10C73D   |
    LDA $C877,y         ; $10C740   |
    ASL A               ; $10C743   |
    STA $02             ; $10C744   |
    REP #$30            ; $10C746   |
    LDA $7E4000         ; $10C748   |
    CLC                 ; $10C74C   |
    ADC #$000D          ; $10C74D   |
    TAX                 ; $10C750   |
    DEC A               ; $10C751   |
    STA $7E4000         ; $10C752   |
    LDY #$000D          ; $10C756   |
    SEP #$20            ; $10C759   |

CODE_10C75B:
    LDA $C72C,y         ; $10C75B   |
    STA $7E4002,x       ; $10C75E   |
    DEX                 ; $10C762   |
    DEY                 ; $10C763   |
    BPL CODE_10C75B     ; $10C764   |
    REP #$20            ; $10C766   |
    LDA $7E4000         ; $10C768   |
    SEC                 ; $10C76C   |
    SBC #$0008          ; $10C76D   |
    TAX                 ; $10C770   |
    LDY $02             ; $10C771   |
    LDA $D159,y         ; $10C773   |
    ORA #$0C00          ; $10C776   |
    STA $7E4002,x       ; $10C779   |
    LDA $7E4000         ; $10C77D   |
    SEC                 ; $10C781   |
    SBC #$0002          ; $10C782   |
    TAX                 ; $10C785   |
    LDA $D16D,y         ; $10C786   |
    ORA #$0C00          ; $10C789   |
    STA $7E4002,x       ; $10C78C   |
    SEP #$30            ; $10C790   |
    PLX                 ; $10C792   |
    RTS                 ; $10C793   |

DATA_10C794:         db $35, $3A, $09, $00, $FC, $2C, $FC, $2C
DATA_10C79C:         db $FC, $2C, $9C, $3E, $9D, $3E, $55, $3A
DATA_10C7A4:         db $09, $00, $FC, $2C, $FC, $2C, $FC, $2C
DATA_10C7AC:         db $9E, $3E, $9F, $3E, $FF, $FF

    JSR CODE_10C885     ; $10C7B2   |
    LDA $117C           ; $10C7B5   |
    STA $0E             ; $10C7B8   |
    LDA $117D           ; $10C7BA   |
    STA $0F             ; $10C7BD   |
    JSR CODE_10CD09     ; $10C7BF   |
    STZ $01             ; $10C7C2   |
    STZ $03             ; $10C7C4   |
    STZ $05             ; $10C7C6   |
    LDA $1179           ; $10C7C8   |
    ASL A               ; $10C7CB   |
    STA $04             ; $10C7CC   |
    LDA $117A           ; $10C7CE   |
    ASL A               ; $10C7D1   |
    STA $02             ; $10C7D2   |
    LDA $117B           ; $10C7D4   |
    ASL A               ; $10C7D7   |
    STA $00             ; $10C7D8   |
    REP #$30            ; $10C7DA   |
    LDA $7E4000         ; $10C7DC   |
    CLC                 ; $10C7E0   |
    ADC #$001D          ; $10C7E1   |
    TAX                 ; $10C7E4   |
    DEC A               ; $10C7E5   |
    STA $7E4000         ; $10C7E6   |
    LDY #$001D          ; $10C7EA   |
    SEP #$20            ; $10C7ED   |

CODE_10C7EF:
    LDA $C794,y         ; $10C7EF   |
    STA $7E4002,x       ; $10C7F2   |
    DEX                 ; $10C7F6   |
    DEY                 ; $10C7F7   |
    BPL CODE_10C7EF     ; $10C7F8   |
    REP #$20            ; $10C7FA   |
    LDA $7E4000         ; $10C7FC   |
    SEC                 ; $10C800   |
    SBC #$0018          ; $10C801   |
    TAX                 ; $10C804   |
    LDY $00             ; $10C805   |
    BEQ CODE_10C813     ; $10C807   |
    LDA $D159,y         ; $10C809   |
    ORA #$0C00          ; $10C80C   |
    STA $7E4002,x       ; $10C80F   |

CODE_10C813:
    LDY $02             ; $10C813   |
    BNE CODE_10C81B     ; $10C815   |
    LDA $00             ; $10C817   |
    BEQ CODE_10C825     ; $10C819   |

CODE_10C81B:
    LDA $D159,y         ; $10C81B   |
    ORA #$0C00          ; $10C81E   |
    STA $7E4004,x       ; $10C821   |

CODE_10C825:
    LDY $04             ; $10C825   |
    LDA $D159,y         ; $10C827   |
    ORA #$0C00          ; $10C82A   |
    STA $7E4006,x       ; $10C82D   |
    LDA $7E4000         ; $10C831   |
    SEC                 ; $10C835   |
    SBC #$000A          ; $10C836   |
    TAX                 ; $10C839   |
    LDY $00             ; $10C83A   |
    BEQ CODE_10C848     ; $10C83C   |
    LDA $D16D,y         ; $10C83E   |
    ORA #$0C00          ; $10C841   |
    STA $7E4002,x       ; $10C844   |

CODE_10C848:
    LDY $02             ; $10C848   |
    BNE CODE_10C850     ; $10C84A   |
    LDA $00             ; $10C84C   |
    BEQ CODE_10C85A     ; $10C84E   |

CODE_10C850:
    LDA $D16D,y         ; $10C850   |
    ORA #$0C00          ; $10C853   |
    STA $7E4004,x       ; $10C856   |

CODE_10C85A:
    LDY $04             ; $10C85A   |
    LDA $D16D,y         ; $10C85C   |
    ORA #$0C00          ; $10C85F   |
    STA $7E4006,x       ; $10C862   |
    SEP #$30            ; $10C866   |
    RTS                 ; $10C868   |

DATA_10C869:         db $01, $00, $00, $01, $00, $01, $00, $01
DATA_10C871:         db $00, $00, $01, $00, $01, $00

DATA_10C877:         db $03, $00, $01, $00, $02, $00, $01, $00
DATA_10C87F:         db $02, $00, $01, $00, $01, $00

CODE_10C885:
    LDX $1166           ; $10C885   |
    LDA $C869,x         ; $10C888   |
    JSL $008365         ; $10C88B   |

DATA_10C88F:         dw $C893
DATA_10C891:         dw $C8A4

    STZ $117D           ; $10C893   |
    LDY $1167           ; $10C896   |
    LDA $1178           ; $10C899   |
    CLC                 ; $10C89C   |
    ADC $C877,y         ; $10C89D   |
    STA $117C           ; $10C8A0   |
    RTS                 ; $10C8A3   |

    STZ $00             ; $10C8A4   |
    STZ $01             ; $10C8A6   |
    LDY $1167           ; $10C8A8   |
    LDX $C877,y         ; $10C8AB   |
    BEQ CODE_10C8C2     ; $10C8AE   |
    LDA $1178           ; $10C8B0   |

CODE_10C8B3:
    DEX                 ; $10C8B3   |
    BEQ CODE_10C8C0     ; $10C8B4   |
    CLC                 ; $10C8B6   |
    ADC $1178           ; $10C8B7   |
    BCC CODE_10C8BE     ; $10C8BA   |
    INC $01             ; $10C8BC   |

CODE_10C8BE:
    BRA CODE_10C8B3     ; $10C8BE   |

CODE_10C8C0:
    STA $00             ; $10C8C0   |

CODE_10C8C2:
    REP #$20            ; $10C8C2   |
    LDA $00             ; $10C8C4   |
    STA $117C           ; $10C8C6   |
    SEP #$20            ; $10C8C9   |
    RTS                 ; $10C8CB   |

DATA_10C8CC:         db $FF, $01

CODE_10C8CE:
    REP #$20            ; $10C8CE   |
    LDA #$0063          ; $10C8D0   |
    STA $00             ; $10C8D3   |
    INC A               ; $10C8D5   |
    STA $02             ; $10C8D6   |
    LDA $1176           ; $10C8D8   |
    CMP #$0063          ; $10C8DB   |
    BCS CODE_10C8E5     ; $10C8DE   |
    STA $00             ; $10C8E0   |
    INC A               ; $10C8E2   |
    STA $02             ; $10C8E3   |

CODE_10C8E5:
    SEP #$20            ; $10C8E5   |
    LDA $0F             ; $10C8E7   |
    LSR A               ; $10C8E9   |
    LSR A               ; $10C8EA   |
    DEC A               ; $10C8EB   |
    TAX                 ; $10C8EC   |
    LDA $1178           ; $10C8ED   |
    CLC                 ; $10C8F0   |
    ADC $C8CC,x         ; $10C8F1   |
    STA $1178           ; $10C8F4   |
    CMP $02             ; $10C8F7   |
    BNE CODE_10C901     ; $10C8F9   |
    LDA #$01            ; $10C8FB   |
    STA $1178           ; $10C8FD   |
    RTS                 ; $10C900   |

CODE_10C901:
    CMP #$00            ; $10C901   |
    BNE CODE_10C90A     ; $10C903   |
    LDA $00             ; $10C905   |
    STA $1178           ; $10C907   |

CODE_10C90A:
    RTS                 ; $10C90A   |

DATA_10C90B:         db $01, $03

DATA_10C90D:         db $01, $01

DATA_10C90F:         db $0E, $0E

DATA_10C911:         db $00, $00

DATA_10C913:         db $0D, $0D

DATA_10C915:         db $08, $04

CODE_10C917:
    LDA $1183           ; $10C917   |
    BEQ CODE_10C934     ; $10C91A   |
    LDA $116E,x         ; $10C91C   |
    BEQ CODE_10C92A     ; $10C91F   |
    CMP #$01            ; $10C921   |
    BEQ CODE_10C945     ; $10C923   |
    DEC $116E,x         ; $10C925   |
    BRA CODE_10C960     ; $10C928   |

CODE_10C92A:
    LDA $30             ; $10C92A   |
    AND $C90B,x         ; $10C92C   |
    BNE CODE_10C934     ; $10C92F   |
    DEC $1168,x         ; $10C931   |

CODE_10C934:
    LDA $1168,x         ; $10C934   |
    BEQ CODE_10C96C     ; $10C937   |
    CMP $C915,x         ; $10C939   |
    BNE CODE_10C960     ; $10C93C   |
    LDA #$50            ; $10C93E   |
    STA $116E,x         ; $10C940   |
    BRA CODE_10C960     ; $10C943   |

CODE_10C945:
    TXA                 ; $10C945   |
    INC A               ; $10C946   |
    ORA $1174           ; $10C947   |
    STA $1174           ; $10C94A   |
    AND #$03            ; $10C94D   |
    CMP #$03            ; $10C94F   |
    BNE CODE_10C95C     ; $10C951   |
    LDA #$02            ; $10C953   |
    STA $1165           ; $10C955   |
    JSR CODE_10C73A     ; $10C958   |
    RTS                 ; $10C95B   |

CODE_10C95C:
    JSR CODE_10C6DC     ; $10C95C   |
    RTS                 ; $10C95F   |

CODE_10C960:
    LDA $1168,x         ; $10C960   |
    CLC                 ; $10C963   |
    ADC $116A,x         ; $10C964   |
    STA $116A,x         ; $10C967   |
    BCC CODE_10C9B0     ; $10C96A   |

CODE_10C96C:
    TXY                 ; $10C96C   |
    PHY                 ; $10C96D   |
    LDA #$50            ; $10C96E   |\ play sound #$0050
    JSL $0085D2         ; $10C970   |/
    PLY                 ; $10C974   |
    LDA $1166,x         ; $10C975   |
    CLC                 ; $10C978   |
    ADC $C90D,y         ; $10C979   |
    CMP $C90F,y         ; $10C97C   |
    BNE CODE_10C984     ; $10C97F   |
    LDA $C911,y         ; $10C981   |

CODE_10C984:
    STA $1166,x         ; $10C984   |
    DEC A               ; $10C987   |
    BPL CODE_10C98D     ; $10C988   |
    LDA $C913,y         ; $10C98A   |

CODE_10C98D:
    STA $116C,x         ; $10C98D   |
    LDA #$00            ; $10C990   |
    CPX #$00            ; $10C992   |
    BEQ CODE_10C998     ; $10C994   |
    LDA #$10            ; $10C996   |

CODE_10C998:
    STA $0F             ; $10C998   |
    LDY #$00            ; $10C99A   |
    LDA $1166,x         ; $10C99C   |
    STA $1175           ; $10C99F   |

CODE_10C9A2:
    JSR CODE_10CBB9     ; $10C9A2   |
    LDA $116C,x         ; $10C9A5   |
    STA $1175           ; $10C9A8   |
    INY                 ; $10C9AB   |
    CPY #$02            ; $10C9AC   |
    BNE CODE_10C9A2     ; $10C9AE   |

CODE_10C9B0:
    RTS                 ; $10C9B0   |

DATA_10C9B1:         dw $3A2D, $0003

DATA_10C9B5:         dw $3A6C, $0003

DATA_10C9B9:         dw $3A8A, $0003

DATA_10C9BD:         dw $3A88, $0003

DATA_10C9C1:         dw $3A86, $0003

DATA_10C9C5:         dw $3A64, $0003

DATA_10C9C9:         dw $3A23, $0003

DATA_10C9CD:         dw $39E3, $0003

DATA_10C9D1:         dw $39A4, $0003

DATA_10C9D5:         dw $3986, $0003

DATA_10C9D9:         dw $3988, $0003

DATA_10C9DD:         dw $398A, $0003

DATA_10C9E1:         dw $39AC, $0003

DATA_10C9E5:         dw $39ED, $0003

DATA_10C9E9:         dw $3A31, $0003

DATA_10C9ED:         dw $39F1, $0003

DATA_10C9F1:         dw $39B2, $0003

DATA_10C9F5:         dw $3994, $0003

DATA_10C9F9:         dw $3996, $0003

DATA_10C9FD:         dw $3998, $0003

DATA_10CA01:         dw $39BA, $0003

DATA_10CA05:         dw $39FB, $0003

DATA_10CA09:         dw $3A3B, $0003

DATA_10CA0D:         dw $3A7A, $0003

DATA_10CA11:         dw $3A98, $0003

DATA_10CA15:         dw $3A96, $0003

DATA_10CA19:         dw $3A94, $0003

DATA_10CA1D:         dw $3A72, $0003

DATA_10CA21:         dw $2283, $6283

DATA_10CA25:         dw $6288, $2288

DATA_10CA29:         dw $A285, $E285

DATA_10CA2D:         dw $E28A, $A28A

DATA_10CA31:         dw $6288, $2288

DATA_10CA35:         dw $2283, $6283

DATA_10CA39:         dw $A289, $E289

DATA_10CA3D:         dw $6284, $2284

DATA_10CA41:         dw $E28A, $A28A

DATA_10CA45:         dw $A285, $E285

DATA_10CA49:         dw $2287, $6287

DATA_10CA4D:         dw $6288, $2288

DATA_10CA51:         dw $E286, $A286

DATA_10CA55:         dw $A289, $E289

DATA_10CA59:         dw $228B, $628B

DATA_10CA5D:         dw $228C, $228D

DATA_10CA61:         dw $228B, $628B

DATA_10CA65:         dw $228C, $228D

DATA_10CA69:         dw $228B, $628B

DATA_10CA6D:         dw $2291, $2292

DATA_10CA71:         dw $228B, $628B

DATA_10CA75:         dw $228C, $228D

DATA_10CA79:         dw $228B, $628B

DATA_10CA7D:         dw $228E, $228F

DATA_10CA81:         dw $228B, $628B

DATA_10CA85:         dw $228C, $228D

DATA_10CA89:         dw $228B, $628B

DATA_10CA8D:         dw $228E, $228F

DATA_10CA91:         dw $A283, $E283

DATA_10CA95:         dw $E288, $A288

DATA_10CA99:         dw $2285, $6285

DATA_10CA9D:         dw $628A, $228A

DATA_10CAA1:         dw $E288, $A288

DATA_10CAA5:         dw $A283, $E283

DATA_10CAA9:         dw $2289, $6289

DATA_10CAAD:         dw $E284, $A284

DATA_10CAB1:         dw $628A, $228A

DATA_10CAB5:         dw $2285, $6285

DATA_10CAB9:         dw $A287, $E287

DATA_10CABD:         dw $E288, $A288

DATA_10CAC1:         dw $6286, $2286

DATA_10CAC5:         dw $2289, $6289

DATA_10CAC9:         dw $A28B, $E28B

DATA_10CACD:         dw $E28D, $A28D

DATA_10CAD1:         dw $A28B, $E28B

DATA_10CAD5:         dw $E28D, $A28D

DATA_10CAD9:         dw $A28B, $E28B

DATA_10CADD:         dw $A291, $2293

DATA_10CAE1:         dw $A28B, $E28B

DATA_10CAE5:         dw $E28D, $A28D

DATA_10CAE9:         dw $A28B, $E28B

DATA_10CAED:         dw $2290, $E28E

DATA_10CAF1:         dw $A28B, $E28B

DATA_10CAF5:         dw $E28D, $A28D

DATA_10CAF9:         dw $A28B, $E28B

DATA_10CAFD:         dw $2290, $E28E

DATA_10CB01:         dw $C9D5, $C9D9, $C9DD, $C9E1
DATA_10CB09:         dw $C9E5, $C9B1, $C9B5, $C9B9
DATA_10CB11:         dw $C9BD, $C9C1, $C9C5, $C9C9
DATA_10CB19:         dw $C9CD, $C9D1, $C9B1, $C9B1
DATA_10CB21:         dw $C9FD, $CA01, $CA05, $CA09
DATA_10CB29:         dw $CA0D, $CA11, $CA15, $CA19
DATA_10CB31:         dw $CA1D, $C9E9, $C9ED, $C9F1
DATA_10CB39:         dw $C9F5

DATA_10CB3B:         dw $C9F9, $CA45, $CA49, $CA4D
DATA_10CB43:         dw $CA51, $CA55, $CA21, $CA25
DATA_10CB4B:         dw $CA29, $CA2D, $CA31, $CA35
DATA_10CB53:         dw $CA39, $CA3D, $CA41, $CA21
DATA_10CB5B:         dw $CA21, $CA6D, $CA71, $CA75
DATA_10CB63:         dw $CA79, $CA7D, $CA81, $CA85
DATA_10CB6B:         dw $CA89, $CA8D, $CA59, $CA5D
DATA_10CB73:         dw $CA61, $CA65, $CA69

DATA_10CB79:         dw $CAB5, $CAB9, $CABD, $CAC1
DATA_10CB81:         dw $CAC5, $CA91, $CA95, $CA99
DATA_10CB89:         dw $CA9D, $CAA1, $CAA5, $CAA9
DATA_10CB91:         dw $CAAD, $CAB1, $CA91, $CA91
DATA_10CB99:         dw $CADD, $CAE1, $CAE5, $CAE9
DATA_10CBA1:         dw $CAED, $CAF1, $CAF5, $CAF9
DATA_10CBA9:         dw $CAFD, $CAC9, $CACD, $CAD1
DATA_10CBB1:         dw $CAD5, $CAD9

DATA_10CBB5:         dw $0800, $1C00

CODE_10CBB9:
    REP #$20            ; $10CBB9   |
    PHX                 ; $10CBBB   |
    PHY                 ; $10CBBC   |
    TYA                 ; $10CBBD   |
    AND #$0001          ; $10CBBE   |
    ASL A               ; $10CBC1   |
    TAY                 ; $10CBC2   |
    LDA $CBB5,y         ; $10CBC3   |
    STA $06             ; $10CBC6   |
    LDA $1175           ; $10CBC8   |
    AND #$00FF          ; $10CBCB   |
    ORA $0F             ; $10CBCE   |
    ASL A               ; $10CBD0   |
    TAX                 ; $10CBD1   |
    LDA $CB01,x         ; $10CBD2   |
    STA $00             ; $10CBD5   |
    LDA $CB3D,x         ; $10CBD7   |
    STA $02             ; $10CBDA   |
    LDA $CB79,x         ; $10CBDC   |
    STA $04             ; $10CBDF   |
    REP #$10            ; $10CBE1   |
    LDA $7E4000         ; $10CBE3   |
    TAX                 ; $10CBE7   |
    LDY #$0000          ; $10CBE8   |

CODE_10CBEB:
    LDA ($00),y         ; $10CBEB   |
    STA $7E4002,x       ; $10CBED   |
    CPY #$0000          ; $10CBF1   |
    BNE CODE_10CBFA     ; $10CBF4   |
    CLC                 ; $10CBF6   |
    ADC #$0020          ; $10CBF7   |

CODE_10CBFA:
    STA $7E400A,x       ; $10CBFA   |
    INX                 ; $10CBFE   |
    INX                 ; $10CBFF   |
    INY                 ; $10CC00   |
    INY                 ; $10CC01   |
    CPY #$0004          ; $10CC02   |
    BNE CODE_10CBEB     ; $10CC05   |
    LDY #$0000          ; $10CC07   |

CODE_10CC0A:
    LDA ($02),y         ; $10CC0A   |
    ORA $06             ; $10CC0C   |
    STA $7E4002,x       ; $10CC0E   |
    LDA ($04),y         ; $10CC12   |
    ORA $06             ; $10CC14   |
    STA $7E400A,x       ; $10CC16   |
    INX                 ; $10CC1A   |
    INX                 ; $10CC1B   |
    INY                 ; $10CC1C   |
    INY                 ; $10CC1D   |
    CPY #$0004          ; $10CC1E   |
    BNE CODE_10CC0A     ; $10CC21   |
    INX                 ; $10CC23   |
    INX                 ; $10CC24   |
    LDA #$FFFF          ; $10CC25   |
    STA $7E4008,x       ; $10CC28   |
    TXA                 ; $10CC2C   |
    CLC                 ; $10CC2D   |
    ADC #$0006          ; $10CC2E   |
    STA $7E4000         ; $10CC31   |
    SEP #$30            ; $10CC35   |
    PLY                 ; $10CC37   |
    PLX                 ; $10CC38   |
    RTS                 ; $10CC39   |

CODE_10CC3A:
    LDA $1174           ; $10CC3A   |
    BEQ CODE_10CC6D     ; $10CC3D   |
    LDX #$01            ; $10CC3F   |
    AND #$02            ; $10CC41   |
    BNE CODE_10CC47     ; $10CC43   |
    LDX #$00            ; $10CC45   |

CODE_10CC47:
    LDA #$00            ; $10CC47   |
    CPX #$00            ; $10CC49   |
    BEQ CODE_10CC4F     ; $10CC4B   |
    LDA #$10            ; $10CC4D   |

CODE_10CC4F:
    STA $0F             ; $10CC4F   |
    LDY #$00            ; $10CC51   |
    LDA $10DE           ; $10CC53   |
    CMP #$09            ; $10CC56   |
    BEQ CODE_10CC61     ; $10CC58   |
    LDA $30             ; $10CC5A   |
    AND #$01            ; $10CC5C   |
    BNE CODE_10CC61     ; $10CC5E   |
    INY                 ; $10CC60   |

CODE_10CC61:
    LDA $1166,x         ; $10CC61   |
    STA $1175           ; $10CC64   |
    JSR CODE_10CBB9     ; $10CC67   |
    DEX                 ; $10CC6A   |
    BPL CODE_10CC47     ; $10CC6B   |

CODE_10CC6D:
    RTS                 ; $10CC6D   |

DATA_10CC6E:         db $09, $3A, $03, $00, $FC, $2C, $FC, $2C
DATA_10CC76:         db $29, $3A, $03, $00, $FC, $2C, $FC, $2C
DATA_10CC7E:         db $FF, $FF

CODE_10CC80:
    LDA $1178           ; $10CC80   |
    STA $0E             ; $10CC83   |
    STZ $0F             ; $10CC85   |
    JSR CODE_10CD09     ; $10CC87   |
    STZ $03             ; $10CC8A   |
    STZ $05             ; $10CC8C   |
    LDA $1179           ; $10CC8E   |
    ASL A               ; $10CC91   |
    STA $04             ; $10CC92   |
    LDA $117A           ; $10CC94   |
    ASL A               ; $10CC97   |
    STA $02             ; $10CC98   |
    REP #$30            ; $10CC9A   |
    LDA $7E4000         ; $10CC9C   |
    CLC                 ; $10CCA0   |
    ADC #$0011          ; $10CCA1   |
    TAX                 ; $10CCA4   |
    DEC A               ; $10CCA5   |
    STA $7E4000         ; $10CCA6   |
    LDY #$0011          ; $10CCAA   |
    SEP #$20            ; $10CCAD   |

CODE_10CCAF:
    LDA $CC6E,y         ; $10CCAF   |
    STA $7E4002,x       ; $10CCB2   |
    DEX                 ; $10CCB6   |
    DEY                 ; $10CCB7   |
    BPL CODE_10CCAF     ; $10CCB8   |
    REP #$20            ; $10CCBA   |
    LDA $7E4000         ; $10CCBC   |
    SEC                 ; $10CCC0   |
    SBC #$000C          ; $10CCC1   |
    TAX                 ; $10CCC4   |
    LDA $02             ; $10CCC5   |
    BEQ CODE_10CCD5     ; $10CCC7   |
    LDY $02             ; $10CCC9   |
    LDA $D159,y         ; $10CCCB   |
    ORA #$0C00          ; $10CCCE   |
    STA $7E4002,x       ; $10CCD1   |

CODE_10CCD5:
    LDY $04             ; $10CCD5   |
    LDA $D159,y         ; $10CCD7   |
    ORA #$0C00          ; $10CCDA   |
    STA $7E4004,x       ; $10CCDD   |
    LDA $7E4000         ; $10CCE1   |
    SEC                 ; $10CCE5   |
    SBC #$0004          ; $10CCE6   |
    TAX                 ; $10CCE9   |
    LDA $02             ; $10CCEA   |
    BEQ CODE_10CCFA     ; $10CCEC   |
    LDY $02             ; $10CCEE   |
    LDA $D16D,y         ; $10CCF0   |
    ORA #$0C00          ; $10CCF3   |
    STA $7E4002,x       ; $10CCF6   |

CODE_10CCFA:
    LDY $04             ; $10CCFA   |
    LDA $D16D,y         ; $10CCFC   |
    ORA #$0C00          ; $10CCFF   |
    STA $7E4004,x       ; $10CD02   |
    SEP #$30            ; $10CD06   |
    RTS                 ; $10CD08   |

CODE_10CD09:
    STZ $117B           ; $10CD09   |
    STZ $117A           ; $10CD0C   |
    STZ $1179           ; $10CD0F   |
    REP #$20            ; $10CD12   |
    LDA $0E             ; $10CD14   |
    CMP #$0100          ; $10CD16   |
    BCC CODE_10CD31     ; $10CD19   |
    STZ $00             ; $10CD1B   |

CODE_10CD1D:
    CMP #$0064          ; $10CD1D   |
    BCC CODE_10CD2A     ; $10CD20   |
    INC $00             ; $10CD22   |
    SEC                 ; $10CD24   |
    SBC #$0064          ; $10CD25   |
    BRA CODE_10CD1D     ; $10CD28   |

CODE_10CD2A:
    SEP #$20            ; $10CD2A   |
    LDX $00             ; $10CD2C   |
    STX $117B           ; $10CD2E   |

CODE_10CD31:
    SEP #$20            ; $10CD31   |
    CMP #$64            ; $10CD33   |
    BCC CODE_10CD3F     ; $10CD35   |
    INC $117B           ; $10CD37   |
    SEC                 ; $10CD3A   |
    SBC #$64            ; $10CD3B   |
    BRA CODE_10CD31     ; $10CD3D   |

CODE_10CD3F:
    CMP #$0A            ; $10CD3F   |
    BCC CODE_10CD4B     ; $10CD41   |
    INC $117A           ; $10CD43   |
    SEC                 ; $10CD46   |
    SBC #$0A            ; $10CD47   |
    BRA CODE_10CD3F     ; $10CD49   |

CODE_10CD4B:
    STA $1179           ; $10CD4B   |
    RTS                 ; $10CD4E   |

    LDA $10DE           ; $10CD4F   |
    ASL A               ; $10CD52   |
    TAX                 ; $10CD53   |
    JMP ($CD57,x)       ; $10CD54   |

DATA_10CD57:         dw $A41C
DATA_10CD59:         dw $A427
DATA_10CD5B:         dw $A444
DATA_10CD5D:         dw $A466
DATA_10CD5F:         dw $A481
DATA_10CD61:         dw $A4EC
DATA_10CD63:         dw $A549
DATA_10CD65:         dw $A5B3
DATA_10CD67:         dw $CF39
DATA_10CD69:         dw $CFF2
DATA_10CD6B:         dw $D0B8
DATA_10CD6D:         dw $D0C1
DATA_10CD6F:         dw $A621

DATA_10CD71:         dw $0000, $0090, $0120, $01B0
DATA_10CD79:         dw $0240, $02D0

DATA_10CD7D:         db $50, $78, $A0, $50, $78, $A0

DATA_10CD83:         db $68, $68, $68, $90, $90, $90

DATA_10CD89:         db $03, $03, $03, $FD, $FD, $FD, $00, $01
DATA_10CD91:         db $02, $03, $04, $05, $06, $07, $08

DATA_10CD98:         dw $39AA, $39AF, $39B4, $3A4A
DATA_10CDA0:         dw $3A4F, $3A54

CODE_10CDA4:
    SEP #$30            ; $10CDA4   |
    LDA #$00            ; $10CDA6   |
    STA $1114           ; $10CDA8   |
    TAY                 ; $10CDAB   |
    LDA $CD7D,y         ; $10CDAC   |
    STA $10F6           ; $10CDAF   |
    LDA $CD83,y         ; $10CDB2   |
    STA $10F7           ; $10CDB5   |
    LDX #$08            ; $10CDB8   |
    TXY                 ; $10CDBA   |

CODE_10CDBB:
    TXA                 ; $10CDBB   |
    STA $00,x           ; $10CDBC   |
    DEX                 ; $10CDBE   |
    BPL CODE_10CDBB     ; $10CDBF   |
    LDA #$04            ; $10CDC1   |
    STA $2D             ; $10CDC3   |
    LDA #$11            ; $10CDC5   |
    STA $2E             ; $10CDC7   |
    JSR CODE_10BD2A     ; $10CDC9   |
    LDX #$05            ; $10CDCC   |
    TXY                 ; $10CDCE   |

CODE_10CDCF:
    TXA                 ; $10CDCF   |
    STA $00,x           ; $10CDD0   |
    DEX                 ; $10CDD2   |
    BPL CODE_10CDCF     ; $10CDD3   |
    LDA #$15            ; $10CDD5   |
    STA $2D             ; $10CDD7   |
    LDA #$11            ; $10CDD9   |
    STA $2E             ; $10CDDB   |
    JSR CODE_10BD2A     ; $10CDDD   |
    LDY #$02            ; $10CDE0   |
    LDA $0381           ; $10CDE2   |
    CMP #$32            ; $10CDE5   |
    BCS CODE_10CDEB     ; $10CDE7   |
    LDY #$00            ; $10CDE9   |

CODE_10CDEB:
    LDA #$09            ; $10CDEB   |

CODE_10CDED:
    LDX $1115,y         ; $10CDED   |
    STA $1104,x         ; $10CDF0   |
    DEY                 ; $10CDF3   |
    BPL CODE_10CDED     ; $10CDF4   |
    REP #$30            ; $10CDF6   |
    LDA #$7BBE          ; $10CDF8   |
    STA $12             ; $10CDFB   |
    LDA #$007E          ; $10CDFD   |
    STA $14             ; $10CE00   |
    LDY #$0005          ; $10CE02   |

CODE_10CE05:
    TYA                 ; $10CE05   |
    ASL A               ; $10CE06   |
    TAX                 ; $10CE07   |
    LDA $CD98,x         ; $10CE08   |
    STA $10             ; $10CE0B   |
    LDA $1104,y         ; $10CE0D   |
    AND #$00FF          ; $10CE10   |
    ASL A               ; $10CE13   |
    TAX                 ; $10CE14   |
    PHY                 ; $10CE15   |
    LDA $CE30,x         ; $10CE16   |
    JSR CODE_10CF01     ; $10CE19   |
    PLY                 ; $10CE1C   |
    LDA $12             ; $10CE1D   |
    CLC                 ; $10CE1F   |
    ADC #$0012          ; $10CE20   |
    STA $12             ; $10CE23   |
    LDA $14             ; $10CE25   |
    ADC #$0000          ; $10CE27   |
    STA $14             ; $10CE2A   |
    DEY                 ; $10CE2C   |
    BPL CODE_10CE05     ; $10CE2D   |
    RTS                 ; $10CE2F   |

DATA_10CE30:         dw $CE44
DATA_10CE32:         dw $CE56
DATA_10CE34:         dw $CE68
DATA_10CE36:         dw $CE7A
DATA_10CE38:         dw $CE8C
DATA_10CE3A:         dw $CE9E
DATA_10CE3C:         dw $CEB0
DATA_10CE3E:         dw $CEC2
DATA_10CE40:         dw $CED4
DATA_10CE42:         dw $CEE6

DATA_10CE44:         dw $0D5A, $0D5B, $0D5C, $0D5D
DATA_10CE4C:         dw $0D5E, $0D5F, $0D60, $0D61
DATA_10CE54:         dw $0D62

DATA_10CE56:         dw $1589, $158A, $158B, $158C
DATA_10CE5E:         dw $158D, $158E, $158F, $1590
DATA_10CE66:         dw $1591

DATA_10CE68:         dw $0D51, $0D52, $0D53, $0D54
DATA_10CE70:         dw $0D55, $0D56, $0D57, $0D58
DATA_10CE78:         dw $0D59

DATA_10CE7A:         dw $1563, $1564, $1565, $1566
DATA_10CE82:         dw $1567, $1568, $1569, $156A
DATA_10CE8A:         dw $156B

DATA_10CE8C:         dw $0D3F, $0D40, $0D41, $0D42
DATA_10CE94:         dw $0D43, $0D44, $0D45, $0D46
DATA_10CE9C:         dw $0D47

DATA_10CE9E:         dw $1192, $1193, $1194, $1195
DATA_10CEA6:         dw $1196, $1197, $1198, $1199
DATA_10CEAE:         dw $119A

DATA_10CEB0:         dw $159B, $159C, $159D, $159E
DATA_10CEB8:         dw $159F, $15A0, $15A1, $15A2
DATA_10CEC0:         dw $15A3

DATA_10CEC2:         dw $0D92, $0D93, $0D94, $0D95
DATA_10CECA:         dw $0D96, $0D97, $0D98, $0D99
DATA_10CED2:         dw $0D9A

DATA_10CED4:         dw $0D6C, $0D6D, $0D6E, $0D6F
DATA_10CEDC:         dw $0D70, $0D71, $0D72, $0D73
DATA_10CEE4:         dw $0D74

DATA_10CEE6:         dw $1575, $1576, $1577, $1578
DATA_10CEEE:         dw $1579, $157A, $157B, $157C
DATA_10CEF6:         dw $157D

DATA_10CEF8:         db $01, $02, $04, $03, $06, $07, $09, $08
DATA_10CF00:         db $05

CODE_10CF01:
    STA $16             ; $10CF01   |
    LDX #$0009          ; $10CF03   |
    LDY #$0000          ; $10CF06   |

CODE_10CF09:
    LDA ($16),y         ; $10CF09   |
    STA [$12],y         ; $10CF0B   |
    INY                 ; $10CF0D   |
    INY                 ; $10CF0E   |
    DEX                 ; $10CF0F   |
    BNE CODE_10CF09     ; $10CF10   |
    LDA #$0003          ; $10CF12   |
    STA $0E             ; $10CF15   |
    LDA $14             ; $10CF17   |
    STA $01             ; $10CF19   |
    LDY $10             ; $10CF1B   |
    LDX $12             ; $10CF1D   |

CODE_10CF1F:
    LDA #$0006          ; $10CF1F   |
    PHY                 ; $10CF22   |
    PHX                 ; $10CF23   |
    JSL $00BEA6         ; $10CF24   |
    PLA                 ; $10CF28   |
    CLC                 ; $10CF29   |
    ADC #$0006          ; $10CF2A   |
    TAX                 ; $10CF2D   |
    PLA                 ; $10CF2E   |
    CLC                 ; $10CF2F   |
    ADC #$0020          ; $10CF30   |
    TAY                 ; $10CF33   |
    DEC $0E             ; $10CF34   |
    BNE CODE_10CF1F     ; $10CF36   |
    RTS                 ; $10CF38   |

    SEP #$20            ; $10CF39   |
    LDA $110F           ; $10CF3B   |
    BEQ CODE_10CF43     ; $10CF3E   |
    DEC $110F           ; $10CF40   |

CODE_10CF43:
    REP #$20            ; $10CF43   |
    LDA $10F6           ; $10CF45   |
    AND #$00FF          ; $10CF48   |
    CLC                 ; $10CF4B   |
    ADC #$0014          ; $10CF4C   |
    STA $00             ; $10CF4F   |
    LDA $10F7           ; $10CF51   |
    AND #$00FF          ; $10CF54   |
    CLC                 ; $10CF57   |
    ADC #$0014          ; $10CF58   |
    STA $02             ; $10CF5B   |
    LDA #$3160          ; $10CF5D   |
    STA $04             ; $10CF60   |
    JSR CODE_10BBF9     ; $10CF62   |
    LDA $093E           ; $10CF65   |
    AND #$C080          ; $10CF68   |
    BEQ CODE_10CF92     ; $10CF6B   |
    LDA #$0009          ; $10CF6D   |\ play sound #$0009
    JSL $0085D2         ; $10CF70   |/
    LDY #$000A          ; $10CF74   |
    STY $10F0           ; $10CF77   |
    LDA $A2DD,y         ; $10CF7A   |
    JSR CODE_10A39A     ; $10CF7D   |
    SEP #$30            ; $10CF80   |
    LDA #$18            ; $10CF82   |
    STA $110F           ; $10CF84   |
    INC $10DE           ; $10CF87   |
    REP #$20            ; $10CF8A   |
    STZ $111C           ; $10CF8C   |
    REP #$10            ; $10CF8F   |
    RTS                 ; $10CF91   |

CODE_10CF92:
    SEP #$30            ; $10CF92   |
    LDA $093F           ; $10CF94   |
    AND #$0F            ; $10CF97   |
    BEQ CODE_10CF9F     ; $10CF99   |
    LDY #$20            ; $10CF9B   |
    BRA CODE_10CFA6     ; $10CF9D   |

CODE_10CF9F:
    LDY $110F           ; $10CF9F   |
    BNE CODE_10CFEF     ; $10CFA2   |
    LDY #$10            ; $10CFA4   |

CODE_10CFA6:
    STY $110F           ; $10CFA6   |
    LDA $093D           ; $10CFA9   |
    AND #$0F            ; $10CFAC   |
    BNE CODE_10CFB2     ; $10CFAE   |
    BRA CODE_10CFEF     ; $10CFB0   |

CODE_10CFB2:
    PHA                 ; $10CFB2   |
    AND #$03            ; $10CFB3   |
    TAY                 ; $10CFB5   |
    LDA $1114           ; $10CFB6   |
    CLC                 ; $10CFB9   |
    ADC $B63F,y         ; $10CFBA   |
    BPL CODE_10CFC3     ; $10CFBD   |
    LDA #$05            ; $10CFBF   |
    BRA CODE_10CFC9     ; $10CFC1   |

CODE_10CFC3:
    CMP #$06            ; $10CFC3   |
    BCC CODE_10CFC9     ; $10CFC5   |
    LDA #$00            ; $10CFC7   |

CODE_10CFC9:
    STA $1114           ; $10CFC9   |
    TAY                 ; $10CFCC   |
    PLA                 ; $10CFCD   |
    LSR A               ; $10CFCE   |
    LSR A               ; $10CFCF   |
    BIT #$03            ; $10CFD0   |
    BEQ CODE_10CFDD     ; $10CFD2   |
    TYA                 ; $10CFD4   |
    CLC                 ; $10CFD5   |
    ADC $CD89,y         ; $10CFD6   |
    STA $1114           ; $10CFD9   |
    TAY                 ; $10CFDC   |

CODE_10CFDD:
    LDA $CD7D,y         ; $10CFDD   |
    STA $10F6           ; $10CFE0   |
    LDA $CD83,y         ; $10CFE3   |
    STA $10F7           ; $10CFE6   |
    LDA #$5C            ; $10CFE9   |\ play sound #$005C
    JSL $0085D2         ; $10CFEB   |/

CODE_10CFEF:
    REP #$30            ; $10CFEF   |
    RTS                 ; $10CFF1   |

    SEP #$20            ; $10CFF2   |
    LDA $110F           ; $10CFF4   |
    BNE CODE_10D006     ; $10CFF7   |
    LDA #$20            ; $10CFF9   |
    STA $110F           ; $10CFFB   |
    LDA #$32            ; $10CFFE   |\ play sound #$0032
    JSL $0085D2         ; $10D000   |/
    BRA CODE_10D009     ; $10D004   |

CODE_10D006:
    DEC $110F           ; $10D006   |

CODE_10D009:
    REP #$20            ; $10D009   |
    SEP #$10            ; $10D00B   |
    LDA #$0053          ; $10D00D   |
    STA $3000           ; $10D010   |
    LDA #$A420          ; $10D013   |
    STA $3006           ; $10D016   |
    LDA $111C           ; $10D019   |
    STA $3008           ; $10D01C   |
    LDA #$0000          ; $10D01F   |
    STA $300A           ; $10D022   |
    LDX #$08            ; $10D025   |
    LDA #$E01F          ; $10D027   |
    JSL $7EDE44         ; $10D02A   | GSU init
    REP #$10            ; $10D02E   |
    LDA #$0070          ; $10D030   |
    STA $01             ; $10D033   |
    LDA $1114           ; $10D035   |
    AND #$00FF          ; $10D038   |
    ASL A               ; $10D03B   |
    TAX                 ; $10D03C   |
    LDY $CD71,x         ; $10D03D   |
    LDX #$5800          ; $10D040   |
    LDA #$0003          ; $10D043   |
    STA $0E             ; $10D046   |

CODE_10D048:
    LDA #$0060          ; $10D048   |
    PHX                 ; $10D04B   |
    PHY                 ; $10D04C   |
    JSL $00BEA6         ; $10D04D   |
    PLA                 ; $10D051   |
    CLC                 ; $10D052   |
    ADC #$0030          ; $10D053   |
    TAY                 ; $10D056   |
    PLA                 ; $10D057   |
    CLC                 ; $10D058   |
    ADC #$0200          ; $10D059   |
    TAX                 ; $10D05C   |
    DEC $0E             ; $10D05D   |
    BNE CODE_10D048     ; $10D05F   |
    SEP #$30            ; $10D061   |
    LDA $111C           ; $10D063   |
    CMP #$0C            ; $10D066   |
    BEQ CODE_10D076     ; $10D068   |
    LDA $30             ; $10D06A   |
    AND #$03            ; $10D06C   |
    BNE CODE_10D073     ; $10D06E   |
    INC $111C           ; $10D070   |

CODE_10D073:
    REP #$30            ; $10D073   |
    RTS                 ; $10D075   |

CODE_10D076:
    REP #$30            ; $10D076   |
    INC $10DE           ; $10D078   |
    LDA $1114           ; $10D07B   |
    AND #$00FF          ; $10D07E   |
    TAY                 ; $10D081   |
    LDA $1104,y         ; $10D082   |
    AND #$00FF          ; $10D085   |
    CMP #$0009          ; $10D088   |
    BEQ CODE_10D09F     ; $10D08B   |
    TAY                 ; $10D08D   |
    LDA $CEF8,y         ; $10D08E   |
    JSR CODE_109C80     ; $10D091   |
    LDA #$0005          ; $10D094   |
    STA $004D           ; $10D097   |
    LDY #$0004          ; $10D09A   |
    BRA CODE_10D0A9     ; $10D09D   |

CODE_10D09F:
    LDA #$007D          ; $10D09F   |\ play sound #$007D
    JSL $0085D2         ; $10D0A2   |/
    LDY #$0006          ; $10D0A6   |

CODE_10D0A9:
    STY $10F0           ; $10D0A9   |
    LDA #$0080          ; $10D0AC   |
    STA $10E0           ; $10D0AF   |
    LDA $A2DD,y         ; $10D0B2   |
    JMP CODE_10A39A     ; $10D0B5   |

    DEC $10E0           ; $10D0B8   |
    BNE CODE_10D0C0     ; $10D0BB   |
    INC $10DE           ; $10D0BD   |

CODE_10D0C0:
    RTS                 ; $10D0C0   |

    LDA #$0053          ; $10D0C1   |
    STA $3000           ; $10D0C4   |
    LDA #$A420          ; $10D0C7   |
    STA $3006           ; $10D0CA   |
    LDA #$0000          ; $10D0CD   |
    STA $3008           ; $10D0D0   |
    LDA $10E0           ; $10D0D3   |
    STA $300A           ; $10D0D6   |
    SEP #$10            ; $10D0D9   |
    LDX #$08            ; $10D0DB   |
    LDA #$E01F          ; $10D0DD   |
    JSL $7EDE44         ; $10D0E0   | GSU init
    REP #$10            ; $10D0E4   |
    LDA $1114           ; $10D0E6   |
    AND #$00FF          ; $10D0E9   |
    STA $0E             ; $10D0EC   |
    LDX #$0005          ; $10D0EE   |

CODE_10D0F1:
    CPX $0E             ; $10D0F1   |
    BEQ CODE_10D12E     ; $10D0F3   |
    PHX                 ; $10D0F5   |
    TXA                 ; $10D0F6   |
    ASL A               ; $10D0F7   |
    TAX                 ; $10D0F8   |
    LDA #$0070          ; $10D0F9   |
    STA $01             ; $10D0FC   |
    LDY $CD71,x         ; $10D0FE   |
    LDX #$5800          ; $10D101   |
    LDA #$0060          ; $10D104   |
    PHY                 ; $10D107   |
    JSL $00BEA6         ; $10D108   |
    PLA                 ; $10D10C   |
    CLC                 ; $10D10D   |
    ADC #$0030          ; $10D10E   |
    TAY                 ; $10D111   |
    LDX #$5A00          ; $10D112   |
    LDA #$0060          ; $10D115   |
    PHY                 ; $10D118   |
    JSL $00BEA6         ; $10D119   |
    PLA                 ; $10D11D   |
    CLC                 ; $10D11E   |
    ADC #$0030          ; $10D11F   |
    TAY                 ; $10D122   |
    LDX #$5C00          ; $10D123   |
    LDA #$0060          ; $10D126   |
    JSL $00BEA6         ; $10D129   |
    PLX                 ; $10D12D   |

CODE_10D12E:
    DEX                 ; $10D12E   |
    BPL CODE_10D0F1     ; $10D12F   |
    LDA $10E0           ; $10D131   |
    CMP #$000C          ; $10D134   |
    BNE CODE_10D14E     ; $10D137   |
    STZ $037D           ; $10D139   |
    STZ $037F           ; $10D13C   |
    LDA #$0064          ; $10D13F   |
    STA $0381           ; $10D142   |
    LDA #$0080          ; $10D145   |
    STA $10E0           ; $10D148   |
    INC $10DE           ; $10D14B   |

CODE_10D14E:
    LDA $30             ; $10D14E   |
    AND #$0003          ; $10D150   |
    BNE CODE_10D158     ; $10D153   |
    INC $10E0           ; $10D155   |

CODE_10D158:
    RTS                 ; $10D158   |

DATA_10D159:         dw $00CF, $00C7, $00C8, $00C9
DATA_10D161:         dw $00CA, $00CB, $00CC, $00CD
DATA_10D169:         dw $00CE, $80DC

DATA_10D16D:         dw $80CF, $00D7, $00D8, $00D9
DATA_10D175:         dw $00DA, $00DB, $00DC, $00DD
DATA_10D17D:         dw $00DC, $00DE

    LDA $10DE           ; $10D181   |
    ASL A               ; $10D184   |
    TAX                 ; $10D185   |
    JMP ($D189,x)       ; $10D186   |

DATA_10D189:         dw $A41C
DATA_10D18B:         dw $A427
DATA_10D18D:         dw $A444
DATA_10D18F:         dw $A466
DATA_10D191:         dw $A481
DATA_10D193:         dw $A4EC
DATA_10D195:         dw $A549
DATA_10D197:         dw $A5B3
DATA_10D199:         dw $D946
DATA_10D19B:         dw $D295
DATA_10D19D:         dw $AE80
DATA_10D19F:         dw $D5CA
DATA_10D1A1:         dw $D5FE
DATA_10D1A3:         dw $A621
DATA_10D1A5:         dw $D748
DATA_10D1A7:         dw $D7A3
DATA_10D1A9:         dw $D7D4
DATA_10D1AB:         dw $D843
DATA_10D1AD:         dw $D895
DATA_10D1AF:         dw $D5CD
DATA_10D1B1:         dw $D601
DATA_10D1B3:         dw $D9B8
DATA_10D1B5:         dw $D843
DATA_10D1B7:         dw $D895

CODE_10D1B9:
    STZ $1148           ; $10D1B9   |
    STZ $1184           ; $10D1BC   |
    STZ $114E           ; $10D1BF   |
    LDA #$00FF          ; $10D1C2   |
    STA $1192           ; $10D1C5   |
    STA $1194           ; $10D1C8   |
    SEP #$30            ; $10D1CB   |
    LDX #$0C            ; $10D1CD   |

CODE_10D1CF:
    STZ $119A,x         ; $10D1CF   |
    STZ $119B,x         ; $10D1D2   |
    DEX                 ; $10D1D5   |
    DEX                 ; $10D1D6   |
    BPL CODE_10D1CF     ; $10D1D7   |
    LDA $D3CA           ; $10D1D9   |
    STA $10F6           ; $10D1DC   |
    LDA $D3D8           ; $10D1DF   |
    STA $10F7           ; $10D1E2   |
    STZ $10F8           ; $10D1E5   |
    STZ $1154           ; $10D1E8   |
    STZ $1155           ; $10D1EB   |
    STZ $1164           ; $10D1EE   |
    REP #$30            ; $10D1F1   |
    RTS                 ; $10D1F3   |

DATA_10D1F4:         db $00, $02, $03, $05, $06, $07, $08, $09
DATA_10D1FC:         db $0B, $01, $01, $02, $02, $03, $03, $05
DATA_10D204:         db $32

CODE_10D205:
    SEP #$30            ; $10D205   |
    JSR CODE_10D275     ; $10D207   |
    STA $20             ; $10D20A   |

CODE_10D20C:
    JSR CODE_10D275     ; $10D20C   |
    CMP $20             ; $10D20F   |
    BEQ CODE_10D20C     ; $10D211   |
    STA $21             ; $10D213   |
    LDX #$00            ; $10D215   |
    TXY                 ; $10D217   |

CODE_10D218:
    CPY $20             ; $10D218   |
    BEQ CODE_10D229     ; $10D21A   |
    CPY $21             ; $10D21C   |
    BEQ CODE_10D229     ; $10D21E   |
    LDA $D1F4,y         ; $10D220   |
    STA $00,x           ; $10D223   |
    STA $01,x           ; $10D225   |
    INX                 ; $10D227   |
    INX                 ; $10D228   |

CODE_10D229:
    INY                 ; $10D229   |
    CPX #$0E            ; $10D22A   |
    BNE CODE_10D218     ; $10D22C   |
    LDA #$0E            ; $10D22E   |
    STA $0E             ; $10D230   |
    LDY #$00            ; $10D232   |

CODE_10D234:
    JSL $008408         ; $10D234   |
    LDA $0E             ; $10D238   |
    STA $4202           ; $10D23A   |
    LDA $7970           ; $10D23D   |
    STA $4203           ; $10D240   |
    NOP                 ; $10D243   |
    NOP                 ; $10D244   |
    NOP                 ; $10D245   |
    NOP                 ; $10D246   |
    REP #$20            ; $10D247   |
    LDA $4216           ; $10D249   |
    XBA                 ; $10D24C   |
    SEP #$20            ; $10D24D   |
    AND #$0F            ; $10D24F   |
    TAX                 ; $10D251   |
    LDA $00,x           ; $10D252   |
    STA $1156,y         ; $10D254   |
    INY                 ; $10D257   |
    CPY #$0D            ; $10D258   |
    BEQ CODE_10D269     ; $10D25A   |
    DEC $0E             ; $10D25C   |

CODE_10D25E:
    CPX $0E             ; $10D25E   |
    BEQ CODE_10D234     ; $10D260   |
    LDA $01,x           ; $10D262   |
    STA $00,x           ; $10D264   |
    INX                 ; $10D266   |
    BRA CODE_10D25E     ; $10D267   |

CODE_10D269:
    TXA                 ; $10D269   |
    EOR #$01            ; $10D26A   |
    TAX                 ; $10D26C   |
    LDA $00,x           ; $10D26D   |
    STA $1163           ; $10D26F   |
    REP #$30            ; $10D272   |
    RTS                 ; $10D274   |

CODE_10D275:
    SEP #$20            ; $10D275   |
    JSL $008408         ; $10D277   |
    LDA #$09            ; $10D27B   |
    STA $4202           ; $10D27D   |
    LDA $7970           ; $10D280   |
    STA $4203           ; $10D283   |
    NOP                 ; $10D286   |
    NOP                 ; $10D287   |
    NOP                 ; $10D288   |
    NOP                 ; $10D289   |
    REP #$20            ; $10D28A   |
    LDA $4216           ; $10D28C   |
    XBA                 ; $10D28F   |
    SEP #$20            ; $10D290   |
    AND #$0F            ; $10D292   |
    RTS                 ; $10D294   |

    SEP #$30            ; $10D295   |
    LDA $7978           ; $10D297   |
    BEQ CODE_10D2A1     ; $10D29A   |
    JSR CODE_10AE80     ; $10D29C   |
    BRA CODE_10D2B6     ; $10D29F   |

CODE_10D2A1:
    LDA $1164           ; $10D2A1   |
    CMP #$02            ; $10D2A4   |
    BNE CODE_10D2AD     ; $10D2A6   |
    JSR CODE_10D2B9     ; $10D2A8   |
    BRA CODE_10D2B6     ; $10D2AB   |

CODE_10D2AD:
    JSR CODE_10D3E8     ; $10D2AD   |
    JSR CODE_10D470     ; $10D2B0   |
    JSR CODE_10A928     ; $10D2B3   |

CODE_10D2B6:
    REP #$30            ; $10D2B6   |
    RTS                 ; $10D2B8   |

CODE_10D2B9:
    LDA $1148           ; $10D2B9   |
    CMP #$D006          ; $10D2BC   |
    CLC                 ; $10D2BF   |
    LDA #$8D0A          ; $10D2C0   |
    LSR $A911           ; $10D2C3   |
    ORA $85             ; $10D2C6   |
    EOR $90A9           ; $10D2C8   |
    STA $10E0           ; $10D2CB   |
    REP #$30            ; $10D2CE   |
    INC $1148           ; $10D2D0   |
    JSR CODE_10D6CC     ; $10D2D3   |
    BRA CODE_10D333     ; $10D2D6   |

    SEP #$30            ; $10D2D8   |
    LDA $1192           ; $10D2DA   |
    CMP $1194           ; $10D2DD   |
    BNE CODE_10D341     ; $10D2E0   |
    LDA $1148           ; $10D2E2   |
    CMP #$05            ; $10D2E5   |
    BNE CODE_10D2EC     ; $10D2E7   |
    JSR CODE_10D3AE     ; $10D2E9   |

CODE_10D2EC:
    LDA #$FF            ; $10D2EC   |
    LDX $1196           ; $10D2EE   |
    STA $1156,x         ; $10D2F1   |
    LDX $1198           ; $10D2F4   |
    STA $1156,x         ; $10D2F7   |
    REP #$30            ; $10D2FA   |
    INC $1148           ; $10D2FC   |
    LDA $1148           ; $10D2FF   |
    CMP #$0002          ; $10D302   |
    BNE CODE_10D30A     ; $10D305   |
    JSR CODE_10D37C     ; $10D307   |

CODE_10D30A:
    JSR CODE_10D6CC     ; $10D30A   |
    LDA $1192           ; $10D30D   |
    AND #$00FF          ; $10D310   |
    TAX                 ; $10D313   |
    LDA $A90A,x         ; $10D314   |
    AND #$00FF          ; $10D317   |
    JSR CODE_109C80     ; $10D31A   |
    LDA #$00FF          ; $10D31D   |
    STA $1192           ; $10D320   |
    STA $1194           ; $10D323   |
    LDA #$008F          ; $10D326   |\ play sound #$008F
    JSL $0085D2         ; $10D329   |/
    LDA #$0090          ; $10D32D   |
    STA $10E0           ; $10D330   |

CODE_10D333:
    LDA #$000E          ; $10D333   |
    STA $10DE           ; $10D336   |
    LDX #$0004          ; $10D339   |
    STX $10F0           ; $10D33C   |
    BRA CODE_10D373     ; $10D33F   |

CODE_10D341:
    REP #$30            ; $10D341   |
    INC $1184           ; $10D343   |
    LDA $1184           ; $10D346   |
    CMP #$0002          ; $10D349   |
    BNE CODE_10D35A     ; $10D34C   |
    LDA #$007D          ; $10D34E   |\ play sound #$007D
    JSL $0085D2         ; $10D351   |/
    LDA #$000D          ; $10D355   |
    BRA CODE_10D364     ; $10D358   |

CODE_10D35A:
    LDA #$0090          ; $10D35A   |\ plays sound #$0090
    JSL $0085D2         ; $10D35D   |/
    LDA #$000F          ; $10D361   |

CODE_10D364:
    STA $10DE           ; $10D364   |
    LDA #$0080          ; $10D367   |
    STA $10E0           ; $10D36A   |
    LDX #$0006          ; $10D36D   |
    STX $10F0           ; $10D370   |

CODE_10D373:
    LDA $A2DD,x         ; $10D373   |
    JSR CODE_10A39A     ; $10D376   |
    SEP #$30            ; $10D379   |
    RTS                 ; $10D37B   |

CODE_10D37C:
    LDA $7E4000         ; $10D37C   |
    TAX                 ; $10D380   |
    LDA #$6A13          ; $10D381   |
    STA $7E4002,x       ; $10D384   |
    LDA #$8003          ; $10D388   |
    STA $7E4004,x       ; $10D38B   |
    LDA #$0CAF          ; $10D38F   |
    STA $7E4006,x       ; $10D392   |
    LDA #$0CBF          ; $10D396   |
    STA $7E4008,x       ; $10D399   |
    LDA #$FFFF          ; $10D39D   |
    STA $7E400A,x       ; $10D3A0   |
    TXA                 ; $10D3A4   |
    CLC                 ; $10D3A5   |
    ADC #$0008          ; $10D3A6   |
    STA $7E4000         ; $10D3A9   |
    RTS                 ; $10D3AD   |

CODE_10D3AE:
    LDX #$0D            ; $10D3AE   |

CODE_10D3B0:
    CPX $1196           ; $10D3B0   |
    BEQ CODE_10D3C6     ; $10D3B3   |
    CPX $1198           ; $10D3B5   |
    BEQ CODE_10D3C6     ; $10D3B8   |
    LDA $1156,x         ; $10D3BA   |
    CMP #$F0FF          ; $10D3BD   |
    ORA $A9             ; $10D3C0   |
    TSB $9D             ; $10D3C2   |
    LSR $11,x           ; $10D3C4   |

CODE_10D3C6:
    DEX                 ; $10D3C6   |
    BPL CODE_10D3B0     ; $10D3C7   |
    RTS                 ; $10D3C9   |

DATA_10D3CA:         db $38, $58, $78, $98, $B8, $28, $48, $A8
DATA_10D3D2:         db $C8, $38, $58, $78, $98, $B8

DATA_10D3D8:         db $58, $58, $58, $58, $58, $78, $78, $78
DATA_10D3E0:         db $78, $98, $98, $98, $98, $98

DATA_10D3E6:         db $02, $FE

CODE_10D3E8:
    LDX $1154           ; $10D3E8   |
    LDA $10F8           ; $10D3EB   |
    BEQ CODE_10D435     ; $10D3EE   |
    CMP #$03            ; $10D3F0   |
    BCS CODE_10D40E     ; $10D3F2   |
    LDA $D3CA,x         ; $10D3F4   |
    CMP $10F6           ; $10D3F7   |
    BEQ CODE_10D432     ; $10D3FA   |
    LDA $10F8           ; $10D3FC   |
    AND #$01            ; $10D3FF   |
    TAX                 ; $10D401   |
    LDA $D3E6,x         ; $10D402   |
    CLC                 ; $10D405   |
    ADC $10F6           ; $10D406   |
    STA $10F6           ; $10D409   |
    BRA CODE_10D435     ; $10D40C   |

CODE_10D40E:
    LDA $10F7           ; $10D40E   |
    CMP $D3D8,x         ; $10D411   |
    BEQ CODE_10D432     ; $10D414   |
    LDA $10F8           ; $10D416   |
    AND #$01            ; $10D419   |
    TAX                 ; $10D41B   |
    LDA $D3E6,x         ; $10D41C   |
    CLC                 ; $10D41F   |
    ADC $10F7           ; $10D420   |
    STA $10F7           ; $10D423   |
    LDA $1155           ; $10D426   |
    CLC                 ; $10D429   |
    ADC $10F6           ; $10D42A   |
    STA $10F6           ; $10D42D   |
    BRA CODE_10D435     ; $10D430   |

CODE_10D432:
    STZ $10F8           ; $10D432   |

CODE_10D435:
    RTS                 ; $10D435   |

DATA_10D436:         db $09, $0A, $0B, $0C, $0D, $00, $01, $03
DATA_10D43E:         db $04, $05, $06, $02, $07, $08

DATA_10D444:         db $05, $06, $0B, $07, $08, $09, $0A, $0C
DATA_10D44C:         db $0D, $00, $01, $02, $03, $04, $00, $00
DATA_10D454:         db $00, $00

DATA_10D456:         db $00, $01, $01, $FF, $FF, $FF, $FF, $00
DATA_10D45E:         db $01, $01

DATA_10D460:         db $FF, $FF, $00, $01, $01, $01, $01, $FF
DATA_10D468:         db $FF, $00, $00, $00, $00, $00

DATA_10D46E:         db $FF, $01

CODE_10D470:
    LDA $10F8           ; $10D470   |
    BEQ CODE_10D476     ; $10D473   |

CODE_10D475:
    RTS                 ; $10D475   |

CODE_10D476:
    LDA $093F           ; $10D476   |
    AND #$C0            ; $10D479   |
    BNE CODE_10D484     ; $10D47B   |
    LDA $093E           ; $10D47D   |
    AND #$80            ; $10D480   |
    BEQ CODE_10D487     ; $10D482   |

CODE_10D484:
    JMP CODE_10D520     ; $10D484   |

CODE_10D487:
    LDA $093F           ; $10D487   |
    AND #$0F            ; $10D48A   |
    BEQ CODE_10D475     ; $10D48C   |
    AND #$03            ; $10D48E   |
    BEQ CODE_10D4D1     ; $10D490   |
    AND #$01            ; $10D492   |
    TAX                 ; $10D494   |
    LDA $1154           ; $10D495   |
    CLC                 ; $10D498   |
    ADC $D46E,x         ; $10D499   |
    STA $1154           ; $10D49C   |
    CPX #$00            ; $10D49F   |
    BNE CODE_10D4BA     ; $10D4A1   |
    CMP #$FF            ; $10D4A3   |
    BNE CODE_10D4AE     ; $10D4A5   |
    LDA #$0D            ; $10D4A7   |
    STA $1154           ; $10D4A9   |
    BRA CODE_10D506     ; $10D4AC   |

CODE_10D4AE:
    CMP #$04            ; $10D4AE   |
    BEQ CODE_10D506     ; $10D4B0   |
    CMP #$08            ; $10D4B2   |
    BEQ CODE_10D506     ; $10D4B4   |
    LDX #$00            ; $10D4B6   |
    BRA CODE_10D515     ; $10D4B8   |

CODE_10D4BA:
    CMP #$0E            ; $10D4BA   |
    BNE CODE_10D4C5     ; $10D4BC   |
    LDA #$00            ; $10D4BE   |
    STA $1154           ; $10D4C0   |
    BRA CODE_10D506     ; $10D4C3   |

CODE_10D4C5:
    CMP #$05            ; $10D4C5   |
    BEQ CODE_10D506     ; $10D4C7   |
    CMP #$09            ; $10D4C9   |
    BEQ CODE_10D506     ; $10D4CB   |
    LDX #$01            ; $10D4CD   |
    BRA CODE_10D515     ; $10D4CF   |

CODE_10D4D1:
    LDA $093F           ; $10D4D1   |
    AND #$08            ; $10D4D4   |
    BEQ CODE_10D4EF     ; $10D4D6   |
    LDX $1154           ; $10D4D8   |
    LDA $D452,x         ; $10D4DB   |
    STA $1155           ; $10D4DE   |
    LDA $D436,x         ; $10D4E1   |
    STA $1154           ; $10D4E4   |
    CPX #$05            ; $10D4E7   |
    BCC CODE_10D506     ; $10D4E9   |
    LDX #$02            ; $10D4EB   |
    BRA CODE_10D515     ; $10D4ED   |

CODE_10D4EF:
    LDX $1154           ; $10D4EF   |
    LDA $D460,x         ; $10D4F2   |
    STA $1155           ; $10D4F5   |
    LDA $D444,x         ; $10D4F8   |
    STA $1154           ; $10D4FB   |
    CPX #$09            ; $10D4FE   |
    BCS CODE_10D506     ; $10D500   |
    LDX #$03            ; $10D502   |
    BRA CODE_10D515     ; $10D504   |

CODE_10D506:
    TAX                 ; $10D506   |
    LDA $D3CA,x         ; $10D507   |
    STA $10F6           ; $10D50A   |
    LDA $D3D8,x         ; $10D50D   |
    STA $10F7           ; $10D510   |
    BRA CODE_10D519     ; $10D513   |

CODE_10D515:
    INX                 ; $10D515   |
    STX $10F8           ; $10D516   |

CODE_10D519:
    LDA #$5C            ; $10D519   |\ play sound #$005C
    JSL $0085D2         ; $10D51B   |/
    RTS                 ; $10D51F   |

CODE_10D520:
    LDX $1154           ; $10D520   |
    LDY $1156,x         ; $10D523   |
    CPY #$FF            ; $10D526   |
    BEQ CODE_10D536     ; $10D528   |
    LDA $1164           ; $10D52A   |
    AND #$01            ; $10D52D   |
    BEQ CODE_10D537     ; $10D52F   |
    CPX $1196           ; $10D531   |
    BNE CODE_10D537     ; $10D534   |

CODE_10D536:
    RTS                 ; $10D536   |

CODE_10D537:
    STY $10F3           ; $10D537   |
    LDA $1164           ; $10D53A   |
    AND #$01            ; $10D53D   |
    ASL A               ; $10D53F   |
    TAX                 ; $10D540   |
    TYA                 ; $10D541   |
    STA $1192,x         ; $10D542   |
    LDA $1154           ; $10D545   |
    STA $1196,x         ; $10D548   |
    INC $1164           ; $10D54B   |
    LDA #$01            ; $10D54E   |
    STA $7978           ; $10D550   |
    JSR CODE_10AD77     ; $10D553   |
    REP #$30            ; $10D556   |
    LDX #$0002          ; $10D558   |
    STX $10F0           ; $10D55B   |
    LDA $A2DD,x         ; $10D55E   |
    JSR CODE_10A39A     ; $10D561   |
    SEP #$30            ; $10D564   |
    INC $10DE           ; $10D566   |
    SEP #$30            ; $10D569   |
    RTS                 ; $10D56B   |

DATA_10D56C:         dw $6967, $696B, $696F, $6973
DATA_10D574:         dw $6977, $69E5, $69E9, $69F5
DATA_10D57C:         dw $69F9, $6A67, $6A6B, $6A6F
DATA_10D584:         dw $6A73, $6A77

CODE_10D588:
    LDA $1154           ; $10D588   |
    AND #$00FF          ; $10D58B   |
    ASL A               ; $10D58E   |
    TAX                 ; $10D58F   |
    LDA #$0003          ; $10D590   |
    STA $0E             ; $10D593   |
    LDY $D56C,x         ; $10D595   |

CODE_10D598:
    PHY                 ; $10D598   |
    LDA #$0010          ; $10D599   |
    STA $01             ; $10D59C   |
    LDX #$AB12          ; $10D59E   |
    LDA #$0006          ; $10D5A1   |
    JSL $00BEA6         ; $10D5A4   |
    PLA                 ; $10D5A8   |
    CLC                 ; $10D5A9   |
    ADC #$0020          ; $10D5AA   |
    TAY                 ; $10D5AD   |
    DEC $0E             ; $10D5AE   |
    BNE CODE_10D598     ; $10D5B0   |
    LDA #$D6B1          ; $10D5B2   |
    STA $00             ; $10D5B5   |
    JSR CODE_10D6B4     ; $10D5B7   |
    STZ $10F4           ; $10D5BA   |
    LDA #$0084          ; $10D5BD   |
    LDX #$0015          ; $10D5C0   |
    JMP CODE_10AC94     ; $10D5C3   |

DATA_10D5C6:         db $08, $00, $10, $00

    JSR CODE_10AE80     ; $10D5CA   |
    LDX #$0000          ; $10D5CD   |
    LDA $10DE           ; $10D5D0   |
    CMP #$0013          ; $10D5D3   |
    BNE CODE_10D5DA     ; $10D5D6   |
    INX                 ; $10D5D8   |
    INX                 ; $10D5D9   |

CODE_10D5DA:
    LDA $10F4           ; $10D5DA   |
    CLC                 ; $10D5DD   |
    ADC $D5C6,x         ; $10D5DE   |
    STA $10F4           ; $10D5E1   |
    CMP #$0080          ; $10D5E4   |
    BMI CODE_10D5ED     ; $10D5E7   |
    INC $10DE           ; $10D5E9   |
    RTS                 ; $10D5EC   |

CODE_10D5ED:
    LDA #$D6B1          ; $10D5ED   |
    STA $00             ; $10D5F0   |
    JSR CODE_10D6B4     ; $10D5F2   |
    LDA #$0084          ; $10D5F5   |
    LDX #$0015          ; $10D5F8   |
    JMP CODE_10AC94     ; $10D5FB   |

    JSR CODE_10AE80     ; $10D5FE   |
    LDX #$0000          ; $10D601   |
    LDA $10DE           ; $10D604   |
    CMP #$0014          ; $10D607   |
    BNE CODE_10D60E     ; $10D60A   |
    INX                 ; $10D60C   |
    INX                 ; $10D60D   |

CODE_10D60E:
    LDA $10F4           ; $10D60E   |
    SEC                 ; $10D611   |
    SBC $D5C6,x         ; $10D612   |
    STA $10F4           ; $10D615   |
    BPL CODE_10D673     ; $10D618   |
    LDA $1154           ; $10D61A   |
    AND #$00FF          ; $10D61D   |
    ASL A               ; $10D620   |
    TAX                 ; $10D621   |
    LDY $D56C,x         ; $10D622   |
    LDA $10F3           ; $10D625   |
    AND #$00FF          ; $10D628   |
    ASL A               ; $10D62B   |
    STA $00             ; $10D62C   |
    ASL A               ; $10D62E   |
    ASL A               ; $10D62F   |
    ASL A               ; $10D630   |
    CLC                 ; $10D631   |
    ADC $00             ; $10D632   |
    CLC                 ; $10D634   |
    ADC #$AA16          ; $10D635   |
    TAX                 ; $10D638   |
    LDA #$0003          ; $10D639   |
    STA $0E             ; $10D63C   |
    LDA #$0010          ; $10D63E   |
    STA $01             ; $10D641   |

CODE_10D643:
    LDA #$0006          ; $10D643   |
    PHX                 ; $10D646   |
    PHY                 ; $10D647   |
    JSL $00BEA6         ; $10D648   |
    PLA                 ; $10D64C   |
    CLC                 ; $10D64D   |
    ADC #$0020          ; $10D64E   |
    TAY                 ; $10D651   |
    PLA                 ; $10D652   |
    CLC                 ; $10D653   |
    ADC #$0006          ; $10D654   |
    TAX                 ; $10D657   |
    DEC $0E             ; $10D658   |
    BNE CODE_10D643     ; $10D65A   |
    LDA $10DE           ; $10D65C   |
    CMP #$0014          ; $10D65F   |
    BEQ CODE_10D669     ; $10D662   |
    LDA #$0009          ; $10D664   |
    BRA CODE_10D66F     ; $10D667   |

CODE_10D669:
    INC $1154           ; $10D669   |
    LDA #$0008          ; $10D66C   |

CODE_10D66F:
    STA $10DE           ; $10D66F   |
    RTS                 ; $10D672   |

CODE_10D673:
    LDA $10F3           ; $10D673   |
    AND #$00FF          ; $10D676   |
    CLC                 ; $10D679   |
    ADC #$AB33          ; $10D67A   |
    STA $00             ; $10D67D   |
    JSR CODE_10D6B4     ; $10D67F   |
    LDA $10F3           ; $10D682   |
    AND #$00FF          ; $10D685   |
    TAY                 ; $10D688   |
    LDX #$0011          ; $10D689   |
    LDA $AA0A,y         ; $10D68C   |
    AND #$00FF          ; $10D68F   |
    JMP CODE_10AC94     ; $10D692   |

DATA_10D695:         db $34, $54, $74, $94, $B4, $24, $44, $A4
DATA_10D69D:         db $C4, $34, $54, $74, $94, $B4, $54, $54
DATA_10D6A5:         db $54, $54, $54, $74, $74, $74, $74, $94
DATA_10D6AD:         db $94, $94, $94, $94, $32, $32, $32

CODE_10D6B4:
    LDA $1154           ; $10D6B4   |
    AND #$00FF          ; $10D6B7   |
    TAX                 ; $10D6BA   |
    CLC                 ; $10D6BB   |
    ADC #$D695          ; $10D6BC   |
    STA $02             ; $10D6BF   |
    TXA                 ; $10D6C1   |
    CLC                 ; $10D6C2   |
    ADC #$D6A3          ; $10D6C3   |
    STA $04             ; $10D6C6   |
    JSR CODE_10ACB7     ; $10D6C8   |
    RTS                 ; $10D6CB   |

CODE_10D6CC:
    LDX #$0000          ; $10D6CC   |
    LDA $1148           ; $10D6CF   |
    LDY #$0000          ; $10D6D2   |

CODE_10D6D5:
    CMP #$000A          ; $10D6D5   |
    BCC CODE_10D6E0     ; $10D6D8   |
    SBC #$000A          ; $10D6DA   |
    INY                 ; $10D6DD   |
    BRA CODE_10D6D5     ; $10D6DE   |

CODE_10D6E0:
    STA $00             ; $10D6E0   |
    STY $02             ; $10D6E2   |
    LDA $7E4000         ; $10D6E4   |
    TAX                 ; $10D6E8   |
    LDA #$6A0E          ; $10D6E9   |
    STA $7E4002,x       ; $10D6EC   |
    CLC                 ; $10D6F0   |
    ADC #$0020          ; $10D6F1   |
    STA $7E400A,x       ; $10D6F4   |
    LDA #$0003          ; $10D6F8   |
    STA $7E4004,x       ; $10D6FB   |
    STA $7E400C,x       ; $10D6FF   |
    PHX                 ; $10D703   |
    LDA #$0002          ; $10D704   |
    STA $04             ; $10D707   |
    LDA $02             ; $10D709   |
    BNE CODE_10D718     ; $10D70B   |
    LDA #$0000          ; $10D70D   |
    STA $7E4006,x       ; $10D710   |
    BRA CODE_10D72A     ; $10D714   |

CODE_10D716:
    LDA $00             ; $10D716   |

CODE_10D718:
    ASL A               ; $10D718   |
    TAY                 ; $10D719   |
    LDA $D159,y         ; $10D71A   |
    ORA #$0C00          ; $10D71D   |
    STA $7E4006,x       ; $10D720   |
    LDA $D16D,y         ; $10D724   |
    ORA #$0C00          ; $10D727   |

CODE_10D72A:
    STA $7E400E,x       ; $10D72A   |
    INX                 ; $10D72E   |
    INX                 ; $10D72F   |
    DEC $04             ; $10D730   |
    DEC $04             ; $10D732   |
    BPL CODE_10D716     ; $10D734   |
    PLX                 ; $10D736   |
    LDA #$FFFF          ; $10D737   |
    STA $7E4012,x       ; $10D73A   |
    TXA                 ; $10D73E   |
    CLC                 ; $10D73F   |
    ADC #$0010          ; $10D740   |
    STA $7E4000         ; $10D743   |
    RTS                 ; $10D747   |

    LDA $10E0           ; $10D748   |
    BEQ CODE_10D752     ; $10D74B   |
    DEC $10E0           ; $10D74D   |
    BRA CODE_10D7A2     ; $10D750   |

CODE_10D752:
    LDA $114E           ; $10D752   |
    BNE CODE_10D78C     ; $10D755   |
    LDA $10F3           ; $10D757   |
    AND #$00FF          ; $10D75A   |
    CMP #$0004          ; $10D75D   |
    BNE CODE_10D770     ; $10D760   |
    LDA #$0080          ; $10D762   |
    STA $10E0           ; $10D765   |
    LDA #$000D          ; $10D768   |
    STA $10DE           ; $10D76B   |
    BRA CODE_10D7A2     ; $10D76E   |

CODE_10D770:
    LDA $60C0           ; $10D770   |
    BNE CODE_10D7A2     ; $10D773   |
    STZ $1164           ; $10D775   |
    LDX #$0000          ; $10D778   |
    STX $10F0           ; $10D77B   |
    LDA $A2DD,x         ; $10D77E   |
    JSR CODE_10A39A     ; $10D781   |
    LDA #$0009          ; $10D784   |
    STA $10DE           ; $10D787   |
    BRA CODE_10D7A2     ; $10D78A   |

CODE_10D78C:
    DEC $114E           ; $10D78C   |
    INC $0379           ; $10D78F   |
    LDA #$0008          ; $10D792   |\ play sound #$0008
    JSL $0085D2         ; $10D795   |/
    JSR CODE_109D74     ; $10D799   |
    LDA #$0030          ; $10D79C   |
    STA $10E0           ; $10D79F   |

CODE_10D7A2:
    RTS                 ; $10D7A2   |

    LDA $10E0           ; $10D7A3   |
    BEQ CODE_10D7AD     ; $10D7A6   |
    DEC $10E0           ; $10D7A8   |
    BRA CODE_10D7D3     ; $10D7AB   |

CODE_10D7AD:
    DEC $1164           ; $10D7AD   |
    BMI CODE_10D7BE     ; $10D7B0   |
    LDA #$0050          ; $10D7B2   |\ play sound #$0050
    JSL $0085D2         ; $10D7B5   |/
    INC $10DE           ; $10D7B9   |
    BRA CODE_10D7D3     ; $10D7BC   |

CODE_10D7BE:
    STZ $1164           ; $10D7BE   |
    LDX #$0000          ; $10D7C1   |
    STX $10F0           ; $10D7C4   |
    LDA $A2DD,x         ; $10D7C7   |
    JSR CODE_10A39A     ; $10D7CA   |
    LDA #$0009          ; $10D7CD   |
    STA $10DE           ; $10D7D0   |

CODE_10D7D3:
    RTS                 ; $10D7D3   |

CODE_10D7D4:
    LDA $1164           ; $10D7D4   |
    AND #$00FF          ; $10D7D7   |
    ASL A               ; $10D7DA   |
    TAX                 ; $10D7DB   |
    LDA $1196,x         ; $10D7DC   |
    AND #$00FF          ; $10D7DF   |
    ASL A               ; $10D7E2   |
    TAX                 ; $10D7E3   |
    LDA #$0003          ; $10D7E4   |
    STA $0E             ; $10D7E7   |
    LDY $D56C,x         ; $10D7E9   |

CODE_10D7EC:
    PHY                 ; $10D7EC   |
    LDA #$0010          ; $10D7ED   |
    STA $01             ; $10D7F0   |
    LDX #$AB12          ; $10D7F2   |
    LDA #$0006          ; $10D7F5   |
    JSL $00BEA6         ; $10D7F8   |
    PLA                 ; $10D7FC   |
    CLC                 ; $10D7FD   |
    ADC #$0020          ; $10D7FE   |
    TAY                 ; $10D801   |
    DEC $0E             ; $10D802   |
    BNE CODE_10D7EC     ; $10D804   |
    LDA $1164           ; $10D806   |
    AND #$00FF          ; $10D809   |
    ASL A               ; $10D80C   |
    TAX                 ; $10D80D   |
    LDA $1192,x         ; $10D80E   |
    AND #$00FF          ; $10D811   |
    CLC                 ; $10D814   |
    ADC #$AB33          ; $10D815   |
    STA $00             ; $10D818   |
    JSR CODE_10D926     ; $10D81A   |
    STZ $10F4           ; $10D81D   |
    LDA $1164           ; $10D820   |
    AND #$00FF          ; $10D823   |
    ASL A               ; $10D826   |
    TAX                 ; $10D827   |
    LDA $1192,x         ; $10D828   |
    AND #$00FF          ; $10D82B   |
    TAY                 ; $10D82E   |
    LDX #$0011          ; $10D82F   |
    LDA $AA0A,y         ; $10D832   |
    AND #$00FF          ; $10D835   |
    JSR CODE_10AC94     ; $10D838   |
    INC $10DE           ; $10D83B   |
    RTS                 ; $10D83E   |

DATA_10D83F:         dw $0018, $0010

    LDX #$0000          ; $10D843   |
    LDA $10DE           ; $10D846   |
    CMP #$0011          ; $10D849   |
    BEQ CODE_10D850     ; $10D84C   |
    INX                 ; $10D84E   |
    INX                 ; $10D84F   |

CODE_10D850:
    LDA $10F4           ; $10D850   |
    CLC                 ; $10D853   |
    ADC $D83F,x         ; $10D854   |
    STA $10F4           ; $10D857   |
    CMP #$0080          ; $10D85A   |
    BMI CODE_10D863     ; $10D85D   |
    INC $10DE           ; $10D85F   |
    RTS                 ; $10D862   |

CODE_10D863:
    LDA $1164           ; $10D863   |
    AND #$00FF          ; $10D866   |
    ASL A               ; $10D869   |
    TAX                 ; $10D86A   |
    LDA $1192,x         ; $10D86B   |
    AND #$00FF          ; $10D86E   |
    CLC                 ; $10D871   |
    ADC #$AB33          ; $10D872   |
    STA $00             ; $10D875   |
    JSR CODE_10D926     ; $10D877   |
    LDA $1164           ; $10D87A   |
    AND #$00FF          ; $10D87D   |
    ASL A               ; $10D880   |
    TAX                 ; $10D881   |
    LDA $1192,x         ; $10D882   |
    AND #$00FF          ; $10D885   |
    TAY                 ; $10D888   |
    LDX #$0011          ; $10D889   |
    LDA $AA0A,y         ; $10D88C   |
    AND #$00FF          ; $10D88F   |
    JMP CODE_10AC94     ; $10D892   |

    LDX #$0000          ; $10D895   |
    LDA $10DE           ; $10D898   |
    CMP #$0012          ; $10D89B   |
    BEQ CODE_10D8A2     ; $10D89E   |
    INX                 ; $10D8A0   |
    INX                 ; $10D8A1   |

CODE_10D8A2:
    LDA $10F4           ; $10D8A2   |
    SEC                 ; $10D8A5   |
    SBC $D83F,x         ; $10D8A6   |
    STA $10F4           ; $10D8A9   |
    BPL CODE_10D911     ; $10D8AC   |
    LDA $1164           ; $10D8AE   |
    AND #$00FF          ; $10D8B1   |
    ASL A               ; $10D8B4   |
    TAX                 ; $10D8B5   |
    LDA $1196,x         ; $10D8B6   |
    AND #$00FF          ; $10D8B9   |
    ASL A               ; $10D8BC   |
    TAX                 ; $10D8BD   |
    LDY $D56C,x         ; $10D8BE   |
    LDA #$00D8          ; $10D8C1   |
    CLC                 ; $10D8C4   |
    ADC #$AA16          ; $10D8C5   |
    TAX                 ; $10D8C8   |
    LDA #$0003          ; $10D8C9   |
    STA $0E             ; $10D8CC   |

CODE_10D8CE:
    LDA #$0010          ; $10D8CE   |
    STA $01             ; $10D8D1   |
    LDA #$0006          ; $10D8D3   |
    PHX                 ; $10D8D6   |
    PHY                 ; $10D8D7   |
    JSL $00BEA6         ; $10D8D8   |
    PLA                 ; $10D8DC   |
    CLC                 ; $10D8DD   |
    ADC #$0020          ; $10D8DE   |
    TAY                 ; $10D8E1   |
    PLA                 ; $10D8E2   |
    CLC                 ; $10D8E3   |
    ADC #$0006          ; $10D8E4   |
    TAX                 ; $10D8E7   |
    DEC $0E             ; $10D8E8   |
    BNE CODE_10D8CE     ; $10D8EA   |
    LDA $10DE           ; $10D8EC   |
    CMP #$0012          ; $10D8EF   |
    BNE CODE_10D907     ; $10D8F2   |
    LDA $1164           ; $10D8F4   |
    AND #$00FF          ; $10D8F7   |
    ASL A               ; $10D8FA   |
    TAX                 ; $10D8FB   |
    LDA $D922,x         ; $10D8FC   |
    STA $10E0           ; $10D8FF   |
    LDA #$000F          ; $10D902   |
    BRA CODE_10D90D     ; $10D905   |

CODE_10D907:
    INC $1154           ; $10D907   |
    LDA #$0015          ; $10D90A   |

CODE_10D90D:
    STA $10DE           ; $10D90D   |
    RTS                 ; $10D910   |

CODE_10D911:
    LDA #$D6B1          ; $10D911   |
    STA $00             ; $10D914   |
    JSR CODE_10D926     ; $10D916   |
    LDA #$0084          ; $10D919   |
    LDX #$0015          ; $10D91C   |
    JMP CODE_10AC94     ; $10D91F   |

DATA_10D922:         dw $0040, $0010

CODE_10D926:
    LDA $1164           ; $10D926   |
    AND #$00FF          ; $10D929   |
    ASL A               ; $10D92C   |
    TAX                 ; $10D92D   |
    LDA $1196,x         ; $10D92E   |
    AND #$00FF          ; $10D931   |
    TAX                 ; $10D934   |
    CLC                 ; $10D935   |
    ADC #$D695          ; $10D936   |
    STA $02             ; $10D939   |
    TXA                 ; $10D93B   |
    CLC                 ; $10D93C   |
    ADC #$D6A3          ; $10D93D   |
    STA $04             ; $10D940   |
    JSR CODE_10ACB7     ; $10D942   |
    RTS                 ; $10D945   |

    LDA $1154           ; $10D946   |
    CMP #$000E          ; $10D949   |
    BEQ CODE_10D96A     ; $10D94C   |
    LDA $1154           ; $10D94E   |
    AND #$00FF          ; $10D951   |
    TAX                 ; $10D954   |
    LDA $1156,x         ; $10D955   |
    STA $10F3           ; $10D958   |
    JSR CODE_10D97A     ; $10D95B   |
    LDA #$0050          ; $10D95E   |\ play sound #$0050
    JSL $0085D2         ; $10D961   |/
    LDA #$0013          ; $10D965   |
    BRA CODE_10D976     ; $10D968   |

CODE_10D96A:
    STZ $1154           ; $10D96A   |
    LDA #$0040          ; $10D96D   |
    STA $10E0           ; $10D970   |
    LDA #$0015          ; $10D973   |

CODE_10D976:
    STA $10DE           ; $10D976   |
    RTS                 ; $10D979   |

CODE_10D97A:
    LDA $1154           ; $10D97A   |
    AND #$00FF          ; $10D97D   |
    ASL A               ; $10D980   |
    TAX                 ; $10D981   |
    LDA #$0003          ; $10D982   |
    STA $0E             ; $10D985   |
    LDY $D56C,x         ; $10D987   |

CODE_10D98A:
    PHY                 ; $10D98A   |
    LDA #$0010          ; $10D98B   |
    STA $01             ; $10D98E   |
    LDX #$AB12          ; $10D990   |
    LDA #$0006          ; $10D993   |
    JSL $00BEA6         ; $10D996   |
    PLA                 ; $10D99A   |
    CLC                 ; $10D99B   |
    ADC #$0020          ; $10D99C   |
    TAY                 ; $10D99F   |
    DEC $0E             ; $10D9A0   |
    BNE CODE_10D98A     ; $10D9A2   |
    LDA #$D6B1          ; $10D9A4   |
    STA $00             ; $10D9A7   |
    JSR CODE_10D6B4     ; $10D9A9   |
    STZ $10F4           ; $10D9AC   |
    LDA #$0084          ; $10D9AF   |
    LDX #$0015          ; $10D9B2   |
    JMP CODE_10AC94     ; $10D9B5   |

    LDA $10E0           ; $10D9B8   |
    BEQ CODE_10D9C2     ; $10D9BB   |
    DEC $10E0           ; $10D9BD   |
    BRA CODE_10D9EE     ; $10D9C0   |

CODE_10D9C2:
    LDA $1154           ; $10D9C2   |
    CMP #$000E          ; $10D9C5   |
    BEQ CODE_10D9E5     ; $10D9C8   |
    LDX $1154           ; $10D9CA   |
    STX $1196           ; $10D9CD   |
    LDA $1156,x         ; $10D9D0   |
    STA $1192           ; $10D9D3   |
    STZ $1164           ; $10D9D6   |
    JSR CODE_10D7D4     ; $10D9D9   |
    LDA #$0050          ; $10D9DC   |\ play sound #$0050
    JSL $0085D2         ; $10D9DF   |/
    BRA CODE_10D9EE     ; $10D9E3   |

CODE_10D9E5:
    JSR CODE_10D1B9     ; $10D9E5   |
    LDA #$0009          ; $10D9E8   |
    STA $10DE           ; $10D9EB   |

CODE_10D9EE:
    RTS                 ; $10D9EE   |

DATA_10D9EF:         dw $01C0, $01A0, $0164, $0144
DATA_10D9F7:         dw $0156, $016E, $0192, $01AE

DATA_10D9FF:         dw $07A0, $07A6, $07A6, $07A0
DATA_10DA07:         dw $079A, $0798, $0798, $079A

DATA_10DA0F:         db $44, $26, $18, $5B, $7E

DATA_10DA14:         db $E9, $D0, $56, $E9, $74, $58, $00

DATA_10DA1B:         db $42, $0D, $98, $5B, $7E

DATA_10DA20:         db $E9, $2C, $55, $E9, $FE, $55, $00

DATA_10DA27:         db $42, $0F, $18, $5C, $7E

DATA_10DA2C:         db $E9, $40, $50, $E9, $12, $51, $00

    JSL $008277         ; $10DA33   |
    JSL $01AF6E         ; $10DA37   |
    JSL $0394B8         ; $10DA3B   |
    REP #$20            ; $10DA3F   |
    LDY #$00            ; $10DA41   |
    STZ $21             ; $10DA43   |
    LDA #$0392          ; $10DA45   |
    STA $20             ; $10DA48   |
    LDA #$022E          ; $10DA4A   |
    JSL $0082AB         ; $10DA4D   |
    STZ $7E04           ; $10DA51   |
    REP #$10            ; $10DA54   |
    LDA #$000A          ; $10DA56   |
    ASL A               ; $10DA59   |
    TAX                 ; $10DA5A   |
    LDA $17F3E7,x       ; $10DA5B   |
    TAX                 ; $10DA5F   |
    LDA $17F471,x       ; $10DA60   |
    AND #$00FF          ; $10DA64   |
    ASL A               ; $10DA67   |
    STA $00             ; $10DA68   |
    ASL A               ; $10DA6A   |
    ADC $00             ; $10DA6B   |
    TAX                 ; $10DA6D   |
    LDA $17F7C3,x       ; $10DA6E   |
    STA $32             ; $10DA72   |
    LDA $17F7C4,x       ; $10DA74   |
    STA $33             ; $10DA78   |
    LDA $17F7C6,x       ; $10DA7A   |
    STA $702600         ; $10DA7E   |
    LDA $17F7C8,x       ; $10DA82   |
    STA $702602         ; $10DA86   |
    SEP #$20            ; $10DA8A   |
    LDA #$23            ; $10DA8C   |
    STA $10             ; $10DA8E   |
    STA $11             ; $10DA90   |
    STA $12             ; $10DA92   |
    LDA #$B1            ; $10DA94   |
    STA $13             ; $10DA96   |
    LDA #$B2            ; $10DA98   |
    STA $14             ; $10DA9A   |
    LDA #$1A            ; $10DA9C   |
    STA $15             ; $10DA9E   |
    LDA #$17            ; $10DAA0   |
    STA $16             ; $10DAA2   |
    LDA #$AB            ; $10DAA4   |
    STA $17             ; $10DAA6   |
    STA $6EB6           ; $10DAA8   |
    LDA #$AC            ; $10DAAB   |
    STA $18             ; $10DAAD   |
    STA $6EB7           ; $10DAAF   |
    LDA #$1A            ; $10DAB2   |
    STA $19             ; $10DAB4   |
    STA $6EB8           ; $10DAB6   |
    STA $1A             ; $10DAB9   |
    STA $6EB9           ; $10DABB   |
    STA $1B             ; $10DABE   |
    STA $6EBA           ; $10DAC0   |
    STA $1C             ; $10DAC3   |
    STA $6EBB           ; $10DAC5   |
    REP #$10            ; $10DAC8   |
    LDY #$0000          ; $10DACA   |
    JSL $00B3EE         ; $10DACD   |
    REP #$30            ; $10DAD1   |
    LDA #$00A8          ; $10DAD3   |
    LDX #$5800          ; $10DAD6   |
    JSL $00B756         ; $10DAD9   |
    LDX #$3800          ; $10DADD   |
    JSR CODE_10DC71     ; $10DAE0   |
    LDA #$00A9          ; $10DAE3   |
    LDX #$5800          ; $10DAE6   |
    JSL $00B756         ; $10DAE9   |
    LDX #$3400          ; $10DAED   |
    JSR CODE_10DC71     ; $10DAF0   |
    REP #$30            ; $10DAF3   |
    LDX #$0000          ; $10DAF5   |

CODE_10DAF8:
    LDA #$7FFF          ; $10DAF8   |
    STA $702000,x       ; $10DAFB   |
    STA $702D6C,x       ; $10DAFF   |
    LDA $5FEC4A,x       ; $10DB03   |
    STA $702F6C,x       ; $10DB07   |
    LDA $5FED4A,x       ; $10DB0B   |
    STA $70306C,x       ; $10DB0F   |
    STA $702100,x       ; $10DB13   |
    STA $702E6C,x       ; $10DB17   |
    INX                 ; $10DB1B   |
    INX                 ; $10DB1C   |
    CPX #$0100          ; $10DB1D   |
    BCC CODE_10DAF8     ; $10DB20   |
    SEP #$30            ; $10DB22   |
    LDX #$04            ; $10DB24   |
    JSL $00BDA2         ; $10DB26   |
    LDA #$68            ; $10DB2A   |
    STA $095F           ; $10DB2C   |
    LDX #$04            ; $10DB2F   |

CODE_10DB31:
    LDA $DA0F,x         ; $10DB31   |
    STA $4350,x         ; $10DB34   |
    LDA $DA1B,x         ; $10DB37   |
    STA $4360,x         ; $10DB3A   |
    LDA $DA27,x         ; $10DB3D   |
    STA $4370,x         ; $10DB40   |
    DEX                 ; $10DB43   |
    BPL CODE_10DB31     ; $10DB44   |
    LDA #$7E            ; $10DB46   |
    STA $4357           ; $10DB48   |
    STA $4367           ; $10DB4B   |
    STA $4377           ; $10DB4E   |
    LDX #$06            ; $10DB51   |

CODE_10DB53:
    LDA $DA14,x         ; $10DB53   |
    STA $7E5B18,x       ; $10DB56   |
    LDA $DA20,x         ; $10DB5A   |
    STA $7E5B98,x       ; $10DB5D   |
    LDA $DA2C,x         ; $10DB61   |
    STA $7E5C18,x       ; $10DB64   |
    DEX                 ; $10DB68   |
    BPL CODE_10DB53     ; $10DB69   |
    JSL $00BE26         ; $10DB6B   |
    LDX #$11            ; $10DB6F   |
    JSL $008543         ; $10DB71   |
    JSL $108B61         ; $10DB75   |
    REP #$20            ; $10DB79   |
    LDA #$0720          ; $10DB7B   |
    STA $0C27           ; $10DB7E   |
    STA $3B             ; $10DB81   |
    STA $60A6           ; $10DB83   |
    STA $3F             ; $10DB86   |
    STA $609E           ; $10DB88   |
    STA $43             ; $10DB8B   |
    STA $60A0           ; $10DB8D   |
    LDA #$0000          ; $10DB90   |
    STA $39             ; $10DB93   |
    SEC                 ; $10DB95   |
    SBC #$0100          ; $10DB96   |
    STA $60A4           ; $10DB99   |
    SEP #$20            ; $10DB9C   |
    INC $038C           ; $10DB9E   |
    JSL $108FD6         ; $10DBA1   |
    STZ $038C           ; $10DBA5   |
    REP #$20            ; $10DBA8   |
    LDA #$0040          ; $10DBAA   |
    STA $0C23           ; $10DBAD   |
    STA $3D             ; $10DBB0   |
    STA $41             ; $10DBB2   |
    STA $6096           ; $10DBB4   |
    STA $6098           ; $10DBB7   |
    LDA #$012C          ; $10DBBA   |
    STA $03B6           ; $10DBBD   |
    LDA #$0003          ; $10DBC0   |
    STA $03A1           ; $10DBC3   |
    LDA #$000F          ; $10DBC6   |
    STA $014C           ; $10DBC9   |
    LDA #$0001          ; $10DBCC   |
    STA $0C1E           ; $10DBCF   |
    STA $0C20           ; $10DBD2   |
    LDA #$0180          ; $10DBD5   |
    STA $608C           ; $10DBD8   |
    LDA #$0790          ; $10DBDB   |
    STA $6090           ; $10DBDE   |
    JSL $04DC28         ; $10DBE1   |
    LDA #$10            ; $10DBE5   |
    STA $6F00           ; $10DBE7   |
    LDA #$03            ; $10DBEA   |
    STA $79D6           ; $10DBEC   |
    STZ $7902           ; $10DBEF   |
    REP #$20            ; $10DBF2   |
    STZ $61B2           ; $10DBF4   |
    LDA #$001C          ; $10DBF7   |
    STA $60AC           ; $10DBFA   |
    LDA #$0002          ; $10DBFD   |
    STA $60C4           ; $10DC00   |
    LDX #$0E            ; $10DC03   |

CODE_10DC05:
    LDA #$012D          ; $10DC05   |
    JSL $03A34C         ; $10DC08   |
    LDA $D9EF,x         ; $10DC0C   |
    STA $70E2,y         ; $10DC0F   |
    LDA $D9FF,x         ; $10DC12   |
    STA $7182,y         ; $10DC15   |
    TXA                 ; $10DC18   |
    STA $7976,y         ; $10DC19   |
    SEC                 ; $10DC1C   |
    SBC #$0004          ; $10DC1D   |
    CMP #$0008          ; $10DC20   |
    BCS CODE_10DC2B     ; $10DC23   |
    LDA #$0002          ; $10DC25   |
    STA $7400,y         ; $10DC28   |

CODE_10DC2B:
    TXA                 ; $10DC2B   |
    LSR A               ; $10DC2C   |
    DEC A               ; $10DC2D   |
    LSR A               ; $10DC2E   |
    BNE CODE_10DC37     ; $10DC2F   |
    LDA #$0002          ; $10DC31   |
    STA $74A2,y         ; $10DC34   |

CODE_10DC37:
    DEX                 ; $10DC37   |
    DEX                 ; $10DC38   |
    BPL CODE_10DC05     ; $10DC39   |
    LDA #$01F0          ; $10DC3B   |
    STA $7E1A           ; $10DC3E   |
    SEP #$20            ; $10DC41   |
    LDA #$01            ; $10DC43   |
    STA $4D             ; $10DC45   |
    STZ $0121           ; $10DC47   |
    LDA #$02            ; $10DC4A   |
    STA $0125           ; $10DC4C   |
    LDA #$50            ; $10DC4F   |
    STA $4207           ; $10DC51   |
    LDA #$D8            ; $10DC54   |
    STA $4209           ; $10DC56   |
    LDA #$B1            ; $10DC59   |
    STA $4200           ; $10DC5B   |
    LDA #$0F            ; $10DC5E   |
    STA $0200           ; $10DC60   |
    LDA $0201           ; $10DC63   |
    EOR #$01            ; $10DC66   |
    AND #$01            ; $10DC68   |
    STA $0201           ; $10DC6A   |
    JML $1083E2         ; $10DC6D   |

CODE_10DC71:
    STX $00             ; $10DC71   |
    SEP #$10            ; $10DC73   |
    STA $4305           ; $10DC75   |
    LDX #$80            ; $10DC78   |
    STX $2115           ; $10DC7A   |
    LDA $00             ; $10DC7D   |
    STA $2116           ; $10DC7F   |
    LDA #$1801          ; $10DC82   |
    STA $4300           ; $10DC85   |
    LDA #$5800          ; $10DC88   |
    STA $4302           ; $10DC8B   |
    LDX #$70            ; $10DC8E   |
    STX $4304           ; $10DC90   |
    LDX #$01            ; $10DC93   |
    STX $420B           ; $10DC95   |
    REP #$10            ; $10DC98   |
    RTS                 ; $10DC9A   |

DATA_10DC9B:         dw $DCF0
DATA_10DC9D:         dw $DD7C
DATA_10DC9F:         dw $DD4C
DATA_10DCA1:         dw $DD7C
DATA_10DCA3:         dw $DD60
DATA_10DCA5:         dw $DD61
DATA_10DCA7:         dw $DD6E
DATA_10DCA9:         dw $DD7C
DATA_10DCAB:         dw $DD60

    JSL $008259         ; $10DCAD   |
    LDA $0D27           ; $10DCB1   |
    ASL A               ; $10DCB4   |
    TAX                 ; $10DCB5   |
    JSR ($DC9B,x)       ; $10DCB6   |

    REP #$20            ; $10DCB9   |
    LDA #$0081          ; $10DCBB   |
    STA $7E20           ; $10DCBE   |
    SEP #$20            ; $10DCC1   |
    JSL $04FD28         ; $10DCC3   |
    JSL $0394D3         ; $10DCC7   |
    JSL $04FA67         ; $10DCCB   |
    JSL $04DD9E         ; $10DCCF   |
    JSL $0397DF         ; $10DCD3   |

    REP #$20            ; $10DCD7   |
    LDX #$A908          ; $10DCD9   |
    SBC $4422B1         ; $10DCDC   |
    DEC $A57E,x         ; $10DCE0   |
    AND $4185,y         ; $10DCE3   |
    STA $6098           ; $10DCE6   |
    SEP #$20            ; $10DCE9   |
    JSR CODE_10DDC3     ; $10DCEB   |
    PLB                 ; $10DCEE   |
    RTL                 ; $10DCEF   |

    LDA $30             ; $10DCF0   |
    AND #$01            ; $10DCF2   |
    BNE CODE_10DD4B     ; $10DCF4   |
    REP #$20            ; $10DCF6   |
    LDA $0C23           ; $10DCF8   |
    CMP #$0100          ; $10DCFB   |
    BCS CODE_10DD01     ; $10DCFE   |
    INC A               ; $10DD00   |

CODE_10DD01:
    STA $0C23           ; $10DD01   |
    STA $3D             ; $10DD04   |
    STA $6096           ; $10DD06   |
    SEP #$20            ; $10DD09   |
    INC $0D29           ; $10DD0B   |
    LDA $0D29           ; $10DD0E   |
    AND #$07            ; $10DD11   |
    BNE CODE_10DD4B     ; $10DD13   |
    LDA $70336C         ; $10DD15   |
    CMP #$20            ; $10DD19   |
    BCC CODE_10DD30     ; $10DD1B   |
    LDA #$00            ; $10DD1D   |
    STA $70336C         ; $10DD1F   |
    INC $0D27           ; $10DD23   |
    INC $0D0F           ; $10DD26   |
    LDA #$30            ; $10DD29   |
    STA $0D29           ; $10DD2B   |
    BRA CODE_10DD4B     ; $10DD2E   |

CODE_10DD30:
    REP #$20            ; $10DD30   |
    LDA #$2D6C          ; $10DD32   |
    STA $70336E         ; $10DD35   |
    LDA #$2F6C          ; $10DD39   |
    STA $703370         ; $10DD3C   |
    LDX #$08            ; $10DD40   |
    LDA #$B4A9          ; $10DD42   |
    JSL $7EDE44         ; $10DD45   | GSU init
    SEP #$20            ; $10DD49   |

CODE_10DD4B:
    RTS                 ; $10DD4B   |

    LDA #$22            ; $10DD4C   |
    STA $704070         ; $10DD4E   |
    JSR CODE_10DD88     ; $10DD52   |
    LDA $0D0F           ; $10DD55   |
    BNE CODE_10DD5F     ; $10DD58   |
    LDA #$40            ; $10DD5A   |
    STA $0D29           ; $10DD5C   |

CODE_10DD5F:
    RTS                 ; $10DD5F   |

    RTS                 ; $10DD60   |

    INC $0D0F           ; $10DD61   |
    LDA #$23            ; $10DD64   |
    STA $704070         ; $10DD66   |
    INC $0D27           ; $10DD6A   |
    RTS                 ; $10DD6D   |

    JSR CODE_10DD88     ; $10DD6E   |
    LDA $0D0F           ; $10DD71   |
    BNE CODE_10DD7B     ; $10DD74   |
    LDA #$30            ; $10DD76   |
    STA $0D29           ; $10DD78   |

CODE_10DD7B:
    RTS                 ; $10DD7B   |

    DEC $0D29           ; $10DD7C   |
    BNE CODE_10DD87     ; $10DD7F   |
    STZ $0D29           ; $10DD81   |
    INC $0D27           ; $10DD84   |

CODE_10DD87:
    RTS                 ; $10DD87   |

CODE_10DD88:
    JSL $01DE5A         ; $10DD88   |
    LDA #$20            ; $10DD8C   |
    TSB $094A           ; $10DD8E   |
    LDA #$00            ; $10DD91   |
    STA $61AE           ; $10DD93   |
    STA $61B0           ; $10DD96   |
    LDA $0D0F           ; $10DD99   |
    BNE CODE_10DDA9     ; $10DD9C   |
    INC $0D27           ; $10DD9E   |
    LDA $094A           ; $10DDA1   |
    EOR #$20            ; $10DDA4   |
    STA $094A           ; $10DDA6   |

CODE_10DDA9:
    RTS                 ; $10DDA9   |

; gsu table
DATA_10DDAA:         db $00, $40, $01, $57, $07, $00, $00, $01
DATA_10DDB2:         db $B7, $07, $00, $80, $02, $00, $08, $00
DATA_10DDBA:         db $80, $01, $47, $07, $00, $00, $02, $00
DATA_10DDC2:         db $08

CODE_10DDC3:
    REP #$20            ; $10DDC3   |
    LDA #$0000          ; $10DDC5   |
    STA $3002           ; $10DDC8   |
    STA $6000           ; $10DDCB   |
    STA $3016           ; $10DDCE   |
    LDA $3B             ; $10DDD1   |
    STA $3004           ; $10DDD3   |
    LDA #$DDAA          ; $10DDD6   |
    STA $3006           ; $10DDD9   |
    LDA #$0010          ; $10DDDC   |
    STA $3008           ; $10DDDF   |
    LDA #$385E          ; $10DDE2   |
    STA $3014           ; $10DDE5   |
    LDX #$08            ; $10DDE8   |
    LDA #$DC4D          ; $10DDEA   |
    JSL $7EDE44         ; $10DDED   | GSU init
    LDA #$01A4          ; $10DDF1   |
    JSL $00BE71         ; $10DDF4   |

DATA_10DDF8:         dw $552C, $5E7E, $7038

    LDA #$0000          ; $10DDFE   |
    STA $3002           ; $10DE01   |
    STA $6000           ; $10DE04   |
    STA $3016           ; $10DE07   |
    LDA $3F             ; $10DE0A   |
    STA $3004           ; $10DE0C   |
    LDA #$DDB9          ; $10DE0F   |
    STA $3006           ; $10DE12   |
    LDA #$0010          ; $10DE15   |
    STA $3008           ; $10DE18   |
    LDA #$3516          ; $10DE1B   |
    STA $3014           ; $10DE1E   |
    LDX #$08            ; $10DE21   |
    LDA #$DC4D          ; $10DE23   |
    JSL $7EDE44         ; $10DE26   | GSU init
    LDA #$01A4          ; $10DE2A   |
    JSL $00BE71         ; $10DE2D   |

DATA_10DE31:         dw $5040, $167E, $7035

    SEP #$20            ; $10DE37   |
    LDA #$C0            ; $10DE39   |
    TSB $094A           ; $10DE3B   |
    RTS                 ; $10DE3E   |

.gamemode3F
    JSL $008277         ; $10DE3F   |
    JSL $00831C         ; $10DE43   |
    JSL $0394B8         ; $10DE47   |
    JSL $008259         ; $10DE4B   |

    LDX #$04            ; $10DE4F   |
    JSL $00BDA2         ; $10DE51   |
    LDA #$10            ; $10DE55   |
    STA $0967           ; $10DE57   |
    STZ $0968           ; $10DE5A   |
    LDA #$22            ; $10DE5D   |
    STA $094B           ; $10DE5F   |
    STA $2101           ; $10DE62   |
    STZ $094A           ; $10DE65   |
    REP #$20            ; $10DE68   |
    LDA #$4986          ; $10DE6A   |
    STA $704096         ; $10DE6D   |
    LDA #$0051          ; $10DE71   |
    STA $704098         ; $10DE74   |
    LDX #$09            ; $10DE78   |
    LDA #$B03E          ; $10DE7A   |
    JSL $7EDE44         ; $10DE7D   | GSU init
    LDA #$4000          ; $10DE81   |
    STA $2116           ; $10DE84   |
    LDA #$1801          ; $10DE87   |
    STA $4300           ; $10DE8A   |
    LDA #$5800          ; $10DE8D   |
    STA $4302           ; $10DE90   |
    LDY #$70            ; $10DE93   |
    STY $4304           ; $10DE95   |
    LDA #$2000          ; $10DE98   |
    STA $4305           ; $10DE9B   |
    LDX #$01            ; $10DE9E   |
    STX $420B           ; $10DEA0   |
    LDA #$0000          ; $10DEA3   |
    STA $0948           ; $10DEA6   |
    STA $702000         ; $10DEA9   |
    TAX                 ; $10DEAD   |

CODE_10DEAE:
    STA $702120,x       ; $10DEAE   |
    INX                 ; $10DEB2   |
    INX                 ; $10DEB3   |
    CPX #$20            ; $10DEB4   |
    BCC CODE_10DEAE     ; $10DEB6   |
    LDA #$0000          ; $10DEB8   |
    STA $70336C         ; $10DEBB   |
    LDX #$00            ; $10DEBF   |

CODE_10DEC1:
    STZ $0134,x         ; $10DEC1   |
    INX                 ; $10DEC4   |
    INX                 ; $10DEC5   |
    CPX #$1C            ; $10DEC6   |
    BCC CODE_10DEC1     ; $10DEC8   |
    LDX #$00            ; $10DECA   |

CODE_10DECC:
    STZ $6C00,x         ; $10DECC   |
    STZ $6D00,x         ; $10DECF   |
    STZ $6D20,x         ; $10DED2   |
    DEX                 ; $10DED5   |
    DEX                 ; $10DED6   |
    BNE CODE_10DECC     ; $10DED7   |
    LDA #$0018          ; $10DED9   |
    STA $A1             ; $10DEDC   |
    LDA #$0060          ; $10DEDE   |
    STA $B1             ; $10DEE1   |
    LDX #$00            ; $10DEE3   |

CODE_10DEE5:
    LDA $B1,x           ; $10DEE5   |
    STA $B3,x           ; $10DEE7   |
    LDA $A1,x           ; $10DEE9   |
    CLC                 ; $10DEEB   |
    ADC #$0018          ; $10DEEC   |
    STA $A3,x           ; $10DEEF   |
    INX                 ; $10DEF1   |
    INX                 ; $10DEF2   |
    CPX #$08            ; $10DEF3   |
    BCC CODE_10DEE5     ; $10DEF5   |
    CLC                 ; $10DEF7   |
    ADC #$0010          ; $10DEF8   |
    STA $A1,x           ; $10DEFB   |

CODE_10DEFD:
    LDA $B1,x           ; $10DEFD   |
    STA $B3,x           ; $10DEFF   |
    LDA $A1,x           ; $10DF01   |
    CLC                 ; $10DF03   |
    ADC #$0018          ; $10DF04   |
    STA $A3,x           ; $10DF07   |
    INX                 ; $10DF09   |
    INX                 ; $10DF0A   |
    CPX #$0E            ; $10DF0B   |
    BCC CODE_10DEFD     ; $10DF0D   |
    STZ $C3             ; $10DF0F   |
    LDA #$0800          ; $10DF11   |
    STA $C5             ; $10DF14   |
    LDA #$0100          ; $10DF16   |
    STA $C8             ; $10DF19   |
    LDX #$07            ; $10DF1B   |

CODE_10DF1D:
    LDA #$FFFF          ; $10DF1D   |

CODE_10DF20:
    DEC A               ; $10DF20   |
    BNE CODE_10DF20     ; $10DF21   |
    DEX                 ; $10DF23   |
    BNE CODE_10DF1D     ; $10DF24   |
    SEP #$20            ; $10DF26   |
    LDA #$02            ; $10DF28   |
    STA $0125           ; $10DF2A   |
    STZ $094A           ; $10DF2D   |
    LDA #$50            ; $10DF30   |
    STA $4207           ; $10DF32   |
    LDA #$D8            ; $10DF35   |
    STA $4209           ; $10DF37   |
    LDA #$B1            ; $10DF3A   |
    STA $4200           ; $10DF3C   |
    LDA #$04            ; $10DF3F   |
    STA $004D           ; $10DF41   |
    INC $0118           ; $10DF44   |
    BRA CODE_10DF5C     ; $10DF47   |

DATA_10DF49:         dw $DF6B
DATA_10DF4B:         dw $DF82
DATA_10DF4D:         dw $DFBB
DATA_10DF4F:         dw $E17C
DATA_10DF51:         dw $E199

.gamemode40
    JSL $008259         ; $10DF53   |
    LDX $8F             ; $10DF57   |
    JSR ($DF49,x)       ; $10DF59   |

CODE_10DF5C:
    REP #$20            ; $10DF5C   |
    LDX #$08            ; $10DF5E   |
    LDA #$B1EF          ; $10DF60   |
    JSL $7EDE44         ; $10DF63   | GSU init
    SEP #$20            ; $10DF67   |
    PLB                 ; $10DF69   |
    RTL                 ; $10DF6A   |

    REP #$20            ; $10DF6B   |
    INC $00CA           ; $10DF6D   |
    LDA $00CA           ; $10DF70   |
    CMP #$0200          ; $10DF73   |
    BCC CODE_10DF7C     ; $10DF76   |
    INC $8F             ; $10DF78   |
    INC $8F             ; $10DF7A   |

CODE_10DF7C:
    SEP #$20            ; $10DF7C   |
    JSR CODE_10DFE7     ; $10DF7E   |
    RTS                 ; $10DF81   |

    REP #$20            ; $10DF82   |
    LDA $702126         ; $10DF84   |
    CLC                 ; $10DF88   |
    ADC #$0842          ; $10DF89   |
    BPL CODE_10DF95     ; $10DF8C   |
    INC $8F             ; $10DF8E   |
    INC $8F             ; $10DF90   |
    LDA #$7FFF          ; $10DF92   |

CODE_10DF95:
    STA $702126         ; $10DF95   |
    SEP #$20            ; $10DF99   |
    JSR CODE_10DFE7     ; $10DF9B   |
    RTS                 ; $10DF9E   |

DATA_10DF9F:         db $15, $01, $16, $04, $17, $18, $04, $19

DATA_10DFA7:         db $10, $30, $50, $70, $10, $30, $50, $70

DATA_10DFAF:         db $50, $50, $50, $50, $70, $70, $70, $70

DATA_10DFB7:         db $43, $00, $2E, $00

    LDA $37             ; $10DFBB   |
    AND #$C0            ; $10DFBD   |
    ORA $38             ; $10DFBF   |
    AND #$D0            ; $10DFC1   |
    BEQ CODE_10DFD5     ; $10DFC3   |
    INC $8F             ; $10DFC5   |
    INC $8F             ; $10DFC7   |
    LDA #$5C            ; $10DFC9   |
    LDX $00C3           ; $10DFCB   |
    LDA $DFB7,x         ; $10DFCE   |
    STA $53             ; $10DFD1   |
    BRA CODE_10DFE7     ; $10DFD3   |

CODE_10DFD5:
    LDA $38             ; $10DFD5   |
    AND #$03            ; $10DFD7   |
    BEQ CODE_10DFE7     ; $10DFD9   |
    LDA $C3             ; $10DFDB   |
    EOR #$02            ; $10DFDD   |
    AND #$02            ; $10DFDF   |
    STA $C3             ; $10DFE1   |
    LDA #$5C            ; $10DFE3   |
    STA $53             ; $10DFE5   |

CODE_10DFE7:
    REP #$20            ; $10DFE7   |
    LDA #$6800          ; $10DFE9   |
    STA $3002           ; $10DFEC   |
    LDA #$0800          ; $10DFEF   |
    STA $3018           ; $10DFF2   |
    LDX #$08            ; $10DFF5   |
    LDA #$D2F1          ; $10DFF7   |
    JSL $7EDE44         ; $10DFFA   | GSU init
    LDX #$00            ; $10DFFE   |
    LDY #$07            ; $10E000   |

CODE_10E002:
    LDA $DF9F,y         ; $10E002   |
    AND #$00FF          ; $10E005   |
    STA $3002           ; $10E008   |
    LDA $91,x           ; $10E00B   |
    AND #$00FF          ; $10E00D   |
    STA $3004           ; $10E010   |
    LDA $99,x           ; $10E013   |
    AND #$00FF          ; $10E015   |
    STA $3006           ; $10E018   |
    LDA $DFA7,y         ; $10E01B   |
    AND #$00FF          ; $10E01E   |
    STA $3008           ; $10E021   |
    LDA $DFAF,y         ; $10E024   |
    AND #$00FF          ; $10E027   |
    STA $300A           ; $10E02A   |
    LDA $C1             ; $10E02D   |
    STA $300C           ; $10E02F   |
    PHY                 ; $10E032   |
    PHX                 ; $10E033   |
    LDX #$08            ; $10E034   |
    LDA #$F165          ; $10E036   |
    JSL $7EDE44         ; $10E039   | GSU init
    PLX                 ; $10E03D   |
    PLY                 ; $10E03E   |
    INX                 ; $10E03F   |
    DEY                 ; $10E040   |
    BPL CODE_10E002     ; $10E041   |
    REP #$10            ; $10E043   |
    LDY #$5000          ; $10E045   |
    LDA #$0070          ; $10E048   |
    STA $01             ; $10E04B   |
    LDA #$1000          ; $10E04D   |
    LDX #$6800          ; $10E050   |
    JSL $00BEA6         ; $10E053   |
    LDA #$3100          ; $10E057   |
    STA $04             ; $10E05A   |
    LDX #$0000          ; $10E05C   |
    LDY $6092           ; $10E05F   |

CODE_10E062:
    LDA $A1,x           ; $10E062   |
    STA $6000,y         ; $10E064   |
    LDA $B1,x           ; $10E067   |
    STA $6002,y         ; $10E069   |
    LDA $04             ; $10E06C   |
    STA $6004,y         ; $10E06E   |
    LDA #$4002          ; $10E071   |
    STA $6006,y         ; $10E074   |
    LDA $04             ; $10E077   |
    INC A               ; $10E079   |
    INC A               ; $10E07A   |
    INC A               ; $10E07B   |
    INC A               ; $10E07C   |
    BIT #$000F          ; $10E07D   |
    BNE CODE_10E085     ; $10E080   |
    LDA #$3140          ; $10E082   |

CODE_10E085:
    STA $04             ; $10E085   |
    INX                 ; $10E087   |
    INX                 ; $10E088   |
    TYA                 ; $10E089   |
    CLC                 ; $10E08A   |
    ADC #$0008          ; $10E08B   |
    TAY                 ; $10E08E   |
    CPY #$0240          ; $10E08F   |
    BCC CODE_10E062     ; $10E092   |
    JSR CODE_10E0FB     ; $10E094   |
    STY $6092           ; $10E097   |
    SEP #$10            ; $10E09A   |
    LDA $C1             ; $10E09C   |
    CMP #$0030          ; $10E09E   |
    BCS CODE_10E0A8     ; $10E0A1   |
    INC A               ; $10E0A3   |
    STA $C1             ; $10E0A4   |
    BRA CODE_10E0F4     ; $10E0A6   |

CODE_10E0A8:
    SEP #$20            ; $10E0A8   |
    LDX #$00            ; $10E0AA   |
    STZ $00             ; $10E0AC   |

CODE_10E0AE:
    LDA $C6             ; $10E0AE   |
    BNE CODE_10E0B8     ; $10E0B0   |
    LDA $91,x           ; $10E0B2   |
    BEQ CODE_10E0C1     ; $10E0B4   |
    LDA #$01            ; $10E0B6   |

CODE_10E0B8:
    CLC                 ; $10E0B8   |
    ADC $91,x           ; $10E0B9   |
    STA $91,x           ; $10E0BB   |
    ORA $00             ; $10E0BD   |
    STA $00             ; $10E0BF   |

CODE_10E0C1:
    LDA $C6             ; $10E0C1   |
    BNE CODE_10E0CB     ; $10E0C3   |
    LDA $99,x           ; $10E0C5   |
    BEQ CODE_10E0D0     ; $10E0C7   |
    LDA #$01            ; $10E0C9   |

CODE_10E0CB:
    CLC                 ; $10E0CB   |
    ADC $99,x           ; $10E0CC   |
    STA $99,x           ; $10E0CE   |

CODE_10E0D0:
    INX                 ; $10E0D0   |
    CPX #$08            ; $10E0D1   |
    BCC CODE_10E0AE     ; $10E0D3   |
    REP #$20            ; $10E0D5   |
    LDA $C5             ; $10E0D7   |
    SEC                 ; $10E0D9   |
    SBC #$0010          ; $10E0DA   |
    BPL CODE_10E0F2     ; $10E0DD   |
    LDA #$0000          ; $10E0DF   |
    LDX $00             ; $10E0E2   |
    BNE CODE_10E0F4     ; $10E0E4   |
    DEC $C8             ; $10E0E6   |
    BNE CODE_10E0F2     ; $10E0E8   |
    LDA #$0100          ; $10E0EA   |
    STA $C8             ; $10E0ED   |
    LDA #$0800          ; $10E0EF   |

CODE_10E0F2:
    STA $C5             ; $10E0F2   |

CODE_10E0F4:
    SEP #$20            ; $10E0F4   |
    RTS                 ; $10E0F6   |

DATA_10E0F7:         dw $0050, $007E

CODE_10E0FB:
    LDX $C3             ; $10E0FB   |
    LDA $E0F7,x         ; $10E0FD   |
    STA $6000,y         ; $10E100   |
    STA $6008,y         ; $10E103   |
    LDA #$00C0          ; $10E106   |
    STA $6002,y         ; $10E109   |
    STA $6012,y         ; $10E10C   |
    CLC                 ; $10E10F   |
    ADC #$0008          ; $10E110   |
    STA $600A,y         ; $10E113   |
    LDA #$32A0          ; $10E116   |
    STA $6004,y         ; $10E119   |
    ORA #$0010          ; $10E11C   |
    STA $600C,y         ; $10E11F   |
    LDA #$4000          ; $10E122   |
    STA $6006,y         ; $10E125   |
    STA $600E,y         ; $10E128   |
    TYA                 ; $10E12B   |
    CLC                 ; $10E12C   |
    ADC #$0010          ; $10E12D   |
    TAY                 ; $10E130   |
    LDA #$0048          ; $10E131   |
    STA $00             ; $10E134   |
    LDA #$3220          ; $10E136   |
    STA $02             ; $10E139   |
    LDX #$0006          ; $10E13B   |

CODE_10E13E:
    LDA $00             ; $10E13E   |
    STA $6000,y         ; $10E140   |
    STA $6008,y         ; $10E143   |
    CLC                 ; $10E146   |
    ADC #$0010          ; $10E147   |
    STA $00             ; $10E14A   |
    LDA #$0090          ; $10E14C   |
    STA $6002,y         ; $10E14F   |
    CLC                 ; $10E152   |
    ADC #$0020          ; $10E153   |
    STA $600A,y         ; $10E156   |
    LDA $02             ; $10E159   |
    STA $6004,y         ; $10E15B   |
    CLC                 ; $10E15E   |
    ADC #$0040          ; $10E15F   |
    STA $600C,y         ; $10E162   |
    LDA #$4002          ; $10E165   |
    STA $6006,y         ; $10E168   |
    STA $600E,y         ; $10E16B   |
    INC $02             ; $10E16E   |
    INC $02             ; $10E170   |
    TYA                 ; $10E172   |
    CLC                 ; $10E173   |
    ADC #$0010          ; $10E174   |
    TAY                 ; $10E177   |
    DEX                 ; $10E178   |
    BNE CODE_10E13E     ; $10E179   |
    RTS                 ; $10E17B   |

    JSR CODE_10DFE7     ; $10E17C   |
    LDA $C3             ; $10E17F   |
    BNE CODE_10E18F     ; $10E181   |
    LDA #$1F            ; $10E183   |
    STA $0118           ; $10E185   |
    LDA #$03            ; $10E188   |
    STA $0379           ; $10E18A   |
    BRA CODE_10E198     ; $10E18D   |

CODE_10E18F:
    DEC $0200           ; $10E18F   |
    BNE CODE_10E198     ; $10E192   |
    INC $8F             ; $10E194   |
    INC $8F             ; $10E196   |

CODE_10E198:
    RTS                 ; $10E198   |

    STZ $4200           ; $10E199   |
    LDX #$10            ; $10E19C   |
    JSL $008543         ; $10E19E   |
    STZ $011A           ; $10E1A2   |
    LDA #$80            ; $10E1A5   |
    STA $012B           ; $10E1A7   |
    STZ $0216           ; $10E1AA   |
    STZ $0217           ; $10E1AD   |
    STZ $0200           ; $10E1B0   |
    STZ $0201           ; $10E1B3   |
    LDA #$09            ; $10E1B6   |
    STA $0118           ; $10E1B8   |
    LDA #$B1            ; $10E1BB   |
    STA $4200           ; $10E1BD   |
    RTS                 ; $10E1C0   |

    LDA #$FF            ; $10E1C1   |
    STA $011A           ; $10E1C3   |
    LDA #$0C            ; $10E1C6   |
    STA $0218           ; $10E1C8   |
    INC $0216           ; $10E1CB   |
    JML $1083E2         ; $10E1CE   |

DATA_10E1D2:         dw $5000, $47FF, $0000, $FFFF

    LDA #$24            ; $10E1DA   |
    JSL $008279         ; $10E1DC   |
    JSL $00831C         ; $10E1E0   |
    REP #$10            ; $10E1E4   |
    LDY #$01C3          ; $10E1E6   |
    JSL $00B3EE         ; $10E1E9   |
    SEP #$20            ; $10E1ED   |
    LDA #$81            ; $10E1EF   |
    STA $2115           ; $10E1F1   |
    REP #$30            ; $10E1F4   |
    LDA #$5084          ; $10E1F6   |
    STA $00             ; $10E1F9   |
    LDX #$0000          ; $10E1FB   |
    LDA #$0018          ; $10E1FE   |
    STA $02             ; $10E201   |

CODE_10E203:
    LDA $00             ; $10E203   |
    STA $2116           ; $10E205   |
    LDY #$0010          ; $10E208   |

CODE_10E20B:
    STX $2118           ; $10E20B   |
    INX                 ; $10E20E   |
    DEY                 ; $10E20F   |
    BNE CODE_10E20B     ; $10E210   |
    INC $00             ; $10E212   |
    DEC $02             ; $10E214   |
    BNE CODE_10E203     ; $10E216   |
    LDX #$01FE          ; $10E218   |

CODE_10E21B:
    LDA $5FEE4A,x       ; $10E21B   |
    STA $701600,x       ; $10E21F   |
    STA $701800,x       ; $10E223   |
    DEX                 ; $10E227   |
    DEX                 ; $10E228   |
    BPL CODE_10E21B     ; $10E229   |
    LDX #$0006          ; $10E22B   |

CODE_10E22E:
    LDA $7017C2,x       ; $10E22E   |
    STA $0B93,x         ; $10E232   |
    LDA $7017E2,x       ; $10E235   |
    STA $0B9B,x         ; $10E239   |
    DEX                 ; $10E23C   |
    DEX                 ; $10E23D   |
    BPL CODE_10E22E     ; $10E23E   |
    PHB                 ; $10E240   |\
    LDY #$1200          ; $10E241   | |
    LDX #$E552          ; $10E244   | | move $00E552~$00E952 to $701200~$7015FF
    LDA #$03FF          ; $10E247   | |
    MVN 00 70           ; $10E24A   | |
    PLB                 ; $10E24D   |/
    SEP #$30            ; $10E24E   |
    LDX #$26            ; $10E250   |
    JSL $00BDA2         ; $10E252   |
    STZ $210D           ; $10E256   |
    STZ $210D           ; $10E259   |
    STZ $210E           ; $10E25C   |
    STZ $210E           ; $10E25F   |
    STZ $210F           ; $10E262   |
    STZ $210F           ; $10E265   |
    STZ $2110           ; $10E268   |
    STZ $2110           ; $10E26B   |
    LDA #$03            ; $10E26E   |
    STA $094B           ; $10E270   |
    STA $2101           ; $10E273   |
    REP #$30            ; $10E276   |
    LDX #$0402          ; $10E278   |

CODE_10E27B:
    LDA $EA44,x         ; $10E27B   |
    STA $6CAA,x         ; $10E27E   |
    DEX                 ; $10E281   |
    DEX                 ; $10E282   |
    BPL CODE_10E27B     ; $10E283   |
    LDA #$00C0          ; $10E285   |
    STA $82             ; $10E288   |
    LDA #$0CAA          ; $10E28A   |
    STA $7B             ; $10E28D   |
    SEP #$10            ; $10E28F   |
    LDA #$FFB0          ; $10E291   |
    STA $73             ; $10E294   |
    STZ $71             ; $10E296   |
    LDA #$0030          ; $10E298   |
    STA $0B91           ; $10E29B   |
    LDA #$0008          ; $10E29E   |
    STA $7E             ; $10E2A1   |
    LDA #$03FC          ; $10E2A3   |
    STA $80             ; $10E2A6   |
    LDA #$0009          ; $10E2A8   |
    STA $88             ; $10E2AB   |
    JSR CODE_10E430     ; $10E2AD   |
    LDA #$0000          ; $10E2B0   |
    STA $3002           ; $10E2B3   |
    LDA $73             ; $10E2B6   |
    STA $3004           ; $10E2B8   |
    LDA $71             ; $10E2BB   |
    STA $3006           ; $10E2BD   |
    LDA $7B             ; $10E2C0   |
    STA $300A           ; $10E2C2   |
    LDX #$09            ; $10E2C5   |
    LDA #$F03E          ; $10E2C7   |
    JSL $7EDE44         ; $10E2CA   | GSU init
    LDX #$80            ; $10E2CE   |
    STX $2115           ; $10E2D0   |
    LDA #$0000          ; $10E2D3   |
    STA $2116           ; $10E2D6   |
    LDA #$1801          ; $10E2D9   |
    STA $4300           ; $10E2DC   |
    LDA #$1C00          ; $10E2DF   |
    STA $4302           ; $10E2E2   |
    LDX #$70            ; $10E2E5   |
    STX $4304           ; $10E2E7   |
    LDA #$6000          ; $10E2EA   |
    STA $4305           ; $10E2ED   |
    LDX #$01            ; $10E2F0   |
    STX $420B           ; $10E2F2   |
    JSR CODE_10E430     ; $10E2F5   |
    LDX $012E           ; $10E2F8   |
    PHX                 ; $10E2FB   |
    LDX #$3D            ; $10E2FC   |
    STX $012E           ; $10E2FE   |
    LDX #$09            ; $10E301   |
    LDA #$ECD8          ; $10E303   |
    JSL $7EDE44         ; $10E306   | GSU init
    PLX                 ; $10E30A   |
    STX $012E           ; $10E30B   |
    LDA #$7000          ; $10E30E   |
    STA $2116           ; $10E311   |
    LDA #$1801          ; $10E314   |
    STA $4300           ; $10E317   |
    LDA #$1C00          ; $10E31A   |
    STA $4302           ; $10E31D   |
    LDX #$70            ; $10E320   |
    STX $4304           ; $10E322   |
    LDA #$2000          ; $10E325   |
    STA $4305           ; $10E328   |
    LDX #$01            ; $10E32B   |
    STX $420B           ; $10E32D   |
    SEP #$20            ; $10E330   |
    LDX #$13            ; $10E332   |
    JSL $008543         ; $10E334   |
    LDA #$01            ; $10E338   |
    STA $4D             ; $10E33A   |
    LDA #$50            ; $10E33C   |
    STA $4207           ; $10E33E   |
    LDA #$01            ; $10E341   |
    STA $4208           ; $10E343   |
    LDA #$D8            ; $10E346   |
    STA $4209           ; $10E348   |
    LDA #$B1            ; $10E34B   |
    STA $4200           ; $10E34D   |
    STZ $0200           ; $10E350   |
    JML $1083E2         ; $10E353   |

    LDA $8C             ; $10E357   |
    AND #$03            ; $10E359   |
    BNE CODE_10E360     ; $10E35B   |
    INC $0200           ; $10E35D   |

CODE_10E360:
    REP #$20            ; $10E360   |
    INC $8C             ; $10E362   |
    LDA $0200           ; $10E364   |
    AND #$00FF          ; $10E367   |
    CMP #$000F          ; $10E36A   |
    BCC CODE_10E3DD     ; $10E36D   |
    STZ $71AA           ; $10E36F   |
    INC $0118           ; $10E372   |
    LDA $0201           ; $10E375   |
    EOR #$0001          ; $10E378   |
    AND #$0001          ; $10E37B   |
    STA $0201           ; $10E37E   |
    STZ $8C             ; $10E381   |
    BRA CODE_10E3DD     ; $10E383   |

DATA_10E385:         dw $E44F
DATA_10E387:         dw $E478
DATA_10E389:         dw $E4B0
DATA_10E38B:         dw $E530
DATA_10E38D:         dw $E592
DATA_10E38F:         dw $E5A8
DATA_10E391:         dw $E624
DATA_10E393:         dw $E66B
DATA_10E395:         dw $E692
DATA_10E397:         dw $E6C7
DATA_10E399:         dw $E592
DATA_10E39B:         dw $E5A8
DATA_10E39D:         dw $E6E7
DATA_10E39F:         dw $E724
DATA_10E3A1:         dw $E735
DATA_10E3A3:         dw $E7AF
DATA_10E3A5:         dw $E7F1
DATA_10E3A7:         dw $E807
DATA_10E3A9:         dw $E7F1
DATA_10E3AB:         dw $E855
DATA_10E3AD:         dw $E7F1
DATA_10E3AF:         dw $E575
DATA_10E3B1:         dw $E8B8
DATA_10E3B3:         dw $E592
DATA_10E3B5:         dw $E5A8
DATA_10E3B7:         dw $E575
DATA_10E3B9:         dw $E8FB
DATA_10E3BB:         dw $E575
DATA_10E3BD:         dw $E922
DATA_10E3BF:         dw $E592
DATA_10E3C1:         dw $E5A8
DATA_10E3C3:         dw $E90C
DATA_10E3C5:         dw $E975
DATA_10E3C7:         dw $E992
DATA_10E3C9:         dw $E96B

    REP #$20            ; $10E3CB   |
    INC $8C             ; $10E3CD   |
    LDA $0BD3           ; $10E3CF   |
    BNE CODE_10E42C     ; $10E3D2   |
    LDX $79             ; $10E3D4   |
    CPX #$46            ; $10E3D6   |
    BCS CODE_10E3DD     ; $10E3D8   |
    JSR ($E385,x)       ; $10E3DA   |

CODE_10E3DD:
    LDA $79             ; $10E3DD   |
    CMP #$0034          ; $10E3DF   |
    BCS CODE_10E42C     ; $10E3E2   |
    LDA $0BD3           ; $10E3E4   |
    BNE CODE_10E42C     ; $10E3E7   |
    JSR CODE_10E430     ; $10E3E9   |
    LDA $6F             ; $10E3EC   |
    CLC                 ; $10E3EE   |
    ADC $7E             ; $10E3EF   |
    AND #$03FF          ; $10E3F1   |
    STA $6F             ; $10E3F4   |
    LDA $79             ; $10E3F6   |
    CMP #$0014          ; $10E3F8   |
    BCS CODE_10E400     ; $10E3FB   |
    JSR CODE_10E9C9     ; $10E3FD   |

CODE_10E400:
    LDA $77             ; $10E400   |
    BEQ CODE_10E408     ; $10E402   |
    CLC                 ; $10E404   |
    ADC #$0300          ; $10E405   |

CODE_10E408:
    CLC                 ; $10E408   |
    ADC $6F             ; $10E409   |
    STA $3002           ; $10E40B   |
    LDA $73             ; $10E40E   |
    STA $3004           ; $10E410   |
    LDA $71             ; $10E413   |
    STA $3006           ; $10E415   |
    LDA $7B             ; $10E418   |
    STA $300A           ; $10E41A   |
    LDX #$09            ; $10E41D   |
    LDA #$F03E          ; $10E41F   |
    JSL $7EDE44         ; $10E422   | GSU init
    SEP #$20            ; $10E426   |
    LDA #$03            ; $10E428   |
    STA $6B             ; $10E42A   |

CODE_10E42C:
    SEP #$20            ; $10E42C   |
    PLB                 ; $10E42E   |
    RTL                 ; $10E42F   |

CODE_10E430:
    LDA #$1C00          ; $10E430   |
    STA $3000           ; $10E433   |
    LDA #$0002          ; $10E436   |
    STA $3002           ; $10E439   |
    STZ $3004           ; $10E43C   |
    LDA #$3000          ; $10E43F   |
    STA $3018           ; $10E442   |
    LDX #$08            ; $10E445   |
    LDA #$AA8B          ; $10E447   |
    JSL $7EDE44         ; $10E44A   | GSU init
    RTS                 ; $10E44E   |

    DEC $0B91           ; $10E44F   |
    BNE CODE_10E458     ; $10E452   |
    INC $79             ; $10E454   |
    INC $79             ; $10E456   |

CODE_10E458:
    RTS                 ; $10E458   |

DATA_10E459:         db $1E, $3E, $3E, $1E, $3E, $3E, $3E, $3E
DATA_10E461:         db $3E, $1E, $3E, $3E, $1E, $3E, $1E, $3E
DATA_10E469:         db $3E, $1E, $3E, $1E, $3E, $3E, $3E, $3E
DATA_10E471:         db $3E, $3E, $3E, $1E, $3E, $1E, $3E

    LDA $0B8F           ; $10E478   |
    BEQ CODE_10E482     ; $10E47B   |
    LDA #$000C          ; $10E47D   |
    BRA CODE_10E494     ; $10E480   |

CODE_10E482:
    LDA $0B8D           ; $10E482   |
    CMP #$001F          ; $10E485   |
    BCS CODE_10E49D     ; $10E488   |
    TAX                 ; $10E48A   |
    INC $0B8D           ; $10E48B   |
    LDA $E459,x         ; $10E48E   |
    AND #$00FF          ; $10E491   |

CODE_10E494:
    STA $0B91           ; $10E494   |
    DEC $79             ; $10E497   |
    DEC $79             ; $10E499   |
    BRA CODE_10E4A3     ; $10E49B   |

CODE_10E49D:
    INC $79             ; $10E49D   |
    INC $79             ; $10E49F   |
    BRA CODE_10E4AF     ; $10E4A1   |

CODE_10E4A3:
    LDA $0B8F           ; $10E4A3   |
    EOR #$0002          ; $10E4A6   |
    AND #$0002          ; $10E4A9   |
    STA $0B8F           ; $10E4AC   |

CODE_10E4AF:
    RTS                 ; $10E4AF   |

    LDA $0B8D           ; $10E4B0   |
    CMP #$001F          ; $10E4B3   |
    BCC CODE_10E4CB     ; $10E4B6   |
    LDA $6F             ; $10E4B8   |
    BNE CODE_10E4CB     ; $10E4BA   |
    INC $79             ; $10E4BC   |
    INC $79             ; $10E4BE   |
    INC $78             ; $10E4C0   |
    JSR CODE_10E4CC     ; $10E4C2   |
    JSR CODE_10E511     ; $10E4C5   |
    STZ $71AA           ; $10E4C8   |

CODE_10E4CB:
    RTS                 ; $10E4CB   |

CODE_10E4CC:
    REP #$10            ; $10E4CC   |
    LDA #$0000          ; $10E4CE   |
    TAX                 ; $10E4D1   |

CODE_10E4D2:
    STA $701A00,x       ; $10E4D2   |
    INX                 ; $10E4D6   |
    INX                 ; $10E4D7   |
    CPX #$0200          ; $10E4D8   |
    BNE CODE_10E4D2     ; $10E4DB   |
    LDX #$0006          ; $10E4DD   |

CODE_10E4E0:
    LDA $7019C2,x       ; $10E4E0   |
    STA $701BC2,x       ; $10E4E4   |
    LDA $7019E2,x       ; $10E4E8   |
    STA $701BE2,x       ; $10E4EC   |
    DEX                 ; $10E4F0   |
    DEX                 ; $10E4F1   |
    BPL CODE_10E4E0     ; $10E4F2   |
    SEP #$10            ; $10E4F4   |
    RTS                 ; $10E4F6   |

DATA_10E4F7:         dw $0000, $569C, $28F1, $0006
DATA_10E4FF:         dw $5B9F, $2DF6, $004D, $6FDF

DATA_10E507:         dw $0000, $679F, $1D51, $6FD9
DATA_10E50F:         dw $2144

CODE_10E511:
    LDX #$00            ; $10E511   |

CODE_10E513:
    LDA $E4F7,x         ; $10E513   |
    STA $701AA2,x       ; $10E516   |
    INX                 ; $10E51A   |
    INX                 ; $10E51B   |
    CPX #$10            ; $10E51C   |
    BCC CODE_10E513     ; $10E51E   |
    LDX #$00            ; $10E520   |

CODE_10E522:
    LDA $E507,x         ; $10E522   |
    STA $701AC2,x       ; $10E525   |
    INX                 ; $10E529   |
    INX                 ; $10E52A   |
    CPX #$0A            ; $10E52B   |
    BCC CODE_10E522     ; $10E52D   |
    RTS                 ; $10E52F   |

CODE_10E530:
    LDA $71AA           ; $10E530   |
    CMP #$0020          ; $10E533   |
    BCS CODE_10E555     ; $10E536   |
    LDA #$1800          ; $10E538   |
    STA $3002           ; $10E53B   |
    LDA #$1A00          ; $10E53E   |
    STA $3004           ; $10E541   |
    LDA #$1600          ; $10E544   |
    STA $3006           ; $10E547   |
    LDX #$09            ; $10E54A   |
    LDA #$F64E          ; $10E54C   |
    JSL $7EDE44         ; $10E54F   | GSU init
    BRA CODE_10E574     ; $10E553   |

CODE_10E555:
    INC $79             ; $10E555   |
    INC $79             ; $10E557   |
    STZ $71AA           ; $10E559   |
    PHB                 ; $10E55C   |
    LDX #$70            ; $10E55D   |
    PHX                 ; $10E55F   |
    PLB                 ; $10E560   |
    LDX #$00            ; $10E561   |

CODE_10E563:
    LDA $1600,x         ; $10E563   |
    STA $1800,x         ; $10E566   |
    LDA $1700,x         ; $10E569   |
    STA $1900,x         ; $10E56C   |
    INX                 ; $10E56F   |
    INX                 ; $10E570   |
    BNE CODE_10E563     ; $10E571   |
    PLB                 ; $10E573   |

CODE_10E574:
    RTS                 ; $10E574   |

CODE_10E575:
    JSR CODE_10E530     ; $10E575   |
    LDA $8C             ; $10E578   |
    AND #$0001          ; $10E57A   |
    BNE CODE_10E587     ; $10E57D   |
    LDA $71AA           ; $10E57F   |
    BEQ CODE_10E587     ; $10E582   |
    DEC $71AA           ; $10E584   |

CODE_10E587:
    RTS                 ; $10E587   |

DATA_10E588:         dw $01A7, $01A7, $021C, $021C
DATA_10E590:         dw $021C

    REP #$10            ; $10E592   |
    LDY $84             ; $10E594   |
    LDX $E588,y         ; $10E596   |
    LDA #$6000          ; $10E599   |
    BRA CODE_10E5B2     ; $10E59C   |

DATA_10E59E:         dw $01A7, $01AA, $01AA, $01AA
DATA_10E5A6:         dw $0039

    REP #$10            ; $10E5A8   |
    LDY $84             ; $10E5AA   |
    LDX $E59E,y         ; $10E5AC   |
    LDA #$6800          ; $10E5AF   |

CODE_10E5B2:
    STA $0BD5           ; $10E5B2   |
    LDA $06FC79,x       ; $10E5B5   |
    STA $3002           ; $10E5B9   |
    LDA $06FC7B,x       ; $10E5BC   |
    AND #$00FF          ; $10E5C0   |
    STA $3000           ; $10E5C3   |
    LDA #$0040          ; $10E5C6   |
    STA $3006           ; $10E5C9   |
    SEP #$10            ; $10E5CC   |
    LDX $012E           ; $10E5CE   |
    PHX                 ; $10E5D1   |
    LDX #$3D            ; $10E5D2   |
    STX $012E           ; $10E5D4   |
    LDX #$0A            ; $10E5D7   |
    LDA #$8000          ; $10E5D9   |
    JSL $7EDE44         ; $10E5DC   | GSU init
    PLX                 ; $10E5E0   |
    STX $012E           ; $10E5E1   |
    LDA #$1000          ; $10E5E4   |
    STA $0BD7           ; $10E5E7   |
    INC $0BD3           ; $10E5EA   |
    INC $79             ; $10E5ED   |
    INC $79             ; $10E5EF   |
    STZ $69             ; $10E5F1   |
    STZ $6B             ; $10E5F3   |
    RTS                 ; $10E5F5   |

DATA_10E5F6:         dw $00AB, $00AC, $00AD, $00AE

CODE_10E5FE:
    LDX $84             ; $10E5FE   |
    LDA $E5F6,x         ; $10E600   |
    LDX #$1C00          ; $10E603   |
    JSL $00B756         ; $10E606   |
    SEP #$10            ; $10E60A   |
    LDA #$5CA0          ; $10E60C   |
    STA $0BD5           ; $10E60F   |
    LDA #$0300          ; $10E612   |
    STA $0BD7           ; $10E615   |
    INC $0BD3           ; $10E618   |
    INC $84             ; $10E61B   |
    INC $84             ; $10E61D   |
    STZ $69             ; $10E61F   |
    STZ $6B             ; $10E621   |
    RTS                 ; $10E623   |

    REP #$10            ; $10E624   |
    LDX #$0000          ; $10E626   |

CODE_10E629:
    LDA $5FF04A,x       ; $10E629   |
    STA $701A00,x       ; $10E62D   |
    INX                 ; $10E631   |
    INX                 ; $10E632   |
    CPX #$0180          ; $10E633   |
    BCC CODE_10E629     ; $10E636   |
    LDX #$0006          ; $10E638   |

CODE_10E63B:
    LDA $EE48,x         ; $10E63B   |
    STA $6CAA,x         ; $10E63E   |
    DEX                 ; $10E641   |
    DEX                 ; $10E642   |
    BPL CODE_10E63B     ; $10E643   |
    JSR CODE_10E5FE     ; $10E645   |
    SEP #$10            ; $10E648   |
    LDA #$0000          ; $10E64A   |
    STA $82             ; $10E64D   |
    LDA #$0000          ; $10E64F   |
    STA $80             ; $10E652   |
    STZ $6F             ; $10E654   |
    STZ $73             ; $10E656   |
    STZ $77             ; $10E658   |
    STZ $7E             ; $10E65A   |
    LDA #$0060          ; $10E65C   |
    STA $75             ; $10E65F   |
    INC $79             ; $10E661   |
    INC $79             ; $10E663   |
    LDA #$FE30          ; $10E665   |
    STA $86             ; $10E668   |
    RTS                 ; $10E66A   |

    JSR CODE_10E575     ; $10E66B   |
    LDA $71AA           ; $10E66E   |
    CMP #$0018          ; $10E671   |
    BCC CODE_10E692     ; $10E674   |
    LDA $0B8D           ; $10E676   |
    CMP #$0020          ; $10E679   |
    BEQ CODE_10E692     ; $10E67C   |
    LDA $0B8F           ; $10E67E   |
    EOR #$0002          ; $10E681   |
    AND #$0002          ; $10E684   |
    STA $0B8F           ; $10E687   |
    INC $0B8D           ; $10E68A   |
    LDA #$000A          ; $10E68D   |
    STA $88             ; $10E690   |

CODE_10E692:
    SEP #$20            ; $10E692   |
    LDA $6CAD           ; $10E694   |
    INC A               ; $10E697   |
    STA $6CAD           ; $10E698   |
    REP #$20            ; $10E69B   |
    LDA $86             ; $10E69D   |
    BMI CODE_10E6BC     ; $10E69F   |
    CMP #$01B0          ; $10E6A1   |
    BCC CODE_10E6BC     ; $10E6A4   |
    JSR CODE_10E4CC     ; $10E6A6   |
    JSR CODE_10E511     ; $10E6A9   |
    INC $79             ; $10E6AC   |
    INC $79             ; $10E6AE   |
    LDA $0B8F           ; $10E6B0   |
    EOR #$0002          ; $10E6B3   |
    AND #$0002          ; $10E6B6   |
    STA $0B8F           ; $10E6B9   |

CODE_10E6BC:
    LDY $80             ; $10E6BC   |
    LDA $86             ; $10E6BE   |
    CLC                 ; $10E6C0   |
    ADC #$0008          ; $10E6C1   |
    STA $86             ; $10E6C4   |
    RTS                 ; $10E6C6   |

    SEP #$20            ; $10E6C7   |
    LDA $6CAD           ; $10E6C9   |
    INC A               ; $10E6CC   |
    STA $6CAD           ; $10E6CD   |
    LDA $6CAE           ; $10E6D0   |
    BEQ CODE_10E6D9     ; $10E6D3   |
    DEC A               ; $10E6D5   |
    STA $6CAE           ; $10E6D6   |

CODE_10E6D9:
    REP #$20            ; $10E6D9   |
    AND #$00FF          ; $10E6DB   |
    CMP #$0010          ; $10E6DE   |
    BCS CODE_10E6E6     ; $10E6E1   |
    JSR CODE_10E575     ; $10E6E3   |

CODE_10E6E6:
    RTS                 ; $10E6E6   |

    REP #$10            ; $10E6E7   |
    LDX #$0000          ; $10E6E9   |

CODE_10E6EC:
    LDA $5FF24A,x       ; $10E6EC   |
    STA $701A00,x       ; $10E6F0   |
    INX                 ; $10E6F4   |
    INX                 ; $10E6F5   |
    CPX #$0200          ; $10E6F6   |
    BCC CODE_10E6EC     ; $10E6F9   |
    LDX #$0048          ; $10E6FB   |

CODE_10E6FE:
    LDA $EE50,x         ; $10E6FE   |
    STA $6CAA,x         ; $10E701   |
    DEX                 ; $10E704   |
    DEX                 ; $10E705   |
    BPL CODE_10E6FE     ; $10E706   |
    JSR CODE_10E5FE     ; $10E708   |
    SEP #$10            ; $10E70B   |
    STZ $6F             ; $10E70D   |
    STZ $77             ; $10E70F   |
    STZ $7E             ; $10E711   |
    INC $79             ; $10E713   |
    INC $79             ; $10E715   |
    LDA #$0012          ; $10E717   |
    STA $80             ; $10E71A   |
    STZ $75             ; $10E71C   |
    LDA #$0002          ; $10E71E   |
    STA $4D             ; $10E721   |
    RTS                 ; $10E723   |

    JSR CODE_10E575     ; $10E724   |
    LDA $71AA           ; $10E727   |
    CMP #$0008          ; $10E72A   |
    BCS CODE_10E730     ; $10E72D   |
    RTS                 ; $10E72F   |

CODE_10E730:
    LDA #$0002          ; $10E730   |
    STA $7E             ; $10E733   |

    SEP #$20            ; $10E735   |
    LDA $6F             ; $10E737   |
    AND #$02            ; $10E739   |
    BNE CODE_10E761     ; $10E73B   |
    LDA $6CC4           ; $10E73D   |
    CLC                 ; $10E740   |
    ADC #$01            ; $10E741   |
    STA $6CC4           ; $10E743   |
    LDA $6CD0           ; $10E746   |
    SEC                 ; $10E749   |
    SBC #$01            ; $10E74A   |
    STA $6CD0           ; $10E74C   |
    LDA $6CDC           ; $10E74F   |
    CLC                 ; $10E752   |
    ADC #$01            ; $10E753   |
    STA $6CDC           ; $10E755   |
    LDA $6CE8           ; $10E758   |
    SEC                 ; $10E75B   |
    SBC #$01            ; $10E75C   |
    STA $6CE8           ; $10E75E   |

CODE_10E761:
    LDA $6CE2           ; $10E761   |
    CLC                 ; $10E764   |
    ADC #$01            ; $10E765   |
    STA $6CE2           ; $10E767   |
    LDA $6CEE           ; $10E76A   |
    SEC                 ; $10E76D   |
    SBC #$01            ; $10E76E   |
    STA $6CEE           ; $10E770   |
    LDA $6CCA           ; $10E773   |
    CLC                 ; $10E776   |
    ADC #$01            ; $10E777   |
    STA $6CCA           ; $10E779   |
    LDA $6CD6           ; $10E77C   |
    SEC                 ; $10E77F   |
    SBC #$01            ; $10E780   |
    STA $6CD6           ; $10E782   |
    LDA $6CCB           ; $10E785   |
    SEC                 ; $10E788   |
    SBC #$01            ; $10E789   |
    STA $6CCB           ; $10E78B   |
    STA $6CD7           ; $10E78E   |
    STA $6CE3           ; $10E791   |
    STA $6CEF           ; $10E794   |
    REP #$20            ; $10E797   |
    LDA $6F             ; $10E799   |
    CMP #$00A0          ; $10E79B   |
    BCC CODE_10E7A6     ; $10E79E   |
    INC $79             ; $10E7A0   |
    INC $79             ; $10E7A2   |
    STZ $7E             ; $10E7A4   |

CODE_10E7A6:
    RTS                 ; $10E7A6   |

DATA_10E7A7:         db $1A, $1B, $1C, $1D, $1E, $1F, $20, $1F

    INC $75             ; $10E7AF   |
    LDA $75             ; $10E7B1   |
    CMP #$0010          ; $10E7B3   |
    BCC CODE_10E7BD     ; $10E7B6   |
    LDA #$0008          ; $10E7B8   |
    STA $75             ; $10E7BB   |

CODE_10E7BD:
    LSR A               ; $10E7BD   |
    TAY                 ; $10E7BE   |
    LDX $80             ; $10E7BF   |
    SEP #$20            ; $10E7C1   |
    LDA $E7A7,y         ; $10E7C3   |
    STA $6CAF,x         ; $10E7C6   |
    CPY #$04            ; $10E7C9   |
    BCC CODE_10E7EE     ; $10E7CB   |
    LDA $6CAD,x         ; $10E7CD   |
    SEC                 ; $10E7D0   |
    SBC #$03            ; $10E7D1   |
    STA $6CAD,x         ; $10E7D3   |
    LDA $6CAC,x         ; $10E7D6   |
    CLC                 ; $10E7D9   |
    ADC #$03            ; $10E7DA   |
    STA $6CAC,x         ; $10E7DC   |
    CMP #$48            ; $10E7DF   |
    BCC CODE_10E7EE     ; $10E7E1   |
    REP #$20            ; $10E7E3   |
    LDA #$0040          ; $10E7E5   |
    STA $75             ; $10E7E8   |
    INC $79             ; $10E7EA   |
    INC $79             ; $10E7EC   |

CODE_10E7EE:
    REP #$20            ; $10E7EE   |
    RTS                 ; $10E7F0   |

    DEC $75             ; $10E7F1   |
    BNE CODE_10E7FB     ; $10E7F3   |
    INC $79             ; $10E7F5   |
    INC $79             ; $10E7F7   |
    STZ $75             ; $10E7F9   |

CODE_10E7FB:
    RTS                 ; $10E7FB   |

DATA_10E7FC:         db $21, $22, $23, $24, $25, $26, $27, $28
DATA_10E804:         db $29, $2A, $2B

    SEP #$20            ; $10E807   |
    INC $75             ; $10E809   |
    LDA $75             ; $10E80B   |
    CMP #$0B            ; $10E80D   |
    BCC CODE_10E813     ; $10E80F   |
    LDA #$00            ; $10E811   |

CODE_10E813:
    STA $75             ; $10E813   |
    TAX                 ; $10E815   |
    LDA $E7FC,x         ; $10E816   |
    STA $6CB5           ; $10E819   |
    LDA $6CB2           ; $10E81C   |
    DEC A               ; $10E81F   |
    DEC A               ; $10E820   |
    STA $6CB2           ; $10E821   |
    AND #$02            ; $10E824   |
    BNE CODE_10E83B     ; $10E826   |
    LDA $6CB3           ; $10E828   |
    DEC A               ; $10E82B   |
    STA $6CB3           ; $10E82C   |
    CMP #$C0            ; $10E82F   |
    BNE CODE_10E83B     ; $10E831   |
    INC $79             ; $10E833   |
    INC $79             ; $10E835   |
    LDA #$08            ; $10E837   |
    STA $75             ; $10E839   |

CODE_10E83B:
    REP #$20            ; $10E83B   |
    LDA #$0100          ; $10E83D   |
    CLC                 ; $10E840   |
    ADC $6F             ; $10E841   |
    STA $6CB0           ; $10E843   |
    RTS                 ; $10E846   |

DATA_10E847:         dw $E877
DATA_10E849:         dw $E89B
DATA_10E84B:         dw $E877
DATA_10E84D:         dw $E89B
DATA_10E84F:         dw $E89B
DATA_10E851:         dw $E89B
DATA_10E853:         dw $E877

    LDA $75             ; $10E855   |
    AND #$FFFE          ; $10E857   |
    TAX                 ; $10E85A   |
    JSR ($E847,x)       ; $10E85B   |

    INC $75             ; $10E85E   |
    LDA $75             ; $10E860   |
    CMP #$000E          ; $10E862   |
    BCC CODE_10E876     ; $10E865   |
    JSR CODE_10E4CC     ; $10E867   |
    JSR CODE_10E511     ; $10E86A   |
    INC $79             ; $10E86D   |
    INC $79             ; $10E86F   |
    LDA #$0010          ; $10E871   |
    STA $75             ; $10E874   |

CODE_10E876:
    RTS                 ; $10E876   |

    LDA #$03FF          ; $10E877   |
    STA $701610         ; $10E87A   |
    STA $701630         ; $10E87E   |
    STA $701650         ; $10E882   |
    STA $701670         ; $10E886   |
    STA $701810         ; $10E88A   |
    STA $701830         ; $10E88E   |
    STA $701850         ; $10E892   |
    STA $701870         ; $10E896   |
    RTS                 ; $10E89A   |

    LDA #$1041          ; $10E89B   |
    STA $701610         ; $10E89E   |
    LDA #$1400          ; $10E8A2   |
    STA $701630         ; $10E8A5   |
    LDA #$1800          ; $10E8A9   |
    STA $701650         ; $10E8AC   |
    LDA #$1C00          ; $10E8B0   |
    STA $701670         ; $10E8B3   |
    RTS                 ; $10E8B7   |

    REP #$10            ; $10E8B8   |
    LDX #$0000          ; $10E8BA   |

CODE_10E8BD:
    LDA $5FF24A,x       ; $10E8BD   |
    STA $701A00,x       ; $10E8C1   |
    INX                 ; $10E8C5   |
    INX                 ; $10E8C6   |
    CPX #$0200          ; $10E8C7   |
    BCC CODE_10E8BD     ; $10E8CA   |
    LDX #$0000          ; $10E8CC   |

CODE_10E8CF:
    LDA $5FF44A,x       ; $10E8CF   |
    STA $701A80,x       ; $10E8D3   |
    INX                 ; $10E8D7   |
    INX                 ; $10E8D8   |
    CPX #$0020          ; $10E8D9   |
    BCC CODE_10E8CF     ; $10E8DC   |
    LDA $5FF44A         ; $10E8DE   |
    STA $701A00         ; $10E8E2   |
    JSR CODE_10E5FE     ; $10E8E6   |
    SEP #$10            ; $10E8E9   |
    LDA #$0080          ; $10E8EB   |
    STA $75             ; $10E8EE   |
    LDA #$FFFF          ; $10E8F0   |
    STA $6CAA           ; $10E8F3   |
    INC $79             ; $10E8F6   |
    INC $79             ; $10E8F8   |
    RTS                 ; $10E8FA   |

    DEC $75             ; $10E8FB   |
    BNE CODE_10E90B     ; $10E8FD   |
    JSR CODE_10E4CC     ; $10E8FF   |
    JSR CODE_10E511     ; $10E902   |
    INC $79             ; $10E905   |
    INC $79             ; $10E907   |
    STZ $75             ; $10E909   |

CODE_10E90B:
    RTS                 ; $10E90B   |

    JSR CODE_10E530     ; $10E90C   |
    LDA $71AA           ; $10E90F   |
    BEQ CODE_10E921     ; $10E912   |
    DEC $71AA           ; $10E914   |
    LDA $8C             ; $10E917   |
    AND #$0002          ; $10E919   |
    BNE CODE_10E921     ; $10E91C   |
    INC $71AA           ; $10E91E   |

CODE_10E921:
    RTS                 ; $10E921   |

    REP #$10            ; $10E922   |
    LDX #$0000          ; $10E924   |

CODE_10E927:
    LDA $5FF24A,x       ; $10E927   |
    STA $701A00,x       ; $10E92B   |
    INX                 ; $10E92F   |
    INX                 ; $10E930   |
    CPX #$0200          ; $10E931   |
    BCC CODE_10E927     ; $10E934   |
    JSR CODE_10E5FE     ; $10E936   |
    LDA #$0340          ; $10E939   |
    STA $0BD7           ; $10E93C   |
    SEP #$10            ; $10E93F   |
    LDX #$00            ; $10E941   |

CODE_10E943:
    LDA $5FF1CA,x       ; $10E943   |
    STA $701A00,x       ; $10E947   |
    INX                 ; $10E94B   |
    INX                 ; $10E94C   |
    CPX #$80            ; $10E94D   |
    BCC CODE_10E943     ; $10E94F   |
    LDA #$337F          ; $10E951   |
    STA $701AB2         ; $10E954   |
    STA $701AB4         ; $10E958   |
    LDA #$0009          ; $10E95C   |
    STA $88             ; $10E95F   |
    LDA #$0030          ; $10E961   |
    STA $75             ; $10E964   |
    INC $79             ; $10E966   |
    INC $79             ; $10E968   |
    RTS                 ; $10E96A   |

    LDA $75             ; $10E96B   |
    DEC A               ; $10E96D   |
    BNE CODE_10E975     ; $10E96E   |
    LDA #$000A          ; $10E970   |
    STA $88             ; $10E973   |

CODE_10E975:
    DEC $75             ; $10E975   |
    BNE CODE_10E991     ; $10E977   |
    LDA $0B8F           ; $10E979   |
    EOR #$0002          ; $10E97C   |
    AND #$0002          ; $10E97F   |
    STA $0B8F           ; $10E982   |
    INC $0B8D           ; $10E985   |
    INC $79             ; $10E988   |
    INC $79             ; $10E98A   |
    LDA #$0170          ; $10E98C   |
    STA $75             ; $10E98F   |

CODE_10E991:
    RTS                 ; $10E991   |

    DEC $75             ; $10E992   |
    BNE CODE_10E9AB     ; $10E994   |
    LDA $0B8F           ; $10E996   |
    EOR #$0002          ; $10E999   |
    AND #$0002          ; $10E99C   |
    STA $0B8F           ; $10E99F   |
    INC $79             ; $10E9A2   |
    INC $79             ; $10E9A4   |
    LDA #$0030          ; $10E9A6   |
    STA $75             ; $10E9A9   |

CODE_10E9AB:
    RTS                 ; $10E9AB   |

DATA_10E9AC:         db $00, $01, $02, $03, $04, $05, $06, $07
DATA_10E9B4:         db $08, $09, $0A, $0B, $0C

DATA_10E9B9:         db $0D, $8F, $12, $10
DATA_10E9BD:         db $0E, $0D, $0E, $10
DATA_10E9C1:         db $8F, $12, $10, $10
DATA_10E9C5:         db $8F, $10, $10, $8F

CODE_10E9C9:
    REP #$10            ; $10E9C9   |
    LDY $80             ; $10E9CB   |
    LDA $86             ; $10E9CD   |
    BNE CODE_10E9DC     ; $10E9CF   |
    LDA $77             ; $10E9D1   |
    BEQ CODE_10E9D9     ; $10E9D3   |
    CLC                 ; $10E9D5   |
    ADC #$0300          ; $10E9D6   |

CODE_10E9D9:
    CLC                 ; $10E9D9   |
    ADC $6F             ; $10E9DA   |

CODE_10E9DC:
    STA $6CAA,y         ; $10E9DC   |
    LDA $77             ; $10E9DF   |
    BEQ CODE_10E9ED     ; $10E9E1   |
    LDA $73             ; $10E9E3   |
    BEQ CODE_10E9ED     ; $10E9E5   |
    CLC                 ; $10E9E7   |
    ADC #$0002          ; $10E9E8   |
    STA $73             ; $10E9EB   |

CODE_10E9ED:
    INC $75             ; $10E9ED   |
    LDA $75             ; $10E9EF   |
    CMP #$000D          ; $10E9F1   |
    BCC CODE_10E9F9     ; $10E9F4   |
    LDA #$0000          ; $10E9F6   |

CODE_10E9F9:
    STA $75             ; $10E9F9   |
    TAX                 ; $10E9FB   |
    SEP #$20            ; $10E9FC   |
    LDA $71             ; $10E9FE   |
    STA $6CAC,y         ; $10EA00   |
    LDA $73             ; $10EA03   |
    BEQ CODE_10EA0A     ; $10EA05   |
    STA $6CAD,y         ; $10EA07   |

CODE_10EA0A:
    LDA $E9AC,x         ; $10EA0A   |
    CLC                 ; $10EA0D   |
    ADC $82             ; $10EA0E   |
    STA $6CAF,y         ; $10EA10   |
    SEP #$30            ; $10EA13   |
    LDA $84             ; $10EA15   |
    BNE CODE_10EA41     ; $10EA17   |
    LDA $70             ; $10EA19   |
    BNE CODE_10EA41     ; $10EA1B   |
    LDA $6F             ; $10EA1D   |
    BNE CODE_10EA41     ; $10EA1F   |
    LDA $8A             ; $10EA21   |
    INC A               ; $10EA23   |
    AND #$03            ; $10EA24   |
    STA $8A             ; $10EA26   |
    TAX                 ; $10EA28   |
    LDA $E9B9,x         ; $10EA29   |
    STA $6EE9           ; $10EA2C   |
    LDA $E9BD,x         ; $10EA2F   |
    STA $6E65           ; $10EA32   |
    LDA $E9C1,x         ; $10EA35   |
    STA $6E8F           ; $10EA38   |
    LDA $E9C5,x         ; $10EA3B   |
    STA $6E2F           ; $10EA3E   |

CODE_10EA41:
    REP #$20            ; $10EA41   |
    RTS                 ; $10EA43   |

DATA_10EA44:         dw $05C0, $E872, $1040, $05C0
DATA_10EA4C:         dw $E044, $1040, $05C0, $E216
DATA_10EA54:         dw $1040, $05C0, $D8E8, $1040
DATA_10EA5C:         dw $05C0, $E8BA, $1040, $05C0
DATA_10EA64:         dw $E08C, $1040, $05A0, $2600
DATA_10EA6C:         dw $9440, $0580, $E062, $1040
DATA_10EA74:         dw $0580, $D834, $1040, $0580
DATA_10EA7C:         dw $E806, $1040, $0580, $D8D8
DATA_10EA84:         dw $1040, $0580, $E0AA, $1040
DATA_10EA8C:         dw $057C, $0210, $1040, $057C
DATA_10EA94:         dw $06EC, $1040, $0578, $0A26
DATA_10EA9C:         dw $1040, $0578, $0DD7, $1040
DATA_10EAA4:         dw $0570, $24B9, $1040, $0570
DATA_10EAAC:         dw $2452, $1040, $0568, $1416
DATA_10EAB4:         dw $1040, $0568, $1CE8, $1040
DATA_10EABC:         dw $0568, $0CC0, $1240, $0560
DATA_10EAC4:         dw $1E44, $1040, $0560, $24BA
DATA_10EACC:         dw $1040, $055C, $1A00, $1240
DATA_10EAD4:         dw $0558, $1A5F, $1040, $0558
DATA_10EADC:         dw $1AAC, $1040, $0540, $E27F
DATA_10EAE4:         dw $1040, $0540, $D851, $1040
DATA_10EAEC:         dw $0540, $E023, $1040, $0540
DATA_10EAF4:         dw $E8F5, $1040, $0540, $E0C7
DATA_10EAFC:         dw $1040, $0540, $D899, $1040
DATA_10EB04:         dw $0500, $D872, $1040, $0500
DATA_10EB0C:         dw $DE44, $1040, $0500, $E816
DATA_10EB14:         dw $1040, $0500, $E0E8, $1040
DATA_10EB1C:         dw $0500, $D8BA, $1040, $0500
DATA_10EB24:         dw $E28C, $1040, $04C0, $E872
DATA_10EB2C:         dw $1040, $04C0, $E044, $1040
DATA_10EB34:         dw $04C0, $E216, $1040, $04C0
DATA_10EB3C:         dw $D8E8, $1040, $04C0, $E8BA
DATA_10EB44:         dw $1040, $04C0, $E08C, $1040
DATA_10EB4C:         dw $0480, $E062, $1040, $0480
DATA_10EB54:         dw $D834, $1040, $0480, $F006
DATA_10EB5C:         dw $1040, $0480, $D8D8, $1040
DATA_10EB64:         dw $0480, $E0AA, $1040, $0470
DATA_10EB6C:         dw $D8F8, $1240, $0440, $E27F
DATA_10EB74:         dw $1040, $0440, $D851, $1040
DATA_10EB7C:         dw $0440, $E023, $1040, $0440
DATA_10EB84:         dw $E8F5, $1040, $0440, $E0C7
DATA_10EB8C:         dw $1040, $0440, $D899, $1040
DATA_10EB94:         dw $0400, $D872, $1040, $0400
DATA_10EB9C:         dw $DE44, $1040, $0400, $E816
DATA_10EBA4:         dw $1040, $0400, $E0E8, $1040
DATA_10EBAC:         dw $0400, $D8BA, $1040, $0400
DATA_10EBB4:         dw $E28C, $1040, $03E0, $A060
DATA_10EBBC:         dw $1240, $03E0, $B0A0, $1240
DATA_10EBC4:         dw $03E0, $E020, $8F30, $03C0
DATA_10EBCC:         dw $D87F, $1040, $03C0, $E051
DATA_10EBD4:         dw $1040, $03C0, $E823, $1040
DATA_10EBDC:         dw $03C0, $D8F5, $1040, $03C0
DATA_10EBE4:         dw $D2C7, $1040, $03C0, $E899
DATA_10EBEC:         dw $1040, $03A0, $9090, $1340
DATA_10EBF4:         dw $03A0, $B070, $1240, $03A0
DATA_10EBFC:         dw $E010, $0E40, $0380, $F062
DATA_10EC04:         dw $1040, $0380, $E034, $1040
DATA_10EC0C:         dw $0380, $D806, $1040, $0380
DATA_10EC14:         dw $DED8, $1040, $0380, $E8AA
DATA_10EC1C:         dw $1040, $0380, $E670, $1140
DATA_10EC24:         dw $0360, $F0E0, $8F40, $0340
DATA_10EC2C:         dw $E872, $1040, $0340, $E044
DATA_10EC34:         dw $1040, $0340, $E216, $1040
DATA_10EC3C:         dw $0340, $D8E8, $1040, $0340
DATA_10EC44:         dw $E8BA, $1040, $0340, $E08C
DATA_10EC4C:         dw $1040, $0320, $9000, $1340
DATA_10EC54:         dw $0300, $E062, $1040, $0300
DATA_10EC5C:         dw $D834, $1040, $0300, $F006
DATA_10EC64:         dw $1040, $0300, $D8D8, $1040
DATA_10EC6C:         dw $0300, $E0AA, $1040, $02E0
DATA_10EC74:         dw $A060, $1240, $02E0, $B0E0
DATA_10EC7C:         dw $1240, $02E0, $00C0, $0D40
DATA_10EC84:         dw $02C0, $E27F, $1040, $02C0
DATA_10EC8C:         dw $D851, $1040, $02C0, $E023
DATA_10EC94:         dw $1040, $02C0, $E8F5, $1040
DATA_10EC9C:         dw $02C0, $E0C7, $1040, $02C0
DATA_10ECA4:         dw $D899, $1040, $02C0, $D67F
DATA_10ECAC:         dw $1140, $02A0, $B030, $1240
DATA_10ECB4:         dw $0280, $D872, $1040, $0280
DATA_10ECBC:         dw $DE44, $1040, $0280, $E816
DATA_10ECC4:         dw $1040, $0280, $E0E8, $1040
DATA_10ECCC:         dw $0280, $D8BA, $1040, $0280
DATA_10ECD4:         dw $E28C, $1040, $0280, $D68C
DATA_10ECDC:         dw $1140, $0260, $9050, $1340
DATA_10ECE4:         dw $0240, $D87F, $1040, $0240
DATA_10ECEC:         dw $E051, $1040, $0240, $E823
DATA_10ECF4:         dw $1040, $0240, $D8F5, $1040
DATA_10ECFC:         dw $0240, $D2C7, $1040, $0240
DATA_10ED04:         dw $E899, $1040, $0200, $F062
DATA_10ED0C:         dw $1040, $0200, $E034, $1040
DATA_10ED14:         dw $0200, $D806, $1040, $0200
DATA_10ED1C:         dw $DED8, $1040, $0200, $E8AA
DATA_10ED24:         dw $1040, $01C0, $E872, $1040
DATA_10ED2C:         dw $01C0, $E044, $1040, $01C0
DATA_10ED34:         dw $E216, $1040, $01C0, $D8E8
DATA_10ED3C:         dw $1040, $01C0, $E8BA, $1040
DATA_10ED44:         dw $01C0, $E08C, $1040, $0180
DATA_10ED4C:         dw $E062, $1040, $0180, $D834
DATA_10ED54:         dw $1040, $0180, $E806, $1040
DATA_10ED5C:         dw $0180, $D8D8, $1040, $0180
DATA_10ED64:         dw $E0AA, $1040, $0140, $E27F
DATA_10ED6C:         dw $1040, $0140, $D851, $1040
DATA_10ED74:         dw $0140, $E023, $1040, $0140
DATA_10ED7C:         dw $E8F5, $1040, $0140, $E0C7
DATA_10ED84:         dw $1040, $0140, $D899, $1040
DATA_10ED8C:         dw $0100, $D872, $1040, $0100
DATA_10ED94:         dw $DE44, $1040, $0100, $E816
DATA_10ED9C:         dw $1040, $0100, $E0E8, $1040
DATA_10EDA4:         dw $0100, $D8BA, $1040, $0100
DATA_10EDAC:         dw $E28C, $1040, $00C0, $E872
DATA_10EDB4:         dw $1040, $00C0, $E044, $1040
DATA_10EDBC:         dw $00C0, $E216, $1040, $00C0
DATA_10EDC4:         dw $D8E8, $1040, $00C0, $E8BA
DATA_10EDCC:         dw $1040, $00C0, $E08C, $1040
DATA_10EDD4:         dw $0080, $E062, $1040, $0080
DATA_10EDDC:         dw $D834, $1040, $0080, $F006
DATA_10EDE4:         dw $1040, $0080, $D8D8, $1040
DATA_10EDEC:         dw $0080, $E0AA, $1040, $0070
DATA_10EDF4:         dw $D8F8, $1240, $0040, $E27F
DATA_10EDFC:         dw $1040, $0040, $D851, $1040
DATA_10EE04:         dw $0040, $E023, $1040, $0040
DATA_10EE0C:         dw $E8F5, $1040, $0040, $E0C7
DATA_10EE14:         dw $1040, $0040, $D899, $1040
DATA_10EE1C:         dw $0000, $D872, $1040, $0000
DATA_10EE24:         dw $DE44, $1040, $0000, $E816
DATA_10EE2C:         dw $1040, $0000, $E0E8, $1040
DATA_10EE34:         dw $0000, $D8BA, $1040, $0000
DATA_10EE3C:         dw $E28C, $1040, $0000, $B000
DATA_10EE44:         dw $C010, $FFFF

DATA_10EE48:         dw $0000, $B400, $C020, $FFFF

DATA_10EE50:         dw $0130, $4000, $96B0, $0300
DATA_10EE58:         dw $1070, $2140, $0110, $2800
DATA_10EE60:         dw $1540, $0100, $2018, $1A40
DATA_10EE68:         dw $00E0, $300C, $D840, $00D0
DATA_10EE70:         dw $F818, $D740, $00E0, $30F4
DATA_10EE78:         dw $D940, $00D0, $F8D8, $D740
DATA_10EE80:         dw $00D0, $3030, $D854, $00A0
DATA_10EE88:         dw $F828, $D750, $00D0, $30C8
DATA_10EE90:         dw $D954, $00A0, $F8C8, $D750
DATA_10EE98:         dw $FFFF

DATA_10EE9A:         dw $EEE3
DATA_10EE9C:         dw $F12D

DATA_10EE9E:         dw $EEA2
DATA_10EEA0:         dw $F0EC

DATA_10EEA2:         db $08, $00, $00, $00, $00, $00, $00, $00
DATA_10EEAA:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10EEB2:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10EEBA:         db $00, $60, $00, $00, $00, $40, $00, $00
DATA_10EEC2:         db $00, $20, $00, $00, $02, $00, $00, $00
DATA_10EECA:         db $02, $55, $00, $00, $02, $AA, $00, $00
DATA_10EED2:         db $04, $00, $00, $00, $04, $04, $00, $00
DATA_10EEDA:         db $04, $08, $00, $00, $06, $00, $00, $00
DATA_10EEE2:         db $FF

DATA_10EEE3:         db $2B, $42, $42, $00, $00, $B6, $19, $00
DATA_10EEEB:         db $00, $CD, $C7, $00, $00, $19, $EA, $00
DATA_10EEF3:         db $00, $26, $31, $00, $00, $FA, $1F, $58
DATA_10EEFB:         db $00, $FA, $1E, $58, $00, $B0, $00, $00
DATA_10EF03:         db $00, $C7, $C7, $00, $00, $30, $30, $42
DATA_10EF0B:         db $00, $30, $30, $40, $00, $30, $30, $44
DATA_10EF13:         db $00, $12, $52, $1A, $00, $12, $52, $1A
DATA_10EF1B:         db $00, $12, $52, $1A, $00, $30, $30, $1A
DATA_10EF23:         db $01

; title screen background object table, worlds 1-5 (4 bytes per object)
; Object format OOXXZZYY
; OO = Object
; XX = X cord
; YY = Y cord
; ZZ = Z cord
DATA_10EF24:         dd $0200F6F7
DATA_10EF28:         dd $0300E3D6
DATA_10EF2C:         dd $030024FE
DATA_10EF30:         dd $07000CD0
DATA_10EF34:         dd $0B002ED9
DATA_10EF38:         dd $0B00FE9D
DATA_10EF3C:         dd $0B0028C4
DATA_10EF40:         dd $090045D2
DATA_10EF44:         dd $0904DE10
DATA_10EF48:         dd $0904DF24
DATA_10EF4C:         dd $0904F323
DATA_10EF50:         dd $0A04F10E
DATA_10EF54:         dd $0504EA19
DATA_10EF58:         dd $0C043126
DATA_10EF5C:         dd $0C00D21A
DATA_10EF60:         dd $0C00BF1E
DATA_10EF64:         dd $0F00C81C
DATA_10EF68:         dd $0F00DDF1
DATA_10EF6C:         dd $0F00D63D
DATA_10EF70:         dd $0F00DD4D
DATA_10EF74:         dd $1100EE36
DATA_10EF78:         dd $13000051
DATA_10EF7C:         dd $13004B2F
DATA_10EF80:         dd $13005A28
DATA_10EF84:         dd $11003843
DATA_10EF88:         dd $11003216
DATA_10EF8C:         dd $11005437
DATA_10EF90:         dd $1200593D
DATA_10EF94:         dd $12000012
DATA_10EF98:         dd $1200FE1E
DATA_10EF9C:         dd $1200ED2C
DATA_10EFA0:         dd $1200E100
DATA_10EFA4:         dd $0800C642
DATA_10EFA8:         dd $130047F6
DATA_10EFAC:         dd $13002619
DATA_10EFB0:         dd $13002332
DATA_10EFB4:         dd $0C001646
DATA_10EFB8:         dd $0C00DC19
DATA_10EFBC:         dd $0F00E706
DATA_10EFC0:         dd $0F00BD07
DATA_10EFC4:         dd $0F00D52C
DATA_10EFC8:         dd $1200F72A
DATA_10EFCC:         dd $1200C211
DATA_10EFD0:         dd $1800A9FC
DATA_10EFD4:         dd $1800C9A7
DATA_10EFD8:         dd $1800DAB9
DATA_10EFDC:         dd $1800E9A8
DATA_10EFE0:         dd $1900C0A7
DATA_10EFE4:         dd $19003FBD
DATA_10EFE8:         dd $19004CB9
DATA_10EFEC:         dd $190024BA
DATA_10EFF0:         dd $190030B4
DATA_10EFF4:         dd $190037AA
DATA_10EFF8:         dd $19000BAB
DATA_10EFFC:         dd $190034C7
DATA_10F000:         dd $07004FC6
DATA_10F004:         dd $1800F0B6
DATA_10F008:         dd $1800D7A8
DATA_10F00C:         dd $1900D3C1
DATA_10F010:         dd $190016A5
DATA_10F014:         dd $1900299C
DATA_10F018:         dd $190026AB
DATA_10F01C:         dd $080005B3
DATA_10F020:         dd $07001023
DATA_10F024:         dd $0B00B8ED
DATA_10F028:         dd $0B00AD08
DATA_10F02C:         dd $13009FF0
DATA_10F030:         dd $1100F05A
DATA_10F034:         dd $1100015C
DATA_10F038:         dd $1100026B
DATA_10F03C:         dd $1100274A
DATA_10F040:         dd $1200185C
DATA_10F044:         dd $1200A6E2
DATA_10F048:         dd $16009E02
DATA_10F04C:         dd $15581EFA
DATA_10F050:         dd $1549F7D6
DATA_10F054:         dd $15490021
DATA_10F058:         dd $154A1708
DATA_10F05C:         dd $06303BF8
DATA_10F060:         dd $15005212
DATA_10F064:         dd $1540D0EF
DATA_10F068:         dd $1B401FDE
DATA_10F06C:         dd $1B43E5D9
DATA_10F070:         dd $1B43E8DD
DATA_10F074:         dd $1B45EBE2
DATA_10F078:         dd $1B47EEE6
DATA_10F07C:         dd $1B4CF0EB
DATA_10F080:         dd $1B50F3F1
DATA_10F084:         dd $1B53FAF7
DATA_10F088:         dd $1B53FDF7
DATA_10F08C:         dd $1B5402F7
DATA_10F090:         dd $1B5508F7
DATA_10F094:         dd $1B580FF8
DATA_10F098:         dd $1B5B15F8
DATA_10F09C:         dd $1B3605D2
DATA_10F0A0:         dd $1B37FED2
DATA_10F0A4:         dd $1B39F8D3
DATA_10F0A8:         dd $1B3BF2D4
DATA_10F0AC:         dd $0A3EEBD5
DATA_10F0B0:         dd $040419B6
DATA_10F0B4:         dd $1804C7CD
DATA_10F0B8:         dd $1800BAD5
DATA_10F0BC:         dd $1000C5C1
DATA_10F0C0:         dd $1000B7D7
DATA_10F0C4:         dd $1000CAE0
DATA_10F0C8:         dd $1000D2B4
DATA_10F0CC:         dd $0D00BFB4
DATA_10F0D0:         dd $100050DE
DATA_10F0D4:         dd $1000D2B4
DATA_10F0D8:         dd $0D00BFB4
DATA_10F0DC:         dd $FF0050DE

DATA_10F0E0:         dw $01CC, $01D0, $0070, $0074
DATA_10F0E8:         dw $0168, $0070

DATA_10F0EC:         db $08, $00, $00, $00, $00, $00, $00, $00
DATA_10F0F4:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10F0FC:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10F104:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10F10C:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10F114:         db $00, $00, $00, $00, $00, $00, $00, $00
DATA_10F11C:         db $04, $00, $00, $00, $04, $04, $00, $00
DATA_10F124:         db $04, $08, $00, $00, $00, $00, $00, $00
DATA_10F12C:         db $FF

DATA_10F12D:         db $31, $0A, $20, $50, $00, $00, $B0, $00
DATA_10F135:         db $00, $39, $C7, $00, $00, $50, $00, $00
DATA_10F13D:         db $00, $39, $39, $00, $00, $00, $50, $00
DATA_10F145:         db $00, $09, $16, $00, $00, $B0, $00, $00
DATA_10F14D:         db $00, $C7, $C7, $00, $00, $30, $30, $42
DATA_10F155:         db $00, $30, $30, $40, $00, $30, $30, $44
DATA_10F15D:         db $00, $3D, $06, $1A

; title screen background object table, world 6 (4 bytes per object)
; Object format OOXXZZYY
; OO = Object
; XX = X cord
; YY = Y cord
; ZZ = Z cord
DATA_10F161:         dd $1A063D00
DATA_10F165:         dd $1A063D00
DATA_10F169:         dd $00303000
DATA_10F16D:         dd $1A303015
DATA_10F171:         dd $0022DC02
DATA_10F175:         dd $0043F203
DATA_10F179:         dd $00E60B03
DATA_10F17D:         dd $00580B6E
DATA_10F181:         dd $00BF066E
DATA_10F185:         dd $0009C16E
DATA_10F189:         dd $00C0D86E
DATA_10F18D:         dd $00E6336E
DATA_10F191:         dd $0005DA6F
DATA_10F195:         dd $002ABE6F
DATA_10F199:         dd $002D046F
DATA_10F19D:         dd $00160973
DATA_10F1A1:         dd $0047C26C
DATA_10F1A5:         dd $004BD86C
DATA_10F1A9:         dd $00E2B06C
DATA_10F1AD:         dd $00ECE66C
DATA_10F1B1:         dd $00C8386C
DATA_10F1B5:         dd $00F44A6D
DATA_10F1B9:         dd $00F5D96D
DATA_10F1BD:         dd $00DD5510
DATA_10F1C1:         dd $001FAD10
DATA_10F1C5:         dd $0027381A
DATA_10F1C9:         dd $00262D1A
DATA_10F1CD:         dd $0027231A
DATA_10F1D1:         dd $0020191A
DATA_10F1D5:         dd $00231E1A
DATA_10F1D9:         dd $0066E75C
DATA_10F1DD:         dd $0059EA5D
DATA_10F1E1:         dd $00296061
DATA_10F1E5:         dd $00146761
DATA_10F1E9:         dd $00006161
DATA_10F1ED:         dd $001A5F62
DATA_10F1F1:         dd $00226662
DATA_10F1F5:         dd $003AB766
DATA_10F1F9:         dd $002FAA67
DATA_10F1FD:         dd $000CA267
DATA_10F201:         dd $00FFB068
DATA_10F205:         dd $0054CD68
DATA_10F209:         dd $005C3760
DATA_10F20D:         dd $00581D60
DATA_10F211:         dd $004E425C
DATA_10F215:         dd $006C175C
DATA_10F219:         dd $005F265C
DATA_10F21D:         dd $0052395B
DATA_10F221:         dd $00016A61
DATA_10F225:         dd $000A5F61
DATA_10F229:         dd $000B6762
DATA_10F22D:         dd $00EB5F62
DATA_10F231:         dd $00063D06
DATA_10F235:         dd $40052015
DATA_10F239:         dd $303C1F15
DATA_10F23D:         dd $30FBEC15
DATA_10F241:         dd $203CC815
DATA_10F245:         dd $20E7D015
DATA_10F249:         dd $20D51C15
DATA_10F24D:         dd $50200A15
DATA_10F251:         dd $5014E815
DATA_10F255:         dd $00EBC20E
DATA_10F259:         dd $0001EF0E
DATA_10F25D:         dd $0045230E

DATA_10F261:         db $FF

; level 04 header
DATA_10F262:         db $CE, $3F, $4A, $D3, $0E, $A0, $00, $00
DATA_10F26A:         db $05, $00

; level 04 object data
DATA_10F26C:         db $E4, $20, $F0, $08, $50, $EC, $20, $F9
DATA_10F274:         db $00, $26, $E4, $50, $89, $01, $27, $EC
DATA_10F27C:         db $50, $6B, $00, $08, $EC, $60, $1C, $00
DATA_10F284:         db $06, $00, $50, $49, $D4, $00, $50, $DB
DATA_10F28C:         db $D6, $E4, $60, $9C, $02, $16, $EC, $60
DATA_10F294:         db $BE, $00, $02, $EC, $71, $35, $00, $01
DATA_10F29C:         db $E4, $71, $23, $01, $0D, $EC, $71, $86
DATA_10F2A4:         db $00, $07, $E4, $71, $85, $00, $07, $00
DATA_10F2AC:         db $71, $45, $D6, $E4, $72, $7C, $02, $08
DATA_10F2B4:         db $EB, $72, $7B, $00, $08, $EB, $72, $1C
DATA_10F2BC:         db $00, $02, $00, $72, $28, $DB, $EC, $72
DATA_10F2C4:         db $6F, $00, $09, $EC, $72, $1D, $00, $02
DATA_10F2CC:         db $00, $72, $2D, $D4, $EB, $51, $6F, $00
DATA_10F2D4:         db $09, $E4, $52, $60, $00, $09, $EB, $42
DATA_10F2DC:         db $E0, $00, $04, $00, $51, $1C, $DB, $E4
DATA_10F2E4:         db $42, $E1, $01, $11, $EB, $42, $82, $00
DATA_10F2EC:         db $03, $00, $41, $AE, $D9, $E6, $42, $64
DATA_10F2F4:         db $FF, $19, $E4, $42, $65, $01, $19, $EB
DATA_10F2FC:         db $42, $35, $00, $02, $E4, $42, $36, $00
DATA_10F304:         db $04, $EB, $32, $D6, $00, $01, $00, $32
DATA_10F30C:         db $E2, $DB, $E5, $32, $C8, $FF, $23, $E4
DATA_10F314:         db $32, $C9, $01, $23, $EB, $32, $99, $00
DATA_10F31C:         db $02, $E4, $32, $9A, $01, $26, $00, $32
DATA_10F324:         db $57, $D9, $E4, $33, $86, $00, $17, $EC
DATA_10F32C:         db $33, $87, $00, $17, $00, $33, $36, $D6
DATA_10F334:         db $9E, $71, $5A, $0A, $63, $73, $42, $03
DATA_10F33C:         db $63, $73, $37, $04, $EB, $74, $7C, $00
DATA_10F344:         db $08, $EB, $74, $3E, $00, $01, $E4, $74
DATA_10F34C:         db $7D, $01, $08, $00, $74, $4C, $DC, $E6
DATA_10F354:         db $74, $2F, $00, $0D, $EC, $75, $20, $00
DATA_10F35C:         db $01, $E4, $75, $70, $02, $08, $EC, $75
DATA_10F364:         db $73, $00, $08, $00, $75, $30, $D7, $EB
DATA_10F36C:         db $76, $5D, $00, $0A, $EB, $66, $FF, $00
DATA_10F374:         db $02, $E4, $76, $4E, $01, $0B, $00, $76
DATA_10F37C:         db $1B, $DA, $E6, $67, $D1, $FF, $12, $E4
DATA_10F384:         db $67, $C6, $08, $13, $EB, $67, $5E, $00
DATA_10F38C:         db $03, $00, $67, $8C, $DC, $E4, $67, $6F
DATA_10F394:         db $00, $19, $00, $67, $0B, $DB, $C4, $71
DATA_10F39C:         db $1F, $04, $68, $74, $30, $04, $00, $9E
DATA_10F3A4:         db $74, $24, $02, $68, $64, $F7, $00, $02
DATA_10F3AC:         db $00, $77, $21, $FE, $00, $63, $EE, $FD
DATA_10F3B4:         db $00, $65, $EE, $FD, $63, $61, $62, $01
DATA_10F3BC:         db $63, $41, $E9, $02, $C5, $42, $32, $02
DATA_10F3C4:         db $63, $41, $2B, $04, $63, $41, $5C, $04
DATA_10F3CC:         db $9E, $33, $5D, $02, $9E, $34, $72, $03
DATA_10F3D4:         db $9E, $34, $97, $04, $C4, $62, $F0, $02
DATA_10F3DC:         db $C5, $32, $41, $02, $C4, $32, $50, $02
DATA_10F3E4:         db $C4, $76, $34, $02, $C4, $42, $41, $02
DATA_10F3EC:         db $C4, $76, $72, $00, $C4, $76, $78, $00
DATA_10F3F4:         db $C6, $75, $36, $FE, $C6, $75, $38, $02
DATA_10F3FC:         db $6B, $35, $C0, $1F, $03, $00, $35, $BF
DATA_10F404:         db $82, $00, $23, $FF, $FD, $00, $24, $F0
DATA_10F40C:         db $FD, $4E, $24, $F5, $02, $02, $4F, $34
DATA_10F414:         db $06, $00, $00, $68, $33, $3D, $02, $00
DATA_10F41C:         db $68, $34, $32, $03, $00, $E4, $33, $45
DATA_10F424:         db $01, $1B, $EB, $33, $44, $00, $02, $67
DATA_10F42C:         db $32, $7F, $00, $01, $67, $32, $9C, $03
DATA_10F434:         db $16, $68, $73, $59, $00, $00, $67, $67
DATA_10F43C:         db $D2, $01, $12, $E4, $67, $C4, $01, $13
DATA_10F444:         db $67, $33, $A0, $04, $15, $9E, $50, $7E
DATA_10F44C:         db $01, $9E, $61, $91, $00, $9E, $61, $65
DATA_10F454:         db $04, $E4, $32, $7B, $01, $02, $E6, $32
DATA_10F45C:         db $5E, $FF, $04, $E7, $33, $10, $FF, $08
DATA_10F464:         db $EC, $33, $11, $00, $02, $E9, $33, $42
DATA_10F46C:         db $01, $06, $67, $33, $64, $00, $03, $67
DATA_10F474:         db $33, $41, $00, $05, $00, $35, $A5, $50
DATA_10F47C:         db $E4, $67, $1F, $10, $1E, $6C, $61, $B7
DATA_10F484:         db $00, $00, $67, $71, $11, $01, $0E, $00
DATA_10F48C:         db $61, $F3, $D4, $00, $60, $7C, $D5, $E4
DATA_10F494:         db $60, $EF, $01, $11, $6C, $51, $A4, $00
DATA_10F49C:         db $00, $6C, $51, $A2, $00, $00, $0D, $51
DATA_10F4A4:         db $A0, $01, $0D, $61, $B3, $01, $6C, $61
DATA_10F4AC:         db $B5, $00, $00, $0D, $51, $E0, $01, $67
DATA_10F4B4:         db $60, $3B, $00, $1C, $EC, $61, $F3, $00
DATA_10F4BC:         db $01, $E8, $61, $E1, $01, $02, $E5, $67
DATA_10F4C4:         db $C3, $FF, $04, $9E, $66, $DA, $03, $9E
DATA_10F4CC:         db $75, $03, $09, $9E, $76, $00, $06, $9E
DATA_10F4D4:         db $73, $1E, $05, $0D, $50, $29, $05, $6C
DATA_10F4DC:         db $50, $29, $00, $00, $00, $74, $78, $9B
DATA_10F4E4:         db $D2, $73, $75, $12, $00, $73, $74, $9A
DATA_10F4EC:         db $00, $51, $32, $9A, $D2, $51, $33, $04
DATA_10F4F4:         db $00, $51, $38, $9B, $FF

; level 04 screen exit data
DATA_10F4F9:         db $FF

; level 04 sprite data
DATA_10F4FA:         db $FA, $F0, $5E, $64, $EC, $65, $8A, $EC
DATA_10F502:         db $5E, $64, $EC, $57, $55, $EE, $49, $FA
DATA_10F50A:         db $EE, $32, $89, $C6, $13, $8A, $BE, $13
DATA_10F512:         db $4F, $A4, $0D, $55, $A6, $11, $8A, $74
DATA_10F51A:         db $24, $FA, $C4, $17, $81, $E7, $20, $81
DATA_10F522:         db $CD, $0E, $92, $77, $27, $81, $67, $2C
DATA_10F52A:         db $C1, $62, $28, $CB, $CF, $77, $CC, $AD
DATA_10F532:         db $0E, $0D, $76, $59, $FA, $A0, $1A, $FA
DATA_10F53A:         db $60, $46, $2C, $DF, $34, $2C, $5D, $36
DATA_10F542:         db $1E, $64, $2F, $1E, $64, $39, $1E, $64
DATA_10F54A:         db $37, $94, $D8, $16, $94, $B6, $13, $C1
DATA_10F552:         db $DE, $1C, $AD, $D0, $73, $8D, $78, $1E
DATA_10F55A:         db $65, $EA, $68, $65, $EA, $62, $65, $EE
DATA_10F562:         db $5A, $65, $EE, $54, $65, $EA, $3A, $65
DATA_10F56A:         db $EA, $38, $65, $9E, $0E, $65, $9E, $10
DATA_10F572:         db $65, $9E, $12, $65, $9E, $14, $65, $9E
DATA_10F57A:         db $16, $65, $88, $22, $65, $6A, $21, $65
DATA_10F582:         db $74, $47, $65, $74, $48, $65, $74, $49
DATA_10F58A:         db $65, $74, $4A, $65, $74, $4B, $B5, $6E
DATA_10F592:         db $5D, $FF, $FF

; level 30 header
DATA_10F595:         db $01, $8E, $97, $80, $02, $23, $18, $00
DATA_10F59D:         db $69, $00

; level 30 object data
DATA_10F59F:         db $00, $00, $11, $FD, $00, $01, $11, $FD
DATA_10F5A7:         db $00, $02, $11, $FD, $00, $03, $11, $FD
DATA_10F5AF:         db $00, $04, $11, $FD, $00, $05, $11, $FD
DATA_10F5B7:         db $00, $06, $11, $FD, $00, $07, $11, $FD
DATA_10F5BF:         db $00, $08, $11, $FD, $00, $09, $11, $FD
DATA_10F5C7:         db $EF, $72, $86, $07, $07, $C4, $76, $9C
DATA_10F5CF:         db $03, $C4, $76, $9D, $02, $EF, $76, $AC
DATA_10F5D7:         db $11, $05, $20, $77, $86, $07, $03, $EF
DATA_10F5DF:         db $76, $4C, $09, $02, $EF, $75, $C2, $01
DATA_10F5E7:         db $02, $F3, $75, $79, $01, $05, $F0, $71
DATA_10F5EF:         db $88, $03, $06, $F1, $71, $8C, $05, $04
DATA_10F5F7:         db $F0, $72, $82, $03, $06, $F2, $73, $82
DATA_10F5FF:         db $03, $06, $F0, $73, $8A, $03, $06, $F1
DATA_10F607:         db $74, $82, $03, $04, $F3, $74, $8C, $01
DATA_10F60F:         db $04, $F3, $76, $88, $03, $04, $F0, $78
DATA_10F617:         db $82, $01, $06, $F1, $78, $8A, $01, $04
DATA_10F61F:         db $F2, $79, $8C, $01, $06, $F3, $79, $88
DATA_10F627:         db $03, $04, $00, $1A, $F8, $FF, $00, $3B
DATA_10F62F:         db $0D, $FF, $EF, $7A, $80, $27, $07, $20
DATA_10F637:         db $7B, $7D, $0A, $02, $20, $7B, $6E, $09
DATA_10F63F:         db $02, $EF, $7D, $C0, $17, $03, $ED, $7A
DATA_10F647:         db $68, $03, $FA, $ED, $7E, $68, $03, $FA
DATA_10F64F:         db $ED, $7E, $8C, $03, $F8, $ED, $7F, $80
DATA_10F657:         db $03, $F8, $F3, $7E, $88, $03, $07, $F2
DATA_10F65F:         db $7E, $AC, $03, $05, $F0, $7F, $A0, $03
DATA_10F667:         db $05, $20, $7D, $6A, $01, $07, $ED, $7E
DATA_10F66F:         db $A0, $07, $F6, $20, $7C, $6D, $08, $02
DATA_10F677:         db $20, $7C, $5D, $01, $02, $20, $6D, $C4
DATA_10F67F:         db $01, $0B, $00, $6D, $F0, $FF, $ED, $7C
DATA_10F687:         db $AD, $08, $FF, $EF, $70, $B0, $17, $04
DATA_10F68F:         db $20, $70, $AE, $09, $02, $20, $71, $91
DATA_10F697:         db $06, $02, $20, $71, $84, $03, $02, $20
DATA_10F69F:         db $7B, $5F, $08, $02, $20, $7C, $40, $07
DATA_10F6A7:         db $02, $ED, $7F, $64, $07, $FA, $EF, $7F
DATA_10F6AF:         db $B4, $0B, $04, $20, $7F, $84, $07, $04
DATA_10F6B7:         db $20, $6F, $DF, $00, $0F, $00, $6F, $FF
DATA_10F6BF:         db $FF, $ED, $76, $8C, $09, $FF, $20, $77
DATA_10F6C7:         db $76, $02, $02, $20, $77, $66, $01, $02
DATA_10F6CF:         db $20, $77, $56, $00, $02, $EF, $76, $40
DATA_10F6D7:         db $07, $0B, $6C, $7F, $0C, $02, $00, $6C
DATA_10F6DF:         db $7D, $06, $09, $00, $FF

; level 30 screen exit data
DATA_10F6E4:         db $7F, $B6, $47, $4E, $09, $6F, $B6, $47
DATA_10F6EC:         db $4E, $09, $FF

; level 67 header
DATA_10F6EF:         db $07, $62, $97, $84, $1A, $40, $38, $00
DATA_10F6F7:         db $01, $00

; level 67 object data
DATA_10F6F9:         db $4C, $71, $85, $03, $4B, $71, $AF, $01
DATA_10F701:         db $CD, $70, $94, $01, $FC, $CD, $70, $98
DATA_10F709:         db $03, $FC, $4C, $70, $9B, $02, $48, $60
DATA_10F711:         db $00, $02, $0D, $4C, $73, $71, $03, $44
DATA_10F719:         db $63, $E8, $05, $07, $A7, $71, $B1, $03
DATA_10F721:         db $00, $A7, $71, $BB, $03, $00, $A7, $72
DATA_10F729:         db $B3, $01, $00, $CC, $71, $8D, $FD, $FC
DATA_10F731:         db $CD, $71, $59, $00, $FF, $46, $71, $1A
DATA_10F739:         db $00, $02, $CD, $71, $8E, $02, $FC, $CD
DATA_10F741:         db $72, $51, $02, $FD, $45, $71, $1B, $02
DATA_10F749:         db $02, $46, $71, $3E, $02, $00, $46, $72
DATA_10F751:         db $01, $02, $01, $CC, $71, $72, $FD, $FC
DATA_10F759:         db $CC, $70, $0B, $FE, $FE, $CC, $70, $3E
DATA_10F761:         db $00, $FF, $CC, $70, $2D, $00, $FF, $CC
DATA_10F769:         db $70, $1C, $00, $FF, $45, $60, $EC, $01
DATA_10F771:         db $01, $45, $70, $0E, $01, $01, $44, $70
DATA_10F779:         db $0D, $00, $00, $44, $70, $2F, $00, $00
DATA_10F781:         db $46, $71, $10, $04, $01, $CC, $72, $9A
DATA_10F789:         db $FF, $FE, $CC, $72, $78, $FF, $FE, $CC
DATA_10F791:         db $72, $56, $FF, $FE, $CD, $72, $9D, $01
DATA_10F799:         db $FC, $CD, $72, $7F, $01, $FC, $CD, $73
DATA_10F7A1:         db $51, $01, $FA, $CD, $73, $33, $00, $FF
DATA_10F7A9:         db $45, $62, $D4, $04, $05, $45, $72, $29
DATA_10F7B1:         db $03, $04, $46, $72, $4C, $01, $02, $46
DATA_10F7B9:         db $72, $2E, $01, $02, $46, $73, $00, $01
DATA_10F7C1:         db $02, $CC, $63, $F1, $FF, $FF, $44, $63
DATA_10F7C9:         db $E3, $00, $03, $44, $72, $7B, $01, $01
DATA_10F7D1:         db $44, $72, $37, $01, $01, $4D, $72, $95
DATA_10F7D9:         db $02, $45, $61, $D5, $04, $05, $CC, $71
DATA_10F7E1:         db $58, $FF, $FE, $CD, $71, $73, $03, $FC
DATA_10F7E9:         db $CC, $72, $34, $00, $FF, $44, $71, $39
DATA_10F7F1:         db $00, $00, $53, $71, $41, $03, $53, $71
DATA_10F7F9:         db $5C, $03, $53, $72, $7A, $03, $46, $73
DATA_10F801:         db $B8, $02, $00, $45, $70, $4A, $01, $01
DATA_10F809:         db $CC, $70, $93, $00, $FD, $A7, $70, $B2
DATA_10F811:         db $08, $00, $CD, $70, $92, $00, $FD, $48
DATA_10F819:         db $60, $E0, $01, $0D, $48, $70, $C0, $3F
DATA_10F821:         db $03, $48, $73, $B1, $0E, $00, $48, $63
DATA_10F829:         db $EE, $01, $0C, $CC, $73, $9A, $FA, $F5
DATA_10F831:         db $44, $73, $6B, $02, $04, $48, $73, $AA
DATA_10F839:         db $03, $00, $53, $72, $5C, $03, $53, $73
DATA_10F841:         db $47, $03, $48, $75, $C0, $0F, $03, $A6
DATA_10F849:         db $75, $AD, $04, $00, $76, $A0, $FF, $48
DATA_10F851:         db $75, $00, $0F, $02, $48, $75, $3F, $00
DATA_10F859:         db $06, $48, $75, $30, $00, $08, $CC, $75
DATA_10F861:         db $8A, $FE, $FB, $CD, $75, $76, $01, $FC
DATA_10F869:         db $CC, $75, $75, $FD, $FC, $CD, $75, $41
DATA_10F871:         db $00, $FF, $CD, $75, $8B, $01, $FB, $CC
DATA_10F879:         db $75, $8E, $FF, $FB, $4C, $75, $82, $03
DATA_10F881:         db $CC, $62, $FC, $FF, $FF, $CD, $62, $FD
DATA_10F889:         db $01, $FF, $44, $70, $31, $01, $02, $46
DATA_10F891:         db $70, $58, $01, $00, $CC, $70, $97, $FF
DATA_10F899:         db $FD, $45, $70, $02, $05, $05, $53, $70
DATA_10F8A1:         db $61, $08, $CB, $70, $59, $02, $00, $44
DATA_10F8A9:         db $70, $59, $01, $00, $F4, $60, $83, $F8
DATA_10F8B1:         db $41, $70, $C2, $2E, $41, $73, $B1, $08
DATA_10F8B9:         db $41, $73, $AA, $03, $41, $75, $C1, $0E
DATA_10F8C1:         db $44, $63, $E2, $00, $00, $48, $60, $05
DATA_10F8C9:         db $3A, $0D, $53, $73, $69, $05, $53, $73
DATA_10F8D1:         db $8B, $03, $FF

; level 67 screen exit data
DATA_10F8D4:         db $70, $B6, $4C, $2A, $00, $75, $93, $04
DATA_10F8DC:         db $57, $06, $FF

; level 93 header
DATA_10F8DF:         db $01, $8F, $60, $38, $0A, $33, $70, $00
DATA_10F8E7:         db $69, $20

; level 93 object data
DATA_10F8E9:         db $EE, $50, $80, $0D, $0A, $EE, $40, $80
DATA_10F8F1:         db $5F, $0A, $EE, $30, $80, $5F, $0A, $EE
DATA_10F8F9:         db $23, $8C, $23, $0A, $EE, $20, $80, $11
DATA_10F901:         db $0A, $A6, $30, $60, $05, $A6, $20, $60
DATA_10F909:         db $05, $A6, $40, $60, $05, $A6, $50, $60
DATA_10F911:         db $05, $20, $20, $40, $01, $05, $20, $30
DATA_10F919:         db $40, $01, $05, $20, $40, $40, $01, $05
DATA_10F921:         db $20, $50, $40, $01, $05, $A9, $31, $8E
DATA_10F929:         db $12, $A9, $20, $8C, $12, $EE, $23, $82
DATA_10F931:         db $05, $0A, $A9, $23, $84, $12, $A9, $34
DATA_10F939:         db $82, $12, $A6, $35, $6A, $05, $A6, $25
DATA_10F941:         db $6A, $05, $A6, $45, $6A, $05, $EF, $53
DATA_10F949:         db $84, $2B, $07, $A6, $55, $6A, $05, $A9
DATA_10F951:         db $25, $80, $12, $20, $14, $CC, $01, $0D
DATA_10F959:         db $00, $14, $FC, $FF, $20, $55, $4E, $01
DATA_10F961:         db $05, $20, $45, $4E, $01, $05, $20, $35
DATA_10F969:         db $4E, $01, $05, $20, $25, $4E, $01, $05
DATA_10F971:         db $00, $35, $90, $E0, $EF, $51, $84, $03
DATA_10F979:         db $07, $EF, $51, $8C, $05, $07, $EF, $52
DATA_10F981:         db $86, $09, $07, $A9, $45, $82, $12, $EF
DATA_10F989:         db $60, $80, $0F, $07, $A6, $60, $60, $05
DATA_10F991:         db $A9, $50, $8A, $12, $20, $60, $40, $01
DATA_10F999:         db $05, $EE, $22, $84, $09, $09, $EE, $21
DATA_10F9A1:         db $86, $09, $09, $FF

; level 93 screen exit data
DATA_10F9A5:         db $20, $B6, $0F, $17, $07, $30, $B6, $0F
DATA_10F9AD:         db $37, $07, $40, $B6, $5F, $27, $07, $50
DATA_10F9B5:         db $67, $5E, $7A, $03, $60, $B6, $0F, $77
DATA_10F9BD:         db $07, $25, $C5, $05, $72, $06, $35, $B6
DATA_10F9C5:         db $20, $37, $06, $45, $B6, $20, $57, $06
DATA_10F9CD:         db $55, $B6, $20, $78, $06, $FF

; level B6 header
DATA_10F9D3:         db $05, $AF, $6C, $80, $02, $40, $00, $00
DATA_10F9DB:         db $01, $40

; level B6 object data
DATA_10F9DD:         db $AA, $10, $42, $07, $AB, $10, $4A, $07
DATA_10F9E5:         db $AC, $10, $42, $09, $AD, $10, $A2, $09
DATA_10F9ED:         db $B0, $10, $64, $05, $03, $AC, $10, $6A
DATA_10F9F5:         db $05, $AD, $10, $8A, $05, $00, $10, $7E
DATA_10F9FD:         db $70, $B1, $10, $9A, $00, $AA, $30, $21
DATA_10FA05:         db $0B, $AD, $30, $C1, $0B, $AD, $30, $8B
DATA_10FA0D:         db $04, $AC, $30, $67, $08, $00, $30, $7E
DATA_10FA15:         db $70, $D5, $32, $2E, $09, $AC, $32, $60
DATA_10FA1D:         db $04, $AD, $32, $80, $04, $00, $32, $70
DATA_10FA25:         db $6F, $D4, $32, $24, $09, $D6, $32, $24
DATA_10FA2D:         db $0A, $D7, $32, $B4, $0A, $D3, $32, $35
DATA_10FA35:         db $08, $07, $B1, $32, $95, $01, $AC, $52
DATA_10FA3D:         db $60, $03, $AD, $52, $80, $03, $D4, $52
DATA_10FA45:         db $53, $05, $00, $52, $70, $6F, $D5, $52
DATA_10FA4D:         db $5E, $05, $D6, $52, $53, $0B, $D7, $52
DATA_10FA55:         db $A3, $0B, $AC, $72, $70, $1D, $AD, $72
DATA_10FA5D:         db $90, $1D, $00, $72, $80, $6F, $BC, $73
DATA_10FA65:         db $7E, $03, $00, $72, $75, $75, $00, $72
DATA_10FA6D:         db $7B, $75, $AA, $44, $46, $0B, $00, $73
DATA_10FA75:         db $79, $75, $00, $73, $72, $75, $AB, $44
DATA_10FA7D:         db $98, $06, $AB, $45, $49, $0B, $AD, $44
DATA_10FA85:         db $98, $10, $AA, $45, $97, $06, $B1, $44
DATA_10FA8D:         db $A7, $01, $00, $45, $D8, $6E, $00, $44
DATA_10FA95:         db $D7, $6E, $D6, $24, $3A, $0F, $D7, $24
DATA_10FA9D:         db $CA, $0F, $D4, $24, $3A, $09, $D3, $24
DATA_10FAA5:         db $4B, $0D, $07, $AC, $25, $69, $06, $AD
DATA_10FAAD:         db $25, $89, $06, $D5, $25, $39, $09, $B1
DATA_10FAB5:         db $25, $97, $01, $B1, $24, $AF, $06, $B0
DATA_10FABD:         db $44, $2E, $04, $03, $AC, $44, $2D, $06
DATA_10FAC5:         db $B0, $44, $57, $12, $04, $AC, $44, $46
DATA_10FACD:         db $08, $AC, $45, $42, $08, $AA, $44, $2D
DATA_10FAD5:         db $03, $AB, $45, $22, $03, $B1, $44, $7C
DATA_10FADD:         db $00, $B1, $45, $74, $00, $00, $25, $7E
DATA_10FAE5:         db $70, $D6, $70, $32, $0A, $D7, $70, $C2
DATA_10FAED:         db $0A, $D4, $70, $32, $09, $AC, $70, $6C
DATA_10FAF5:         db $03, $AD, $70, $8C, $03, $D5, $70, $3C
DATA_10FAFD:         db $09, $D3, $70, $43, $08, $07, $B1, $70
DATA_10FB05:         db $A3, $06, $B1, $70, $73, $06, $B1, $70
DATA_10FB0D:         db $9B, $00, $00, $70, $7E, $70, $AC, $30
DATA_10FB15:         db $85, $03, $AB, $30, $25, $07, $AC, $30
DATA_10FB1D:         db $21, $05, $AB, $30, $8B, $05, $AA, $30
DATA_10FB25:         db $67, $03, $B0, $30, $32, $04, $09, $B0
DATA_10FB2D:         db $30, $76, $05, $05, $B1, $30, $9B, $00
DATA_10FB35:         db $B1, $30, $B8, $02, $6C, $32, $65, $05
DATA_10FB3D:         db $00, $A7, $52, $67, $02, $03, $6C, $10
DATA_10FB45:         db $A7, $00, $00, $6C, $52, $94, $00, $00
DATA_10FB4D:         db $FF

; level B6 screen exit data
DATA_10FB4E:         db $10, $93, $04, $27, $06, $30, $93, $04
DATA_10FB56:         db $37, $06, $70, $93, $04, $67, $06, $32
DATA_10FB5E:         db $93, $5B, $37, $07, $52, $93, $5B, $47
DATA_10FB66:         db $07, $72, $93, $5B, $57, $07, $25, $93
DATA_10FB6E:         db $04, $47, $06, $45, $67, $03, $67, $04
DATA_10FB76:         db $FF

; level C5 header
DATA_10FB77:         db $01, $8C, $61, $80, $02, $33, $18, $00
DATA_10FB7F:         db $69, $60

; level C5 object data
DATA_10FB81:         db $EF, $70, $30, $1E, $0C, $A6, $70, $10
DATA_10FB89:         db $06, $20, $60, $E0, $02, $06, $ED, $70
DATA_10FB91:         db $00, $13, $F0, $00, $62, $FF, $FD, $00
DATA_10FB99:         db $63, $F0, $FD, $EF, $73, $3F, $07, $0C
DATA_10FBA1:         db $1F, $71, $6F, $1F, $09, $00, $64, $F0
DATA_10FBA9:         db $FD, $00, $65, $F0, $FD, $00, $66, $F0
DATA_10FBB1:         db $FD, $00, $67, $F0, $FD, $00, $68, $F0
DATA_10FBB9:         db $FD, $00, $69, $F0, $FD, $00, $6A, $F0
DATA_10FBC1:         db $FD, $00, $6B, $F0, $FD, $00, $6C, $F0
DATA_10FBC9:         db $FD, $00, $6D, $F0, $FD, $EF, $7C, $20
DATA_10FBD1:         db $1F, $0D, $1F, $74, $67, $78, $09, $A6
DATA_10FBD9:         db $7D, $06, $09, $20, $6D, $EA, $05, $05
DATA_10FBE1:         db $ED, $7D, $00, $0F, $F0, $FF

; level C5 screen exit data
DATA_10FBE7:         db $70, $93, $5B, $27, $07, $7D, $CC, $49
DATA_10FBEF:         db $64, $02, $FF

; level CC header
DATA_10FBF2:         db $07, $62, $97, $BE, $5A, $5F, $28, $E0
DATA_10FBFA:         db $22, $80

; level CC object data
DATA_10FBFC:         db $48, $64, $00, $03, $03, $48, $64, $60
DATA_10FC04:         db $03, $19, $48, $65, $0C, $03, $1F, $48
DATA_10FC0C:         db $64, $00, $1F, $01, $48, $64, $24, $04
DATA_10FC14:         db $01, $48, $64, $28, $01, $00, $48, $64
DATA_10FC1C:         db $64, $03, $00, $48, $64, $73, $03, $00
DATA_10FC24:         db $48, $74, $82, $01, $00, $CB, $64, $85
DATA_10FC2C:         db $01, $11, $CB, $65, $29, $01, $18, $44
DATA_10FC34:         db $65, $2A, $01, $18, $44, $64, $84, $01
DATA_10FC3C:         db $11, $48, $74, $84, $00, $01, $48, $74
DATA_10FC44:         db $93, $01, $00, $48, $75, $8B, $01, $01
DATA_10FC4C:         db $A2, $74, $BE, $03, $00, $A2, $74, $AC
DATA_10FC54:         db $07, $00, $A2, $74, $9A, $0B, $00, $A1
DATA_10FC5C:         db $74, $BC, $01, $00, $A1, $74, $AA, $01
DATA_10FC64:         db $00, $A1, $74, $98, $01, $00, $A1, $75
DATA_10FC6C:         db $96, $01, $00, $A1, $75, $A4, $01, $00
DATA_10FC74:         db $A1, $75, $B2, $01, $00, $A0, $75, $A6
DATA_10FC7C:         db $01, $00, $A0, $75, $B4, $03, $00, $A0
DATA_10FC84:         db $74, $A8, $01, $00, $A0, $74, $B8, $03
DATA_10FC8C:         db $00, $48, $74, $A4, $03, $01, $48, $75
DATA_10FC94:         db $A8, $04, $01, $A2, $74, $8A, $01, $00
DATA_10FC9C:         db $A2, $74, $8E, $03, $00, $A2, $75, $84
DATA_10FCA4:         db $01, $00, $A2, $75, $63, $01, $00, $A2
DATA_10FCAC:         db $74, $68, $01, $00, $A2, $74, $4C, $01
DATA_10FCB4:         db $00, $53, $74, $53, $02, $53, $75, $5A
DATA_10FCBC:         db $02, $A6, $64, $40, $0A, $47, $74, $C4
DATA_10FCC4:         db $17, $03, $6C, $74, $0D, $04, $00, $41
DATA_10FCCC:         db $75, $A8, $02, $41, $74, $A5, $02, $41
DATA_10FCD4:         db $74, $84, $00, $41, $75, $8B, $00, $41
DATA_10FCDC:         db $75, $28, $01, $41, $74, $26, $01, $FF

; level CC screen exit data
DATA_10FCE4:         db $FF

; level 30 sprite data
DATA_10FCE5:         db $80, $FC, $38, $80, $FA, $3F, $30, $FB
DATA_10FCED:         db $80, $30, $F7, $87, $30, $F5, $8F, $30
DATA_10FCF5:         db $F7, $93, $2F, $ED, $8A, $71, $EE, $AA
DATA_10FCFD:         db $71, $E8, $28, $30, $F9, $50, $30, $F9
DATA_10FD05:         db $48, $30, $F7, $56, $30, $EB, $5D, $6F
DATA_10FD0D:         db $F8, $53, $6F, $F8, $52, $2F, $F3, $71
DATA_10FD15:         db $8A, $F6, $91, $A1, $F1, $B7, $A0, $EB
DATA_10FD1D:         db $CE, $89, $FA, $CC, $97, $F9, $D1, $97
DATA_10FD25:         db $F1, $AD, $97, $E9, $6D, $C1, $E4, $D1
DATA_10FD2D:         db $A0, $ED, $DB, $6F, $F8, $DD, $6F, $F8
DATA_10FD35:         db $D8, $97, $F1, $F7, $97, $F1, $F9, $9A
DATA_10FD3D:         db $F3, $12, $9A, $F5, $0F, $9A, $F1, $28
DATA_10FD45:         db $9A, $F1, $2A, $9A, $E9, $61, $9A, $E9
DATA_10FD4D:         db $66, $9A, $E9, $70, $9A, $E9, $72, $9A
DATA_10FD55:         db $F1, $7B, $9A, $F1, $A2, $9A, $F1, $A4
DATA_10FD5D:         db $9A, $E9, $C2, $9A, $E9, $C4, $9A, $F1
DATA_10FD65:         db $F6, $9A, $F1, $F8, $97, $F1, $17, $6C
DATA_10FD6D:         db $F6, $FD, $84, $E0, $FD, $97, $F1, $B1
DATA_10FD75:         db $65, $F2, $73, $65, $F2, $74, $FA, $F4
DATA_10FD7D:         db $71, $65, $E6, $D7, $65, $E4, $D9, $65
DATA_10FD85:         db $E6, $DE, $65, $E4, $DC, $65, $F8, $C9
DATA_10FD8D:         db $65, $F4, $CA, $FF, $FF

; level 68 sprite data
DATA_10FD92:         db $31, $E9, $02, $C1, $E4, $34, $F4, $EA
DATA_10FD9A:         db $3A, $3F, $F6, $33, $3F, $F8, $54, $FF
DATA_10FDA2:         db $FF

; level 93 sprite data
DATA_10FDA3:         db $97, $51, $4F, $97, $51, $53, $97, $51
DATA_10FDAB:         db $57, $A4, $73, $50, $97, $71, $59, $97
DATA_10FDB3:         db $91, $59, $97, $B1, $59, $97, $B3, $06
DATA_10FDBB:         db $97, $91, $07, $97, $73, $06, $97, $53
DATA_10FDC3:         db $06, $97, $91, $09, $A0, $B1, $39, $A1
DATA_10FDCB:         db $B1, $49, $A1, $B1, $41, $A0, $B1, $2B
DATA_10FDD3:         db $2F, $BA, $20, $2F, $B8, $1E, $33, $B8
DATA_10FDDB:         db $1E, $33, $B8, $16, $2F, $B8, $16, $2F
DATA_10FDE3:         db $B6, $0C, $2F, $B8, $09, $2F, $B8, $27
DATA_10FDEB:         db $2F, $BA, $2A, $2F, $B6, $2E, $2F, $B6
DATA_10FDF3:         db $36, $2F, $B8, $3B, $2F, $B6, $41, $2F
DATA_10FDFB:         db $BA, $45, $2F, $BA, $47, $2F, $B8, $4C
DATA_10FE03:         db $2F, $BA, $4F, $97, $B3, $08, $2F, $98
DATA_10FE0B:         db $4C, $33, $98, $4C, $33, $98, $22, $2F
DATA_10FE13:         db $98, $22, $2F, $98, $08, $2F, $96, $0F
DATA_10FE1B:         db $2F, $98, $1C, $2F, $98, $2F, $2F, $9A
DATA_10FE23:         db $39, $2F, $9A, $3F, $9A, $91, $13, $9A
DATA_10FE2B:         db $91, $15, $9A, $91, $19, $2F, $98, $36
DATA_10FE33:         db $33, $98, $36, $33, $78, $56, $33, $7A
DATA_10FE3B:         db $54, $2F, $78, $56, $2F, $7A, $54, $9A
DATA_10FE43:         db $71, $47, $9A, $71, $4C, $A1, $71, $2D
DATA_10FE4B:         db $A1, $71, $27, $2F, $78, $12, $2F, $7A
DATA_10FE53:         db $14, $2F, $78, $16, $2F, $7A, $18, $33
DATA_10FE5B:         db $7A, $18, $33, $78, $16, $33, $7A, $14
DATA_10FE63:         db $33, $78, $12, $2F, $78, $3A, $2F, $78
DATA_10FE6B:         db $3C, $33, $78, $3A, $33, $78, $3C, $C1
DATA_10FE73:         db $48, $4A, $2F, $56, $1A, $2F, $58, $18
DATA_10FE7B:         db $2F, $58, $2A, $2F, $56, $2C, $33, $56
DATA_10FE83:         db $2C, $33, $58, $2A, $33, $58, $18, $33
DATA_10FE8B:         db $56, $1A, $4F, $4C, $55, $9A, $4F, $42
DATA_10FE93:         db $9A, $4F, $45, $9A, $4F, $26, $9A, $4F
DATA_10FE9B:         db $1D, $FF, $FF

; level B6 sprite data
DATA_10FE9E:         db $97, $F3, $3C, $97, $F3, $3A, $25, $F2
DATA_10FEA6:         db $23, $25, $F2, $2B, $97, $97, $59, $01
DATA_10FEAE:         db $56, $4C, $4F, $4E, $52, $C1, $88, $50
DATA_10FEB6:         db $25, $8C, $4C, $25, $8C, $54, $25, $EC
DATA_10FEBE:         db $06, $25, $EC, $08, $25, $F2, $03, $25
DATA_10FEC6:         db $F2, $05, $25, $F2, $07, $10, $2F, $04
DATA_10FECE:         db $0B, $35, $09, $09, $79, $03, $09, $79
DATA_10FED6:         db $05, $09, $79, $08, $09, $79, $0A, $0B
DATA_10FEDE:         db $33, $07, $0B, $35, $05, $0B, $79, $06
DATA_10FEE6:         db $0B, $79, $07, $10, $69, $04, $65, $68
DATA_10FEEE:         db $26, $65, $68, $27, $65, $68, $29, $65
DATA_10FEF6:         db $68, $28, $09, $75, $26, $09, $75, $25
DATA_10FEFE:         db $09, $75, $27, $65, $B0, $2A, $65, $AE
DATA_10FF06:         db $2B, $65, $B0, $2C, $65, $AE, $2D, $AF
DATA_10FF0E:         db $F3, $27, $AF, $F3, $2F, $25, $F2, $33
DATA_10FF16:         db $AF, $F3, $37, $09, $57, $57, $09, $57
DATA_10FF1E:         db $55, $09, $57, $54, $09, $57, $56, $09
DATA_10FF26:         db $57, $58, $C1, $EA, $04, $25, $F2, $09
DATA_10FF2E:         db $66, $92, $50, $0B, $35, $06, $0B, $35
DATA_10FF36:         db $08, $FF, $FF

; level C5 sprite data
DATA_10FF39:         db $55, $EE, $22, $65, $DE, $27, $65, $DE
DATA_10FF41:         db $2D, $65, $DE, $33, $65, $DE, $39, $80
DATA_10FF49:         db $F2, $39, $80, $F2, $2D, $00, $EE, $49
DATA_10FF51:         db $AF, $ED, $52, $AF, $ED, $5A, $AF, $ED
DATA_10FF59:         db $62, $AF, $ED, $6A, $AF, $ED, $72, $AF
DATA_10FF61:         db $ED, $7A, $AF, $ED, $82, $AF, $ED, $8A
DATA_10FF69:         db $AF, $ED, $92, $AF, $ED, $9A, $AF, $ED
DATA_10FF71:         db $A2, $AF, $ED, $AA, $AF, $ED, $B2, $97
DATA_10FF79:         db $E5, $C1, $97, $E5, $D3, $97, $E5, $D1
DATA_10FF81:         db $4F, $E0, $C8, $10, $DF, $30, $10, $ED
DATA_10FF89:         db $BE, $04, $F1, $B8, $FF, $FF

; level CC sprite data
DATA_10FF8F:         db $F4, $DE, $4E, $F4, $DE, $50, $3C, $EC
DATA_10FF97:         db $50, $48, $C8, $4A, $B5, $F4, $53, $B5
DATA_10FF9F:         db $F2, $4B, $FF, $FF

; freespace
DATA_10FFA3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFAB:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFB3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFBB:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFC3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFCB:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFD3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFDB:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFE3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFEB:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFF3:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_10FFFB:         db $FF, $FF, $FF, $FF, $FF
