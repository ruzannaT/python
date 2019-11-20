DELIMITER $$

DROP PROCEDURE IF EXISTS sp_nav_viventor $$
CREATE PROCEDURE sp_nav_viventor (IN toDate DATE)
BEGIN

-- using a temporary table to improve performance
CREATE TEMPORARY TABLE IF NOT EXISTS navPreprocessing (retrievalDate Date, platform varchar(255), loanId varchar(255), myInvestments decimal(11,6), outstandingPrincipal decimal(11,6), paymentStatus varchar(255), delayOfPayment int, delayHack int); 
DELETE FROM navPreprocessing;

INSERT INTO navPreprocessing
SELECT sub.retrievalDate, 'Viventor' AS platform, sub.loanId, sub.myInvestments, sub.outstandingPrincipal, sub.paymentStatus, sub.delayOfPayment, sub.delayHack
FROM (
	SELECT hist.retrievalDate, hist.loanId, inv.myInvestments, hist.outstandingPrincipal, hist.paymentStatus, hist.delayOfPayment,
		CASE
		WHEN (hist.delayOfPayment IS NULL AND hist.paymentStatus ='Current') THEN 0
		WHEN (hist.delayOfPayment IS NULL AND hist.paymentStatus like '%1-30 days late%') THEN 16   /*data preprocessing for calculation with narrower range*/
		WHEN (hist.delayOfPayment IS NULL AND hist.paymentStatus like '%31-60 days late%') THEN 45
		WHEN (hist.delayOfPayment IS NULL AND hist.paymentStatus like '%Non-performing%') THEN 61
		WHEN hist.delayOfPayment IS NOT NULL THEN hist.delayOfPayment
		ELSE NULL
		END AS delayHack
	FROM ViventorInvestmentHistory hist LEFT JOIN ViventorInvestment inv ON inv.loanId=hist.loanId
	WHERE hist.outstandingPrincipal IS NOT NULL AND hist.retrievalDate = toDate) sub
ORDER BY retrievalDate;

SELECT platform, loanId, NULL AS investmentId, myInvestments, outstandingPrincipal, delayOfPayment,
	CASE
	WHEN delayHack = 0 THEN outstandingPrincipal
	WHEN (delayHack > 0 AND delayHack <= 7) THEN outstandingPrincipal * 0.95
	WHEN (delayHack > 7 AND delayHack <= 15) THEN outstandingPrincipal * 0.85
	WHEN (delayHack > 15 AND delayHack <= 30) THEN outstandingPrincipal * 0.7
	WHEN (delayHack > 30 AND delayHack <= 60) THEN outstandingPrincipal * 0.45
	WHEN delayHack > 60 THEN outstandingPrincipal * 0.3
	/* when delayHack = 'Grace Period' then outstandingPrincipal * 0.95 */
	ELSE 'N/A'
	END AS loanNAV,
	paymentStatus, delayHack, retrievalDate	
FROM navPreprocessing;

DROP TABLE navPreprocessing;

END $$
DELIMITER ;

-- CALL sp_nav_viventor('2019-10-29');
