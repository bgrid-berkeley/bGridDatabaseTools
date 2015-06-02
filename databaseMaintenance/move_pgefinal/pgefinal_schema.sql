-- MySQL dump 10.13  Distrib 5.5.40, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: pgefinal
-- ------------------------------------------------------
-- Server version	5.5.40-0ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,POSTGRESQL' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table "01customer"
--

DROP TABLE IF EXISTS "01customer";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "01customer" (
  "START" date DEFAULT NULL,
  "END" date DEFAULT NULL,
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "PER_ID" int(11) DEFAULT NULL,
  "SERVICE_AGREEMENT_ID" int(11) DEFAULT NULL,
  "SP_ID" bigint(20) DEFAULT NULL,
  "PREMISE_ID" int(11) DEFAULT NULL,
  "SVC_TYPE_CD" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY "ndx_01_sa_unique" ("SERVICE_AGREEMENT_ID"),
  KEY "ndx_01_acct" ("ACCOUNT_ID"),
  KEY "ndx_01_perid" ("PER_ID"),
  KEY "ndx_01_sp" ("SP_ID"),
  KEY "ndx_01_prem" ("PREMISE_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "02premise"
--

DROP TABLE IF EXISTS "02premise";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "02premise" (
  "PREMISE_ID" int(11) DEFAULT NULL,
  "FUEL" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "POSTAL_CODE" char(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  "CITY" varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  "COUNTY" varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  "DIVISION_CODE" char(3) COLLATE utf8_unicode_ci DEFAULT NULL,
  "CLIMATE_BAND" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  "AREA" char(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  "GEOGRAPHY" varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  "E_SM_BILLED_READ_DATE" date DEFAULT NULL,
  "E_SM_INSTALL_DATE" date DEFAULT NULL,
  "E_SM_INSTALL_DATE_ACCURACY" tinyint(1) DEFAULT NULL,
  "G_SM_BILLED_READ_DATE" date DEFAULT NULL,
  "G_SM_INSTALL_DATE" date DEFAULT NULL,
  "G_SM_INSTALL_DATE_ACCURACY" tinyint(1) DEFAULT NULL,
  "INTERCONNECTION_DT" date DEFAULT NULL,
  "INVERTER_NAMEPLATE_KW2" int(11) DEFAULT NULL,
  "NEM_FLAG" tinyint(1) DEFAULT NULL,
  UNIQUE KEY "ndx_02_prem_unique" ("PREMISE_ID"),
  CONSTRAINT "02premise_ibfk_1" FOREIGN KEY ("PREMISE_ID") REFERENCES "01customer" ("PREMISE_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "02premiseMT"
--

DROP TABLE IF EXISTS "02premiseMT";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "02premiseMT" (
  "PREMISE_ID" int(11) DEFAULT NULL,
  "FUEL" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "basicOrFullElec" varchar(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  "CLIMATE_BAND" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  KEY "fuel" ("basicOrFullElec")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "03accountMT"
--

DROP TABLE IF EXISTS "03accountMT";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "03accountMT" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "indvOrMaster" varchar(1) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  KEY "master" ("indvOrMaster")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "03accounts"
--

DROP TABLE IF EXISTS "03accounts";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "03accounts" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "PREMISE_ID" int(11) DEFAULT NULL,
  "GEOGRAPHY" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "CLIMATE_BAND" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "ELECTRIC_RATE" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "GAS_RATE" varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  "TOU_RATE" tinyint(1) DEFAULT NULL,
  "ENVIRONMENT_OR_WILDLIFE" tinyint(1) DEFAULT NULL,
  "ENVIRONMENTAL_ISSUES" tinyint(1) DEFAULT NULL,
  "GREEN_LIVING" tinyint(1) DEFAULT NULL,
  "HIGH_TECH_LIVING" tinyint(1) DEFAULT NULL,
  "EDUCATION" varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  "Cluster" varchar(35) COLLATE utf8_unicode_ci DEFAULT NULL,
  UNIQUE KEY "ndx_03_acct_unique" ("ACCOUNT_ID"),
  UNIQUE KEY "ndx_03_prem_unique" ("PREMISE_ID"),
  CONSTRAINT "03accounts_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID"),
  CONSTRAINT "03accounts_ibfk_2" FOREIGN KEY ("PREMISE_ID") REFERENCES "01customer" ("PREMISE_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "04billing"
--

DROP TABLE IF EXISTS "04billing";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "04billing" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "PREMISE_ID" int(11) DEFAULT NULL,
  "BILL_DATE" date DEFAULT NULL,
  "Therms" int(11) DEFAULT NULL,
  "Gas_Bill" decimal(10,2) DEFAULT NULL,
  "kWh" int(11) DEFAULT NULL,
  "Electric_Bill" decimal(10,2) DEFAULT NULL,
  KEY "ndx_04a_acct" ("ACCOUNT_ID"),
  KEY "ndx_04a_prem" ("PREMISE_ID"),
  KEY "ndx_04a_date" ("BILL_DATE"),
  CONSTRAINT "04billing_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID"),
  CONSTRAINT "04billing_ibfk_2" FOREIGN KEY ("PREMISE_ID") REFERENCES "01customer" ("PREMISE_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "04payments"
--

DROP TABLE IF EXISTS "04payments";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "04payments" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "PREMISE_ID" int(11) DEFAULT NULL,
  "PAYMENT_DATE" date DEFAULT NULL,
  "Gas_Payment" decimal(10,2) DEFAULT NULL,
  "Electric_Payment" decimal(10,2) DEFAULT NULL,
  "Payment_Method" varchar(35) DEFAULT NULL,
  KEY "ndx_04b_acct" ("ACCOUNT_ID"),
  KEY "ndx_04b_prem" ("PREMISE_ID"),
  KEY "ndx_04b_date" ("PAYMENT_DATE"),
  CONSTRAINT "04payments_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID"),
  CONSTRAINT "04payments_ibfk_2" FOREIGN KEY ("PREMISE_ID") REFERENCES "01customer" ("PREMISE_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "05programs"
--

DROP TABLE IF EXISTS "05programs";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "05programs" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "TIMESENROLLED" int(11) DEFAULT NULL,
  "BPP_start" date DEFAULT NULL,
  "BPP_end" date DEFAULT NULL,
  "CARE_start" date DEFAULT NULL,
  "CARE_end" date DEFAULT NULL,
  "ClimateSmart_start" date DEFAULT NULL,
  "ClimateSmart_end" date DEFAULT NULL,
  "DirAccess_start" date DEFAULT NULL,
  "DirAccess_end" date DEFAULT NULL,
  "SmartAC_start" date DEFAULT NULL,
  "SmartAC_end" date DEFAULT NULL,
  "SmartRate_start" date DEFAULT NULL,
  "SmartRate_end" date DEFAULT NULL,
  "MyEnergy_LastLogin" date DEFAULT NULL,
  KEY "ndx_05_acct" ("ACCOUNT_ID"),
  CONSTRAINT "05programs_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "06rebates"
--

DROP TABLE IF EXISTS "06rebates";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "06rebates" (
  "SERVICE_AGREEMENT_ID" int(11) DEFAULT NULL,
  "rebate_type" varchar(25) DEFAULT NULL,
  "application_recvd" date DEFAULT NULL,
  "accept_date" date DEFAULT NULL,
  "check_issue_date" date DEFAULT NULL,
  KEY "ndx_06_sa" ("SERVICE_AGREEMENT_ID"),
  CONSTRAINT "06rebates_ibfk_1" FOREIGN KEY ("SERVICE_AGREEMENT_ID") REFERENCES "01customer" ("SERVICE_AGREEMENT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "07tickets"
--

DROP TABLE IF EXISTS "07tickets";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "07tickets" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "CASE_TYPE" varchar(100) DEFAULT NULL,
  "CREATE_TIME" datetime DEFAULT NULL,
  "CREATE_DATE" date DEFAULT NULL,
  KEY "ndx_07_acct" ("ACCOUNT_ID"),
  CONSTRAINT "07tickets_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "08call"
--

DROP TABLE IF EXISTS "08call";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "08call" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "REASON" varchar(35) DEFAULT NULL,
  "TIME" datetime DEFAULT NULL,
  "DATE" date DEFAULT NULL,
  KEY "ndx_08_acct" ("ACCOUNT_ID"),
  CONSTRAINT "08call_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "09comm"
--

DROP TABLE IF EXISTS "09comm";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "09comm" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "REFERENCE_NUM" varchar(12) DEFAULT NULL,
  "program_name" varchar(25) DEFAULT NULL,
  "channel" varchar(10) DEFAULT NULL,
  "DATE" date DEFAULT NULL,
  KEY "ndx_09_acct" ("ACCOUNT_ID"),
  KEY "ndx_09_ref" ("REFERENCE_NUM"),
  CONSTRAINT "09comm_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "10emails"
--

DROP TABLE IF EXISTS "10emails";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "10emails" (
  "ACCOUNT_ID" int(11) DEFAULT NULL,
  "REFERENCE_NUM" varchar(12) DEFAULT NULL,
  "RESPONSE_TYPE" char(3) DEFAULT NULL,
  "CAMPAIGN_ID" char(3) DEFAULT NULL,
  "response_date" date DEFAULT NULL,
  KEY "ndx_10_acct" ("ACCOUNT_ID"),
  KEY "ndx_10_ref" ("REFERENCE_NUM"),
  CONSTRAINT "10emails_ibfk_1" FOREIGN KEY ("ACCOUNT_ID") REFERENCES "01customer" ("ACCOUNT_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "11census"
--

DROP TABLE IF EXISTS "11census";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "11census" (
  "SP_ID" bigint(20) DEFAULT NULL,
  "CENSUS_BLOCKGROUP" varchar(15) DEFAULT NULL,
  "CBG_LATITUDE" decimal(15,10) DEFAULT NULL,
  "CBG_LONGITUDE" decimal(15,10) DEFAULT NULL,
  "GHCN_WBAN" varchar(11) DEFAULT NULL,
  "GHCN_LATITUDE" decimal(15,10) DEFAULT NULL,
  "GHCN_LONGITUDE" decimal(15,10) DEFAULT NULL,
  KEY "ndx_11_sp" ("SP_ID"),
  KEY "ndx_01_WBAN" ("GHCN_WBAN"),
  CONSTRAINT "11census_ibfk_1" FOREIGN KEY ("SP_ID") REFERENCES "01customer" ("SP_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "12weather"
--

DROP TABLE IF EXISTS "12weather";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "12weather" (
  "WBAN" varchar(11) DEFAULT NULL,
  "DATE" date DEFAULT NULL,
  "ELEMENT" varchar(4) DEFAULT NULL,
  "VALUE" int(11) DEFAULT NULL,
  "MFLAG" varchar(1) DEFAULT NULL,
  "QFLAG" varchar(1) DEFAULT NULL,
  "SFLAG" varchar(1) DEFAULT NULL,
  "TIME" time DEFAULT NULL,
  KEY "ndx_02_WBAN" ("WBAN"),
  CONSTRAINT "12weather_ibfk_1" FOREIGN KEY ("WBAN") REFERENCES "11census" ("GHCN_WBAN")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "baselines"
--

DROP TABLE IF EXISTS "baselines";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "baselines" (
  "dateEffective" date DEFAULT NULL,
  "climateZone" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  "indvOrMaster" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  "basicOrFullElec" char(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  "summerOrWinter" char(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  "baselineElec" float(5,2) DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "electric_daily"
--

DROP TABLE IF EXISTS "electric_daily";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "electric_daily" (
  "sp_id" bigint(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "kwh" decimal(8,4) DEFAULT NULL,
  "n_estimated" int(11) DEFAULT NULL,
  "n_blanks" int(11) DEFAULT NULL,
  UNIQUE KEY "ndx_eday_spid_date" ("sp_id","date"),
  KEY "ndx_12_sp" ("sp_id"),
  KEY "ndx_12_date" ("date"),
  CONSTRAINT "electric_daily_ibfk_1" FOREIGN KEY ("sp_id") REFERENCES "01customer" ("SP_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "electric_daily_mt"
--

DROP TABLE IF EXISTS "electric_daily_mt";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "electric_daily_mt" (
  "sp_id" bigint(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "kwh" decimal(8,4) DEFAULT NULL,
  "n_estimated" int(11) DEFAULT NULL,
  "n_blanks" int(11) DEFAULT NULL,
  "bl_effectiveDate" varchar(10) CHARACTER SET utf8 DEFAULT NULL,
  "summerOrWinter" varchar(6) CHARACTER SET utf8 NOT NULL DEFAULT ''
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "electric_daily_temp"
--

DROP TABLE IF EXISTS "electric_daily_temp";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "electric_daily_temp" (
  "sp_id" bigint(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "kwh" decimal(8,4) DEFAULT NULL,
  "n_estimated" int(11) DEFAULT NULL,
  "n_blanks" int(11) DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "electric_interval_96"
--

DROP TABLE IF EXISTS "electric_interval_96";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "electric_interval_96" (
  "sp_id" bigint(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "w01" int(6) DEFAULT NULL,
  "w02" int(6) DEFAULT NULL,
  "w03" int(6) DEFAULT NULL,
  "w04" int(6) DEFAULT NULL,
  "w05" int(6) DEFAULT NULL,
  "w06" int(6) DEFAULT NULL,
  "w07" int(6) DEFAULT NULL,
  "w08" int(6) DEFAULT NULL,
  "w09" int(6) DEFAULT NULL,
  "w10" int(6) DEFAULT NULL,
  "w11" int(6) DEFAULT NULL,
  "w12" int(6) DEFAULT NULL,
  "w13" int(6) DEFAULT NULL,
  "w14" int(6) DEFAULT NULL,
  "w15" int(6) DEFAULT NULL,
  "w16" int(6) DEFAULT NULL,
  "w17" int(6) DEFAULT NULL,
  "w18" int(6) DEFAULT NULL,
  "w19" int(6) DEFAULT NULL,
  "w20" int(6) DEFAULT NULL,
  "w21" int(6) DEFAULT NULL,
  "w22" int(6) DEFAULT NULL,
  "w23" int(6) DEFAULT NULL,
  "w24" int(6) DEFAULT NULL,
  "w25" int(6) DEFAULT NULL,
  "w26" int(6) DEFAULT NULL,
  "w27" int(6) DEFAULT NULL,
  "w28" int(6) DEFAULT NULL,
  "w29" int(6) DEFAULT NULL,
  "w30" int(6) DEFAULT NULL,
  "w31" int(6) DEFAULT NULL,
  "w32" int(6) DEFAULT NULL,
  "w33" int(6) DEFAULT NULL,
  "w34" int(6) DEFAULT NULL,
  "w35" int(6) DEFAULT NULL,
  "w36" int(6) DEFAULT NULL,
  "w37" int(6) DEFAULT NULL,
  "w38" int(6) DEFAULT NULL,
  "w39" int(6) DEFAULT NULL,
  "w40" int(6) DEFAULT NULL,
  "w41" int(6) DEFAULT NULL,
  "w42" int(6) DEFAULT NULL,
  "w43" int(6) DEFAULT NULL,
  "w44" int(6) DEFAULT NULL,
  "w45" int(6) DEFAULT NULL,
  "w46" int(6) DEFAULT NULL,
  "w47" int(6) DEFAULT NULL,
  "w48" int(6) DEFAULT NULL,
  "w49" int(6) DEFAULT NULL,
  "w50" int(6) DEFAULT NULL,
  "w51" int(6) DEFAULT NULL,
  "w52" int(6) DEFAULT NULL,
  "w53" int(6) DEFAULT NULL,
  "w54" int(6) DEFAULT NULL,
  "w55" int(6) DEFAULT NULL,
  "w56" int(6) DEFAULT NULL,
  "w57" int(6) DEFAULT NULL,
  "w58" int(6) DEFAULT NULL,
  "w59" int(6) DEFAULT NULL,
  "w60" int(6) DEFAULT NULL,
  "w61" int(6) DEFAULT NULL,
  "w62" int(6) DEFAULT NULL,
  "w63" int(6) DEFAULT NULL,
  "w64" int(6) DEFAULT NULL,
  "w65" int(6) DEFAULT NULL,
  "w66" int(6) DEFAULT NULL,
  "w67" int(6) DEFAULT NULL,
  "w68" int(6) DEFAULT NULL,
  "w69" int(6) DEFAULT NULL,
  "w70" int(6) DEFAULT NULL,
  "w71" int(6) DEFAULT NULL,
  "w72" int(6) DEFAULT NULL,
  "w73" int(6) DEFAULT NULL,
  "w74" int(6) DEFAULT NULL,
  "w75" int(6) DEFAULT NULL,
  "w76" int(6) DEFAULT NULL,
  "w77" int(6) DEFAULT NULL,
  "w78" int(6) DEFAULT NULL,
  "w79" int(6) DEFAULT NULL,
  "w80" int(6) DEFAULT NULL,
  "w81" int(6) DEFAULT NULL,
  "w82" int(6) DEFAULT NULL,
  "w83" int(6) DEFAULT NULL,
  "w84" int(6) DEFAULT NULL,
  "w85" int(6) DEFAULT NULL,
  "w86" int(6) DEFAULT NULL,
  "w87" int(6) DEFAULT NULL,
  "w88" int(6) DEFAULT NULL,
  "w89" int(6) DEFAULT NULL,
  "w90" int(6) DEFAULT NULL,
  "w91" int(6) DEFAULT NULL,
  "w92" int(6) DEFAULT NULL,
  "w93" int(6) DEFAULT NULL,
  "w94" int(6) DEFAULT NULL,
  "w95" int(6) DEFAULT NULL,
  "w96" int(6) DEFAULT NULL,
  "q01" tinyint(1) DEFAULT NULL,
  "q02" tinyint(1) DEFAULT NULL,
  "q03" tinyint(1) DEFAULT NULL,
  "q04" tinyint(1) DEFAULT NULL,
  "q05" tinyint(1) DEFAULT NULL,
  "q06" tinyint(1) DEFAULT NULL,
  "q07" tinyint(1) DEFAULT NULL,
  "q08" tinyint(1) DEFAULT NULL,
  "q09" tinyint(1) DEFAULT NULL,
  "q10" tinyint(1) DEFAULT NULL,
  "q11" tinyint(1) DEFAULT NULL,
  "q12" tinyint(1) DEFAULT NULL,
  "q13" tinyint(1) DEFAULT NULL,
  "q14" tinyint(1) DEFAULT NULL,
  "q15" tinyint(1) DEFAULT NULL,
  "q16" tinyint(1) DEFAULT NULL,
  "q17" tinyint(1) DEFAULT NULL,
  "q18" tinyint(1) DEFAULT NULL,
  "q19" tinyint(1) DEFAULT NULL,
  "q20" tinyint(1) DEFAULT NULL,
  "q21" tinyint(1) DEFAULT NULL,
  "q22" tinyint(1) DEFAULT NULL,
  "q23" tinyint(1) DEFAULT NULL,
  "q24" tinyint(1) DEFAULT NULL,
  "q25" tinyint(1) DEFAULT NULL,
  "q26" tinyint(1) DEFAULT NULL,
  "q27" tinyint(1) DEFAULT NULL,
  "q28" tinyint(1) DEFAULT NULL,
  "q29" tinyint(1) DEFAULT NULL,
  "q30" tinyint(1) DEFAULT NULL,
  "q31" tinyint(1) DEFAULT NULL,
  "q32" tinyint(1) DEFAULT NULL,
  "q33" tinyint(1) DEFAULT NULL,
  "q34" tinyint(1) DEFAULT NULL,
  "q35" tinyint(1) DEFAULT NULL,
  "q36" tinyint(1) DEFAULT NULL,
  "q37" tinyint(1) DEFAULT NULL,
  "q38" tinyint(1) DEFAULT NULL,
  "q39" tinyint(1) DEFAULT NULL,
  "q40" tinyint(1) DEFAULT NULL,
  "q41" tinyint(1) DEFAULT NULL,
  "q42" tinyint(1) DEFAULT NULL,
  "q43" tinyint(1) DEFAULT NULL,
  "q44" tinyint(1) DEFAULT NULL,
  "q45" tinyint(1) DEFAULT NULL,
  "q46" tinyint(1) DEFAULT NULL,
  "q47" tinyint(1) DEFAULT NULL,
  "q48" tinyint(1) DEFAULT NULL,
  "q49" tinyint(1) DEFAULT NULL,
  "q50" tinyint(1) DEFAULT NULL,
  "q51" tinyint(1) DEFAULT NULL,
  "q52" tinyint(1) DEFAULT NULL,
  "q53" tinyint(1) DEFAULT NULL,
  "q54" tinyint(1) DEFAULT NULL,
  "q55" tinyint(1) DEFAULT NULL,
  "q56" tinyint(1) DEFAULT NULL,
  "q57" tinyint(1) DEFAULT NULL,
  "q58" tinyint(1) DEFAULT NULL,
  "q59" tinyint(1) DEFAULT NULL,
  "q60" tinyint(1) DEFAULT NULL,
  "q61" tinyint(1) DEFAULT NULL,
  "q62" tinyint(1) DEFAULT NULL,
  "q63" tinyint(1) DEFAULT NULL,
  "q64" tinyint(1) DEFAULT NULL,
  "q65" tinyint(1) DEFAULT NULL,
  "q66" tinyint(1) DEFAULT NULL,
  "q67" tinyint(1) DEFAULT NULL,
  "q68" tinyint(1) DEFAULT NULL,
  "q69" tinyint(1) DEFAULT NULL,
  "q70" tinyint(1) DEFAULT NULL,
  "q71" tinyint(1) DEFAULT NULL,
  "q72" tinyint(1) DEFAULT NULL,
  "q73" tinyint(1) DEFAULT NULL,
  "q74" tinyint(1) DEFAULT NULL,
  "q75" tinyint(1) DEFAULT NULL,
  "q76" tinyint(1) DEFAULT NULL,
  "q77" tinyint(1) DEFAULT NULL,
  "q78" tinyint(1) DEFAULT NULL,
  "q79" tinyint(1) DEFAULT NULL,
  "q80" tinyint(1) DEFAULT NULL,
  "q81" tinyint(1) DEFAULT NULL,
  "q82" tinyint(1) DEFAULT NULL,
  "q83" tinyint(1) DEFAULT NULL,
  "q84" tinyint(1) DEFAULT NULL,
  "q85" tinyint(1) DEFAULT NULL,
  "q86" tinyint(1) DEFAULT NULL,
  "q87" tinyint(1) DEFAULT NULL,
  "q88" tinyint(1) DEFAULT NULL,
  "q89" tinyint(1) DEFAULT NULL,
  "q90" tinyint(1) DEFAULT NULL,
  "q91" tinyint(1) DEFAULT NULL,
  "q92" tinyint(1) DEFAULT NULL,
  "q93" tinyint(1) DEFAULT NULL,
  "q94" tinyint(1) DEFAULT NULL,
  "q95" tinyint(1) DEFAULT NULL,
  "q96" tinyint(1) DEFAULT NULL,
  UNIQUE KEY "ndx_96_spid_date" ("sp_id","date"),
  KEY "ndx_13_sp" ("sp_id"),
  KEY "ndx_13_date" ("date"),
  CONSTRAINT "electric_interval_96_ibfk_1" FOREIGN KEY ("sp_id") REFERENCES "01customer" ("SP_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "gas_daily"
--

DROP TABLE IF EXISTS "gas_daily";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "gas_daily" (
  "SP_ID" bigint(20) DEFAULT NULL,
  "date" date DEFAULT NULL,
  "customer_type" varchar(15) DEFAULT NULL,
  "therms" decimal(10,5) DEFAULT NULL,
  "q_read" varchar(1) DEFAULT NULL,
  "electric_SP_ID" bigint(20) DEFAULT NULL,
  KEY "SP_ID" ("SP_ID"),
  KEY "ndx_sp_id_date" ("SP_ID","date"),
  KEY "ndx_e_sp_id_date" ("SP_ID","electric_SP_ID"),
  KEY "ndx_e_sp_id" ("electric_SP_ID"),
  CONSTRAINT "gas_daily_ibfk_1" FOREIGN KEY ("SP_ID") REFERENCES "01customer" ("SP_ID")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "gas_electric_map"
--

DROP TABLE IF EXISTS "gas_electric_map";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "gas_electric_map" (
  "gas_sp_id" bigint(20) DEFAULT NULL,
  "electric_sp_id" bigint(20) DEFAULT NULL,
  "premise_id" int(11) DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "monthlySummaryMTfromR"
--

DROP TABLE IF EXISTS "monthlySummaryMTfromR";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "monthlySummaryMTfromR" (
  "row_names" text,
  "yearMonth" text,
  "SP_ID" double DEFAULT NULL,
  "countDailykW" bigint(20) DEFAULT NULL,
  "countSMBlanks" bigint(20) DEFAULT NULL,
  "countSMEstimates" bigint(20) DEFAULT NULL,
  "sumDailykWh" double DEFAULT NULL,
  "sumBaseline" double DEFAULT NULL
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "weather_60"
--

DROP TABLE IF EXISTS "weather_60";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "weather_60" (
  "zip5" varchar(5) NOT NULL,
  "TemperatureF" float(5,2) DEFAULT NULL,
  "DewpointF" float(5,2) DEFAULT NULL,
  "Pressure" float(5,2) DEFAULT NULL,
  "WindSpeed" float(5,2) DEFAULT NULL,
  "Humidity" float(5,2) DEFAULT NULL,
  "Clouds" varchar(10) DEFAULT NULL,
  "HourlyPrecip" float(5,2) DEFAULT NULL,
  "SolarRadiation" float(6,2) DEFAULT NULL,
  "date" datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY ("zip5","date"),
  KEY "weather_date" ("date")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "weather_60_merged"
--

DROP TABLE IF EXISTS "weather_60_merged";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "weather_60_merged" (
  "zip5" varchar(5) NOT NULL,
  "TemperatureF" float(5,2) DEFAULT NULL,
  "DewpointF" float(5,2) DEFAULT NULL,
  "Pressure" float(5,2) DEFAULT NULL,
  "WindSpeed" float(5,2) DEFAULT NULL,
  "Humidity" float(5,2) DEFAULT NULL,
  "Clouds" varchar(10) DEFAULT NULL,
  "HourlyPrecip" float(5,2) DEFAULT NULL,
  "SolarRadiation" float(6,2) DEFAULT NULL,
  "date" datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY ("zip5","date"),
  KEY "weather_date" ("date"),
  KEY "weather_zip" ("zip5")
);
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table "weather_60_new3"
--

DROP TABLE IF EXISTS "weather_60_new3";
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE "weather_60_new3" (
  "zip5" varchar(5) NOT NULL,
  "TemperatureF" float(5,2) DEFAULT NULL,
  "DewpointF" float(5,2) DEFAULT NULL,
  "Pressure" float(5,2) DEFAULT NULL,
  "WindSpeed" float(5,2) DEFAULT NULL,
  "Humidity" float(5,2) DEFAULT NULL,
  "Clouds" varchar(10) DEFAULT NULL,
  "HourlyPrecip" float(5,2) DEFAULT NULL,
  "SolarRadiation" float(6,2) DEFAULT NULL,
  "date" datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY ("zip5","date"),
  KEY "weather_date" ("date")
);
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-04-01 13:13:53
