DROP VIEW rass.heat_cool_backout;

CREATE VIEW rass.heat_cool_backout AS
SELECT  a.ident, a.avginc, a.czt24, a.cecfast, 
	a.sqft, a.sqft_a, a.homeage, a.remod, a.dwltype, a.stories,
	a.nr0_5, a.nr6_18, a.nr19_34, a.nr35_54, a.nr55_64, a.nr65_99,
	a.payheat, 
	a.paycool, a.phtngfwl as groom, a.phtelbsb, a.phtelwhp, a.phtelpor,
	(a.phtelbsb = 1 OR a.phtelwhp =1  OR a.phtelpor =1) as eroom, 
	a.windtype, a.noroomac, 
	b.hdd65 as hdd65, b.cdd65 as cdd65,
	a.new_cac_uec, a.new_eht_uec, a.new_auxht_uec, a.new_rac_uec, a.new_swp_uec,
        a.new_pmp_uec, a.new_ght_uec, a.new_gauxht_uec
FROM rass.survdata AS a, rass.dd65 as b

WHERE a.czt24 = b.t24cz;

SELECT * FROM rass.heat_cool_backout;