PSOHLUP1 ;BIR/RTR-Backfill OERR from Pharmacy (all) ; 7/20/96
 ;;7.0;OUTPATIENT PHARMACY;**10**;DEC 1997
 ;
 ;Backfill all Rx's
EN ;
 D NOW^%DTC S $P(^PS(59.7,1,49.99),"^",8)=%
 N C,Y,DA,IFN,RXP,DFN,PAT,PSODFN,PSOPPZ,PSOPPQZ,YEAR1,PSOEST,PSOERSTA,PSOPHSTA,X,T,PRU,PSOCV,PTFLAG,III,ZDFN
 I '$G(DT) S DT=$$DT^XLFDT
 S X1=DT,X2=-121 D C^%DTC S YEAR1=X
 F ZDFN=0:0 S ZDFN=$O(^PS(55,ZDFN)) Q:'ZDFN  D:'$P($G(^PS(55,ZDFN,0)),"^",6)
 .F PSOPPZ=YEAR1:0 S PSOPPZ=$O(^PS(55,ZDFN,"P","A",PSOPPZ)) Q:'PSOPPZ  F PSOPPQZ=0:0 S PSOPPQZ=$O(^PS(55,ZDFN,"P","A",PSOPPZ,PSOPPQZ)) Q:'PSOPPQZ  D PAT D:$D(^PSRX(PSOPPQZ,0))&('$P($G(^PSRX(PSOPPQZ,"OR1")),"^",2))&('$G(PTFLAG))
 ..Q:'$P($G(^PSRX(PSOPPQZ,0)),"^",2)
 ..S PSOEST=$S($D(^PSRX(PSOPPQZ,"STA")):$P($G(^PSRX(PSOPPQZ,"STA")),"^"),1:$P($G(^PSRX(PSOPPQZ,0)),"^",15)) Q:PSOEST=10!(PSOEST=13)!(PSOEST=16)!(PSOEST=14)
 ..D:'$P($G(^PSRX(PSOPPQZ,0)),"^",19)
 ...I $P($G(^PSRX(PSOPPQZ,"OR1")),"^")']"",+$G(^PSDRUG(+$P(^PSRX(PSOPPQZ,0),"^",6),2)) S $P(^PSRX(PSOPPQZ,"OR1"),"^")=+$G(^PSDRUG($P(^PSRX(PSOPPQZ,0),"^",6),2))
 ...I $G(^PSRX(PSOPPQZ,"SIG"))']"" S ^PSRX(PSOPPQZ,"SIG")=$P($G(^PSRX(PSOPPQZ,0)),"^",10)_"^"_0 S $P(^PSRX(PSOPPQZ,0),"^",10)=""
 ...S ^PSRX(PSOPPQZ,"STA")=$P($G(^PSRX(PSOPPQZ,0)),"^",15) S $P(^PSRX(PSOPPQZ,0),"^",15)=""
 ...S PR=0 F  S PR=$O(^PSRX(PSOPPQZ,"P",PR)) Q:'PR  D
 ....I '$P($G(^PSRX(PSOPPQZ,"P",PR,0)),"^") K ^PSRX(PSOPPQZ,"P",PR,0) Q
 ....S ^PSRX("ADP",$E($P(^PSRX(PSOPPQZ,"P",PR,0),"^"),1,7),PSOPPQZ,PR)=""
 ...S $P(^PSRX(PSOPPQZ,0),"^",19)=1
 ..D:'$P($G(^PSRX(PSOPPQZ,"SIG")),"^",2) POP^PSOSIGNO(PSOPPQZ)
 ..D EN^PSOHLSN1(PSOPPQZ,"ZC","")
 ..Q:'$P($G(^PSRX(PSOPPQZ,"OR1")),"^",2)
 ..S PSOEST=$P($G(^PSRX(PSOPPQZ,"STA")),"^")
 ..I +$P($G(^PSRX(PSOPPQZ,2)),"^",6),$P($G(^(2)),"^",6)<DT S $P(^PSRX(PSOPPQZ,"STA"),"^")=11 D ECAN^PSOUTL(PSOPPQZ) S PSOEST=11
 ..S PSOERSTA=$S(PSOEST=3:"OH",PSOEST=12:"OD",PSOEST=15:"OD",1:"SC"),PSOPHSTA=$S(PSOEST=0:"CM",PSOEST=1:"IP",PSOEST=4:"IP",PSOEST=5:"ZS",PSOEST=11:"ZE",1:"")
 ..D EN^PSOHLSN1(PSOPPQZ,PSOERSTA,PSOPHSTA,"")
 .S $P(^PS(55,ZDFN,0),"^",6)=1
 D NOW^%DTC S $P(^PS(59.7,1,49.99),"^",9)=%
 S ZTREQ="@"
 Q
PAT ;Check for correct patient
 S PTFLAG=0
 Q:ZDFN=$P($G(^PSRX(PSOPPQZ,0)),"^",2)
 S PTFLAG=1
 K ^PS(55,ZDFN,"P","A",PSOPPZ,PSOPPQZ)
 F III=0:0 S III=$O(^PS(55,ZDFN,"P",III)) Q:'III  I $G(^PS(55,ZDFN,"P",III,0))=PSOPPQZ K ^PS(55,ZDFN,"P",III,0)
 Q
