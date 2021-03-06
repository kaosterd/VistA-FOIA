RMPRPIYO ;HIN/RVD-PROS INVENTORY ORDER/RE-ORDER ;5/7/01
 ;;3.0;PROSTHETICS;**61**;Feb 09, 1996
 D DIV4^RMPRSIT I $D(Y),(Y<0) K DIC("B") Q
 S X="NOW" D ^%DT D DD^%DT S RMDAT=Y
 ;
 W @IOF
 ;ask for location
 W !!,"Ordering ITEM from Supply or Vendor....",!
 ;
HCPC ;ask for HCPCS
 S RMF=1
 K DTOUT,DUOUT,DIC
 S DIC("A")="Select HCPCS to ORDER: "
 ;
 S DIC="^RMPR(661.11,",DIC(0)="AEMNQ"
 S DIC("S")="S RZ=^RMPR(661.11,+Y,0),RH=$P(RZ,U,1),RI=$P(RZ,U,2),RT=$P(RZ,U,9),RE=$O(^RMPR(661.1,""B"",RH,0)) I $P(^RMPR(661.1,RE,0),U,5),RT'=1,($P(RZ,U,4)=RMPR(""STA""))"
 S DIC("W")="I $D(^RMPR(661.11,+Y,0)) S RMZ=^RMPR(661.11,+Y,0) W ""   "",$P(RMZ,U,7),""  "",$P(RMZ,U,3)"
 W ! D ^DIC I $D(DUOUT)!$D(DTOUT)!(Y<0) G EXIT
 S RMHCPC=$P(^RMPR(661.11,+Y,0),U,1)
 S RMIDA=$P(^RMPR(661.11,+Y,0),U,2)
 S RMHCDA=$O(^RMPR(661.1,"B",RMHCPC,0))
 S RMPR11("HCPCS")=RMHCPC
 S RMPR11("ITEM")=RMIDA
 S RMPR11("STATION")=RMPR("STA")
 ;
VEN ;order item from vendor.
 K DIR,Y S DIR(0)="661.41,4",DIR("A")="Enter Vendor" D ^DIR
 I $D(DUOUT)!$D(DTOUT) W !,"*** Item was not ordered...." H 1 G HCPC
 I X="" W $C(7),!,"Enter Vendor from the Vendor file.." G VEN
 S RMVEN=+Y K DIR,Y
 ;
 ;
ORDER ;order QUANTITY from vendor or supply.
 K DIR,Y S DIR(0)="661.41,7",DIR("A")="Quantity to Order" D ^DIR
 I $D(DUOUT)!$D(DTOUT) W !,"*** Item was not ordered...." H 1 G HCPC
 I X="" W $C(7),!,"Enter quantity 1 to 99999.." G ORDER
 S (RMPR6("QUANTITY"),RMORDER)=Y K DIR,Y
 ;
COM ;comments
 K DIR,Y S DIR(0)="661.41,9",DIR("A")="Enter Comment" D ^DIR
 I $D(DUOUT)!$D(DTOUT) G HCPC
 S (RMPR6("COMMENT"),RMCOM)=Y
SET6 ;set-up 661.6 data
 S RMPR6("VENDOR")=$G(RMVEN)
 S RMPR6("TRAN TYPE")=2
 S RMPR6("LOCATION")=""
 S RMPR6("USER")=$G(DUZ)
 S RMPR6("VALUE")=""
UP6 ;create file 661.6
 S RMERR=$$CRE^RMPRPIX6(.RMPR6,.RMPR11)
 I $G(RMERR) W !,"*** Error in file 661.6 update!!!",! H 2 G HCPC
UPD ;update file 661.41
 ;
 ;D UPDATE^DIE("","RMDAT","","RMERR")
 ;call API for 661.41
 L +^RMPR(661.41,"ASSHID",RMPR("STA"),"O",RMPR11("HCPCS"),RMPR11("ITEM"))
 K RMERR,RMERROR
 S DIE="^RMPR(661.41,"
 S RMDAT(661.41,"+1,",.01)=DT
 S RMDAT(661.41,"+1,",1)=RMPR11("ITEM")
 S RMDAT(661.41,"+1,",2)=RMPR("STA")
 S RMDAT(661.41,"+1,",4)=RMVEN
 S RMDAT(661.41,"+1,",5)=RMPR11("HCPCS")
 S RMDAT(661.41,"+1,",7)=RMORDER
 S RMDAT(661.41,"+1,",9)=RMCOM
 S RMDAT(661.41,"+1,",10)="O"
 D UPDATE^DIE("","RMDAT","","RMERR") I $D(RMERR) S RMERROR=1
 L -^RMPR(661.41,"ASSHID",RMPR("STA"),"O",RMPR11("HCPCS"),RMPR11("ITEM"))
 I $G(RMERROR) W !,"*** Error in file 661.41 update!!!",!
 I '$G(RMERROR) W !,"*** Item was ordered...."
 H 1 G HCPC
 ;
 ; Prompt if adding a new HCPCS Item
OKADD(RMPR11,RMPRYN,RMPREXC) ;
 N DIR,X,Y,DUOUT,DTOUT,DIROUT,DIRUT
 S RMPREXC="",DIR(0)="Y"
 S DIR("A")="Are you adding '"_RMPR11("DESCRIPTION")_"' as a new ITEM for this HCPCS"
 D ^DIR
 I $D(DTOUT) S RMPREXC="T" G ADDNMX
 I $D(DIROUT) S RMPREXC="P" G ADDNMX
 I X=""!(X["^") S RMPREXC="^" G ADDNMX
 S RMPRYN="N" S:Y RMPRYN="Y"
 S RMPREXC=""
ADDNMX Q
 ;
LIKE(RMPRSTN,RMPRHCPC,RMPRTXT,RMPREXC,RMPR11) ;
 N RMPRMAX,RMPRLIN,RMPRGBL,DIR,X,Y,DA,DTOUT,DIROUT,DIRUT,DUOUT,RMPRA
 N RMPRERR,RMPRN
 S RMPREXC="",RMPRMAX=19
 S RMPRGBL="^RMPR(661.11,"_"""ASHD"","_RMPRSTN_","""_RMPRHCPC_""","""_RMPRTXT_""")"
 I $D(^RMPR(661.11,"ASHI",RMPRSTN,RMPRHCPC,RMPRTXT)) D  G LIKEA
 . S RMPRA(1)=$O(^RMPR(661.11,"ASHI",RMPR("STA"),RMPRHCPC,RMPRTXT,""))
 . W !?5,1,?9,$P(^RMPR(661.11,RMPRA(1),0),"^",2)
 . Q
LIKEA1 K RMPRA S RMPRLIN=0
LIKEA S RMPRGBL=$Q(@RMPRGBL)
 I '$D(RMPRLIN) S RMPRLIN=0
 I RMPRGBL="" G LIKEB
 I $QS(RMPRGBL,1)'=661.11 G LIKEB
 I $QS(RMPRGBL,2)'="ASHD" G LIKEB
 I $QS(RMPRGBL,3)'=RMPR("STA") G LIKEB
 I $QS(RMPRGBL,4)'=RMPRHCPC G LIKEB
 I $E($QS(RMPRGBL,5),1,$L(RMPRTXT))'=RMPRTXT G LIKEB
 S RMPRLIN=RMPRLIN+1
 W !?4,$J(RMPRLIN,2),?9,$QS(RMPRGBL,5)
 S RMPRA(RMPRLIN)=$QS(RMPRGBL,6)
 I RMPRLIN'<RMPRMAX G LIKEB
 G LIKEA
LIKEB I RMPRLIN=0 G LIKEX
 S DIR(0)="NAO^1:"_RMPRLIN_": ",DIR("A")="CHOOSE 1-"_RMPRLIN_": "
 D ^DIR W !
 I $D(DTOUT) S RMPREXC="T" G LIKEX
 I $D(DIROUT) S RMPREXC="P" G LIKEX
 I X="" S RMPREXC="" G LIKEX
 I X["^"!$D(DUOUT) S RMPREXC="^" G LIKEX
 K RMPR11
 S RMPR11("IEN")=RMPRA(X),RMPRERR=$$GET^RMPRPIX1(.RMPR11)
LIKEX Q
 ;
LKP ;print a message if PSAS HCPCS not in PIP or invalid HCPCS.
 Q:'$G(RMF)!(X=" ")
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 K RX
 I $D(^RMPR(661.7,"XSHIDS",RMPR("STA"),X)) S RX=1
 I '$G(RX),$D(^RMPR(661.1,"B",X)) D EN^DDIOL("*** Only PSAS HCPCS in PIP can be ordered.  Please verify your Location and PSAS HCPCS!!","","!!")
 K RX
 Q
 ;
EXIT ;MAIN EXIT POINT
 N RMPRSITE,RMPR D KILL^XUSCLEAN
 Q
