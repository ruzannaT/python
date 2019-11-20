DELIMITER $$

DROP PROCEDURE IF EXISTS sp_nav_debitum $$
CREATE PROCEDURE sp_nav_debitum (IN toDate DATE)
BEGIN

SELECT 'Debitum' AS platform, hist.loanId, hist.investmentId, inv.myInvestments, hist.outstandingPrincipal, hist.paymentStatus, hist.delayOfPayment,
	CASE
	WHEN hist.delayOfPayment = 0 THEN hist.outstandingPrincipal
	WHEN (hist.delayOfPayment > 0 AND hist.delayOfPayment <= 7) THEN hist.outstandingPrincipal * 0.95
	WHEN (hist.delayOfPayment > 7 AND hist.delayOfPayment <= 15) THEN hist.outstandingPrincipal * 0.85
	WHEN (hist.delayOfPayment > 15 AND hist.delayOfPayment <= 30) THEN hist.outstandingPrincipal * 0.7
	WHEN (hist.delayOfPayment > 30 AND hist.delayOfPayment <= 60) THEN hist.outstandingPrincipal * 0.45
	WHEN hist.delayOfPayment > 60 THEN hist.outstandingPrincipal * 0.3
	/* when delayHack = 'Grace Period' then outstandingPrincipal * 0.95 */
	ELSE 'N/A'
	END AS loanNAV,
	hist.paymentStatus, NULL AS delayHack, hist.retrievalDate	
FROM DebitumInvestmentHistory hist LEFT JOIN DebitumInvestment inv ON inv.loanId=hist.loanId
WHERE (hist.retrievalDate = toDate and hist.outstandingPrincipal IS NOT NULL);

END $$
DELIMITER ;

-- CALL sp_nav_debitum('2019-10-29');
