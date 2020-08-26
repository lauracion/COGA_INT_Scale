libname master 'E:\Laura\Work\COGA\Projects\INT_scale\data\Phase_I_II_III\phaseII_coga_irpg_09_16_2015';
libname d 'E:\Laura\Work\COGA\Projects\INT_scale\Paper\data\ssagaii';

data tmp1; set master.alldx_saga2rv3;
keep ind_id agd4dx pnd4dx pnd4numsx spd4dx occpd4dx ocobd4dx ptd4dx ptd4bsx ptd4csx ptd4dsx dpd4dx dpd4sx ald4abdx ald4absx ald4dpdx ald4dpsx;run;

* keeping the SSAGAII items needed to score the INT scale;
data tmp2; set master.allssaga2rv1;
	keep IND_ID DM1 DM4 DM8A DM17b AL6 AL17/* DM1 gender, 1 = male 2 = female; DM4 age; DM8A self reported race, see changes below to agree with SSAGAIV */
	AG1 AG2_1-AG2_5 AG2a AG2c AG3A_1-AG3A_9 AG3b AG4 AG4a AG4b AG4c 
	/*Changes from SSAGAIV: AG2c added, AGp2f, AGp2h, AGp2i, and AGp2j are omitted because they are not in SSAGAII */
	PN1 PN2a PN2b PN3 PN3a PN3a1 PN3b PN3b1 PN3c PN3c1 PN4_1-PN4_13 PN5 PN6
	/*Changes from SSAGAIV: PNIx changes for PN1, PN5_1, PNp1f, PNp1h, PNp1i, and PNp1j are omitted because they are not in SSAGAII */
	SP1_1-SP1_6 SP2 SP2a SP2b SP1CODE
	/*Changes from SSAGAIV: SP1CODE replaces partially SPp1f, SPp1h, SPp1i, and SPp1j that are omitted in SSAGAII */
	OC1 OC1a OC1b OC1d OC2 OC3 OC4 OC9 OC9A OC9B OC10 OC11 
	/*Changes from SSAGAIV: OC1D replaces partially OCp1f, OCp1h, OCp1i, and OCp1j, and OC9B replaces partially OCp9f, OCp9h, OCp9i, and OCp9j that are omitted in SSAGAII */
	PT1 PT1d PT2-PT6 PT8-PT14 PT16-PT20 PT22
	/*Changes from SSAGAIV: PT1a1-PT1a20 removed, PT1 and PT1d added instead, PT2 is added, PT7 is deleted, PT8 is added, PT11a and PT15 is removed, PT16 is added, PT20 and PT21 are removed. Most of these changes are due to change in coding
	  the same questions between SSAGAIV and SSAGAII. PT22 replaces partially PTp23f, PTp23h, PTp23i, and PTp23j that are omitted in SSAGAII */
	DP1 DP2 DPB12 DPB12a DPB12b DPB18 DPB14a DPB14b DPB15 DPB15f DPB16 DPB17 DPB19 DPB20 DPB21 DPB22 DPB23 
	DP34 DP34b1 DP34b2 DP34b3 DP34b4 DP34b5 DP34b6 DP34b7 DP34b8 DP34b9 
	/*Changes from SSAGAIV: except for DP1 and DP2, the rest of the variables are different between SSAGAIV and SSAGAII. */
	/* for DIRTY */ dpa5b dpa5d dpa6a dpa7 dpa9 dpa10 dpb5e dpb6f dpb7a dpb9a dpa10a dpb10b dpa8a dpa25e dpb8b dpb25e 
	SU1 SU1a SU1b SU2 SU5 SU9_1--SU9_6 DPB23a DPB23b;
	if DM8A in (4 5) then DM8A=4;
	else if DM8A in (6 7) then DM8A=5;
	else if DM8A = . then DM8A=.;
	else DM8A=1;
run;

data tmp3; set master.allmaster; keep ind_id saga2_dt;run;

proc sort data=tmp1;by ind_id;
proc sort data=tmp2;by ind_id;
proc sort data=tmp3;by ind_id;
* merging all needed information to calculate the INT scale items and score;
data d.v21_int_ssaga23; merge tmp3 tmp2 tmp1; by ind_id;run;

* generating INT Scale Score for SSAGA-II adults;
data d.v21_int_ssaga23; 
	set d.v21_int_ssaga23;

	**************;
	* Agoraphobia ;
	**************;

	if AG2_1=1 & AG2_2=1 & AG2_3=1 & AG2_4=1 & AG2_5=1 & AG2a=1 then AG_ko1=1;
	else if AG2_1=. | AG2_2=. | AG2_3=. | AG2_4=. | AG2_5=. | AG2a=. | AG2_1=9 | AG2_2=9 | AG2_3=9 | AG2_4=9 | AG2_5=9 | AG2a=9 then AG_ko1=.;
	else AG_ko1=0;

	if AG1=5 & (AG_ko1^=1) & AG2c notin (3,4) then INT1_1=1;
	else if AG1=. or AG1=9 then INT1_1=.;
	else INT1_1=0;
	
	if AG3A_1=5 | AG3A_2=5 | AG3A_3=5 | AG3A_4=5 | AG3A_5=5 | AG3A_6=5 | AG3A_7=5 | AG3A_8=5 | AG3A_9=5 | AG3b=5 | AG4=5 | AG4a=5 | AG4b=5 | AG4c=5 then INT1_2=1;
	else if AG1=. or AG1=9 then INT1_2=.;
	else INT1_2=0;

	* 0-3 score;
	if agd4dx=5 then INT1=3; 
	else if agd4dx=. or agd4dx=9 then INT1=.;
	else if INT1_1=1 and INT1_2=1 then INT1=2;
	else if INT1_1=1 or INT1_2=1 then INT1=1;
	else if INT1_1=0 and INT1_2=0 then INT1=0;
	else INT1=.;

	*****************;
	* Panic Disorder ;
	*****************;

	if PN1=5 & (PN2a=5 | PN2b=5 | PN5>1) then INT2_1=1;
	else if PN1=. or PN1=9 then INT2_1=.;
	else INT2_1=0;

	PN4_cnt=0;
	array PN4 (13) PN4_1-PN4_13;
	do i=1 to 13;
		if PN4(i)=5 then PN4_cnt+1;
	end;
	if PN4_cnt>3 & PN6=5 then INT2_2=1;
	else if PN1=. then INT2_2=.;
	else INT2_2=0;
	
	if PN3=5 | (PN3a=5 & PN3a1=5) | (PN3b=5 & PN3b1=5) | (PN3c=5 & PN3c1=5) then INT2_3=1;
	else if PN1=. or PN1=9 then INT2_3=.;
	else INT2_3=0;

	* 0-3 score;
	INT2_1cnt=0;
	INT2_0cnt=0;
	array INT2_ary INT2_1 INT2_2 INT2_3;
	do i=1 to 3;
		if INT2_ary(i)=1 then INT2_1cnt+1;
		else if INT2_ary(i)=0 then INT2_0cnt+1;
	end;
	if pnd4dx=5 then INT2=3; 
	else if pnd4dx=. or pnd4dx=9 then INT2=.;
	else if INT2_1cnt>1 then INT2=2;
	else if INT2_1cnt=1 then INT2=1;
	else if INT2_0cnt=3 then INT2=0;
	else INT2=.;

	****************;
	* Social Phobia ;
	****************;

	if (SP1_1=5 | SP1_2=5 | SP1_3=5 | SP1_4=5 | SP1_5=5 | SP1_6=5) and SP1CODE notin (3,4) then INT3_1=1;
	else if (SP1_1=. or SP1_1=9) & (SP1_2=. or SP1_2=9) & (SP1_3=. or SP1_3=9) & (SP1_4=. or SP1_4=9) & (SP1_5=. or SP1_5=9) & (SP1_6=. or SP1_6=9) then INT3_1=.;
	else INT3_1=0;

	if SP2=5 then INT3_2=1;
	else if (SP1_1=. or SP1_1=9) & (SP1_2=. or SP1_2=9) & (SP1_3=. or SP1_3=9) & (SP1_4=. or SP1_4=9) & (SP1_5=. or SP1_5=9) & (SP1_6=. or SP1_6=9) then INT3_2=.;
	else INT3_2=0;
	
	if SP2a=5 | SP2b=5 then INT3_3=1;
	else if (SP1_1=. or SP1_1=9) & (SP1_2=. or SP1_2=9) & (SP1_3=. or SP1_3=9) & (SP1_4=. or SP1_4=9) & (SP1_5=. or SP1_5=9) & (SP1_6=. or SP1_6=9) then INT3_3=.;
	else INT3_3=0;

	* 0-3 score;
	INT3_1cnt=0;
	INT3_0cnt=0;
	array INT3_ary INT3_1 INT3_2 INT3_3;
	do i=1 to 3;
		if INT3_ary(i)=1 then INT3_1cnt+1;
		else if INT3_ary(i)=0 then INT3_0cnt+1;
	end;
	if spd4dx=5 then INT3=3; 
	else if spd4dx=. or spd4dx=9 then INT3=.;
	else if INT3_1cnt>1 then INT3=2;
	else if INT3_1cnt=1 then INT3=1;
	else if INT3_0cnt=3 then INT3=0;
	else INT3=.;

	**************************************;
	* OCD (Obsessive-Compulsive Disorder) ;
	**************************************;

	if OC1=5 & OC1a^=5 & OC1b^=5 & OC1d notin (3,4) & OC2=5 & OC3=5 then INT4_1=1;
	else if OC1=. or OC1=9 then INT4_1=.;
	else INT4_1=0;

	if OC9=5 & (OC9A=5 | OC10=5) & OC9b notin (3,4) then INT4_2=1;
	else if OC9=. or OC9=9 then INT4_2=.;
	else INT4_2=0;

	if OC4=5 | OC11=5 then INT4_3=1;
	else if OC1=. | OC1=9 | OC9=. | OC9=9 then INT4_3=.;
	else INT4_3=0;
	
	* 0-3 score;
	INT4_1cnt=0;
	INT4_0cnt=0;
	array INT4_ary INT4_1-INT4_3;
	do i=1 to 3;
		if INT4_ary(i)=1 then INT4_1cnt+1;
		else if INT4_ary(i)=0 then INT4_0cnt+1;
	end;
	if OCcpD4dx=5 or OCobD4dx=5 then INT4=3; 
	else if (OCcpD4dx=. | OCCPD4dx=9) & (OCobD4dx=. | OCobD4dx=9) then INT4=.;
	else if INT4_1cnt>1 then INT4=2;
	else if INT4_1cnt>0 then INT4=1;
	else if INT4_0cnt=3 then INT4=0;
	else INT4=.;

	****************************************;
	* PTSD (Post Traumatic Stress Disorder) ;
	****************************************;

	if PT1=1 | (PT1=5 & PT1d=1) then INT5_1=0;
	else if (PT2=5 | PT3=5 | PT4=5 | PT5=5 | PT6=5) & PT22^=3 then INT5_1=1;
	else if ((PT1=. | PT1=9) & (PT1d=. | PT1d=9)) | ((PT2=. | PT2=9) & (PT3=. | PT3=9) & (PT4=. | PT4=9) & (PT5=. | PT5=9) & (PT6=. | PT6=9)) then INT5_1=.;
	else INT5_1=0;
		
	if PT2=1 & PT3=1 & PT4=1 & PT5=1 & PT6=1 then oneINT5_1=1;

	if (PT8=. | PT8=9) & (PT9=. | PT9=9) & (PT10=. | PT10=9) & (PT11=. | PT11=9) & (PT12=. | PT12=9) & (PT13=. | PT13=9) & (PT14=. | PT14=9) then sumINT5_2=.;
	else sumINT5_2=sum(PT8=5, PT9=5, PT10=5, PT11=5, PT12=5, PT13=5, PT14=5);

	if PT1=1 | (PT1=5 & PT1d=1) | oneINT5_1=1  then INT5_2=0;
	else if sumINT5_2 > 2 & PT22^=3 then INT5_2=1;
	else if sumINT5_2=. then INT5_2=.;
	else INT5_2=0;
	
	if (PT16=. | PT16=9) & (PT17=. | PT17=9) & (PT18=. | PT18=9) & (PT19=. | PT19=9) & (PT20=. | PT20=9) then sumINT5_3=.;
	else sumINT5_3=sum(PT16=5, PT17=5, PT18=5, PT19=5, PT20=5);

	if PT1=1 | (PT1=5 & PT1d=1) | oneINT5_1=1 | sumINT5_2 in (0,1,2) then INT5_3=0;
	else if sumINT5_3 > 1 & PT22^=3 then INT5_3=1;
	else if sumINT5_3=. then INT5_3=.;
	else INT5_3=0;

	* 0-3 score;
	INT5_1cnt=0;
	INT5_0cnt=0;
	array INT5_ary INT5_1 INT5_2 INT5_3;
	do i=1 to 3;
		if INT5_ary(i)=1 then INT5_1cnt+1;
		else if INT5_ary(i)=0 then INT5_0cnt+1;
	end;
	if ptd4dx=5 then INT5=3; 
	else if ptd4dx=. or ptd4dx=9 then INT5=.;
	else if INT5_1cnt>1 then INT5=2;
	else if INT5_1cnt=1 then INT5=1;
	else if INT5_0cnt=3 then INT5=0;
	else INT5=.;

	*********************************;
	* MDE (Major Depression Episode) ;
	*********************************;

	/* start of code modified from dpd4s2rv3.docs for SSAGAII */

	/*      drinks + drugs + medication + illness + postpartum 	              */
	if (dpa5b=5 | dpa5d=5 | dpa6a=5 | dpa7=5 | dpa9=5 |dpa10a=5) and
	   (dpb5e=1 | dpb6f=1 | dpb7a=1 | dpb9a=1 | dpb10b=1)
	then ddmip=1; else ddmip=0;
  
	/********        bereavement                                            ***/
	if (dpa8a=5) and (dpa25e lt 9)  then bereavement=1; else bereavement=0;

	/********        all possible causes together                           ***/
    if (dpb8b=1) and (dpb25e lt 9) then alltogether=1; else alltogether=0;         

	/* end of code modified from dpd4s2rv3.docs for SSAGAII  */
	
	DIRTY=sum(of ddmip, bereavement, alltogether);  

	if (DP1=. or DP1=9) & (DP2=. or DP2=9) then
		do;
			INT6_1=.;INT6_2=.;INT6_3=.;INT6_4=.;INT6_5=.;INT6_6=.;INT6_7=.;INT6_8=.;
		end;
	else if DIRTY = 0 then
			do;
				if DPB12=5 | DPB12a=5 | DPB12b=5 | DPB18=5 then INT6_1=1; else INT6_1=0;
				if DPB14a=5 | DPB14b=5 then INT6_2=1; else INT6_2=0;
				if DPB15=5 | DPB15f=5 then INT6_3=1; else INT6_3=0;
				if DPB16=5 | DPB17=5 then INT6_4=1; else INT6_4=0;
				if DPB19=5 then INT6_5=1; else INT6_5=0;
				if DPB20=5 | DPB21=5 then INT6_6=1; else INT6_6=0;
				if DPB22=5 then INT6_7=1; else INT6_7=0;
				if DPB23=5 then INT6_8=1; else INT6_8=0;
			end;
	else if DP34=5 then
			do;
				if DP34b1=5 | DP34b2=5 then INT6_1=1; else INT6_1=0; 
				if DP34b3=5 then INT6_2=1; else INT6_2=0;
				if DP34b4=5 then INT6_3=1; else INT6_3=0;
				if DP34b5=5 then INT6_4=1; else INT6_4=0;
				if DP34b6=5 then INT6_5=1;	else INT6_5=0;
				if DP34b7=5 then INT6_6=1; else INT6_6=0;
				if DP34b8=5 then INT6_7=1; else INT6_7=0;
				if DP34b9=5 then INT6_8=1; else INT6_8=0;
			end;
	else do;
			INT6_1=0;INT6_2=0;INT6_3=0;INT6_4=0;INT6_5=0;INT6_6=0;INT6_7=0;INT6_8=0;
		 end;

	* 0-3 score;
	INT6_1cnt=0;
	INT6_0cnt=0;
	array INT6_ary INT6_1-INT6_8;
	do i=1 to 8;
		if INT6_ary(i)=1 then INT6_1cnt+1;
		else if INT6_ary(i)=0 then INT6_0cnt+1;
	end;
	if dpd4dx=5 then INT6=3; 
	else if dpd4dx=. or dpd4dx=9 then INT6=.;
	else if INT6_1cnt>4	then INT6=2;
	else if INT6_1cnt>0 then INT6=1;
	else if INT6_0cnt=8 then INT6=0;
	else INT6=.;

	**************;
	* Suicidality ;
	**************;

	if SU1a = 5 then INT7_1 = 1;
	else if (SU1=. or SU1=.K or SU1=9) then INT7_1 = .;
	else INT7_1 = 0;

	if SU1b=5 or DPB23a=5 then INT7_2=1;
	else if (SU1=. or SU1=.K or SU1=9) then INT7_2 = .;
	else INT7_2 = 0;

	if (DPB23b=5 or SU2=5) & SU5=5 & (SU9_1=5 & SU9_2=1 & SU9_3=1 & SU9_4=1 & SU9_5=1 & SU9_6=1) then INT7_3=1;
	else if ((DPB23b=. | DPB23b=9) & (SU2=. | SU2=9)) | (SU5=. | SU5=9) | (SU9_1=. | SU9_1=.) | 
		    (SU9_2=. | SU9_2=.) | (SU9_3=. | SU9_3=.) | (SU9_4=. | SU9_4=.) | (SU9_5=. | SU9_5=.) | (SU9_6=. | SU9_6=.) then INT7_3=.;

	* 0-3 score;
	if INT7_3=1 then INT7=3;
	else if INT7_1=1 and INT7_2=1 then INT7=2;
	else if INT7_1=1 or INT7_2=1 then INT7=1;
	else if INT7_1=0 and INT7_2=0 then INT7=0;
	else INT7=.;

	***************;
	* All together ;
	***************;
	* calculating the total score using listwise deletion, do not want to have total score for subjects that have at least one of the items missing;
	if nmiss(of INT1-INT7)=0 then INT_Total_Score= sum(of INT1-INT7);
	else INT_Total_Score=.;
*	if INT_Total_Score=. then delete;
	INT_unusable = (missing(INT1)+missing(INT2)+missing(INT3)+missing(INT4)+missing(INT5)+
                    missing(INT6)+missing(INT7))*100/7;
run;

proc freq data=d.v21_int_ssaga23; where saga2_dt ne . and 
	(ind_id < 29000000 or (ind_id > 29999999 and ind_id < 49000000) or
	 (ind_id > 49999999 and ind_id < 59000000) or (ind_id > 59999999 and ind_id < 79000000)); * excluding IRPG subjects;
	title 'The final INT scale for SSAGA 2';
	table INT_Total_Score INT_unusable / missprint;
run;

proc means data=d.v21_int_ssaga23 min max n mean std; where saga2_dt ne . and INT_Total_Score = .
and (ind_id < 29000000 or (ind_id > 29999999 and ind_id < 49000000) or
	 (ind_id > 49999999 and ind_id < 59000000) or (ind_id > 59999999 and ind_id < 79000000)); 
var saga2_dt ind_id;
proc means data=d.v21_int_ssaga23 min max n mean std; where saga2_dt ne . and INT_Total_Score ne .
and (ind_id < 29000000 or (ind_id > 29999999 and ind_id < 49000000) or
	 (ind_id > 49999999 and ind_id < 59000000) or (ind_id > 59999999 and ind_id < 79000000)); 
var saga2_dt ind_id; run;

proc sort data=d.v21_int_ssaga23; by saga2_dt;run;

data d.v21_int_ssaga23; set d.v21_int_ssaga23;
where saga2_dt ne . and (ind_id < 29000000 or (ind_id > 29999999 and ind_id < 49000000) or
	 (ind_id > 49999999 and ind_id < 59000000) or (ind_id > 59999999 and ind_id < 79000000));run;

* harvesting and merging achen and neo;

libname s2neo 'E:\Laura\Work\COGA\Projects\INT_scale\data\Phase_I_II_III';

proc sort data=s2neo.neo; by ind_id;
proc sort data=d.v21_int_ssaga23; by ind_id;
data d.neo; merge d.v21_int_ssaga23 s2neo.neo; by ind_id;run;
data d.neo; set d.neo;if year(saga2_dt)=year(neo_dt);run;
data tmp; set d.neo; keep ind_id neo_n -- neo_C;run;
data d.v21_int_ssaga23; merge d.v21_int_ssaga23 tmp; by ind_id;run;

data d.v21_int_ssaga23 
	(keep = ind_id intvyr DM1 Age DM8b DM17b agd4dx pnd4dx pnd4numsx spd4dx occpd4dx ocobd4dx ptd4dx ptd4critbsx ptd4critcsx ptd4critdsx dpd4dx dpd4sx 
	 ald4abdx ald4absx ald4dpdx ald4dpsx AL6 AL17 neo_n -- neo_C INT1--INT7 INT_total_score); 
rename saga2_dt=intvyr ptd4bsx=ptd4critbsx ptd4csx=ptd4critcsx ptd4dsx=ptd4critdsx DM4=Age DM8a=DM8b;
set d.v21_int_ssaga23;
run;

data d.v21_int_ssaga23; set d.v21_int_ssaga23;
SC_AnxDep_raw=.;
SC_Withdrawn_raw=.;
SC_Somatic_raw=.;
SC_Aggressive_raw=.;
SC_RuleBreak_raw=.;
SC_Intrusive_raw=.;
SC_Internal_raw=.;
SC_External_raw=.;output;run;

* scoring and harvesting DAQ/craving;
* DAQ administered to 12 yo and on who already tried alcohol;

data tmp; set master.allcraving;
where ind_id < 29000000 or (ind_id > 29999999 and ind_id < 49000000) or
	 (ind_id > 49999999 and ind_id < 59000000) or (ind_id > 59999999 and ind_id < 79000000);
  if (crv1 in (-3,9)) then crv1 = .K;
  if (crv2 in (-3,9)) then crv2 = .K;
  if (crv3 in (-3,9)) then crv3 = .K;
  if (crv4 in (-3,9)) then crv4 = .K;
  if (crv5 in (-3,9)) then crv5 = .K;
  if (crv6 in (-3,9)) then crv6 = .K;
  if (crv7 in (-3,9)) then crv7 = .K;
  if (crv8 in (-3,9)) then crv8 = .K;
  if (crv9 in (-3,9)) then crv9 = .K;
  if (crv10 in (-3,9)) then crv10 = .K;
  if (crv11 in (-3,9)) then crv11 = .K;
  if (crv12 in (-3,9)) then crv12 = .K;
  if (crv13 in (-3,9)) then crv13 = .K;
  if (crv14 in (-3,9)) then crv14 = .K;
  total_daq = sum(of crv1 - crv14);
  strong_desire_AUD = sum(of crv1 - crv6);
  strong_desire_non_AUD = sum(of crv1 - crv5);
  neg_reinforce_AUD = sum(of crv7 - crv10);
  neg_reinforce_non_AUD = sum(of crv6 - crv10);
  pos_reinforce_ability_to_control = sum(of crv11 - crv14);
  daq_unusable = (missing(crv1)+missing(crv2)+missing(crv3)+missing(crv4)+missing(crv5)+
                  missing(crv6)+missing(crv7)+missing(crv8)+missing(crv9)+missing(crv10)+
				  missing(crv11)+missing(crv12)+missing(crv13)+missing(crv14))*100/14;
run;
data tmp; set tmp;
	keep ind_id QSCL_DT total_daq strong_desire_AUD strong_desire_non_AUD
		 neg_reinforce_AUD neg_reinforce_non_AUD pos_reinforce_ability_to_control daq_unusable;

proc sort data=d.v21_int_ssaga23; by ind_id;
proc sort data=tmp; by ind_id;
data tmp; merge d.v21_int_ssaga23 tmp; by ind_id;
data tmp; set tmp; if year(intvyr)=year(QSCL_DT);
data tmp; set tmp; 	keep ind_id QSCL_DT total_daq strong_desire_AUD strong_desire_non_AUD
		 neg_reinforce_AUD neg_reinforce_non_AUD pos_reinforce_ability_to_control daq_unusable;
if daq_unusable>0 then do total_daq = .; strong_desire_AUD = .; strong_desire_non_AUD = .;
		 neg_reinforce_AUD = .; neg_reinforce_non_AUD = .; pos_reinforce_ability_to_control = .; end;

* Merging SSAGA and DAQ;
data d.v21_int_ssaga23; merge d.v21_int_ssaga23 tmp; by ind_id;run;
