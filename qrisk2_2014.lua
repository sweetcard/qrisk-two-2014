local qrisk = {}

function qrisk.calc_cvd_risk_male(age,b_AF,b_ra,b_renal,b_treatedhyp,b_type1,b_type2,bmi,ethrisk,fh_cvd,rati,sbp,smoke_cat,surv,town)
	survivor = {
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.977699398994446,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0
	};

	-- The conditional arrays 

	Iethrisk = {
	0.0,
	0.0,
	0.3567133647493443400000000,
	0.5369559608176189800000000,
	0.5190878419529624300000000,
	0.2182992106490147000000000,
	-0.3474174705898491800000000,
	-0.3674730037922803700000000,
	-0.3749664891426142700000000,
	-0.1926947742531604500000000
	};

	Ismoke = {
	0,
	0.2784649664157046200000000,
	0.6067834395168959500000000,
	0.7103835060989258700000000,
	0.8626172339181202900000000
	};

	--Applying the fractional polynomial transforms */
	--(which includes scaling)                      */

	dage = age * 1.0;
	dage=dage/10;
	age_1 = math.pow(dage,-1);
	age_2 = math.pow(dage,2);
	dbmi = bmi * 1.0;
	dbmi=dbmi/10;
	bmi_1 = math.pow(dbmi,-2);
	bmi_2 = math.pow(dbmi,-2)*math.log(dbmi);

	--/* Centring the continuous variables */

	age_1 = age_1 - 0.232008963823318;
	age_2 = age_2 - 18.577636718750000;
	bmi_1 = bmi_1 - 0.146408438682556;
	bmi_2 = bmi_2 - 0.140651300549507;
	rati = rati - 4.377167701721191;
	sbp = sbp - 131.038314819335940;
	town = town - 0.151332527399063;

	--/* Start of Sum */
	a=0.0;

	--/* The conditional sums */

	a = a + Iethrisk[ethrisk + 1];
	a = a + Ismoke[smoke_cat + 1];

	--/* Sum from continuous values */

	a = a + age_1 * -17.6225543381945610000000000;
	a = a + age_2 * 0.0241873189298273640000000;
	a = a + bmi_1 * 1.7320282704272665000000000;
	a = a + bmi_2 * -7.2311754066699754000000000;
	a = a + rati * 0.1751387974012235100000000;
	a = a + sbp * 0.0101676305179196900000000;
	a = a + town * 0.0298177271496720960000000;

	--/* Sum from boolean values */

	a = a + b_AF * 0.9890997526189402300000000;
	a = a + b_ra * 0.2541886209118611200000000;
	a = a + b_renal * 0.7949789230438320000000000;
	a = a + b_treatedhyp * 0.6229359479868044100000000;
	a = a + b_type1 * 1.3330353321463930000000000;
	a = a + b_type2 * 0.9372956828151940400000000;
	a = a + fh_cvd * 0.5923353736582422900000000;

	--/* Sum from interaction terms */
		  
	if smoke_cat==1 then
		a = a + (age_1 * 0.9243747443632776000000000);
	elseif smoke_cat==2 then
		a = a + (age_1 * 1.9597527500081284000000000);
	elseif smoke_cat==3 then
		a = a + (age_1 * 2.9993544847631153000000000);
	elseif smoke_cat==4 then
		a = a + (age_1 * 5.0370735254768100000000000);
	end

	a = a + age_1 * b_AF * 8.2354205455482727000000000;
	a = a + age_1 * b_renal * -3.9747389951976779000000000;
	a = a + age_1 * b_treatedhyp * 7.8737743159167728000000000;
	a = a + age_1 * b_type1 * 5.4238504414460937000000000;
	a = a + age_1 * b_type2 * 5.0624161806530141000000000;
	a = a + age_1 * bmi_1 * 33.5437525167394240000000000;
	a = a + age_1 * bmi_2 * -129.9766738257203800000000000;
	a = a + age_1 * fh_cvd * 1.9279963874659789000000000;
	a = a + age_1 * sbp * 0.0523440892175620200000000;
	a = a + age_1 * town * -0.1730588074963540200000000;
	  
	if smoke_cat==1 then
		a = a + (age_2 * -0.0034466074038854394000000);
	elseif smoke_cat==2 then
		a = a + (age_2 * -0.0050703431499952954000000);
	elseif smoke_cat==3 then
		a = a + (age_2 * 0.0003216059799916440800000);
	elseif smoke_cat==4 then
		a = a + (age_2 * 0.0031312537144240087000000);
	end

	a = a + age_2 * b_AF * 0.0073291937255039966000000;
	a = a + age_2 * b_renal * -0.0261557073286531780000000;
	a = a + age_2 * b_treatedhyp * 0.0085556382622618121000000;
	a = a + age_2 * b_type1 * 0.0020586479482670723000000;
	a = a + age_2 * b_type2 * -0.0002328590770854172900000;
	a = a + age_2 * bmi_1 * 0.0811847212080794990000000;
	a = a + age_2 * bmi_2 * -0.2558919068850948300000000;
	a = a + age_2 * fh_cvd * -0.0056729073729663406000000;
	a = a + age_2 * sbp * -0.0000536584257307299330000;
	a = a + age_2 * town * -0.0010763305052605857000000;

	--/* Calculate the score itself */

	score = 100.0 * (1.0 - math.pow(survivor[surv + 1], math.exp(a)) );

	return score;

end

--[[
function qrisk.calc_cvd_risk_female(age,b_AF,b_ra,b_renal,b_treatedhyp,b_type1,b_type2,bmi,ethrisk,fh_cvd,rati,sbp,smoke_cat,surv,town)
	survivor = {
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0,
	0.988948762416840,
	0.0,
	0.0,
	0.0,
	0.0,
	0.0
	};

	-- The conditional arrays 

	Iethrisk = {
	0,
	0,
	0.2671958047902151500000000,
	0.7147534261793343500000000,
	0.3702894474455115700000000,
	0.2073797362620235500000000,
	-0.1744149722741736900000000,
	-0.3271878654368842200000000,
	-0.2200617876129250500000000,
	-0.2090388032466696800000000
	};

	Ismoke = {
	0,
	0.1947480856528854800000000,
	0.6229400520450627500000000,
	0.7405819891143352600000000,
	0.9134392684576959600000000
	};

	--Applying the fractional polynomial transforms */
	--(which includes scaling)                      */

	dage = age * 1.0;
	dage=dage/10;
	age_1 = math.pow(dage,0.5)
	age_2 = dage
	dbmi = bmi * 1.0;
	dbmi=dbmi/10;
	bmi_1 = math.pow(dbmi,-2);
	bmi_2 = math.pow(dbmi,-2)*math.log(dbmi);

	--/* Centring the continuous variables */

	age_1 = age_1 - 2.099778413772583;
	age_2 = age_2 - 4.409069538116455;
	bmi_1 = bmi_1 - 0.154046609997749;
	bmi_2 = bmi_2 - 0.144072100520134;
	rati = rati - 3.554229259490967;
	sbp = sbp - 125.773628234863280;
	town = town - 0.032508373260498;

	--/* Start of Sum */
	a=0.0;

	--/* The conditional sums */

	a = a + Iethrisk[ethrisk + 1];
	a = a + Ismoke[smoke_cat + 1];

	--/* Sum from continuous values */

	a = a + age_1 * 3.8734583855051343000000000;
	a = a + age_2 * 0.1346634304478384600000000;
	a = a + bmi_1 * -0.1557872403333062600000000;
	a = a + bmi_2 * -3.7727795566691125000000000;
	a = a + rati * 0.1525695208919679600000000;
	a = a + sbp * 0.0132165300119653560000000;
	a = a + town * 0.0643647529864017080000000;

	--/* Sum from boolean values */

	a = a + b_AF * 1.4235421148946676000000000;
	a = a + b_ra * 0.3021462511553648100000000;
	a = a + b_renal * 0.8614743039721416400000000;
	a = a + b_treatedhyp * 0.5889355458733703800000000;
	a = a + b_type1 * 1.6684783657502795000000000;
	a = a + b_type2 * 1.1350165062510138000000000;
	a = a + fh_cvd * 0.5133972775738673300000000;

	--/* Sum from interaction terms */
  
	if smoke_cat==1 then
		a = a + (age_1 * 0.6891139747579299000000000);
	elseif smoke_cat==2 then
		a = a + (age_1 * 0.6942632802121626600000000);
	elseif smoke_cat==3 then
		a = a + (age_1 * -1.6952388644218186000000000);
	elseif smoke_cat==4 then
		a = a + (age_1 * -1.2150150940219255000000000);
	end
  
	a = a + age_1 * b_AF * -3.5855215448190969000000000;
	a = a + age_1 * b_renal * -3.0766647922469192000000000;
	a = a + age_1 * b_treatedhyp * -4.0295302811880314000000000;
	a = a + age_1 * b_type1 * -0.3344110567405778600000000;
	a = a + age_1 * b_type2 * -3.3144806806620530000000000;
	a = a + age_1 * bmi_1 * -5.5933905797230006000000000;
	a = a + age_1 * bmi_2 * 64.3635572837688980000000000;
	a = a + age_1 * fh_cvd * 0.8605433761217157200000000;
	a = a + age_1 * sbp * -0.0509321154551188590000000;
	a = a + age_1 * town * 0.1518664540724453700000000;


	if smoke_cat==1 then
		a = a + (age_2 * -0.1765395485882681500000000);
	elseif smoke_cat==2 then
		a = a + (age_2 * -0.2323836483278573000000000);
	elseif smoke_cat==3 then
		a = a + (age_2 * 0.2734395770551826300000000);
	elseif smoke_cat==4 then
		a = a + (age_2 * 0.1432552287454152700000000);
	end

	a = a + age_2 * b_AF * 0.4986871390807032200000000;
	a = a + age_2 * b_renal * 0.4393033615664938600000000;
	a = a + age_2 * b_treatedhyp * 0.6904385790303250200000000;
	a = a + age_2 * b_type1 * -0.1734316566060327700000000;
	a = a + age_2 * b_type2 * 0.4864930655867949500000000;
	a = a + age_2 * bmi_1 * 1.5223341309207974000000000;
	a = a + age_2 * bmi_2 * -12.7413436207964070000000000;
	a = a + age_2 * fh_cvd * -0.2756708481415109900000000;
	a = a + age_2 * sbp * 0.0073790750039744186000000;
	a = a + age_2 * town * -0.0487465462679640900000000;

	--/* Calculate the score itself */

	score = 100.0 * (1.0 - math.pow(survivor[surv + 1], math.exp(a)) );
	return score;
end

local function qrisk2.validate_params()
	-- validate the arguments here
	-- unsure whether the type should be coerced
end

local function qrisk.calc_cvd_risk(age,b_AF,b_ra,b_renal,b_treatedhyp,b_type1,b_type2,bmi,ethrisk,fh_cvd,rati,sbp,smoke_cat,surv,town,sex)
	if sex == '0' then
		qrisk2.calc_cvd_risk_female(age,b_AF,b_ra,b_renal,b_treatedhyp,b_type1,b_type2,bmi,ethrisk,fh_cvd,rati,sbp,smoke_cat,surv,town);
	elseif sex == '1' then
		qrisk2.calc_cvd_risk_male(age,b_AF,b_ra,b_renal,b_treatedhyp,b_type1,b_type2,bmi,ethrisk,fh_cvd,rati,sbp,smoke_cat,surv,town);
	end
end		
--]]

return qrisk;

--main(arg)
