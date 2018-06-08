
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;16F688MPPT.mpas,66 :: 		begin
;16F688MPPT.mpas,67 :: 		if T0IF_bit=1 then begin
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L__Interrupt2
;16F688MPPT.mpas,68 :: 		if PWM_FLAG=1 then begin
	BTFSS      _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
	GOTO       L__Interrupt5
;16F688MPPT.mpas,69 :: 		ON_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _ON_PWM+0
;16F688MPPT.mpas,71 :: 		TMR0:=255-ON_PWM;
	MOVF       _VOL_PWM+0, 0
	SUBLW      255
	MOVWF      TMR0+0
;16F688MPPT.mpas,72 :: 		PWM_SIG:=0;
	BCF        RC1_bit+0, BitPos(RC1_bit+0)
;16F688MPPT.mpas,73 :: 		PWM_FLAG:=0;
	BCF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;16F688MPPT.mpas,74 :: 		end else begin
	GOTO       L__Interrupt6
L__Interrupt5:
;16F688MPPT.mpas,76 :: 		TMR0:=255-PWM_MAX+ON_PWM;
	MOVF       _ON_PWM+0, 0
	MOVWF      TMR0+0
;16F688MPPT.mpas,77 :: 		PWM_SIG:=1;
	BSF        RC1_bit+0, BitPos(RC1_bit+0)
;16F688MPPT.mpas,78 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;16F688MPPT.mpas,79 :: 		end;
L__Interrupt6:
;16F688MPPT.mpas,80 :: 		T0IF_bit:=0;
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
;16F688MPPT.mpas,81 :: 		end;
L__Interrupt2:
;16F688MPPT.mpas,82 :: 		end;
L_end_Interrupt:
L__Interrupt82:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_main:

;16F688MPPT.mpas,84 :: 		begin
;16F688MPPT.mpas,85 :: 		CMCON0:=7;
	MOVLW      7
	MOVWF      CMCON0+0
;16F688MPPT.mpas,86 :: 		ANSEL:=%00000101;       // ADC conversion clock = fRC, RA0=Current, RA2=Voltage
	MOVLW      5
	MOVWF      ANSEL+0
;16F688MPPT.mpas,87 :: 		TRISA0_bit:=1;
	BSF        TRISA0_bit+0, BitPos(TRISA0_bit+0)
;16F688MPPT.mpas,88 :: 		TRISA2_bit:=1;
	BSF        TRISA2_bit+0, BitPos(TRISA2_bit+0)
;16F688MPPT.mpas,89 :: 		VCFG_bit:=1;
	BSF        VCFG_bit+0, BitPos(VCFG_bit+0)
;16F688MPPT.mpas,90 :: 		CHS1_bit:=1;
	BSF        CHS1_bit+0, BitPos(CHS1_bit+0)
;16F688MPPT.mpas,91 :: 		ADFM_bit:=1;
	BSF        ADFM_bit+0, BitPos(ADFM_bit+0)
;16F688MPPT.mpas,93 :: 		TRISC1_bit:=0;          // PWM
	BCF        TRISC1_bit+0, BitPos(TRISC1_bit+0)
;16F688MPPT.mpas,94 :: 		TRISC3_bit:=0;          // LED
	BCF        TRISC3_bit+0, BitPos(TRISC3_bit+0)
;16F688MPPT.mpas,96 :: 		LED1:=0;
	BCF        RC3_bit+0, BitPos(RC3_bit+0)
;16F688MPPT.mpas,97 :: 		PWM_SIG:=1;
	BSF        RC1_bit+0, BitPos(RC1_bit+0)
;16F688MPPT.mpas,98 :: 		PWM_FLAG:=1;
	BSF        _PWM_FLAG+0, BitPos(_PWM_FLAG+0)
;16F688MPPT.mpas,99 :: 		LED1_tm:=250;
	MOVLW      250
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,100 :: 		ON_PWM:=0;
	CLRF       _ON_PWM+0
;16F688MPPT.mpas,101 :: 		VOL_PWM:=0;
	CLRF       _VOL_PWM+0
;16F688MPPT.mpas,102 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;16F688MPPT.mpas,104 :: 		OPTION_REG:=%11011111;        // ~4KHz @ 4MHz, 1000000 / 4 = 3.9k
	MOVLW      223
	MOVWF      OPTION_REG+0
;16F688MPPT.mpas,105 :: 		TMR0IE_bit:=1;
	BSF        TMR0IE_bit+0, BitPos(TMR0IE_bit+0)
;16F688MPPT.mpas,107 :: 		LM358_diff:=cLM358_diff;
	MOVLW      4
	MOVWF      _LM358_diff+0
;16F688MPPT.mpas,109 :: 		if Write_OPAMP=0 then begin
	BTFSC      RC5_bit+0, BitPos(RC5_bit+0)
	GOTO       L__main9
;16F688MPPT.mpas,110 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,111 :: 		adc_cur:=ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	MOVWF      _adc_cur+0
	MOVF       R0+1, 0
	MOVWF      _adc_cur+1
;16F688MPPT.mpas,112 :: 		EEPROM_Write(0, Lo(adc_cur));
	CLRF       FARG_EEPROM_Write_address+0
	MOVF       _adc_cur+0, 0
	MOVWF      FARG_EEPROM_Write_data_+0
	CALL       _EEPROM_Write+0
;16F688MPPT.mpas,113 :: 		end;
L__main9:
;16F688MPPT.mpas,117 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;16F688MPPT.mpas,118 :: 		LM358_diff:=EEPROM_Read(0);
	CLRF       FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _LM358_diff+0
;16F688MPPT.mpas,121 :: 		IncPWM_EQ:=0;
	CLRF       _IncPWM_EQ+0
;16F688MPPT.mpas,122 :: 		IncPWM_EQ:=EEPROM_Read(3);
	MOVLW      3
	MOVWF      FARG_EEPROM_Read_address+0
	CALL       _EEPROM_Read+0
	MOVF       R0+0, 0
	MOVWF      _IncPWM_EQ+0
;16F688MPPT.mpas,127 :: 		T1CKPS1_bit:=1;               // timer prescaler 1:4
	BSF        T1CKPS1_bit+0, BitPos(T1CKPS1_bit+0)
;16F688MPPT.mpas,129 :: 		TMR1CS_bit:=0;
	BCF        TMR1CS_bit+0, BitPos(TMR1CS_bit+0)
;16F688MPPT.mpas,130 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;16F688MPPT.mpas,131 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;16F688MPPT.mpas,133 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;16F688MPPT.mpas,134 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;16F688MPPT.mpas,135 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;16F688MPPT.mpas,136 :: 		vol1:=0;
	CLRF       _vol1+0
;16F688MPPT.mpas,137 :: 		vol2:=0;
	CLRF       _vol2+0
;16F688MPPT.mpas,138 :: 		Reset_Tick100:=100;
	MOVLW      100
	MOVWF      _Reset_Tick100+0
;16F688MPPT.mpas,139 :: 		Reset_Tick:=Reset_Tick_Start;
	MOVLW      220
	MOVWF      _Reset_Tick+0
	MOVLW      5
	MOVWF      _Reset_Tick+1
;16F688MPPT.mpas,141 :: 		GIE_bit:=1;                   // enable Interrupt
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;16F688MPPT.mpas,143 :: 		TMR1ON_bit:=1;
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;16F688MPPT.mpas,145 :: 		VOL_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _VOL_PWM+0
;16F688MPPT.mpas,146 :: 		lo_PWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _lo_PWM+0
;16F688MPPT.mpas,147 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;16F688MPPT.mpas,148 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;16F688MPPT.mpas,149 :: 		adc_prev:=0;
	CLRF       _adc_prev+0
	CLRF       _adc_prev+1
;16F688MPPT.mpas,151 :: 		while True do begin
L__main12:
;16F688MPPT.mpas,153 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__main17
;16F688MPPT.mpas,154 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      252
	MOVWF      TMR1H+0
;16F688MPPT.mpas,155 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      23
	MOVWF      TMR1L+0
;16F688MPPT.mpas,156 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;16F688MPPT.mpas,157 :: 		Inc(TICK_1000);
	INCF       _TICK_1000+0, 1
;16F688MPPT.mpas,158 :: 		if TICK_1000>=LED1_tm then begin
	MOVF       _LED1_tm+0, 0
	SUBWF      _TICK_1000+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main20
;16F688MPPT.mpas,159 :: 		LED1:=not LED1;
	MOVLW
	XORWF      RC3_bit+0, 1
;16F688MPPT.mpas,160 :: 		TICK_1000:=0;
	CLRF       _TICK_1000+0
;16F688MPPT.mpas,161 :: 		end;
L__main20:
;16F688MPPT.mpas,184 :: 		end;
L__main17:
;16F688MPPT.mpas,185 :: 		if (VOL_PWM>=(PWM_MAX-1)) then
	MOVLW      254
	SUBWF      _VOL_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main23
;16F688MPPT.mpas,186 :: 		LED1_tm:=64
	MOVLW      64
	MOVWF      _LED1_tm+0
	GOTO       L__main24
;16F688MPPT.mpas,187 :: 		else if (VOL_PWM<=lo_PWM) then
L__main23:
	MOVF       _VOL_PWM+0, 0
	SUBWF      _lo_PWM+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L__main26
;16F688MPPT.mpas,188 :: 		LED1_tm:=90
	MOVLW      90
	MOVWF      _LED1_tm+0
	GOTO       L__main27
;16F688MPPT.mpas,189 :: 		else
L__main26:
;16F688MPPT.mpas,190 :: 		LED1_tm:=120;
	MOVLW      120
	MOVWF      _LED1_tm+0
L__main27:
L__main24:
;16F688MPPT.mpas,192 :: 		power_prev:=power_curr;
	MOVF       _power_curr+0, 0
	MOVWF      _power_prev+0
	MOVF       _power_curr+1, 0
	MOVWF      _power_prev+1
	MOVF       _power_curr+2, 0
	MOVWF      _power_prev+2
	MOVF       _power_curr+3, 0
	MOVWF      _power_prev+3
;16F688MPPT.mpas,193 :: 		adc_prev:=adc_cur;
	MOVF       _adc_cur+0, 0
	MOVWF      _adc_prev+0
	MOVF       _adc_cur+1, 0
	MOVWF      _adc_prev+1
;16F688MPPT.mpas,195 :: 		adc_vol:=0;
	CLRF       _adc_vol+0
	CLRF       _adc_vol+1
;16F688MPPT.mpas,196 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
;16F688MPPT.mpas,197 :: 		for i:=0 to adc_max_loop-1 do begin
	CLRF       _i+0
L__main29:
;16F688MPPT.mpas,198 :: 		adc_cur:=adc_cur+ADC_Read(0);
	CLRF       FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_cur+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_cur+1, 1
;16F688MPPT.mpas,199 :: 		adc_vol:=adc_vol+ADC_Read(2);
	MOVLW      2
	MOVWF      FARG_ADC_Read_channel+0
	CALL       _ADC_Read+0
	MOVF       R0+0, 0
	ADDWF      _adc_vol+0, 1
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      _adc_vol+1, 1
;16F688MPPT.mpas,200 :: 		end;
	MOVF       _i+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main32
	INCF       _i+0, 1
	GOTO       L__main29
L__main32:
;16F688MPPT.mpas,201 :: 		adc_vol:=adc_vol div adc_max_loop;
;16F688MPPT.mpas,202 :: 		adc_cur:=adc_cur div adc_max_loop;
;16F688MPPT.mpas,204 :: 		if adc_cur>LM358_diff then
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main84
	MOVF       _adc_cur+0, 0
	SUBWF      _LM358_diff+0, 0
L__main84:
	BTFSC      STATUS+0, 0
	GOTO       L__main34
;16F688MPPT.mpas,205 :: 		adc_cur:=adc_cur-LM358_diff
	MOVF       _LM358_diff+0, 0
	SUBWF      _adc_cur+0, 1
	BTFSS      STATUS+0, 0
	DECF       _adc_cur+1, 1
	GOTO       L__main35
;16F688MPPT.mpas,206 :: 		else
L__main34:
;16F688MPPT.mpas,207 :: 		adc_cur:=0;
	CLRF       _adc_cur+0
	CLRF       _adc_cur+1
L__main35:
;16F688MPPT.mpas,209 :: 		if (adc_cur>0) then begin
	MOVF       _adc_cur+1, 0
	SUBLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main85
	MOVF       _adc_cur+0, 0
	SUBLW      0
L__main85:
	BTFSC      STATUS+0, 0
	GOTO       L__main37
;16F688MPPT.mpas,210 :: 		if lo_PWM=0 then
	MOVF       _lo_PWM+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L__main40
;16F688MPPT.mpas,211 :: 		lo_PWM:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _lo_PWM+0
L__main40:
;16F688MPPT.mpas,212 :: 		power_curr:= adc_cur * adc_vol;
	MOVF       _adc_cur+0, 0
	MOVWF      R0+0
	MOVF       _adc_cur+1, 0
	MOVWF      R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       _adc_vol+0, 0
	MOVWF      R4+0
	MOVF       _adc_vol+1, 0
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
;16F688MPPT.mpas,213 :: 		if power_curr=power_prev then begin
	MOVF       R0+3, 0
	XORWF      _power_prev+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+2, 0
	XORWF      _power_prev+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+1, 0
	XORWF      _power_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main86
	MOVF       R0+0, 0
	XORWF      _power_prev+0, 0
L__main86:
	BTFSS      STATUS+0, 2
	GOTO       L__main43
;16F688MPPT.mpas,214 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;16F688MPPT.mpas,215 :: 		if adc_cur>adc_prev then begin
	MOVF       _adc_cur+1, 0
	SUBWF      _adc_prev+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main87
	MOVF       _adc_cur+0, 0
	SUBWF      _adc_prev+0, 0
L__main87:
	BTFSC      STATUS+0, 0
	GOTO       L__main46
;16F688MPPT.mpas,216 :: 		flag_inc:=False;
	CLRF       _flag_inc+0
;16F688MPPT.mpas,217 :: 		end else
	GOTO       L__main47
L__main46:
;16F688MPPT.mpas,218 :: 		if adc_cur<adc_prev then begin
	MOVF       _adc_prev+1, 0
	SUBWF      _adc_cur+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main88
	MOVF       _adc_prev+0, 0
	SUBWF      _adc_cur+0, 0
L__main88:
	BTFSC      STATUS+0, 0
	GOTO       L__main49
;16F688MPPT.mpas,219 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;16F688MPPT.mpas,220 :: 		end else begin
	GOTO       L__main50
L__main49:
;16F688MPPT.mpas,221 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;16F688MPPT.mpas,222 :: 		end;
L__main50:
L__main47:
;16F688MPPT.mpas,223 :: 		vol2:=0;
	CLRF       _vol2+0
;16F688MPPT.mpas,224 :: 		LED1_tm:=240;
	MOVLW      240
	MOVWF      _LED1_tm+0
;16F688MPPT.mpas,225 :: 		continue;
	GOTO       L__main12
;16F688MPPT.mpas,226 :: 		end else begin
L__main43:
;16F688MPPT.mpas,227 :: 		if Inc_pwm<Inc_Pwm_Max then
	MOVLW      8
	SUBWF      _Inc_pwm+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main52
;16F688MPPT.mpas,228 :: 		Inc(Inc_pwm);
	INCF       _Inc_pwm+0, 1
L__main52:
;16F688MPPT.mpas,229 :: 		if power_curr<power_prev then begin
	MOVF       _power_prev+3, 0
	SUBWF      _power_curr+3, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+2, 0
	SUBWF      _power_curr+2, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+1, 0
	SUBWF      _power_curr+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main89
	MOVF       _power_prev+0, 0
	SUBWF      _power_curr+0, 0
L__main89:
	BTFSC      STATUS+0, 0
	GOTO       L__main55
;16F688MPPT.mpas,231 :: 		vol1:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _vol1+0
;16F688MPPT.mpas,232 :: 		flag_inc:=not flag_inc;
	COMF       _flag_inc+0, 1
;16F688MPPT.mpas,234 :: 		if vol2<>0 then begin
	MOVF       _vol2+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L__main58
;16F688MPPT.mpas,235 :: 		Inc_pwm:=0;
	CLRF       _Inc_pwm+0
;16F688MPPT.mpas,236 :: 		wPWM:=vol1;
	MOVF       _vol1+0, 0
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
;16F688MPPT.mpas,237 :: 		wPWM:=(wPWM+vol2+1) div 2+3; { >=3 }
	MOVF       _vol2+0, 0
	ADDWF      _wPWM+0, 1
	BTFSC      STATUS+0, 0
	INCF       _wPWM+1, 1
	INCF       _wPWM+0, 1
	BTFSC      STATUS+0, 2
	INCF       _wPWM+1, 1
	RRF        _wPWM+1, 1
	RRF        _wPWM+0, 1
	BCF        _wPWM+1, 7
	MOVLW      3
	ADDWF      _wPWM+0, 1
	BTFSC      STATUS+0, 0
	INCF       _wPWM+1, 1
;16F688MPPT.mpas,238 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)>PWM_MAX) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main61
;16F688MPPT.mpas,239 :: 		wPWM:=word(PWM_MAX)
	MOVLW      255
	MOVWF      _wPWM+0
	MOVLW      0
	MOVWF      _wPWM+1
	GOTO       L__main62
;16F688MPPT.mpas,240 :: 		else if Lo(wPWM)<PWM_LOW then
L__main61:
	MOVLW      1
	SUBWF      _wPWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main64
;16F688MPPT.mpas,241 :: 		wPWM:=word(PWM_LOW);
	MOVLW      1
	MOVWF      _wPWM+0
	MOVLW      0
	MOVWF      _wPWM+1
L__main64:
L__main62:
;16F688MPPT.mpas,243 :: 		VOL_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _VOL_PWM+0
;16F688MPPT.mpas,245 :: 		vol2:=0;
	CLRF       _vol2+0
;16F688MPPT.mpas,247 :: 		wPWM:=(word(PWM_MAX-VOL_PWM)+((PWMHI_DIV+1) div 2)) div PWMHI_DIV;
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      3
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      6
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	MOVWF      _wPWM+1
;16F688MPPT.mpas,248 :: 		wPWM:=wPWM+word(VOL_PWM);
	MOVF       _VOL_PWM+0, 0
	MOVWF      R2+0
	CLRF       R2+1
	MOVF       R2+0, 0
	ADDWF      R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	ADDWF      R2+1, 0
	MOVWF      _wPWM+1
;16F688MPPT.mpas,249 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)>PWM_MAX) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVF       _wPWM+0, 0
	SUBLW      255
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main67
;16F688MPPT.mpas,250 :: 		wPWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
L__main67:
;16F688MPPT.mpas,251 :: 		hi_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _hi_PWM+0
;16F688MPPT.mpas,253 :: 		wPWM:=(word(VOL_PWM-PWM_LOW)+((PWMLO_DIV+1) div 2)) div PWMLO_DIV;
	MOVLW      1
	SUBWF      _VOL_PWM+0, 0
	MOVWF      R0+0
	MOVLW      0
	BTFSS      STATUS+0, 0
	ADDLW      1
	CLRF       R0+1
	SUBWF      R0+1, 1
	MOVLW      8
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      15
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_U+0
	MOVF       R0+0, 0
	MOVWF      _wPWM+0
	MOVF       R0+1, 0
	MOVWF      _wPWM+1
;16F688MPPT.mpas,254 :: 		wPWM:=word(VOL_PWM)-wPWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
	MOVF       R0+0, 0
	SUBWF      _wPWM+0, 1
	BTFSS      STATUS+0, 0
	DECF       _wPWM+1, 1
	MOVF       R0+1, 0
	SUBWF      _wPWM+1, 1
;16F688MPPT.mpas,255 :: 		if (Hi(wPWM)<>0) or (Lo(wPWM)<PWM_LOW) then
	MOVF       _wPWM+1, 0
	XORLW      0
	MOVLW      255
	BTFSC      STATUS+0, 2
	MOVLW      0
	MOVWF      R1+0
	MOVLW      1
	SUBWF      _wPWM+0, 0
	MOVLW      255
	BTFSC      STATUS+0, 0
	MOVLW      0
	MOVWF      R0+0
	MOVF       R1+0, 0
	IORWF      R0+0, 1
	BTFSC      STATUS+0, 2
	GOTO       L__main70
;16F688MPPT.mpas,256 :: 		wPWM:=PWM_LOW;
	MOVLW      1
	MOVWF      _wPWM+0
	CLRF       _wPWM+1
L__main70:
;16F688MPPT.mpas,257 :: 		lo_PWM:=lo(wPWM);
	MOVF       _wPWM+0, 0
	MOVWF      _lo_PWM+0
;16F688MPPT.mpas,258 :: 		continue;
	GOTO       L__main12
;16F688MPPT.mpas,259 :: 		end;
L__main58:
;16F688MPPT.mpas,260 :: 		end else begin
	GOTO       L__main56
L__main55:
;16F688MPPT.mpas,262 :: 		vol2:=VOL_PWM;
	MOVF       _VOL_PWM+0, 0
	MOVWF      _vol2+0
;16F688MPPT.mpas,263 :: 		end;
L__main56:
;16F688MPPT.mpas,265 :: 		end else begin
	GOTO       L__main38
L__main37:
;16F688MPPT.mpas,267 :: 		power_curr:=0;
	CLRF       _power_curr+0
	CLRF       _power_curr+1
	CLRF       _power_curr+2
	CLRF       _power_curr+3
;16F688MPPT.mpas,268 :: 		Inc_pwm:=Inc_Pwm_Max;
	MOVLW      8
	MOVWF      _Inc_pwm+0
;16F688MPPT.mpas,269 :: 		flag_inc:=True;
	MOVLW      255
	MOVWF      _flag_inc+0
;16F688MPPT.mpas,270 :: 		vol2:=0;
	CLRF       _vol2+0
;16F688MPPT.mpas,271 :: 		lo_PWM:=0;
	CLRF       _lo_PWM+0
;16F688MPPT.mpas,272 :: 		hi_PWM:=PWM_MAX;
	MOVLW      255
	MOVWF      _hi_PWM+0
;16F688MPPT.mpas,273 :: 		end;
L__main38:
;16F688MPPT.mpas,275 :: 		if flag_inc then begin
	MOVF       _flag_inc+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main73
;16F688MPPT.mpas,276 :: 		if VOL_PWM<(hi_PWM-Inc_pwm) then begin
	MOVF       _Inc_pwm+0, 0
	SUBWF      _hi_PWM+0, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	SUBWF      _VOL_PWM+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main76
;16F688MPPT.mpas,277 :: 		VOL_PWM:=VOL_PWM+Inc_pwm;
	MOVF       _Inc_pwm+0, 0
	ADDWF      _VOL_PWM+0, 1
;16F688MPPT.mpas,278 :: 		end else
	GOTO       L__main77
L__main76:
;16F688MPPT.mpas,279 :: 		VOL_PWM:=hi_PWM;
	MOVF       _hi_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main77:
;16F688MPPT.mpas,280 :: 		end else begin
	GOTO       L__main74
L__main73:
;16F688MPPT.mpas,281 :: 		if VOL_PWM>(lo_PWM+(Inc_Pwm_Max+1-Inc_pwm)) then begin
	MOVF       _Inc_pwm+0, 0
	SUBLW      9
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDWF      _lo_PWM+0, 0
	MOVWF      R1+0
	MOVF       _VOL_PWM+0, 0
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__main79
;16F688MPPT.mpas,282 :: 		VOL_PWM:=VOL_PWM-(Inc_Pwm_Max+1-Inc_pwm);
	MOVF       _Inc_pwm+0, 0
	SUBLW      9
	MOVWF      R0+0
	MOVF       R0+0, 0
	SUBWF      _VOL_PWM+0, 1
;16F688MPPT.mpas,283 :: 		end else
	GOTO       L__main80
L__main79:
;16F688MPPT.mpas,284 :: 		VOL_PWM:=lo_PWM;
	MOVF       _lo_PWM+0, 0
	MOVWF      _VOL_PWM+0
L__main80:
;16F688MPPT.mpas,285 :: 		end;
L__main74:
;16F688MPPT.mpas,286 :: 		end;
	GOTO       L__main12
;16F688MPPT.mpas,287 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main