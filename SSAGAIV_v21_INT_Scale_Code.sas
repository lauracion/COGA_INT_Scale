libname master 'E:\Laura\Work\COGA\Projects\INT_scale\data\orig_dist_71';
libname d 'E:\Laura\Work\COGA\Projects\INT_scale\Paper\data\ssagaiv';

%macro gen(dataset);
* keeping the DSMIV diagnoses needed to score the INT scale;
data tmp1; set master.dx_&dataset;
keep ind_id agd4dx pnd4dx pnd4numsx spd4dx occpd4dx ocobd4dx ptd4dx ptd4critbsx ptd4critcsx ptd4critdsx dpd4dx dpd4sx ald4abdx ald4absx ald4dpdx ald4dpsx;run;

* keeping the SSAGAIV items needed to score the INT scale;
data tmp2; set master.&dataset;
	keep IND_ID intvyr DM1 Age DM8b DM17b AL6 AL17
	AG1 AG2_1-AG2_5 AG2a AG3A_1-AG3A_9 AG3b AG4 AG4a AG4b AG4c AGp2f AGp2h AGp2i AGp2j
	PN1x PN2a PN2b PN3 PN3a PN3a1 PN3b PN3b1 PN3c PN3c1 PN4_1-PN4_13 PN5 PN5_1 PN6 PNp1f PNp1h PNp1i PNp1j
	SP1_1-SP1_6 SP2 SP2a SP2b SPp1d SPp1f SPp1h SPp1i SPp1j
	OC1 OC1a OC1b OC1c OC2 OC3 OC4 OC9 OC9A OC10 OC11 OCp1f OCp1h OCp1i OCp1j OCp9f OCp9h OCp9i OCp9j
	PT1a1-PT1a20 PT3-PT7 PT9-PT15 PT11a PT17-PT21 PTp23f PTp23h PTp23i PTp23j
	DP1 DP2 DP2a DP4a DP4b DP4c DP5 DP6a DP6b DP7 DP7f DP8-DP13 DP15a DP15b DP15c DP15d DP27 DP27b1-DP27b13
	/* for DIRTY */ dp20 dp21c dp21 dp21a dp21_1 dp21_2 dp21a1 dp22b1 dp22b2 dp22b3 dp23 dp24 dp25 dp26a
	SU1 SU1a SU1b SU2 SU5 SU9_1--SU9_6;
	if dm8b in (1 2 3 6) then dm8b=1;
	if dm17b = 0 then dm17b=1; *ssagaii does not have a 0 category for income;
run;

proc sort data=tmp1;by ind_id;
proc sort data=tmp2;by ind_id;
* merging all needed information to calculate the INT scale items and score;
data d.v21_int_&dataset; merge tmp2 tmp1; by ind_id;run;

* generating INT Scale Score for SSAGA-IV adults;
data d.v21_int_&dataset; 
	set d.v21_int_&dataset;

	**************;
	* Agoraphobia ;
	**************;

	if AG2_1=1 & AG2_2=1 & AG2_3=1 & AG2_4=1 & AG2_5=1 & AG2a=1 then AG_ko1=1;
	else if AG2_1=. | AG2_2=. | AG2_3=. | AG2_4=. | AG2_5=. | AG2a=. then AG_ko1=.;
	else AG_ko1=0;

	if AGp2h=5 | AGp2i=5 | AGp2j=5 | AGp2f=5 then AG_ko2=1;
	else if AGp2h=. & AGp2i=. & AGp2j=. & AGp2f=. then AG_ko2=.;
	else AG_ko2=0;

	if AG1=5 & (AG_ko1^=1) & (AG_ko2^=1) then INT1_1=1;
	else if AG1=. then INT1_1=.;
	else INT1_1=0;
	
	if AG3A_1=5 | AG3A_2=5 | AG3A_3=5 | AG3A_4=5 | AG3A_5=5 | AG3A_6=5 | AG3A_7=5 | AG3A_8=5 | AG3A_9=5 | AG3b=5 | AG4=5 | AG4a=5 | AG4b=5 | AG4c=5 then INT1_2=1;
	else if AG1=. then INT1_2=.;
	else INT1_2=0;

	* 0-3 score;
	if agd4dx=5 then INT1=3; 
	else if agd4dx=. then INT1=.;
	else if INT1_1=1 and INT1_2=1 then INT1=2;
	else if INT1_1=1 or INT1_2=1 then INT1=1;
	else if INT1_1=0 and INT1_2=0 then INT1=0;
	else INT1=.;

	*****************;
	* Panic Disorder ;
	*****************;

	if PNp1h=5 | PNp1i=5 | PNp1j=5 | PNp1f=5 then PN_ko1=1;
	else if PNp1h=. & PNp1i=. & PNp1j=. & PNp1f=. then PN_ko1=.;
	else PN_ko1=0;
	
	if PN1x=5 & (PN2a=5 | PN2b=5 | PN5>1 | PN5_1=5) & PN_ko1^=1 then INT2_1=1;
	else if PN1x=. then INT2_1=.;
	else INT2_1=0;

	PN4_cnt=0;
	array PN4 (13) PN4_1-PN4_13;
	do i=1 to 13;
		if PN4(i)=5 then PN4_cnt+1;
	end;
	if PN4_cnt>3 & PN6=5 then INT2_2=1;
	else if PN1x=. then INT2_2=.;
	else INT2_2=0;
	
	if PN3=5 | (PN3a=5 & PN3a1=5) | (PN3b=5 & PN3b1=5) | (PN3c=5 & PN3c1=5) then INT2_3=1;
	else if PN1x=. then INT2_3=.;
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
	else if pnd4dx=. then INT2=.;
	else if INT2_1cnt>1 then INT2=2;
	else if INT2_1cnt=1 then INT2=1;
	else if INT2_0cnt=3 then INT2=0;
	else INT2=.;

	****************;
	* Social Phobia ;
	****************;

	if SPp1h=5 | SPp1i=5 | SPp1j=5 | SPp1f=5 then SP_ko1=1;
	else if SPp1h=. & SPp1i=. & SPp1j=. & SPp1f=. then SP_ko1=.;
	else SP_ko1=0;
	
	if (SP1_1=5 | SP1_2=5 | SP1_3=5 | SP1_4=5 | SP1_5=5 | SP1_6=5) and SP_ko1^=1 then INT3_1=1;
	else if SP1_1=. & SP1_2=. & SP1_3=. & SP1_4=. & SP1_5=. & SP1_6=. then INT3_1=.;
	else INT3_1=0;

	if SP2=5 then INT3_2=1;
	else if SP1_1=. & SP1_2=. & SP1_3=. & SP1_4=. & SP1_5=. & SP1_6=. then INT3_2=.;
	else INT3_2=0;
	
	if SP2a=5 | SP2b=5 then INT3_3=1;
	else if SP1_1=. & SP1_2=. & SP1_3=. & SP1_4=. & SP1_5=. & SP1_6=. then INT3_3=.;
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
	else if spd4dx=. then INT3=.;
	else if INT3_1cnt>1 then INT3=2;
	else if INT3_1cnt=1 then INT3=1;
	else if INT3_0cnt=3 then INT3=0;
	else INT3=.;

	**************************************;
	* OCD (Obsessive-Compulsive Disorder) ;
	**************************************;

	if OCp1h=5 | OCp1i=5 | OCp1j=5 | OCp1f=5 then OC_ko1=1;
	else if OCp1h=. & OCp1i=. & OCp1j=. & OCp1f=. then OC_ko1=.;
	else OC_ko1=0;

	if OC1=5 & OC1a^=5 & OC1b^=5 & OC2=5 & OC3=5 & OC_ko1^=1 then INT4_1=1;
	else if OC1=. then INT4_1=.;
	else INT4_1=0;

	if OCp9h=5 | OCp9i=5 | OCp9j=5 | OCp9f=5 then OC_ko2=1;
	else if OCp9h=. & OCp9i=. & OCp9j=. & OCp9f=. then OC_ko2=.;
	else OC_ko2=0;

	if OC9=5 & (OC9A=5 | OC10=5) & OC_ko2^=1 then INT4_2=1;
	else if OC9=. then INT4_2=.;
	else INT4_2=0;

	if OC4=5 | OC11=5 then INT4_3=1;
	else if OC1=. | OC9=. then INT4_3=.;
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
	else if OCcpD4dx=. & OCobD4dx=. then INT4=.;
	else if INT4_1cnt>1 then INT4=2;
	else if INT4_1cnt>0 then INT4=1;
	else if INT4_0cnt=3 then INT4=0;
	else INT4=.;

	****************************************;
	* PTSD (Post Traumatic Stress Disorder) ;
	****************************************;

	if PTp23h=5 | PTp23i=5 | PTp23j=5 | PTp23f=5 then PT_ko1=1;
	else if PTp23h=. & PTp23i=. & PTp23j=. & PTp23f=. then PT_ko1=.;
	else PT_ko1=0;

	PT1a_cnt=0;
	PT1a_0cnt=0;
	array PT1a (20) PT1a1-PT1a20;
	do i=1 to 20;
		if PT1a(i)=5 then PT1a_cnt+1;
		else if PT1a(i) not in (1,5) then PT1a_0cnt+1;
	end;

	if (PT3=5 | PT4=5 | PT5=5 | PT6=5 | PT7=5) & PT_ko1^=1 then INT5_1=1;
	else if PT3=. & PT4=. & PT5=. & PT6=. & PT7=. & PT1a_0cnt=20 then INT5_1=.;
	else INT5_1=0;
	
	sumINT5_2=sum(PT9=5, PT10=5, PT11=5 & PT11a^=5, PT12=5, PT13=5, PT14=5, PT15=5);
	if sumINT5_2>2 & PT_ko1^=1 then INT5_2=1;
	else if PT9=. & PT10=. & PT11=. & PT11a=. & PT12=. & PT13=. & PT14=. & PT15=. & PT1a_0cnt=20 then INT5_2=.;
	else INT5_2=0;

	sumINT5_3=sum(PT17=5, PT18=5, PT19=5, PT20=5, PT21=5);
	if sumINT5_3>1 & PT_ko1^=1 then INT5_3=1;
	else if PT17=. & PT18=. & PT19=. & PT20=. & PT21=. & PT1a_0cnt=20 then INT5_3=.;
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
	else if ptd4dx=. then INT5=.;
	else if INT5_1cnt>1 then INT5=2;
	else if INT5_1cnt=1 then INT5=1;
	else if INT5_0cnt=3 then INT5=0;
	else INT5=.;

	*********************************;
	* MDE (Major Depression Episode) ;
	*********************************;

	/* start of code taken from DP_DSMIVrv.txt for SSAGAIV */

	/********       quit or cut down on smoking          			    *******/
	if dp20=5 then smoking=1; else smoking=0;       
	/*      Calculate if drank enough to be "dirty"          	              */
	if dm1=1 then 
		do;   * for males;
			if dp21c=5 											  then drinks=1; 
			else if (dp21 >=2)*(dp21a >=5)                        then drinks=1;
			else if (dp21 =.K)*(dp21_1 =5)*(dp21a >=5)            then drinks=1;
			else if (dp21 =.K)*(dp21_1 =5)*(dp21a =.K)*(dp21a1=5) then drinks=1;
			else if (dp21 >=2)*(dp21a =.K)*(dp21a1=5)             then drinks=1; else drinks=0;
 		end;
	if dm1=2 then 
		do;  * for females;
    		if dp21c=5 											  then drinks=1;
			else if (dp21 >=2)*(dp21a >=5)           			  then drinks=1;
			else if (dp21 >=4)*(dp21a >=3)           			  then drinks=1;
			else if (dp21 =.K)*(dp21_2=5)*(dp21a=.K)*(dp21a1=5)   then drinks=1;
			else if (dp21 =.K)*(dp21_2=5)*(dp21a >=3)             then drinks=1;
			else if (dp21 =.K)*(dp21_1=5)*(dp21a >=5)             then drinks=1;
			else if (dp21 >=4)*(dp21a=.K)*(dp21a1=5)              then drinks=1; else drinks=0;
  		end;
  
	/***  Calculate if used enough drugs to be "dirty"             		    ***/
	if (dp22b1 ge 4 | dp22b2 ge 4 | dp22b3 ge 4)  then drugs=1; else drugs=0;
	/********        start or change meds dose                              ***/
	if dp23=5  then medication=1; else medication=0;    
	/********        bereavement                                            ***/
	if dp24=5  then bereavement=1; else bereavement=0;    
	/********        organic causes, illness                        	    ***/
	if dp25=5  then organic=1; else organic=0;    
	/*********       miscarriage, abortion, 'post-partum'                   ***/
	if dp26a=5 then postpartum=1; else postpartum=0;    

	/* end of code taken from DP_DSMIVrv.txt for SSAGAIV */
	
	DIRTY=sum(of smoking, drinks, drugs,medication,postpartum, bereavement, organic);  

	if DP1=. & DP2=. & (DP2a=. | DP2a=.K) then
		do;
			INT6_1=.;INT6_2=.;INT6_3=.;INT6_4=.;INT6_5=.;INT6_6=.;INT6_7=.;INT6_8=.;
		end;
	else if DIRTY = 0 then
		do;
			if DP4a=5 | DP4b=5 | DP4c=5 | DP5=5 then INT6_1=1; else INT6_1=0;
			if DP6a=5 | DP6b=5 then INT6_2=1; else INT6_2=0;
			if DP7=5 | DP7f=5 then INT6_3=1; else INT6_3=0;
			if DP8=5 | DP9=5 then INT6_4=1; else INT6_4=0;
			if DP10=5 then INT6_5=1; else INT6_5=0;
			if DP11=5 then INT6_6=1; else INT6_6=0;
			if DP13=5 then INT6_7=1; else INT6_7=0;
			if DP15a=5 then INT6_8=1; else INT6_8=0;
		end;
		  else if DP27=5 then
				do;
					if DP27b1=5 | DP27b2=5 | DP27b3=5 then INT6_1=1; else INT6_1=0; 
					if DP27b4=5 | DP27b5=5 then INT6_2=1; else INT6_2=0; 
					if DP27b6=5 | DP27b7=5 then INT6_3=1; else INT6_3=0;
					if DP27b8=5 | DP27b9=5 then INT6_4=1; else INT6_4=0;
					if DP27b10=5 then INT6_5=1;	else INT6_5=0; 
					if DP27b11=5 then INT6_6=1; else INT6_6=0;
					if DP27b12=5 then INT6_7=1; else INT6_7=0;
					if DP27b13=5 then INT6_8=1; else INT6_8=0;
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
	else if dpd4dx=. then INT6=.;
	else if INT6_1cnt>4	then INT6=2;
	else if INT6_1cnt>0 then INT6=1;
	else if INT6_0cnt=8 then INT6=0;
	else INT6=.;

	**************;
	* Suicidality ;
	**************;

	if SU1a=5 then INT7_1=1;
	else if (SU1=. or SU1=.K) and DP15b ne 5 then INT7_1=.;
	else INT7_1=0;

	if SU1b=5 or DP15c=5 then INT7_2=1;
	else if (SU1=. or SU1=.K) and DP15b ne 5 then INT7_2=.;
	else INT7_2=0;

	if (DP15d=5 or SU2=5) and SU5=5 and (SU9_1=5 and SU9_2=1 and SU9_3=1 and SU9_4=1 and SU9_5=1 and SU9_6=1) then INT7_3=1;
	else if (DP15d=. and SU2=.) or SU5=. or SU9_1=. or SU9_2=. or SU9_3=. or SU9_4=. or SU9_5=. or SU9_6=. then INT7_3=.;

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
%mend;
%gen(ssaga4);%gen(ssaga4_f1);%gen(ssaga4_f2);%gen(ssaga4_f3);%gen(ssaga4_f4);%gen(ssaga4_f5);%gen(ssaga4_f6);

%macro freq(dataset);
proc freq data=d.v21_int_&dataset;
	title 'The final INT scale';
	table INT_Total_Score INT_unusable/ missprint;
run;
%mend;
%freq(ssaga4);%freq(ssaga4_f1);%freq(ssaga4_f2);%freq(ssaga4_f3);%freq(ssaga4_f4);%freq(ssaga4_f5);%freq(ssaga4_f6);


* macro to harvest neo and achenbach data;

%macro harvest(achen,neo,ssaga);

* Achenbach variables - only interviews performed during the same year as SSAGA;
data tmp3; 
	set master.&achen;
		keep ind_id datefilled SC_AnxDep_raw SC_Withdrawn_raw SC_Somatic_raw SC_Aggressive_raw SC_RuleBreak_raw SC_Intrusive_raw 
		     SC_Internal_raw SC_External_raw; 
proc sort data=d.v21_int_&ssaga; by ind_id;
proc sort data=tmp3; by ind_id;
data tmp3; merge d.v21_int_&ssaga tmp3 ; by ind_id;
data tmp3; set tmp3; if intvyr=year(datefilled);
data tmp3; set tmp3; keep ind_id datefilled SC_AnxDep_raw SC_Withdrawn_raw SC_Somatic_raw SC_Aggressive_raw SC_RuleBreak_raw SC_Intrusive_raw 
		     			  SC_Internal_raw SC_External_raw;

* NEO - only interviews performed during the same year as SSAGA;
data tmp4; 
	set master.&neo;
		keep ind_id adm_y neo_n--neo_c; 
proc sort data=tmp4; by ind_id;
data tmp4; merge d.v21_int_&ssaga tmp4; by ind_id;run;
data tmp4; set tmp4;if intvyr=adm_y;
data tmp4; set tmp4; keep ind_id adm_y neo_n--neo_c;

* Merging SSAGA, Achen and NEO;
data d.v21_int_&ssaga; merge d.v21_int_&ssaga tmp3 tmp4; by ind_id;run;

%mend;
%harvest(asr4,neo4,ssaga4);%harvest(asr4_f1,neo4_f1,ssaga4_f1);%harvest(asr4_f2,neo4_f2,ssaga4_f2);
%harvest(asr4_f3,neo4_f3,ssaga4_f3);%harvest(asr4_f4,neo4_f4,ssaga4_f4);
%harvest(asr4_f4,neo4_f5,ssaga4_f5);%harvest(asr4_f4,neo4_f6,ssaga4_f6); * no data processed yet for f5 and f6 for achen - using f4 so macro does not fail;

* score and harvest DAQ/craving data;
* DAQ administered to 12 yo and on who already tried alcohol;

%macro daqscore(crv,ssaga);
data tmp; set master.&crv;
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
	keep ind_id adm_y total_daq strong_desire_AUD strong_desire_non_AUD
		 neg_reinforce_AUD neg_reinforce_non_AUD pos_reinforce_ability_to_control daq_unusable;

proc sort data=d.v21_int_&ssaga; by ind_id;
proc sort data=tmp; by ind_id;
data tmp; merge d.v21_int_&ssaga tmp; by ind_id;
data tmp; set tmp; if intvyr=adm_y;
data tmp; set tmp; 	keep ind_id adm_y total_daq strong_desire_AUD strong_desire_non_AUD
		 neg_reinforce_AUD neg_reinforce_non_AUD pos_reinforce_ability_to_control daq_unusable;
if daq_unusable>0 then do total_daq = .; strong_desire_AUD = .; strong_desire_non_AUD = .;
		 neg_reinforce_AUD = .; neg_reinforce_non_AUD = .; pos_reinforce_ability_to_control = .; end;

* Merging SSAGA and DAQ;
data d.v21_int_&ssaga; merge d.v21_int_&ssaga tmp; by ind_id;run;

%mend;
%daqscore(crv4,ssaga4);%daqscore(crv4_f1,ssaga4_f1);%daqscore(crv4_f2,ssaga4_f2);%daqscore(crv4_f3,ssaga4_f3);
%daqscore(crv4_f4,ssaga4_f4);%daqscore(crv4_f5,ssaga4_f5);%daqscore(crv4_f6,ssaga4_f6);
