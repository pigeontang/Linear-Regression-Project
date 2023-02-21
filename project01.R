library(ggplot2)
library(dplyr)
library(caret)
library(tidyverse)
library(data.table)
library(lubridate)
library(corrplot)
library(gpairs)
options(scipen = 999)

setwd("~/Desktop/Spring 21/DataAnalysis/groupProj")
democracy = read.csv("democracyIndex.csv")
brthrt = read.csv("BirthRate.csv")
sunhr = read.csv("sunlightHours.csv")
scdrte = read.csv("suiciderate.csv")
hmncptl = read.csv("humancapitalindex.csv")
happy = read.csv("happiness_6_19.csv")
gni_un = read.csv("gini_15-18_un.csv")
unemployment_wb = read.csv("unemployment_wb.csv")
work_week = read.csv("annual-working-hours-per-worker.csv")
oecd = read.csv("oecdCountries.csv")
svngrt = read.csv("savingsRate_oecd.csv")
country = read.csv("countryabbv.csv")
marriage = read.csv("maritalStatus.csv")
dprsn = read.csv("depression.csv")
psychamt = read.csv("mentalHealthWorkers.csv")
alc = read.csv("alcohol.csv")

##### Clean Data ####
# See dimensions that are not NA and length
brthrt_info = data.frame(sapply(brthrt, function(x) sum(is.na(x))))
democracy_info = data.frame(sapply(democracy, function(x) sum(is.na(x))))
wrkhr_info = data.frame(sapply(wrkhr, function(x) sum(is.na(x))))
gni_info = data.frame(sapply(gni, function(x) sum(is.na(x))))
happy_info = data.frame(sapply(happy, function(x) sum(is.na(x))))



# Re format variables 
oecd = as.character(oecd$country)

sun_avg = sunhr %>%
  select(Country, Year) %>%
  group_by(Country) %>%
  summarise_at(vars(Year), list(name = "mean")) %>%
  rename_with(~ c("Country", "sunAvg"))

brthrt = brthrt %>%
  rename_with(~ gsub("X", "", names(brthrt))) %>%
  select(Country.Name, `2018`) %>%
  rename_with(~ c("Country", "birthrte"))

srs = unique(scdrte$Series.Name)
scdrte = scdrte %>%
  filter(Series.Name == srs[1]) %>%
  select(Country.Name, X2018..YR2018.) %>%
  rename_with(~ c("Country", "suicideRte")) %>%
  mutate(suicideRte = as.numeric(suicideRte))

srs.hmn = unique(hmncptl$Series.Name)
hmncptl = hmncptl %>%
  filter(Series.Name == srs.hmn[1]) %>%
  select(Country.Name, X2018..YR2018.) %>%
  rename_with(~ c("Country", "humanCap")) %>%
  mutate(humanCap = as.numeric(humanCap))

srs.unemp = unique(unmplymnt$Series.Name)
unmplymnt = unmplymnt %>%
  filter(Series.Name == srs.unemp[3]) %>%
  select(Country.Name, X2018..YR2018.) %>%
  rename_with(~ c("Country", "unemployment")) %>%
  mutate(unemployment = as.numeric(unemployment))

democracy = democracy %>%
  filter(time == 2018) %>%
  select(name,Democracy.index..EIU.) %>%
  rename_with(~ c("Country", "demoIndex"))

years = c(2016,2017,2018)
happy = happy %>%
  filter(year %in% years) %>%
  select(Country.name, Life.Ladder) %>%
  group_by(Country.name) %>%
  summarise_at(vars(Life.Ladder), list(name = "mean")) %>%
  rename_with(~ c("Country", "happyniessIndex"))

gni_un = gni_un %>%
  select(Country.or.Area, Value) %>%
  group_by(Country.or.Area) %>%
  summarise_at(vars(Value), list(name = "mean")) %>%
  rename_with(~ c("Country", "gni_avg"))

unemployment_wb = unemployment_wb %>%
  rename_with(~ gsub("X", "", names(unemployment_wb))) %>%
  select(Country.Name, `2018`) %>%
  rename_with(~ c("Country", "unemployment_wb"))

work_week = work_week %>%
  mutate(Entity = gsub("Czechia", "Czech Republic", work_week$Entity)) %>%
  filter(Year == 2017) %>%
  select(Entity, Average.annual.working.hours.per.worker) %>%
  rename_with(~ c("Country", "avg_workHrsYr"))

country=country %>%
  mutate(alpha3 = trimws(alpha3,which = "both"),
         Country = trimws(Country,which = "both"))

svngrt = svngrt %>%
  mutate(left_join(svngrt, country, by=c("LOCATION"="alpha3"))) %>%
  select(Country, TIME, Value) %>%
  filter(TIME >= 2019) %>%
  group_by(Country) %>%
  summarise_at(vars(Value), list(name = "mean")) %>%
  rename_with(~ c("Country", "savingsRate")) %>%
  drop_na()

indicator = unique(marriage$Indicator)
marriage = marriage %>%
  filter(Indicator %in% indicator[c(3,6)] & Year >= 2016) %>%
  group_by(Country, Indicator) %>%
  summarise_at(vars(Value), list(name = "mean")) %>%
  mutate(marrRt = name[Indicator == indicator[3]],
         divRt = c(name[Indicator == indicator[6]])) %>%
  select(Country, marrRt,divRt) %>%
  distinct()
  
dprsn=dprsn %>%
  select(country, prevalence) %>%
  rename_all(~ c("Country","depressionRate"))

psychamt = psychamt[,c(1:6)]
colnames(psychamt)=psychamt[1,]
psychamt = psychamt[-1,]
psychamt[is.na(psychamt)]=0
psychamt=psychamt %>%
  gather("Year","psychAmt",-Country) %>%
  group_by(Country) %>%
  summarise_at(vars(psychAmt), list(name = "max")) %>%
  rename(psychAmt=name)

alc=alc %>%
  filter(Dim1=="Both sexes") %>%
  select(Location,Period,FactValueNumeric)%>%
  group_by(Location) %>%
  summarise_at(vars(FactValueNumeric), list(name = "mean")) %>%
  rename_all(~c("Country","alcohol"))


# Merge into 1
data_list = lst(democracy, sun_avg, hmncptl, scdrte, brthrt, happy, gni_un, 
                unemployment_wb, work_week,svngrt,marriage, dprsn,psychamt,alc)
i = 3
data = merge(democracy, sun_avg, by = "Country")
while(i <= length(data_list)) {
  data = left_join(data,data_list[[i]] , by = "Country")
  print(length(data$Country))
  i = i+1
}

data = data %>%
  filter(Country %in% oecd)
rownames(data) = data$Country
data = data[,-1]
data=data[,c(4,1:3,5:15)]
data_info = data.frame(sapply(data, function(x) sum(is.na(x))))

data_mat = as.matrix(data)
gpairs(data_mat, lower.pars = list(scatter = "stats"))

##### Confounder loop
nm = seq(1:length(names(data)))
coeff = data.frame(matrix(0,nrow=15,ncol=15))
rownames(coeff) = c("(Intercept)",names(data)[c(2:15)])
for (names in nm) {
 formula = paste0(names(data)[c(1:names+1)],collapse = "+")
 formula = paste0("suicideRte ~", formula) # Your Y variable here
 model = lm(formula,data)
 
 coeff[,names] = data.frame(c(summary(model)$coefficients[,1],matrix(0,ncol=1,nrow=(14-names))))
 x = data.frame(rownames(data.frame(model$coefficients)))
 x$sig = summary(model)$coefficients[,4] < .1
 names(x) = c("var","sig")
 x = x$var[x$sig == TRUE]
 
 print(formula)
 print(paste0("Residuals: ",model$df.residual))
 print(paste0("Adj R: ",summary(model)$adj.r.squared))
 print(paste0("Sig Variables (.1): ",paste0(x, collapse = ", ")))
 print("- - - - - - - - - - - - - - - - -")
} # Full formula gives minimum residuals but still high
coeff

##### Modeling ####
model = lm(suicideRte ~., data=data)
summary(model)
step(model,direction = "backward")
modelback = lm(suicideRte ~ birthrte + unemployment_wb + marrRt + divRt + alcohol
, data=data)
summary(modelback)
