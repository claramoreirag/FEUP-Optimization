/*********************************************
 * OPL 22.1.0.0 Model
 * Author: clara
 * Creation Date: 17 May 2022 at 12:31:48
 *********************************************/
{string} Classes=...;
{string} MWFClasses=...;
{string} TuThClasses=...;
{string} Teachers=...;
{string} MWFtimes=...;
{string} TuThteachers=...;
{string} MWFteachers=...;
{string} TuThtimes=...;

string TeachersOfClasses[Classes]=...;

int MWFpreferences[Teachers][MWFtimes]=...;
int TuThpreferences[Teachers][TuThtimes]=...;

int Seniority[Teachers]=...;

dvar boolean MWF[MWFClasses][MWFtimes];
dvar boolean TuTh[TuThClasses][TuThtimes];

//aux dvars
dvar int TotalPreferences;
dvar int SChours;

//maximization function: maximize teacher preferences by seniority
maximize TotalPreferences - 10*SChours;

subject to{
	TotalPreferences== (sum (i in MWFClasses) 
							sum (j in MWFtimes) Seniority[TeachersOfClasses[i]]*MWF[i][j]*MWFpreferences[TeachersOfClasses[i]][j] ) 
	+ (sum (i in TuThClasses) sum (j in TuThtimes) Seniority[TeachersOfClasses[i]]*TuTh[i][j]*TuThpreferences[TeachersOfClasses[i]][j] );

	//implicit constraints
	//only one slot per class
	forall (i in MWFClasses){
	  sum (j in MWFtimes) MWF[i][j]==1;
	}
 
  	forall (i in TuThClasses){
	  sum (j in TuThtimes) TuTh[i][j]==1;
  	}
  	
  	//same teacher can not be allocated to more than one class in the same slot
 forall(i in MWFtimes){
        MWF["CS012"][i]+MWF["CS033"][i]+MWF["CS034"][i]<=1;
        MWF["CS041"][i]+MWF["CS061"][i]<=1;
        MWF["CS023"][i]+MWF["CS025"][i]+MWF["CS026"][i]<=1;
        MWF["CS021"][i]+MWF["CS022"][i]+MWF["CS024"][i]<=1;  
  }
  
  forall(i in TuThtimes){
        TuTh["CS011"][i]+TuTh["CS031"][i]+TuTh["CS032"][i]<=1;
        TuTh["CS065"][i]+TuTh["CS066"][i]+TuTh["CS071"][i]<=1;
        TuTh["CS062"][i]+TuTh["CS063"][i]+TuTh["CS064"][i]<=1;
  }
  	
  	//explicit constraints
  	//only 3 classes per slot
  	forall (j in TuThtimes){
	  sum (i in TuThClasses) TuTh[i][j]<=3;
  	}
  	forall (j in MWFtimes){
	  sum (i in MWFClasses) MWF[i][j]<=3;
  	}
  	
  	//soft constraint starting before 9am or ending after 4pm
  	SChours== sum(i in MWFClasses)( MWF[i]["3:50"]+ MWF[i]["5:25"]) + 
  	sum(i in TuThClasses) (TuTh[i]["8:15"]+ TuTh[i]["4:10"] + TuTh[i]["6:00"]); 
  	
}
