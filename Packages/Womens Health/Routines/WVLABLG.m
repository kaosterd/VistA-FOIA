WVLABLG ;HCIOFO/FT IHS/ANMC/MWR - DISPLAY LAB LOG; ;8/31/98  16:24
 ;;1.0;WOMEN'S HEALTH;;Sep 30, 1998
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  CALLED BY OPTION: "WV LAB PRINT LOG" TO PRINT THE "LOG" OF
 ;;  OF PROCEDURES THAT HAVE BEEN ENTERED ("ACCESSIONED").
 ;
 ;---> VARIABLES:
 ;---> DATES: WVBEGDT=BEGINNING DATE, WVENDDT=ENDING DATE
 ;---> WVA:   1=ALL PROCEDURES, 0=ONLY PROCEDURES WITHOUT RESULTS
 ;---> WVB:   1=DISPLAY EACH PROCEDURE, 0=TOTALS ONLY
 ;
 D SETVARS^WVUTL5 S WVPOP=0
 D TITLE^WVUTL5("PRINT LOG OF PROCEDURES ENTRY")
 D DATES    G:WVPOP EXIT
 D SELECT   G:WVPOP EXIT
 D FACILITY G:WVPOP EXIT
 D RESULT   G:WVPOP EXIT
 D TOTALS   G:WVPOP EXIT
 D ORDER    G:WVPOP EXIT
 D DEVICE   G:WVPOP EXIT
 D SORT
 D COPYGBL
 D ^WVLABLG1
 ;
EXIT ;EP
 D KILLALL^WVUTL8
 Q
 ;
DATES ;EP
 ;---> ASK DATE RANGE.  RETURN DATES IN WVBEGDT AND WVENDDT.
 ;---> LAB PEOPLE GENERALLY LOOK AT THE LOG FOR ONE DAY.
 D ASKDATES^WVUTL3(.WVBEGDT,.WVENDDT,.WVPOP,"T-1","",1)
 Q
 ;
SELECT ;EP
 ;---> SELECT ENTRIES TO SEARCH FOR.
 D SELECT^WVSELECT("Accession Area",790.2,"WVAREA","","PAP",.WVPOP)
 Q
 ;
FACILITY ;EP
 ;---> SELECT FACILITY TO SEARCH FOR.
 N B S B=$$INSTTX^WVUTL6(DUZ(2))
 W !!?3,"Select the Facility for the log you wish to display."
 D DIC^WVFMAN(790.02,"QEMA",.Y,"   Select FACILITY: ",B)
 I Y<0 S WVPOP=1 Q
 S WVFAC=+Y
 Q
 ;
RESULT ;EP
 ;---> DISPLAY ALL PROCEDURES, OR ONLY PROCEDURES WITHOUT RESULTS.
 N DIR K DIRUT
 W !!?3,"Display ALL Procedures, or only Procedures with NO RESULTS?"
 S DIR("A")="   Select ALL or NO RESULTS: ",DIR("B")="ALL"
 S DIR(0)="SAM^a:ALL;n:NO RESULTS" D HELP1^WVLABLG2
 D ^DIR
 I Y=-1!($D(DIRUT)) S WVPOP=1 Q
 ;---> IF ALL PPROCEDURES, S WVA=1; IF ONLY NO RESULTS, S WVA=0.
 S WVA=$S(Y="a":1,1:0)
 Q
 ;
TOTALS ;EP
 ;---> DISPLAY ALL PROCEDURES, OR ONLY TOTALS.
 N DIR
 W !!?3,"Display data for EACH Procedure, or just TOTALS?"
 S DIR("A")="   Select EACH or TOTALS: ",DIR("B")="EACH"
 S DIR(0)="SAM^e:EACH;n:TOTALS" D HELP2^WVLABLG2
 D ^DIR
 I Y=-1!($D(DIRUT)) S WVPOP=1 Q
 ;---> IF DISPLAY EACH PROCEDURE, S WVB=1; IF TOTALS ONLY, S WVB=0
 S WVB=$S(Y="e":1,1:0)
 Q
 ;
ORDER ;EP
 ;---> ASK ORDER BY ACCESSION# OR BY PATIENT NAME.
 ;---> SORT SEQUENCE IN WVC:  1=ACCESSION# (DEFAULT), 2=PATIENT NAME
 S WVC=1
 ;---> QUIT IF DISPLAYING TOTALS ONLY.
 Q:'WVB  N DIR,DIRUT,Y
 W !!?3,"Display Procedures in order of:"
 W ?37,"1) ACCESSION# (earliest first)"
 W !?37,"2) PATIENT NAME (alphabetically)"
 S DIR("A")="   Select 1 or 2: ",DIR("B")=1
 S DIR(0)="SAM^1:ACCESSION#;2:PATIENT NAME" D HELP3^WVLABLG2
 D ^DIR
 I Y=-1!($D(DIRUT)) S WVPOP=1 Q
 S WVC=Y
 Q
 ;
DEVICE ;EP
 ;---> GET DEVICE AND POSSIBLY QUEUE TO TASKMAN.
 S ZTRTN="DEQUEUE^WVLABLG"
 F WVSV="A","B","C","BEGDT","ENDDT","FAC" D
 .I $D(@("WV"_WVSV)) S ZTSAVE("WV"_WVSV)=""
 ;---> SAVE ATTRIBUTES ARRAY. NOTE: SUBSTITUTE LOCAL ARRAY FOR WVAREA.
 I $D(WVAREA) N N S N=0 F  S N=$O(WVAREA(N)) Q:N=""  D
 .S ZTSAVE("WVAREA("""_N_""")")=""
 D ZIS^WVUTL2(.WVPOP,1)
 Q
 ;
SORT ;EP
 ;---> SORT AND STORE ARRAY IN ^TMP("WV",$J
 ;---> WVBEGDT1=ONE SECOND BEFORE BEGIN DATE.
 ;---> WVENDDT1=THE LAST SECOND OF END DATE.
 ;
 K ^TMP("WV",$J)
 S WVBEGDT1=WVBEGDT-.0001,WVENDDT1=WVENDDT+.9999
 S WVDATE=WVBEGDT1
 F  S WVDATE=$O(^WV(790.1,"ADE",WVDATE)) Q:'WVDATE!(WVDATE>WVENDDT1)  D
 .S WVIEN=0
 .F  S WVIEN=$O(^WV(790.1,"ADE",WVDATE,WVIEN)) Q:'WVIEN  D
 ..S Y=^WV(790.1,WVIEN,0),WVDFN=$P(Y,U,2)
 ..;---> QUIT IF NOT DONE AT THE SELECTED FACILITY.
 ..Q:$P(Y,U,34)'=WVFAC
 ..;---> QUIT IF NOT ALL "ACCESSION AREAS" (PROCEDURE TYPES) AND
 ..;---> THIS DOES NOT MATCH THE SELECTED AREA.
 ..I '$D(WVAREA("ALL")) Q:$P(Y,U,4)=""  Q:'$D(WVAREA($P(Y,U,4)))
 ..D STORE
 Q
 ;
 ;
STORE ;EP
 ;--->WVDATE IS ALREADY SET FROM LL SORT ABOVE.        ;---> DATE
 S WVCHRT=$$SSN^WVUTL1(WVDFN)                          ;---> SSN
 S WVNAME=$$NAME^WVUTL1(WVDFN)                         ;---> NAME
 S WVACCN=$P(Y,U)                                      ;---> ACCESSION#
 S X=$P(Y,U,4),WVPCDN=$$PCDNAM^WVUTL6                  ;---> PROC TYPE
 S WVDIAG=$$DIAG^WVUTL4($P(Y,U,5))                     ;---> RESULT/DIAG
 S WVRES=$O(^WV(790.1,WVIEN,1,0))                         ;---> RESULT TEXT
 ;---> QUIT IF DISPLAYING ONLY PROCEDURES WITH NO RESULTS.
 Q:'WVA&($P(Y,U,5))
 S WVPDATE=$$SLDT2^WVUTL5($P(Y,U,12))                  ;---> PROC DATE
 S WVRCVDT=$$SLDT2^WVUTL5($P(Y,U,17))                  ;---> RCV RES DAT
 S X=$P(Y,U,11),WVHLOC=$$HOSPLC^WVUTL6                 ;---> HOSP LOC
 S X=$P(Y,U,7),WVPROV=$$PROV^WVUTL6                    ;---> PROVIDER
 S X=$P(Y,U,18),WVUSER=$$PROV^WVUTL6                   ;---> ENTERED BY
 ;
 S X=WVCHRT_U_WVNAME_U_WVDATE_U_WVACCN_U_WVPCDN_U_WVRES_U_WVPDATE
 S X=X_U_WVHLOC_U_WVPROV_U_WVUSER_U_WVRCVDT_U_WVDIAG_U_WVIEN
 I WVC=1 S ^TMP("WV",$J,1,WVDATE,$P(WVACCN,"-"),$P(WVACCN,"-",2))=X Q
 I WVC=2 S ^TMP("WV",$J,1,WVDATE,WVNAME,WVACCN)=X Q
 Q
 ;
COPYGBL ;EP
 ;---> COPY ^TMP("WV",$J,1 TO ^TMP("WV",$J,2 TO MAKE IT FLAT.
 N I,M,N,P,Q
 S N=0,I=0
 F  S N=$O(^TMP("WV",$J,1,N)) Q:N=""  D
 .S M=0
 .F  S M=$O(^TMP("WV",$J,1,N,M)) Q:M=""  D
 ..S P=0
 ..F  S P=$O(^TMP("WV",$J,1,N,M,P)) Q:P=""  D
 ...S I=I+1,^TMP("WV",$J,2,I)=^TMP("WV",$J,1,N,M,P)
 Q
 ;
DEQUEUE ;EP
 ;---> TASKMAN QUEUE OF PRINTOUT.
 D SETVARS^WVUTL5,SORT,COPYGBL,^WVLABLG1,EXIT
 Q