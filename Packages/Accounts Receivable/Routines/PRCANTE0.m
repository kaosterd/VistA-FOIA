PRCANTE0 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;SEP 19, 1995@07:50:48
 ;;0.0;
 ;;7.2;SEP 19, 1995@07:50:48
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 G CONT^PRCANTE1
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
PRCAI02K ;;8007994
PRCAI02L ;;10327226
PRCAI02M ;;10873093
PRCAI02N ;;8963541
PRCAI02O ;;10109729
PRCAI02P ;;6826290
PRCAI02Q ;;960956
PRCAI02R ;;8649853
PRCAI02S ;;8104721
PRCAI02T ;;7277981
PRCAI02U ;;8107829
PRCAI02V ;;11677837
PRCAI02W ;;16244788
PRCAI02X ;;17075662
PRCAI02Y ;;12274573
PRCAI02Z ;;13381976
PRCAI030 ;;12345426
PRCAI031 ;;11483989
PRCAI032 ;;10668818
PRCAI033 ;;14455621
PRCAI034 ;;13902721
PRCAI035 ;;13874247
PRCAI036 ;;12525023
PRCAI037 ;;12885572
PRCAI038 ;;10111549
PRCAI039 ;;12080000
PRCAI03A ;;8526214
PRCAI03B ;;5281278
PRCAI03C ;;11640455
PRCAI03D ;;11021635
PRCAI03E ;;13161574
PRCAI03F ;;12402198
PRCAI03G ;;17168216
PRCAI03H ;;16568262
PRCAI03I ;;17186299
PRCAI03J ;;15760618
PRCAI03K ;;13569305
PRCAI03L ;;14391893
PRCAI03M ;;17499453
PRCAI03N ;;13281182
PRCAI03O ;;17490178
PRCAI03P ;;16231410
PRCAI03Q ;;18152253
PRCAI03R ;;9476855
PRCAI03S ;;7537069
PRCAI03T ;;6237207
PRCAI03U ;;8457505
PRCAI03V ;;7514911
PRCAI03W ;;7041327
PRCAI03X ;;7740587
PRCAI03Y ;;6850615
PRCAI03Z ;;8390948
PRCAI040 ;;7729811
PRCAI041 ;;8157068
PRCAI042 ;;7645512
PRCAI043 ;;8315602
PRCAI044 ;;8285033
PRCAI045 ;;7972071
PRCAI046 ;;8916747
PRCAI047 ;;7296355
PRCAI048 ;;9574157
PRCAI049 ;;9421376
PRCAI04A ;;7758784
PRCAI04B ;;8351678
PRCAI04C ;;8697970
PRCAI04D ;;10051672
PRCAI04E ;;10133133
PRCAI04F ;;9559488
PRCAI04G ;;9443032
PRCAI04H ;;8511706
PRCAI04I ;;8441560
PRCAI04J ;;7657223
PRCAI04K ;;8337881
PRCAI04L ;;9164430
PRCAI04M ;;5218914
PRCAI04N ;;4929607
PRCAI04O ;;1928416
PRCAINI1 ;;5004820
PRCAINI2 ;;5232536
PRCAINI3 ;;16806494
PRCAINI4 ;;3357708
PRCAINI5 ;;2514289
PRCAINIS ;;2209498
PRCAINIT ;;10324995
PRCAINS1 ;;4248556
PRCAINST ;;2087276
PRCAKBT ;;13416814
PRCAKBT1 ;;12375527
PRCAKM ;;9835440
PRCAKMR ;;5182179
PRCAKS ;;8219375
PRCAKTP ;;3816580
PRCAKUN ;;9454631
PRCALET ;;1444147
PRCALM ;;9961044
PRCALST ;;13048313
PRCALST1 ;;1260099
PRCALT2 ;;4758188
PRCAMARK ;;6372040
PRCAMAS ;;3280486
PRCAMESG ;;781868
PRCAMRKC ;;545164
PRCANRU ;;8570583
PRCANRU0 ;;6087574
PRCAOFF ;;12315560
PRCAOFF1 ;;8556370
PRCAOFF2 ;;13326420
PRCAOFF3 ;;7837487
PRCAOFF4 ;;8279590
PRCAOLD ;;9177437
PRCAPAT ;;18113504
PRCAPAT1 ;;1657991
PRCAPAY ;;11877840
PRCAPAY1 ;;13978186
PRCAPAY2 ;;10975714
PRCAPAY3 ;;2847314
PRCAPCL ;;8181427
PRCAPRO ;;10192688
PRCAPTR ;;4330309
PRCAQUE ;;4247288
PRCAREP ;;9114542
PRCAREPT ;;13564453
PRCARETN ;;12618183
PRCARFD ;;18279609
PRCARFD1 ;;11110938
PRCARFD2 ;;2403950
PRCARFD3 ;;2152789
PRCARFP ;;7070826
PRCARFU ;;6738284
PRCARPS ;;9786141
PRCARPS1 ;;15508414
PRCASER ;;7326682
PRCASER1 ;;10306446
PRCASET ;;5156070
PRCASIG ;;3048834
PRCASVC ;;5279576
PRCASVC1 ;;4487671
PRCASVC3 ;;3133773
PRCASVC6 ;;9687817
PRCAUDT ;;12891243
PRCAUDT1 ;;5877681
PRCAUPD ;;5882693
PRCAUT1 ;;4102245
PRCAUT2 ;;3164379
PRCAUT3 ;;5490775
PRCAUTL ;;11165515
PRCAWO ;;9280254
PRCAWO1 ;;6372476
PRCAWOF ;;8448404
PRCAWREA ;;6818127
PRCAWV ;;5919273
PRCAX ;;10670246