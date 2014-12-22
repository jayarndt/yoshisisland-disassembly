lorom

org $008000

CODE_008000:        78            SEI                       ; Disable IRQ
CODE_008001:        C2 09         REP #$09                  ;\ Disable emulation mode
CODE_008003:        FB            XCE                       ;/
CODE_008004:        E2 30         SEP #$30                  ;
CODE_008006:        A9 00         LDA #$00                  ;
CODE_008008:        48            PHA                       ;\ set ROM bank
CODE_008009:        AB            PLB                       ;/
CODE_00800A:        48            PHA                       ;\
CODE_00800B:        48            PHA                       ; | init direct page
CODE_00800C:        2B            PLD                       ;/
CODE_00800D:        9C 00 42      STZ $4200                 ; Disable IRQ, NMI and auto-joypad reading
CODE_008010:        9C 16 40      STZ $4016                 ; disable joypad port
CODE_008013:        A9 8F         LDA #$8F                  ;\ Enable F-blank
CODE_008015:        8D 00 21      STA $2100                 ;/
CODE_008018:        A9 01         LDA #$01                  ;\ Enable Backup RAM
CODE_00801A:        8D 33 30      STA $3033                 ;/
CODE_00801D:        9C 06 21      STZ $2106                 ; set pixel size to 1x1
CODE_008020:        9C 40 21      STZ $2140                 ;\
CODE_008023:        9C 41 21      STZ $2141                 ; | Clear SPC I/O ports
CODE_008026:        9C 42 21      STZ $2142                 ; |
CODE_008029:        9C 43 21      STZ $2143                 ;/
CODE_00802C:        A9 FF         LDA #$FF                  ;\ Latch H/V counters in I/O port
CODE_00802E:        8D 01 42      STA $4201                 ;/
CODE_008031:        9C 07 42      STZ $4207                 ;\ init H Timer
CODE_008034:        9C 08 42      STZ $4208                 ;/
CODE_008037:        9C 09 42      STZ $4209                 ;\ init V Timer
CODE_00803A:        9C 0A 42      STZ $420A                 ;/
CODE_00803D:        9C 0B 42      STZ $420B                 ;\ init DMA and HDMA enables
CODE_008040:        9C 0C 42      STZ $420C                 ;/
CODE_008043:        9C 0D 42      STZ $420D                 ; SlowROM
CODE_008046:        C2 20         REP #$20                  ;
CODE_008048:        A9 00 80      LDA #$8000                ;\ Set up OAM
CODE_00804B:        8D 02 21      STA $2102                 ;/
CODE_00804E:        A9 FF 01      LDA #$01FF                ;\ Set up the stack
CODE_008051:        1B            TCS                       ;/
CODE_008052:        E2 20         SEP #$20                  ;
CODE_008054:        22 D0 82 00   JSL CODE_0082D0           ; init RAM and SRAM

CODE_008058:        A2 10         LDX #$10                  ;\ Upload SPC engine
CODE_00805A:        22 43 85 00   JSL CODE_008543           ;/

CODE_00805E:        C2 20         REP #$20                  ;
CODE_008060:        A2 0F         LDX #$0F                  ;\
CODE_008062:        BD 3F 81      LDA $813F,x               ; |
CODE_008065:        9D 00 01      STA $0100,x               ; | copy $008140~$00814E to $0101~$010F
CODE_008068:        CA            DEX                       ; |
CODE_008069:        CA            DEX                       ; |
CODE_00806A:        10 F6         BPL CODE_008062           ;/
CODE_00806C:        A9 00 C0      LDA #$C000                ;\
CODE_00806F:        85 20         STA $20                   ; |
CODE_008071:        A0 7E         LDY #$7E                  ; |
CODE_008073:        84 22         STY $22                   ; |
CODE_008075:        A9 00 C0      LDA #$C000                ; | DMA $00C000~$00FFFF to $7EC000~$7EFFFF
CODE_008078:        85 23         STA $23                   ; |
CODE_00807A:        A0 00         LDY #$00                  ; |
CODE_00807C:        84 25         STY $25                   ; |
CODE_00807E:        A9 00 40      LDA #$4000                ; |
CODE_008081:        22 88 82 00   JSL CODE_008288           ;/

; init GSU stuff, kinda
; sets up clock speed and initializes the RAMBR
CODE_008085:        E2 20         SEP #$20                  ;
CODE_008087:        C2 10         REP #$10                  ;
CODE_008089:        A2 46 00      LDX #$0046                ;\
CODE_00808C:        9E 18 01      STZ $0118,x               ; | init $0118~$015E
CODE_00808F:        CA            DEX                       ; |
CODE_008090:        10 FA         BPL CODE_00808C           ;/
CODE_008092:        E2 10         SEP #$10                  ;
CODE_008094:        A9 01         LDA #$01                  ;\ Sets GSU clock speed
CODE_008096:        8D 39 30      STA $3039                 ;/ 00 = 10.7MHz, 01 = 21.4MHz
CODE_008099:        A9 A0         LDA #$A0                  ;\ mask GSU interrupts and set multiplier frequency to high-speed
CODE_00809B:        8D 37 30      STA $3037                 ;/
CODE_00809E:        A9 16         LDA #$16                  ;\ set SCBR to #$16
CODE_0080A0:        8D 2D 01      STA $012D                 ;/
CODE_0080A3:        A9 3D         LDA #$3D                  ;\ set screen mode to OBJ array, 16-color gradient mode
CODE_0080A5:        8D 2E 01      STA $012E                 ;/ and give GSU ROM/RAM bus access
CODE_0080A8:        C2 20         REP #$20                  ;
CODE_0080AA:        9C 2B 01      STZ $012B                 ;
CODE_0080AD:        9C 16 02      STZ $0216                 ;
CODE_0080B0:        A2 08         LDX #$08                  ;\
CODE_0080B2:        A9 7B A9      LDA #$A97B                ; | initialize RAMBR to #$0000
CODE_0080B5:        22 44 DE 7E   JSL CODE_7EDE44           ;/ GSU init

CODE_0080B9:        E2 20         SEP #$20                  ;
CODE_0080BB:        AF 7D 7E 70   LDA $707E7D               ;\
CODE_0080BF:        D0 08         BNE CODE_0080C9           ; |
CODE_0080C1:        AF 7C 7E 70   LDA $707E7C               ; |
CODE_0080C5:        C9 03         CMP #$03                  ; |
CODE_0080C7:        90 27         BCC CODE_0080F0           ; |
CODE_0080C9:        C2 20         REP #$20                  ; |
CODE_0080CB:        A9 00 00      LDA #$0000                ; | check checksum and nuke it if it's corrupted
CODE_0080CE:        8F 7C 7E 70   STA $707E7C               ; |
CODE_0080D2:        8F 70 7E 70   STA $707E70               ; |
CODE_0080D6:        8F 72 7E 70   STA $707E72               ; |
CODE_0080DA:        8F 74 7E 70   STA $707E74               ; |
CODE_0080DE:        8F 76 7E 70   STA $707E76               ; |
CODE_0080E2:        8F 78 7E 70   STA $707E78               ; |
CODE_0080E6:        8F 7A 7E 70   STA $707E7A               ;/
CODE_0080EA:        22 00 80 10   JSL CODE_108000           ; generate new checksum

CODE_0080EE:        E2 20         SEP #$20                  ;
CODE_0080F0:        58            CLI                       ; enable interrupts

.GameLoop
CODE_0080F1:        AD 1B 01      LDA $011B                 ;\ Wait for interrupt
CODE_0080F4:        30 FB         BMI CODE_0080F1           ;/
CODE_0080F6:        80 38         BRA CODE_008130           ;

CODE_0080F8:        AD 43 09      LDA $0943                 ;
CODE_0080FB:        29 10         AND #$10                  ;
CODE_0080FD:        F0 08         BEQ CODE_008107           ;
CODE_0080FF:        AD 2F 01      LDA $012F                 ;
CODE_008102:        49 01         EOR #$01                  ;
CODE_008104:        8D 2F 01      STA $012F                 ;
CODE_008107:        AD 2F 01      LDA $012F                 ;
CODE_00810A:        F0 24         BEQ CODE_008130           ;
CODE_00810C:        A0 20         LDY #$20                  ;
CODE_00810E:        AD 42 09      LDA $0942                 ;
CODE_008111:        29 10         AND #$10                  ;
CODE_008113:        D0 18         BNE CODE_00812D           ;
CODE_008115:        AD 40 09      LDA $0940                 ;
CODE_008118:        29 30         AND #$30                  ;
CODE_00811A:        D0 05         BNE CODE_008121           ;
CODE_00811C:        9C 30 01      STZ $0130                 ;
CODE_00811F:        80 19         BRA CODE_00813A           ;

CODE_008121:        AD 30 01      LDA $0130                 ;
CODE_008124:        F0 05         BEQ CODE_00812B           ;
CODE_008126:        CE 30 01      DEC $0130                 ;
CODE_008129:        80 0F         BRA CODE_00813A           ;

CODE_00812B:        A0 04         LDY #$04                  ;
CODE_00812D:        8C 30 01      STY $0130                 ;

CODE_008130:        C2 20         REP #$20                  ;\
CODE_008132:        E6 30         INC $30                   ; | Frame beginning
CODE_008134:        E2 20         SEP #$20                  ; |
CODE_008136:        22 50 81 00   JSL CODE_008150           ;/ execute game mode code

CODE_00813A:        CE 1B 01      DEC $011B                 ;\ end and begin new frame
CODE_00813D:        80 B2         BRA CODE_0080F1           ;/

CODE_00813F:        40            RTI                       ;

; this is data copied to RAM to be executed as code later
; copied to $0101~$010F
CODE_008140:        EA            NOP                       ;\
CODE_008141:        EA            NOP                       ; |
CODE_008142:        EA            NOP                       ; |
CODE_008143:        40            RTI                       ; | db $EA,$EA,$EA,$40,$EA,$EA,$EA,$5C
CODE_008144:        EA            NOP                       ; | db $00,$C0,$7E,$5C,$E8,$C3,$7E
CODE_008145:        EA            NOP                       ; |
CODE_008146:        EA            NOP                       ; |
CODE_008147:        5C 00 C0 7E   JML CODE_7EC000           ; | jump to NMI

CODE_00814B:        5C E8 C3 7E   JML CODE_7EC3E8           ;/ jump to IRQ

CODE_00814F:        40            RTI                       ;

CODE_008150:        AD 18 01      LDA $0118                 ;\ get game mode pointer
CODE_008153:        0A            ASL A                     ; |
CODE_008154:        6D 18 01      ADC $0118                 ; |
CODE_008157:        AA            TAX                       ; |
CODE_008158:        8B            PHB                       ; |
CODE_008159:        BD 6C 81      LDA $816C,x               ; |\
CODE_00815C:        48            PHA                       ; | | set pointer bank
CODE_00815D:        48            PHA                       ; | |
CODE_00815E:        AB            PLB                       ; |/
CODE_00815F:        BF 6B 81 00   LDA $00816B,x             ; |\
CODE_008163:        48            PHA                       ; | | set pointer address
CODE_008164:        BF 6A 81 00   LDA $00816A,x             ; | |
CODE_008168:        48            PHA                       ; |/
CODE_008169:        6B            RTL                       ;/ jump to game mode pointer

.GameModePtr
	dl $10838A					;0 Prepare Nintendo Presents
	dl $10891D					;1 Load Nintendo Presents
	dl $0083EF					;2 Fade into Nintendo Presents
	dl $1083E6					;3 Nintendo Presents
	dl $0083CC					;4 Fade out of Nintendo Presents
	dl $0FBDBD					;5 Load cutscene
	dl $0083CC					;6 Fade into cutscene
	dl $0FBEB9					;7 Cutscene
	dl $0083EF					;8 Fade out of cutscene
	dl $1780D5					;9 Load title screen
	dl $1787D4					;A Fade into title screen
	dl $0083CC					;B Level fade out (after entering pipe)
	dl $01AF8F					;C Level fade in + level name
	dl $01B4E0					;D Level fade in after pipe/door
	dl $108D4B					;E Level fade in (after level name)
	dl $01C0D8					;F Level (with control)
	dl $01B57F					;10 Victory cutscenes
	dl $108E85					;11 Death
	dl $0083CC					;12 Death from running out of stars
	dl $0FBB79					;13 Prepare retry screen
	dl $0083CC					;14 Retry screen cutscene fade in
	dl $0FBC65					;15 Retry screen cutscene
	dl $0083FB					;16 Load end of world cutscene
	dl $10E1C0					;17
	dl $1780D5					;18
	dl $1787D4					;19 World cutscene after mecha bowser
	dl $0083CC					;1A Load credits?
	dl $10E1D9					;1B Load/Fade to credits (?)
	dl $10E356					;1C Beginning of credits (during very slow fade in effect)
	dl $10E3CA					;1D Credits
	dl $0083A7					;1E Start+select level fade out
	dl $0083EF					;1F Level fade out to overworld
	dl $17A58D					;20 Prepare overworld
	dl $0083CC					;21 Fade into overworld
	dl $17B3CC					;22 Overworld
	dl $0083CC					;23 Fade to overworld after beating a level (not 100%)
	dl $17B362					;24 Overworld level progression
	dl $0083CC					;25 Fade to overworld after beating a level (100%)
	dl $17AA19					;26 Change level score on overworld
	dl $0083CC					;27 Fade into World score flip cutscene
	dl $17A931					;28 World score flip cutscene
	dl $0083EF					;29 Go to bonus game from high score screen (to 2A)
	dl $109AE7					;2A Prepare/load bonus game
	dl $0083CC					;2B Fade in to bonus game or prepare/load bonus game ??
	dl $10A13A					;2C In bonus game
	dl $0083CC					;2D Throwing balloons minigame
	dl $117FFF					;2E
	dl $0083CC					;2F
	dl $1181D8					;30
	dl $01E26C					;31 Loading/fade to score screen from boss cutscene
	dl $0083CC					;32
	dl $01E52C					;33
	dl $0083CC					;34
	dl $01E5E8					;35 Restart from the middle ring screen
	dl $01E6EF					;36 Restart selection
	dl $0083EF					;37 Fade out of title screen
	dl $10DA32					;38 Load intro cutscene
	dl $10DCAC					;39 Intro cutscene
	dl $0083CC					;3A Retry cutscene fade out
	dl $01E6A1					;3B Prepare retry screen
	dl $0083CC					;3C Fade into retry screen
	dl $01E6B8					;3D Retry screen
	dl $01E6EF					;3E Retry cutscene selection
	dl $10DE3E					;3F Load game over screen ?
	dl $10DF52					;40 Game over screen
	dl $0083CC					;41
	dl $108A99					;42
	dl $0083CC					;43
	dl $1088FA					;44

CODE_008239:        9C 00 42      STZ $4200                 ; disable NMI
CODE_00823C:        9C 0C 42      STZ $420C                 ; disable HDMA
CODE_00823F:        A9 8F         LDA #$8F                  ;\ Enables F-blank
CODE_008241:        8D 00 21      STA $2100                 ;/
CODE_008244:        6B            RTL                       ;

CODE_008245:        A9 81         LDA #$81                  ;\
CODE_008247:        8D 00 42      STA $4200                 ; | enable NMI and auto-joypad read
CODE_00824A:        6B            RTL                       ;/

CODE_00824B:        C2 20         REP #$20                  ;
CODE_00824D:        A2 08         LDX #$08                  ;\
CODE_00824F:        A9 16 BD      LDA #$BD16                ; | initialize OAM routine
CODE_008252:        22 44 DE 7E   JSL CODE_7EDE44           ;/ GSU init

CODE_008256:        E2 20         SEP #$20                  ;
CODE_008258:        6B            RTL                       ;

CODE_008259:        C2 20         REP #$20                  ;
CODE_00825B:        A2 08         LDX #$08                  ;\
CODE_00825D:        A9 D8 B1      LDA #$B1D8                ; | initialize OAM buffer routine
CODE_008260:        22 44 DE 7E   JSL CODE_7EDE44           ;/ GSU init

CODE_008264:        E2 20         SEP #$20                  ;
CODE_008266:        6B            RTL                       ;

CODE_008267:        C2 20         REP #$20                  ;
CODE_008269:        A2 08         LDX #$08                  ;\
CODE_00826B:        A9 89 B2      LDA #$B289                ; | compress OAM high buffer into OAM high table routine
CODE_00826E:        22 44 DE 7E   JSL CODE_7EDE44           ;/ GSU init

CODE_008272:        E2 20         SEP #$20                  ;
CODE_008274:        6B            RTL                       ;

DATA_008275:	     db $FF,$FF

CODE_008277:        A9 03         LDA #$03                  ;
CODE_008279:        8D 27 01      STA $0127                 ;
CODE_00827C:        22 39 82 00   JSL CODE_008239           ;
CODE_008280:        22 4B 82 00   JSL CODE_00824B           ;
CODE_008284:        5C 7B E3 00   JML CODE_00E37B           ;

; DMA $00C000 - $00FFFF to $7EC000 - $7EFFFF
CODE_008288:        8D 05 43      STA $4305                 ;
CODE_00828B:        A5 20         LDA $20                   ;
CODE_00828D:        8D 81 21      STA $2181                 ;
CODE_008290:        A4 22         LDY $22                   ;
CODE_008292:        8C 83 21      STY $2183                 ;
CODE_008295:        A9 00 80      LDA #$8000                ;
CODE_008298:        8D 00 43      STA $4300                 ;
CODE_00829B:        A5 23         LDA $23                   ;
CODE_00829D:        8D 02 43      STA $4302                 ;
CODE_0082A0:        A4 25         LDY $25                   ;
CODE_0082A2:        8C 04 43      STY $4304                 ;
CODE_0082A5:        A0 01         LDY #$01                  ;
CODE_0082A7:        8C 0B 42      STY $420B                 ;
CODE_0082AA:        6B            RTL                       ;

; general-purpose DMA (used for init RAM and SRAM, among other things)
CODE_0082AB:        8D 05 43      STA $4305                 ;
CODE_0082AE:        8C 1B 21      STY $211B                 ;
CODE_0082B1:        A2 00         LDX #$00                  ;
CODE_0082B3:        8E 1B 21      STX $211B                 ;
CODE_0082B6:        E8            INX                       ;
CODE_0082B7:        8E 1C 21      STX $211C                 ;
CODE_0082BA:        A9 80 34      LDA #$3480                ;
CODE_0082BD:        8D 00 43      STA $4300                 ;
CODE_0082C0:        A5 20         LDA $20                   ;
CODE_0082C2:        8D 02 43      STA $4302                 ;
CODE_0082C5:        A6 22         LDX $22                   ;
CODE_0082C7:        8E 04 43      STX $4304                 ;
CODE_0082CA:        A2 01         LDX #$01                  ;
CODE_0082CC:        8E 0B 42      STX $420B                 ;
CODE_0082CF:        6B            RTL                       ;

CODE_0082D0:        22 39 82 00   JSL CODE_008239           ;\
CODE_0082D4:        C2 20         REP #$20                  ; |
CODE_0082D6:        A0 00         LDY #$00                  ; |
CODE_0082D8:        64 20         STZ $20                   ; | clear $7E0000 - $7E00FF
CODE_0082DA:        64 22         STZ $22                   ; |
CODE_0082DC:        A9 00 01      LDA #$0100                ; |
CODE_0082DF:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_0082E3:        A9 00 02      LDA #$0200                ;\
CODE_0082E6:        85 20         STA $20                   ; |
CODE_0082E8:        A2 7E         LDX #$7E                  ; | clear $7E0200 - $7EBFFF
CODE_0082EA:        86 22         STX $22                   ; | 
CODE_0082EC:        A9 00 BE      LDA #$BE00                ; |
CODE_0082EF:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_0082F3:        64 20         STZ $20                   ;\
CODE_0082F5:        A2 7F         LDX #$7F                  ; |
CODE_0082F7:        86 22         STX $22                   ; | clear $7F0000 - $7FFFFF
CODE_0082F9:        A9 00 00      LDA #$0000                ; |
CODE_0082FC:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_008300:        A2 70         LDX #$70                  ;\
CODE_008302:        86 22         STX $22                   ; | clear $700000 - $707BFF
CODE_008304:        A9 00 7C      LDA #$7C00                ; |
CODE_008307:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_00830B:        A9 FF FF      LDA #$FFFF                ;
CODE_00830E:        8F 02 40 7E   STA $7E4002               ;
CODE_008312:        A9 02 48      LDA #$4802                ;
CODE_008315:        8F 00 48 7E   STA $7E4800               ;
CODE_008319:        E2 20         SEP #$20                  ;
CODE_00831B:        6B            RTL                       ;

CODE_00831C:        C2 20         REP #$20                  ;
CODE_00831E:        A0 00         LDY #$00                  ;\
CODE_008320:        64 21         STZ $21                   ; |
CODE_008322:        A9 35 00      LDA #$0035                ; | clear $7E0035 - $7E00EF
CODE_008325:        85 20         STA $20                   ; |
CODE_008327:        A9 CB 00      LDA #$00CB                ; |
CODE_00832A:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_00832E:        A9 3C 09      LDA #$093C                ;\
CODE_008331:        85 20         STA $20                   ; | clear $7E093C - $7E11B6
CODE_008333:        A9 7A 08      LDA #$087A                ; |
CODE_008336:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_00833A:        A9 92 60      LDA #$6092                ;\
CODE_00833D:        85 20         STA $20                   ; | clear $700092 - $7001F7
CODE_00833F:        A9 66 01      LDA #$0166                ; |
CODE_008342:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_008346:        A9 08 7E      LDA #$7E08                ;\
CODE_008349:        85 20         STA $20                   ; | clear $701E08 - $701FEF
CODE_00834B:        A9 E8 01      LDA #$01E8                ; |
CODE_00834E:        22 AB 82 00   JSL CODE_0082AB           ;/

CODE_008352:        A9 04 26      LDA #$2604                ;\
CODE_008355:        85 20         STA $20                   ; |
CODE_008357:        A2 70         LDX #$70                  ; | clear $702604 - $7077FF
CODE_008359:        86 22         STX $22                   ; |
CODE_00835B:        A9 FC 51      LDA #$51FC                ; |
CODE_00835E:        22 AB 82 00   JSL CODE_0082AB           ;/
CODE_008362:        E2 20         SEP #$20                  ;
CODE_008364:        6B            RTL                       ;

.ExecutePtr
CODE_008365:        84 03         STY $03                   ;\ preserve Y
CODE_008367:        7A            PLY                       ; |\ pull the high byte and bank byte and store it in $00
CODE_008368:        84 00         STY $00                   ; |/ to create a pointer to the pointer table 
CODE_00836A:        C2 30         REP #$30                  ; |
CODE_00836C:        29 FF 00      AND #$00FF                ; | allow for a maximum of 256 pointers
CODE_00836F:        0A            ASL A                     ; |\ get the pointer table index and store it in Y
CODE_008370:        A8            TAY                       ; |/
CODE_008371:        68            PLA                       ; |\ pull the high byte and bank byte and store it in $01
CODE_008372:        85 01         STA $01                   ; |/ to create a pointer to the pointer table 
CODE_008374:        C8            INY                       ; | increment to the first byte of the pointer table
CODE_008375:        B7 00         LDA [$00],y               ; | load the pointer
CODE_008377:        85 00         STA $00                   ; | and store the pointer
CODE_008379:        E2 30         SEP #$30                  ; |
CODE_00837B:        A4 03         LDY $03                   ; | restore Y
CODE_00837D:        DC 00 00      JML [$0000]               ;/ jump to the pointer

.ExecutePtrLong
CODE_008380:        84 05         STY $05                   ;\ preserve Y
CODE_008382:        7A            PLY                       ; |\ pull the high byte and bank byte and store it in $02
CODE_008383:        84 02         STY $02                   ; |/ to create a pointer to the pointer table 
CODE_008385:        C2 30         REP #$30                  ; |
CODE_008387:        29 FF 00      AND #$00FF                ; | allow for a maximum of 256 pointers
CODE_00838A:        85 03         STA $03                   ; |\
CODE_00838C:        0A            ASL A                     ; | | multiply the pointer by three
CODE_00838D:        65 03         ADC $03                   ; | |
CODE_00838F:        A8            TAY                       ; |/
CODE_008390:        68            PLA                       ; |\ pull the high byte and bank byte and store it in $03
CODE_008391:        85 03         STA $03                   ; |/ to create a pointer to the pointer table 
CODE_008393:        C8            INY                       ; | increment to the first byte of the pointer table
CODE_008394:        B7 02         LDA [$02],y               ; |\ load and store the first two bytes of the pointer
CODE_008396:        85 00         STA $00                   ; |/
CODE_008398:        C8            INY                       ; | move to the next byte in the pointer table
CODE_008399:        B7 02         LDA [$02],y               ; |\ load and store the last byte of the pointer
CODE_00839B:        85 01         STA $01                   ; |/ (also rereads the high byte)
CODE_00839D:        EB            XBA                       ; |
CODE_00839E:        E2 30         SEP #$30                  ; |
CODE_0083A0:        8B            PHB                       ; |\
CODE_0083A1:        48            PHA                       ; | | load pointer bank
CODE_0083A2:        AB            PLB                       ; |/
CODE_0083A3:        A4 05         LDY $05                   ; | restore Y
CODE_0083A5:        DC 00 00      JML [$0000]               ;/ jump to the pointer

CODE_0083A8:        AE 01 02      LDX $0201                 ;
CODE_0083AB:        AD 00 02      LDA $0200                 ;
CODE_0083AE:        29 0F         AND #$0F                  ;
CODE_0083B0:        DD C6 83      CMP $83C6,x               ;
CODE_0083B3:        D0 32         BNE CODE_0083E7           ;
CODE_0083B5:        8A            TXA                       ;
CODE_0083B6:        49 01         EOR #$01                  ;
CODE_0083B8:        29 01         AND #$01                  ;
CODE_0083BA:        8D 01 02      STA $0201                 ;

CODE_0083BD:        A9 20         LDA #$20                  ;\
CODE_0083BF:        8D 18 01      STA $0118                 ; | jump to prepare overworld game mode
CODE_0083C2:        80 2A         BRA CODE_0083EE           ;/

DATA_0083C4:	     db $01,$FF,$0F,$00,$8B,$A9,$00,$48

; various game modes:
; $04, $06, $0B, $12, $14, $1A, $21, $23, $25, $27
; $2B, $2D, $2F, $32, $34, $3A, $3C, $41, $43
CODE_0083CC:        AB            PLB                       ;
CODE_0083CD:        AE 01 02      LDX $0201                 ;
CODE_0083D0:        AD 00 02      LDA $0200                 ;
CODE_0083D3:        29 0F         AND #$0F                  ;
CODE_0083D5:        DD C6 83      CMP $83C6,x               ;
CODE_0083D8:        D0 0D         BNE CODE_0083E7           ;

CODE_0083DA:        8A            TXA                       ;
CODE_0083DB:        49 01         EOR #$01                  ;
CODE_0083DD:        29 01         AND #$01                  ;
CODE_0083DF:        8D 01 02      STA $0201                 ;
CODE_0083E2:        EE 18 01      INC $0118                 ;
CODE_0083E5:        80 07         BRA CODE_0083EE           ;

CODE_0083E7:        18            CLC                       ;
CODE_0083E8:        7D C4 83      ADC $83C4,x               ;
CODE_0083EB:        8D 00 02      STA $0200                 ;
CODE_0083EE:        AB            PLB                       ;
CODE_0083EF:        6B            RTL                       ;

.gamemode1F
CODE_0083F0:        CE 02 02      DEC $0202                 ;
CODE_0083F3:        10 F9         BPL CODE_0083EE           ;
CODE_0083F5:        A9 02         LDA #$02                  ;
CODE_0083F7:        8D 02 02      STA $0202                 ;
CODE_0083FA:        80 D1         BRA CODE_0083CD           ;

CODE_0083FC:        CE 02 02      DEC $0202                 ;
CODE_0083FF:        10 ED         BPL CODE_0083EE           ;
CODE_008401:        A9 08         LDA #$08                  ;
CODE_008403:        8D 02 02      STA $0202                 ;
CODE_008406:        80 C5         BRA CODE_0083CD           ;

CODE_008408:        08            PHP                       ;
CODE_008409:        E2 20         SEP #$20                  ;
CODE_00840B:        AD 37 21      LDA $2137                 ; latch H/V counter
CODE_00840E:        AD 3F 21      LDA $213F                 ; set "low byte" read for $213C
CODE_008411:        C2 20         REP #$20                  ;
CODE_008413:        AD 3C 21      LDA $213C                 ;\
CODE_008416:        18            CLC                       ; | set horizontal scanline location
CODE_008417:        6D 70 79      ADC $7970                 ; |
CODE_00841A:        8D 70 79      STA $7970                 ;/
CODE_00841D:        28            PLP                       ;
CODE_00841E:        6B            RTL                       ;

.SPC700UploadLoop
CODE_00841F:        08            PHP                       ;\ Preserve processor flags
CODE_008420:        C2 30         REP #$30                  ; |  16 bit A/X/Y
CODE_008422:        A0 00 00      LDY #$0000                ; |
CODE_008425:        A9 AA BB      LDA #$BBAA                ; |\ Value to check if the SPC is ready
							    ; | |
.SPCWait                                                    ; | |
CODE_008428:        CD 40 21      CMP $2140                 ; | | Wait for the SPC to be ready
CODE_00842B:        D0 FB         BNE CODE_008428           ; |/
CODE_00842D:        E2 20         SEP #$20                  ; | 8 bit A
CODE_00842F:        A9 CC         LDA #$CC                  ; |\ Byte used to enable SPC block upload
CODE_008431:        80 26         BRA CODE_008459           ; |/

							    ; |
.TransferBytes                                              ; |\
CODE_008433:        B7 00         LDA [$00],y               ; | | Load the Byte into the low byte
CODE_008435:        C8            INY                       ; | | Increase the index
CODE_008436:        EB            XBA                       ; | | Move it to the high byte
CODE_008437:        A9 00         LDA #$00                  ; |/ Set the validation byte to the low byte
CODE_008439:        80 0B         BRA CODE_008446           ; |

							    ; |
.NextByte                                                   ; |\
CODE_00843B:        EB            XBA                       ; | | Switch the high and low byte
CODE_00843C:        B7 00         LDA [$00],y               ; | | Load a new low byte
CODE_00843E:        C8            INY                       ; | | Increase the index
CODE_00843F:        EB            XBA                       ; |/ Switch the new low byte to the high byte
							    ; |
.SPCWait                                                    ; |\ SPC wait loop
CODE_008440:        CD 40 21      CMP $2140                 ; | | Wait till $2140 matches the validation byte
CODE_008443:        D0 FB         BNE CODE_008440           ; |/
CODE_008445:        1A            INC A                     ; | Increment the validation byte
							    ; |\
CODE_008446:        C2 20         REP #$20                  ; | | 16 bit A 
CODE_008448:        8D 40 21      STA $2140                 ; | | Store to $2140/$2141 
CODE_00844B:        E2 20         SEP #$20                  ; | | 8 bit A 
CODE_00844D:        CA            DEX                       ; |/ Decrement byte counter 
CODE_00844E:        D0 EB         BNE CODE_00843B           ; | 
							    ; |
.SPCWait                                                    ; |\ SPC wait loop 
CODE_008450:        CD 40 21      CMP $2140                 ; | | 
CODE_008453:        D0 FB         BNE CODE_008450           ; |/ 
							    ; |
.AddThree                                                   ; |\ 
CODE_008455:        69 03         ADC #$03                  ; | | If A is 0 add 3 again 
CODE_008457:        F0 FC         BEQ CODE_008455           ; |/ 
							    ; |
.SendSPCBlock						    ; |
CODE_008459:        48            PHA                       ; | Preserve A to store to $2140 later
CODE_00845A:        C2 20         REP #$20                  ; | 16 bit A
CODE_00845C:        B7 00         LDA [$00],y               ; |\
CODE_00845E:        D0 1C         BNE CODE_00847C           ; | | Clear out the address
CODE_008460:        CE 0C 00      DEC $000C                 ; | | (can't use 00 for transfers)
CODE_008463:        30 17         BMI CODE_00847C           ; |/

CODE_008465:        AD 0C 00      LDA $000C                 ;
CODE_008468:        0A            ASL A                     ;
CODE_008469:        6D 0C 00      ADC $000C                 ;
CODE_00846C:        A8            TAY                       ;
CODE_00846D:        B9 03 00      LDA $0003,y               ;
CODE_008470:        85 00         STA $00                   ;
CODE_008472:        B9 04 00      LDA $0004,y               ;
CODE_008475:        85 01         STA $01                   ;
CODE_008477:        A0 00 00      LDY #$0000                ;

CODE_00847A:        B7 00         LDA [$00],y               ; |\ Get data length
CODE_00847C:        C8            INY                       ; | |
CODE_00847D:        C8            INY                       ; | |
CODE_00847E:        AA            TAX                       ; |/
CODE_00847F:        B7 00         LDA [$00],y               ; |\ Get address to write to in SPC RAM
CODE_008481:        C8            INY                       ; | |
CODE_008482:        C8            INY                       ; |/
CODE_008483:        8D 42 21      STA $2142                 ; | Store the address of SPC RAM to write to $2142
CODE_008486:        E2 20         SEP #$20                  ; | 8 bit A
CODE_008488:        E0 01 00      CPX #$0001                ; |
CODE_00848B:        A9 00         LDA #$00                  ; |\ Store the carry flag in $2141
CODE_00848D:        2A            ROL A                     ; | |
CODE_00848E:        8D 41 21      STA $2141                 ; |/
CODE_008491:        69 7F         ADC #$7F                  ; | if A is one this sets the overflow flag
CODE_008493:        68            PLA                       ; |\ Store the A pushed earlier
CODE_008494:        8D 40 21      STA $2140                 ; |/
							    ; |
.SPCWait						    ; |\ SPC wait loop
CODE_008497:        CD 40 21      CMP $2140                 ; | |
CODE_00849A:        D0 FB         BNE CODE_008497           ; |/
CODE_00849C:        70 95         BVS CODE_008433           ; | If the overflow is not set, keep uploading
CODE_00849E:        9C 40 21      STZ $2140                 ; |\ Clear SPC I/O ports
CODE_0084A1:        9C 41 21      STZ $2141                 ; | |
CODE_0084A4:        9C 42 21      STZ $2142                 ; | |
CODE_0084A7:        9C 43 21      STZ $2143                 ; |/
CODE_0084AA:        28            PLP                       ; | Restore processor flag
CODE_0084AB:        60            RTS                       ;/

; SPC data block pointers
.SPCPtr
DATA_0084AC:         dl $4E0000
DATA_0084AF:         dl $4E169C
DATA_0084B2:         dl $4E23BF
DATA_0084B5:         dl $4E2C39
DATA_0084B8:         dl $4E38D2
DATA_0084BB:         dl $4ED0FE
DATA_0084BE:         dl $4ED5D0
DATA_0084C1:         dl $4EE279
DATA_0084C4:         dl $4EEC85
DATA_0084C7:         dl $4F4122
DATA_0084CA:         dl $4F5C48
DATA_0084CD:         dl $4F6E5A
DATA_0084D0:         dl $4F82E6
DATA_0084D3:         dl $4FFCB2
DATA_0084D6:         dl $500342
DATA_0084D9:         dl $4F33F0
DATA_0084DC:         dl $4EFEC1
DATA_0084DF:         dl $4F205D
DATA_0084E2:         dl $4E3E90
DATA_0084E5:         dl $4EBBEC

; SPC data block sets (4 bytes per)
DATA_0084E8:         dd $FFFFFF2B
DATA_0084EC:         dd $FF2E2225
DATA_0084F0:         dd $FF1C2225
DATA_0084F4:         dd $FF131925
DATA_0084F8:         dd $FF101625
DATA_0084FC:         dd $FF0D1625
DATA_008500:         dd $FF282225
DATA_008504:         dd $FF0A1625
DATA_008508:         dd $FF071925
DATA_00850C:         dd $FF1F1925
DATA_008510:         dd $FF040125
DATA_008514:         dd $FFFF3431
DATA_008518:         dd $FFFF3A37

; Item-Denial table for each music track; $00 enables items and $01 disables them
DATA_00851C:         db $00, $00, $00, $01, $00, $01, $00, $01
DATA_008524:         db $01, $01, $00, $00, $01, $00, $00, $00

DATA_00852C:         db $FF, $00, $FF

; SPC data block set to use for each level
DATA_00852F:         dw $100C
DATA_008531:         dw $1C18
DATA_008533:         dw $1C14
DATA_008535:         dw $2420
DATA_008537:         dw $2424
DATA_008539:         dw $2828
DATA_00853B:         dw $1C2C
DATA_00853D:         dw $0000
DATA_00853F:         dw $0400
DATA_008541:         dw $3008

CODE_008543:        8E 4E 01      STX $014E                 ;
CODE_008546:        AE 4E 01      LDX $014E                 ;
CODE_008549:        BF 1C 85 00   LDA $00851C,x             ;
CODE_00854D:        30 03         BMI CODE_008552           ;
CODE_00854F:        8D 48 0B      STA $0B48                 ;
CODE_008552:        E8            INX                       ;
CODE_008553:        EC 03 02      CPX $0203                 ;
CODE_008556:        D0 01         BNE CODE_008559           ;
CODE_008558:        6B            RTL                       ;

CODE_008559:        8E 03 02      STX $0203                 ;
CODE_00855C:        9C 05 02      STZ $0205                 ;
CODE_00855F:        BF 2E 85 00   LDA $00852E,x             ;
CODE_008563:        AA            TAX                       ;
CODE_008564:        64 0C         STZ $0C                   ;
CODE_008566:        64 0D         STZ $0D                   ;
CODE_008568:        64 0E         STZ $0E                   ;
CODE_00856A:        A0 00         LDY #$00                  ;
CODE_00856C:        BF E8 84 00   LDA $0084E8,x             ;
CODE_008570:        D9 07 02      CMP $0207,y               ;
CODE_008573:        F0 2A         BEQ CODE_00859F           ;
CODE_008575:        99 07 02      STA $0207,y               ;
CODE_008578:        C9 FF         CMP #$FF                  ;
CODE_00857A:        F0 23         BEQ CODE_00859F           ;
CODE_00857C:        E6 0C         INC $0C                   ;
CODE_00857E:        DA            PHX                       ;
CODE_00857F:        5A            PHY                       ;
CODE_008580:        AA            TAX                       ;
CODE_008581:        A4 0E         LDY $0E                   ;
CODE_008583:        BF AB 84 00   LDA $0084AB,x             ;
CODE_008587:        99 00 00      STA $0000,y               ;
CODE_00858A:        BF AC 84 00   LDA $0084AC,x             ;
CODE_00858E:        99 01 00      STA $0001,y               ;
CODE_008591:        BF AD 84 00   LDA $0084AD,x             ;
CODE_008595:        99 02 00      STA $0002,y               ;
CODE_008598:        C8            INY                       ;
CODE_008599:        C8            INY                       ;
CODE_00859A:        C8            INY                       ;
CODE_00859B:        84 0E         STY $0E                   ;
CODE_00859D:        7A            PLY                       ;
CODE_00859E:        FA            PLX                       ;
CODE_00859F:        E8            INX                       ;
CODE_0085A0:        C8            INY                       ;
CODE_0085A1:        C0 04         CPY #$04                  ;
CODE_0085A3:        90 C7         BCC CODE_00856C           ;
CODE_0085A5:        C6 0C         DEC $0C                   ;
CODE_0085A7:        30 0A         BMI CODE_0085B3           ;

.UploadDataToSPC
CODE_0085A9:        78            SEI                       ;\ Prevent interrupts from interrupting SPC upload
CODE_0085AA:        A9 FF         LDA #$FF                  ; |
CODE_0085AC:        8D 40 21      STA $2140                 ; |
CODE_0085AF:        20 1F 84      JSR CODE_00841F           ; | Main SPC upload loop
CODE_0085B2:        58            CLI                       ;/ Enable interrupts again

CODE_0085B3:        A2 03         LDX #$03                  ;\
CODE_0085B5:        9E 40 21      STZ $2140,x               ; | clear APU I/O registers
CODE_0085B8:        CA            DEX                       ; |
CODE_0085B9:        10 FA         BPL CODE_0085B5           ;/

CODE_0085BB:        C2 20         REP #$20                  ;
CODE_0085BD:        9C 4D 00      STZ $004D                 ;\
CODE_0085C0:        9C 4F 00      STZ $004F                 ; |
CODE_0085C3:        9C 53 00      STZ $0053                 ; | clear APU I/O mirrors?
CODE_0085C6:        9C 55 00      STZ $0055                 ; |
CODE_0085C9:        9C 57 00      STZ $0057                 ; |
CODE_0085CC:        9C 59 00      STZ $0059                 ;/
CODE_0085CF:        E2 20         SEP #$20                  ;
CODE_0085D1:        6B            RTL                       ;

CODE_0085D2:        AC 57 00      LDY $0057                 ;\
CODE_0085D5:        99 59 00      STA $0059,y               ; | Play sound
CODE_0085D8:        EE 57 00      INC $0057                 ; |
CODE_0085DB:        6B            RTL                       ;/

.init_kamek_OH_MY
CODE_0085DC:        6B            RTL                       ;

DATA_0085DD:		dw $8607
DATA_0085DF:		dw $8641
DATA_0085E1:		dw $8670
DATA_0085E3:		dw $8691

.main_kamek_OH_MY
CODE_0085E5:        A0 01         LDY #$01                  ;
CODE_0085E7:        8C 1E 0C      STY $0C1E                 ;
CODE_0085EA:        B5 78         LDA $78,x                 ;
CODE_0085EC:        38            SEC                       ;
CODE_0085ED:        ED 39 00      SBC $0039                 ;
CODE_0085F0:        C9 F0 00      CMP #$00F0                ;
CODE_0085F3:        30 03         BMI CODE_0085F8           ;
CODE_0085F5:        EE 39 00      INC $0039                 ;
CODE_0085F8:        AD 39 00      LDA $0039                 ;
CODE_0085FB:        8D 23 0C      STA $0C23                 ;
CODE_0085FE:        9B            TXY                       ;
CODE_0085FF:        B5 76         LDA $76,x                 ;
CODE_008601:        0A            ASL A                     ;
CODE_008602:        AA            TAX                       ;
CODE_008603:        FC DD 85      JSR ($85DD,x)             ;

CODE_008606:        6B            RTL                       ;

CODE_008607:        BB            TYX                       ;
CODE_008608:        BD 20 72      LDA $7220,x               ;
CODE_00860B:        30 15         BMI CODE_008622           ;
CODE_00860D:        9E 20 72      STZ $7220,x               ;
CODE_008610:        9E 40 75      STZ $7540,x               ;
CODE_008613:        A9 02 00      LDA #$0002                ;
CODE_008616:        9D 02 74      STA $7402,x               ;
CODE_008619:        A9 20 00      LDA #$0020                ;
CODE_00861C:        9D 96 7A      STA $7A96,x               ;
CODE_00861F:        F6 76         INC $76,x                 ;
CODE_008621:        60            RTS                       ;

CODE_008622:        C9 00 FF      CMP #$FF00                ;
CODE_008625:        30 05         BMI CODE_00862C           ;
CODE_008627:        A9 05 00      LDA #$0005                ;
CODE_00862A:        80 11         BRA CODE_00863D           ;

CODE_00862C:        BD 98 7A      LDA $7A98,x               ;
CODE_00862F:        D0 0F         BNE CODE_008640           ;
CODE_008631:        A9 02 00      LDA #$0002                ;
CODE_008634:        9D 98 7A      STA $7A98,x               ;
CODE_008637:        BD 02 74      LDA $7402,x               ;
CODE_00863A:        49 01 00      EOR #$0001                ;
CODE_00863D:        9D 02 74      STA $7402,x               ;
CODE_008640:        60            RTS                       ;

CODE_008641:        BB            TYX                       ;
CODE_008642:        BD 96 7A      LDA $7A96,x               ;
CODE_008645:        1D 98 7A      ORA $7A98,x               ;
CODE_008648:        D0 25         BNE CODE_00866F           ;
CODE_00864A:        FE 02 74      INC $7402,x               ;
CODE_00864D:        BD 02 74      LDA $7402,x               ;
CODE_008650:        C9 04 00      CMP #$0004                ;
CODE_008653:        D0 14         BNE CODE_008669           ;
CODE_008655:        A9 5B 00      LDA #$005B                ;\ play sound #$005B
CODE_008658:        22 D2 85 00   JSL CODE_0085D2           ;/

CODE_00865C:        A9 82 00      LDA #$0082                ;
CODE_00865F:        8F 70 40 70   STA $704070               ;
CODE_008663:        EE 0F 0D      INC $0D0F                 ;
CODE_008666:        F6 76         INC $76,x                 ;
CODE_008668:        60            RTS                       ;

CODE_008669:        A9 08 00      LDA #$0008                ;
CODE_00866C:        9D 98 7A      STA $7A98,x               ;
CODE_00866F:        60            RTS                       ;

CODE_008670:        BB            TYX                       ;
CODE_008671:        AD 0F 0D      LDA $0D0F                 ;
CODE_008674:        D0 1A         BNE CODE_008690           ;
CODE_008676:        A9 02 00      LDA #$0002                ;
CODE_008679:        9D 02 74      STA $7402,x               ;
CODE_00867C:        A9 00 FC      LDA #$FC00                ;
CODE_00867F:        9D 20 72      STA $7220,x               ;
CODE_008682:        A9 40 00      LDA #$0040                ;
CODE_008685:        9D 40 75      STA $7540,x               ;
CODE_008688:        A9 00 04      LDA #$0400                ;
CODE_00868B:        9D E0 75      STA $75E0,x               ;
CODE_00868E:        F6 76         INC $76,x                 ;
CODE_008690:        60            RTS                       ;

CODE_008691:        BB            TYX                       ;
CODE_008692:        BD 20 72      LDA $7220,x               ;
CODE_008695:        18            CLC                       ;
CODE_008696:        69 80 00      ADC #$0080                ;
CODE_008699:        C9 00 01      CMP #$0100                ;
CODE_00869C:        B0 05         BCS CODE_0086A3           ;
CODE_00869E:        A9 06 00      LDA #$0006                ;
CODE_0086A1:        80 11         BRA CODE_0086B4           ;

CODE_0086A3:        18            CLC                       ;
CODE_0086A4:        69 80 00      ADC #$0080                ;
CODE_0086A7:        C9 00 02      CMP #$0200                ;
CODE_0086AA:        B0 05         BCS CODE_0086B1           ;
CODE_0086AC:        A9 05 00      LDA #$0005                ;
CODE_0086AF:        80 03         BRA CODE_0086B4           ;

CODE_0086B1:        A9 02 00      LDA #$0002                ;
CODE_0086B4:        9D 02 74      STA $7402,x               ;
CODE_0086B7:        BD 20 72      LDA $7220,x               ;
CODE_0086BA:        30 06         BMI CODE_0086C2           ;
CODE_0086BC:        A9 02 00      LDA #$0002                ;
CODE_0086BF:        9D 00 74      STA $7400,x               ;
CODE_0086C2:        BD 80 76      LDA $7680,x               ;
CODE_0086C5:        C9 40 01      CMP #$0140                ;
CODE_0086C8:        30 C6         BMI CODE_008690           ;
CODE_0086CA:        AE 8A 10      LDX $108A                 ;
CODE_0086CD:        BD E2 70      LDA $70E2,x               ;
CODE_0086D0:        85 00         STA $00                   ;
CODE_0086D2:        BD 82 71      LDA $7182,x               ;
CODE_0086D5:        85 02         STA $02                   ;
CODE_0086D7:        22 A3 E1 02   JSL CODE_02E1A3           ;

CODE_0086DB:        AE 8A 10      LDX $108A                 ;
CODE_0086DE:        22 1E A3 03   JSL CODE_03A31E           ;

CODE_0086E2:        A6 12         LDX $12                   ;
CODE_0086E4:        68            PLA                       ;
CODE_0086E5:        5C 1E A3 03   JML CODE_03A31E           ;

.init_background_shyguy
CODE_0086E9:        AC 73 00      LDY $0073                 ;
CODE_0086EC:        F0 04         BEQ CODE_0086F2           ;
CODE_0086EE:        5C 1E A3 03   JML CODE_03A31E           ;

CODE_0086F2:        BD E2 70      LDA $70E2,x               ;
CODE_0086F5:        38            SEC                       ;
CODE_0086F6:        ED 39 00      SBC $0039                 ;
CODE_0086F9:        18            CLC                       ;
CODE_0086FA:        6D 3D 00      ADC $003D                 ;
CODE_0086FD:        9D E2 70      STA $70E2,x               ;
CODE_008700:        9D 00 79      STA $7900,x               ;
CODE_008703:        BD 82 71      LDA $7182,x               ;
CODE_008706:        18            CLC                       ;
CODE_008707:        69 08 00      ADC #$0008                ;
CODE_00870A:        38            SEC                       ;
CODE_00870B:        ED 3B 00      SBC $003B                 ;
CODE_00870E:        18            CLC                       ;
CODE_00870F:        6D 3F 00      ADC $003F                 ;
CODE_008712:        29 F8 FF      AND #$FFF8                ;
CODE_008715:        18            CLC                       ;
CODE_008716:        69 0A 00      ADC #$000A                ;
CODE_008719:        9D 82 71      STA $7182,x               ;
CODE_00871C:        9D 02 79      STA $7902,x               ;
CODE_00871F:        FE A1 74      INC $74A1,x               ;
CODE_008722:        FE A1 74      INC $74A1,x               ;
CODE_008725:        6B            RTL                       ;

DATA_008726:		db $E0,$FF,$20,$00

.main_background_shyguy
CODE_00872A:        22 23 AF 03   JSL CODE_03AF23           ;
CODE_00872E:        22 C7 A2 03   JSL CODE_03A2C7           ;
CODE_008732:        90 04         BCC CODE_008738           ;
CODE_008734:        5C 2E A3 03   JML CODE_03A32E           ;

CODE_008738:        BD 00 74      LDA $7400,x               ;
CODE_00873B:        3A            DEC A                     ;
CODE_00873C:        85 00         STA $00                   ;
CODE_00873E:        BD E2 70      LDA $70E2,x               ;
CODE_008741:        38            SEC                       ;
CODE_008742:        FD 00 79      SBC $7900,x               ;
CODE_008745:        18            CLC                       ;
CODE_008746:        69 20 00      ADC #$0020                ;
CODE_008749:        C9 40 00      CMP #$0040                ;
CODE_00874C:        90 19         BCC CODE_008767           ;
CODE_00874E:        45 00         EOR $00                   ;
CODE_008750:        30 15         BMI CODE_008767           ;

CODE_008752:        A5 10         LDA $10                   ;
CODE_008754:        29 1F 00      AND #$001F                ;
CODE_008757:        18            CLC                       ;
CODE_008758:        69 30 00      ADC #$0030                ;
CODE_00875B:        9D F6 7A      STA $7AF6,x               ;
CODE_00875E:        BD 00 74      LDA $7400,x               ;
CODE_008761:        49 02 00      EOR #$0002                ;
CODE_008764:        9D 00 74      STA $7400,x               ;
CODE_008767:        BC F6 7A      LDY $7AF6,x               ;
CODE_00876A:        F0 E6         BEQ CODE_008752           ;
CODE_00876C:        BC 00 74      LDY $7400,x               ;
CODE_00876F:        B9 26 87      LDA $8726,y               ;
CODE_008772:        9D 20 72      STA $7220,x               ;
CODE_008775:        BC 98 7A      LDY $7A98,x               ;
CODE_008778:        D0 0F         BNE CODE_008789           ;
CODE_00877A:        A9 08 00      LDA #$0008                ;
CODE_00877D:        9D 98 7A      STA $7A98,x               ;
CODE_008780:        BD 02 74      LDA $7402,x               ;
CODE_008783:        49 01 00      EOR #$0001                ;
CODE_008786:        9D 02 74      STA $7402,x               ;
CODE_008789:        6B            RTL                       ;

.init_skinny_platform
CODE_00878A:        9E 00 74      STZ $7400,x               ;
CODE_00878D:        6B            RTL                       ;

.main_skinny_platform
CODE_00878E:        C2 10         REP #$10                  ;
CODE_008790:        BC 62 73      LDY $7362,x               ;
CODE_008793:        BD 82 76      LDA $7682,x               ;
CODE_008796:        85 00         STA $00                   ;
CODE_008798:        BD 36 7A      LDA $7A36,x               ;
CODE_00879B:        29 FF 00      AND #$00FF                ;
CODE_00879E:        18            CLC                       ;
CODE_00879F:        65 00         ADC $00                   ;
CODE_0087A1:        99 02 60      STA $6002,y               ;
CODE_0087A4:        BD 37 7A      LDA $7A37,x               ;
CODE_0087A7:        29 FF 00      AND #$00FF                ;
CODE_0087AA:        18            CLC                       ;
CODE_0087AB:        65 00         ADC $00                   ;
CODE_0087AD:        99 0A 60      STA $600A,y               ;
CODE_0087B0:        BD 38 7A      LDA $7A38,x               ;
CODE_0087B3:        29 FF 00      AND #$00FF                ;
CODE_0087B6:        18            CLC                       ;
CODE_0087B7:        65 00         ADC $00                   ;
CODE_0087B9:        99 12 60      STA $6012,y               ;
CODE_0087BC:        BD 39 7A      LDA $7A39,x               ;
CODE_0087BF:        29 FF 00      AND #$00FF                ;
CODE_0087C2:        18            CLC                       ;
CODE_0087C3:        65 00         ADC $00                   ;
CODE_0087C5:        99 1A 60      STA $601A,y               ;
CODE_0087C8:        BD 00 79      LDA $7900,x               ;
CODE_0087CB:        29 FF 00      AND #$00FF                ;
CODE_0087CE:        18            CLC                       ;
CODE_0087CF:        65 00         ADC $00                   ;
CODE_0087D1:        99 22 60      STA $6022,y               ;
CODE_0087D4:        BD 01 79      LDA $7901,x               ;
CODE_0087D7:        29 FF 00      AND #$00FF                ;
CODE_0087DA:        18            CLC                       ;
CODE_0087DB:        65 00         ADC $00                   ;
CODE_0087DD:        99 2A 60      STA $602A,y               ;
CODE_0087E0:        BD 02 79      LDA $7902,x               ;
CODE_0087E3:        29 FF 00      AND #$00FF                ;
CODE_0087E6:        18            CLC                       ;
CODE_0087E7:        65 00         ADC $00                   ;
CODE_0087E9:        99 32 60      STA $6032,y               ;
CODE_0087EC:        BD 03 79      LDA $7903,x               ;
CODE_0087EF:        29 FF 00      AND #$00FF                ;
CODE_0087F2:        18            CLC                       ;
CODE_0087F3:        65 00         ADC $00                   ;
CODE_0087F5:        99 3A 60      STA $603A,y               ;
CODE_0087F8:        E2 10         SEP #$10                  ;
CODE_0087FA:        AD FC 60      LDA $60FC                 ;
CODE_0087FD:        29 03 00      AND #$0003                ;
CODE_008800:        D0 09         BNE CODE_00880B           ;
CODE_008802:        AD 90 60      LDA $6090                 ;
CODE_008805:        18            CLC                       ;
CODE_008806:        75 18         ADC $18,x                 ;
CODE_008808:        8D 90 60      STA $6090                 ;
CODE_00880B:        BD 36 7A      LDA $7A36,x               ;
CODE_00880E:        29 FF 00      AND #$00FF                ;
CODE_008811:        8D 00 60      STA $6000                 ;
CODE_008814:        85 00         STA $00                   ;
CODE_008816:        BD 37 7A      LDA $7A37,x               ;
CODE_008819:        29 FF 00      AND #$00FF                ;
CODE_00881C:        8D 02 60      STA $6002                 ;
CODE_00881F:        85 02         STA $02                   ;
CODE_008821:        BD 38 7A      LDA $7A38,x               ;
CODE_008824:        29 FF 00      AND #$00FF                ;
CODE_008827:        8D 04 60      STA $6004                 ;
CODE_00882A:        85 04         STA $04                   ;
CODE_00882C:        BD 39 7A      LDA $7A39,x               ;
CODE_00882F:        29 FF 00      AND #$00FF                ;
CODE_008832:        8D 06 60      STA $6006                 ;
CODE_008835:        85 06         STA $06                   ;
CODE_008837:        BD 00 79      LDA $7900,x               ;
CODE_00883A:        29 FF 00      AND #$00FF                ;
CODE_00883D:        8D 08 60      STA $6008                 ;

CODE_008840:        85 08         STA $08                   ;
CODE_008842:        BD 01 79      LDA $7901,x               ;
CODE_008845:        29 FF 00      AND #$00FF                ;
CODE_008848:        8D 0A 60      STA $600A                 ;
CODE_00884B:        85 0A         STA $0A                   ;
CODE_00884D:        BD 02 79      LDA $7902,x               ;
CODE_008850:        29 FF 00      AND #$00FF                ;
CODE_008853:        8D 0C 60      STA $600C                 ;
CODE_008856:        85 0C         STA $0C                   ;
CODE_008858:        BD 03 79      LDA $7903,x               ;
CODE_00885B:        29 FF 00      AND #$00FF                ;
CODE_00885E:        8D 0E 60      STA $600E                 ;
CODE_008861:        85 0E         STA $0E                   ;
CODE_008863:        9C 02 30      STZ $3002                 ;
CODE_008866:        AC AB 60      LDY $60AB                 ;

CODE_008869:        10 05         BPL CODE_008870           ;
CODE_00886B:        AC C0 60      LDY $60C0                 ;
CODE_00886E:        D0 57         BNE CODE_0088C7           ;
CODE_008870:        AD 1C 61      LDA $611C                 ;
CODE_008873:        38            SEC                       ;
CODE_008874:        FD E2 70      SBC $70E2,x               ;
CODE_008877:        18            CLC                       ;
CODE_008878:        69 20 00      ADC #$0020                ;
CODE_00887B:        C9 40 00      CMP #$0040                ;
CODE_00887E:        B0 4F         BCS CODE_0088CF           ;
CODE_008880:        8D 04 30      STA $3004                 ;
CODE_008883:        BD E2 70      LDA $70E2,x               ;
CODE_008886:        38            SEC                       ;
CODE_008887:        E9 18 00      SBC #$0018                ;
CODE_00888A:        38            SEC                       ;
CODE_00888B:        ED 1C 61      SBC $611C                 ;
CODE_00888E:        8D 06 30      STA $3006                 ;
CODE_008891:        A9 46 00      LDA #$0046                ;
CODE_008894:        18            CLC                       ;
CODE_008895:        75 78         ADC $78,x                 ;
CODE_008897:        8D 3E 60      STA $603E                 ;
CODE_00889A:        4A            LSR A                     ;
CODE_00889B:        8D 3C 60      STA $603C                 ;
CODE_00889E:        8D 0C 30      STA $300C                 ;
CODE_0088A1:        AD 1E 61      LDA $611E                 ;
CODE_0088A4:        18            CLC                       ;
CODE_0088A5:        6D 12 61      ADC $6112                 ;
CODE_0088A8:        8D 10 30      STA $3010                 ;
CODE_0088AB:        AD 22 61      LDA $6122                 ;
CODE_0088AE:        8D 12 30      STA $3012                 ;
CODE_0088B1:        BD 82 71      LDA $7182,x               ;
CODE_0088B4:        8D 14 30      STA $3014                 ;
CODE_0088B7:        A2 0B         LDX #$0B                  ;
CODE_0088B9:        A9 0A 86      LDA #$860A                ;
CODE_0088BC:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_0088C0:        A6 12         LDX $12                   ;
CODE_0088C2:        AC 02 30      LDY $3002                 ;
CODE_0088C5:        D0 2E         BNE CODE_0088F5           ;
CODE_0088C7:        BD 22 72      LDA $7222,x               ;
CODE_0088CA:        F0 03         BEQ CODE_0088CF           ;
CODE_0088CC:        4C 9F 89      JMP CODE_00899F           ;

CODE_0088CF:        A0 0E         LDY #$0E                  ;
CODE_0088D1:        B9 60 79      LDA $7960,y               ;
CODE_0088D4:        F0 16         BEQ CODE_0088EC           ;
CODE_0088D6:        C9 08 00      CMP #$0008                ;
CODE_0088D9:        10 03         BPL CODE_0088DE           ;
CODE_0088DB:        A9 08 00      LDA #$0008                ;
CODE_0088DE:        4A            LSR A                     ;
CODE_0088DF:        4A            LSR A                     ;
CODE_0088E0:        4A            LSR A                     ;
CODE_0088E1:        49 FF FF      EOR #$FFFF                ;
CODE_0088E4:        1A            INC A                     ;
CODE_0088E5:        18            CLC                       ;
CODE_0088E6:        79 60 79      ADC $7960,y               ;
CODE_0088E9:        99 60 79      STA $7960,y               ;
CODE_0088EC:        88            DEY                       ;
CODE_0088ED:        88            DEY                       ;
CODE_0088EE:        10 E1         BPL CODE_0088D1           ;
CODE_0088F0:        74 18         STZ $18,x                 ;
CODE_0088F2:        4C 85 89      JMP CODE_008985           ;

CODE_0088F5:        BD 22 72      LDA $7222,x               ;
CODE_0088F8:        F0 20         BEQ CODE_00891A           ;
CODE_0088FA:        A0 0E         LDY #$0E                  ;
CODE_0088FC:        B9 00 60      LDA $6000,y               ;
CODE_0088FF:        38            SEC                       ;
CODE_008900:        F9 60 79      SBC $7960,y               ;
CODE_008903:        30 0F         BMI CODE_008914           ;
CODE_008905:        C9 00 80      CMP #$8000                ;
CODE_008908:        6A            ROR A                     ;
CODE_008909:        C9 00 80      CMP #$8000                ;
CODE_00890C:        6A            ROR A                     ;
CODE_00890D:        18            CLC                       ;
CODE_00890E:        79 60 79      ADC $7960,y               ;
CODE_008911:        99 60 79      STA $7960,y               ;
CODE_008914:        88            DEY                       ;
CODE_008915:        88            DEY                       ;
CODE_008916:        10 E4         BPL CODE_0088FC           ;
CODE_008918:        80 1C         BRA CODE_008936           ;

CODE_00891A:        A0 0E         LDY #$0E                  ;
CODE_00891C:        B9 00 60      LDA $6000,y               ;
CODE_00891F:        38            SEC                       ;
CODE_008920:        F9 60 79      SBC $7960,y               ;
CODE_008923:        C9 00 80      CMP #$8000                ;
CODE_008926:        6A            ROR A                     ;
CODE_008927:        C9 00 80      CMP #$8000                ;
CODE_00892A:        6A            ROR A                     ;
CODE_00892B:        18            CLC                       ;
CODE_00892C:        79 60 79      ADC $7960,y               ;
CODE_00892F:        99 60 79      STA $7960,y               ;
CODE_008932:        88            DEY                       ;
CODE_008933:        88            DEY                       ;
CODE_008934:        10 E6         BPL CODE_00891C           ;
CODE_008936:        B4 18         LDY $18,x                 ;
CODE_008938:        D0 15         BNE CODE_00894F           ;
CODE_00893A:        AD AA 60      LDA $60AA                 ;
CODE_00893D:        4A            LSR A                     ;
CODE_00893E:        4A            LSR A                     ;
CODE_00893F:        4A            LSR A                     ;
CODE_008940:        4A            LSR A                     ;
CODE_008941:        95 78         STA $78,x                 ;
CODE_008943:        AC D4 60      LDY $60D4                 ;
CODE_008946:        F0 07         BEQ CODE_00894F           ;
CODE_008948:        AD AA 60      LDA $60AA                 ;
CODE_00894B:        4A            LSR A                     ;
CODE_00894C:        9D 22 72      STA $7222,x               ;
CODE_00894F:        AD FC 60      LDA $60FC                 ;
CODE_008952:        29 03 00      AND #$0003                ;
CODE_008955:        D0 2E         BNE CODE_008985           ;
CODE_008957:        AD 20 60      LDA $6020                 ;
CODE_00895A:        29 FE FF      AND #$FFFE                ;
CODE_00895D:        A8            TAY                       ;
CODE_00895E:        B9 60 79      LDA $7960,y               ;
CODE_008961:        18            CLC                       ;
CODE_008962:        7D 82 71      ADC $7182,x               ;
CODE_008965:        38            SEC                       ;
CODE_008966:        E9 1E 00      SBC #$001E                ;
CODE_008969:        38            SEC                       ;
CODE_00896A:        ED 12 61      SBC $6112                 ;
CODE_00896D:        8D 90 60      STA $6090                 ;
CODE_008970:        9C AA 60      STZ $60AA                 ;
CODE_008973:        EE B4 61      INC $61B4                 ;
CODE_008976:        A0 02         LDY #$02                  ;
CODE_008978:        94 18         STY $18,x                 ;
CODE_00897A:        BD 22 72      LDA $7222,x               ;
CODE_00897D:        F0 06         BEQ CODE_008985           ;
CODE_00897F:        A9 00 08      LDA #$0800                ;
CODE_008982:        8D AA 60      STA $60AA                 ;
CODE_008985:        BD 22 72      LDA $7222,x               ;
CODE_008988:        F0 08         BEQ CODE_008992           ;
CODE_00898A:        B5 78         LDA $78,x                 ;
CODE_00898C:        18            CLC                       ;
CODE_00898D:        69 04 00      ADC #$0004                ;
CODE_008990:        80 0B         BRA CODE_00899D           ;

CODE_008992:        B5 78         LDA $78,x                 ;
CODE_008994:        38            SEC                       ;
CODE_008995:        E9 08 00      SBC #$0008                ;
CODE_008998:        10 03         BPL CODE_00899D           ;
CODE_00899A:        A9 00 00      LDA #$0000                ;
CODE_00899D:        95 78         STA $78,x                 ;
CODE_00899F:        E2 20         SEP #$20                  ;
CODE_0089A1:        A5 00         LDA $00                   ;
CODE_0089A3:        9D 36 7A      STA $7A36,x               ;
CODE_0089A6:        A5 02         LDA $02                   ;
CODE_0089A8:        9D 37 7A      STA $7A37,x               ;
CODE_0089AB:        A5 04         LDA $04                   ;
CODE_0089AD:        9D 38 7A      STA $7A38,x               ;
CODE_0089B0:        A5 06         LDA $06                   ;
CODE_0089B2:        9D 39 7A      STA $7A39,x               ;
CODE_0089B5:        A5 08         LDA $08                   ;
CODE_0089B7:        9D 00 79      STA $7900,x               ;
CODE_0089BA:        A5 0A         LDA $0A                   ;
CODE_0089BC:        9D 01 79      STA $7901,x               ;
CODE_0089BF:        A5 0C         LDA $0C                   ;
CODE_0089C1:        9D 02 79      STA $7902,x               ;
CODE_0089C4:        A5 0E         LDA $0E                   ;
CODE_0089C6:        9D 03 79      STA $7903,x               ;
CODE_0089C9:        C2 20         REP #$20                  ;
CODE_0089CB:        6B            RTL                       ;

; pointer table (address - 1)
DATA_0089CC:         dw $8CBE, $8D03, $8D36, $8D74
DATA_0089D4:         dw $8D8E, $8DA4, $8DB1, $8DE6
DATA_0089DC:         dw $8DF7, $8E15, $8E36, $8E5D
DATA_0089E4:         dw $8E7D, $8EEE, $8EFD, $8F0A
DATA_0089EC:         dw $8F3A, $8F69, $8F9A, $8FD1
DATA_0089F4:         dw $9006, $9027, $9098, $90B9
DATA_0089FC:         dw $90C2, $AD09, $90F5, $912C
DATA_008A04:         dw $9153, $9518, $917A, $919F
DATA_008A0C:         dw $91C6, $9219, $9253, $927C
DATA_008A14:         dw $92ED, $9375, $93A3, $93DD
DATA_008A1C:         dw $9432, $9518, $9547, $955E
DATA_008A24:         dw $92AC, $92A4, $955E, $9518
DATA_008A2C:         dw $9518, $9518, $9518, $9547
DATA_008A34:         dw $A7D9, $9530, $961A, $9530
DATA_008A3C:         dw $9645, $95CB, $9530, $986C
DATA_008A44:         dw $986C, $9518, $958C, $986C
DATA_008A4C:         dw $9575, $9575, $9518, $9547
DATA_008A54:         dw $9415, $9ADC, $9B12, $9530
DATA_008A5C:         dw $9518, $9530, $9530, $955E
DATA_008A64:         dw $9B54, $9518, $9B87, $9BBB
DATA_008A6C:         dw $9BE2, $9C1C, $9E91, $9518
DATA_008A74:         dw $9518, $951C, $A192, $A192
DATA_008A7C:         dw $A550, $A56E, $A599, $9ADC
DATA_008A84:         dw $A6A8, $A6CD, $A834, $A6A8
DATA_008A8C:         dw $A725, $9B54, $A758, $A775
DATA_008A94:         dw $9518, $A78C, $A7A3, $A7F6
DATA_008A9C:         dw $9530, $9518, $A80D, $9518
DATA_008AA4:         dw $8D95, $9219, $9518, $9518
DATA_008AAC:         dw $98AB, $9912, $9997, $9A18
DATA_008AB4:         dw $9A65

$00/8AB6 8B          PHB                     ;
$00/8AB7 4B          PHK                     ;
$00/8AB8 AB          PLB                     ;
$00/8AB9 AD B0 61    LDA $61B0  [$00:61B0]   ;
$00/8ABC 0D 55 0B    ORA $0B55  [$00:0B55]   ;
$00/8ABF 0D 98 03    ORA $0398  [$00:0398]   ;
$00/8AC2 8D 8F 0B    STA $0B8F  [$00:0B8F]   ;
$00/8AC5 A2 3C       LDX #$3C                ;
$00/8AC7 BC C0 6E    LDY $6EC0,x[$00:6EC0]   ;
$00/8ACA F0 03       BEQ $03    [$8ACF]      ;
$00/8ACC 20 D7 8A    JSR $8AD7  [$00:8AD7]   ;
$00/8ACF CA          DEX                     ;
$00/8AD0 CA          DEX                     ;
$00/8AD1 CA          DEX                     ;
$00/8AD2 CA          DEX                     ;
$00/8AD3 10 F2       BPL $F2    [$8AC7]      ;
$00/8AD5 AB          PLB                     ;
$00/8AD6 6B          RTL                     ;

CODE_008AD7:        BD 20 73      LDA $7320,x               ;
CODE_008ADA:        0A            ASL A                     ;
CODE_008ADB:        C2 10         REP #$10                  ;
CODE_008ADD:        A8            TAY                       ;
CODE_008ADE:        B9 58 86      LDA $8658,y               ;
CODE_008AE1:        E2 10         SEP #$10                  ;
CODE_008AE3:        48            PHA                       ;
CODE_008AE4:        60            RTS                       ;

CODE_008AE5:        AD 8F 0B      LDA $0B8F                 ;
CODE_008AE8:        F0 08         BEQ CODE_008AF2           ;
CODE_008AEA:        68            PLA                       ;
CODE_008AEB:        60            RTS                       ;

CODE_008AEC:        AD 8F 0B      LDA $0B8F                 ;
CODE_008AEF:        F0 01         BEQ CODE_008AF2           ;
CODE_008AF1:        60            RTS                       ;

CODE_008AF2:        BD 82 77      LDA $7782,x               ;
CODE_008AF5:        D0 16         BNE CODE_008B0D           ;
CODE_008AF7:        68            PLA                       ;

CODE_008AF8:        9E C0 6E      STZ $6EC0,x               ;
CODE_008AFB:        A9 FF 00      LDA #$00FF                ;
CODE_008AFE:        9D 62 74      STA $7462,x               ;
CODE_008B01:        BC E2 76      LDY $76E2,x               ;
CODE_008B04:        30 06         BMI CODE_008B0C           ;
CODE_008B06:        B9 CE 7E      LDA $7ECE,y               ;
CODE_008B09:        1C CC 7E      TRB $7ECC                 ;
CODE_008B0C:        60            RTS                       ;

CODE_008B0D:        DE 82 77      DEC $7782,x               ;
CODE_008B10:        BD 8E 7E      LDA $7E8E,x               ;
CODE_008B13:        F0 03         BEQ CODE_008B18           ;
CODE_008B15:        DE 8E 7E      DEC $7E8E,x               ;
CODE_008B18:        BC 81 77      LDY $7781,x               ;
CODE_008B1B:        F0 03         BEQ CODE_008B20           ;
CODE_008B1D:        DE 81 77      DEC $7781,x               ;
CODE_008B20:        60            RTS                       ;

; spawn sprite
CODE_008B21:        48            PHA                       ;
CODE_008B22:        A0 3C         LDY #$3C                  ;
CODE_008B24:        B9 C0 6E      LDA $6EC0,y               ;
CODE_008B27:        F0 14         BEQ CODE_008B3D           ;
CODE_008B29:        88            DEY                       ;
CODE_008B2A:        88            DEY                       ;
CODE_008B2B:        88            DEY                       ;
CODE_008B2C:        88            DEY                       ;
CODE_008B2D:        10 F5         BPL CODE_008B24           ;
CODE_008B2F:        AC 4A 7E      LDY $7E4A                 ;
CODE_008B32:        88            DEY                       ;
CODE_008B33:        88            DEY                       ;
CODE_008B34:        88            DEY                       ;
CODE_008B35:        88            DEY                       ;
CODE_008B36:        10 02         BPL CODE_008B3A           ;
CODE_008B38:        A0 3C         LDY #$3C                  ;
CODE_008B3A:        8C 4A 7E      STY $7E4A                 ;
CODE_008B3D:        A9 00 00      LDA #$0000                ;
CODE_008B40:        99 E0 71      STA $71E0,y               ;
CODE_008B43:        99 E2 71      STA $71E2,y               ;
CODE_008B46:        99 C0 73      STA $73C0,y               ;
CODE_008B49:        99 A0 70      STA $70A0,y               ;
CODE_008B4C:        99 40 71      STA $7140,y               ;
CODE_008B4F:        99 4C 7E      STA $7E4C,y               ;
CODE_008B52:        99 4E 7E      STA $7E4E,y               ;
CODE_008B55:        99 8C 7E      STA $7E8C,y               ;
CODE_008B58:        99 82 77      STA $7782,y               ;
CODE_008B5B:        99 8E 7E      STA $7E8E,y               ;
CODE_008B5E:        99 C2 73      STA $73C2,y               ;
CODE_008B61:        99 20 78      STA $7820,y               ;
CODE_008B64:        99 C2 6E      STA $6EC2,y               ;
CODE_008B67:        99 E0 76      STA $76E0,y               ;
CODE_008B6A:        99 40 76      STA $7640,y               ;
CODE_008B6D:        99 42 76      STA $7642,y               ;
CODE_008B70:        99 00 75      STA $7500,y               ;
CODE_008B73:        99 A0 75      STA $75A0,y               ;
CODE_008B76:        99 80 77      STA $7780,y               ;
CODE_008B79:        3A            DEC A                     ;
CODE_008B7A:        99 22 73      STA $7322,y               ;
CODE_008B7D:        99 E2 76      STA $76E2,y               ;
CODE_008B80:        A9 FF 1F      LDA #$1FFF                ;
CODE_008B83:        99 22 78      STA $7822,y               ;
CODE_008B86:        68            PLA                       ;
CODE_008B87:        99 20 73      STA $7320,y               ;
CODE_008B8A:        DA            PHX                       ;
CODE_008B8B:        0A            ASL A                     ;
CODE_008B8C:        C2 10         REP #$10                  ;
CODE_008B8E:        AA            TAX                       ;
CODE_008B8F:        E2 20         SEP #$20                  ;
CODE_008B91:        5A            PHY                       ;
CODE_008B92:        BF 9E B5 0A   LDA $0AB59E,x             ;
CODE_008B96:        A0 06 00      LDY #$0006                ;
CODE_008B99:        D9 B5 6E      CMP $6EB5,y               ;
CODE_008B9C:        F0 06         BEQ CODE_008BA4           ;
CODE_008B9E:        88            DEY                       ;
CODE_008B9F:        D0 F8         BNE CODE_008B99           ;
CODE_008BA1:        98            TYA                       ;
CODE_008BA2:        80 05         BRA CODE_008BA9           ;

CODE_008BA4:        98            TYA                       ;
CODE_008BA5:        69 06         ADC #$06                  ;
CODE_008BA7:        0A            ASL A                     ;
CODE_008BA8:        0A            ASL A                     ;
CODE_008BA9:        C2 20         REP #$20                  ;
CODE_008BAB:        29 FF 00      AND #$00FF                ;
CODE_008BAE:        7A            PLY                       ;
CODE_008BAF:        99 40 71      STA $7140,y               ;
CODE_008BB2:        BF 9F B1 0A   LDA $0AB19F,x             ;
CODE_008BB6:        29 FF 00      AND #$00FF                ;
CODE_008BB9:        49 30 00      EOR #$0030                ;
CODE_008BBC:        99 02 70      STA $7002,y               ;
CODE_008BBF:        BF 9E B1 0A   LDA $0AB19E,x             ;
CODE_008BC3:        29 FF 00      AND #$00FF                ;
CODE_008BC6:        99 62 74      STA $7462,y               ;
CODE_008BC9:        BF 9D B3 0A   LDA $0AB39D,x             ;
CODE_008BCD:        29 00 FF      AND #$FF00                ;
CODE_008BD0:        10 03         BPL CODE_008BD5           ;
CODE_008BD2:        09 FF 00      ORA #$00FF                ;
CODE_008BD5:        EB            XBA                       ;
CODE_008BD6:        99 02 75      STA $7502,y               ;
CODE_008BD9:        BF 9E B3 0A   LDA $0AB39E,x             ;
CODE_008BDD:        29 00 FF      AND #$FF00                ;
CODE_008BE0:        10 03         BPL CODE_008BE5           ;
CODE_008BE2:        09 FF 00      ORA #$00FF                ;
CODE_008BE5:        EB            XBA                       ;
CODE_008BE6:        0A            ASL A                     ;
CODE_008BE7:        0A            ASL A                     ;
CODE_008BE8:        0A            ASL A                     ;
CODE_008BE9:        0A            ASL A                     ;
CODE_008BEA:        99 A2 75      STA $75A2,y               ;
CODE_008BED:        BF 9E AB 0A   LDA $0AAB9E,x             ;
CODE_008BF1:        99 60 6F      STA $6F60,y               ;
CODE_008BF4:        BF 9E AD 0A   LDA $0AAD9E,x             ;
CODE_008BF8:        99 62 6F      STA $6F62,y               ;
CODE_008BFB:        BF 9E AF 0A   LDA $0AAF9E,x             ;
CODE_008BFF:        99 00 70      STA $7000,y               ;
CODE_008C02:        A9 0E 00      LDA #$000E                ;
CODE_008C05:        99 C0 6E      STA $6EC0,y               ;
CODE_008C08:        A9 FF 00      LDA #$00FF                ;
CODE_008C0B:        99 60 74      STA $7460,y               ;
CODE_008C0E:        E2 10         SEP #$10                  ;
CODE_008C10:        FA            PLX                       ;
CODE_008C11:        6B            RTL                       ;

CODE_008C12:        BD A0 75      LDA $75A0,x               ;
CODE_008C15:        38            SEC                       ;
CODE_008C16:        FD E0 71      SBC $71E0,x               ;
CODE_008C19:        0A            ASL A                     ;
CODE_008C1A:        BD 00 75      LDA $7500,x               ;
CODE_008C1D:        90 04         BCC CODE_008C23           ;
CODE_008C1F:        49 FF FF      EOR #$FFFF                ;
CODE_008C22:        1A            INC A                     ;
CODE_008C23:        18            CLC                       ;
CODE_008C24:        7D E0 71      ADC $71E0,x               ;
CODE_008C27:        9D E0 71      STA $71E0,x               ;
CODE_008C2A:        29 FF 00      AND #$00FF                ;
CODE_008C2D:        EB            XBA                       ;
CODE_008C2E:        18            CLC                       ;
CODE_008C2F:        7D A0 70      ADC $70A0,x               ;
CODE_008C32:        9D A0 70      STA $70A0,x               ;
CODE_008C35:        BD E0 71      LDA $71E0,x               ;
CODE_008C38:        29 00 FF      AND #$FF00                ;
CODE_008C3B:        10 03         BPL CODE_008C40           ;
CODE_008C3D:        09 FF 00      ORA #$00FF                ;
CODE_008C40:        EB            XBA                       ;
CODE_008C41:        69 00 00      ADC #$0000                ;
CODE_008C44:        9D 80 72      STA $7280,x               ;
CODE_008C47:        18            CLC                       ;
CODE_008C48:        7D A2 70      ADC $70A2,x               ;
CODE_008C4B:        9D A2 70      STA $70A2,x               ;
CODE_008C4E:        BD A2 75      LDA $75A2,x               ;
CODE_008C51:        38            SEC                       ;
CODE_008C52:        FD E2 71      SBC $71E2,x               ;
CODE_008C55:        0A            ASL A                     ;
CODE_008C56:        BD 02 75      LDA $7502,x               ;
CODE_008C59:        90 04         BCC CODE_008C5F           ;
CODE_008C5B:        49 FF FF      EOR #$FFFF                ;
CODE_008C5E:        1A            INC A                     ;
CODE_008C5F:        18            CLC                       ;
CODE_008C60:        7D E2 71      ADC $71E2,x               ;
CODE_008C63:        9D E2 71      STA $71E2,x               ;
CODE_008C66:        29 FF 00      AND #$00FF                ;
CODE_008C69:        EB            XBA                       ;
CODE_008C6A:        18            CLC                       ;
CODE_008C6B:        7D 40 71      ADC $7140,x               ;
CODE_008C6E:        9D 40 71      STA $7140,x               ;
CODE_008C71:        BD E2 71      LDA $71E2,x               ;
CODE_008C74:        29 00 FF      AND #$FF00                ;
CODE_008C77:        10 03         BPL CODE_008C7C           ;
CODE_008C79:        09 FF 00      ORA #$00FF                ;
CODE_008C7C:        EB            XBA                       ;
CODE_008C7D:        69 00 00      ADC #$0000                ;
CODE_008C80:        9D 82 72      STA $7282,x               ;
CODE_008C83:        18            CLC                       ;
CODE_008C84:        7D 42 71      ADC $7142,x               ;
CODE_008C87:        9D 42 71      STA $7142,x               ;
CODE_008C8A:        60            RTS                       ;

DATA_008C8B:          dw $0007, $0008, $0009, $000A
DATA_008C93:          dw $0009, $0008, $0007, $0006
DATA_008C9B:          dw $0005, $0004, $0003, $0002
DATA_008CA3:          dw $0001, $0003, $0004, $0005
DATA_008CAB:          dw $0004, $0003, $0003, $0003
DATA_008CB3:          dw $0003, $0003, $0003, $0003
DATA_008CBB:          dw $0003, $0003

CODE_008CBF:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008CC2:        BD 82 77      LDA $7782,x               ;
CODE_008CC5:        D0 18         BNE CODE_008CDF           ;
CODE_008CC7:        BD 4C 7E      LDA $7E4C,x               ;
CODE_008CCA:        3A            DEC A                     ;
CODE_008CCB:        3A            DEC A                     ;
CODE_008CCC:        10 01         BPL CODE_008CCF           ;
CODE_008CCE:        60            RTS                       ;

CODE_008CCF:        9D 4C 7E      STA $7E4C,x               ;
CODE_008CD2:        A8            TAY                       ;
CODE_008CD3:        B9 8B 8C      LDA $8C8B,y               ;
CODE_008CD6:        9D C2 73      STA $73C2,x               ;
CODE_008CD9:        B9 A5 8C      LDA $8CA5,y               ;
CODE_008CDC:        9D 82 77      STA $7782,x               ;
CODE_008CDF:        60            RTS                       ;

DATA_008CE0:          dw $0000, $0002, $0001, $0001
DATA_008CE8:          dw $0000, $0000, $0001, $0000
DATA_008CF0:          dw $0000, $0000, $0000, $FFFF
DATA_008CF8:          dw $0000, $0000, $FFFF, $FFFF
DATA_008D00:          dw $FFFE, $0000

CODE_008D04:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008D07:        BD 82 77      LDA $7782,x               ;
CODE_008D0A:        0A            ASL A                     ;
CODE_008D0B:        A8            TAY                       ;
CODE_008D0C:        B9 DE 8C      LDA $8CDE,y               ;
CODE_008D0F:        18            CLC                       ;
CODE_008D10:        7D 42 71      ADC $7142,x               ;
CODE_008D13:        9D 42 71      STA $7142,x               ;
CODE_008D16:        60            RTS                       ;

DATA_008D17:          dw $0001, $0000, $0000, $0000
DATA_008D1F:          dw $0000, $0000, $FFFF, $0000
DATA_008D27:          dw $FFFF, $0000, $0000, $0000
DATA_008D2F:          dw $0000, $0000, $0001, $0000

CODE_008D37:        20 E5 8A      JSR CODE_008AE5           ;

CODE_008D3A:        BD 22 78      LDA $7822,x               ;
CODE_008D3D:        29 FF 00      AND #$00FF                ;
CODE_008D40:        9D 82 77      STA $7782,x               ;
CODE_008D43:        D0 03         BNE CODE_008D48           ;
CODE_008D45:        4C F8 8A      JMP CODE_008AF8           ;

CODE_008D48:        A9 FF 00      LDA #$00FF                ;
CODE_008D4B:        1D 22 78      ORA $7822,x               ;
CODE_008D4E:        9D 22 78      STA $7822,x               ;
CODE_008D51:        A9 02 00      LDA #$0002                ;
CODE_008D54:        9D 62 74      STA $7462,x               ;
CODE_008D57:        FE 4C 7E      INC $7E4C,x               ;
CODE_008D5A:        BD 4C 7E      LDA $7E4C,x               ;
CODE_008D5D:        89 18 00      BIT #$0018                ;
CODE_008D60:        F0 03         BEQ CODE_008D65           ;
CODE_008D62:        DE 42 71      DEC $7142,x               ;
CODE_008D65:        29 0F 00      AND #$000F                ;
CODE_008D68:        0A            ASL A                     ;
CODE_008D69:        A8            TAY                       ;
CODE_008D6A:        BD A2 70      LDA $70A2,x               ;
CODE_008D6D:        18            CLC                       ;
CODE_008D6E:        79 17 8D      ADC $8D17,y               ;
CODE_008D71:        9D A2 70      STA $70A2,x               ;
CODE_008D74:        60            RTS                       ;

CODE_008D75:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008D78:        BD 82 77      LDA $7782,x               ;
CODE_008D7B:        D0 0C         BNE CODE_008D89           ;
CODE_008D7D:        FE 82 77      INC $7782,x               ;
CODE_008D80:        BD 02 70      LDA $7002,x               ;
CODE_008D83:        09 80 00      ORA #$0080                ;
CODE_008D86:        9D 02 70      STA $7002,x               ;
CODE_008D89:        60            RTS                       ;

DATA_008D8A:		db $40,$40,$FF,$00,$00

CODE_008D8F:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008D92:        FE C2 73      INC $73C2,x               ;
CODE_008D95:        60            RTS                       ;

CODE_008D96:        20 EC 8A      JSR CODE_008AEC           ;
CODE_008D99:        A5 14         LDA $14                   ;
CODE_008D9B:        4A            LSR A                     ;
CODE_008D9C:        4A            LSR A                     ;
CODE_008D9D:        4A            LSR A                     ;
CODE_008D9E:        29 03 00      AND #$0003                ;
CODE_008DA1:        9D C2 73      STA $73C2,x               ;
CODE_008DA4:        60            RTS                       ;

CODE_008DA5:        20 EC 8A      JSR CODE_008AEC           ;
CODE_008DA8:        60            RTS                       ;

DATA_008DA9:          db $02, $01, $00, $FF, $00, $06, $06, $06
DATA_008DB1:          db $03

CODE_008DB2:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008DB5:        E2 20         SEP #$20                  ;
CODE_008DB7:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008DBA:        BD 82 77      LDA $7782,x               ;
CODE_008DBD:        D0 18         BNE CODE_008DD7           ;
CODE_008DBF:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008DC2:        30 20         BMI CODE_008DE4           ;
CODE_008DC4:        88            DEY                       ;
CODE_008DC5:        C0 03         CPY #$03                  ;
CODE_008DC7:        D0 08         BNE CODE_008DD1           ;
CODE_008DC9:        BD 00 70      LDA $7000,x               ;
CODE_008DCC:        29 FC         AND #$FC                  ;
CODE_008DCE:        9D 00 70      STA $7000,x               ;
CODE_008DD1:        B9 AE 8D      LDA $8DAE,y               ;
CODE_008DD4:        9D 82 77      STA $7782,x               ;
CODE_008DD7:        B9 A9 8D      LDA $8DA9,y               ;
CODE_008DDA:        9D C2 73      STA $73C2,x               ;
CODE_008DDD:        30 02         BMI CODE_008DE1           ;
CODE_008DDF:        A9 06         LDA #$06                  ;
CODE_008DE1:        9D 62 74      STA $7462,x               ;
CODE_008DE4:        C2 20         REP #$20                  ;
CODE_008DE6:        60            RTS                       ;

CODE_008DE7:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008DEA:        E2 20         SEP #$20                  ;
CODE_008DEC:        BD 82 77      LDA $7782,x               ;
CODE_008DEF:        4A            LSR A                     ;
CODE_008DF0:        4A            LSR A                     ;
CODE_008DF1:        4A            LSR A                     ;
CODE_008DF2:        9D C2 73      STA $73C2,x               ;
CODE_008DF5:        C2 20         REP #$20                  ;
CODE_008DF7:        60            RTS                       ;

CODE_008DF8:        DE 82 77      DEC $7782,x               ;
CODE_008DFB:        BD 82 77      LDA $7782,x               ;
CODE_008DFE:        D0 03         BNE CODE_008E03           ;
CODE_008E00:        4C F8 8A      JMP CODE_008AF8           ;

CODE_008E03:        C9 3F 00      CMP #$003F                ;
CODE_008E06:        B0 03         BCS CODE_008E0B           ;
CODE_008E08:        DE 82 77      DEC $7782,x               ;
CODE_008E0B:        E2 20         SEP #$20                  ;
CODE_008E0D:        4A            LSR A                     ;
CODE_008E0E:        29 07         AND #$07                  ;
CODE_008E10:        9D C2 73      STA $73C2,x               ;
CODE_008E13:        C2 20         REP #$20                  ;
CODE_008E15:        60            RTS                       ;

CODE_008E16:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008E19:        BC C2 73      LDY $73C2,x               ;
CODE_008E1C:        BD 82 77      LDA $7782,x               ;
CODE_008E1F:        D0 0E         BNE CODE_008E2F           ;
CODE_008E21:        DE C2 73      DEC $73C2,x               ;
CODE_008E24:        10 03         BPL CODE_008E29           ;
CODE_008E26:        4C F8 8A      JMP CODE_008AF8           ;

CODE_008E29:        A9 02 00      LDA #$0002                ;
CODE_008E2C:        9D 82 77      STA $7782,x               ;
CODE_008E2F:        60            RTS                       ;

DATA_008E30:          db $09, $07, $06, $03, $02, $01, $00

CODE_008E37:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008E3A:        E2 20         SEP #$20                  ;
CODE_008E3C:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008E3F:        BD 82 77      LDA $7782,x               ;
CODE_008E42:        D0 0B         BNE CODE_008E4F           ;
CODE_008E44:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008E47:        30 0C         BMI CODE_008E55           ;
CODE_008E49:        B9 2F 8E      LDA $8E2F,y               ;
CODE_008E4C:        9D 82 77      STA $7782,x               ;
CODE_008E4F:        B9 33 8E      LDA $8E33,y               ;
CODE_008E52:        9D C2 73      STA $73C2,x               ;
CODE_008E55:        C2 20         REP #$20                  ;
CODE_008E57:        60            RTS                       ;

DATA_008E58:          db $06, $06, $06, $06, $04, $03

CODE_008E5E:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008E61:        E2 20         SEP #$20                  ;
CODE_008E63:        BC C2 73      LDY $73C2,x               ;
CODE_008E66:        BD 82 77      LDA $7782,x               ;
CODE_008E69:        D0 0C         BNE CODE_008E77           ;
CODE_008E6B:        88            DEY                       ;
CODE_008E6C:        30 09         BMI CODE_008E77           ;
CODE_008E6E:        DE C2 73      DEC $73C2,x               ;
CODE_008E71:        B9 58 8E      LDA $8E58,y               ;
CODE_008E74:        9D 82 77      STA $7782,x               ;
CODE_008E77:        C2 20         REP #$20                  ;
CODE_008E79:        60            RTS                       ;

DATA_008E7A:          db $06, $06, $05, $05

CODE_008E7E:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008E81:        E2 20         SEP #$20                  ;
CODE_008E83:        BC C2 73      LDY $73C2,x               ;
CODE_008E86:        BD 82 77      LDA $7782,x               ;
CODE_008E89:        4A            LSR A                     ;
CODE_008E8A:        D0 0E         BNE CODE_008E9A           ;
CODE_008E8C:        88            DEY                       ;
CODE_008E8D:        88            DEY                       ;
CODE_008E8E:        30 0A         BMI CODE_008E9A           ;
CODE_008E90:        98            TYA                       ;
CODE_008E91:        9D C2 73      STA $73C2,x               ;
CODE_008E94:        B9 7A 8E      LDA $8E7A,y               ;
CODE_008E97:        9D 82 77      STA $7782,x               ;
CODE_008E9A:        C2 10         REP #$10                  ;
CODE_008E9C:        BD C2 73      LDA $73C2,x               ;
CODE_008E9F:        4A            LSR A                     ;
CODE_008EA0:        9B            TXY                       ;
CODE_008EA1:        BE 4C 7E      LDX $7E4C,y               ;
CODE_008EA4:        BF 54 E9 00   LDA $00E954,x             ;
CODE_008EA8:        8D 1B 21      STA $211B                 ;
CODE_008EAB:        BF 55 E9 00   LDA $00E955,x             ;
CODE_008EAF:        8D 1B 21      STA $211B                 ;
CODE_008EB2:        A9 FC         LDA #$FC                  ;
CODE_008EB4:        90 02         BCC CODE_008EB8           ;
CODE_008EB6:        A9 FE         LDA #$FE                  ;
CODE_008EB8:        18            CLC                       ;
CODE_008EB9:        79 4E 7E      ADC $7E4E,y               ;
CODE_008EBC:        99 4E 7E      STA $7E4E,y               ;
CODE_008EBF:        8D 1C 21      STA $211C                 ;
CODE_008EC2:        C2 20         REP #$20                  ;
CODE_008EC4:        AD 35 21      LDA $2135                 ;
CODE_008EC7:        0A            ASL A                     ;
CODE_008EC8:        0A            ASL A                     ;
CODE_008EC9:        0A            ASL A                     ;
CODE_008ECA:        99 E0 71      STA $71E0,y               ;
CODE_008ECD:        BF D4 E9 00   LDA $00E9D4,x             ;
CODE_008ED1:        E2 20         SEP #$20                  ;
CODE_008ED3:        8D 1B 21      STA $211B                 ;
CODE_008ED6:        EB            XBA                       ;
CODE_008ED7:        8D 1B 21      STA $211B                 ;
CODE_008EDA:        B9 4E 7E      LDA $7E4E,y               ;
CODE_008EDD:        8D 1C 21      STA $211C                 ;
CODE_008EE0:        C2 20         REP #$20                  ;
CODE_008EE2:        AD 35 21      LDA $2135                 ;
CODE_008EE5:        0A            ASL A                     ;
CODE_008EE6:        0A            ASL A                     ;
CODE_008EE7:        0A            ASL A                     ;
CODE_008EE8:        99 E2 71      STA $71E2,y               ;
CODE_008EEB:        E2 10         SEP #$10                  ;
CODE_008EED:        BB            TYX                       ;
CODE_008EEE:        60            RTS                       ;

CODE_008EEF:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008EF2:        BD E2 71      LDA $71E2,x               ;
CODE_008EF5:        30 06         BMI CODE_008EFD           ;
CODE_008EF7:        A9 01 00      LDA #$0001                ;
CODE_008EFA:        9D C2 73      STA $73C2,x               ;
CODE_008EFD:        60            RTS                       ;

CODE_008EFE:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008F01:        BD 82 77      LDA $7782,x               ;
CODE_008F04:        4A            LSR A                     ;
CODE_008F05:        4A            LSR A                     ;
CODE_008F06:        4A            LSR A                     ;
CODE_008F07:        9D C2 73      STA $73C2,x               ;
CODE_008F0A:        60            RTS                       ;

CODE_008F0B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008F0E:        BD 82 77      LDA $7782,x               ;
CODE_008F11:        C9 08 00      CMP #$0008                ;
CODE_008F14:        D0 03         BNE CODE_008F19           ;
CODE_008F16:        FE C2 73      INC $73C2,x               ;
CODE_008F19:        29 07 00      AND #$0007                ;
CODE_008F1C:        D0 10         BNE CODE_008F2E           ;
CODE_008F1E:        AD 70 79      LDA $7970                 ;
CODE_008F21:        29 01 00      AND #$0001                ;
CODE_008F24:        D0 01         BNE CODE_008F27           ;
CODE_008F26:        3A            DEC A                     ;
CODE_008F27:        18            CLC                       ;
CODE_008F28:        7D A2 70      ADC $70A2,x               ;
CODE_008F2B:        9D A2 70      STA $70A2,x               ;
CODE_008F2E:        60            RTS                       ;

CODE_008F2F:          db $02, $02, $02, $01, $01, $01, $03, $03
CODE_008F37:          db $03, $02, $02, $02

CODE_008F3B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008F3E:        BD 82 77      LDA $7782,x               ;
CODE_008F41:        D0 18         BNE CODE_008F5B           ;
CODE_008F43:        E2 20         SEP #$20                  ;
CODE_008F45:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008F48:        F0 0F         BEQ CODE_008F59           ;
CODE_008F4A:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008F4D:        B9 34 8F      LDA $8F34,y               ;
CODE_008F50:        9D 82 77      STA $7782,x               ;
CODE_008F53:        B9 2E 8F      LDA $8F2E,y               ;
CODE_008F56:        9D C2 73      STA $73C2,x               ;
CODE_008F59:        C2 20         REP #$20                  ;
CODE_008F5B:        60            RTS                       ;

CODE_008F5C:          db $05, $04, $03, $01, $01, $02, $01, $03
CODE_008F64:          db $03, $03, $03, $03, $04, $04

CODE_008F6A:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008F6D:        BD 82 77      LDA $7782,x               ;
CODE_008F70:        D0 18         BNE CODE_008F8A           ;
CODE_008F72:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008F75:        30 13         BMI CODE_008F8A           ;
CODE_008F77:        E2 20         SEP #$20                  ;
CODE_008F79:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008F7C:        B9 5C 8F      LDA $8F5C,y               ;
CODE_008F7F:        9D C2 73      STA $73C2,x               ;
CODE_008F82:        B9 63 8F      LDA $8F63,y               ;
CODE_008F85:        9D 82 77      STA $7782,x               ;
CODE_008F88:        C2 20         REP #$20                  ;
CODE_008F8A:        60            RTS                       ;

CODE_008F8B:          db $08, $07, $06, $05, $04, $03, $02, $01
CODE_008F93:          db $40, $02, $02, $02, $02, $02, $02, $02

CODE_008F9B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008F9E:        BD 82 77      LDA $7782,x               ;
CODE_008FA1:        D0 18         BNE CODE_008FBB           ;
CODE_008FA3:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008FA6:        30 13         BMI CODE_008FBB           ;
CODE_008FA8:        E2 20         SEP #$20                  ;
CODE_008FAA:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008FAD:        B9 8B 8F      LDA $8F8B,y               ;
CODE_008FB0:        9D C2 73      STA $73C2,x               ;
CODE_008FB3:        B9 93 8F      LDA $8F93,y               ;
CODE_008FB6:        9D 82 77      STA $7782,x               ;
CODE_008FB9:        C2 20         REP #$20                  ;
CODE_008FBB:        60            RTS                       ;

DATA_008FBC:          db $0B, $0A, $09, $08, $07, $06, $05, $04
DATA_008FC4:          db $03, $02, $01, $04, $04, $04, $04, $04
DATA_008FCC:          db $04, $03, $03, $02, $02, $01

CODE_008FD2:        BC 4E 7E      LDY $7E4E,x               ;
CODE_008FD5:        F0 0D         BEQ CODE_008FE4           ;
CODE_008FD7:        AD 8F 0B      LDA $0B8F                 ;
CODE_008FDA:        F0 08         BEQ CODE_008FE4           ;
CODE_008FDC:        DE 82 77      DEC $7782,x               ;
CODE_008FDF:        10 06         BPL CODE_008FE7           ;
CODE_008FE1:        4C F8 8A      JMP CODE_008AF8           ;

CODE_008FE4:        20 E5 8A      JSR CODE_008AE5           ;
CODE_008FE7:        BD 82 77      LDA $7782,x               ;
CODE_008FEA:        D0 18         BNE CODE_009004           ;
CODE_008FEC:        DE 4C 7E      DEC $7E4C,x               ;
CODE_008FEF:        30 13         BMI CODE_009004           ;
CODE_008FF1:        E2 20         SEP #$20                  ;
CODE_008FF3:        BC 4C 7E      LDY $7E4C,x               ;
CODE_008FF6:        B9 BC 8F      LDA $8FBC,y               ;
CODE_008FF9:        9D C2 73      STA $73C2,x               ;
CODE_008FFC:        B9 C7 8F      LDA $8FC7,y               ;
CODE_008FFF:        9D 82 77      STA $7782,x               ;
CODE_009002:        C2 20         REP #$20                  ;
CODE_009004:        60            RTS                       ;

DATA_009005:          db $01, $11

CODE_009007:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00900A:        BD 82 77      LDA $7782,x               ;
CODE_00900D:        D0 18         BNE CODE_009027           ;
CODE_00900F:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009012:        30 13         BMI CODE_009027           ;
CODE_009014:        E2 20         SEP #$20                  ;
CODE_009016:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009019:        B9 05 90      LDA $9005,y               ;
CODE_00901C:        9D C2 73      STA $73C2,x               ;
CODE_00901F:        B9 06 90      LDA $9006,y               ;
CODE_009022:        9D 82 77      STA $7782,x               ;
CODE_009025:        C2 20         REP #$20                  ;
CODE_009027:        60            RTS                       ;

CODE_009028:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00902B:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00902E:        B9 E2 70      LDA $70E2,y               ;
CODE_009031:        85 00         STA $00                   ;
CODE_009033:        B9 82 71      LDA $7182,y               ;
CODE_009036:        18            CLC                       ;
CODE_009037:        69 08 00      ADC #$0008                ;
CODE_00903A:        85 02         STA $02                   ;
CODE_00903C:        BD 4E 7E      LDA $7E4E,x               ;
CODE_00903F:        85 06         STA $06                   ;
CODE_009041:        BD 8C 7E      LDA $7E8C,x               ;
CODE_009044:        85 04         STA $04                   ;
CODE_009046:        BD A2 70      LDA $70A2,x               ;
CODE_009049:        85 08         STA $08                   ;
CODE_00904B:        BD 42 71      LDA $7142,x               ;
CODE_00904E:        85 0A         STA $0A                   ;
CODE_009050:        22 42 9B 04   JSL CODE_049B42           ;
CODE_009054:        A5 04         LDA $04                   ;
CODE_009056:        9D 8C 7E      STA $7E8C,x               ;
CODE_009059:        10 06         BPL CODE_009061           ;
CODE_00905B:        49 FF FF      EOR #$FFFF                ;
CODE_00905E:        1A            INC A                     ;
CODE_00905F:        85 04         STA $04                   ;
CODE_009061:        A5 06         LDA $06                   ;
CODE_009063:        9D 4E 7E      STA $7E4E,x               ;
CODE_009066:        10 04         BPL CODE_00906C           ;
CODE_009068:        49 FF FF      EOR #$FFFF                ;
CODE_00906B:        1A            INC A                     ;
CODE_00906C:        18            CLC                       ;
CODE_00906D:        65 04         ADC $04                   ;
CODE_00906F:        C9 30 00      CMP #$0030                ;
CODE_009072:        B0 06         BCS CODE_00907A           ;
CODE_009074:        A9 01 00      LDA #$0001                ;
CODE_009077:        9D C2 73      STA $73C2,x               ;
CODE_00907A:        A5 08         LDA $08                   ;
CODE_00907C:        9D A2 70      STA $70A2,x               ;
CODE_00907F:        A5 0A         LDA $0A                   ;
CODE_009081:        9D 42 71      STA $7142,x               ;
CODE_009084:        60            RTS                       ;

DATA_009085:          db $0A, $09, $08, $07, $06, $05, $04, $03
DATA_00908D:          db $02, $01, $05, $05, $05, $04, $04, $04
DATA_009095:          db $03, $03, $02, $02

CODE_009099:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00909C:        BD 82 77      LDA $7782,x               ;
CODE_00909F:        D0 18         BNE CODE_0090B9           ;
CODE_0090A1:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0090A4:        30 13         BMI CODE_0090B9           ;
CODE_0090A6:        E2 20         SEP #$20                  ;
CODE_0090A8:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0090AB:        B9 85 90      LDA $9085,y               ;
CODE_0090AE:        9D C2 73      STA $73C2,x               ;
CODE_0090B1:        B9 8F 90      LDA $908F,y               ;
CODE_0090B4:        9D 82 77      STA $7782,x               ;
CODE_0090B7:        C2 20         REP #$20                  ;
CODE_0090B9:        60            RTS                       ;

CODE_0090BA:        20 EC 8A      JSR CODE_008AEC           ;
CODE_0090BD:        60            RTS                       ;

DATA_0090BE:          db $06, $04, $04, $03, $03

CODE_0090C3:        20 E5 8A      JSR CODE_008AE5           ;
CODE_0090C6:        BD 82 77      LDA $7782,x               ;
CODE_0090C9:        D0 14         BNE CODE_0090DF           ;
CODE_0090CB:        DE C2 73      DEC $73C2,x               ;
CODE_0090CE:        10 03         BPL CODE_0090D3           ;
CODE_0090D0:        4C F8 8A      JMP CODE_008AF8           ;

CODE_0090D3:        BC C2 73      LDY $73C2,x               ;
CODE_0090D6:        B9 BE 90      LDA $90BE,y               ;
CODE_0090D9:        29 FF 00      AND #$00FF                ;
CODE_0090DC:        9D 82 77      STA $7782,x               ;
CODE_0090DF:        60            RTS                       ;

DATA_0090E0:          db $0B, $0A, $09, $08, $07, $06, $05, $04
DATA_0090E8:          db $03, $02, $01, $06, $06, $06, $06, $06
DATA_0090F0:          db $06, $06, $03, $03, $03, $03

CODE_0090F6:        BC 4E 7E      LDY $7E4E,x               ;
CODE_0090F9:        F0 05         BEQ CODE_009100           ;
CODE_0090FB:        20 F2 8A      JSR CODE_008AF2           ;
CODE_0090FE:        80 03         BRA CODE_009103           ;

CODE_009100:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009103:        BD 82 77      LDA $7782,x               ;
CODE_009106:        D0 18         BNE CODE_009120           ;
CODE_009108:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00910B:        30 13         BMI CODE_009120           ;
CODE_00910D:        E2 20         SEP #$20                  ;
CODE_00910F:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009112:        B9 E0 90      LDA $90E0,y               ;
CODE_009115:        9D C2 73      STA $73C2,x               ;
CODE_009118:        B9 EB 90      LDA $90EB,y               ;
CODE_00911B:        9D 82 77      STA $7782,x               ;
CODE_00911E:        C2 20         REP #$20                  ;
CODE_009120:        60            RTS                       ;

DATA_009121:          db $06, $05, $04, $03, $02, $01, $04, $08
DATA_009129:          db $08, $08, $04, $02

CODE_00912D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009130:        BD 82 77      LDA $7782,x               ;
CODE_009133:        D0 18         BNE CODE_00914D           ;
CODE_009135:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009138:        30 13         BMI CODE_00914D           ;
CODE_00913A:        E2 20         SEP #$20                  ;
CODE_00913C:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00913F:        B9 21 91      LDA $9121,y               ;
CODE_009142:        9D C2 73      STA $73C2,x               ;
CODE_009145:        B9 27 91      LDA $9127,y               ;
CODE_009148:        9D 82 77      STA $7782,x               ;
CODE_00914B:        C2 20         REP #$20                  ;
CODE_00914D:        60            RTS                       ;

DATA_00914E:          db $03, $02, $01, $06, $04, $02

CODE_009154:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009157:        BD 82 77      LDA $7782,x               ;
CODE_00915A:        D0 18         BNE CODE_009174           ;
CODE_00915C:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00915F:        30 13         BMI CODE_009174           ;
CODE_009161:        E2 20         SEP #$20                  ;
CODE_009163:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009166:        B9 4E 91      LDA $914E,y               ;
CODE_009169:        9D C2 73      STA $73C2,x               ;
CODE_00916C:        B9 51 91      LDA $9151,y               ;
CODE_00916F:        9D 82 77      STA $7782,x               ;
CODE_009172:        C2 20         REP #$20                  ;
CODE_009174:        60            RTS                       ;

DATA_009175:          db $03, $02, $01, $06, $04, $02

CODE_00917B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00917E:        BD 82 77      LDA $7782,x               ;
CODE_009181:        D0 18         BNE CODE_00919B           ;
CODE_009183:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009186:        30 13         BMI CODE_00919B           ;
CODE_009188:        E2 20         SEP #$20                  ;
CODE_00918A:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00918D:        B9 75 91      LDA $9175,y               ;
CODE_009190:        9D C2 73      STA $73C2,x               ;
CODE_009193:        B9 78 91      LDA $9178,y               ;
CODE_009196:        9D 82 77      STA $7782,x               ;
CODE_009199:        C2 20         REP #$20                  ;
CODE_00919B:        60            RTS                       ;

DATA_00919C:          db $02, $01, $0C, $08

CODE_0091A0:        20 E5 8A      JSR CODE_008AE5           ;
CODE_0091A3:        BD 82 77      LDA $7782,x               ;
CODE_0091A6:        D0 18         BNE CODE_0091C0           ;
CODE_0091A8:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0091AB:        30 13         BMI CODE_0091C0           ;
CODE_0091AD:        E2 20         SEP #$20                  ;
CODE_0091AF:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0091B2:        B9 9C 91      LDA $919C,y               ;
CODE_0091B5:        9D C2 73      STA $73C2,x               ;
CODE_0091B8:        B9 9E 91      LDA $919E,y               ;
CODE_0091BB:        9D 82 77      STA $7782,x               ;
CODE_0091BE:        C2 20         REP #$20                  ;
CODE_0091C0:        60            RTS                       ;

DATA_0091C1:          db $03, $02, $01, $08, $08, $04

CODE_0091C7:        20 12 8C      JSR CODE_008C12           ;
CODE_0091CA:        BD A0 75      LDA $75A0,x               ;
CODE_0091CD:        DD E0 71      CMP $71E0,x               ;
CODE_0091D0:        D0 07         BNE CODE_0091D9           ;
CODE_0091D2:        49 FF FF      EOR #$FFFF                ;
CODE_0091D5:        1A            INC A                     ;
CODE_0091D6:        9D A0 75      STA $75A0,x               ;
CODE_0091D9:        BD A2 75      LDA $75A2,x               ;
CODE_0091DC:        DD E2 71      CMP $71E2,x               ;
CODE_0091DF:        D0 07         BNE CODE_0091E8           ;
CODE_0091E1:        49 FF FF      EOR #$FFFF                ;
CODE_0091E4:        1A            INC A                     ;
CODE_0091E5:        9D A2 75      STA $75A2,x               ;
CODE_0091E8:        DE 82 77      DEC $7782,x               ;
CODE_0091EB:        D0 26         BNE CODE_009213           ;
CODE_0091ED:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0091F0:        10 04         BPL CODE_0091F6           ;
CODE_0091F2:        20 F8 8A      JSR CODE_008AF8           ;
CODE_0091F5:        60            RTS                       ;

CODE_0091F6:        E2 20         SEP #$20                  ;
CODE_0091F8:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0091FB:        B9 C1 91      LDA $91C1,y               ;
CODE_0091FE:        9D C2 73      STA $73C2,x               ;
CODE_009201:        B9 C4 91      LDA $91C4,y               ;
CODE_009204:        9D 82 77      STA $7782,x               ;
CODE_009207:        C2 20         REP #$20                  ;
CODE_009209:        C0 02         CPY #$02                  ;
CODE_00920B:        30 06         BMI CODE_009213           ;
CODE_00920D:        A9 80 00      LDA #$0080                ;
CODE_009210:        9D E2 71      STA $71E2,x               ;
CODE_009213:        60            RTS                       ;

DATA_009214:          db $03, $02, $01, $08, $08, $08

CODE_00921A:        20 12 8C      JSR CODE_008C12           ;
CODE_00921D:        20 F2 8A      JSR CODE_008AF2           ;
CODE_009220:        BD 82 77      LDA $7782,x               ;
CODE_009223:        D0 18         BNE CODE_00923D           ;
CODE_009225:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009228:        30 13         BMI CODE_00923D           ;
CODE_00922A:        E2 20         SEP #$20                  ;
CODE_00922C:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00922F:        B9 14 92      LDA $9214,y               ;
CODE_009232:        9D C2 73      STA $73C2,x               ;
CODE_009235:        B9 17 92      LDA $9217,y               ;
CODE_009238:        9D 82 77      STA $7782,x               ;
CODE_00923B:        C2 20         REP #$20                  ;
CODE_00923D:        60            RTS                       ;

DATA_00923E:          db $0B, $0A, $09, $08, $07, $06, $05, $04
DATA_009246:          db $03, $02, $01, $01, $01, $01, $01, $01
DATA_00924E:          db $01, $01, $01, $01, $01, $02, $20

CODE_009254:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009257:        BD 82 77      LDA $7782,x               ;
CODE_00925A:        D0 18         BNE CODE_009274           ;
CODE_00925C:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00925F:        30 13         BMI CODE_009274           ;
CODE_009261:        E2 20         SEP #$20                  ;
CODE_009263:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009266:        B9 3E 92      LDA $923E,y               ;
CODE_009269:        9D C2 73      STA $73C2,x               ;
CODE_00926C:        B9 49 92      LDA $9249,y               ;
CODE_00926F:        9D 82 77      STA $7782,x               ;
CODE_009272:        C2 20         REP #$20                  ;
CODE_009274:        60            RTS                       ;

DATA_009275:          db $04, $03, $02, $01, $06, $06, $06, $06

CODE_00927D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009280:        BD 82 77      LDA $7782,x               ;
CODE_009283:        D0 18         BNE CODE_00929D           ;
CODE_009285:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009288:        30 13         BMI CODE_00929D           ;
CODE_00928A:        E2 20         SEP #$20                  ;
CODE_00928C:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00928F:        B9 75 92      LDA $9275,y               ;
CODE_009292:        9D C2 73      STA $73C2,x               ;
CODE_009295:        B9 79 92      LDA $9279,y               ;
CODE_009298:        9D 82 77      STA $7782,x               ;
CODE_00929B:        C2 20         REP #$20                  ;
CODE_00929D:        60            RTS                       ;

DATA_00929E:          db $03, $03, $03, $03, $03, $03, $03, $AD
DATA_0092A6:          db $8F, $0B, $F0, $03

CODE_0092AA:        20 12 8C      JSR CODE_008C12           ;
CODE_0092AD:        20 F2 8A      JSR CODE_008AF2           ;
CODE_0092B0:        BD 82 77      LDA $7782,x               ;
CODE_0092B3:        D0 16         BNE CODE_0092CB           ;
CODE_0092B5:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0092B8:        30 11         BMI CODE_0092CB           ;
CODE_0092BA:        E2 20         SEP #$20                  ;
CODE_0092BC:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0092BF:        98            TYA                       ;
CODE_0092C0:        9D C2 73      STA $73C2,x               ;
CODE_0092C3:        B9 9E 92      LDA $929E,y               ;
CODE_0092C6:        9D 82 77      STA $7782,x               ;
CODE_0092C9:        C2 20         REP #$20                  ;
CODE_0092CB:        60            RTS                       ;

DATA_0092CC:          db $03, $02, $00, $01, $08, $00, $FA, $FF
DATA_0092D4:          db $FD, $FF, $01, $00, $09, $00, $F8, $FF
DATA_0092DC:          db $06, $00, $03, $00, $FF, $FF, $F7, $FF
DATA_0092E4:          db $FE, $FF, $04, $00, $FE, $FF, $FC, $FF
DATA_0092EC:          db $FB, $FF

CODE_0092EE:        BC 4E 7E      LDY $7E4E,x               ;
CODE_0092F1:        B9 00 74      LDA $7400,y               ;
CODE_0092F4:        85 00         STA $00                   ;
CODE_0092F6:        B9 02 74      LDA $7402,y               ;
CODE_0092F9:        38            SEC                       ;
CODE_0092FA:        E9 1B 00      SBC #$001B                ;
CODE_0092FD:        0A            ASL A                     ;
CODE_0092FE:        5A            PHY                       ;
CODE_0092FF:        A8            TAY                       ;
CODE_009300:        A5 00         LDA $00                   ;
CODE_009302:        F0 05         BEQ CODE_009309           ;
CODE_009304:        B9 DA 92      LDA $92DA,y               ;
CODE_009307:        80 03         BRA CODE_00930C           ;

CODE_009309:        B9 D0 92      LDA $92D0,y               ;
CODE_00930C:        85 00         STA $00                   ;
CODE_00930E:        B9 E4 92      LDA $92E4,y               ;
CODE_009311:        85 02         STA $02                   ;
CODE_009313:        7A            PLY                       ;
CODE_009314:        B9 E2 70      LDA $70E2,y               ;
CODE_009317:        18            CLC                       ;
CODE_009318:        65 00         ADC $00                   ;
CODE_00931A:        18            CLC                       ;
CODE_00931B:        7D C0 78      ADC $78C0,x               ;
CODE_00931E:        DD A2 70      CMP $70A2,x               ;
CODE_009321:        F0 0A         BEQ CODE_00932D           ;
CODE_009323:        30 05         BMI CODE_00932A           ;
CODE_009325:        FE A2 70      INC $70A2,x               ;
CODE_009328:        80 03         BRA CODE_00932D           ;

CODE_00932A:        DE A2 70      DEC $70A2,x               ;
CODE_00932D:        B9 82 71      LDA $7182,y               ;
CODE_009330:        18            CLC                       ;
CODE_009331:        65 02         ADC $02                   ;
CODE_009333:        18            CLC                       ;
CODE_009334:        7D C2 78      ADC $78C2,x               ;
CODE_009337:        DD 42 71      CMP $7142,x               ;
CODE_00933A:        F0 0A         BEQ CODE_009346           ;
CODE_00933C:        30 05         BMI CODE_009343           ;
CODE_00933E:        FE 42 71      INC $7142,x               ;
CODE_009341:        80 03         BRA CODE_009346           ;

CODE_009343:        DE 42 71      DEC $7142,x               ;
CODE_009346:        DE 82 77      DEC $7782,x               ;
CODE_009349:        D0 25         BNE CODE_009370           ;
CODE_00934B:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00934E:        10 04         BPL CODE_009354           ;
CODE_009350:        20 F8 8A      JSR CODE_008AF8           ;
CODE_009353:        60            RTS                       ;

CODE_009354:        E2 20         SEP #$20                  ;
CODE_009356:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009359:        B9 CC 92      LDA $92CC,y               ;
CODE_00935C:        9D C2 73      STA $73C2,x               ;
CODE_00935F:        A9 04         LDA #$04                  ;
CODE_009361:        9D 82 77      STA $7782,x               ;
CODE_009364:        C2 20         REP #$20                  ;
CODE_009366:        C0 02         CPY #$02                  ;
CODE_009368:        30 06         BMI CODE_009370           ;
CODE_00936A:        A9 80 00      LDA #$0080                ;
CODE_00936D:        9D E2 71      STA $71E2,x               ;
CODE_009370:        60            RTS                       ;

DATA_009371:          db $03, $02, $01, $00, $04

CODE_009376:        BC 4E 7E      LDY $7E4E,x               ;
CODE_009379:        F0 05         BEQ CODE_009380           ;
CODE_00937B:        20 F2 8A      JSR CODE_008AF2           ;
CODE_00937E:        80 03         BRA CODE_009383           ;

CODE_009380:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009383:        BD 82 77      LDA $7782,x               ;
CODE_009386:        D0 17         BNE CODE_00939F           ;
CODE_009388:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00938B:        30 12         BMI CODE_00939F           ;
CODE_00938D:        E2 20         SEP #$20                  ;
CODE_00938F:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009392:        B9 71 93      LDA $9371,y               ;
CODE_009395:        9D C2 73      STA $73C2,x               ;
CODE_009398:        A9 04         LDA #$04                  ;
CODE_00939A:        9D 82 77      STA $7782,x               ;
CODE_00939D:        C2 20         REP #$20                  ;
CODE_00939F:        60            RTS                       ;

DATA_0093A0:          db $04, $03, $02, $01

CODE_0093A4:        20 E5 8A      JSR CODE_008AE5           ;
CODE_0093A7:        BD 82 77      LDA $7782,x               ;
CODE_0093AA:        D0 17         BNE CODE_0093C3           ;
CODE_0093AC:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0093AF:        30 12         BMI CODE_0093C3           ;
CODE_0093B1:        E2 20         SEP #$20                  ;
CODE_0093B3:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0093B6:        B9 A0 93      LDA $93A0,y               ;
CODE_0093B9:        9D C2 73      STA $73C2,x               ;
CODE_0093BC:        A9 04         LDA #$04                  ;
CODE_0093BE:        9D 82 77      STA $7782,x               ;
CODE_0093C1:        C2 20         REP #$20                  ;
CODE_0093C3:        60            RTS                       ;

DATA_0093C4:	     db $09, $08, $07, $06, $05, $04, $03, $02
DATA_0093CC:	     db $01, $00, $FF, $00, $FF, $03, $03, $03
DATA_0093D4:	     db $03, $03, $02, $02, $02, $01, $03, $01
DATA_0093DC:	     db $01, $01

CODE_0093DE:        20 F2 8A      JSR CODE_008AF2           ;
CODE_0093E1:        BD 82 77      LDA $7782,x               ;
CODE_0093E4:        D0 29         BNE CODE_00940F           ;
CODE_0093E6:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0093E9:        30 24         BMI CODE_00940F           ;
CODE_0093EB:        E2 20         SEP #$20                  ;
CODE_0093ED:        BC 4C 7E      LDY $7E4C,x               ;
CODE_0093F0:        B9 C4 93      LDA $93C4,y               ;
CODE_0093F3:        10 0A         BPL CODE_0093FF           ;
CODE_0093F5:        BD 4E 7E      LDA $7E4E,x               ;
CODE_0093F8:        10 05         BPL CODE_0093FF           ;
CODE_0093FA:        9D 62 74      STA $7462,x               ;
CODE_0093FD:        80 08         BRA CODE_009407           ;

CODE_0093FF:        9D C2 73      STA $73C2,x               ;
CODE_009402:        A9 02         LDA #$02                  ;
CODE_009404:        9D 62 74      STA $7462,x               ;
CODE_009407:        B9 D1 93      LDA $93D1,y               ;
CODE_00940A:        9D 82 77      STA $7782,x               ;
CODE_00940D:        C2 20         REP #$20                  ;
CODE_00940F:        60            RTS                       ;

DATA_009410:	     db $02, $04, $06, $0A, $06, $04

CODE_009416:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009419:        BD 82 77      LDA $7782,x               ;
CODE_00941C:        D0 14         BNE CODE_009432           ;
CODE_00941E:        DE C2 73      DEC $73C2,x               ;
CODE_009421:        10 03         BPL CODE_009426           ;
CODE_009423:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009426:        BC C2 73      LDY $73C2,x               ;
CODE_009429:        B9 10 94      LDA $9410,y               ;
CODE_00942C:        29 FF 00      AND #$00FF                ;
CODE_00942F:        9D 82 77      STA $7782,x               ;
CODE_009432:        60            RTS                       ;

CODE_009433:        BD 22 73      LDA $7322,x               ;
CODE_009436:        10 0E         BPL CODE_009446           ;
CODE_009438:        AD CE 61      LDA $61CE                 ;
CODE_00943B:        F0 06         BEQ CODE_009443           ;
CODE_00943D:        A9 06 00      LDA #$0006                ;
CODE_009440:        9D 62 74      STA $7462,x               ;
CODE_009443:        4C 03 95      JMP CODE_009503           ;

CODE_009446:        AD CE 61      LDA $61CE                 ;
CODE_009449:        F0 29         BEQ CODE_009474           ;
CODE_00944B:        BD A2 70      LDA $70A2,x               ;
CODE_00944E:        8D 02 30      STA $3002                 ;
CODE_009451:        BD 42 71      LDA $7142,x               ;
CODE_009454:        8D 04 30      STA $3004                 ;
CODE_009457:        BD 8C 7E      LDA $7E8C,x               ;
CODE_00945A:        8D 06 30      STA $3006                 ;
CODE_00945D:        BD 22 73      LDA $7322,x               ;
CODE_009460:        8D 0A 30      STA $300A                 ;
CODE_009463:        A9 04 00      LDA #$0004                ;
CODE_009466:        8D 0E 30      STA $300E                 ;
CODE_009469:        DA            PHX                       ;
CODE_00946A:        A2 09         LDX #$09                  ;
CODE_00946C:        A9 F4 F5      LDA #$F5F4                ;
CODE_00946F:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_009473:        FA            PLX                       ;
CODE_009474:        C2 10         REP #$10                  ;
CODE_009476:        A8            TAY                       ;
CODE_009477:        BD 4E 7E      LDA $7E4E,x               ;
CODE_00947A:        D0 09         BNE CODE_009485           ;
CODE_00947C:        A9 10 00      LDA #$0010                ;
CODE_00947F:        38            SEC                       ;
CODE_009480:        FD 4C 7E      SBC $7E4C,x               ;
CODE_009483:        10 03         BPL CODE_009488           ;
CODE_009485:        A9 00 00      LDA #$0000                ;
CODE_009488:        85 00         STA $00                   ;
CODE_00948A:        B9 00 60      LDA $6000,y               ;
CODE_00948D:        38            SEC                       ;
CODE_00948E:        E5 00         SBC $00                   ;
CODE_009490:        99 00 60      STA $6000,y               ;
CODE_009493:        B9 02 60      LDA $6002,y               ;
CODE_009496:        38            SEC                       ;
CODE_009497:        E5 00         SBC $00                   ;
CODE_009499:        99 02 60      STA $6002,y               ;
CODE_00949C:        B9 08 60      LDA $6008,y               ;
CODE_00949F:        18            CLC                       ;
CODE_0094A0:        65 00         ADC $00                   ;
CODE_0094A2:        99 08 60      STA $6008,y               ;
CODE_0094A5:        B9 0A 60      LDA $600A,y               ;
CODE_0094A8:        38            SEC                       ;
CODE_0094A9:        E5 00         SBC $00                   ;
CODE_0094AB:        99 0A 60      STA $600A,y               ;
CODE_0094AE:        B9 10 60      LDA $6010,y               ;
CODE_0094B1:        38            SEC                       ;
CODE_0094B2:        E5 00         SBC $00                   ;
CODE_0094B4:        99 10 60      STA $6010,y               ;
CODE_0094B7:        B9 12 60      LDA $6012,y               ;
CODE_0094BA:        18            CLC                       ;
CODE_0094BB:        65 00         ADC $00                   ;
CODE_0094BD:        99 12 60      STA $6012,y               ;
CODE_0094C0:        B9 18 60      LDA $6018,y               ;
CODE_0094C3:        18            CLC                       ;
CODE_0094C4:        65 00         ADC $00                   ;
CODE_0094C6:        99 18 60      STA $6018,y               ;
CODE_0094C9:        B9 1A 60      LDA $601A,y               ;
CODE_0094CC:        18            CLC                       ;
CODE_0094CD:        65 00         ADC $00                   ;
CODE_0094CF:        99 1A 60      STA $601A,y               ;
CODE_0094D2:        80 2D         BRA CODE_009501           ;

CODE_0094D4:        A9 20 00      LDA #$0020                ;
CODE_0094D7:        38            SEC                       ;
CODE_0094D8:        FD 4C 7E      SBC $7E4C,x               ;
CODE_0094DB:        85 00         STA $00                   ;
CODE_0094DD:        B9 02 60      LDA $6002,y               ;
CODE_0094E0:        18            CLC                       ;
CODE_0094E1:        65 00         ADC $00                   ;
CODE_0094E3:        99 02 60      STA $6002,y               ;
CODE_0094E6:        B9 08 60      LDA $6008,y               ;
CODE_0094E9:        38            SEC                       ;
CODE_0094EA:        E5 00         SBC $00                   ;
CODE_0094EC:        99 08 60      STA $6008,y               ;
CODE_0094EF:        B9 10 60      LDA $6010,y               ;
CODE_0094F2:        18            CLC                       ;
CODE_0094F3:        65 00         ADC $00                   ;
CODE_0094F5:        99 10 60      STA $6010,y               ;
CODE_0094F8:        B9 1A 60      LDA $601A,y               ;
CODE_0094FB:        38            SEC                       ;
CODE_0094FC:        E5 00         SBC $00                   ;
CODE_0094FE:        99 1A 60      STA $601A,y               ;
CODE_009501:        E2 10         SEP #$10                  ;
CODE_009503:        20 F2 8A      JSR CODE_008AF2           ;
CODE_009506:        BD 4C 7E      LDA $7E4C,x               ;
CODE_009509:        18            CLC                       ;
CODE_00950A:        69 04 00      ADC #$0004                ;
CODE_00950D:        C9 20 00      CMP #$0020                ;
CODE_009510:        90 03         BCC CODE_009515           ;
CODE_009512:        A9 20 00      LDA #$0020                ;
CODE_009515:        9D 4C 7E      STA $7E4C,x               ;
CODE_009518:        60            RTS                       ;

CODE_009519:        20 EC 8A      JSR CODE_008AEC           ;
CODE_00951C:        60            RTS                       ;

CODE_00951D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009520:        BD 82 77      LDA $7782,x               ;
CODE_009523:        D0 08         BNE CODE_00952D           ;
CODE_009525:        FE 82 77      INC $7782,x               ;
CODE_009528:        DE C2 73      DEC $73C2,x               ;
CODE_00952B:        30 01         BMI CODE_00952E           ;
CODE_00952D:        60            RTS                       ;

CODE_00952E:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009531:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009534:        BD 82 77      LDA $7782,x               ;
CODE_009537:        D0 0B         BNE CODE_009544           ;
CODE_009539:        A9 02 00      LDA #$0002                ;
CODE_00953C:        9D 82 77      STA $7782,x               ;
CODE_00953F:        DE C2 73      DEC $73C2,x               ;
CODE_009542:        30 01         BMI CODE_009545           ;
CODE_009544:        60            RTS                       ;

CODE_009545:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009548:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00954B:        BD 82 77      LDA $7782,x               ;
CODE_00954E:        D0 0B         BNE CODE_00955B           ;
CODE_009550:        A9 03 00      LDA #$0003                ;
CODE_009553:        9D 82 77      STA $7782,x               ;
CODE_009556:        DE C2 73      DEC $73C2,x               ;
CODE_009559:        30 01         BMI CODE_00955C           ;
CODE_00955B:        60            RTS                       ;

CODE_00955C:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00955F:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009562:        BD 82 77      LDA $7782,x               ;
CODE_009565:        D0 0B         BNE CODE_009572           ;
CODE_009567:        A9 04 00      LDA #$0004                ;
CODE_00956A:        9D 82 77      STA $7782,x               ;
CODE_00956D:        DE C2 73      DEC $73C2,x               ;
CODE_009570:        30 01         BMI CODE_009573           ;
CODE_009572:        60            RTS                       ;

CODE_009573:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009576:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009579:        BD 82 77      LDA $7782,x               ;
CODE_00957C:        D0 0B         BNE CODE_009589           ;
CODE_00957E:        A9 06 00      LDA #$0006                ;
CODE_009581:        9D 82 77      STA $7782,x               ;
CODE_009584:        DE C2 73      DEC $73C2,x               ;
CODE_009587:        30 01         BMI CODE_00958A           ;
CODE_009589:        60            RTS                       ;

CODE_00958A:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00958D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009590:        BD 82 77      LDA $7782,x               ;
CODE_009593:        D0 0B         BNE CODE_0095A0           ;
CODE_009595:        A9 08 00      LDA #$0008                ;
CODE_009598:        9D 82 77      STA $7782,x               ;
CODE_00959B:        DE C2 73      DEC $73C2,x               ;
CODE_00959E:        30 01         BMI CODE_0095A1           ;
CODE_0095A0:        60            RTS                       ;

CODE_0095A1:        4C F8 8A      JMP CODE_008AF8           ;

DATA_0095A4:          db $20, $00, $22, $00, $20, $80, $02, $40
DATA_0095AC:          db $00, $00, $02, $00, $20, $00, $22, $00
DATA_0095B4:          db $20, $80, $02, $80

DATA_0095B8:          db $00, $00, $00, $00, $00, $80, $00, $40
DATA_0095C0:          db $00, $00, $00, $00, $00, $00, $00, $00
DATA_0095C8:          db $00, $80, $00, $80

CODE_0095CC:        BD 22 73      LDA $7322,x               ;
CODE_0095CF:        30 22         BMI CODE_0095F3           ;
CODE_0095D1:        BC 4E 7E      LDY $7E4E,x               ;
CODE_0095D4:        B9 A4 95      LDA $95A4,y               ;
CODE_0095D7:        85 00         STA $00                   ;
CODE_0095D9:        B9 B8 95      LDA $95B8,y               ;
CODE_0095DC:        85 02         STA $02                   ;
CODE_0095DE:        C2 10         REP #$10                  ;
CODE_0095E0:        BC 22 73      LDY $7322,x               ;
CODE_0095E3:        B9 04 60      LDA $6004,y               ;
CODE_0095E6:        05 00         ORA $00                   ;
CODE_0095E8:        45 02         EOR $02                   ;
CODE_0095EA:        18            CLC                       ;
CODE_0095EB:        7D 8C 7E      ADC $7E8C,x               ;
CODE_0095EE:        99 04 60      STA $6004,y               ;
CODE_0095F1:        E2 10         SEP #$10                  ;
CODE_0095F3:        20 E5 8A      JSR CODE_008AE5           ;
CODE_0095F6:        BD 8E 7E      LDA $7E8E,x               ;
CODE_0095F9:        D0 18         BNE CODE_009613           ;
CODE_0095FB:        BD C0 78      LDA $78C0,x               ;
CODE_0095FE:        9D 8E 7E      STA $7E8E,x               ;
CODE_009601:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009604:        18            CLC                       ;
CODE_009605:        69 02 00      ADC #$0002                ;
CODE_009608:        9D 4E 7E      STA $7E4E,x               ;
CODE_00960B:        C9 14 00      CMP #$0014                ;
CODE_00960E:        30 03         BMI CODE_009613           ;
CODE_009610:        9E 4E 7E      STZ $7E4E,x               ;
CODE_009613:        60            RTS                       ;

DATA_009614:          db $04, $03, $02, $01, $00, $00, $00

CODE_00961B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00961E:        BD 82 77      LDA $7782,x               ;
CODE_009621:        D0 17         BNE CODE_00963A           ;
CODE_009623:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009626:        30 12         BMI CODE_00963A           ;
CODE_009628:        E2 20         SEP #$20                  ;
CODE_00962A:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00962D:        B9 14 96      LDA $9614,y               ;
CODE_009630:        9D C2 73      STA $73C2,x               ;
CODE_009633:        A9 04         LDA #$04                  ;
CODE_009635:        9D 82 77      STA $7782,x               ;
CODE_009638:        C2 20         REP #$20                  ;
CODE_00963A:        60            RTS                       ;

DATA_00963B:          db $04, $04, $04, $04, $04, $04, $04, $03
DATA_009643:          db $03, $02, $02

CODE_009646:        DA            PHX                       ;
CODE_009647:        8A            TXA                       ;
CODE_009648:        29 FF 00      AND #$00FF                ;
CODE_00964B:        8D 14 30      STA $3014                 ; r10
CODE_00964E:        A9 00 00      LDA #$0000                ;
CODE_009651:        8D 00 30      STA $3000                 ;
CODE_009654:        A9 93 96      LDA #$9693                ;
CODE_009657:        8D 1C 30      STA $301C                 ; r14
CODE_00965A:        A2 09         LDX #$09                  ;
CODE_00965C:        A9 B1 8C      LDA #$8CB1                ;
CODE_00965F:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_009663:        FA            PLX                       ;
CODE_009664:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009667:        BD 82 77      LDA $7782,x               ;
CODE_00966A:        D0 1B         BNE CODE_009687           ;
CODE_00966C:        DE C2 73      DEC $73C2,x               ;
CODE_00966F:        10 03         BPL CODE_009674           ;
CODE_009671:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009674:        E2 20         SEP #$20                  ;
CODE_009676:        BC C2 73      LDY $73C2,x               ;
CODE_009679:        B9 88 96      LDA $9688,y               ;
CODE_00967C:        9D 01 70      STA $7001,x               ;
CODE_00967F:        B9 3B 96      LDA $963B,y               ;
CODE_009682:        9D 82 77      STA $7782,x               ;
CODE_009685:        C2 20         REP #$20                  ;
CODE_009687:        60            RTS                       ;

DATA_009688:         db $08, $10, $18, $28, $38, $58, $58, $58
DATA_009690:         db $58, $58, $68

; gsu table
DATA_009693:         dw $9868, $985E, $984F, $9836
DATA_00969B:         dw $9813, $97DC, $97A5, $976E
DATA_0096A3:         dw $9737, $9700, $96BF, $96AB

DATA_0096AB:         db $08, $08, $6A, $C6, $02, $F8, $08, $6A
DATA_0096B3:         db $86, $02, $08, $F8, $6A, $46, $02, $F8
DATA_0096BB:         db $F8, $6A, $06, $02

DATA_0096BF:         db $04, $FC, $45, $06, $00, $00, $08, $55
DATA_0096C7:         db $06, $00, $04, $04, $42, $C2, $02, $FC
DATA_0096CF:         db $04, $42, $82, $02, $04, $FC, $42, $42
DATA_0096D7:         db $02, $FC, $FC, $42, $02, $02, $0F, $0D
DATA_0096DF:         db $4C, $06, $00, $00, $0F, $4C, $46, $00
DATA_0096E7:         db $F7, $06, $4C, $06, $00, $12, $03, $4C
DATA_0096EF:         db $46, $00, $09, $F9, $4C, $46, $00, $FE
DATA_0096F7:         db $FB, $4C, $46, $00, $04, $06, $4C, $06
DATA_0096FF:         db $00

DATA_009700:         db $04, $FC, $54, $06, $00, $10, $10, $55
DATA_009708:         db $06, $00, $00, $08, $45, $06, $00, $00
DATA_009710:         db $08, $55, $06, $00, $10, $12, $4C, $06
DATA_009718:         db $00, $FF, $14, $4C, $46, $00, $F6, $09
DATA_009720:         db $4C, $06, $00, $13, $06, $4C, $46, $00
DATA_009728:         db $0A, $FC, $4C, $46, $00, $FD, $FE, $4C
DATA_009730:         db $46, $00, $04, $09, $4C, $06, $00

DATA_009737:         db $04, $FC, $44, $06, $00, $F8, $10, $55
DATA_00973F:         db $06, $00, $00, $08, $54, $06, $00, $10
DATA_009747:         db $10, $45, $06, $00, $11, $16, $4C, $06
DATA_00974F:         db $00, $FE, $18, $4C, $46, $00, $F5, $0D
DATA_009757:         db $4C, $06, $00, $14, $0A, $4C, $46, $00
DATA_00975F:         db $0B, $00, $4C, $06, $00, $FC, $02, $4C
DATA_009767:         db $46, $00, $04, $0D, $4C, $06, $00

DATA_00976E:         db $00, $18, $55, $06, $00, $00, $08, $44
DATA_009776:         db $06, $00, $10, $10, $54, $06, $00, $F8
DATA_00977E:         db $10, $45, $06, $00, $12, $1A, $4C, $06
DATA_009786:         db $00, $FD, $1C, $4D, $46, $00, $F5, $11
DATA_00978E:         db $4C, $06, $00, $15, $0E, $4D, $46, $00
DATA_009796:         db $0C, $04, $4D, $06, $00, $FB, $06, $4D
DATA_00979E:         db $46, $00, $04, $11, $4C, $06, $00

DATA_0097A5:         db $08, $08, $55, $06, $00, $10, $10, $44
DATA_0097AD:         db $06, $00, $F8, $10, $54, $06, $00, $00
DATA_0097B5:         db $18, $45, $06, $00, $12, $1E, $4D, $06
DATA_0097BD:         db $00, $FD, $20, $4E, $46, $00, $F4, $15
DATA_0097C5:         db $4D, $06, $00, $15, $12, $4E, $46, $00
DATA_0097CD:         db $0C, $08, $4E, $06, $00, $FB, $0A, $4E
DATA_0097D5:         db $46, $00, $04, $15, $4C, $06, $00

DATA_0097DC:         db $10, $20, $55, $06, $00, $F8, $10, $44
DATA_0097E4:         db $06, $00, $00, $18, $54, $06, $00, $08
DATA_0097EC:         db $08, $45, $06, $00, $12, $23, $4E, $46
DATA_0097F4:         db $00, $FD, $25, $4F, $46, $00, $F4, $1A
DATA_0097FC:         db $4E, $06, $00, $15, $17, $4F, $46, $00
DATA_009804:         db $0C, $0D, $4F, $06, $00, $FB, $0F, $4F
DATA_00980C:         db $46, $00, $04, $1A, $4D, $06, $00

DATA_009813:         db $12, $27, $4F, $46, $00, $F4, $1F, $4F
DATA_00981B:         db $06, $00, $04, $1F, $4E, $06, $00, $FC
DATA_009823:         db $28, $55, $06, $00, $00, $18, $44, $06
DATA_00982B:         db $00, $08, $08, $54, $06, $00, $10, $20
DATA_009833:         db $45, $06, $00

DATA_009836:         db $04, $24, $4F, $06, $00, $08, $30, $55
DATA_00983E:         db $06, $00, $FC, $28, $45, $06, $00, $10
DATA_009846:         db $20, $54, $06, $00, $08, $08, $44, $06
DATA_00984E:         db $00

DATA_00984F:         db $08, $30, $45, $06, $00, $FC, $28, $54
DATA_009857:         db $06, $00, $10, $20, $44, $06, $00

DATA_00985E:         db $08, $30, $54, $06, $00, $FC, $28, $44
DATA_009866:         db $06, $00

DATA_009868:         db $08, $30, $44, $06, $00

CODE_00986D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009870:        BD 82 77      LDA $7782,x               ;
CODE_009873:        D0 0E         BNE CODE_009883           ;
CODE_009875:        DE 4E 7E      DEC $7E4E,x               ;
CODE_009878:        30 09         BMI CODE_009883           ;
CODE_00987A:        FE C2 73      INC $73C2,x               ;
CODE_00987D:        BD 4C 7E      LDA $7E4C,x               ;
CODE_009880:        9D 82 77      STA $7782,x               ;
CODE_009883:        60            RTS                       ;

DATA_009884:          dw $002C, $003C, $0050, $0064
DATA_00988C:          dw $0068, $000C, $000C, $0014
DATA_009894:          dw $0018, $001C, $0004, $0004
DATA_00989C:          dw $0004, $0005, $0006, $0000
DATA_0098A4:          dw $0001, $0002, $0001, $0003

CODE_0098AC:        DA            PHX                       ;
CODE_0098AD:        BD C0 78      LDA $78C0,x               ;
CODE_0098B0:        8D 02 30      STA $3002                 ; r1
CODE_0098B3:        BD C2 78      LDA $78C2,x               ;
CODE_0098B6:        8D 04 30      STA $3004                 ; r2
CODE_0098B9:        BD 22 73      LDA $7322,x               ;
CODE_0098BC:        8D 06 30      STA $3006                 ; r3
CODE_0098BF:        BD 8C 7E      LDA $7E8C,x               ;
CODE_0098C2:        8D 08 30      STA $3008                 ; r4
CODE_0098C5:        BD A2 70      LDA $70A2,x               ;
CODE_0098C8:        8D 0A 30      STA $300A                 ; r5
CODE_0098CB:        BD 42 71      LDA $7142,x               ;
CODE_0098CE:        8D 0C 30      STA $300C                 ; r6
CODE_0098D1:        A2 08         LDX #$08                  ;
CODE_0098D3:        A9 87 92      LDA #$9287                ;
CODE_0098D6:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_0098DA:        FA            PLX                       ;
CODE_0098DB:        20 E5 8A      JSR CODE_008AE5           ;
CODE_0098DE:        BD 8E 7E      LDA $7E8E,x               ;
CODE_0098E1:        D0 2C         BNE CODE_00990F           ;
CODE_0098E3:        FE 4C 7E      INC $7E4C,x               ;
CODE_0098E6:        BD 4C 7E      LDA $7E4C,x               ;
CODE_0098E9:        0A            ASL A                     ;
CODE_0098EA:        A8            TAY                       ;
CODE_0098EB:        C0 0A         CPY #$0A                  ;
CODE_0098ED:        D0 05         BNE CODE_0098F4           ;
CODE_0098EF:        A9 00 00      LDA #$0000                ;
CODE_0098F2:        80 1B         BRA CODE_00990F           ;

CODE_0098F4:        B9 84 98      LDA $9884,y               ;
CODE_0098F7:        9D C0 78      STA $78C0,x               ;
CODE_0098FA:        B9 8E 98      LDA $988E,y               ;
CODE_0098FD:        9D C2 78      STA $78C2,x               ;
CODE_009900:        B9 98 98      LDA $9898,y               ;
CODE_009903:        9D 8E 7E      STA $7E8E,x               ;
CODE_009906:        B9 A2 98      LDA $98A2,y               ;
CODE_009909:        9D C2 73      STA $73C2,x               ;
CODE_00990C:        A9 03 00      LDA #$0003                ;
CODE_00990F:        9D 82 77      STA $7782,x               ;
CODE_009912:        60            RTS                       ;

CODE_009913:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009916:        A9 01 00      LDA #$0001                ;
CODE_009919:        9D 82 77      STA $7782,x               ;
CODE_00991C:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00991F:        BD 4C 7E      LDA $7E4C,x               ;
CODE_009922:        10 2F         BPL CODE_009953           ;
CODE_009924:        A9 01 00      LDA #$0001                ;
CODE_009927:        9D 4C 7E      STA $7E4C,x               ;
CODE_00992A:        FE 4E 7E      INC $7E4E,x               ;
CODE_00992D:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009930:        C9 0F 00      CMP #$000F                ;
CODE_009933:        90 1E         BCC CODE_009953           ;
CODE_009935:        A9 0E 00      LDA #$000E                ;
CODE_009938:        9D 4E 7E      STA $7E4E,x               ;
CODE_00993B:        BD 62 74      LDA $7462,x               ;
CODE_00993E:        29 FF 00      AND #$00FF                ;
CODE_009941:        C9 FF 00      CMP #$00FF                ;
CODE_009944:        F0 0D         BEQ CODE_009953           ;
CODE_009946:        DA            PHX                       ;
CODE_009947:        5A            PHY                       ;
CODE_009948:        20 5F 99      JSR CODE_00995F           ;
CODE_00994B:        7A            PLY                       ;
CODE_00994C:        FA            PLX                       ;
CODE_00994D:        A9 FF 00      LDA #$00FF                ;
CODE_009950:        9D 62 74      STA $7462,x               ;
CODE_009953:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009956:        0A            ASL A                     ;
CODE_009957:        A8            TAY                       ;
CODE_009958:        B9 7A 99      LDA $997A,y               ;
CODE_00995B:        9D C2 73      STA $73C2,x               ;
CODE_00995E:        60            RTS                       ;

CODE_00995F:        A9 2D 02      LDA #$022D                ;
CODE_009962:        22 21 8B 00   JSL CODE_008B21           ;
CODE_009966:        BD A2 70      LDA $70A2,x               ;
CODE_009969:        99 A2 70      STA $70A2,y               ;
CODE_00996C:        BD 42 71      LDA $7142,x               ;
CODE_00996F:        99 42 71      STA $7142,y               ;
CODE_009972:        DA            PHX                       ;
CODE_009973:        BB            TYX                       ;
CODE_009974:        22 96 9A 00   JSL CODE_009A96           ;
CODE_009978:        FA            PLX                       ;
CODE_009979:        60            RTS                       ;

DATA_00997A:          dw $0000, $0001, $0002, $0003
DATA_009982:          dw $0004, $0005, $0006, $0007
DATA_00998A:          dw $0008, $0009, $000A, $000B
DATA_009992:          dw $000C, $000E, $000D

CODE_009998:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00999B:        A9 02 00      LDA #$0002                ;
CODE_00999E:        9D 82 77      STA $7782,x               ;
CODE_0099A1:        DE 4C 7E      DEC $7E4C,x               ;
CODE_0099A4:        BD 4C 7E      LDA $7E4C,x               ;
CODE_0099A7:        10 0F         BPL CODE_0099B8           ;
CODE_0099A9:        BC 4E 7E      LDY $7E4E,x               ;
CODE_0099AC:        B9 10 9A      LDA $9A10,y               ;
CODE_0099AF:        29 FF 00      AND #$00FF                ;
CODE_0099B2:        9D 4C 7E      STA $7E4C,x               ;
CODE_0099B5:        FE 4E 7E      INC $7E4E,x               ;
CODE_0099B8:        BD 4E 7E      LDA $7E4E,x               ;
CODE_0099BB:        29 03 00      AND #$0003                ;
CODE_0099BE:        0A            ASL A                     ;
CODE_0099BF:        A8            TAY                       ;
CODE_0099C0:        B9 08 9A      LDA $9A08,y               ;
CODE_0099C3:        9D C2 73      STA $73C2,x               ;
CODE_0099C6:        BD E2 71      LDA $71E2,x               ;
CODE_0099C9:        30 3C         BMI CODE_009A07           ;
CODE_0099CB:        C9 80 02      CMP #$0280                ;
CODE_0099CE:        90 07         BCC CODE_0099D7           ;
CODE_0099D0:        A9 00 00      LDA #$0000                ;
CODE_0099D3:        9D 82 77      STA $7782,x               ;
CODE_0099D6:        60            RTS                       ;

CODE_0099D7:        BD 8C 7E      LDA $7E8C,x               ;
CODE_0099DA:        D0 2B         BNE CODE_009A07           ;
CODE_0099DC:        FE 8C 7E      INC $7E8C,x               ;
CODE_0099DF:        A9 2E 02      LDA #$022E                ;
CODE_0099E2:        22 21 8B 00   JSL CODE_008B21           ;
CODE_0099E6:        BD A2 70      LDA $70A2,x               ;
CODE_0099E9:        18            CLC                       ;
CODE_0099EA:        69 D8 FF      ADC #$FFD8                ;
CODE_0099ED:        99 A2 70      STA $70A2,y               ;
CODE_0099F0:        BD 42 71      LDA $7142,x               ;
CODE_0099F3:        18            CLC                       ;
CODE_0099F4:        69 00 00      ADC #$0000                ;
CODE_0099F7:        99 42 71      STA $7142,y               ;
CODE_0099FA:        A9 03 00      LDA #$0003                ;
CODE_0099FD:        99 82 77      STA $7782,y               ;
CODE_009A00:        DA            PHX                       ;
CODE_009A01:        BB            TYX                       ;
CODE_009A02:        22 BF 9A 00   JSL CODE_009ABF           ;
CODE_009A06:        FA            PLX                       ;
CODE_009A07:        60            RTS                       ;

DATA_009A08:          db $00, $00, $01, $00, $02, $00, $01, $00
DATA_009A10:          db $02, $03, $03, $03, $03, $20, $03, $03
DATA_009A18:          db $03

CODE_009A19:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009A1C:        A9 02 00      LDA #$0002                ;
CODE_009A1F:        9D 82 77      STA $7782,x               ;
CODE_009A22:        DA            PHX                       ;
CODE_009A23:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009A26:        BD 4C 7E      LDA $7E4C,x               ;
CODE_009A29:        10 1E         BPL CODE_009A49           ;
CODE_009A2B:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009A2E:        29 01 00      AND #$0001                ;
CODE_009A31:        18            CLC                       ;
CODE_009A32:        69 00 00      ADC #$0000                ;
CODE_009A35:        9D 4C 7E      STA $7E4C,x               ;
CODE_009A38:        FE 4E 7E      INC $7E4E,x               ;
CODE_009A3B:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009A3E:        C9 0C 00      CMP #$000C                ;
CODE_009A41:        90 06         BCC CODE_009A49           ;
CODE_009A43:        A9 04 00      LDA #$0004                ;
CODE_009A46:        9D 4E 7E      STA $7E4E,x               ;
CODE_009A49:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009A4C:        9D C2 73      STA $73C2,x               ;
CODE_009A4F:        BD 8E 7E      LDA $7E8E,x               ;
CODE_009A52:        D0 0D         BNE CODE_009A61           ;
CODE_009A54:        0B            PHD                       ;
CODE_009A55:        A9 00 00      LDA #$0000                ;
CODE_009A58:        48            PHA                       ;
CODE_009A59:        2B            PLD                       ;
CODE_009A5A:        22 B8 91 11   JSL CODE_1191B8           ;
CODE_009A5E:        C2 20         REP #$20                  ;
CODE_009A60:        2B            PLD                       ;
CODE_009A61:        FA            PLX                       ;
CODE_009A62:        8E 4A 7E      STX $7E4A                 ;
CODE_009A65:        60            RTS                       ;

CODE_009A66:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009A69:        A9 02 00      LDA #$0002                ;
CODE_009A6C:        9D 82 77      STA $7782,x               ;
CODE_009A6F:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009A72:        BD 4C 7E      LDA $7E4C,x               ;
CODE_009A75:        10 18         BPL CODE_009A8F           ;
CODE_009A77:        A9 03 00      LDA #$0003                ;
CODE_009A7A:        9D 4C 7E      STA $7E4C,x               ;
CODE_009A7D:        FE 4E 7E      INC $7E4E,x               ;
CODE_009A80:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009A83:        C9 08 00      CMP #$0008                ;
CODE_009A86:        90 07         BCC CODE_009A8F           ;
CODE_009A88:        A9 00 00      LDA #$0000                ;
CODE_009A8B:        9D 82 77      STA $7782,x               ;
CODE_009A8E:        60            RTS                       ;

CODE_009A8F:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009A92:        9D C2 73      STA $73C2,x               ;
CODE_009A95:        60            RTS                       ;

CODE_009A96:        A9 02 00      LDA #$0002                ;
CODE_009A99:        9D 82 77      STA $7782,x               ;
CODE_009A9C:        A9 03 00      LDA #$0003                ;
CODE_009A9F:        9D 4C 7E      STA $7E4C,x               ;
CODE_009AA2:        9E 4E 7E      STZ $7E4E,x               ;
CODE_009AA5:        9E 02 75      STZ $7502,x               ;
CODE_009AA8:        A9 00 00      LDA #$0000                ;
CODE_009AAB:        9D 62 74      STA $7462,x               ;
CODE_009AAE:        A9 40 00      LDA #$0040                ;
CODE_009AB1:        9D 8E 7E      STA $7E8E,x               ;
CODE_009AB4:        A9 08 00      LDA #$0008                ;\ play sound #$0008
CODE_009AB7:        22 D2 85 00   JSL CODE_0085D2           ;/
CODE_009ABB:        8E 4A 7E      STX $7E4A                 ;
CODE_009ABE:        6B            RTL                       ;

CODE_009ABF:        A9 03 00      LDA #$0003                ;
CODE_009AC2:        9D 82 77      STA $7782,x               ;
CODE_009AC5:        9E 4E 7E      STZ $7E4E,x               ;
CODE_009AC8:        9E 02 75      STZ $7502,x               ;
CODE_009ACB:        A9 00 00      LDA #$0000                ;
CODE_009ACE:        9D 62 74      STA $7462,x               ;
CODE_009AD1:        A9 3F 00      LDA #$003F                ;\ play sound #$003F
CODE_009AD4:        22 D2 85 00   JSL CODE_0085D2           ;/
CODE_009AD8:        6B            RTL                       ;

DATA_009AD9:          db $40, $00, $C0, $FF, $20, $F2, $8A, $BD
DATA_009AE1:          db $8E, $7E, $D0, $03

CODE_009AE5:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009AE8:        C9 40 00      CMP #$0040                ;
CODE_009AEB:        10 0D         BPL CODE_009AFA           ;
CODE_009AED:        A0 FF         LDY #$FF                  ;
CODE_009AEF:        29 01 00      AND #$0001                ;
CODE_009AF2:        F0 02         BEQ CODE_009AF6           ;
CODE_009AF4:        A0 01         LDY #$01                  ;
CODE_009AF6:        98            TYA                       ;
CODE_009AF7:        9D 62 74      STA $7462,x               ;
CODE_009AFA:        BD 8E 7E      LDA $7E8E,x               ;
CODE_009AFD:        29 3F 00      AND #$003F                ;
CODE_009B00:        D0 10         BNE CODE_009B12           ;
CODE_009B02:        BD C0 73      LDA $73C0,x               ;
CODE_009B05:        49 02 00      EOR #$0002                ;
CODE_009B08:        9D C0 73      STA $73C0,x               ;
CODE_009B0B:        A8            TAY                       ;
CODE_009B0C:        B9 D9 9A      LDA $9AD9,y               ;
CODE_009B0F:        9D E0 71      STA $71E0,x               ;
CODE_009B12:        60            RTS                       ;

CODE_009B13:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009B16:        BC 62 74      LDY $7462,x               ;
CODE_009B19:        C0 FF         CPY #$FF                  ;
CODE_009B1B:        D0 08         BNE CODE_009B25           ;
CODE_009B1D:        A9 01 00      LDA #$0001                ;
CODE_009B20:        9D 62 74      STA $7462,x               ;
CODE_009B23:        80 2D         BRA CODE_009B52           ;

CODE_009B25:        BD 8C 7E      LDA $7E8C,x               ;
CODE_009B28:        18            CLC                       ;
CODE_009B29:        7D 4E 7E      ADC $7E4E,x               ;
CODE_009B2C:        9D 8C 7E      STA $7E8C,x               ;
CODE_009B2F:        89 00 FF      BIT #$FF00                ;
CODE_009B32:        F0 0C         BEQ CODE_009B40           ;
CODE_009B34:        29 FF 00      AND #$00FF                ;
CODE_009B37:        9D 8C 7E      STA $7E8C,x               ;
CODE_009B3A:        A9 FF 00      LDA #$00FF                ;
CODE_009B3D:        9D 62 74      STA $7462,x               ;
CODE_009B40:        BD 4E 7E      LDA $7E4E,x               ;
CODE_009B43:        18            CLC                       ;
CODE_009B44:        69 04 00      ADC #$0004                ;
CODE_009B47:        C9 00 01      CMP #$0100                ;
CODE_009B4A:        30 03         BMI CODE_009B4F           ;
CODE_009B4C:        A9 00 01      LDA #$0100                ;
CODE_009B4F:        9D 4E 7E      STA $7E4E,x               ;
CODE_009B52:        60            RTS                       ;

DATA_009B53:         db $0C, $10, $20, $E5, $8A, $BD, $82, $77
DATA_009B5B:         db $D0, $14, $DE, $C2, $73, $10, $03

CODE_009B62:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009B65:        BC C2 73      LDY $73C2,x               ;
CODE_009B68:        B9 53 9B      LDA $9B53,y               ;
CODE_009B6B:        29 FF 00      AND #$00FF                ;
CODE_009B6E:        9D 82 77      STA $7782,x               ;
CODE_009B71:        60            RTS                       ;

DATA_009B72:         db $03, $03, $03, $03, $03, $03, $03, $03
DATA_009B7A:         db $03, $02, $02, $02, $02, $02, $02, $02
DATA_009B82:         db $02, $02, $02, $02, $02, $02

CODE_009B88:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009B8B:        E2 20         SEP #$20                  ;
CODE_009B8D:        BD 82 77      LDA $7782,x               ;
CODE_009B90:        F0 0F         BEQ CODE_009BA1           ;
CODE_009B92:        BC C2 73      LDY $73C2,x               ;
CODE_009B95:        C0 16         CPY #$16                  ;
CODE_009B97:        D0 1B         BNE CODE_009BB4           ;
CODE_009B99:        C9 02         CMP #$02                  ;
CODE_009B9B:        B0 17         BCS CODE_009BB4           ;
CODE_009B9D:        A9 FF         LDA #$FF                  ;
CODE_009B9F:        80 15         BRA CODE_009BB6           ;

CODE_009BA1:        DE C2 73      DEC $73C2,x               ;
CODE_009BA4:        10 05         BPL CODE_009BAB           ;
CODE_009BA6:        C2 20         REP #$20                  ;
CODE_009BA8:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009BAB:        BC C2 73      LDY $73C2,x               ;
CODE_009BAE:        B9 72 9B      LDA $9B72,y               ;
CODE_009BB1:        9D 82 77      STA $7782,x               ;
CODE_009BB4:        A9 05         LDA #$05                  ;
CODE_009BB6:        9D 62 74      STA $7462,x               ;
CODE_009BB9:        C2 20         REP #$20                  ;
CODE_009BBB:        60            RTS                       ;

CODE_009BBC:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009BBF:        BD 82 77      LDA $7782,x               ;
CODE_009BC2:        D0 03         BNE CODE_009BC7           ;
CODE_009BC4:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009BC7:        BD 8E 7E      LDA $7E8E,x               ;
CODE_009BCA:        D0 11         BNE CODE_009BDD           ;
CODE_009BCC:        A9 04 00      LDA #$0004                ;
CODE_009BCF:        9D 8E 7E      STA $7E8E,x               ;
CODE_009BD2:        DE C2 73      DEC $73C2,x               ;
CODE_009BD5:        10 06         BPL CODE_009BDD           ;
CODE_009BD7:        A9 05 00      LDA #$0005                ;
CODE_009BDA:        9D C2 73      STA $73C2,x               ;
CODE_009BDD:        60            RTS                       ;

DATA_009BDE:         db $08, $06, $04, $02, $02

CODE_009BE3:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009BE6:        BD 82 77      LDA $7782,x               ;
CODE_009BE9:        D0 25         BNE CODE_009C10           ;
CODE_009BEB:        DE 4C 7E      DEC $7E4C,x               ;
CODE_009BEE:        10 03         BPL CODE_009BF3           ;
CODE_009BF0:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009BF3:        E2 20         SEP #$20                  ;
CODE_009BF5:        DE C2 73      DEC $73C2,x               ;
CODE_009BF8:        BC 4C 7E      LDY $7E4C,x               ;
CODE_009BFB:        B9 DE 9B      LDA $9BDE,y               ;
CODE_009BFE:        9D 82 77      STA $7782,x               ;
CODE_009C01:        C2 20         REP #$20                  ;
CODE_009C03:        A9 01 00      LDA #$0001                ;
CODE_009C06:        C0 03         CPY #$03                  ;
CODE_009C08:        D0 03         BNE CODE_009C0D           ;
CODE_009C0A:        A9 FF FF      LDA #$FFFF                ;
CODE_009C0D:        9D 62 74      STA $7462,x               ;
CODE_009C10:        60            RTS                       ;

DATA_009C11:         db $03, $03, $03, $03, $03, $03
DATA_009C17:         db $03, $02, $02, $02, $02, $02

CODE_009C1D:        DA            PHX                       ;
CODE_009C1E:        8A            TXA                       ;
CODE_009C1F:        29 FF 00      AND #$00FF                ;
CODE_009C22:        8D 14 30      STA $3014                 ; r10
CODE_009C25:        A9 00 00      LDA #$0000                ;
CODE_009C28:        8D 00 30      STA $3000                 ; r0
CODE_009C2B:        A9 6B 9C      LDA #$9C6B                ;
CODE_009C2E:        8D 1C 30      STA $301C                 ; r14
CODE_009C31:        A2 09         LDX #$09                  ;
CODE_009C33:        A9 B1 8C      LDA #$8CB1                ;
CODE_009C36:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_009C3A:        FA            PLX                       ;
CODE_009C3B:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009C3E:        BD 82 77      LDA $7782,x               ;
CODE_009C41:        D0 1B         BNE CODE_009C5E           ;
CODE_009C43:        DE C2 73      DEC $73C2,x               ;
CODE_009C46:        10 03         BPL CODE_009C4B           ;
CODE_009C48:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009C4B:        E2 20         SEP #$20                  ;
CODE_009C4D:        BC C2 73      LDY $73C2,x               ;
CODE_009C50:        B9 5F 9C      LDA $9C5F,y               ;
CODE_009C53:        9D 01 70      STA $7001,x               ;
CODE_009C56:        B9 11 9C      LDA $9C11,y               ;
CODE_009C59:        9D 82 77      STA $7782,x               ;
CODE_009C5C:        C2 20         REP #$20                  ;
CODE_009C5E:        60            RTS                       ;

DATA_009C5F:         db $10, $10, $20, $38, $48, $58
DATA_009C65:         db $58, $50, $58, $50, $50, $48

; gsu table
DATA_009C6B:         dw $9E88, $9E7E, $9E6A, $9E47
DATA_009C73:         dw $9E1A, $9DE3, $9DAC, $9D7A
DATA_009C7B:         dw $9D43, $9D11, $9CDF, $9CB2
DATA_009C83:         dw $9C85

DATA_009C85:         db $03, $FE, $55, $06, $00, $09, $0B, $4C
DATA_009C8D:         db $04, $00, $09, $00, $4C, $04, $00, $FF
DATA_009C95:         db $01, $4C, $04, $00, $05, $07, $4C, $04
DATA_009C9D:         db $00, $0E, $07, $4C, $04, $00, $00, $0B
DATA_009CA5:         db $4C, $04, $00, $FE, $06, $4C, $04, $00
DATA_009CAD:         db $04, $FD, $4D, $04, $00

DATA_009CB2:         db $03, $FE, $55, $06, $00, $0A, $0D, $4C
DATA_009CBA:         db $04, $00, $0A, $FD, $4C, $04, $00, $FE
DATA_009CC2:         db $FE, $4C, $04, $00, $05, $08, $4C, $04
DATA_009CCA:         db $00, $10, $06, $4C, $04, $00, $FF, $0C
DATA_009CD2:         db $4D, $84, $00, $FC, $07, $4C, $04, $00
DATA_009CDA:         db $04, $FE, $4D, $04, $00

DATA_009CDF:         db $0C, $02, $55, $06, $00, $03, $FE, $45
DATA_009CE7:         db $06, $00, $0A, $0F, $4C, $04, $00, $09
DATA_009CEF:         db $FB, $4D, $44, $00, $FD, $FD, $4C, $04
DATA_009CF7:         db $00, $05, $09, $4C, $04, $00, $12, $06
DATA_009CFF:         db $4D, $04, $00, $FE, $0D, $4E, $84, $00
DATA_009D07:         db $FA, $08, $4C, $04, $00, $04, $FF, $4D
DATA_009D0F:         db $04, $00

DATA_009D11:         db $0C, $02, $55, $06, $00, $03, $FE, $54
DATA_009D19:         db $06, $00, $0B, $12, $4D, $44, $00, $0B
DATA_009D21:         db $FA, $4D, $44, $00, $FD, $FD, $4C, $04
DATA_009D29:         db $00, $05, $0B, $4C, $04, $00, $13, $06
DATA_009D31:         db $4D, $04, $00, $FE, $0F, $4E, $84, $00
DATA_009D39:         db $FA, $0A, $4D, $04, $00, $04, $01, $4E
DATA_009D41:         db $04, $00

DATA_009D43:         db $FC, $08, $55, $06, $00, $0C, $02, $45
DATA_009D4B:         db $06, $00, $03, $FE, $44, $06, $00, $0C
DATA_009D53:         db $15, $4D, $44, $00, $0C, $FA, $4D, $44
DATA_009D5B:         db $00, $FC, $FE, $4C, $04, $00, $05, $0D
DATA_009D63:         db $4C, $04, $00, $14, $07, $4D, $04, $00
DATA_009D6B:         db $FD, $11, $4F, $84, $00, $F9, $0C, $4D
DATA_009D73:         db $04, $00, $04, $03, $4E, $04, $00

DATA_009D7A:         db $FC, $08, $55, $06, $00, $0C, $02, $54
DATA_009D82:         db $06, $00, $0C, $19, $4E, $44, $00, $0C
DATA_009D8A:         db $FB, $4E, $44, $00, $FC, $FF, $4D, $44
DATA_009D92:         db $00, $05, $10, $4D, $44, $00, $15, $08
DATA_009D9A:         db $4D, $04, $00, $FD, $14, $4F, $84, $00
DATA_009DA2:         db $F9, $0F, $4D, $04, $00, $04, $06, $4E
DATA_009DAA:         db $04, $00

DATA_009DAC:         db $07, $16, $55, $06, $00, $FC, $08, $55
DATA_009DB4:         db $06, $00, $0C, $02, $44, $06, $00, $0D
DATA_009DBC:         db $1D, $4E, $44, $00, $0D, $FC, $4E, $44
DATA_009DC4:         db $00, $FB, $01, $4E, $44, $00, $05, $13
DATA_009DCC:         db $4E, $44, $00, $15, $09, $4E, $04, $00
DATA_009DD4:         db $FC, $17, $4F, $84, $00, $F8, $12, $4E
DATA_009DDC:         db $04, $00, $04, $09, $4F, $04, $00

DATA_009DE3:         db $07, $17, $55, $06, $00, $FC, $09, $55
DATA_009DEB:         db $06, $00, $0C, $03, $44, $06, $00, $0D
DATA_009DF3:         db $1F, $4F, $44, $00, $0D, $FE, $4F, $44
DATA_009DFB:         db $00, $FB, $03, $4E, $44, $00, $05, $15
DATA_009E03:         db $4E, $44, $00, $16, $0A, $4E, $04, $00
DATA_009E0B:         db $FC, $19, $4F, $84, $00, $F8, $14, $4E
DATA_009E13:         db $04, $00, $04, $0A, $4F, $04, $00

DATA_009E1A:         db $03, $20, $44, $06, $00, $07, $16, $45
DATA_009E22:         db $06, $00, $FC, $08, $54, $06, $00, $0D
DATA_009E2A:         db $22, $4F, $44, $00, $0E, $01, $4F, $44
DATA_009E32:         db $00, $FB, $05, $4F, $44, $00, $05, $19
DATA_009E3A:         db $4E, $44, $00, $17, $0D, $4E, $04, $00
DATA_009E42:         db $F7, $17, $4F, $04, $00

DATA_009E47:         db $17, $10, $4F, $04, $00, $03, $20, $54
DATA_009E4F:         db $06, $00, $07, $16, $54, $06, $00, $FC
DATA_009E57:         db $08, $44, $06, $00, $0E, $05, $4F, $44
DATA_009E5F:         db $00, $F7, $1A, $4F, $04, $00, $05, $1C
DATA_009E67:         db $4F, $44, $00

DATA_009E6A:         db $18, $12, $4F, $04, $00, $03, $20, $45
DATA_009E72:         db $06, $00, $07, $16, $44, $06, $00, $05
DATA_009E7A:         db $1F, $4F, $44, $00

DATA_009E7E:         db $03, $20, $54, $06, $00, $05, $22, $4F
DATA_009E86:         db $44, $00

DATA_009E88:         db $03, $20, $44, $06, $00, $05, $25, $4F
DATA_009E90:         db $44, $00, $DA

CODE_009E92:        DA            PHX                       ;
CODE_009E93:        8A            TXA                       ;
CODE_009E94:        29 FF 00      AND #$00FF                ;
CODE_009E97:        8D 14 30      STA $3014                 ; r10
CODE_009E9A:        A9 00 00      LDA #$0000                ;
CODE_009E9D:        8D 00 30      STA $3000                 ; r0
CODE_009EA0:        A9 E0 9E      LDA #$9EE0                ;
CODE_009EA3:        8D 1C 30      STA $301C                 ; r14
CODE_009EA6:        A2 09         LDX #$09                  ;
CODE_009EA8:        A9 B1 8C      LDA #$8CB1                ;
CODE_009EAB:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_009EAF:        FA            PLX                       ;
CODE_009EB0:        20 E5 8A      JSR CODE_008AE5           ;
CODE_009EB3:        BD 82 77      LDA $7782,x               ;
CODE_009EB6:        D0 1A         BNE CODE_009ED2           ;
CODE_009EB8:        DE C2 73      DEC $73C2,x               ;
CODE_009EBB:        10 03         BPL CODE_009EC0           ;
CODE_009EBD:        4C F8 8A      JMP CODE_008AF8           ;

CODE_009EC0:        E2 20         SEP #$20                  ;
CODE_009EC2:        BC C2 73      LDY $73C2,x               ;
CODE_009EC5:        B9 D3 9E      LDA $9ED3,y               ;
CODE_009EC8:        9D 01 70      STA $7001,x               ;
CODE_009ECB:        A9 02         LDA #$02                  ;
CODE_009ECD:        9D 82 77      STA $7782,x               ;
CODE_009ED0:        C2 20         REP #$20                  ;
CODE_009ED2:        60            RTS                       ;

DATA_009ED3:         db $10, $20, $30, $40, $50, $50, $48, $50
DATA_009EDB:         db $60, $58, $50, $60, $60

; gsu table
DATA_009EE0:         dw $A172, $A15E, $A140, $A118
DATA_009EE8:         dw $A0E6, $A0B4, $A087, $A055
DATA_009EF0:         dw $A019, $9FE2, $9FB0, $9F74
DATA_009EF8:         dw $9F38, $9EFC

DATA_009EFC:         db $07, $08, $42, $C2, $02, $F7, $08, $42
DATA_009F04:         db $82, $02, $07, $F8, $42, $42, $02, $F7
DATA_009F0C:         db $F8, $42, $02, $02, $09, $01, $86, $08
DATA_009F14:         db $02, $FF, $08, $86, $08, $02, $F5, $FE
DATA_009F1C:         db $86, $08, $02, $01, $F6, $86, $08, $02
DATA_009F24:         db $0C, $09, $86, $08, $02, $F5, $0A, $86
DATA_009F2C:         db $08, $02, $0B, $F4, $86, $08, $02, $F6
DATA_009F34:         db $F3, $86, $08, $02

DATA_009F38:         db $05, $05, $42, $C2, $02, $FD, $05, $42
DATA_009F40:         db $82, $02, $05, $FD, $42, $42, $02, $FD
DATA_009F48:         db $FD, $42, $02, $02, $11, $01, $86, $08
DATA_009F50:         db $02, $FF, $10, $86, $08, $02, $ED, $FE
DATA_009F58:         db $86, $08, $02, $01, $F2, $86, $08, $02
DATA_009F60:         db $10, $0D, $86, $08, $02, $F1, $0E, $86
DATA_009F68:         db $08, $02, $0D, $EE, $86, $08, $02, $F4
DATA_009F70:         db $ED, $86, $08, $02

DATA_009F74:         db $08, $08, $6A, $C6, $02, $F8, $08, $6A
DATA_009F7C:         db $86, $02, $08, $F8, $6A, $46, $02, $F8
DATA_009F84:         db $F8, $6A, $06, $02, $15, $03, $86, $08
DATA_009F8C:         db $02, $FF, $14, $86, $08, $02, $E9, $FF
DATA_009F94:         db $86, $08, $02, $01, $F0, $86, $08, $02
DATA_009F9C:         db $14, $0F, $86, $08, $02, $EF, $10, $86
DATA_009FA4:         db $08, $02, $0F, $EC, $86, $08, $02, $F2
DATA_009FAC:         db $EB, $86, $08, $02

DATA_009FB0:         db $08, $08, $E3, $06, $02, $F8, $00, $E3
DATA_009FB8:         db $06, $02, $19, $05, $86, $08, $02, $FF
DATA_009FC0:         db $1A, $86, $08, $02, $E5, $01, $86, $08
DATA_009FC8:         db $02, $01, $EE, $E3, $06, $02, $16, $12
DATA_009FD0:         db $86, $08, $02, $ED, $13, $86, $08, $02
DATA_009FD8:         db $11, $EA, $86, $08, $02, $F0, $E9, $86
DATA_009FE0:         db $08, $02

DATA_009FE2:         db $08, $F8, $E3, $06, $02, $08, $08, $E5
DATA_009FEA:         db $06, $02, $F8, $00, $E5, $06, $02, $1D
DATA_009FF2:         db $07, $86, $08, $02, $FF, $1E, $E3, $06
DATA_009FFA:         db $02, $E1, $03, $86, $08, $02, $01, $ED
DATA_00A002:         db $E5, $06, $02, $18, $16, $86, $08, $02
DATA_00A00A:         db $EB, $17, $86, $08, $02, $13, $E9, $86
DATA_00A012:         db $08, $02, $EE, $E8, $86, $08, $02

DATA_00A019:         db $00, $00, $E3, $06, $02, $08, $F8, $E5
DATA_00A021:         db $06, $02, $08, $08, $E5, $06, $02, $F8
DATA_00A029:         db $00, $E7, $06, $02, $21, $09, $86, $08
DATA_00A031:         db $02, $FF, $24, $E5, $06, $02, $DD, $05
DATA_00A039:         db $86, $08, $02, $01, $ED, $E7, $06, $02
DATA_00A041:         db $1A, $1A, $86, $08, $02, $E9, $1B, $86
DATA_00A049:         db $08, $02, $15, $E9, $86, $08, $02, $EC
DATA_00A051:         db $E8, $86, $08, $02

DATA_00A055:         db $00, $10, $E3, $06, $02, $00, $00, $E5
DATA_00A05D:         db $06, $02, $08, $F8, $E7, $06, $02, $24
DATA_00A065:         db $0C, $E3, $06, $02, $FF, $2A, $E7, $06
DATA_00A06D:         db $02, $DA, $08, $86, $08, $02, $1D, $20
DATA_00A075:         db $86, $08, $02, $E6, $21, $86, $08, $02
DATA_00A07D:         db $18, $EA, $86, $08, $02, $E9, $E9, $86
DATA_00A085:         db $08, $02

DATA_00A087:         db $F0, $08, $E3, $06, $02, $00, $10, $E5
DATA_00A08F:         db $06, $02, $00, $00, $E7, $06, $02, $26
DATA_00A097:         db $0F, $E5, $06, $02, $D8, $0B, $86, $08
DATA_00A09F:         db $02, $1F, $25, $86, $08, $02, $E4, $26
DATA_00A0A7:         db $86, $08, $02, $1A, $EC, $86, $08, $02
DATA_00A0AF:         db $E7, $EB, $E3, $06, $02

DATA_00A0B4:         db $E8, $18, $E3, $06, $02, $08, $20, $E3
DATA_00A0BC:         db $06, $02, $F0, $08, $E5, $06, $02, $00
DATA_00A0C4:         db $10, $E7, $06, $02, $28, $14, $E7, $06
DATA_00A0CC:         db $02, $D6, $10, $86, $08, $02, $21, $2C
DATA_00A0D4:         db $86, $08, $02, $E2, $2D, $E3, $06, $02
DATA_00A0DC:         db $1C, $EF, $86, $08, $02, $E5, $EE, $E5
DATA_00A0E4:         db $06, $02

DATA_00A0E6:         db $18, $10, $E3, $06, $02, $E8, $18, $E5
DATA_00A0EE:         db $06, $02, $08, $20, $E5, $06, $02, $F0
DATA_00A0F6:         db $08, $E7, $06, $02, $00, $10, $E7, $06
DATA_00A0FE:         db $02, $D5, $15, $86, $08, $02, $22, $32
DATA_00A106:         db $86, $08, $02, $E1, $33, $E5, $06, $02
DATA_00A10E:         db $1D, $F3, $E5, $06, $02, $E4, $F2, $E7
DATA_00A116:         db $06, $02

DATA_00A118:         db $00, $38, $E3, $06, $02, $18, $10, $E5
DATA_00A120:         db $06, $02, $E8, $18, $E7, $06, $02, $08
DATA_00A128:         db $20, $E7, $06, $02, $D3, $1B, $86, $08
DATA_00A130:         db $02, $24, $38, $E3, $06, $02, $E0, $39
DATA_00A138:         db $E7, $06, $02, $1F, $F9, $E5, $06, $02

DATA_00A140:         db $08, $10, $E3, $06, $02, $00, $38, $E5
DATA_00A148:         db $06, $02, $18, $10, $E7, $06, $02, $D3
DATA_00A150:         db $21, $E3, $06, $02, $24, $3E, $E5, $06
DATA_00A158:         db $02, $1F, $FF, $E7, $06, $02

DATA_00A15E:         db $08, $10, $E5, $06, $02, $00, $38, $E7
DATA_00A166:         db $06, $02, $D2, $27, $E5, $06, $02, $25
DATA_00A16E:         db $44, $E7, $06, $02

DATA_00A172:         db $08, $10, $E7, $06, $02, $D1, $2D, $E7
DATA_00A17A:         db $06, $02

DATA_00A17C:         db $04, $04, $04, $04, $04, $04, $04, $04
DATA_00A184:         db $04, $04, $04, $04, $04, $04, $04, $03
DATA_00A18C:         db $03, $03, $02, $02, $01, $01, $01

CODE_00A193:        DA            PHX                       ;
CODE_00A194:        8A            TXA                       ;
CODE_00A195:        8D 14 30      STA $3014                 ; r10
CODE_00A198:        A9 00 00      LDA #$0000                ;
CODE_00A19B:        8D 00 30      STA $3000                 ; r0
CODE_00A19E:        A9 E9 A1      LDA #$A1E9                ;
CODE_00A1A1:        8D 1C 30      STA $301C                 ; r14
CODE_00A1A4:        A2 09         LDX #$09                  ;
CODE_00A1A6:        A9 B1 8C      LDA #$8CB1                ;
CODE_00A1A9:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_00A1AD:        FA            PLX                       ;
CODE_00A1AE:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A1B1:        BD 82 77      LDA $7782,x               ;
CODE_00A1B4:        D0 1B         BNE CODE_00A1D1           ;
CODE_00A1B6:        DE C2 73      DEC $73C2,x               ;
CODE_00A1B9:        10 03         BPL CODE_00A1BE           ;
CODE_00A1BB:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A1BE:        E2 20         SEP #$20                  ;
CODE_00A1C0:        BC C2 73      LDY $73C2,x               ;
CODE_00A1C3:        B9 D2 A1      LDA $A1D2,y               ;
CODE_00A1C6:        9D 01 70      STA $7001,x               ;
CODE_00A1C9:        B9 7C A1      LDA $A17C,y               ;
CODE_00A1CC:        9D 82 77      STA $7782,x               ;
CODE_00A1CF:        C2 20         REP #$20                  ;
CODE_00A1D1:        60            RTS                       ;

DATA_00A1D2:         db $08, $10, $18, $20, $28, $30, $40, $38
DATA_00A1DA:         db $40, $40, $40, $40, $40, $40, $40, $40
DATA_00A1E2:         db $40, $40, $40, $40, $40, $40, $40

; gsu table
DATA_00A1E9:         dw $A548, $A53E, $A52F, $A51B
DATA_00A1F1:         dw $A502, $A4E4, $A4BC, $A499
DATA_00A1F9:         dw $A471, $A449, $A421, $A3F9
DATA_00A201:         dw $A3D1, $A3A9, $A381, $A359
DATA_00A209:         dw $A331, $A309, $A2E1, $A2B9
DATA_00A211:         dw $A291, $A269, $A241, $A219

DATA_00A219:         db $02, $00, $11, $00, $00, $FC, $00, $10
DATA_00A221:         db $00, $00, $04, $FC, $01, $00, $00, $FC
DATA_00A229:         db $FC, $00, $00, $00, $FB, $00, $11, $00
DATA_00A231:         db $00, $F8, $00, $10, $00, $00, $FB, $FA
DATA_00A239:         db $01, $00, $00, $F6, $FC, $00

DATA_00A241:         db $00, $00, $06, $03, $01, $00, $00, $FC
DATA_00A249:         db $05, $10, $40, $00, $08, $F7, $10, $00
DATA_00A251:         db $00, $FC, $F7, $10, $00, $00, $FB, $00
DATA_00A259:         db $11, $40, $00, $F3, $03, $10, $40, $00
DATA_00A261:         db $FB, $F1, $01, $40, $00, $F2, $F7, $01
DATA_00A269:         db $00, $00

DATA_00A269:         db $09, $03, $10, $40, $00, $FC, $08, $00
DATA_00A271:         db $40, $00, $0B, $F5, $10, $40, $00, $FC
DATA_00A279:         db $F4, $11, $00, $00, $FB, $01, $10, $40
DATA_00A281:         db $00, $F0, $03, $10, $00, $00, $FB, $ED
DATA_00A289:         db $01, $C0, $00, $EF, $F4, $01, $80, $00

DATA_00A291:         db $0C, $04, $01, $40, $00, $FC, $08, $01
DATA_00A299:         db $40, $00, $0D, $F3, $01, $40, $00, $FC
DATA_00A2A1:         db $F3, $10, $40, $00, $FB, $02, $00, $40
DATA_00A2A9:         db $00, $ED, $04, $00, $00, $00, $FB, $EB
DATA_00A2B1:         db $00, $C0, $00, $ED, $F2, $10, $80, $00

DATA_00A2B9:         db $0D, $05, $00, $C0, $00, $FC, $0A, $01
DATA_00A2C1:         db $C0, $00, $0E, $F2, $01, $C0, $00, $FC
DATA_00A2C9:         db $F3, $00, $40, $00, $FB, $03, $01, $40
DATA_00A2D1:         db $00, $EC, $05, $01, $00, $00, $FB, $E9
DATA_00A2D9:         db $11, $80, $00, $EC, $F1, $10, $C0, $00

DATA_00A2E1:         db $0E, $06, $11, $80, $00, $FB, $0C, $00
DATA_00A2E9:         db $C0, $00, $0F, $F1, $00, $C0, $00, $FC
DATA_00A2F1:         db $F3, $00, $C0, $00, $FB, $04, $01, $C0
DATA_00A2F9:         db $00, $EB, $06, $01, $80, $00, $FB, $E8
DATA_00A301:         db $10, $80, $00, $EB, $F0, $01, $C0, $00

DATA_00A309:         db $0E, $06, $01, $80, $00, $FC, $0C, $11
DATA_00A311:         db $80, $00, $0F, $F1, $11, $80, $00, $FC
DATA_00A319:         db $F3, $11, $80, $00, $FB, $05, $00, $C0
DATA_00A321:         db $00, $EB, $06, $00, $80, $00, $FB, $E8
DATA_00A329:         db $00, $80, $00, $EB, $F0, $00, $40, $00

DATA_00A331:         db $0D, $0A, $10, $00, $00, $FD, $0F, $10
DATA_00A339:         db $80, $00, $10, $F2, $10, $80, $00, $FE
DATA_00A341:         db $F6, $00, $80, $00, $FB, $06, $11, $80
DATA_00A349:         db $00, $EB, $07, $11, $80, $00, $FC, $EB
DATA_00A351:         db $01, $00, $00, $ED, $F4, $11, $00, $00

DATA_00A359:         db $0C, $0E, $10, $40, $00, $FE, $13, $00
DATA_00A361:         db $80, $00, $11, $F6, $01, $00, $00, $FE
DATA_00A369:         db $F8, $00, $00, $00, $FD, $09, $00, $80
DATA_00A371:         db $00, $E9, $09, $00, $C0, $00, $FC, $EE
DATA_00A379:         db $10, $00, $00, $EF, $F3, $00, $00, $00

DATA_00A381:         db $0B, $0E, $00, $40, $00, $FE, $16, $01
DATA_00A389:         db $00, $00, $10, $F9, $00, $00, $00, $FC
DATA_00A391:         db $FB, $11, $00, $00, $FD, $0C, $00, $00
DATA_00A399:         db $00, $E9, $0C, $00, $40, $00, $FA, $F2
DATA_00A3A1:         db $11, $00, $00, $EE, $F3, $01, $00, $00

DATA_00A3A9:         db $0A, $0F, $01, $40, $00, $FD, $19, $10
DATA_00A3B1:         db $00, $00, $0F, $FE, $11, $00, $00, $FB
DATA_00A3B9:         db $FB, $00, $40, $00, $FB, $0F, $11, $00
DATA_00A3C1:         db $00, $EB, $10, $11, $00, $00, $FA, $F2
DATA_00A3C9:         db $10, $40, $00, $EE, $F4, $01, $00, $00

DATA_00A3D1:         db $09, $10, $01, $40, $00, $FB, $1A, $00
DATA_00A3D9:         db $40, $00, $0E, $FD, $00, $40, $00, $FA
DATA_00A3E1:         db $FC, $01, $40, $00, $F9, $10, $00, $40
DATA_00A3E9:         db $00, $EC, $11, $00, $00, $00, $F9, $F3
DATA_00A3F1:         db $00, $40, $00, $ED, $F6, $00, $00, $00

DATA_00A3F9:         db $0B, $13, $00, $40, $00, $FA, $1D, $01
DATA_00A401:         db $40, $00, $0D, $FE, $01, $40, $00, $FB
DATA_00A409:         db $FE, $01, $C0, $00, $FA, $11, $01, $40
DATA_00A411:         db $00, $ED, $11, $01, $00, $00, $F9, $F3
DATA_00A419:         db $01, $40, $00, $EB, $FC, $10, $00, $00

DATA_00A421:         db $0C, $16, $10, $40, $00, $F9, $1E, $01
DATA_00A429:         db $40, $00, $0D, $FF, $01, $40, $00, $FB
DATA_00A431:         db $00, $00, $C0, $00, $FA, $12, $01, $C0
DATA_00A439:         db $00, $ED, $13, $01, $00, $00, $F9, $F5
DATA_00A441:         db $01, $40, $00, $E9, $FE, $11, $00, $00

DATA_00A449:         db $0D, $19, $11, $00, $00, $FA, $20, $00
DATA_00A451:         db $40, $00, $0E, $02, $00, $40, $00, $FB
DATA_00A459:         db $01, $10, $C0, $00, $FA, $15, $01, $C0
DATA_00A461:         db $00, $EC, $16, $00, $00, $00, $FA, $F8
DATA_00A469:         db $00, $40, $00, $E9, $FD, $10, $40, $00

DATA_00A471:         db $0F, $1A, $10, $00, $00, $FB, $23, $10
DATA_00A479:         db $40, $00, $0E, $05, $10, $40, $00, $FC
DATA_00A481:         db $03, $10, $C0, $00, $FA, $17, $01, $40
DATA_00A489:         db $00, $EC, $19, $10, $00, $00, $FB, $FB
DATA_00A491:         db $10, $40, $00, $E9, $FD, $00, $40, $00

DATA_00A499:         db $11, $1C, $01, $00, $00, $FD, $26, $00
DATA_00A4A1:         db $00, $00, $11, $08, $01, $00, $00, $FB
DATA_00A4A9:         db $09, $00, $C0, $00, $FB, $1C, $10, $00
DATA_00A4B1:         db $00, $E9, $1C, $00, $40, $00, $E9, $00
DATA_00A4B9:         db $01, $40, $00

DATA_00A4BC:         db $10, $1B, $00, $00, $00, $FC, $25, $10
DATA_00A4C4:         db $00, $00, $10, $09, $10, $00, $00, $FC
DATA_00A4CC:         db $06, $10, $C0, $00, $FB, $1A, $10, $40
DATA_00A4D4:         db $00, $EA, $1B, $10, $40, $00, $FB, $FD
DATA_00A4DC:         db $11, $00, $00, $E9, $FE, $01, $40, $00

DATA_00A4E4:         db $12, $1D, $01, $00, $00, $FE, $28, $01
DATA_00A4EC:         db $00, $00, $11, $09, $01, $00, $00, $FB
DATA_00A4F4:         db $0B, $00, $C0, $00, $FD, $1D, $01, $00
DATA_00A4FC:         db $00, $E9, $04, $00, $40, $00

DATA_00A502:         db $11, $21, $00, $00, $00, $10, $0C, $00
DATA_00A50A:         db $00, $00, $FA, $0E, $01, $C0, $00, $FD
DATA_00A512:         db $1E, $01, $00, $00, $EA, $07, $10, $40
DATA_00A51A:         db $00

DATA_00A51B:         db $10, $0E, $10, $00, $00, $FB, $11, $01
DATA_00A523:         db $40, $00, $FC, $22, $10, $00, $00, $EA
DATA_00A52B:         db $0A, $10, $00, $00

DATA_00A52F:         db $0F, $13, $11, $00, $00, $FB, $25, $11
DATA_00A537:         db $00, $00, $EB, $0A, $00, $00, $00

DATA_00A53E:         db $FA, $26, $10, $40, $00, $EB, $0B, $01
DATA_00A546:         db $00, $00

DATA_00A548:         db $F9, $27, $01, $40, $00

DATA_00A54D:         dw $F800, $0800

CODE_00A551:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A554:        A0 00         LDY #$00                  ;
CODE_00A556:        BD 42 71      LDA $7142,x               ;
CODE_00A559:        DD 4C 7E      CMP $7E4C,x               ;
CODE_00A55C:        10 02         BPL CODE_00A560           ;
CODE_00A55E:        C8            INY                       ;
CODE_00A55F:        C8            INY                       ;
CODE_00A560:        B9 4D A5      LDA $A54D,y               ;
CODE_00A563:        9D A2 75      STA $75A2,x               ;
CODE_00A566:        60            RTS                       ;

DATA_00A567:         db $07, $07, $05, $04, $04, $04, $04, $04

CODE_00A56F:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A572:        BD 82 77      LDA $7782,x               ;
CODE_00A575:        D0 14         BNE CODE_00A58B           ;
CODE_00A577:        DE C2 73      DEC $73C2,x               ;
CODE_00A57A:        10 03         BPL CODE_00A57F           ;
CODE_00A57C:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A57F:        BC C2 73      LDY $73C2,x               ;
CODE_00A582:        B9 67 A5      LDA $A567,y               ;
CODE_00A585:        29 FF 00      AND #$00FF                ;
CODE_00A588:        9D 82 77      STA $7782,x               ;
CODE_00A58B:        60            RTS                       ;

DATA_00A58C:         db $06, $06, $06, $06, $06, $05, $05, $05
DATA_00A594:         db $05, $05, $05, $04, $04, $04

CODE_00A59A:        DA            PHX                       ;
CODE_00A59B:        8A            TXA                       ;
CODE_00A59C:        29 FF 00      AND #$00FF                ;
CODE_00A59F:        8D 14 30      STA $3014                 ;
CODE_00A5A2:        A9 00 00      LDA #$0000                ;
CODE_00A5A5:        8D 00 30      STA $3000                 ;
CODE_00A5A8:        A9 EB A5      LDA #$A5EB                ;
CODE_00A5AB:        8D 1C 30      STA $301C                 ;
CODE_00A5AE:        A2 09         LDX #$09                  ;
CODE_00A5B0:        A9 B1 8C      LDA #$8CB1                ;
CODE_00A5B3:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_00A5B7:        FA            PLX                       ;
CODE_00A5B8:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A5BB:        BD 82 77      LDA $7782,x               ;
CODE_00A5BE:        D0 1B         BNE CODE_00A5DB           ;
CODE_00A5C0:        DE C2 73      DEC $73C2,x               ;
CODE_00A5C3:        10 03         BPL CODE_00A5C8           ;
CODE_00A5C5:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A5C8:        E2 20         SEP #$20                  ;
CODE_00A5CA:        BC C2 73      LDY $73C2,x               ;
CODE_00A5CD:        B9 DC A5      LDA $A5DC,y               ;
CODE_00A5D0:        9D 01 70      STA $7001,x               ;
CODE_00A5D3:        B9 8C A5      LDA $A58C,y               ;
CODE_00A5D6:        9D 82 77      STA $7782,x               ;
CODE_00A5D9:        C2 20         REP #$20                  ;
CODE_00A5DB:        60            RTS                       ;

DATA_00A5DC:         db $08, $08, $08, $10, $18, $20, $18, $18
DATA_00A5E4:         db $18, $18, $10, $10, $10, $08, $08

DATA_00A5EB:         dw $A6A4, $A69F, $A69A, $A690
DATA_00A5F3:         dw $A681, $A66D, $A65E, $A64F
DATA_00A5FB:         dw $A640, $A631, $A627, $A61D
DATA_00A603:         dw $A613, $A60E, $A609

DATA_00A609:         db $00, $00, $E3, $06, $02

DATA_00A60E:         db $00, $01, $E3, $06, $02

DATA_00A613:         db $00, $00, $F8, $06, $00
DATA_00A618:         db $00, $03, $E3, $06, $02

DATA_00A61D:         db $00, $00, $F8, $46, $00
DATA_00A622:         db $00, $06, $E3, $06, $02

DATA_00A627:         db $00, $00, $F8, $06, $00
DATA_00A62C:         db $00, $0A, $E5, $06, $02

DATA_00A631:         db $08, $09, $F8, $06, $00
DATA_00A636:         db $00, $01, $F7, $46, $00
DATA_00A63B:         db $00, $0E, $E5, $46, $02

DATA_00A640:         db $08, $0A, $F8, $46, $00
DATA_00A645:         db $00, $03, $F7, $06, $00
DATA_00A64A:         db $00, $12, $E5, $06, $02

DATA_00A64F:         db $08, $0C, $F7, $06, $00
DATA_00A654:         db $00, $05, $F7, $46, $00
DATA_00A659:         db $00, $16, $E5, $46, $02

DATA_00A65E:         db $08, $0E, $F7, $46, $00
DATA_00A663:         db $00, $07, $F7, $06, $00
DATA_00A668:         db $00, $1A, $E7, $06, $02

DATA_00A66D:         db $00, $0B, $E1, $06, $00
DATA_00A672:         db $04, $18, $F8, $06, $00
DATA_00A677:         db $08, $10, $E1, $06, $00
DATA_00A67C:         db $00, $1E, $E7, $46, $02

DATA_00A681:         db $04, $19, $F8, $46, $00
DATA_00A686:         db $08, $12, $E1, $06, $00
DATA_00A68B:         db $00, $22, $E7, $86, $02

DATA_00A690:         db $04, $1B, $F8, $06, $00
DATA_00A695:         db $00, $26, $E7, $C6, $02

DATA_00A69A:         db $04, $1D, $59, $06, $00

DATA_00A69F:         db $04, $1F, $F7, $46, $00
DATA_00A6A4:         db $04, $21, $E1, $06, $00

$00/A6A9 20 E5 8A    JSR $8AE5  [$00:8AE5]   ;
$00/A6AC BD 82 77    LDA $7782,x[$00:7782]   ;
$00/A6AF D0 03       BNE $03    [$A6B4]      ;
$00/A6B1 4C F8 8A    JMP $8AF8  [$00:8AF8]   ;

$00/A6B4 BD 8E 7E    LDA $7E8E,x[$00:7E8E]   ;
$00/A6B7 D0 14       BNE $14    [$A6CD]      ;
$00/A6B9 E2 20       SEP #$20                ;
$00/A6BB A9 02       LDA #$02                ;
$00/A6BD 9D 8E 7E    STA $7E8E,x[$00:7E8E]   ;
$00/A6C0 DE C2 73    DEC $73C2,x[$00:73C2]   ;
$00/A6C3 10 06       BPL $06    [$A6CB]      ;
$00/A6C5 BD 4C 7E    LDA $7E4C,x[$00:7E4C]   ;
$00/A6C8 9D C2 73    STA $73C2,x[$00:73C2]   ;
$00/A6CB C2 20       REP #$20                ;
$00/A6CD 60          RTS                     ;

$00/A6CE 20 E5 8A    JSR $8AE5  [$00:8AE5]   ;
$00/A6D1 BD 20 78    LDA $7820,x[$00:7820]   ;
$00/A6D4 29 01 00    AND #$0001              ;
$00/A6D7 F0 28       BEQ $28    [$A701]      ;
$00/A6D9 BD C2 73    LDA $73C2,x[$00:73C2]   ;
$00/A6DC D0 06       BNE $06    [$A6E4]      ;
$00/A6DE A9 1C 00    LDA #$001C              ;
$00/A6E1 9D 62 6F    STA $6F62,x[$00:6F62]   ;
$00/A6E4 C9 03 00    CMP #$0003              ;
$00/A6E7 F0 03       BEQ $03    [$A6EC]      ;
$00/A6E9 FE C2 73    INC $73C2,x[$00:73C2]   ;
$00/A6EC BD E2 71    LDA $71E2,x[$00:71E2]   ;
$00/A6EF 30 10       BMI $10    [$A701]      ;
$00/A6F1 4A          LSR A                   ;
$00/A6F2 C9 20 00    CMP #$0020              ;
$00/A6F5 B0 03       BCS $03    [$A6FA]      ;
$00/A6F7 4C F8 8A    JMP $8AF8  [$00:8AF8]   ;

$00/A6FA 49 FF FF    EOR #$FFFF              ;
$00/A6FD 1A          INC A                   ;
$00/A6FE 9D E2 71    STA $71E2,x[$00:71E2]   ;
$00/A701 60          RTS                     ;


DATA_00A702:         db $0A, $09, $08, $07, $06, $05, $04, $03
DATA_00A70A:         db $02, $01, $00, $00

DATA_00A70E:         db $04, $04, $03, $03, $02, $02, $01, $01
DATA_00A716:         db $01, $01, $01, $01

DATA_00A71A:         db $01, $01, $01, $01, $01, $01, $01, $01
DATA_00A722:         db $01, $01, $FF, $01, $20, $E5, $8A, $BD
DATA_00A72A:         db $82, $77, $D0, $21, $DE, $4C, $7E, $10
DATA_00A732:         db $03

CODE_00A733:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A736:        E2 20         SEP #$20                  ;
CODE_00A738:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00A73B:        B9 02 A7      LDA $A702,y               ;
CODE_00A73E:        9D C2 73      STA $73C2,x               ;
CODE_00A741:        B9 0E A7      LDA $A70E,y               ;
CODE_00A744:        9D 82 77      STA $7782,x               ;
CODE_00A747:        B9 1A A7      LDA $A71A,y               ;
CODE_00A74A:        9D 62 74      STA $7462,x               ;
CODE_00A74D:        C2 20         REP #$20                  ;
CODE_00A74F:        60            RTS                       ;

DATA_00A750:         db $03, $03, $03, $03, $03, $03, $03, $02
DATA_00A758:         db $02

CODE_00A759:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A75C:        BD 82 77      LDA $7782,x               ;
CODE_00A75F:        D0 14         BNE CODE_00A775           ;
CODE_00A761:        DE C2 73      DEC $73C2,x               ;
CODE_00A764:        10 03         BPL CODE_00A769           ;
CODE_00A766:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A769:        BC C2 73      LDY $73C2,x               ;
CODE_00A76C:        B9 50 A7      LDA $A750,y               ;
CODE_00A76F:        29 FF 00      AND #$00FF                ;
CODE_00A772:        9D 82 77      STA $7782,x               ;
CODE_00A775:        60            RTS                       ;

CODE_00A776:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A779:        BD 82 77      LDA $7782,x               ;
CODE_00A77C:        D0 0E         BNE CODE_00A78C           ;
CODE_00A77E:        DE C2 73      DEC $73C2,x               ;
CODE_00A781:        10 03         BPL CODE_00A786           ;
CODE_00A783:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A786:        A9 03 00      LDA #$0003                ;
CODE_00A789:        9D 82 77      STA $7782,x               ;
CODE_00A78C:        60            RTS                       ;

CODE_00A78D:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A790:        BD 82 77      LDA $7782,x               ;
CODE_00A793:        D0 0E         BNE CODE_00A7A3           ;
CODE_00A795:        DE C2 73      DEC $73C2,x               ;
CODE_00A798:        10 03         BPL CODE_00A79D           ;
CODE_00A79A:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A79D:        A9 04 00      LDA #$0004                ;
CODE_00A7A0:        9D 82 77      STA $7782,x               ;
CODE_00A7A3:        60            RTS                       ;

CODE_00A7A4:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A7A7:        BD 82 77      LDA $7782,x               ;
CODE_00A7AA:        D0 24         BNE CODE_00A7D0           ;
CODE_00A7AC:        E2 20         SEP #$20                  ;
CODE_00A7AE:        A9 01         LDA #$01                  ;
CODE_00A7B0:        9D 62 74      STA $7462,x               ;
CODE_00A7B3:        C2 20         REP #$20                  ;
CODE_00A7B5:        A9 04 00      LDA #$0004                ;
CODE_00A7B8:        9D 82 77      STA $7782,x               ;
CODE_00A7BB:        DE C2 73      DEC $73C2,x               ;
CODE_00A7BE:        10 10         BPL CODE_00A7D0           ;
CODE_00A7C0:        A9 01 00      LDA #$0001                ;
CODE_00A7C3:        9D C2 73      STA $73C2,x               ;
CODE_00A7C6:        BD 42 71      LDA $7142,x               ;
CODE_00A7C9:        18            CLC                       ;
CODE_00A7CA:        69 08 00      ADC #$0008                ;
CODE_00A7CD:        9D 42 71      STA $7142,x               ;
CODE_00A7D0:        60            RTS                       ;

DATA_00A7D1:         db $03, $03, $02, $02, $02, $01, $01, $01
DATA_00A7D9:         db $02

CODE_00A7DA:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A7DD:        BD 82 77      LDA $7782,x               ;
CODE_00A7E0:        D0 14         BNE CODE_00A7F6           ;
CODE_00A7E2:        DE C2 73      DEC $73C2,x               ;
CODE_00A7E5:        10 03         BPL CODE_00A7EA           ;
CODE_00A7E7:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A7EA:        BC C2 73      LDY $73C2,x               ;
CODE_00A7ED:        B9 D1 A7      LDA $A7D1,y               ;
CODE_00A7F0:        29 FF 00      AND #$00FF                ;
CODE_00A7F3:        9D 82 77      STA $7782,x               ;
CODE_00A7F6:        60            RTS                       ;

CODE_00A7F7:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A7FA:        BD 82 77      LDA $7782,x               ;
CODE_00A7FD:        D0 0E         BNE CODE_00A80D           ;
CODE_00A7FF:        DE C2 73      DEC $73C2,x               ;
CODE_00A802:        10 03         BPL CODE_00A807           ;
CODE_00A804:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A807:        A9 02 00      LDA #$0002                ;
CODE_00A80A:        9D 82 77      STA $7782,x               ;
CODE_00A80D:        60            RTS                       ;

CODE_00A80E:        20 F2 8A      JSR CODE_008AF2           ;
CODE_00A811:        60            RTS                       ;

DATA_00A824:         db $04, $04, $04, $04, $04, $04, $02, $02
DATA_00A82C:         db $02, $02, $02, $02, $02, $02, $02, $02
DATA_00A834:         db $02

DATA_00A812:         dw $282C, $2024, $181C, $14FF
DATA_00A81A:         dw $10FF, $0CFF, $08FF, $04FF
DATA_00A822:         dw $00FF

$00/A835 BC 4C 7E    LDY $7E4C,x[$00:7E4C]   ;
$00/A838 B9 11 A8    LDA $A811,y[$00:A811]   ;
$00/A83B 30 53       BMI $53    [$A890]      ;
$00/A83D EB          XBA                     ;
$00/A83E 1D 4E 7E    ORA $7E4E,x[$00:7E4E]   ;
$00/A841 29 FF 00    AND #$00FF              ;
$00/A844 9D C2 73    STA $73C2,x[$00:73C2]   ;
$00/A847 86 00       STX $00    [$00:0000]   ;

CODE_00A849:        8A            TXA                       ;
CODE_00A84A:        29 FF 00      AND #$00FF                ;
CODE_00A84D:        8D 14 30      STA $3014                 ;
CODE_00A850:        A9 00 00      LDA #$0000                ;
CODE_00A853:        8D 00 30      STA $3000                 ;
CODE_00A856:        A9 AE A8      LDA #$A8AE                ;
CODE_00A859:        8D 1C 30      STA $301C                 ;
CODE_00A85C:        A2 09         LDX #$09                  ;
CODE_00A85E:        A9 B1 8C      LDA #$8CB1                ;
CODE_00A861:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_00A865:        A6 00         LDX $00                   ;
CODE_00A867:        A9 04 00      LDA #$0004                ;
CODE_00A86A:        8D 0E 30      STA $300E                 ;
CODE_00A86D:        BD A2 70      LDA $70A2,x               ;
CODE_00A870:        8D 02 30      STA $3002                 ;
CODE_00A873:        BD 42 71      LDA $7142,x               ;
CODE_00A876:        8D 04 30      STA $3004                 ;
CODE_00A879:        BD C2 78      LDA $78C2,x               ;
CODE_00A87C:        8D 06 30      STA $3006                 ;
CODE_00A87F:        BD 22 73      LDA $7322,x               ;
CODE_00A882:        8D 0A 30      STA $300A                 ;
CODE_00A885:        A2 09         LDX #$09                  ;
CODE_00A887:        A9 F4 F5      LDA #$F5F4                ;
CODE_00A88A:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_00A88E:        A6 00         LDX $00                   ;
CODE_00A890:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00A893:        BD 82 77      LDA $7782,x               ;
CODE_00A896:        D0 15         BNE CODE_00A8AD           ;
CODE_00A898:        DE 4C 7E      DEC $7E4C,x               ;
CODE_00A89B:        10 03         BPL CODE_00A8A0           ;
CODE_00A89D:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00A8A0:        E2 20         SEP #$20                  ;
CODE_00A8A2:        BC 4C 7E      LDY $7E4C,x               ;
CODE_00A8A5:        B9 24 A8      LDA $A824,y               ;
CODE_00A8A8:        9D 82 77      STA $7782,x               ;
CODE_00A8AB:        C2 20         REP #$20                  ;
CODE_00A8AD:        60            RTS                       ;

DATA_00A8AE:         dw $A90E, $AA12, $AB16, $AC1A
DATA_00A8B6:         dw $A922, $AA26, $AB2A, $AC2E
DATA_00A8BE:         dw $A936, $AA3A, $AB3E, $AC42
DATA_00A8C6:         dw $A94A, $AA4E, $AB52, $AC56
DATA_00A8CE:         dw $A95E, $AA62, $AB66, $AC6A
DATA_00A8D6:         dw $A972, $AA76, $AB7A, $AC7E
DATA_00A8DE:         dw $A986, $AA8A, $AB8E, $AC92
DATA_00A8E6:         dw $A99A, $AA9E, $ABA2, $ACA6
DATA_00A8EE:         dw $A9AE, $AAB2, $ABB6, $ACBA
DATA_00A8F6:         dw $A9C2, $AAC6, $ABCA, $ACCE
DATA_00A8FE:         dw $A9D6, $AADA, $ABDE, $ACE2
DATA_00A906:         dw $A9EA, $AAEE, $ABF2, $ACF6

DATA_00A90E:         db $FC, $00, $42, $C2, $02
DATA_00A913:         db $FC, $F0, $42, $42, $02
DATA_00A918:         db $EC, $00, $42, $82, $02
DATA_00A91D:         db $EC, $F0, $42, $02, $02

DATA_00A922:         db $0C, $FC, $42, $C2, $02
DATA_00A927:         db $FC, $FC, $42, $82, $02
DATA_00A92C:         db $0C, $EC, $42, $42, $02
DATA_00A931:         db $FC, $EC, $42, $02, $02

DATA_00A936:         db $14, $08, $42, $C2, $02
DATA_00A93B:         db $14, $F8, $42, $42, $02
DATA_00A940:         db $04, $08, $42, $82, $02
DATA_00A945:         db $04, $F8, $42, $02, $02

DATA_00A94A:         db $0C, $14, $42, $C2, $02
DATA_00A94F:         db $FC, $14, $42, $82, $02
DATA_00A954:         db $0C, $04, $42, $42, $02
DATA_00A959:         db $FC, $04, $42, $02, $02

DATA_00A95E:         db $FC, $10, $42, $C2, $02
DATA_00A963:         db $EC, $10, $42, $82, $02
DATA_00A968:         db $FC, $00, $42, $42, $02
DATA_00A96D:         db $EC, $00, $42, $02, $02

DATA_00A972:         db $08, $08, $42, $C2, $02
DATA_00A977:         db $F8, $08, $42, $82, $02
DATA_00A97C:         db $08, $F8, $42, $42, $02
DATA_00A981:         db $F8, $F8, $42, $02, $02

DATA_00A986:         db $08, $04, $E3, $06, $02
DATA_00A98B:         db $FC, $08, $E3, $06, $02
DATA_00A990:         db $04, $FC, $E3, $06, $02
DATA_00A995:         db $F8, $F8, $E3, $06, $02

DATA_00A99A:         db $08, $02, $E3, $06, $02
DATA_00A99F:         db $FC, $06, $E3, $06, $02
DATA_00A9A4:         db $04, $FA, $E3, $06, $02
DATA_00A9A9:         db $F8, $F6, $E5, $06, $02

DATA_00A9AE:         db $08, $00, $E5, $06, $02
DATA_00A9B3:         db $FC, $04, $E3, $06, $02
DATA_00A9B8:         db $04, $F8, $E3, $06, $02
DATA_00A9BD:         db $F8, $F4, $E7, $06, $02

DATA_00A9C2:         db $08, $EE, $E0, $02, $00
DATA_00A9C7:         db $08, $FE, $E7, $06, $02
DATA_00A9CC:         db $FC, $02, $E3, $06, $02
DATA_00A9D1:         db $04, $F6, $E5, $06, $02

DATA_00A9D6:         db $08, $EC, $E0, $02, $00
DATA_00A9DB:         db $08, $E4, $E0, $02, $00
DATA_00A9E0:         db $FC, $00, $E5, $06, $02
DATA_00A9E5:         db $04, $F4, $E7, $06, $02

DATA_00A9EA:         db $08, $F6, $E0, $02, $00
DATA_00A9EF:         db $08, $EE, $E0, $02, $00
DATA_00A9F4:         db $08, $E6, $E0, $02, $00
DATA_00A9F9:         db $FC, $FE, $E7, $06, $02
DATA_00A9FE:         db $00, $10, $E0, $02, $00
DATA_00AA03:         db $00, $08, $E0, $02, $00
DATA_00AA08:         db $00, $00, $E0, $02, $00
DATA_00AA0D:         db $00, $F8, $E0, $02, $00

DATA_00AA12:         db $FF, $02, $60, $C3, $02
DATA_00AA17:         db $FF, $F2, $60, $43, $02
DATA_00AA1C:         db $EF, $02, $60, $83, $02
DATA_00AA21:         db $EF, $F2, $60, $03, $02

DATA_00AA26:         db $0B, $FF, $60, $C3, $02
DATA_00AA2B:         db $FB, $FF, $60, $83, $02
DATA_00AA30:         db $0B, $EF, $60, $43, $02
DATA_00AA35:         db $FB, $EF, $60, $03, $02

DATA_00AA3A:         db $11, $08, $60, $C3, $02
DATA_00AA3F:         db $11, $F8, $60, $43, $02
DATA_00AA44:         db $01, $08, $60, $83, $02
DATA_00AA49:         db $01, $F8, $60, $03, $02

DATA_00AA4E:         db $0B, $11, $60, $C3, $02
DATA_00AA53:         db $FB, $11, $60, $83, $02
DATA_00AA58:         db $0B, $01, $60, $43, $02
DATA_00AA5D:         db $FB, $01, $60, $03, $02

DATA_00AA62:         db $FF, $0E, $60, $C3, $02
DATA_00AA67:         db $EF, $0E, $60, $83, $02
DATA_00AA6C:         db $FF, $FE, $60, $43, $02
DATA_00AA71:         db $EF, $FE, $60, $03, $02

DATA_00AA76:         db $08, $08, $60, $C3, $02
DATA_00AA7B:         db $F8, $08, $60, $83, $02
DATA_00AA80:         db $08, $F8, $60, $43, $02
DATA_00AA85:         db $F8, $F8, $60, $03, $02

DATA_00AA8A:         db $06, $03, $63, $07, $02
DATA_00AA8F:         db $FD, $06, $63, $07, $02
DATA_00AA94:         db $03, $FD, $63, $07, $02
DATA_00AA99:         db $FA, $FA, $63, $07, $02

DATA_00AA9E:         db $06, $01, $63, $07, $02
DATA_00AAA3:         db $FD, $04, $63, $07, $02
DATA_00AAA8:         db $03, $FB, $63, $07, $02
DATA_00AAAD:         db $FA, $F8, $65, $07, $02

DATA_00AAB2:         db $06, $00, $65, $07, $02
DATA_00AAB7:         db $FD, $03, $63, $07, $02
DATA_00AABC:         db $03, $FA, $63, $07, $02
DATA_00AAC1:         db $FA, $F7, $67, $07, $02

DATA_00AAC6:         db $08, $F0, $E0, $02, $00
DATA_00AACB:         db $06, $FE, $67, $07, $02
DATA_00AAD0:         db $FD, $01, $63, $07, $02
DATA_00AAD5:         db $03, $F8, $65, $07, $02

DATA_00AADA:         db $08, $E7, $E0, $02, $00
DATA_00AADF:         db $08, $EF, $E0, $02, $00
DATA_00AAE4:         db $FD, $00, $65, $07, $02
DATA_00AAE9:         db $03, $F7, $67, $07, $02

DATA_00AAEE:         db $08, $E5, $E0, $02, $00
DATA_00AAF3:         db $08, $ED, $E0, $02, $00
DATA_00AAF8:         db $08, $F5, $E0, $02, $00
DATA_00AAFD:         db $FD, $FD, $67, $07, $02
DATA_00AB02:         db $00, $10, $E0, $02, $00
DATA_00AB07:         db $00, $08, $E0, $02, $00
DATA_00AB0C:         db $00, $00, $E0, $02, $00
DATA_00AB11:         db $00, $F8, $E0, $02, $00

DATA_00AB16:         db $02, $04, $72, $C3, $00
DATA_00AB1B:         db $02, $FC, $72, $43, $00
DATA_00AB20:         db $FA, $04, $72, $83, $00
DATA_00AB25:         db $FA, $FC, $72, $03, $00

DATA_00AB2A:         db $0A, $02, $72, $C3, $00
DATA_00AB2F:         db $02, $02, $72, $83, $00
DATA_00AB34:         db $0A, $FA, $72, $43, $00
DATA_00AB39:         db $02, $FA, $72, $03, $00

DATA_00AB3E:         db $0E, $08, $72, $C3, $00
DATA_00AB43:         db $0E, $00, $72, $43, $00
DATA_00AB48:         db $06, $08, $72, $83, $00
DATA_00AB4D:         db $06, $00, $72, $03, $00

DATA_00AB52:         db $0A, $0E, $72, $C3, $00
DATA_00AB57:         db $02, $0E, $72, $83, $00
DATA_00AB5C:         db $0A, $06, $72, $43, $00
DATA_00AB61:         db $02, $06, $72, $03, $00

DATA_00AB66:         db $02, $0C, $72, $C3, $00
DATA_00AB6B:         db $FA, $0C, $72, $83, $00
DATA_00AB70:         db $02, $04, $72, $43, $00
DATA_00AB75:         db $FA, $04, $72, $03, $00

DATA_00AB7A:         db $08, $08, $72, $C3, $00
DATA_00AB7F:         db $00, $08, $72, $83, $00
DATA_00AB84:         db $08, $00, $72, $43, $00
DATA_00AB89:         db $00, $00, $72, $03, $00

DATA_00AB8E:         db $00, $00, $69, $07, $00
DATA_00AB93:         db $06, $02, $69, $07, $00
DATA_00AB98:         db $08, $06, $69, $07, $00
DATA_00AB9D:         db $02, $08, $69, $07, $00

DATA_00ABA2:         db $00, $FF, $6A, $07, $00
DATA_00ABA7:         db $06, $01, $69, $07, $00
DATA_00ABAC:         db $08, $05, $69, $07, $00
DATA_00ABB1:         db $02, $07, $69, $07, $00

DATA_00ABB6:         db $00, $FE, $6B, $07, $00
DATA_00ABBB:         db $06, $00, $69, $07, $00
DATA_00ABC0:         db $08, $04, $6A, $07, $00
DATA_00ABC5:         db $02, $06, $69, $07, $00

DATA_00ABCA:         db $08, $F7, $E0, $02, $00
DATA_00ABCF:         db $06, $FF, $6A, $07, $00
DATA_00ABD4:         db $08, $03, $6B, $07, $00
DATA_00ABD9:         db $02, $05, $69, $07, $00

DATA_00ABDE:         db $08, $EE, $E0, $02, $00
DATA_00ABE3:         db $08, $F6, $E0, $02, $00
DATA_00ABE8:         db $06, $FE, $6B, $07, $00
DATA_00ABED:         db $02, $04, $6A, $07, $00

DATA_00ABF2:         db $08, $E5, $E0, $02, $00
DATA_00ABF7:         db $08, $ED, $E0, $02, $00
DATA_00ABFC:         db $08, $FB, $E0, $02, $00
DATA_00AC01:         db $02, $03, $6B, $07, $00
DATA_00AC06:         db $00, $10, $E0, $02, $00
DATA_00AC0B:         db $00, $08, $E0, $02, $00
DATA_00AC10:         db $00, $00, $E0, $02, $00
DATA_00AC15:         db $00, $F8, $E0, $02, $00

DATA_00AC1A:         db $05, $06, $62, $C3, $00
DATA_00AC1F:         db $05, $FE, $62, $43, $00
DATA_00AC24:         db $FD, $06, $62, $83, $00
DATA_00AC29:         db $FD, $FE, $62, $03, $00

DATA_00AC2E:         db $0B, $FD, $62, $43, $00
DATA_00AC33:         db $0B, $05, $62, $C3, $00
DATA_00AC38:         db $03, $05, $62, $83, $00
DATA_00AC3D:         db $03, $FD, $62, $03, $00

DATA_00AC42:         db $0B, $00, $62, $43, $00
DATA_00AC47:         db $0B, $08, $62, $C3, $00
DATA_00AC4C:         db $03, $08, $62, $83, $00
DATA_00AC51:         db $03, $00, $62, $03, $00

DATA_00AC56:         db $03, $0B, $62, $83, $00
DATA_00AC5B:         db $0B, $03, $62, $43, $00
DATA_00AC60:         db $0B, $0B, $62, $C3, $00
DATA_00AC65:         db $03, $03, $62, $03, $00

DATA_00AC6A:         db $04, $0A, $62, $C3, $00
DATA_00AC6F:         db $04, $02, $62, $43, $00
DATA_00AC74:         db $FC, $0A, $62, $83, $00
DATA_00AC79:         db $FC, $02, $62, $03, $00

DATA_00AC7E:         db $08, $00, $62, $43, $00
DATA_00AC83:         db $08, $08, $62, $C3, $00
DATA_00AC88:         db $00, $08, $62, $83, $00
DATA_00AC8D:         db $00, $00, $62, $03, $00

DATA_00AC92:         db $05, $03, $79, $07, $00
DATA_00AC97:         db $06, $05, $79, $07, $00
DATA_00AC9C:         db $03, $06, $79, $07, $00
DATA_00ACA1:         db $02, $02, $79, $07, $00

DATA_00ACA6:         db $05, $02, $79, $07, $00
DATA_00ACAB:         db $06, $04, $79, $07, $00
DATA_00ACB0:         db $03, $05, $79, $07, $00
DATA_00ACB5:         db $02, $01, $7A, $07, $00

DATA_00ACBA:         db $05, $02, $79, $07, $00
DATA_00ACBF:         db $06, $04, $7A, $07, $00
DATA_00ACC4:         db $03, $05, $79, $07, $00
DATA_00ACC9:         db $02, $01, $7B, $07, $00

DATA_00ACCE:         db $08, $F9, $E0, $02, $00
DATA_00ACD3:         db $05, $01, $7A, $07, $00
DATA_00ACD8:         db $06, $03, $7B, $07, $00
DATA_00ACDD:         db $03, $04, $79, $07, $00

DATA_00ACE2:         db $08, $F1, $E0, $02, $00
DATA_00ACE7:         db $08, $F9, $E0, $02, $00
DATA_00ACEC:         db $05, $01, $7B, $07, $00
DATA_00ACF1:         db $03, $04, $7A, $07, $00

DATA_00ACF6:         db $08, $EB, $E0, $02, $00
DATA_00ACFB:         db $08, $F3, $E0, $02, $00
DATA_00AD00:         db $08, $FB, $E0, $02, $00
DATA_00AD05:         db $03, $03, $7B, $07, $00

CODE_00AD0A:        BD 22 73      LDA $7322,x               ;
CODE_00AD0D:        30 52         BMI CODE_00AD61           ;
CODE_00AD0F:        C2 10         REP #$10                  ;
CODE_00AD11:        A8            TAY                       ;
CODE_00AD12:        BD 4C 7E      LDA $7E4C,x               ;
CODE_00AD15:        85 00         STA $00                   ;
CODE_00AD17:        B9 00 60      LDA $6000,y               ;
CODE_00AD1A:        38            SEC                       ;
CODE_00AD1B:        E5 00         SBC $00                   ;
CODE_00AD1D:        99 00 60      STA $6000,y               ;
CODE_00AD20:        B9 02 60      LDA $6002,y               ;
CODE_00AD23:        38            SEC                       ;
CODE_00AD24:        E5 00         SBC $00                   ;
CODE_00AD26:        99 02 60      STA $6002,y               ;
CODE_00AD29:        B9 08 60      LDA $6008,y               ;
CODE_00AD2C:        18            CLC                       ;
CODE_00AD2D:        65 00         ADC $00                   ;
CODE_00AD2F:        99 08 60      STA $6008,y               ;
CODE_00AD32:        B9 0A 60      LDA $600A,y               ;
CODE_00AD35:        38            SEC                       ;
CODE_00AD36:        E5 00         SBC $00                   ;
CODE_00AD38:        99 0A 60      STA $600A,y               ;
CODE_00AD3B:        B9 10 60      LDA $6010,y               ;
CODE_00AD3E:        38            SEC                       ;
CODE_00AD3F:        E5 00         SBC $00                   ;
CODE_00AD41:        99 10 60      STA $6010,y               ;
CODE_00AD44:        B9 12 60      LDA $6012,y               ;
CODE_00AD47:        18            CLC                       ;
CODE_00AD48:        65 00         ADC $00                   ;
CODE_00AD4A:        99 12 60      STA $6012,y               ;
CODE_00AD4D:        B9 18 60      LDA $6018,y               ;
CODE_00AD50:        18            CLC                       ;
CODE_00AD51:        65 00         ADC $00                   ;
CODE_00AD53:        99 18 60      STA $6018,y               ;
CODE_00AD56:        B9 1A 60      LDA $601A,y               ;
CODE_00AD59:        18            CLC                       ;
CODE_00AD5A:        65 00         ADC $00                   ;
CODE_00AD5C:        99 1A 60      STA $601A,y               ;
CODE_00AD5F:        E2 10         SEP #$10                  ;
CODE_00AD61:        20 E5 8A      JSR CODE_008AE5           ;
CODE_00AD64:        BD 82 77      LDA $7782,x               ;
CODE_00AD67:        D0 03         BNE CODE_00AD6C           ;
CODE_00AD69:        4C F8 8A      JMP CODE_008AF8           ;

CODE_00AD6C:        60            RTS                       ;

; these tables contain information for
; what to copy into VRAM, where, and how big
; byte 1: index into either $06F95E or $06FC79 table
; (this will be compressed chunk of data)
; if byte 1 == $FF, end loop for copying
; if byte 1 > $F0, use (byte 1 - $F0) as index into $7E0010
; and then grab chunk index from there instead
; this is for dynamic loading such as tilesets & spritesets
; bytes 2 & 3: VRAM destination address (word addressed)
; the address being >= $8000 (sign bit on)
; indicates it's $06FC79 table, $0A8000 decompression routine
; sign bit off (< $8000) indicates $06F95E, $08A980 decompression
; IF sign bit on, read an extra word: size of data to copy in BYTES
; (since VRAM uses word addressing, divide by 2 to get VRAM size)
; when sign bit is off, $0800 is size so no extra word
; tables are separated by offsets, loops through and will
; copy ALL of these at once until $FF reached
; this is part of loading for a screen, offsets are types of screen

; $000: in level
DATA_00AD6D:         db $19
DATA_00AD6E:         dw $F800, $1000
DATA_00AD71:         db $12
DATA_00AD73:         dw $9200, $0400
DATA_00AD77:         db $76
DATA_00AD78:         dw $9500, $0600
DATA_00AD7C:         db $72
DATA_00AD7D:         dw $C000, $2000
DATA_00AD81:         db $4F
DATA_00AD82:         dw $6000
DATA_00AD84:         db $F3
DATA_00AD85:         dw $9800, $1000
DATA_00AD89:         db $F4
DATA_00AD8A:         dw $A000, $1000
DATA_00AD8E:         db $F0
DATA_00AD8F:         dw $0000
DATA_00AD91:         db $F1
DATA_00AD92:         dw $0800
DATA_00AD94:         db $F2
DATA_00AD95:         dw $7000
DATA_00AD97:         db $F7
DATA_00AD98:         dw $D000, $0400
DATA_00AD9C:         db $F8
DATA_00AD9D:         dw $D200, $0400
DATA_00ADA1:         db $F9
DATA_00ADA2:         dw $D400, $0400
DATA_00ADA6:         db $FA
DATA_00ADA7:         dw $D600, $0400
DATA_00ADAB:         db $FB
DATA_00ADAC:         dw $D800, $0400
DATA_00ADB0:         db $FC
DATA_00ADB1:         dw $DA00, $0400
DATA_00ADB5:         db $F5
DATA_00ADB6:         dw $2800
DATA_00ADB8:         db $F6
DATA_00ADB9:         dw $2C00
DATA_00ADBB:         db $FF

; $04F: Yoshi's Island (file selection screen, end world cutscenes)
DATA_00ADBC:         db $F0
DATA_00ADBD:         dw $3400
DATA_00ADBF:         db $1D
DATA_00ADC0:         dw $3800
DATA_00ADC2:         db $73
DATA_00ADC3:         dw $DC00, $0800
DATA_00ADC7:         db $73
DATA_00ADC8:         dw $FC00, $0800
DATA_00ADCC:         db $74
DATA_00ADCD:         dw $BC00, $0800
DATA_00ADD1:         db $B1
DATA_00ADD2:         dw $0000
DATA_00ADD4:         db $FF

; $068: Nintendo Presents
DATA_00ADD5:         db $72
DATA_00ADD6:         dw $C000, $2000
DATA_00ADDA:         db $FF

; $06E: toadies death cinematic
DATA_00ADDB:         db $10
DATA_00ADDC:         dw $C000, $1000
DATA_00ADE0:         db $11
DATA_00ADE1:         dw $C800, $1000
DATA_00ADE5:         db $FF

; $079: intro cinematic
DATA_00ADE6:         db $27
DATA_00ADE7:         dw $7800
DATA_00ADE9:         db $87
DATA_00ADEA:         dw $8000, $2000
DATA_00ADEE:         db $88
DATA_00ADEF:         dw $9000, $2000
DATA_00ADF3:         db $89
DATA_00ADF4:         dw $A000, $2000
DATA_00ADF8:         db $8B
DATA_00ADF9:         db $B000, $2000
DATA_00ADFD:         db $8A
DATA_00ADFE:         dw $C000, $2000
DATA_00AE02:         db $4A
DATA_00AE03:         dw $5000
DATA_00AE05:         db $73
DATA_00AE06:         dw $7400
DATA_00AE08:         db $74
DATA_00AE09:         dw $6000
DATA_00AE0B:         db $75
DATA_00AE0C:         dw $6800
DATA_00AE0E:         db $FF

; $0A2: map screen
DATA_00AE0F:         db $F0
DATA_00AE10:         dw $0000
DATA_00AE12:         db $F1
DATA_00AE13:         dw $0800
DATA_00AE15:         db $7E
DATA_00AE16:         dw $1400
DATA_00AE18:         db $F2
DATA_00AE19:         dw $B800, $0800
DATA_00AE1D:         db $F3
DATA_00AE1E:         dw $BC00, $0800
DATA_00AE22:         db $56
DATA_00AE23:         dw $1000
DATA_00AE25:         db $F4
DATA_00AE26:         dw $3000
DATA_00AE28:         db $F5
DATA_00AE29:         dw $C000, $0800
DATA_00AE2D:         db $F6
DATA_00AE2E:         dw $C400, $0800
DATA_00AE32:         db $F7
DATA_00AE33:         dw $C800, $0800
DATA_00AE37:         db $F8
DATA_00AE38:         dw $CC00, $0800
DATA_00AE3C:         db $F9
DATA_00AE3D:         dw $D000, $0800
DATA_00AE41:         db $FA
DATA_00AE42:         dw $D400, $0800
DATA_00AE46:         db $FB
DATA_00AE47:         dw $D800, $0800
DATA_00AE4B:         db $FC
DATA_00AE4C:         dw $DC00, $0800
DATA_00AE50:         db $8F
DATA_00AE51:         dw $E000, $1000
DATA_00AE55:         db $8C
DATA_00AE56:         dw $F000, $1000
DATA_00AE5A:         db $73
DATA_00AE5B:         dw $FC00, $0800
DATA_00AE5F:         db $FF

; $0F3: bonus games
DATA_00AE60:         db $21
DATA_00AE61:         dw $7000
DATA_00AE63:         db $22
DATA_00AE64:         dw $7400
DATA_00AE66:         db $14
DATA_00AE67:         dw $F800, $1000
DATA_00AE6B:         db $15
DATA_00AE6C:         dw $9000, $1000
DATA_00AE70:         db $16
DATA_00AE71:         dw $9800, $1000
DATA_00AE75:         db $1C
DATA_00AE76:         dw $2800
DATA_00AE78:         db $4E
DATA_00AE79:         dw $2C00
DATA_00AE7B:         db $72
DATA_00AE7C:         dw $C000, $2000
DATA_00AE80:         db $13
DATA_00AE81:         dw $D000, $1000
DATA_00AE85:         db $F0
DATA_00AE86:         dw $6800
DATA_00AE88:         db $F2
DATA_00AE89:         dw $3800
DATA_00AE8B:         db $F4
DATA_00AE8C:         dw $3400
DATA_00AE8E:         db $FF

; $122: minigames
DATA_00AE8F:         db $41
DATA_00AE90:         dw $7000
DATA_00AE92:         db $19
DATA_00AE93:         dw $F800, $1000
DATA_00AE97:         db $25
DATA_00AE98:         dw $0000
DATA_00AE9A:         db $26
DATA_00AE9B:         dw $0800
DATA_00AE9D:         db $F0
DATA_00AE9E:         dw $9800, $1000
DATA_00AEA2:         db $F1
DATA_00AEA3:         dw $A000, $1000
DATA_00AEA7:         db $50
DATA_00AEA8:         dw $2800
DATA_00AEAA:         db $4E
DATA_00AEAB:         db $2C00
DATA_00AEAD:         db $72
DATA_00AEAE:         dw $C000, $2000
DATA_00AEB2:         db $24
DATA_00AEB3:         dw $5000
DATA_00AEB5:         db $4E
DATA_00AEB6:         dw $D800, $0400
DATA_00AEBA:         db $F2
DATA_00AEBB:         dw $6800
DATA_00AEBD:         db $F3
DATA_00AEBE:         dw $3800
DATA_00AEC0:         db $FF

; $154: Raphael the Raven boss fight
DATA_00AEC1:         db $F0
DATA_00AEC2:         dw $0000
DATA_00AEC4:         db $F1
DATA_00AEC5:         dw $1000
DATA_00AEC7:         db $F2
DATA_00AEC8:         dw $2000
DATA_00AECA:         db $F3
DATA_00AECB:         dw $3000
DATA_00AECD:         db $F4
DATA_00AECE:         dw $0000
DATA_00AED0:         db $72
DATA_00AED1:         dw $C000, $2000
DATA_00AED5:         db $4F
DATA_00AED6:         dw $6000
DATA_00AED8:         db $F5
DATA_00AED9:         dw $D000, $0400
DATA_00AEDD:         db $F6
DATA_00AEDE:         dw $D200, $0400
DATA_00AEE2:         db $F7
DATA_00AEE3:         dw $D400, $0400
DATA_00AEE7:         db $F8
DATA_00AEE8:         dw $D600, $0400
DATA_00AEEC:         db $F9
DATA_00AEED:         dw $D800, $0400
DATA_00AEF1:         db $FA
DATA_00AEF2:         dw $DA00, $0400
DATA_00AEF6:         db $FF

; $18A: 6-8 kamek autoscroll section
DATA_00AEF7:         db $1B
DATA_00AEF8:         dw $7000
DATA_00AEFA:         db $1E
DATA_00AEFB:         dw $7400
DATA_00AEFD:         db $1E
DATA_00AEFE:         dw $7800
DATA_00AF00:         db $72
DATA_00AF01:         dw $C000, $2000
DATA_00AF05:         db $4F
DATA_00AF06:         dw $6000
DATA_00AF08:         db $AF
DATA_00AF09:         dw $2800
DATA_00AF0B:         db $AF
DATA_00AF0C:         dw $3000
DATA_00AF0E:         db $AF
DATA_00AF0F:         dw $3800
DATA_00AF11:         db $67
DATA_00AF12:         dw $D000, $0400
DATA_00AF16:         db $3C
DATA_00AF17:         dw $D200, $0400
DATA_00AF1B:         db $55
DATA_00AF1C:         dw $D400, $0400
DATA_00AF20:         db $1A
DATA_00AF21:         dw $D600, $0400
DATA_00AF25:         db $1A
DATA_00AF26:         dw $D800, $0400
DATA_00AF2A:         db $29
DATA_00AF2B:         dw $DA00, $0400
DATA_00AF2F:         db $FF

; $1C3: credits & ending cutscenes
DATA_00AF30:         db $B3
DATA_00AF31:         dw $D400, $1000
DATA_00AF35:         db $AA
DATA_00AF36:         dw $5C00
DATA_00AF38:         db $FF
; end screen:VRAM tables

; begin tileset / spriteset data
; each entry in each table represents
; a different tileset / spriteset for the layer
; these are compressed graphics file indices
; into $06FC79 / $06F95E tables

; worlds 1-5 BG1 tileset data
; byte 1 gets loaded into $7E0010, 2 -> $11, 3 -> $12
; corresponds with $F0, $F1, and $F2 in $AD6D table
; there are 16 BG1 tilesets, $00-$0F
DATA_00AF39:         db $00, $01, $40
DATA_00AF3C:         db $02, $03, $41
DATA_00AF3F:         db $08, $09, $44
DATA_00AF42:         db $0A, $0B, $45
DATA_00AF45:         db $04, $05, $42
DATA_00AF48:         db $06, $07, $43
DATA_00AF4B:         db $0C, $0D, $46
DATA_00AF4E:         db $0E, $0F, $47
DATA_00AF51:         db $30, $31, $40
DATA_00AF54:         db $32, $33, $41
DATA_00AF57:         db $38, $39, $46
DATA_00AF5A:         db $3A, $3B, $45
DATA_00AF5D:         db $34, $35, $42
DATA_00AF60:         db $36, $37, $47
DATA_00AF63:         db $3C, $3D, $46
DATA_00AF66:         db $3E, $3F, $47

; world 6: same exact layout as above table
; except just for world 6 BG1
DATA_00AF69:         db $00, $01, $40
DATA_00AF6C:         db $69, $6A, $6B
DATA_00AF6F:         db $08, $09, $44
DATA_00AF72:         db $0A, $0B, $45
DATA_00AF75:         db $04, $05, $42
DATA_00AF78:         db $06, $07, $43
DATA_00AF7B:         db $0C, $0D, $46
DATA_00AF7E:         db $0E, $0F, $47
DATA_00AF81:         db $30, $31, $40
DATA_00AF84:         db $32, $33, $41
DATA_00AF87:         db $38, $39, $46
DATA_00AF8A:         db $3A, $3B, $45
DATA_00AF8D:         db $34, $35, $42
DATA_00AF90:         db $36, $37, $47
DATA_00AF93:         db $3C, $3D, $46
DATA_00AF96:         db $3E, $3F, $47

; BG2 tileset data
; byte 1 -> $7E0013, 2 -> $14
; corresponds to $F3 and $F4 in $AD6D table
; there are 32 BG2 tilesets, $00-$1F
DATA_00AF99:         db $17, $18
DATA_00AF9B:         db $08, $A3
DATA_00AF9D:         db $02, $03
DATA_00AF9F:         db $00, $01
DATA_00AFA1:         db $00, $01
DATA_00AFA3:         db $77, $7E
DATA_00AFA5:         db $0C, $90
DATA_00AFA7:         db $0A, $0B
DATA_00AFA9:         db $06, $07
DATA_00AFAB:         db $77, $78
DATA_00AFAD:         db $79, $0E
DATA_00AFAF:         db $04, $7A
DATA_00AFB1:         db $7B, $7C
DATA_00AFB3:         db $7D, $A4
DATA_00AFB5:         db $7F, $7E
DATA_00AFB7:         db $81, $82
DATA_00AFB9:         db $77, $78
DATA_00AFBB:         db $00, $05
DATA_00AFBD:         db $00, $05
DATA_00AFBF:         db $83, $84
DATA_00AFC1:         db $80, $81
DATA_00AFC3:         db $85, $86
DATA_00AFC5:         db $A1, $A2
DATA_00AFC7:         db $08, $09
DATA_00AFC9:         db $0D, $7E
DATA_00AFCB:         db $0E, $90
DATA_00AFCD:         db $85, $86
DATA_00AFCF:         db $85, $86
DATA_00AFD1:         db $09, $09
DATA_00AFD3:         db $A5, $A6
DATA_00AFD5:         db $7A, $7B
DATA_00AFD7:         db $A7, $A8

; BG3 tileset data
; byte 1 -> $7E0015, 2 -> $16
; corresponds to $F5 and $F6 in $AD6D table
; there are 48 BG3 tilesets, $00-$2F
DATA_00AFD9:         db $4D, $4E
DATA_00AFDB:         db $14, $15
DATA_00AFDD:         db $16, $15
DATA_00AFDF:         db $18, $18
DATA_00AFE1:         db $51, $52
DATA_00AFE3:         db $16, $15
DATA_00AFE5:         db $16, $15
DATA_00AFE7:         db $16, $15
DATA_00AFE9:         db $16, $15
DATA_00AFEB:         db $13, $13
DATA_00AFED:         db $12, $4E
DATA_00AFEF:         db $16, $15
DATA_00AFF1:         db $1A, $11
DATA_00AFF3:         db $10, $11
DATA_00AFF5:         db $28, $29
DATA_00AFF7:         db $2A, $2B
DATA_00AFF9:         db $4D, $4E
DATA_00AFFB:         db $10, $63
DATA_00AFFD:         db $15, $17
DATA_00AFFF:         db $4E, $4E
DATA_00B001:         db $51, $52
DATA_00B003:         db $53, $52
DATA_00B005:         db $5B, $5C
DATA_00B007:         db $54, $54
DATA_00B009:         db $1B, $54
DATA_00B00B:         db $51, $52
DATA_00B00D:         db $51, $52
DATA_00B00F:         db $18, $17
DATA_00B011:         db $14, $14
DATA_00B013:         db $4E, $4E
DATA_00B015:         db $19, $19
DATA_00B017:         db $4D, $4E
DATA_00B019:         db $61, $18
DATA_00B01B:         db $51, $52
DATA_00B01D:         db $62, $4E
DATA_00B01F:         db $19, $63
DATA_00B021:         db $64, $4E
DATA_00B023:         db $65, $65
DATA_00B025:         db $66, $17
DATA_00B027:         db $67, $52
DATA_00B029:         db $62, $62
DATA_00B02B:         db $57, $58
DATA_00B02D:         db $19, $19
DATA_00B02F:         db $57, $58
DATA_00B031:         db $68, $62
DATA_00B033:         db $68, $62
DATA_00B035:         db $57, $58
DATA_00B037:         db $59, $58

; spriteset data
; bytes 1-6 -> $7E0017-1C
; corresponds to $F7-$FC in $AD6D table
; there are 128 spritesets, $00-$7F
DATA_00B039:         db $20, $21, $2A, $2B, $5E, $29
DATA_00B03F:         db $20, $21, $5E, $1C, $31, $29
DATA_00B045:         db $1F, $2C, $36, $40, $51, $29
DATA_00B04B:         db $2E, $5E, $37, $1A, $1A, $1F
DATA_00B051:         db $55, $5E, $5F, $1F, $1A, $29
DATA_00B057:         db $53, $40, $51, $1A, $1A, $29
DATA_00B05D:         db $36, $2A, $2B, $3C, $2D, $71
DATA_00B063:         db $4A, $36, $1C, $71, $31, $59
DATA_00B069:         db $6A, $1A, $1A, $1A, $1A, $1A
DATA_00B06F:         db $50, $71, $2F, $31, $49, $29
DATA_00B075:         db $55, $57, $5D, $71, $1C, $2F
DATA_00B07B:         db $55, $71, $3C, $57, $4A, $1C
DATA_00B081:         db $3C, $3F, $1F, $71, $1A, $1A
DATA_00B087:         db $25, $71, $1C, $1A, $1A, $1A
DATA_00B08D:         db $2E, $1A, $1A, $1A, $1A, $1F
DATA_00B093:         db $36, $57, $38, $1C, $5C, $29
DATA_00B099:         db $3A, $3B, $31, $55, $71, $29
DATA_00B09F:         db $60, $61, $1C, $22, $23, $25
DATA_00B0A5:         db $1C, $25, $42, $43, $4F, $29
DATA_00B0AB:         db $5A, $5B, $5C, $25, $6A, $29
DATA_00B0B1:         db $1F, $37, $39, $42, $43, $1A
DATA_00B0B7:         db $27, $35, $4E, $3D, $1A, $30
DATA_00B0BD:         db $4E, $1C, $51, $46, $71, $29
DATA_00B0C3:         db $22, $23, $45, $60, $1A, $30
DATA_00B0C9:         db $42, $43, $38, $39, $1C, $59
DATA_00B0CF:         db $60, $1D, $71, $4E, $1C, $30
DATA_00B0D5:         db $60, $1D, $40, $46, $4E, $30
DATA_00B0DB:         db $55, $1D, $60, $4E, $51, $1A
DATA_00B0E1:         db $36, $63, $1F, $5C, $1A, $29
DATA_00B0E7:         db $39, $1D, $35, $1B, $63, $30
DATA_00B0ED:         db $71, $1A, $51, $5F, $60, $30
DATA_00B0F3:         db $2A, $63, $1A, $1A, $1A, $1A
DATA_00B0F9:         db $27, $3E, $1A, $3D, $1A, $1A
DATA_00B0FF:         db $25, $2B, $47, $64, $36, $1F
DATA_00B105:         db $51, $61, $48, $65, $1C, $60
DATA_00B10B:         db $48, $1C, $65, $28, $60, $71
DATA_00B111:         db $1C, $45, $1F, $71, $6A, $29
DATA_00B117:         db $4D, $6A, $48, $1F, $1A, $29
DATA_00B11D:         db $28, $60, $38, $4E, $36, $51
DATA_00B123:         db $1A, $1A, $2D, $1A, $1A, $1A
DATA_00B129:         db $45, $35, $54, $64, $1F, $1C
DATA_00B12F:         db $54, $58, $35, $3D, $71, $64
DATA_00B135:         db $35, $41, $1F, $64, $5C, $1C
DATA_00B13B:         db $32, $33, $34, $41, $4C, $54
DATA_00B141:         db $64, $1E, $41, $1F, $1C, $29
DATA_00B147:         db $55, $1E, $28, $60, $71, $5C
DATA_00B14D:         db $64, $4C, $41, $40, $68, $29
DATA_00B153:         db $2F, $5C, $5D, $1C, $1A, $1A
DATA_00B159:         db $27, $65, $49, $AA, $1C, $1F
DATA_00B15F:         db $61, $48, $71, $1C, $55, $6A
DATA_00B165:         db $71, $3C, $60, $3F, $49, $AA
DATA_00B16B:         db $53, $1A, $1C, $55, $31, $59
DATA_00B171:         db $42, $43, $55, $1F, $41, $1A
DATA_00B177:         db $2A, $2B, $29, $71, $1C, $5D
DATA_00B17D:         db $55, $1F, $27, $2A, $1A, $29
DATA_00B183:         db $4F, $2B, $47, $52, $60, $51
DATA_00B189:         db $2B, $47, $38, $71, $60, $51
DATA_00B18F:         db $40, $29, $31, $4E, $1C, $59
DATA_00B195:         db $1C, $1A, $1A, $4E, $1A, $1A
DATA_00B19B:         db $2B, $47, $26, $52, $56, $29
DATA_00B1A1:         db $2B, $47, $26, $52, $31, $29
DATA_00B1A7:         db $2B, $47, $1F, $29, $31, $51
DATA_00B1AD:         db $2B, $47, $2F, $1E, $71, $29
DATA_00B1B3:         db $29, $1A, $1A, $53, $1B, $1F
DATA_00B1B9:         db $31, $40, $1F, $1A, $1A, $1A
DATA_00B1BF:         db $41, $35, $39, $71, $1F, $29
DATA_00B1C5:         db $2B, $47, $24, $49, $1A, $1F
DATA_00B1CB:         db $1F, $5C, $49, $4E, $5D, $47
DATA_00B1D1:         db $3A, $3B, $1C, $1A, $1A, $29
DATA_00B1D7:         db $1F, $1A, $38, $1A, $1A, $1A
DATA_00B1DD:         db $2B, $47, $37, $54, $71, $29
DATA_00B1E3:         db $3F, $3C, $66, $1C, $47, $60
DATA_00B1E9:         db $31, $35, $71, $54, $55, $1F
DATA_00B1EF:         db $2E, $1F, $49, $24, $5E, $29
DATA_00B1F5:         db $58, $54, $5E, $1F, $48, $29
DATA_00B1FB:         db $60, $65, $30, $71, $1A, $1A
DATA_00B201:         db $5E, $29, $71, $26, $49, $4B
DATA_00B207:         db $55, $2F, $58, $64, $2C, $59
DATA_00B20D:         db $5E, $24, $1C, $29, $49, $4B
DATA_00B213:         db $27, $25, $38, $49, $2A, $29
DATA_00B219:         db $1F, $36, $4E, $1A, $1A, $1A
DATA_00B21F:         db $4D, $1F, $55, $28, $60, $71
DATA_00B225:         db $2E, $71, $1C, $1A, $1A, $1A
DATA_00B22B:         db $35, $39, $41, $25, $64, $29
DATA_00B231:         db $64, $25, $36, $41, $1A, $29
DATA_00B237:         db $4E, $44, $1A, $3D, $48, $29
DATA_00B23D:         db $5D, $1E, $36, $3D, $25, $48
DATA_00B243:         db $42, $43, $44, $6A, $1A, $1A
DATA_00B249:         db $64, $45, $1A, $1A, $1F, $29
DATA_00B24F:         db $2A, $2B, $38, $6A, $6C, $5E
DATA_00B255:         db $55, $31, $1A, $1A, $1A, $1F
DATA_00B25B:         db $35, $3E, $1C, $3D, $2B, $47
DATA_00B261:         db $2A, $2B, $5E, $63, $1A, $1A
DATA_00B267:         db $24, $1A, $1A, $1A, $1A, $1A
DATA_00B26D:         db $1A, $36, $31, $29, $66, $59
DATA_00B273:         db $40, $3A, $3B, $37, $36, $1A
DATA_00B279:         db $2F, $70, $61, $6A, $1A, $1F
DATA_00B27F:         db $6B, $6C, $1A, $6A, $47, $1F
DATA_00B285:         db $57, $5C, $5D, $24, $1C, $29
DATA_00B28B:         db $1B, $71, $29, $1C, $1F, $5D
DATA_00B291:         db $55, $5C, $5F, $45, $71, $37
DATA_00B297:         db $6F, $6D, $6E, $29, $6A, $1A
DATA_00B29D:         db $55, $6A, $A9, $1A, $1A, $1F
DATA_00B2A3:         db $62, $3C, $4E, $53, $71, $44
DATA_00B2A9:         db $68, $6A, $1A, $1A, $1A, $1A
DATA_00B2AF:         db $1A, $1E, $52, $1F, $71, $29
DATA_00B2B5:         db $5D, $44, $4C, $56, $1A, $1A
DATA_00B2BB:         db $1C, $29, $44, $2A, $71, $4E
DATA_00B2C1:         db $45, $71, $1C, $58, $1A, $1A
DATA_00B2C7:         db $55, $25, $71, $1F, $29, $1C
DATA_00B2CD:         db $5D, $37, $71, $29, $1C, $1A
DATA_00B2D3:         db $45, $6A, $1F, $1A, $1A, $1A
DATA_00B2D9:         db $1F, $64, $41, $53, $3E, $1C
DATA_00B2DF:         db $53, $71, $5D, $1C, $1A, $1A
DATA_00B2E5:         db $36, $1C, $38, $28, $60, $29
DATA_00B2EB:         db $2B, $47, $20, $21, $1C, $71
DATA_00B2F1:         db $20, $21, $2F, $1C, $5D, $47
DATA_00B2F7:         db $27, $35, $41, $54, $64, $68
DATA_00B2FD:         db $1C, $71, $2C, $2D, $1A, $1A
DATA_00B303:         db $6A, $6C, $63, $1A, $1A, $1A
DATA_00B309:         db $22, $23, $45, $60, $1A, $30
DATA_00B30F:         db $67, $3C, $55, $1A, $1A, $29
DATA_00B315:         db $54, $71, $41, $4C, $64, $37
DATA_00B31B:         db $AD, $AE, $AF, $B0, $67, $6A
DATA_00B321:         db $55, $47, $57, $49, $1C, $29
DATA_00B327:         db $27, $2B, $47, $1C, $25, $29
DATA_00B32D:         db $27, $71, $1C, $31, $1A, $1A
DATA_00B333:         db $1C, $45, $1F, $71, $46, $29

load_level_gfx:
CODE_00B339:        8B            PHB                       ;
CODE_00B33A:        4B            PHK                       ;
CODE_00B33B:        AB            PLB                       ;
CODE_00B33C:        C2 30         REP #$30                  ;
CODE_00B33E:        AD 36 01      LDA $0136                 ; \
CODE_00B341:        0A            ASL A                     ;  | load BG1 tileset #
CODE_00B342:        6D 36 01      ADC $0136                 ;  | * 3
CODE_00B345:        A8            TAY                       ; /
CODE_00B346:        AD 18 02      LDA $0218                 ; \  test world #
CODE_00B349:        C9 0A 00      CMP #$000A                ; /  != 6
CODE_00B34C:        D0 0C         BNE CODE_00B35A           ;
CODE_00B34E:        B9 69 AF      LDA $AF69,y               ; \
CODE_00B351:        85 10         STA $10                   ;  | different
CODE_00B353:        B9 6A AF      LDA $AF6A,y               ;  | table for
CODE_00B356:        85 11         STA $11                   ;  | world 6 BG1
CODE_00B358:        80 0A         BRA CODE_00B364           ; /

;
CODE_00B35A:        B9 39 AF      LDA $AF39,y               ; \  non-world 6
CODE_00B35D:        85 10         STA $10                   ;  | BG1 VRAM files
CODE_00B35F:        B9 3A AF      LDA $AF3A,y               ;  | -> $10, $11, $12
CODE_00B362:        85 11         STA $11                   ; /
CODE_00B364:        AD 3A 01      LDA $013A                 ; \  load BG2 tileset #
CODE_00B367:        0A            ASL A                     ; /  * 2
CODE_00B368:        A8            TAY                       ;
CODE_00B369:        B9 99 AF      LDA $AF99,y               ; \  BG2 VRAM files
CODE_00B36C:        85 13         STA $13                   ; /  -> $13, $14
CODE_00B36E:        AD 3E 01      LDA $013E                 ; \  load BG3 tileset #
CODE_00B371:        0A            ASL A                     ; /  * 2
CODE_00B372:        A8            TAY                       ;
CODE_00B373:        B9 D9 AF      LDA $AFD9,y               ; \  BG3 VRAM files
CODE_00B376:        85 15         STA $15                   ; /  -> $15, $16
CODE_00B378:        AD 42 01      LDA $0142                 ; \
CODE_00B37B:        0A            ASL A                     ;  | load spriteset #
CODE_00B37C:        6D 42 01      ADC $0142                 ;  | * 6
CODE_00B37F:        0A            ASL A                     ;  |
CODE_00B380:        A8            TAY                       ; /
CODE_00B381:        B9 39 B0      LDA $B039,y               ; \
CODE_00B384:        8D B6 6E      STA $6EB6                 ;  | sprite VRAM files
CODE_00B387:        85 17         STA $17                   ;  | -> $17, $18, $19,
CODE_00B389:        B9 3B B0      LDA $B03B,y               ;  |    $1A, $1B, $1C
CODE_00B38C:        8D B8 6E      STA $6EB8                 ;  |
CODE_00B38F:        85 19         STA $19                   ;  | also store in
CODE_00B391:        B9 3D B0      LDA $B03D,y               ;  | $700EB6-EBB
CODE_00B394:        8D BA 6E      STA $6EBA                 ;  |
CODE_00B397:        85 1B         STA $1B                   ; /
CODE_00B399:        E2 20         SEP #$20                  ;
CODE_00B39B:        A0 00 00      LDY #$0000                ;

; pass in a Y for an $AD6D table offset to begin at
load_compressed_gfx_files:
CODE_00B39E:        A9 16         LDA #$16                  ; \  loop through compressed
CODE_00B3A0:        8D 2D 01      STA $012D                 ;  | chunks of VRAM data in AD6D
CODE_00B3A3:        A9 3D         LDA #$3D                  ;  | table
CODE_00B3A5:        8D 2E 01      STA $012E                 ;  | 3 or 5 byte entries
CODE_00B3A8:        B9 6D AD      LDA $AD6D,y               ;  | byte 1: chunk index
CODE_00B3AB:        C9 F0         CMP #$F0                  ;  | FF marks done with section
CODE_00B3AD:        90 11         BCC CODE_00B3C0           ;  |
CODE_00B3AF:        C9 FF         CMP #$FF                  ;  | > $F0
CODE_00B3B1:        F0 18         BEQ CODE_00B3CB           ;  | marks it
CODE_00B3B3:        38            SEC                       ;  | as an index into
CODE_00B3B4:        E9 F0         SBC #$F0                  ;  | $7E0010 table (tile/spriteset)
CODE_00B3B6:        C2 20         REP #$20                  ;  | this value in table
CODE_00B3B8:        29 FF 00      AND #$00FF                ;  | is then used as file index
CODE_00B3BB:        AA            TAX                       ;  |
CODE_00B3BC:        E2 20         SEP #$20                  ;  | bytes 2 & 3 (word):
CODE_00B3BE:        B5 10         LDA $10,x                 ;  | VRAM destination address
CODE_00B3C0:        BE 6E AD      LDX $AD6E,y               ;  | 
CODE_00B3C3:        20 07 B5      JSR CODE_00B507           ;  | decompress
CODE_00B3C6:        C8            INY                       ;  |
CODE_00B3C7:        C8            INY                       ;  | continue looping
CODE_00B3C8:        C8            INY                       ;  |
CODE_00B3C9:        80 DD         BRA CODE_00B3A8           ; /

CODE_00B3CB:        E2 10         SEP #$10                  ;
CODE_00B3CD:        AB            PLB                       ;
CODE_00B3CE:        6B            RTL                       ;

CODE_00B3CF:        8B            PHB                       ;
CODE_00B3D0:        4B            PHK                       ;
CODE_00B3D1:        AB            PLB                       ;
CODE_00B3D2:        A9 68         LDA #$68                  ;
CODE_00B3D4:        85 10         STA $10                   ;
CODE_00B3D6:        AD 1A 01      LDA $011A                 ;
CODE_00B3D9:        C9 80         CMP #$80                  ;
CODE_00B3DB:        F0 09         BEQ CODE_00B3E6           ;
CODE_00B3DD:        AD 16 02      LDA $0216                 ;
CODE_00B3E0:        D0 04         BNE CODE_00B3E6           ;
CODE_00B3E2:        A9 1F         LDA #$1F                  ;
CODE_00B3E4:        85 10         STA $10                   ;
CODE_00B3E6:        C2 10         REP #$10                  ;
CODE_00B3E8:        A0 4F 00      LDY #$004F                ;
CODE_00B3EB:        4C 9E B3      JMP CODE_00B39E           ;

CODE_00B3EE:        8B            PHB                       ;
CODE_00B3EF:        4B            PHK                       ;
CODE_00B3F0:        AB            PLB                       ;
CODE_00B3F1:        4C 9E B3      JMP CODE_00B39E           ;

; tilemaps for each world map (2 bytes per world: BG1, BG2)
DATA_00B3F4:         db $7C, $7D
DATA_00B3F6:         db $7F, $80
DATA_00B3F8:         db $81, $82
DATA_00B3FA:         db $83, $84
DATA_00B3FC:         db $85, $86
DATA_00B3FE:         db $87, $88

DATA_00B400:         db $74, $B5, $B7, $75, $B6, $B8, $4C, $6C
DATA_00B408:         db $6D

; GFX for each world map (8 bytes per world)
DATA_00B409:         dw $9A99, $9C9B, $9E9D, $A09F
DATA_00B411:         dw $9A99, $9C9B, $9E9D, $A09F
DATA_00B419:         dw $9A99, $9C9B, $9E9D, $A09F
DATA_00B421:         dw $9A99, $9C9B, $9E9D, $A09F
DATA_00B429:         dw $9A99, $9C9B, $9E9D, $A09F
DATA_00B431:         dw $9A99, $9C9B, $9695, $9897

CODE_00B439:        8B            PHB                       ;
CODE_00B43A:        4B            PHK                       ;
CODE_00B43B:        AB            PLB                       ;
CODE_00B43C:        A9 74         LDA #$74                  ;
CODE_00B43E:        85 12         STA $12                   ;
CODE_00B440:        A9 75         LDA #$75                  ;
CODE_00B442:        85 13         STA $13                   ;
CODE_00B444:        A9 4C         LDA #$4C                  ;
CODE_00B446:        85 14         STA $14                   ;
CODE_00B448:        AC 18 02      LDY $0218                 ;
CODE_00B44B:        B9 F4 B3      LDA $B3F4,y               ;
CODE_00B44E:        85 10         STA $10                   ;
CODE_00B450:        B9 F5 B3      LDA $B3F5,y               ;
CODE_00B453:        85 11         STA $11                   ;
CODE_00B455:        98            TYA                       ;
CODE_00B456:        0A            ASL A                     ;
CODE_00B457:        0A            ASL A                     ;
CODE_00B458:        A8            TAY                       ;
CODE_00B459:        A2 00         LDX #$00                  ;
CODE_00B45B:        B9 09 B4      LDA $B409,y               ;
CODE_00B45E:        95 15         STA $15,x                 ;
CODE_00B460:        C8            INY                       ;
CODE_00B461:        E8            INX                       ;
CODE_00B462:        E0 08         CPX #$08                  ;
CODE_00B464:        90 F5         BCC CODE_00B45B           ;
CODE_00B466:        C2 10         REP #$10                  ;
CODE_00B468:        A0 A2 00      LDY #$00A2                ;
CODE_00B46B:        4C 9E B3      JMP CODE_00B39E           ;

DATA_00B46E:         dw $0404, $7904, $0404, $7704
DATA_00B476:         dw $0C04, $040C

DATA_00B47A:         dw $0404, $7A04, $0404, $7804
DATA_00B482:         dw $0405, $0404

DATA_00B486:         dw $9696, $9696, $9897, $9A98
DATA_00B48E:         dw $999B, $9699

DATA_00B492:         dw $9C9C, $9F9C, $9C9C, $A09C
DATA_00B49A:         dw $9CA1, $9C9C

$00/B49E 8B          PHB
$00/B49F 4B          PHK                     ;
$00/B4A0 AB          PLB                     ;
$00/B4A1 B9 6E B4    LDA $B46E,y[$00:B46E]   ;
$00/B4A4 85 10       STA $10    [$00:0010]   ;
$00/B4A6 B9 7A B4    LDA $B47A,y[$00:B47A]   ;
$00/B4A9 85 11       STA $11    [$00:0011]   ;
$00/B4AB B9 86 B4    LDA $B486,y[$00:B486]   ;
$00/B4AE 85 12       STA $12    [$00:0012]   ;
$00/B4B0 B9 92 B4    LDA $B492,y[$00:B492]   ;
$00/B4B3 85 13       STA $13    [$00:0013]   ;
$00/B4B5 A9 4E       LDA #$4E                ;
$00/B4B7 8D BA 6E    STA $6EBA  [$00:6EBA]   ;
$00/B4BA A9 FF       LDA #$FF                ;
$00/B4BC 8D B6 6E    STA $6EB6  [$00:6EB6]   ;
$00/B4BF 8D B7 6E    STA $6EB7  [$00:6EB7]   ;
$00/B4C2 8D B8 6E    STA $6EB8  [$00:6EB8]   ;
$00/B4C5 8D B9 6E    STA $6EB9  [$00:6EB9]   ;
$00/B4C8 8D BB 6E    STA $6EBB  [$00:6EBB]   ;
$00/B4CB C2 10       REP #$10                ;
$00/B4CD A0 22 01    LDY #$0122              ;
$00/B4D0 4C 9E B3    JMP $B39E  [$00:B39E]   ;

$00/B4D3 8B          PHB                     ;
$00/B4D4 4B          PHK                     ;
$00/B4D5 AB          PLB                     ;
$00/B4D6 A2 18 22    LDX #$2218              ;
$00/B4D9 A2 BD 00    LDX #$00BD              ;
$00/B4DC A9 38       LDA #$38                ;
$00/B4DE 8D 0A 21    STA $210A  [$00:210A]   ;
$00/B4E1 A9 67       LDA #$67                ;
$00/B4E3 8D B6 6E    STA $6EB6  [$00:6EB6]   ;
$00/B4E6 A9 3C       LDA #$3C                ;
$00/B4E8 8D B7 6E    STA $6EB7  [$00:6EB7]   ;
$00/B4EB A9 55       LDA #$55                ;
$00/B4ED 8D B8 6E    STA $6EB8  [$00:6EB8]   ;
$00/B4F0 A9 1A       LDA #$1A                ;
$00/B4F2 8D B9 6E    STA $6EB9  [$00:6EB9]   ;
$00/B4F5 A9 1A       LDA #$1A                ;
$00/B4F7 8D BA 6E    STA $6EBA  [$00:6EBA]   ;
$00/B4FA A9 29       LDA #$29                ;
$00/B4FC 8D BB 6E    STA $6EBB  [$00:6EBB]   ;
$00/B4FF C2 10       REP #$10                ;
$00/B501 A0 8A 01    LDY #$018A              ;
$00/B504 4C 9E B3    JMP $B39E  [$00:B39E]   ;

; routine: decompresses LC_LZ16 (?) data file
$00/B507 86 0E       STX $0E    [$00:000E]   ; preserve VRAM dest address
$00/B509 C2 20       REP #$20                ;
$00/B50B 29 FF 00    AND #$00FF              ;
$00/B50E 85 0C       STA $0C    [$00:000C]   ;
$00/B510 0A          ASL A                   ;
$00/B511 65 0C       ADC $0C    [$00:000C]   ;
$00/B513 AA          TAX                     ;
$00/B514 A5 0E       LDA $0E    [$00:000E]   ; \
$00/B516 10 35       BPL $35    [$B54D]      ;  | VRAM destination address
$00/B518 B9 70 AD    LDA $AD70,y[$00:AD70]   ;  | being >= $8000 signifies
$00/B51B 85 0A       STA $0A    [$00:000A]   ;  | it is 0A8000 decompression instead
$00/B51D C8          INY                     ;  | we also have an extra word
$00/B51E C8          INY                     ;  | in the AD6D table, they are
$00/B51F 5A          PHY                     ; /  the size of uncompressed chunk
$00/B520 0A          ASL A                   ; \
$00/B521 0A          ASL A                   ;  | effectively >> 6
$00/B522 EB          XBA                     ; /
$00/B523 29 FF 00    AND #$00FF              ;
$00/B526 8D 06 30    STA $3006  [$00:3006]   ;
$00/B529 BF 79 FC 06 LDA $06FC79,x[$06:FC79] ; vram data address
$00/B52D 8D 02 30    STA $3002  [$00:3002]   ;
$00/B530 BF 7B FC 06 LDA $06FC7B,x[$06:FC7B] ; bank of address
$00/B534 29 FF 00    AND #$00FF              ;
$00/B537 8D 00 30    STA $3000  [$00:3000]   ;
$00/B53A E2 10       SEP #$10                ;
$00/B53C A2 0A       LDX #$0A                ;
$00/B53E A9 00 80    LDA #$8000              ;
$00/B541 22 44 DE 7E JSL $7EDE44[$7E:DE44]   ; decompress
$00/B545 C2 10       REP #$10                ;
$00/B547 A4 0A       LDY $0A    [$00:000A]   ;
$00/B549 E2 20       SEP #$20                ;
$00/B54B 80 35       BRA $35    [$B582]      ;

; decompresses LC_LZ1 data file
$00/B54D 5A          PHY                     ;
$00/B54E BF 5E F9 06 LDA $06F95E,x[$06:515E] ; \
$00/B552 8D 12 30    STA $3012  [$00:3012]   ;  |
$00/B555 BF 60 F9 06 LDA $06F960,x[$06:5160] ;  | source address of
$00/B559 29 FF 00    AND #$00FF              ;  | compressed data
$00/B55C 8D 08 30    STA $3008  [$00:3008]   ; /
$00/B55F A9 00 58    LDA #$5800              ; \  destination
$00/B562 8D 14 30    STA $3014  [$00:3014]   ; /
$00/B565 E2 10       SEP #$10                ;
$00/B567 A2 08       LDX #$08                ;
$00/B569 A9 80 A9    LDA #$A980              ;
$00/B56C 22 44 DE 7E JSL $7EDE44[$7E:DE44]   ; decompression routine
$00/B570 C2 10       REP #$10                ;
$00/B572 AD 14 30    LDA $3014  [$00:3014]   ; \
$00/B575 38          SEC                     ;  | end - start = size
$00/B576 E9 00 58    SBC #$5800              ;  | of uncompressed data
$00/B579 A8          TAY                     ; /
$00/B57A E2 20       SEP #$20                ;
$00/B57C A5 0C       LDA $0C    [$00:000C]   ;
$00/B57E C9 B1       CMP #$B1                ;
$00/B580 B0 25       BCS $25    [$B5A7]      ;
$00/B582 A9 80       LDA #$80                ; \
$00/B584 8D 15 21    STA $2115  [$00:2115]   ;  |
$00/B587 A6 0E       LDX $0E    [$00:000E]   ;  | DMA
$00/B589 8E 16 21    STX $2116  [$00:2116]   ;  | decompressed data
$00/B58C A2 01 18    LDX #$1801              ;  | to VRAM
$00/B58F 8E 00 43    STX $4300  [$00:4300]   ;  | destination passed in
$00/B592 A2 00 58    LDX #$5800              ;  | from X, ultimately 
$00/B595 8E 02 43    STX $4302  [$00:4302]   ;  | from AD6D tables
$00/B598 A9 70       LDA #$70                ;  |
$00/B59A 8D 04 43    STA $4304  [$00:4304]   ;  |
$00/B59D 8C 05 43    STY $4305  [$00:4305]   ;  |
$00/B5A0 A9 01       LDA #$01                ;  |
$00/B5A2 8D 0B 42    STA $420B  [$00:420B]   ; /
$00/B5A5 7A          PLY                     ;
$00/B5A6 60          RTS                     ;

$00/B5A7 A2 00 00    LDX #$0000              ;
$00/B5AA C9 B9       CMP #$B9                ;
$00/B5AC F0 16       BEQ $16    [$B5C4]      ;
$00/B5AE C9 BA       CMP #$BA                ;
$00/B5B0 F0 12       BEQ $12    [$B5C4]      ;
$00/B5B2 E8          INX                     ;
$00/B5B3 E8          INX                     ;
$00/B5B4 C9 BB       CMP #$BB                ;
$00/B5B6 F0 0C       BEQ $0C    [$B5C4]      ;
$00/B5B8 C9 BC       CMP #$BC                ;
$00/B5BA F0 08       BEQ $08    [$B5C4]      ;
$00/B5BC E8          INX                     ;
$00/B5BD E8          INX                     ;
$00/B5BE C9 BD       CMP #$BD                ;
$00/B5C0 F0 02       BEQ $02    [$B5C4]      ;
$00/B5C2 E8          INX                     ;
$00/B5C3 E8          INX                     ;
$00/B5C4 C2 20       REP #$20                ;
$00/B5C6 98          TYA                     ;
$00/B5C7 85 00       STA $00    [$00:0000]   ;
$00/B5C9 0A          ASL A                   ;
$00/B5CA 48          PHA                     ;
$00/B5CB E2 20       SEP #$20                ;
$00/B5CD 8B          PHB                     ;
$00/B5CE A9 7E       LDA #$7E                ;
$00/B5D0 48          PHA                     ;
$00/B5D1 AB          PLB                     ;
$00/B5D2 C2 20       REP #$20                ;
$00/B5D4 FC 01 B6    JSR ($B601,x)[$00:B609] ;

$00/B5D7 E2 20       SEP #$20                ;
$00/B5D9 AB          PLB                     ;
$00/B5DA 7A          PLY                     ;
$00/B5DB A5 00       LDA $00    [$00:0000]   ;
$00/B5DD F0 20       BEQ $20    [$B5FF]      ;
$00/B5DF 8D 15 21    STA $2115  [$00:2115]   ;
$00/B5E2 A6 0E       LDX $0E    [$00:000E]   ;
$00/B5E4 8E 16 21    STX $2116  [$00:2116]   ;
$00/B5E7 A6 02       LDX $02    [$00:0002]   ;
$00/B5E9 8E 00 43    STX $4300  [$00:4300]   ;
$00/B5EC A2 BE 7B    LDX #$7BBE              ;
$00/B5EF 8E 02 43    STX $4302  [$00:4302]   ;
$00/B5F2 A9 7E       LDA #$7E                ;
$00/B5F4 8D 04 43    STA $4304  [$00:4304]   ;
$00/B5F7 8C 05 43    STY $4305  [$00:4305]   ;
$00/B5FA A9 01       LDA #$01                ;
$00/B5FC 8D 0B 42    STA $420B  [$00:420B]   ;
$00/B5FF 7A          PLY                     ;
$00/B600 60          RTS                     ;

DATA_00B601:         dw $B609, $B6B7, $B70B, $B609

$00/B609 A2 00 00    LDX #$0000              ;
$00/B60C A0 00 00    LDY #$0000              ;
$00/B60F BF 00 58 70 LDA $705800,x[$70:5806] ;
$00/B613 48          PHA                     ;
$00/B614 29 0F 00    AND #$000F              ;
$00/B617 99 BE 7B    STA $7BBE,y[$7E:8BBE]   ;
$00/B61A C8          INY                     ;
$00/B61B 68          PLA                     ;
$00/B61C 29 F0 00    AND #$00F0              ;
$00/B61F 4A          LSR A                   ;
$00/B620 4A          LSR A                   ;
$00/B621 4A          LSR A                   ;
$00/B622 4A          LSR A                   ;
$00/B623 99 BE 7B    STA $7BBE,y[$7E:8BBE]   ;
$00/B626 E8          INX                     ;
$00/B627 C8          INY                     ;
$00/B628 C6 00       DEC $00    [$00:0000]   ;
$00/B62A D0 E3       BNE $E3    [$B60F]      ;
$00/B62C A9 80 00    LDA #$0080              ;
$00/B62F 85 00       STA $00    [$00:0000]   ;
$00/B631 A9 00 19    LDA #$1900              ;
$00/B634 85 02       STA $02    [$00:0002]   ;
$00/B636 60          RTS                     ;

DATA_00B637:         dw $0000, $0000, $0000, $0000
DATA_00B63F:         dw $0000, $1010, $1010, $1010
DATA_00B647:         dw $2010, $2020, $2020, $3020
DATA_00B64F:         dw $3030, $3030, $3030, $3030
DATA_00B657:         dw $3030, $3030, $3030, $3030
DATA_00B65F:         dw $3030, $3030, $3030, $3030
DATA_00B667:         dw $3030, $3030, $3030, $3030
DATA_00B66F:         dw $3030, $3030, $3030, $3030

DATA_00B677:         dw $3030, $3030, $4040, $4040
DATA_00B67F:         dw $4040, $4040, $4040, $4040
DATA_00B687:         dw $4040, $4040, $4040, $4040
DATA_00B68F:         dw $4040, $4040, $4040, $4040
DATA_00B697:         dw $4040, $4040, $4040, $4040
DATA_00B69F:         dw $4040, $4040, $4040, $4040
DATA_00B6A7:         dw $4040, $4040, $4040, $4040
DATA_00B6AF:         dw $4040, $4040, $4040, $4040

$00/B6B7 A9 00 00    LDA #$0000              ;
$00/B6BA 85 04       STA $04    [$00:0004]   ;
$00/B6BC A2 37 B6    LDX #$B637              ;
$00/B6BF A5 0C       LDA $0C    [$00:000C]   ;
$00/B6C1 C9 BC 00    CMP #$00BC              ;
$00/B6C4 D0 03       BNE $03    [$B6C9]      ;
$00/B6C6 A2 77 B6    LDX #$B677              ;
$00/B6C9 86 02       STX $02    [$00:0002]   ;
$00/B6CB A2 00 00    LDX #$0000              ;
$00/B6CE 9B          TXY                     ;
$00/B6CF A9 20 00    LDA #$0020              ;
$00/B6D2 85 06       STA $06    [$00:0006]   ;
$00/B6D4 BF 00 58 70 LDA $705800,x[$70:5806] ;
$00/B6D8 29 FF 00    AND #$00FF              ;
$00/B6DB 48          PHA                     ;
$00/B6DC 29 0F 00    AND #$000F              ;
$00/B6DF 07 02       ORA [$02]  [$00:0270]   ;
$00/B6E1 99 BE 7B    STA $7BBE,y[$7E:8BBE]   ;
$00/B6E4 C8          INY                     ;
$00/B6E5 68          PLA                     ;
$00/B6E6 4A          LSR A                   ;
$00/B6E7 4A          LSR A                   ;
$00/B6E8 4A          LSR A                   ;
$00/B6E9 4A          LSR A                   ;
$00/B6EA 07 02       ORA [$02]  [$00:0270]   ;
$00/B6EC 99 BE 7B    STA $7BBE,y[$7E:8BBE]   ;
$00/B6EF C8          INY                     ;
$00/B6F0 E8          INX                     ;
$00/B6F1 C6 06       DEC $06    [$00:0006]   ;
$00/B6F3 D0 07       BNE $07    [$B6FC]      ;
$00/B6F5 A9 20 00    LDA #$0020              ;
$00/B6F8 85 06       STA $06    [$00:0006]   ;
$00/B6FA E6 02       INC $02    [$00:0002]   ;
$00/B6FC C6 00       DEC $00    [$00:0000]   ;
$00/B6FE D0 D4       BNE $D4    [$B6D4]      ;
$00/B700 A9 80 00    LDA #$0080              ;
$00/B703 85 00       STA $00    [$00:0000]   ;
$00/B705 A9 00 19    LDA #$1900              ;
$00/B708 85 02       STA $02    [$00:0002]   ;
$00/B70A 60          RTS                     ;

$00/B70B 8B          PHB                     ;
$00/B70C 4B          PHK                     ;
$00/B70D AB          PLB                     ;
$00/B70E E2 10       SEP #$10                ;
$00/B710 A2 00       LDX #$00                ;
$00/B712 8E 15 21    STX $2115  [$0F:2115]   ;
$00/B715 A2 70       LDX #$70                ;
$00/B717 8E 04 43    STX $4304  [$0F:4304]   ;
$00/B71A A9 00 18    LDA #$1800              ;
$00/B71D 8D 00 43    STA $4300  [$0F:4300]   ;
$00/B720 A9 00 58    LDA #$5800              ;
$00/B723 85 00       STA $00    [$00:7960]   ;
$00/B725 A2 40       LDX #$40                ;
$00/B727 A0 01       LDY #$01                ;
$00/B729 A5 0E       LDA $0E    [$00:796E]   ;
$00/B72B 8D 16 21    STA $2116  [$0F:2116]   ;
$00/B72E A5 00       LDA $00    [$00:7960]   ;
$00/B730 8D 02 43    STA $4302  [$0F:4302]   ;
$00/B733 A9 40 00    LDA #$0040              ;
$00/B736 8D 05 43    STA $4305  [$0F:4305]   ;
$00/B739 8C 0B 42    STY $420B  [$0F:420B]   ;
$00/B73C A5 0E       LDA $0E    [$00:796E]   ;
$00/B73E 18          CLC                     ;
$00/B73F 69 80 00    ADC #$0080              ;
$00/B742 85 0E       STA $0E    [$00:796E]   ;
$00/B744 A5 00       LDA $00    [$00:7960]   ;
$00/B746 18          CLC                     ;
$00/B747 69 40 00    ADC #$0040              ;
$00/B74A 85 00       STA $00    [$00:7960]   ;
$00/B74C CA          DEX                     ;
$00/B74D D0 DA       BNE $DA    [$B729]      ;
$00/B74F C2 10       REP #$10                ;
$00/B751 AB          PLB                     ;
$00/B752 60          RTS                     ;

; decompress graphics LC_LZ1
$00/B753 A2 00 68    LDX #$6800              ;
$00/B756 8D 00 60    STA $6000  [$0F:6000]   ;
$00/B759 0A          ASL A                   ;
$00/B75A 6D 00 60    ADC $6000  [$0F:6000]   ;
$00/B75D 8E 00 60    STX $6000  [$0F:6000]   ;
$00/B760 8E 14 30    STX $3014  [$0F:3014]   ;
$00/B763 AA          TAX                     ;
$00/B764 BF 5E F9 06 LDA $06F95E,x[$06:F9B6] ;
$00/B768 8D 12 30    STA $3012  [$0F:3012]   ;
$00/B76B BF 60 F9 06 LDA $06F960,x[$06:F9B8] ;
$00/B76F 29 FF 00    AND #$00FF              ;
$00/B772 8D 08 30    STA $3008  [$0F:3008]   ;
$00/B775 E2 10       SEP #$10                ;
$00/B777 A2 08       LDX #$08                ;
$00/B779 A9 80 A9    LDA #$A980              ;
$00/B77C 22 44 DE 7E JSL $7EDE44[$7E:DE44]   ; decompression routine
$00/B780 C2 10       REP #$10                ;
$00/B782 AD 14 30    LDA $3014  [$0F:3014]   ;
$00/B785 38          SEC                     ;
$00/B786 ED 00 60    SBC $6000  [$0F:6000]   ;
$00/B789 6B          RTL                     ;

; screen palette tables begin
; split up into two-word entries, ending in $FFFF
; format of entries:
; RRRRRRRR RRRRRRRR dddddddd llllssss
; R = ROM (source) offset from $3FA000
; if negative, lop off sign bit and use as index into $7E0010 (dynamic)
; d = starting destination offset into CGRAM mirror table
; NOTE: d is a word address so * 2
; l = # of loops separated by $20 dest, source keeps counting
; s = size, # of words to copy per loop

; $00: in level
DATA_00B78A:         dw $027C, $3B11, $01C8, $5F81
DATA_00B792:         dw $8000, $1100, $8006, $1F01
DATA_00B79A:         dw $8002, $2F41, $800A, $341C
DATA_00B7A2:         dw $8004, $2F61, $8008, $2FE1
DATA_00B7AA:         dw $800C, $1FD1, $FFFF

; $26: Yoshi's Island (file selection screen, end world cutscenes) & credits?
DATA_00B7B0:         dw $2860, $4F31, $28D8, $1F21
DATA_00B7B8:         dw $2860, $4FB1, $8000, $1100
DATA_00B7C0:         dw $8002, $2F01, $8004, $1FF1
DATA_00B7C8:         dw $FFFF

; $40: Nintendo Presents
DATA_00B7CA:         dw $0130, $1100, $01C8, $1F81
DATA_00B7D2:         dw $FFFF

; $4A: toadies death cinematic
DATA_00B7D4:         dw $28F6, $2FE1, $FFFF

; $50: intro cinematic
DATA_00B7DA:         dw $2DDC, $1100, $2DDC, $2F01
DATA_00B7E2:         dw $30AC, $1F21, $328C, $1F31
DATA_00B7EA:         dw $2E18, $3F41, $346C, $1F81
DATA_00B7F2:         dw $2ECC, $7F91, $FFFF

; $6E: map screen
DATA_00B7F8:         dw $8000, $1100, $8002, $1F01
DATA_00B800:         dw $8004, $1F11, $8006, $1F21
DATA_00B808:         dw $8008, $1F71, $2860, $4F31
DATA_00B810:         dw $2860, $4F81, $3F4C, $2FC1
DATA_00B818:         dw $3DC6, $2FE1, $FFFF

; $94: bonus games
DATA_00B81E:         dw $401A, $1100, $8000, $3F01
DATA_00B826:         dw $8002, $1F71, $01C8, $6F81
DATA_00B82E:         dw $8004, $4F31, $8006, $4F91
DATA_00B836:         dw $3FFC, $1F51, $3FFC, $1FB1
DATA_00B83E:         dw $8008, $1FD1, $01C8, $2FE1
DATA_00B846:         dw $0222, $1FE1, $FFFF

; $C2: minigames
DATA_00B84E:         dw $2148, $1F01, $027C, $3B11
DATA_00B856:         dw $4354, $4F41, $01C8, $6F81
DATA_00B85E:         dw $8000, $1FD1, $FFFF

; $D8: 6-8 kamek autoscroll section
DATA_00B862:         dw $586E, $8F01, $01C8, $5F81
DATA_00B86A:         dw $8000, $1FD1, $8002, $2FE1
DATA_00B872:         dw $FFFF
; end screen palette tables

; foreground palette pointers (worlds 1-5)
DATA_00B874:         dw $067E, $06D2, $0726, $077A
DATA_00B87C:         dw $07CE, $0822, $0876, $08CA
DATA_00B884:         dw $091E, $0972, $09C6, $0A1A
DATA_00B88C:         dw $0A6E, $0AC2, $0B16, $0B6A
DATA_00B894:         dw $0BBE, $0C12, $0C66, $0CBA
DATA_00B89C:         dw $0D0E, $0D62, $0DB6, $0E0A
DATA_00B8A4:         dw $0E5E, $0EB2, $0F06, $0F5A
DATA_00B8AC:         dw $0FAE, $1002, $1056, $10AA

; foreground palette pointers (world 6)
DATA_00B8B4:         dw $067E, $0BBE, $0726, $077A
DATA_00B8BC:         dw $07CE, $0822, $0876, $08CA
DATA_00B8C4:         dw $091E, $0972, $09C6, $0A1A
DATA_00B8CC:         dw $0A6E, $0AC2, $0B16, $0B6A
DATA_00B8D4:         dw $0BBE, $0C12, $0C66, $0CBA
DATA_00B8DC:         dw $0D0E, $0D62, $0DB6, $0E0A
DATA_00B8E4:         dw $0E5E, $0EB2, $0F06, $0F5A
DATA_00B8EC:         dw $0FAE, $1002, $1056, $10AA

; layer 2 object palette pointers?
DATA_00B8F4:         dw $12A2, $11EE, $113A, $10FE
DATA_00B8FC:         dw $11B2, $1176, $1266, $122A
DATA_00B904:         dw $12DE, $1356, $1392, $13CE
DATA_00B90C:         dw $140A, $1446, $1482, $14BE
DATA_00B914:         dw $1356, $10FE, $1176, $14FA
DATA_00B91C:         dw $1536, $1572, $1662, $1662
DATA_00B924:         dw $15AE, $15EA, $1626, $16DA
DATA_00B92C:         dw $169E, $1716, $1752, $178E
DATA_00B934:         dw $187E, $18BA, $18F6, $1932
DATA_00B93C:         dw $196E, $19AA, $19E6, $1A22
DATA_00B944:         dw $1A5E, $1A9A, $1AD6, $1B12
DATA_00B94C:         dw $1B4E, $1B8A, $1BC6, $1C02
DATA_00B954:         dw $1C3E, $1C7A, $1CB6, $1CF2
DATA_00B95C:         dw $1D2E, $1D6A, $1DA6, $1DE2
DATA_00B964:         dw $1E1E, $1E5A, $1E96, $1ED2
DATA_00B96C:         dw $1F0E, $1F4A, $1F86, $1FC2

; layer 3 object palette pointers?
DATA_00B974:         dw $1FFE, $201C, $203A, $2058
DATA_00B97C:         dw $2076, $2094, $20B2, $20D0
DATA_00B984:         dw $2166, $210C, $212A, $2148
DATA_00B98C:         dw $20EE, $2184, $21A2, $21C0
DATA_00B994:         dw $21DE, $21FC, $221A, $2238
DATA_00B99C:         dw $2256, $2274, $2292, $22B0
DATA_00B9A4:         dw $22CE, $22EC, $230A, $2328
DATA_00B9AC:         dw $2346, $2364, $2382, $23A0
DATA_00B9B4:         dw $23BE, $23DC, $23FA, $2418
DATA_00B9BC:         dw $2436, $2454, $2472, $2490
DATA_00B9C4:         dw $24AE, $24CC, $24EA, $2508
DATA_00B9CC:         dw $2526, $2544, $2562, $2580
DATA_00B9D4:         dw $259E, $25BC, $25DA, $25F8
DATA_00B9DC:         dw $2616, $2634, $2652, $2670
DATA_00B9E4:         dw $268E, $26AC, $26CA, $26E8
DATA_00B9EC:         dw $2706, $2724, $2742, $2760

; sprite palette pointers?
DATA_00B9F4:         dw $02BE, $02FA, $0336, $0372
DATA_00B9FC:         dw $03AE, $03EA, $0426, $0462
DATA_00BA04:         dw $049E, $04DA, $0516, $0552
DATA_00BA0C:         dw $058E, $05CA, $0606, $0642

; relative pointers to each yoshi's palette
DATA_00BA14:         dw $0040, $005E, $007C, $009A
DATA_00BA1C:         dw $00B8, $00D6, $00F4, $0112

.load_level_palettes
$00/BA25 4B          PHK                     ;
$00/BA26 AB          PLB                     ;
$00/BA27 C2 30       REP #$30                ;
$00/BA29 AD 34 01    LDA $0134  [$00:0134]   ;
$00/BA2C 0A          ASL A                   ;
$00/BA2D 69 30 01    ADC #$0130              ;
$00/BA30 85 10       STA $10    [$00:0010]   ;
$00/BA32 AD 38 01    LDA $0138  [$00:0138]   ;
$00/BA35 0A          ASL A                   ;
$00/BA36 A8          TAY                     ;
$00/BA37 AD 18 02    LDA $0218  [$00:0218]   ;
$00/BA3A C9 0A 00    CMP #$000A              ;
$00/BA3D D0 05       BNE $05    [$BA44]      ;
$00/BA3F B9 B4 B8    LDA $B8B4,y[$00:B8B4]   ;
$00/BA42 80 03       BRA $03    [$BA47]      ;

$00/BA44 B9 74 B8    LDA $B874,y[$00:B874]   ;
$00/BA47 85 12       STA $12    [$00:0012]   ;
$00/BA49 18          CLC                     ;
$00/BA4A 69 3C 00    ADC #$003C              ;
$00/BA4D 85 1A       STA $1A    [$00:001A]   ;
$00/BA4F AD 3C 01    LDA $013C  [$00:013C]   ;
$00/BA52 0A          ASL A                   ;
$00/BA53 A8          TAY                     ;
$00/BA54 B9 F4 B8    LDA $B8F4,y[$00:B8F4]   ;
$00/BA57 85 14       STA $14    [$00:0014]   ;
$00/BA59 AD 40 01    LDA $0140  [$00:0140]   ;
$00/BA5C 0A          ASL A                   ;
$00/BA5D A8          TAY                     ;
$00/BA5E B9 74 B9    LDA $B974,y[$00:B974]   ;
$00/BA61 85 16       STA $16    [$00:0016]   ;
$00/BA63 AD 44 01    LDA $0144  [$00:0144]   ;
$00/BA66 0A          ASL A                   ;
$00/BA67 A8          TAY                     ;
$00/BA68 B9 F4 B9    LDA $B9F4,y[$00:B9F4]   ;
$00/BA6B 85 18       STA $18    [$00:0018]   ;
$00/BA6D AD 83 03    LDA $0383  [$00:0383]   ;
$00/BA70 0A          ASL A                   ;
$00/BA71 A8          TAY                     ;
$00/BA72 B9 14 BA    LDA $BA14,y[$00:BA14]   ;
$00/BA75 85 1C       STA $1C    [$00:001C]   ;
$00/BA77 A2 00 00    LDX #$0000              ;

; loads a set of palettes from ROM into CGRAM
.load_palettes
CODE_00BA7A:        A9 00 A0      LDA #$A000                ;
CODE_00BA7D:        85 00         STA $00                   ;
CODE_00BA7F:        A9 A0 5F      LDA #$5FA0                ;
CODE_00BA82:        85 01         STA $01                   ;
CODE_00BA84:        BD 8A B7      LDA $B78A,x               ;
CODE_00BA87:        10 0C         BPL CODE_00BA95           ;
CODE_00BA89:        C9 FF FF      CMP #$FFFF                ;
CODE_00BA8C:        F0 50         BEQ CODE_00BADE           ;
CODE_00BA8E:        29 FF 7F      AND #$7FFF                ;
CODE_00BA91:        A8            TAY                       ;
CODE_00BA92:        B9 10 00      LDA $0010,y               ;
CODE_00BA95:        A8            TAY                       ;
CODE_00BA96:        BD 8D B7      LDA $B78D,x               ;
CODE_00BA99:        29 0F 00      AND #$000F                ;
CODE_00BA9C:        85 03         STA $03                   ;
CODE_00BA9E:        BD 8D B7      LDA $B78D,x               ;
CODE_00BAA1:        29 F0 00      AND #$00F0                ;
CODE_00BAA4:        4A            LSR A                     ;
CODE_00BAA5:        4A            LSR A                     ;
CODE_00BAA6:        4A            LSR A                     ;
CODE_00BAA7:        4A            LSR A                     ;
CODE_00BAA8:        85 05         STA $05                   ;
CODE_00BAAA:        BD 8C B7      LDA $B78C,x               ;
CODE_00BAAD:        29 FF 00      AND #$00FF                ;
CODE_00BAB0:        0A            ASL A                     ;
CODE_00BAB1:        85 07         STA $07                   ;
CODE_00BAB3:        DA            PHX                       ;
CODE_00BAB4:        AA            TAX                       ;
CODE_00BAB5:        A5 03         LDA $03                   ;
CODE_00BAB7:        85 09         STA $09                   ;
CODE_00BAB9:        B7 00         LDA [$00],y               ;
CODE_00BABB:        9F 00 20 70   STA $702000,x             ;
CODE_00BABF:        9F 6C 2D 70   STA $702D6C,x             ;
CODE_00BAC3:        C8            INY                       ;
CODE_00BAC4:        C8            INY                       ;
CODE_00BAC5:        E8            INX                       ;
CODE_00BAC6:        E8            INX                       ;
CODE_00BAC7:        C6 09         DEC $09                   ;
CODE_00BAC9:        D0 EE         BNE CODE_00BAB9           ;
CODE_00BACB:        A5 07         LDA $07                   ;
CODE_00BACD:        18            CLC                       ;
CODE_00BACE:        69 20 00      ADC #$0020                ;
CODE_00BAD1:        85 07         STA $07                   ;
CODE_00BAD3:        C6 05         DEC $05                   ;
CODE_00BAD5:        D0 DD         BNE CODE_00BAB4           ;
CODE_00BAD7:        FA            PLX                       ;
CODE_00BAD8:        E8            INX                       ;
CODE_00BAD9:        E8            INX                       ;
CODE_00BADA:        E8            INX                       ;
CODE_00BADB:        E8            INX                       ;
CODE_00BADC:        80 A6         BRA CODE_00BA84           ;

CODE_00BADE:        E2 30         SEP #$30                  ;
CODE_00BAE0:        AB            PLB                       ;
CODE_00BAE1:        6B            RTL                       ;

DATA_00BAE2:	     db $3C,$29,$7A,$29,$AE,$2C,$CC,$2C

CODE_00BAEA:        8B            PHB                       ;
CODE_00BAEB:        4B            PHK                       ;
CODE_00BAEC:        AB            PLB                       ;
CODE_00BAED:        C2 20         REP #$20                  ;
CODE_00BAEF:        BD E2 BA      LDA $BAE2,x               ;
CODE_00BAF2:        85 10         STA $10                   ;
CODE_00BAF4:        1A            INC A                     ;
CODE_00BAF5:        1A            INC A                     ;
CODE_00BAF6:        85 12         STA $12                   ;
CODE_00BAF8:        BD E6 BA      LDA $BAE6,x               ;
CODE_00BAFB:        85 14         STA $14                   ;
CODE_00BAFD:        C2 10         REP #$10                  ;
CODE_00BAFF:        A2 26 00      LDX #$0026                ;
CODE_00BB02:        4C 7A BA      JMP CODE_00BA7A           ;

CODE_00BB05:        8B            PHB                       ;
CODE_00BB06:        4B            PHK                       ;
CODE_00BB07:        AB            PLB                       ;
CODE_00BB08:        4C 7A BA      JMP CODE_00BA7A           ;

DATA_00BB0B:         dw $3ADE, $3B5A, $3BD6
DATA_00BB11:         dw $3C52, $3CCE, $3D4A

; palette pointer for each world map (4 pointers per world)
DATA_00BB17:         dw $3AE2, $3B00, $3B1E, $3B3C
DATA_00BB1F:         dw $3B5E, $3B7C, $3B9A, $3BB8
DATA_00BB27:         dw $3BDA, $3BF8, $3C16, $3C34
DATA_00BB2F:         dw $3C56, $3C74, $3C92, $3CB0
DATA_00BB37:         dw $3CD2, $3CF0, $3D0E, $3D2C
DATA_00BB3F:         dw $3D4E, $3D6C, $3D8A, $3DA8

$00/BB47 8B          PHB                     ;
$00/BB48 4B          PHK                     ;
$00/BB49 AB          PLB                     ;
$00/BB4A AE 18 02    LDX $0218  [$00:0218]   ;
$00/BB4D BD 0B BB    LDA $BB0B,x[$00:BB0B]   ;
$00/BB50 85 10       STA $10    [$00:0010]   ;
$00/BB52 8A          TXA                     ;
$00/BB53 0A          ASL A                   ;
$00/BB54 0A          ASL A                   ;
$00/BB55 AA          TAX                     ;
$00/BB56 BD 17 BB    LDA $BB17,x[$00:BB17]   ;
$00/BB59 85 12       STA $12    [$00:0012]   ;
$00/BB5B BD 19 BB    LDA $BB19,x[$00:BB19]   ;
$00/BB5E 85 14       STA $14    [$00:0014]   ;
$00/BB60 BD 1B BB    LDA $BB1B,x[$00:BB1B]   ;
$00/BB63 85 16       STA $16    [$00:0016]   ;
$00/BB65 BD 1D BB    LDA $BB1D,x[$00:BB1D]   ;
$00/BB68 85 18       STA $18    [$00:0018]   ;
$00/BB6A A2 6E 00    LDX #$006E              ;
$00/BB6D 4C 7A BA    JMP $BA7A  [$00:BA7A]   ;

$00/BB70 8B          PHB                     ;
$00/BB71 4B          PHK                     ;
$00/BB72 AB          PLB                     ;
$00/BB73 A9 94 7F    LDA #$7F94              ;
$00/BB76 8D 48 09    STA $0948  [$00:0948]   ;
$00/BB79 A9 00 00    LDA #$0000              ;
$00/BB7C 8F 00 20 70 STA $702000[$70:2000]   ;
$00/BB80 AD 83 03    LDA $0383  [$00:0383]   ;
$00/BB83 0A          ASL A                   ;
$00/BB84 AA          TAX                     ;
$00/BB85 BD 14 BA    LDA $BA14,x[$00:BA14]   ;
$00/BB88 85 10       STA $10    [$00:0010]   ;
$00/BB8A A2 C2 00    LDX #$00C2              ;
$00/BB8D 4C 7A BA    JMP $BA7A  [$00:BA7A]   ;

$00/BB90 8B          PHB                     ;
$00/BB91 4B          PHK                     ;
$00/BB92 AB          PLB                     ;
$00/BB93 C2 30       REP #$30                ;
$00/BB95 AD 83 03    LDA $0383  [$00:0383]   ;
$00/BB98 0A          ASL A                   ;
$00/BB99 A8          TAY                     ;
$00/BB9A B9 14 BA    LDA $BA14,y[$00:BA14]   ;
$00/BB9D 85 10       STA $10    [$00:0010]   ;
$00/BB9F AD 44 01    LDA $0144  [$00:0144]   ;
$00/BBA2 0A          ASL A                   ;
$00/BBA3 A8          TAY                     ;
$00/BBA4 B9 F4 B9    LDA $B9F4,y[$00:B9F4]   ;
$00/BBA7 85 12       STA $12    [$00:0012]   ;
$00/BBA9 A2 D8 00    LDX #$00D8              ;
$00/BBAC 4C 7A BA    JMP $BA7A  [$00:BA7A]   ;

DATA_00BBAF:         dw $0000, $0014, $0028, $003C
DATA_00BBB7:         dw $0050, $0064, $0078, $008C
DATA_00BBBF:         dw $00A0, $00B4, $00C8, $00DC
DATA_00BBC7:         dw $00F0, $0104, $0118, $012C
DATA_00BBCF:         dw $0140, $0154, $0168, $01A4
DATA_00BBD7:         dw $017C, $0190

DATA_00BBDB:         db $05, $07, $08, $09, $0B, $0C, $23, $24
DATA_00BBE3:         db $25, $2C, $2D, $2E, $2F, $30, $31

; 20-byte chunks of data
DATA_00BBEA:         db $06, $00, $0A, $1D, $00, $10, $3C, $3C, $3C, $22
DATA_00BBF4:         db $22, $32, $00, $00, $13, $00, $00, $00, $00, $3F

DATA_00BBFE:         db $00, $00, $16, $3D, $00, $01, $70, $74, $78, $00
DATA_00BC08:         db $06, $00, $00, $00, $13, $00, $00, $00, $00, $00

DATA_00BC12:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC1C:         db $02, $00, $00, $00, $17, $00, $00, $00, $22, $20

DATA_00BC26:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC30:         db $02, $00, $00, $00, $14, $03, $00, $00, $22, $20

DATA_00BC3A:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC44:         db $02, $00, $00, $00, $13, $04, $00, $00, $22, $B3

DATA_00BC4E:         db $04, $00, $16, $3D, $01, $22, $69, $3A, $34, $77
DATA_00BC58:         db $02, $00, $00, $00, $11, $02, $00, $00, $22, $20

DATA_00BC62:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC6C:         db $02, $00, $00, $00, $13, $14, $00, $00, $22, $72

DATA_00BC76:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC80:         db $02, $00, $00, $00, $15, $02, $00, $00, $22, $20

DATA_00BC8A:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BC94:         db $02, $00, $00, $00, $15, $02, $00, $00, $22, $24

DATA_00BC9E:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BCA8:         db $02, $00, $00, $00, $11, $06, $00, $00, $22, $20

DATA_00BCB2:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BCBC:         db $02, $00, $00, $00, $13, $00, $00, $00, $22, $20

DATA_00BCC6:         db $0A, $00, $16, $3D, $01, $07, $00, $00, $00, $00
DATA_00BCD0:         db $00, $00, $00, $00, $11, $04, $00, $00, $22, $20

DATA_00BCDA:         db $02, $00, $16, $3D, $01, $00, $69, $28, $30, $77
DATA_00BCE4:         db $77, $00, $00, $00, $1F, $00, $00, $00, $02, $20

DATA_00BCEE:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BCF8:         db $02, $00, $00, $00, $11, $06, $00, $00, $22, $20

DATA_00BD02:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BD0C:         db $02, $00, $00, $00, $15, $00, $00, $00, $22, $20

DATA_00BD16:         db $02, $00, $16, $3D, $01, $59, $3A, $69, $34, $77
DATA_00BD20:         db $02, $00, $00, $00, $05, $12, $00, $00, $22, $45

DATA_00BD2A:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BD34:         db $02, $00, $00, $00, $13, $04, $00, $00, $22, $B3

DATA_00BD3E:         db $02, $00, $16, $3D, $01, $69, $69, $3A, $34, $77
DATA_00BD48:         db $02, $00, $00, $00, $04, $13, $00, $00, $22, $24

DATA_00BD52:         db $08, $02, $16, $3D, $01, $09, $61, $69, $74, $00
DATA_00BD5C:         db $77, $00, $30, $00, $15, $02, $0A, $02, $02, $20

DATA_00BD66:         db $0C, $00, $16, $1D, $00, $01, $1C, $1C, $15, $22
DATA_00BD70:         db $01, $32, $00, $80, $17, $00, $00, $00, $10, $00

DATA_00BD7A:         db $0E, $06, $16, $3D, $01, $41, $6A, $3A, $34, $77
DATA_00BD84:         db $02, $00, $00, $A0, $17, $00, $10, $00, $20, $94

DATA_00BD8E:         db $08, $04, $07, $1B, $00, $03, $50, $5C, $00, $50
DATA_00BD98:         db $00, $00, $00, $00, $13, $00, $00, $00, $00, $00

; subroutine of sorts probably
CODE_00BDA2:        8B            PHB                       ;
CODE_00BDA3:        4B            PHK                       ;
CODE_00BDA4:        AB            PLB                       ;
CODE_00BDA5:        C2 10         REP #$10                  ;
CODE_00BDA7:        BC AF BB      LDY $BBAF,x               ;
CODE_00BDAA:        B9 EA BB      LDA $BBEA,y               ;
CODE_00BDAD:        8D 1C 01      STA $011C                 ;
CODE_00BDB0:        B9 EB BB      LDA $BBEB,y               ;
CODE_00BDB3:        8D 26 01      STA $0126                 ;
CODE_00BDB6:        B9 EC BB      LDA $BBEC,y               ;
CODE_00BDB9:        8D 2D 01      STA $012D                 ;
CODE_00BDBC:        B9 ED BB      LDA $BBED,y               ;
CODE_00BDBF:        8D 2E 01      STA $012E                 ;
CODE_00BDC2:        B9 EE BB      LDA $BBEE,y               ;
CODE_00BDC5:        F0 1E         BEQ CODE_00BDE5           ;
CODE_00BDC7:        C2 20         REP #$20                  ;
CODE_00BDC9:        AF 00 20 70   LDA $702000               ;
CODE_00BDCD:        8D 48 09      STA $0948                 ;
CODE_00BDD0:        8F 20 20 70   STA $702020               ;
CODE_00BDD4:        8F 8C 2D 70   STA $702D8C               ;
CODE_00BDD8:        A9 00 00      LDA #$0000                ;
CODE_00BDDB:        8F 00 20 70   STA $702000               ;
CODE_00BDDF:        8F 6C 2D 70   STA $702D6C               ;
CODE_00BDE3:        E2 20         SEP #$20                  ;
CODE_00BDE5:        A2 00 00      LDX #$0000                ;
CODE_00BDE8:        B9 EF BB      LDA $BBEF,y               ;
CODE_00BDEB:        9D 5E 09      STA $095E,x               ;
CODE_00BDEE:        C8            INY                       ;
CODE_00BDEF:        E8            INX                       ;
CODE_00BDF0:        E0 0F 00      CPX #$000F                ;
CODE_00BDF3:        90 F3         BCC CODE_00BDE8           ;
CODE_00BDF5:        9C 4A 09      STZ $094A                 ;
CODE_00BDF8:        9C 0A 21      STZ $210A                 ;
CODE_00BDFB:        A0 00 21      LDY #$2100                ;
CODE_00BDFE:        84 00         STY $00                   ;
CODE_00BE00:        E2 10         SEP #$10                  ;
CODE_00BE02:        A2 0E         LDX #$0E                  ;
CODE_00BE04:        BC DB BB      LDY $BBDB,x               ;
CODE_00BE07:        BD 5E 09      LDA $095E,x               ;
CODE_00BE0A:        91 00         STA ($00),y               ;
CODE_00BE0C:        CA            DEX                       ;
CODE_00BE0D:        10 F5         BPL CODE_00BE04           ;
CODE_00BE0F:        C2 20         REP #$20                  ;
CODE_00BE11:        9C 4C 09      STZ $094C                 ;
CODE_00BE14:        9C 2A 21      STZ $212A                 ;
CODE_00BE17:        E2 20         SEP #$20                  ;
CODE_00BE19:        A9 02         LDA #$02                  ;
CODE_00BE1B:        8D 4B 09      STA $094B                 ;
CODE_00BE1E:        8D 01 21      STA $2101                 ;
CODE_00BE21:        9C 33 21      STZ $2133                 ;
CODE_00BE24:        AB            PLB                       ;
CODE_00BE25:        6B            RTL                       ;

CODE_00BE26:        C2 30         REP #$30                  ;
CODE_00BE28:        8B            PHB                       ;\
CODE_00BE29:        A0 00 22      LDY #$2200                ; |
CODE_00BE2C:        A2 52 E5      LDX #$E552                ; | move $00E552~$00E952 to $702200~$7025FF
CODE_00BE2F:        A9 FF 03      LDA #$03FF                ; |
CODE_00BE32:        54 70 00      MVN 00 70                 ; |
CODE_00BE35:        AB            PLB                       ;/
CODE_00BE36:        E2 30         SEP #$30                  ;
CODE_00BE38:        6B            RTL                       ;

; subroutine
; the four words following a call to this routine are passed-in arguments
; after storing the arguments, the sub adds 8 to the return address and jumps back
; arguments are stored, indexed by $096D, as follows:
; fourth word -> $096F,x
; first word -> $0971,x
; second word -> $0973,x
; third word -> $0975,x
; #$0000 -> $0977,x
; this is a way of setting up a DMA used by $00DE0C, the format of the arguments is actually:
; DDDDDD SSSSSS ssss
; D = long destination address
; S = long source address
; s = size
CODE_00BE39:        08            PHP                       ;
CODE_00BE3A:        C2 30         REP #$30                  ;
CODE_00BE3C:        AE 6D 09      LDX $096D                 ; argument store index
CODE_00BE3F:        A3 02         LDA $02,s                 ;\ return address as index
CODE_00BE41:        A8            TAY                       ;/
CODE_00BE42:        B9 07 00      LDA $0007,y               ;\
CODE_00BE45:        9D 6F 09      STA $096F,x               ;/ last word passed in
CODE_00BE48:        B9 01 00      LDA $0001,y               ;\
CODE_00BE4B:        9D 71 09      STA $0971,x               ;/ first word passed in
CODE_00BE4E:        B9 03 00      LDA $0003,y               ;\
CODE_00BE51:        9D 73 09      STA $0973,x               ;/ second word passed in
CODE_00BE54:        B9 05 00      LDA $0005,y               ;\
CODE_00BE57:        9D 75 09      STA $0975,x               ;/ third word passed in
CODE_00BE5A:        A9 00 00      LDA #$0000                ;
CODE_00BE5D:        9D 77 09      STA $0977,x               ;
CODE_00BE60:        8A            TXA                       ;
CODE_00BE61:        18            CLC                       ;
CODE_00BE62:        69 08 00      ADC #$0008                ;\ offset argument store index
CODE_00BE65:        8D 6D 09      STA $096D                 ;/
CODE_00BE68:        98            TYA                       ;
CODE_00BE69:        18            CLC                       ;
CODE_00BE6A:        69 08 00      ADC #$0008                ;
CODE_00BE6D:        83 02         STA $02,s                 ; adds 8 to return address
CODE_00BE6F:        28            PLP                       ;
CODE_00BE70:        6B            RTL                       ;

; subroutine
; the three words following a call to this sub are passed-in arguments
; the accumulator is also passed in
; after storing the arguments, the sub adds 6 to the return address and jumps back
; arguments are stored, indexed by $096D, as follows:
; accumulator -> $096F,x
; first word -> $0971,x
; second word -> $0973,x
; third word -> $0975,x
; #$0000 -> $0977,x
$00/BE71 08          PHP                     ;
$00/BE72 C2 10       REP #$10                ;
$00/BE74 AE 6D 09    LDX $096D  [$00:096D]   ;\ store accumulator argument
$00/BE77 9D 6F 09    STA $096F,x[$00:096F]   ;/
$00/BE7A A3 02       LDA $02,s  [$00:0201]   ;\ return address as index
$00/BE7C A8          TAY                     ;/
$00/BE7D B9 01 00    LDA $0001,y[$00:0001]   ;\ first word passed in
$00/BE80 9D 71 09    STA $0971,x[$00:0971]   ;/
$00/BE83 B9 03 00    LDA $0003,y[$00:0003]   ;\ second word passed in
$00/BE86 9D 73 09    STA $0973,x[$00:0973]   ;/
$00/BE89 B9 05 00    LDA $0005,y[$00:0005]   ;\ last word passed in
$00/BE8C 9D 75 09    STA $0975,x[$00:0975]   ;/
$00/BE8F A9 00 00    LDA #$0000              ;
$00/BE92 9D 77 09    STA $0977,x[$00:0977]   ;
$00/BE95 8A          TXA                     ;
$00/BE96 18          CLC                     ;
$00/BE97 69 08 00    ADC #$0008              ;\ offset argument store index
$00/BE9A 8D 6D 09    STA $096D  [$00:096D]   ;/
$00/BE9D 98          TYA                     ;
$00/BE9E 18          CLC                     ;
$00/BE9F 69 06 00    ADC #$0006              ;\ adds 6 to return address
$00/BEA2 83 02       STA $02,s  [$00:0201]   ;/
$00/BEA4 28          PLP                     ;
$00/BEA5 6B          RTL                     ;

$00/BEA6 8B          PHB                     ;
$00/BEA7 F4 48 7E    PEA $7E48               ;\
$00/BEAA AB          PLB                     ; | data bank $7E
$00/BEAB AB          PLB                     ;/
$00/BEAC DA          PHX                     ;
$00/BEAD AE 00 48    LDX $4800  [$00:4800]   ;
$00/BEB0 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BEB3 98          TYA                     ;
$00/BEB4 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BEB7 A9 80 01    LDA #$0180              ;
$00/BEBA 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BEBD A9 18 00    LDA #$0018              ;
$00/BEC0 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BEC3 AD 00 00    LDA $0000  [$00:0000]   ;
$00/BEC6 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BEC9 68          PLA                     ;
$00/BECA 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BECD 8A          TXA                     ;
$00/BECE 18          CLC                     ;
$00/BECF 69 0C 00    ADC #$000C              ;
$00/BED2 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BED5 8D 00 48    STA $4800  [$00:4800]   ;
$00/BED8 AB          PLB                     ;
$00/BED9 6B          RTL                     ;

$00/BEDA 8B          PHB                     ;
$00/BEDB F4 48 7E    PEA $7E48               ;\
$00/BEDE AB          PLB                     ; | data bank $7E
$00/BEDF AB          PLB                     ;/
$00/BEE0 DA          PHX                     ;
$00/BEE1 AE 00 48    LDX $4800  [$00:4800]   ;
$00/BEE4 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BEE7 98          TYA                     ;
$00/BEE8 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BEEB A9 80 09    LDA #$0980              ;
$00/BEEE 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BEF1 A9 18 00    LDA #$0018              ;
$00/BEF4 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BEF7 A9 48 7E    LDA #$7E48              ;
$00/BEFA 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BEFD 8A          TXA                     ;
$00/BEFE 18          CLC                     ;
$00/BEFF 69 0C 00    ADC #$000C              ;
$00/BF02 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BF05 8A          TXA                     ;
$00/BF06 18          CLC                     ;
$00/BF07 69 0D 00    ADC #$000D              ;
$00/BF0A 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BF0D 8D 00 48    STA $4800  [$00:4800]   ;
$00/BF10 68          PLA                     ;
$00/BF11 9D 0C 00    STA $000C,x[$00:000C]   ;
$00/BF14 AB          PLB                     ;
$00/BF15 6B          RTL                     ;

$00/BF16 8B          PHB                     ;
$00/BF17 F4 48 7E    PEA $7E48               ;\
$00/BF1A AB          PLB                     ; | data bank $7E
$00/BF1B AB          PLB                     ;/
$00/BF1C DA          PHX                     ;
$00/BF1D AE 00 48    LDX $4800  [$00:4800]   ;
$00/BF20 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BF23 98          TYA                     ;
$00/BF24 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BF27 A9 00 00    LDA #$0000              ;
$00/BF2A 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BF2D A9 18 00    LDA #$0018              ;
$00/BF30 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BF33 AD 00 00    LDA $0000  [$00:0000]   ;
$00/BF36 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BF39 68          PLA                     ;
$00/BF3A 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BF3D 8A          TXA                     ;
$00/BF3E 18          CLC                     ;
$00/BF3F 69 0C 00    ADC #$000C              ;
$00/BF42 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BF45 8D 00 48    STA $4800  [$00:4800]   ;
$00/BF48 AB          PLB                     ;
$00/BF49 6B          RTL                     ;

$00/BF4A 8B          PHB                     ;
$00/BF4B F4 48 7E    PEA $7E48               ;\
$00/BF4E AB          PLB                     ; | data bank $7E
$00/BF4F AB          PLB                     ;/
$00/BF50 DA          PHX                     ;
$00/BF51 AE 00 48    LDX $4800  [$00:4800]   ;
$00/BF54 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BF57 98          TYA                     ;
$00/BF58 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BF5B A9 00 08    LDA #$0800              ;
$00/BF5E 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BF61 A9 18 00    LDA #$0018              ;
$00/BF64 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BF67 A9 48 7E    LDA #$7E48              ;
$00/BF6A 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BF6D 8A          TXA                     ;
$00/BF6E 18          CLC                     ;
$00/BF6F 69 0C 00    ADC #$000C              ;
$00/BF72 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BF75 8A          TXA                     ;
$00/BF76 18          CLC                     ;
$00/BF77 69 0D 00    ADC #$000D              ;
$00/BF7A 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BF7D 8D 00 48    STA $4800  [$00:4800]   ;
$00/BF80 68          PLA                     ;
$00/BF81 9D 0C 00    STA $000C,x[$00:000C]   ;
$00/BF84 AB          PLB                     ;
$00/BF85 6B          RTL                     ;

$00/BF86 8B          PHB                     ;
$00/BF87 F4 48 7E    PEA $7E48               ;\
$00/BF8A AB          PLB                     ; | data bank $7E
$00/BF8B AB          PLB                     ;/
$00/BF8C DA          PHX                     ;
$00/BF8D AE 00 48    LDX $4800  [$00:4800]   ;
$00/BF90 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BF93 98          TYA                     ;
$00/BF94 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BF97 A9 80 00    LDA #$0080              ;
$00/BF9A 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BF9D A9 19 00    LDA #$0019              ;
$00/BFA0 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BFA3 AD 00 00    LDA $0000  [$00:0000]   ;
$00/BFA6 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BFA9 68          PLA                     ;
$00/BFAA 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BFAD 8A          TXA                     ;
$00/BFAE 18          CLC                     ;
$00/BFAF 69 0C 00    ADC #$000C              ;
$00/BFB2 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BFB5 8D 00 48    STA $4800  [$00:4800]   ;
$00/BFB8 AB          PLB                     ;
$00/BFB9 6B          RTL                     ;

$00/BFBA 8B          PHB                     ;
$00/BFBB F4 48 7E    PEA $7E48               ;\
$00/BFBE AB          PLB                     ; | data bank $7E
$00/BFBF AB          PLB                     ;/
$00/BFC0 DA          PHX                     ;
$00/BFC1 AE 00 48    LDX $4800  [$00:4800]   ;
$00/BFC4 9D 08 00    STA $0008,x[$00:0008]   ;
$00/BFC7 98          TYA                     ;
$00/BFC8 9D 00 00    STA $0000,x[$00:0000]   ;
$00/BFCB A9 80 08    LDA #$0880              ;
$00/BFCE 9D 02 00    STA $0002,x[$00:0002]   ;
$00/BFD1 A9 19 00    LDA #$0019              ;
$00/BFD4 9D 04 00    STA $0004,x[$00:0004]   ;
$00/BFD7 A9 48 7E    LDA #$7E48              ;
$00/BFDA 9D 06 00    STA $0006,x[$00:0006]   ;
$00/BFDD 8A          TXA                     ;
$00/BFDE 18          CLC                     ;
$00/BFDF 69 0C 00    ADC #$000C              ;
$00/BFE2 9D 05 00    STA $0005,x[$00:0005]   ;
$00/BFE5 8A          TXA                     ;
$00/BFE6 18          CLC                     ;
$00/BFE7 69 0D 00    ADC #$000D              ;
$00/BFEA 9D 0A 00    STA $000A,x[$00:000A]   ;
$00/BFED 8D 00 48    STA $4800  [$00:4800]   ;
$00/BFF0 68          PLA                     ;
$00/BFF1 9D 0C 00    STA $000C,x[$00:000C]   ;
$00/BFF4 AB          PLB                     ;
$00/BFF5 6B          RTL                     ;

; freespace
DATA_00BFF6:         db $FF, $FF, $FF, $FF, $FF
DATA_00BFFB:         db $FF, $FF, $FF, $FF, $FF

;RAM
.NMI
CODE_00C000:        78            SEI                       ; Disable interrupts
CODE_00C001:        C2 38         REP #$38                  ;
CODE_00C003:        48            PHA                       ;\
CODE_00C004:        DA            PHX                       ; |
CODE_00C005:        5A            PHY                       ; | push everything 
CODE_00C006:        0B            PHD                       ; |
CODE_00C007:        8B            PHB                       ;/
CODE_00C008:        A9 00 00      LDA #$0000                ;\ set direct page to #$0000
CODE_00C00B:        5B            TCD                       ;/
CODE_00C00C:        E2 30         SEP #$30                  ;
CODE_00C00E:        48            PHA                       ;\ set bank to $00
CODE_00C00F:        AB            PLB                       ;/
CODE_00C010:        AC 10 42      LDY $4210                 ; clear NMI flag
CODE_00C013:        AE 1C 01      LDX $011C                 ;
CODE_00C016:        FC 74 C0      JSR ($C074,x)             ;

CODE_00C019:        A5 4D         LDA $4D                   ;
CODE_00C01B:        D0 07         BNE CODE_00C024           ;
CODE_00C01D:        AE 40 21      LDX $2140                 ;
CODE_00C020:        E4 4F         CPX $4F                   ;
CODE_00C022:        D0 07         BNE CODE_00C02B           ;
CODE_00C024:        8D 40 21      STA $2140                 ;
CODE_00C027:        85 4F         STA $4F                   ;
CODE_00C029:        64 4D         STZ $4D                   ;
CODE_00C02B:        A5 51         LDA $51                   ;
CODE_00C02D:        8D 41 21      STA $2141                 ;
CODE_00C030:        64 51         STZ $51                   ;
CODE_00C032:        AD 43 21      LDA $2143                 ;
CODE_00C035:        C5 55         CMP $55                   ;
CODE_00C037:        D0 33         BNE CODE_00C06C           ;
CODE_00C039:        A4 53         LDY $53                   ;
CODE_00C03B:        F0 08         BEQ CODE_00C045           ;

CODE_00C03D:        C5 53         CMP $53                   ;
CODE_00C03F:        F0 0C         BEQ CODE_00C04D           ;
CODE_00C041:        64 53         STZ $53                   ;
CODE_00C043:        80 22         BRA CODE_00C067           ;

CODE_00C045:        A6 57         LDX $57                   ;
CODE_00C047:        F0 1E         BEQ CODE_00C067           ;

CODE_00C049:        C5 59         CMP $59                   ;
CODE_00C04B:        D0 04         BNE CODE_00C051           ;
CODE_00C04D:        A0 00         LDY #$00                  ;
CODE_00C04F:        80 16         BRA CODE_00C067           ;

CODE_00C051:        CA            DEX                       ;
CODE_00C052:        E0 07         CPX #$07                  ;
CODE_00C054:        90 02         BCC CODE_00C058           ;
CODE_00C056:        A2 06         LDX #$06                  ;
CODE_00C058:        86 57         STX $57                   ;
CODE_00C05A:        A4 59         LDY $59                   ;
CODE_00C05C:        A2 00         LDX #$00                  ;
CODE_00C05E:        B5 5A         LDA $5A,x                 ;
CODE_00C060:        95 59         STA $59,x                 ;
CODE_00C062:        E8            INX                       ;
CODE_00C063:        E4 57         CPX $57                   ;
CODE_00C065:        90 F7         BCC CODE_00C05E           ;

CODE_00C067:        8C 43 21      STY $2143                 ;
CODE_00C06A:        84 55         STY $55                   ;
CODE_00C06C:        C2 30         REP #$30                  ;
CODE_00C06E:        AB            PLB                       ;
CODE_00C06F:        2B            PLD                       ;
CODE_00C070:        7A            PLY                       ;
CODE_00C071:        FA            PLX                       ;
CODE_00C072:        68            PLA                       ;
CODE_00C073:        40            RTI                       ; Return from NMI

DATA_00C074:         dw $C084, $C10A, $C10A, $C22C
DATA_00C07C:         dw $C10A, $C10A, $C10B, $C10A

$00/C084 A0 8F       LDY #$8F                ;\ Force blank
$00/C086 8C 00 21    STY $2100  [$04:2100]   ;/
$00/C089 9C 0C 42    STZ $420C  [$00:420C]   ; Disable HDMA
$00/C08C AD 1B 01    LDA $011B  [$00:011B]   ;
$00/C08F D0 03       BNE $03    [$C094]      ;
$00/C091 4C FD C0    JMP $C0FD  [$00:C0FD]   ;

$00/C094 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/C097 20 DF E3    JSR $E3DF  [$00:E3DF]   ;
$00/C09A 20 AA E3    JSR $E3AA  [$00:E3AA]   ;
$00/C09D C2 20       REP #$20                ;
$00/C09F A9 0B 42    LDA #$420B              ;
$00/C0A2 5B          TCD                     ;
$00/C0A3 A2 01       LDX #$01                ;
$00/C0A5 20 AC D4    JSR $D4AC  [$00:D4AC]   ;
$00/C0A8 20 E5 D4    JSR $D4E5  [$00:D4E5]   ;
$00/C0AB A0 80       LDY #$80                ;
$00/C0AD 8C 15 21    STY $2115  [$00:2115]   ;
$00/C0B0 A9 01 18    LDA #$1801              ;
$00/C0B3 85 F5       STA $F5    [$00:00F5]   ;
$00/C0B5 20 6B DC    JSR $DC6B  [$00:DC6B]   ;
$00/C0B8 A9 00 00    LDA #$0000              ;
$00/C0BB 5B          TCD                     ;
$00/C0BC E2 20       SEP #$20                ;
$00/C0BE 20 07 E5    JSR $E507  [$00:E507]   ;
$00/C0C1 A5 39       LDA $39    [$00:0039]   ;\
$00/C0C3 8D 0D 21    STA $210D  [$00:210D]   ; | BG1 horizontal scroll
$00/C0C6 A5 3A       LDA $3A    [$00:003A]   ; |
$00/C0C8 8D 0D 21    STA $210D  [$00:210D]   ;/
$00/C0CB A5 3B       LDA $3B    [$00:003B]   ;\

; sub called by GSU init routine $7EDECF
; r0 = #$0008
$00/C0CD 8D 0E 21    STA $210E  [$00:210E]   ; | BG1 vertical scroll
$00/C0D0 A5 3C       LDA $3C    [$00:003C]   ; |
$00/C0D2 8D 0E 21    STA $210E  [$00:210E]   ;/
$00/C0D5 A5 3D       LDA $3D    [$00:003D]   ;\
$00/C0D7 8D 0F 21    STA $210F  [$00:210F]   ; | BG2 horizontal scroll
$00/C0DA A5 3E       LDA $3E    [$00:003E]   ; |
$00/C0DC 8D 0F 21    STA $210F  [$00:210F]   ;/
$00/C0DF A5 3F       LDA $3F    [$00:003F]   ;\
$00/C0E1 8D 10 21    STA $2110  [$00:2110]   ; | BG2 vertical scroll
$00/C0E4 A5 40       LDA $40    [$00:0040]   ; |
$00/C0E6 8D 10 21    STA $2110  [$00:2110]   ;/
$00/C0E9 A5 41       LDA $41    [$00:0041]   ;\
$00/C0EB 8D 11 21    STA $2111  [$00:2111]   ; | BG3 horizontal scroll
$00/C0EE A5 42       LDA $42    [$00:0042]   ; |
$00/C0F0 8D 11 21    STA $2111  [$00:2111]   ;/
$00/C0F3 A5 43       LDA $43    [$00:0043]   ;\
$00/C0F5 8D 12 21    STA $2112  [$00:2112]   ; | BG3 vertical scroll
$00/C0F8 A5 44       LDA $44    [$00:0044]   ; |
$00/C0FA 8D 12 21    STA $2112  [$00:2112]   ;/

$00/C0FD AD 00 02    LDA $0200  [$00:0200]   ;
$00/C100 8D 00 21    STA $2100  [$00:2100]   ;
$00/C103 AD 4A 09    LDA $094A  [$00:094A]   ;
$00/C106 8D 0C 42    STA $420C  [$00:420C]   ;
$00/C109 60          RTS                     ;

$00/C10A 60          RTS                     ;

$00/C10B A0 8F       LDY #$8F                ;\ Force blank
$00/C10D 8C 00 21    STY $2100  [$04:2100]   ;/
$00/C110 9C 0C 42    STZ $420C  [$00:420C]   ; Disable HDMA
$00/C113 AD 6B 09    LDA $096B  [$00:096B]   ;
$00/C116 8D 30 21    STA $2130  [$00:2130]   ;
$00/C119 AD 94 09    LDA $0994  [$00:0994]   ;
$00/C11C 09 80       ORA #$80                ;
$00/C11E 8D 32 21    STA $2132  [$00:2132]   ;
$00/C121 AD 92 09    LDA $0992  [$00:0992]   ;
$00/C124 09 40       ORA #$40                ;
$00/C126 8D 32 21    STA $2132  [$00:2132]   ;
$00/C129 AD 90 09    LDA $0990  [$00:0990]   ;
$00/C12C 09 20       ORA #$20                ;
$00/C12E 8D 32 21    STA $2132  [$00:2132]   ;
$00/C131 AD 1B 01    LDA $011B  [$00:011B]   ;
$00/C134 D0 03       BNE $03    [$C139]      ;
$00/C136 4C DF C1    JMP $C1DF  [$00:C1DF]   ;

$00/C139 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/C13C 20 DF E3    JSR $E3DF  [$00:E3DF]   ;
$00/C13F 20 AA E3    JSR $E3AA  [$00:E3AA]   ;
$00/C142 C2 20       REP #$20                ;
$00/C144 A9 0B 42    LDA #$420B              ;
$00/C147 5B          TCD                     ;
$00/C148 A2 01 20    LDX #$2001              ;
$00/C14B AC D4 20    LDY $20D4  [$00:20D4]   ;
$00/C14E 10 D5       BPL $D5    [$C125]      ;
$00/C150 A9 00 00    LDA #$0000              ;
$00/C153 5B          TCD                     ;
$00/C154 A5 39       LDA $39    [$00:0039]   ;
$00/C156 8F 59 5B 7E STA $7E5B59[$7E:5B59]   ;
$00/C15A A5 3B       LDA $3B    [$00:003B]   ;
$00/C15C 8F 5B 5B 7E STA $7E5B5B[$7E:5B5B]   ;
$00/C160 A5 69       LDA $69    [$00:0069]   ;
$00/C162 8F 5E 5B 7E STA $7E5B5E[$7E:5B5E]   ;
$00/C166 A5 6B       LDA $6B    [$00:006B]   ;
$00/C168 8F 60 5B 7E STA $7E5B60[$7E:5B60]   ;
$00/C16C A5 3D       LDA $3D    [$00:003D]   ;
$00/C16E 8F 99 5B 7E STA $7E5B99[$7E:5B99]   ;
$00/C172 A5 3F       LDA $3F    [$00:003F]   ;
$00/C174 8F 9B 5B 7E STA $7E5B9B[$7E:5B9B]   ;
$00/C178 A5 6D       LDA $6D    [$00:006D]   ;
$00/C17A 8F 9E 5B 7E STA $7E5B9E[$7E:5B9E]   ;
$00/C17E A5 6F       LDA $6F    [$00:006F]   ;
$00/C180 8F A0 5B 7E STA $7E5BA0[$7E:5BA0]   ;
$00/C184 AD 44 11    LDA $1144  [$00:1144]   ;
$00/C187 8F 40 57 7E STA $7E5740[$7E:5740]   ;
$00/C18B E2 20       SEP #$20                ;
$00/C18D AD 6C 09    LDA $096C  [$00:096C]   ;
$00/C190 8F 9B 5C 7E STA $7E5C9B[$7E:5C9B]   ;
$00/C194 20 07 E5    JSR $E507  [$00:E507]   ; update controllers

; set the screen scrolling registers
$00/C197 AD 69 09    LDA $0969  [$00:0969]   ;
$00/C19A 8D 2E 21    STA $212E  [$00:212E]   ;
$00/C19D AD 66 09    LDA $0966  [$00:0966]   ;
$00/C1A0 8D 25 21    STA $2125  [$00:2125]   ;
$00/C1A3 A5 39       LDA $39    [$00:0039]   ;\
$00/C1A5 8D 0D 21    STA $210D  [$00:210D]   ; | BG1 horizontal scroll
$00/C1A8 A5 3A       LDA $3A    [$00:003A]   ; |
$00/C1AA 8D 0D 21    STA $210D  [$00:210D]   ;/
$00/C1AD A5 3B       LDA $3B    [$00:003B]   ;\
$00/C1AF 8D 0E 21    STA $210E  [$00:210E]   ; | BG1 vertical scroll
$00/C1B2 A5 3C       LDA $3C    [$00:003C]   ; |
$00/C1B4 8D 0E 21    STA $210E  [$00:210E]   ;/
$00/C1B7 A5 3D       LDA $3D    [$00:003D]   ;\
$00/C1B9 8D 0F 21    STA $210F  [$00:210F]   ; | BG2 horizontal scroll
$00/C1BC A5 3E       LDA $3E    [$00:003E]   ; |
$00/C1BE 8D 0F 21    STA $210F  [$00:210F]   ;/
$00/C1C1 A5 3F       LDA $3F    [$00:003F]   ;\
$00/C1C3 8D 10 21    STA $2110  [$00:2110]   ; | BG2 vertical scroll
$00/C1C6 A5 40       LDA $40    [$00:0040]   ; |
$00/C1C8 8D 10 21    STA $2110  [$00:2110]   ;/
$00/C1CB A5 41       LDA $41    [$00:0041]   ;\
$00/C1CD 8D 11 21    STA $2111  [$00:2111]   ; | BG3 horizontal scroll
$00/C1D0 A5 42       LDA $42    [$00:0042]   ; |
$00/C1D2 8D 11 21    STA $2111  [$00:2111]   ;/
$00/C1D5 A5 43       LDA $43    [$00:0043]   ;\
$00/C1D7 8D 12 21    STA $2112  [$00:2112]   ; | BG3 vertical scroll
$00/C1DA A5 44       LDA $44    [$00:0044]   ; |
$00/C1DC 8D 12 21    STA $2112  [$00:2112]   ;/

$00/C1DF AD 00 02    LDA $0200  [$00:0200]   ;
$00/C1E2 8D 00 21    STA $2100  [$00:2100]   ;
$00/C1E5 AD 4A 09    LDA $094A  [$00:094A]   ;
$00/C1E8 8D 0C 42    STA $420C  [$00:420C]   ;
$00/C1EB 60          RTS                     ;

DATA_00C1EC:         dw $4000, $6000, $4700, $6700

DATA_00C1F4:         dw $5180, $7180, $56DE, $56DE
DATA_00C1FC:         dw $64DE, $64DE

DATA_00C200:         dw $79DE, $79DE, $0E00, $0E00
DATA_00C208:         dw $1500, $1500, $1500, $1500

DATA_00C210:         db $63, $62

DATA_00C212:         db $3F, $BF, $00, $50, $28, $00, $00, $00
DATA_00C21A:         db $00, $00

DATA_00C21C:         db $01, $00, $01, $00, $01, $00, $00, $00
DATA_00C224:         db $FF, $FF, $FF, $00, $01, $01, $01, $00

$00/C22C A0 8F       LDY #$8F                ;\ Force blank
$00/C22E 8C 00 21    STY $2100  [$17:2100]   ;/
$00/C231 9C 0C 42    STZ $420C  [$17:420C]   ; Disable HDMA
$00/C234 AD 39 11    LDA $1139  [$00:1139]   ;
$00/C237 F0 02       BEQ $02    [$C23B]      ;
$00/C239 85 51       STA $51    [$00:0051]   ;
$00/C23B AD 6C 09    LDA $096C  [$00:096C]   ;
$00/C23E 8D 31 21    STA $2131  [$00:2131]   ;
$00/C241 AD 94 09    LDA $0994  [$00:0994]   ;
$00/C244 09 80       ORA #$80                ;
$00/C246 8D 32 21    STA $2132  [$00:2132]   ;
$00/C249 AD 92 09    LDA $0992  [$00:0992]   ;
$00/C24C 09 40       ORA #$40                ;
$00/C24E 8D 32 21    STA $2132  [$00:2132]   ;
$00/C251 AD 90 09    LDA $0990  [$00:0990]   ;
$00/C254 09 20       ORA #$20                ;
$00/C256 8D 32 21    STA $2132  [$00:2132]   ;
$00/C259 C2 20       REP #$20                ;
$00/C25B EE 31 01    INC $0131  [$00:0131]   ;
$00/C25E A0 80 8C    LDY #$8C80              ;
$00/C261 15 21       ORA $21,x  [$00:0021]   ;
$00/C263 A9 01 18    LDA #$1801              ;
$00/C266 8D 00 43    STA $4300  [$00:4300]   ;
$00/C269 A0 01 E2    LDY #$E201              ;
$00/C26C 20 AD 80    JSR $80AD  [$00:80AD]   ;
$00/C26F 09 F0 2C    ORA #$2CF0              ;
$00/C272 0A          ASL A                   ;
$00/C273 0D 84 09    ORA $0984  [$00:0984]   ;
$00/C276 0A          ASL A                   ;
$00/C277 AA          TAX                     ;
$00/C278 C2 20       REP #$20                ;
$00/C27A BF E8 C1 7E LDA $7EC1E8,x[$7E:C1E8] ;
$00/C27E 8D 16 21    STA $2116  [$00:2116]   ;
$00/C281 BF F4 C1 7E LDA $7EC1F4,x[$7E:C1F4] ;
$00/C285 8D 02 43    STA $4302  [$00:4302]   ;
$00/C288 BF 00 C2 7E LDA $7EC200,x[$7E:C200] ;
$00/C28C 8D 05 43    STA $4305  [$00:4305]   ;
$00/C28F A2 7F 8E    LDX #$8E7F              ;
$00/C292 04 43       TSB $43    [$00:0043]   ;
$00/C294 8C 0B 42    STY $420B  [$00:420B]   ;
$00/C297 E2 20       SEP #$20                ;
$00/C299 CE 80 09    DEC $0980  [$00:0980]   ;
$00/C29C D0 05       BNE $05    [$C2A3]      ;
$00/C29E AD 1B 01    LDA $011B  [$00:011B]   ;
$00/C2A1 D0 03       BNE $03    [$C2A6]      ;
$00/C2A3 4C 3E C3    JMP $C33E  [$00:C33E]   ;

$00/C2A6 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/C2A9 AD 82 09    LDA $0982  [$00:0982]   ;
$00/C2AC 9C 82 09    STZ $0982  [$00:0982]   ;
$00/C2AF 8D 80 09    STA $0980  [$00:0980]   ;
$00/C2B2 20 DF E3    JSR $E3DF  [$7E:E3DF]   ;
$00/C2B5 C2 20       REP #$20                ;
$00/C2B7 A9 0B 42    LDA #$420B              ;
$00/C2BA 5B          TCD                     ;
$00/C2BB A2 01       LDX #$01                ;
$00/C2BD 20 AC D4    JSR $D4AC  [$7E:D4AC]   ;
$00/C2C0 20 10 D5    JSR $D510  [$7E:D510]   ;
$00/C2C3 A9 40 50    LDA #$5040              ;
$00/C2C6 8D 81 21    STA $2181  [$00:2181]   ;
$00/C2C9 A0 7E       LDY #$7E                ;
$00/C2CB 8C 83 21    STY $2183  [$00:2183]   ;
$00/C2CE A9 00 80    LDA #$8000              ;
$00/C2D1 85 F5       STA $F5    [$00:4300]   ;
$00/C2D3 A9 AA 6C    LDA #$6CAA              ;
$00/C2D6 85 F7       STA $F7    [$00:4302]   ;
$00/C2D8 A0 00       LDY #$00                ;
$00/C2DA 84 F9       STY $F9    [$00:4304]   ;
$00/C2DC A9 80 03    LDA #$0380              ;
$00/C2DF 85 FA       STA $FA    [$00:4305]   ;
$00/C2E1 86 00       STX $00    [$00:420B]   ;
$00/C2E3 A9 00 00    LDA #$0000              ;
$00/C2E6 5B          TCD                     ;
$00/C2E7 E2 20       SEP #$20                ;
$00/C2E9 AC 84 09    LDY $0984  [$00:0984]   ;
$00/C2EC B9 10 C2    LDA $C210,y[$00:C210]   ;
$00/C2EF 8D 01 21    STA $2101  [$00:2101]   ;
$00/C2F2 AD 69 09    LDA $0969  [$00:0969]   ;
$00/C2F5 8D 2E 21    STA $212E  [$00:212E]   ;
$00/C2F8 AD 66 09    LDA $0966  [$00:0966]   ;
$00/C2FB 8D 25 21    STA $2125  [$00:2125]   ;
$00/C2FE A5 39       LDA $39    [$00:0039]   ;\
$00/C300 8D 0D 21    STA $210D  [$00:210D]   ; | BG1 horizontal scroll
$00/C303 A5 3A       LDA $3A    [$00:003A]   ; |
$00/C305 8D 0D 21    STA $210D  [$00:210D]   ;/
$00/C308 A5 3B       LDA $3B    [$00:003B]   ;\
$00/C30A 8D 0E 21    STA $210E  [$00:210E]   ; | BG1 vertical scroll
$00/C30D A5 3C       LDA $3C    [$00:003C]   ; |
$00/C30F 8D 0E 21    STA $210E  [$00:210E]   ;/
$00/C312 AD 0E 02    LDA $020E  [$00:020E]   ;\
$00/C315 8D 1F 21    STA $211F  [$00:211F]   ; | BG2 horizontal scroll
$00/C318 AD 0F 02    LDA $020F  [$00:020F]   ; |
$00/C31B 8D 1F 21    STA $211F  [$00:211F]   ;/
$00/C31E AD 10 02    LDA $0210  [$00:0210]   ;\
$00/C321 8D 20 21    STA $2120  [$00:2120]   ; | BG2 vertical scroll
$00/C324 AD 11 02    LDA $0211  [$00:0211]   ; |
$00/C327 8D 20 21    STA $2120  [$00:2120]   ;/
$00/C32A A5 3D       LDA $3D    [$00:003D]   ;\
$00/C32C 8D 0F 21    STA $210F  [$00:210F]   ; | BG3 horizontal scroll
$00/C32F A5 3E       LDA $3E    [$00:003E]   ; |
$00/C331 8D 0F 21    STA $210F  [$00:210F]   ;/
$00/C334 A5 3F       LDA $3F    [$00:003F]   ;\
$00/C336 8D 10 21    STA $2110  [$00:2110]   ; | BG3 vertical scroll
$00/C339 A5 40       LDA $40    [$00:0040]   ; |
$00/C33B 8D 10 21    STA $2110  [$00:2110]   ;/

$00/C33E C2 20       REP #$20                ;
$00/C340 A5 41       LDA $41    [$00:0041]   ;
$00/C342 18          CLC                     ;
$00/C343 6D 9E 09    ADC $099E  [$00:099E]   ;
$00/C346 85 41       STA $41    [$00:0041]   ;
$00/C348 4A          LSR A                   ;
$00/C349 8D BD 09    STA $09BD  [$00:09BD]   ;
$00/C34C 4A          LSR A                   ;
$00/C34D 4A          LSR A                   ;
$00/C34E 4A          LSR A                   ;
$00/C34F 8D A1 09    STA $09A1  [$00:09A1]   ;
$00/C352 6D BD 09    ADC $09BD  [$00:09BD]   ;
$00/C355 8D B9 09    STA $09B9  [$00:09B9]   ;
$00/C358 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C35B 8D B5 09    STA $09B5  [$00:09B5]   ;
$00/C35E 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C361 8D B1 09    STA $09B1  [$00:09B1]   ;
$00/C364 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C367 8D AD 09    STA $09AD  [$00:09AD]   ;
$00/C36A 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C36D 8D A9 09    STA $09A9  [$00:09A9]   ;
$00/C370 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C373 8D A5 09    STA $09A5  [$00:09A5]   ;
$00/C376 6D A1 09    ADC $09A1  [$00:09A1]   ;
$00/C379 8D A1 09    STA $09A1  [$00:09A1]   ;
$00/C37C E2 20       SEP #$20                ;
$00/C37E AD 5F 09    LDA $095F  [$00:095F]   ;
$00/C381 8D 07 21    STA $2107  [$00:2107]   ;
$00/C384 AD 60 09    LDA $0960  [$00:0960]   ;
$00/C387 8D 08 21    STA $2108  [$00:2108]   ;
$00/C38A AD 5E 09    LDA $095E  [$00:095E]   ;
$00/C38D 8F 19 5A 7E STA $7E5A19[$7E:5A19]   ;
$00/C391 AD 67 09    LDA $0967  [$00:0967]   ;
$00/C394 8F 99 5A 7E STA $7E5A99[$7E:5A99]   ;
$00/C398 AD A0 09    LDA $09A0  [$00:09A0]   ;
$00/C39B 8D 11 43    STA $4311  [$00:4311]   ;
$00/C39E 20 07 E5    JSR $E507  [$00:E507]   ;
$00/C3A1 AD 00 02    LDA $0200  [$00:0200]   ;
$00/C3A4 8D 00 21    STA $2100  [$00:2100]   ;
$00/C3A7 AD 4A 09    LDA $094A  [$00:094A]   ;
$00/C3AA 8D 0C 42    STA $420C  [$00:420C]   ;
$00/C3AD AD 8E 09    LDA $098E  [$00:098E]   ;
$00/C3B0 F0 35       BEQ $35    [$C3E7]      ;
$00/C3B2 4B          PHK                     ;
$00/C3B3 AB          PLB                     ;
$00/C3B4 AC 01 02    LDY $0201  [$00:0201]   ;
$00/C3B7 BE 12 C2    LDX $C212,y[$00:C212]   ;
$00/C3BA 8E 6C 09    STX $096C  [$00:096C]   ;
$00/C3BD 98          TYA                     ;
$00/C3BE 0A          ASL A                   ;
$00/C3BF 0A          ASL A                   ;
$00/C3C0 A8          TAY                     ;
$00/C3C1 A2 04 DE    LDX #$DE04              ;
$00/C3C4 96 09       STX $09,y  [$00:0009]   ;
$00/C3C6 10 1A       BPL $1A    [$C3E2]      ;
$00/C3C8 B9 1C C2    LDA $C21C,y[$00:C21C]   ;
$00/C3CB 9D 96 09    STA $0996,x[$00:0996]   ;
$00/C3CE BD 90 09    LDA $0990,x[$00:0990]   ;
$00/C3D1 18          CLC                     ;
$00/C3D2 79 24 C2    ADC $C224,y[$00:C224]   ;
$00/C3D5 10 02       BPL $02    [$C3D9]      ;
$00/C3D7 A9 00       LDA #$00                ;
$00/C3D9 C9 1F       CMP #$1F                ;
$00/C3DB 90 02       BCC $02    [$C3DF]      ;
$00/C3DD A9 1F       LDA #$1F                ;
$00/C3DF 9D 90 09    STA $0990,x[$00:0990]   ;
$00/C3E2 C8          INY                     ;
$00/C3E3 CA          DEX                     ;
$00/C3E4 CA          DEX                     ;
$00/C3E5 10 DC       BPL $DC    [$C3C3]      ;
$00/C3E7 60          RTS                     ;

.IRQ_Handler
CODE_00C3E8:        78            SEI                       ; Disable interrupts

.IRQ_Start
CODE_00C3E9:        C2 38         REP #$38                  ;\
CODE_00C3EB:        48            PHA                       ; |
CODE_00C3EC:        DA            PHX                       ; |
CODE_00C3ED:        5A            PHY                       ; | Push A/X/Y/DP/DB
CODE_00C3EE:        0B            PHD                       ; |
CODE_00C3EF:        8B            PHB                       ;/
CODE_00C3F0:        A9 00 00      LDA #$0000                ;\ reset DP
CODE_00C3F3:        5B            TCD                       ;/
CODE_00C3F4:        E2 30         SEP #$30                  ;
CODE_00C3F6:        48            PHA                       ;\ DB = $00
CODE_00C3F7:        AB            PLB                       ;/

CODE_00C3F8:        AD 11 42      LDA $4211                 ;
CODE_00C3FB:        AE 26 01      LDX $0126                 ;
CODE_00C3FE:        FC 0A C4      JSR ($C40A,x)             ;

.IRQ_Return
CODE_00C401:        C2 30         REP #$30                  ;
CODE_00C403:        AB            PLB                       ;
CODE_00C404:        2B            PLD                       ;
CODE_00C405:        7A            PLY                       ;
CODE_00C406:        FA            PLX                       ;
CODE_00C407:        68            PLA                       ;
CODE_00C408:        58            CLI                       ;

.EmptyHandler
CODE_00C409:        40            RTI                       ; Return from IRQ

DATA_00C40A:	     dw $C412
DATA_00C40C:	     dw $C821
DATA_00C40E:	     dw $CA9A
DATA_00C410:	     dw $D308

CODE_00C412:        AD 25 01      LDA $0125                 ;
CODE_00C415:        D0 26         BNE CODE_00C43D           ;
CODE_00C417:        2C 12 42      BIT $4212                 ;\ wait for h-blank to occur
CODE_00C41A:        70 FB         BVS CODE_00C417           ;/
CODE_00C41C:        2C 12 42      BIT $4212                 ;\ wait for h-blank to end
CODE_00C41F:        50 FB         BVC CODE_00C41C           ;/

CODE_00C421:        AD 4A 09      LDA $094A                 ;
CODE_00C424:        8D 0C 42      STA $420C                 ;
CODE_00C427:        9C 00 21      STZ $2100                 ; turn screen brightness off
CODE_00C42A:        A9 50         LDA #$50                  ;\ set h-timer to #$50
CODE_00C42C:        8D 07 42      STA $4207                 ;/
CODE_00C42F:        A9 08         LDA #$08                  ;\
CODE_00C431:        EE 25 01      INC $0125                 ; | set v-timer to #$08
CODE_00C434:        8D 09 42      STA $4209                 ;/
CODE_00C437:        A9 B1         LDA #$B1                  ;\ Enable IRQ, NMI and auto-joypad reading
CODE_00C439:        8D 00 42      STA $4200                 ;/
CODE_00C43C:        60            RTS                       ;

$00/C43D 3A          DEC A                   ;
$00/C43E D0 25       BNE $25    [$C465]      ;
$00/C440 2C 12 42    BIT $4212  [$04:4212]   ;\ wait for h-blank to occur
$00/C443 70 FB       BVS $FB    [$C440]      ;/
$00/C445 2C 12 42    BIT $4212  [$04:4212]   ;\ wait for h-blank to end
$00/C448 50 FB       BVC $FB    [$C445]      ;/

$00/C44A AD 00 02    LDA $0200  [$04:0200]   ;\ restore brightness
$00/C44D 8D 00 21    STA $2100  [$04:2100]   ;/
$00/C450 A9 50       LDA #$50                ;\ set h-timer to #$50
$00/C452 8D 07 42    STA $4207  [$04:4207]   ;/
$00/C455 A9 D8       LDA #$D8                ; possibly set v-timer to #$D8
$00/C457 AE 21 01    LDX $0121  [$04:0121]   ;
$00/C45A D0 03       BNE $03    [$C45F]      ;
$00/C45C 4C 31 C4    JMP $C431  [$04:C431]   ;

$00/C45F 20 31 C4    JSR $C431  [$04:C431]   ;
$00/C462 7C 14 C7    JMP ($C714,x)[$04:3004] ;

$00/C465 2C 12 42    BIT $4212  [$00:4212]   ;\ wait for h-blank to occur
$00/C468 70 FB       BVS $FB    [$C465]      ;/
$00/C46A 2C 12 42    BIT $4212  [$00:4212]   ;\ wait for h-blank to end
$00/C46D 50 FB       BVC $FB    [$C46A]      ;/

$00/C46F A0 8F       LDY #$8F                ;\ Force blank
$00/C471 8C 00 21    STY $2100  [$00:2100]   ;/
$00/C474 9C 0C 42    STZ $420C  [$00:420C]   ; Disable HDMA
$00/C477 AE 1C 01    LDX $011C  [$00:011C]   ;
$00/C47A 7C 7D C4    JMP ($C47D,x)[$7E:C43C] ;

DATA_00C47D:         dw $C43C, $C48D, $C5FE, $C43C
DATA_00C485:         dw $C87A, $C641, $C43C, $C43C

$00/C48D AD 1B 01    LDA $011B  [$04:011B]   ;
$00/C490 D0 03       BNE $03    [$C495]      ;
$00/C492 4C CC C6    JMP $C6CC  [$04:C6CC]   ;

$00/C495 C2 20       REP #$20                ;
$00/C497 A5 3B       LDA $3B    [$00:003B]   ;
$00/C499 18          CLC                     ;
$00/C49A 6D B0 0C    ADC $0CB0  [$04:0CB0]   ;
$00/C49D 8D 1F 01    STA $011F  [$04:011F]   ;
$00/C4A0 A5 39       LDA $39    [$00:0039]   ;
$00/C4A2 8D 1D 01    STA $011D  [$00:011D]   ;
$00/C4A5 E2 20       SEP #$20                ;
$00/C4A7 8D 0E 21    STA $210E  [$00:210E]   ;
$00/C4AA EB          XBA                     ;
$00/C4AB 8D 0E 21    STA $210E  [$00:210E]   ;
$00/C4AE 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/C4B1 20 DF E3    JSR $E3DF  [$00:E3DF]   ;
$00/C4B4 20 AA E3    JSR $E3AA  [$00:E3AA]   ;
$00/C4B7 C2 20       REP #$20                ;
$00/C4B9 0B          PHD                     ;
$00/C4BA A9 0B 42    LDA #$420B              ;
$00/C4BD 5B          TCD                     ;
$00/C4BE A2 01       LDX #$01                ;
$00/C4C0 20 0C DE    JSR $DE0C  [$04:DE0C]   ;
$00/C4C3 20 AC D4    JSR $D4AC  [$04:D4AC]   ;
$00/C4C6 20 E5 D4    JSR $D4E5  [$04:D4E5]   ;
$00/C4C9 A0 80       LDY #$80                ;
$00/C4CB 8C 15 21    STY $2115  [$04:2115]   ;
$00/C4CE A9 01 18    LDA #$1801              ;
$00/C4D1 85 F5       STA $F5    [$00:00F5]   ;
$00/C4D3 AC 0F 0B    LDY $0B0F  [$04:0B0F]   ;
$00/C4D6 F0 1C       BEQ $1C    [$C4F4]      ;
$00/C4D8 C0 0C       CPY #$0C                ;
$00/C4DA 90 18       BCC $18    [$C4F4]      ;
$00/C4DC A9 00 4E    LDA #$4E00              ;
$00/C4DF 8D 16 21    STA $2116  [$04:2116]   ;
$00/C4E2 A9 00 68    LDA #$6800              ;
$00/C4E5 85 F7       STA $F7    [$00:00F7]   ;
$00/C4E7 A0 70       LDY #$70                ;
$00/C4E9 84 F9       STY $F9    [$00:00F9]   ;
$00/C4EB A9 00 0C    LDA #$0C00              ;
$00/C4EE 85 FA       STA $FA    [$00:00FA]   ;
$00/C4F0 86 00       STX $00    [$00:0000]   ;
$00/C4F2 80 1A       BRA $1A    [$C50E]      ;

$00/C4F4 20 AE DC    JSR $DCAE  [$04:DCAE]   ;
$00/C4F7 20 5D D6    JSR $D65D  [$00:D65D]   ;
$00/C4FA 20 6B DC    JSR $DC6B  [$00:DC6B]   ;
$00/C4FD AC 15 0D    LDY $0D15  [$04:0D15]   ;
$00/C500 F0 06       BEQ $06    [$C508]      ;
$00/C502 20 97 DC    JSR $DC97  [$04:DC97]   ;
$00/C505 9C 15 0D    STZ $0D15  [$04:0D15]   ;
$00/C508 20 A9 DB    JSR $DBA9  [$04:DBA9]   ;
$00/C50B 20 1C DC    JSR $DC1C  [$04:DC1C]   ;
$00/C50E 2B          PLD                     ;
$00/C50F AC 0D 0D    LDY $0D0D  [$04:0D0D]   ;
$00/C512 D0 07       BNE $07    [$C51B]      ;
$00/C514 AC 34 01    LDY $0134  [$04:0134]   ;
$00/C517 C0 10       CPY #$10                ;
$00/C519 90 1E       BCC $1E    [$C539]      ;
$00/C51B AD 0B 0D    LDA $0D0B  [$04:0D0B]   ;
$00/C51E 8F 19 5D 7E STA $7E5D19[$7E:5D19]   ;
$00/C522 18          CLC                     ;
$00/C523 69 69 00    ADC #$0069              ;
$00/C526 8F 1C 5D 7E STA $7E5D1C[$7E:5D1C]   ;
$00/C52A AD 09 0D    LDA $0D09  [$04:0D09]   ;
$00/C52D 8F 99 5C 7E STA $7E5C99[$7E:5C99]   ;
$00/C531 18          CLC                     ;
$00/C532 69 D2 00    ADC #$00D2              ;
$00/C535 8F 9C 5C 7E STA $7E5C9C[$7E:5C9C]   ;
$00/C539 E2 20       SEP #$20                ;
$00/C53B AD 1D 01    LDA $011D  [$00:011D]   ;
$00/C53E 8D 0D 21    STA $210D  [$00:210D]   ;
$00/C541 AD 1E 01    LDA $011E  [$00:011E]   ;
$00/C544 8D 0D 21    STA $210D  [$00:210D]   ;
$00/C547 AD 1F 01    LDA $011F  [$00:011F]   ;
$00/C54A 8D 0E 21    STA $210E  [$00:210E]   ;
$00/C54D AD 20 01    LDA $0120  [$00:0120]   ;
$00/C550 8D 0E 21    STA $210E  [$00:210E]   ;
$00/C553 A5 3D       LDA $3D    [$00:003D]   ;
$00/C555 8D 0F 21    STA $210F  [$00:210F]   ;
$00/C558 A5 3E       LDA $3E    [$00:003E]   ;
$00/C55A 8D 0F 21    STA $210F  [$00:210F]   ;
$00/C55D A5 3F       LDA $3F    [$00:003F]   ;
$00/C55F 8D 10 21    STA $2110  [$00:2110]   ;
$00/C562 A5 40       LDA $40    [$00:0040]   ;
$00/C564 8D 10 21    STA $2110  [$00:2110]   ;
$00/C567 A5 41       LDA $41    [$00:0041]   ;
$00/C569 8D 11 21    STA $2111  [$00:2111]   ;
$00/C56C A5 42       LDA $42    [$00:0042]   ;
$00/C56E 8D 11 21    STA $2111  [$00:2111]   ;
$00/C571 A5 43       LDA $43    [$00:0043]   ;
$00/C573 8D 12 21    STA $2112  [$00:2112]   ;
$00/C576 A5 44       LDA $44    [$00:0044]   ;
$00/C578 8D 12 21    STA $2112  [$00:2112]   ;
$00/C57B 20 07 E5    JSR $E507  [$00:E507]   ;
$00/C57E C2 20       REP #$20                ;
$00/C580 A9 00 21    LDA #$2100              ;
$00/C583 5B          TCD                     ;
$00/C584 AD 67 09    LDA $0967  [$00:0967]   ;
$00/C587 85 2C       STA $2C    [$00:002C]   ;
$00/C589 AD 69 09    LDA $0969  [$00:0969]   ;
$00/C58C 85 2E       STA $2E    [$00:002E]   ;
$00/C58E AD 62 09    LDA $0962  [$00:0962]   ;
$00/C591 85 0B       STA $0B    [$00:000B]   ;
$00/C593 AD 5F 09    LDA $095F  [$00:095F]   ;
$00/C596 85 07       STA $07    [$00:0007]   ;
$00/C598 AD 64 09    LDA $0964  [$00:0964]   ;
$00/C59B 85 23       STA $23    [$00:0023]   ;
$00/C59D AD 6B 09    LDA $096B  [$00:096B]   ;
$00/C5A0 85 30       STA $30    [$00:0030]   ;
$00/C5A2 AD 4C 09    LDA $094C  [$00:094C]   ;
$00/C5A5 85 2A       STA $2A    [$00:002A]   ;
$00/C5A7 E2 20       SEP #$20                ;
$00/C5A9 AD 61 09    LDA $0961  [$00:0961]   ;
$00/C5AC 85 09       STA $09    [$00:0009]   ;
$00/C5AE AD 5E 09    LDA $095E  [$00:095E]   ;
$00/C5B1 85 05       STA $05    [$00:0005]   ;
$00/C5B3 AD 5B 09    LDA $095B  [$00:095B]   ;
$00/C5B6 85 06       STA $06    [$00:0006]   ;
$00/C5B8 AD 66 09    LDA $0966  [$00:0966]   ;
$00/C5BB 85 25       STA $25    [$00:0025]   ;
$00/C5BD C2 20       REP #$20                ;
$00/C5BF A9 00 43    LDA #$4300              ;
$00/C5C2 5B          TCD                     ;
$00/C5C3 A5 12       LDA $12    [$00:0012]   ;
$00/C5C5 85 18       STA $18    [$00:0018]   ;
$00/C5C7 A5 22       LDA $22    [$00:0022]   ;
$00/C5C9 85 28       STA $28    [$00:0028]   ;
$00/C5CB A5 32       LDA $32    [$00:0032]   ;
$00/C5CD 85 38       STA $38    [$00:0038]   ;
$00/C5CF A5 42       LDA $42    [$00:0042]   ;
$00/C5D1 85 48       STA $48    [$00:0048]   ;
$00/C5D3 A5 52       LDA $52    [$00:0052]   ;
$00/C5D5 85 58       STA $58    [$00:0058]   ;
$00/C5D7 A5 62       LDA $62    [$00:0062]   ;
$00/C5D9 85 68       STA $68    [$00:0068]   ;
$00/C5DB A5 72       LDA $72    [$00:0072]   ;
$00/C5DD 85 78       STA $78    [$00:0078]   ;
$00/C5DF E2 20       SEP #$20                ;
$00/C5E1 A9 01       LDA #$01                ;
$00/C5E3 85 1A       STA $1A    [$00:001A]   ;
$00/C5E5 85 2A       STA $2A    [$00:002A]   ;
$00/C5E7 85 3A       STA $3A    [$00:003A]   ;
$00/C5E9 85 4A       STA $4A    [$00:004A]   ;
$00/C5EB 85 5A       STA $5A    [$00:005A]   ;
$00/C5ED 85 6A       STA $6A    [$00:006A]   ;
$00/C5EF 85 7A       STA $7A    [$00:007A]   ;
$00/C5F1 9C 25 01    STZ $0125  [$00:0125]   ;
$00/C5F4 A9 50       LDA #$50                ;
$00/C5F6 8D 07 42    STA $4207  [$00:4207]   ;
$00/C5F9 A9 06       LDA #$06                ;
$00/C5FB 4C 34 C4    JMP $C434  [$00:C434]   ;

$00/C5FE AD 1B 01    LDA $011B  [$00:011B]   ;
$00/C601 D0 03       BNE $03    [$C606]      ;
$00/C603 4C CC C6    JMP $C6CC  [$00:C6CC]   ;

$00/C606 A9 80       LDA #$80                ;
$00/C608 8D 15 21    STA $2115  [$00:2115]   ;
$00/C60B C2 20       REP #$20                ;
$00/C60D A9 00 36    LDA #$3600              ;
$00/C610 8D 16 21    STA $2116  [$04:2116]   ;
$00/C613 A9 01 18    LDA #$1801              ;
$00/C616 8D 00 43    STA $4300  [$04:4300]   ;
$00/C619 A9 F2 7E    LDA #$7EF2              ;
$00/C61C 8D 02 43    STA $4302  [$04:4302]   ;
$00/C61F A0 00       LDY #$00                ;
$00/C621 8C 04 43    STY $4304  [$04:4304]   ;
$00/C624 A0 80       LDY #$80                ;
$00/C626 8C 05 43    STY $4305  [$04:4305]   ;
$00/C629 A2 01       LDX #$01                ;
$00/C62B 8E 0B 42    STX $420B  [$04:420B]   ;

$00/C62E A9 80 00    LDA #$0080              ;
$00/C631 85 43       STA $43    [$00:0043]   ;
$00/C633 64 41       STZ $41    [$00:0041]   ;
$00/C635 AD F0 7E    LDA $7EF0  [$04:7EF0]   ;
$00/C638 8D 1F 01    STA $011F  [$04:011F]   ;
$00/C63B AD EE 7E    LDA $7EEE  [$04:7EEE]   ;
$00/C63E 4C A2 C4    JMP $C4A2  [$04:C4A2]   ;

$00/C641 AD 1B 01    LDA $011B  [$00:011B]   ;
$00/C644 D0 03       BNE $03    [$C649]      ;
$00/C646 4C CC C6    JMP $C6CC  [$00:C6CC]   ;

$00/C649 AD 4E 09    LDA $094E  [$00:094E]   ;
$00/C64C 8D 1A 21    STA $211A  [$00:211A]   ;
$00/C64F AD 4F 09    LDA $094F  [$00:094F]   ;
$00/C652 8D 1B 21    STA $211B  [$00:211B]   ;
$00/C655 AD 50 09    LDA $0950  [$00:0950]   ;
$00/C658 8D 1B 21    STA $211B  [$00:211B]   ;
$00/C65B AD 51 09    LDA $0951  [$00:0951]   ;
$00/C65E 8D 1C 21    STA $211C  [$00:211C]   ;
$00/C661 AD 52 09    LDA $0952  [$00:0952]   ;
$00/C664 8D 1C 21    STA $211C  [$00:211C]   ;
$00/C667 AD 53 09    LDA $0953  [$00:0953]   ;
$00/C66A 8D 1D 21    STA $211D  [$00:211D]   ;
$00/C66D AD 54 09    LDA $0954  [$00:0954]   ;
$00/C670 8D 1D 21    STA $211D  [$00:211D]   ;
$00/C673 AD 55 09    LDA $0955  [$00:0955]   ;
$00/C676 8D 1E 21    STA $211E  [$00:211E]   ;
$00/C679 AD 56 09    LDA $0956  [$00:0956]   ;
$00/C67C 8D 1E 21    STA $211E  [$00:211E]   ;
$00/C67F AD 57 09    LDA $0957  [$00:0957]   ;
$00/C682 8D 1F 21    STA $211F  [$00:211F]   ;
$00/C685 AD 58 09    LDA $0958  [$00:0958]   ;
$00/C688 8D 1F 21    STA $211F  [$00:211F]   ;
$00/C68B AD 59 09    LDA $0959  [$00:0959]   ;
$00/C68E 8D 20 21    STA $2120  [$00:2120]   ;
$00/C691 AD 5A 09    LDA $095A  [$00:095A]   ;
$00/C694 8D 20 21    STA $2120  [$00:2120]   ;
$00/C697 C2 20       REP #$20                ;
$00/C699 AD 83 0B    LDA $0B83  [$04:0B83]   ;
$00/C69C 8F E5 51 7E STA $7E51E5[$7E:51E5]   ;
$00/C6A0 8F E8 51 7E STA $7E51E8[$7E:51E8]   ;
$00/C6A4 AD 67 09    LDA $0967  [$04:0967]   ;
$00/C6A7 8F EB 51 7E STA $7E51EB[$7E:51EB]   ;
$00/C6AB A5 39       LDA $39    [$00:0039]   ;
$00/C6AD 85 3D       STA $3D    [$00:003D]   ;
$00/C6AF A5 3B       LDA $3B    [$00:003B]   ;
$00/C6B1 18          CLC                     ;
$00/C6B2 6D B0 0C    ADC $0CB0  [$04:0CB0]   ;
$00/C6B5 85 3F       STA $3F    [$00:003F]   ;
$00/C6B7 A5 43       LDA $43    [$00:0043]   ;
$00/C6B9 AC 46 01    LDY $0146  [$04:0146]   ;
$00/C6BC C0 09       CPY #$09                ;
$00/C6BE D0 04       BNE $04    [$C6C4]      ;
$00/C6C0 18          CLC                     ;
$00/C6C1 6D B0 0C    ADC $0CB0  [$04:0CB0]   ;
$00/C6C4 8D 1F 01    STA $011F  [$04:011F]   ;
$00/C6C7 A5 41       LDA $41    [$00:0041]   ;
$00/C6C9 4C A2 C4    JMP $C4A2  [$04:C4A2]   ;

$00/C6CC AD 21 01    LDA $0121  [$04:0121]   ;
$00/C6CF F0 28       BEQ $28    [$C6F9]      ;
$00/C6D1 C2 20       REP #$20                ;
$00/C6D3 0B          PHD                     ;
$00/C6D4 A9 0B 42    LDA #$420B              ;
$00/C6D7 5B          TCD                     ;
$00/C6D8 A2 01       LDX #$01                ;
$00/C6DA 20 0C DE    JSR $DE0C  [$04:DE0C]   ;
$00/C6DD 20 AC D4    JSR $D4AC  [$04:D4AC]   ;
$00/C6E0 20 E5 D4    JSR $D4E5  [$04:D4E5]   ;
$00/C6E3 A0 80       LDY #$80                ;
$00/C6E5 8C 15 21    STY $2115  [$04:2115]   ;
$00/C6E8 A9 01 18    LDA #$1801              ;
$00/C6EB 85 F5       STA $F5    [$00:00F5]   ;
$00/C6ED 20 AE DC    JSR $DCAE  [$04:DCAE]   ;
$00/C6F0 20 6B DC    JSR $DC6B  [$04:DC6B]   ;
$00/C6F3 2B          PLD                     ;
$00/C6F4 E2 20       SEP #$20                ;
$00/C6F6 20 07 E5    JSR $E507  [$04:E507]   ;
$00/C6F9 AD 1D 01    LDA $011D  [$04:011D]   ;
$00/C6FC 8D 0D 21    STA $210D  [$04:210D]   ;
$00/C6FF AD 1E 01    LDA $011E  [$04:011E]   ;
$00/C702 8D 0D 21    STA $210D  [$04:210D]   ;
$00/C705 AD 1F 01    LDA $011F  [$04:011F]   ;
$00/C708 8D 0E 21    STA $210E  [$04:210E]   ;
$00/C70B AD 20 01    LDA $0120  [$04:0120]   ;
$00/C70E 8D 0E 21    STA $210E  [$04:210E]   ;
$00/C711 4C 7E C5    JMP $C57E  [$04:C57E]   ;

DATA_00C714:         dw $C718, $C719

$00/C718 60          RTS                     ;

$00/C719 22 1E C7 00 JSL $00C71E[$00:C71E]   ;
$00/C71D 60          RTS                     ;

$00/C71E 22 59 82 00 JSL $008259[$00:8259]   ;
$00/C722 22 D3 94 03 JSL $0394D3[$03:94D3]   ;
$00/C726 22 67 FA 04 JSL $04FA67[$04:FA67]   ;
$00/C72A 22 9E DD 04 JSL $04DD9E[$04:DD9E]   ;
$00/C72E 22 D3 97 03 JSL $0397D3[$03:97D3]   ;
$00/C732 C2 20       REP #$20                ;
$00/C734 A2 08       LDX #$08                ;
$00/C736 A9 EF B1    LDA #$B1EF              ;
$00/C739 22 44 DE 7E JSL $7EDE44[$7E:DE44]   ; GSU init
$00/C73D EE 23 0D    INC $0D23  [$00:0D23]   ;
$00/C740 EE 25 0D    INC $0D25  [$00:0D25]   ;
$00/C743 AD 25 0D    LDA $0D25  [$00:0D25]   ;
$00/C746 C9 10 00    CMP #$0010              ;
$00/C749 90 2A       BCC $2A    [$C775]      ;
$00/C74B AD 3E 09    LDA $093E  [$00:093E]   ;
$00/C74E 0D 42 09    ORA $0942  [$00:0942]   ;
$00/C751 F0 0A       BEQ $0A    [$C75D]      ;
$00/C753 AD 23 0D    LDA $0D23  [$00:0D23]   ;
$00/C756 18          CLC                     ;
$00/C757 69 06 00    ADC #$0006              ;
$00/C75A 8D 23 0D    STA $0D23  [$00:0D23]   ;
$00/C75D AD 25 0D    LDA $0D25  [$00:0D25]   ;
$00/C760 29 03 00    AND #$0003              ;
$00/C763 F0 04       BEQ $04    [$C769]      ;
$00/C765 5C C8 C7 00 JMP $00C7C8[$00:C7C8]   ;

$00/C769 C2 10       REP #$10                ;
$00/C76B A2 00 00    LDX #$0000              ;
$00/C76E AC 1A 02    LDY $021A  [$00:021A]   ;
$00/C771 5C 78 C7 00 JMP $00C778[$00:C778]   ;

$00/C775 E2 20       SEP #$20                ;
$00/C777 6B          RTL                     ;

CODE_00C778:        C2 20         REP #$20                  ;
CODE_00C77A:        8B            PHB                       ;
CODE_00C77B:        4B            PHK                       ;
CODE_00C77C:        AB            PLB                       ;
CODE_00C77D:        AD 21 0D      LDA $0D21                 ;
CODE_00C780:        29 3F 00      AND #$003F                ;
CODE_00C783:        8D 16 30      STA $3016                 ;
CODE_00C786:        8C 1C 30      STY $301C                 ;
CODE_00C789:        A9 51 00      LDA #$0051                ;
CODE_00C78C:        8D 00 30      STA $3000                 ;
CODE_00C78F:        A9 BC 49      LDA #$49BC                ;
CODE_00C792:        8D 14 30      STA $3014                 ;
CODE_00C795:        E2 10         SEP #$10                  ;
CODE_00C797:        AD 1D 0D      LDA $0D1D                 ;
CODE_00C79A:        8D 12 30      STA $3012                 ;
CODE_00C79D:        AD 1F 0D      LDA $0D1F                 ;
CODE_00C7A0:        8D 10 30      STA $3010                 ;
CODE_00C7A3:        A2 09         LDX #$09                  ;
CODE_00C7A5:        A9 2F E9      LDA #$E92F                ;
CODE_00C7A8:        22 44 DE 7E   JSL CODE_7EDE44           ; GSU init

CODE_00C7AC:        AD 16 30      LDA $3016                 ;
CODE_00C7AF:        8D 21 0D      STA $0D21                 ;
CODE_00C7B2:        AD 10 30      LDA $3010                 ;
CODE_00C7B5:        8D 1F 0D      STA $0D1F                 ;
CODE_00C7B8:        AD 12 30      LDA $3012                 ;
CODE_00C7BB:        8D 1D 0D      STA $0D1D                 ;
CODE_00C7BE:        EE F9 0C      INC $0CF9                 ;
CODE_00C7C1:        AB            PLB                       ;
CODE_00C7C2:        A9 38 50      LDA #$5038                ;
CODE_00C7C5:        8D 1B 0D      STA $0D1B                 ;
CODE_00C7C8:        C2 10         REP #$10                  ;
CODE_00C7CA:        A9 AA AA      LDA #$AAAA                ;
CODE_00C7CD:        8D 00 6C      STA $6C00                 ;
CODE_00C7D0:        8D 02 6C      STA $6C02                 ;
CODE_00C7D3:        A9 E0 00      LDA #$00E0                ;
CODE_00C7D6:        8D 19 0D      STA $0D19                 ;
CODE_00C7D9:        E2 20         SEP #$20                  ;
CODE_00C7DB:        A2 00 00      LDX #$0000                ;
CODE_00C7DE:        C2 20         REP #$20                  ;
CODE_00C7E0:        8A            TXA                       ;
CODE_00C7E1:        29 FF 00      AND #$00FF                ;
CODE_00C7E4:        4A            LSR A                     ;
CODE_00C7E5:        09 C0 35      ORA #$35C0                ;
CODE_00C7E8:        9D 02 6A      STA $6A02,x               ;
CODE_00C7EB:        09 20 00      ORA #$0020                ;
CODE_00C7EE:        9D 22 6A      STA $6A22,x               ;
CODE_00C7F1:        AD 4C 0B      LDA $0B4C                 ;
CODE_00C7F4:        38            SEC                       ;
CODE_00C7F5:        ED 19 0D      SBC $0D19                 ;
CODE_00C7F8:        E2 20         SEP #$20                  ;
CODE_00C7FA:        9D 00 6A      STA $6A00,x               ;
CODE_00C7FD:        9D 20 6A      STA $6A20,x               ;

CODE_00C800:        AD 19 0D      LDA $0D19                 ;
CODE_00C803:        38            SEC                       ;
CODE_00C804:        E9 10         SBC #$10                  ;
CODE_00C806:        8D 19 0D      STA $0D19                 ;
CODE_00C809:        AD 1B 0D      LDA $0D1B                 ;
CODE_00C80C:        9D 01 6A      STA $6A01,x               ;
CODE_00C80F:        AD 1C 0D      LDA $0D1C                 ;
CODE_00C812:        9D 21 6A      STA $6A21,x               ;
CODE_00C815:        E8            INX                       ;
CODE_00C816:        E8            INX                       ;
CODE_00C817:        E8            INX                       ;
CODE_00C818:        E8            INX                       ;
CODE_00C819:        E0 20 00      CPX #$0020                ;
CODE_00C81C:        90 C0         BCC CODE_00C7DE           ;
CODE_00C81E:        E2 10         SEP #$10                  ;
CODE_00C820:        6B            RTL                       ;

CODE_00C821:        AD 25 01      LDA $0125                 ;
CODE_00C824:        D0 1C         BNE CODE_00C842           ;

.WaitForHBlank
CODE_00C826:        2C 12 42      BIT $4212                 ;
CODE_00C829:        70 FB         BVS CODE_00C826           ;

CODE_00C82B:        2C 12 42      BIT $4212                 ;
CODE_00C82E:        50 FB         BVC CODE_00C82B           ;

CODE_00C830:        AD 4A 09      LDA $094A                 ;
CODE_00C833:        8D 0C 42      STA $420C                 ;
CODE_00C836:        9C 00 21      STZ $2100                 ;
CODE_00C839:        A9 50         LDA #$50                  ;
CODE_00C83B:        8D 07 42      STA $4207                 ;
CODE_00C83E:        A9 0E         LDA #$0E                  ;
CODE_00C840:        80 1A         BRA CODE_00C85C           ;

CODE_00C842:        3A            DEC A                     ;
CODE_00C843:        D0 1D         BNE CODE_00C862           ;
CODE_00C845:        2C 12 42      BIT $4212                 ;
CODE_00C848:        70 FB         BVS CODE_00C845           ;
CODE_00C84A:        2C 12 42      BIT $4212                 ;
CODE_00C84D:        50 FB         BVC CODE_00C84A           ;
CODE_00C84F:        AD 00 02      LDA $0200                 ;
CODE_00C852:        8D 00 21      STA $2100                 ;
CODE_00C855:        A9 50         LDA #$50                  ;
CODE_00C857:        8D 07 42      STA $4207                 ;
CODE_00C85A:        A9 C6         LDA #$C6                  ;
CODE_00C85C:        EE 25 01      INC $0125                 ;
CODE_00C85F:        4C 34 C4      JMP CODE_00C434           ;

CODE_00C862:        2C 12 42      BIT $4212                 ;
CODE_00C865:        70 FB         BVS CODE_00C862           ;
CODE_00C867:        2C 12 42      BIT $4212                 ;
CODE_00C86A:        50 FB         BVC CODE_00C867           ;
CODE_00C86C:        A0 8F         LDY #$8F                  ;
CODE_00C86E:        8C 00 21      STY $2100                 ;
CODE_00C871:        9C 0C 42      STZ $420C                 ;
CODE_00C874:        AE 1C 01      LDX $011C                 ;
CODE_00C877:        7C 7D C4      JMP ($C47D,x)             ;

CODE_00C87A:        AD 1B 01      LDA $011B                 ;
CODE_00C87D:        D0 03         BNE CODE_00C882           ;
CODE_00C87F:        4C 10 CA      JMP CODE_00CA10           ;

CODE_00C882:        9C 1B 01      STZ $011B                 ;
CODE_00C885:        20 DF E3      JSR CODE_00E3DF           ;
CODE_00C888:        20 AA E3      JSR CODE_00E3AA           ;
CODE_00C88B:        C2 20         REP #$20                  ;
CODE_00C88D:        0B            PHD                       ;
CODE_00C88E:        A9 0B 42      LDA #$420B                ;
CODE_00C891:        5B            TCD                       ;
CODE_00C892:        A2 01         LDX #$01                  ;
CODE_00C894:        20 0C DE      JSR CODE_00DE0C           ;
CODE_00C897:        20 AC D4      JSR CODE_00D4AC           ;
CODE_00C89A:        20 E5 D4      JSR CODE_00D4E5           ;
CODE_00C89D:        A0 80         LDY #$80                  ;
CODE_00C89F:        8C 15 21      STY $2115                 ;
CODE_00C8A2:        A9 01 18      LDA #$1801                ;
CODE_00C8A5:        85 F5         STA $F5                   ;
CODE_00C8A7:        AD 15 0D      LDA $0D15                 ;
CODE_00C8AA:        F0 19         BEQ CODE_00C8C5           ;
CODE_00C8AC:        A9 00 70      LDA #$7000                ;
CODE_00C8AF:        8D 16 21      STA $2116                 ;
CODE_00C8B2:        A9 00 4C      LDA #$4C00                ;
CODE_00C8B5:        85 F7         STA $F7                   ;
CODE_00C8B7:        A0 70         LDY #$70                  ;
CODE_00C8B9:        84 F9         STY $F9                   ;
CODE_00C8BB:        A9 00 08      LDA #$0800                ;
CODE_00C8BE:        85 FA         STA $FA                   ;
CODE_00C8C0:        86 00         STX $00                   ;
CODE_00C8C2:        9C 15 0D      STZ $0D15                 ;
CODE_00C8C5:        AD F9 0C      LDA $0CF9                 ;
CODE_00C8C8:        F0 16         BEQ CODE_00C8E0           ;
CODE_00C8CA:        85 FA         STA $FA                   ;
CODE_00C8CC:        A9 00 50      LDA #$5000                ;
CODE_00C8CF:        8D 16 21      STA $2116                 ;
CODE_00C8D2:        A9 00 58      LDA #$5800                ;
CODE_00C8D5:        85 F7         STA $F7                   ;
CODE_00C8D7:        A0 70         LDY #$70                  ;
CODE_00C8D9:        84 F9         STY $F9                   ;
CODE_00C8DB:        86 00         STX $00                   ;
CODE_00C8DD:        9C F9 0C      STZ $0CF9                 ;
CODE_00C8E0:        AD 85 0B      LDA $0B85                 ;
CODE_00C8E3:        D0 03         BNE CODE_00C8E8           ;
CODE_00C8E5:        4C BA C9      JMP CODE_00C9BA           ;

CODE_00C8E8:        A9 00 54      LDA #$5400                ;
CODE_00C8EB:        8D 16 21      STA $2116                 ;
CODE_00C8EE:        A0 40         LDY #$40                  ;
CODE_00C8F0:        AD 28 61      LDA $6128                 ;
CODE_00C8F3:        85 F7         STA $F7                   ;
CODE_00C8F5:        A9 53 00      LDA #$0053                ;
CODE_00C8F8:        85 F9         STA $F9                   ;
CODE_00C8FA:        84 FA         STY $FA                   ;
CODE_00C8FC:        86 00         STX $00                   ;
CODE_00C8FE:        AD 2C 61      LDA $612C                 ;
CODE_00C901:        85 F7         STA $F7                   ;
CODE_00C903:        84 FA         STY $FA                   ;
CODE_00C905:        86 00         STX $00                   ;
CODE_00C907:        AD 30 61      LDA $6130                 ;
CODE_00C90A:        85 F7         STA $F7                   ;
CODE_00C90C:        84 FA         STY $FA                   ;
CODE_00C90E:        86 00         STX $00                   ;
CODE_00C910:        AD 34 61      LDA $6134                 ;
CODE_00C913:        85 F7         STA $F7                   ;
CODE_00C915:        84 FA         STY $FA                   ;
CODE_00C917:        86 00         STX $00                   ;
CODE_00C919:        AD 38 61      LDA $6138                 ;
CODE_00C91C:        85 F7         STA $F7                   ;
CODE_00C91E:        84 FA         STY $FA                   ;
CODE_00C920:        86 00         STX $00                   ;
CODE_00C922:        AD 3C 61      LDA $613C                 ;
CODE_00C925:        85 F7         STA $F7                   ;
CODE_00C927:        84 FA         STY $FA                   ;
CODE_00C929:        86 00         STX $00                   ;
CODE_00C92B:        AD 40 61      LDA $6140                 ;
CODE_00C92E:        85 F7         STA $F7                   ;
CODE_00C930:        84 FA         STY $FA                   ;
CODE_00C932:        86 00         STX $00                   ;
CODE_00C934:        AD 44 61      LDA $6144                 ;
CODE_00C937:        85 F7         STA $F7                   ;
CODE_00C939:        84 FA         STY $FA                   ;
CODE_00C93B:        86 00         STX $00                   ;
CODE_00C93D:        A9 00 55      LDA #$5500                ;
CODE_00C940:        8D 16 21      STA $2116                 ;
CODE_00C943:        E2 20         SEP #$20                  ;
CODE_00C945:        AD 28 61      LDA $6128                 ;
CODE_00C948:        85 F7         STA $F7                   ;
CODE_00C94A:        AD 2B 61      LDA $612B                 ;
CODE_00C94D:        85 F8         STA $F8                   ;
CODE_00C94F:        84 FA         STY $FA                   ;
CODE_00C951:        86 00         STX $00                   ;
CODE_00C953:        AD 2C 61      LDA $612C                 ;
CODE_00C956:        85 F7         STA $F7                   ;
CODE_00C958:        AD 2F 61      LDA $612F                 ;
CODE_00C95B:        85 F8         STA $F8                   ;
CODE_00C95D:        84 FA         STY $FA                   ;
CODE_00C95F:        86 00         STX $00                   ;
CODE_00C961:        AD 30 61      LDA $6130                 ;
CODE_00C964:        85 F7         STA $F7                   ;
CODE_00C966:        AD 33 61      LDA $6133                 ;
CODE_00C969:        85 F8         STA $F8                   ;
CODE_00C96B:        84 FA         STY $FA                   ;
CODE_00C96D:        86 00         STX $00                   ;
CODE_00C96F:        AD 34 61      LDA $6134                 ;
CODE_00C972:        85 F7         STA $F7                   ;
CODE_00C974:        AD 37 61      LDA $6137                 ;
CODE_00C977:        85 F8         STA $F8                   ;
CODE_00C979:        84 FA         STY $FA                   ;
CODE_00C97B:        86 00         STX $00                   ;
CODE_00C97D:        AD 38 61      LDA $6138                 ;
CODE_00C980:        85 F7         STA $F7                   ;
CODE_00C982:        AD 3B 61      LDA $613B                 ;
CODE_00C985:        85 F8         STA $F8                   ;
CODE_00C987:        84 FA         STY $FA                   ;
CODE_00C989:        86 00         STX $00                   ;
CODE_00C98B:        AD 3C 61      LDA $613C                 ;
CODE_00C98E:        85 F7         STA $F7                   ;
CODE_00C990:        AD 3F 61      LDA $613F                 ;
CODE_00C993:        85 F8         STA $F8                   ;
CODE_00C995:        84 FA         STY $FA                   ;
CODE_00C997:        86 00         STX $00                   ;
CODE_00C999:        AD 40 61      LDA $6140                 ;
CODE_00C99C:        85 F7         STA $F7                   ;
CODE_00C99E:        AD 43 61      LDA $6143                 ;
CODE_00C9A1:        85 F8         STA $F8                   ;
CODE_00C9A3:        84 FA         STY $FA                   ;
CODE_00C9A5:        86 00         STX $00                   ;
CODE_00C9A7:        AD 44 61      LDA $6144                 ;
CODE_00C9AA:        85 F7         STA $F7                   ;
CODE_00C9AC:        AD 47 61      LDA $6147                 ;
CODE_00C9AF:        85 F8         STA $F8                   ;
CODE_00C9B1:        84 FA         STY $FA                   ;
CODE_00C9B3:        86 00         STX $00                   ;
CODE_00C9B5:        C2 20         REP #$20                  ;
CODE_00C9B7:        9C 85 0B      STZ $0B85                 ;

CODE_00C9BA:        2B            PLD                       ;
CODE_00C9BB:        E2 20         SEP #$20                  ;
CODE_00C9BD:        20 07 E5      JSR CODE_00E507           ;
CODE_00C9C0:        A5 39         LDA $39                   ;
CODE_00C9C2:        8D 0D 21      STA $210D                 ;
CODE_00C9C5:        A5 3A         LDA $3A                   ;
CODE_00C9C7:        8D 0D 21      STA $210D                 ;
CODE_00C9CA:        A5 3B         LDA $3B                   ;
CODE_00C9CC:        8D 0E 21      STA $210E                 ;
CODE_00C9CF:        A5 3C         LDA $3C                   ;
CODE_00C9D1:        8D 0E 21      STA $210E                 ;
CODE_00C9D4:        A5 3D         LDA $3D                   ;
CODE_00C9D6:        8D 0F 21      STA $210F                 ;
CODE_00C9D9:        A5 3E         LDA $3E                   ;
CODE_00C9DB:        8D 0F 21      STA $210F                 ;
CODE_00C9DE:        A5 3F         LDA $3F                   ;
CODE_00C9E0:        8D 10 21      STA $2110                 ;
CODE_00C9E3:        A5 40         LDA $40                   ;
CODE_00C9E5:        8D 10 21      STA $2110                 ;
CODE_00C9E8:        A5 41         LDA $41                   ;
CODE_00C9EA:        8D 11 21      STA $2111                 ;
CODE_00C9ED:        A5 42         LDA $42                   ;
CODE_00C9EF:        8D 11 21      STA $2111                 ;
CODE_00C9F2:        A5 43         LDA $43                   ;
CODE_00C9F4:        8D 12 21      STA $2112                 ;
CODE_00C9F7:        A5 44         LDA $44                   ;
CODE_00C9F9:        8D 12 21      STA $2112                 ;
CODE_00C9FC:        A5 45         LDA $45                   ;
CODE_00C9FE:        8D 13 21      STA $2113                 ;
CODE_00CA01:        A5 46         LDA $46                   ;
CODE_00CA03:        8D 13 21      STA $2113                 ;
CODE_00CA06:        A5 47         LDA $47                   ;
CODE_00CA08:        8D 14 21      STA $2114                 ;
CODE_00CA0B:        A5 48         LDA $48                   ;
CODE_00CA0D:        8D 14 21      STA $2114                 ;
CODE_00CA10:        AD 4B 09      LDA $094B                 ;
CODE_00CA13:        8D 01 21      STA $2101                 ;
CODE_00CA16:        AD 5F 09      LDA $095F                 ;
CODE_00CA19:        8D 07 21      STA $2107                 ;
CODE_00CA1C:        AD 60 09      LDA $0960                 ;
CODE_00CA1F:        8D 08 21      STA $2108                 ;
CODE_00CA22:        AD 6B 09      LDA $096B                 ;
CODE_00CA25:        8D 30 21      STA $2130                 ;
CODE_00CA28:        AD 6C 09      LDA $096C                 ;
CODE_00CA2B:        8D 31 21      STA $2131                 ;
CODE_00CA2E:        AD 5B 09      LDA $095B                 ;
CODE_00CA31:        8D 06 21      STA $2106                 ;

CODE_00CA34:        C2 20         REP #$20                  ;
CODE_00CA36:        AD 07 14      LDA $1407                 ;
CODE_00CA39:        8F 99 5B 7E   STA $7E5B99               ;
CODE_00CA3D:        8F 9C 5B 7E   STA $7E5B9C               ;
CODE_00CA41:        A9 00 43      LDA #$4300                ;
CODE_00CA44:        5B            TCD                       ;
CODE_00CA45:        A5 12         LDA $12                   ;
CODE_00CA47:        85 18         STA $18                   ;
CODE_00CA49:        A5 22         LDA $22                   ;
CODE_00CA4B:        85 28         STA $28                   ;
CODE_00CA4D:        A5 32         LDA $32                   ;
CODE_00CA4F:        85 38         STA $38                   ;
CODE_00CA51:        A5 42         LDA $42                   ;
CODE_00CA53:        85 48         STA $48                   ;
CODE_00CA55:        A5 52         LDA $52                   ;
CODE_00CA57:        85 58         STA $58                   ;
CODE_00CA59:        A5 62         LDA $62                   ;
CODE_00CA5B:        85 68         STA $68                   ;
CODE_00CA5D:        A5 72         LDA $72                   ;
CODE_00CA5F:        85 78         STA $78                   ;
CODE_00CA61:        E2 20         SEP #$20                  ;
CODE_00CA63:        A9 01         LDA #$01                  ;
CODE_00CA65:        85 1A         STA $1A                   ;
CODE_00CA67:        85 2A         STA $2A                   ;
CODE_00CA69:        85 3A         STA $3A                   ;
CODE_00CA6B:        85 4A         STA $4A                   ;
CODE_00CA6D:        85 5A         STA $5A                   ;
CODE_00CA6F:        85 6A         STA $6A                   ;
CODE_00CA71:        85 7A         STA $7A                   ;
CODE_00CA73:        9C 25 01      STZ $0125                 ;
CODE_00CA76:        A9 50         LDA #$50                  ;
CODE_00CA78:        8D 07 42      STA $4207                 ;
CODE_00CA7B:        A9 0C         LDA #$0C                  ;
CODE_00CA7D:        4C 34 C4      JMP CODE_00C434           ;

; vram address stuff?
DATA_00CA80:         dw $2000, $2000, $1000, $3000
DATA_00CA88:         dw $0000, $4000

DATA_00CA8C:         dw $96DE, $56DE, $76DE, $76DE
DATA_00CA94:         dw $56DE, $96DE

DATA_00CA98:         db $50, $52

$00/CA9A 2C 12 42    BIT $4212  [$00:4212]   ;
$00/CA9D 70 FB       BVS $FB    [$CA9A]      ;
$00/CA9F 2C 12 42    BIT $4212  [$00:4212]   ;
$00/CAA2 50 FB       BVC $FB    [$CA9F]      ;
$00/CAA4 A9 8F       LDA #$8F                ;
$00/CAA6 8D 00 21    STA $2100  [$00:2100]   ;
$00/CAA9 20 C3 D4    JSR $D4C3  [$7E:D4C3]   ;
$00/CAAC AD 69 00    LDA $0069  [$00:0069]   ;
$00/CAAF F0 46       BEQ $46    [$CAF7]      ;
$00/CAB1 0A          ASL A                   ;
$00/CAB2 0D 6D 00    ORA $006D  [$00:006D]   ;
$00/CAB5 0A          ASL A                   ;
$00/CAB6 AA          TAX                     ;
$00/CAB7 C2 20       REP #$20                ;
$00/CAB9 A0 80       LDY #$80                ;
$00/CABB 8C 15 21    STY $2115  [$00:2115]   ;
$00/CABE BF 7C CA 7E LDA $7ECA7C,x[$7E:CA7C] ;
$00/CAC2 8D 16 21    STA $2116  [$00:2116]   ;
$00/CAC5 A9 01 18    LDA #$1801              ;
$00/CAC8 8D 00 43    STA $4300  [$00:4300]   ;
$00/CACB BF 88 CA 7E LDA $7ECA88,x[$7E:CA88] ;
$00/CACF 8D 02 43    STA $4302  [$00:4302]   ;
$00/CAD2 A9 00 20    LDA #$2000              ;
$00/CAD5 8D 05 43    STA $4305  [$00:4305]   ;
$00/CAD8 A0 7F       LDY #$7F                ;
$00/CADA 8C 04 43    STY $4304  [$00:4304]   ;
$00/CADD A0 01       LDY #$01                ;
$00/CADF 8C 0B 42    STY $420B  [$00:420B]   ;

$00/CAE2 E2 20       SEP #$20                ;
$00/CAE4 CE 69 00    DEC $0069  [$00:0069]   ;
$00/CAE7 D0 13       BNE $13    [$CAFC]      ;
$00/CAE9 A6 6D       LDX $6D    [$00:006D]   ;
$00/CAEB BF 98 CA 7E LDA $7ECA98,x[$7E:CA98] ;
$00/CAEF 8D 0B 21    STA $210B  [$00:210B]   ;
$00/CAF2 8A          TXA                     ;
$00/CAF3 49 01       EOR #$01                ;
$00/CAF5 85 6D       STA $6D    [$00:006D]   ;
$00/CAF7 AD 1B 01    LDA $011B  [$00:011B]   ;
$00/CAFA D0 18       BNE $18    [$CB14]      ;
$00/CAFC 2C 12 42    BIT $4212  [$00:4212]   ;
$00/CAFF 70 FB       BVS $FB    [$CAFC]      ;
$00/CB01 2C 12 42    BIT $4212  [$00:4212]   ;
$00/CB04 50 FB       BVC $FB    [$CB01]      ;
$00/CB06 AD 00 02    LDA $0200  [$00:0200]   ;
$00/CB09 8D 00 21    STA $2100  [$00:2100]   ;
$00/CB0C A9 B1       LDA #$B1                ;
$00/CB0E 8D 00 42    STA $4200  [$00:4200]   ;
$00/CB11 4C 97 CB    JMP $CB97  [$00:CB97]   ;

$00/CB14 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/CB17 C2 20       REP #$20                ;
$00/CB19 A9 0B 42    LDA #$420B              ;
$00/CB1C 5B          TCD                     ;
$00/CB1D A2 06       LDX #$06                ;
$00/CB1F BD 93 0B    LDA $0B93,x[$00:0B93]   ;
$00/CB22 9F C2 17 70 STA $7017C2,x[$70:17C2] ;
$00/CB26 BD 9B 0B    LDA $0B9B,x[$00:0B9B]   ;
$00/CB29 9F E2 17 70 STA $7017E2,x[$70:17E2] ;
$00/CB2D CA          DEX                     ;
$00/CB2E CA          DEX                     ;
$00/CB2F 10 EE       BPL $EE    [$CB1F]      ;
$00/CB31 A2 01       LDX #$01                ;
$00/CB33 20 2B D5    JSR $D52B  [$00:D52B]   ;
$00/CB36 AD D3 0B    LDA $0BD3  [$00:0BD3]   ;
$00/CB39 F0 20       BEQ $20    [$CB5B]      ;
$00/CB3B AD D5 0B    LDA $0BD5  [$00:0BD5]   ;
$00/CB3E 8D 16 21    STA $2116  [$00:2116]   ;
$00/CB41 A9 01 18    LDA #$1801              ;
$00/CB44 85 F5       STA $F5    [$00:00F5]   ;
$00/CB46 A9 00 1C    LDA #$1C00              ;
$00/CB49 85 F7       STA $F7    [$00:00F7]   ;
$00/CB4B A0 70       LDY #$70                ;
$00/CB4D 84 F9       STY $F9    [$00:00F9]   ;
$00/CB4F AD D7 0B    LDA $0BD7  [$00:0BD7]   ;
$00/CB52 85 FA       STA $FA    [$00:00FA]   ;
$00/CB54 A0 01       LDY #$01                ;
$00/CB56 84 00       STY $00    [$00:0000]   ;
$00/CB58 9C D3 0B    STZ $0BD3  [$00:0BD3]   ;
$00/CB5B A9 00 00    LDA #$0000              ;
$00/CB5E 5B          TCD                     ;
$00/CB5F E2 20       SEP #$20                ;
$00/CB61 20 07 E5    JSR $E507  [$00:E507]   ;
$00/CB64 AD 00 02    LDA $0200  [$00:0200]   ;
$00/CB67 8D 00 21    STA $2100  [$00:2100]   ;
$00/CB6A A9 B1       LDA #$B1                ;
$00/CB6C 8D 00 42    STA $4200  [$00:4200]   ;
$00/CB6F AD 6B 00    LDA $006B  [$00:006B]   ;
$00/CB72 F0 23       BEQ $23    [$CB97]      ;
$00/CB74 9C 6B 00    STZ $006B  [$00:006B]   ;
$00/CB77 8D 69 00    STA $0069  [$00:0069]   ;
$00/CB7A C2 20       REP #$20                ;
$00/CB7C A9 DE 56    LDA #$56DE              ;
$00/CB7F 85 20       STA $20    [$00:0020]   ;
$00/CB81 A0 7F       LDY #$7F                ;
$00/CB83 84 22       STY $22    [$00:0022]   ;
$00/CB85 A9 00 1C    LDA #$1C00              ;
$00/CB88 85 23       STA $23    [$00:0023]   ;
$00/CB8A A0 70       LDY #$70                ;
$00/CB8C 84 25       STY $25    [$00:0025]   ;
$00/CB8E A9 00 60    LDA #$6000              ;
$00/CB91 22 88 82 00 JSL $008288[$00:8288]   ;
$00/CB95 E2 20       SEP #$20                ;
$00/CB97 C2 20       REP #$20                ;
$00/CB99 A5 00       LDA $00    [$00:0000]   ;
$00/CB9B 48          PHA                     ;
$00/CB9C AE 8F 0B    LDX $0B8F  [$00:0B8F]   ;
$00/CB9F AD 93 0B    LDA $0B93  [$00:0B93]   ;
$00/CBA2 18          CLC                     ;
$00/CBA3 7F 58 CC 7E ADC $7ECC58,x[$7E:CC58] ;
$00/CBA7 30 0C       BMI $0C    [$CBB5]      ;
$00/CBA9 8D 93 0B    STA $0B93  [$00:0B93]   ;
$00/CBAC 8D 97 0B    STA $0B97  [$00:0B97]   ;
$00/CBAF 8D 9D 0B    STA $0B9D  [$00:0B9D]   ;
$00/CBB2 8D 9F 0B    STA $0B9F  [$00:0B9F]   ;
$00/CBB5 A2 00       LDX #$00                ;
$00/CBB7 A9 80 F0    LDA #$F080              ;
$00/CBBA 9D 6D 09    STA $096D,x[$00:096D]   ;
$00/CBBD 9E 6F 09    STZ $096F,x[$00:096F]   ;
$00/CBC0 9D 6D 0A    STA $0A6D,x[$00:0A6D]   ;
$00/CBC3 9E 6F 0A    STZ $0A6F,x[$00:0A6F]   ;
$00/CBC6 CA          DEX                     ;
$00/CBC7 CA          DEX                     ;
$00/CBC8 CA          DEX                     ;
$00/CBC9 CA          DEX                     ;
$00/CBCA D0 EE       BNE $EE    [$CBBA]      ;
$00/CBCC AD 8D 0B    LDA $0B8D  [$00:0B8D]   ;
$00/CBCF 0A          ASL A                   ;
$00/CBD0 AA          TAX                     ;
$00/CBD1 BF C2 D2 7E LDA $7ED2C2,x[$7E:D2C2] ;
$00/CBD5 85 00       STA $00    [$00:0000]   ;
$00/CBD7 A9 7E 00    LDA #$007E              ;
$00/CBDA 85 02       STA $02    [$00:0002]   ;
$00/CBDC C2 10       REP #$10                ;
$00/CBDE A2 00 00    LDX #$0000              ;
$00/CBE1 9B          TXY                     ;
$00/CBE2 C2 20       REP #$20                ;
$00/CBE4 B7 00       LDA [$00],y[$55:5555]   ;
$00/CBE6 85 0A       STA $0A    [$00:000A]   ;
$00/CBE8 C8          INY                     ;
$00/CBE9 C8          INY                     ;
$00/CBEA E2 20       SEP #$20                ;
$00/CBEC B7 00       LDA [$00],y[$55:5555]   ;
$00/CBEE C9 FF       CMP #$FF                ;
$00/CBF0 F0 3F       BEQ $3F    [$CC31]      ;
$00/CBF2 48          PHA                     ;
$00/CBF3 29 EF       AND #$EF                ;
$00/CBF5 9D 6F 09    STA $096F,x[$00:096F]   ;
$00/CBF8 09 10       ORA #$10                ;
$00/CBFA 9D 73 09    STA $0973,x[$00:0973]   ;
$00/CBFD 68          PLA                     ;
$00/CBFE 29 10       AND #$10                ;
$00/CC00 4A          LSR A                   ;
$00/CC01 4A          LSR A                   ;
$00/CC02 4A          LSR A                   ;
$00/CC03 09 3D       ORA #$3D                ;
$00/CC05 9D 70 09    STA $0970,x[$00:0970]   ;
$00/CC08 9D 74 09    STA $0974,x[$00:0974]   ;
$00/CC0B A5 0A       LDA $0A    [$00:000A]   ;
$00/CC0D 9D 6D 09    STA $096D,x[$00:096D]   ;
$00/CC10 9D 71 09    STA $0971,x[$00:0971]   ;
$00/CC13 C8          INY                     ;
$00/CC14 18          CLC                     ;
$00/CC15 77 00       ADC [$00],y[$55:5555]   ;
$00/CC17 85 0A       STA $0A    [$00:000A]   ;
$00/CC19 A5 0B       LDA $0B    [$00:000B]   ;
$00/CC1B 9D 6E 09    STA $096E,x[$00:096E]   ;
$00/CC1E 18          CLC                     ;
$00/CC1F 69 08       ADC #$08                ;
$00/CC21 9D 72 09    STA $0972,x[$00:0972]   ;
$00/CC24 C2 20       REP #$20                ;
$00/CC26 8A          TXA                     ;
$00/CC27 18          CLC                     ;
$00/CC28 69 08 00    ADC #$0008              ;
$00/CC2B AA          TAX                     ;
$00/CC2C C8          INY                     ;
$00/CC2D E2 20       SEP #$20                ;
$00/CC2F 80 BB       BRA $BB    [$CBEC]      ;

$00/CC31 C8          INY                     ;
$00/CC32 B7 00       LDA [$00],y[$55:5555]   ;
$00/CC34 F0 1A       BEQ $1A    [$CC50]      ;
$00/CC36 C8          INY                     ;
$00/CC37 3A          DEC A                   ;
$00/CC38 F0 A8       BEQ $A8    [$CBE2]      ;
$00/CC3A 3A          DEC A                   ;
$00/CC3B F0 09       BEQ $09    [$CC46]      ;
$00/CC3D A5 0A       LDA $0A    [$00:000A]   ;
$00/CC3F 18          CLC                     ;
$00/CC40 69 08       ADC #$08                ;
$00/CC42 85 0A       STA $0A    [$00:000A]   ;
$00/CC44 80 A6       BRA $A6    [$CBEC]      ;

$00/CC46 B7 00       LDA [$00],y[$55:5555]   ;
$00/CC48 18          CLC                     ;
$00/CC49 65 0B       ADC $0B    [$00:000B]   ;
$00/CC4B 85 0B       STA $0B    [$00:000B]   ;
$00/CC4D C8          INY                     ;
$00/CC4E 80 9C       BRA $9C    [$CBEC]      ;

$00/CC50 C2 20       REP #$20                ;
$00/CC52 68          PLA                     ;
$00/CC53 85 00       STA $00    [$00:0000]   ;
$00/CC55 E2 30       SEP #$30                ;
$00/CC57 60          RTS                     ;

DATA_00CC58:         db $BE, $F7, $42, $08

; credits text
DATA_00CC5C:         dw $A857, $08DA, $08B5, $0498
DATA_00CC64:         dw $07B9, $077C, $087A, $08BB
DATA_00CC6C:         dw $089E, $07B9, $08BA, $085C
DATA_00CC74:         dw $00FF, $A449, $08F5, $0878
DATA_00CC7C:         dw $089A, $0878, $08BA, $087F
DATA_00CC84:         dw $0C98, $08F5, $077C, $08D9
DATA_00CC8C:         dw $08BC, $089A, $0878, $01FF
DATA_00CC94:         dw $B443, $08F5, $089E, $08BA
DATA_00CC9C:         dw $087F, $0498, $087F, $0498
DATA_00CCA4:         dw $089A, $109E, $08D7, $0878
DATA_00CCAC:         dw $089A, $0878, $087E, $089E
DATA_00CCB4:         dw $00FF, $A449, $08F4, $087F
DATA_00CCBC:         dw $0498, $087E, $077C, $077D
DATA_00CCC4:         dw $08BC, $089C, $0C98, $08D1
DATA_00CCCC:         dw $0498, $089D, $089E, $01FF
DATA_00CCD4:         dw $B450, $08D1, $0498, $087B
DATA_00CCDC:         dw $077C, $089A, $0C98, $08D4
DATA_00CCE4:         dw $089E, $089D, $089D, $089E
DATA_00CCEC:         dw $00FF, $A849, $08DA, $08F1
DATA_00CCF4:         dw $07B9, $089E, $087E, $07B9
DATA_00CCFC:         dw $0878, $089C, $089C, $077C
DATA_00CD04:         dw $07B9, $08BA, $085C, $00FF
DATA_00CD0C:         dw $A44A, $08F5, $089E, $08BA
DATA_00CD14:         dw $087F, $0498, $109E, $06D2
DATA_00CD1C:         dw $08BE, $0878, $08BE, $0878
DATA_00CD24:         dw $089A, $0898, $01FF, $B45A
DATA_00CD2C:         dw $08D6, $0878, $08BA, $0878
DATA_00CD34:         dw $07B9, $10BC, $08D7, $0498
DATA_00CD3C:         dw $0498, $00FF, $A452, $08D4
DATA_00CD44:         dw $0498, $08D8, $089E, $08BA
DATA_00CD4C:         dw $087F, $1098, $08D4, $089E
DATA_00CD54:         dw $087B, $0878, $01FF, $B442
DATA_00CD5C:         dw $08F4, $0878, $08BB, $089E
DATA_00CD64:         dw $07B9, $10BC, $08F5, $0878
DATA_00CD6C:         dw $089A, $0878, $087F, $0878
DATA_00CD74:         dw $08BB, $0878, $00FF, $A449
DATA_00CD7C:         dw $08D4, $0878, $08D9, $08BC
DATA_00CD84:         dw $0878, $089A, $0C98, $08D6
DATA_00CD8C:         dw $089E, $07B9, $0498, $08BB
DATA_00CD94:         dw $0878, $01FF, $B443, $081A
DATA_00CD9C:         dw $08BC, $0498, $087A, $087F
DATA_00CDA4:         dw $0C98, $081A, $0878, $089C
DATA_00CDAC:         dw $0878, $089C, $089E, $08BB
DATA_00CDB4:         dw $089E, $00FF, $A438, $08F4
DATA_00CDBC:         dw $087F, $0498, $087E, $077C
DATA_00CDC4:         dw $087F, $0498, $07B9, $109E
DATA_00CDCC:         dw $08D4, $0878, $08BA, $0878
DATA_00CDD4:         dw $089C, $0878, $08BB, $08BA
DATA_00CDDC:         dw $08BC, $01FF, $B449, $08F4
DATA_00CDE4:         dw $087F, $0498, $087E, $077C
DATA_00CDEC:         dw $089A, $0C98, $081A, $089E
DATA_00CDF4:         dw $08BA, $087F, $0498, $087B
DATA_00CDFC:         dw $0878, $00FF, $A440, $081A
DATA_00CE04:         dw $0878, $08BA, $08BC, $089D
DATA_00CE0C:         dw $089E, $07B9, $0C98, $08F5
DATA_00CE14:         dw $0878, $089A, $077C, $08BB
DATA_00CE1C:         dw $0878, $089D, $0498, $00FF
DATA_00CE24:         dw $A83D, $08DA, $08B4, $089E
DATA_00CE2C:         dw $08BC, $07B9, $08BA, $0F7C
DATA_00CE34:         dw $08B5, $077C, $08BA, $0498
DATA_00CE3C:         dw $087E, $089D, $077C, $07B9
DATA_00CE44:         dw $08BA, $085C, $00FF, $A43E
DATA_00CE4C:         dw $081A, $0878, $08BA, $08BC
DATA_00CE54:         dw $087F, $0498, $08BA, $1078
DATA_00CE5C:         dw $081A, $0878, $089C, $0878
DATA_00CE64:         dw $089C, $08BC, $07B9, $0878
DATA_00CE6C:         dw $01FF, $B45A, $08D4, $077C
DATA_00CE74:         dw $089D, $08BB, $1078, $08F6
DATA_00CE7C:         dw $08BA, $08BC, $0498, $00FF
DATA_00CE84:         dw $A442, $081A, $089E, $08BA
DATA_00CE8C:         dw $087F, $0498, $087F, $0498
DATA_00CE94:         dw $07B9, $109E, $08D7, $089E
DATA_00CE9C:         dw $089C, $089E, $08BB, $089E
DATA_00CEA4:         dw $01FF, $B460, $07B6, $0498
DATA_00CEAC:         dw $0799, $0C98, $08D7, $089E
DATA_00CEB4:         dw $08BB, $089E, $00FF, $A83F
DATA_00CEBC:         dw $08DA, $08F4, $089E, $08BC
DATA_00CEC4:         dw $089D, $107B, $08B4, $089E
DATA_00CECC:         dw $089C, $089F, $089E, $08BA
DATA_00CED4:         dw $077C, $07B9, $085C, $00FF
DATA_00CEDC:         dw $A45A, $08D4, $089E, $0799
DATA_00CEE4:         dw $0C98, $08D4, $089E, $089D
DATA_00CEEC:         dw $087B, $089E, $00FF, $A830
DATA_00CEF4:         dw $08DA, $08B4, $087F, $0878
DATA_00CEFC:         dw $07B9, $0878, $087A, $08BB
DATA_00CF04:         dw $077C, $0FB9, $08B5, $077C
DATA_00CF0C:         dw $08BA, $0498, $087E, $089D
DATA_00CF14:         dw $077C, $07B9, $08BA, $085C
DATA_00CF1C:         dw $00FF, $A44E, $08F4, $087F
DATA_00CF24:         dw $0498, $087E, $077C, $077D
DATA_00CF2C:         dw $08BC, $089C, $0C98, $08D1
DATA_00CF34:         dw $0498, $089D, $089E, $01FF
DATA_00CF3C:         dw $B44C, $08D1, $0498, $08BA
DATA_00CF44:         dw $0878, $08BA, $087F, $0C98
DATA_00CF4C:         dw $08D7, $089E, $087E, $0878
DATA_00CF54:         dw $089C, $0498, $00FF, $A44A
DATA_00CF5C:         dw $08D6, $0878, $08BA, $0878
DATA_00CF64:         dw $087F, $0498, $07B9, $109E
DATA_00CF6C:         dw $06D2, $0498, $089C, $08BC
DATA_00CF74:         dw $07B9, $0878, $01FF, $B445
DATA_00CF7C:         dw $08F5, $089E, $089C, $089E
DATA_00CF84:         dw $0878, $089A, $0C98, $08D4
DATA_00CF8C:         dw $08BC, $07B9, $089E, $08BC
DATA_00CF94:         dw $089C, $077C, $00FF, $A84B
DATA_00CF9C:         dw $08DA, $08B4, $08DB, $08D0
DATA_00CFA4:         dw $08DB, $08B5, $077C, $08BA
DATA_00CFAC:         dw $0498, $087E, $089D, $077C
DATA_00CFB4:         dw $07B9, $085C, $00FF, $A448
DATA_00CFBC:         dw $081A, $089E, $08BA, $087F
DATA_00CFC4:         dw $0498, $0878, $089A, $0C98
DATA_00CFCC:         dw $08D4, $089E, $0498, $08D9
DATA_00CFD4:         dw $08BC, $089C, $0498, $00FF
DATA_00CFDC:         dw $A838, $08DA, $08F4, $089F
DATA_00CFE4:         dw $077C, $087A, $0498, $0878
DATA_00CFEC:         dw $0C9B, $08F5, $087F, $0878
DATA_00CFF4:         dw $089D, $089A, $10BA, $08F5
DATA_00CFFC:         dw $089E, $085C, $00FF, $A443
DATA_00D004:         dw $0818, $0878, $08BB, $0878
DATA_00D00C:         dw $07B9, $10BC, $081A, $0878
DATA_00D014:         dw $089C, $0878, $087E, $08BC
DATA_00D01C:         dw $087A, $087F, $0498, $01FF
DATA_00D024:         dw $B445, $081A, $089E, $08BA
DATA_00D02C:         dw $087F, $0498, $089A, $0C98
DATA_00D034:         dw $08D1, $0878, $07B9, $08BC
DATA_00D03C:         dw $087F, $0878, $089D, $0878
DATA_00D044:         dw $00FF, $A450, $081A, $089E
DATA_00D04C:         dw $0498, $087A, $087F, $0C98
DATA_00D054:         dw $08D4, $089E, $08BB, $0878
DATA_00D05C:         dw $0879, $077C, $01FF, $B44B
DATA_00D064:         dw $081A, $0878, $08BA, $08BC
DATA_00D06C:         dw $087F, $0498, $07B9, $109E
DATA_00D074:         dw $08F4, $0878, $089A, $0878
DATA_00D07C:         dw $0498, $00FF, $A44B, $08D1
DATA_00D084:         dw $0498, $07B9, $089E, $089D
DATA_00D08C:         dw $089E, $0879, $10BC, $08D4
DATA_00D094:         dw $0878, $089A, $08BC, $0498
DATA_00D09C:         dw $01FF, $B440, $08F4, $087F
DATA_00D0A4:         dw $0498, $087E, $077C, $089A
DATA_00D0AC:         dw $0C98, $081A, $0878, $089C
DATA_00D0B4:         dw $0878, $08BA, $087F, $0498
DATA_00D0BC:         dw $07B9, $089E, $00FF, $A44C
DATA_00D0C4:         dw $08D4, $0498, $089C, $0498
DATA_00D0CC:         dw $08D8, $089E, $08BA, $087F
DATA_00D0D4:         dw $0C98, $07B7, $08BC, $089A
DATA_00D0DC:         dw $08BC, $0498, $01FF, $B45B
DATA_00D0E4:         dw $08D4, $077C, $0498, $08D9
DATA_00D0EC:         dw $109E, $08D4, $0878, $08BB
DATA_00D0F4:         dw $089E, $00FF, $A449, $08F4
DATA_00D0FC:         dw $089E, $0498, $087A, $087F
DATA_00D104:         dw $0498, $07B9, $109E, $08F5
DATA_00D10C:         dw $089E, $089C, $0498, $08BB
DATA_00D114:         dw $0878, $01FF, $B44F, $08D6
DATA_00D11C:         dw $0498, $0F7C, $081A, $089E
DATA_00D124:         dw $08BA, $087F, $0498, $089C
DATA_00D12C:         dw $08BC, $07B9, $0878, $00FF
DATA_00D134:         dw $A449, $08D4, $077C, $089D
DATA_00D13C:         dw $08BA, $08BC, $089A, $0F7C
DATA_00D144:         dw $08F5, $0878, $089D, $0878
DATA_00D14C:         dw $0879, $077C, $01FF, $B445
DATA_00D154:         dw $08F5, $077C, $08BB, $08BA
DATA_00D15C:         dw $10BC, $08D1, $0878, $08BA
DATA_00D164:         dw $087F, $0498, $089C, $089E
DATA_00D16C:         dw $08BB, $089E, $00FF, $A451
DATA_00D174:         dw $08B5, $077C, $07B9, $077C
DATA_00D17C:         dw $0F9A, $0818, $087F, $0498
DATA_00D184:         dw $089F, $089F, $049B, $077C
DATA_00D18C:         dw $01FF, $B457, $08D1, $0498
DATA_00D194:         dw $07B9, $109E, $081A, $0878
DATA_00D19C:         dw $089C, $0878, $087B, $0878
DATA_00D1A4:         dw $00FF, $A858, $08DA, $08F1
DATA_00D1AC:         dw $07B9, $089E, $087B, $08BC
DATA_00D1B4:         dw $087A, $077C, $07B9, $085C
DATA_00D1BC:         dw $00FF, $A443, $08F4, $087F
DATA_00D1C4:         dw $0498, $087E, $077C, $07B9
DATA_00D1CC:         dw $10BC, $08D6, $0498, $08D8
DATA_00D1D4:         dw $0878, $089C, $089E, $08BB
DATA_00D1DC:         dw $089E, $00FF, $A834, $08DA
DATA_00D1E4:         dw $07B6, $08BF, $077C, $087A
DATA_00D1EC:         dw $08BC, $08BB, $0498, $08BD
DATA_00D1F4:         dw $0F7C, $08F1, $07B9, $089E
DATA_00D1FC:         dw $087B, $08BC, $087A, $077C
DATA_00D204:         dw $07B9, $085C, $00FF, $A446
DATA_00D20C:         dw $08D1, $0498, $07B9, $089E
DATA_00D214:         dw $08BA, $087F, $0C98, $081A
DATA_00D21C:         dw $0878, $089C, $0878, $08BC
DATA_00D224:         dw $087A, $087F, $0498, $00FF
DATA_00D22C:         dw $A41E, $07D5, $089E, $089E
DATA_00D234:         dw $089A, $10BA, $049B, $0498
DATA_00D23C:         dw $089A, $0F7C, $08BB, $087F
DATA_00D244:         dw $077C, $10D8, $087F, $0878
DATA_00D24C:         dw $08BD, $0F7C, $0878, $07B9
DATA_00D254:         dw $07B9, $0498, $08BD, $077C
DATA_00D25C:         dw $087B, $01FF, $B424, $08BE
DATA_00D264:         dw $087F, $077C, $07B9, $0F7C
DATA_00D26C:         dw $089C, $089E, $109C, $0878
DATA_00D274:         dw $089D, $107B, $087B, $0878
DATA_00D27C:         dw $107B, $049B, $0498, $08BD
DATA_00D284:         dw $077C, $08DB, $08DB, $08DB
DATA_00D28C:         dw $08DB, $00FF, $A442, $08D1
DATA_00D294:         dw $077C, $07B9, $089E, $077C
DATA_00D29C:         dw $10BA, $0878, $07B9, $0F7C
DATA_00D2A4:         dw $0879, $089E, $07B9, $089D
DATA_00D2AC:         dw $081F, $081F, $00FF, $A462
DATA_00D2B4:         dw $08F5, $08D1, $0FB6, $07B6
DATA_00D2BC:         dw $08D7, $08B5, $00FF

; credits text pointers
DATA_00D2C2:         dw $CC5C, $CC5C, $CC76, $CCB6
DATA_00D2CA:         dw $CCEE, $CD0C, $CD40, $CD7A
DATA_00D2D2:         dw $CDB8, $CE00, $CE24, $CE4A
DATA_00D2DA:         dw $CE84, $CEBA, $CEDC, $CEF2
DATA_00D2E2:         dw $CF1E, $CF5A, $CF9A, $CFBA
DATA_00D2EA:         dw $CFDC, $D002, $D046, $D080
DATA_00D2F2:         dw $D0C2, $D0F8, $D134, $D172
DATA_00D2FA:         dw $D1A6, $D1BE, $D1E0, $D20A
DATA_00D302:         dw $D22C, $D290, $D2B2

$00/D308 AD 25 01    LDA $0125  [$00:0125]   ;
$00/D30B D0 1C       BNE $1C    [$D329]      ;
$00/D30D 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D310 70 FB       BVS $FB    [$D30D]      ;
$00/D312 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D315 50 FB       BVC $FB    [$D312]      ;
$00/D317 AD 4A 09    LDA $094A  [$00:094A]   ;
$00/D31A 8D 0C 42    STA $420C  [$00:420C]   ;
$00/D31D 9C 00 21    STZ $2100  [$00:2100]   ;
$00/D320 A9 50       LDA #$50                ;
$00/D322 8D 07 42    STA $4207  [$00:4207]   ;
$00/D325 A9 08       LDA #$08                ;
$00/D327 80 1A       BRA $1A    [$D343]      ;

$00/D329 3A          DEC A                   ;
$00/D32A D0 23       BNE $23    [$D34F]      ;
$00/D32C 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D32F 70 FB       BVS $FB    [$D32C]      ;
$00/D331 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D334 50 FB       BVC $FB    [$D331]      ;
$00/D336 AD 00 02    LDA $0200  [$00:0200]   ;
$00/D339 8D 00 21    STA $2100  [$00:2100]   ;
$00/D33C A9 50       LDA #$50                ;
$00/D33E 8D 07 42    STA $4207  [$00:4207]   ;
$00/D341 A9 D8       LDA #$D8                ;
$00/D343 EE 25 01    INC $0125  [$00:0125]   ;
$00/D346 8D 09 42    STA $4209  [$00:4209]   ;
$00/D349 A9 B1       LDA #$B1                ;
$00/D34B 8D 00 42    STA $4200  [$00:4200]   ;
$00/D34E 60          RTS                     ;

$00/D34F 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D352 70 FB       BVS $FB    [$D34F]      ;
$00/D354 2C 12 42    BIT $4212  [$00:4212]   ;
$00/D357 50 FB       BVC $FB    [$D354]      ;
$00/D359 A0 8F       LDY #$8F                ;
$00/D35B 8C 00 21    STY $2100  [$00:2100]   ;
$00/D35E 9C 0C 42    STZ $420C  [$00:420C]   ;
$00/D361 AD 1B 01    LDA $011B  [$00:011B]   ;
$00/D364 D0 03       BNE $03    [$D369]      ;
$00/D366 4C 6B D4    JMP $D46B  [$00:D46B]   ;

$00/D369 9C 1B 01    STZ $011B  [$00:011B]   ;
$00/D36C 20 DF E3    JSR $E3DF  [$00:E3DF]   ;
$00/D36F 20 AA E3    JSR $E3AA  [$00:E3AA]   ;
$00/D372 C2 20       REP #$20                ;
$00/D374 0B          PHD                     ;
$00/D375 A9 0B 42    LDA #$420B              ;
$00/D378 5B          TCD                     ;
$00/D379 A2 01       LDX #$01                ;
$00/D37B 20 0C DE    JSR $DE0C  [$00:DE0C]   ;
$00/D37E 20 AC D4    JSR $D4AC  [$00:D4AC]   ;
$00/D381 20 E5 D4    JSR $D4E5  [$00:D4E5]   ;
$00/D384 A0 80       LDY #$80                ;
$00/D386 8C 15 21    STY $2115  [$00:2115]   ;
$00/D389 A9 01 18    LDA #$1801              ;
$00/D38C 85 F5       STA $F5    [$00:00F5]   ;
$00/D38E 20 AE DC    JSR $DCAE  [$00:DCAE]   ;
$00/D391 AC 15 0D    LDY $0D15  [$00:0D15]   ;
$00/D394 F0 08       BEQ $08    [$D39E]      ;
$00/D396 20 97 DC    JSR $DC97  [$00:DC97]   ;
$00/D399 9C 15 0D    STZ $0D15  [$00:0D15]   ;
$00/D39C 80 03       BRA $03    [$D3A1]      ;

$00/D39E 20 6B DC    JSR $DC6B  [$00:DC6B]   ;
$00/D3A1 AD 18 01    LDA $0118  [$00:0118]   ;
$00/D3A4 C9 30 00    CMP #$0030              ;
$00/D3A7 D0 1A       BNE $1A    [$D3C3]      ;
$00/D3A9 AD 4A 09    LDA $094A  [$00:094A]   ;
$00/D3AC 29 20 00    AND #$0020              ;
$00/D3AF F0 0F       BEQ $0F    [$D3C0]      ;
$00/D3B1 AD E0 10    LDA $10E0  [$00:10E0]   ;
$00/D3B4 8F 40 50 7E STA $7E5040[$7E:5040]   ;
$00/D3B8 49 FF FF    EOR #$FFFF              ;
$00/D3BB 1A          INC A                   ;
$00/D3BC 8F 42 50 7E STA $7E5042[$7E:5042]   ;
$00/D3C0 20 A9 DB    JSR $DBA9  [$00:DBA9]   ;
$00/D3C3 2B          PLD                     ;
$00/D3C4 E2 20       SEP #$20                ;
$00/D3C6 A5 39       LDA $39    [$00:0039]   ;
$00/D3C8 8D 0D 21    STA $210D  [$00:210D]   ;
$00/D3CB A5 3A       LDA $3A    [$00:003A]   ;
$00/D3CD 8D 0D 21    STA $210D  [$00:210D]   ;
$00/D3D0 A5 3B       LDA $3B    [$00:003B]   ;
$00/D3D2 8D 0E 21    STA $210E  [$00:210E]   ;
$00/D3D5 A5 3C       LDA $3C    [$00:003C]   ;
$00/D3D7 8D 0E 21    STA $210E  [$00:210E]   ;
$00/D3DA A5 3D       LDA $3D    [$00:003D]   ;
$00/D3DC 8D 0F 21    STA $210F  [$00:210F]   ;
$00/D3DF A5 3E       LDA $3E    [$00:003E]   ;
$00/D3E1 8D 0F 21    STA $210F  [$00:210F]   ;
$00/D3E4 A5 3F       LDA $3F    [$00:003F]   ;
$00/D3E6 8D 10 21    STA $2110  [$00:2110]   ;
$00/D3E9 A5 40       LDA $40    [$00:0040]   ;
$00/D3EB 8D 10 21    STA $2110  [$00:2110]   ;
$00/D3EE A5 41       LDA $41    [$00:0041]   ;
$00/D3F0 8D 11 21    STA $2111  [$00:2111]   ;
$00/D3F3 A5 42       LDA $42    [$00:0042]   ;
$00/D3F5 8D 11 21    STA $2111  [$00:2111]   ;
$00/D3F8 A5 43       LDA $43    [$00:0043]   ;
$00/D3FA 8D 12 21    STA $2112  [$00:2112]   ;
$00/D3FD A5 44       LDA $44    [$00:0044]   ;
$00/D3FF 8D 12 21    STA $2112  [$00:2112]   ;
$00/D402 AD 67 09    LDA $0967  [$00:0967]   ;
$00/D405 8D 2C 21    STA $212C  [$00:212C]   ;
$00/D408 AD 68 09    LDA $0968  [$00:0968]   ;
$00/D40B 8D 2D 21    STA $212D  [$00:212D]   ;
$00/D40E AD 69 09    LDA $0969  [$00:0969]   ;
$00/D411 8D 2E 21    STA $212E  [$00:212E]   ;
$00/D414 AD 6A 09    LDA $096A  [$00:096A]   ;
$00/D417 8D 2F 21    STA $212F  [$00:212F]   ;
$00/D41A AD 62 09    LDA $0962  [$00:0962]   ;
$00/D41D 8D 0B 21    STA $210B  [$00:210B]   ;
$00/D420 AD 5F 09    LDA $095F  [$00:095F]   ;
$00/D423 8D 07 21    STA $2107  [$00:2107]   ;
$00/D426 AD 5E 09    LDA $095E  [$00:095E]   ;
$00/D429 8D 05 21    STA $2105  [$00:2105]   ;
$00/D42C AD 64 09    LDA $0964  [$00:0964]   ;
$00/D42F 8D 23 21    STA $2123  [$00:2123]   ;
$00/D432 AD 65 09    LDA $0965  [$00:0965]   ;
$00/D435 8D 24 21    STA $2124  [$00:2124]   ;
$00/D438 AD 66 09    LDA $0966  [$00:0966]   ;
$00/D43B 8D 25 21    STA $2125  [$00:2125]   ;
$00/D43E AD 6B 09    LDA $096B  [$00:096B]   ;
$00/D441 8D 30 21    STA $2130  [$00:2130]   ;
$00/D444 AD 6C 09    LDA $096C  [$00:096C]   ;
$00/D447 8D 31 21    STA $2131  [$00:2131]   ;
$00/D44A AD 4C 09    LDA $094C  [$00:094C]   ;
$00/D44D 8D 2A 21    STA $212A  [$00:212A]   ;
$00/D450 AD 4D 09    LDA $094D  [$00:094D]   ;
$00/D453 8D 2B 21    STA $212B  [$00:212B]   ;
$00/D456 AD 60 09    LDA $0960  [$00:0960]   ;
$00/D459 8D 08 21    STA $2108  [$00:2108]   ;
$00/D45C AD 61 09    LDA $0961  [$00:0961]   ;
$00/D45F 8D 09 21    STA $2109  [$00:2109]   ;
$00/D462 AD 5B 09    LDA $095B  [$00:095B]   ;
$00/D465 8D 06 21    STA $2106  [$00:2106]   ;
$00/D468 20 07 E5    JSR $E507  [$00:E507]   ;
$00/D46B C2 20       REP #$20                ;
$00/D46D A9 00 43    LDA #$4300              ;
$00/D470 5B          TCD                     ;
$00/D471 A5 12       LDA $12    [$00:0012]   ;
$00/D473 85 18       STA $18    [$00:0018]   ;
$00/D475 A5 22       LDA $22    [$00:0022]   ;
$00/D477 85 28       STA $28    [$00:0028]   ;
$00/D479 A5 32       LDA $32    [$00:0032]   ;
$00/D47B 85 38       STA $38    [$00:0038]   ;
$00/D47D A5 42       LDA $42    [$00:0042]   ;
$00/D47F 85 48       STA $48    [$00:0048]   ;
$00/D481 A5 52       LDA $52    [$00:0052]   ;
$00/D483 85 58       STA $58    [$00:0058]   ;
$00/D485 A5 62       LDA $62    [$00:0062]   ;
$00/D487 85 68       STA $68    [$00:0068]   ;
$00/D489 A5 72       LDA $72    [$00:0072]   ;
$00/D48B 85 78       STA $78    [$00:0078]   ;
$00/D48D E2 20       SEP #$20                ;
$00/D48F A9 01       LDA #$01                ;
$00/D491 85 1A       STA $1A    [$00:001A]   ;
$00/D493 85 2A       STA $2A    [$00:002A]   ;
$00/D495 85 3A       STA $3A    [$00:003A]   ;
$00/D497 85 4A       STA $4A    [$00:004A]   ;
$00/D499 85 5A       STA $5A    [$00:005A]   ;
$00/D49B 85 6A       STA $6A    [$00:006A]   ;
$00/D49D 85 7A       STA $7A    [$00:007A]   ;
$00/D49F 9C 25 01    STZ $0125  [$00:0125]   ;
$00/D4A2 A9 50       LDA #$50                ;
$00/D4A4 8D 07 42    STA $4207  [$00:4207]   ;
$00/D4A7 A9 06       LDA #$06                ;
$00/D4A9 4C 46 D3    JMP $D346  [$00:D346]   ;

$00/D4AC 9C 02 21    STZ $2102  [$04:2102]   ;
$00/D4AF 64 F5       STZ $F5    [$00:00F5]   ;
$00/D4B1 A9 04 00    LDA #$0004              ;
$00/D4B4 85 F6       STA $F6    [$00:00F6]   ;
$00/D4B6 A9 6A 00    LDA #$006A              ;
$00/D4B9 85 F8       STA $F8    [$00:00F8]   ;
$00/D4BB A9 20 02    LDA #$0220              ;
$00/D4BE 85 FA       STA $FA    [$00:00FA]   ;
$00/D4C0 86 00       STX $00    [$00:0000]   ;
$00/D4C2 60          RTS                     ;

$00/D4C3 C2 20       REP #$20                ;
$00/D4C5 9C 02 21    STZ $2102  [$00:2102]   ;
$00/D4C8 9C 00 43    STZ $4300  [$00:4300]   ;
$00/D4CB A9 04 6D    LDA #$6D04              ;
$00/D4CE 8D 01 43    STA $4301  [$00:4301]   ;
$00/D4D1 A9 09 00    LDA #$0009              ;
$00/D4D4 8D 03 43    STA $4303  [$00:4303]   ;
$00/D4D7 A9 20 02    LDA #$0220              ;
$00/D4DA 8D 05 43    STA $4305  [$00:4305]   ;
$00/D4DD A2 01       LDX #$01                ;
$00/D4DF 8E 0B 42    STX $420B  [$00:420B]   ;
$00/D4E2 E2 20       SEP #$20                ;
$00/D4E4 60          RTS                     ;

$00/D4E5 AD 48 09    LDA $0948  [$04:0948]   ;\
$00/D4E8 29 1F 00    AND #$001F              ; |
$00/D4EB 09 20 00    ORA #$0020              ; |
$00/D4EE A8          TAY                     ; |
$00/D4EF 8C 32 21    STY $2132  [$04:2132]   ; |
$00/D4F2 AD 48 09    LDA $0948  [$04:0948]   ; |
$00/D4F5 4A          LSR A                   ; |
$00/D4F6 4A          LSR A                   ; |
$00/D4F7 4A          LSR A                   ; |
$00/D4F8 4A          LSR A                   ; |
$00/D4F9 4A          LSR A                   ; |
$00/D4FA 29 1F 00    AND #$001F              ; |
$00/D4FD 09 40 00    ORA #$0040              ; |
$00/D500 A8          TAY                     ; |
$00/D501 8C 32 21    STY $2132  [$04:2132]   ; |
$00/D504 AD 49 09    LDA $0949  [$04:0949]   ; |
$00/D507 4A          LSR A                   ; |
$00/D508 4A          LSR A                   ; |
$00/D509 09 80 00    ORA #$0080              ; |
$00/D50C A8          TAY                     ; |
$00/D50D 8C 32 21    STY $2132  [$04:2132]   ;/

; dp = #$420B
$00/D510 A0 00       LDY #$00                ;\ starting address in CGRAM
$00/D512 8C 21 21    STY $2121  [$04:2121]   ;/
$00/D515 A9 00 22    LDA #$2200              ;\ set destination to $2122
$00/D518 85 F5       STA $F5    [$00:00F5]   ;/
$00/D51A A9 00 20    LDA #$2000              ;\
$00/D51D 85 F7       STA $F7    [$00:00F7]   ; | set source address ($702000)
$00/D51F A0 70       LDY #$70                ; |
$00/D521 84 F9       STY $F9    [$00:00F9]   ;/
$00/D523 A9 00 02    LDA #$0200              ;\ transfer $0200 bytes
$00/D526 85 FA       STA $FA    [$00:00FA]   ;/
$00/D528 86 00       STX $00    [$00:0000]   ; begin DMA
$00/D52A 60          RTS                     ;

$00/D52B AD 48 09    LDA $0948  [$04:0948]   ;
$00/D52E 29 1F 00    AND #$001F              ;
$00/D531 09 20 00    ORA #$0020              ;
$00/D534 A8          TAY                     ;
$00/D535 8C 32 21    STY $2132  [$04:2132]   ;
$00/D538 AD 48 09    LDA $0948  [$04:0948]   ;
$00/D53B 4A          LSR A                   ;
$00/D53C 4A          LSR A                   ;
$00/D53D 4A          LSR A                   ;
$00/D53E 4A          LSR A                   ;
$00/D53F 4A          LSR A                   ;
$00/D540 29 1F 00    AND #$001F              ;
$00/D543 09 40 00    ORA #$0040              ;
$00/D546 A8          TAY                     ;
$00/D547 8C 32 21    STY $2132  [$04:2132]   ;
$00/D54A AD 49 09    LDA $0949  [$04:0949]   ;
$00/D54D 4A          LSR A                   ;
$00/D54E 4A          LSR A                   ;
$00/D54F 09 80 00    ORA #$0080              ;
$00/D552 A8          TAY                     ;
$00/D553 8C 32 21    STY $2132  [$04:2132]   ;
$00/D556 A0 00       LDY #$00                ;
$00/D558 8C 21 21    STY $2121  [$04:2121]   ;
$00/D55B A9 00 22    LDA #$2200              ;
$00/D55E 85 F5       STA $F5    [$00:00F5]   ;
$00/D560 A9 00 16    LDA #$1600              ;
$00/D563 85 F7       STA $F7    [$00:00F7]   ;
$00/D565 A0 70       LDY #$70                ;
$00/D567 84 F9       STY $F9    [$00:00F9]   ;
$00/D569 A9 00 02    LDA #$0200              ;
$00/D56C 85 FA       STA $FA    [$00:00FA]   ;
$00/D56E 86 00       STX $00    [$00:0000]   ;
$00/D570 60          RTS                     ;

$00/D571 8B          PHB                     ;
$00/D572 0B          PHD                     ;
$00/D573 4B          PHK                     ;
$00/D574 AB          PLB                     ;
$00/D575 C2 20       REP #$20                ;
$00/D577 A9 0B 42    LDA #$420B              ;
$00/D57A 5B          TCD                     ;
$00/D57B A2 01       LDX #$01                ;
$00/D57D A0 80       LDY #$80                ;
$00/D57F 8C 15 21    STY $2115  [$00:2115]   ;
$00/D582 A9 01 18    LDA #$1801              ;
$00/D585 85 F5       STA $F5    [$00:00F5]   ;
$00/D587 A9 20 00    LDA #$0020              ;
$00/D58A 8D 00 00    STA $0000  [$00:0000]   ;
$00/D58D EE 74 79    INC $7974  [$00:7974]   ;
$00/D590 20 5D D6    JSR $D65D  [$00:D65D]   ;
$00/D593 CE 00 00    DEC $0000  [$00:0000]   ;
$00/D596 D0 F5       BNE $F5    [$D58D]      ;
$00/D598 E2 20       SEP #$20                ;
$00/D59A 2B          PLD                     ;
$00/D59B AB          PLB                     ;
$00/D59C 6B          RTL                     ;

; vram address stuff?
DATA_00D59D:         dw $1400, $1400, $1440, $1440
DATA_00D5A5:         dw $1480, $1480, $14C0, $14C0
DATA_00D5AD:         dw $1400, $1400, $1440, $1440
DATA_00D5B5:         dw $1480, $1480, $14C0, $14C0
DATA_00D5BD:         dw $1400, $1400, $1440, $1440
DATA_00D5C5:         dw $1480, $1480, $14C0, $14C0
DATA_00D5CD:         dw $1400, $1400, $1440, $1440
DATA_00D5D5:         dw $1480, $1480, $14C0, $14C0

DATA_00D5DD:         dw $C000, $C000, $C400, $C100
DATA_00D5E5:         dw $C500, $C000, $C400, $A880
DATA_00D5ED:         dw $C080, $C080, $C480, $C180
DATA_00D5F5:         dw $C580, $C080, $C480, $AA80
DATA_00D5FD:         dw $C200, $C200, $C600, $C300
DATA_00D605:         dw $C700, $C200, $C600, $AC80
DATA_00D60D:         dw $C280, $C280, $C680, $C380
DATA_00D615:         dw $C780, $C280, $C680, $AE80

DATA_00D61D:         dw $0000, $0000, $0008, $0000
DATA_00D625:         dw $0008, $0000, $0010, $0000
DATA_00D62D:         dw $0000, $0000, $0008, $0000
DATA_00D635:         dw $0008, $0000, $0010, $0000
DATA_00D63D:         dw $0000, $0000, $0008, $0000
DATA_00D645:         dw $0008, $0000, $0010, $0000
DATA_00D64D:         dw $0000, $0000, $0008, $0000
DATA_00D655:         dw $0008, $0000, $0010, $0000

$00/D65D AD B0 61    LDA $61B0  [$04:61B0]   ;
$00/D660 D0 03       BNE $03    [$D665]      ;
$00/D662 EE 6D 0B    INC $0B6D  [$04:0B6D]   ;
$00/D665 AD 48 01    LDA $0148  [$04:0148]   ;
$00/D668 0A          ASL A                   ;
$00/D669 AA          TAX                     ;
$00/D66A FC C2 D6    JSR ($D6C2,x)[$04:9BBD] ;
$00/D66D AD 74 79    LDA $7974  [$04:7974]   ;
$00/D670 29 1E 00    AND #$001E              ;
$00/D673 0A          ASL A                   ;
$00/D674 A8          TAY                     ;
$00/D675 AD 08 7E    LDA $7E08  [$04:7E08]   ;
$00/D678 39 1D D6    AND $D61D,y[$04:D61D]   ;
$00/D67B F0 02       BEQ $02    [$D67F]      ;
$00/D67D C8          INY                     ;
$00/D67E C8          INY                     ;
$00/D67F B9 9D D5    LDA $D59D,y[$04:D59D]   ;
$00/D682 8D 16 21    STA $2116  [$04:2116]   ;
$00/D685 B9 DD D5    LDA $D5DD,y[$04:D5DD]   ;
$00/D688 85 F7       STA $F7    [$00:00F7]   ;
$00/D68A A0 52       LDY #$52                ;
$00/D68C 84 F9       STY $F9    [$00:00F9]   ;
$00/D68E A0 80       LDY #$80                ;
$00/D690 84 FA       STY $FA    [$00:00FA]   ;
$00/D692 86 00       STX $00    [$00:0000]   ;
$00/D694 AD FB 0C    LDA $0CFB  [$04:0CFB]   ;
$00/D697 F0 28       BEQ $28    [$D6C1]      ;
$00/D699 A9 80 12    LDA #$1280              ;
$00/D69C 8D 16 21    STA $2116  [$04:2116]   ;
$00/D69F A9 C0 60    LDA #$60C0              ;
$00/D6A2 85 F7       STA $F7    [$00:00F7]   ;
$00/D6A4 A0 70       LDY #$70                ;
$00/D6A6 84 F9       STY $F9    [$00:00F9]   ;
$00/D6A8 A9 00 01    LDA #$0100              ;
$00/D6AB 85 FA       STA $FA    [$00:00FA]   ;
$00/D6AD 86 00       STX $00    [$00:0000]   ;
$00/D6AF 85 FA       STA $FA    [$00:00FA]   ;
$00/D6B1 A9 80 13    LDA #$1380              ;
$00/D6B4 8D 16 21    STA $2116  [$04:2116]   ;
$00/D6B7 A9 C0 62    LDA #$62C0              ;
$00/D6BA 85 F7       STA $F7    [$00:00F7]   ;
$00/D6BC 86 00       STX $00    [$00:0000]   ;
$00/D6BE 9C FB 0C    STZ $0CFB  [$04:0CFB]   ;
$00/D6C1 60          RTS                     ;

DATA_00D6C2:         dw $D6EA, $D713, $D765, $D7B4
DATA_00D6CA:         dw $D6E6, $D7F1, $D81E, $D898
DATA_00D6D2:         dw $D92D, $D977, $D99C, $D9F6
DATA_00D6DA:         dw $DA65, $DAE4, $DB06, $DB1C
DATA_00D6E2:         dw $DB54, $DB86

$00/D6E6 68          PLA                     ;
$00/D6E7 A2 01       LDX #$01                ;
$00/D6E9 60          RTS                     ;

$00/D6EA AD 74 79    LDA $7974  [$04:7974]   ;
$00/D6ED 29 07 00    AND #$0007              ;
$00/D6F0 EB          XBA                     ;
$00/D6F1 4A          LSR A                   ;
$00/D6F2 09 00 10    ORA #$1000              ;
$00/D6F5 8D 16 21    STA $2116  [$04:2116]   ;
$00/D6F8 A9 00 B4    LDA #$B400              ;
$00/D6FB 85 F7       STA $F7    [$00:00F7]   ;
$00/D6FD A2 52       LDX #$52                ;
$00/D6FF 86 F9       STX $F9    [$00:00F9]   ;
$00/D701 A9 00 01    LDA #$0100              ;
$00/D704 85 FA       STA $FA    [$00:00FA]   ;
$00/D706 A2 01       LDX #$01                ;
$00/D708 86 00       STX $00    [$00:0000]   ;
$00/D70A 60          RTS                     ;

DATA_00D70B:         dw $8800, $8A00, $8C00, $8E00

$00/D713 A9 00 2F    LDA #$2F00              ;
$00/D716 8D 16 21    STA $2116  [$04:2116]   ;
$00/D719 A9 00 02    LDA #$0200              ;
$00/D71C 85 FA       STA $FA    [$00:00FA]   ;
$00/D71E A0 56       LDY #$56                ;
$00/D720 84 F9       STY $F9    [$00:00F9]   ;
$00/D722 AD 74 79    LDA $7974  [$04:7974]   ;
$00/D725 4A          LSR A                   ;
$00/D726 4A          LSR A                   ;
$00/D727 29 06 00    AND #$0006              ;
$00/D72A A8          TAY                     ;
$00/D72B B9 0B D7    LDA $D70B,y[$04:D70B]   ;
$00/D72E 85 F7       STA $F7    [$00:00F7]   ;
$00/D730 A2 01       LDX #$01                ;
$00/D732 86 00       STX $00    [$00:0000]   ;
$00/D734 60          RTS                     ;

DATA_00D735:         dw $1000, $1080, $1200, $1280

DATA_00D73D:         dw $1100, $1180, $1300, $1380

DATA_00D745:         dw $D000, $D800, $C000, $C000
DATA_00D74D:         dw $D200, $DA00, $C000, $C000
DATA_00D755:         dw $D400, $DC00, $C000, $C000
DATA_00D75D:         dw $D600, $DE00, $C000, $C000

$00/D765 AD 74 79    LDA $7974  [$04:7974]   ;
$00/D768 29 1E 00    AND #$001E              ;
$00/D76B A8          TAY                     ;
$00/D76C B9 45 D7    LDA $D745,y[$04:D745]   ;
$00/D76F 85 F7       STA $F7    [$00:00F7]   ;
$00/D771 A2 52       LDX #$52                ;
$00/D773 86 F9       STX $F9    [$00:00F9]   ;
$00/D775 98          TYA                     ;
$00/D776 29 06 00    AND #$0006              ;
$00/D779 A8          TAY                     ;
$00/D77A B9 35 D7    LDA $D735,y[$04:D735]   ;
$00/D77D 8D 16 21    STA $2116  [$04:2116]   ;
$00/D780 A9 00 01    LDA #$0100              ;
$00/D783 85 FA       STA $FA    [$00:00FA]   ;
$00/D785 A2 01       LDX #$01                ;
$00/D787 86 00       STX $00    [$00:0000]   ;
$00/D789 85 FA       STA $FA    [$00:00FA]   ;
$00/D78B B9 3D D7    LDA $D73D,y[$04:D73D]   ;
$00/D78E 8D 16 21    STA $2116  [$04:2116]   ;
$00/D791 86 00       STX $00    [$00:0000]   ;
$00/D793 60          RTS                     ;

DATA_00D794:         dw $9000, $9000, $9000, $9000
DATA_00D79C:         dw $9200, $9200, $9200, $9200
DATA_00D7A4:         dw $9400, $9400, $9400, $9400
DATA_00D7AC:         dw $9600, $9600, $9600, $9600

$00/D7B4 AD 74 79    LDA $7974  [$04:7974]   ;
$00/D7B7 29 0F 00    AND #$000F              ;
$00/D7BA 0A          ASL A                   ;
$00/D7BB A8          TAY                     ;
$00/D7BC B9 94 D7    LDA $D794,y[$04:D794]   ;
$00/D7BF 85 F7       STA $F7    [$00:00F7]   ;
$00/D7C1 A2 56       LDX #$56                ;
$00/D7C3 86 F9       STX $F9    [$00:00F9]   ;
$00/D7C5 A9 00 2F    LDA #$2F00              ;
$00/D7C8 8D 16 21    STA $2116  [$04:2116]   ;
$00/D7CB A9 00 02    LDA #$0200              ;
$00/D7CE 85 FA       STA $FA    [$00:00FA]   ;
$00/D7D0 A2 01       LDX #$01                ;
$00/D7D2 86 00       STX $00    [$00:0000]   ;
$00/D7D4 60          RTS                     ;

DATA_00D7D5:         dw $9800, $9A00, $9C00, $9E00
DATA_00D7DD:         dw $A000, $A200, $A400, $A600
DATA_00D7E5:         dw $A400, $A200, $A000, $9E00
DATA_00D7ED:         dw $9C00, $9A00

$00/D7F1 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D7F4 1A          INC A                   ;
$00/D7F5 C9 38 00    CMP #$0038              ;
$00/D7F8 90 03       BCC $03    [$D7FD]      ;
$00/D7FA A9 00 00    LDA #$0000              ;
$00/D7FD 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D800 4A          LSR A                   ;
$00/D801 29 FE 00    AND #$00FE              ;
$00/D804 A8          TAY                     ;
$00/D805 B9 D5 D7    LDA $D7D5,y[$04:D7D5]   ;
$00/D808 85 F7       STA $F7    [$00:00F7]   ;
$00/D80A A2 56       LDX #$56                ;
$00/D80C 86 F9       STX $F9    [$00:00F9]   ;
$00/D80E A9 00 2F    LDA #$2F00              ;
$00/D811 8D 16 21    STA $2116  [$04:2116]   ;
$00/D814 A9 00 02    LDA #$0200              ;
$00/D817 85 FA       STA $FA    [$00:00FA]   ;
$00/D819 A2 01       LDX #$01                ;
$00/D81B 86 00       STX $00    [$00:0000]   ;
$00/D81D 60          RTS                     ;

$00/D81E AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/D821 C9 06 00    CMP #$0006              ;
$00/D824 90 0E       BCC $0E    [$D834]      ;
$00/D826 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/D829 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D82C 1A          INC A                   ;
$00/D82D 1A          INC A                   ;
$00/D82E 29 0E 00    AND #$000E              ;
$00/D831 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D834 AC 67 0B    LDY $0B67  [$04:0B67]   ;
$00/D837 AD 46 01    LDA $0146  [$04:0146]   ;
$00/D83A C9 0A 00    CMP #$000A              ;
$00/D83D D0 C6       BNE $C6    [$D805]      ;
$00/D83F B9 D5 D7    LDA $D7D5,y[$04:D7D5]   ;
$00/D842 85 F7       STA $F7    [$00:00F7]   ;
$00/D844 A2 56       LDX #$56                ;
$00/D846 86 F9       STX $F9    [$00:00F9]   ;
$00/D848 A9 00 7F    LDA #$7F00              ;
$00/D84B 8D 16 21    STA $2116  [$04:2116]   ;
$00/D84E A9 00 02    LDA #$0200              ;
$00/D851 85 FA       STA $FA    [$00:00FA]   ;
$00/D853 A2 01       LDX #$01                ;
$00/D855 86 00       STX $00    [$00:0000]   ;
$00/D857 60          RTS                     ;

DATA_00D858:         dw $C800, $CA00, $CC00, $CE00
DATA_00D860:         dw $EC00, $EE00, $F000, $F200

DATA_00D868:         dw $C900, $CB00, $CD00, $CF00
DATA_00D870:         dw $ED00, $EF00, $F100, $F300

DATA_00D878:         dw $EC00, $EE00, $F000, $F200
DATA_00D880:         dw $F400, $F600, $F800, $FA00

DATA_00D888:         dw $ED00, $EF00, $F100, $F300
DATA_00D890:         dw $F500, $F700, $F900, $FB00

$00/D898 AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/D89B C9 0B 00    CMP #$000B              ;
$00/D89E 90 0D       BCC $0D    [$D8AD]      ;
$00/D8A0 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/D8A3 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D8A6 1A          INC A                   ;
$00/D8A7 29 03 00    AND #$0003              ;
$00/D8AA 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D8AD AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D8B0 0A          ASL A                   ;
$00/D8B1 A8          TAY                     ;
$00/D8B2 A2 52       LDX #$52                ;
$00/D8B4 AD 36 01    LDA $0136  [$04:0136]   ;
$00/D8B7 C9 0A 00    CMP #$000A              ;
$00/D8BA D0 07       BNE $07    [$D8C3]      ;
$00/D8BC 98          TYA                     ;
$00/D8BD 09 08 00    ORA #$0008              ;
$00/D8C0 A8          TAY                     ;
$00/D8C1 A2 56       LDX #$56                ;
$00/D8C3 86 F9       STX $F9    [$00:00F9]   ;
$00/D8C5 A2 01       LDX #$01                ;
$00/D8C7 AD 74 79    LDA $7974  [$04:7974]   ;
$00/D8CA 29 01 00    AND #$0001              ;
$00/D8CD F0 27       BEQ $27    [$D8F6]      ;
$00/D8CF B9 58 D8    LDA $D858,y[$04:D858]   ;
$00/D8D2 85 F7       STA $F7    [$00:00F7]   ;
$00/D8D4 A9 00 10    LDA #$1000              ;
$00/D8D7 8D 16 21    STA $2116  [$04:2116]   ;
$00/D8DA A9 00 01    LDA #$0100              ;
$00/D8DD 85 FA       STA $FA    [$00:00FA]   ;
$00/D8DF 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D8E2 B9 68 D8    LDA $D868,y[$04:D868]   ;
$00/D8E5 85 F7       STA $F7    [$00:00F7]   ;
$00/D8E7 A9 00 11    LDA #$1100              ;
$00/D8EA 8D 16 21    STA $2116  [$04:2116]   ;
$00/D8ED A9 00 01    LDA #$0100              ;
$00/D8F0 85 FA       STA $FA    [$00:00FA]   ;
$00/D8F2 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D8F5 60          RTS                     ;

$00/D8F6 B9 78 D8    LDA $D878,y[$04:D878]   ;
$00/D8F9 85 F7       STA $F7    [$00:00F7]   ;
$00/D8FB A9 80 10    LDA #$1080              ;
$00/D8FE 8D 16 21    STA $2116  [$04:2116]   ;
$00/D901 A9 00 01    LDA #$0100              ;
$00/D904 85 FA       STA $FA    [$00:00FA]   ;
$00/D906 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D909 B9 88 D8    LDA $D888,y[$04:D888]   ;
$00/D90C 85 F7       STA $F7    [$00:00F7]   ;
$00/D90E A9 80 11    LDA #$1180              ;
$00/D911 8D 16 21    STA $2116  [$04:2116]   ;
$00/D914 A9 00 01    LDA #$0100              ;
$00/D917 85 FA       STA $FA    [$00:00FA]   ;
$00/D919 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D91C 60          RTS                     ;

DATA_00D91D:         dw $E400, $E600, $E800, $EA00

DATA_00D925:         dw $E500, $E700, $E900, $EB00

$00/D92D EE 6D 0B    INC $0B6D  [$04:0B6D]   ;
$00/D930 AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/D933 C9 10 00    CMP #$0010              ;
$00/D936 90 0D       BCC $0D    [$D945]      ;
$00/D938 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/D93B AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D93E 1A          INC A                   ;
$00/D93F 29 03 00    AND #$0003              ;
$00/D942 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D945 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D948 0A          ASL A                   ;
$00/D949 A8          TAY                     ;
$00/D94A B9 1D D9    LDA $D91D,y[$04:D91D]   ;
$00/D94D 85 F7       STA $F7    [$00:00F7]   ;
$00/D94F A2 52       LDX #$52                ;
$00/D951 86 F9       STX $F9    [$00:00F9]   ;
$00/D953 A9 00 10    LDA #$1000              ;
$00/D956 8D 16 21    STA $2116  [$04:2116]   ;
$00/D959 A9 00 01    LDA #$0100              ;
$00/D95C 85 FA       STA $FA    [$00:00FA]   ;
$00/D95E A2 01       LDX #$01                ;
$00/D960 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D963 B9 25 D9    LDA $D925,y[$04:D925]   ;
$00/D966 85 F7       STA $F7    [$00:00F7]   ;
$00/D968 A9 00 11    LDA #$1100              ;
$00/D96B 8D 16 21    STA $2116  [$04:2116]   ;
$00/D96E A9 00 01    LDA #$0100              ;
$00/D971 85 FA       STA $FA    [$00:00FA]   ;
$00/D973 8E 0B 42    STX $420B  [$04:420B]   ;
$00/D976 60          RTS                     ;

$00/D977 EE 6D 0B    INC $0B6D  [$04:0B6D]   ;
$00/D97A AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/D97D C9 08 00    CMP #$0008              ;
$00/D980 90 10       BCC $10    [$D992]      ;
$00/D982 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/D985 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D988 18          CLC                     ;
$00/D989 69 00 02    ADC #$0200              ;
$00/D98C 29 00 06    AND #$0600              ;
$00/D98F 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D992 A9 00 80    LDA #$8000              ;
$00/D995 18          CLC                     ;
$00/D996 6D 67 0B    ADC $0B67  [$04:0B67]   ;
$00/D999 4C 08 D8    JMP $D808  [$04:D808]   ;

$00/D99C AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/D99F C9 08 00    CMP #$0008              ;
$00/D9A2 90 10       BCC $10    [$D9B4]      ;
$00/D9A4 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/D9A7 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/D9AA 18          CLC                     ;
$00/D9AB 69 00 02    ADC #$0200              ;
$00/D9AE 29 00 0E    AND #$0E00              ;
$00/D9B1 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/D9B4 A9 00 B0    LDA #$B000              ;
$00/D9B7 18          CLC                     ;
$00/D9B8 6D 67 0B    ADC $0B67  [$04:0B67]   ;
$00/D9BB 4C 08 D8    JMP $D808  [$04:D808]   ;

DATA_00D9BE:         dw $B000, $B200, $B400, $B600
DATA_00D9C6:         dw $B800, $BA00, $BC00, $BE00
DATA_00D9CE:         dw $BC00, $BA00, $B800, $B600
DATA_00D9D6:         dw $B400, $B200

DATA_00D9DA:         dw $000A, $0004, $0004, $0004
DATA_00D9E2:         dw $0004, $0004, $0004, $000A
DATA_00D9EA:         dw $0004, $0004, $0004, $0004
DATA_00D9F2:         dw $0004, $0004

$00/D9F6 AD 74 79    LDA $7974  [$04:7974]   ;
$00/D9F9 29 01 00    AND #$0001              ;
$00/D9FC D0 04       BNE $04    [$DA02]      ;
$00/D9FE 20 65 D7    JSR $D765  [$04:D765]   ;
$00/DA01 60          RTS                     ;

$00/DA02 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/DA05 29 0F 00    AND #$000F              ;
$00/DA08 0A          ASL A                   ;
$00/DA09 A8          TAY                     ;
$00/DA0A AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/DA0D D9 DA D9    CMP $D9DA,y[$04:D9DA]   ;
$00/DA10 90 11       BCC $11    [$DA23]      ;
$00/DA12 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/DA15 EE 67 0B    INC $0B67  [$04:0B67]   ;
$00/DA18 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/DA1B C9 0E 00    CMP #$000E              ;
$00/DA1E 90 03       BCC $03    [$DA23]      ;
$00/DA20 9C 67 0B    STZ $0B67  [$04:0B67]   ;
$00/DA23 B9 BE D9    LDA $D9BE,y[$04:D9BE]   ;
$00/DA26 4C 08 D8    JMP $D808  [$04:D808]   ;

DATA_00DA29:         dw $E000, $E100, $E200, $E300
DATA_00DA31:         dw $F400, $F500, $F600, $F700
DATA_00DA39:         dw $F400, $F500, $E200, $E300

DATA_00DA41:         dw $F800, $F900, $FA00, $FB00
DATA_00DA49:         dw $FC00, $FD00, $FE00, $FF00
DATA_00DA51:         dw $FC00, $FD00, $FA00, $FB00

DATA_00DA59:         dw $0010, $000C, $000C, $0010
DATA_00DA61:         dw $000C, $000C

$00/DA65 AE 67 0B    LDX $0B67  [$04:0B67]   ;
$00/DA68 AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/DA6B DD 59 DA    CMP $DA59,x[$04:DA59]   ;
$00/DA6E 90 13       BCC $13    [$DA83]      ;
$00/DA70 9C 6D 0B    STZ $0B6D  [$04:0B6D]   ;
$00/DA73 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/DA76 1A          INC A                   ;
$00/DA77 1A          INC A                   ;
$00/DA78 C9 0C 00    CMP #$000C              ;
$00/DA7B 90 03       BCC $03    [$DA80]      ;
$00/DA7D A9 00 00    LDA #$0000              ;
$00/DA80 8D 67 0B    STA $0B67  [$04:0B67]   ;
$00/DA83 AD 67 0B    LDA $0B67  [$04:0B67]   ;
$00/DA86 0A          ASL A                   ;
$00/DA87 A8          TAY                     ;
$00/DA88 A2 52       LDX #$52                ;
$00/DA8A 86 F9       STX $F9    [$00:00F9]   ;
$00/DA8C A2 01       LDX #$01                ;
$00/DA8E AD 74 79    LDA $7974  [$04:7974]   ;
$00/DA91 29 02 00    AND #$0002              ;
$00/DA94 D0 27       BNE $27    [$DABD]      ;
$00/DA96 B9 29 DA    LDA $DA29,y[$04:DA29]   ;
$00/DA99 85 F7       STA $F7    [$00:00F7]   ;
$00/DA9B A9 00 10    LDA #$1000              ;
$00/DA9E 8D 16 21    STA $2116  [$04:2116]   ;
$00/DAA1 A9 00 01    LDA #$0100              ;
$00/DAA4 85 FA       STA $FA    [$00:00FA]   ;
$00/DAA6 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DAA9 B9 2B DA    LDA $DA2B,y[$04:DA2B]   ;
$00/DAAC 85 F7       STA $F7    [$00:00F7]   ;
$00/DAAE A9 00 11    LDA #$1100              ;
$00/DAB1 8D 16 21    STA $2116  [$04:2116]   ;
$00/DAB4 A9 00 01    LDA #$0100              ;
$00/DAB7 85 FA       STA $FA    [$00:00FA]   ;
$00/DAB9 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DABC 60          RTS                     ;

$00/DABD B9 41 DA    LDA $DA41,y[$04:DA41]   ;
$00/DAC0 85 F7       STA $F7    [$00:00F7]   ;
$00/DAC2 A9 80 10    LDA #$1080              ;
$00/DAC5 8D 16 21    STA $2116  [$04:2116]   ;
$00/DAC8 A9 00 01    LDA #$0100              ;
$00/DACB 85 FA       STA $FA    [$00:00FA]   ;
$00/DACD 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DAD0 B9 43 DA    LDA $DA43,y[$04:DA43]   ;
$00/DAD3 85 F7       STA $F7    [$00:00F7]   ;
$00/DAD5 A9 80 11    LDA #$1180              ;
$00/DAD8 8D 16 21    STA $2116  [$04:2116]   ;
$00/DADB A9 00 01    LDA #$0100              ;
$00/DADE 85 FA       STA $FA    [$00:00FA]   ;
$00/DAE0 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DAE3 60          RTS                     ;

$00/DAE4 EE 6F 0B    INC $0B6F  [$04:0B6F]   ;
$00/DAE7 AD 6F 0B    LDA $0B6F  [$04:0B6F]   ;
$00/DAEA C9 06 00    CMP #$0006              ;
$00/DAED B0 03       BCS $03    [$DAF2]      ;
$00/DAEF 4C 98 D8    JMP $D898  [$04:D898]   ;

$00/DAF2 9C 6F 0B    STZ $0B6F  [$04:0B6F]   ;
$00/DAF5 AD 69 0B    LDA $0B69  [$04:0B69]   ;
$00/DAF8 1A          INC A                   ;
$00/DAF9 1A          INC A                   ;
$00/DAFA 29 0E 00    AND #$000E              ;
$00/DAFD 8D 69 0B    STA $0B69  [$04:0B69]   ;
$00/DB00 AC 69 0B    LDY $0B69  [$04:0B69]   ;
$00/DB03 4C 05 D8    JMP $D805  [$04:D805]   ;

$00/DB06 EE 6F 0B    INC $0B6F  [$04:0B6F]   ;
$00/DB09 AD 74 79    LDA $7974  [$04:7974]   ;
$00/DB0C 29 01 00    AND #$0001              ;
$00/DB0F F0 E1       BEQ $E1    [$DAF2]      ;
$00/DB11 4C 65 DA    JMP $DA65  [$04:DA65]   ;

DATA_00DB14:         dw $A800, $AA00, $AC00, $AE00

$00/DB1C AD 71 0B    LDA $0B71  [$04:0B71]   ;
$00/DB1F 1A          INC A                   ;
$00/DB20 C9 06 00    CMP #$0006              ;
$00/DB23 90 06       BCC $06    [$DB2B]      ;
$00/DB25 EE 6B 0B    INC $0B6B  [$04:0B6B]   ;
$00/DB28 A9 00 00    LDA #$0000              ;
$00/DB2B 8D 71 0B    STA $0B71  [$04:0B71]   ;
$00/DB2E A2 01       LDX #$01                ;
$00/DB30 AC 6B 0B    LDY $0B6B  [$04:0B6B]   ;
$00/DB33 C9 00 00    CMP #$0000              ;
$00/DB36 D0 0B       BNE $0B    [$DB43]      ;
$00/DB38 98          TYA                     ;
$00/DB39 29 06 00    AND #$0006              ;
$00/DB3C A8          TAY                     ;
$00/DB3D B9 14 DB    LDA $DB14,y[$04:DB14]   ;
$00/DB40 4C 08 D8    JMP $D808  [$04:D808]   ;

$00/DB43 60          RTS                     ;

DATA_00DB44:         dw $C000, $C100, $C200, $C300

DATA_00DB4C:         dw $C080, $C180, $C280, $C380

$00/DB54 AD 6D 0B    LDA $0B6D  [$04:0B6D]   ;
$00/DB57 29 0C 00    AND #$000C              ;
$00/DB5A 4A          LSR A                   ;
$00/DB5B A8          TAY                     ;
$00/DB5C A2 56       LDX #$56                ;
$00/DB5E 86 F9       STX $F9    [$00:00F9]   ;
$00/DB60 B9 44 DB    LDA $DB44,y[$04:DB44]   ;
$00/DB63 85 F7       STA $F7    [$00:00F7]   ;
$00/DB65 A9 00 2F    LDA #$2F00              ;
$00/DB68 8D 16 21    STA $2116  [$04:2116]   ;
$00/DB6B A9 80 00    LDA #$0080              ;
$00/DB6E 85 FA       STA $FA    [$00:00FA]   ;
$00/DB70 A2 01       LDX #$01                ;
$00/DB72 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DB75 85 FA       STA $FA    [$00:00FA]   ;
$00/DB77 B9 4C DB    LDA $DB4C,y[$04:DB4C]   ;
$00/DB7A 85 F7       STA $F7    [$00:00F7]   ;
$00/DB7C A9 80 2F    LDA #$2F80              ;
$00/DB7F 8D 16 21    STA $2116  [$04:2116]   ;
$00/DB82 8E 0B 42    STX $420B  [$04:420B]   ;
$00/DB85 60          RTS                     ;

$00/DB86 AD 74 79    LDA $7974  [$04:7974]   ;
$00/DB89 29 03 00    AND #$0003              ;
$00/DB8C D0 03       BNE $03    [$DB91]      ;
$00/DB8E 4C B4 D7    JMP $D7B4  [$04:D7B4]   ;

$00/DB91 4C 65 DA    JMP $DA65  [$04:DA65]   ;

$00/DB94 C2 20       REP #$20                ;
$00/DB96 0B          PHD                     ;
$00/DB97 A9 0B 42    LDA #$420B              ;
$00/DB9A 5B          TCD                     ;
$00/DB9B A9 01 18    LDA #$1801              ;
$00/DB9E 85 F5       STA $F5    [$00:00F5]   ;
$00/DBA0 A2 01       LDX #$01                ;
$00/DBA2 20 A9 DB    JSR $DBA9  [$04:DBA9]   ;
$00/DBA5 2B          PLD                     ;
$00/DBA6 E2 20       SEP #$20                ;
$00/DBA8 6B          RTL                     ;

$00/DBA9 A0 00       LDY #$00                ;
$00/DBAB 84 F9       STY $F9    [$00:00F9]   ;
$00/DBAD A0 81       LDY #$81                ;
$00/DBAF 8C 15 21    STY $2115  [$04:2115]   ;
$00/DBB2 AC 77 00    LDY $0077  [$04:0077]   ;
$00/DBB5 F0 1E       BEQ $1E    [$DBD5]      ;
$00/DBB7 A9 AA 6D    LDA #$6DAA              ;
$00/DBBA 85 F7       STA $F7    [$00:00F7]   ;
$00/DBBC AD 7B 00    LDA $007B  [$04:007B]   ;
$00/DBBF 8D 16 21    STA $2116  [$04:2116]   ;
$00/DBC2 A0 40       LDY #$40                ;
$00/DBC4 84 FA       STY $FA    [$00:00FA]   ;
$00/DBC6 86 00       STX $00    [$00:0000]   ;
$00/DBC8 AD 7F 00    LDA $007F  [$04:007F]   ;
$00/DBCB 8D 16 21    STA $2116  [$04:2116]   ;
$00/DBCE 84 FA       STY $FA    [$00:00FA]   ;
$00/DBD0 86 00       STX $00    [$00:0000]   ;
$00/DBD2 9C 77 00    STZ $0077  [$04:0077]   ;
$00/DBD5 A0 80       LDY #$80                ;
$00/DBD7 8C 15 21    STY $2115  [$04:2115]   ;
$00/DBDA AC 79 00    LDY $0079  [$04:0079]   ;
$00/DBDD F0 3C       BEQ $3C    [$DC1B]      ;
$00/DBDF A9 2A 6E    LDA #$6E2A              ;
$00/DBE2 85 F7       STA $F7    [$00:00F7]   ;
$00/DBE4 AD 7D 00    LDA $007D  [$04:007D]   ;
$00/DBE7 8D 16 21    STA $2116  [$04:2116]   ;
$00/DBEA AD 83 00    LDA $0083  [$04:0083]   ;
$00/DBED 85 FA       STA $FA    [$00:00FA]   ;
$00/DBEF 86 00       STX $00    [$00:0000]   ;
$00/DBF1 AD 81 00    LDA $0081  [$04:0081]   ;
$00/DBF4 8D 16 21    STA $2116  [$04:2116]   ;
$00/DBF7 AD 87 00    LDA $0087  [$04:0087]   ;
$00/DBFA 85 FA       STA $FA    [$00:00FA]   ;
$00/DBFC 86 00       STX $00    [$00:0000]   ;
$00/DBFE AD 85 00    LDA $0085  [$04:0085]   ;
$00/DC01 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC04 AD 83 00    LDA $0083  [$04:0083]   ;
$00/DC07 85 FA       STA $FA    [$00:00FA]   ;
$00/DC09 86 00       STX $00    [$00:0000]   ;
$00/DC0B AD 89 00    LDA $0089  [$04:0089]   ;
$00/DC0E 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC11 AD 87 00    LDA $0087  [$04:0087]   ;
$00/DC14 85 FA       STA $FA    [$00:00FA]   ;
$00/DC16 86 00       STX $00    [$00:0000]   ;
$00/DC18 9C 79 00    STZ $0079  [$04:0079]   ;
$00/DC1B 60          RTS                     ;

$00/DC1C AD ED 09    LDA $09ED  [$04:09ED]   ;
$00/DC1F F0 3F       BEQ $3F    [$DC60]      ;
$00/DC21 A2 80       LDX #$80                ;
$00/DC23 8E 15 21    STX $2115  [$04:2115]   ;
$00/DC26 A2 01       LDX #$01                ;
$00/DC28 86 F5       STX $F5    [$00:00F5]   ;
$00/DC2A A2 18       LDX #$18                ;
$00/DC2C 86 F6       STX $F6    [$00:00F6]   ;
$00/DC2E A2 4C       LDX #$4C                ;
$00/DC30 86 F9       STX $F9    [$00:00F9]   ;
$00/DC32 A0 00       LDY #$00                ;
$00/DC34 A2 01       LDX #$01                ;
$00/DC36 B9 EF 09    LDA $09EF,y[$04:09EF]   ;
$00/DC39 30 25       BMI $25    [$DC60]      ;
$00/DC3B 48          PHA                     ;
$00/DC3C 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC3F B9 F1 09    LDA $09F1,y[$04:09F1]   ;
$00/DC42 85 F7       STA $F7    [$00:00F7]   ;
$00/DC44 A9 04 00    LDA #$0004              ;
$00/DC47 85 FA       STA $FA    [$00:00FA]   ;
$00/DC49 86 00       STX $00    [$00:0000]   ;
$00/DC4B 68          PLA                     ;
$00/DC4C 18          CLC                     ;
$00/DC4D 69 20 00    ADC #$0020              ;
$00/DC50 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC53 A9 04 00    LDA #$0004              ;
$00/DC56 85 FA       STA $FA    [$00:00FA]   ;
$00/DC58 86 00       STX $00    [$00:0000]   ;
$00/DC5A C8          INY                     ;
$00/DC5B C8          INY                     ;
$00/DC5C C8          INY                     ;
$00/DC5D C8          INY                     ;
$00/DC5E 80 D6       BRA $D6    [$DC36]      ;

$00/DC60 A9 00 00    LDA #$0000              ;
$00/DC63 8D ED 09    STA $09ED  [$04:09ED]   ;
$00/DC66 3A          DEC A                   ;
$00/DC67 8D EF 09    STA $09EF  [$04:09EF]   ;
$00/DC6A 60          RTS                     ;

$00/DC6B AD F9 0C    LDA $0CF9  [$04:0CF9]   ;
$00/DC6E F0 26       BEQ $26    [$DC96]      ;
$00/DC70 10 0B       BPL $0B    [$DC7D]      ;
$00/DC72 29 E0 7F    AND #$7FE0              ;
$00/DC75 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC78 A9 00 68    LDA #$6800              ;
$00/DC7B 80 09       BRA $09    [$DC86]      ;

$00/DC7D A9 00 5C    LDA #$5C00              ;
$00/DC80 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC83 A9 00 58    LDA #$5800              ;
$00/DC86 85 F7       STA $F7    [$00:00F7]   ;
$00/DC88 A0 70       LDY #$70                ;
$00/DC8A 84 F9       STY $F9    [$00:00F9]   ;
$00/DC8C A9 00 08    LDA #$0800              ;
$00/DC8F 85 FA       STA $FA    [$00:00FA]   ;
$00/DC91 86 00       STX $00    [$00:0000]   ;
$00/DC93 9C F9 0C    STZ $0CF9  [$04:0CF9]   ;
$00/DC96 60          RTS                     ;

$00/DC97 A9 00 30    LDA #$3000              ;
$00/DC9A 8D 16 21    STA $2116  [$04:2116]   ;
$00/DC9D A9 00 4E    LDA #$4E00              ;
$00/DCA0 85 F7       STA $F7    [$00:00F7]   ;
$00/DCA2 A0 70       LDY #$70                ;
$00/DCA4 84 F9       STY $F9    [$00:00F9]   ;
$00/DCA6 A9 00 08    LDA #$0800              ;
$00/DCA9 85 FA       STA $FA    [$00:00FA]   ;
$00/DCAB 86 00       STX $00    [$00:0000]   ;
$00/DCAD 60          RTS                     ;

$00/DCAE A9 00 40    LDA #$4000              ;
$00/DCB1 8D 16 21    STA $2116  [$04:2116]   ;
$00/DCB4 A0 40       LDY #$40                ;
$00/DCB6 AD 28 61    LDA $6128  [$04:6128]   ;
$00/DCB9 85 F7       STA $F7    [$00:00F7]   ;
$00/DCBB AD 2A 61    LDA $612A  [$04:612A]   ;
$00/DCBE 85 F9       STA $F9    [$00:00F9]   ;
$00/DCC0 84 FA       STY $FA    [$00:00FA]   ;
$00/DCC2 86 00       STX $00    [$00:0000]   ;
$00/DCC4 AD 2C 61    LDA $612C  [$04:612C]   ;
$00/DCC7 85 F7       STA $F7    [$00:00F7]   ;
$00/DCC9 AD 2E 61    LDA $612E  [$04:612E]   ;
$00/DCCC 85 F9       STA $F9    [$00:00F9]   ;
$00/DCCE 84 FA       STY $FA    [$00:00FA]   ;
$00/DCD0 86 00       STX $00    [$00:0000]   ;
$00/DCD2 AD 30 61    LDA $6130  [$04:6130]   ;
$00/DCD5 85 F7       STA $F7    [$00:00F7]   ;
$00/DCD7 AD 32 61    LDA $6132  [$04:6132]   ;
$00/DCDA 85 F9       STA $F9    [$00:00F9]   ;
$00/DCDC 84 FA       STY $FA    [$00:00FA]   ;
$00/DCDE 86 00       STX $00    [$00:0000]   ;
$00/DCE0 AD 34 61    LDA $6134  [$04:6134]   ;
$00/DCE3 85 F7       STA $F7    [$00:00F7]   ;
$00/DCE5 AD 36 61    LDA $6136  [$04:6136]   ;
$00/DCE8 85 F9       STA $F9    [$00:00F9]   ;
$00/DCEA 84 FA       STY $FA    [$00:00FA]   ;
$00/DCEC 86 00       STX $00    [$00:0000]   ;
$00/DCEE AD 38 61    LDA $6138  [$04:6138]   ;
$00/DCF1 85 F7       STA $F7    [$00:00F7]   ;
$00/DCF3 AD 3A 61    LDA $613A  [$04:613A]   ;
$00/DCF6 85 F9       STA $F9    [$00:00F9]   ;
$00/DCF8 84 FA       STY $FA    [$00:00FA]   ;
$00/DCFA 86 00       STX $00    [$00:0000]   ;
$00/DCFC AD 3C 61    LDA $613C  [$04:613C]   ;
$00/DCFF 85 F7       STA $F7    [$00:00F7]   ;
$00/DD01 AD 3E 61    LDA $613E  [$04:613E]   ;
$00/DD04 85 F9       STA $F9    [$00:00F9]   ;
$00/DD06 84 FA       STY $FA    [$00:00FA]   ;
$00/DD08 86 00       STX $00    [$00:0000]   ;
$00/DD0A AD 40 61    LDA $6140  [$04:6140]   ;
$00/DD0D 85 F7       STA $F7    [$00:00F7]   ;
$00/DD0F AD 42 61    LDA $6142  [$04:6142]   ;
$00/DD12 85 F9       STA $F9    [$00:00F9]   ;
$00/DD14 A9 20 00    LDA #$0020              ;
$00/DD17 85 FA       STA $FA    [$00:00FA]   ;
$00/DD19 86 00       STX $00    [$00:0000]   ;
$00/DD1B 85 FA       STA $FA    [$00:00FA]   ;
$00/DD1D AD 45 61    LDA $6145  [$04:6145]   ;
$00/DD20 85 F8       STA $F8    [$00:00F8]   ;
$00/DD22 AD 44 61    LDA $6144  [$04:6144]   ;
$00/DD25 85 F7       STA $F7    [$00:00F7]   ;
$00/DD27 86 00       STX $00    [$00:0000]   ;
$00/DD29 A9 00 41    LDA #$4100              ;
$00/DD2C 8D 16 21    STA $2116  [$04:2116]   ;
$00/DD2F AD 28 61    LDA $6128  [$04:6128]   ;
$00/DD32 85 F7       STA $F7    [$00:00F7]   ;
$00/DD34 AD 2A 61    LDA $612A  [$04:612A]   ;
$00/DD37 EB          XBA                     ;
$00/DD38 85 F8       STA $F8    [$00:00F8]   ;
$00/DD3A 84 FA       STY $FA    [$00:00FA]   ;
$00/DD3C 86 00       STX $00    [$00:0000]   ;
$00/DD3E AD 2C 61    LDA $612C  [$04:612C]   ;
$00/DD41 85 F7       STA $F7    [$00:00F7]   ;
$00/DD43 AD 2E 61    LDA $612E  [$04:612E]   ;
$00/DD46 EB          XBA                     ;
$00/DD47 85 F8       STA $F8    [$00:00F8]   ;
$00/DD49 84 FA       STY $FA    [$00:00FA]   ;
$00/DD4B 86 00       STX $00    [$00:0000]   ;
$00/DD4D AD 30 61    LDA $6130  [$04:6130]   ;
$00/DD50 85 F7       STA $F7    [$00:00F7]   ;
$00/DD52 AD 32 61    LDA $6132  [$04:6132]   ;
$00/DD55 EB          XBA                     ;
$00/DD56 85 F8       STA $F8    [$00:00F8]   ;
$00/DD58 84 FA       STY $FA    [$00:00FA]   ;
$00/DD5A 86 00       STX $00    [$00:0000]   ;
$00/DD5C AD 34 61    LDA $6134  [$04:6134]   ;
$00/DD5F 85 F7       STA $F7    [$00:00F7]   ;
$00/DD61 AD 36 61    LDA $6136  [$04:6136]   ;
$00/DD64 EB          XBA                     ;
$00/DD65 85 F8       STA $F8    [$00:00F8]   ;
$00/DD67 84 FA       STY $FA    [$00:00FA]   ;
$00/DD69 86 00       STX $00    [$00:0000]   ;
$00/DD6B AD 38 61    LDA $6138  [$04:6138]   ;
$00/DD6E 85 F7       STA $F7    [$00:00F7]   ;
$00/DD70 AD 3A 61    LDA $613A  [$04:613A]   ;
$00/DD73 EB          XBA                     ;
$00/DD74 85 F8       STA $F8    [$00:00F8]   ;
$00/DD76 84 FA       STY $FA    [$00:00FA]   ;
$00/DD78 86 00       STX $00    [$00:0000]   ;
$00/DD7A AD 3C 61    LDA $613C  [$04:613C]   ;
$00/DD7D 85 F7       STA $F7    [$00:00F7]   ;
$00/DD7F AD 3E 61    LDA $613E  [$04:613E]   ;
$00/DD82 EB          XBA                     ;
$00/DD83 85 F8       STA $F8    [$00:00F8]   ;
$00/DD85 84 FA       STY $FA    [$00:00FA]   ;
$00/DD87 86 00       STX $00    [$00:0000]   ;
$00/DD89 AD 40 61    LDA $6140  [$04:6140]   ;
$00/DD8C 85 F7       STA $F7    [$00:00F7]   ;
$00/DD8E AD 42 61    LDA $6142  [$04:6142]   ;
$00/DD91 EB          XBA                     ;
$00/DD92 85 F8       STA $F8    [$00:00F8]   ;
$00/DD94 A9 20 00    LDA #$0020              ;
$00/DD97 85 FA       STA $FA    [$00:00FA]   ;
$00/DD99 86 00       STX $00    [$00:0000]   ;
$00/DD9B 85 FA       STA $FA    [$00:00FA]   ;
$00/DD9D AD 44 61    LDA $6144  [$04:6144]   ;
$00/DDA0 85 F7       STA $F7    [$00:00F7]   ;
$00/DDA2 AD 46 61    LDA $6146  [$04:6146]   ;
$00/DDA5 EB          XBA                     ;
$00/DDA6 85 F8       STA $F8    [$00:00F8]   ;
$00/DDA8 86 00       STX $00    [$00:0000]   ;
$00/DDAA AD 85 0B    LDA $0B85  [$04:0B85]   ;
$00/DDAD F0 38       BEQ $38    [$DDE7]      ;
$00/DDAF A9 20 46    LDA #$4620              ;
$00/DDB2 8D 16 21    STA $2116  [$04:2116]   ;
$00/DDB5 AD 87 0B    LDA $0B87  [$04:0B87]   ;
$00/DDB8 85 F7       STA $F7    [$00:00F7]   ;
$00/DDBA A9 52 00    LDA #$0052              ;
$00/DDBD 85 F9       STA $F9    [$00:00F9]   ;
$00/DDBF 84 FA       STY $FA    [$00:00FA]   ;
$00/DDC1 86 00       STX $00    [$00:0000]   ;
$00/DDC3 AD 8B 0B    LDA $0B8B  [$04:0B8B]   ;
$00/DDC6 85 F7       STA $F7    [$00:00F7]   ;
$00/DDC8 84 FA       STY $FA    [$00:00FA]   ;
$00/DDCA 86 00       STX $00    [$00:0000]   ;
$00/DDCC A9 20 47    LDA #$4720              ;
$00/DDCF 8D 16 21    STA $2116  [$04:2116]   ;
$00/DDD2 AD 89 0B    LDA $0B89  [$04:0B89]   ;
$00/DDD5 85 F7       STA $F7    [$00:00F7]   ;
$00/DDD7 84 FA       STY $FA    [$00:00FA]   ;
$00/DDD9 86 00       STX $00    [$00:0000]   ;
$00/DDDB AD 8D 0B    LDA $0B8D  [$04:0B8D]   ;
$00/DDDE 85 F7       STA $F7    [$00:00F7]   ;
$00/DDE0 84 FA       STY $FA    [$00:00FA]   ;
$00/DDE2 86 00       STX $00    [$00:0000]   ;
$00/DDE4 9C 85 0B    STZ $0B85  [$04:0B85]   ;
$00/DDE7 AD 14 61    LDA $6114  [$04:6114]   ;
$00/DDEA F0 1F       BEQ $1F    [$DE0B]      ;
$00/DDEC 85 F7       STA $F7    [$00:00F7]   ;
$00/DDEE A0 52       LDY #$52                ;
$00/DDF0 84 F9       STY $F9    [$00:00F9]   ;
$00/DDF2 A9 00 42    LDA #$4200              ;
$00/DDF5 8D 16 21    STA $2116  [$04:2116]   ;
$00/DDF8 A0 01       LDY #$01                ;
$00/DDFA 84 FB       STY $FB    [$00:00FB]   ;
$00/DDFC 86 00       STX $00    [$00:0000]   ;
$00/DDFE A9 00 43    LDA #$4300              ;
$00/DE01 8D 16 21    STA $2116  [$04:2116]   ;
$00/DE04 84 FB       STY $FB    [$00:00FB]   ;
$00/DE06 86 00       STX $00    [$00:0000]   ;
$00/DE08 9C 14 61    STZ $6114  [$04:6114]   ;
$00/DE0B 60          RTS                     ;

; perform DMA's that were added to queue by $00BE39
$00/DE0C A9 00 80    LDA #$8000              ;
$00/DE0F 85 F5       STA $F5    [$00:00F5]   ; WRAM is destination
$00/DE11 A0 02       LDY #$02                ;
$00/DE13 B9 6D 09    LDA $096D,y[$04:096D]   ; size
$00/DE16 F0 2B       BEQ $2B    [$DE43]      ;
$00/DE18 85 FA       STA $FA    [$00:00FA]   ;
$00/DE1A B9 6F 09    LDA $096F,y[$04:096F]   ; \
$00/DE1D 8D 81 21    STA $2181  [$04:2181]   ;  | destination WRAM address
$00/DE20 B9 70 09    LDA $0970,y[$04:0970]   ;  |
$00/DE23 8D 82 21    STA $2182  [$04:2182]   ; /
$00/DE26 B9 72 09    LDA $0972,y[$04:0972]   ; \
$00/DE29 85 F7       STA $F7    [$00:00F7]   ;  | source address
$00/DE2B B9 73 09    LDA $0973,y[$04:0973]   ;  |
$00/DE2E 85 F8       STA $F8    [$00:00F8]   ; /
$00/DE30 86 00       STX $00    [$00:0000]   ; do DMA
$00/DE32 98          TYA                     ;
$00/DE33 18          CLC                     ;
$00/DE34 69 08 00    ADC #$0008              ;
$00/DE37 A8          TAY                     ;
$00/DE38 B9 6D 09    LDA $096D,y[$04:096D]   ;
$00/DE3B D0 DB       BNE $DB    [$DE18]      ; keep doing more DMA's until 0 size encountered
$00/DE3D 9C 6D 09    STZ $096D  [$04:096D]   ;
$00/DE40 9C 6F 09    STZ $096F  [$04:096F]   ;
$00/DE43 60          RTS                     ;

.superfxinit1
CODE_00DE44:        9C 30 30      STZ $3030                 ; nuke GSU status/flag register
CODE_00DE47:        AC 2D 01      LDY $012D                 ;\ set SCBR
CODE_00DE4A:        8C 38 30      STY $3038                 ;/
CODE_00DE4D:        AC 2E 01      LDY $012E                 ;\ set SCMR
CODE_00DE50:        8C 3A 30      STY $303A                 ;/
CODE_00DE53:        8E 34 30      STX $3034                 ; set PBR
CODE_00DE56:        8D 1E 30      STA $301E                 ; set program counter
CODE_00DE59:        A9 20 00      LDA #$0020                ;\ start GSU execution
CODE_00DE5C:        2C 30 30      BIT $3030                 ;/\
CODE_00DE5F:        D0 FB         BNE CODE_00DE5C           ; / wait for GSU execution to end
CODE_00DE61:        A0 00         LDY #$00                  ;\ give SCPU ROM/RAM bus access
CODE_00DE63:        8C 3A 30      STY $303A                 ;/
CODE_00DE66:        6B            RTL                       ;

.superfxinit2
CODE_00DE67:        8B            PHB                       ; preserve bank
CODE_00DE68:        9C 30 30      STZ $3030                 ; nuke GSU status/flag register
CODE_00DE6B:        AC 2D 01      LDY $012D                 ;\ set SCBR
CODE_00DE6E:        8C 38 30      STY $3038                 ;/
CODE_00DE71:        AC 2E 01      LDY $012E                 ;\ set SCMR
CODE_00DE74:        8C 3A 30      STY $303A                 ;/
CODE_00DE77:        8E 34 30      STX $3034                 ; set PBR
CODE_00DE7A:        8D 1E 30      STA $301E                 ; set program counter
CODE_00DE7D:        4B            PHK                       ;\
CODE_00DE7E:        AB            PLB                       ; | sub call
CODE_00DE7F:        20 40 E2      JSR CODE_00E240           ;/
CODE_00DE82:        AB            PLB                       ; restore bank
CODE_00DE83:        A9 20 00      LDA #$0020                ;\ start GSU execution
CODE_00DE86:        2C 30 30      BIT $3030                 ;/\
CODE_00DE89:        D0 FB         BNE CODE_00DE86           ; / wait for GSU execution to end
CODE_00DE8B:        A0 00         LDY #$00                  ;\ give SCPU ROM/RAM bus access
CODE_00DE8D:        8C 3A 30      STY $303A                 ;/
CODE_00DE90:        6B            RTL                       ;

.superfxinit3
CODE_00DE91:        9C 30 30      STZ $3030                 ; nuke GSU status/flag register
CODE_00DE94:        AC 2D 01      LDY $012D                 ;\ set SCBR
CODE_00DE97:        8C 38 30      STY $3038                 ;/
CODE_00DE9A:        AC 2E 01      LDY $012E                 ;\ set SCMR
CODE_00DE9D:        8C 3A 30      STY $303A                 ;/
CODE_00DEA0:        8E 34 30      STX $3034                 ; set PBR
CODE_00DEA3:        8D 1E 30      STA $301E                 ; set program counter
CODE_00DEA6:        C2 10         REP #$10                  ;
CODE_00DEA8:        A9 20 00      LDA #$0020                ;\
CODE_00DEAB:        A8            TAY                       ; | start GSU execution
CODE_00DEAC:        2C 30 30      BIT $3030                 ;/\
CODE_00DEAF:        D0 FB         BNE CODE_00DEAC           ; / wait for GSU execution to end
CODE_00DEB1:        AE 00 30      LDX $3000                 ;\
CODE_00DEB4:        F0 10         BEQ CODE_00DEC6           ; |
CODE_00DEB6:        BF 00 00 7F   LDA $7F0000,x             ; |
CODE_00DEBA:        8D 00 30      STA $3000                 ; | execute the GSU routine again until r0 is zero
CODE_00DEBD:        AD 1E 30      LDA $301E                 ; |
CODE_00DEC0:        8D 1E 30      STA $301E                 ; |
CODE_00DEC3:        98            TYA                       ; |
CODE_00DEC4:        80 E6         BRA CODE_00DEAC           ;/ 

CODE_00DEC6:        A0 00 00      LDY #$0000                ;\ give SCPU ROM/RAM bus access
CODE_00DEC9:        8C 3A 30      STY $303A                 ;/
CODE_00DECC:        E2 10         SEP #$10                  ;
CODE_00DECE:        6B            RTL                       ;

.superfxinit4
CODE_00DECF:        9C 30 30      STZ $3030                 ; nuke GSU status/flag register
CODE_00DED2:        AC 2D 01      LDY $012D                 ;\ set SCBR
CODE_00DED5:        8C 38 30      STY $3038                 ;/
CODE_00DED8:        AC 2E 01      LDY $012E                 ;\ set SCMR
CODE_00DEDB:        8C 3A 30      STY $303A                 ;/
CODE_00DEDE:        8E 34 30      STX $3034                 ; set PBR
CODE_00DEE1:        8D 1E 30      STA $301E                 ; set program counter
CODE_00DEE4:        C2 10         REP #$10                  ;
CODE_00DEE6:        A9 20 00      LDA #$0020                ;\
CODE_00DEE9:        A8            TAY                       ; | start GSU execution
CODE_00DEEA:        2C 30 30      BIT $3030                 ;/\
CODE_00DEED:        D0 FB         BNE CODE_00DEEA           ; / wait for GSU execution to end
CODE_00DEEF:        AE 00 30      LDX $3000                 ;\
CODE_00DEF2:        10 10         BPL CODE_00DF04           ; |
CODE_00DEF4:        BF 00 00 7F   LDA $7F0000,x             ; |
CODE_00DEF8:        8D 00 30      STA $3000                 ; | execute the GSU routine again until r0 is positive
CODE_00DEFB:        AD 1E 30      LDA $301E                 ; |
CODE_00DEFE:        8D 1E 30      STA $301E                 ; |
CODE_00DF01:        98            TYA                       ; |
CODE_00DF02:        80 E6         BRA CODE_00DEEA           ;/

CODE_00DF04:        F0 19         BEQ CODE_00DF1F           ; end GSU execution if r0 is zero
CODE_00DF06:        9C 3A 30      STZ $303A                 ; give SCPU ROM/RAM bus access
CODE_00DF09:        FC 26 DF      JSR ($DF26,x)             ; x = r0 (#$0002 - #$001A)

CODE_00DF0C:        E2 20         SEP #$20                  ;
CODE_00DF0E:        AD 2E 01      LDA $012E                 ;\ set SCMR
CODE_00DF11:        8D 3A 30      STA $303A                 ;/
CODE_00DF14:        C2 20         REP #$20                  ;
CODE_00DF16:        AD 1E 30      LDA $301E                 ;\
CODE_00DF19:        8D 1E 30      STA $301E                 ; | execute the GSU routine again
CODE_00DF1C:        98            TYA                       ; |
CODE_00DF1D:        80 CB         BRA CODE_00DEEA           ;/

CODE_00DF1F:        A0 00 00      LDY #$0000                ;\ give SCPU ROM/RAM bus access
CODE_00DF22:        8C 3A 30      STY $303A                 ;/
CODE_00DF25:        E2 10         SEP #$10                  ;
CODE_00DF27:        6B            RTL                       ;

; pointer table
; index is r0 after a GSU routine is called by $7EDECF
; when r0 is positive and non-zero
DATA_00DF28:	     dw $DF68		; r0 = #$0002
DATA_00DF2A:	     dw $E04F		; r0 = #$0004
DATA_00DF2C:	     dw $E0A9		; r0 = #$0006
DATA_00DF2E:	     dw $C0CD		; r0 = #$0008
DATA_00DF30:	     dw $DFC3		; r0 = #$000A
DATA_00DF32:	     dw $E023		; r0 = #$000C
DATA_00DF34:	     dw $E017		; r0 = #$000E
DATA_00DF36:	     dw $E0D7		; r0 = #$0010
DATA_00DF38:	     dw $E0E6		; r0 = #$0012
DATA_00DF3A:	     dw $E0F2		; r0 = #$0014
DATA_00DF3C:	     dw $DF44		; r0 = #$0016
DATA_00DF3E:	     dw $E068		; r0 = #$0018
DATA_00DF40:	     dw $E101		; r0 = #$001A
DATA_00DF42:	     dw $E126		; r0 = #$001C

; r0 = #$0016
CODE_00DF44:        5A            PHY                       ;
CODE_00DF45:        AD 1A 02      LDA $021A                 ;
CODE_00DF48:        C9 0B 00      CMP #$000B                ;
CODE_00DF4B:        D0 15         BNE CODE_00DF62           ;
CODE_00DF4D:        9C 1A 02      STZ $021A                 ;
CODE_00DF50:        A9 1F 00      LDA #$001F                ;
CODE_00DF53:        8D 18 01      STA $0118                 ;
CODE_00DF56:        A9 01 00      LDA #$0001                ;
CODE_00DF59:        8D 2D 02      STA $022D                 ;
CODE_00DF5C:        22 B7 B2 01   JSL CODE_01B2B7           ;
CODE_00DF60:        7A            PLY                       ;
CODE_00DF61:        60            RTS                       ;

CODE_00DF62:        22 B5 A4 02   JSL CODE_02A4B5           ;
CODE_00DF66:        7A            PLY                       ;
CODE_00DF67:        60            RTS                       ;

; r0 = #$0002
CODE_00DF68:        5A            PHY                       ;
CODE_00DF69:        E2 10         SEP #$10                  ;
CODE_00DF6B:        AD 0C 30      LDA $300C                 ; r6
CODE_00DF6E:        C9 00 A4      CMP #$A400                ;
CODE_00DF71:        D0 07         BNE CODE_00DF7A           ;

CODE_00DF73:        20 E2 DF      JSR CODE_00DFE2           ;
CODE_00DF76:        E2 10         SEP #$10                  ;
CODE_00DF78:        80 1D         BRA CODE_00DF97           ;

CODE_00DF7A:        AD 00 60      LDA $6000                 ;
CODE_00DF7D:        29 F0 FF      AND #$FFF0                ;
CODE_00DF80:        8D 00 00      STA $0000                 ;
CODE_00DF83:        AD 02 60      LDA $6002                 ;
CODE_00DF86:        29 F0 FF      AND #$FFF0                ;
CODE_00DF89:        8D 02 00      STA $0002                 ;
CODE_00DF8C:        22 20 A5 03   JSL CODE_03A520           ;
CODE_00DF90:        A9 09 00      LDA #$0009                ;\ play sound #$0009
CODE_00DF93:        22 D2 85 00   JSL CODE_0085D2           ;/
CODE_00DF97:        A9 E4 01      LDA #$01E4                ;
CODE_00DF9A:        22 21 8B 00   JSL CODE_008B21           ;
CODE_00DF9E:        AD 00 00      LDA $0000                 ;
CODE_00DFA1:        99 A2 70      STA $70A2,y               ;
CODE_00DFA4:        AD 02 00      LDA $0002                 ;
CODE_00DFA7:        99 42 71      STA $7142,y               ;
CODE_00DFAA:        A9 0C 00      LDA #$000C                ;
CODE_00DFAD:        99 C2 73      STA $73C2,y               ;
CODE_00DFB0:        A9 08 00      LDA #$0008                ;
CODE_00DFB3:        99 82 77      STA $7782,y               ;
CODE_00DFB6:        C2 10         REP #$10                  ;

CODE_00DFB8:        A9 00 00      LDA #$0000                ;
CODE_00DFBB:        8D 95 00      STA $0095                 ;
CODE_00DFBE:        A9 07 00      LDA #$0007                ;
CODE_00DFC1:        80 0A         BRA CODE_00DFCD           ;

; r0 = #$000A
CODE_00DFC3:        A9 00 00      LDA #$0000                ;
CODE_00DFC6:        8D 95 00      STA $0095                 ;
CODE_00DFC9:        5A            PHY                       ;
CODE_00DFCA:        A9 01 00      LDA #$0001                ;
CODE_00DFCD:        8D 8F 00      STA $008F                 ;
CODE_00DFD0:        AD 00 60      LDA $6000                 ;
CODE_00DFD3:        8D 91 00      STA $0091                 ;
CODE_00DFD6:        AD 02 60      LDA $6002                 ;
CODE_00DFD9:        8D 93 00      STA $0093                 ;
CODE_00DFDC:        22 95 92 10   JSL CODE_109295           ;
CODE_00DFE0:        7A            PLY                       ;
CODE_00DFE1:        60            RTS                       ;

CODE_00DFE2:        A9 93 00      LDA #$0093                ;
CODE_00DFE5:        EE B4 03      INC $03B4                 ;
CODE_00DFE8:        AC B4 03      LDY $03B4                 ;
CODE_00DFEB:        C0 14 00      CPY #$0014                ;
CODE_00DFEE:        30 01         BMI CODE_00DFF1           ;
CODE_00DFF0:        1A            INC A                     ;
CODE_00DFF1:        22 D2 85 00   JSL CODE_0085D2           ;
CODE_00DFF5:        A9 02 00      LDA #$0002                ;
CODE_00DFF8:        8D 06 00      STA $0006                 ;
CODE_00DFFB:        E2 10         SEP #$10                  ;
CODE_00DFFD:        AD 00 60      LDA $6000                 ;
CODE_00E000:        29 F0 FF      AND #$FFF0                ;
CODE_00E003:        8D 00 00      STA $0000                 ;
CODE_00E006:        AD 02 60      LDA $6002                 ;
CODE_00E009:        29 F0 FF      AND #$FFF0                ;
CODE_00E00C:        22 F5 A4 03   JSL CODE_03A4F5           ;
CODE_00E010:        C2 10         REP #$10                  ;
CODE_00E012:        60            RTS                       ;

CODE_00E013:        20 E2 DF      JSR CODE_00DFE2           ;
CODE_00E016:        6B            RTL                       ;

; r0 = #$000E
CODE_00E017:        AD 0A 30      LDA $300A                 ; r5
CODE_00E01A:        8D 95 00      STA $0095                 ;
CODE_00E01D:        80 AA         BRA CODE_00DFC9           ;

CODE_00E01F:        20 23 E0      JSR CODE_00E023           ;
CODE_00E022:        6B            RTL                       ;

; r0 = #$000C
CODE_00E023:        20 C3 DF      JSR CODE_00DFC3           ;
CODE_00E026:        5A            PHY                       ;
CODE_00E027:        AD 91 00      LDA $0091                 ;
CODE_00E02A:        18            CLC                       ;
CODE_00E02B:        69 10 00      ADC #$0010                ;
CODE_00E02E:        8D 91 00      STA $0091                 ;
CODE_00E031:        22 95 92 10   JSL CODE_109295           ;
CODE_00E035:        AD 93 00      LDA $0093                 ;
CODE_00E038:        18            CLC                       ;
CODE_00E039:        69 10 00      ADC #$0010                ;
CODE_00E03C:        8D 93 00      STA $0093                 ;
CODE_00E03F:        22 95 92 10   JSL CODE_109295           ;
CODE_00E043:        AD 00 60      LDA $6000                 ;
CODE_00E046:        8D 91 00      STA $0091                 ;
CODE_00E049:        22 95 92 10   JSL CODE_109295           ;
CODE_00E04D:        7A            PLY                       ;
CODE_00E04E:        60            RTS                       ;

; r0 = #$0004
CODE_00E04F:        5A            PHY                       ;
CODE_00E050:        AD 00 60      LDA $6000                 ;
CODE_00E053:        8D 91 00      STA $0091                 ;
CODE_00E056:        AD 02 60      LDA $6002                 ;
CODE_00E059:        8D 93 00      STA $0093                 ;
CODE_00E05C:        A9 00 00      LDA #$0000                ;
CODE_00E05F:        8D 8F 00      STA $008F                 ;
CODE_00E062:        22 95 92 10   JSL CODE_109295           ;
CODE_00E066:        7A            PLY                       ;
CODE_00E067:        60            RTS                       ;

; r0 = #$0018
CODE_00E068:        5A            PHY                       ;
CODE_00E069:        AD 00 60      LDA $6000                 ;
CODE_00E06C:        8D 91 00      STA $0091                 ;
CODE_00E06F:        AD 02 60      LDA $6002                 ;
CODE_00E072:        8D 93 00      STA $0093                 ;
CODE_00E075:        A9 06 00      LDA #$0006                ;
CODE_00E078:        8D 8F 00      STA $008F                 ;
CODE_00E07B:        22 95 92 10   JSL CODE_109295           ;
CODE_00E07F:        7A            PLY                       ;
CODE_00E080:        60            RTS                       ;

DATA_00E081:         dw $0000, $0000, $0000, $2A0D
DATA_00E089:         dw $0000, $0000, $0000, $2A1C
DATA_00E091:         dw $0000, $0000, $0000, $2A2B
DATA_00E099:         dw $0000, $0000, $0000, $2A3A
DATA_00E0A1:         dw $0000, $0000, $0000, $964C

; r0 = #$0006
CODE_00E0A9:        5A            PHY                       ;
CODE_00E0AA:        AD 0C 30      LDA $300C                 ; r6
CODE_00E0AD:        29 FF 00      AND #$00FF                ;
CODE_00E0B0:        0A            ASL A                     ;
CODE_00E0B1:        AA            TAX                       ;
CODE_00E0B2:        BF 81 E0 00   LDA $00E081,x             ;
CODE_00E0B6:        85 95         STA $95                   ;
CODE_00E0B8:        AD 00 60      LDA $6000                 ;
CODE_00E0BB:        85 91         STA $91                   ;
CODE_00E0BD:        AD 02 60      LDA $6002                 ;
CODE_00E0C0:        85 93         STA $93                   ;
CODE_00E0C2:        A9 04 00      LDA #$0004                ;
CODE_00E0C5:        85 8F         STA $8F                   ;
CODE_00E0C7:        22 95 92 10   JSL CODE_109295           ;
CODE_00E0CB:        7A            PLY                       ;
CODE_00E0CC:        60            RTS                       ;

CODE_00E0CD:        5A            PHY                       ;
CODE_00E0CE:        AE 02 30      LDX $3002                 ; r1
CODE_00E0D1:        22 87 BF 03   JSL CODE_03BF87           ;
CODE_00E0D5:        7A            PLY                       ;
CODE_00E0D6:        60            RTS                       ;

; r0 = #$0010
CODE_00E0D7:        AD 3E 01      LDA $013E                 ;
CODE_00E0DA:        C9 0A 00      CMP #$000A                ;
CODE_00E0DD:        D0 06         BNE CODE_00E0E5           ;
CODE_00E0DF:        5A            PHY                       ;
CODE_00E0E0:        22 F6 F1 04   JSL CODE_04F1F6           ;
CODE_00E0E4:        7A            PLY                       ;
CODE_00E0E5:        60            RTS                       ;

; r0 = #$0012
CODE_00E0E6:        AD CA 0C      LDA $0CCA                 ;
CODE_00E0E9:        D0 06         BNE CODE_00E0F1           ;
CODE_00E0EB:        5A            PHY                       ;
CODE_00E0EC:        22 9C AC 04   JSL CODE_04AC9C           ;
CODE_00E0F0:        7A            PLY                       ;
CODE_00E0F1:        60            RTS                       ;

; r0 = #$0014
CODE_00E0F2:        5A            PHY                       ;
CODE_00E0F3:        E2 10         SEP #$10                  ;
CODE_00E0F5:        22 53 A8 03   JSL CODE_03A853           ;
CODE_00E0F9:        C2 10         REP #$10                  ;
CODE_00E0FB:        7A            PLY                       ;
CODE_00E0FC:        60            RTS                       ;

DATA_00E0FD:	     dw $0080, $FF80

; r0 = #$001A
CODE_00E101:        AD CA 0C      LDA $0CCA                 ;
CODE_00E104:        D0 1F         BNE CODE_00E125           ;
CODE_00E106:        5A            PHY                       ;
CODE_00E107:        A9 28 00      LDA #$0028                ;
CODE_00E10A:        22 E2 F6 04   JSL CODE_04F6E2           ;
CODE_00E10E:        A9 00 FB      LDA #$FB00                ;
CODE_00E111:        8D AA 60      STA $60AA                 ;
CODE_00E114:        AE C4 60      LDX $60C4                 ;
CODE_00E117:        BF FD E0 00   LDA $00E0FD,x             ;
CODE_00E11B:        8D A8 60      STA $60A8                 ;
CODE_00E11E:        A9 20 00      LDA #$0020                ;
CODE_00E121:        8D F6 61      STA $61F6                 ;
CODE_00E124:        7A            PLY                       ;
CODE_00E125:        60            RTS                       ;

; r0 = #$001C
CODE_00E126:        5A            PHY                       ;
CODE_00E127:        AD 00 60      LDA $6000                 ;
CODE_00E12A:        8F 72 79 00   STA $007972               ;
CODE_00E12E:        E2 10         SEP #$10                  ;
CODE_00E130:        AA            TAX                       ;
CODE_00E131:        BD 60 73      LDA $7360,x               ;
CODE_00E134:        C9 15 01      CMP #$0115                ;
CODE_00E137:        F0 0B         BEQ CODE_00E144           ;
CODE_00E139:        C9 65 00      CMP #$0065                ;
CODE_00E13C:        D0 0C         BNE CODE_00E14A           ;
CODE_00E13E:        22 92 EA 0C   JSL CODE_0CEA92           ;
CODE_00E142:        80 0A         BRA CODE_00E14E           ;

CODE_00E144:        22 27 CA 04   JSL CODE_04CA27           ;
CODE_00E148:        80 04         BRA CODE_00E14E           ;

CODE_00E14A:        22 99 B4 0E   JSL CODE_0EB499           ;
CODE_00E14E:        C2 10         REP #$10                  ;
CODE_00E150:        7A            PLY                       ;
CODE_00E151:        60            RTS                       ;

.superfxinit5
CODE_00E152:        8B            PHB                       ; preserve bank
CODE_00E153:        9C 30 30      STZ $3030                 ; nuke status/flag register
CODE_00E156:        AC 2D 01      LDY $012D                 ;\ set SCBR
CODE_00E159:        8C 38 30      STY $3038                 ;/
CODE_00E15C:        AC 2E 01      LDY $012E                 ;\ set SCMR
CODE_00E15F:        8C 3A 30      STY $303A                 ;/
CODE_00E162:        8E 34 30      STX $3034                 ; set PBR
CODE_00E165:        8D 1E 30      STA $301E                 ; set program counter
CODE_00E168:        AD 1A 01      LDA $011A                 ;
CODE_00E16B:        F0 03         BEQ CODE_00E170           ;
CODE_00E16D:        4C 25 E2      JMP CODE_00E225           ;

CODE_00E170:        4B            PHK                       ;
CODE_00E171:        AB            PLB                       ;
CODE_00E172:        C2 10         REP #$10                  ;
CODE_00E174:        A6 04         LDX $04                   ;
CODE_00E176:        A4 06         LDY $06                   ;
CODE_00E178:        A9 0C 00      LDA #$000C                ;
CODE_00E17B:        85 0C         STA $0C                   ;
CODE_00E17D:        E0 FE 01      CPX #$01FE                ;
CODE_00E180:        90 06         BCC CODE_00E188           ;
CODE_00E182:        64 0E         STZ $0E                   ;
CODE_00E184:        A5 3F         LDA $3F                   ;
CODE_00E186:        80 66         BRA CODE_00E1EE           ;

CODE_00E188:        98            TYA                       ;
CODE_00E189:        4A            LSR A                     ;
CODE_00E18A:        4A            LSR A                     ;
CODE_00E18B:        85 08         STA $08                   ;
CODE_00E18D:        18            CLC                       ;
CODE_00E18E:        69 08 00      ADC #$0008                ;
CODE_00E191:        C9 20 00      CMP #$0020                ;
CODE_00E194:        90 03         BCC CODE_00E199           ;
CODE_00E196:        A9 20 00      LDA #$0020                ;
CODE_00E199:        0A            ASL A                     ;
CODE_00E19A:        85 0A         STA $0A                   ;
CODE_00E19C:        BD D4 E9      LDA $E9D4,x               ;
CODE_00E19F:        08            PHP                       ;
CODE_00E1A0:        10 04         BPL CODE_00E1A6           ;
CODE_00E1A2:        49 FF FF      EOR #$FFFF                ;
CODE_00E1A5:        1A            INC A                     ;
CODE_00E1A6:        C9 00 01      CMP #$0100                ;
CODE_00E1A9:        E2 20         SEP #$20                  ;
CODE_00E1AB:        EB            XBA                       ;
CODE_00E1AC:        A5 0A         LDA $0A                   ;
CODE_00E1AE:        B0 14         BCS CODE_00E1C4           ;
CODE_00E1B0:        8F 02 42 00   STA $004202               ;
CODE_00E1B4:        EB            XBA                       ;
CODE_00E1B5:        8F 03 42 00   STA $004203               ;
CODE_00E1B9:        EA            NOP                       ;
CODE_00E1BA:        EA            NOP                       ;
CODE_00E1BB:        EA            NOP                       ;
CODE_00E1BC:        C2 20         REP #$20                  ;
CODE_00E1BE:        AF 17 42 00   LDA $004217               ;
CODE_00E1C2:        80 02         BRA CODE_00E1C6           ;

CODE_00E1C4:        C2 20         REP #$20                  ;
CODE_00E1C6:        29 FF 00      AND #$00FF                ;
CODE_00E1C9:        4A            LSR A                     ;
CODE_00E1CA:        4A            LSR A                     ;
CODE_00E1CB:        4A            LSR A                     ;
CODE_00E1CC:        4A            LSR A                     ;
CODE_00E1CD:        28            PLP                       ;
CODE_00E1CE:        10 04         BPL CODE_00E1D4           ;
CODE_00E1D0:        49 FF FF      EOR #$FFFF                ;
CODE_00E1D3:        1A            INC A                     ;
CODE_00E1D4:        85 0E         STA $0E                   ;
CODE_00E1D6:        18            CLC                       ;
CODE_00E1D7:        65 08         ADC $08                   ;
CODE_00E1D9:        29 FF 00      AND #$00FF                ;
CODE_00E1DC:        C9 30 00      CMP #$0030                ;
CODE_00E1DF:        A5 0E         LDA $0E                   ;
CODE_00E1E1:        90 08         BCC CODE_00E1EB           ;
CODE_00E1E3:        A5 08         LDA $08                   ;
CODE_00E1E5:        49 FF FF      EOR #$FFFF                ;
CODE_00E1E8:        69 2F 00      ADC #$002F                ;
CODE_00E1EB:        18            CLC                       ;
CODE_00E1EC:        65 3F         ADC $3F                   ;
CODE_00E1EE:        99 C6 55      STA $55C6,y               ;
CODE_00E1F1:        A5 0E         LDA $0E                   ;
CODE_00E1F3:        99 C4 55      STA $55C4,y               ;
CODE_00E1F6:        DA            PHX                       ;
CODE_00E1F7:        8A            TXA                       ;
CODE_00E1F8:        C9 FE 01      CMP #$01FE                ;
CODE_00E1FB:        90 03         BCC CODE_00E200           ;
CODE_00E1FD:        A9 FE 01      LDA #$01FE                ;
CODE_00E200:        4A            LSR A                     ;
CODE_00E201:        29 FC 00      AND #$00FC                ;
CODE_00E204:        AA            TAX                       ;
CODE_00E205:        BD C2 54      LDA $54C2,x               ;
CODE_00E208:        99 C2 53      STA $53C2,y               ;
CODE_00E20B:        68            PLA                       ;
CODE_00E20C:        38            SEC                       ;
CODE_00E20D:        E9 10 00      SBC #$0010                ;
CODE_00E210:        29 FE 07      AND #$07FE                ;
CODE_00E213:        AA            TAX                       ;
CODE_00E214:        C8            INY                       ;
CODE_00E215:        C8            INY                       ;
CODE_00E216:        C8            INY                       ;
CODE_00E217:        C8            INY                       ;
CODE_00E218:        C6 0C         DEC $0C                   ;
CODE_00E21A:        F0 03         BEQ CODE_00E21F           ;
CODE_00E21C:        4C 7D E1      JMP CODE_00E17D           ;

CODE_00E21F:        86 04         STX $04                   ;
CODE_00E221:        84 06         STY $06                   ;
CODE_00E223:        E2 10         SEP #$10                  ;

CODE_00E225:        AB            PLB                       ;
CODE_00E226:        A9 20 00      LDA #$0020                ;\ start GSU execution
CODE_00E229:        2C 30 30      BIT $3030                 ;/\
CODE_00E22C:        D0 FB         BNE CODE_00E229           ; / wait for GSU execution to end
CODE_00E22E:        A0 00         LDY #$00                  ;\
CODE_00E230:        8C 3A 30      STY $303A                 ;/ give SCPU ROM/RAM bus access
CODE_00E233:        6B            RTL                       ;

DATA_00E234:	     dw $0064,$000A
DATA_00E238:	     dw $000A,$FFF6
DATA_00E23C:	     dw $012C,$0000

CODE_00E240:        C2 10         REP #$10                  ;
CODE_00E242:        AD 79 03      LDA $0379                 ;\
CODE_00E245:        C9 E8 03      CMP #$03E8                ; |
CODE_00E248:        90 14         BCC CODE_00E25E           ; | Prevents the player from getting >999 lives
							    ; |
CODE_00E24A:        A9 E7 03      LDA #$03E7                ; |
CODE_00E24D:        8D 79 03      STA $0379                 ;/
CODE_00E250:        AD 7F 03      LDA $037F                 ;
CODE_00E253:        C9 E8 03      CMP #$03E8                ;
CODE_00E256:        90 06         BCC CODE_00E25E           ;
CODE_00E258:        A9 E7 03      LDA #$03E7                ;
CODE_00E25B:        8D 7F 03      STA $037F                 ;

CODE_00E25E:        9C 89 03      STZ $0389                 ;
CODE_00E261:        EE A9 03      INC $03A9                 ;
CODE_00E264:        A0 00 00      LDY #$0000                ;
CODE_00E267:        AD 96 03      LDA $0396                 ;
CODE_00E26A:        F0 49         BEQ CODE_00E2B5           ;
CODE_00E26C:        10 02         BPL CODE_00E270           ;

CODE_00E26E:        C8            INY                       ;
CODE_00E26F:        C8            INY                       ;
CODE_00E270:        AD 57 0B      LDA $0B57                 ;
CODE_00E273:        D0 08         BNE CODE_00E27D           ;
CODE_00E275:        AD A9 03      LDA $03A9                 ;
CODE_00E278:        C9 08 00      CMP #$0008                ;
CODE_00E27B:        90 36         BCC CODE_00E2B3           ;
CODE_00E27D:        A9 36 00      LDA #$0036                ;
CODE_00E280:        20 72 E3      JSR CODE_00E372           ;

CODE_00E283:        9C A9 03      STZ $03A9                 ;
CODE_00E286:        AD B6 03      LDA $03B6                 ;
CODE_00E289:        18            CLC                       ;
CODE_00E28A:        79 38 E2      ADC $E238,y               ;
CODE_00E28D:        30 08         BMI CODE_00E297           ;
CODE_00E28F:        8D B6 03      STA $03B6                 ;
CODE_00E292:        D9 3C E2      CMP $E23C,y               ;
CODE_00E295:        90 0C         BCC CODE_00E2A3           ;
CODE_00E297:        B9 3C E2      LDA $E23C,y               ;
CODE_00E29A:        8D B6 03      STA $03B6                 ;
CODE_00E29D:        9C 96 03      STZ $0396                 ;
CODE_00E2A0:        4C 2C E3      JMP CODE_00E32C           ;

CODE_00E2A3:        AD 96 03      LDA $0396                 ;
CODE_00E2A6:        38            SEC                       ;
CODE_00E2A7:        F9 38 E2      SBC $E238,y               ;
CODE_00E2AA:        8D 96 03      STA $0396                 ;
CODE_00E2AD:        98            TYA                       ;
CODE_00E2AE:        D0 03         BNE CODE_00E2B3           ;
CODE_00E2B0:        EE 89 03      INC $0389                 ;
CODE_00E2B3:        80 77         BRA CODE_00E32C           ;

CODE_00E2B5:        AD 87 03      LDA $0387                 ;
CODE_00E2B8:        30 12         BMI CODE_00E2CC           ;
CODE_00E2BA:        D0 70         BNE CODE_00E32C           ;

CODE_00E2BC:        AD 57 0B      LDA $0B57                 ;
CODE_00E2BF:        0D 65 0B      ORA $0B65                 ;
CODE_00E2C2:        0D 7B 0B      ORA $0B7B                 ;
CODE_00E2C5:        0D 0F 0D      ORA $0D0F                 ;
CODE_00E2C8:        F0 2B         BEQ CODE_00E2F5           ;
CODE_00E2CA:        80 60         BRA CODE_00E32C           ;

CODE_00E2CC:        AD B6 03      LDA $03B6                 ;
CODE_00E2CF:        C9 6D 00      CMP #$006D                ;
CODE_00E2D2:        B0 58         BCS CODE_00E32C           ;
CODE_00E2D4:        EE 94 03      INC $0394                 ;
CODE_00E2D7:        AD 94 03      LDA $0394                 ;
CODE_00E2DA:        C9 0C 00      CMP #$000C                ;
CODE_00E2DD:        90 4D         BCC CODE_00E32C           ;

CODE_00E2DF:        9C 94 03      STZ $0394                 ;
CODE_00E2E2:        EE B6 03      INC $03B6                 ;
CODE_00E2E5:        AD B6 03      LDA $03B6                 ;
CODE_00E2E8:        C9 64 00      CMP #$0064                ;
CODE_00E2EB:        D0 3F         BNE CODE_00E32C           ;

CODE_00E2ED:        A9 32 00      LDA #$0032                ;
CODE_00E2F0:        20 72 E3      JSR CODE_00E372           ;

CODE_00E2F3:        80 37         BRA CODE_00E32C           ;

CODE_00E2F5:        9C 94 03      STZ $0394                 ;
CODE_00E2F8:        AD 8A 0C      LDA $0C8A                 ;
CODE_00E2FB:        D0 72         BNE CODE_00E36F           ;
CODE_00E2FD:        AD B6 03      LDA $03B6                 ;
CODE_00E300:        F0 6D         BEQ CODE_00E36F           ;
CODE_00E302:        EE 92 03      INC $0392                 ;
CODE_00E305:        AD 92 03      LDA $0392                 ;
CODE_00E308:        C9 04 00      CMP #$0004                ;
CODE_00E30B:        90 1F         BCC CODE_00E32C           ;
CODE_00E30D:        9C 92 03      STZ $0392                 ;
CODE_00E310:        CE B6 03      DEC $03B6                 ;
CODE_00E313:        AD B6 03      LDA $03B6                 ;
CODE_00E316:        C9 5A 00      CMP #$005A                ;
CODE_00E319:        B0 11         BCS CODE_00E32C           ;
CODE_00E31B:        AD AB 03      LDA $03AB                 ;
CODE_00E31E:        29 FF 00      AND #$00FF                ;
CODE_00E321:        D0 09         BNE CODE_00E32C           ;
CODE_00E323:        EE AB 03      INC $03AB                 ;
CODE_00E326:        A9 24 00      LDA #$0024                ;
CODE_00E329:        20 72 E3      JSR CODE_00E372           ;

CODE_00E32C:        A2 00 00      LDX #$0000                ;
CODE_00E32F:        AD B6 03      LDA $03B6                 ;
CODE_00E332:        C9 E8 03      CMP #$03E8                ;
CODE_00E335:        90 06         BCC CODE_00E33D           ;

CODE_00E337:        A9 E7 03      LDA #$03E7                ;
CODE_00E33A:        8D B6 03      STA $03B6                 ;

CODE_00E33D:        A0 00 00      LDY #$0000                ;

CODE_00E340:        DD 34 E2      CMP $E234,x               ;
CODE_00E343:        90 06         BCC CODE_00E34B           ;
CODE_00E345:        FD 34 E2      SBC $E234,x               ;
CODE_00E348:        C8            INY                       ;
CODE_00E349:        80 F5         BRA CODE_00E340           ;

CODE_00E34B:        94 00         STY $00,x                 ;
CODE_00E34D:        E8            INX                       ;
CODE_00E34E:        E8            INX                       ;
CODE_00E34F:        E0 04 00      CPX #$0004                ;
CODE_00E352:        D0 E9         BNE CODE_00E33D           ;
CODE_00E354:        95 00         STA $00,x                 ;
CODE_00E356:        A5 00         LDA $00                   ;
CODE_00E358:        8D A1 03      STA $03A1                 ;
CODE_00E35B:        A5 02         LDA $02                   ;
CODE_00E35D:        8D A3 03      STA $03A3                 ;
CODE_00E360:        A5 04         LDA $04                   ;
CODE_00E362:        8D A5 03      STA $03A5                 ;
CODE_00E365:        D0 08         BNE CODE_00E36F           ;
CODE_00E367:        AD 92 03      LDA $0392                 ;
CODE_00E36A:        D0 03         BNE CODE_00E36F           ;
CODE_00E36C:        EE 89 03      INC $0389                 ;

CODE_00E36F:        E2 10         SEP #$10                  ;
CODE_00E371:        60            RTS                       ;

CODE_00E372:        DA            PHX                       ;
CODE_00E373:        A6 57         LDX $57                   ;\
CODE_00E375:        95 59         STA $59,x                 ; | play sound
CODE_00E377:        E6 57         INC $57                   ;/
CODE_00E379:        FA            PLX                       ;
CODE_00E37A:        60            RTS                       ;

CODE_00E37B:        8B            PHB                       ;
CODE_00E37C:        4B            PHK                       ;
CODE_00E37D:        AB            PLB                       ;
CODE_00E37E:        20 AA E3      JSR CODE_00E3AA           ;
CODE_00E381:        AB            PLB                       ;
CODE_00E382:        6B            RTL                       ;

DATA_00E383:	     db $02,$40,$7E,$75,$82,$00,$08,$80
DATA_00E38B:	     db $17,$F2,$E8,$01,$2D,$B6,$01,$76
DATA_00E393:	     db $B9,$01,$00,$80,$17,$9E,$BC,$0F
DATA_00E39B:	     db $C1,$B6,$01,$FA,$E8,$01,$42,$E5
DATA_00E3A3:	     db $01,$02,$E9,$01,$D2,$E1,$10

CODE_00E3AA:        C2 10         REP #$10                  ;
CODE_00E3AC:        AC 27 01      LDY $0127                 ;
CODE_00E3AF:        BE 83 E3      LDX $E383,y               ;
CODE_00E3B2:        B9 85 E3      LDA $E385,y               ;
CODE_00E3B5:        20 4A E4      JSR CODE_00E44A           ;
CODE_00E3B8:        AD 27 01      LDA $0127                 ;
CODE_00E3BB:        D0 0D         BNE CODE_00E3CA           ;
CODE_00E3BD:        8F 00 40 7E   STA $7E4000               ;
CODE_00E3C1:        8F 01 40 7E   STA $7E4001               ;
CODE_00E3C5:        3A            DEC A                     ;
CODE_00E3C6:        8F 03 40 7E   STA $7E4003               ;
CODE_00E3CA:        9C 27 01      STZ $0127                 ;
CODE_00E3CD:        60            RTS                       ;

DATA_00E3CE:	     db $00,$48

DATA_00E3D0:	     db $7E,$2A,$B7,$11,$44,$B7,$11

CODE_00E3D7:        8B            PHB                       ;
CODE_00E3D8:        4B            PHK                       ;
CODE_00E3D9:        AB            PLB                       ;
CODE_00E3DA:        20 DF E3      JSR CODE_00E3DF           ;
CODE_00E3DD:        AB            PLB                       ;
CODE_00E3DE:        6B            RTL                       ;

CODE_00E3DF:        C2 10         REP #$10                  ;
CODE_00E3E1:        AE 29 01      LDX $0129                 ;
CODE_00E3E4:        BC CE E3      LDY $E3CE,x               ;
CODE_00E3E7:        BD D0 E3      LDA $E3D0,x               ;
CODE_00E3EA:        8B            PHB                       ;
CODE_00E3EB:        48            PHA                       ;
CODE_00E3EC:        AB            PLB                       ;
CODE_00E3ED:        85 00         STA $00                   ;
CODE_00E3EF:        C2 20         REP #$20                  ;
CODE_00E3F1:        B9 00 00      LDA $0000,y               ;
CODE_00E3F4:        85 04         STA $04                   ;
CODE_00E3F6:        C9 02 48      CMP #$4802                ;
CODE_00E3F9:        F0 48         BEQ CODE_00E443           ;
CODE_00E3FB:        C8            INY                       ;
CODE_00E3FC:        C8            INY                       ;
CODE_00E3FD:        B9 00 00      LDA $0000,y               ;
CODE_00E400:        8F 16 21 00   STA $002116               ;
CODE_00E404:        B9 04 00      LDA $0004,y               ;
CODE_00E407:        8F 01 43 00   STA $004301               ;
CODE_00E40B:        B9 06 00      LDA $0006,y               ;
CODE_00E40E:        8F 03 43 00   STA $004303               ;
CODE_00E412:        B9 08 00      LDA $0008,y               ;
CODE_00E415:        8F 05 43 00   STA $004305               ;
CODE_00E419:        B9 02 00      LDA $0002,y               ;
CODE_00E41C:        E2 20         SEP #$20                  ;
CODE_00E41E:        8F 15 21 00   STA $002115               ;
CODE_00E422:        EB            XBA                       ;
CODE_00E423:        8F 00 43 00   STA $004300               ;
CODE_00E427:        A9 01         LDA #$01                  ;
CODE_00E429:        8F 0B 42 00   STA $00420B               ;
CODE_00E42D:        C2 20         REP #$20                  ;
CODE_00E42F:        B9 0A 00      LDA $000A,y               ;
CODE_00E432:        A8            TAY                       ;
CODE_00E433:        C5 04         CMP $04                   ;
CODE_00E435:        D0 C6         BNE CODE_00E3FD           ;
CODE_00E437:        AF 29 01 00   LDA $000129               ;
CODE_00E43B:        D0 06         BNE CODE_00E443           ;
CODE_00E43D:        A9 02 48      LDA #$4802                ;
CODE_00E440:        8D 00 48      STA $4800                 ;
CODE_00E443:        AB            PLB                       ;
CODE_00E444:        9C 29 01      STZ $0129                 ;
CODE_00E447:        E2 30         SEP #$30                  ;
CODE_00E449:        60            RTS                       ;

CODE_00E44A:        8B            PHB                       ;
CODE_00E44B:        48            PHA                       ;
CODE_00E44C:        AB            PLB                       ;
CODE_00E44D:        85 00         STA $00                   ;
CODE_00E44F:        C2 20         REP #$20                  ;
CODE_00E451:        BC 00 00      LDY $0000,x               ;
CODE_00E454:        10 04         BPL CODE_00E45A           ;
CODE_00E456:        E2 30         SEP #$30                  ;
CODE_00E458:        AB            PLB                       ;
CODE_00E459:        60            RTS                       ;

CODE_00E45A:        BD 02 00      LDA $0002,x               ;
CODE_00E45D:        29 FF 1F      AND #$1FFF                ;
CODE_00E460:        1A            INC A                     ;
CODE_00E461:        85 01         STA $01                   ;
CODE_00E463:        85 03         STA $03                   ;
CODE_00E465:        A9 80 00      LDA #$0080                ;
CODE_00E468:        3C 02 00      BIT $0002,x               ;
CODE_00E46B:        10 03         BPL CODE_00E470           ;
CODE_00E46D:        A9 81 00      LDA #$0081                ;
CODE_00E470:        8F 15 21 00   STA $002115               ;
CODE_00E474:        85 05         STA $05                   ;
CODE_00E476:        98            TYA                       ;
CODE_00E477:        8F 16 21 00   STA $002116               ;
CODE_00E47B:        BD 02 00      LDA $0002,x               ;
CODE_00E47E:        29 00 20      AND #$2000                ;
CODE_00E481:        F0 1C         BEQ CODE_00E49F           ;
CODE_00E483:        A9 03 00      LDA #$0003                ;
CODE_00E486:        85 03         STA $03                   ;
CODE_00E488:        BD 04 00      LDA $0004,x               ;
CODE_00E48B:        8F 02 43 00   STA $004302               ;
CODE_00E48F:        BD 05 00      LDA $0005,x               ;
CODE_00E492:        8F 03 43 00   STA $004303               ;
CODE_00E496:        AF 39 21 00   LDA $002139               ;
CODE_00E49A:        A9 81 39      LDA #$3981                ;
CODE_00E49D:        80 4C         BRA CODE_00E4EB           ;

CODE_00E49F:        A5 00         LDA $00                   ;
CODE_00E4A1:        8F 04 43 00   STA $004304               ;
CODE_00E4A5:        A0 01         LDY #$01                  ;
CODE_00E4A7:        18            CLC                       ;
CODE_00E4A8:        50 37         BVC CODE_00E4E1           ;
CODE_00E4AA:        46 01         LSR $01                   ;
CODE_00E4AC:        A9 02 00      LDA #$0002                ;
CODE_00E4AF:        85 03         STA $03                   ;
CODE_00E4B1:        A9 08 19      LDA #$1908                ;
CODE_00E4B4:        8F 00 43 00   STA $004300               ;
CODE_00E4B8:        8A            TXA                       ;
CODE_00E4B9:        18            CLC                       ;
CODE_00E4BA:        69 05 00      ADC #$0005                ;
CODE_00E4BD:        8F 02 43 00   STA $004302               ;
CODE_00E4C1:        A5 01         LDA $01                   ;
CODE_00E4C3:        8F 05 43 00   STA $004305               ;
CODE_00E4C7:        A9 00 01      LDA #$0100                ;
CODE_00E4CA:        8F 0A 42 00   STA $00420A               ;
CODE_00E4CE:        A5 05         LDA $05                   ;
CODE_00E4D0:        29 7F 00      AND #$007F                ;
CODE_00E4D3:        8F 15 21 00   STA $002115               ;
CODE_00E4D7:        BD 00 00      LDA $0000,x               ;
CODE_00E4DA:        8F 16 21 00   STA $002116               ;
CODE_00E4DE:        A0 08         LDY #$08                  ;
CODE_00E4E0:        18            CLC                       ;
CODE_00E4E1:        8A            TXA                       ;
CODE_00E4E2:        18            CLC                       ;
CODE_00E4E3:        69 04 00      ADC #$0004                ;
CODE_00E4E6:        8F 02 43 00   STA $004302               ;
CODE_00E4EA:        98            TYA                       ;
CODE_00E4EB:        8F 00 43 00   STA $004300               ;
CODE_00E4EF:        A5 01         LDA $01                   ;
CODE_00E4F1:        8F 05 43 00   STA $004305               ;
CODE_00E4F5:        A9 00 01      LDA #$0100                ;
CODE_00E4F8:        8F 0A 42 00   STA $00420A               ;
CODE_00E4FC:        8A            TXA                       ;
CODE_00E4FD:        18            CLC                       ;
CODE_00E4FE:        69 04 00      ADC #$0004                ;
CODE_00E501:        65 03         ADC $03                   ;
CODE_00E503:        AA            TAX                       ;
CODE_00E504:        4C 51 E4      JMP CODE_00E451           ;

CODE_00E507:        AD 12 42      LDA $4212                 ;\
CODE_00E50A:        4A            LSR A                     ; | enable auto-joypad read
CODE_00E50B:        B0 FA         BCS CODE_00E507           ;/
CODE_00E50D:        C2 30         REP #$30                  ;

.update_controllers					    ;\
CODE_00E50F:        AD 18 42      LDA $4218                 ; |\ load controller 1 data
CODE_00E512:        89 0F 00      BIT #$000F                ; | | filter out potentially unwanted bits
CODE_00E515:        F0 03         BEQ CODE_00E51A           ; | |
CODE_00E517:        A9 00 00      LDA #$0000                ; | |
CODE_00E51A:        8D 3C 09      STA $093C                 ; | |\ store filtered value to $093C and Y
CODE_00E51D:        A8            TAY                       ; | |/
CODE_00E51E:        4D 44 09      EOR $0944                 ; | | flip any disabled bits off
CODE_00E521:        2D 3C 09      AND $093C                 ; | | reset any disabled bits turned on
CODE_00E524:        8D 3E 09      STA $093E                 ; | | store controller data
CODE_00E527:        8C 44 09      STY $0944                 ; |/
CODE_00E52A:        AD 1A 42      LDA $421A                 ; |\ load controller 2 data
CODE_00E52D:        89 0F 00      BIT #$000F                ; | | filter out potentially unwanted bits
CODE_00E530:        F0 03         BEQ CODE_00E535           ; | |
CODE_00E532:        A9 00 00      LDA #$0000                ; | |
CODE_00E535:        8D 40 09      STA $0940                 ; | |\ store filtered value to $0940 and Y
CODE_00E538:        A8            TAY                       ; | |/
CODE_00E539:        4D 46 09      EOR $0946                 ; | | flip any disabled bits off
CODE_00E53C:        2D 40 09      AND $0940                 ; | | reset any disabled bits turned on
CODE_00E53F:        8D 42 09      STA $0942                 ; | | store controller data
CODE_00E542:        8C 46 09      STY $0946                 ; |/
CODE_00E545:        AD 3C 09      LDA $093C                 ; |
CODE_00E548:        85 35         STA $35                   ; |
CODE_00E54A:        AD 3E 09      LDA $093E                 ; |
CODE_00E54D:        85 37         STA $37                   ; |
CODE_00E54F:        E2 30         SEP #$30                  ; |
CODE_00E551:        60            RTS                       ;/

; 1024 bytes moved to $702200
; division lookup table for gsu: 1/x
DATA_00E552:         dw $FFFF, $FFFF, $8000, $5555
DATA_00E55A:         dw $4000, $3333, $2AAA, $2492
DATA_00E562:         dw $2000, $1C71, $1999, $1745
DATA_00E56A:         dw $1555, $13B1, $1249, $1111
DATA_00E572:         dw $1000, $0F0F, $0E38, $0D79
DATA_00E57A:         dw $0CCC, $0C30, $0BA2, $0B21
DATA_00E582:         dw $0AAA, $0A3D, $09D8, $097B
DATA_00E58A:         dw $0924, $08D3, $0888, $0842
DATA_00E592:         dw $0800, $07C1, $0787, $0750
DATA_00E59A:         dw $071C, $06EB, $06BC, $0690
DATA_00E5A2:         dw $0666, $063E, $0618, $05F4
DATA_00E5AA:         dw $05D1, $05B0, $0590, $0572
DATA_00E5B2:         dw $0555, $0539, $051E, $0505
DATA_00E5BA:         dw $04EC, $04D4, $04BD, $04A7
DATA_00E5C2:         dw $0492, $047D, $0469, $0456
DATA_00E5CA:         dw $0444, $0432, $0421, $0410
DATA_00E5D2:         dw $0400, $03F0, $03E0, $03D2
DATA_00E5DA:         dw $03C3, $03B5, $03A8, $039B
DATA_00E5E2:         dw $038E, $0381, $0375, $0369
DATA_00E5EA:         dw $035E, $0353, $0348, $033D
DATA_00E5F2:         dw $0333, $0329, $031F, $0315
DATA_00E5FA:         dw $030C, $0303, $02FA, $02F1
DATA_00E602:         dw $02E8, $02E0, $02D8, $02D0
DATA_00E60A:         dw $02C8, $02C0, $02B9, $02B1
DATA_00E612:         dw $02AA, $02A3, $029C, $0295
DATA_00E61A:         dw $028F, $0288, $0282, $027C
DATA_00E622:         dw $0276, $0270, $026A, $0264
DATA_00E62A:         dw $025E, $0259, $0253, $024E
DATA_00E632:         dw $0249, $0243, $023E, $0239
DATA_00E63A:         dw $0234, $0230, $022B, $0226
DATA_00E642:         dw $0222, $021D, $0219, $0214
DATA_00E64A:         dw $0210, $020C, $0208, $0204
DATA_00E652:         dw $0200, $01FC, $01F8, $01F4
DATA_00E65A:         dw $01F0, $01EC, $01E9, $01E5
DATA_00E662:         dw $01E1, $01DE, $01DA, $01D7
DATA_00E66A:         dw $01D4, $01D0, $01CD, $01CA
DATA_00E672:         dw $01C7, $01C3, $01C0, $01BD
DATA_00E67A:         dw $01BA, $01B7, $01B4, $01B2
DATA_00E682:         dw $01AF, $01AC, $01A9, $01A6
DATA_00E68A:         dw $01A4, $01A1, $019E, $019C
DATA_00E692:         dw $0199, $0197, $0194, $0192
DATA_00E69A:         dw $018F, $018D, $018A, $0188
DATA_00E6A2:         dw $0186, $0183, $0181, $017F
DATA_00E6AA:         dw $017D, $017A, $0178, $0176
DATA_00E6B2:         dw $0174, $0172, $0170, $016E
DATA_00E6BA:         dw $016C, $016A, $0168, $0166
DATA_00E6C2:         dw $0164, $0162, $0160, $015E
DATA_00E6CA:         dw $015C, $015A, $0158, $0157
DATA_00E6D2:         dw $0155, $0153, $0151, $0150
DATA_00E6DA:         dw $014E, $014C, $014A, $0149
DATA_00E6E2:         dw $0147, $0146, $0144, $0142
DATA_00E6EA:         dw $0141, $013F, $013E, $013C
DATA_00E6F2:         dw $013B, $0139, $0138, $0136
DATA_00E6FA:         dw $0135, $0133, $0132, $0130
DATA_00E702:         dw $012F, $012E, $012C, $012B
DATA_00E70A:         dw $0129, $0128, $0127, $0125
DATA_00E712:         dw $0124, $0123, $0121, $0120
DATA_00E71A:         dw $011F, $011E, $011C, $011B
DATA_00E722:         dw $011A, $0119, $0118, $0116
DATA_00E72A:         dw $0115, $0114, $0113, $0112
DATA_00E732:         dw $0111, $010F, $010E, $010D
DATA_00E73A:         dw $010C, $010B, $010A, $0109
DATA_00E742:         dw $0108, $0107, $0106, $0105
DATA_00E74A:         dw $0104, $0103, $0102, $0101
DATA_00E752:         dw $0100, $00FF, $00FE, $00FD
DATA_00E75A:         dw $00FC, $00FB, $00FA, $00F9
DATA_00E762:         dw $00F8, $00F7, $00F6, $00F5
DATA_00E76A:         dw $00F4, $00F3, $00F2, $00F1
DATA_00E772:         dw $00F0, $00F0, $00EF, $00EE
DATA_00E77A:         dw $00ED, $00EC, $00EB, $00EA
DATA_00E782:         dw $00EA, $00E9, $00E8, $00E7
DATA_00E78A:         dw $00E6, $00E5, $00E5, $00E4
DATA_00E792:         dw $00E3, $00E2, $00E1, $00E1
DATA_00E79A:         dw $00E0, $00DF, $00DE, $00DE
DATA_00E7A2:         dw $00DD, $00DC, $00DB, $00DB
DATA_00E7AA:         dw $00DA, $00D9, $00D9, $00D8
DATA_00E7B2:         dw $00D7, $00D6, $00D6, $00D5
DATA_00E7BA:         dw $00D4, $00D4, $00D3, $00D2
DATA_00E7C2:         dw $00D2, $00D1, $00D0, $00D0
DATA_00E7CA:         dw $00CF, $00CE, $00CE, $00CD
DATA_00E7D2:         dw $00CC, $00CC, $00CB, $00CA
DATA_00E7DA:         dw $00CA, $00C9, $00C9, $00C8
DATA_00E7E2:         dw $00C7, $00C7, $00C6, $00C5
DATA_00E7EA:         dw $00C5, $00C4, $00C4, $00C3
DATA_00E7F2:         dw $00C3, $00C2, $00C1, $00C1
DATA_00E7FA:         dw $00C0, $00C0, $00BF, $00BF
DATA_00E802:         dw $00BE, $00BD, $00BD, $00BC
DATA_00E80A:         dw $00BC, $00BB, $00BB, $00BA
DATA_00E812:         dw $00BA, $00B9, $00B9, $00B8
DATA_00E81A:         dw $00B8, $00B7, $00B7, $00B6
DATA_00E822:         dw $00B6, $00B5, $00B5, $00B4
DATA_00E82A:         dw $00B4, $00B3, $00B3, $00B2
DATA_00E832:         dw $00B2, $00B1, $00B1, $00B0
DATA_00E83A:         dw $00B0, $00AF, $00AF, $00AE
DATA_00E842:         dw $00AE, $00AD, $00AD, $00AC
DATA_00E84A:         dw $00AC, $00AC, $00AB, $00AB
DATA_00E852:         dw $00AA, $00AA, $00A9, $00A9
DATA_00E85A:         dw $00A8, $00A8, $00A8, $00A7
DATA_00E862:         dw $00A7, $00A6, $00A6, $00A5
DATA_00E86A:         dw $00A5, $00A5, $00A4, $00A4
DATA_00E872:         dw $00A3, $00A3, $00A3, $00A2
DATA_00E87A:         dw $00A2, $00A1, $00A1, $00A1
DATA_00E882:         dw $00A0, $00A0, $009F, $009F
DATA_00E88A:         dw $009F, $009E, $009E, $009D
DATA_00E892:         dw $009D, $009D, $009C, $009C
DATA_00E89A:         dw $009C, $009B, $009B, $009A
DATA_00E8A2:         dw $009A, $009A, $0099, $0099
DATA_00E8AA:         dw $0099, $0098, $0098, $0098
DATA_00E8B2:         dw $0097, $0097, $0097, $0096
DATA_00E8BA:         dw $0096, $0095, $0095, $0095
DATA_00E8C2:         dw $0094, $0094, $0094, $0093
DATA_00E8CA:         dw $0093, $0093, $0092, $0092
DATA_00E8D2:         dw $0092, $0091, $0091, $0091
DATA_00E8DA:         dw $0090, $0090, $0090, $0090
DATA_00E8E2:         dw $008F, $008F, $008F, $008E
DATA_00E8EA:         dw $008E, $008E, $008D, $008D
DATA_00E8F2:         dw $008D, $008C, $008C, $008C
DATA_00E8FA:         dw $008C, $008B, $008B, $008B
DATA_00E902:         dw $008A, $008A, $008A, $0089
DATA_00E90A:         dw $0089, $0089, $0089, $0088
DATA_00E912:         dw $0088, $0088, $0087, $0087
DATA_00E91A:         dw $0087, $0087, $0086, $0086
DATA_00E922:         dw $0086, $0086, $0085, $0085
DATA_00E92A:         dw $0085, $0084, $0084, $0084
DATA_00E932:         dw $0084, $0083, $0083, $0083
DATA_00E93A:         dw $0083, $0082, $0082, $0082
DATA_00E942:         dw $0082, $0081, $0081, $0081
DATA_00E94A:         dw $0081, $0080, $0080, $0080

DATA_00E953:         db $00

; mode 7 stuff?
DATA_00E954:         dw $0100, $0100, $0100, $00FF
DATA_00E95C:         dw $00FF, $00FE, $00FD, $00FC
DATA_00E964:         dw $00FB, $00FA, $00F8, $00F7
DATA_00E96C:         dw $00F5, $00F3, $00F1, $00EF
DATA_00E974:         dw $00ED, $00EA, $00E7, $00E5
DATA_00E97C:         dw $00E2, $00DF, $00DC, $00D8
DATA_00E984:         dw $00D5, $00D1, $00CE, $00CA
DATA_00E98C:         dw $00C6, $00C2, $00BE, $00B9
DATA_00E994:         dw $00B5, $00B1, $00AC, $00A7
DATA_00E99C:         dw $00A2, $009D, $0098, $0093
DATA_00E9A4:         dw $008E, $0089, $0084, $007E
DATA_00E9AC:         dw $0079, $0073, $006D, $0068
DATA_00E9B4:         dw $0062, $005C, $0056, $0050
DATA_00E9BC:         dw $004A, $0044, $003E, $0038
DATA_00E9C4:         dw $0032, $002C, $0026, $001F
DATA_00E9CC:         dw $0019, $0013, $000D, $0006

DATA_00E9D4:         dw $0000, $FFFA, $FFF3, $FFED
DATA_00E9DC:         dw $FFE7, $FFE1, $FFDA, $FFD4
DATA_00E9E4:         dw $FFCE, $FFC8, $FFC2, $FFBC
DATA_00E9EC:         dw $FFB6, $FFB0, $FFAA, $FFA4
DATA_00E9F4:         dw $FF9E, $FF98, $FF93, $FF8D
DATA_00E9FC:         dw $FF87, $FF82, $FF7C, $FF77
DATA_00EA04:         dw $FF72, $FF6D, $FF68, $FF63
DATA_00EA0C:         dw $FF5E, $FF59, $FF54, $FF4F
DATA_00EA14:         dw $FF4B, $FF47, $FF42, $FF3E
DATA_00EA1C:         dw $FF3A, $FF36, $FF32, $FF2F
DATA_00EA24:         dw $FF2B, $FF28, $FF24, $FF21
DATA_00EA2C:         dw $FF1E, $FF1B, $FF19, $FF16
DATA_00EA34:         dw $FF13, $FF11, $FF0F, $FF0D
DATA_00EA3C:         dw $FF0B, $FF09, $FF08, $FF06
DATA_00EA44:         dw $FF05, $FF04, $FF03, $FF02
DATA_00EA4C:         dw $FF01, $FF01, $FF00, $FF00

DATA_00EA57:         dw $00FF, $01FF, $01FF, $02FF
DATA_00EA5F:         dw $03FF, $04FF, $05FF, $06FF
DATA_00EA67:         dw $08FF, $09FF, $0BFF, $0DFF
DATA_00EA6F:         dw $0FFF, $11FF, $13FF, $16FF
DATA_00EA77:         dw $19FF, $1BFF, $1EFF, $21FF
DATA_00EA7F:         dw $24FF, $28FF, $2BFF, $2FFF
DATA_00EA87:         dw $32FF, $36FF, $3AFF, $3EFF
DATA_00EA8F:         dw $42FF, $47FF, $4BFF, $4FFF
DATA_00EA97:         dw $54FF, $59FF, $5EFF, $63FF
DATA_00EA9F:         dw $68FF, $6DFF, $72FF, $77FF
DATA_00EAA7:         dw $7CFF, $82FF, $87FF, $8DFF
DATA_00EAAF:         dw $93FF, $98FF, $9EFF, $A4FF
DATA_00EAB7:         dw $AAFF, $B0FF, $B6FF, $BCFF
DATA_00EABF:         dw $C2FF, $C8FF, $CEFF, $D4FF
DATA_00EAC7:         dw $DAFF, $E1FF, $E7FF, $EDFF
DATA_00EACF:         dw $F3FF, $FAFF, $00FF

DATA_00EAD5:         dw $0600, $0D00, $1300, $1900
DATA_00EADD:         dw $1F00, $2600, $2C00, $3200
DATA_00EAE5:         dw $3800, $3E00, $4400, $4A00
DATA_00EAED:         dw $5000, $5600, $5C00, $6200
DATA_00EAF5:         dw $6800, $6D00, $7300, $7900
DATA_00EAFD:         dw $7E00, $8400, $8900, $8E00
DATA_00EB05:         dw $9300, $9800, $9D00, $A200
DATA_00EB0D:         dw $A700, $AC00, $B100, $B500
DATA_00EB15:         dw $B900, $BE00, $C200, $C600
DATA_00EB1D:         dw $CA00, $CE00, $D100, $D500
DATA_00EB25:         dw $D800, $DC00, $DF00, $E200
DATA_00EB2D:         dw $E500, $E700, $EA00, $ED00
DATA_00EB35:         dw $EF00, $F100, $F300, $F500
DATA_00EB3D:         dw $F700, $F800, $FA00, $FB00
DATA_00EB45:         dw $FC00, $FD00, $FE00, $FF00
DATA_00EB4D:         dw $FF00

DATA_00EB4F:         dw $0000, $0001, $0001, $0001
DATA_00EB57:         dw $0001, $FF01, $FF00, $FE00
DATA_00EB5F:         dw $FD00, $FC00, $FB00, $FA00
DATA_00EB67:         dw $F800, $F700, $F500, $F300
DATA_00EB6F:         dw $F100, $EF00, $ED00, $EA00
DATA_00EB77:         dw $E700, $E500, $E200, $DF00
DATA_00EB7F:         dw $DC00, $D800, $D500, $D100
DATA_00EB87:         dw $CE00, $CA00, $C600, $C200
DATA_00EB8F:         dw $BE00, $B900, $B500, $B100
DATA_00EB97:         dw $AC00, $A700, $A200, $9D00
DATA_00EB9F:         dw $9800, $9300, $8E00, $8900
DATA_00EBA7:         dw $8400, $7E00, $7900, $7300
DATA_00EBAF:         dw $6D00, $6800, $6200, $5C00
DATA_00EBB7:         dw $5600, $5000, $4A00, $4400
DATA_00EBBF:         dw $3E00, $3800, $3200, $2C00
DATA_00EBC7:         dw $2600, $1F00, $1900, $1300
DATA_00EBCF:         dw $0D00, $0600

DATA_00EBD3:         db $00

; level 10 header
DATA_00EBD4:         db $A3, $5F, $20, $30, $8D, $50, $58, $C9
DATA_00EBDC:         db $01, $00

; level 10 object data
DATA_00EBDE:         db $48, $22, $D0, $2F, $02, $48, $24, $76
DATA_00EBE6:         db $09, $05, $48, $24, $1D, $02, $04, $48
DATA_00EBEE:         db $24, $69, $06, $00, $C6, $12, $6A, $FA
DATA_00EBF6:         db $C4, $23, $57, $04, $C4, $22, $4D, $04
DATA_00EBFE:         db $C6, $13, $6E, $06, $C6, $12, $6C, $05
DATA_00EC06:         db $C6, $13, $6C, $FC, $3C, $24, $4B, $01
DATA_00EC0E:         db $48, $12, $00, $01, $1C, $48, $14, $9C
DATA_00EC16:         db $03, $06, $48, $20, $00, $01, $0B, $48
DATA_00EC1E:         db $20, $C0, $0F, $03, $48, $20, $B7, $08
DATA_00EC26:         db $00, $48, $20, $A8, $07, $00, $A5, $20
DATA_00EC2E:         db $8A, $02, $48, $20, $3E, $01, $06, $48
DATA_00EC36:         db $20, $08, $07, $02, $A6, $14, $E8, $04
DATA_00EC3E:         db $48, $24, $04, $0B, $00, $48, $24, $90
DATA_00EC46:         db $06, $00, $48, $12, $02, $27, $00, $C6
DATA_00EC4E:         db $12, $F3, $04, $A7, $22, $B2, $23, $01
DATA_00EC56:         db $48, $14, $08, $07, $08, $00, $14, $E5
DATA_00EC5E:         db $50, $00, $24, $56, $A8, $00, $20, $A5
DATA_00EC66:         db $50, $15, $12, $62, $02, $3C, $12, $33
DATA_00EC6E:         db $FD, $41, $24, $69, $03, $41, $24, $76
DATA_00EC76:         db $02, $41, $24, $90, $06, $41, $24, $04
DATA_00EC7E:         db $09, $41, $20, $C2, $05, $41, $20, $B7
DATA_00EC86:         db $01, $41, $20, $A8, $05, $FF

; level 10 screen exit data
DATA_00EC8C:         db $20, $48, $02, $72, $04, $24, $48, $AA
DATA_00EC94:         db $73, $04, $14, $78, $00, $58, $06, $12
DATA_00EC9C:         db $D4, $03, $7B, $05, $FF

; level 48 header
DATA_00ECA1:         db $A3, $5F, $20, $30, $8D, $60, $59, $A9
DATA_00ECA9:         db $01, $00

; level 48 object data
DATA_00ECAB:         db $00, $00, $1E, $FD, $00, $01, $11, $FD
DATA_00ECB3:         db $00, $02, $1E, $FD, $00, $03, $11, $FD
DATA_00ECBB:         db $00, $04, $1E, $FD, $00, $05, $11, $FD
DATA_00ECC3:         db $00, $06, $1E, $FD, $00, $07, $11, $FD
DATA_00ECCB:         db $48, $70, $00, $09, $01, $48, $7A, $00
DATA_00ECD3:         db $0F, $01, $48, $70, $20, $01, $07, $48
DATA_00ECDB:         db $70, $A0, $0F, $05, $47, $71, $C0, $6F
DATA_00ECE3:         db $03, $47, $78, $C0, $21, $03, $A5, $70
DATA_00ECEB:         db $02, $03, $00, $74, $A3, $9A, $D2, $74
DATA_00ECF3:         db $A4, $01, $CE, $74, $87, $FF, $D2, $74
DATA_00ECFB:         db $88, $05, $CE, $74, $8E, $02, $D2, $75
DATA_00ED03:         db $B1, $03, $00, $75, $A5, $91, $D1, $75
DATA_00ED0B:         db $66, $03, $00, $75, $56, $8E, $D2, $75
DATA_00ED13:         db $57, $01, $00, $75, $59, $8F, $D1, $75
DATA_00ED1B:         db $6A, $03, $00, $75, $AA, $90, $D2, $75
DATA_00ED23:         db $BB, $01, $CE, $75, $9E, $FF, $CE, $75
DATA_00ED2B:         db $9F, $01, $D2, $76, $B1, $01, $CE, $76
DATA_00ED33:         db $67, $FC, $D2, $76, $68, $06, $00, $76
DATA_00ED3B:         db $6F, $8F, $00, $76, $7F, $91, $D2, $76
DATA_00ED43:         db $89, $05, $00, $76, $88, $8E, $00, $76
DATA_00ED4B:         db $98, $90, $D2, $76, $A9, $05, $D1, $76
DATA_00ED53:         db $AF, $00, $D2, $76, $BF, $05, $CE, $77
DATA_00ED5B:         db $96, $FF, $00, $78, $89, $9C, $D1, $78
DATA_00ED63:         db $99, $01, $00, $78, $8E, $9C, $00, $79
DATA_00ED6B:         db $83, $9C, $D1, $78, $9E, $01, $D1, $79
DATA_00ED73:         db $93, $01, $00, $79, $A6, $9A, $D2, $79
DATA_00ED7B:         db $A7, $03, $D1, $79, $AB, $00, $48, $7A
DATA_00ED83:         db $90, $0F, $06, $48, $7A, $2C, $03, $06
DATA_00ED8B:         db $A5, $7A, $1A, $03, $00, $73, $7F, $9C
DATA_00ED93:         db $D1, $73, $8F, $02, $00, $73, $BF, $9D
DATA_00ED9B:         db $C6, $71, $55, $FE, $68, $71, $5D, $00
DATA_00EDA3:         db $00, $C4, $71, $37, $04, $68, $72, $80
DATA_00EDAB:         db $02, $02, $C4, $72, $65, $06, $C4, $73
DATA_00EDB3:         db $55, $06, $68, $74, $39, $03, $00, $68
DATA_00EDBB:         db $75, $16, $03, $00, $C4, $75, $5D, $04
DATA_00EDC3:         db $C6, $76, $27, $FC, $C4, $76, $29, $06
DATA_00EDCB:         db $C4, $77, $48, $02, $C6, $77, $56, $FE
DATA_00EDD3:         db $00, $77, $8E, $50, $00, $78, $82, $50
DATA_00EDDB:         db $68, $78, $68, $01, $00, $68, $78, $6D
DATA_00EDE3:         db $01, $00, $68, $79, $63, $00, $00, $00
DATA_00EDEB:         db $72, $94, $9A, $D2, $72, $95, $06, $00
DATA_00EDF3:         db $72, $9C, $9B, $48, $72, $BF, $04, $04
DATA_00EDFB:         db $48, $77, $AB, $0B, $05, $68, $73, $7D
DATA_00EE03:         db $00, $00, $00, $73, $80, $50, $68, $73
DATA_00EE0B:         db $73, $00, $00, $C4, $72, $50, $02, $68
DATA_00EE13:         db $72, $74, $00, $00, $68, $71, $7E, $00
DATA_00EE1B:         db $00, $00, $7A, $72, $50, $00, $7A, $76
DATA_00EE23:         db $50, $41, $70, $A2, $0D, $41, $72, $AF
DATA_00EE2B:         db $04, $41, $77, $AB, $0B, $41, $7A, $90
DATA_00EE33:         db $0B, $FF

; level 48 screen exit data
DATA_00EE35:         db $70, $10, $0A, $28, $05, $7A, $10, $4B
DATA_00EE3D:         db $24, $05, $FF

; level 78 header
DATA_00EE40:         db $05, $AF, $6C, $B8, $0D, $50, $70, $08
DATA_00EE48:         db $79, $20

; level 78 object data
DATA_00EE4A:         db $AC, $50, $70, $08, $AB, $50, $77, $19
DATA_00EE52:         db $AC, $60, $F7, $18, $AD, $50, $90, $06
DATA_00EE5A:         db $AA, $50, $95, $19, $AD, $70, $15, $05
DATA_00EE62:         db $AA, $70, $19, $02, $B2, $70, $2A, $FB
DATA_00EE6A:         db $B3, $70, $1E, $F8, $B0, $70, $0A, $03
DATA_00EE72:         db $03, $AC, $70, $80, $04, $AD, $70, $A0
DATA_00EE7A:         db $05, $AD, $70, $1F, $02, $AD, $71, $14
DATA_00EE82:         db $0B, $AA, $71, $10, $09, $AB, $71, $14
DATA_00EE8A:         db $03, $AD, $71, $32, $03, $AB, $71, $32
DATA_00EE92:         db $05, $B0, $71, $01, $02, $02, $B1, $70
DATA_00EE9A:         db $2A, $01, $B1, $71, $21, $01, $B1, $71
DATA_00EEA2:         db $42, $00, $B1, $71, $71, $00, $AC, $71
DATA_00EEAA:         db $72, $03, $AD, $71, $90, $05, $B2, $71
DATA_00EEB2:         db $57, $FF, $B7, $71, $96, $01, $AC, $71
DATA_00EEBA:         db $58, $05, $AD, $71, $B8, $05, $BC, $71
DATA_00EEC2:         db $5E, $07, $B0, $71, $76, $07, $03, $00
DATA_00EECA:         db $50, $80, $6F, $00, $70, $90, $6F, $00
DATA_00EED2:         db $71, $0E, $70, $AC, $00, $60, $0C, $AD
DATA_00EEDA:         db $00, $80, $0C, $00, $00, $5D, $74, $AC
DATA_00EEE2:         db $00, $5E, $01, $AD, $00, $9E, $01, $AF
DATA_00EEEA:         db $00, $7E, $01, $D4, $00, $4F, $07, $D6
DATA_00EEF2:         db $00, $4F, $06, $D5, $01, $45, $07, $D7
DATA_00EEFA:         db $00, $BF, $06, $D3, $01, $50, $04, $05
DATA_00EF02:         db $00, $00, $70, $6F, $AA, $20, $98, $08
DATA_00EF0A:         db $AB, $20, $9A, $06, $AC, $20, $EA, $07
DATA_00EF12:         db $AD, $30, $08, $08, $AA, $21, $70, $08
DATA_00EF1A:         db $AB, $21, $C2, $03, $AC, $21, $70, $0D
DATA_00EF22:         db $AB, $21, $7C, $04, $AC, $21, $AC, $03
DATA_00EF2A:         db $B0, $21, $92, $09, $02, $AD, $21, $C2
DATA_00EF32:         db $0D, $B6, $21, $F3, $02, $B7, $31, $01
DATA_00EF3A:         db $05, $AC, $31, $26, $02, $AF, $31, $46
DATA_00EF42:         db $02, $AD, $31, $67, $01, $AA, $30, $0A
DATA_00EF4A:         db $06, $AB, $30, $0E, $06, $AE, $30, $0C
DATA_00EF52:         db $06, $D4, $20, $21, $07, $D6, $20, $21
DATA_00EF5A:         db $0B, $D5, $20, $2C, $07, $D7, $20, $91
DATA_00EF62:         db $0B, $D3, $20, $32, $09, $05, $B1, $20
DATA_00EF6A:         db $B9, $00, $B1, $20, $E9, $00, $D4, $30
DATA_00EF72:         db $64, $04, $D6, $30, $64, $0C, $D5, $31
DATA_00EF7A:         db $60, $04, $D7, $30, $A4, $0C, $D3, $30
DATA_00EF82:         db $75, $0A, $02, $00, $21, $BE, $70, $D4
DATA_00EF8A:         db $21, $F8, $09, $D6, $21, $F8, $06, $D5
DATA_00EF92:         db $21, $FE, $09, $D7, $31, $88, $06, $D3
DATA_00EF9A:         db $31, $09, $04, $07, $B1, $30, $1B, $00
DATA_00EFA2:         db $B1, $30, $1E, $00, $B1, $30, $2C, $01
DATA_00EFAA:         db $B1, $30, $5C, $01, $B1, $30, $8C, $01
DATA_00EFB2:         db $00, $31, $02, $7F, $B1, $21, $F2, $00
DATA_00EFBA:         db $D6, $33, $11, $0D, $D5, $33, $1E, $0B
DATA_00EFC2:         db $D7, $33, $C1, $0D, $D4, $33, $11, $0B
DATA_00EFCA:         db $D3, $33, $22, $0B, $09, $FF

; level 78 screen exit data
DATA_00EFD0:         db $50, $10, $49, $1E, $03, $70, $A1, $78
DATA_00EFD8:         db $0A, $03, $71, $A1, $02, $29, $02, $00
DATA_00EFE0:         db $A1, $2D, $29, $03, $01, $78, $06, $38
DATA_00EFE8:         db $00, $30, $78, $12, $09, $00, $21, $A1
DATA_00EFF0:         db $04, $78, $02, $31, $78, $33, $3A, $00
DATA_00EFF8:         db $33, $78, $1B, $36, $00, $FF

; level A1 header
DATA_00EFFE:         db $03, $5C, $C3, $00, $05, $50, $28, $03
DATA_00F006:         db $01, $40

; level A1 object data
DATA_00F008:         db $00, $0D, $11, $FD, $00, $0E, $11, $FD
DATA_00F010:         db $00, $0F, $11, $FD, $48, $00, $00, $7F
DATA_00F018:         db $01, $44, $00, $42, $14, $08, $45, $01
DATA_00F020:         db $77, $03, $05, $48, $00, $20, $03, $01
DATA_00F028:         db $CD, $01, $77, $03, $FD, $48, $00, $40
DATA_00F030:         db $01, $04, $48, $00, $90, $06, $02, $48
DATA_00F038:         db $00, $C0, $12, $00, $48, $01, $A8, $03
DATA_00F040:         db $02, $48, $00, $D0, $1B, $02, $43, $00
DATA_00F048:         db $24, $01, $48, $01, $28, $03, $01, $43
DATA_00F050:         db $01, $29, $01, $8C, $00, $25, $13, $4E
DATA_00F058:         db $01, $BE, $04, $00, $48, $02, $A5, $16
DATA_00F060:         db $05, $48, $02, $68, $00, $01, $4E, $02
DATA_00F068:         db $79, $05, $00, $48, $02, $4F, $00, $03
DATA_00F070:         db $48, $03, $8B, $00, $01, $4E, $03, $8C
DATA_00F078:         db $02, $00, $4E, $03, $BC, $02, $00, $48
DATA_00F080:         db $03, $8F, $00, $02, $48, $03, $BF, $02
DATA_00F088:         db $04, $48, $04, $B5, $06, $04, $48, $04
DATA_00F090:         db $BF, $02, $04, $46, $07, $82, $03, $00
DATA_00F098:         db $CD, $07, $95, $04, $FC, $CD, $07, $C2
DATA_00F0A0:         db $03, $FD, $46, $06, $CE, $03, $00, $48
DATA_00F0A8:         db $05, $B5, $09, $01, $48, $06, $C1, $1E
DATA_00F0B0:         db $03, $48, $07, $6A, $05, $05, $53, $00
DATA_00F0B8:         db $96, $0C, $A6, $07, $A7, $03, $48, $07
DATA_00F0C0:         db $22, $0D, $03, $43, $01, $2C, $01, $8C
DATA_00F0C8:         db $01, $2D, $17, $43, $03, $25, $01, $48
DATA_00F0D0:         db $03, $26, $01, $01, $43, $03, $28, $01
DATA_00F0D8:         db $8C, $03, $29, $1B, $43, $05, $25, $03
DATA_00F0E0:         db $69, $05, $26, $05, $03, $48, $05, $26
DATA_00F0E8:         db $05, $00, $43, $05, $2C, $03, $8C, $05
DATA_00F0F0:         db $2D, $13, $43, $07, $21, $01, $C4, $06
DATA_00F0F8:         db $64, $04, $C4, $04, $6A, $02, $C4, $02
DATA_00F100:         db $5A, $0A, $68, $01, $AE, $01, $00, $68
DATA_00F108:         db $02, $A1, $01, $00, $48, $20, $00, $2F
DATA_00F110:         db $01, $48, $20, $20, $01, $09, $A6, $20
DATA_00F118:         db $91, $02, $A6, $22, $9C, $02, $48, $22
DATA_00F120:         db $2E, $01, $09, $48, $22, $B8, $07, $00
DATA_00F128:         db $6C, $21, $26, $02, $00, $6C, $21, $B3
DATA_00F130:         db $08, $00, $48, $20, $B2, $05, $00, $48
DATA_00F138:         db $20, $C0, $2F, $03, $F4, $20, $A8, $05
DATA_00F140:         db $F4, $22, $A6, $05, $48, $74, $00, $04
DATA_00F148:         db $05, $48, $70, $00, $41, $01, $48, $70
DATA_00F150:         db $20, $02, $09, $48, $70, $A0, $09, $01
DATA_00F158:         db $48, $71, $B1, $01, $00, $48, $70, $C0
DATA_00F160:         db $17, $03, $48, $72, $C1, $09, $03, $A6
DATA_00F168:         db $70, $82, $03, $F4, $70, $BA, $04, $00
DATA_00F170:         db $72, $85, $C4, $48, $73, $A3, $01, $02
DATA_00F178:         db $CB, $73, $A8, $01, $02, $46, $73, $A9
DATA_00F180:         db $03, $02, $CB, $73, $9E, $01, $00, $45
DATA_00F188:         db $73, $7D, $02, $01, $44, $73, $9D, $01
DATA_00F190:         db $03, $48, $73, $AE, $01, $02, $48, $73
DATA_00F198:         db $A7, $04, $00, $46, $74, $D5, $09, $00
DATA_00F1A0:         db $48, $73, $D3, $1C, $02, $46, $54, $78
DATA_00F1A8:         db $02, $00, $CB, $54, $78, $04, $02, $CD
DATA_00F1B0:         db $54, $CB, $02, $FC, $45, $54, $5B, $02
DATA_00F1B8:         db $02, $48, $54, $00, $0F, $01, $48, $54
DATA_00F1C0:         db $20, $07, $02, $48, $54, $28, $00, $02
DATA_00F1C8:         db $48, $54, $50, $01, $1A, $48, $54, $2E
DATA_00F1D0:         db $01, $2A, $48, $63, $02, $0F, $0F, $CC
DATA_00F1D8:         db $54, $CA, $FE, $FE, $48, $54, $CA, $05
DATA_00F1E0:         db $05, $53, $54, $89, $05, $A7, $54, $52
DATA_00F1E8:         db $00, $02, $A7, $54, $D9, $00, $04, $A7
DATA_00F1F0:         db $64, $4D, $00, $07, $A7, $64, $82, $00
DATA_00F1F8:         db $06, $A7, $64, $F2, $02, $00, $A7, $74
DATA_00F200:         db $64, $01, $00, $A7, $74, $45, $00, $01
DATA_00F208:         db $00, $63, $EE, $FE, $53, $73, $AB, $03
DATA_00F210:         db $C6, $54, $B7, $FC, $C6, $64, $B8, $04
DATA_00F218:         db $C6, $74, $4A, $FE, $F4, $06, $BB, $04
DATA_00F220:         db $00, $74, $92, $C4, $41, $70, $A3, $06
DATA_00F228:         db $41, $70, $CC, $0B, $41, $71, $B1, $01
DATA_00F230:         db $41, $72, $C1, $09, $41, $73, $A3, $01
DATA_00F238:         db $41, $73, $A7, $04, $41, $73, $D5, $08
DATA_00F240:         db $41, $73, $AE, $01, $41, $74, $D0, $0D
DATA_00F248:         db $41, $54, $C8, $03, $41, $20, $B2, $05
DATA_00F250:         db $41, $20, $CA, $1B, $41, $22, $B8, $05
DATA_00F258:         db $41, $00, $92, $04, $41, $01, $A8, $03
DATA_00F260:         db $41, $02, $A5, $15, $41, $04, $B0, $01
DATA_00F268:         db $41, $04, $B5, $06, $41, $04, $BF, $02
DATA_00F270:         db $41, $05, $B5, $09, $41, $06, $C1, $09
DATA_00F278:         db $41, $06, $CD, $0C, $A7, $54, $2B, $00
DATA_00F280:         db $00, $F4, $54, $CC, $01, $69, $64, $29
DATA_00F288:         db $04, $03, $69, $54, $12, $05, $03, $6C
DATA_00F290:         db $05, $4C, $00, $01, $6C, $05, $45, $00
DATA_00F298:         db $01, $48, $64, $28, $00, $03, $48, $64
DATA_00F2A0:         db $29, $06, $00, $68, $64, $55, $00, $00
DATA_00F2A8:         db $FF

; level A1 screen exit data
DATA_00F2A9:         db $07, $78, $00, $79, $06, $20, $78, $1F
DATA_00F2B1:         db $70, $07, $22, $78, $00, $07, $06, $70
DATA_00F2B9:         db $78, $1F, $2B, $07, $54, $BE, $18, $4A
DATA_00F2C1:         db $00, $FF

; level BE header
DATA_00F2C3:         db $10, $DB, $0C, $15, $8E, $B0, $08, $C0
DATA_00F2CB:         db $19, $60

; level BE object data
DATA_00F2CD:         db $00, $00, $1E, $FD, $00, $01, $11, $FD
DATA_00F2D5:         db $00, $02, $11, $FD, $01, $21, $60, $04
DATA_00F2DD:         db $29, $01, $41, $C5, $14, $03, $03, $21
DATA_00F2E5:         db $65, $26, $02, $22, $69, $26, $01, $22
DATA_00F2ED:         db $6A, $05, $29, $02, $31, $6B, $12, $01
DATA_00F2F5:         db $31, $6C, $06, $12, $03, $32, $63, $12
DATA_00F2FD:         db $58, $41, $8B, $08, $00, $14, $31, $51
DATA_00F305:         db $04, $07, $14, $31, $C1, $03, $04, $14
DATA_00F30D:         db $41, $01, $04, $09, $14, $41, $93, $02
DATA_00F315:         db $02, $67, $31, $81, $00, $01, $57, $31
DATA_00F31D:         db $E1, $02, $57, $41, $13, $01, $57, $41
DATA_00F325:         db $71, $01, $57, $41, $83, $01, $63, $31
DATA_00F32D:         db $86, $01, $63, $31, $B8, $01, $63, $31
DATA_00F335:         db $F7, $01, $63, $41, $28, $01, $63, $41
DATA_00F33D:         db $56, $01, $14, $31, $8B, $02, $0E, $14
DATA_00F345:         db $32, $81, $02, $02, $14, $31, $AD, $06
DATA_00F34D:         db $0D, $67, $31, $FE, $03, $00, $67, $42
DATA_00F355:         db $70, $01, $00, $57, $31, $CC, $01, $57
DATA_00F35D:         db $32, $D1, $01, $57, $41, $0C, $01, $57
DATA_00F365:         db $41, $3C, $02, $57, $42, $41, $01, $63
DATA_00F36D:         db $32, $85, $01, $63, $32, $C6, $01, $63
DATA_00F375:         db $32, $F5, $01, $63, $42, $24, $01, $63
DATA_00F37D:         db $42, $47, $01, $63, $42, $75, $01, $63
DATA_00F385:         db $42, $A6, $01, $14, $32, $49, $04, $05
DATA_00F38D:         db $14, $32, $9C, $02, $03, $14, $32, $C9
DATA_00F395:         db $05, $05, $14, $42, $1B, $03, $04, $14
DATA_00F39D:         db $42, $9A, $02, $02, $14, $42, $5A, $04
DATA_00F3A5:         db $04, $57, $32, $7A, $01, $57, $32, $DD
DATA_00F3AD:         db $01, $57, $32, $FA, $02, $57, $42, $2C
DATA_00F3B5:         db $02, $57, $42, $6C, $02, $14, $42, $59
DATA_00F3BD:         db $01, $06, $57, $42, $8A, $02, $67, $32
DATA_00F3C5:         db $5E, $00, $03, $57, $32, $8C, $01, $57
DATA_00F3CD:         db $41, $42, $01, $63, $41, $79, $01, $C6
DATA_00F3D5:         db $31, $8A, $FC, $C6, $41, $2A, $FC, $C6
DATA_00F3DD:         db $32, $84, $04, $C6, $42, $28, $FC, $C4
DATA_00F3E5:         db $42, $87, $00, $57, $31, $B3, $01, $02
DATA_00F3ED:         db $21, $CD, $05, $01, $21, $CE, $02, $05
DATA_00F3F5:         db $03, $22, $C1, $05, $58, $31, $1D, $04
DATA_00F3FD:         db $00, $14, $21, $EE, $02, $03, $FF

; level BE screen exit data
DATA_00F404:         db $42, $C8, $03, $38, $00, $FF

; level C8 header
DATA_00F40A:         db $A3, $5F, $20, $30, $8D, $50, $58, $00
DATA_00F412:         db $01, $40

; level C8 object data
DATA_00F414:         db $46, $30, $7F, $05, $00, $44, $31, $25
DATA_00F41C:         db $08, $04, $45, $31, $2E, $05, $04, $44
DATA_00F424:         db $30, $26, $02, $04, $CD, $30, $79, $05
DATA_00F42C:         db $FB, $CB, $30, $71, $08, $03, $CC, $32
DATA_00F434:         db $78, $FB, $FB, $44, $32, $29, $04, $04
DATA_00F43C:         db $CB, $32, $78, $06, $03, $48, $30, $00
DATA_00F444:         db $2F, $01, $48, $30, $20, $05, $04, $48
DATA_00F44C:         db $30, $70, $01, $03, $41, $30, $A2, $05
DATA_00F454:         db $48, $30, $B0, $09, $04, $41, $32, $B4
DATA_00F45C:         db $09, $48, $32, $97, $01, $06, $48, $32
DATA_00F464:         db $2E, $01, $09, $CB, $30, $7F, $14, $03
DATA_00F46C:         db $48, $31, $84, $02, $02, $41, $30, $BA
DATA_00F474:         db $04, $41, $31, $74, $02, $44, $30, $BF
DATA_00F47C:         db $04, $02, $48, $30, $BF, $00, $02, $48
DATA_00F484:         db $31, $B3, $00, $02, $48, $30, $EF, $04
DATA_00F48C:         db $01, $48, $31, $B4, $02, $00, $44, $31
DATA_00F494:         db $B7, $04, $02, $48, $31, $B7, $00, $02
DATA_00F49C:         db $48, $31, $BB, $00, $02, $48, $31, $E7
DATA_00F4A4:         db $04, $01, $41, $31, $BC, $02, $44, $31
DATA_00F4AC:         db $BF, $04, $02, $48, $31, $BF, $00, $02
DATA_00F4B4:         db $48, $32, $B3, $00, $02, $48, $31, $EF
DATA_00F4BC:         db $04, $01, $53, $30, $BF, $04, $53, $31
DATA_00F4C4:         db $B7, $04, $53, $31, $BF, $04, $53, $31
DATA_00F4CC:         db $5B, $04, $48, $31, $28, $03, $01, $48
DATA_00F4D4:         db $31, $4A, $01, $01, $49, $30, $37, $02
DATA_00F4DC:         db $49, $32, $3A, $02, $49, $31, $52, $02
DATA_00F4E4:         db $49, $31, $5F, $02, $FF

; level C8 screen exit data
DATA_00F4E9:         db $32, $CF, $04, $4D, $00, $FF

; level CF header
DATA_00F4EF:         db $03, $5E, $C0, $4A, $FD, $70, $60, $8F
DATA_00F4F7:         db $64, $00

; level CF object data
DATA_00F4F9:         db $48, $40, $00, $01, $1F, $48, $41, $06
DATA_00F501:         db $09, $1F, $48, $50, $C4, $0F, $00, $FF
DATA_00F509:         db $FF

; level D4 header
DATA_00F50A:         db $A3, $5F, $20, $30, $8D, $20, $58, $C9
DATA_00F512:         db $05, $E0

; level D4 object data
DATA_00F514:         db $48, $72, $2A, $05, $0A, $48, $70, $D0
DATA_00F51C:         db $2F, $02, $A5, $70, $B3, $02, $CB, $72
DATA_00F524:         db $26, $01, $01, $CB, $72, $57, $01, $07
DATA_00F52C:         db $44, $71, $5F, $07, $01, $44, $72, $27
DATA_00F534:         db $02, $04, $44, $72, $78, $01, $05, $CB
DATA_00F53C:         db $71, $8E, $01, $04, $CB, $70, $26, $0C
DATA_00F544:         db $01, $44, $70, $47, $17, $08, $CC, $70
DATA_00F54C:         db $96, $FC, $F9, $48, $70, $86, $03, $00
DATA_00F554:         db $48, $70, $96, $01, $03, $48, $70, $6C
DATA_00F55C:         db $00, $02, $53, $70, $89, $03, $48, $70
DATA_00F564:         db $5C, $04, $00, $48, $70, $4F, $17, $00
DATA_00F56C:         db $48, $71, $7E, $09, $00, $48, $71, $AE
DATA_00F574:         db $09, $00, $53, $72, $46, $04, $53, $71
DATA_00F57C:         db $AB, $03, $53, $70, $53, $03, $00, $70
DATA_00F584:         db $8B, $32, $50, $70, $9B, $01, $00, $70
DATA_00F58C:         db $BB, $35, $51, $70, $BC, $0F, $52, $71
DATA_00F594:         db $67, $FC, $04, $00, $71, $B3, $37, $51
DATA_00F59C:         db $71, $68, $0F, $00, $72, $68, $34, $50
DATA_00F5A4:         db $72, $58, $00, $00, $72, $48, $32, $00
DATA_00F5AC:         db $71, $BC, $34, $00, $71, $AC, $32, $00
DATA_00F5B4:         db $71, $B9, $3A, $50, $71, $C9, $00, $48
DATA_00F5BC:         db $70, $20, $01, $0A, $48, $70, $00, $2F
DATA_00F5C4:         db $01, $C4, $72, $80, $06, $C4, $72, $90
DATA_00F5CC:         db $06, $C4, $72, $B0, $06, $C4, $72, $C0
DATA_00F5D4:         db $06, $C4, $71, $23, $12, $C4, $71, $33
DATA_00F5DC:         db $12, $00, $70, $48, $3F, $00, $70, $59
DATA_00F5E4:         db $40, $00, $71, $72, $3F, $00, $70, $AF
DATA_00F5EC:         db $3C, $00, $71, $A8, $43, $00, $71, $A9
DATA_00F5F4:         db $44, $00, $70, $8E, $3F, $00, $71, $98
DATA_00F5FC:         db $41, $00, $71, $99, $42, $00, $71, $96
DATA_00F604:         db $45, $00, $71, $8A, $3F, $00, $72, $37
DATA_00F60C:         db $3F, $FF

; level D4 screen exit data
DATA_00F60E:         db $70, $10, $23, $12, $04, $FF

; level 10 sprite data
DATA_00F614:         db $1E, $4F, $42, $65, $34, $32, $65, $34
DATA_00F61C:         db $34, $65, $34, $36, $1E, $31, $26, $FF
DATA_00F624:         db $FF

; level 48 sprite data
DATA_00F625:         db $8A, $F2, $13, $80, $F8, $16, $1B, $F6
DATA_00F62D:         db $18, $1B, $F6, $20, $1B, $F6, $22, $81
DATA_00F635:         db $F8, $4A, $80, $F8, $38, $1B, $F6, $36
DATA_00F63D:         db $8A, $F5, $3F, $8A, $F3, $44, $89, $F3
DATA_00F645:         db $89, $8A, $F3, $97, $4F, $EA, $9D, $65
DATA_00F64D:         db $EC, $92, $FA, $F0, $6C, $8B, $F3, $93
DATA_00F655:         db $89, $F3, $8E, $1B, $F6, $1A, $8A, $F2
DATA_00F65D:         db $1D, $1B, $F6, $3A, $8A, $F1, $26, $65
DATA_00F665:         db $F2, $18, $65, $F2, $1A, $65, $F2, $36
DATA_00F66D:         db $65, $F2, $38, $65, $F2, $3A, $8D, $E2
DATA_00F675:         db $23, $FF, $FF

; level 78 sprite data
DATA_00F678:         db $65, $EE, $1A, $31, $13, $12, $93, $72
DATA_00F680:         db $06, $4F, $4A, $04, $65, $52, $15, $65
DATA_00F688:         db $52, $18, $AF, $53, $19, $AF, $53, $14
DATA_00F690:         db $AF, $53, $16, $AF, $53, $17, $AF, $EF
DATA_00F698:         db $18, $AF, $EF, $19, $AF, $EF, $1B, $AF
DATA_00F6A0:         db $EF, $1C, $B5, $62, $1B, $93, $76, $33
DATA_00F6A8:         db $93, $6E, $1B, $E7, $76, $3A, $61, $6B
DATA_00F6B0:         db $38, $FF, $FF

; level A1 sprite data
DATA_00F6B3:         db $05, $07, $17, $06, $07, $1E, $06, $07
DATA_00F6BB:         db $34, $05, $07, $39, $05, $07, $53, $06
DATA_00F6C3:         db $07, $5E, $06, $07, $70, $99, $0D, $58
DATA_00F6CB:         db $99, $0B, $46, $FA, $14, $3D, $DA, $10
DATA_00F6D3:         db $06, $65, $14, $20, $C0, $0C, $6A, $C1
DATA_00F6DB:         db $0C, $14, $05, $07, $05, $8A, $F8, $1C
DATA_00F6E3:         db $26, $E5, $16, $1E, $F6, $0A, $1E, $54
DATA_00F6EB:         db $08, $1E, $54, $26, $26, $47, $17, $8A
DATA_00F6F3:         db $F4, $2F, $26, $E5, $35, $1E, $F7, $49
DATA_00F6FB:         db $FA, $F8, $3B, $C2, $A4, $4B, $65, $C4
DATA_00F703:         db $43, $65, $D2, $46, $65, $E4, $4C, $1E
DATA_00F70B:         db $16, $6B, $BE, $DE, $44, $BE, $CE, $4D
DATA_00F713:         db $AD, $EC, $3E, $AD, $50, $0F, $1E, $B8
DATA_00F71B:         db $4C, $FF, $FF

; level BE sprite data
DATA_00F71E:         db $20, $8C, $12, $20, $7A, $12, $20, $7C
DATA_00F726:         db $20, $20, $8E, $1F, $20, $92, $27, $20
DATA_00F72E:         db $72, $2B, $31, $89, $2D, $01, $96, $18
DATA_00F736:         db $DA, $74, $14, $DA, $86, $21, $DA, $8E
DATA_00F73E:         db $2B, $65, $7C, $17, $65, $80, $19, $65
DATA_00F746:         db $7C, $27, $65, $80, $25, $4F, $66, $1F
DATA_00F74E:         db $FF, $FF

; level C8 sprite data
DATA_00F750:         db $01, $72, $03, $12, $74, $2B, $DA, $6C
DATA_00F758:         db $15, $DA, $7A, $11, $DA, $7A, $19, $DA
DATA_00F760:         db $7A, $21, $DA, $68, $1D, $6A, $6E, $0B
DATA_00F768:         db $6A, $6E, $0C, $6A, $6E, $0D, $4F, $6A
DATA_00F770:         db $10, $FF, $FF

; level CF sprite data
DATA_00F773:         db $34, $B6, $0B, $48, $98, $03, $FF, $FF

; level D4 sprite data
DATA_00F77B:         db $B2, $E4, $0A, $72, $EE, $10, $72, $F2
DATA_00F783:         db $11, $25, $E8, $04, $25, $E6, $04, $FA
DATA_00F78B:         db $EC, $23, $AF, $ED, $21, $AF, $ED, $25
DATA_00F793:         db $AF, $ED, $27, $AF, $ED, $1F, $98, $E8
DATA_00F79B:         db $28, $44, $E7, $0D, $D6, $EB, $2C, $97
DATA_00F7A3:         db $EF, $0B, $FF, $FF

; freespace
DATA_00F7A7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7AF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7B7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7BF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7C7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7CF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7D7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7DF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7E7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7EF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7F7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F7FF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F807:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F80F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F817:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F81F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F827:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F82F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F837:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F83F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F847:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F84F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F857:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F85F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F867:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F86F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F877:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F87F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F887:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F88F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F897:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F89F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8A7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8AF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8B7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8BF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8C7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8CF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8D7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8DF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8E7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8EF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8F7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F8FF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F907:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F90F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F917:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F91F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F927:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F92F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F937:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F93F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F947:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F94F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F957:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F95F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F967:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F96F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F977:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F97F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F987:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F98F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F997:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F99F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9A7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9AF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9B7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9BF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9C7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9CF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9D7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9DF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9E7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9EF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9F7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00F9FF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FA9F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAA7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAAF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAB7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FABF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAC7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FACF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAD7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FADF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAE7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAEF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAF7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FAFF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FB9F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBA7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBAF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBB7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBBF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBC7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBCF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBD7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBDF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBE7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBEF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBF7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FBFF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FC9F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCA7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCAF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCB7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCBF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCC7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCCF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCD7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCDF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCE7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCEF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCF7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FCFF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FD9F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDA7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDAF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDB7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDBF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDC7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDCF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDD7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDDF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDE7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDEF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDF7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FDFF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FE9F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEA7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEAF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEB7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEBF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEC7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FECF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FED7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEDF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEE7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEEF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEF7:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FEFF:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF07:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF0F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF17:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF1F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF27:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF2F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF37:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF3F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF47:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF4F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF57:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF5F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF67:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF6F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF77:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF7F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF87:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF8F:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF97:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FF9F:         db $FF

.buildtime
DATA_00FFA0:         db $95, $07, $31 		; build date (July 31st, 1995)
DATA_00FFA3:         db $11, $19 		; build time (11:19 am)

; freespace, 11 bytes
DATA_00FFA5:         db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
DATA_00FFAD:         db $FF, $FF, $FF

.ROMRegistration
	db $30,$31					    ; 
	db $59,$49,$20,$20				    ; "YI  "
	db $00,$00,$00,$00,$00,$00,$00			    ;
	db $05						    ; 32KB RAM allotted to Super FX
	db $00						    ; Not a special version
	db $00						    ;
    
.ROMSpecs    
	db $59,$4F,$53,$48,$49,$27,$53,$20		    ; "YOSHI'S "
	db $49,$53,$4C,$41,$4E,$44,$20,$20		    ; "ISLAND  "
	db $20,$20,$20,$20,$20				    ; "     "
	db $20						    ; LoROM
	db $15						    ; ROM + SuperFX + RAM + SRAM
	db $0B						    ; 2MB ROM
	db $00						    ; 2KB SRAM
	db $01						    ; NTSC
	db $33						    ; Extended header
	db $00						    ; Version 1.0
	dw $ECD3					    ; Checksum complement
	dw $132C					    ; Checksum
	dw $814F,$814F  				    ;
	dw $814F					    ; Native COP vector (unused)
	dw $814F					    ; Native BRK vector (unused)
	dw $814F					    ; Native ABORT vector (unused)
	dw $0108					    ; Native NMI vector (v-blank)
	dw $814F					    ; Native RESET vector (unused)
	dw $010C					    ; Native IRQ vector
	dw $814F,$814F  				    ;
	dw $814F					    ; Emulation COP vector (unused)
	dw $814F					    ; Emulation BRK vector (unused)
	dw $814F					    ; Emulation ABORT vector (unused)
	dw $814F					    ; Emulation NMI vector (unused)
	dw $8000					    ; Emulation RESET vector (start game)
	dw $814F					    ; Emulation IRQ and BRK vector (unused)