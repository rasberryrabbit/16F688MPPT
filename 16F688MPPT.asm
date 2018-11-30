
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;16F688MPPT.mpas,68 :: 		begin
;16F688MPPT.mpas,69 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt3
;16F688MPPT.mpas,70 :: 		PWM_SIG:=not PWM_SIG;
	MOVLW
	XORWF      RC1_bit+0, 1
;16F688MPPT.mpas,71 :: 		if PWM_SIG=0 then begin
	BTFSC      RC1_bit+0, BitPos(RC1_bit+0)
	GOTO       L__Interrupt6
;16F688MPPT.mpas,72 :: 		doADCRead:=1;
	MOVLW      1
	MOVWF      _doADCRead+0
;16F688MPPT.mpas,74 :: 		ON_PWM:=VOLPWM;
	MOVF       _VOLPWM+0, 0
	MOVWF      _ON_PWM+0
;16F688MPPT.mpas,75 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOLPWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;16F688MPPT.mpas,76 :: 		end else begin
	GOTO       L__Interrupt7
L__Interrupt6:
;16F688MPPT.mpas,78 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	ADDLW      25
	MOVWF      TMR0+0
;16F688MPPT.mpas,79 :: 		end;
L__Interrupt7:
;16F688MPPT.mpas,80 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;16F688MPPT.mpas,81 :: 		end;
L__Interrupt3:
;16F688MPPT.mpas,82 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt9
;16F688MPPT.mpas,83 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      248
	MOVWF      TMR1H+0
;16F688MPPT.mpas,84 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      48
	MOVWF      TMR1L+0
;16F688MPPT.mpas,85 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;16F688MPPT.mpas,86 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
	BTFSC      STATUS+0, 2
	INCF       _TICK_1000+1, 1
;16F688MPPT.mpas,87 :: 		end;
L__Interrupt9:
;16F688MPPT.mpas,88 :: 		end;
L_end_Interrupt:
L__Interrupt67:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;16F688MPPT.mpas,90 :: 		begin
;16F688MPPT.mpas,91 :: 		CMCON0:=7;
	MOVLW      7
	MOVWF      CMCON0+0
;16F688MPPT.mpas,92 :: 		ANSEL:=%00000101;       // ADC conversion clock = fRC, RA0=Current, RA2=Voltage
	MOVLW      5
	MOVWF      ANSEL+0
;16F688MPPT.mpas,93 :: 		TRISA0_bit:=1;
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;16F688MPPT.mpas,94 :: 		TRISA1_bit:=1;          // Vref
	BSF        TRISA1_bit+0, BitPos(TRISA1_bit+0)
;16F688MPPT.mpas,95 :: 		TRISA2_bit:=1;
	BSF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;16F688MPPT.mpas,96 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;16F688MPPT.mpas,97 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;16F688MPPT.mpas,98 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;16F688MPPT.mpas,100 :: 		TRISC1_bit:=0;          // PWM
	BCF        TRISC1_bit+0, BitPos(TRISC1_bit+0)
;16F688MPPT.mpas,101 :: 		TRISC4_bit:=0;          // LED
	BCF        TRISC4_bit+0, BitPos(TRISC4_bit+0)
;16F688MPPT.mpas,102 :: 		TRISC3_bit:=1;          // OP-AMP Cal
	BSF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;16F688MPPT.mpas,104 :: 		LED1:=0;
	BCF        RC4_bit+0, BitPos(RC4_bit+0)
;16F688MPPT.mpas,105 :: 		PWM_SIG:=1;
	BSF        RC1_bit+0, BitPos(RC1_bit+0)
;16F688MPPT.mpas,106 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,107 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;16F688MPPT.mpas,108 :: 		VOLPWM:=0;
	CLRF       _VOLPWM+0
;16F688MPPT.mpas,109 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
	CLRF       _TICK_1000+1
;16F688MPPT.mpas,111 :: 		OPTION_REG:=%11011111;        // ~4KHz @ 4MHz, 1000000 / 4 = 3.9k
	MOVLW      223
	MOVWF      OPTION_REG+0
;16F688MPPT.mpas,112 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;16F688MPPT.mpas,114 :: 		LM358_diff:=cLM358_diff;
	CLRF       _LM358_diff+0
;16F688MPPT.mpas,115 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,116 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,117 :: 		ClrWDT;
	CLRWDT
;16F688MPPT.mpas,119 :: 		if Write_OPAMP=0 then begin
	BTFSC      RC3_bit+0, BitPos(RC3_bit+0)
	GOTO       L__main13
;16F688MPPT.mpas,120 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,121 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,122 :: 		adc_cur:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;16F688MPPT.mpas,123 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;16F688MPPT.mpas,124 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,125 :: 		LED1:=1;
	BSF        RC4_bit+0, BitPos(RC4_bit+0)
;16F688MPPT.mpas,126 :: 		Delay_ms(700);
	MOVLW      8
	MOVWF      R11+0
	MOVLW      27
	MOVWF      R12+0
	MOVLW      39
	MOVWF      R13+0
L__main15:
	DECFSZ     R13+0, 1
	GOTO       L__main15
	DECFSZ     R12+0, 1
	GOTO       L__main15
	DECFSZ     R11+0, 1
	GOTO       L__main15
;16F688MPPT.mpas,127 :: 		LED1:=0;
	BCF        RC4_bit+0, BitPos(RC4_bit+0)
;16F688MPPT.mpas,128 :: 		end;
L__main13:
;16F688MPPT.mpas,129 :: 		ClrWDT;
	CLRWDT
;16F688MPPT.mpas,133 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,134 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;16F688MPPT.mpas,136 :: 		if LM358_diff>$1f then
	MOVF       R0+0, 0
	SUBLW      31
	BTFSC      STATUS+0, 0
	GOTO       L__main17
;16F688MPPT.mpas,137 :: 		LM358_diff:=0;
	CLRF       _LM358_diff+0
L__main17:
;16F688MPPT.mpas,143 :: 		T1CKPS1_bit:=0;
	BCF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;16F688MPPT.mpas,144 :: 		T1CKPS0_bit:=0;               // timer prescaler 1:1
	BCF        T1CKPS0_bit+0, BitPos(T1CKPS0_bit+0)
;16F688MPPT.mpas,146 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;16F688MPPT.mpas,147 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      48
	MOVWF      TMR1L+0
;16F688MPPT.mpas,148 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      248
	MOVWF      TMR1H+0
;16F688MPPT.mpas,149 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;16F688MPPT.mpas,151 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;16F688MPPT.mpas,152 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;16F688MPPT.mpas,153 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;16F688MPPT.mpas,155 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;16F688MPPT.mpas,156 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;16F688MPPT.mpas,158 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;16F688MPPT.mpas,160 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;16F688MPPT.mpas,162 :: 		VOLPWM:=PWM_MID;
	MOVLW      110
	MOVWF      _VOLPWM+0
;16F688MPPT.mpas,163 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;16F688MPPT.mpas,164 :: 		vol_prev1:=0;
	CLRF       _vol_prev1+0
	CLRF       _vol_prev1+1
;16F688MPPT.mpas,166 :: 		powertime:=0;
	CLRF       _powertime+0
	CLRF       _powertime+1
;16F688MPPT.mpas,167 :: 		prevtime:=0;
	CLRF       _prevtime+0
	CLRF       _prevtime+1
;16F688MPPT.mpas,168 :: 		voltime:=0;
	CLRF       _voltime+0
	CLRF       _voltime+1
;16F688MPPT.mpas,171 :: 		clrwdt;
	CLRWDT
;16F688MPPT.mpas,172 :: 		delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L__main19:
	DECFSZ     R13+0, 1
	GOTO       L__main19
	DECFSZ     R12+0, 1
	GOTO       L__main19
	DECFSZ     R11+0, 1
	GOTO       L__main19
	NOP
	NOP
;16F688MPPT.mpas,173 :: 		LED1:=1;
	BSF        RC4_bit+0, BitPos(RC4_bit+0)
;16F688MPPT.mpas,174 :: 		delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L__main20:
	DECFSZ     R13+0, 1
	GOTO       L__main20
	DECFSZ     R12+0, 1
	GOTO       L__main20
	DECFSZ     R11+0, 1
	GOTO       L__main20
	NOP
	NOP
;16F688MPPT.mpas,175 :: 		LED1:=0;
	BCF        RC4_bit+0, BitPos(RC4_bit+0)
;16F688MPPT.mpas,176 :: 		clrwdt;
	CLRWDT
;16F688MPPT.mpas,178 :: 		while True do begin
L__main22:
;16F688MPPT.mpas,180 :: 		wtmp := TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;16F688MPPT.mpas,181 :: 		if wtmp - prevtime > LED1_tm then begin
	MOVF       _prevtime+0, 0
	SUBWF      _TICK_1000+0, 0
	MOVWF      R1+0
	MOVF       _prevtime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _TICK_1000+1, 0
	MOVWF      R1+1
	MOVF       R1+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main69
	MOVF       R1+0, 0
	SUBWF      _LED1_tm+0, 0
L__main69:
	BTFSC      STATUS+0, 0
	GOTO       L__main27
;16F688MPPT.mpas,182 :: 		prevtime := wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _prevtime+0
	MOVF       _wtmp+1, 0
	MOVWF      _prevtime+1
;16F688MPPT.mpas,183 :: 		LED1 := not LED1;
	MOVLW
	XORWF      RC4_bit+0, 1
;16F688MPPT.mpas,184 :: 		end;
L__main27:
;16F688MPPT.mpas,187 :: 		doADCRead:=0;
	CLRF       _doADCRead+0
;16F688MPPT.mpas,189 :: 		vol_prev2:=vol_prev1;
	MOVF       _vol_prev1+0, 0
	MOVWF      _vol_prev2+0
	MOVF       _vol_prev1+1, 0
	MOVWF      _vol_prev2+1
;16F688MPPT.mpas,190 :: 		vol_prev1:=adc_vol;
	MOVF       _adc_vol+0, 0
	MOVWF      _vol_prev1+0
	MOVF       _adc_vol+1, 0
	MOVWF      _vol_prev1+1
;16F688MPPT.mpas,191 :: 		while doADCRead=0 do ;
L__main30:
	MOVF       _doADCRead+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main30
;16F688MPPT.mpas,193 :: 		adc_vol:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_vol+0
	MOVF       R0+1, 0
	MOVWF      _adc_vol+1
;16F688MPPT.mpas,194 :: 		adc_cur:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;16F688MPPT.mpas,195 :: 		for i:=0 to adc_max_loop-2 do begin
	CLRF       _i+0
L__main35:
;16F688MPPT.mpas,196 :: 		wtmp:=ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _wtmp+0
	MOVF       R0+1, 0
	MOVWF      _wtmp+1
;16F688MPPT.mpas,197 :: 		xtmp:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _xtmp+0
	MOVF       R0+1, 0
	MOVWF      _xtmp+1
;16F688MPPT.mpas,198 :: 		adc_vol:=(adc_vol+wtmp) div 2;
	MOVF       _wtmp+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       _wtmp+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
	RRF        _adc_vol+1, 1
	RRF        _adc_vol+0, 1
	BCF        _adc_vol+1, 7
;16F688MPPT.mpas,199 :: 		adc_cur:=(adc_cur+xtmp) div 2;
	MOVF       R0+0, 0
	ADDWF      _adc_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_cur+1, 1
	RRF        _adc_cur+1, 1
	RRF        _adc_cur+0, 1
	BCF        _adc_cur+1, 7
;16F688MPPT.mpas,200 :: 		end;
	MOVF       _i+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L__main38
	INCF       _i+0, 1
	GOTO       L__main35
L__main38:
;16F688MPPT.mpas,201 :: 		adc_vol:=adc_vol * VOLMUL;
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
	RLF        _adc_vol+0, 1
	RLF        _adc_vol+1, 1
	BCF        _adc_vol+0, 0
;16F688MPPT.mpas,204 :: 		wtmp:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;16F688MPPT.mpas,205 :: 		if wtmp - powertime < _UPDATE_INT then
	MOVF       _powertime+0, 0
	SUBWF      _TICK_1000+0, 0
	MOVWF      R1+0
	MOVF       _powertime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _TICK_1000+1, 0
	MOVWF      R1+1
	MOVLW      0
	SUBWF      R1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main70
	MOVLW      10
	SUBWF      R1+0, 0
L__main70:
	BTFSC      STATUS+0, 0
	GOTO       L__main40
;16F688MPPT.mpas,206 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
L__main40:
;16F688MPPT.mpas,207 :: 		clrwdt;
	CLRWDT
;16F688MPPT.mpas,208 :: 		powertime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _powertime+0
	MOVF       _wtmp+1, 0
	MOVWF      _powertime+1
;16F688MPPT.mpas,210 :: 		power_prev:= power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;16F688MPPT.mpas,211 :: 		power_curr:= adc_vol * adc_cur;
	MOVF       _adc_vol+0, 0
	MOVWF      R0+0
	MOVF       _adc_vol+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _adc_cur+0, 0
	MOVWF      R4+0
	MOVF       _adc_cur+1, 0
	MOVWF      R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      _power_curr+0
	MOVF       R0+1, 0
	MOVWF      _power_curr+1
	MOVF       R0+2, 0
	MOVWF      _power_curr+2
	MOVF       R0+3, 0
	MOVWF      _power_curr+3
;16F688MPPT.mpas,214 :: 		wtmp:=TICK_1000;
	MOVF       _TICK_1000+0, 0
	MOVWF      _wtmp+0
	MOVF       _TICK_1000+1, 0
	MOVWF      _wtmp+1
;16F688MPPT.mpas,215 :: 		if ON_PWM>PWM_MID then begin
	MOVF       _ON_PWM+0, 0
	SUBLW      110
	BTFSC      STATUS+0, 0
	GOTO       L__main43
;16F688MPPT.mpas,216 :: 		if wtmp - voltime > _PWM_CHECK then begin
	MOVF       _voltime+0, 0
	SUBWF      _wtmp+0, 0
	MOVWF      R1+0
	MOVF       _voltime+1, 0
	BTFSS      STATUS+0, 0
	ADDLW      1
	SUBWF      _wtmp+1, 0
	MOVWF      R1+1
	MOVF       R1+1, 0
	SUBLW      8
	BTFSS      STATUS+0, 2
	GOTO       L__main71
	MOVF       R1+0, 0
	SUBLW      202
L__main71:
	BTFSC      STATUS+0, 0
	GOTO       L__main46
;16F688MPPT.mpas,217 :: 		voltime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _voltime+0
	MOVF       _wtmp+1, 0
	MOVWF      _voltime+1
;16F688MPPT.mpas,218 :: 		adc_cur:=LM358_diff;
	MOVF       _LM358_diff+0, 0
	MOVWF      _adc_cur+0
	CLRF       _adc_cur+1
;16F688MPPT.mpas,219 :: 		end;
L__main46:
;16F688MPPT.mpas,220 :: 		end else
	GOTO       L__main44
L__main43:
;16F688MPPT.mpas,221 :: 		voltime:=wtmp;
	MOVF       _wtmp+0, 0
	MOVWF      _voltime+0
	MOVF       _wtmp+1, 0
	MOVWF      _voltime+1
L__main44:
;16F688MPPT.mpas,223 :: 		if adc_cur>LM358_diff then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main72
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main72:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;16F688MPPT.mpas,225 :: 		if power_curr = power_prev then begin
	MOVF       _power_curr+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _power_curr+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _power_curr+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main73
	MOVF       _power_curr+0, 0
	XORWF      _power_prev+0, 0
L__main73:
	BTFSS      STATUS+0, 2
	GOTO       L__main52
;16F688MPPT.mpas,226 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,227 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;16F688MPPT.mpas,228 :: 		end else if power_curr < power_prev then begin
L__main52:
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main74
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main74:
	BTFSC      STATUS+0, 0
	GOTO       L__main55
;16F688MPPT.mpas,229 :: 		LED1_tm:=150;
	MOVLW      150
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,230 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;16F688MPPT.mpas,231 :: 		end else
	GOTO       L__main56
L__main55:
;16F688MPPT.mpas,232 :: 		LED1_tm:=200;
	MOVLW      200
	MOVWF      _LED1_tm+0
L__main56:
;16F688MPPT.mpas,238 :: 		end else begin
	GOTO       L__main50
L__main49:
;16F688MPPT.mpas,239 :: 		LED1_tm:=100;
	MOVLW      100
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,240 :: 		VOLPWM:=PWM_MID;
	MOVLW      110
	MOVWF      _VOLPWM+0
;16F688MPPT.mpas,241 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;16F688MPPT.mpas,242 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;16F688MPPT.mpas,243 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;16F688MPPT.mpas,244 :: 		goto CONTLOOP;
	GOTO       L__main_CONTLOOP
;16F688MPPT.mpas,245 :: 		end;
L__main50:
;16F688MPPT.mpas,248 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main58
;16F688MPPT.mpas,249 :: 		if VOLPWM<PWM_MAX then
	MOVLW      230
	SUBWF      _VOLPWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main61
;16F688MPPT.mpas,250 :: 		Inc(VOLPWM)
	INCF       _VOLPWM+0, 1
	GOTO       L__main62
;16F688MPPT.mpas,251 :: 		else begin
L__main61:
;16F688MPPT.mpas,252 :: 		VOLPWM:=PWM_MAX;
	MOVLW      230
	MOVWF      _VOLPWM+0
;16F688MPPT.mpas,253 :: 		flag_inc:=false;
	CLRF       _flag_inc+0
;16F688MPPT.mpas,254 :: 		end;
L__main62:
;16F688MPPT.mpas,255 :: 		end else begin
	GOTO       L__main59
L__main58:
;16F688MPPT.mpas,256 :: 		if VOLPWM>PWM_MIN then
	MOVF       _VOLPWM+0, 0
	SUBLW      1
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;16F688MPPT.mpas,257 :: 		Dec(VOLPWM)
	DECF       _VOLPWM+0, 1
	GOTO       L__main65
;16F688MPPT.mpas,258 :: 		else begin
L__main64:
;16F688MPPT.mpas,259 :: 		VOLPWM:=PWM_MIN;
	MOVLW      1
	MOVWF      _VOLPWM+0
;16F688MPPT.mpas,260 :: 		flag_inc:=true;
	MOVLW      255
	MOVWF      _flag_inc+0
;16F688MPPT.mpas,261 :: 		end;
L__main65:
;16F688MPPT.mpas,262 :: 		end;
L__main59:
;16F688MPPT.mpas,263 :: 		CONTLOOP:
L__main_CONTLOOP:
;16F688MPPT.mpas,265 :: 		end;
	GOTO       L__main22
;16F688MPPT.mpas,266 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main
