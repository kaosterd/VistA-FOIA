PSGSET ;BIR/CML3-INPATIENT SIGN-ON ;25 SEP 95 / 1:39 PM
 ;;5.0; INPATIENT MEDICATIONS ;;16 DEC 97
 K %DT,%ZIS,IO("Q") D HOME^%ZIS K IOP S X=$P($G(^PS(59.7,1,20)),"^",2) W !!,"(Inpatient Medications - Version "_$P($T(PSGSET+1),";",3) W "  ",$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3),")"
 D ENCV^PSGSETU
 I $S($D(DUZ)[0:1,DUZ'=+DUZ:1,1:'$D(^VA(200,DUZ,0))) W $C(7),$C(7),!!," BUT I DON'T KNOW WHO YOU ARE!!  (DUZ TROUBLE)" S XQUIT=1 D ENKV^PSGSETU Q
 I $D(^VA(200,DUZ,.1)),$P(^(.1),"^",4)]"" S N=$P(^(.1),"^",4)
 E  S N=$P(^VA(200,DUZ,0),"^")
 S X=$R(6)+1 W !!,$P("HI^HELLO^GREETINGS^WELCOME^HOWDY^GOOD ^","^",X),$S(X'=6:"",PSGDT#1<.12:"MORNING",PSGDT#1<.18:"AFTERNOON",1:"EVENING"),", ",N,"!  ("
 S X=$P(PSJSYSU,";",3) W $S(X=3:"PHARMACIST",X=2:"PHARMACY TECHNICIAN",X=1:"NURSE",$P(PSJSYSU,";",2):"PROVIDER",1:"WARD STAFF") W:X&$P(PSJSYSU,";",2) " & PROVIDER" W ")"
 ;
DONE ;
 D ENKV^PSGSETU Q
 ;
BRJCHK ;
 S X1=DT,X2=-2 D C^%DTC W:'$O(^PS(53.42,X)) $C(7),$C(7),$C(7),$C(7),$C(7),!!?16,"*** WARNING!  THE UNIT DOSE BACKGROUND JOB ***",!?16,"*** (PSJU BRJ) DOES NOT SEEM TO BE RUNNING! ***",! Q
 ;
ENDLP ;
 S PSGION=$S($D(ION):ION,1:"HOME") K %ZIS S %ZIS="QN",IOP=X D ^%ZIS I POP S IOP=PSGION D ^%ZIS K %ZIS,IOP,PSGION K X Q
 W $S(X=$E(ION,1,$L(X)):$E(ION,$L(X)+1,$L(ION)),1:"  "_ION) S X=ION D ^%ZISC K %ZIS,PSGION,IOP Q