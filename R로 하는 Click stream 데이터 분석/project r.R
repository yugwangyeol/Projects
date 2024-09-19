
#패키지 
install.packages("data.table")
library("data.table")
install.packages("dplyr")
library(dplyr)
if (!require(reshape2)) {install.packages(('reshape2'))} 
library(reshape2)
if (!require(tidyr)) {install.packages(('tidyr'))} 
library(tidyr)

if(!require(caret)) install.packages("caret");
library(caret)
if(!require(xgboost)) install.packages("xgboost");
library(xgboost)
if(!require(e1071)) install.packages("e1071");
library(e1071)
if(!require(tictoc)) install.packages("tictoc");
library('tictoc')

if(!require(caret)) install.packages("caret"); 
library(caret)
if(!require(e1071)) install.packages("e1071");
library(e1071)
if(!require(dplyr)) install.packages("dplyr");
library(dplyr)
if(!require(randomForest)) install.packages("randomForest");
library(randomForest)

install.packages('readxl');
library('readxl')
library(lubridate)


# install.packages('devtools')
library(devtools)
devtools::install_github("bmschmidt/wordVectors")
library(wordVectors)


library(dplyr)
# Install & load data.table package
library(data.table)
library(randomForest)
library(caret)

library(plyr)

#data

train_cs<-fread('train_clickstreams.tab')
train_skw<-fread('train_searchkeywords.tab')
test_cs<-fread('test_clickstreams.tab')
test_skw<-fread('test_searchkeywords.tab')
train_pf<-read.csv('train_profiles.csv')
sample_sub<-read.csv('sample_submission.csv')
bact_df<-read.csv('bact_df.csv')
bact_tdf<-read.csv('bact_tdf.csv')
hf <- read.csv('hf.csv')
thf <- read.csv('thf.csv')
discussion_tr<-read.csv('discussion_tr.csv')
discussion_te<-read.csv('discussion_te.csv')
df_tr_2<-read.csv('df_tr_2.csv')
df_te_2<-read.csv('df_te_2.csv')

df_tr_3<-read.csv('df_tr_3.csv')
df_te_3<-read.csv('df_te_3.csv')



df_tr<-df_tr_2
df_te<-df_te_2

train_pf$CUS_ID = NULL
train_cs<- cbind(train_cs,train_pf)

train_pf<-train_pf %>% group_by(CUS_ID)
train_skw %>% group_by(CUS_ID)

cus_id_1<-df_tr_2[2]

#train_df
VDAYS_tr <- train_cs %>% group_by(CUS_ID) %>% summarise( VDAYS = length(unique(TIME_ID/(10^2))))
DWELLTIME_tr <- train_cs %>% group_by(CUS_ID) %>% summarise(DWELLTIME= sum(ST_TIME))
PAGEVIEWS_tr <- train_cs %>% group_by(CUS_ID) %>% summarise(PAGEVIEWS= sum(SITE_CNT))
VSITES_tr <- train_cs %>% group_by(CUS_ID) %>% summarise(VSITES= length(unique(SITE_NM))) 
COVERAGE_tr <- train_cs %>% group_by(CUS_ID) %>% summarise(COVERAGE= length(unique(BACT_NM)))
COVERAGE_tr$COVERAGE<- round(COVERAGE_tr$COVERAGE/22,2)
DAYTIME_tr <- round(DWELLTIME_tr/VDAYS_tr)
names(DAYTIME_tr)[2] <- c('DAYTIME')

df_tr<-data.frame(DWELLTIME_tr,PAGEVIEWS_tr,VSITES_tr,COVERAGE_tr,VDAYS_tr,DAYTIME_tr,bact_df,hf,train_pf)
df_tr$CUS_ID.1 = NULL
df_tr$CUS_ID.2 = NULL
df_tr$CUS_ID.3 = NULL
df_tr$CUS_ID.4 = NULL
df_tr$CUS_ID.5 = NULL
df_tr$CUS_ID.6 = NULL

df_tr <- data.frame(df_tr,hf)
names(df_tr)[37] <-c('DAYTIME')
df_tr<-df_tr[,-6:-7]

#test_df
VDAYS_te <- test_cs %>% group_by(CUS_ID) %>% summarise( VDAYS= length(unique((TIME_ID%%(10^2)))))
DWELLTIME_te <- test_cs %>% group_by(CUS_ID) %>% summarise(DWELLTIME = sum(ST_TIME))
PAGEVIEWS_te <- test_cs %>% group_by(CUS_ID) %>% summarise(PAGEVIEWS = sum(SITE_CNT))
VSITES_te <- test_cs %>% group_by(CUS_ID) %>% summarise(VSITES= length(unique(SITE_NM))) 
COVERAGE_te <- test_cs %>% group_by(CUS_ID) %>% summarise(COVERAGE = length(unique(BACT_NM)))
COVERAGE_te$COVERAGE<- round(COVERAGE_tr$COVERAGE/22,2)
DAYTIME_te <- round(DWELLTIME_te/VDAYS_te)
names(DAYTIME_te)[2] <- c('DAYTIME')


df_te<-data.frame(DWELLTIME_te,PAGEVIEWS_te,VSITES_te,COVERAGE_te,VDAYS_te,DAYTIME_te,bact_tdf,thf)
df_te$CUS_ID.1 = NULL
df_te$CUS_ID.2 = NULL
df_te$CUS_ID.3 = NULL
df_te$CUS_ID.4 = NULL
df_te$CUS_ID.5 = NULL
df_te$X= NULL
df_te$X.1= NULL

df_te<-data.frame(df_te,thf)
df_te <- df_te[,-6:-8]
names(df_te)[35] <-c('DAYTIME')

####DF_tr

a<-wday(ymd_h(train_cs$TIME_ID),label=TRUE,abbr = TRUE)
a<-data.frame(a)
TDF_tr <- data.frame()
train_cs <- cbind(train_cs,a)

for (i in 1:2500){
  c<-train_cs %>% filter(CUS_ID==i) %>% filter(a=='일') %>% summarise(DF_SU=sum(ST_TIME))
  TDF_tr <- rbind(TDF_tr,c)
}

df_tr <- cbind(df_tr,TDF_tr)
df_tr$DF_M=NULL
df_tr$X.1=NULL

###
df_tr_1
###

df_tr<-df_tr_1
df_tr_1<-df_tr


###DF_te
b<-wday(ymd_h(test_cs$TIME_ID),label=TRUE,abbr=TRUE)
b<-data.frame(b)
TDF_te <- data.frame()
test_cs <- cbind(test_cs,b)

for (i in 2501:5000){
  c<-test_cs %>% filter(CUS_ID==i) %>% filter(b=='일') %>% summarise(DF_SU=sum(ST_TIME))
  TDF_te <- rbind(TDF_te,c)
}

df_te <- cbind(df_te,TDF_te)

df_te$X=NULL
test_cs$b=NULL

###HF_tr
HF_tr<- data.frame()

for (i in 2501:5000){
  c<-test_c %>% filter(CUS_ID==i) %>% filter( THF==18 | THF==19 | THF==20 | THF==21 | THF==22 | THF==23 ) %>% summarise(THF_tr_3=sum(ST_TIME))
  HF_tr <- rbind(HF_tr,c)
}

tdf<-cbind(tdf,HF_tr)

###ct_tr
for (i in 2501:5000) {
  c<-test_c %>% filter(CUS_ID==i) %>% filter(BACT_NM==bact[13]) %>% summarise(trip_cnt=sum(SITE_CNT))
  trip<-rbind(trip,c)
}


###
df_tr_1
###

df_tr<-df_tr_1
df_tr_1<-df_tr
df_tr<-df_tr_2
df_te<-df_te_2

#### 비율 만들기_tr

ads<-df_tr[,c("HF_tr","HF_tr_1","HF_tr_2","HF_tr_3")]
ads<-rowSums(ads)
ads<-data.frame(ads)

df_tr["HF_tr"]<-df_tr["HF_tr"]/ads
df_tr["HF_tr_1"]<-df_tr["HF_tr_1"]/ads
df_tr["HF_tr_2"]<-df_tr["HF_tr_2"]/ads
df_tr["HF_tr_3"]<-df_tr["HF_tr_3"]/ads

ads_1<-df_tr[,c("DF_M","DF_T","DF_W","DF_TH","DF_F","DF_S","DF_SU")]
ads_1<-rowSums(ads_1)
ads_1<-data.frame(ads_1)

df_tr["DF_M"]<-df_tr["DF_M"]/ads_1
df_tr["DF_T"]<-df_tr["DF_T"]/ads_1
df_tr["DF_W"]<-df_tr["DF_W"]/ads_1
df_tr["DF_TH"]<-df_tr["DF_TH"]/ads_1
df_tr["DF_F"]<-df_tr["DF_F"]/ads_1
df_tr["DF_S"]<-df_tr["DF_S"]/ads_1
df_tr["DF_SU"]<-df_tr["DF_SU"]/ads_1

ads_2<-df_tr[,c('int_cnt','com_cnt','news_cnt','game_cnt','edu_cnt','ent_cnt','shop_cnt','spo_cnt','hob_cnt','it_cnt','fin_cnt','edu_off_cnt','trip_cnt','heal_cnt','make_cnt','buis_cnt','pol_cnt','cul_cnt','sell_cnt','ser_cnt','art_cnt','stu_cnt')]
ads_2<-rowSums(ads_2)
ads_2<-data.frame(ads_2)

df_tr["int_cnt"]<-df_tr["int_cnt"]/ads_2
df_tr["com_cnt"]<-df_tr["com_cnt"]/ads_2
df_tr["news_cnt"]<-df_tr["news_cnt"]/ads_2
df_tr["game_cnt"]<-df_tr["game_cnt"]/ads_2
df_tr["edu_cnt"]<-df_tr["edu_cnt"]/ads_2
df_tr["ent_cnt"]<-df_tr["ent_cnt"]/ads_2
df_tr["shop_cnt"]<-df_tr["shop_cnt"]/ads_2
df_tr["spo_cnt"]<-df_tr["spo_cnt"]/ads_2
df_tr["hob_cnt"]<-df_tr["hob_cnt"]/ads_2
df_tr["it_cnt"]<-df_tr["it_cnt"]/ads_2
df_tr["fin_cnt"]<-df_tr["fin_cnt"]/ads_2
df_tr["edu_off_cnt"]<-df_tr["edu_off_cnt"]/ads_2
df_tr["trip_cnt"]<-df_tr["trip_cnt"]/ads_2
df_tr["heal_cnt"]<-df_tr["heal_cnt"]/ads_2
df_tr["make_cnt"]<-df_tr["make_cnt"]/ads_2
df_tr["buis_cnt"]<-df_tr["buis_cnt"]/ads_2
df_tr["pol_cnt"]<-df_tr["pol_cnt"]/ads_2
df_tr["cul_cnt"]<-df_tr["cul_cnt"]/ads_2
df_tr["sell_cnt"]<-df_tr["sell_cnt"]/ads_2
df_tr["ser_cnt"]<-df_tr["ser_cnt"]/ads_2
df_tr["art_cnt"]<-df_tr["art_cnt"]/ads_2
df_tr["stu_cnt"]<-df_tr["stu_cnt"]/ads_2

df_te[is.na(df_te)]<-round(mean(df_te$DWELLTIME,na.rm=TRUE))
sum(is.na(df_tr))
df_tr

ncol(df_tr)
df_tr$DAYCOV[is.na(df_tr$DAYCOV)] <- round(mean(df_tr$DAYCOV,na.rm=TRUE),2)


df_te$DWELLTIME[is.na(df_te$DWELLTIME)] <- round(mean(df_te$DWELLTIME,na.rm=TRUE),2)
sum(is.na(df_te))

#### 비율 만들기_te

ads_te<-df_te[,c("HF_tr","HF_tr_1","HF_tr_2","HF_tr_3")]
ads_te<-rowSums(ads_te)
ads_te<-data.frame(ads_te)

df_te["HF_tr"]<-df_te["HF_tr"]/ads_te
df_te["HF_tr_1"]<-df_te["HF_tr_1"]/ads_te
df_te["HF_tr_2"]<-df_te["HF_tr_2"]/ads_te
df_te["HF_tr_3"]<-df_te["HF_tr_3"]/ads_te

ads_te_1<-df_te[,c("DF_M","DF_T","DF_W","DF_TH","DF_F","DF_S","DF_SU")]
ads_te_1<-rowSums(ads_te_1)
ads_te_1<-data.frame(ads_te_1)

df_te["DF_M"]<-df_te["DF_M"]/ads_te_1
df_te["DF_T"]<-df_te["DF_T"]/ads_te_1
df_te["DF_W"]<-df_te["DF_W"]/ads_te_1
df_te["DF_TH"]<-df_te["DF_TH"]/ads_te_1
df_te["DF_F"]<-df_te["DF_F"]/ads_te_1
df_te["DF_S"]<-df_te["DF_S"]/ads_te_1
df_te["DF_SU"]<-df_te["DF_SU"]/ads_te_1

ads_te_2<-df_te[,c('int_cnt','com_cnt','news_cnt','game_cnt','edu_cnt','ent_cnt','shop_cnt','spo_cnt','hob_cnt','it_cnt','fin_cnt','edu_off_cnt','trip_cnt','heal_cnt','make_cnt','buis_cnt','pol_cnt','cul_cnt','sell_cnt','ser_cnt','art_cnt','stu_cnt')]
ads_te_2<-rowSums(ads_te_2)
ads_te_2<-data.frame(ads_te_2)

df_te["int_cnt"]<-df_te["int_cnt"]/ads_te_2
df_te["com_cnt"]<-df_te["com_cnt"]/ads_te_2
df_te["news_cnt"]<-df_te["news_cnt"]/ads_te_2
df_te["game_cnt"]<-df_te["game_cnt"]/ads_te_2
df_te["edu_cnt"]<-df_te["edu_cnt"]/ads_te_2
df_te["ent_cnt"]<-df_te["ent_cnt"]/ads_te_2
df_te["shop_cnt"]<-df_te["shop_cnt"]/ads_te_2
df_te["spo_cnt"]<-df_te["spo_cnt"]/ads_te_2
df_te["hob_cnt"]<-df_te["hob_cnt"]/ads_te_2
df_te["it_cnt"]<-df_te["it_cnt"]/ads_te_2
df_te["fin_cnt"]<-df_te["fin_cnt"]/ads_te_2
df_te["edu_off_cnt"]<-df_te["edu_off_cnt"]/ads_te_2
df_te["trip_cnt"]<-df_te["trip_cnt"]/ads_te_2
df_te["heal_cnt"]<-df_te["heal_cnt"]/ads_te_2
df_te["make_cnt"]<-df_te["make_cnt"]/ads_te_2
df_te["buis_cnt"]<-df_te["buis_cnt"]/ads_te_2
df_te["pol_cnt"]<-df_te["pol_cnt"]/ads_te_2
df_te["cul_cnt"]<-df_te["cul_cnt"]/ads_te_2
df_te["sell_cnt"]<-df_te["sell_cnt"]/ads_te_2
df_te["ser_cnt"]<-df_te["ser_cnt"]/ads_te_2
df_te["art_cnt"]<-df_te["art_cnt"]/ads_te_2
df_te["stu_cnt"]<-df_te["stu_cnt"]/ads_te_2

df_te$X=NULL

#train_gbm
control = trainControl(method='repeatedcv', search='grid', number=5,repeats = 3,verbose = TRUE) # repeatcv : k - fold를 repeats만큼 반복
tic('gbm running time :')
gbm.model <- train(
  GROUP ~ .,
  data = df_tr, 
  tuneLength = 3,
  trControl = control,
  method="gbm",na.action=na.exclude)
toc()

gbm.model$bestTune

pred.gbm <- predict(gbm.model,df_te[-31])
confusionMatrix(pred.gbm, df_te[,31])

gbm.grid = expand.grid(
  shrinkage = c(0.1,0.3, 0.5),  # 학습률
  interaction.depth = c(3,6,9),  # 트리의 최대 깊이
  n.minobsinnode = c(5,10,15),   # 나무 생성을 위한 최소 data 개수
  n.trees = c(500,100,1200)  # 최대 나무 개수
)

control = trainControl(method='repeatedcv', search='grid', number=5,repeats = 3,verbose = TRUE) #number은 fold개수, repeats는 반복횟수.
tic('gbm running time :')
gbm.model <- train(
  GROUP ~ .,
  data = df_tr,
  tuneGrid = gbm.grid,
  trControl = control,
  method = 'gbm'
)
toc()

pred.gbm <- predict(gbm.model,df_te,type = 'prob')
write.csv(pred.gbm,'prediction_gbm.csv',row.names = TRUE)
pred.gbm_1 <- read.csv('prediction_gbm.csv')
pred.gbm_1[,1] <- c(2501:5000)
names(pred.gbm_1)[1] <- c('CUS_ID')
write.csv(pred.gbm_1,'prediction_gbm.csv',row.names = TRUE)


#### XGB
### eXtreme Gradient Boosting
## parameter tuning
control = trainControl(method='repeatedcv', search='grid', number=5,repeats = 3,verbose = TRUE)
tic('xgb running time :')
xgb.model <- train(
  GROUP ~ .,
  data = df_tr,
  tuneLength = 4, #실험해볼 parameter 개수.
  trControl = control,
  method="xgbTree")
toc()

xgb.model

pred.xgb <- predict(xgb.model,test[-31])
confusionMatrix(pred.xgb, test[,31])

pred.xgb <- predict(xgb.model,df_te,type = 'prob')
pred.xgb <- predict(xgb.model,df_te,type='prob')
write.csv(pred.xgb,'prediction_3.csv',row.names = TRUE)
pred.xgb_1 <- read.csv('prediction_3.csv')
pred.xgb_1[,1] <- c(2501:5000)
names(pred.xgb_1)[1] <- c('CUS_ID')
write.csv(pred.xgb_1,'prediction_3.csv',row.names = TRUE)
mvm

## XGB Parameter tuning
xgb.grid = expand.grid(
  nrounds = 300,
  eta = 0.05,
  gamma = 5,
  max_depth = 4,
  min_child_weight = 6,
  colsample_bytree = 1,
  subsample = 1
)

control = trainControl(method='repeatedcv', search='grid', number=5,repeats = 3,verbose = TRUE)
xgb.model <- train(
  GROUP ~ .,
  data = df_tr,
  tuneGrid = xgb.grid, ##설정한 parameter 조합.
  trControl = control,
  method = 'xgbTree'
)
xgb.model

pred.xgb <- predict(xgb.model,df_te,type='prob')
write.csv(pred.xgb,'prediction_xgb.csv',row.names = TRUE)
pred.xgb_1 <- read.csv('prediction_xgb.csv')
pred.xgb_1[,1] <- c(2501:5000)
names(pred.xgb_1)[1] <- c('CUS_ID')
write.csv(pred.xgb_1,'prediction_xgb.csv',row.names = TRUE)


pred.xgb <- predict(xgb.model,test[-31])
confusionMatrix(pred.xgb, test[,31])



###randomforest_tr

df_tr[is.na(df_tr)] <- round(mean(df_tr$DWELLTIME_1,na.rm=TRUE))
df_tr[is.na(df_tr)] <- round(mean(df_tr$PAGEVIEWS_1,na.rm=TRUE))
df_tr[is.na(df_tr)] <- round(mean(df_tr$VSITES_1,na.rm=TRUE))
df_tr[is.na(df_tr)] <- round(mean(df_tr$COVERAGE_1,na.rm=TRUE))
df_tr[is.na(df_tr)] <- round(mean(df_tr$YDAYS_1,na.rm=TRUE))
sum(is.na(df_tr$DWELLTIME_1))

control = trainControl(method='repeatedcv', search='grid', number=5,repeats = 10,verbose = TRUE)
rf.model <- train(
  GROUP ~ .,
  data = df_tr,
  tuneGrid = rf.grid,
  trControl = control,
  method="rf")
rf.model
rf.grid = expand.grid(
  mtry = c(1:10)          
)

pred.rf <- predict(rf.model,df_te,type = 'prob')
write.csv(pred.rf,'prediction_rf.csv',row.names = TRUE)
pred.rf_1 <- read.csv('prediction_rf.csv')
pred.rf_1[,1] <- c(2501:5000)
names(pred.rf_1)[1] <- c('CUS_ID')
write.csv(pred.rf_1,'prediction_rf.csv',row.names = TRUE)



####################################################tr_mact

mact_nm_un <- train_cs$MACT_NM %>% unique()
df_colname <- c('검색','블로그/SNS','일간지','인터넷신문','온라인게임','전문뉴스','웹서비스','커뮤니케이션','학생/교과교육','게임포털','포털','영화','만화/애니메이션',
                '커뮤니티포털','모바일컨텐츠','종합쇼핑','멀티미디어/동영상','가격비교','분야별커뮤니티','골프','생활','솔루션','어린이커뮤니티','성인/전문교육',
                '다운로드','학술정보','부동산','학원','소프트웨어','유며/재미','여행정보','쇼핑정보','전문병원','취미/스포츠 쇼핑물','건강/의학정보','운세','산업용품 쇼핑물',
                '보험','자동차','숙박','의류 쇼핑물','인터넷비즈니스','음악','방송','화장품/미용 쇼핑물','잡지/웹진','교육자료','공공서비스','지불/결제','도메인/호스팅',
                '명품','종교','무역','금융','운송','데스크탑','어학교육','게임방송','취업','쇼핑기타','아이템거래','증권/주식','쇼핑기타','패션잡화 쇼핑물','게임전문지/웹진',
                'B2B','정부/기관','도서/음반/악기 쇼핑물','생활용품 쇼핑물','하드웨어','통신사','법/법률','가전 쇼핑물','지방자치','무선/이동통신','종합유통','SaaS/ASP',
                '인터넷방송','여성커뮤니티','음/식료품','컨설팅','사회복지','야구','여행사','연예인/스타','예술','가구/인테리어 쇼핑물','식품/건강 쇼핑물','창업/프렌차이즈',
                '은행','사무관리','교통','도박','통신 쇼핑물','게임정보','유아교육','자산관리/운용','가정용품','전기/전자','유아/어린이 쇼핑물','경제','선거','프로그램개발',
                '국내지역정보','학교','정보통신서비스','성인','생활/취미기타','보안','음식/식품','IT/통신','특수교육','웹저작도구/정보','대학/종합벼원','해외지역정보',
                '기록/자료관','컴퓨터/인터넷 쇼핑물','봉제의복','여행지','문학','교육기관/단체','학교커뮤니티','인터넷,컴퓨터 관련단체','시스템구축/운영','의료','화장품/미용',
                '결혼','유통/판매업','제조 기타','스포츠정보','공연','신용','PC게임','기획사','대출','레포츠','다이어트','중소기업/벤처','자연과학','경매','건설/건축',
                '정부투자기관','정치','화학','약학','기계/산업용품','NGO','의학','노동','종이/펄프','의학','레저','게임개발','의류/패션잡화','언론단체/기관','인문/사회과학',
                '겨울스포츠','여행관련기관/단체','교육관련업체','사무기기/용품','가전','농림수산업/가공업','기사검색','섬유/직물','축구','건강관리','금속','네트워크','취미',
                '마라톤','무예/격투기','PC방/게임방','스포츠기타','유리','비디오게임','군대/국방','인권','건설/토목','패션/의류','과외','사회유형','게임기관/단체',
                '사회/문화/종교 기타','종합레저/레포츠','문화','교사/교수','모바일게임','선물/옵션/채권','입찰','길드/동호회','환경','에너지/자원','세금/세무','농구',
                '게임대회/리그','남북통일','공항','여행기타','청소년관련단체','수상스포츠','장애인','외국정부/외교','배구','임신/출산','상담','기업금융','스포츠선수','게임기타')
length(mact_nm_un)

mact_nm_un<-as.vector(mact_nm_un)


y <- data.frame()
tic('MACTtime:')
for (i in 1:207) {
  for (j in 1:2500) {
    x <- train_cs %>% filter(CUS_ID == 4) %>% filter(MACT_NM == mact_nm_un[4]) %>% summarise(a = sum(SITE_CNT))
    y <- rbind(y,x)
  }
  if (i == 1) {
    z <- data.frame(y)
    rm(x,y)
    y <- data.frame()
  } else if (i > 1) {
    z <- cbind(z,y)
    rm(x,y)
    y<-data.frame()
  }
}
toc()

write.csv(z,'z.csv',row.names = TRUE)


rm(w)
z<-read.csv('z.csv')
q_1<-read.csv('q_1.csv')
z
z_1<-t(z)
z_1[,289:290]
z_1<-z_1[-1,]


q=data.frame()
s<-sort(z_1[,2],decreasing = TRUE)
w<-names(s[1:3])

q=data.frame()

for (i in 2:2500){
  s<-sort(z_1[,i],decreasing = TRUE)
  w<-names(s[1:3])
  q<-cbind(q,w)
  rm(s,w)
}

write.csv(q_1,'q_1.csv',row.names = TRUE)

s<-sort(z_1[,1],decreasing = TRUE)
w<-names(s[1:3])
q<-cbind(q,w)
rm(s,w)

colnames(q)<-c(1:2500)
q<-data.frame(w)
q_1<-t(q)
q_1[289]

####################################################te_mact

mact_nm_un_1 <- test_cs$MACT_NM %>% unique()
df_colname <- c('검색','블로그/SNS','일간지','인터넷신문','온라인게임','전문뉴스','웹서비스','커뮤니케이션','학생/교과교육','게임포털','포털','영화','만화/애니메이션',
                '커뮤니티포털','모바일컨텐츠','종합쇼핑','멀티미디어/동영상','가격비교','분야별커뮤니티','골프','생활','솔루션','어린이커뮤니티','성인/전문교육',
                '다운로드','학술정보','부동산','학원','소프트웨어','유며/재미','여행정보','쇼핑정보','전문병원','취미/스포츠 쇼핑물','건강/의학정보','운세','산업용품 쇼핑물',
                '보험','자동차','숙박','의류 쇼핑물','인터넷비즈니스','음악','방송','화장품/미용 쇼핑물','잡지/웹진','교육자료','공공서비스','지불/결제','도메인/호스팅',
                '명품','종교','무역','금융','운송','데스크탑','어학교육','게임방송','취업','쇼핑기타','아이템거래','증권/주식','쇼핑기타','패션잡화 쇼핑물','게임전문지/웹진',
                'B2B','정부/기관','도서/음반/악기 쇼핑물','생활용품 쇼핑물','하드웨어','통신사','법/법률','가전 쇼핑물','지방자치','무선/이동통신','종합유통','SaaS/ASP',
                '인터넷방송','여성커뮤니티','음/식료품','컨설팅','사회복지','야구','여행사','연예인/스타','예술','가구/인테리어 쇼핑물','식품/건강 쇼핑물','창업/프렌차이즈',
                '은행','사무관리','교통','도박','통신 쇼핑물','게임정보','유아교육','자산관리/운용','가정용품','전기/전자','유아/어린이 쇼핑물','경제','선거','프로그램개발',
                '국내지역정보','학교','정보통신서비스','성인','생활/취미기타','보안','음식/식품','IT/통신','특수교육','웹저작도구/정보','대학/종합벼원','해외지역정보',
                '기록/자료관','컴퓨터/인터넷 쇼핑물','봉제의복','여행지','문학','교육기관/단체','학교커뮤니티','인터넷,컴퓨터 관련단체','시스템구축/운영','의료','화장품/미용',
                '결혼','유통/판매업','제조 기타','스포츠정보','공연','신용','PC게임','기획사','대출','레포츠','다이어트','중소기업/벤처','자연과학','경매','건설/건축',
                '정부투자기관','정치','화학','약학','기계/산업용품','NGO','의학','노동','종이/펄프','의학','레저','게임개발','의류/패션잡화','언론단체/기관','인문/사회과학',
                '겨울스포츠','여행관련기관/단체','교육관련업체','사무기기/용품','가전','농림수산업/가공업','기사검색','섬유/직물','축구','건강관리','금속','네트워크','취미',
                '마라톤','무예/격투기','PC방/게임방','스포츠기타','유리','비디오게임','군대/국방','인권','건설/토목','패션/의류','과외','사회유형','게임기관/단체',
                '사회/문화/종교 기타','종합레저/레포츠','문화','교사/교수','모바일게임','선물/옵션/채권','입찰','길드/동호회','환경','에너지/자원','세금/세무','농구',
                '게임대회/리그','남북통일','공항','여행기타','청소년관련단체','수상스포츠','장애인','외국정부/외교','배구','임신/출산','상담','기업금융','스포츠선수','게임기타')
length(mact_nm_un_1)

mact_nm_un<-as.vector(mact_nm_un_1)


y <- data.frame()
tic('MACTtime:')
for (i in 1:207) {
  for (j in 2501:5000) {
    x <- test_cs %>% filter(CUS_ID == j) %>% filter(MACT_NM == mact_nm_un_1[i]) %>% summarise(a = sum(SITE_CNT))
    y <- rbind(y,x)
  }
  if (i == 1) {
    z <- data.frame(y)
    rm(x,y)
    y <- data.frame()
  } else if (i > 1) {
    z <- cbind(z,y)
    rm(x,y)
    y<-data.frame()
  }
}

toc()
rm(z)

write.csv(z,'z.te.csv',row.names = TRUE)


rm(w)
z<-read.csv('z.te.csv')
z
z_1<-t(z)
z_1[,289:290]
z_1<-z_1[-1,]


q=data.frame()
s<-sort(z_1[,2],decreasing = TRUE)
w<-names(s[1:3])

q=data.frame()

for (i in 2:2500){
  s<-sort(z_1[,i],decreasing = TRUE)
  w<-names(s[1:3])
  q<-cbind(q,w)
  rm(s,w)
}

write.csv(q_1,'q_1.csv',row.names = TRUE)

s<-sort(z_1[,1],decreasing = TRUE)
w<-names(s[1:3])
q<-cbind(q,w)
rm(s,w)

colnames(q)<-c(1:2500)
q<-data.frame(w)
q_1<-t(q)
q_1[289]

mact_nm_un_1[1:207]

rm(q)

han<-function(x){
  for (i in 1:207){
    a<-test_cs %>% filter(CUS_ID==x) %>% filter(MACT_NM==mact_nm_un_1[i]) %>% summarise(a = sum(SITE_CNT))
  }
}


z_2<-sapply(test_cs,han)

test_cs[,8]==mact_nm_un_1[]

################################# searchkeyword

###### 단어장 만들기

setkey(train_pf, CUS_ID); setkey(train_cs, CUS_ID) 
md.dt <- merge(train_pf, train_cs)
md.dt %>% str


f <- function(x, t) {
  grp <- md.dt[CUS_ID==x, GROUP][1]
  itemfreq <- table(md.dt[CUS_ID==x,  ACT_NM])
  fitems <- itemfreq[itemfreq >= t]
  act <- names(fitems)
  #  
  sapply(act, function(x) gsub(" ", "_", x))
  set.seed(1)
  #
  as.vector((sapply(1:20, function(x) c(grp, sample(act)))))
}
items <- unlist(sapply(train_pf$CUS_ID, f, 2)) 
write.table(items, "train.txt", eol = " ", quote = F, row.names = F, col.names = F) # 단어장 저장(혹시라도 열어보고 싶다면 주의)

##### Train model
set.seed(12345)
model = train_word2vec("train_cs.txt","vec.bin",
                       vectors=300, # 임베딩차원
                       threads=2, # 사용할 CPU코어 개수 
                       window=7, # window size
                       cbow=1, # 0 == CBOW, 1 == Skip gram 
                       iter=5, # 학습 반복횟수
                       negative_samples=10, # negative sample 비 1 : negative_samples
                       force = T # 모델 덮어쓸지 말지
)

## [reload the model]
model <- read.binary.vectors("vec.bin") # 학습된 모델 불러오기 이미 학습을 했다면 위의 코드는 실행하지 않아도 된다.
train <- md.dt %>% select(CUS_ID,ACT_NM,GROUP)

##### Explore the model
for (word in unique(md.dt[,GROUP])) print(closest_to(model, word, n=10))

model[[unique(md.dt[,GROUP]), average=F]] %>% plot(method="pca") # group을 2차원 공간에 뿌림

items.1 <- c(unique(md.dt[,GROUP]), unique(md.dt[CUS_ID==1, ACT_NM])) 

model[[items.1[1:100], average=F]] %>% plot(method="pca") #group + 텍스트를 2차원 공간에 뿌림

# 코사인 유사도 계산 
cosineSimilarity(model[[unique(md.dt[CUS_ID==1, ACT_NM]), average=T]],
                 model[[c("M20-","M30","M40+","F20-","F30","F40+"), average=F]])
cosineSimilarity(model[[unique(md.dt[CUS_ID==2, ACT_NM]), average=T]], 
                 model[[c("M20-","M30","M40+","F20-","F30","F40+"), average=F]])

##### Predict & Evaluate
# calculate the cosine similarity between items and target classes
g <- function(x, dt, min) {
  itemfreq <- table(dt[CUS_ID==x, ACT_NM])
  fitems <- itemfreq[itemfreq >= min]
  sim <- cosineSimilarity(model[[names(fitems), average=T]],
                          model[[c("M20-","M30","M40+","F20-","F30","F40+"), average=F]])
  return(names(which.max(sim[1,])))
}

# accuracy for train data
# 조금 오래걸림(버틸만함)
ctab <- table(sapply(cs.dt$CUS_ID, g, md.dt, 1), cs.dt$GROUP); ctab

sum(diag(ctab)) / nrow(cs.dt) 

nrow(cs.dt[GROUP=="M20-",]) / nrow(cs.dt)
nrow(cs.dt[GROUP=="M30",]) / nrow(cs.dt)
nrow(cs.dt[GROUP=="M40+",]) / nrow(cs.dt)
nrow(cs.dt[GROUP=="F20-",]) / nrow(cs.dt)
nrow(cs.dt[GROUP=="F30",]) / nrow(cs.dt)
nrow(cs.dt[GROUP=="F40+",]) / nrow(cs.dt)


#exel 
write.csv(df_tr,'df_tr_2.csv',row.names = TRUE)
write.csv(df_te,'df_te_2.csv',row.names = TRUE)
aa<-read.csv('prediction_1.csv')
aa[,1]<-c(2501:5000)
names(aa)[1]<-c('CUS_ID')

test_cs <- cbind(test_cs,b)
df_te <- cbind(df_te,bact_tdf)



###############################randomforest_tr

control = trainControl(method='repeatedcv', search='random', number=5,repeats = 10,verbose = TRUE)
rf.model <- train(
  GROUP ~ .,
  data = df_tr_3,
  tuneLength = 3,
  trControl = control,
  method="rf")
rf.model

accuracy

rf.grid = expand.grid(
  mtry = c(1,3,5)          # 노드를 나눌 기준을 정할 때 고려할 변수의 수
)

pred.rf <- predict(rf.model,df_te_3,type = 'prob')
write.csv(pred.rf,'rm_rm.csv',row.names = TRUE)
pred.rf_1 <- read.csv('rm_rm.csv')
pred.rf_1[,1] <- c(2501:5000)
names(pred.rf_1)[1] <- c('CUS_ID')
write.csv(pred.rf_1,'rm_rm.csv',row.names = TRUE)
hanbohye<- read.csv('rm_rm.csv')
