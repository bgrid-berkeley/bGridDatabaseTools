-- View: rass.dd65
-- DROP VIEW rass.dd65;

CREATE OR REPLACE VIEW rass.dd65 AS 
 SELECT hdd65.t24cz,
    cdd72.cddnorm + hdd72.hddnorm - hdd65.hddnorm AS cdd65,
    hdd65.hddnorm AS hdd65,
    hdd72.hddnorm AS hdd72,
    cdd72.cddnorm AS cdd72
   FROM ( SELECT ddn_electricbillingdatamodels.t24cz,
            avg(ddn_electricbillingdatamodels.hddnorm) AS hddnorm
           FROM rass.ddn_electricbillingdatamodels
          WHERE ddn_electricbillingdatamodels.heatref = 65 OR (ddn_electricbillingdatamodels.heatref >= 64 AND ddn_electricbillingdatamodels.heatref <= 66 AND ddn_electricbillingdatamodels.t24cz IN (1,5))
          GROUP BY ddn_electricbillingdatamodels.t24cz
          ORDER BY ddn_electricbillingdatamodels.t24cz) hdd65,
    ( SELECT ddn_electricbillingdatamodels.t24cz,
            avg(ddn_electricbillingdatamodels.hddnorm) AS hddnorm
           FROM rass.ddn_electricbillingdatamodels
          WHERE ddn_electricbillingdatamodels.heatref = 72 OR (ddn_electricbillingdatamodels.heatref = 71 AND ddn_electricbillingdatamodels.t24cz IN (1,3))
          GROUP BY ddn_electricbillingdatamodels.t24cz
          ORDER BY ddn_electricbillingdatamodels.t24cz) hdd72,
    ( SELECT ddn_electricbillingdatamodels.t24cz,
            avg(ddn_electricbillingdatamodels.cddnorm) AS cddnorm
           FROM rass.ddn_electricbillingdatamodels
          WHERE ddn_electricbillingdatamodels.coolref = 72
          GROUP BY ddn_electricbillingdatamodels.t24cz
          ORDER BY ddn_electricbillingdatamodels.t24cz) cdd72
  WHERE cdd72.t24cz = hdd72.t24cz AND cdd72.t24cz = hdd65.t24cz;

--ALTER TABLE rass.dd65
 -- OWNER TO bgrid;

SELECT * FROM rass.dd65;