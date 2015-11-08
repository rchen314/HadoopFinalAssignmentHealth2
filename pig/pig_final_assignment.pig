
hadoop dfs -copyFromLocal inpatient.csv /pig/inpatient.csv

REGISTER /usr/lib/pig/piggybank.jar;

DEFINE CSVLoader org.apache.pig.piggybank.storage.CSVLoader();

DEFINE REPLACE org.apache.pig.piggybank.evaluation.string.REPLACE();


L = LOAD '/pig/inpatient.csv' USING CSVLoader AS (procedure, id, provider,
      city, address, state, zip, region, discharges, covered_charge, total_charge,
      medicare_charge);

A  = FILTER L BY state != 'Provider State';

AF = FOREACH A GENERATE procedure, state, total_charge;

BF = FOREACH AF GENERATE procedure as procedure,
                        state as state,
                        REPLACE(total_charge, ',', '') AS total_charge;

CF = FOREACH BF GENERATE procedure as procedure,
                         state as state,
                         (float) REGEX_EXTRACT(total_charge, '([0-9]*\\.[0-9]*)', 1) AS total_charge;

X  = GROUP CF BY state;

AC = FOREACH X GENERATE group AS grp, AVG(CF.total_charge);

S  = ORDER AC BY $1 DESC;

DUMP S;


Y = GROUP CF by procedure;

AD = FOREACH Y GENERATE group AS grp, AVG(CF.total_charge);

T  = ORDER AD BY $1 DESC;

DUMP T;


Results of state query:

(AK,14572.391745298972)
(DC,12998.029389880952)
(HI,12775.739504162542)
(CA,12629.668472019062)
(MD,12608.947661015507)
(NY,11795.492051783562)
(VT,11766.304485857929)
(WY,11398.485881357541)
(CT,11365.450668782632)
(NJ,10678.988641289126)
(WA,10543.1516532486)
(RI,10509.566857993197)
(OR,10436.192851923355)
(DE,10360.072433549136)
(NV,10291.718023062149)
(MA,10279.98152182091)
(AZ,10154.528211900704)
(SD,10141.687990290638)
(MN,9948.236957123183)
(ND,9827.638051109856)
(ID,9827.180084062358)
(IL,9790.676095555202)
(MI,9754.420404794977)
(UT,9749.90709048412)
(NM,9619.841088680821)
(CO,9502.685543774802)
(NE,9331.682510059882)
(NH,9289.661799082054)
(WI,9270.70559810835)
(MT,9252.80278069417)
(TX,9243.979567503977)
(SC,9132.420751970276)
(PA,9100.043216425722)
(NC,9089.435710232732)
(GA,8925.793907718382)
(VA,8887.7521767515)
(FL,8826.990432116869)
(OH,8808.127646794948)
(IN,8756.082530993252)
(MO,8724.631266516633)
(ME,8679.994977521466)
(LA,8638.662569588547)
(KS,8455.476429698232)
(OK,8353.641032869853)
(IA,8312.571709339181)
(KY,8278.588842161007)
(MS,8229.164828149313)
(TN,8153.950845787942)
(AR,8019.248809297706)
(WV,7968.480239359218)
(AL,7568.232146906164)


Results of Procedure query:

(870 - SEPTICEMIA OR SEVERE SEPSIS W MV 96+ HOURS,44259.48536716254)
(853 - INFECTIOUS & PARASITIC DISEASES W O.R. PROCEDURE W MCC,40315.961397392806)
(207 - RESPIRATORY SYSTEM DIAGNOSIS W VENTILATOR SUPPORT 96+ HOURS,38588.92100171969)
(329 - MAJOR SMALL & LARGE BOWEL PROCEDURES W MCC,37765.59428459519)
(460 - SPINAL FUSION EXCEPT CERVICAL W/O MCC,27778.67117410379)
(246 - PERC CARDIOVASC PROC W DRUG-ELUTING STENT W MCC OR 4+ VESSELS/STENTS,23326.339008826337)
(252 - OTHER VASCULAR PROCEDURES W MCC,22845.63931499783)
(469 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W MCC,22531.261534334764)
(238 - MAJOR CARDIOVASC PROCEDURES W/O MCC,21948.545111813626)
(480 - HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W MCC,20984.3666356213)
(243 - PERMANENT CARDIAC PACEMAKER IMPLANT W CC,18132.91750509511)
(330 - MAJOR SMALL & LARGE BOWEL PROCEDURES W CC,17926.668275304695)
(253 - OTHER VASCULAR PROCEDURES W CC,17317.71410666043)
(208 - RESPIRATORY SYSTEM DIAGNOSIS W VENTILATOR SUPPORT <96 HOURS,16213.300898849096)
(286 - CIRCULATORY DISORDERS EXCEPT AMI, W CARD CATH W MCC,14937.634048763737)
(473 - CERVICAL SPINAL FUSION W/O CC/MCC,14672.599530880614)
(470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC,14566.929210582386)
(247 - PERC CARDIOVASC PROC W DRUG-ELUTING STENT W/O MCC,14353.51965193315)
(244 - PERMANENT CARDIAC PACEMAKER IMPLANT W/O CC/MCC,13899.71430050872)
(177 - RESPIRATORY INFECTIONS & INFLAMMATIONS W MCC,13829.385503976373)
(314 - OTHER CIRCULATORY SYSTEM DIAGNOSES W MCC,13316.075664112774)
(251 - PERC CARDIOVASC PROC W/O CORONARY ARTERY STENT W/O MCC,13315.209482730828)
(064 - INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W MCC,13263.823033807075)
(871 - SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W MCC,13238.823369119787)
(481 - HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W CC,12632.267628121263)
(249 - PERC CARDIOVASC PROC W NON-DRUG-ELUTING STENT W/O MCC,12593.51061641034)
(377 - G.I. HEMORRHAGE W MCC,12490.130537440906)
(280 - ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE W MCC,12441.672329535071)
(698 - OTHER KIDNEY & URINARY TRACT DIAGNOSES W MCC,11706.836629697333)
(418 - LAPAROSCOPIC CHOLECYSTECTOMY W/O C.D.E. W CC,11576.152705251237)
(682 - RENAL FAILURE W MCC,11540.285124593705)
(254 - OTHER VASCULAR PROCEDURES W/O CC/MCC,11488.639284880264)
(917 - POISONING & TOXIC EFFECTS OF DRUGS W MCC,10763.814406208296)
(482 - HIP & FEMUR PROCEDURES EXCEPT MAJOR JOINT W/O CC/MCC,10468.181897442157)
(602 - CELLULITIS W MCC,10425.559780609292)
(291 - HEART FAILURE & SHOCK W MCC,10266.545960767411)
(193 - SIMPLE PNEUMONIA & PLEURISY W MCC,10053.683174491809)
(178 - RESPIRATORY INFECTIONS & INFLAMMATIONS W CC,9800.37711813556)
(811 - RED BLOOD CELL DISORDERS W MCC,9256.681136856416)
(189 - PULMONARY EDEMA & RESPIRATORY FAILURE,9056.326566739846)
(372 - MAJOR GASTROINTESTINAL DISORDERS & PERITONEAL INFECTIONS W CC,8747.23469893679)
(308 - CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W MCC,8690.294294901098)
(391 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W MCC,8481.852530043292)
(689 - KIDNEY & URINARY TRACT INFECTIONS W MCC,8193.427832181336)
(190 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W MCC,8162.984632549012)
(640 - MISC DISORDERS OF NUTRITION,METABOLISM,FLUIDS/ELECTROLYTES W MCC,8129.88156838613)
(419 - LAPAROSCOPIC CHOLECYSTECTOMY W/O C.D.E. W/O CC/MCC,8068.0902227145525)
(281 - ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE W CC,7994.259066516356)
(065 - INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W CC,7922.671140533756)
(872 - SEPTICEMIA OR SEVERE SEPSIS W/O MV 96+ HOURS W/O MCC,7886.192144617016)
(287 - CIRCULATORY DISORDERS EXCEPT AMI, W CARD CATH W/O MCC,7736.450409218117)
(699 - OTHER KIDNEY & URINARY TRACT DIAGNOSES W CC,7288.396911090354)
(176 - PULMONARY EMBOLISM W/O MCC,7279.954979489389)
(439 - DISORDERS OF PANCREAS EXCEPT MALIGNANCY W CC,7266.568759714496)
(394 - OTHER DIGESTIVE SYSTEM DIAGNOSES W CC,7110.467088263552)
(491 - BACK & NECK PROC EXC SPINAL FUSION W/O CC/MCC,7083.423903245192)
(378 - G.I. HEMORRHAGE W CC,7027.50604843628)
(315 - OTHER CIRCULATORY SYSTEM DIAGNOSES W CC,7020.10835864741)
(683 - RENAL FAILURE W CC,6995.780526144463)
(885 - PSYCHOSES,6968.721874044148)
(194 - SIMPLE PNEUMONIA & PLEURISY W CC,6963.253593543252)
(039 - EXTRACRANIAL PROCEDURES W/O CC/MCC,6960.5339955072695)
(292 - HEART FAILURE & SHOCK W CC,6957.831656730179)
(300 - PERIPHERAL VASCULAR DISORDERS W CC,6761.615005142502)
(057 - DEGENERATIVE NERVOUS SYSTEM DISORDERS W/O MCC,6706.276437522767)
(191 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W CC,6627.311334049001)
(389 - G.I. OBSTRUCTION W CC,6447.112063154335)
(074 - CRANIAL & PERIPHERAL NERVE DISORDERS W/O MCC,6386.79317573337)
(202 - BRONCHITIS & ASTHMA W CC/MCC,6011.3220973373145)
(638 - DIABETES W CC,5889.5704597892345)
(603 - CELLULITIS W/O MCC,5798.941041213234)
(309 - CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W CC,5791.4905862763835)
(552 - MEDICAL BACK PROBLEMS W/O MCC,5725.789675766067)
(066 - INTRACRANIAL HEMORRHAGE OR CEREBRAL INFARCTION W/O CC/MCC,5713.985212459121)
(812 - RED BLOOD CELL DISORDERS W/O MCC,5562.148373651073)
(282 - ACUTE MYOCARDIAL INFARCTION, DISCHARGED ALIVE W/O CC/MCC,5523.34847964777)
(101 - SEIZURES W/O MCC,5493.361878322642)
(690 - KIDNEY & URINARY TRACT INFECTIONS W/O MCC,5353.763303744589)
(563 - FX, SPRN, STRN & DISL EXCEPT FEMUR, HIP, PELVIS & THIGH W/O MCC,5078.114058083635)
(069 - TRANSIENT ISCHEMIA,5068.644288727024)
(392 - ESOPHAGITIS, GASTROENT & MISC DIGEST DISORDERS W/O MCC,5041.766131902145)
(312 - SYNCOPE & COLLAPSE,5003.199234328904)
(192 - CHRONIC OBSTRUCTIVE PULMONARY DISEASE W/O CC/MCC,4983.952607012384)
(379 - G.I. HEMORRHAGE W/O CC/MCC,4983.869090454521)
(897 - ALCOHOL/DRUG ABUSE OR DEPENDENCE W/O REHABILITATION THERAPY W/O MCC,4949.9073076732375)
(195 - SIMPLE PNEUMONIA & PLEURISY W/O CC/MCC,4862.178316578362)
(948 - SIGNS & SYMPTOMS W/O MCC,4824.766433537106)
(536 - FRACTURES OF HIP & PELVIS W/O MCC,4791.288806601289)
(641 - MISC DISORDERS OF NUTRITION,METABOLISM,FLUIDS/ELECTROLYTES W/O MCC,4781.625173231206)
(293 - HEART FAILURE & SHOCK W/O CC/MCC,4693.19726844126)
(684 - RENAL FAILURE W/O CC/MCC,4618.035460941375)
(301 - PERIPHERAL VASCULAR DISORDERS W/O CC/MCC,4599.646495510262)
(149 - DYSEQUILIBRIUM,4589.104335522362)
(918 - POISONING & TOXIC EFFECTS OF DRUGS W/O MCC,4485.378731359104)
(390 - G.I. OBSTRUCTION W/O CC/MCC,4480.417474866079)
(305 - HYPERTENSION W/O MCC,4403.186982958163)
(203 - BRONCHITIS & ASTHMA W/O CC/MCC,4389.9101283950295)
(303 - ATHEROSCLEROSIS W/O MCC,4156.294019199735)
(310 - CARDIAC ARRHYTHMIA & CONDUCTION DISORDERS W/O CC/MCC,3967.388113592547)
(313 - CHEST PAIN,3912.2837085946258)
